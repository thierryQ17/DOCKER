<?php
/**
 * API pour récupérer les circonscriptions, cantons et communes d'un département
 * Structure: Circonscription > Canton > Communes
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
$codeDept = $_GET['dept'] ?? '';

switch ($action) {
    case 'detail':
        if (empty($codeDept)) {
            echo json_encode(['error' => 'Code département requis']);
            exit;
        }

        $result = [
            'circonscriptions' => [],
            'osm_urls' => [],
            'relation_ids' => [],
            'region' => null,
            'departement' => null
        ];

        // Récupérer les infos du département et de sa région
        $stmt = $pdo->prepare("
            SELECT
                d.numero_departement,
                d.nom_departement,
                d.region as region_nom,
                r.code_region,
                r.nom_region
            FROM departements d
            LEFT JOIN regions r ON d.region = r.nom_region
            WHERE d.numero_departement = :dept
            LIMIT 1
        ");
        $stmt->execute(['dept' => $codeDept]);
        $deptInfo = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($deptInfo) {
            $result['region'] = [
                'code' => $deptInfo['code_region'],
                'nom' => $deptInfo['nom_region']
            ];
            $result['departement'] = [
                'numero' => $deptInfo['numero_departement'],
                'nom' => $deptInfo['nom_departement']
            ];
        }

        // Récupérer les URLs OSM et GeoJSON depuis t_circonscriptions
        $stmt = $pdo->prepare("
            SELECT relation_osm, url_openstreetmap, geojson
            FROM t_circonscriptions
            WHERE code_departement = :dept
        ");
        $stmt->execute(['dept' => $codeDept]);
        $osmData = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($osmData && $osmData['url_openstreetmap']) {
            $result['osm_urls'] = explode(',', $osmData['url_openstreetmap']);
        }
        if ($osmData && $osmData['relation_osm']) {
            $result['relation_ids'] = explode(',', $osmData['relation_osm']);
        }
        // Retourner le GeoJSON stocké (déjà décodé en objet)
        if ($osmData && $osmData['geojson']) {
            $result['geojson'] = json_decode($osmData['geojson']);
        }

        // Récupérer les circonscriptions et cantons
        $stmt = $pdo->prepare("
            SELECT DISTINCT circonscription, canton
            FROM circonscriptions_Cantons
            WHERE numero_departement = :dept
            ORDER BY circonscription, canton
        ");
        $stmt->execute(['dept' => $codeDept]);
        $circosCantons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Récupérer les communes avec leurs cantons
        $stmt = $pdo->prepare("
            SELECT nomCommune, nomCanton
            FROM t_mairies
            WHERE codeDept = :dept
            ORDER BY nomCanton, nomCommune
        ");
        $stmt->execute(['dept' => $codeDept]);
        $communes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Organiser communes par canton
        $communesByCanton = [];
        foreach ($communes as $commune) {
            $canton = $commune['nomCanton'] ?: 'Sans canton';
            if (!isset($communesByCanton[$canton])) {
                $communesByCanton[$canton] = [];
            }
            $communesByCanton[$canton][] = $commune['nomCommune'];
        }

        // Organiser par circonscription > canton > communes
        foreach ($circosCantons as $row) {
            $circo = $row['circonscription'];
            $canton = $row['canton'];

            if (!isset($result['circonscriptions'][$circo])) {
                $result['circonscriptions'][$circo] = [];
            }

            // Ajouter le canton avec ses communes
            $communesDuCanton = $communesByCanton[$canton] ?? [];
            $result['circonscriptions'][$circo][$canton] = $communesDuCanton;
        }

        echo json_encode($result);
        break;

    case 'getCantonsGeoJSON':
        $codeDept = $_GET['dept'] ?? '';

        if (empty($codeDept)) {
            echo json_encode(['error' => 'Code département requis']);
            exit;
        }

        // Récupérer les cantons du département avec leurs GeoJSON
        // Utilise geojson_osm (plus précis) si disponible, sinon geojson
        $stmt = $pdo->prepare("
            SELECT DISTINCT canton_code, canton_nom, circonscription,
                   COALESCE(geojson_osm, geojson) as geojson
            FROM t_cantons
            WHERE departement_numero = :dept AND (geojson_osm IS NOT NULL OR geojson IS NOT NULL)
            ORDER BY canton_code
        ");
        $stmt->execute(['dept' => $codeDept]);
        $cantons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $features = [];
        foreach ($cantons as $canton) {
            $geoData = json_decode($canton['geojson'], true);
            if ($geoData) {
                if ($geoData['type'] === 'FeatureCollection' && isset($geoData['features'])) {
                    foreach ($geoData['features'] as $feature) {
                        $feature['properties']['canton_code'] = $canton['canton_code'];
                        $feature['properties']['canton_nom'] = $canton['canton_nom'];
                        $feature['properties']['circonscription'] = $canton['circonscription'];
                        $features[] = $feature;
                    }
                } elseif ($geoData['type'] === 'Feature') {
                    $geoData['properties']['canton_code'] = $canton['canton_code'];
                    $geoData['properties']['canton_nom'] = $canton['canton_nom'];
                    $geoData['properties']['circonscription'] = $canton['circonscription'];
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

    case 'getMaireByCommune':
        $commune = $_GET['commune'] ?? '';
        $dept = $_GET['dept'] ?? '';

        if (empty($commune)) {
            echo json_encode(['error' => 'Nom de commune requis']);
            exit;
        }

        // Rechercher la commune et son maire
        $sql = "
            SELECT
                m.nomCommune,
                m.codeCommune,
                m.codePostal,
                m.telephone,
                m.email,
                m.siteInternet,
                m.nbHabitants,
                m.adresseMairie,
                mr.nomMaire,
                mr.prenomMaire,
                mr.nomPrenom,
                mr.dateDebutMandat
            FROM t_mairies m
            LEFT JOIN t_maires mr ON m.codeCommune = mr.codeCommune
            WHERE m.nomCommune = :commune
        ";

        $params = ['commune' => $commune];

        if (!empty($dept)) {
            $sql .= " AND m.codeDept = :dept";
            $params['dept'] = $dept;
        }

        $sql .= " LIMIT 1";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            echo json_encode(['success' => true, 'data' => $result]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Commune non trouvée']);
        }
        break;

    case 'getHierarchy':
        // Retourne toutes les régions avec leurs départements
        $stmt = $pdo->query("
            SELECT
                r.code_region,
                r.nom_region,
                d.numero_departement,
                d.nom_departement
            FROM regions r
            LEFT JOIN departements d ON d.region = r.nom_region
            ORDER BY r.nom_region, d.numero_departement
        ");
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Organiser par région > départements
        $hierarchy = [];
        foreach ($rows as $row) {
            $regionCode = $row['code_region'];
            if (!isset($hierarchy[$regionCode])) {
                $hierarchy[$regionCode] = [
                    'code' => $regionCode,
                    'nom' => $row['nom_region'],
                    'departements' => []
                ];
            }
            if ($row['numero_departement']) {
                $hierarchy[$regionCode]['departements'][] = [
                    'numero' => $row['numero_departement'],
                    'nom' => $row['nom_departement']
                ];
            }
        }

        echo json_encode([
            'success' => true,
            'regions' => array_values($hierarchy)
        ]);
        break;

    case 'getAllRegionsGeoJSON':
        // Retourne le GeoJSON simplifié de toutes les régions depuis t_regions
        // Utilise geojson_simple pour des performances optimales (~133 KB au lieu de ~22 MB)
        $stmt = $pdo->query("
            SELECT code_region, nom_region, geojson_simple as geojson
            FROM t_regions
            WHERE geojson_simple IS NOT NULL
            ORDER BY nom_region
        ");

        echo '{"type":"FeatureCollection","features":[';
        $first = true;

        while ($region = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $geojson = $region['geojson'];
            if (!$geojson) continue;

            // Extraire les features du GeoJSON
            // Format attendu: {"type":"FeatureCollection","features":[...]}
            if (preg_match('/"features"\s*:\s*\[(.*)\]\s*\}$/s', $geojson, $matches)) {
                $featuresContent = $matches[1];
                if (trim($featuresContent)) {
                    // Ajouter les propriétés nom_region et code_region à chaque feature
                    $featuresContent = preg_replace(
                        '/"properties"\s*:\s*\{/',
                        '"properties":{"nom_region":"' . addslashes($region['nom_region']) . '","code_region":"' . $region['code_region'] . '",',
                        $featuresContent
                    );

                    if (!$first) echo ',';
                    echo $featuresContent;
                    $first = false;
                }
            }
        }

        echo ']}';
        break;

    default:
        echo json_encode(['error' => 'Action inconnue']);
}
