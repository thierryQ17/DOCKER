<?php
/**
 * Import des geometries GeoJSON des DEPARTEMENTS depuis Overpass API
 *
 * Ce script:
 * 1. Recupere tous les departements avec leur relation_osm (contour du departement)
 * 2. Pour chaque departement, appelle Overpass API pour obtenir la geometrie
 * 3. Stocke le GeoJSON resultant dans la colonne geojson de la table departements
 *
 * Usage: php import_geojson_departements.php [code_dept]
 * - Sans argument: traite tous les departements
 * - Avec argument: traite uniquement le departement specifie (ex: 59, 75, 2A)
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

echo "=== Import GeoJSON des DEPARTEMENTS ===\n\n";

// Recuperer les departements a traiter
$sql = "SELECT numero_departement, nom_departement, relation_osm
        FROM departements
        WHERE relation_osm IS NOT NULL AND relation_osm != '' AND relation_osm != '0'";

if ($specificDept) {
    $sql .= " AND numero_departement = :dept";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['dept' => $specificDept]);
} else {
    $sql .= " ORDER BY numero_departement";
    $stmt = $pdo->query($sql);
}

$departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

if (count($departements) === 0) {
    echo "Aucun departement trouve avec une relation OSM.\n";
    exit;
}

echo "Departements a traiter: " . count($departements) . "\n\n";

// Fonction pour appeler Overpass API (une seule relation par departement)
function fetchOverpassGeoJSON($relationId) {
    // Requete Overpass pour une seule relation
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

    // Convertir en GeoJSON Feature (pas FeatureCollection car un seul departement)
    return convertToGeoJSON($data['elements'], $relationId);
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

// Fonction pour convertir les elements Overpass en GeoJSON Feature
function convertToGeoJSON($elements, $relationId) {
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

    // Trouver la relation
    foreach ($elements as $el) {
        if ($el['type'] === 'relation' && $el['id'] == $relationId) {
            $outerRings = [];
            $innerRings = [];

            foreach ($el['members'] as $member) {
                if ($member['type'] === 'way') {
                    $wayId = $member['ref'];
                    if (isset($ways[$wayId]) && !empty($ways[$wayId])) {
                        if ($member['role'] === 'outer') {
                            $outerRings[] = $ways[$wayId];
                        } elseif ($member['role'] === 'inner') {
                            $innerRings[] = $ways[$wayId];
                        }
                    }
                }
            }

            if (empty($outerRings)) {
                return ['error' => 'Pas de contour outer'];
            }

            // Fusionner les segments en anneaux
            $allOuterRings = mergeWaySegmentsToRings($outerRings);
            $allInnerRings = mergeWaySegmentsToRings($innerRings);

            if (empty($allOuterRings)) {
                return ['error' => 'Impossible de fusionner les anneaux'];
            }

            // Extraire les tags
            $tags = $el['tags'] ?? [];
            $name = $tags['name'] ?? ('Departement ' . $relationId);

            // Construire la geometrie
            // Si un seul outer ring: Polygon avec eventuellement des inner rings
            // Si plusieurs outer rings: MultiPolygon
            if (count($allOuterRings) === 1) {
                $coordinates = [$allOuterRings[0]];
                // Ajouter les inner rings au premier polygon
                foreach ($allInnerRings as $innerRing) {
                    $coordinates[] = $innerRing;
                }
                $geometry = [
                    'type' => 'Polygon',
                    'coordinates' => $coordinates
                ];
            } else {
                // MultiPolygon
                $coordinates = [];
                foreach ($allOuterRings as $idx => $outerRing) {
                    // Pour simplifier, on met tous les inner rings dans le premier polygon
                    if ($idx === 0 && !empty($allInnerRings)) {
                        $polygonCoords = [$outerRing];
                        foreach ($allInnerRings as $innerRing) {
                            $polygonCoords[] = $innerRing;
                        }
                        $coordinates[] = $polygonCoords;
                    } else {
                        $coordinates[] = [$outerRing];
                    }
                }
                $geometry = [
                    'type' => 'MultiPolygon',
                    'coordinates' => $coordinates
                ];
            }

            return [
                'type' => 'Feature',
                'properties' => [
                    'id' => $el['id'],
                    'name' => $name,
                    'ref' => $tags['ref'] ?? '',
                    'insee' => $tags['ref:INSEE'] ?? '',
                    'admin_level' => $tags['admin_level'] ?? '6'
                ],
                'geometry' => $geometry
            ];
        }
    }

    return ['error' => 'Relation non trouvee'];
}

// Preparer la requete de mise a jour
$updateStmt = $pdo->prepare("
    UPDATE departements
    SET geojson = :geojson
    WHERE numero_departement = :code_dept
");

$success = 0;
$errors = [];

foreach ($departements as $index => $dept) {
    $codeDept = $dept['numero_departement'];
    $nomDept = $dept['nom_departement'];
    $relationId = $dept['relation_osm'];

    echo sprintf("[%d/%d] %s (%s) - relation %s... ",
        $index + 1,
        count($departements),
        $nomDept,
        $codeDept,
        $relationId
    );

    if (empty($relationId)) {
        echo "SKIP (pas de relation)\n";
        continue;
    }

    // Appeler Overpass API
    $result = fetchOverpassGeoJSON($relationId);

    if (isset($result['error'])) {
        echo "ERREUR: " . $result['error'] . "\n";
        $errors[] = "$codeDept: " . $result['error'];
        sleep(5);
        continue;
    }

    // Verifier qu'on a une geometrie
    if (!isset($result['geometry'])) {
        echo "ERREUR: Pas de geometrie\n";
        $errors[] = "$codeDept: Pas de geometrie";
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
        $geomType = $result['geometry']['type'];
        echo "OK ({$geomType}, {$sizeKB} KB)\n";
        $success++;
    } catch (PDOException $e) {
        echo "ERREUR BDD: " . $e->getMessage() . "\n";
        $errors[] = "$codeDept: " . $e->getMessage();
    }

    // Pause pour respecter les limites Overpass API
    if ($index < count($departements) - 1) {
        sleep(3);
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
