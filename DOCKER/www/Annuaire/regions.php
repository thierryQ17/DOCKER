<?php
/**
 * Page d'affichage des cartes des regions et departements
 * Systeme similaire a circonscriptions.php mais pour Regions > Departements
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

// Charger les regions
$stmt = $pdo->query("
    SELECT r.*, COUNT(d.id) as nb_departements
    FROM regions r
    LEFT JOIN departements d ON d.region = r.nom_region
    GROUP BY r.id
    ORDER BY r.nom_region
");
$regionsData = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Charger les departements
$stmt = $pdo->query("SELECT * FROM departements ORDER BY numero_departement");
$departementsData = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Organiser par region
$deptsByRegion = [];
foreach ($departementsData as $dept) {
    $region = $dept['region'];
    if (!isset($deptsByRegion[$region])) {
        $deptsByRegion[$region] = [];
    }
    $deptsByRegion[$region][] = $dept;
}

// Diviser les regions en 2 colonnes
$mid = ceil(count($regionsData) / 2);
$regionsCol1 = array_slice($regionsData, 0, $mid);
$regionsCol2 = array_slice($regionsData, $mid);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cartes des Regions et Departements</title>
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
            background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%);
            border-radius: 12px;
            padding: 12px 20px;
            margin: 10px 15px;
            color: white;
            box-shadow: 0 4px 15px rgba(111, 66, 193, 0.3);
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

        .page-header .btn-back {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            margin-left: auto;
        }

        .page-header .btn-back:hover {
            background: rgba(255,255,255,0.3);
            color: white;
        }

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
            background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%);
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

        .region-header .btn-map {
            background: rgba(255,255,255,0.25);
            border: none;
            color: white;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            margin-left: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .region-header .btn-map:hover {
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
            padding: 10px;
            text-align: center;
            transition: all 0.2s ease;
            border: 1px solid #e9ecef;
            cursor: pointer;
        }

        .dept-card:hover {
            background: #e9ecef;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .dept-card .dept-code {
            font-weight: 700;
            color: #6f42c1;
            font-size: 18px;
            margin-bottom: 4px;
        }

        .dept-card .dept-name {
            font-size: 11px;
            color: #6c757d;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dept-card .dept-icon {
            font-size: 24px;
            color: #6f42c1;
            margin-bottom: 5px;
        }

        /* Modal */
        .modal-backdrop.show { opacity: 0.7; }

        .modal-content {
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%);
            color: white;
            border: none;
            padding: 12px 20px;
        }

        .modal-header .btn-close {
            filter: brightness(0) invert(1);
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
            width: 300px;
            min-width: 300px;
            background: white;
            border-right: 1px solid #e9ecef;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            max-height: 70vh;
        }

        .modal-map-container {
            flex: 1;
            position: relative;
            min-height: 70vh;
        }

        #regionMap, #deptMap {
            width: 100%;
            height: 100%;
            min-height: 70vh;
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
            color: #6f42c1;
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

        /* Departement dans l'arbre */
        .tree-dept > .tree-header {
            background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%);
            color: white;
            font-weight: 600;
            margin: 2px 8px;
            border-radius: 6px;
        }

        .tree-dept > .tree-header:hover {
            background: linear-gradient(135deg, #5a32a3 0%, #4a2593 100%);
        }

        .tree-dept > .tree-header .tree-toggle {
            color: white;
        }

        .tree-dept > .tree-header .tree-count {
            background: rgba(255,255,255,0.25);
            color: white;
        }

        .tree-dept-links {
            display: flex;
            gap: 6px;
            margin-left: auto;
        }

        .tree-dept-links a {
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

        .tree-dept-links a:hover {
            background: rgba(255,255,255,0.45);
            color: white;
        }

        /* Liens vers circonscriptions */
        .tree-dept-links .link-circo {
            background: rgba(23, 162, 184, 0.7);
        }

        .tree-dept-links .link-circo:hover {
            background: rgba(23, 162, 184, 1);
        }

        .tree-dept-links .link-osm {
            background: rgba(126, 188, 111, 0.7);
        }

        .tree-dept-links .link-osm:hover {
            background: rgba(126, 188, 111, 1);
        }

        /* Infos dans sidebar */
        .sidebar-info {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .sidebar-info h6 {
            color: #6f42c1;
            margin-bottom: 10px;
            font-size: 13px;
        }

        .sidebar-info .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            margin-bottom: 5px;
            color: #495057;
        }

        .sidebar-info .info-item i {
            color: #6f42c1;
            width: 16px;
        }

        /* Recherche */
        .search-box {
            padding: 10px 12px;
            border-bottom: 1px solid #e9ecef;
        }

        .search-box input {
            width: 100%;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 13px;
        }

        .search-box input:focus {
            outline: none;
            border-color: #6f42c1;
            box-shadow: 0 0 0 2px rgba(111, 66, 193, 0.1);
        }

        /* Legend */
        .map-legend {
            position: absolute;
            bottom: 20px;
            left: 20px;
            background: white;
            padding: 10px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
            z-index: 1000;
            font-size: 12px;
        }

        .map-legend h6 {
            margin: 0 0 8px 0;
            font-size: 12px;
            color: #6f42c1;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }

        .legend-color {
            width: 20px;
            height: 12px;
            border-radius: 2px;
            border: 1px solid rgba(0,0,0,0.2);
        }

        /* Loading */
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .loading-overlay .spinner-border {
            color: #6f42c1;
        }

        /* Bouton retour */
        .btn-back-map {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 1000;
            background: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #6f42c1;
            cursor: pointer;
        }

        .btn-back-map:hover {
            background: #f0f0f0;
        }

        .btn-back-map.hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="page-header d-flex align-items-center">
        <h1>
            <i class="bi bi-geo-alt-fill"></i>
            Carte des Regions et Departements
        </h1>
        <a href="circonscriptions.php" class="btn-back">
            <i class="bi bi-arrow-left"></i> Circonscriptions
        </a>
    </div>

    <div class="regions-container">
        <div class="region-column">
            <?php foreach ($regionsCol1 as $region): ?>
            <div class="region-block">
                <div class="region-header" onclick="toggleRegion(this)">
                    <div class="region-title">
                        <i class="bi bi-chevron-down toggle-icon"></i>
                        <i class="bi bi-geo-alt"></i>
                        <?= htmlspecialchars($region['nom_region']) ?>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="dept-count"><?= $region['nb_departements'] ?> depts</span>
                        <button class="btn-map" onclick="event.stopPropagation(); openRegionModal('<?= htmlspecialchars($region['nom_region']) ?>')">
                            <i class="bi bi-map"></i> Carte
                        </button>
                    </div>
                </div>
                <div class="region-content">
                    <?php if (isset($deptsByRegion[$region['nom_region']])): ?>
                        <?php foreach ($deptsByRegion[$region['nom_region']] as $dept): ?>
                        <div class="dept-card" onclick="openDeptInRegionModal('<?= htmlspecialchars($region['nom_region']) ?>', '<?= $dept['numero_departement'] ?>')">
                            <i class="bi bi-building dept-icon"></i>
                            <div class="dept-code"><?= $dept['numero_departement'] ?></div>
                            <div class="dept-name" title="<?= htmlspecialchars($dept['nom_departement']) ?>"><?= htmlspecialchars($dept['nom_departement']) ?></div>
                        </div>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </div>
            </div>
            <?php endforeach; ?>
        </div>

        <div class="region-column">
            <?php foreach ($regionsCol2 as $region): ?>
            <div class="region-block">
                <div class="region-header" onclick="toggleRegion(this)">
                    <div class="region-title">
                        <i class="bi bi-chevron-down toggle-icon"></i>
                        <i class="bi bi-geo-alt"></i>
                        <?= htmlspecialchars($region['nom_region']) ?>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="dept-count"><?= $region['nb_departements'] ?> depts</span>
                        <button class="btn-map" onclick="event.stopPropagation(); openRegionModal('<?= htmlspecialchars($region['nom_region']) ?>')">
                            <i class="bi bi-map"></i> Carte
                        </button>
                    </div>
                </div>
                <div class="region-content">
                    <?php if (isset($deptsByRegion[$region['nom_region']])): ?>
                        <?php foreach ($deptsByRegion[$region['nom_region']] as $dept): ?>
                        <div class="dept-card" onclick="openDeptInRegionModal('<?= htmlspecialchars($region['nom_region']) ?>', '<?= $dept['numero_departement'] ?>')">
                            <i class="bi bi-building dept-icon"></i>
                            <div class="dept-code"><?= $dept['numero_departement'] ?></div>
                            <div class="dept-name" title="<?= htmlspecialchars($dept['nom_departement']) ?>"><?= htmlspecialchars($dept['nom_departement']) ?></div>
                        </div>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>

    <!-- Modal Region -->
    <div class="modal fade modal-xl-custom" id="regionModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-geo-alt-fill me-2"></i>
                        <span id="regionModalTitle">Region</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body modal-body-with-sidebar">
                    <div class="modal-sidebar">
                        <div class="sidebar-info" id="regionInfo">
                            <h6><i class="bi bi-info-circle"></i> Informations</h6>
                            <div class="info-item">
                                <i class="bi bi-building"></i>
                                <span id="regionDeptCount">0 departements</span>
                            </div>
                        </div>
                        <div class="search-box">
                            <input type="text" id="searchDept" placeholder="Rechercher un departement..." oninput="filterDepartements()">
                        </div>
                        <div class="tree-root" id="deptTree">
                            <!-- Arbre des departements -->
                        </div>
                    </div>
                    <div class="modal-map-container">
                        <div id="regionMap"></div>
                        <button class="btn-back-map hidden" id="btnBackToRegion" onclick="backToRegionView()">
                            <i class="bi bi-arrow-left"></i> Retour a la region
                        </button>
                        <div class="loading-overlay" id="mapLoading">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Chargement...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // Donnees PHP converties en JS
        const deptsByRegion = <?= json_encode($deptsByRegion) ?>;

        let regionMap = null;
        let currentRegion = null;
        let currentDeptCode = null;
        let regionsLayer = null;
        let deptsLayer = null;
        let regionBounds = null;

        // Couleurs pour les departements
        const deptColors = [
            '#6f42c1', '#17a2b8', '#28a745', '#fd7e14', '#dc3545',
            '#20c997', '#6610f2', '#e83e8c', '#ffc107', '#007bff'
        ];

        function getDeptColor(index) {
            return deptColors[index % deptColors.length];
        }

        // Toggle region collapse
        function toggleRegion(header) {
            header.classList.toggle('collapsed');
            const content = header.nextElementSibling;
            content.classList.toggle('collapsed');
        }

        // Ouvrir modal region
        function openRegionModal(regionName) {
            currentRegion = regionName;
            currentDeptCode = null;
            document.getElementById('regionModalTitle').textContent = regionName.replace(/-/g, ' ');

            const modal = new bootstrap.Modal(document.getElementById('regionModal'));
            modal.show();

            // Initialiser la carte apres ouverture
            document.getElementById('regionModal').addEventListener('shown.bs.modal', function() {
                initRegionMap(regionName);
            }, { once: true });
        }

        // Ouvrir modal avec un departement specifique
        function openDeptInRegionModal(regionName, deptCode) {
            currentRegion = regionName;
            currentDeptCode = deptCode;
            document.getElementById('regionModalTitle').textContent = regionName.replace(/-/g, ' ');

            const modal = new bootstrap.Modal(document.getElementById('regionModal'));
            modal.show();

            document.getElementById('regionModal').addEventListener('shown.bs.modal', function() {
                initRegionMap(regionName, deptCode);
            }, { once: true });
        }

        // Initialiser la carte de la region
        async function initRegionMap(regionName, focusDeptCode = null) {
            const loading = document.getElementById('mapLoading');
            loading.style.display = 'flex';

            // Creer ou reinitialiser la carte
            if (regionMap) {
                regionMap.remove();
            }

            regionMap = L.map('regionMap').setView([46.603354, 1.888334], 6);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(regionMap);

            // Charger les departements de la region
            try {
                // Construire l'arbre des departements
                buildDeptTree(regionName);

                // Charger les geometries depuis Overpass
                const depts = deptsByRegion[regionName] || [];
                document.getElementById('regionDeptCount').textContent = depts.length + ' departements';

                if (depts.length > 0) {
                    const relationIds = depts.map(d => d.relation_osm).filter(id => id);

                    if (relationIds.length > 0) {
                        const geoJSON = await fetchOverpassGeoJSON(relationIds, depts);

                        if (geoJSON && geoJSON.features && geoJSON.features.length > 0) {
                            deptsLayer = L.geoJSON(geoJSON, {
                                style: function(feature) {
                                    const index = feature.properties.deptIndex || 0;
                                    return {
                                        fillColor: getDeptColor(index),
                                        weight: 2,
                                        opacity: 1,
                                        color: 'white',
                                        fillOpacity: 0.6
                                    };
                                },
                                onEachFeature: function(feature, layer) {
                                    const props = feature.properties;
                                    const popup = `
                                        <div style="text-align:center;">
                                            <strong style="color:#6f42c1;">${props.numero_departement} - ${props.nom_departement}</strong>
                                            <br><small>Cliquez pour voir les circonscriptions</small>
                                        </div>
                                    `;
                                    layer.bindPopup(popup);
                                    layer.on('click', function() {
                                        zoomToDept(props.numero_departement, props.nom_departement);
                                    });
                                    layer.on('mouseover', function() {
                                        layer.setStyle({ fillOpacity: 0.85 });
                                    });
                                    layer.on('mouseout', function() {
                                        layer.setStyle({ fillOpacity: 0.6 });
                                    });
                                }
                            }).addTo(regionMap);

                            regionBounds = deptsLayer.getBounds();
                            regionMap.fitBounds(regionBounds, { padding: [20, 20] });

                            // Si un departement specifique est demande
                            if (focusDeptCode) {
                                setTimeout(() => {
                                    highlightDept(focusDeptCode);
                                }, 500);
                            }
                        }
                    }
                }
            } catch (error) {
                console.error('Erreur chargement carte:', error);
            }

            loading.style.display = 'none';
        }

        // Fetch Overpass API
        async function fetchOverpassGeoJSON(relationIds, depts) {
            const query = `[out:json][timeout:120];
                (${relationIds.map(id => `relation(${id});`).join('')})
                out body;>;out skel qt;`;

            const response = await fetch('https://overpass-api.de/api/interpreter', {
                method: 'POST',
                body: 'data=' + encodeURIComponent(query),
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            });

            const data = await response.json();
            return convertToGeoJSON(data.elements, relationIds, depts);
        }

        // Convertir Overpass en GeoJSON
        function convertToGeoJSON(elements, relationIds, depts) {
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

                const mergedRings = mergeWaySegmentsToRings(outerRings);
                if (mergedRings.length === 0) return;

                // Trouver le departement correspondant
                const relIndex = relationIds.indexOf(String(el.id));
                const dept = depts[relIndex] || {};

                const geometry = mergedRings.length === 1
                    ? { type: 'Polygon', coordinates: [mergedRings[0]] }
                    : { type: 'MultiPolygon', coordinates: mergedRings.map(r => [r]) };

                features.push({
                    type: 'Feature',
                    properties: {
                        id: el.id,
                        name: el.tags?.name || dept.nom_departement || '',
                        numero_departement: dept.numero_departement || '',
                        nom_departement: dept.nom_departement || '',
                        deptIndex: relIndex
                    },
                    geometry: geometry
                });
            });

            return { type: 'FeatureCollection', features };
        }

        // Merge way segments
        function mergeWaySegmentsToRings(segments) {
            if (segments.length === 0) return [];
            if (segments.length === 1) {
                const ring = [...segments[0]];
                if (ring.length > 2 && !pointsEqual(ring[0], ring[ring.length - 1])) {
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
                    if (pointsEqual(ring[0], ring[ring.length - 1]) && ring.length > 3) break;

                    for (let i = 0; i < remaining.length; i++) {
                        const seg = remaining[i];
                        if (!seg || seg.length === 0) continue;

                        const first = ring[0];
                        const last = ring[ring.length - 1];
                        const segFirst = seg[0];
                        const segLast = seg[seg.length - 1];

                        if (pointsEqual(last, segFirst)) {
                            ring = ring.concat(seg.slice(1));
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (pointsEqual(last, segLast)) {
                            ring = ring.concat([...seg].reverse().slice(1));
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (pointsEqual(first, segLast)) {
                            ring = seg.slice(0, -1).concat(ring);
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        } else if (pointsEqual(first, segFirst)) {
                            ring = [...seg].reverse().slice(0, -1).concat(ring);
                            remaining.splice(i, 1);
                            changed = true;
                            break;
                        }
                    }
                }

                if (ring.length > 2) {
                    if (!pointsEqual(ring[0], ring[ring.length - 1])) {
                        ring.push(ring[0]);
                    }
                    rings.push(ring);
                }
            }

            return rings;
        }

        function pointsEqual(p1, p2, tolerance = 0.00001) {
            if (!p1 || !p2) return false;
            return Math.abs(p1[0] - p2[0]) < tolerance && Math.abs(p1[1] - p2[1]) < tolerance;
        }

        // Construire l'arbre des departements
        function buildDeptTree(regionName) {
            const container = document.getElementById('deptTree');
            const depts = deptsByRegion[regionName] || [];

            let html = '';
            depts.forEach((dept, index) => {
                const osmUrl = dept.url_openstreetmap || '';
                html += `
                    <div class="tree-node tree-dept" data-dept="${dept.numero_departement}">
                        <div class="tree-header" onclick="zoomToDept('${dept.numero_departement}', '${dept.nom_departement}')">
                            <span class="tree-icon"><i class="bi bi-building"></i></span>
                            <span class="tree-label">${dept.numero_departement} - ${dept.nom_departement}</span>
                            <div class="tree-dept-links">
                                <a href="circonscriptions.php#dept-${dept.numero_departement}" target="_blank" class="link-circo" title="Voir les circonscriptions">
                                    <i class="bi bi-diagram-3"></i>
                                </a>
                                ${osmUrl ? `<a href="${osmUrl}" target="_blank" class="link-osm" title="OpenStreetMap">
                                    <i class="bi bi-globe"></i>
                                </a>` : ''}
                            </div>
                        </div>
                    </div>
                `;
            });

            container.innerHTML = html;
        }

        // Zoom sur un departement
        function zoomToDept(deptCode, deptName) {
            if (!deptsLayer) return;

            deptsLayer.eachLayer(function(layer) {
                if (layer.feature.properties.numero_departement === deptCode) {
                    regionMap.fitBounds(layer.getBounds(), { padding: [50, 50] });
                    layer.openPopup();

                    // Afficher bouton retour
                    document.getElementById('btnBackToRegion').classList.remove('hidden');
                }
            });

            // Highlight dans l'arbre
            document.querySelectorAll('.tree-dept').forEach(el => {
                el.classList.remove('active');
                if (el.dataset.dept === deptCode) {
                    el.classList.add('active');
                }
            });
        }

        // Highlight departement
        function highlightDept(deptCode) {
            zoomToDept(deptCode);
        }

        // Retour a la vue region
        function backToRegionView() {
            if (regionBounds && regionMap) {
                regionMap.fitBounds(regionBounds, { padding: [20, 20] });
                document.getElementById('btnBackToRegion').classList.add('hidden');
                regionMap.closePopup();
            }
        }

        // Filtrer les departements
        function filterDepartements() {
            const search = document.getElementById('searchDept').value.toLowerCase();
            document.querySelectorAll('.tree-dept').forEach(el => {
                const text = el.textContent.toLowerCase();
                el.style.display = text.includes(search) ? 'block' : 'none';
            });
        }

        // Fermer modal - nettoyer carte
        document.getElementById('regionModal').addEventListener('hidden.bs.modal', function() {
            if (regionMap) {
                regionMap.remove();
                regionMap = null;
            }
            deptsLayer = null;
            regionBounds = null;
            document.getElementById('btnBackToRegion').classList.add('hidden');
        });
    </script>
</body>
</html>
