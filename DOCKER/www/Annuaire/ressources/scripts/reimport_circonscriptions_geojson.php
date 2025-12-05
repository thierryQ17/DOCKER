<?php
/**
 * Script pour réimporter les GeoJSON des circonscriptions depuis OpenStreetMap
 * Utilise l'API Overpass pour récupérer les polygones propres
 *
 * Options:
 *   --force : Sauvegarde même si certaines circonscriptions ont échoué
 *   --retry=N : Nombre de tentatives par relation (défaut: 3)
 */

ini_set('memory_limit', '512M');
set_time_limit(0);

echo "=== Réimport des GeoJSON des circonscriptions ===\n\n";

// Parser les options
$forceMode = in_array('--force', $argv);
$retryCount = 3;
foreach ($argv as $arg) {
    if (preg_match('/^--retry=(\d+)$/', $arg, $m)) {
        $retryCount = (int)$m[1];
    }
}

// Filtrer les départements (exclure les options)
$filterDepts = array_filter(array_slice($argv, 1), function($arg) {
    return !str_starts_with($arg, '--');
});

try {
    $pdo = new PDO(
        'mysql:host=mysql_db;dbname=annuairesMairesDeFrance;charset=utf8mb4',
        'root',
        'root',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    die("Erreur connexion BDD: " . $e->getMessage() . "\n");
}

// Récupérer les départements avec leurs relation_osm
$stmt = $pdo->query("
    SELECT code_departement, nom_departement, relation_osm
    FROM t_circonscriptions
    WHERE relation_osm IS NOT NULL AND relation_osm != ''
    ORDER BY code_departement
");
$departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Départements à traiter: " . count($departements) . "\n";
echo "Mode: " . ($forceMode ? "FORCE (sauvegarde partielle)" : "STRICT (toutes les circos requises)") . "\n";
echo "Tentatives par relation: $retryCount\n\n";

if (!empty($filterDepts)) {
    echo "Filtrage sur les départements: " . implode(', ', $filterDepts) . "\n\n";
}

$updateStmt = $pdo->prepare("UPDATE t_circonscriptions SET geojson = :geojson WHERE code_departement = :dept");

$success = 0;
$partial = 0;
$errors = 0;

/**
 * Récupère une relation OSM avec retry et backoff
 */
function fetchRelationWithRetry($relationId, $maxRetries = 3) {
    $overpassUrl = "https://overpass-api.de/api/interpreter";
    $query = "[out:json][timeout:90];relation($relationId);out geom;";

    for ($attempt = 1; $attempt <= $maxRetries; $attempt++) {
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $overpassUrl,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => "data=" . urlencode($query),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 180,
            CURLOPT_USERAGENT => 'AnnuaireMaires/1.0 (reimport script)'
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode === 200 && $response) {
            $data = json_decode($response, true);
            if ($data && !empty($data['elements'])) {
                return ['success' => true, 'data' => $data];
            }
        }

        if ($attempt < $maxRetries) {
            $waitTime = pow(2, $attempt); // Backoff exponentiel: 2, 4, 8 secondes
            echo "(retry $attempt/$maxRetries dans {$waitTime}s)... ";
            sleep($waitTime);
        }
    }

    return ['success' => false, 'httpCode' => $httpCode ?? 0];
}

foreach ($departements as $dept) {
    $codeDept = $dept['code_departement'];

    // Filtrer si arguments fournis
    if (!empty($filterDepts) && !in_array($codeDept, $filterDepts)) {
        continue;
    }

    $nomDept = $dept['nom_departement'];
    $relationIds = explode(',', $dept['relation_osm']);
    $totalCircos = count(array_filter(array_map('trim', $relationIds)));

    echo "[$codeDept] $nomDept - $totalCircos circonscriptions\n";

    $features = [];
    $failedRelations = [];

    foreach ($relationIds as $index => $relationId) {
        $relationId = trim($relationId);
        if (empty($relationId)) continue;

        echo "  - Relation $relationId... ";

        $result = fetchRelationWithRetry($relationId, $retryCount);

        if (!$result['success']) {
            echo "ERREUR HTTP " . ($result['httpCode'] ?? 'timeout') . "\n";
            $failedRelations[] = $relationId;
            continue;
        }

        $element = $result['data']['elements'][0];
        $name = $element['tags']['name'] ?? "Circonscription " . ($index + 1);
        $ref = $element['tags']['ref'] ?? null;

        // Convertir en GeoJSON
        $geometry = osmRelationToGeometry($element);

        if (!$geometry) {
            echo "ERREUR: Conversion geometry\n";
            $failedRelations[] = $relationId;
            continue;
        }

        $feature = [
            'type' => 'Feature',
            'properties' => [
                'id' => (int)$relationId,
                'name' => $name,
                'ref' => $ref,
                'relationId' => (int)$relationId,
                'relationIndex' => $index
            ],
            'geometry' => $geometry
        ];

        $features[] = $feature;
        echo "OK (" . $geometry['type'] . ")\n";

        // Pause pour ne pas surcharger l'API
        sleep(1);
    }

    // Vérifier si on peut sauvegarder
    $canSave = false;
    if (empty($features)) {
        echo "  AUCUNE feature récupérée!\n\n";
        $errors++;
    } elseif (count($features) === $totalCircos) {
        $canSave = true;
        echo "  => COMPLET: toutes les $totalCircos circonscriptions récupérées\n";
    } elseif ($forceMode) {
        $canSave = true;
        echo "  => PARTIEL (--force): " . count($features) . "/$totalCircos circonscriptions\n";
        echo "  => Relations en échec: " . implode(', ', $failedRelations) . "\n";
    } else {
        echo "  => INCOMPLET: " . count($features) . "/$totalCircos - PAS DE SAUVEGARDE\n";
        echo "  => Relations en échec: " . implode(', ', $failedRelations) . "\n";
        echo "  => Utilisez --force pour sauvegarder partiellement\n\n";
        $partial++;
        continue;
    }

    if ($canSave) {
        // Construire le FeatureCollection
        $featureCollection = [
            'type' => 'FeatureCollection',
            'features' => $features
        ];

        $geojson = json_encode($featureCollection, JSON_UNESCAPED_UNICODE);

        // Mettre à jour la BDD
        $updateStmt->execute([
            'geojson' => $geojson,
            'dept' => $codeDept
        ]);

        echo "  => Sauvegardé: " . count($features) . " features, " . strlen($geojson) . " bytes\n\n";
        $success++;
    }

    // Pause entre les départements
    sleep(2);
}

echo "\n=== TERMINE ===\n";
echo "Succès complets: $success\n";
echo "Partiels (non sauvegardés): $partial\n";
echo "Erreurs: $errors\n";

/**
 * Convertit une relation OSM en geometry GeoJSON (Polygon ou MultiPolygon)
 */
function osmRelationToGeometry($element) {
    if (!isset($element['members'])) {
        return null;
    }

    // Extraire les ways "outer"
    $outerWays = [];
    $innerWays = [];

    foreach ($element['members'] as $member) {
        if ($member['type'] !== 'way') continue;
        if (!isset($member['geometry'])) continue;

        $role = $member['role'] ?? 'outer';
        $coords = [];
        foreach ($member['geometry'] as $point) {
            $coords[] = [$point['lon'], $point['lat']];
        }

        if ($role === 'inner') {
            $innerWays[] = $coords;
        } else {
            $outerWays[] = $coords;
        }
    }

    if (empty($outerWays)) {
        return null;
    }

    // Fusionner les ways outer en anneaux fermés
    $rings = mergeWaysIntoRings($outerWays);

    if (empty($rings)) {
        return null;
    }

    // Si un seul anneau, c'est un Polygon
    if (count($rings) === 1) {
        $coordinates = [$rings[0]];
        // Ajouter les inner rings si présents
        foreach ($innerWays as $inner) {
            $coordinates[] = $inner;
        }
        return [
            'type' => 'Polygon',
            'coordinates' => $coordinates
        ];
    }

    // Plusieurs anneaux = MultiPolygon
    $polygons = [];
    foreach ($rings as $ring) {
        $polygons[] = [$ring];
    }

    return [
        'type' => 'MultiPolygon',
        'coordinates' => $polygons
    ];
}

/**
 * Fusionne les ways en anneaux fermés
 */
function mergeWaysIntoRings($ways) {
    if (empty($ways)) return [];

    $rings = [];
    $remaining = $ways;

    while (!empty($remaining)) {
        $ring = array_shift($remaining);
        $changed = true;

        while ($changed) {
            $changed = false;
            $lastPoint = end($ring);
            $firstPoint = reset($ring);

            foreach ($remaining as $i => $way) {
                $wayFirst = reset($way);
                $wayLast = end($way);

                // Le début du way correspond à la fin du ring
                if (pointsEqual($lastPoint, $wayFirst)) {
                    $ring = array_merge($ring, array_slice($way, 1));
                    unset($remaining[$i]);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                }
                // La fin du way correspond à la fin du ring (inverser le way)
                if (pointsEqual($lastPoint, $wayLast)) {
                    $ring = array_merge($ring, array_slice(array_reverse($way), 1));
                    unset($remaining[$i]);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                }
                // Le début du way correspond au début du ring (inverser le ring)
                if (pointsEqual($firstPoint, $wayFirst)) {
                    $ring = array_merge(array_reverse($ring), array_slice($way, 1));
                    unset($remaining[$i]);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                }
                // La fin du way correspond au début du ring
                if (pointsEqual($firstPoint, $wayLast)) {
                    $ring = array_merge($way, array_slice($ring, 1));
                    unset($remaining[$i]);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                }
            }
        }

        // Fermer l'anneau si nécessaire
        $first = reset($ring);
        $last = end($ring);
        if (!pointsEqual($first, $last)) {
            $ring[] = $first;
        }

        $rings[] = $ring;
    }

    return $rings;
}

/**
 * Compare deux points (avec tolérance)
 */
function pointsEqual($p1, $p2, $tolerance = 0.0001) {
    return abs($p1[0] - $p2[0]) < $tolerance && abs($p1[1] - $p2[1]) < $tolerance;
}
