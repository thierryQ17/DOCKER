<?php
/**
 * Script pour réimporter les GeoJSON des cantons depuis OpenStreetMap
 * Les cantons électoraux français (depuis 2015) utilisent boundary=political dans OSM
 * Note: admin_level=7 = arrondissements, admin_level=8 = communes
 *
 * Usage: php reimport_cantons_geojson.php [dept_code]
 * Exemple: php reimport_cantons_geojson.php 60
 */

ini_set('display_errors', 1);
error_reporting(E_ALL);
set_time_limit(0);

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

// Paramètre département (optionnel)
$targetDept = isset($argv[1]) ? $argv[1] : null;

echo "=== Réimport GeoJSON Cantons depuis OpenStreetMap ===\n\n";

/**
 * Récupère le GeoJSON d'un canton via Overpass API
 */
function fetchCantonGeoJSON($relationId) {
    $overpassUrl = 'https://overpass-api.de/api/interpreter';

    $query = "[out:json][timeout:60];
relation({$relationId});
out geom;";

    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $overpassUrl,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => 'data=' . urlencode($query),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 120,
        CURLOPT_HTTPHEADER => ['User-Agent: AnnuaireMairesFrance/1.0']
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode !== 200 || !$response) {
        return null;
    }

    $data = json_decode($response, true);
    if (!$data || empty($data['elements'])) {
        return null;
    }

    // Convertir en GeoJSON
    return convertToGeoJSON($data['elements'][0]);
}

/**
 * Convertit une relation OSM en GeoJSON
 */
function convertToGeoJSON($element) {
    if ($element['type'] !== 'relation' || !isset($element['members'])) {
        return null;
    }

    $coordinates = [];
    $outerWays = [];

    // Extraire les ways "outer"
    foreach ($element['members'] as $member) {
        if ($member['type'] === 'way' && isset($member['geometry'])) {
            $role = $member['role'] ?? 'outer';
            if ($role === 'outer' || $role === '') {
                $wayCoords = [];
                foreach ($member['geometry'] as $point) {
                    $wayCoords[] = [$point['lon'], $point['lat']];
                }
                $outerWays[] = $wayCoords;
            }
        }
    }

    if (empty($outerWays)) {
        return null;
    }

    // Assembler les ways en polygones
    $polygons = assemblePolygons($outerWays);

    if (empty($polygons)) {
        return null;
    }

    $properties = [
        'name' => $element['tags']['name'] ?? '',
        'ref' => $element['tags']['ref'] ?? '',
        'admin_level' => $element['tags']['admin_level'] ?? '9'
    ];

    // Simple polygone ou multipolygone
    if (count($polygons) === 1) {
        $geojson = [
            'type' => 'Feature',
            'properties' => $properties,
            'geometry' => [
                'type' => 'Polygon',
                'coordinates' => [$polygons[0]]
            ]
        ];
    } else {
        $multiCoords = [];
        foreach ($polygons as $poly) {
            $multiCoords[] = [$poly];
        }
        $geojson = [
            'type' => 'Feature',
            'properties' => $properties,
            'geometry' => [
                'type' => 'MultiPolygon',
                'coordinates' => $multiCoords
            ]
        ];
    }

    return json_encode(['type' => 'FeatureCollection', 'features' => [$geojson]]);
}

/**
 * Assemble des segments de ways en polygones fermés
 */
function assemblePolygons($ways) {
    if (empty($ways)) return [];

    $polygons = [];
    $remaining = $ways;

    while (!empty($remaining)) {
        $current = array_shift($remaining);
        $changed = true;

        while ($changed && !empty($remaining)) {
            $changed = false;

            foreach ($remaining as $key => $way) {
                $currentFirst = $current[0];
                $currentLast = $current[count($current) - 1];
                $wayFirst = $way[0];
                $wayLast = $way[count($way) - 1];

                // Connecter les ways
                if (coordsEqual($currentLast, $wayFirst)) {
                    array_pop($current);
                    $current = array_merge($current, $way);
                    unset($remaining[$key]);
                    $changed = true;
                    break;
                } elseif (coordsEqual($currentLast, $wayLast)) {
                    array_pop($current);
                    $current = array_merge($current, array_reverse($way));
                    unset($remaining[$key]);
                    $changed = true;
                    break;
                } elseif (coordsEqual($currentFirst, $wayLast)) {
                    array_pop($way);
                    $current = array_merge($way, $current);
                    unset($remaining[$key]);
                    $changed = true;
                    break;
                } elseif (coordsEqual($currentFirst, $wayFirst)) {
                    array_shift($current);
                    $current = array_merge(array_reverse($way), $current);
                    unset($remaining[$key]);
                    $changed = true;
                    break;
                }
            }

            $remaining = array_values($remaining);
        }

        // Fermer le polygone si nécessaire
        if (!coordsEqual($current[0], $current[count($current) - 1])) {
            $current[] = $current[0];
        }

        $polygons[] = $current;
    }

    return $polygons;
}

/**
 * Compare deux coordonnées
 */
function coordsEqual($a, $b, $tolerance = 0.000001) {
    return abs($a[0] - $b[0]) < $tolerance && abs($a[1] - $b[1]) < $tolerance;
}

/**
 * Recherche les cantons d'un département via Overpass API
 * Les cantons électoraux français utilisent boundary=political dans OSM
 */
function findCantonsOSM($deptCode, $deptNom) {
    echo "  Recherche cantons OSM pour {$deptCode} - {$deptNom}...\n";

    $overpassUrl = 'https://overpass-api.de/api/interpreter';

    // Rechercher les cantons électoraux (boundary=political avec political_division=canton)
    // ou avec ref:INSEE commençant par le code département
    $query = "[out:json][timeout:120];
area[\"ISO3166-2\"=\"FR-{$deptCode}\"]->.searchArea;
(
  relation[\"boundary\"=\"political\"][\"political_division\"=\"canton\"](area.searchArea);
  relation[\"ref:INSEE\"~\"^{$deptCode}\"](area.searchArea);
);
out tags;";

    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $overpassUrl,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => 'data=' . urlencode($query),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 180,
        CURLOPT_HTTPHEADER => ['User-Agent: AnnuaireMairesFrance/1.0']
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode !== 200 || !$response) {
        echo "    Erreur HTTP: {$httpCode}\n";
        return [];
    }

    $data = json_decode($response, true);
    if (!$data || empty($data['elements'])) {
        echo "    Aucun canton trouvé\n";
        return [];
    }

    $cantons = [];
    foreach ($data['elements'] as $element) {
        if ($element['type'] === 'relation') {
            $cantons[] = [
                'relation_id' => $element['id'],
                'name' => $element['tags']['name'] ?? '',
                'ref' => $element['tags']['ref'] ?? ''
            ];
        }
    }

    echo "    " . count($cantons) . " cantons trouvés\n";
    return $cantons;
}

/**
 * Associe un canton OSM à un canton de la BDD
 */
function matchCantonToDb($pdo, $deptCode, $osmCanton) {
    $osmName = $osmCanton['name'];
    $osmRef = $osmCanton['ref'];

    // D'abord essayer par ref (code canton)
    if ($osmRef) {
        $stmt = $pdo->prepare("
            SELECT id, canton_nom FROM t_cantons
            WHERE departement_numero = :dept AND canton_code LIKE :ref
        ");
        $stmt->execute(['dept' => $deptCode, 'ref' => '%' . $osmRef]);
        $match = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($match) {
            return $match;
        }
    }

    // Sinon essayer par nom
    if ($osmName) {
        // Nettoyer le nom (enlever "Canton de ", "Canton d'", etc.)
        $cleanName = preg_replace('/^Canton (de |d\'|des |du )/i', '', $osmName);

        $stmt = $pdo->prepare("
            SELECT id, canton_nom FROM t_cantons
            WHERE departement_numero = :dept
            AND (canton_nom LIKE :name1 OR canton_nom LIKE :name2 OR canton_nom LIKE :name3)
        ");
        $stmt->execute([
            'dept' => $deptCode,
            'name1' => $cleanName,
            'name2' => '%' . $cleanName . '%',
            'name3' => $osmName
        ]);
        $match = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($match) {
            return $match;
        }
    }

    return null;
}

// Récupérer les départements à traiter
if ($targetDept) {
    $stmt = $pdo->prepare("SELECT DISTINCT departement_numero, departement_nom FROM t_cantons WHERE departement_numero = :dept");
    $stmt->execute(['dept' => $targetDept]);
} else {
    $stmt = $pdo->query("SELECT DISTINCT departement_numero, departement_nom FROM t_cantons ORDER BY departement_numero");
}
$departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Départements à traiter: " . count($departements) . "\n\n";

$totalUpdated = 0;
$totalNotFound = 0;

foreach ($departements as $dept) {
    $deptCode = $dept['departement_numero'];
    $deptNom = $dept['departement_nom'];

    echo "\n[{$deptCode}] {$deptNom}\n";

    // Rechercher les cantons OSM
    $osmCantons = findCantonsOSM($deptCode, $deptNom);

    if (empty($osmCantons)) {
        echo "  Aucun canton OSM trouvé, passage au suivant\n";
        continue;
    }

    $deptUpdated = 0;
    $deptNotMatched = 0;

    foreach ($osmCantons as $osmCanton) {
        $relationId = $osmCanton['relation_id'];
        $osmName = $osmCanton['name'];

        echo "  - {$osmName} (OSM: {$relationId})";

        // Associer au canton en BDD
        $dbMatch = matchCantonToDb($pdo, $deptCode, $osmCanton);

        if (!$dbMatch) {
            echo " => Non trouvé en BDD\n";
            $deptNotMatched++;
            $totalNotFound++;
            continue;
        }

        echo " => {$dbMatch['canton_nom']} (ID: {$dbMatch['id']})";

        // Récupérer le GeoJSON depuis OSM
        $geojson = fetchCantonGeoJSON($relationId);

        if (!$geojson) {
            echo " => Erreur GeoJSON\n";
            continue;
        }

        // Mettre à jour en BDD (dans geojson_osm pour ne pas écraser les données existantes)
        $stmt = $pdo->prepare("
            UPDATE t_cantons
            SET relation_osm = :relation_osm, geojson_osm = :geojson_osm
            WHERE id = :id
        ");
        $stmt->execute([
            'relation_osm' => $relationId,
            'geojson_osm' => $geojson,
            'id' => $dbMatch['id']
        ]);

        echo " => OK\n";
        $deptUpdated++;
        $totalUpdated++;

        // Pause pour respecter les limites Overpass
        usleep(500000); // 0.5 seconde
    }

    echo "  Résumé {$deptCode}: {$deptUpdated} mis à jour, {$deptNotMatched} non trouvés\n";

    // Pause entre départements
    sleep(2);
}

echo "\n=== TERMINÉ ===\n";
echo "Total mis à jour: {$totalUpdated}\n";
echo "Total non trouvés: {$totalNotFound}\n";
