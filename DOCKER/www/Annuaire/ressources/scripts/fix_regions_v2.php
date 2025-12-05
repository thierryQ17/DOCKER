<?php
/**
 * Script pour corriger les GeoJSON des régions manquantes
 * Télécharge depuis polygons.openstreetmap.fr
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

// Régions à corriger avec leurs bons IDs OSM
$regions = [
    'Hauts-de-France' => 4217435,
    'Occitanie' => 3792883
];

echo "=== Correction des GeoJSON régions ===\n\n";

foreach ($regions as $regionName => $relationId) {
    echo "Traitement: $regionName (relation $relationId)...\n";

    // Télécharger depuis polygons.openstreetmap.fr
    $url = "https://polygons.openstreetmap.fr/get_geojson.py?id=$relationId&params=0";
    echo "  Téléchargement...\n";

    $context = stream_context_create([
        'http' => [
            'timeout' => 120,
            'user_agent' => 'AnnuaireMaires/1.0'
        ]
    ]);

    $geometry = @file_get_contents($url, false, $context);

    if (!$geometry) {
        echo "  ERREUR: Téléchargement échoué\n";
        continue;
    }

    echo "  Taille téléchargée: " . strlen($geometry) . " bytes\n";

    // Créer un FeatureCollection complet
    $geojson = [
        'type' => 'FeatureCollection',
        'features' => [[
            'type' => 'Feature',
            'properties' => [
                'id' => $relationId,
                'name' => $regionName,
                'relationId' => $relationId
            ],
            'geometry' => json_decode($geometry, true)
        ]]
    ];

    $geojsonStr = json_encode($geojson, JSON_UNESCAPED_UNICODE);
    echo "  Taille GeoJSON: " . strlen($geojsonStr) . " bytes\n";

    // Simplifier
    echo "  Simplification...\n";
    $simplified = simplifyGeoJSON($geojsonStr, 0.008);
    echo "  Taille simplifiée: " . strlen($simplified) . " bytes\n";

    // Mettre à jour t_regions
    $stmt = $pdo->prepare("UPDATE t_regions SET geojson = :geojson, geojson_simple = :simple, relation_osm = :rel WHERE nom_region = :nom");
    $stmt->execute([
        'geojson' => $geojsonStr,
        'simple' => $simplified,
        'rel' => $relationId,
        'nom' => $regionName
    ]);
    echo "  t_regions mis à jour\n";

    // Aussi mettre à jour la table regions
    $stmt = $pdo->prepare("UPDATE regions SET geojson = :geojson, relation_osm = :rel WHERE nom_region = :nom");
    $stmt->execute([
        'geojson' => $geojsonStr,
        'rel' => $relationId,
        'nom' => $regionName
    ]);
    echo "  regions mis à jour\n";

    echo "  OK!\n\n";
}

echo "=== Terminé ===\n";

// Vérification
$stmt = $pdo->query("SELECT nom_region, LENGTH(geojson_simple) as size FROM t_regions ORDER BY nom_region");
echo "\nTailles des GeoJSON simplifiés:\n";
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "  {$row['nom_region']}: {$row['size']} bytes\n";
}

// ============== Fonctions de simplification ==============

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
