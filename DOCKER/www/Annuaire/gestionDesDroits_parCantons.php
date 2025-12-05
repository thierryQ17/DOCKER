<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

/**
 * Page de gestion des droits par canton
 * Arborescence: Régions > Départements > Circo > Cantons > Responsables
 */

// Configuration de la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Statistiques
$stats = $pdo->query("
    SELECT
        COUNT(DISTINCT region) as nb_regions,
        COUNT(DISTINCT numero_departement) as nb_departements,
        COUNT(DISTINCT circonscription) as nb_circos,
        COUNT(DISTINCT canton) as nb_cantons
    FROM maires
")->fetch(PDO::FETCH_ASSOC);

// Compter les responsables assignés
$statsResponsables = $pdo->query("
    SELECT COUNT(DISTINCT canton) as nb_cantons_avec_responsable
    FROM gestionDroitsCantons
    WHERE utilisateur_id IS NOT NULL
")->fetch(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Droits par Canton - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #17a2b8;
            --primary-dark: #138496;
            --responsable-color: #6f42c1;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
            padding-top: 100px;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
        }

        .main-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 10px 20px;
        }

        .tree-container {
            background: white;
            border-radius: 8px;
            padding: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .tree-node {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .tree-item {
            position: relative;
        }

        .tree-item-content {
            display: flex;
            align-items: flex-start;
            padding: 4px 8px;
            margin: 1px 0;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            gap: 6px;
        }

        .tree-item-content:hover {
            background: #f0f7ff;
        }

        .tree-toggle {
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 3px;
            background: #f0f0f0;
            transition: all 0.2s;
            flex-shrink: 0;
            font-size: 10px;
            margin-top: 2px;
        }

        .tree-toggle:hover {
            background: #e0e0e0;
        }

        .tree-toggle.expanded {
            transform: rotate(90deg);
        }

        .tree-toggle.no-children {
            visibility: hidden;
        }

        .tree-toggle.loading {
            background: var(--primary-color);
        }

        .tree-toggle.loading i {
            animation: spin 1s linear infinite;
            color: white;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .tree-icon {
            width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            font-size: 11px;
            flex-shrink: 0;
            margin-top: 0px;
        }

        .tree-icon.region { background: #e3f2fd; color: #1976d2; }
        .tree-icon.departement { background: #f3e5f5; color: #7b1fa2; }
        .tree-icon.circo { background: #fff3e0; color: #e65100; }
        .tree-icon.canton { background: #e8f5e9; color: #388e3c; }
        .tree-icon.domtom { background: #e8f5e9; color: #388e3c; }

        .tree-icon[onclick] {
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }

        .tree-icon[onclick]:hover {
            transform: scale(1.1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .tree-label {
            font-size: 12px;
            min-width: 120px;
            max-width: 250px;
        }

        .tree-badge {
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 8px;
            background: #f0f0f0;
            color: #666;
        }

        .tree-children {
            display: none;
            margin-left: 24px;
            padding-left: 10px;
            border-left: 1px solid #e0e0e0;
        }

        .tree-children.expanded {
            display: block;
        }

        /* Niveaux */
        .level-1 .tree-label { font-weight: 600; font-size: 14px; }
        .level-2 .tree-label { font-weight: 500; font-size: 13px; }
        .level-3 .tree-label { font-weight: 500; font-size: 12px; }
        .level-4 .tree-label { font-size: 12px; }

        /* Alternance couleurs */
        .tree-children .tree-item:nth-child(odd) > .tree-item-content {
            background-color: rgba(0, 0, 0, 0.02);
        }
        .tree-children .tree-item:nth-child(even) > .tree-item-content {
            background-color: rgba(23, 162, 184, 0.12);
        }
        .tree-children .tree-item:nth-child(odd) > .tree-item-content:hover {
            background-color: rgba(0, 0, 0, 0.06);
        }
        .tree-children .tree-item:nth-child(even) > .tree-item-content:hover {
            background-color: rgba(23, 162, 184, 0.22);
        }

        /* Colonne responsable */
        .right-text {
            width: 180px;
            padding: 4px 8px;
            font-size: 12px;
            text-align: left;
            color: #999;
            line-height: 1.4;
            margin-left: auto;
            flex-shrink: 0;
        }

        .right-text.filled {
            color: var(--responsable-color);
            font-weight: 500;
        }

        .loading-indicator {
            text-align: center;
            padding: 20px;
            color: #666;
        }

        /* Header des colonnes */
        .columns-header {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            background: white;
            font-weight: 600;
            font-size: 14px;
            position: fixed;
            top: 56px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1020;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 800px;
            width: calc(100% - 40px);
        }

        .columns-header .spacer {
            flex: 1;
            padding-left: 20px;
        }

        .columns-header .col-title {
            width: 180px;
            text-align: left;
            color: var(--responsable-color);
        }

        /* Autocomplete */
        .autocomplete-container {
            position: relative;
        }

        .autocomplete-results {
            position: fixed;
            max-height: 180px;
            overflow-y: auto;
            background: white;
            border: 1px solid #17a2b8;
            border-radius: 4px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.35);
            z-index: 99999;
            display: none;
        }

        .autocomplete-results.show {
            display: block;
        }

        .autocomplete-item {
            padding: 6px 10px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            font-size: 12px;
        }

        .autocomplete-item:hover {
            background: #e3f2fd;
        }

        /* Multi-select */
        .multi-select-container {
            display: flex;
            flex-wrap: wrap;
            gap: 2px;
            padding: 2px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            min-height: 26px;
            background: white;
            cursor: text;
            align-items: center;
        }

        .multi-select-container:focus-within {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.15);
        }

        .multi-select-tag {
            display: inline-flex;
            align-items: center;
            gap: 2px;
            padding: 1px 5px;
            background: rgba(111, 66, 193, 0.15);
            border-radius: 8px;
            font-size: 10px;
            color: var(--responsable-color);
            white-space: nowrap;
        }

        .multi-select-tag .remove-tag {
            cursor: pointer;
            font-weight: bold;
            font-size: 11px;
            opacity: 0.7;
        }

        .multi-select-tag .remove-tag:hover {
            opacity: 1;
        }

        .multi-select-input {
            flex: 1;
            min-width: 60px;
            border: none;
            outline: none;
            padding: 2px;
            font-size: 11px;
            background: transparent;
        }

        /* Modale */
        .modal-header {
            padding: 8px 12px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
        }

        .modal-title {
            font-size: 14px;
        }

        .modal-body {
            padding: 15px;
            max-height: 85vh;
            overflow-y: auto;
            overflow-x: visible;
        }

        /* Permettre à l'autocomplete de déborder du tableau */
        .modal-body table {
            overflow: visible;
        }
        .modal-body td {
            overflow: visible;
            position: relative;
        }

        .modal-footer {
            padding: 8px 12px;
        }

        /* Tableau modale */
        .modal-table {
            table-layout: fixed;
            width: 100%;
        }
        .modal-table th.col-canton,
        .modal-table td.col-canton {
            width: 200px;
        }
        .modal-table th.col-responsable,
        .modal-table td.col-responsable {
            width: auto;
        }

        .table-sm td, .table-sm th {
            padding: 4px 6px;
            font-size: 12px;
            vertical-align: middle;
        }

        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.02);
        }

        .table-striped tbody tr:nth-of-type(even) {
            background-color: rgba(23, 162, 184, 0.05);
        }

        .compact .multi-select-tag {
            padding: 0px 4px;
            font-size: 9px;
        }

        .compact .multi-select-input {
            min-width: 40px;
            padding: 1px;
            font-size: 10px;
        }

        .multi-select-container.compact {
            min-height: 22px;
            padding: 1px;
            gap: 1px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-geo-alt me-2"></i>Gestion des Droits par Canton
            </a>
        </div>
    </nav>

    <!-- Header des colonnes sticky -->
    <div class="columns-header">
        <div class="spacer">Régions / Départements / Circonscriptions / Cantons</div>
        <div class="col-title"><i class="bi bi-person-badge me-1"></i>Responsables</div>
    </div>

    <div class="main-container">
        <div class="tree-container">
            <ul id="treeRoot" class="tree-node">
                <li class="loading-indicator">
                    <i class="bi bi-arrow-repeat"></i> Chargement des régions...
                </li>
            </ul>
        </div>
    </div>

    <!-- Modale -->
    <div class="modal fade" id="rightsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rightsModalLabel">
                        <i class="bi bi-geo-alt me-2"></i>Gestion des responsables
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="modalContent"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Fermer</button>
                    <button type="button" class="btn btn-primary btn-sm" onclick="saveModalRights()">
                        <i class="bi bi-check-circle me-1"></i>Enregistrer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Variables globales
        const loadedNodes = new Set();
        const responsablesCache = {};
        let rightsModal = null;
        let currentModalType = null;
        let currentModalId = null;
        const multiSelectData = {};
        const autocompleteTimeouts = {};

        // Charger les régions
        async function loadRegions() {
            const response = await fetch('api.php?action=getRegions');
            const data = await response.json();
            return data.success ? data.regions : [];
        }

        // Charger les départements d'une région
        async function loadDepartements(region) {
            const response = await fetch(`api.php?action=getDepartementsByRegion&region=${encodeURIComponent(region)}`);
            const data = await response.json();
            return data.success ? data.departements : [];
        }

        // Charger les circonscriptions d'un département
        async function loadCircos(numeroDepartement) {
            const response = await fetch(`api.php?action=getCircosByDepartement&numero_departement=${encodeURIComponent(numeroDepartement)}`);
            const data = await response.json();
            return data.success ? data.circos : [];
        }

        // Charger les cantons d'une circonscription
        async function loadCantons(numeroDepartement, circo) {
            const response = await fetch(`api.php?action=getCantonsByCirco&numero_departement=${encodeURIComponent(numeroDepartement)}&circo=${encodeURIComponent(circo)}`);
            const data = await response.json();
            return data.success ? data.cantons : [];
        }

        // Charger les responsables par canton
        async function loadResponsables() {
            try {
                const response = await fetch('api.php?action=getGestionDroitsCantons');
                const data = await response.json();
                if (data.success && data.droits) {
                    data.droits.forEach(d => {
                        const key = `${d.numero_departement}_${d.canton}`;
                        responsablesCache[key] = {
                            responsable_ids: d.responsable_ids || '',
                            responsable: d.responsable || ''
                        };
                    });
                }
            } catch (error) {
                console.error('Erreur chargement responsables:', error);
            }
        }

        // Liste des régions DOM-TOM
        const DOMTOM_REGIONS = ['Guadeloupe', 'Guyane', 'La-Reunion', 'Martinique', 'Mayotte'];

        // Créer le HTML d'un noeud
        function createNodeHTML(type, data, level) {
            const hasChildren = type !== 'canton';
            let icon = 'bi-globe';
            let iconClass = 'region';
            let label = data.label || data;
            let nodeId = data.id || label;
            let badge = data.count || 0;

            switch(type) {
                case 'region':
                    icon = 'bi-globe';
                    iconClass = 'region';
                    break;
                case 'domtom':
                    icon = 'bi-tree';
                    iconClass = 'domtom';
                    break;
                case 'departement':
                    icon = 'bi-building';
                    iconClass = 'departement';
                    break;
                case 'circo':
                    icon = 'bi-signpost';
                    iconClass = 'circo';
                    break;
                case 'canton':
                    icon = 'bi-geo-alt';
                    iconClass = 'canton';
                    break;
            }

            let html = `<li class="tree-item level-${level}" data-type="${type}" data-id="${escapeHtml(nodeId)}" data-has-children="${hasChildren}">`;
            html += `<div class="tree-item-content" onclick="toggleNode(this, '${escapeHtml(nodeId)}', '${type}')">`;

            // Toggle
            if (hasChildren) {
                html += `<span class="tree-toggle"><i class="bi bi-chevron-right"></i></span>`;
            } else {
                html += `<span class="tree-toggle no-children"></span>`;
            }

            // Icône cliquable pour cantons
            if (type === 'canton') {
                const cantonKey = `${data.dept}_${data.label}`;
                const resp = responsablesCache[cantonKey] || {};
                html += `<span class="tree-icon ${iconClass}" onclick="event.stopPropagation(); openCantonModal('${escapeHtml(data.label)}', '${data.dept}')" style="cursor: pointer;" title="Gérer le responsable"><i class="bi ${icon}"></i></span>`;
                html += `<span class="tree-label">${escapeHtml(label)}</span>`;
                html += `<span class="right-text ${resp.responsable ? 'filled' : ''}">${formatResponsables(resp.responsable)}</span>`;
            } else if (type === 'circo') {
                html += `<span class="tree-icon ${iconClass}" onclick="event.stopPropagation(); openCircoModal('${escapeHtml(data.label)}', '${data.dept}')" style="cursor: pointer;" title="Gérer les responsables"><i class="bi ${icon}"></i></span>`;
                html += `<span class="tree-label">${escapeHtml(label)}</span>`;
                if (badge > 0) html += `<span class="tree-badge">${badge}</span>`;
            } else {
                html += `<span class="tree-icon ${iconClass}"><i class="bi ${icon}"></i></span>`;
                html += `<span class="tree-label">${escapeHtml(label)}</span>`;
                if (badge > 0) html += `<span class="tree-badge">${badge}</span>`;
            }

            html += '</div>';

            if (hasChildren) {
                html += '<ul class="tree-node tree-children"></ul>';
            }

            html += '</li>';
            return html;
        }

        // Échapper HTML
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Formater les responsables avec retour à la ligne
        function formatResponsables(names) {
            if (!names) return '-';
            const list = names.split(/[,;]/).map(n => n.trim()).filter(n => n);
            if (list.length === 0) return '-';
            return list.map(n => escapeHtml(n)).join('<br>');
        }

        // Formater le numéro de circonscription (1ere, 2e, 3e...)
        function formatCirco(num) {
            const n = parseInt(num);
            if (n === 1) return '1ère circo';
            return n + 'e circo';
        }

        // Toggle un noeud
        async function toggleNode(element, nodeId, type) {
            const toggle = element.querySelector('.tree-toggle');
            const childrenContainer = element.nextElementSibling;

            if (toggle.classList.contains('no-children')) return;
            if (toggle.classList.contains('loading')) return;

            const isExpanded = toggle.classList.contains('expanded');

            if (isExpanded) {
                toggle.classList.remove('expanded');
                if (childrenContainer) childrenContainer.classList.remove('expanded');
            } else {
                // Fermer les autres branches au même niveau
                const parentItem = element.closest('.tree-item');
                const parentContainer = parentItem ? parentItem.parentElement : document.getElementById('treeRoot');
                if (parentContainer) {
                    parentContainer.querySelectorAll(':scope > .tree-item > .tree-item-content .tree-toggle.expanded').forEach(otherToggle => {
                        if (otherToggle !== toggle) {
                            otherToggle.classList.remove('expanded');
                            const otherContent = otherToggle.closest('.tree-item-content');
                            const otherChildren = otherContent ? otherContent.nextElementSibling : null;
                            if (otherChildren && otherChildren.classList.contains('tree-children')) {
                                otherChildren.classList.remove('expanded');
                            }
                        }
                    });
                }

                const cacheKey = `${type}_${nodeId}`;
                if (!loadedNodes.has(cacheKey)) {
                    toggle.classList.add('loading');
                    toggle.innerHTML = '<i class="bi bi-arrow-repeat"></i>';

                    try {
                        let children = [];
                        const treeItem = element.closest('.tree-item');

                        if (type === 'region') {
                            const depts = await loadDepartements(nodeId);
                            children = depts.map(d => ({
                                type: 'departement',
                                data: { label: `${d.nom_departement} (${d.numero_departement})`, id: d.numero_departement, count: d.nb_circos, dept: d.numero_departement }
                            }));
                        } else if (type === 'domtom') {
                            // Charger les départements de toutes les régions DOM-TOM
                            let allDepts = [];
                            for (const region of DOMTOM_REGIONS) {
                                const depts = await loadDepartements(region);
                                allDepts = allDepts.concat(depts);
                            }
                            children = allDepts.map(d => ({
                                type: 'departement',
                                data: { label: `${d.nom_departement} (${d.numero_departement})`, id: d.numero_departement, count: d.nb_circos, dept: d.numero_departement }
                            }));
                        } else if (type === 'departement') {
                            const circos = await loadCircos(nodeId);
                            children = circos.map(c => ({
                                type: 'circo',
                                data: { label: formatCirco(c.circonscription), id: `${nodeId}_${c.circonscription}`, count: c.nb_cantons, dept: nodeId, circo: c.circonscription }
                            }));
                        } else if (type === 'circo') {
                            const parts = nodeId.split('_');
                            const dept = parts[0];
                            const circo = parts[1];
                            const cantons = await loadCantons(dept, circo);
                            children = cantons.map(c => ({
                                type: 'canton',
                                data: { label: c.canton, id: `${dept}_${c.canton}`, dept: dept }
                            }));
                        }

                        if (childrenContainer && children.length > 0) {
                            const level = parseInt(treeItem.className.match(/level-(\d+)/)?.[1] || 1) + 1;
                            childrenContainer.innerHTML = children.map(c => createNodeHTML(c.type, c.data, level)).join('');
                        }

                        loadedNodes.add(cacheKey);
                    } catch (error) {
                        console.error('Erreur chargement:', error);
                    }

                    toggle.classList.remove('loading');
                    toggle.innerHTML = '<i class="bi bi-chevron-right"></i>';
                }

                toggle.classList.add('expanded');
                if (childrenContainer) childrenContainer.classList.add('expanded');
            }
        }

        // Ouvrir modale canton
        function openCantonModal(canton, dept) {
            const modalTitle = document.getElementById('rightsModalLabel');
            const modalContent = document.getElementById('modalContent');

            currentModalType = 'canton';
            currentModalId = { canton, dept };

            modalTitle.innerHTML = `<i class="bi bi-geo-alt me-2" style="color: #388e3c;"></i>Responsable - ${canton}`;

            const cantonKey = `${dept}_${canton}`;
            const resp = responsablesCache[cantonKey] || {};

            let html = `<p class="text-muted mb-3">Assigner un responsable pour ce canton</p>`;
            html += `<div class="mb-3">`;
            html += `<label class="form-label" style="color: var(--responsable-color);"><i class="bi bi-person-badge me-1"></i>Responsable</label>`;
            html += `<div class="autocomplete-container">`;
            html += `<div class="multi-select-container" id="multiselect-responsable" data-role="responsable"></div>`;
            html += `<input type="hidden" id="modalResponsable" data-canton="${escapeHtml(canton)}" data-dept="${dept}" value="${escapeHtml(resp.responsable_ids || '')}">`;
            html += `<div class="autocomplete-results" id="autocomplete-responsable"></div>`;
            html += `</div></div>`;

            modalContent.innerHTML = html;

            // Initialiser le multi-select (type 4 = Membre)
            initMultiSelect('multiselect-responsable', 'modalResponsable', 'autocomplete-responsable', 4, resp.responsable_ids || '', resp.responsable || '');

            if (!rightsModal) {
                rightsModal = new bootstrap.Modal(document.getElementById('rightsModal'));
            }
            rightsModal.show();
        }

        // Ouvrir modale circo (tous les cantons)
        function openCircoModal(circoLabel, dept) {
            const modalTitle = document.getElementById('rightsModalLabel');
            const modalContent = document.getElementById('modalContent');

            currentModalType = 'circo';
            currentModalId = { circoLabel, dept };

            modalTitle.innerHTML = `<i class="bi bi-signpost me-2" style="color: #e65100;"></i>Responsables - ${circoLabel}`;

            let html = `<p class="text-muted mb-2" style="font-size: 12px;">Gérer les responsables pour tous les cantons de cette circonscription</p>`;
            html += `<div class="table-responsive"><table class="table table-sm table-striped mb-0 modal-table">`;
            html += `<thead><tr><th class="col-canton">Canton</th><th class="col-responsable" style="color: var(--responsable-color);"><i class="bi bi-trash" style="cursor: pointer; opacity: 0.6; float: left;" onclick="clearAllResponsables()" title="Vider toute la colonne"></i><span style="display: inline-block; text-align: center; width: calc(100% - 30px);">Responsable <i class="bi bi-people-fill" style="cursor: pointer;" onclick="copyFirstResponsableToAll()" title="Copier le 1er vers tous"></i></span></th></tr></thead>`;
            html += `<tbody id="modalTableBody"><tr><td colspan="2" class="text-center"><i class="bi bi-arrow-repeat"></i> Chargement...</td></tr></tbody>`;
            html += `</table></div>`;
            modalContent.innerHTML = html;

            // Charger les cantons
            loadCircoCantons(dept, circoLabel.replace('Circo ', ''));

            if (!rightsModal) {
                rightsModal = new bootstrap.Modal(document.getElementById('rightsModal'));
            }
            rightsModal.show();
        }

        // Charger les cantons d'une circo pour la modale
        async function loadCircoCantons(dept, circo) {
            const tableBody = document.getElementById('modalTableBody');
            try {
                const cantons = await loadCantons(dept, circo);
                let html = '';
                let rowIndex = 0;

                for (const c of cantons) {
                    const cantonKey = `${dept}_${c.canton}`;
                    const resp = responsablesCache[cantonKey] || {};

                    html += `<tr data-canton="${escapeHtml(c.canton)}" data-dept="${dept}">`;
                    html += `<td class="col-canton"><strong>${escapeHtml(c.canton)}</strong></td>`;
                    html += `<td class="col-responsable"><div class="autocomplete-container"><div class="multi-select-container compact" id="ms-resp-${rowIndex}" data-role="responsable"></div><input type="hidden" id="input-resp-${rowIndex}" data-canton="${escapeHtml(c.canton)}" data-dept="${dept}" value="${escapeHtml(resp.responsable_ids || '')}"><div class="autocomplete-results" id="ac-resp-${rowIndex}"></div></div></td>`;
                    html += `</tr>`;
                    rowIndex++;
                }

                tableBody.innerHTML = html || '<tr><td colspan="2" class="text-muted text-center">Aucun canton</td></tr>';

                // Initialiser les multi-select
                rowIndex = 0;
                for (const c of cantons) {
                    const cantonKey = `${dept}_${c.canton}`;
                    const resp = responsablesCache[cantonKey] || {};
                    // Type 5 = Référents + Membres actifs (tous les responsables possibles)
                    initMultiSelect(`ms-resp-${rowIndex}`, `input-resp-${rowIndex}`, `ac-resp-${rowIndex}`, 5, resp.responsable_ids || '', resp.responsable || '', true);
                    rowIndex++;
                }
            } catch (error) {
                console.error('Erreur:', error);
                tableBody.innerHTML = '<tr><td colspan="2" class="text-danger text-center">Erreur de chargement</td></tr>';
            }
        }

        // Initialiser multi-select
        function initMultiSelect(containerId, hiddenInputId, resultsId, userType, initialIds = '', initialNames = '', compact = false) {
            const container = document.getElementById(containerId);
            const hiddenInput = document.getElementById(hiddenInputId);
            const results = document.getElementById(resultsId);

            if (!container || !hiddenInput || !results) return;

            const input = document.createElement('input');
            input.type = 'text';
            input.className = 'multi-select-input';
            input.placeholder = compact ? '+' : 'Rechercher...';
            input.autocomplete = 'off';
            container.appendChild(input);

            let selectedUsers = [];

            if (initialIds && initialIds.trim()) {
                const ids = initialIds.split(/[,;]/).map(v => v.trim()).filter(v => v);
                const names = initialNames ? initialNames.split(/[,;]/).map(v => v.trim()).filter(v => v) : ids;
                ids.forEach((id, index) => {
                    selectedUsers.push({ id: id, name: names[index] || id });
                });
                renderTags();
            }

            multiSelectData[containerId] = { selectedUsers, hiddenInput, container };

            function renderTags() {
                container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());
                selectedUsers.forEach(user => {
                    const tag = document.createElement('span');
                    tag.className = 'multi-select-tag';
                    tag.dataset.id = user.id;
                    tag.innerHTML = `${escapeHtml(user.name)} <span class="remove-tag">×</span>`;
                    tag.querySelector('.remove-tag').addEventListener('click', function(e) {
                        e.stopPropagation();
                        removeUser(user.id);
                    });
                    container.insertBefore(tag, input);
                });
                hiddenInput.value = selectedUsers.map(u => u.id).join(', ');
                multiSelectData[containerId] = { selectedUsers: [...selectedUsers], hiddenInput, container };
            }

            function addUser(id, name) {
                if (id && !selectedUsers.find(u => u.id === String(id))) {
                    selectedUsers.push({ id: String(id), name: name });
                    renderTags();
                    input.value = '';
                }
            }

            function removeUser(id) {
                selectedUsers = selectedUsers.filter(u => u.id !== String(id));
                renderTags();
            }

            container.addEventListener('click', () => input.focus());

            input.addEventListener('input', function() {
                const query = this.value.trim();
                if (autocompleteTimeouts[containerId]) clearTimeout(autocompleteTimeouts[containerId]);
                autocompleteTimeouts[containerId] = setTimeout(() => {
                    searchUsers(query, userType, results, selectedUsers, addUser, container);
                }, 300);
            });

            input.addEventListener('focus', function() {
                searchUsers(this.value.trim(), userType, results, selectedUsers, addUser, container);
            });

            input.addEventListener('blur', function(e) {
                // Ne pas fermer si on clique dans la liste de résultats (scrollbar inclus)
                setTimeout(() => {
                    if (!results.matches(':hover')) {
                        results.classList.remove('show');
                    }
                }, 200);
            });

            // Fermer la liste quand on clique en dehors (mais pas sur la scrollbar)
            results.addEventListener('mouseleave', function() {
                if (document.activeElement !== input) {
                    results.classList.remove('show');
                }
            });

            input.addEventListener('keydown', function(e) {
                if (e.key === 'Backspace' && !this.value && selectedUsers.length > 0) {
                    removeUser(selectedUsers[selectedUsers.length - 1].id);
                }
            });
        }

        // Normaliser une chaîne (retirer les accents)
        function normalizeString(str) {
            return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
        }

        // Rechercher utilisateurs
        async function searchUsers(query, type, resultsContainer, selectedUsers, addCallback, inputContainer) {
            // Positionner la liste en fixed sous l'input
            if (inputContainer) {
                const rect = inputContainer.getBoundingClientRect();
                resultsContainer.style.top = (rect.bottom + 2) + 'px';
                resultsContainer.style.left = rect.left + 'px';
                resultsContainer.style.width = rect.width + 'px';
            }

            resultsContainer.innerHTML = '<div style="padding: 6px; text-align: center; color: #666; font-size: 10px;">Recherche...</div>';
            resultsContainer.classList.add('show');

            try {
                const response = await fetch(`api.php?action=searchUtilisateurs&type=${type}&q=${encodeURIComponent(query)}`);
                const data = await response.json();

                if (data.success && data.utilisateurs.length > 0) {
                    // Ne pas filtrer les utilisateurs déjà sélectionnés - permettre la multi-sélection
                    const selectedIds = selectedUsers.map(u => String(u.id));

                    // Normaliser la recherche pour ignorer les accents
                    const normalizedQuery = normalizeString(query);

                    // Filtrer les résultats en tenant compte des accents
                    let filteredUsers = data.utilisateurs.filter(u =>
                        normalizeString(u.value).includes(normalizedQuery)
                    );

                    // Trier par nom (avec gestion des accents)
                    filteredUsers.sort((a, b) => a.value.localeCompare(b.value, 'fr', { sensitivity: 'base' }));

                    if (filteredUsers.length > 0) {
                        resultsContainer.innerHTML = filteredUsers.map(u => {
                            // Marquer visuellement les utilisateurs déjà sélectionnés
                            const isSelected = selectedIds.includes(String(u.id));
                            const selectedStyle = isSelected ? ' style="opacity: 0.6; background-color: #e3f2fd;"' : '';
                            return `<div class="autocomplete-item" data-id="${u.id}" data-name="${escapeHtml(u.value)}"${selectedStyle}>${escapeHtml(u.value)}</div>`;
                        }).join('');

                        resultsContainer.querySelectorAll('.autocomplete-item').forEach(item => {
                            item.addEventListener('mousedown', function(e) {
                                e.preventDefault();
                                addCallback(this.dataset.id, this.dataset.name);
                                // Marquer visuellement l'élément comme sélectionné
                                this.style.opacity = '0.6';
                                this.style.backgroundColor = '#e3f2fd';
                            });
                        });
                    } else {
                        resultsContainer.innerHTML = '<div style="padding: 6px; text-align: center; color: #666; font-size: 10px;">Aucun utilisateur trouvé</div>';
                    }
                } else {
                    resultsContainer.innerHTML = '<div style="padding: 6px; text-align: center; color: #666; font-size: 10px;">Aucun résultat</div>';
                }
            } catch (error) {
                resultsContainer.innerHTML = '<div style="padding: 6px; text-align: center; color: #dc3545; font-size: 10px;">Erreur</div>';
            }
        }

        // Récupérer les noms depuis un conteneur
        function getNamesFromContainer(containerId) {
            const data = multiSelectData[containerId];
            if (data && data.selectedUsers) {
                return data.selectedUsers.map(u => u.name).join(', ');
            }
            return '';
        }

        // Copier le premier responsable vers tous les autres cantons
        function copyFirstResponsableToAll() {
            const firstContainerId = 'ms-resp-0';
            const firstData = multiSelectData[firstContainerId];

            if (!firstData || !firstData.selectedUsers || firstData.selectedUsers.length === 0) {
                alert('Aucun responsable dans le premier champ');
                return;
            }

            const sourceUsers = [...firstData.selectedUsers];
            let index = 1;
            let count = 0;

            while (true) {
                const containerId = `ms-resp-${index}`;
                const container = document.getElementById(containerId);

                if (!container) break;

                const hiddenInputId = `input-resp-${index}`;
                const hiddenInput = document.getElementById(hiddenInputId);

                if (hiddenInput) {
                    hiddenInput.value = sourceUsers.map(u => u.id).join(', ');

                    // Supprimer les tags existants
                    container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());

                    // Recréer les tags
                    const inputField = container.querySelector('.multi-select-input');

                    sourceUsers.forEach(user => {
                        const tag = document.createElement('span');
                        tag.className = 'multi-select-tag';
                        tag.dataset.id = user.id;
                        tag.innerHTML = `${escapeHtml(user.name)} <span class="remove-tag">×</span>`;
                        tag.querySelector('.remove-tag').addEventListener('click', function(e) {
                            e.stopPropagation();
                            tag.remove();
                            const currentIds = hiddenInput.value.split(/[,;]/).map(v => v.trim()).filter(v => v && v !== user.id);
                            hiddenInput.value = currentIds.join(', ');
                        });
                        container.insertBefore(tag, inputField);
                    });

                    multiSelectData[containerId] = {
                        selectedUsers: [...sourceUsers],
                        hiddenInput,
                        container
                    };

                    count++;
                }

                index++;
            }
        }

        // Vider tous les champs responsables
        function clearAllResponsables() {
            if (!confirm('Voulez-vous vraiment vider tous les champs "Responsable" ?')) {
                return;
            }

            let index = 0;
            let count = 0;

            while (true) {
                const containerId = `ms-resp-${index}`;
                const container = document.getElementById(containerId);

                if (!container) break;

                const hiddenInputId = `input-resp-${index}`;
                const hiddenInput = document.getElementById(hiddenInputId);

                if (hiddenInput) {
                    hiddenInput.value = '';
                    container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());

                    multiSelectData[containerId] = {
                        selectedUsers: [],
                        hiddenInput,
                        container
                    };

                    count++;
                }

                index++;
            }
        }

        // Rendu des tags pour un conteneur spécifique
        function renderTagsForContainer(containerId) {
            const data = multiSelectData[containerId];
            if (!data) return;

            const container = data.container;
            const input = container.querySelector('.multi-select-input');

            // Supprimer les anciens tags
            container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());

            // Créer les nouveaux tags
            data.selectedUsers.forEach(user => {
                const tag = document.createElement('span');
                tag.className = 'multi-select-tag';
                tag.dataset.id = user.id;
                tag.innerHTML = `${escapeHtml(user.name)} <span class="remove-tag">×</span>`;
                tag.querySelector('.remove-tag').addEventListener('click', function(e) {
                    e.stopPropagation();
                    data.selectedUsers = data.selectedUsers.filter(u => u.id !== user.id);
                    data.hiddenInput.value = data.selectedUsers.map(u => u.id).join(', ');
                    renderTagsForContainer(containerId);
                });
                container.insertBefore(tag, input);
            });
        }

        // Sauvegarder
        async function saveModalRights() {
            const saveBtn = document.querySelector('.modal-footer .btn-primary');
            saveBtn.disabled = true;
            saveBtn.innerHTML = '<i class="bi bi-arrow-repeat me-1"></i>Enregistrement...';

            try {
                if (currentModalType === 'canton') {
                    const { canton, dept } = currentModalId;
                    const ids = document.getElementById('modalResponsable')?.value || '';
                    const names = getNamesFromContainer('multiselect-responsable');
                    await saveResponsable(dept, canton, ids, names);
                    updateTreeDisplay(dept, canton, names);
                } else if (currentModalType === 'circo') {
                    const inputs = document.querySelectorAll('input[type="hidden"][data-canton][data-dept]');
                    for (const input of inputs) {
                        const canton = input.dataset.canton;
                        const dept = input.dataset.dept;
                        const ids = input.value;
                        const containerId = input.id.replace('input-', 'ms-');
                        const names = getNamesFromContainer(containerId);
                        await saveResponsable(dept, canton, ids, names);
                        updateTreeDisplay(dept, canton, names);
                    }
                }
                rightsModal.hide();
            } catch (error) {
                console.error('Erreur sauvegarde:', error);
                alert('Erreur lors de la sauvegarde');
            }

            saveBtn.disabled = false;
            saveBtn.innerHTML = '<i class="bi bi-check-circle me-1"></i>Enregistrer';
        }

        // Sauvegarder un responsable
        async function saveResponsable(dept, canton, ids, names) {
            const formData = new FormData();
            formData.append('action', 'saveGestionDroitsCanton');
            formData.append('numero_departement', dept);
            formData.append('canton', canton);
            formData.append('utilisateur_ids', ids);

            const response = await fetch('api.php', { method: 'POST', body: formData });
            const data = await response.json();

            if (data.success) {
                const key = `${dept}_${canton}`;
                responsablesCache[key] = { responsable_ids: ids, responsable: names };
            }
            return data;
        }

        // Mettre à jour l'affichage
        function updateTreeDisplay(dept, canton, names) {
            const cantonItem = document.querySelector(`.tree-item[data-id="${dept}_${canton}"]`);
            if (cantonItem) {
                const rightText = cantonItem.querySelector('.right-text');
                if (rightText) {
                    rightText.innerHTML = formatResponsables(names);
                    rightText.className = `right-text ${names ? 'filled' : ''}`;
                }
            }
        }

        // Initialisation
        async function init() {
            const treeRoot = document.getElementById('treeRoot');

            try {
                await loadResponsables();
                const allRegions = await loadRegions();

                // Séparer les régions métropolitaines des DOM-TOM
                const metropolitaines = [];
                const domtomRegions = [];

                allRegions.forEach(r => {
                    if (DOMTOM_REGIONS.includes(r.region)) {
                        domtomRegions.push(r);
                    } else {
                        metropolitaines.push(r);
                    }
                });

                let html = '';

                // Afficher les régions métropolitaines
                if (metropolitaines.length > 0) {
                    html += metropolitaines.map(r => createNodeHTML('region', { label: r.region, id: r.region, count: r.nb_departements }, 1)).join('');
                }

                // Ajouter le noeud DOM-TOM regroupé
                if (domtomRegions.length > 0) {
                    const totalDepts = domtomRegions.reduce((sum, r) => sum + parseInt(r.nb_departements), 0);
                    html += createNodeHTML('domtom', { label: 'DOM-TOM', id: 'DOMTOM', count: totalDepts }, 1);
                }

                if (html) {
                    treeRoot.innerHTML = html;
                } else {
                    treeRoot.innerHTML = '<li class="text-muted">Aucune région trouvée</li>';
                }
            } catch (error) {
                console.error('Erreur init:', error);
                treeRoot.innerHTML = '<li class="text-danger">Erreur de chargement</li>';
            }
        }

        // Fermer autocomplete sur clic externe
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.autocomplete-container')) {
                document.querySelectorAll('.autocomplete-results').forEach(r => r.classList.remove('show'));
            }
        });

        // Lancer
        init();
    </script>
</body>
</html>
