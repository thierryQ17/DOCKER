<?php
/**
 * Import des geometries GeoJSON depuis Overpass API vers regions et departements
 *
 * Ce script:
 * 1. Recupere toutes les regions/departements avec leurs relation_osm
 * 2. Pour chaque entite, appelle Overpass API pour obtenir les geometries
 * 3. Stocke le GeoJSON resultant dans la colonne geojson
 *
 * Usage: php import_geojson_regions.php [regions|departements] [code]
 * - regions: traite les regions
 * - departements: traite les departements
 * - code: optionnel, traite uniquement l'entite specifiee
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

// Arguments
$type = $argv[1] ?? 'regions';
$specificCode = $argv[2] ?? null;

echo "=== Import GeoJSON des $type ===\n\n";

// Fonction pour appeler Overpass API
function fetchOverpassGeoJSON($relationId) {
    $query = "[out:json][timeout:90];relation($relationId);out body;>;out skel qt;";

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

    return convertToGeoJSON($data['elements'], $relationId);
}

// Comparer deux points (avec tolerance)
function pointsEqual($p1, $p2, $tolerance = 0.00001) {
    if (!$p1 || !$p2) return false;
    return abs($p1[0] - $p2[0]) < $tolerance && abs($p1[1] - $p2[1]) < $tolerance;
}

// Fusionner les segments de ways en anneaux fermes
function mergeWaySegmentsToRings($segments) {
    if (empty($segments)) return [];
    if (count($segments) === 1) {
        $ring = $segments[0];
        if (count($ring) > 2 && !pointsEqual($ring[0], end($ring))) {
            $ring[] = $ring[0];
        }
        return [$ring];
    }

    $rings = [];
    $remaining = array_values($segments);

    while (!empty($remaining)) {
        $ring = array_shift($remaining);
        $remaining = array_values($remaining);
        $changed = true;
        $maxIterations = count($segments) * 4 + 50;
        $iterations = 0;

        while ($changed && $iterations < $maxIterations) {
            $changed = false;
            $iterations++;

            if (empty($ring)) break;

            $firstPoint = $ring[0];
            $lastPoint = $ring[count($ring) - 1];

            if (pointsEqual($firstPoint, $lastPoint) && count($ring) > 3) {
                break;
            }

            for ($i = 0; $i < count($remaining); $i++) {
                $segment = $remaining[$i];
                if (empty($segment)) continue;

                $segFirst = $segment[0];
                $segLast = $segment[count($segment) - 1];

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
                } elseif (pointsEqual($firstPoint, $segLast)) {
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
function convertToGeoJSON($elements, $relationId) {
    $nodes = [];
    foreach ($elements as $el) {
        if ($el['type'] === 'node') {
            $nodes[$el['id']] = [$el['lon'], $el['lat']];
        }
    }

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

    $features = [];
    foreach ($elements as $el) {
        if ($el['type'] !== 'relation' || !isset($el['members'])) {
            continue;
        }

        $outerRings = [];

        // D'abord essayer les ways avec role='outer'
        foreach ($el['members'] as $member) {
            if ($member['type'] === 'way' && $member['role'] === 'outer') {
                $wayId = $member['ref'];
                if (isset($ways[$wayId]) && !empty($ways[$wayId])) {
                    $outerRings[] = $ways[$wayId];
                }
            }
        }

        // Si pas de ways outer, essayer les ways sans role ou avec role vide
        if (empty($outerRings)) {
            foreach ($el['members'] as $member) {
                if ($member['type'] === 'way' && (empty($member['role']) || $member['role'] === '')) {
                    $wayId = $member['ref'];
                    if (isset($ways[$wayId]) && !empty($ways[$wayId])) {
                        $outerRings[] = $ways[$wayId];
                    }
                }
            }
        }

        // En dernier recours, prendre tous les ways (sauf inner)
        if (empty($outerRings)) {
            foreach ($el['members'] as $member) {
                if ($member['type'] === 'way' && $member['role'] !== 'inner') {
                    $wayId = $member['ref'];
                    if (isset($ways[$wayId]) && !empty($ways[$wayId])) {
                        $outerRings[] = $ways[$wayId];
                    }
                }
            }
        }

        if (empty($outerRings)) {
            continue;
        }

        $allRings = mergeWaySegmentsToRings($outerRings);

        if (empty($allRings)) {
            continue;
        }

        $tags = $el['tags'] ?? [];
        $name = $tags['name'] ?? '';

        if (count($allRings) === 1) {
            $geometry = [
                'type' => 'Polygon',
                'coordinates' => [$allRings[0]]
            ];
        } else {
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
                'relationId' => $el['id']
            ],
            'geometry' => $geometry
        ];
    }

    return [
        'type' => 'FeatureCollection',
        'features' => $features
    ];
}

// Traitement selon le type
if ($type === 'regions') {
    $sql = "SELECT id, nom_region, code_region, relation_osm
            FROM regions
            WHERE relation_osm IS NOT NULL AND relation_osm != ''";

    if ($specificCode) {
        $sql .= " AND (code_region = :code OR nom_region = :code)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute(['code' => $specificCode]);
    } else {
        $stmt = $pdo->query($sql);
    }

    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "Regions a traiter: " . count($items) . "\n\n";

    $updateStmt = $pdo->prepare("UPDATE regions SET geojson = :geojson WHERE id = :id");

    $success = 0;
    $errors = [];

    foreach ($items as $index => $item) {
        echo sprintf("[%d/%d] %s (code: %s)... ",
            $index + 1,
            count($items),
            $item['nom_region'],
            $item['code_region']
        );

        $result = fetchOverpassGeoJSON($item['relation_osm']);

        if (isset($result['error'])) {
            echo "ERREUR: " . $result['error'] . "\n";
            $errors[] = $item['nom_region'] . ": " . $result['error'];
            sleep(5);
            continue;
        }

        if (empty($result['features'])) {
            echo "ERREUR: Aucune geometrie\n";
            $errors[] = $item['nom_region'] . ": Aucune geometrie";
            continue;
        }

        $geojsonStr = json_encode($result, JSON_UNESCAPED_UNICODE);

        try {
            $updateStmt->execute([
                'geojson' => $geojsonStr,
                'id' => $item['id']
            ]);

            $sizeKB = round(strlen($geojsonStr) / 1024, 1);
            echo "OK ({$sizeKB} KB)\n";
            $success++;
        } catch (PDOException $e) {
            echo "ERREUR BDD: " . $e->getMessage() . "\n";
            $errors[] = $item['nom_region'] . ": " . $e->getMessage();
        }

        if ($index < count($items) - 1) {
            sleep(15);
        }

        gc_collect_cycles();
    }
} elseif ($type === 'departements') {
    $sql = "SELECT id, numero_departement, nom_departement, relation_osm
            FROM departements
            WHERE relation_osm IS NOT NULL AND relation_osm != ''";

    if ($specificCode) {
        $sql .= " AND numero_departement = :code";
        $stmt = $pdo->prepare($sql);
        $stmt->execute(['code' => $specificCode]);
    } else {
        $stmt = $pdo->query($sql);
    }

    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "Departements a traiter: " . count($items) . "\n\n";

    $updateStmt = $pdo->prepare("UPDATE departements SET geojson = :geojson WHERE id = :id");

    $success = 0;
    $errors = [];

    foreach ($items as $index => $item) {
        echo sprintf("[%d/%d] %s - %s... ",
            $index + 1,
            count($items),
            $item['numero_departement'],
            $item['nom_departement']
        );

        $result = fetchOverpassGeoJSON($item['relation_osm']);

        if (isset($result['error'])) {
            echo "ERREUR: " . $result['error'] . "\n";
            $errors[] = $item['numero_departement'] . ": " . $result['error'];
            sleep(15);
            continue;
        }

        if (empty($result['features'])) {
            echo "ERREUR: Aucune geometrie\n";
            $errors[] = $item['numero_departement'] . ": Aucune geometrie";
            continue;
        }

        $geojsonStr = json_encode($result, JSON_UNESCAPED_UNICODE);

        try {
            $updateStmt->execute([
                'geojson' => $geojsonStr,
                'id' => $item['id']
            ]);

            $sizeKB = round(strlen($geojsonStr) / 1024, 1);
            echo "OK ({$sizeKB} KB)\n";
            $success++;
        } catch (PDOException $e) {
            echo "ERREUR BDD: " . $e->getMessage() . "\n";
            $errors[] = $item['numero_departement'] . ": " . $e->getMessage();
        }

        if ($index < count($items) - 1) {
            sleep(15);
        }

        gc_collect_cycles();
    }
} else {
    die("Type invalide. Utilisez 'regions' ou 'departements'\n");
}

echo "\n=== Resultat ===\n";
echo "Succes: $success / " . count($items) . "\n";

if (!empty($errors)) {
    echo "\nErreurs:\n";
    foreach ($errors as $err) {
        echo "  - $err\n";
    }
}

echo "\nTermine!\n";
