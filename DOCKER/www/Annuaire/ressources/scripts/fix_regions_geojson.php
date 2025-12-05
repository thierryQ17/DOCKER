<?php
/**
 * Script pour corriger les GeoJSON des régions Hauts-de-France et Occitanie
 */

ini_set('memory_limit', '512M');
set_time_limit(300);

try {
    $pdo = new PDO(
        'mysql:host=mysql_db;dbname=annuairesMairesDeFrance;charset=utf8mb4',
        'root',
        'root',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    die("Erreur connexion: " . $e->getMessage() . "\n");
}

// Régions à corriger avec leurs IDs OSM
$regions = [
    'Hauts-de-France' => 1773437,   // Relation OSM correcte
    'Occitanie' => 3792879          // Relation OSM
];

echo "=== Correction des GeoJSON régions ===\n\n";

foreach ($regions as $regionName => $relationId) {
    echo "Traitement: $regionName (relation $relationId)...\n";

    // Télécharger depuis Overpass API
    $overpassUrl = "https://overpass-api.de/api/interpreter";
    $query = "[out:json];relation($relationId);out geom;";

    echo "  Téléchargement depuis Overpass...\n";

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $overpassUrl);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, "data=" . urlencode($query));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 120);
    curl_setopt($ch, CURLOPT_USERAGENT, 'AnnuaireMaires/1.0');

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode !== 200 || !$response) {
        echo "  ERREUR: Téléchargement échoué (HTTP $httpCode)\n";
        continue;
    }

    $data = json_decode($response, true);
    if (!$data || !isset($data['elements']) || empty($data['elements'])) {
        echo "  ERREUR: Pas de données\n";
        continue;
    }

    $element = $data['elements'][0];

    // Convertir en GeoJSON
    echo "  Conversion en GeoJSON...\n";
    $geojson = convertToGeoJSON($element);

    if (!$geojson) {
        echo "  ERREUR: Conversion échouée\n";
        continue;
    }

    $geojsonStr = json_encode($geojson, JSON_UNESCAPED_UNICODE);
    echo "  Taille GeoJSON: " . strlen($geojsonStr) . " bytes\n";

    // Simplifier
    echo "  Simplification...\n";
    $simplified = simplifyGeoJSON($geojsonStr, 0.008);
    echo "  Taille simplifiée: " . strlen($simplified) . " bytes\n";

    // Mettre à jour la base
    $stmt = $pdo->prepare("UPDATE t_regions SET geojson = :geojson, geojson_simple = :simple WHERE nom_region = :nom");
    $stmt->execute([
        'geojson' => $geojsonStr,
        'simple' => $simplified,
        'nom' => $regionName
    ]);

    // Aussi mettre à jour la table regions
    $stmt = $pdo->prepare("UPDATE regions SET geojson = :geojson WHERE nom_region = :nom");
    $stmt->execute([
        'geojson' => $geojsonStr,
        'nom' => $regionName
    ]);

    echo "  OK!\n\n";
}

echo "=== Terminé ===\n";

// Vérification
$stmt = $pdo->query("SELECT nom_region, LENGTH(geojson_simple) as size FROM t_regions WHERE nom_region IN ('Hauts-de-France', 'Occitanie')");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "{$row['nom_region']}: {$row['size']} bytes\n";
}

// Fonctions de conversion et simplification
function convertToGeoJSON($element) {
    if (!isset($element['members'])) {
        return null;
    }

    $coordinates = [];
    $currentRing = [];

    foreach ($element['members'] as $member) {
        if ($member['type'] === 'way' && isset($member['geometry'])) {
            $ring = [];
            foreach ($member['geometry'] as $point) {
                $ring[] = [$point['lon'], $point['lat']];
            }

            // Essayer de connecter les anneaux
            if (empty($currentRing)) {
                $currentRing = $ring;
            } else {
                $lastPoint = end($currentRing);
                $firstPoint = $ring[0];

                // Si les points se connectent
                if (abs($lastPoint[0] - $firstPoint[0]) < 0.0001 && abs($lastPoint[1] - $firstPoint[1]) < 0.0001) {
                    array_shift($ring);
                    $currentRing = array_merge($currentRing, $ring);
                } else {
                    // Nouveau ring
                    if (count($currentRing) >= 4) {
                        // Fermer le ring
                        if ($currentRing[0] !== end($currentRing)) {
                            $currentRing[] = $currentRing[0];
                        }
                        $coordinates[] = [$currentRing];
                    }
                    $currentRing = $ring;
                }
            }
        }
    }

    // Ajouter le dernier ring
    if (count($currentRing) >= 4) {
        if ($currentRing[0] !== end($currentRing)) {
            $currentRing[] = $currentRing[0];
        }
        $coordinates[] = [$currentRing];
    }

    if (empty($coordinates)) {
        return null;
    }

    return [
        'type' => 'FeatureCollection',
        'features' => [[
            'type' => 'Feature',
            'properties' => [
                'id' => $element['id'],
                'name' => $element['tags']['name'] ?? '',
                'relationId' => $element['id']
            ],
            'geometry' => [
                'type' => 'MultiPolygon',
                'coordinates' => $coordinates
            ]
        ]]
    ];
}

function simplifyGeoJSON($geojsonStr, $tolerance = 0.01) {
    $geojson = json_decode($geojsonStr, true);
    if (!$geojson) return $geojsonStr;

    if (isset($geojson['features'])) {
        foreach ($geojson['features'] as &$feature) {
            if (isset($feature['geometry'])) {
                $feature['geometry'] = simplifyGeometry($feature['geometry'], $tolerance);
            }
        }
    }

    return json_encode($geojson, JSON_UNESCAPED_UNICODE);
}

function simplifyGeometry($geometry, $tolerance) {
    if (!isset($geometry['type']) || !isset($geometry['coordinates'])) {
        return $geometry;
    }

    switch ($geometry['type']) {
        case 'Polygon':
            $geometry['coordinates'] = simplifyCoordinates($geometry['coordinates'], $tolerance);
            break;
        case 'MultiPolygon':
            $newCoords = [];
            foreach ($geometry['coordinates'] as $polygon) {
                $simplified = simplifyCoordinates($polygon, $tolerance);
                if (!empty($simplified)) {
                    $newCoords[] = $simplified;
                }
            }
            $geometry['coordinates'] = $newCoords;
            break;
    }

    return $geometry;
}

function simplifyCoordinates($coords, $tolerance) {
    $simplified = [];
    foreach ($coords as $ring) {
        $simplifiedRing = douglasPeucker($ring, $tolerance);
        if (count($simplifiedRing) >= 4) {
            if ($simplifiedRing[0] !== $simplifiedRing[count($simplifiedRing) - 1]) {
                $simplifiedRing[] = $simplifiedRing[0];
            }
            $simplified[] = $simplifiedRing;
        }
    }
    return $simplified;
}

function douglasPeucker($points, $tolerance) {
    if (count($points) < 3) return $points;

    $dmax = 0;
    $index = 0;
    $end = count($points) - 1;

    for ($i = 1; $i < $end; $i++) {
        $d = perpendicularDistance($points[$i], $points[0], $points[$end]);
        if ($d > $dmax) {
            $index = $i;
            $dmax = $d;
        }
    }

    if ($dmax > $tolerance) {
        $results1 = douglasPeucker(array_slice($points, 0, $index + 1), $tolerance);
        $results2 = douglasPeucker(array_slice($points, $index), $tolerance);
        array_pop($results1);
        return array_merge($results1, $results2);
    } else {
        return [$points[0], $points[$end]];
    }
}

function perpendicularDistance($point, $lineStart, $lineEnd) {
    $x = $point[0]; $y = $point[1];
    $x1 = $lineStart[0]; $y1 = $lineStart[1];
    $x2 = $lineEnd[0]; $y2 = $lineEnd[1];

    $A = $x - $x1; $B = $y - $y1;
    $C = $x2 - $x1; $D = $y2 - $y1;

    $dot = $A * $C + $B * $D;
    $lenSq = $C * $C + $D * $D;

    if ($lenSq == 0) return sqrt($A * $A + $B * $B);

    $param = $dot / $lenSq;

    if ($param < 0) { $xx = $x1; $yy = $y1; }
    else if ($param > 1) { $xx = $x2; $yy = $y2; }
    else { $xx = $x1 + $param * $C; $yy = $y1 + $param * $D; }

    return sqrt(($x - $xx) * ($x - $xx) + ($y - $yy) * ($y - $yy));
}
