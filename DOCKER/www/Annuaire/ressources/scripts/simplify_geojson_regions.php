<?php
/**
 * Script pour simplifier les GeoJSON des régions
 * Utilise l'algorithme de Douglas-Peucker pour réduire le nombre de points
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

// Algorithme de Douglas-Peucker pour simplifier une ligne
function douglasPeucker($points, $tolerance) {
    if (count($points) < 3) {
        return $points;
    }

    // Trouver le point le plus éloigné de la ligne entre le premier et le dernier
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

    // Si la distance max est supérieure à la tolérance, simplifier récursivement
    if ($dmax > $tolerance) {
        $results1 = douglasPeucker(array_slice($points, 0, $index + 1), $tolerance);
        $results2 = douglasPeucker(array_slice($points, $index), $tolerance);

        // Combiner les résultats (enlever le point dupliqué)
        array_pop($results1);
        return array_merge($results1, $results2);
    } else {
        // Garder seulement les points de début et de fin
        return [$points[0], $points[$end]];
    }
}

// Distance perpendiculaire d'un point à une ligne
function perpendicularDistance($point, $lineStart, $lineEnd) {
    $x = $point[0];
    $y = $point[1];
    $x1 = $lineStart[0];
    $y1 = $lineStart[1];
    $x2 = $lineEnd[0];
    $y2 = $lineEnd[1];

    $A = $x - $x1;
    $B = $y - $y1;
    $C = $x2 - $x1;
    $D = $y2 - $y1;

    $dot = $A * $C + $B * $D;
    $lenSq = $C * $C + $D * $D;

    if ($lenSq == 0) {
        return sqrt($A * $A + $B * $B);
    }

    $param = $dot / $lenSq;

    if ($param < 0) {
        $xx = $x1;
        $yy = $y1;
    } else if ($param > 1) {
        $xx = $x2;
        $yy = $y2;
    } else {
        $xx = $x1 + $param * $C;
        $yy = $y1 + $param * $D;
    }

    $dx = $x - $xx;
    $dy = $y - $yy;

    return sqrt($dx * $dx + $dy * $dy);
}

// Simplifier les coordonnées d'un polygone
function simplifyCoordinates($coords, $tolerance) {
    $simplified = [];
    foreach ($coords as $ring) {
        $simplifiedRing = douglasPeucker($ring, $tolerance);
        // S'assurer que le polygone est fermé
        if (count($simplifiedRing) >= 3) {
            if ($simplifiedRing[0] !== $simplifiedRing[count($simplifiedRing) - 1]) {
                $simplifiedRing[] = $simplifiedRing[0];
            }
            $simplified[] = $simplifiedRing;
        }
    }
    return $simplified;
}

// Simplifier une géométrie
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

// Simplifier un GeoJSON complet
function simplifyGeoJSON($geojsonStr, $tolerance = 0.01) {
    $geojson = json_decode($geojsonStr, true);
    if (!$geojson) {
        return null;
    }

    if (isset($geojson['features'])) {
        foreach ($geojson['features'] as &$feature) {
            if (isset($feature['geometry'])) {
                $feature['geometry'] = simplifyGeometry($feature['geometry'], $tolerance);
            }
        }
    } elseif (isset($geojson['geometry'])) {
        $geojson['geometry'] = simplifyGeometry($geojson['geometry'], $tolerance);
    }

    return json_encode($geojson, JSON_UNESCAPED_UNICODE);
}

echo "=== Simplification des GeoJSON régions ===\n";

// Récupérer toutes les régions avec GeoJSON
$stmt = $pdo->query("SELECT id, nom_region, LENGTH(geojson) as size FROM t_regions WHERE geojson IS NOT NULL");
$regions = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Régions à traiter: " . count($regions) . "\n\n";

// Tolérance pour la simplification (0.01 = ~1km à cette latitude)
$tolerance = 0.008;

$updateStmt = $pdo->prepare("UPDATE t_regions SET geojson_simple = :geojson WHERE id = :id");

$totalOriginal = 0;
$totalSimplified = 0;

foreach ($regions as $region) {
    echo "Traitement: {$region['nom_region']} ({$region['size']} bytes)... ";

    // Récupérer le GeoJSON complet
    $stmt = $pdo->prepare("SELECT geojson FROM t_regions WHERE id = :id");
    $stmt->execute(['id' => $region['id']]);
    $geojsonStr = $stmt->fetchColumn();

    if (!$geojsonStr) {
        echo "SKIP (pas de données)\n";
        continue;
    }

    $totalOriginal += strlen($geojsonStr);

    // Simplifier
    $simplified = simplifyGeoJSON($geojsonStr, $tolerance);

    if ($simplified) {
        $newSize = strlen($simplified);
        $totalSimplified += $newSize;
        $reduction = round((1 - $newSize / $region['size']) * 100, 1);

        // Mettre à jour
        $updateStmt->execute([
            'geojson' => $simplified,
            'id' => $region['id']
        ]);

        echo "OK ({$newSize} bytes, -{$reduction}%)\n";
    } else {
        echo "ERREUR\n";
    }
}

echo "\n=== Résumé ===\n";
echo "Taille originale totale: " . number_format($totalOriginal) . " bytes\n";
echo "Taille simplifiée totale: " . number_format($totalSimplified) . " bytes\n";
echo "Réduction: " . round((1 - $totalSimplified / $totalOriginal) * 100, 1) . "%\n";

// Vérification
$stmt = $pdo->query("SELECT nom_region, LENGTH(geojson) as original, LENGTH(geojson_simple) as simplified FROM t_regions WHERE geojson_simple IS NOT NULL");
echo "\n=== Vérification ===\n";
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "{$row['nom_region']}: {$row['original']} -> {$row['simplified']} bytes\n";
}
