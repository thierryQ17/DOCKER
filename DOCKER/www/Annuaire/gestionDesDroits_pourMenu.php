<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

/**
 * Page de gestion des droits par département
 * Version avec arborescence - Les départements sont imbriqués dans les régions
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

// La table gestionAccesDepartements utilise une structure relationnelle
// Structure: id, departement_id (FK), utilisateur_id (FK), typeUtilisateur_id (FK)

// Compter le nombre d'éléments par type (statistiques)
$stats = $pdo->query("
    SELECT type_element, COUNT(*) as nb
    FROM arborescence
    WHERE niveau > 0 AND type_element IN ('region', 'departement')
    GROUP BY type_element
    ORDER BY FIELD(type_element, 'region', 'departement')
")->fetchAll(PDO::FETCH_KEY_PAIR);

// Compter les droits assignés par type (nouvelle structure relationnelle)
$statsRoles = $pdo->query("
    SELECT
        COUNT(DISTINCT CASE WHEN g.typeUtilisateur_id = 2 THEN CONCAT(g.departement_id, '-', g.utilisateur_id) END) as nb_admin,
        COUNT(DISTINCT CASE WHEN g.typeUtilisateur_id = 3 THEN CONCAT(g.departement_id, '-', g.utilisateur_id) END) as nb_referent,
        COUNT(DISTINCT CASE WHEN g.typeUtilisateur_id = 4 THEN CONCAT(g.departement_id, '-', g.utilisateur_id) END) as nb_membre
    FROM gestionAccesDepartements g
")->fetch(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Droits - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #17a2b8;
            --primary-dark: #138496;
            --admin-color: #dc3545;
            --referent-color: #fd7e14;
            --membre-color: #28a745;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
            padding-top: 100px; /* navbar (56px) + header (44px) */
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
            align-items: center;
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

        .tree-item-content.active {
            background: #e3f2fd;
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
        }

        .tree-icon.region { background: #e3f2fd; color: #1976d2; }
        .tree-icon.departement { background: #f3e5f5; color: #7b1fa2; }
        .tree-icon.domtom { background: #e8f5e9; color: #388e3c; }

        .tree-icon[onclick] {
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .tree-icon[onclick]:hover {
            transform: scale(1.1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .tree-label {
            flex: 1;
            font-size: 12px;
            min-width: 150px;
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
        .level-1 .tree-label { font-weight: 600; font-size: 15px; }
        .level-2 .tree-label { font-weight: 500; }

        /* Alternance couleurs des lignes départements */
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

        /* Colonnes de droits */
        .rights-columns {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            margin-left: auto;
        }

        .right-text {
            width: 150px;
            padding: 4px 8px;
            font-size: 12px;
            text-align: left;
            color: #999;
            line-height: 1.4;
        }

        .right-text.filled {
            color: #333;
            font-weight: 500;
        }

        .right-text.admin.filled {
            color: var(--admin-color);
        }

        .right-text.referent.filled {
            color: var(--referent-color);
        }

        .right-text.membre.filled {
            color: var(--membre-color);
        }

        .loading-indicator {
            text-align: center;
            padding: 20px;
            color: #666;
        }

        /* Header des colonnes - sticky sous la navbar */
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
            min-width: 280px;
            flex: 1;
            padding-left: 20px;
        }

        .columns-header .col-title {
            width: 150px;
            text-align: left;
            margin: 0 5px;
        }

        .columns-header .col-title.admin { color: var(--admin-color); }
        .columns-header .col-title.referent { color: var(--referent-color); }
        .columns-header .col-title.membre { color: var(--membre-color); }

        @media (max-width: 992px) {
            .right-text {
                width: 100px;
            }
            .columns-header .col-title {
                width: 100px;
            }
        }

        @media (max-width: 768px) {
            body {
                padding-top: 56px; /* juste navbar, header caché */
            }

            .main-container {
                padding: 10px;
            }

            .rights-columns {
                flex-direction: column;
                gap: 2px;
                margin-left: 0;
                margin-top: 5px;
            }

            .right-text {
                width: auto;
                text-align: left;
                font-size: 11px;
            }

            .tree-children {
                margin-left: 20px;
                padding-left: 10px;
            }

            .columns-header {
                display: none;
            }
        }

        /* Autocomplete styles */
        .autocomplete-container {
            position: relative;
        }

        .autocomplete-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            max-height: 180px;
            overflow-y: auto;
            background: white;
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 4px 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            z-index: 1070;
            display: none;
        }

        .autocomplete-results.show {
            display: block;
            animation: fadeIn 0.1s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-3px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .autocomplete-item {
            padding: 4px 8px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            font-size: 11px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .autocomplete-item:last-child {
            border-bottom: none;
        }

        .autocomplete-item:hover,
        .autocomplete-item.active {
            background: #e3f2fd;
        }

        .autocomplete-loading {
            padding: 6px;
            text-align: center;
            color: #666;
            font-size: 10px;
        }

        /* Styles pour sélection multiple avec tags */
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

        .multi-select-container.compact {
            min-height: 22px;
            padding: 1px;
            gap: 1px;
        }

        .multi-select-tag {
            display: inline-flex;
            align-items: center;
            gap: 2px;
            padding: 1px 5px;
            background: #e3f2fd;
            border-radius: 8px;
            font-size: 10px;
            color: #1976d2;
            white-space: nowrap;
        }

        .multi-select-tag.admin {
            background: rgba(220, 53, 69, 0.15);
            color: var(--admin-color);
        }

        .multi-select-tag.referent {
            background: rgba(253, 126, 20, 0.15);
            color: var(--referent-color);
        }

        .multi-select-tag.membre {
            background: rgba(40, 167, 69, 0.15);
            color: var(--membre-color);
        }

        .multi-select-tag .remove-tag {
            cursor: pointer;
            font-weight: bold;
            font-size: 11px;
            line-height: 1;
            opacity: 0.7;
            transition: opacity 0.2s;
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

        .multi-select-input::placeholder {
            color: #aaa;
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

        /* Tableau condensé dans la modale */
        .table-sm td, .table-sm th {
            padding: 4px 6px;
            font-size: 12px;
            vertical-align: middle;
        }

        .table-sm thead th {
            font-size: 11px;
            padding: 6px;
        }

        /* Alternance des couleurs de lignes */
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.02);
        }

        .table-striped tbody tr:nth-of-type(even) {
            background-color: rgba(23, 162, 184, 0.05);
        }

        /* Modale condensée */
        .modal-header {
            padding: 8px 12px;
        }

        .modal-title {
            font-size: 14px;
        }

        .modal-body {
            padding: 10px 12px;
            max-height: 70vh;
            overflow-y: auto;
        }

        .modal-footer {
            padding: 6px 12px;
        }

        .modal-footer .btn {
            padding: 4px 12px;
            font-size: 12px;
        }

        /* Largeurs fixes pour le tableau de la modale */
        .modal-table {
            table-layout: fixed;
            width: 100%;
        }
        .modal-table th.col-dept,
        .modal-table td.col-dept {
            width: 120px;
        }
        .modal-table th.col-admin,
        .modal-table td.col-admin,
        .modal-table th.col-referent,
        .modal-table td.col-referent,
        .modal-table th.col-membre,
        .modal-table td.col-membre {
            width: 200px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-shield-lock me-2"></i>Gestion des Droits pour le Menu
            </a>
        </div>
    </nav>

    <!-- Header des colonnes sticky -->
    <div class="columns-header">
        <div class="spacer">Région / Département</div>
        <div class="col-title admin"><i class="bi bi-person-badge me-1"></i>Admin</div>
        <div class="col-title referent"><i class="bi bi-person-gear me-1"></i>Référent</div>
        <div class="col-title membre"><i class="bi bi-person me-1"></i>Membre</div>
    </div>

    <div class="main-container">
        <!-- Conteneur de l'arbre -->
        <div class="tree-container">
            <!-- Arbre (chargé dynamiquement) -->
            <ul id="treeRoot" class="tree-node">
                <li class="loading-indicator">
                    <i class="bi bi-arrow-repeat"></i> Chargement des régions...
                </li>
            </ul>
        </div>
    </div>

    <!-- Modale de gestion des droits -->
    <div class="modal fade" id="rightsModal" tabindex="-1" aria-labelledby="rightsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rightsModalLabel">
                        <i class="bi bi-shield-lock me-2"></i>Gestion des droits
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
                </div>
                <div class="modal-body">
                    <div id="modalContent">
                        <!-- Contenu chargé dynamiquement -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                    <button type="button" class="btn btn-primary" onclick="saveModalRights()">
                        <i class="bi bi-check-circle me-1"></i>Enregistrer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Configuration des icônes par type
        const ICONS = {
            'region': 'bi-globe',
            'departement': 'bi-building',
            'domtom': 'bi-tree'
        };

        // Cache des noeuds déjà chargés
        const loadedNodes = new Set();

        // Cache des droits par département
        let droitsCache = {};

        // Charger les droits depuis l'API
        // Les droits sont indexés par numero_departement pour la compatibilité avec l'affichage
        async function loadDroits() {
            try {
                const response = await fetch('api.php?action=getGestionDroits');
                const data = await response.json();
                if (data.success && data.droits) {
                    data.droits.forEach(d => {
                        // Indexer par numero_departement pour l'affichage
                        droitsCache[d.numero_departement] = d;
                    });
                }
            } catch (error) {
                console.error('Erreur chargement droits:', error);
            }
        }

        // Charger les enfants d'un noeud via l'API
        async function loadChildren(parentId = 0) {
            const url = parentId === 0
                ? 'api.php?action=getArborescenceChildren&parent_id=0'
                : `api.php?action=getArborescenceChildren&parent_id=${parentId}`;

            const response = await fetch(url);
            const data = await response.json();

            if (data.success) {
                return data.children;
            }
            return [];
        }

        // Extraire le numéro de département du libellé
        function extractDeptNumber(libelle) {
            // Format: "Ain (01)" ou "01 - Ain"
            const match1 = libelle.match(/\((\d{2,3}[A-B]?)\)$/);
            if (match1) return match1[1];

            const match2 = libelle.match(/^(\d{2,3}[A-B]?)\s*-/);
            if (match2) return match2[1];

            return null;
        }

        // Créer le HTML d'un noeud
        function createNodeHTML(node) {
            const hasChildren = parseInt(node.nb_enfants) > 0;
            const icon = ICONS[node.type_element] || 'bi-folder';
            const level = node.niveau;
            const isDepartement = node.type_element === 'departement';

            // Extraire le numéro de département
            const deptNumber = isDepartement ? extractDeptNumber(node.libelle) : null;
            const droits = deptNumber ? (droitsCache[deptNumber] || {}) : {};

            const isRegion = node.type_element === 'region' || node.type_element === 'domtom';

            let html = `<li class="tree-item level-${level}" data-id="${node.id}" data-type="${node.type_element}" data-label="${escapeHtml(node.libelle.toLowerCase())}" data-has-children="${hasChildren}" ${deptNumber ? `data-dept="${deptNumber}"` : ''}>`;
            html += `<div class="tree-item-content" ${!isDepartement ? `onclick="toggleNode(this, ${node.id})"` : ''}>`;

            // 1. Flèche (toggle) en premier
            if (!isDepartement) {
                html += `<span class="tree-toggle ${hasChildren ? '' : 'no-children'}"><i class="bi bi-chevron-right"></i></span>`;
            } else {
                html += `<span class="tree-toggle no-children"></span>`;
            }

            // 2. Icône cliquable pour ouvrir la modale (régions et départements)
            if (isRegion) {
                html += `<span class="tree-icon ${node.type_element}" onclick="event.stopPropagation(); openRightsModal('${escapeHtml(node.libelle)}', ${node.id}, 'region')" style="cursor: pointer;" title="Gérer les droits"><i class="bi ${icon}"></i></span>`;
            } else if (isDepartement && deptNumber) {
                html += `<span class="tree-icon ${node.type_element}" onclick="event.stopPropagation(); openRightsModal('${escapeHtml(node.libelle)}', '${deptNumber}', 'departement')" style="cursor: pointer;" title="Gérer les droits"><i class="bi ${icon}"></i></span>`;
            } else {
                html += `<span class="tree-icon ${node.type_element}"><i class="bi ${icon}"></i></span>`;
            }
            html += `<span class="tree-label">${escapeHtml(node.libelle)}</span>`;

            if (hasChildren && !isDepartement) {
                html += `<span class="tree-badge">${parseInt(node.nb_enfants).toLocaleString('fr-FR')}</span>`;
            }

            // Ajouter les colonnes de droits pour les départements (texte seulement)
            if (isDepartement && deptNumber) {
                html += `<div class="rights-columns">`;
                html += `<span class="right-text admin ${droits.admin ? 'filled' : ''}">${formatRightsMultiline(droits.admin)}</span>`;
                html += `<span class="right-text referent ${droits.referent ? 'filled' : ''}">${formatRightsMultiline(droits.referent)}</span>`;
                html += `<span class="right-text membre ${droits.membre ? 'filled' : ''}">${formatRightsMultiline(droits.membre)}</span>`;
                html += `</div>`;
            }

            html += '</div>';

            if (hasChildren && !isDepartement) {
                html += '<ul class="tree-node tree-children"></ul>';
            }
            html += '</li>';

            return html;
        }

        // Échapper les caractères HTML
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Formater les droits avec retour à la ligne pour plusieurs personnes
        function formatRightsMultiline(value) {
            if (!value || value.trim() === '') return '-';
            // Séparer par virgule ou point-virgule
            const persons = value.split(/[,;]/).map(v => v.trim()).filter(v => v);
            if (persons.length === 0) return '-';
            if (persons.length === 1) return escapeHtml(persons[0]);
            // Plusieurs personnes : retour à la ligne
            return persons.map(p => escapeHtml(p)).join('<br>');
        }

        // Toggle d'un noeud (avec chargement asynchrone)
        async function toggleNode(element, nodeId) {
            const toggle = element.querySelector('.tree-toggle');
            const childrenContainer = element.nextElementSibling;

            if (toggle.classList.contains('no-children')) return;
            if (toggle.classList.contains('loading')) return;

            const isExpanded = toggle.classList.contains('expanded');

            if (isExpanded) {
                toggle.classList.remove('expanded');
                if (childrenContainer) {
                    childrenContainer.classList.remove('expanded');
                }
            } else {
                // Fermer les autres branches au même niveau (frères/sœurs)
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
                if (!loadedNodes.has(nodeId)) {
                    toggle.classList.add('loading');
                    toggle.innerHTML = '<i class="bi bi-arrow-repeat"></i>';

                    try {
                        const children = await loadChildren(nodeId);

                        if (childrenContainer && children.length > 0) {
                            childrenContainer.innerHTML = children.map(createNodeHTML).join('');
                        }

                        loadedNodes.add(nodeId);
                    } catch (error) {
                        console.error('Erreur chargement:', error);
                    }

                    toggle.classList.remove('loading');
                    toggle.innerHTML = '<i class="bi bi-chevron-right"></i>';
                }

                toggle.classList.add('expanded');
                if (childrenContainer) {
                    childrenContainer.classList.add('expanded');
                }
            }
        }

        // Variables pour la modale
        let currentModalType = null;
        let currentModalId = null;
        let rightsModal = null;

        // Ouvrir la modale de gestion des droits
        async function openRightsModal(label, id, type) {
            currentModalType = type;
            currentModalId = id;

            const modalTitle = document.getElementById('rightsModalLabel');
            const modalContent = document.getElementById('modalContent');

            if (type === 'region') {
                modalTitle.innerHTML = `<i class="bi bi-globe me-2" style="color: #1976d2;"></i>Droits - ${label}`;

                // Charger les départements de la région
                if (!loadedNodes.has(id)) {
                    const children = await loadChildren(id);
                    // Stocker temporairement
                    modalContent.dataset.children = JSON.stringify(children);
                } else {
                    // Récupérer depuis le DOM
                    const regionItem = document.querySelector(`.tree-item[data-id="${id}"]`);
                    const childrenContainer = regionItem?.querySelector('.tree-children');
                    if (childrenContainer) {
                        const depts = [];
                        childrenContainer.querySelectorAll('.tree-item[data-type="departement"]').forEach(item => {
                            const deptNum = item.dataset.dept;
                            const labelEl = item.querySelector('.tree-label');
                            if (deptNum && labelEl) {
                                depts.push({ numero: deptNum, libelle: labelEl.textContent });
                            }
                        });
                        modalContent.dataset.children = JSON.stringify(depts);
                    }
                }

                // Générer le contenu pour la région
                let html = `<p class="text-muted mb-2" style="font-size: 12px;">Gérer les droits pour tous les départements de la région</p>`;
                html += `<div class="table-responsive"><table class="table table-sm table-striped mb-0 modal-table">`;
                html += `<thead><tr><th class="col-dept">Département</th><th class="col-admin" style="color: var(--admin-color);"><i class="bi bi-trash" style="cursor: pointer; opacity: 0.6; float: left;" onclick="clearAllColumn('admin')" title="Vider toute la colonne"></i><span style="display: inline-block; text-align: center; width: calc(100% - 30px);">Admin <i class="bi bi-people-fill" style="cursor: pointer;" onclick="copyFirstToAll('admin')" title="Copier le 1er vers tous"></i></span></th><th class="col-referent" style="color: var(--referent-color);"><i class="bi bi-trash" style="cursor: pointer; opacity: 0.6; float: left;" onclick="clearAllColumn('referent')" title="Vider toute la colonne"></i><span style="display: inline-block; text-align: center; width: calc(100% - 30px);">Référent <i class="bi bi-people-fill" style="cursor: pointer;" onclick="copyFirstToAll('referent')" title="Copier le 1er vers tous"></i></span></th><th class="col-membre" style="color: var(--membre-color);"><i class="bi bi-trash" style="cursor: pointer; opacity: 0.6; float: left;" onclick="clearAllColumn('membre')" title="Vider toute la colonne"></i><span style="display: inline-block; text-align: center; width: calc(100% - 30px);">Membre <i class="bi bi-people-fill" style="cursor: pointer;" onclick="copyFirstToAll('membre')" title="Copier le 1er vers tous"></i></span></th></tr></thead>`;
                html += `<tbody id="modalTableBody"><tr><td colspan="4" class="text-center"><i class="bi bi-arrow-repeat"></i> Chargement...</td></tr></tbody>`;
                html += `</table></div>`;
                modalContent.innerHTML = html;

                // Charger les données
                loadRegionDepartments(id);

            } else if (type === 'departement') {
                const deptNum = id;
                const droits = droitsCache[deptNum] || {};

                modalTitle.innerHTML = `<i class="bi bi-building me-2" style="color: #7b1fa2;"></i>Droits - ${label}`;

                // Hidden input stocke les IDs, l'affichage montre les noms
                let html = `<p class="text-muted mb-3">Gérer les droits pour ce département (sélection multiple)</p>`;
                html += `<div class="mb-3">`;
                html += `<label class="form-label" style="color: var(--admin-color);"><i class="bi bi-person-badge me-1"></i>Admin</label>`;
                html += `<div class="autocomplete-container">`;
                html += `<div class="multi-select-container" id="multiselect-admin" data-role="admin"></div>`;
                html += `<input type="hidden" id="modalAdmin" data-dept="${deptNum}" data-role="admin" value="${escapeHtml(droits.admin_ids || '')}">`;
                html += `<div class="autocomplete-results" id="autocomplete-admin"></div>`;
                html += `</div></div>`;
                html += `<div class="mb-3">`;
                html += `<label class="form-label" style="color: var(--referent-color);"><i class="bi bi-person-gear me-1"></i>Référent</label>`;
                html += `<div class="autocomplete-container">`;
                html += `<div class="multi-select-container" id="multiselect-referent" data-role="referent"></div>`;
                html += `<input type="hidden" id="modalReferent" data-dept="${deptNum}" data-role="referent" value="${escapeHtml(droits.referent_ids || '')}">`;
                html += `<div class="autocomplete-results" id="autocomplete-referent"></div>`;
                html += `</div></div>`;
                html += `<div class="mb-3">`;
                html += `<label class="form-label" style="color: var(--membre-color);"><i class="bi bi-person me-1"></i>Membre</label>`;
                html += `<div class="autocomplete-container">`;
                html += `<div class="multi-select-container" id="multiselect-membre" data-role="membre"></div>`;
                html += `<input type="hidden" id="modalMembre" data-dept="${deptNum}" data-role="membre" value="${escapeHtml(droits.membre_ids || '')}">`;
                html += `<div class="autocomplete-results" id="autocomplete-membre"></div>`;
                html += `</div></div>`;
                modalContent.innerHTML = html;

                // Initialiser le multi-select pour chaque champ (IDs + noms)
                initMultiSelect('multiselect-admin', 'modalAdmin', 'autocomplete-admin', 2, droits.admin_ids || '', droits.admin || '');
                initMultiSelect('multiselect-referent', 'modalReferent', 'autocomplete-referent', 3, droits.referent_ids || '', droits.referent || '');
                initMultiSelect('multiselect-membre', 'modalMembre', 'autocomplete-membre', 4, droits.membre_ids || '', droits.membre || '');
            }

            // Ouvrir la modale
            if (!rightsModal) {
                rightsModal = new bootstrap.Modal(document.getElementById('rightsModal'));
            }
            rightsModal.show();
        }

        // Charger les départements d'une région dans la modale
        async function loadRegionDepartments(regionId) {
            const tableBody = document.getElementById('modalTableBody');
            if (!tableBody) return;

            try {
                const children = await loadChildren(regionId);
                let html = '';

                let rowIndex = 0;
                const deptData = []; // Stocker les données pour initialisation
                for (const child of children) {
                    if (child.type_element === 'departement') {
                        const deptNum = extractDeptNumber(child.libelle);
                        if (deptNum) {
                            const droits = droitsCache[deptNum] || {};
                            deptData.push({ deptNum, droits, rowIndex });
                            html += `<tr data-dept="${deptNum}">`;
                            html += `<td class="col-dept"><strong>${child.libelle}</strong></td>`;
                            // Les hidden inputs stockent les IDs
                            html += `<td class="col-admin"><div class="autocomplete-container"><div class="multi-select-container compact" id="ms-admin-${rowIndex}" data-role="admin" data-dept="${deptNum}"></div><input type="hidden" id="input-admin-${rowIndex}" data-dept="${deptNum}" data-role="admin" value="${escapeHtml(droits.admin_ids || '')}"><div class="autocomplete-results" id="ac-admin-${rowIndex}"></div></div></td>`;
                            html += `<td class="col-referent"><div class="autocomplete-container"><div class="multi-select-container compact" id="ms-referent-${rowIndex}" data-role="referent" data-dept="${deptNum}"></div><input type="hidden" id="input-referent-${rowIndex}" data-dept="${deptNum}" data-role="referent" value="${escapeHtml(droits.referent_ids || '')}"><div class="autocomplete-results" id="ac-referent-${rowIndex}"></div></div></td>`;
                            html += `<td class="col-membre"><div class="autocomplete-container"><div class="multi-select-container compact" id="ms-membre-${rowIndex}" data-role="membre" data-dept="${deptNum}"></div><input type="hidden" id="input-membre-${rowIndex}" data-dept="${deptNum}" data-role="membre" value="${escapeHtml(droits.membre_ids || '')}"><div class="autocomplete-results" id="ac-membre-${rowIndex}"></div></div></td>`;
                            html += `</tr>`;
                            rowIndex++;
                        }
                    }
                }

                tableBody.innerHTML = html || '<tr><td colspan="4" class="text-muted text-center">Aucun département</td></tr>';

                // Initialiser le multi-select pour tous les champs du tableau (IDs + noms)
                for (const { deptNum, droits, rowIndex: i } of deptData) {
                    initMultiSelect(`ms-admin-${i}`, `input-admin-${i}`, `ac-admin-${i}`, 2, droits.admin_ids || '', droits.admin || '', true);
                    initMultiSelect(`ms-referent-${i}`, `input-referent-${i}`, `ac-referent-${i}`, 3, droits.referent_ids || '', droits.referent || '', true);
                    initMultiSelect(`ms-membre-${i}`, `input-membre-${i}`, `ac-membre-${i}`, 4, droits.membre_ids || '', droits.membre || '', true);
                }
            } catch (error) {
                console.error('Erreur chargement départements:', error);
                tableBody.innerHTML = '<tr><td colspan="4" class="text-danger text-center">Erreur de chargement</td></tr>';
            }
        }

        // Copier les valeurs du premier champ vers tous les autres champs de la même colonne
        function copyFirstToAll(role) {
            // Trouver le premier conteneur de cette colonne qui a des données
            const firstContainerId = `ms-${role}-0`;
            const firstData = multiSelectData[firstContainerId];

            if (!firstData || !firstData.selectedUsers || firstData.selectedUsers.length === 0) {
                alert(`Aucune valeur dans le premier champ ${role}`);
                return;
            }

            // Copier les utilisateurs du premier champ
            const sourceUsers = [...firstData.selectedUsers];

            // Trouver tous les conteneurs de cette colonne (ms-role-0, ms-role-1, ...)
            let index = 1;
            let count = 0;

            while (true) {
                const containerId = `ms-${role}-${index}`;
                const container = document.getElementById(containerId);

                if (!container) break;

                const hiddenInputId = `input-${role}-${index}`;
                const hiddenInput = document.getElementById(hiddenInputId);

                if (hiddenInput) {
                    // Mettre à jour le hidden input avec les IDs
                    hiddenInput.value = sourceUsers.map(u => u.id).join(', ');

                    // Supprimer les tags existants
                    container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());

                    // Recréer les tags
                    const inputField = container.querySelector('.multi-select-input');
                    const roleClass = container.dataset.role || role;

                    sourceUsers.forEach(user => {
                        const tag = document.createElement('span');
                        tag.className = `multi-select-tag ${roleClass}`;
                        tag.dataset.id = user.id;
                        tag.innerHTML = `${escapeHtml(user.name)} <span class="remove-tag">×</span>`;
                        tag.querySelector('.remove-tag').addEventListener('click', function(e) {
                            e.stopPropagation();
                            tag.remove();
                            // Mettre à jour le hidden input
                            const currentIds = hiddenInput.value.split(/[,;]/).map(v => v.trim()).filter(v => v && v !== user.id);
                            hiddenInput.value = currentIds.join(', ');
                        });
                        container.insertBefore(tag, inputField);
                    });

                    // Mettre à jour le cache
                    multiSelectData[containerId] = {
                        selectedUsers: [...sourceUsers],
                        hiddenInput,
                        container,
                        role: roleClass
                    };

                    count++;
                }

                index++;
            }

            console.log(`✅ Valeurs copiées vers ${count} champ(s) ${role}`);
        }

        // Vider tous les champs d'une colonne
        function clearAllColumn(role) {
            if (!confirm(`Voulez-vous vraiment vider tous les champs "${role}" ?`)) {
                return;
            }

            let index = 0;
            let count = 0;

            while (true) {
                const containerId = `ms-${role}-${index}`;
                const container = document.getElementById(containerId);

                if (!container) break;

                const hiddenInputId = `input-${role}-${index}`;
                const hiddenInput = document.getElementById(hiddenInputId);

                if (hiddenInput) {
                    // Vider le hidden input
                    hiddenInput.value = '';

                    // Supprimer tous les tags
                    container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());

                    // Mettre à jour le cache
                    multiSelectData[containerId] = {
                        selectedUsers: [],
                        hiddenInput,
                        container,
                        role: container.dataset.role || role
                    };

                    count++;
                }

                index++;
            }

            console.log(`🗑️ ${count} champ(s) ${role} vidé(s)`);
        }

        // Récupérer les noms depuis un conteneur multi-select
        function getNamesFromContainer(containerId) {
            const data = multiSelectData[containerId];
            if (data && data.selectedUsers) {
                return data.selectedUsers.map(u => u.name).join(', ');
            }
            return '';
        }

        // Sauvegarder les droits depuis la modale
        async function saveModalRights() {
            const saveBtn = document.querySelector('.modal-footer .btn-primary');
            saveBtn.disabled = true;
            saveBtn.innerHTML = '<i class="bi bi-arrow-repeat me-1"></i>Enregistrement...';

            try {
                if (currentModalType === 'departement') {
                    const deptNum = currentModalId;
                    const adminIds = document.getElementById('modalAdmin')?.value || '';
                    const referentIds = document.getElementById('modalReferent')?.value || '';
                    const membreIds = document.getElementById('modalMembre')?.value || '';

                    // Récupérer les noms depuis les conteneurs
                    const adminNames = getNamesFromContainer('multiselect-admin');
                    const referentNames = getNamesFromContainer('multiselect-referent');
                    const membreNames = getNamesFromContainer('multiselect-membre');

                    await saveRight(deptNum, 'admin', adminIds, adminNames);
                    await saveRight(deptNum, 'referent', referentIds, referentNames);
                    await saveRight(deptNum, 'membre', membreIds, membreNames);

                    // Mettre à jour l'affichage dans l'arbre
                    updateTreeDisplay(deptNum);

                } else if (currentModalType === 'region') {
                    // Récupérer les hidden inputs (qui contiennent les IDs)
                    const hiddenInputs = document.querySelectorAll('input[type="hidden"][data-dept][data-role]');
                    for (const input of hiddenInputs) {
                        const deptNum = input.dataset.dept;
                        const role = input.dataset.role;
                        const ids = input.value;

                        // Récupérer les noms depuis le conteneur correspondant
                        const containerId = input.id.replace('input-', 'ms-');
                        const names = getNamesFromContainer(containerId);

                        await saveRight(deptNum, role, ids, names);
                        updateTreeDisplay(deptNum);
                    }
                }

                // Fermer la modale
                rightsModal.hide();

            } catch (error) {
                console.error('Erreur sauvegarde:', error);
                alert('Erreur lors de la sauvegarde');
            }

            saveBtn.disabled = false;
            saveBtn.innerHTML = '<i class="bi bi-check-circle me-1"></i>Enregistrer';
        }

        // Sauvegarder un droit individuel
        // value = IDs (ex: "1, 2, 3")
        // names = Noms (ex: "Jean Dupont, Marie Martin")
        async function saveRight(deptNum, role, value, names = '') {
            // Récupérer le departement_id depuis le cache ou via l'API
            let departementId = droitsCache[deptNum]?.departement_id;

            // Si pas dans le cache, chercher l'ID du département
            if (!departementId) {
                const deptResponse = await fetch(`api.php?action=getDepartementId&numero_departement=${encodeURIComponent(deptNum)}`);
                const deptData = await deptResponse.json();
                if (deptData.success && deptData.departement_id) {
                    departementId = deptData.departement_id;
                }
            }

            if (!departementId) {
                console.error('Département non trouvé:', deptNum);
                return { success: false, error: 'Département non trouvé' };
            }

            const formData = new FormData();
            formData.append('action', 'saveGestionDroits');
            formData.append('departement_id', departementId);
            formData.append('role', role);
            formData.append('value', value); // Envoie les IDs

            const response = await fetch('api.php', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();
            if (data.success) {
                // Mettre à jour le cache avec les IDs et les noms
                if (!droitsCache[deptNum]) droitsCache[deptNum] = { departement_id: departementId };
                droitsCache[deptNum][role + '_ids'] = value;
                droitsCache[deptNum][role] = names; // Stocker les noms pour l'affichage
            }
            return data;
        }

        // Mettre à jour l'affichage d'un département dans l'arbre
        function updateTreeDisplay(deptNum) {
            const deptItem = document.querySelector(`.tree-item[data-dept="${deptNum}"]`);
            if (deptItem) {
                const droits = droitsCache[deptNum] || {};
                const rightsContainer = deptItem.querySelector('.rights-columns');
                if (rightsContainer) {
                    rightsContainer.innerHTML = `
                        <span class="right-text admin ${droits.admin ? 'filled' : ''}">${formatRightsMultiline(droits.admin)}</span>
                        <span class="right-text referent ${droits.referent ? 'filled' : ''}">${formatRightsMultiline(droits.referent)}</span>
                        <span class="right-text membre ${droits.membre ? 'filled' : ''}">${formatRightsMultiline(droits.membre)}</span>
                    `;
                }
            }
        }


        // Tout déplier
        async function expandAll() {
            const items = document.querySelectorAll('.tree-item[data-has-children="true"]');

            for (const item of items) {
                const content = item.querySelector('.tree-item-content');
                const toggle = content.querySelector('.tree-toggle');
                const nodeId = parseInt(item.dataset.id);

                if (!toggle.classList.contains('expanded') && !toggle.classList.contains('no-children')) {
                    await toggleNode(content, nodeId);
                    await new Promise(resolve => setTimeout(resolve, 50));
                }
            }
        }

        // Tout replier
        function collapseAll() {
            document.querySelectorAll('.tree-toggle').forEach(toggle => {
                toggle.classList.remove('expanded');
            });
            document.querySelectorAll('.tree-children').forEach(children => {
                children.classList.remove('expanded');
            });
        }

        // Recherche (désactivée - zone de recherche supprimée)
        // La fonctionnalité de recherche pourra être réactivée si nécessaire

        // Charger les régions au démarrage
        async function init() {
            const treeRoot = document.getElementById('treeRoot');

            try {
                // Charger d'abord les droits
                await loadDroits();

                // Puis charger les régions
                const children = await loadChildren(0);

                if (children.length > 0) {
                    treeRoot.innerHTML = children.map(createNodeHTML).join('');
                    loadedNodes.add(0);
                } else {
                    treeRoot.innerHTML = '<li class="text-muted">Aucune donnée</li>';
                }
            } catch (error) {
                console.error('Erreur initialisation:', error);
                treeRoot.innerHTML = '<li class="text-danger">Erreur de chargement</li>';
            }
        }

        // Lancer l'initialisation
        init();

        // ==========================================
        // MULTI-SELECT UTILISATEURS
        // ==========================================

        // Cache pour les timeouts de debounce
        const autocompleteTimeouts = {};

        // Cache global pour stocker le mapping ID->Nom pour chaque conteneur
        const multiSelectData = {};

        // Initialiser un champ multi-select
        // initialIds = "1, 2, 3" (IDs séparés par virgules)
        // initialNames = "Jean Dupont, Marie Martin, Paul Durand" (noms séparés par virgules)
        function initMultiSelect(containerId, hiddenInputId, resultsId, userType, initialIds = '', initialNames = '', compact = false) {
            const container = document.getElementById(containerId);
            const hiddenInput = document.getElementById(hiddenInputId);
            const results = document.getElementById(resultsId);
            const role = container?.dataset.role || 'admin';

            if (!container || !hiddenInput || !results) return;

            // Créer le champ de saisie dans le conteneur
            const input = document.createElement('input');
            input.type = 'text';
            input.className = 'multi-select-input';
            input.placeholder = compact ? '+' : 'Rechercher...';
            input.autocomplete = 'off';
            container.appendChild(input);

            // Stocker les utilisateurs sélectionnés : [{id, name}, ...]
            let selectedUsers = [];

            // Parser les valeurs initiales
            if (initialIds && initialIds.trim()) {
                const ids = initialIds.split(/[,;]/).map(v => v.trim()).filter(v => v);
                const names = initialNames ? initialNames.split(/[,;]/).map(v => v.trim()).filter(v => v) : ids;

                ids.forEach((id, index) => {
                    selectedUsers.push({
                        id: id,
                        name: names[index] || id
                    });
                });
                renderTags();
            }

            // Stocker dans le cache global
            multiSelectData[containerId] = { selectedUsers, hiddenInput, container, role };

            // Fonction pour rendre les tags
            function renderTags() {
                // Supprimer les tags existants
                container.querySelectorAll('.multi-select-tag').forEach(t => t.remove());

                // Ajouter les nouveaux tags avant l'input
                selectedUsers.forEach(user => {
                    const tag = document.createElement('span');
                    tag.className = `multi-select-tag ${role}`;
                    tag.dataset.id = user.id;
                    tag.innerHTML = `${escapeHtml(user.name)} <span class="remove-tag">×</span>`;
                    tag.querySelector('.remove-tag').addEventListener('click', function(e) {
                        e.stopPropagation();
                        removeUser(user.id);
                    });
                    container.insertBefore(tag, input);
                });

                // Mettre à jour le hidden input (stocke les IDs)
                hiddenInput.value = selectedUsers.map(u => u.id).join(', ');

                // Mettre à jour le cache global
                multiSelectData[containerId] = { selectedUsers: [...selectedUsers], hiddenInput, container, role };
            }

            // Ajouter un utilisateur
            function addUser(id, name) {
                if (id && !selectedUsers.find(u => u.id === String(id))) {
                    selectedUsers.push({ id: String(id), name: name });
                    renderTags();
                    input.value = '';
                }
            }

            // Supprimer un utilisateur
            function removeUser(id) {
                selectedUsers = selectedUsers.filter(u => u.id !== String(id));
                renderTags();
            }

            // Clic sur le conteneur = focus sur l'input
            container.addEventListener('click', function() {
                input.focus();
            });

            // Événement de saisie avec debounce
            input.addEventListener('input', function() {
                const query = this.value.trim();

                if (autocompleteTimeouts[containerId]) {
                    clearTimeout(autocompleteTimeouts[containerId]);
                }

                autocompleteTimeouts[containerId] = setTimeout(() => {
                    searchUsersForMultiSelect(query, userType, results, selectedUsers, addUser);
                }, 300);
            });

            // Focus - afficher tous les utilisateurs
            input.addEventListener('focus', function() {
                searchUsersForMultiSelect(this.value.trim(), userType, results, selectedUsers, addUser);
            });

            // Fermer la liste quand on clique ailleurs (mais pas sur l'ascenseur)
            let isMouseDownOnResults = false;

            results.addEventListener('mousedown', function() {
                isMouseDownOnResults = true;
            });

            results.addEventListener('mouseup', function() {
                isMouseDownOnResults = false;
            });

            input.addEventListener('blur', function() {
                setTimeout(() => {
                    if (!isMouseDownOnResults) {
                        results.classList.remove('show');
                    }
                    isMouseDownOnResults = false;
                }, 200);
            });

            // Navigation au clavier
            input.addEventListener('keydown', function(e) {
                const items = results.querySelectorAll('.autocomplete-item');
                const active = results.querySelector('.autocomplete-item.active');

                // Ctrl+Tab = afficher tous les utilisateurs
                if (e.ctrlKey && e.key === 'Tab') {
                    e.preventDefault();
                    searchUsersForMultiSelect('', userType, results, selectedUsers, addUser);
                    return;
                }

                if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    if (!active && items.length > 0) {
                        items[0].classList.add('active');
                        items[0].scrollIntoView({ block: 'nearest' });
                    } else if (active && active.nextElementSibling) {
                        active.classList.remove('active');
                        active.nextElementSibling.classList.add('active');
                        active.nextElementSibling.scrollIntoView({ block: 'nearest' });
                    }
                } else if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    if (active && active.previousElementSibling) {
                        active.classList.remove('active');
                        active.previousElementSibling.classList.add('active');
                        active.previousElementSibling.scrollIntoView({ block: 'nearest' });
                    }
                } else if (e.key === 'Enter') {
                    e.preventDefault();
                    if (active) {
                        active.click();
                    }
                } else if (e.key === 'Escape') {
                    results.classList.remove('show');
                } else if (e.key === 'Backspace' && !this.value && selectedUsers.length > 0) {
                    // Supprimer le dernier tag avec Backspace
                    removeUser(selectedUsers[selectedUsers.length - 1].id);
                }
            });
        }

        // Normaliser une chaîne (retirer les accents)
        function normalizeString(str) {
            return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
        }

        // Rechercher les utilisateurs via l'API (pour multi-select)
        async function searchUsersForMultiSelect(query, type, resultsContainer, selectedUsers, addCallback) {
            resultsContainer.innerHTML = '<div class="autocomplete-loading"><i class="bi bi-arrow-repeat"></i> Recherche...</div>';
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

                        // Ajouter les événements de clic (multi-sélection : la liste reste ouverte)
                        resultsContainer.querySelectorAll('.autocomplete-item').forEach(item => {
                            item.addEventListener('mousedown', function(e) {
                                e.preventDefault();
                                const id = this.dataset.id;
                                const name = this.dataset.name;
                                addCallback(id, name);
                                // Marquer visuellement l'élément comme sélectionné
                                this.style.opacity = '0.6';
                                this.style.backgroundColor = '#e3f2fd';
                            });
                        });
                    } else {
                        resultsContainer.innerHTML = '<div class="autocomplete-loading">Aucun utilisateur trouvé</div>';
                    }
                } else {
                    resultsContainer.innerHTML = '<div class="autocomplete-loading">Aucun résultat</div>';
                }
            } catch (error) {
                console.error('Erreur recherche:', error);
                resultsContainer.innerHTML = '<div class="autocomplete-loading text-danger">Erreur de recherche</div>';
            }
        }

        // Fermer toutes les listes autocomplete quand on clique ailleurs
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.autocomplete-container')) {
                document.querySelectorAll('.autocomplete-results').forEach(r => r.classList.remove('show'));
            }
        });
    </script>
</body>
</html>
