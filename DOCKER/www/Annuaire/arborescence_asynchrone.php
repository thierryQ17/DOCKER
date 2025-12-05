<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

/**
 * Page d'affichage du menu arborescent basé sur la table arborescence (Nested Sets)
 * Version ASYNCHRONE avec lazy loading
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

// Compter le nombre d'éléments par type (statistiques uniquement - sans circonscriptions)
$stats = $pdo->query("
    SELECT type_element, COUNT(*) as nb
    FROM arborescence
    WHERE niveau > 0 AND type_element != 'circonscription'
    GROUP BY type_element
    ORDER BY FIELD(type_element, 'region', 'departement', 'canton')
")->fetchAll(PDO::FETCH_KEY_PAIR);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Arborescence - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #17a2b8;
            --primary-dark: #138496;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .stats-bar {
            background: white;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .stat-item .badge {
            font-size: 0.9rem;
        }

        .tree-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
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
            padding: 8px 12px;
            margin: 2px 0;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            gap: 10px;
        }

        .tree-item-content:hover {
            background: #f0f7ff;
        }

        .tree-item-content.active {
            background: #e3f2fd;
        }

        .tree-toggle {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            background: #f0f0f0;
            transition: all 0.2s;
            flex-shrink: 0;
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
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-size: 14px;
            flex-shrink: 0;
        }

        .tree-icon.region { background: #e3f2fd; color: #1976d2; }
        .tree-icon.departement { background: #f3e5f5; color: #7b1fa2; }
        .tree-icon.circonscription { background: #fff3e0; color: #ef6c00; }
        .tree-icon.canton { background: #e8f5e9; color: #388e3c; }

        .tree-label {
            flex: 1;
            font-size: 14px;
        }

        .tree-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 10px;
            background: #f0f0f0;
            color: #666;
        }

        .tree-children {
            display: none;
            margin-left: 34px;
            padding-left: 15px;
            border-left: 2px solid #e0e0e0;
        }

        .tree-children.expanded {
            display: block;
        }

        /* Niveaux */
        .level-1 .tree-label { font-weight: 600; font-size: 15px; }
        .level-2 .tree-label { font-weight: 500; }
        .level-3 .tree-label { font-size: 13px; }
        .level-4 .tree-label { font-size: 13px; color: #666; }

        .search-box {
            margin-bottom: 15px;
        }

        .search-box input {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 14px;
            transition: border-color 0.2s;
        }

        .search-box input:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(23, 162, 184, 0.1);
        }

        .btn-expand-all {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-expand-all:hover {
            background: var(--primary-dark);
        }

        .highlight {
            background: #fff3cd;
            padding: 0 2px;
            border-radius: 2px;
        }

        .search-results {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            display: none;
        }

        .search-results.visible {
            display: block;
        }

        .search-result-item {
            padding: 8px 12px;
            margin: 4px 0;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .search-result-item:hover {
            background: #e3f2fd;
        }

        .search-result-breadcrumb {
            font-size: 11px;
            color: #666;
            margin-top: 2px;
        }

        .loading-indicator {
            text-align: center;
            padding: 20px;
            color: #666;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 10px;
            }

            .stats-bar {
                flex-direction: column;
                gap: 10px;
            }

            .tree-children {
                margin-left: 20px;
                padding-left: 10px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="maires_responsive.php">
                <i class="bi bi-diagram-3 me-2"></i>Arborescence
            </a>
            <div class="d-flex gap-2">
                <a href="gestionDesDroits.php" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-shield-lock me-1"></i>Gestion des Droits
                </a>
                <a href="maires_responsive.php" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Retour
                </a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <!-- Statistiques -->
        <div class="stats-bar">
            <div class="stat-item">
                <i class="bi bi-globe text-primary"></i>
                <span>Régions</span>
                <span class="badge bg-primary"><?= number_format($stats['region'] ?? 0) ?></span>
            </div>
            <div class="stat-item">
                <i class="bi bi-building text-purple" style="color: #7b1fa2;"></i>
                <span>Départements</span>
                <span class="badge" style="background: #7b1fa2;"><?= number_format($stats['departement'] ?? 0) ?></span>
            </div>
            <div class="stat-item">
                <i class="bi bi-pin-map text-success"></i>
                <span>Cantons</span>
                <span class="badge bg-success"><?= number_format($stats['canton'] ?? 0) ?></span>
            </div>
        </div>

        <!-- Conteneur de l'arbre -->
        <div class="tree-container">
            <!-- Recherche et actions -->
            <div class="d-flex gap-2 mb-3 flex-wrap">
                <div class="search-box flex-grow-1">
                    <input type="text" id="searchInput" class="form-control" placeholder="Rechercher..." autocomplete="off">
                </div>
                <button class="btn-expand-all" onclick="expandAll()">
                    <i class="bi bi-arrows-expand me-1"></i>Tout déplier
                </button>
                <button class="btn-expand-all" onclick="collapseAll()" style="background: #6c757d;">
                    <i class="bi bi-arrows-collapse me-1"></i>Tout replier
                </button>
            </div>

            <!-- Résultats de recherche -->
            <div id="searchResults" class="search-results"></div>

            <!-- Arbre (chargé dynamiquement) -->
            <ul id="treeRoot" class="tree-node">
                <li class="loading-indicator">
                    <i class="bi bi-arrow-repeat"></i> Chargement des régions...
                </li>
            </ul>
        </div>
    </div>

    <script>
        // Configuration des icônes par type
        const ICONS = {
            'region': 'bi-globe',
            'departement': 'bi-building',
            'circonscription': 'bi-geo-alt',
            'canton': 'bi-pin-map'
        };

        // Cache des noeuds déjà chargés
        const loadedNodes = new Set();

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

        // Créer le HTML d'un noeud
        function createNodeHTML(node) {
            const hasChildren = parseInt(node.nb_enfants) > 0;
            const icon = ICONS[node.type_element] || 'bi-folder';
            const level = node.niveau;

            let html = `<li class="tree-item level-${level}" data-id="${node.id}" data-type="${node.type_element}" data-label="${escapeHtml(node.libelle.toLowerCase())}" data-has-children="${hasChildren}">`;
            html += `<div class="tree-item-content" onclick="toggleNode(this, ${node.id})">`;
            html += `<span class="tree-toggle ${hasChildren ? '' : 'no-children'}"><i class="bi bi-chevron-right"></i></span>`;
            html += `<span class="tree-icon ${node.type_element}"><i class="bi ${icon}"></i></span>`;
            html += `<span class="tree-label">${escapeHtml(node.libelle)}</span>`;
            if (hasChildren) {
                html += `<span class="tree-badge">${parseInt(node.nb_enfants).toLocaleString('fr-FR')}</span>`;
            }
            html += '</div>';
            if (hasChildren) {
                html += '<ul class="tree-node tree-children"></ul>';
            }
            html += '</li>';

            return html;
        }

        // Échapper les caractères HTML
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Toggle d'un noeud (avec chargement asynchrone)
        async function toggleNode(element, nodeId) {
            const toggle = element.querySelector('.tree-toggle');
            const childrenContainer = element.nextElementSibling;

            if (toggle.classList.contains('no-children')) return;

            // Si déjà en train de charger, ignorer
            if (toggle.classList.contains('loading')) return;

            const isExpanded = toggle.classList.contains('expanded');

            if (isExpanded) {
                // Replier
                toggle.classList.remove('expanded');
                if (childrenContainer) {
                    childrenContainer.classList.remove('expanded');
                }
            } else {
                // Déplier - charger les enfants si pas encore fait
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

        // Tout déplier (charge tout progressivement)
        async function expandAll() {
            const items = document.querySelectorAll('.tree-item[data-has-children="true"]');

            for (const item of items) {
                const content = item.querySelector('.tree-item-content');
                const toggle = content.querySelector('.tree-toggle');
                const nodeId = parseInt(item.dataset.id);

                if (!toggle.classList.contains('expanded')) {
                    await toggleNode(content, nodeId);
                    // Petit délai pour éviter de surcharger
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

        // Recherche via l'API
        let searchTimeout;
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const query = e.target.value.trim();
            const resultsContainer = document.getElementById('searchResults');

            clearTimeout(searchTimeout);

            if (query.length < 2) {
                resultsContainer.classList.remove('visible');
                resultsContainer.innerHTML = '';
                return;
            }

            searchTimeout = setTimeout(async () => {
                try {
                    const response = await fetch(`api.php?action=searchArborescence&q=${encodeURIComponent(query)}&limit=20`);
                    const data = await response.json();

                    if (data.success && data.results.length > 0) {
                        let html = `<div class="mb-2 text-muted small">${data.count} résultat(s) pour "${escapeHtml(query)}"</div>`;

                        data.results.forEach(result => {
                            const icon = ICONS[result.type_element] || 'bi-folder';
                            const breadcrumb = result.breadcrumb ? result.breadcrumb.join(' › ') : '';

                            html += `
                                <div class="search-result-item" onclick="navigateToNode(${result.id})">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="tree-icon ${result.type_element}"><i class="bi ${icon}"></i></span>
                                        <span>${escapeHtml(result.libelle)}</span>
                                    </div>
                                    ${breadcrumb ? `<div class="search-result-breadcrumb">${escapeHtml(breadcrumb)}</div>` : ''}
                                </div>
                            `;
                        });

                        resultsContainer.innerHTML = html;
                        resultsContainer.classList.add('visible');
                    } else {
                        resultsContainer.innerHTML = '<div class="text-muted">Aucun résultat</div>';
                        resultsContainer.classList.add('visible');
                    }
                } catch (error) {
                    console.error('Erreur recherche:', error);
                }
            }, 300);
        });

        // Naviguer vers un noeud (déplier ses ancêtres)
        async function navigateToNode(nodeId) {
            try {
                // Récupérer le noeud avec ses ancêtres
                const response = await fetch(`api.php?action=getArborescenceNode&id=${nodeId}`);
                const data = await response.json();

                if (data.success) {
                    // Fermer la recherche
                    document.getElementById('searchResults').classList.remove('visible');
                    document.getElementById('searchInput').value = '';

                    // Déplier tous les ancêtres
                    for (const ancestor of data.ancestors) {
                        if (ancestor.niveau === 0) continue; // Skip racine

                        const ancestorItem = document.querySelector(`.tree-item[data-id="${ancestor.id}"]`);
                        if (ancestorItem) {
                            const content = ancestorItem.querySelector('.tree-item-content');
                            const toggle = content.querySelector('.tree-toggle');

                            if (!toggle.classList.contains('expanded')) {
                                await toggleNode(content, ancestor.id);
                            }
                        }
                    }

                    // Scroll vers le noeud cible
                    setTimeout(() => {
                        const targetItem = document.querySelector(`.tree-item[data-id="${nodeId}"]`);
                        if (targetItem) {
                            targetItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            targetItem.querySelector('.tree-item-content').classList.add('active');
                            setTimeout(() => {
                                targetItem.querySelector('.tree-item-content').classList.remove('active');
                            }, 2000);
                        }
                    }, 300);
                }
            } catch (error) {
                console.error('Erreur navigation:', error);
            }
        }

        // Charger les régions au démarrage
        async function init() {
            const treeRoot = document.getElementById('treeRoot');

            try {
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
    </script>
</body>
</html>
