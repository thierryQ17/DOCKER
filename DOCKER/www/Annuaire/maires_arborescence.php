<?php
// Configuration de la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

// Charger la configuration globale depuis menus.json
$menusConfig = json_decode(file_get_contents(__DIR__ . '/config/menus.json'), true);
$GLOBALS['filtreHabitants'] = $menusConfig['filtreHabitants'] ?? 1000;

// Configuration des seuils d'habitants pour le filtre combiné
$seuilsHabitants = [500, 700, 1000, 2000, 5000, 10000];

// Seuil d'habitants pour le filtre combiné des cantons (depuis menus.json)
$seuilHabitantsCanton = $GLOBALS['filtreHabitants'];

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Détection du mode "département direct" via URL
$deptMode = isset($_GET['dept']) ? trim($_GET['dept']) : null;
$deptData = null;

if ($deptMode) {
    // Rechercher le département via arborescence
    if (is_numeric($deptMode)) {
        // Recherche par numéro (ex: "60")
        $stmt = $pdo->prepare("
            SELECT
                a.reference_id as numero_departement,
                SUBSTRING(a.libelle, LOCATE(' - ', a.libelle) + 3) as nom_departement,
                p.libelle as region
            FROM arborescence a
            JOIN arborescence p ON a.parent_id = p.id
            WHERE a.type_element = 'departement' AND a.reference_id = ?
            LIMIT 1
        ");
        $stmt->execute([$deptMode]);
    } else {
        // Recherche par nom (ex: "oise", "nord", etc.)
        $stmt = $pdo->prepare("
            SELECT
                a.reference_id as numero_departement,
                SUBSTRING(a.libelle, LOCATE(' - ', a.libelle) + 3) as nom_departement,
                p.libelle as region
            FROM arborescence a
            JOIN arborescence p ON a.parent_id = p.id
            WHERE a.type_element = 'departement' AND LOWER(a.libelle) LIKE CONCAT('%', LOWER(?), '%')
            LIMIT 1
        ");
        $stmt->execute([$deptMode]);
    }
    $deptData = $stmt->fetch(PDO::FETCH_ASSOC);
}

// ============================================================================
// ROUTES AJAX DÉPLACÉES DANS api.php
// Toutes les routes AJAX ont été centralisées dans le fichier api.php
// pour une meilleure architecture et maintenabilité
// ============================================================================


// Récupérer la liste des régions avec le nombre de maires via arborescence
$regionsStmt = $pdo->query("
    SELECT a.libelle as region, COUNT(m.id) as nb_maires
    FROM arborescence a
    LEFT JOIN arborescence d ON d.parent_id = a.id AND d.type_element = 'departement'
    LEFT JOIN maires m ON d.reference_id = m.numero_departement
    WHERE a.type_element = 'region'
    GROUP BY a.id, a.libelle
    ORDER BY a.libelle ASC
");
$allRegions = $regionsStmt->fetchAll(PDO::FETCH_ASSOC);

// Séparer les DOM-TOM des régions métropolitaines
$domtomList = ['Guadeloupe', 'Guyane', 'La-Reunion', 'Martinique', 'Mayotte'];
$regions = [];
$domtom = [];

foreach ($allRegions as $region) {
    if (in_array($region['region'], $domtomList)) {
        $domtom[] = $region;
    } else {
        $regions[] = $region;
    }
}

// Statistiques globales
$statsStmt = $pdo->query("
    SELECT
        COUNT(*) as total_maires,
        COUNT(DISTINCT region) as total_regions,
        COUNT(DISTINCT numero_departement) as total_departements,
        COUNT(DISTINCT ville) as total_villes
    FROM maires
");
$stats = $statsStmt->fetch(PDO::FETCH_ASSOC);

// Récupérer les listes pour les datalists via arborescence
$departementsListStmt = $pdo->query("
    SELECT a.libelle as dept_display
    FROM arborescence a
    WHERE a.type_element = 'departement'
    ORDER BY a.reference_id ASC
");
$departementsList = $departementsListStmt->fetchAll(PDO::FETCH_COLUMN);

// Communes restent via maires (données spécifiques)
$communesListStmt = $pdo->query("
    SELECT DISTINCT ville
    FROM maires
    ORDER BY ville ASC
");
$communesList = $communesListStmt->fetchAll(PDO::FETCH_COLUMN);

// Cantons via arborescence
$cantonsListStmt = $pdo->query("
    SELECT a.libelle as canton
    FROM arborescence a
    WHERE a.type_element = 'canton'
    ORDER BY a.libelle ASC
");
$cantonsList = $cantonsListStmt->fetchAll(PDO::FETCH_COLUMN);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annuaire des Maires de France</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="ressources/css/styles-maires.css?v=<?= time() ?>">
    <style>
        /* Styles du menu arborescent */
        .tree-container {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
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
            padding: 8px 10px;
            margin: 2px 0;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            gap: 8px;
            color: white;
        }

        .tree-item-content:hover {
            background: rgba(255,255,255,0.15);
        }

        .tree-item-content.active {
            background: rgba(255,255,255,0.25);
        }

        .tree-toggle {
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            background: rgba(255,255,255,0.15);
            transition: all 0.2s;
            flex-shrink: 0;
        }

        .tree-toggle:hover {
            background: rgba(255,255,255,0.25);
        }

        .tree-toggle.expanded {
            transform: rotate(90deg);
        }

        .tree-toggle.no-children {
            visibility: hidden;
        }

        .tree-toggle.loading {
            background: rgba(255,255,255,0.3);
        }

        .tree-toggle.loading i {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .tree-icon {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
            font-size: 12px;
            flex-shrink: 0;
        }

        .tree-icon.region { background: rgba(255,255,255,0.2); color: white; }
        .tree-icon.departement { background: rgba(123,31,162,0.5); color: white; }
        .tree-icon.canton { background: rgba(56,142,60,0.5); color: white; }
        .tree-icon.domtom { background: rgba(255,193,7,0.6); color: white; }

        .tree-label {
            flex: 1;
            font-size: 13px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .tree-badge {
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 8px;
            background: rgba(255,255,255,0.2);
            color: white;
        }

        .tree-children {
            display: none;
            margin-left: 20px;
            padding-left: 10px;
            border-left: 2px solid rgba(255,255,255,0.2);
        }

        .tree-children.expanded {
            display: block;
        }

        /* Niveaux de l'arbre */
        .level-1 .tree-label { font-weight: 600; font-size: 14px; }
        .level-2 .tree-label { font-weight: 500; font-size: 13px; }
        .level-3 .tree-label { font-size: 12px; opacity: 0.9; }

        .tree-loading {
            text-align: center;
            padding: 20px;
            color: rgba(255,255,255,0.7);
        }

        .tree-loading i {
            animation: spin 1s linear infinite;
        }

        /* Scrollbar pour l'arbre */
        .tree-container::-webkit-scrollbar {
            width: 8px;
        }

        .tree-container::-webkit-scrollbar-track {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }

        .tree-container::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.3);
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <!-- Datalists pour l'autocomplétion -->
    <datalist id="departements-datalist">
        <?php foreach ($departementsList as $dept): ?>
            <option value="<?= htmlspecialchars($dept) ?>">
        <?php endforeach; ?>
    </datalist>

    <datalist id="communes-datalist">
        <?php foreach ($communesList as $commune): ?>
            <option value="<?= htmlspecialchars($commune) ?>">
        <?php endforeach; ?>
    </datalist>

    <datalist id="cantons-datalist">
        <?php foreach ($cantonsList as $canton): ?>
            <option value="<?= htmlspecialchars($canton) ?>">
        <?php endforeach; ?>
    </datalist>

    <datalist id="circonscriptions-datalist">
        <!-- Sera rempli dynamiquement par JavaScript -->
    </datalist>

    <div class="container-fluid h-100 p-0">
        <div class="row g-0 h-100">
            <!-- Menu latéral + Barre de fermeture -->
            <div class="col-auto sidebar-wrapper<?= $deptMode ? ' hidden' : '' ?>">
                <div class="sidebar">
            <div class="sidebar-header">
                <a href="maires.php" style="display: block; cursor: pointer;">
                    <img src="ressources/images/logoUPR.png" alt="Logo UPR">
                </a>
                <h1><i class="bi bi-diagram-3 me-2"></i>Arborescence</h1>

                <!-- Case à cocher communes traitées -->
                <div style="margin-top: 10px; padding: 6px 8px; background: rgba(255,255,255,0.1); border-radius: 4px; display: flex; align-items: center; gap: 6px; cursor: pointer;" onclick="document.getElementById('communesTraitees').click()">
                    <input type="checkbox" id="communesTraitees" style="cursor: pointer; width: 14px; height: 14px;" onchange="toggleCommunesTraitees()" />
                    <label for="communesTraitees" style="cursor: pointer; font-size: 0.75em; margin: 0; user-select: none;">Communes traitées</label>
                </div>
            </div>

            <!-- Menu arborescent asynchrone -->
            <div class="tree-container" id="treeContainer">
                <ul id="treeRoot" class="tree-node">
                    <li class="tree-loading">
                        <i class="bi bi-arrow-repeat"></i> Chargement...
                    </li>
                </ul>
            </div>
        </div>

                <!-- Colonne de fermeture (bande verticale visible quand menu ouvert) -->
                <div id="closeMenuStrip" class="close-menu-strip" title="Cacher le menu">
                    <span class="icon">‹‹</span>
                </div>

                <!-- Colonne d'ouverture (bande verticale visible quand menu fermé) -->
                <div id="openMenuStrip" class="open-menu-strip" title="Afficher le menu">
                    <span class="icon">››</span>
                </div>
            </div>

            <!-- Contenu principal -->
            <div class="col main-content">
            <div class="content-header">
                <h2 id="regionTitle">
                    <span id="regionTitleText">
                        <?php if ($deptMode && $deptData): ?>
                            Parrainage 2027 - <?= htmlspecialchars($deptData['nom_departement']) ?> (<?= htmlspecialchars($deptData['numero_departement']) ?>)
                        <?php else: ?>
                            UPR - Parrainage 2027 - Annuaire des Maires de France
                        <?php endif; ?>
                    </span>
                </h2>
                <div class="stats-mini">
                    <?php if ($deptMode && $deptData): ?>
                        <?php
                        // Compter les maires du département sélectionné
                        $stmtCount = $pdo->prepare("SELECT COUNT(*) as nb_maires FROM maires WHERE numero_departement = ?");
                        $stmtCount->execute([$deptData['numero_departement']]);
                        $deptStats = $stmtCount->fetch(PDO::FETCH_ASSOC);
                        ?>
                        <div class="stat-mini">
                            <div class="value"><?= number_format($deptStats['nb_maires']) ?></div>
                            <div class="label">Maires</div>
                        </div>
                    <?php else: ?>
                        <div class="stat-mini">
                            <div class="value"><?= number_format($stats['total_regions']) ?></div>
                            <div class="label">Régions</div>
                        </div>
                        <div class="stat-mini">
                            <div class="value"><?= number_format($stats['total_departements']) ?></div>
                            <div class="label">Départements</div>
                        </div>
                        <div class="stat-mini">
                            <div class="value"><?= number_format($stats['total_maires']) ?></div>
                            <div class="label">Maires</div>
                        </div>
                    <?php endif; ?>
                </div>
            </div>

            <div class="content-body" id="contentBody">
                <!-- Recherche avancée -->
                <div class="search-advanced collapsed" id="searchAdvanced" <?= $deptMode ? 'style="display: none;"' : '' ?>>
                    <div class="search-advanced-header" id="searchAdvancedToggle">
                        <h3>🔍 Recherche avancée</h3>
                        <span class="search-toggle-icon">▼</span>
                    </div>
                    <div class="search-advanced-body">
                        <div class="search-grid">
                            <div class="search-field" style="max-width: 30px !important; min-width: 30px !important; width: 30px !important; flex: 0 0 30px !important;">
                                <label style="opacity: 0;">.</label>
                                <button onclick="resetAdvancedSearch()" style="padding: 8px 5px; background: #17a2b8; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 11px; font-weight: 600; width: 100%;" title="Réinitialiser les filtres">↻</button>
                            </div>

                            <div class="search-field">
                                <label for="searchRegion">Région</label>
                                <select id="searchRegion">
                                    <option value="">Toutes les régions</option>
                                    <?php foreach ($regions as $region): ?>
                                        <option value="<?= htmlspecialchars($region['region']) ?>"><?= htmlspecialchars($region['region']) ?></option>
                                    <?php endforeach; ?>
                                    <option value="Guadeloupe">Guadeloupe</option>
                                    <option value="Martinique">Martinique</option>
                                    <option value="Guyane">Guyane</option>
                                    <option value="La-Reunion">La-Reunion</option>
                                    <option value="Mayotte">Mayotte</option>
                                </select>
                            </div>

                            <div class="search-field">
                                <label for="searchDepartement">Département</label>
                                <input type="text" id="searchDepartement" placeholder="Ex: 75, Paris" autocomplete="off">
                                <div class="autocomplete-list" id="departement-autocomplete"></div>
                            </div>

                            <div class="search-field">
                                <label for="searchCanton">Canton</label>
                                <input type="text" id="searchCanton" placeholder="Ex: Canton de Paris" autocomplete="off">
                                <div class="autocomplete-list" id="canton-autocomplete-advanced"></div>
                            </div>

                            <div class="search-field">
                                <label for="searchCommune">Commune</label>
                                <input type="text" id="searchCommune" placeholder="Ex: Paris, Lyon" autocomplete="off">
                                <div class="autocomplete-list" id="commune-autocomplete-advanced"></div>
                            </div>

                            <div class="search-field" style="max-width: 100px;">
                                <label for="searchNbHabitants">Habitants (max)</label>
                                <input type="number" id="searchNbHabitants" placeholder="Max" min="0">
                            </div>
                        </div>

                        <div class="search-actions">
                            <button class="btn-search" id="btnAdvancedSearch">Rechercher</button>
                        </div>
                    </div>
                </div>

                <div id="resultsContainer">
                    <div class="empty-state">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                        <h3>Utilisez la recherche avancée</h3>
                        <p>Utilisez les filtres ci-dessus ou sélectionnez une région dans le menu de gauche</p>
                    </div>
                </div>
            </div>
            </div>
        </div>
    </div>

    <!-- Modal pour afficher les détails du maire -->
    <div class="modal-overlay" id="maireModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Détails du maire</h3>
                <button class="modal-close" onclick="closeMaireModal()">×</button>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- Contenu chargé dynamiquement -->
            </div>
            <div class="modal-actions" id="modalActions">
                <!-- Boutons chargés dynamiquement -->
            </div>
        </div>
    </div>

    <script>
        // Mode département direct via URL
        <?php if ($deptMode && $deptData): ?>
        window.DEPT_MODE = {
            enabled: true,
            numero: '<?= htmlspecialchars($deptData['numero_departement']) ?>',
            nom: '<?= htmlspecialchars($deptData['nom_departement']) ?>',
            region: '<?= htmlspecialchars($deptData['region']) ?>'
        };
        <?php else: ?>
        window.DEPT_MODE = { enabled: false };
        <?php endif; ?>

        // Configuration des seuils d'habitants pour le filtre combiné
        window.SEUILS_HABITANTS = <?= json_encode($seuilsHabitants) ?>;
        window.SEUIL_HABITANTS_CANTON = <?= $seuilHabitantsCanton ?>;
    </script>
    <script src="ressources/js/scripts-maires.js?v=<?= time() ?>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script du menu arborescent asynchrone -->
    <script>
    (function() {
        // Configuration des icônes par type
        const TREE_ICONS = {
            'region': 'bi-globe',
            'departement': 'bi-building',
            'canton': 'bi-pin-map',
            'domtom': 'bi-globe-americas'
        };

        // Cache des noeuds déjà chargés
        const loadedTreeNodes = new Set();

        // Charger les enfants d'un noeud via l'API
        async function loadTreeChildren(parentId = 0) {
            const url = `api.php?action=getArborescenceChildren&parent_id=${parentId}`;
            const response = await fetch(url);
            const data = await response.json();
            return data.success ? data.children : [];
        }

        // Échapper les caractères HTML
        function escapeTreeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Créer le HTML d'un noeud
        function createTreeNodeHTML(node) {
            const hasChildren = parseInt(node.nb_enfants) > 0;
            const icon = TREE_ICONS[node.type_element] || 'bi-folder';
            const level = node.niveau;

            let html = `<li class="tree-item level-${level}" data-id="${node.id}" data-type="${node.type_element}" data-reference="${node.reference_id || ''}" data-has-children="${hasChildren}">`;
            html += `<div class="tree-item-content" onclick="handleTreeNodeClick(event, this, ${node.id}, '${node.type_element}', '${escapeTreeHtml(node.reference_id || '')}')">`;
            html += `<span class="tree-toggle ${hasChildren ? '' : 'no-children'}" onclick="event.stopPropagation(); toggleTreeNode(this.parentElement, ${node.id})"><i class="bi bi-chevron-right"></i></span>`;
            html += `<span class="tree-icon ${node.type_element}"><i class="bi ${icon}"></i></span>`;
            html += `<span class="tree-label">${escapeTreeHtml(node.libelle)}</span>`;
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

        // Gérer le clic sur un noeud (charger les maires ou déplier)
        window.handleTreeNodeClick = async function(event, element, nodeId, nodeType, referenceId) {
            // Si c'est un département, charger les maires (identique à maires.php)
            if (nodeType === 'departement' && referenceId) {
                // Marquer comme actif
                document.querySelectorAll('.tree-item-content.active').forEach(el => el.classList.remove('active'));
                element.classList.add('active');

                // Récupérer le libellé pour le titre
                const deptLabel = element.querySelector('.tree-label').textContent;

                // Trouver la région parente
                const regionItem = element.closest('.tree-children')?.closest('.tree-item');
                const regionLabel = regionItem ? regionItem.querySelector('.tree-label').textContent : '';

                // Utiliser AppState et loadMaires comme dans maires.php
                if (typeof window.AppState !== 'undefined' && typeof window.loadMaires === 'function') {
                    window.AppState.currentRegion = regionLabel;
                    window.AppState.currentDepartement = referenceId;
                    window.AppState.currentPage = 1;
                    window.loadMaires(true);

                    // Charger les circonscriptions
                    if (typeof window.loadCirconscriptions === 'function') {
                        window.loadCirconscriptions(regionLabel, referenceId);
                    }

                    // Masquer la recherche avancée
                    const searchAdvanced = document.getElementById('searchAdvanced');
                    if (searchAdvanced) {
                        searchAdvanced.style.display = 'none';
                    }

                    // Mettre à jour le titre
                    document.getElementById('regionTitleText').textContent = `${regionLabel} - ${deptLabel}`;
                } else {
                    console.error('AppState ou loadMaires non disponible');
                }
            } else if (nodeType === 'canton') {
                // Marquer comme actif
                document.querySelectorAll('.tree-item-content.active').forEach(el => el.classList.remove('active'));
                element.classList.add('active');

                // Récupérer le libellé du canton
                const cantonLabel = element.querySelector('.tree-label').textContent;

                // Trouver le département parent pour avoir le contexte
                const deptItem = element.closest('.tree-children')?.closest('.tree-item');
                const deptRef = deptItem ? deptItem.dataset.reference : '';

                // Trouver la région parente
                const regionItem = deptItem?.closest('.tree-children')?.closest('.tree-item');
                const regionLabel = regionItem ? regionItem.querySelector('.tree-label').textContent : '';

                // Utiliser loadMairesAdvanced pour les cantons
                if (typeof window.loadMairesAdvanced === 'function') {
                    // Masquer la recherche avancée
                    const searchAdvanced = document.getElementById('searchAdvanced');
                    if (searchAdvanced) {
                        searchAdvanced.style.display = 'none';
                    }

                    // Mettre à jour le titre
                    document.getElementById('regionTitleText').textContent = `${cantonLabel}`;

                    // Charger les maires du canton
                    window.loadMairesAdvanced(regionLabel, deptRef, '', cantonLabel, '', '', true);
                } else {
                    console.error('loadMairesAdvanced non disponible');
                }
            } else {
                // Sinon, toggle les enfants
                await toggleTreeNode(element, nodeId);
            }
        };

        // Toggle d'un noeud (avec chargement asynchrone)
        window.toggleTreeNode = async function(element, nodeId) {
            const toggle = element.querySelector('.tree-toggle');
            const li = element.closest('.tree-item');
            const childrenContainer = li.querySelector('.tree-children');

            if (toggle.classList.contains('no-children')) return;
            if (toggle.classList.contains('loading')) return;

            const isExpanded = toggle.classList.contains('expanded');

            if (isExpanded) {
                // Replier
                toggle.classList.remove('expanded');
                if (childrenContainer) {
                    childrenContainer.classList.remove('expanded');
                }
            } else {
                // Fermer les autres noeuds ouverts au même niveau (frères)
                const parentContainer = li.parentElement;
                if (parentContainer) {
                    parentContainer.querySelectorAll(':scope > .tree-item').forEach(sibling => {
                        if (sibling !== li) {
                            const siblingToggle = sibling.querySelector(':scope > .tree-item-content > .tree-toggle');
                            const siblingChildren = sibling.querySelector(':scope > .tree-children');
                            if (siblingToggle) {
                                siblingToggle.classList.remove('expanded');
                            }
                            if (siblingChildren) {
                                siblingChildren.classList.remove('expanded');
                            }
                        }
                    });
                }

                // Déplier - charger les enfants si pas encore fait
                if (!loadedTreeNodes.has(nodeId)) {
                    toggle.classList.add('loading');
                    toggle.innerHTML = '<i class="bi bi-arrow-repeat"></i>';

                    try {
                        const children = await loadTreeChildren(nodeId);

                        if (childrenContainer && children.length > 0) {
                            childrenContainer.innerHTML = children.map(createTreeNodeHTML).join('');
                        }

                        loadedTreeNodes.add(nodeId);
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
        };

        // Initialiser l'arbre au chargement
        async function initTree() {
            const treeRoot = document.getElementById('treeRoot');

            try {
                const children = await loadTreeChildren(0);

                if (children.length > 0) {
                    treeRoot.innerHTML = children.map(createTreeNodeHTML).join('');
                    loadedTreeNodes.add(0);
                } else {
                    treeRoot.innerHTML = '<li style="color: rgba(255,255,255,0.7); padding: 10px;">Aucune donnée</li>';
                }
            } catch (error) {
                console.error('Erreur initialisation:', error);
                treeRoot.innerHTML = '<li style="color: #ff6b6b; padding: 10px;">Erreur de chargement</li>';
            }
        }

        // Lancer l'initialisation quand le DOM est prêt
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initTree);
        } else {
            initTree();
        }
    })();
    </script>
</body>
</html>
