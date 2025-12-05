<?php
/**
 * Page d'affichage des cartes de circonscriptions par region
 * Donnees chargees depuis la table t_circonscriptions
 */

// Connexion BDD
try {
    $pdo = new PDO(
        'mysql:host=mysql_db;dbname=annuairesMairesDeFrance;charset=utf8mb4',
        'root',
        'root',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    die("Erreur de connexion BDD");
}

// Charger les donnees depuis la BDD
$stmt = $pdo->query("SELECT code_departement, nom_departement, region, image_path, url_source FROM t_circonscriptions ORDER BY region, code_departement");
$circonscriptions = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Organiser par region
$regions = [];
$departementsData = [];
foreach ($circonscriptions as $row) {
    $region = $row['region'];
    $code = $row['code_departement'];

    if (!isset($regions[$region])) {
        $regions[$region] = [];
    }
    $regions[$region][$code] = [
        'nom' => $row['nom_departement'],
        'image' => $row['image_path'],
        'url' => $row['url_source']
    ];

    $departementsData[] = [
        'code' => $code,
        'nom' => $row['nom_departement'],
        'region' => $region,
        'image' => $row['image_path'],
        'url' => $row['url_source']
    ];
}

// Diviser les regions en 2 colonnes
$regionsArray = array_keys($regions);
$mid = ceil(count($regionsArray) / 2);
$regionsCol1 = array_slice($regionsArray, 0, $mid);
$regionsCol2 = array_slice($regionsArray, $mid);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cartes des Circonscriptions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        * { box-sizing: border-box; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .page-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border-radius: 12px;
            padding: 12px 20px;
            margin: 10px 15px;
            color: white;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
        }

        .page-header h1 {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-header h1 i { font-size: 22px; }

        .regions-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            padding: 0 15px 15px;
        }

        @media (max-width: 992px) {
            .regions-container {
                grid-template-columns: 1fr;
            }
        }

        .region-column {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .region-block {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .region-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 10px 15px;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            user-select: none;
            transition: opacity 0.2s;
        }

        .region-header:hover {
            opacity: 0.9;
        }

        .region-header .region-title {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .region-header .toggle-icon {
            transition: transform 0.3s ease;
        }

        .region-header.collapsed .toggle-icon {
            transform: rotate(-90deg);
        }

        .region-header .dept-count {
            background: rgba(255,255,255,0.25);
            padding: 2px 10px;
            border-radius: 10px;
            font-size: 12px;
        }

        .region-header .btn-region-map {
            background: rgba(255,255,255,0.25);
            border: none;
            color: white;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            margin-left: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: background 0.2s;
        }

        .region-header .btn-region-map:hover {
            background: rgba(255,255,255,0.4);
        }

        .region-content {
            padding: 10px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 10px;
            overflow: hidden;
            transition: max-height 0.3s ease, padding 0.3s ease, opacity 0.3s ease;
        }

        .region-content.collapsed {
            max-height: 0 !important;
            padding-top: 0;
            padding-bottom: 0;
            opacity: 0;
        }

        .dept-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 8px;
            text-align: center;
            transition: all 0.2s ease;
            border: 1px solid #e9ecef;
        }

        .dept-card:hover {
            background: #e9ecef;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .dept-card img {
            width: 100%;
            height: 70px;
            object-fit: contain;
            border-radius: 4px;
            background: white;
            cursor: pointer;
        }

        .dept-card .dept-code {
            font-weight: 700;
            color: #17a2b8;
            font-size: 14px;
            margin-top: 5px;
        }

        .dept-card .dept-name {
            font-size: 11px;
            color: #6c757d;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dept-card .dept-link {
            display: inline-block;
            margin-top: 5px;
            font-size: 11px;
            color: #17a2b8;
            text-decoration: none;
        }

        .dept-card .dept-link:hover {
            text-decoration: underline;
        }

        /* Modal */
        .modal-backdrop.show { opacity: 0.7; }

        .modal-content {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            border: none;
            padding: 12px 20px;
        }

        .modal-header .btn-close {
            filter: brightness(0) invert(1);
        }

        .modal-body {
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
        }

        .modal-body img {
            max-width: 100%;
            max-height: 70vh;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .modal-footer {
            border: none;
            padding: 10px 20px;
            background: #f8f9fa;
            justify-content: center;
        }

        .btn-source {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border: none;
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            font-size: 13px;
            text-decoration: none;
        }

        .btn-source:hover {
            color: white;
            opacity: 0.9;
        }

        /* Modal avec panneau lateral */
        .modal-xl-custom .modal-dialog {
            max-width: 95%;
            width: 1200px;
        }

        .modal-body-with-sidebar {
            display: flex;
            padding: 0 !important;
            background: #f8f9fa;
            min-height: 70vh;
        }

        .modal-sidebar {
            width: 320px;
            min-width: 320px;
            background: white;
            border-right: 1px solid #e9ecef;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            max-height: 70vh;
        }

        /* Enfants d'arbre (cantons et communes) */
        .tree-children {
            display: none;
        }

        .tree-children.expanded {
            display: block;
        }

        /* Scroll uniquement pour les communes sous les cantons (10 lignes max) */
        .tree-canton > .tree-children {
            max-height: 240px;
            overflow-y: auto;
        }

        /* Arbre hierarchique */
        .tree-root {
            padding: 10px 0;
        }

        .tree-node {
            text-align: left;
        }

        .tree-header {
            display: flex;
            align-items: center;
            padding: 8px 12px;
            cursor: pointer;
            transition: background 0.2s;
            gap: 8px;
            user-select: none;
        }

        .tree-header:hover {
            background: #f0f0f0;
        }

        .tree-toggle {
            width: 16px;
            height: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #17a2b8;
            transition: transform 0.2s;
            font-size: 10px;
        }

        .tree-toggle.collapsed {
            transform: rotate(-90deg);
        }

        .tree-icon {
            font-size: 14px;
        }

        .tree-label {
            flex: 1;
            font-size: 13px;
            text-align: left;
        }

        .tree-count {
            background: #e9ecef;
            color: #495057;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 500;
        }

        /* Bouton FRANCE independant (style region) */
        .france-button {
            display: flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 700;
            margin: 4px 8px 8px 8px;
            padding: 10px 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .france-button:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
        }

        .france-button.active {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2);
        }

        .france-button i {
            font-size: 16px;
        }

        .france-flag-img {
            width: 24px;
            height: auto;
            border-radius: 2px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.2);
        }

        /* Bouton FRANCE en haut de page */
        .france-top-button {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 700;
            font-size: 16px;
            padding: 12px 24px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
            margin: 0 15px 15px 15px;
        }

        .france-top-button:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(23, 162, 184, 0.4);
        }

        .france-top-button img {
            width: 32px;
            height: auto;
            border-radius: 3px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* Niveau 0 - Region */
        .tree-region > .tree-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 700;
            margin: 4px 8px;
            border-radius: 8px;
            padding: 10px 12px;
        }

        .tree-region > .tree-header:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
        }

        .tree-region > .tree-header .tree-toggle {
            color: white;
        }

        .tree-region > .tree-header .tree-icon {
            font-size: 16px;
        }

        /* Niveau 0.5 - Departement */
        .tree-dept > .tree-header {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
            color: white;
            font-weight: 600;
            margin: 4px 8px 4px 16px;
            border-radius: 6px;
            padding: 8px 10px;
        }

        .tree-dept > .tree-header:hover {
            background: linear-gradient(135deg, #218838 0%, #1e7e34 100%);
        }

        .tree-dept > .tree-header .tree-toggle {
            color: white;
        }

        .tree-dept > .tree-header .tree-count {
            background: rgba(255,255,255,0.25);
            color: white;
        }

        .tree-dept > .tree-header .tree-icon {
            font-size: 14px;
        }

        /* Niveau 1 - Circonscription */
        .tree-circo > .tree-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 600;
            margin: 2px 8px 2px 24px;
            border-radius: 6px;
        }

        .tree-circo > .tree-header:hover {
            background: linear-gradient(135deg, #138496 0%, #0d6d7f 100%);
        }

        .tree-circo > .tree-header .tree-toggle {
            color: white;
        }

        .tree-circo > .tree-header .tree-count {
            background: rgba(255,255,255,0.25);
            color: white;
        }

        /* Icones OSM dans les circonscriptions */
        .tree-circo-links {
            display: flex;
            gap: 6px;
            margin-left: auto;
        }

        .tree-circo-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            background: rgba(255,255,255,0.25);
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 12px;
            transition: background 0.2s;
        }

        .tree-circo-links a:hover {
            background: rgba(255,255,255,0.45);
            color: white;
        }

        .tree-circo-links a[title*="OpenStreetMap"] {
            background: rgba(126, 188, 111, 0.7);
        }

        .tree-circo-links a[title*="OpenStreetMap"]:hover {
            background: rgba(126, 188, 111, 1);
        }

        .tree-circo-links a[title*="Overpass"] {
            background: rgba(255, 193, 7, 0.7);
        }

        .tree-circo-links a[title*="Overpass"]:hover {
            background: rgba(255, 193, 7, 1);
        }

        /* Niveau 2 - Canton */
        .tree-canton > .tree-header {
            background: #e0f7fa;
            color: #0097a7;
            font-weight: 500;
            margin-left: 32px;
            margin-right: 8px;
            margin-top: 2px;
            margin-bottom: 2px;
            border-radius: 4px;
            border-left: 3px solid #17a2b8;
        }

        .tree-canton > .tree-header:hover {
            background: #b2ebf2;
        }

        .tree-canton > .tree-header .tree-toggle {
            color: #0097a7;
        }

        .tree-canton > .tree-header .tree-count {
            background: rgba(23, 162, 184, 0.2);
            color: #17a2b8;
        }

        /* Niveau 3 - Commune */
        .tree-commune {
            padding: 4px 12px 4px 60px;
            font-size: 12px;
            color: #333;
            text-align: left;
            border-bottom: 1px solid #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .tree-commune span {
            flex: 1;
            cursor: pointer;
        }

        .tree-commune:hover {
            background: #e0f7fa;
            color: #006064;
        }

        .tree-commune:last-child {
            border-bottom: none;
        }

        .tree-commune i {
            margin-right: 5px;
            color: #17a2b8;
        }

        .tree-commune.active {
            background: #17a2b8;
            color: white;
        }

        .tree-commune.active i {
            color: white;
        }

        .modal-main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .modal-main-content img {
            max-width: 100%;
            max-height: 60vh;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .modal-main-content iframe {
            width: 100%;
            height: 60vh;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .modal-main-content .map-container {
            display: none;
            width: 100%;
        }

        .modal-main-content .map-container.active {
            display: block;
        }

        .modal-main-content .image-container {
            display: block;
        }

        .modal-main-content .image-container.hidden {
            display: none;
        }

        /* Header cliquable pour retour carte */
        .modal-header.clickable-header {
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .modal-header.clickable-header:hover {
            opacity: 0.9;
        }

        .modal-header .back-hint {
            font-size: 11px;
            opacity: 0.8;
            margin-left: 10px;
            display: none;
        }

        .modal-header .back-hint.visible {
            display: inline;
        }

        /* Bouton plein ecran */
        .btn-fullscreen {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 6px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.2s;
            margin-right: 10px;
        }

        .btn-fullscreen:hover {
            background: rgba(255,255,255,0.35);
        }

        .modal-header-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-osm-link {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            background: rgba(255, 193, 7, 0.7);
            border-radius: 6px;
            color: white;
            text-decoration: none;
            font-size: 16px;
            transition: background 0.2s;
        }

        .btn-osm-link:hover {
            background: rgba(255, 193, 7, 1);
            color: white;
        }

        /* Mode plein ecran */
        .modal-xl-custom.fullscreen .modal-dialog {
            max-width: 100%;
            width: 100%;
            height: 100%;
            margin: 0;
        }

        .modal-xl-custom.fullscreen .modal-content {
            height: 100vh;
            border-radius: 0;
        }

        .modal-xl-custom.fullscreen .modal-body-with-sidebar {
            min-height: calc(100vh - 110px);
            max-height: calc(100vh - 110px);
        }

        .modal-xl-custom.fullscreen .modal-sidebar {
            max-height: calc(100vh - 110px);
        }

        .modal-xl-custom.fullscreen .modal-main-content img {
            max-height: calc(100vh - 150px);
        }

        .modal-xl-custom.fullscreen .modal-main-content iframe {
            height: calc(100vh - 150px);
        }

        .modal-xl-custom.fullscreen .leaflet-inline-container {
            height: calc(100vh - 130px);
            border-radius: 0;
        }

        .sidebar-loading {
            padding: 20px;
            text-align: center;
            color: #6c757d;
        }

        .sidebar-loading i {
            font-size: 24px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Recherche commune dans sidebar */
        .sidebar-search {
            padding: 10px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .sidebar-search-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .sidebar-search-icon {
            position: absolute;
            left: 10px;
            color: #adb5bd;
            font-size: 14px;
            pointer-events: none;
        }

        .sidebar-search input {
            width: 100%;
            padding: 8px 32px 8px 32px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 13px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .sidebar-search input:focus {
            outline: none;
            border-color: #17a2b8;
            box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.2);
        }

        .sidebar-search-clear {
            position: absolute;
            right: 6px;
            background: #6c757d;
            border: none;
            color: white;
            width: 22px;
            height: 22px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 10px;
            transition: background 0.2s;
        }

        .sidebar-search-clear:hover {
            background: #dc3545;
        }

        .sidebar-search-map {
            position: absolute;
            right: 32px;
            background: #7ebc6f;
            border: none;
            color: white;
            width: 22px;
            height: 22px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 11px;
            transition: background 0.2s;
        }

        .sidebar-search-map:hover {
            background: #5a9a4a;
        }

        .sidebar-search-map.active {
            background: #17a2b8;
        }

        .sidebar-search-count {
            margin-top: 6px;
            font-size: 11px;
            color: #6c757d;
            text-align: center;
        }

        .sidebar-search-count.has-filter {
            color: #17a2b8;
            font-weight: 500;
        }

        /* Elements filtres (caches) */
        .tree-commune.filtered-out {
            display: none !important;
        }

        .tree-canton.filtered-out {
            display: none !important;
        }

        .tree-circo.filtered-out {
            display: none !important;
        }

        /* Surlignage des communes trouvees */
        .tree-commune.filter-match {
            background: #ffe082;
            border-left: 3px solid #ff9800;
        }

        .tree-commune.filter-match:hover {
            background: #ffd54f;
        }

        /* =====================================================
           STYLES ARBRE HIERARCHIQUE MODAL REGION
           Region > Departement > Circonscription
           ===================================================== */

        /* Niveau Region (racine) */
        .tree-region-root {
            padding: 10px 0;
        }

        .tree-region > .tree-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 600;
            margin: 0 8px 4px;
            border-radius: 6px;
            padding: 10px 12px;
        }

        .tree-region > .tree-header:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
        }

        .tree-region > .tree-header .tree-toggle {
            color: white;
        }

        .tree-region > .tree-header .tree-count {
            background: rgba(255,255,255,0.25);
            color: white;
        }

        /* Niveau Departement */
        .tree-dept {
            margin-left: 12px;
        }

        .tree-dept > .tree-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 500;
            margin: 2px 8px;
            border-radius: 5px;
            padding: 8px 10px;
        }

        .tree-dept > .tree-header:hover {
            background: linear-gradient(135deg, #138496 0%, #0d6d7f 100%);
        }

        .tree-dept > .tree-header .tree-toggle {
            color: white;
        }

        .tree-dept > .tree-header .tree-count {
            background: rgba(255,255,255,0.25);
            color: white;
        }

        .tree-dept > .tree-header .tree-color-badge {
            width: 14px;
            height: 14px;
            border-radius: 3px;
            margin-right: 6px;
            flex-shrink: 0;
        }

        /* Niveau Circonscription (sous departement) */
        .tree-circo-sub {
            margin-left: 20px;
        }

        .tree-circo-sub > .tree-header {
            background: #e0f7fa;
            color: #0097a7;
            font-weight: 500;
            margin: 2px 8px;
            border-radius: 4px;
            padding: 6px 10px;
            border-left: 3px solid #17a2b8;
        }

        .tree-circo-sub > .tree-header:hover {
            background: #b2ebf2;
        }

        .tree-circo-sub > .tree-header .tree-toggle {
            color: #0097a7;
            width: 14px;
            height: 14px;
        }

        .tree-circo-sub > .tree-header .tree-label {
            font-size: 12px;
        }

        /* Conteneur Leaflet inline (dans la modale principale) */
        .leaflet-inline-container {
            display: none;
            width: 100%;
            height: 60vh;
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .leaflet-inline-container.active {
            display: block;
        }

        #leafletInlineMap {
            width: 100%;
            height: 100%;
        }

        .leaflet-popup-content {
            font-size: 13px;
        }

        /* Labels des régions sur la carte */
        .region-label {
            background: transparent !important;
            border: none !important;
        }

        .region-tag {
            display: inline-block;
            background: rgba(200, 200, 200, 0.8);
            color: #444;
            font-size: 8px;
            font-weight: 500;
            padding: 2px 6px;
            border-radius: 8px;
            white-space: nowrap;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
            text-transform: uppercase;
            letter-spacing: 0.2px;
            transform: translate(-50%, -50%);
        }

        .circo-legend {
            background: white;
            padding: 10px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            font-size: 12px;
        }

        .circo-legend h4 {
            margin: 0 0 8px 0;
            font-size: 13px;
            font-weight: 600;
            color: #17a2b8;
        }

        .circo-legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 4px 0;
        }

        .circo-legend-color {
            width: 20px;
            height: 14px;
            border-radius: 3px;
            border: 1px solid rgba(0,0,0,0.2);
        }

        .leaflet-loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            z-index: 1000;
            text-align: center;
        }

        .leaflet-loading i {
            font-size: 32px;
            color: #17a2b8;
            animation: spin 1s linear infinite;
        }

        .leaflet-loading p {
            margin: 10px 0 0;
            color: #666;
        }

        /* Module de recherche */
        .search-module {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 15px;
            margin: 0 15px 15px;
        }

        .search-module .search-title {
            font-size: 14px;
            font-weight: 600;
            color: #17a2b8;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-module .search-input-wrapper {
            position: relative;
        }

        .search-module input {
            width: 100%;
            padding: 10px 15px;
            padding-left: 40px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .search-module input:focus {
            outline: none;
            border-color: #17a2b8;
            box-shadow: 0 0 0 3px rgba(23, 162, 184, 0.15);
        }

        .search-module .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #adb5bd;
            font-size: 16px;
        }

        .search-module .autocomplete-list {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-height: 250px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            margin-top: 5px;
        }

        .search-module .autocomplete-list.show {
            display: block;
        }

        .search-module .autocomplete-item {
            padding: 10px 15px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-module .autocomplete-item:last-child {
            border-bottom: none;
        }

        .search-module .autocomplete-item:hover {
            background: #f8f9fa;
        }

        .search-module .autocomplete-item .dept-code {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 12px;
            min-width: 35px;
            text-align: center;
        }

        .search-module .autocomplete-item .dept-info {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-module .autocomplete-item .dept-name {
            font-weight: 500;
            color: #333;
        }

        .search-module .autocomplete-item .dept-region {
            font-size: 11px;
            color: #6c757d;
        }

        .search-module .autocomplete-item .dept-region::before {
            content: "—";
            margin-right: 8px;
            color: #ccc;
        }

        .search-module .autocomplete-item-all {
            background: #f8f9fa;
            font-weight: 500;
            color: #17a2b8;
        }

        /* Surbrillance du departement selectionne */
        .dept-card.highlighted {
            border: 2px solid #17a2b8;
            background: #eef0ff;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
            animation: pulse 1s ease-in-out 2;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
    </style>
</head>
<body>
    <div class="page-header">
        <h1><i class="bi bi-map"></i> Cartes des Circonscriptions Legislatives</h1>
    </div>

    <!-- Bouton FRANCE en haut de page -->
    <button class="france-top-button" onclick="openFranceModal()">
        <img src="ressources/images/france-flag.png" alt="France">
        <span>FRANCE</span>
    </button>

    <!-- Module de recherche -->
    <div class="search-module">
        <div class="search-input-wrapper">
            <i class="bi bi-geo-alt search-icon"></i>
            <input type="text"
                   id="searchDept"
                   placeholder="Tapez un code ou nom de departement..."
                   onfocus="showSearchAutocomplete()"
                   oninput="filterSearchAutocomplete()"
                   onblur="setTimeout(() => hideSearchAutocomplete(), 200)">
            <div class="autocomplete-list" id="searchAutocomplete"></div>
        </div>
    </div>

    <div class="regions-container">
        <!-- Colonne 1 -->
        <div class="region-column">
            <?php foreach ($regionsCol1 as $regionName): ?>
            <div class="region-block">
                <div class="region-header collapsed" onclick="toggleRegion(this)">
                    <span class="region-title">
                        <i class="bi bi-chevron-down toggle-icon"></i>
                        <i class="bi bi-geo-alt"></i>
                        <?= htmlspecialchars($regionName) ?>
                    </span>
                    <div class="d-flex align-items-center">
                        <span class="dept-count"><?= count($regions[$regionName]) ?> dep.</span>
                        <button class="btn-region-map" onclick="event.stopPropagation(); openRegionMapModal('<?= htmlspecialchars(addslashes($regionName)) ?>')" title="Voir la carte de la region">
                            <i class="bi bi-map"></i>
                        </button>
                    </div>
                </div>
                <div class="region-content collapsed" data-region="<?= htmlspecialchars($regionName) ?>">
                    <?php foreach ($regions[$regionName] as $code => $dept): ?>
                    <div class="dept-card" data-code="<?= htmlspecialchars($code) ?>">
                        <img src="<?= htmlspecialchars($dept['image']) ?>"
                             alt="<?= htmlspecialchars($dept['nom']) ?>"
                             loading="lazy"
                             onclick="openModal('<?= htmlspecialchars($code) ?>', '<?= htmlspecialchars($dept['nom']) ?>', '<?= htmlspecialchars($dept['image']) ?>', '<?= htmlspecialchars($dept['url']) ?>')">
                        <div class="dept-code"><?= htmlspecialchars($code) ?></div>
                        <div class="dept-name" title="<?= htmlspecialchars($dept['nom']) ?>"><?= htmlspecialchars($dept['nom']) ?></div>
                        <a href="<?= htmlspecialchars($dept['url']) ?>" target="_blank" class="dept-link">
                            <i class="bi bi-box-arrow-up-right"></i> Source
                        </a>
                    </div>
                    <?php endforeach; ?>
                </div>
            </div>
            <?php endforeach; ?>
        </div>

        <!-- Colonne 2 -->
        <div class="region-column">
            <?php foreach ($regionsCol2 as $regionName): ?>
            <div class="region-block">
                <div class="region-header collapsed" onclick="toggleRegion(this)">
                    <span class="region-title">
                        <i class="bi bi-chevron-down toggle-icon"></i>
                        <i class="bi bi-geo-alt"></i>
                        <?= htmlspecialchars($regionName) ?>
                    </span>
                    <div class="d-flex align-items-center">
                        <span class="dept-count"><?= count($regions[$regionName]) ?> dep.</span>
                        <button class="btn-region-map" onclick="event.stopPropagation(); openRegionMapModal('<?= htmlspecialchars(addslashes($regionName)) ?>')" title="Voir la carte de la region">
                            <i class="bi bi-map"></i>
                        </button>
                    </div>
                </div>
                <div class="region-content collapsed" data-region="<?= htmlspecialchars($regionName) ?>">
                    <?php foreach ($regions[$regionName] as $code => $dept): ?>
                    <div class="dept-card" data-code="<?= htmlspecialchars($code) ?>">
                        <img src="<?= htmlspecialchars($dept['image']) ?>"
                             alt="<?= htmlspecialchars($dept['nom']) ?>"
                             loading="lazy"
                             onclick="openModal('<?= htmlspecialchars($code) ?>', '<?= htmlspecialchars($dept['nom']) ?>', '<?= htmlspecialchars($dept['image']) ?>', '<?= htmlspecialchars($dept['url']) ?>')">
                        <div class="dept-code"><?= htmlspecialchars($code) ?></div>
                        <div class="dept-name" title="<?= htmlspecialchars($dept['nom']) ?>"><?= htmlspecialchars($dept['nom']) ?></div>
                        <a href="<?= htmlspecialchars($dept['url']) ?>" target="_blank" class="dept-link">
                            <i class="bi bi-box-arrow-up-right"></i> Source
                        </a>
                    </div>
                    <?php endforeach; ?>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>

    <!-- Modal pour afficher la carte d'une region -->
    <div class="modal fade modal-xl-custom" id="regionMapModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">
                    <h5 class="modal-title" style="flex: 1;">
                        <i class="bi bi-geo-alt-fill me-2"></i>
                        <span id="regionMapTitle">Region</span>
                    </h5>
                    <div class="modal-header-actions" onclick="event.stopPropagation();">
                        <button type="button" class="btn-fullscreen" onclick="toggleRegionMapFullscreen();" title="Plein ecran">
                            <i class="bi bi-arrows-fullscreen" id="regionMapFullscreenIcon"></i>
                        </button>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                </div>
                <div class="modal-body modal-body-with-sidebar">
                    <div class="modal-sidebar" id="regionMapSidebar">
                        <div class="sidebar-info" style="padding: 10px 15px; background: #f8f9fa; border-bottom: 1px solid #e9ecef;">
                            <div id="regionDeptCount" class="info-item" style="font-size: 13px; color: #6c757d;">
                                <i class="bi bi-building"></i>
                                <span>0 departements</span>
                            </div>
                        </div>
                        <div class="tree-root" id="regionHierarchyTree">
                            <!-- Arbre hierarchique: Region > Departements > Circonscriptions -->
                        </div>
                    </div>
                    <div class="modal-main-content" style="position: relative;">
                        <div id="regionLeafletMap" style="width: 100%; height: 70vh; min-height: 500px;"></div>
                        <div class="loading-overlay" id="regionMapLoading" style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.9); display: flex; align-items: center; justify-content: center; z-index: 1000;">
                            <div class="spinner-border" role="status" style="color: #17a2b8;">
                                <span class="visually-hidden">Chargement...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal pour afficher l'image en grand avec panneau lateral -->
    <div class="modal fade modal-xl-custom" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header clickable-header" onclick="returnToLeafletMap()">
                    <h5 class="modal-title" style="flex: 1;">
                        <span id="modalTitle">Circonscriptions</span>
                        <span class="back-hint" id="backHint"><i class="bi bi-arrow-left"></i> Cliquez pour revenir a la carte</span>
                    </h5>
                    <div class="modal-header-actions" onclick="event.stopPropagation();">
                        <button type="button" class="btn-fullscreen" onclick="toggleFullscreen();" title="Plein ecran">
                            <i class="bi bi-arrows-fullscreen" id="fullscreenIcon"></i>
                        </button>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                </div>
                <div class="modal-body modal-body-with-sidebar">
                    <!-- Panneau lateral gauche -->
                    <div class="modal-sidebar" id="modalSidebar">
                        <!-- Champ de recherche commune -->
                        <div class="sidebar-search" id="sidebarSearch" style="display:none;">
                            <div class="sidebar-search-wrapper">
                                <i class="bi bi-search sidebar-search-icon"></i>
                                <input type="text"
                                       id="searchCommune"
                                       placeholder="Filtrer les communes..."
                                       oninput="filterCommuneInTree()"
                                       autocomplete="off">
                                <button type="button" class="sidebar-search-map" id="btnShowMap" onclick="showDeptOnLeaflet()" title="Afficher la carte">
                                    <i class="bi bi-map"></i>
                                </button>
                                <button type="button" class="sidebar-search-clear" id="searchCommuneClear" onclick="resetCommuneFilter()" title="Reinitialiser">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                            </div>
                            <div class="sidebar-search-count" id="searchCommuneCount"></div>
                        </div>
                        <div class="sidebar-loading" id="sidebarLoading">
                            <i class="bi bi-arrow-repeat"></i>
                            <p>Chargement...</p>
                        </div>
                        <div id="sidebarContent"></div>
                    </div>
                    <!-- Contenu principal (carte Leaflet) -->
                    <div class="modal-main-content">
                        <div class="map-container" id="mapContainer">
                            <iframe id="googleMapFrame" src="" allowfullscreen loading="lazy"></iframe>
                        </div>
                        <div class="leaflet-inline-container active" id="leafletInlineContainer">
                            <div id="leafletInlineLoading" class="leaflet-loading">
                                <i class="bi bi-arrow-repeat"></i>
                                <p>Chargement de la carte...</p>
                            </div>
                            <div id="leafletInlineMap"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        let modal;
        let leafletInlineMap = null; // Carte Leaflet dans la modale principale
        let leafletMarker = null; // Marqueur pour la commune selectionnee
        let currentDeptCode = '';
        let currentDeptName = '';
        let currentSourceUrl = '';
        let currentOsmUrls = []; // URLs OpenStreetMap par circonscription
        let currentRelationIds = []; // IDs des relations OSM pour tout le département
        let currentGeoJSON = null; // GeoJSON stocké en base (si disponible)
        let currentCommunesList = []; // Liste des communes du departement avec leur circo/canton

        // Donnees des departements pour la recherche (depuis BDD)
        const departementsData = <?= json_encode($departementsData) ?>;

        document.addEventListener('DOMContentLoaded', function() {
            modal = new bootstrap.Modal(document.getElementById('imageModal'));
        });

        function toggleRegion(header) {
            const content = header.nextElementSibling;
            const isCollapsed = header.classList.contains('collapsed');

            if (isCollapsed) {
                // Ouvrir
                header.classList.remove('collapsed');
                content.classList.remove('collapsed');
                content.style.maxHeight = content.scrollHeight + 'px';
            } else {
                // Fermer
                header.classList.add('collapsed');
                content.classList.add('collapsed');
                content.style.maxHeight = '0';
            }
        }

        function openRegionByName(regionName) {
            const contents = document.querySelectorAll('.region-content[data-region]');
            contents.forEach(content => {
                if (content.dataset.region === regionName) {
                    const header = content.previousElementSibling;
                    if (header.classList.contains('collapsed')) {
                        header.classList.remove('collapsed');
                        content.classList.remove('collapsed');
                        content.style.maxHeight = content.scrollHeight + 'px';
                    }
                }
            });
        }

        // Recherche - Afficher l'autocomplete
        function showSearchAutocomplete() {
            filterSearchAutocomplete();
        }

        // Recherche - Filtrer l'autocomplete
        function filterSearchAutocomplete() {
            const input = document.getElementById('searchDept');
            const listEl = document.getElementById('searchAutocomplete');
            const search = input.value.toLowerCase().trim();

            listEl.innerHTML = '';

            // Option "Tous les departements"
            const allItem = document.createElement('div');
            allItem.className = 'autocomplete-item autocomplete-item-all';
            allItem.innerHTML = '<i class="bi bi-globe"></i> Afficher tous les departements';
            allItem.onclick = function() { selectAllDepts(); };
            listEl.appendChild(allItem);

            // Filtrer les departements
            let filtered = departementsData.filter(d => {
                return d.code.toLowerCase().includes(search) ||
                       d.nom.toLowerCase().includes(search) ||
                       d.region.toLowerCase().includes(search);
            });

            // Limiter a 5 resultats
            filtered = filtered.slice(0, 5);

            filtered.forEach(d => {
                const item = document.createElement('div');
                item.className = 'autocomplete-item';
                item.innerHTML = `
                    <span class="dept-code">${d.code}</span>
                    <div class="dept-info">
                        <div class="dept-name">${d.nom}</div>
                        <div class="dept-region">${d.region}</div>
                    </div>
                `;
                item.onclick = function() { selectDept(d.code, d.nom, d.region, d.image, d.url); };
                listEl.appendChild(item);
            });

            listEl.classList.add('show');
        }

        // Recherche - Cacher l'autocomplete
        function hideSearchAutocomplete() {
            document.getElementById('searchAutocomplete').classList.remove('show');
        }

        // Selectionner tous les departements (ouvrir toutes les regions)
        function selectAllDepts() {
            document.getElementById('searchDept').value = '';
            hideSearchAutocomplete();

            // Enlever toute surbrillance
            document.querySelectorAll('.dept-card.highlighted').forEach(el => {
                el.classList.remove('highlighted');
            });

            // Ouvrir toutes les regions
            document.querySelectorAll('.region-header.collapsed').forEach(header => {
                toggleRegion(header);
            });
        }

        // Selectionner un departement - ouvre directement la modale
        function selectDept(code, nom, region, image, url) {
            const input = document.getElementById('searchDept');
            input.value = code + ' - ' + nom;
            hideSearchAutocomplete();

            // Ouvrir directement la modale avec les infos du departement
            openModal(code, nom, image, url);
        }

        function openModal(code, nom, imagePath, urlSource) {
            currentDeptCode = code;
            currentDeptName = nom;
            currentSourceUrl = urlSource;
            currentRelationIds = []; // Reset, sera rempli par loadSidebarData
            currentGeoJSON = null; // Reset
            document.getElementById('modalTitle').textContent = 'Circonscriptions de ' + nom + ' (' + code + ')';

            // Afficher loading et cacher contenu
            document.getElementById('sidebarLoading').style.display = 'block';
            document.getElementById('sidebarContent').innerHTML = '';

            // Cacher l'iframe, preparer pour la carte Leaflet
            document.getElementById('mapContainer').classList.remove('active');
            document.getElementById('leafletInlineContainer').classList.add('active');
            document.getElementById('backHint').classList.remove('visible');

            // Afficher loading dans le conteneur Leaflet
            const loadingEl = document.getElementById('leafletInlineLoading');
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement de la carte...</p>';

            // Nettoyer la carte Leaflet inline existante
            if (leafletInlineMap) {
                leafletInlineMap.remove();
                leafletInlineMap = null;
            }

            modal.show();

            // Charger les donnees du departement
            loadSidebarData(code);
        }

        // Charger les circonscriptions/cantons/communes via API
        // Structure arborescente: FRANCE > Toutes Régions > Départements > Circonscription > Canton > Communes
        async function loadSidebarData(codeDept) {
            try {
                // Charger en parallele: hierarchie complete + details du departement selectionne
                const [hierarchyResponse, detailResponse] = await Promise.all([
                    fetch('api_circonscriptions.php?action=getHierarchy'),
                    fetch(`api_circonscriptions.php?action=detail&dept=${codeDept}`)
                ]);
                const hierarchyData = await hierarchyResponse.json();
                const data = await detailResponse.json();

                document.getElementById('sidebarLoading').style.display = 'none';

                if (data.error) {
                    document.getElementById('sidebarContent').innerHTML = '<div class="sidebar-loading">Aucune donnee</div>';
                    return;
                }

                let html = '';

                // Bouton FRANCE independant (au-dessus de l'arbre)
                html += `
                    <div class="france-button" onclick="showFranceMap()">
                        <img src="ressources/images/france-flag.png" alt="France" class="france-flag-img">
                        <span>FRANCE</span>
                    </div>
                `;

                html += '<div class="tree-root">';
                const circos = Object.keys(data.circonscriptions || {});
                const selectedRegionCode = data.region?.code || '';
                const selectedDeptNumero = data.departement?.numero || '';
                const allRegions = hierarchyData.regions || [];

                // Stocker les URLs OSM par circonscription
                currentOsmUrls = data.osm_urls || [];

                // Stocker les IDs de relations pour le departement
                currentRelationIds = data.relation_ids || [];

                // Stocker le GeoJSON de la BDD s'il est disponible
                currentGeoJSON = data.geojson || null;

                // Afficher automatiquement la carte Leaflet inline si on a des relations ou du GeoJSON
                if (currentRelationIds.length > 0 || currentGeoJSON) {
                    showLeafletInline();
                }

                // Construire la liste des communes pour la recherche
                currentCommunesList = [];
                if (circos.length > 0) {
                    circos.forEach(circo => {
                        const cantons = data.circonscriptions[circo];
                        Object.keys(cantons).forEach(canton => {
                            cantons[canton].forEach(commune => {
                                currentCommunesList.push({
                                    commune: commune,
                                    canton: canton,
                                    circo: circo
                                });
                            });
                        });
                    });
                }

                // Afficher le champ de recherche si on a des communes
                if (currentCommunesList.length > 0) {
                    document.getElementById('sidebarSearch').style.display = 'block';
                    document.getElementById('searchCommune').value = '';
                    document.getElementById('searchCommuneCount').textContent = '';
                    document.getElementById('searchCommuneCount').classList.remove('has-filter');
                } else {
                    document.getElementById('sidebarSearch').style.display = 'none';
                }

                // Construire l'arbre avec TOUTES les regions
                allRegions.forEach((region, idxRegion) => {
                    const isSelectedRegion = region.code === selectedRegionCode;
                    const regionToggleClass = isSelectedRegion ? '' : 'collapsed';
                    const regionChildrenClass = isSelectedRegion ? 'expanded' : '';

                    html += `
                        <div class="tree-node tree-region" id="tree_region_${region.code}">
                            <div class="tree-header tree-header-region" onclick="toggleTreeNode(this)">
                                <span class="tree-toggle ${regionToggleClass}"><i class="bi bi-chevron-down"></i></span>
                                <i class="bi bi-map tree-icon"></i>
                                <span class="tree-label">${region.nom}</span>
                                <span class="tree-count">${region.departements.length} dept.</span>
                            </div>
                            <div class="tree-children ${regionChildrenClass}">
                    `;

                    // Pour chaque departement de la region
                    region.departements.forEach(dept => {
                        const isSelectedDept = dept.numero === selectedDeptNumero;
                        const deptToggleClass = isSelectedDept ? '' : 'collapsed';
                        const deptChildrenClass = isSelectedDept ? 'expanded' : '';

                        html += `
                            <div class="tree-node tree-dept" id="tree_dept_${dept.numero}" data-dept="${dept.numero}">
                                <div class="tree-header tree-header-dept" onclick="toggleDept(this, '${dept.numero}')">
                                    <span class="tree-toggle ${deptToggleClass}"><i class="bi bi-chevron-down"></i></span>
                                    <i class="bi bi-building tree-icon"></i>
                                    <span class="tree-label">${dept.nom} (${dept.numero})</span>
                                </div>
                                <div class="tree-children ${deptChildrenClass}">
                        `;

                        // Si c'est le departement selectionne, afficher les circonscriptions
                        if (isSelectedDept && circos.length > 0) {
                            circos.forEach((circo, idxCirco) => {
                                const cantons = data.circonscriptions[circo];
                                const cantonsKeys = Object.keys(cantons);

                                const osmUrl = currentOsmUrls[idxCirco] || '';
                                const circoEscaped = circo.replace(/'/g, "\\'");

                                let osmLinks = '<div class="tree-circo-links">';
                                if (osmUrl) {
                                    osmLinks += `<a href="#" title="Voir sur OpenStreetMap" onclick="event.stopPropagation(); showOsmMap('${osmUrl}', '${circoEscaped}');"><i class="bi bi-globe"></i></a>`;
                                }
                                osmLinks += '</div>';

                                html += `
                                    <div class="tree-node tree-circo" id="circo_${idxCirco}">
                                        <div class="tree-header" onclick="toggleCirco(${idxCirco}, ${circos.length})">
                                            <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                            <i class="bi bi-pin-map tree-icon"></i>
                                            <span class="tree-label">${circo}</span>
                                            <span class="tree-count">${cantonsKeys.length} cantons</span>
                                            ${osmLinks}
                                        </div>
                                        <div class="tree-children">
                                `;

                                cantonsKeys.forEach(canton => {
                                    const communes = cantons[canton];
                                    html += `
                                        <div class="tree-node tree-canton">
                                            <div class="tree-header" onclick="toggleTreeNode(this)">
                                                <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                                <i class="bi bi-signpost-split tree-icon"></i>
                                                <span class="tree-label">${canton}</span>
                                                <span class="tree-count">${communes.length}</span>
                                            </div>
                                            <div class="tree-children">
                                    `;

                                    communes.forEach(commune => {
                                        const communeEscaped = commune.replace(/'/g, "\\'");
                                        html += `<div class="tree-commune" onclick="locateCommuneOnMap('${communeEscaped}')">
                                            <span><i class="bi bi-geo-alt-fill"></i>${commune}</span>
                                        </div>`;
                                    });

                                    html += '</div></div>';
                                });

                                html += '</div></div>';
                            });
                        }

                        html += '</div></div>'; // Fermer dept
                    });

                    html += '</div></div>'; // Fermer region
                });

                html += '</div>';

                document.getElementById('sidebarContent').innerHTML = html || '<div class="sidebar-loading">Aucune donnee disponible</div>';

                // Ouvrir la premiere circonscription du departement selectionne
                if (circos.length > 0) {
                    toggleCirco(0, circos.length);
                }

                // Scroller vers le departement selectionne
                setTimeout(() => {
                    const selectedDeptEl = document.getElementById('tree_dept_' + selectedDeptNumero);
                    if (selectedDeptEl) {
                        selectedDeptEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }, 100);

            } catch (error) {
                document.getElementById('sidebarLoading').style.display = 'none';
                document.getElementById('sidebarContent').innerHTML = '<div class="sidebar-loading">Erreur de chargement</div>';
            }
        }

        // Toggle departement et charger ses donnees si necessaire
        async function toggleDept(header, deptNumero) {
            const toggle = header.querySelector('.tree-toggle');
            const children = header.nextElementSibling;
            const isOpening = toggle.classList.contains('collapsed');

            // Toggle visuel
            toggle.classList.toggle('collapsed');
            if (children) children.classList.toggle('expanded');

            // Si on ouvre et qu'il n'y a pas de contenu, charger les donnees
            if (isOpening && children && children.children.length === 0) {
                children.innerHTML = '<div class="sidebar-loading" style="padding:10px;font-size:12px;">Chargement...</div>';

                try {
                    const response = await fetch(`api_circonscriptions.php?action=detail&dept=${deptNumero}`);
                    const data = await response.json();

                    if (data.error || !data.circonscriptions) {
                        children.innerHTML = '<div class="sidebar-loading" style="padding:10px;font-size:12px;">Aucune donnee</div>';
                        return;
                    }

                    const circos = Object.keys(data.circonscriptions);
                    let circosHtml = '';

                    circos.forEach((circo, idxCirco) => {
                        const cantons = data.circonscriptions[circo];
                        const cantonsKeys = Object.keys(cantons);

                        circosHtml += `
                            <div class="tree-node tree-circo" id="circo_${deptNumero}_${idxCirco}">
                                <div class="tree-header" onclick="toggleTreeNode(this)">
                                    <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                    <i class="bi bi-pin-map tree-icon"></i>
                                    <span class="tree-label">${circo}</span>
                                    <span class="tree-count">${cantonsKeys.length} cantons</span>
                                </div>
                                <div class="tree-children">
                        `;

                        cantonsKeys.forEach(canton => {
                            const communes = cantons[canton];
                            circosHtml += `
                                <div class="tree-node tree-canton">
                                    <div class="tree-header" onclick="toggleTreeNode(this)">
                                        <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                        <i class="bi bi-signpost-split tree-icon"></i>
                                        <span class="tree-label">${canton}</span>
                                        <span class="tree-count">${communes.length}</span>
                                    </div>
                                    <div class="tree-children">
                            `;

                            communes.forEach(commune => {
                                const communeEscaped = commune.replace(/'/g, "\\'");
                                circosHtml += `<div class="tree-commune" onclick="locateCommuneOnMap('${communeEscaped}')">
                                    <span><i class="bi bi-geo-alt-fill"></i>${commune}</span>
                                </div>`;
                            });

                            circosHtml += '</div></div>';
                        });

                        circosHtml += '</div></div>';
                    });

                    children.innerHTML = circosHtml || '<div class="sidebar-loading" style="padding:10px;font-size:12px;">Aucune circonscription</div>';

                } catch (err) {
                    children.innerHTML = '<div class="sidebar-loading" style="padding:10px;font-size:12px;">Erreur</div>';
                }
            }
        }

        // Toggle node de l'arbre
        function toggleTreeNode(header) {
            const toggle = header.querySelector('.tree-toggle');
            const children = header.nextElementSibling;

            if (toggle) {
                toggle.classList.toggle('collapsed');
            }
            if (children && children.classList.contains('tree-children')) {
                children.classList.toggle('expanded');
            }
        }

        // Toggle entre circonscriptions (ferme les autres quand on en ouvre une)
        function toggleCirco(circoIdx, totalCircos) {
            const clickedCirco = document.getElementById('circo_' + circoIdx);
            if (!clickedCirco) return;

            const clickedHeader = clickedCirco.querySelector('.tree-header');
            const clickedToggle = clickedHeader.querySelector('.tree-toggle');
            const clickedChildren = clickedHeader.nextElementSibling;
            const isCurrentlyOpen = !clickedToggle.classList.contains('collapsed');

            // Fermer toutes les circonscriptions
            for (let i = 0; i < totalCircos; i++) {
                const circoNode = document.getElementById('circo_' + i);
                if (circoNode) {
                    const header = circoNode.querySelector('.tree-header');
                    const toggle = header.querySelector('.tree-toggle');
                    const children = header.nextElementSibling;

                    // Fermer cette circo et tous ses cantons
                    toggle.classList.add('collapsed');
                    if (children) children.classList.remove('expanded');

                    // Fermer tous les cantons
                    circoNode.querySelectorAll('.tree-canton .tree-toggle').forEach(t => t.classList.add('collapsed'));
                    circoNode.querySelectorAll('.tree-canton .tree-children').forEach(c => c.classList.remove('expanded'));
                }
            }

            // Si la circo cliquee etait fermee, l'ouvrir avec tous ses cantons
            if (!isCurrentlyOpen) {
                clickedToggle.classList.remove('collapsed');
                if (clickedChildren) clickedChildren.classList.add('expanded');

                // Ouvrir tous les cantons de cette circo
                clickedCirco.querySelectorAll('.tree-canton .tree-header').forEach(cantonHeader => {
                    const toggle = cantonHeader.querySelector('.tree-toggle');
                    const children = cantonHeader.nextElementSibling;
                    if (toggle) toggle.classList.remove('collapsed');
                    if (children) children.classList.add('expanded');
                });
            }
        }

        // Revenir a la carte Leaflet (depuis une iframe ou autre vue)
        function returnToLeafletMap() {
            // Cacher l'iframe si elle est active
            document.getElementById('mapContainer').classList.remove('active');
            document.getElementById('googleMapFrame').src = '';
            document.getElementById('backHint').classList.remove('visible');

            // S'assurer que le conteneur Leaflet est visible
            const container = document.getElementById('leafletInlineContainer');
            if (!container.classList.contains('active') && (currentRelationIds.length > 0 || currentGeoJSON)) {
                showLeafletInline();
            }

            // Retirer la classe active de toutes les communes
            document.querySelectorAll('.tree-commune.active').forEach(el => {
                el.classList.remove('active');
            });
        }

        // Ouvrir la modale FRANCE avec carte de toutes les regions
        async function openFranceModal() {
            // Configurer le titre de la modale
            document.querySelector('#imageModal .modal-title').textContent = 'FRANCE - Carte des Régions';

            // Afficher le loading du sidebar
            document.getElementById('sidebarLoading').style.display = 'block';

            // Nettoyer la carte Leaflet existante
            if (leafletInlineMap) {
                leafletInlineMap.remove();
                leafletInlineMap = null;
            }

            // Ouvrir la modale en plein écran
            const modalEl = document.getElementById('imageModal');
            modalEl.classList.add('fullscreen');
            document.getElementById('fullscreenIcon').className = 'bi bi-fullscreen-exit';
            modal.show();

            // Charger la hierarchie pour le sidebar
            await loadSidebarDataForFrance();

            // Afficher la carte France
            await showFranceMap();
        }

        // Charger le sidebar avec toutes les régions (sans département sélectionné)
        async function loadSidebarDataForFrance() {
            try {
                const hierarchyResponse = await fetch('api_circonscriptions.php?action=getHierarchy');
                const hierarchyData = await hierarchyResponse.json();

                const sidebarLoading = document.getElementById('sidebarLoading');
                const sidebarContent = document.getElementById('sidebarContent');

                if (sidebarLoading) sidebarLoading.style.display = 'none';

                if (!hierarchyData.success || !hierarchyData.regions) {
                    if (sidebarContent) sidebarContent.innerHTML = '<p class="text-danger p-3">Erreur de chargement</p>';
                    return;
                }

                // Construire l'arbre avec toutes les régions fermées
                let html = '';

                // Bouton FRANCE (actif)
                html += `
                    <div class="france-button active" onclick="showFranceMap()">
                        <img src="ressources/images/france-flag.png" alt="France" class="france-flag-img">
                        <span>FRANCE</span>
                    </div>
                `;

                // Toutes les régions (fermées)
                hierarchyData.regions.forEach(region => {
                    const nbDepts = region.departements ? region.departements.length : 0;

                    html += `
                        <div class="tree-node tree-region">
                            <div class="tree-header" onclick="toggleTreeNode(this)">
                                <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                <span class="tree-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                <span class="tree-label">${region.nom}</span>
                                <span class="tree-count">${nbDepts}</span>
                            </div>
                            <div class="tree-children" data-region="${region.nom}">
                    `;

                    // Départements de cette région (fermés)
                    if (region.departements) {
                        region.departements.forEach(dept => {
                            html += `
                                <div class="tree-node tree-dept" data-dept="${dept.numero}">
                                    <div class="tree-header" onclick="loadDeptAndOpen('${dept.numero}', '${dept.nom.replace(/'/g, "\\'")}', this)">
                                        <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                        <span class="tree-icon"><i class="bi bi-building"></i></span>
                                        <span class="tree-label">${dept.numero} - ${dept.nom}</span>
                                    </div>
                                    <div class="tree-children dept-content"></div>
                                </div>
                            `;
                        });
                    }

                    html += `
                            </div>
                        </div>
                    `;
                });

                if (sidebarContent) sidebarContent.innerHTML = html;

            } catch (error) {
                console.error('Error in loadSidebarDataForFrance:', error);
                const sidebarContent = document.getElementById('sidebarContent');
                if (sidebarContent) sidebarContent.innerHTML = '<p class="text-danger p-3">Erreur de chargement</p>';
            }
        }

        // Charger un département et ouvrir son contenu dans l'arbre
        async function loadDeptAndOpen(deptCode, deptNom, headerEl) {
            const deptNode = headerEl.closest('.tree-dept');
            const childrenContainer = deptNode.querySelector('.dept-content');
            const toggleIcon = headerEl.querySelector('.tree-toggle');

            // Toggle si déjà chargé
            if (childrenContainer.innerHTML.trim() !== '') {
                toggleIcon.classList.toggle('collapsed');
                childrenContainer.classList.toggle('expanded');
                return;
            }

            // Charger les données du département
            try {
                const response = await fetch(`api_circonscriptions.php?action=detail&dept=${deptCode}`);
                const data = await response.json();

                if (data.error) {
                    childrenContainer.innerHTML = '<p class="text-danger p-2">Erreur</p>';
                    return;
                }

                let html = '';
                const circos = data.circonscriptions || {};

                Object.keys(circos).forEach(circoName => {
                    const cantons = circos[circoName];
                    const nbCantons = Object.keys(cantons).length;

                    html += `
                        <div class="tree-node tree-circo">
                            <div class="tree-header" onclick="toggleTreeNode(this)">
                                <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                <span class="tree-icon"><i class="bi bi-diagram-3"></i></span>
                                <span class="tree-label">${circoName}</span>
                                <span class="tree-count">${nbCantons}</span>
                            </div>
                            <div class="tree-children">
                    `;

                    Object.keys(cantons).forEach(cantonName => {
                        const communes = cantons[cantonName];
                        html += `
                            <div class="tree-node tree-canton">
                                <div class="tree-header" onclick="toggleTreeNode(this)">
                                    <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                    <span class="tree-icon"><i class="bi bi-pin-map"></i></span>
                                    <span class="tree-label">${cantonName}</span>
                                    <span class="tree-count">${communes.length}</span>
                                </div>
                                <div class="tree-children">
                        `;

                        communes.forEach(commune => {
                            html += `<div class="tree-commune"><i class="bi bi-house-door"></i> <span onclick="selectCommune('${commune.replace(/'/g, "\\'")}', '${deptCode}')">${commune}</span></div>`;
                        });

                        html += `
                                </div>
                            </div>
                        `;
                    });

                    html += `
                            </div>
                        </div>
                    `;
                });

                childrenContainer.innerHTML = html;
                toggleIcon.classList.remove('collapsed');
                childrenContainer.classList.add('expanded');

            } catch (error) {
                childrenContainer.innerHTML = '<p class="text-danger p-2">Erreur de chargement</p>';
            }
        }

        // Afficher la carte de France (toutes les regions)
        async function showFranceMap() {
            const container = document.getElementById('leafletInlineContainer');
            const loadingEl = document.getElementById('leafletInlineLoading');

            // Cacher l'iframe, afficher le conteneur Leaflet
            document.getElementById('mapContainer').classList.remove('active');
            container.classList.add('active');

            // Afficher loading
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement de la carte de France...<br><small>(Les données sont volumineuses, patientez...)</small></p>';

            // Nettoyer la carte existante
            if (leafletInlineMap) {
                leafletInlineMap.remove();
                leafletInlineMap = null;
            }

            try {
                // Charger les GeoJSON des regions depuis l'API
                loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Téléchargement des données régions...</p>';
                const response = await fetch('api_circonscriptions.php?action=getAllRegionsGeoJSON');
                loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Traitement des données...</p>';
                const geoJson = await response.json();

                // Creer la carte centree sur la France
                leafletInlineMap = L.map('leafletInlineMap').setView([46.603354, 1.888334], 6);

                // Ajouter le fond de carte OpenStreetMap
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                }).addTo(leafletInlineMap);

                // Couleurs pour les regions
                const regionColors = [
                    '#e74c3c', '#3498db', '#2ecc71', '#9b59b6', '#f39c12',
                    '#1abc9c', '#e67e22', '#34495e', '#16a085', '#c0392b',
                    '#2980b9', '#27ae60', '#8e44ad'
                ];

                if (geoJson && geoJson.features && geoJson.features.length > 0) {
                    // Creer un index de couleur par region
                    const regionColorMap = {};
                    const regionLayers = {};
                    let colorIdx = 0;

                    const geoJsonLayer = L.geoJSON(geoJson, {
                        style: function(feature) {
                            const regionName = feature.properties.nom_region || 'Inconnu';
                            if (!regionColorMap[regionName]) {
                                regionColorMap[regionName] = regionColors[colorIdx % regionColors.length];
                                colorIdx++;
                            }
                            return {
                                color: '#ffffff',
                                weight: 2,
                                opacity: 1,
                                fillColor: regionColorMap[regionName],
                                fillOpacity: 0.4
                            };
                        },
                        onEachFeature: function(feature, layer) {
                            const regionName = feature.properties.nom_region || 'Region inconnue';

                            // Stocker la layer pour calculer le centre
                            if (!regionLayers[regionName]) {
                                regionLayers[regionName] = layer;
                            }

                            layer.on('mouseover', function() {
                                this.setStyle({ fillOpacity: 0.7, weight: 3 });
                            });
                            layer.on('mouseout', function() {
                                this.setStyle({ fillOpacity: 0.4, weight: 2 });
                            });
                        }
                    }).addTo(leafletInlineMap);

                    // Stocker les bounds des régions pour le zoom
                    window.franceRegionBounds = {};
                    window.franceRegionLayers = regionLayers;

                    // Ajouter les labels de région au centre de chaque région
                    Object.keys(regionLayers).forEach(regionName => {
                        const layer = regionLayers[regionName];
                        const bounds = layer.getBounds();
                        const center = bounds.getCenter();

                        // Stocker les bounds pour le zoom
                        window.franceRegionBounds[regionName] = bounds;

                        // Créer un marqueur avec un DivIcon pour le label cliquable
                        const label = L.marker(center, {
                            icon: L.divIcon({
                                className: 'region-label',
                                html: `<span class="region-tag" onclick="zoomToRegion('${regionName.replace(/'/g, "\\'")}')" style="cursor:pointer;">${regionName}</span>`,
                                iconSize: null,
                                iconAnchor: [0, 0]
                            }),
                            interactive: true
                        }).addTo(leafletInlineMap);

                        // Rendre aussi le polygone cliquable
                        layer.on('click', function() {
                            zoomToRegion(regionName);
                        });
                    });

                    // Ajuster la vue sur les donnees (padding plus grand pour zoom arrière)
                    const bounds = L.geoJSON(geoJson).getBounds();
                    if (bounds.isValid()) {
                        leafletInlineMap.fitBounds(bounds, { padding: [10, 10] });
                    }
                }

                loadingEl.style.display = 'none';

            } catch (error) {
                console.error('Erreur chargement carte France:', error);
                loadingEl.innerHTML = '<p>Erreur de chargement</p>';
            }
        }

        // Variable pour stocker la couche des départements
        let departementsLayer = null;
        let deptLabelsLayer = null;

        // Zoomer sur une région et afficher ses départements
        async function zoomToRegion(regionName) {
            const loadingEl = document.getElementById('leafletInlineLoading');

            // Zoomer sur la région
            if (window.franceRegionBounds && window.franceRegionBounds[regionName]) {
                leafletInlineMap.fitBounds(window.franceRegionBounds[regionName], { padding: [30, 30] });
            }

            // Afficher loading
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement des départements...</p>';

            try {
                // Charger les départements de cette région avec leurs GeoJSON
                const response = await fetch(`api_regions.php?action=getDepartementsGeoJSON&region=${encodeURIComponent(regionName)}`);
                const data = await response.json();

                if (!data.success || !data.geojson) {
                    loadingEl.style.display = 'none';
                    return;
                }

                // Supprimer l'ancienne couche de départements et les labels si elle existe
                if (departementsLayer) {
                    leafletInlineMap.removeLayer(departementsLayer);
                    departementsLayer = null;
                }
                if (deptLabelsLayer) {
                    leafletInlineMap.removeLayer(deptLabelsLayer);
                    deptLabelsLayer = null;
                }

                // Couleurs pour les départements
                const deptColors = [
                    '#3498db', '#e74c3c', '#2ecc71', '#9b59b6', '#f39c12',
                    '#1abc9c', '#e67e22', '#34495e', '#16a085', '#c0392b',
                    '#2980b9', '#27ae60', '#8e44ad'
                ];
                let colorIdx = 0;

                // Créer le layer group pour les labels des départements
                deptLabelsLayer = L.layerGroup().addTo(leafletInlineMap);

                // Ajouter la couche des départements
                departementsLayer = L.geoJSON(data.geojson, {
                    style: function(feature) {
                        const color = deptColors[colorIdx % deptColors.length];
                        colorIdx++;
                        return {
                            color: '#ffffff',
                            weight: 2,
                            opacity: 1,
                            fillColor: color,
                            fillOpacity: 0.5
                        };
                    },
                    onEachFeature: function(feature, layer) {
                        const props = feature.properties || {};
                        const deptNum = props.numero_departement || props.code || '';
                        const deptNom = props.nom_departement || props.name || '';

                        // Label au centre du département (ajouté au layer group)
                        const center = layer.getBounds().getCenter();
                        const marker = L.marker(center, {
                            icon: L.divIcon({
                                className: 'dept-label',
                                html: `<span class="dept-tag">${deptNum}</span>`,
                                iconSize: null,
                                iconAnchor: [0, 0]
                            }),
                            interactive: false
                        });
                        deptLabelsLayer.addLayer(marker);

                        // Popup au survol
                        layer.bindTooltip(`<strong>${deptNum} - ${deptNom}</strong>`, {
                            permanent: false,
                            direction: 'top'
                        });

                        layer.on('mouseover', function() {
                            this.setStyle({ fillOpacity: 0.8 });
                        });
                        layer.on('mouseout', function() {
                            this.setStyle({ fillOpacity: 0.5 });
                        });
                    }
                }).addTo(leafletInlineMap);

                // Ajuster le zoom sur les départements
                const bounds = departementsLayer.getBounds();
                if (bounds.isValid()) {
                    leafletInlineMap.fitBounds(bounds, { padding: [20, 20] });
                }

                loadingEl.style.display = 'none';

            } catch (error) {
                console.error('Erreur chargement départements:', error);
                loadingEl.style.display = 'none';
            }
        }

        // Afficher la carte Leaflet dans le conteneur principal
        function showLeafletInline() {
            if (currentRelationIds.length === 0 && !currentGeoJSON) {
                return;
            }

            const container = document.getElementById('leafletInlineContainer');
            const loadingEl = document.getElementById('leafletInlineLoading');

            // Si deja actif, ne rien faire
            if (container.classList.contains('active') && leafletInlineMap) {
                return;
            }

            // Cacher l'iframe, afficher le conteneur Leaflet
            document.getElementById('mapContainer').classList.remove('active');
            container.classList.add('active');

            // Afficher loading
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement des ' + currentRelationIds.length + ' circonscriptions...</p>';

            // Charger la carte apres un court delai
            setTimeout(() => {
                loadLeafletInlineMap();
            }, 100);
        }

        // Charger la carte Leaflet inline
        async function loadLeafletInlineMap() {
            // Nettoyer la carte existante
            if (leafletInlineMap) {
                leafletInlineMap.remove();
                leafletInlineMap = null;
            }

            // Creer la carte
            leafletInlineMap = L.map('leafletInlineMap').setView([46.603354, 1.888334], 6);

            // Ajouter le fond de carte OpenStreetMap
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(leafletInlineMap);

            // Couleurs pour les differentes circonscriptions
            const colors = ['#e41a1c', '#377eb8', '#4daf4a', '#984ea3', '#ff7f00', '#ffff33', '#a65628', '#f781bf', '#17a2b8', '#6c757d'];

            try {
                let geoJson = null;

                // Priorite 1: Utiliser le GeoJSON stocke en base s'il est disponible
                if (currentGeoJSON && currentGeoJSON.features && currentGeoJSON.features.length > 0) {
                    geoJson = currentGeoJSON;
                    // Ajouter relationIndex aux features si absent
                    geoJson.features.forEach((feature, idx) => {
                        if (feature.properties.relationIndex === undefined) {
                            feature.properties.relationIndex = idx;
                        }
                    });
                }
                // Priorite 2: Fallback sur Overpass API
                else if (currentRelationIds.length > 0) {
                    const relationQuery = currentRelationIds.map(id => `relation(${id});`).join('');
                    const overpassQuery = `[out:json][timeout:60];(${relationQuery});out body;>;out skel qt;`;
                    const overpassUrl = `https://overpass-api.de/api/interpreter?data=${encodeURIComponent(overpassQuery)}`;

                    const response = await fetch(overpassUrl);
                    const data = await response.json();

                    if (data.elements && data.elements.length > 0) {
                        geoJson = osmToGeoJSON(data, currentRelationIds);
                    }
                }

                if (geoJson && geoJson.features && geoJson.features.length > 0) {
                    const layer = L.geoJSON(geoJson, {
                        style: function(feature) {
                            const idx = feature.properties.relationIndex || 0;
                            const color = colors[idx % colors.length];
                            return {
                                color: 'white',
                                weight: 2,
                                opacity: 1,
                                fillColor: color,
                                fillOpacity: 0.6
                            };
                        },
                        onEachFeature: function(feature, layer) {
                            const name = shortenCircoName(feature.properties.name) || 'Circonscription';
                            const idx = feature.properties.relationIndex;
                            const color = colors[idx % colors.length];
                            layer.bindPopup('<div style="border-left: 4px solid ' + color + '; padding-left: 8px;"><strong>' + name + '</strong></div>');
                        }
                    }).addTo(leafletInlineMap);

                    // Zoomer sur tous les polygones
                    leafletInlineMap.fitBounds(layer.getBounds(), { padding: [20, 20] });

                    // Ajouter une legende si plusieurs circonscriptions
                    if (geoJson.features.length > 1) {
                        addLegendInline(geoJson.features, colors);
                    }
                }

                // Cacher le loading
                document.getElementById('leafletInlineLoading').style.display = 'none';

            } catch (error) {
                console.error('Erreur chargement OSM:', error);
                document.getElementById('leafletInlineLoading').innerHTML = '<i class="bi bi-exclamation-triangle" style="color: #dc3545;"></i><p>Erreur de chargement</p>';
            }
        }

        // Convertir les noms de circonscriptions en format court (1ère, 2ème, etc.)
        function shortenCircoName(name) {
            if (!name) return name;

            // Mapping des ordinaux en toutes lettres vers format court
            const ordinaux = {
                'première': '1ère', 'premiere': '1ère',
                'deuxième': '2ème', 'deuxieme': '2ème',
                'troisième': '3ème', 'troisieme': '3ème',
                'quatrième': '4ème', 'quatrieme': '4ème',
                'cinquième': '5ème', 'cinquieme': '5ème',
                'sixième': '6ème', 'sixieme': '6ème',
                'septième': '7ème', 'septieme': '7ème',
                'huitième': '8ème', 'huitieme': '8ème',
                'neuvième': '9ème', 'neuvieme': '9ème',
                'dixième': '10ème', 'dixieme': '10ème',
                'onzième': '11ème', 'onzieme': '11ème',
                'douzième': '12ème', 'douzieme': '12ème',
                'treizième': '13ème', 'treizieme': '13ème',
                'quatorzième': '14ème', 'quatorzieme': '14ème',
                'quinzième': '15ème', 'quinzieme': '15ème',
                'seizième': '16ème', 'seizieme': '16ème',
                'dix-septième': '17ème', 'dix-septieme': '17ème',
                'dix-huitième': '18ème', 'dix-huitieme': '18ème',
                'dix-neuvième': '19ème', 'dix-neuvieme': '19ème',
                'vingtième': '20ème', 'vingtieme': '20ème',
                'vingt-et-unième': '21ème', 'vingt-et-unieme': '21ème',
                'vingt-deuxième': '22ème', 'vingt-deuxieme': '22ème',
                'vingt-troisième': '23ème', 'vingt-troisieme': '23ème'
            };

            let result = name;
            for (const [long, short] of Object.entries(ordinaux)) {
                const regex = new RegExp(long, 'gi');
                result = result.replace(regex, short);
            }
            // Retirer "de " ou "de l'" apres "circonscription"
            result = result.replace(/circonscription de l'/gi, "circonscription l'");
            result = result.replace(/circonscription de /gi, 'circonscription ');
            return result;
        }

        // Extraire juste le numero ordinal d'un nom de circonscription (ex: "1ère circonscription du Nord" -> "1ère")
        function extractCircoNumber(name) {
            if (!name) return null;
            // D'abord convertir en format court
            const shortened = shortenCircoName(name);
            // Extraire le numero ordinal (1ère, 2ème, etc.)
            const match = shortened.match(/(\d+(?:ère|ème))/i);
            return match ? match[1] : null;
        }

        // Ajouter une legende a la carte inline
        function addLegendInline(features, colors) {
            const legend = L.control({ position: 'bottomright' });

            legend.onAdd = function(map) {
                const div = L.DomUtil.create('div', 'circo-legend');
                div.innerHTML = '<h4>Circonscriptions du<br><strong>' + currentDeptName.toUpperCase() + '</strong></h4>';

                features.forEach((feature, idx) => {
                    const fullName = feature.properties.name || '';
                    const shortNum = extractCircoNumber(fullName) || (idx + 1) + 'ème';
                    const color = colors[idx % colors.length];
                    div.innerHTML += '<div class="circo-legend-item"><div class="circo-legend-color" style="background:' + color + ';"></div><span>' + shortNum + '</span></div>';
                });

                return div;
            };

            legend.addTo(leafletInlineMap);
        }

        // Afficher le site source dans l'iframe
        function showSourceSite() {
            if (!currentSourceUrl) return;

            // Afficher la carte (iframe) - cacher Leaflet
            document.getElementById('leafletInlineContainer').classList.remove('active');
            document.getElementById('mapContainer').classList.add('active');
            document.getElementById('googleMapFrame').src = currentSourceUrl;

            // Afficher le hint de retour
            document.getElementById('backHint').classList.add('visible');

            // Retirer la classe active de toutes les communes
            document.querySelectorAll('.tree-commune.active').forEach(el => {
                el.classList.remove('active');
            });
        }

        // Afficher OpenStreetMap pour une seule circonscription (dans la carte inline)
        async function showOsmMap(osmUrl, circoName) {
            if (!osmUrl) return;

            // Extraire l'ID de relation depuis l'URL
            const relationMatch = osmUrl.match(/relation\/(\d+)/);
            if (!relationMatch) return;

            const relationId = relationMatch[1];

            // Afficher loading
            const loadingEl = document.getElementById('leafletInlineLoading');
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement de ' + (circoName || 'la circonscription') + '...</p>';

            // S'assurer que le conteneur Leaflet est visible
            document.getElementById('mapContainer').classList.remove('active');
            document.getElementById('leafletInlineContainer').classList.add('active');

            // Nettoyer la carte existante
            if (leafletInlineMap) {
                leafletInlineMap.remove();
                leafletInlineMap = null;
            }
            leafletMarker = null;

            // Charger la carte avec une seule circonscription via Overpass
            await loadSingleCircoInline(relationId, circoName);
        }

        // Charger une seule circonscription dans la carte inline
        async function loadSingleCircoInline(relationId, circoName) {
            // Creer la carte
            leafletInlineMap = L.map('leafletInlineMap').setView([46.603354, 1.888334], 6);

            // Ajouter le fond de carte OpenStreetMap
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(leafletInlineMap);

            const colors = ['#e41a1c'];

            try {
                const relationQuery = `relation(${relationId});`;
                const overpassQuery = `[out:json][timeout:60];(${relationQuery});out body;>;out skel qt;`;
                const overpassUrl = `https://overpass-api.de/api/interpreter?data=${encodeURIComponent(overpassQuery)}`;

                const response = await fetch(overpassUrl);
                const data = await response.json();

                if (data.elements && data.elements.length > 0) {
                    const geoJson = osmToGeoJSON(data, [relationId]);

                    if (geoJson && geoJson.features && geoJson.features.length > 0) {
                        const layer = L.geoJSON(geoJson, {
                            style: function(feature) {
                                return {
                                    color: 'white',
                                    weight: 2,
                                    opacity: 1,
                                    fillColor: colors[0],
                                    fillOpacity: 0.6
                                };
                            },
                            onEachFeature: function(feature, layer) {
                                const name = shortenCircoName(feature.properties.name || circoName) || 'Circonscription';
                                layer.bindPopup('<div style="border-left: 4px solid ' + colors[0] + '; padding-left: 8px;"><strong>' + name + '</strong></div>');
                            }
                        }).addTo(leafletInlineMap);

                        // Zoomer sur le polygone
                        leafletInlineMap.fitBounds(layer.getBounds(), { padding: [20, 20] });
                    }
                }

                // Cacher le loading
                document.getElementById('leafletInlineLoading').style.display = 'none';

            } catch (error) {
                document.getElementById('leafletInlineLoading').innerHTML = '<i class="bi bi-exclamation-triangle" style="color: #dc3545;"></i><p>Erreur de chargement</p>';
            }
        }

        // Afficher toutes les circonscriptions du departement sur la carte inline
        function showDeptOnLeaflet() {
            if (currentRelationIds.length === 0 && !currentGeoJSON) return;

            // Recharger la carte inline avec toutes les circonscriptions
            showLeafletInline();
        }

        // Localiser une commune sur la carte du departement (dans la carte inline)
        async function locateCommuneOnMap(communeName) {
            if (!leafletInlineMap) {
                // Si la carte n'est pas encore chargee, la charger d'abord
                await showLeafletInline();
                // Attendre que la carte soit prete
                setTimeout(() => addCommuneMarkerInline(communeName), 500);
                return;
            }

            // Ajouter le marqueur sur la carte inline
            await addCommuneMarkerInline(communeName);
        }

        // Ajouter un marqueur pour une commune sur la carte inline
        async function addCommuneMarkerInline(communeName) {
            try {
                // Geocoder la commune avec Nominatim (limiter a la France)
                const searchQuery = encodeURIComponent(communeName + ', ' + currentDeptName + ', France');
                const nominatimUrl = `https://nominatim.openstreetmap.org/search?q=${searchQuery}&format=json&limit=1&countrycodes=fr`;

                // Lancer les deux requetes en parallele
                const [nominatimResponse, maireResponse] = await Promise.all([
                    fetch(nominatimUrl, {
                        headers: { 'User-Agent': 'AnnuaireMaires/1.0' }
                    }),
                    fetch(`api_circonscriptions.php?action=getMaireByCommune&commune=${encodeURIComponent(communeName)}&dept=${encodeURIComponent(currentDeptCode)}`)
                ]);

                const results = await nominatimResponse.json();
                const maireData = await maireResponse.json();

                if (results && results.length > 0) {
                    const result = results[0];
                    const lat = parseFloat(result.lat);
                    const lon = parseFloat(result.lon);

                    // Supprimer l'ancien marqueur s'il existe
                    if (leafletMarker && leafletInlineMap) {
                        leafletInlineMap.removeLayer(leafletMarker);
                    }

                    // Creer une icone personnalisee (rouge)
                    const redIcon = L.divIcon({
                        className: 'commune-marker',
                        html: '<div style="background:#dc3545; width:24px; height:24px; border-radius:50%; border:3px solid white; box-shadow:0 2px 8px rgba(0,0,0,0.4); display:flex; align-items:center; justify-content:center;"><i class="bi bi-geo-alt-fill" style="color:white; font-size:12px;"></i></div>',
                        iconSize: [24, 24],
                        iconAnchor: [12, 12],
                        popupAnchor: [0, -12]
                    });

                    // Ajouter le marqueur
                    leafletMarker = L.marker([lat, lon], { icon: redIcon }).addTo(leafletInlineMap);

                    // Construire le contenu du popup avec les infos du maire
                    let popupContent = '<div style="min-width:200px;">';
                    popupContent += '<strong style="font-size:14px;">' + communeName + '</strong>';
                    popupContent += '<br><small style="color:#666;">' + currentDeptName + '</small>';

                    if (maireData.success && maireData.data) {
                        const data = maireData.data;
                        popupContent += '<hr style="margin:8px 0; border-color:#eee;">';

                        // Nom du maire (utiliser nomPrenom ou construire depuis prenomMaire + nomMaire)
                        const nomMaire = data.nomPrenom || ((data.prenomMaire || '') + ' ' + (data.nomMaire || '')).trim();
                        if (nomMaire) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-person-fill" style="color:#0d6efd;"></i> <strong>' + nomMaire + '</strong></div>';
                        }

                        // Telephone
                        if (data.telephone) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-telephone-fill" style="color:#198754;"></i> <a href="tel:' + data.telephone + '">' + data.telephone + '</a></div>';
                        }

                        // Email
                        if (data.email) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-envelope-fill" style="color:#dc3545;"></i> <a href="mailto:' + data.email + '" style="font-size:12px;">' + data.email + '</a></div>';
                        }

                        // Habitants
                        if (data.nbHabitants) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-people-fill" style="color:#6c757d;"></i> ' + parseInt(data.nbHabitants).toLocaleString('fr-FR') + ' hab.</div>';
                        }
                    }

                    popupContent += '</div>';

                    // Ajouter le popup
                    leafletMarker.bindPopup(popupContent).openPopup();

                    // Centrer la carte sur le marqueur avec un zoom modere (pas trop zoome)
                    leafletInlineMap.setView([lat, lon], 9);
                }
            } catch (error) {
                // Erreur silencieuse
            }
        }

        // Convertir les donnees Overpass en GeoJSON (supporte MultiPolygon)
        function osmToGeoJSON(data, relationIds) {
            const nodes = {};
            const ways = {};
            const features = [];

            // Indexer les noeuds
            data.elements.forEach(el => {
                if (el.type === 'node') {
                    nodes[el.id] = [el.lon, el.lat];
                }
            });

            // Indexer les ways
            data.elements.forEach(el => {
                if (el.type === 'way') {
                    ways[el.id] = el.nodes.map(nodeId => nodes[nodeId]).filter(n => n);
                }
            });

            // Traiter les relations
            data.elements.forEach(el => {
                if (el.type === 'relation') {
                    const outerRings = [];

                    el.members.forEach(member => {
                        if (member.type === 'way' && member.role === 'outer') {
                            const coords = ways[member.ref];
                            if (coords && coords.length > 0) {
                                outerRings.push(coords);
                            }
                        }
                    });

                    if (outerRings.length > 0) {
                        // Fusionner les segments en anneaux (peut retourner plusieurs anneaux)
                        const allRings = mergeWaySegmentsToRings(outerRings);

                        if (allRings.length > 0) {
                            // Trouver l'index de cette relation dans la liste
                            const relationIndex = relationIds ? relationIds.indexOf(String(el.id)) : 0;

                            // Si plusieurs anneaux, creer un MultiPolygon
                            if (allRings.length === 1) {
                                features.push({
                                    type: 'Feature',
                                    properties: {
                                        ...el.tags,
                                        relationId: el.id,
                                        relationIndex: relationIndex >= 0 ? relationIndex : features.length
                                    },
                                    geometry: {
                                        type: 'Polygon',
                                        coordinates: [allRings[0]]
                                    }
                                });
                            } else {
                                // MultiPolygon: plusieurs anneaux separes
                                features.push({
                                    type: 'Feature',
                                    properties: {
                                        ...el.tags,
                                        relationId: el.id,
                                        relationIndex: relationIndex >= 0 ? relationIndex : features.length
                                    },
                                    geometry: {
                                        type: 'MultiPolygon',
                                        coordinates: allRings.map(ring => [ring])
                                    }
                                });
                            }
                        }
                    }
                }
            });

            return {
                type: 'FeatureCollection',
                features: features
            };
        }

        // Fusionner les segments de ways en anneaux continus (retourne TOUS les anneaux)
        function mergeWaySegmentsToRings(segments) {
            if (segments.length === 0) return [];
            if (segments.length === 1) {
                // Fermer l'anneau si necessaire
                const ring = segments[0];
                if (ring.length > 2 && !pointsEqual(ring[0], ring[ring.length - 1])) {
                    ring.push(ring[0]);
                }
                return [ring];
            }

            const rings = [];
            const remaining = segments.map(s => [...s]); // Copie profonde

            while (remaining.length > 0) {
                // Commencer un nouvel anneau
                let ring = [...remaining.shift()];
                let changed = true;
                let maxIterations = remaining.length * 3 + 20;
                let iterations = 0;

                while (changed && iterations < maxIterations) {
                    changed = false;
                    iterations++;

                    const firstPoint = ring[0];
                    const lastPoint = ring[ring.length - 1];

                    // Verifier si l'anneau est ferme
                    if (pointsEqual(firstPoint, lastPoint) && ring.length > 3) {
                        break;
                    }

                    for (let i = 0; i < remaining.length; i++) {
                        const segment = remaining[i];
                        if (!segment || segment.length === 0) continue;

                        const segFirst = segment[0];
                        const segLast = segment[segment.length - 1];

                        // Essayer de connecter a la fin de l'anneau
                        if (pointsEqual(lastPoint, segFirst)) {
                            ring.push(...segment.slice(1));
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (pointsEqual(lastPoint, segLast)) {
                            ring.push(...segment.reverse().slice(1));
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        }
                        // Essayer de connecter au debut de l'anneau
                        else if (pointsEqual(firstPoint, segLast)) {
                            ring = [...segment.slice(0, -1), ...ring];
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (pointsEqual(firstPoint, segFirst)) {
                            ring = [...segment.reverse().slice(0, -1), ...ring];
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        }
                    }
                }

                // Fermer l'anneau si necessaire
                if (ring.length > 2) {
                    if (!pointsEqual(ring[0], ring[ring.length - 1])) {
                        ring.push(ring[0]);
                    }
                    rings.push(ring);
                }
            }

            return rings;
        }

        // Comparer deux points (avec tolerance)
        function pointsEqual(p1, p2) {
            if (!p1 || !p2) return false;
            const tolerance = 0.00001; // Tolerance plus fine
            return Math.abs(p1[0] - p2[0]) < tolerance && Math.abs(p1[1] - p2[1]) < tolerance;
        }

        // Toggle plein ecran
        function toggleFullscreen() {
            const modalEl = document.getElementById('imageModal');
            const icon = document.getElementById('fullscreenIcon');

            modalEl.classList.toggle('fullscreen');

            if (modalEl.classList.contains('fullscreen')) {
                icon.className = 'bi bi-fullscreen-exit';
            } else {
                icon.className = 'bi bi-arrows-fullscreen';
            }
        }

        // ========================================
        // Filtrage des communes dans l'arborescence
        // ========================================

        // Filtrer les communes dans l'arborescence
        function filterCommuneInTree() {
            const input = document.getElementById('searchCommune');
            const search = input.value.trim().toLowerCase();
            const countEl = document.getElementById('searchCommuneCount');

            // Si recherche vide ou trop courte, retirer le filtre sans effacer le champ
            if (search.length < 2) {
                clearFilterClasses();
                countEl.textContent = '';
                countEl.classList.remove('has-filter');
                return;
            }

            // Retirer les classes de filtre precedentes
            document.querySelectorAll('.tree-commune').forEach(el => {
                el.classList.remove('filtered-out', 'filter-match');
            });
            document.querySelectorAll('.tree-canton').forEach(el => {
                el.classList.remove('filtered-out');
            });
            document.querySelectorAll('.tree-circo').forEach(el => {
                el.classList.remove('filtered-out');
            });

            let matchCount = 0;
            const circosWithMatches = new Set();
            const cantonsWithMatches = new Set();

            // Parcourir toutes les communes et appliquer le filtre
            document.querySelectorAll('.tree-commune').forEach(communeEl => {
                const span = communeEl.querySelector('span');
                if (!span) return;

                const communeName = span.textContent.toLowerCase();

                if (communeName.includes(search)) {
                    // Cette commune correspond au filtre
                    communeEl.classList.add('filter-match');
                    matchCount++;

                    // Trouver le canton parent et le marquer comme ayant des correspondances
                    const cantonEl = communeEl.closest('.tree-canton');
                    if (cantonEl) {
                        cantonsWithMatches.add(cantonEl);

                        // Trouver la circo parent et la marquer comme ayant des correspondances
                        const circoEl = cantonEl.closest('.tree-circo');
                        if (circoEl) {
                            circosWithMatches.add(circoEl);
                        }
                    }
                } else {
                    // Cacher cette commune
                    communeEl.classList.add('filtered-out');
                }
            });

            // Cacher les cantons sans correspondances
            document.querySelectorAll('.tree-canton').forEach(cantonEl => {
                if (!cantonsWithMatches.has(cantonEl)) {
                    cantonEl.classList.add('filtered-out');
                } else {
                    // Ouvrir ce canton pour montrer les resultats
                    const toggle = cantonEl.querySelector('.tree-toggle');
                    const children = cantonEl.querySelector('.tree-children');
                    if (toggle) toggle.classList.remove('collapsed');
                    if (children) children.classList.add('expanded');
                }
            });

            // Cacher les circos sans correspondances
            document.querySelectorAll('.tree-circo').forEach(circoEl => {
                if (!circosWithMatches.has(circoEl)) {
                    circoEl.classList.add('filtered-out');
                } else {
                    // Ouvrir cette circo pour montrer les resultats
                    const toggle = circoEl.querySelector('.tree-toggle');
                    const children = circoEl.querySelector('.tree-children');
                    if (toggle) toggle.classList.remove('collapsed');
                    if (children) children.classList.add('expanded');
                }
            });

            // Afficher le compteur
            if (matchCount > 0) {
                countEl.textContent = matchCount + ' commune' + (matchCount > 1 ? 's' : '') + ' trouvee' + (matchCount > 1 ? 's' : '');
                countEl.classList.add('has-filter');
            } else {
                countEl.textContent = 'Aucune commune trouvee';
                countEl.classList.add('has-filter');
            }
        }

        // Retirer uniquement les classes de filtre (sans vider le champ)
        function clearFilterClasses() {
            // Retirer toutes les classes de filtre
            document.querySelectorAll('.tree-commune').forEach(el => {
                el.classList.remove('filtered-out', 'filter-match');
            });
            document.querySelectorAll('.tree-canton').forEach(el => {
                el.classList.remove('filtered-out');
            });
            document.querySelectorAll('.tree-circo').forEach(el => {
                el.classList.remove('filtered-out');
            });
        }

        // Reinitialiser le filtre (bouton X)
        function resetCommuneFilter() {
            const input = document.getElementById('searchCommune');
            const countEl = document.getElementById('searchCommuneCount');

            // Vider le champ de recherche
            input.value = '';

            // Retirer toutes les classes de filtre
            clearFilterClasses();
            document.querySelectorAll('.tree-commune').forEach(el => {
                el.classList.remove('active');
            });

            // Vider le compteur
            countEl.textContent = '';
            countEl.classList.remove('has-filter');

            // Fermer tous les cantons (garder seulement la 1ere circo ouverte)
            const circoNodes = document.querySelectorAll('.tree-circo');
            if (circoNodes.length > 0) {
                toggleCirco(0, circoNodes.length);
            }
        }

        // =====================================================
        // MODAL CARTE REGION - HIERARCHIE COMPLETE
        // Region > Departement > Circonscription
        // =====================================================
        let regionMapModal = null;
        let regionLeafletMap = null;
        let regionDeptsLayer = null;
        let currentRegionName = null;
        let currentRegionHierarchy = null; // Donnees hierarchiques

        // Couleurs pour les departements
        const regionDeptColors = [
            '#6f42c1', '#17a2b8', '#28a745', '#fd7e14', '#dc3545',
            '#20c997', '#6610f2', '#e83e8c', '#ffc107', '#007bff',
            '#6c757d', '#343a40'
        ];

        function getRegionDeptColor(index) {
            return regionDeptColors[index % regionDeptColors.length];
        }

        // Ouvrir la modal de carte region
        async function openRegionMapModal(regionName) {
            currentRegionName = regionName;
            document.getElementById('regionMapTitle').textContent = regionName.replace(/-/g, ' ');

            if (!regionMapModal) {
                regionMapModal = new bootstrap.Modal(document.getElementById('regionMapModal'));
            }
            regionMapModal.show();

            // Initialiser la carte apres ouverture
            document.getElementById('regionMapModal').addEventListener('shown.bs.modal', function handler() {
                initRegionLeafletMap(regionName);
                document.getElementById('regionMapModal').removeEventListener('shown.bs.modal', handler);
            });
        }

        // Initialiser la carte Leaflet de la region avec hierarchie complete
        async function initRegionLeafletMap(regionName) {
            const loading = document.getElementById('regionMapLoading');
            loading.style.display = 'flex';

            // Creer ou reinitialiser la carte
            if (regionLeafletMap) {
                regionLeafletMap.remove();
            }

            regionLeafletMap = L.map('regionLeafletMap').setView([46.603354, 1.888334], 6);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(regionLeafletMap);

            try {
                // Recuperer la hierarchie complete via l'API
                const response = await fetch(`api_regions.php?action=getFullHierarchy&region=${encodeURIComponent(regionName)}`);
                const data = await response.json();

                if (data.success) {
                    currentRegionHierarchy = data;

                    // Mettre a jour le compteur
                    const nbDepts = data.departements ? data.departements.length : 0;
                    document.getElementById('regionDeptCount').querySelector('span').textContent = nbDepts + ' departements';

                    // Construire l'arbre hierarchique
                    buildRegionHierarchyTree(data);

                    // Afficher le GeoJSON sur la carte (departements)
                    if (data.geojson && data.geojson.features && data.geojson.features.length > 0) {
                        displayRegionGeoJSON(data.geojson, data.departements);
                    } else if (data.departements && data.departements.length > 0) {
                        // Fallback: essayer Overpass API
                        const relationIds = data.departements.map(d => d.relation_osm).filter(id => id);
                        if (relationIds.length > 0) {
                            const geoJSON = await fetchRegionOverpassGeoJSON(relationIds, data.departements);
                            if (geoJSON && geoJSON.features && geoJSON.features.length > 0) {
                                displayRegionGeoJSON(geoJSON, data.departements);
                            }
                        }
                    }
                }
            } catch (error) {
                console.error('Erreur chargement carte region:', error);
            }

            loading.style.display = 'none';
        }

        // Afficher le GeoJSON sur la carte
        function displayRegionGeoJSON(geoJSON, departements) {
            regionDeptsLayer = L.geoJSON(geoJSON, {
                style: function(feature) {
                    const deptNum = feature.properties.numero_departement;
                    const index = departements.findIndex(d => d.numero === deptNum);
                    return {
                        fillColor: getRegionDeptColor(index >= 0 ? index : 0),
                        weight: 2,
                        opacity: 1,
                        color: 'white',
                        fillOpacity: 0.6
                    };
                },
                onEachFeature: function(feature, layer) {
                    const props = feature.properties;
                    const deptNum = props.numero_departement || '';
                    const deptNom = props.nom_departement || '';
                    const popup = `
                        <div style="text-align:center;">
                            <strong style="color:#17a2b8;">${deptNum} - ${deptNom}</strong>
                            <br><a href="javascript:void(0)" onclick="openDeptFromRegion('${deptNum}')">
                                <i class="bi bi-diagram-3"></i> Voir les circonscriptions
                            </a>
                        </div>
                    `;
                    layer.bindPopup(popup);
                    layer.on('mouseover', function() {
                        layer.setStyle({ fillOpacity: 0.85 });
                    });
                    layer.on('mouseout', function() {
                        layer.setStyle({ fillOpacity: 0.6 });
                    });
                }
            }).addTo(regionLeafletMap);

            regionLeafletMap.fitBounds(regionDeptsLayer.getBounds(), { padding: [20, 20] });
        }

        // Fetch Overpass API pour les departements de la region (fallback)
        async function fetchRegionOverpassGeoJSON(relationIds, depts) {
            const query = `[out:json][timeout:120];
                (${relationIds.map(id => `relation(${id});`).join('')})
                out body;>;out skel qt;`;

            const response = await fetch('https://overpass-api.de/api/interpreter', {
                method: 'POST',
                body: 'data=' + encodeURIComponent(query),
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            });

            const data = await response.json();
            return convertRegionToGeoJSON(data.elements, relationIds, depts);
        }

        // Convertir Overpass en GeoJSON pour la region
        function convertRegionToGeoJSON(elements, relationIds, depts) {
            const nodes = {};
            const ways = {};

            elements.forEach(el => {
                if (el.type === 'node') {
                    nodes[el.id] = [el.lon, el.lat];
                }
            });

            elements.forEach(el => {
                if (el.type === 'way' && el.nodes) {
                    ways[el.id] = el.nodes.map(nodeId => nodes[nodeId]).filter(n => n);
                }
            });

            const features = [];

            elements.forEach(el => {
                if (el.type !== 'relation' || !el.members) return;

                const outerRings = [];
                el.members.forEach(member => {
                    if (member.type === 'way' && member.role === 'outer') {
                        if (ways[member.ref] && ways[member.ref].length > 0) {
                            outerRings.push(ways[member.ref]);
                        }
                    }
                });

                if (outerRings.length === 0) return;

                const mergedRings = mergeWaySegments(outerRings);
                if (mergedRings.length === 0) return;

                const dept = depts.find(d => d.relation_osm === String(el.id)) || {};
                const deptIndex = depts.findIndex(d => d.relation_osm === String(el.id));

                const geometry = mergedRings.length === 1
                    ? { type: 'Polygon', coordinates: [mergedRings[0]] }
                    : { type: 'MultiPolygon', coordinates: mergedRings.map(r => [r]) };

                features.push({
                    type: 'Feature',
                    properties: {
                        id: el.id,
                        name: el.tags?.name || dept.nom || '',
                        numero_departement: dept.numero || '',
                        nom_departement: dept.nom || '',
                        deptIndex: deptIndex >= 0 ? deptIndex : 0
                    },
                    geometry: geometry
                });
            });

            return { type: 'FeatureCollection', features };
        }

        // Merge way segments
        function mergeWaySegments(segments) {
            if (segments.length === 0) return [];
            if (segments.length === 1) {
                const ring = [...segments[0]];
                if (ring.length > 2 && !ptsEqual(ring[0], ring[ring.length - 1])) {
                    ring.push(ring[0]);
                }
                return [ring];
            }

            const rings = [];
            let remaining = [...segments];

            while (remaining.length > 0) {
                let ring = [...remaining.shift()];
                let changed = true;
                let iterations = 0;
                const maxIter = segments.length * 4 + 50;

                while (changed && iterations < maxIter) {
                    changed = false;
                    iterations++;

                    if (ring.length === 0) break;
                    if (ptsEqual(ring[0], ring[ring.length - 1]) && ring.length > 3) break;

                    for (let i = 0; i < remaining.length; i++) {
                        const seg = remaining[i];
                        if (!seg || seg.length === 0) continue;

                        const first = ring[0];
                        const last = ring[ring.length - 1];
                        const segFirst = seg[0];
                        const segLast = seg[seg.length - 1];

                        if (ptsEqual(last, segFirst)) {
                            ring = ring.concat(seg.slice(1));
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (ptsEqual(last, segLast)) {
                            ring = ring.concat([...seg].reverse().slice(1));
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (ptsEqual(first, segLast)) {
                            ring = seg.slice(0, -1).concat(ring);
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (ptsEqual(first, segFirst)) {
                            ring = [...seg].reverse().slice(0, -1).concat(ring);
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        }
                    }
                }

                if (ring.length > 2) {
                    if (!ptsEqual(ring[0], ring[ring.length - 1])) {
                        ring.push(ring[0]);
                    }
                    rings.push(ring);
                }
            }

            return rings;
        }

        function ptsEqual(p1, p2, tolerance = 0.00001) {
            if (!p1 || !p2) return false;
            return Math.abs(p1[0] - p2[0]) < tolerance && Math.abs(p1[1] - p2[1]) < tolerance;
        }

        // Construire l'arbre hierarchique: Region > Departements > Circonscriptions
        function buildRegionHierarchyTree(data) {
            const container = document.getElementById('regionHierarchyTree');
            const regionName = data.region ? data.region.nom : currentRegionName;
            const departements = data.departements || [];

            let html = '<div class="tree-region-root">';

            // Niveau Region (racine, toujours ouvert)
            html += `
                <div class="tree-node tree-region">
                    <div class="tree-header" onclick="toggleRegionTreeNode(this)">
                        <span class="tree-toggle"><i class="bi bi-chevron-down"></i></span>
                        <i class="bi bi-geo-alt-fill tree-icon"></i>
                        <span class="tree-label">${regionName}</span>
                        <span class="tree-count">${departements.length} dept.</span>
                    </div>
                    <div class="tree-children expanded">
            `;

            // Niveau Departements
            departements.forEach((dept, deptIndex) => {
                const nbCircos = dept.circonscriptions ? dept.circonscriptions.length : 0;
                const deptColor = getRegionDeptColor(deptIndex);

                html += `
                    <div class="tree-node tree-dept" data-dept="${dept.numero}">
                        <div class="tree-header" onclick="toggleRegionTreeNode(this)">
                            <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                            <span class="tree-color-badge" style="background: ${deptColor};"></span>
                            <i class="bi bi-building tree-icon"></i>
                            <span class="tree-label">${dept.numero} - ${dept.nom}</span>
                            <span class="tree-count">${nbCircos} circo.</span>
                        </div>
                        <div class="tree-children">
                `;

                // Niveau Circonscriptions
                if (dept.circonscriptions && dept.circonscriptions.length > 0) {
                    dept.circonscriptions.forEach((circo, circoIndex) => {
                        const circoName = shortenCircoName(circo.nom) || circo.nom;
                        html += `
                            <div class="tree-node tree-circo-sub" data-circo="${circo.nom}">
                                <div class="tree-header" onclick="selectCircoInRegionMap('${dept.numero}', '${circo.nom.replace(/'/g, "\\'")}')">
                                    <i class="bi bi-pin-map-fill tree-icon" style="color: #0097a7;"></i>
                                    <span class="tree-label">${circoName}</span>
                                </div>
                            </div>
                        `;
                    });
                }

                html += `
                        </div>
                    </div>
                `;
            });

            html += `
                    </div>
                </div>
            </div>`;

            container.innerHTML = html;
        }

        // Toggle node dans l'arbre de la modal region
        function toggleRegionTreeNode(header) {
            const toggle = header.querySelector('.tree-toggle');
            const children = header.nextElementSibling;

            if (toggle) {
                toggle.classList.toggle('collapsed');
            }
            if (children && children.classList.contains('tree-children')) {
                children.classList.toggle('expanded');
            }
        }

        // Selectionner une circonscription dans la carte region
        function selectCircoInRegionMap(deptCode, circoName) {
            // Fermer la modal region et ouvrir la modal du departement
            openDeptFromRegion(deptCode);
        }

        // Ouvrir un departement depuis la modal region
        function openDeptFromRegion(deptCode) {
            // Fermer la modal region
            if (regionMapModal) {
                regionMapModal.hide();
            }

            // Trouver le departement dans les donnees
            const dept = departementsData.find(d => d.code === deptCode);
            if (dept) {
                // Ouvrir la modal du departement
                setTimeout(() => {
                    openModal(dept.code, dept.nom, dept.image, dept.url);
                }, 300);
            }
        }

        // Toggle plein ecran pour la modal region
        function toggleRegionMapFullscreen() {
            const modalEl = document.getElementById('regionMapModal');
            const icon = document.getElementById('regionMapFullscreenIcon');

            modalEl.classList.toggle('fullscreen');

            if (modalEl.classList.contains('fullscreen')) {
                icon.classList.remove('bi-arrows-fullscreen');
                icon.classList.add('bi-fullscreen-exit');
            } else {
                icon.classList.remove('bi-fullscreen-exit');
                icon.classList.add('bi-arrows-fullscreen');
            }

            // Redimensionner la carte
            setTimeout(() => {
                if (regionLeafletMap) {
                    regionLeafletMap.invalidateSize();
                }
            }, 300);
        }

        // Nettoyer la carte region quand la modal se ferme
        document.getElementById('regionMapModal').addEventListener('hidden.bs.modal', function() {
            if (regionLeafletMap) {
                regionLeafletMap.remove();
                regionLeafletMap = null;
            }
            regionDeptsLayer = null;
            currentRegionHierarchy = null;
            // Reset fullscreen
            document.getElementById('regionMapModal').classList.remove('fullscreen');
            document.getElementById('regionMapFullscreenIcon').classList.remove('bi-fullscreen-exit');
            document.getElementById('regionMapFullscreenIcon').classList.add('bi-arrows-fullscreen');
        });
    </script>
</body>
</html>
