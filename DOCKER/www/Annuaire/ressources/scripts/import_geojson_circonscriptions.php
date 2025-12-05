<?php
/**
 * Import des geometries GeoJSON depuis Overpass API vers t_circonscriptions
 *
 * Ce script:
 * 1. Recupere tous les departements avec leurs relation_osm
 * 2. Pour chaque departement, appelle Overpass API pour obtenir les geometries
 * 3. Stocke le GeoJSON resultant dans la colonne geojson
 *
 * Usage: php import_geojson_circonscriptions.php [code_dept]
 * - Sans argument: traite tous les departements
 * - Avec argument: traite uniquement le departement specifie (ex: 60, 75, 2A)
 */

set_time_limit(0);
ini_set('memory_limit', '512M');

// Connexion BDD
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

// Argument optionnel: code departement specifique
$specificDept = $argv[1] ?? null;

echo "=== Import GeoJSON des circonscriptions ===\n\n";

// Recuperer les departements a traiter
$sql = "SELECT code_departement, nom_departement, relation_osm
        FROM t_circonscriptions
        WHERE relation_osm IS NOT NULL AND relation_osm != ''";

if ($specificDept) {
    $sql .= " AND code_departement = :dept";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['dept' => $specificDept]);
} else {
    $stmt = $pdo->query($sql);
}

$departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

if (count($departements) === 0) {
    echo "Aucun departement trouve avec des relations OSM.\n";
    exit;
}

echo "Departements a traiter: " . count($departements) . "\n\n";

// Fonction pour appeler Overpass API
function fetchOverpassGeoJSON($relationIds) {
    // Construire la requete Overpass
    $relationsQuery = '';
    foreach ($relationIds as $id) {
        $relationsQuery .= "relation($id);";
    }

    // Requete Overpass - out body pour les tags, >; pour les membres, out skel qt pour les coords
    $query = "[out:json][timeout:90];($relationsQuery);out body;>;out skel qt;";

    $url = 'https://overpass-api.de/api/interpreter';

    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $url,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => 'data=' . urlencode($query),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 120,
        CURLOPT_HTTPHEADER => [
            'Content-Type: application/x-www-form-urlencoded',
            'User-Agent: AnnuaireMaires/1.0'
        ]
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);

    if ($error) {
        return ['error' => "Erreur cURL: $error"];
    }

    if ($httpCode !== 200) {
        return ['error' => "HTTP $httpCode"];
    }

    $data = json_decode($response, true);
    if (!$data || !isset($data['elements'])) {
        return ['error' => "Reponse invalide"];
    }

    // Convertir en GeoJSON FeatureCollection
    return convertToGeoJSON($data['elements'], $relationIds);
}

// Comparer deux points (avec tolerance)
function pointsEqual($p1, $p2, $tolerance = 0.00001) {
    if (!$p1 || !$p2) return false;
    return abs($p1[0] - $p2[0]) < $tolerance && abs($p1[1] - $p2[1]) < $tolerance;
}

// Fusionner les segments de ways en anneaux fermes (retourne TOUS les anneaux)
function mergeWaySegmentsToRings($segments) {
    if (empty($segments)) return [];
    if (count($segments) === 1) {
        $ring = $segments[0];
        // Fermer l'anneau si necessaire
        if (count($ring) > 2 && !pointsEqual($ring[0], end($ring))) {
            $ring[] = $ring[0];
        }
        return [$ring];
    }

    $rings = [];
    $remaining = array_values($segments); // Reindexer

    while (!empty($remaining)) {
        // Commencer un nouvel anneau
        $ring = array_shift($remaining);
        $remaining = array_values($remaining); // Reindexer apres shift
        $changed = true;
        $maxIterations = count($segments) * 4 + 50;
        $iterations = 0;

        while ($changed && $iterations < $maxIterations) {
            $changed = false;
            $iterations++;

            if (empty($ring)) break;

            $firstPoint = $ring[0];
            $lastPoint = $ring[count($ring) - 1];

            // Verifier si l'anneau est ferme
            if (pointsEqual($firstPoint, $lastPoint) && count($ring) > 3) {
                break;
            }

            for ($i = 0; $i < count($remaining); $i++) {
                $segment = $remaining[$i];
                if (empty($segment)) continue;

                $segFirst = $segment[0];
                $segLast = $segment[count($segment) - 1];

                // Essayer de connecter a la fin de l'anneau
                if (pointsEqual($lastPoint, $segFirst)) {
                    $ring = array_merge($ring, array_slice($segment, 1));
                    array_splice($remaining, $i, 1);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                } elseif (pointsEqual($lastPoint, $segLast)) {
                    $ring = array_merge($ring, array_slice(array_reverse($segment), 1));
                    array_splice($remaining, $i, 1);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                }
                // Essayer de connecter au debut de l'anneau
                elseif (pointsEqual($firstPoint, $segLast)) {
                    $ring = array_merge(array_slice($segment, 0, -1), $ring);
                    array_splice($remaining, $i, 1);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                } elseif (pointsEqual($firstPoint, $segFirst)) {
                    $ring = array_merge(array_slice(array_reverse($segment), 0, -1), $ring);
                    array_splice($remaining, $i, 1);
                    $remaining = array_values($remaining);
                    $changed = true;
                    break;
                }
            }
        }

        // Fermer l'anneau si necessaire
        if (count($ring) > 2) {
            if (!pointsEqual($ring[0], $ring[count($ring) - 1])) {
                $ring[] = $ring[0];
            }
            $rings[] = $ring;
        }
    }

    return $rings;
}

// Fonction pour convertir les elements Overpass en GeoJSON
// Reproduit exactement l'algorithme JavaScript osmToGeoJSON
function convertToGeoJSON($elements, $relationIds = []) {
    // Indexer les noeuds
    $nodes = [];
    foreach ($elements as $el) {
        if ($el['type'] === 'node') {
            $nodes[$el['id']] = [$el['lon'], $el['lat']];
        }
    }

    // Indexer les ways
    $ways = [];
    foreach ($elements as $el) {
        if ($el['type'] === 'way' && isset($el['nodes'])) {
            $wayCoords = [];
            foreach ($el['nodes'] as $nodeId) {
                if (isset($nodes[$nodeId])) {
                    $wayCoords[] = $nodes[$nodeId];
                }
            }
            $ways[$el['id']] = $wayCoords;
        }
    }

    // Traiter les relations
    $features = [];
    foreach ($elements as $el) {
        if ($el['type'] !== 'relation' || !isset($el['members'])) {
            continue;
        }

        $outerRings = [];

        foreach ($el['members'] as $member) {
            if ($member['type'] === 'way' && $member['role'] === 'outer') {
                $wayId = $member['ref'];
                if (isset($ways[$wayId]) && !empty($ways[$wayId])) {
                    $outerRings[] = $ways[$wayId];
                }
            }
        }

        if (empty($outerRings)) {
            continue;
        }

        // Fusionner les segments en anneaux
        $allRings = mergeWaySegmentsToRings($outerRings);

        if (empty($allRings)) {
            continue;
        }

        // Trouver l'index de cette relation dans la liste
        $relationIndex = array_search((string)$el['id'], array_map('strval', $relationIds));
        if ($relationIndex === false) {
            $relationIndex = count($features);
        }

        // Extraire les tags
        $tags = $el['tags'] ?? [];
        $name = $tags['name'] ?? ('Circonscription ' . $el['id']);

        // Construire la geometrie
        if (count($allRings) === 1) {
            $geometry = [
                'type' => 'Polygon',
                'coordinates' => [$allRings[0]]
            ];
        } else {
            // MultiPolygon: chaque anneau est un polygone separe
            $coordinates = [];
            foreach ($allRings as $ring) {
                $coordinates[] = [$ring];
            }
            $geometry = [
                'type' => 'MultiPolygon',
                'coordinates' => $coordinates
            ];
        }

        $features[] = [
            'type' => 'Feature',
            'properties' => [
                'id' => $el['id'],
                'name' => $name,
                'ref' => $tags['ref'] ?? '',
                'relationId' => $el['id'],
                'relationIndex' => $relationIndex
            ],
            'geometry' => $geometry
        ];
    }

    return [
        'type' => 'FeatureCollection',
        'features' => $features
    ];
}

// Preparer la requete de mise a jour
$updateStmt = $pdo->prepare("
    UPDATE t_circonscriptions
    SET geojson = :geojson
    WHERE code_departement = :code_dept
");

$success = 0;
$errors = [];

foreach ($departements as $index => $dept) {
    $codeDept = $dept['code_departement'];
    $nomDept = $dept['nom_departement'];
    $relationIds = array_filter(explode(',', $dept['relation_osm']));

    echo sprintf("[%d/%d] %s (%s) - %d circonscriptions... ",
        $index + 1,
        count($departements),
        $nomDept,
        $codeDept,
        count($relationIds)
    );

    if (empty($relationIds)) {
        echo "SKIP (pas de relations)\n";
        continue;
    }

    // Appeler Overpass API
    $result = fetchOverpassGeoJSON($relationIds);

    if (isset($result['error'])) {
        echo "ERREUR: " . $result['error'] . "\n";
        $errors[] = "$codeDept: " . $result['error'];
        // Pause plus longue en cas d'erreur
        sleep(5);
        continue;
    }

    // Verifier qu'on a des features
    if (empty($result['features'])) {
        echo "ERREUR: Aucune geometrie\n";
        $errors[] = "$codeDept: Aucune geometrie";
        continue;
    }

    // Stocker en BDD
    $geojsonStr = json_encode($result, JSON_UNESCAPED_UNICODE);

    try {
        $updateStmt->execute([
            'geojson' => $geojsonStr,
            'code_dept' => $codeDept
        ]);

        $sizeKB = round(strlen($geojsonStr) / 1024, 1);
        echo "OK (" . count($result['features']) . " features, {$sizeKB} KB)\n";
        $success++;
    } catch (PDOException $e) {
        echo "ERREUR BDD: " . $e->getMessage() . "\n";
        $errors[] = "$codeDept: " . $e->getMessage();
    }

    // Pause pour respecter les limites Overpass API (5 secondes pour eviter 429)
    if ($index < count($departements) - 1) {
        sleep(5);
    }

    // Liberer la memoire
    unset($result);
    gc_collect_cycles();
}

echo "\n=== Resultat ===\n";
echo "Succes: $success / " . count($departements) . "\n";

if (!empty($errors)) {
    echo "\nErreurs:\n";
    foreach ($errors as $err) {
        echo "  - $err\n";
    }
}

echo "\nTermine!\n";
