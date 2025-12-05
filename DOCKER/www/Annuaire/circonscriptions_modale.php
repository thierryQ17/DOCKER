<?php
/**
 * Page Carte de France en fullscreen
 * Affiche la carte interactive avec le menu latéral (sidebar)
 * S'ouvre directement en plein écran
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

// Charger les données des départements pour la recherche
$stmt = $pdo->query("SELECT code_departement, nom_departement, region, image_path, url_source FROM t_circonscriptions ORDER BY region, code_departement");
$circonscriptions = $stmt->fetchAll(PDO::FETCH_ASSOC);

$departementsData = [];
foreach ($circonscriptions as $row) {
    $departementsData[] = [
        'code' => $row['code_departement'],
        'nom' => $row['nom_departement'],
        'region' => $row['region'],
        'image' => $row['image_path'],
        'url' => $row['url_source']
    ];
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carte de France - Circonscriptions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        /* Container principal fullscreen */
        .fullscreen-container {
            display: flex;
            width: 100vw;
            height: 100vh;
            background: #f0f2f5;
        }

        /* Sidebar gauche */
        .sidebar {
            width: 320px;
            min-width: 320px;
            height: 100vh;
            background: white;
            border-right: 1px solid #e9ecef;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .sidebar-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-header img {
            width: 28px;
            height: auto;
            border-radius: 3px;
        }

        .sidebar-header h1 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
        }

        .sidebar-search {
            padding: 10px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
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
            padding: 8px 10px 8px 32px;
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

        .sidebar-content {
            flex: 1;
            overflow-y: auto;
        }

        /* Bouton FRANCE */
        .france-button {
            display: flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 700;
            margin: 8px;
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

        .france-button img {
            width: 24px;
            height: auto;
            border-radius: 2px;
        }

        /* Arbre hiérarchique */
        .tree-root {
            padding: 0 0 10px 0;
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

        .tree-children {
            display: none;
        }

        .tree-children.expanded {
            display: block;
        }

        /* Niveau Region */
        .tree-region > .tree-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 600;
            margin: 4px 8px;
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

        /* Niveau Département */
        .tree-dept > .tree-header {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
            color: white;
            font-weight: 500;
            margin: 2px 8px 2px 16px;
            border-radius: 5px;
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

        /* Niveau Circonscription */
        .tree-circo > .tree-header {
            background: #e0f7fa;
            color: #0097a7;
            font-weight: 500;
            margin: 2px 8px 2px 24px;
            border-radius: 4px;
            padding: 6px 10px;
            border-left: 3px solid #17a2b8;
        }

        .tree-circo > .tree-header:hover {
            background: #b2ebf2;
        }

        .tree-circo > .tree-header .tree-toggle {
            color: #0097a7;
        }

        /* Niveau Canton */
        .tree-canton > .tree-header {
            background: #fff3e0;
            color: #e65100;
            font-weight: 500;
            margin: 2px 8px 2px 32px;
            border-radius: 4px;
            padding: 5px 10px;
            border-left: 3px solid #ff9800;
        }

        .tree-canton > .tree-header:hover {
            background: #ffe0b2;
        }

        /* Niveau Commune */
        .tree-commune {
            padding: 4px 12px 4px 48px;
            font-size: 12px;
            color: #333;
            text-align: left;
            border-bottom: 1px solid #f5f5f5;
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .tree-commune:hover {
            background: #e0f7fa;
            color: #006064;
        }

        .tree-commune i {
            margin-right: 5px;
            color: #17a2b8;
        }

        /* Zone carte principale */
        .map-container {
            flex: 1;
            height: 100vh;
            position: relative;
        }

        #leafletMap {
            width: 100%;
            height: 100%;
        }

        .map-loading {
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

        .map-loading i {
            font-size: 32px;
            color: #17a2b8;
            animation: spin 1s linear infinite;
        }

        .map-loading p {
            margin: 10px 0 0;
            color: #666;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
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
            cursor: pointer;
        }

        /* Labels des départements */
        .dept-label {
            background: transparent !important;
            border: none !important;
        }

        .dept-tag {
            display: inline-block;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 4px;
            white-space: nowrap;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
            transform: translate(-50%, -50%);
        }

        /* Tags ronds pour les circonscriptions */
        .circo-label {
            background: transparent !important;
            border: none !important;
        }

        .circo-tag {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            background: white;
            color: #333;
            font-size: 12px;
            font-weight: 700;
            border-radius: 50%;
            border: 1px solid #333;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
            margin-left: -14px;
            margin-top: -14px;
        }

        /* Tags des cantons - transparents */
        .canton-label {
            background: transparent !important;
            border: none !important;
        }

        .canton-tag {
            display: inline-block;
            background: rgba(255, 255, 255, 0.7);
            color: #555;
            font-size: 9px;
            font-weight: 500;
            padding: 2px 6px;
            border-radius: 3px;
            white-space: nowrap;
            transform: translate(-50%, -50%);
            pointer-events: none;
            text-shadow: 0 0 2px white;
        }

        /* Panes Leaflet personnalisés - ordre z-index explicite */
        .leaflet-regionsPane-pane {
            z-index: 400 !important;
        }
        .leaflet-departementsPane-pane {
            z-index: 450 !important;
        }
        .leaflet-circosPane-pane {
            z-index: 500 !important;
        }
        .leaflet-cantonsPane-pane {
            z-index: 550 !important;
        }
        /* Forcer les éléments SVG des circonscriptions à être visibles */
        .leaflet-circosPane-pane,
        .leaflet-circosPane-pane svg,
        .leaflet-circosPane-pane path {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        .leaflet-circosPane-pane svg {
            overflow: visible !important;
        }

        /* Légende */
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

        /* Sidebar loading */
        .sidebar-loading {
            padding: 20px;
            text-align: center;
            color: #6c757d;
        }

        .sidebar-loading i {
            font-size: 24px;
            animation: spin 1s linear infinite;
        }

        /* Responsive - mobile */
        @media (max-width: 768px) {
            .sidebar {
                position: absolute;
                z-index: 1001;
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .btn-toggle-sidebar {
                display: flex;
            }
        }

        .btn-toggle-sidebar {
            display: none;
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 1002;
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 20px;
            cursor: pointer;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        /* Bouton retour France */
        .btn-back-france {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 1000;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border: none;
            color: white;
            padding: 8px 15px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: none;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .btn-back-france:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
        }

        .btn-back-france img {
            width: 20px;
            height: auto;
            border-radius: 2px;
        }

        /* Scroll uniquement pour les communes sous les cantons */
        .tree-canton > .tree-children {
            max-height: 240px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="fullscreen-container">
        <!-- Sidebar gauche avec menu -->
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="ressources/images/france-flag.png" alt="France">
                <h1>Carte de France</h1>
            </div>

            <div class="sidebar-search">
                <div class="sidebar-search-wrapper">
                    <i class="bi bi-search sidebar-search-icon"></i>
                    <input type="text" id="searchInput" placeholder="Rechercher un département..." oninput="filterTree()">
                </div>
            </div>

            <div class="sidebar-content" id="sidebarContent">
                <div class="sidebar-loading" id="sidebarLoading">
                    <i class="bi bi-arrow-repeat"></i>
                    <p>Chargement...</p>
                </div>
            </div>
        </div>

        <!-- Zone carte principale -->
        <div class="map-container">
            <button class="btn-toggle-sidebar" id="btnToggleSidebar" onclick="toggleSidebar()">
                <i class="bi bi-list"></i>
            </button>

            <button class="btn-back-france" id="btnBackFrance" onclick="showFranceMap()">
                <img src="ressources/images/france-flag.png" alt="">
                <span>Retour France</span>
            </button>

            <div id="mapLoading" class="map-loading">
                <i class="bi bi-arrow-repeat"></i>
                <p>Chargement de la carte...</p>
            </div>

            <div id="leafletMap"></div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // Variables globales
        let leafletMap = null;
        let departementsLayer = null;
        let deptLabelsLayer = null;
        let currentView = 'france'; // 'france', 'region', 'dept'
        let currentRegionName = null;
        let currentDeptCode = null;
        let currentDeptName = null;
        let currentGeoJSON = null;
        let currentRelationIds = [];
        let leafletMarker = null;

        // Données des départements
        const departementsData = <?= json_encode($departementsData) ?>;

        // Couleurs pour les régions
        const regionColors = [
            '#e74c3c', '#3498db', '#2ecc71', '#9b59b6', '#f39c12',
            '#1abc9c', '#e67e22', '#34495e', '#16a085', '#c0392b',
            '#2980b9', '#27ae60', '#8e44ad'
        ];

        // Couleurs pour les départements
        const deptColors = [
            '#3498db', '#e74c3c', '#2ecc71', '#9b59b6', '#f39c12',
            '#1abc9c', '#e67e22', '#34495e', '#16a085', '#c0392b',
            '#2980b9', '#27ae60', '#8e44ad'
        ];

        // Couleurs pour les circonscriptions
        const circoColors = ['#e41a1c', '#377eb8', '#4daf4a', '#984ea3', '#ff7f00', '#ffff33', '#a65628', '#f781bf', '#17a2b8', '#6c757d'];

        // Initialisation au chargement
        document.addEventListener('DOMContentLoaded', async function() {
            // Charger le sidebar
            await loadSidebar();

            // Afficher la carte de France
            await showFranceMap();
        });

        // Charger le sidebar avec la hiérarchie
        async function loadSidebar() {
            try {
                const response = await fetch('api_circonscriptions.php?action=getHierarchy');
                const data = await response.json();

                if (!data.success || !data.regions) {
                    document.getElementById('sidebarContent').innerHTML = '<p class="text-danger p-3">Erreur de chargement</p>';
                    return;
                }

                let html = '';

                // Bouton FRANCE (actif par défaut)
                html += `
                    <div class="france-button active" id="btnFrance" onclick="showFranceMap()">
                        <img src="ressources/images/france-flag.png" alt="France">
                        <span>FRANCE</span>
                    </div>
                `;

                html += '<div class="tree-root" id="treeRoot">';

                // Toutes les régions
                data.regions.forEach(region => {
                    const nbDepts = region.departements ? region.departements.length : 0;
                    const regionId = region.nom.replace(/[^a-zA-Z0-9]/g, '_');

                    html += `
                        <div class="tree-node tree-region" data-region="${region.nom}" id="region_${regionId}">
                            <div class="tree-header" onclick="toggleTreeNode(this); zoomToRegion('${region.nom.replace(/'/g, "\\'")}')">
                                <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                                <span class="tree-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                <span class="tree-label">${region.nom}</span>
                                <span class="tree-count">${nbDepts}</span>
                            </div>
                            <div class="tree-children" data-region="${region.nom}">
                    `;

                    // Départements de cette région
                    if (region.departements) {
                        region.departements.forEach(dept => {
                            html += `
                                <div class="tree-node tree-dept" data-dept="${dept.numero}">
                                    <div class="tree-header" onclick="loadDeptDetail('${dept.numero}', '${dept.nom.replace(/'/g, "\\'")}', this)">
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

                html += '</div>';

                document.getElementById('sidebarLoading').style.display = 'none';
                document.getElementById('sidebarContent').innerHTML = html;

            } catch (error) {
                console.error('Erreur chargement sidebar:', error);
                document.getElementById('sidebarContent').innerHTML = '<p class="text-danger p-3">Erreur de chargement</p>';
            }
        }

        // Toggle noeud de l'arbre
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

        // Afficher la carte de France (toutes les régions)
        async function showFranceMap() {
            currentView = 'france';
            currentRegionName = null;

            // Mettre à jour le bouton FRANCE
            document.getElementById('btnFrance')?.classList.add('active');
            document.getElementById('btnBackFrance').style.display = 'none';

            const loadingEl = document.getElementById('mapLoading');
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement de la carte de France...</p>';

            // Nettoyer la carte existante
            if (leafletMap) {
                leafletMap.remove();
                leafletMap = null;
            }

            try {
                // Charger les GeoJSON des régions
                const response = await fetch('api_circonscriptions.php?action=getAllRegionsGeoJSON');
                const geoJson = await response.json();

                // Créer la carte centrée sur la France
                leafletMap = L.map('leafletMap').setView([46.603354, 1.888334], 6);

                // Créer des panes personnalisés avec z-index explicites pour contrôler l'ordre des couches
                // Ordre (du bas vers le haut) : tuiles (200) < régions (400) < départements (450) < circonscriptions (500)
                leafletMap.createPane('regionsPane');
                leafletMap.getPane('regionsPane').style.zIndex = 400;

                leafletMap.createPane('departementsPane');
                leafletMap.getPane('departementsPane').style.zIndex = 450;

                leafletMap.createPane('circosPane');
                leafletMap.getPane('circosPane').style.zIndex = 500;

                leafletMap.createPane('cantonsPane');
                leafletMap.getPane('cantonsPane').style.zIndex = 550;

                // Ajouter le fond de carte
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                }).addTo(leafletMap);

                if (geoJson && geoJson.features && geoJson.features.length > 0) {
                    const regionColorMap = {};
                    const regionLayers = {};
                    let colorIdx = 0;

                    // Couche des régions (en dessous - dans regionsPane)
                    window.regionsGeoJsonLayer = L.geoJSON(geoJson, {
                        pane: 'regionsPane',
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

                            if (!regionLayers[regionName]) {
                                regionLayers[regionName] = layer;
                            }

                            layer.on('mouseover', function() {
                                // Ne pas changer le style si on est dans cette région
                                if (currentRegionName === regionName) return;
                                this.setStyle({ fillOpacity: 0.7, weight: 3 });
                            });
                            layer.on('mouseout', function() {
                                // Remettre le style normal (visible)
                                if (currentRegionName === regionName) {
                                    // Région courante : reste transparente
                                    return;
                                }
                                this.setStyle({ fillOpacity: 0.4, weight: 2 });
                            });
                            layer.on('click', function(e) {
                                // Si on clique sur la région courante, laisser passer aux départements
                                if (currentRegionName === regionName) {
                                    return;
                                }
                                zoomToRegion(regionName);
                            });
                        }
                    }).addTo(leafletMap);

                    // Stocker les bounds des régions
                    window.franceRegionBounds = {};
                    window.franceRegionLayers = regionLayers;

                    // Ajouter les labels des régions
                    Object.keys(regionLayers).forEach(regionName => {
                        const layer = regionLayers[regionName];
                        const bounds = layer.getBounds();
                        // Utiliser le centroïde réel du polygone
                        const center = getPolygonCentroid(layer.feature) || bounds.getCenter();

                        window.franceRegionBounds[regionName] = bounds;

                        L.marker(center, {
                            icon: L.divIcon({
                                className: 'region-label',
                                html: `<span class="region-tag" onclick="zoomToRegion('${regionName.replace(/'/g, "\\'")}')">${regionName}</span>`,
                                iconSize: null,
                                iconAnchor: [0, 0]
                            }),
                            interactive: true
                        }).addTo(leafletMap);
                    });

                    // Ajuster la vue
                    const bounds = L.geoJSON(geoJson).getBounds();
                    if (bounds.isValid()) {
                        leafletMap.fitBounds(bounds, { padding: [10, 10] });
                    }
                }

                loadingEl.style.display = 'none';

            } catch (error) {
                console.error('Erreur chargement carte France:', error);
                loadingEl.innerHTML = '<p>Erreur de chargement</p>';
            }
        }

        // Zoomer sur une région et afficher ses départements
        async function zoomToRegion(regionName) {
            currentView = 'region';
            currentRegionName = regionName;

            document.getElementById('btnFrance')?.classList.remove('active');
            document.getElementById('btnBackFrance').style.display = 'flex';

            const loadingEl = document.getElementById('mapLoading');

            // Zoomer sur la région
            if (window.franceRegionBounds && window.franceRegionBounds[regionName]) {
                leafletMap.fitBounds(window.franceRegionBounds[regionName], { padding: [30, 30] });
            }

            // Ouvrir la région dans le sidebar
            openRegionInSidebar(regionName);

            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement des départements...</p>';

            try {
                const response = await fetch(`api_regions.php?action=getDepartementsGeoJSON&region=${encodeURIComponent(regionName)}`);
                const data = await response.json();

                if (!data.success || !data.geojson) {
                    loadingEl.style.display = 'none';
                    return;
                }

                // Supprimer l'ancienne couche des départements et leurs tags
                if (departementsLayer) {
                    leafletMap.removeLayer(departementsLayer);
                    departementsLayer = null;
                }
                if (deptLabelsLayer) {
                    leafletMap.removeLayer(deptLabelsLayer);
                    deptLabelsLayer = null;
                }

                // Supprimer les circonscriptions si on change de région
                if (window.circosLayer) {
                    leafletMap.removeLayer(window.circosLayer);
                    window.circosLayer = null;
                }
                if (window.circosLabelsLayer) {
                    leafletMap.removeLayer(window.circosLabelsLayer);
                    window.circosLabelsLayer = null;
                }
                currentDeptCode = null;
                currentDeptName = null;

                let colorIdx = 0;
                deptLabelsLayer = L.layerGroup();

                departementsLayer = L.geoJSON(data.geojson, {
                    pane: 'departementsPane',
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
                        const deptNum = props.numero_departement || '';
                        const deptNom = props.nom_departement || '';

                        // Label au centroïde réel du polygone
                        const center = getPolygonCentroid(feature) || layer.getBounds().getCenter();
                        const marker = L.marker(center, {
                            icon: L.divIcon({
                                className: 'dept-label',
                                html: `<span class="dept-tag">${deptNom} - ${deptNum}</span>`,
                                iconSize: null,
                                iconAnchor: [0, 0]
                            }),
                            interactive: false
                        });
                        marker.deptNum = deptNum; // Stocker le numéro pour filtrage ultérieur
                        deptLabelsLayer.addLayer(marker);

                        layer.on('mouseover', function() {
                            // Ne pas changer le style si on est dans ce département
                            if (currentDeptCode === deptNum) return;
                            this.setStyle({ fillOpacity: 0.8 });
                        });
                        layer.on('mouseout', function() {
                            // Remettre le style normal
                            if (currentDeptCode === deptNum) return;
                            this.setStyle({ fillOpacity: 0.5 });
                        });
                        layer.on('click', function() {
                            // Si on clique sur le département courant, ne rien faire
                            if (currentDeptCode === deptNum) return;
                            loadDeptMap(deptNum, deptNom);
                        });
                    }
                });

                // Ajouter les couches
                departementsLayer.addTo(leafletMap);
                deptLabelsLayer.addTo(leafletMap);

                // Garder toutes les régions visibles
                // Seule la région courante est rendue transparente pour voir les départements
                // L'ordre des couches est géré par les panes personnalisés
                if (window.regionsGeoJsonLayer) {
                    window.regionsGeoJsonLayer.eachLayer(function(layer) {
                        const layerRegion = layer.feature?.properties?.nom_region;
                        if (layerRegion === regionName) {
                            // Région courante : transparente pour voir les départements
                            layer.setStyle({ fillOpacity: 0, weight: 0, opacity: 0 });
                            if (layer._path) {
                                layer._path.style.pointerEvents = 'none';
                            }
                        } else {
                            // Autres régions : visibles et cliquables
                            layer.setStyle({
                                fillOpacity: 0.4,
                                weight: 2,
                                opacity: 1
                            });
                            if (layer._path) {
                                layer._path.style.pointerEvents = 'auto';
                            }
                        }
                    });
                }

                const bounds = departementsLayer.getBounds();
                if (bounds.isValid()) {
                    leafletMap.fitBounds(bounds, { padding: [20, 20] });
                }

                loadingEl.style.display = 'none';

            } catch (error) {
                console.error('Erreur chargement départements:', error);
                loadingEl.style.display = 'none';
            }
        }

        // Ouvrir une région dans le sidebar
        function openRegionInSidebar(regionName) {
            const regionId = regionName.replace(/[^a-zA-Z0-9]/g, '_');
            const regionEl = document.getElementById('region_' + regionId);
            if (regionEl) {
                const header = regionEl.querySelector('.tree-header');
                const toggle = header.querySelector('.tree-toggle');
                const children = header.nextElementSibling;

                if (toggle.classList.contains('collapsed')) {
                    toggle.classList.remove('collapsed');
                    if (children) children.classList.add('expanded');
                }

                regionEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }

        // Charger les détails d'un département (circonscriptions, cantons, communes)
        async function loadDeptDetail(deptCode, deptNom, headerEl) {
            const deptNode = headerEl.closest('.tree-dept');
            const childrenContainer = deptNode.querySelector('.dept-content');
            const toggleIcon = headerEl.querySelector('.tree-toggle');

            // Toggle si déjà chargé
            if (childrenContainer.innerHTML.trim() !== '') {
                toggleIcon.classList.toggle('collapsed');
                childrenContainer.classList.toggle('expanded');
                return;
            }

            // Charger les données
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
                                <span class="tree-label">${shortenCircoName(circoName)}</span>
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
                            html += `<div class="tree-commune" onclick="locateCommune('${commune.replace(/'/g, "\\'")}', '${deptCode}', '${deptNom.replace(/'/g, "\\'")}')">
                                <i class="bi bi-house-door"></i> ${commune}
                            </div>`;
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

                // Charger aussi la carte du département
                loadDeptMap(deptCode, deptNom);

            } catch (error) {
                childrenContainer.innerHTML = '<p class="text-danger p-2">Erreur de chargement</p>';
            }
        }

        // Charger la carte d'un département avec ses circonscriptions
        async function loadDeptMap(deptCode, deptNom) {
            // Sauvegarder l'ancien département pour le restaurer
            const previousDeptCode = currentDeptCode;

            currentView = 'dept';
            currentDeptCode = deptCode;
            currentDeptName = deptNom;

            document.getElementById('btnFrance')?.classList.remove('active');
            document.getElementById('btnBackFrance').style.display = 'flex';

            const loadingEl = document.getElementById('mapLoading');
            loadingEl.style.display = 'block';
            loadingEl.innerHTML = '<i class="bi bi-arrow-repeat"></i><p>Chargement des circonscriptions...</p>';

            try {
                const response = await fetch(`api_circonscriptions.php?action=detail&dept=${deptCode}`);
                const data = await response.json();

                currentGeoJSON = data.geojson || null;
                currentRelationIds = data.relation_ids || [];

                // Supprimer l'ancienne couche des circonscriptions
                if (window.circosLayer) {
                    leafletMap.removeLayer(window.circosLayer);
                    window.circosLayer = null;
                }
                if (window.circosLabelsLayer) {
                    leafletMap.removeLayer(window.circosLabelsLayer);
                    window.circosLabelsLayer = null;
                }

                // Supprimer l'ancienne couche des cantons
                if (window.cantonsLayer) {
                    leafletMap.removeLayer(window.cantonsLayer);
                    window.cantonsLayer = null;
                }
                if (window.cantonsLabelsLayer) {
                    leafletMap.removeLayer(window.cantonsLabelsLayer);
                    window.cantonsLabelsLayer = null;
                }

                // Supprimer la légende existante
                if (window.currentLegend) {
                    leafletMap.removeControl(window.currentLegend);
                    window.currentLegend = null;
                }

                // IMPORTANT: Restaurer l'affichage de l'ancien département (s'il y en avait un)
                if (previousDeptCode && previousDeptCode !== deptCode && departementsLayer) {
                    departementsLayer.eachLayer(function(layer) {
                        const layerDeptNum = layer.feature?.properties?.numero_departement;
                        if (layerDeptNum === previousDeptCode) {
                            // Restaurer l'affichage de l'ancien département
                            layer.setStyle({
                                fillOpacity: 0.5,
                                weight: 2,
                                opacity: 1
                            });
                            if (layer._path) {
                                layer._path.style.display = '';
                                layer._path.style.pointerEvents = 'auto';
                            }
                        }
                    });

                    // Restaurer aussi le label de l'ancien département
                    if (deptLabelsLayer) {
                        deptLabelsLayer.eachLayer(function(marker) {
                            if (marker.deptNum === previousDeptCode) {
                                marker.setOpacity(1);
                            }
                        });
                    }
                }

                let geoJson = currentGeoJSON;

                if (geoJson && geoJson.features && geoJson.features.length > 0) {
                    geoJson.features.forEach((feature, idx) => {
                        if (feature.properties.relationIndex === undefined) {
                            feature.properties.relationIndex = idx;
                        }
                    });

                    let colorIdx = 0;
                    window.circosLabelsLayer = L.layerGroup();

                    // Créer le layer GeoJSON pour les circonscriptions
                    window.circosLayer = L.geoJSON(geoJson, {
                        style: function(feature) {
                            const idx = feature.properties.relationIndex || 0;
                            const color = circoColors[idx % circoColors.length];
                            return {
                                color: 'white',
                                weight: 2,
                                opacity: 1,
                                fillColor: color,
                                fillOpacity: 0.6
                            };
                        },
                        onEachFeature: function(feature, layer) {
                            const idx = feature.properties.relationIndex || 0;
                            const circoNum = extractCircoNumber(feature.properties.name) || (idx + 1);

                            // Tag rond au centroïde réel du polygone (pas le centre de la bounding box)
                            const center = getPolygonCentroid(feature) || layer.getBounds().getCenter();
                            const marker = L.marker(center, {
                                icon: L.divIcon({
                                    className: 'circo-label',
                                    html: `<span class="circo-tag">${circoNum}</span>`,
                                    iconSize: null,
                                    iconAnchor: [0, 0]
                                }),
                                interactive: false
                            });
                            window.circosLabelsLayer.addLayer(marker);

                            // Pas de tooltip, juste hover effect
                            layer.on('mouseover', function() {
                                this.setStyle({ fillOpacity: 0.8 });
                            });
                            layer.on('mouseout', function() {
                                this.setStyle({ fillOpacity: 0.6 });
                            });
                        }
                    });

                    // D'abord modifier le style des départements
                    // IMPORTANT: Masquer complètement le département courant pour que les circonscriptions soient visibles
                    if (departementsLayer) {
                        departementsLayer.eachLayer(function(layer) {
                            const layerDeptNum = layer.feature?.properties?.numero_departement;
                            if (layerDeptNum === deptCode) {
                                // Département courant : MASQUER complètement (pas juste transparent)
                                // Car même avec fillOpacity 0, le path SVG peut masquer les couches en dessous
                                layer.setStyle({
                                    fillOpacity: 0,
                                    weight: 0,
                                    opacity: 0
                                });
                                if (layer._path) {
                                    layer._path.style.display = 'none';
                                }
                            } else {
                                // Autres départements : visibles et cliquables
                                layer.setStyle({
                                    fillOpacity: 0.5,
                                    weight: 2,
                                    opacity: 1
                                });
                                if (layer._path) {
                                    layer._path.style.pointerEvents = 'auto';
                                }
                            }
                        });
                    }

                    // Ajouter les couches des circonscriptions
                    window.circosLayer.addTo(leafletMap);
                    window.circosLabelsLayer.addTo(leafletMap);

                    // FORCER les circonscriptions au premier plan
                    window.circosLayer.bringToFront();

                    // Forcer la visibilité des paths SVG des circonscriptions
                    window.circosLayer.eachLayer(function(layer) {
                        if (layer._path) {
                            layer._path.style.visibility = 'visible';
                            layer._path.style.display = 'block';
                        }
                    });

                    // L'ordre des couches est maintenant géré par les panes personnalisés :
                    // regionsPane (z-index 400) < departementsPane (450) < circosPane (500)

                    // Remettre les labels au premier plan
                    window.circosLabelsLayer.eachLayer(function(marker) {
                        if (marker._icon) {
                            marker._icon.style.zIndex = 1000;
                        }
                    });

                    // Masquer les tags des autres départements (garder celui du département courant)
                    if (deptLabelsLayer) {
                        deptLabelsLayer.eachLayer(function(marker) {
                            if (marker.deptNum === deptCode) {
                                // Tag du département courant : visible et au premier plan
                                marker.setOpacity(1);
                                if (marker._icon) {
                                    marker._icon.style.zIndex = 1001;
                                }
                            } else {
                                // Autres départements : masquer le tag
                                marker.setOpacity(0);
                            }
                        });
                    }

                    // Zoomer sur le département
                    leafletMap.fitBounds(window.circosLayer.getBounds(), { padding: [20, 20] });

                    // Charger les cantons du département
                    loadCantonsLayer(deptCode);
                } else {
                    // Pas de GeoJSON - garder le département visible
                    console.warn('Pas de GeoJSON pour le département ' + deptCode);
                    // Zoomer sur le département même sans circonscriptions
                    if (departementsLayer) {
                        departementsLayer.eachLayer(function(layer) {
                            const layerDeptNum = layer.feature?.properties?.numero_departement;
                            if (layerDeptNum === deptCode) {
                                leafletMap.fitBounds(layer.getBounds(), { padding: [20, 20] });
                            }
                        });
                    }
                    // Charger les cantons même sans circonscriptions
                    loadCantonsLayer(deptCode);
                }

                loadingEl.style.display = 'none';

            } catch (error) {
                console.error('Erreur chargement département:', error);
                loadingEl.innerHTML = '<p>Erreur de chargement</p>';
            }
        }

        // Charger la couche des cantons d'un département
        async function loadCantonsLayer(deptCode) {
            try {
                const response = await fetch(`api_circonscriptions.php?action=getCantonsGeoJSON&dept=${deptCode}`);
                const data = await response.json();

                if (!data.success || !data.geojson || !data.geojson.features || data.geojson.features.length === 0) {
                    console.warn('Pas de cantons GeoJSON pour le département ' + deptCode);
                    return;
                }

                window.cantonsLabelsLayer = L.layerGroup();

                // Créer le layer GeoJSON pour les cantons - bordures pointillées, fond transparent
                window.cantonsLayer = L.geoJSON(data.geojson, {
                    pane: 'cantonsPane',
                    style: function(feature) {
                        return {
                            color: '#666',           // Couleur de la bordure
                            weight: 1.5,             // Épaisseur de la bordure
                            opacity: 0.7,            // Opacité de la bordure
                            dashArray: '8, 12',      // Bordure pointillée plus espacée
                            fillColor: 'transparent',
                            fillOpacity: 0           // Fond transparent
                        };
                    },
                    onEachFeature: function(feature, layer) {
                        const cantonNom = feature.properties.canton_nom || feature.properties.name || 'Canton';

                        // Tag au centroïde du canton
                        const center = getPolygonCentroid(feature) || layer.getBounds().getCenter();
                        const marker = L.marker(center, {
                            pane: 'cantonsPane',
                            icon: L.divIcon({
                                className: 'canton-label',
                                html: `<span class="canton-tag">${cantonNom}</span>`,
                                iconSize: null,
                                iconAnchor: [0, 0]
                            }),
                            interactive: false
                        });
                        window.cantonsLabelsLayer.addLayer(marker);

                        // Effet hover léger
                        layer.on('mouseover', function() {
                            this.setStyle({ weight: 2.5, opacity: 1 });
                        });
                        layer.on('mouseout', function() {
                            this.setStyle({ weight: 1.5, opacity: 0.7 });
                        });
                    }
                });

                // Ajouter les couches
                window.cantonsLayer.addTo(leafletMap);
                window.cantonsLabelsLayer.addTo(leafletMap);

                console.log('Cantons chargés:', data.geojson.features.length);

            } catch (error) {
                console.error('Erreur chargement cantons:', error);
            }
        }

        // Ajouter une légende
        function addLegend(features, deptNom) {
            // Supprimer l'ancienne légende si elle existe
            if (window.currentLegend) {
                leafletMap.removeControl(window.currentLegend);
            }

            const legend = L.control({ position: 'bottomright' });

            legend.onAdd = function(map) {
                const div = L.DomUtil.create('div', 'circo-legend');
                div.innerHTML = '<h4>Circonscriptions du<br><strong>' + deptNom.toUpperCase() + '</strong></h4>';

                features.forEach((feature, idx) => {
                    const fullName = feature.properties.name || '';
                    const shortNum = extractCircoNumber(fullName) || (idx + 1) + 'ème';
                    const color = circoColors[idx % circoColors.length];
                    div.innerHTML += '<div class="circo-legend-item"><div class="circo-legend-color" style="background:' + color + ';"></div><span>' + shortNum + '</span></div>';
                });

                return div;
            };

            legend.addTo(leafletMap);
            window.currentLegend = legend;
        }

        // Localiser une commune sur la carte
        async function locateCommune(communeName, deptCode, deptNom) {
            if (!leafletMap) return;

            try {
                const searchQuery = encodeURIComponent(communeName + ', ' + deptNom + ', France');
                const nominatimUrl = `https://nominatim.openstreetmap.org/search?q=${searchQuery}&format=json&limit=1&countrycodes=fr`;

                const [nominatimResponse, maireResponse] = await Promise.all([
                    fetch(nominatimUrl, { headers: { 'User-Agent': 'AnnuaireMaires/1.0' } }),
                    fetch(`api_circonscriptions.php?action=getMaireByCommune&commune=${encodeURIComponent(communeName)}&dept=${encodeURIComponent(deptCode)}`)
                ]);

                const results = await nominatimResponse.json();
                const maireData = await maireResponse.json();

                if (results && results.length > 0) {
                    const result = results[0];
                    const lat = parseFloat(result.lat);
                    const lon = parseFloat(result.lon);

                    if (leafletMarker) {
                        leafletMap.removeLayer(leafletMarker);
                    }

                    const redIcon = L.divIcon({
                        className: 'commune-marker',
                        html: '<div style="background:#dc3545; width:24px; height:24px; border-radius:50%; border:3px solid white; box-shadow:0 2px 8px rgba(0,0,0,0.4); display:flex; align-items:center; justify-content:center;"><i class="bi bi-geo-alt-fill" style="color:white; font-size:12px;"></i></div>',
                        iconSize: [24, 24],
                        iconAnchor: [12, 12],
                        popupAnchor: [0, -12]
                    });

                    leafletMarker = L.marker([lat, lon], { icon: redIcon }).addTo(leafletMap);

                    let popupContent = '<div style="min-width:200px;">';
                    popupContent += '<strong style="font-size:14px;">' + communeName + '</strong>';
                    popupContent += '<br><small style="color:#666;">' + deptNom + '</small>';

                    if (maireData.success && maireData.data) {
                        const data = maireData.data;
                        popupContent += '<hr style="margin:8px 0; border-color:#eee;">';

                        const nomMaire = data.nomPrenom || ((data.prenomMaire || '') + ' ' + (data.nomMaire || '')).trim();
                        if (nomMaire) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-person-fill" style="color:#0d6efd;"></i> <strong>' + nomMaire + '</strong></div>';
                        }

                        if (data.telephone) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-telephone-fill" style="color:#198754;"></i> <a href="tel:' + data.telephone + '">' + data.telephone + '</a></div>';
                        }

                        if (data.email) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-envelope-fill" style="color:#dc3545;"></i> <a href="mailto:' + data.email + '" style="font-size:12px;">' + data.email + '</a></div>';
                        }

                        if (data.nbHabitants) {
                            popupContent += '<div style="margin-bottom:4px;"><i class="bi bi-people-fill" style="color:#6c757d;"></i> ' + parseInt(data.nbHabitants).toLocaleString('fr-FR') + ' hab.</div>';
                        }
                    }

                    popupContent += '</div>';

                    leafletMarker.bindPopup(popupContent).openPopup();
                    leafletMap.setView([lat, lon], 10);
                }
            } catch (error) {
                console.error('Erreur localisation commune:', error);
            }
        }

        // Convertir les noms de circonscriptions en format court
        function shortenCircoName(name) {
            if (!name) return name;

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
                'douzième': '12ème', 'douzieme': '12ème'
            };

            let result = name;
            for (const [long, short] of Object.entries(ordinaux)) {
                const regex = new RegExp(long, 'gi');
                result = result.replace(regex, short);
            }
            result = result.replace(/circonscription de l'/gi, "circonscription l'");
            result = result.replace(/circonscription de /gi, 'circonscription ');
            return result;
        }

        // Extraire le numéro d'une circonscription (juste le chiffre)
        function extractCircoNumber(name) {
            if (!name) return null;
            const match = name.match(/(\d+)/);
            return match ? match[1] : null;
        }

        // Calculer le centroïde d'un polygone GeoJSON
        function getPolygonCentroid(feature) {
            if (!feature || !feature.geometry) return null;

            const geom = feature.geometry;
            let coords = [];

            // Extraire les coordonnées selon le type de géométrie
            if (geom.type === 'Polygon') {
                coords = geom.coordinates[0]; // Premier anneau (extérieur)
            } else if (geom.type === 'MultiPolygon') {
                // Pour MultiPolygon, trouver le plus grand polygone
                let maxArea = 0;
                let largestRing = null;

                geom.coordinates.forEach(polygon => {
                    const ring = polygon[0];
                    const area = Math.abs(calculatePolygonArea(ring));
                    if (area > maxArea) {
                        maxArea = area;
                        largestRing = ring;
                    }
                });

                if (largestRing) {
                    coords = largestRing;
                }
            }

            if (coords.length === 0) return null;

            // Calcul du centroïde (formule du centroïde d'un polygone)
            let signedArea = 0;
            let cx = 0;
            let cy = 0;

            for (let i = 0; i < coords.length - 1; i++) {
                const x0 = coords[i][0];
                const y0 = coords[i][1];
                const x1 = coords[i + 1][0];
                const y1 = coords[i + 1][1];

                const a = x0 * y1 - x1 * y0;
                signedArea += a;
                cx += (x0 + x1) * a;
                cy += (y0 + y1) * a;
            }

            signedArea *= 0.5;
            if (signedArea === 0) return null;

            cx = cx / (6 * signedArea);
            cy = cy / (6 * signedArea);

            return L.latLng(cy, cx); // Lat, Lng
        }

        // Calculer l'aire d'un polygone (pour trouver le plus grand)
        function calculatePolygonArea(ring) {
            let area = 0;
            for (let i = 0; i < ring.length - 1; i++) {
                area += ring[i][0] * ring[i + 1][1];
                area -= ring[i + 1][0] * ring[i][1];
            }
            return area / 2;
        }

        // Filtrer l'arbre de recherche
        function filterTree() {
            const search = document.getElementById('searchInput').value.toLowerCase().trim();
            const regions = document.querySelectorAll('.tree-region');

            if (search.length < 2) {
                // Afficher tout
                regions.forEach(region => {
                    region.style.display = '';
                    region.querySelectorAll('.tree-dept').forEach(dept => {
                        dept.style.display = '';
                    });
                });
                return;
            }

            regions.forEach(region => {
                const regionName = region.dataset.region.toLowerCase();
                let hasMatch = regionName.includes(search);

                region.querySelectorAll('.tree-dept').forEach(dept => {
                    const deptNum = dept.dataset.dept.toLowerCase();
                    const deptLabel = dept.querySelector('.tree-label').textContent.toLowerCase();

                    if (deptNum.includes(search) || deptLabel.includes(search)) {
                        dept.style.display = '';
                        hasMatch = true;
                    } else {
                        dept.style.display = 'none';
                    }
                });

                region.style.display = hasMatch ? '' : 'none';

                // Ouvrir la région si elle a des correspondances
                if (hasMatch && !regionName.includes(search)) {
                    const toggle = region.querySelector('.tree-toggle');
                    const children = region.querySelector('.tree-children');
                    if (toggle.classList.contains('collapsed')) {
                        toggle.classList.remove('collapsed');
                        if (children) children.classList.add('expanded');
                    }
                }
            });
        }

        // Toggle sidebar (mobile)
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
        }
    </script>
</body>
</html>
