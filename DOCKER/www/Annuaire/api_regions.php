<?php
/**
 * API pour recuperer les regions et departements avec leurs geometries
 * Structure: Region > Departements
 */

header('Content-Type: application/json; charset=utf-8');

try {
    $pdo = new PDO(
        'mysql:host=mysql_db;dbname=annuairesMairesDeFrance;charset=utf8mb4',
        'root',
        'root',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    echo json_encode(['error' => 'Erreur connexion BDD']);
    exit;
}

$action = $_GET['action'] ?? '';

switch ($action) {
    case 'listRegions':
        // Liste toutes les regions avec stats
        $stmt = $pdo->query("
            SELECT
                r.id,
                r.nom_region,
                r.code_region,
                r.relation_osm,
                r.url_openstreetmap,
                r.geojson IS NOT NULL as has_geojson,
                COUNT(d.id) as nb_departements
            FROM regions r
            LEFT JOIN departements d ON d.region = r.nom_region
            GROUP BY r.id
            ORDER BY r.nom_region
        ");
        $regions = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success' => true, 'data' => $regions]);
        break;

    case 'getRegion':
        $regionId = $_GET['id'] ?? '';
        $regionName = $_GET['nom'] ?? '';

        if (empty($regionId) && empty($regionName)) {
            echo json_encode(['error' => 'ID ou nom de region requis']);
            exit;
        }

        $sql = "SELECT * FROM regions WHERE ";
        if (!empty($regionId)) {
            $sql .= "id = :param";
            $param = $regionId;
        } else {
            $sql .= "nom_region = :param";
            $param = $regionName;
        }

        $stmt = $pdo->prepare($sql);
        $stmt->execute(['param' => $param]);
        $region = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($region) {
            // Decoder le geojson si present
            if ($region['geojson']) {
                $region['geojson'] = json_decode($region['geojson']);
            }
            echo json_encode(['success' => true, 'data' => $region]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Region non trouvee']);
        }
        break;

    case 'getDepartementsByRegion':
        $regionName = $_GET['region'] ?? '';

        if (empty($regionName)) {
            echo json_encode(['error' => 'Nom de region requis']);
            exit;
        }

        $stmt = $pdo->prepare("
            SELECT
                d.id,
                d.numero_departement,
                d.nom_departement,
                d.region,
                d.relation_osm,
                d.url_openstreetmap,
                d.geojson IS NOT NULL as has_geojson
            FROM departements d
            WHERE d.region = :region
            ORDER BY d.numero_departement
        ");
        $stmt->execute(['region' => $regionName]);
        $departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'data' => $departements]);
        break;

    case 'getDepartement':
        $numeroDept = $_GET['numero'] ?? '';

        if (empty($numeroDept)) {
            echo json_encode(['error' => 'Numero de departement requis']);
            exit;
        }

        $stmt = $pdo->prepare("SELECT * FROM departements WHERE numero_departement = :numero");
        $stmt->execute(['numero' => $numeroDept]);
        $dept = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($dept) {
            if ($dept['geojson']) {
                $dept['geojson'] = json_decode($dept['geojson']);
            }
            echo json_encode(['success' => true, 'data' => $dept]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Departement non trouve']);
        }
        break;

    case 'getRegionDetail':
        // Detail complet d'une region avec ses departements
        $regionName = $_GET['region'] ?? '';

        if (empty($regionName)) {
            echo json_encode(['error' => 'Nom de region requis']);
            exit;
        }

        // Info region
        $stmt = $pdo->prepare("SELECT * FROM regions WHERE nom_region = :region");
        $stmt->execute(['region' => $regionName]);
        $region = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$region) {
            echo json_encode(['success' => false, 'error' => 'Region non trouvee']);
            exit;
        }

        // Departements de la region
        $stmt = $pdo->prepare("
            SELECT
                d.numero_departement,
                d.nom_departement,
                d.relation_osm,
                d.url_openstreetmap,
                d.geojson
            FROM departements d
            WHERE d.region = :region
            ORDER BY d.numero_departement
        ");
        $stmt->execute(['region' => $regionName]);
        $departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Construire le GeoJSON combine si les departements ont des geojson
        $features = [];
        foreach ($departements as &$dept) {
            if ($dept['geojson']) {
                $geoData = json_decode($dept['geojson'], true);
                if ($geoData) {
                    if ($geoData['type'] === 'FeatureCollection' && isset($geoData['features'])) {
                        foreach ($geoData['features'] as $feature) {
                            $feature['properties']['numero_departement'] = $dept['numero_departement'];
                            $feature['properties']['nom_departement'] = $dept['nom_departement'];
                            $features[] = $feature;
                        }
                    } elseif ($geoData['type'] === 'Feature') {
                        $geoData['properties']['numero_departement'] = $dept['numero_departement'];
                        $geoData['properties']['nom_departement'] = $dept['nom_departement'];
                        $features[] = $geoData;
                    }
                }
                unset($dept['geojson']); // Ne pas renvoyer le geojson brut
            }
        }

        $result = [
            'region' => $region,
            'departements' => $departements,
            'relation_ids' => array_filter(array_column($departements, 'relation_osm'))
        ];

        if (!empty($features)) {
            $result['geojson'] = [
                'type' => 'FeatureCollection',
                'features' => $features
            ];
        }

        // Decoder le geojson de la region si present
        if ($region['geojson']) {
            $result['region']['geojson'] = json_decode($region['geojson']);
        }

        echo json_encode($result);
        break;

    case 'getAllRegionsGeoJSON':
        // Retourne le GeoJSON de toutes les regions
        $stmt = $pdo->query("
            SELECT nom_region, code_region, relation_osm, geojson
            FROM regions
            WHERE geojson IS NOT NULL
        ");
        $regions = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $features = [];
        foreach ($regions as $region) {
            $geoData = json_decode($region['geojson'], true);
            if ($geoData && isset($geoData['features'])) {
                foreach ($geoData['features'] as $feature) {
                    $feature['properties']['nom_region'] = $region['nom_region'];
                    $feature['properties']['code_region'] = $region['code_region'];
                    $features[] = $feature;
                }
            }
        }

        echo json_encode([
            'type' => 'FeatureCollection',
            'features' => $features
        ]);
        break;

    case 'getAllDepartementsGeoJSON':
        // Retourne le GeoJSON de tous les departements
        $stmt = $pdo->query("
            SELECT numero_departement, nom_departement, region, geojson
            FROM departements
            WHERE geojson IS NOT NULL
        ");
        $depts = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $features = [];
        foreach ($depts as $dept) {
            $geoData = json_decode($dept['geojson'], true);
            if ($geoData) {
                if ($geoData['type'] === 'FeatureCollection' && isset($geoData['features'])) {
                    foreach ($geoData['features'] as $feature) {
                        $feature['properties']['numero_departement'] = $dept['numero_departement'];
                        $feature['properties']['nom_departement'] = $dept['nom_departement'];
                        $feature['properties']['region'] = $dept['region'];
                        $features[] = $feature;
                    }
                } elseif ($geoData['type'] === 'Feature') {
                    $geoData['properties']['numero_departement'] = $dept['numero_departement'];
                    $geoData['properties']['nom_departement'] = $dept['nom_departement'];
                    $geoData['properties']['region'] = $dept['region'];
                    $features[] = $geoData;
                }
            }
        }

        echo json_encode([
            'type' => 'FeatureCollection',
            'features' => $features
        ]);
        break;

    case 'getDepartementsGeoJSON':
        // Retourne le GeoJSON des départements d'une région
        $regionName = $_GET['region'] ?? '';

        if (empty($regionName)) {
            echo json_encode(['error' => 'Nom de region requis']);
            exit;
        }

        $stmt = $pdo->prepare("
            SELECT numero_departement, nom_departement, geojson
            FROM departements
            WHERE region = :region AND geojson IS NOT NULL
            ORDER BY numero_departement
        ");
        $stmt->execute(['region' => $regionName]);
        $depts = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $features = [];
        foreach ($depts as $dept) {
            $geoData = json_decode($dept['geojson'], true);
            if ($geoData) {
                // Gérer les deux formats: Feature ou FeatureCollection
                if ($geoData['type'] === 'FeatureCollection' && isset($geoData['features'])) {
                    foreach ($geoData['features'] as $feature) {
                        $feature['properties']['numero_departement'] = $dept['numero_departement'];
                        $feature['properties']['nom_departement'] = $dept['nom_departement'];
                        $features[] = $feature;
                    }
                } elseif ($geoData['type'] === 'Feature') {
                    // C'est directement une Feature
                    $geoData['properties']['numero_departement'] = $dept['numero_departement'];
                    $geoData['properties']['nom_departement'] = $dept['nom_departement'];
                    $features[] = $geoData;
                }
            }
        }

        echo json_encode([
            'success' => true,
            'geojson' => [
                'type' => 'FeatureCollection',
                'features' => $features
            ]
        ]);
        break;

    case 'getStats':
        // Statistiques par region
        $stmt = $pdo->query("
            SELECT
                r.nom_region,
                r.code_region,
                COUNT(DISTINCT d.numero_departement) as nb_departements,
                COUNT(DISTINCT m.codeCommune) as nb_communes,
                SUM(m.nbHabitants) as population
            FROM regions r
            LEFT JOIN departements d ON d.region = r.nom_region
            LEFT JOIN t_mairies m ON m.codeDept = d.numero_departement
            GROUP BY r.id
            ORDER BY r.nom_region
        ");
        $stats = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success' => true, 'data' => $stats]);
        break;

    case 'getFullHierarchy':
        // Hierarchie complete: Regions > Departements > Circonscriptions
        $regionName = $_GET['region'] ?? '';

        // Recuperer la region
        $stmt = $pdo->prepare("SELECT * FROM regions WHERE nom_region = :region");
        $stmt->execute(['region' => $regionName]);
        $region = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$region) {
            echo json_encode(['success' => false, 'error' => 'Region non trouvee']);
            exit;
        }

        // Departements de la region avec leurs GeoJSON
        $stmt = $pdo->prepare("
            SELECT
                d.numero_departement,
                d.nom_departement,
                d.relation_osm,
                d.geojson
            FROM departements d
            WHERE d.region = :region
            ORDER BY d.numero_departement
        ");
        $stmt->execute(['region' => $regionName]);
        $departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Pour chaque departement, recuperer les circonscriptions
        $hierarchy = [];
        $allFeatures = [];

        foreach ($departements as $dept) {
            $deptData = [
                'numero' => $dept['numero_departement'],
                'nom' => $dept['nom_departement'],
                'relation_osm' => $dept['relation_osm'],
                'circonscriptions' => []
            ];

            // Ajouter les features GeoJSON du departement
            if ($dept['geojson']) {
                $geoData = json_decode($dept['geojson'], true);
                if ($geoData) {
                    if ($geoData['type'] === 'FeatureCollection' && isset($geoData['features'])) {
                        foreach ($geoData['features'] as $feature) {
                            $feature['properties']['numero_departement'] = $dept['numero_departement'];
                            $feature['properties']['nom_departement'] = $dept['nom_departement'];
                            $feature['properties']['type'] = 'departement';
                            $allFeatures[] = $feature;
                        }
                    } elseif ($geoData['type'] === 'Feature') {
                        $geoData['properties']['numero_departement'] = $dept['numero_departement'];
                        $geoData['properties']['nom_departement'] = $dept['nom_departement'];
                        $geoData['properties']['type'] = 'departement';
                        $allFeatures[] = $geoData;
                    }
                }
            }

            // Recuperer les circonscriptions du departement depuis circonscriptions_Cantons
            $stmtCirco = $pdo->prepare("
                SELECT DISTINCT
                    cc.circonscription
                FROM circonscriptions_Cantons cc
                WHERE cc.numero_departement = :dept
                ORDER BY cc.circonscription
            ");
            $stmtCirco->execute(['dept' => $dept['numero_departement']]);
            $circos = $stmtCirco->fetchAll(PDO::FETCH_ASSOC);

            foreach ($circos as $circo) {
                $deptData['circonscriptions'][] = [
                    'nom' => $circo['circonscription']
                ];
            }

            $hierarchy[] = $deptData;
        }

        $result = [
            'success' => true,
            'region' => [
                'nom' => $region['nom_region'],
                'code' => $region['code_region'],
                'relation_osm' => $region['relation_osm']
            ],
            'departements' => $hierarchy
        ];

        // Ajouter le GeoJSON combine
        if (!empty($allFeatures)) {
            $result['geojson'] = [
                'type' => 'FeatureCollection',
                'features' => $allFeatures
            ];
        }

        echo json_encode($result);
        break;

    default:
        echo json_encode(['error' => 'Action inconnue']);
}
