<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

// Configuration de la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

// Configuration des seuils d'habitants pour le filtre combiné
$seuilsHabitants = [500, 700, 1000, 2000, 5000, 10000];

// Seuil d'habitants pour le filtre combiné des cantons (depuis menus.json)
$seuilHabitantsCanton = $GLOBALS['filtreHabitants'] ?? 1000;

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Récupérer les informations de l'utilisateur connecté
$currentUserType = $_SESSION['user_type'] ?? 0;
$currentUserId = $_SESSION['user_id'] ?? 0;

// Pour les référents (3) et membres (4), récupérer leurs départements autorisés
$userAllowedDepts = [];
$userAllowedDeptNumbers = [];
if ($currentUserType == 3 || $currentUserType == 4) {
    // Récupérer les IDs et numéros des départements autorisés
    $stmtDepts = $pdo->prepare("
        SELECT DISTINCT d.id, d.numero_departement
        FROM gestionAccesDepartements gd
        JOIN departements d ON gd.departement_id = d.id
        WHERE gd.utilisateur_id = ?
    ");
    $stmtDepts->execute([$currentUserId]);
    $deptRows = $stmtDepts->fetchAll(PDO::FETCH_ASSOC);
    foreach ($deptRows as $row) {
        $userAllowedDepts[] = (int)$row['id'];
        $userAllowedDeptNumbers[] = $row['numero_departement'];
    }
}

// Déterminer si le menu doit être filtré
$filterMenu = ($currentUserType == 3 || $currentUserType == 4) && !empty($userAllowedDeptNumbers);

// Pour les référents (3) et membres (4), récupérer les cantons autorisés en écriture
$userWritableCantons = [];
if ($currentUserType == 3 || $currentUserType == 4) {
    $stmtCantons = $pdo->prepare("
        SELECT DISTINCT canton
        FROM gestionAccesCantons
        WHERE utilisateur_id = ?
    ");
    $stmtCantons->execute([$currentUserId]);
    $userWritableCantons = $stmtCantons->fetchAll(PDO::FETCH_COLUMN);
}

// Détection du mode "département direct" via URL
$deptMode = isset($_GET['dept']) ? trim($_GET['dept']) : null;
$deptData = null;

if ($deptMode) {
    // Rechercher le département par numéro ou par nom via arborescence
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
// Pour les référents et membres, filtrer selon leurs départements autorisés
if ($filterMenu && !empty($userAllowedDeptNumbers)) {
    // Créer les placeholders pour la requête IN
    $placeholders = str_repeat('?,', count($userAllowedDeptNumbers) - 1) . '?';
    $regionsStmt = $pdo->prepare("
        SELECT a.libelle as region, COUNT(m.id) as nb_maires
        FROM arborescence a
        LEFT JOIN arborescence d ON d.parent_id = a.id AND d.type_element = 'departement'
        LEFT JOIN maires m ON d.reference_id = m.numero_departement AND m.numero_departement IN ($placeholders)
        WHERE a.type_element = 'region'
        GROUP BY a.id, a.libelle
        HAVING nb_maires > 0
        ORDER BY a.libelle ASC
    ");
    $regionsStmt->execute($userAllowedDeptNumbers);
} else {
    $regionsStmt = $pdo->query("
        SELECT a.libelle as region, COUNT(m.id) as nb_maires
        FROM arborescence a
        LEFT JOIN arborescence d ON d.parent_id = a.id AND d.type_element = 'departement'
        LEFT JOIN maires m ON d.reference_id = m.numero_departement
        WHERE a.type_element = 'region'
        GROUP BY a.id, a.libelle
        ORDER BY a.libelle ASC
    ");
}
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

// Statistiques globales (filtrées pour référents/membres)
if ($filterMenu && !empty($userAllowedDeptNumbers)) {
    $placeholders = str_repeat('?,', count($userAllowedDeptNumbers) - 1) . '?';
    $statsStmt = $pdo->prepare("
        SELECT
            COUNT(*) as total_maires,
            COUNT(DISTINCT region) as total_regions,
            COUNT(DISTINCT numero_departement) as total_departements,
            COUNT(DISTINCT ville) as total_villes
        FROM maires
        WHERE numero_departement IN ($placeholders)
    ");
    $statsStmt->execute($userAllowedDeptNumbers);
} else {
    $statsStmt = $pdo->query("
        SELECT
            COUNT(*) as total_maires,
            COUNT(DISTINCT region) as total_regions,
            COUNT(DISTINCT numero_departement) as total_departements,
            COUNT(DISTINCT ville) as total_villes
        FROM maires
    ");
}
$stats = $statsStmt->fetch(PDO::FETCH_ASSOC);

// Récupérer les listes pour les datalists via arborescence (filtrées pour référents/membres)
if ($filterMenu && !empty($userAllowedDeptNumbers)) {
    $placeholders = str_repeat('?,', count($userAllowedDeptNumbers) - 1) . '?';

    // Départements via arborescence
    $departementsListStmt = $pdo->prepare("
        SELECT a.libelle as dept_display
        FROM arborescence a
        WHERE a.type_element = 'departement' AND a.reference_id IN ($placeholders)
        ORDER BY a.reference_id ASC
    ");
    $departementsListStmt->execute($userAllowedDeptNumbers);

    // Communes restent via maires (données spécifiques)
    $communesListStmt = $pdo->prepare("
        SELECT DISTINCT ville
        FROM maires
        WHERE numero_departement IN ($placeholders)
        ORDER BY ville ASC
    ");
    $communesListStmt->execute($userAllowedDeptNumbers);

    // Cantons via arborescence
    $cantonsListStmt = $pdo->prepare("
        SELECT DISTINCT a.libelle as canton
        FROM arborescence a
        JOIN arborescence c ON a.parent_id = c.id
        JOIN arborescence d ON c.parent_id = d.id
        WHERE a.type_element = 'canton' AND d.reference_id IN ($placeholders)
        ORDER BY a.libelle ASC
    ");
    $cantonsListStmt->execute($userAllowedDeptNumbers);
} else {
    // Départements via arborescence
    $departementsListStmt = $pdo->query("
        SELECT a.libelle as dept_display
        FROM arborescence a
        WHERE a.type_element = 'departement'
        ORDER BY a.reference_id ASC
    ");

    // Communes restent via maires (données spécifiques)
    $communesListStmt = $pdo->query("
        SELECT DISTINCT ville
        FROM maires
        ORDER BY ville ASC
    ");

    // Cantons via arborescence
    $cantonsListStmt = $pdo->query("
        SELECT a.libelle as canton
        FROM arborescence a
        WHERE a.type_element = 'canton'
        ORDER BY a.libelle ASC
    ");
}
$departementsList = $departementsListStmt->fetchAll(PDO::FETCH_COLUMN);
$communesList = $communesListStmt->fetchAll(PDO::FETCH_COLUMN);
$cantonsList = $cantonsListStmt->fetchAll(PDO::FETCH_COLUMN);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annuaire des Maires de France</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="ressources/css/styles-maires.css?v=<?= time() ?>">
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
                <h1>🏛️ Régions de France</h1>

                <!-- Case à cocher communes traitées -->
                <div style="margin-top: 10px; padding: 6px 8px; background: rgba(255,255,255,0.1); border-radius: 4px; display: flex; align-items: center; gap: 6px; cursor: pointer;" onclick="document.getElementById('communesTraitees').click()">
                    <input type="checkbox" id="communesTraitees" style="cursor: pointer; width: 14px; height: 14px;" onchange="toggleCommunesTraitees()" />
                    <label for="communesTraitees" style="cursor: pointer; font-size: 0.75em; margin: 0; user-select: none;">Communes traitées</label>
                </div>
            </div>

            <div class="regions-list" id="regionsList">
                <!-- Régions métropolitaines -->
                <?php foreach ($regions as $region): ?>
                <div class="region-item">
                    <div class="region-header" data-region="<?= htmlspecialchars($region['region']) ?>">
                        <span class="region-name">
                            <span class="region-arrow">▶</span>
                            <?= htmlspecialchars($region['region']) ?>
                        </span>
                        <span class="region-count"><?= number_format($region['nb_maires']) ?></span>
                    </div>
                    <div class="departements-list"></div>
                </div>
                <?php endforeach; ?>

                <!-- Section DOM-TOM -->
                <?php if (!empty($domtom)):
                    // Calculer les régions DOM-TOM sous forme de liste pour la requête
                    $domtomRegions = array_column($domtom, 'region');
                ?>
                <div class="region-item domtom-section">
                    <div class="region-header domtom-header" data-domtom-regions="<?= htmlspecialchars(json_encode($domtomRegions)) ?>">
                        <span class="region-name">
                            <span class="region-arrow">▶</span>
                            🌴 DOM-TOM
                        </span>
                        <span class="region-count"><?= number_format(array_sum(array_column($domtom, 'nb_maires'))) ?></span>
                    </div>
                    <div class="departements-list"></div>
                </div>
                <?php endif; ?>
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
            </div>

            <div class="content-body" id="contentBody">
                <!-- Recherche avancée -->
                <div class="search-advanced collapsed" id="searchAdvanced" <?= $deptMode ? 'style="display: none;"' : '' ?>>
                    <div class="search-advanced-header" id="searchAdvancedToggle">
                        <h3><i class="bi bi-search me-2"></i>Recherche avancée</h3>
                        <span class="search-toggle-icon"><i class="bi bi-chevron-down"></i></span>
                    </div>
                    <div class="search-advanced-body">
                        <div class="search-grid">
                            <div class="search-field search-field-btn">
                                <label style="opacity: 0;">.</label>
                                <button class="btn-reset-modern" onclick="resetAdvancedSearch()" title="Réinitialiser les filtres">
                                    <i class="bi bi-arrow-counterclockwise"></i>
                                </button>
                            </div>

                            <div class="search-field">
                                <label for="searchRegion"><i class="bi bi-globe-europe-africa me-1"></i>Région</label>
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
                                <label for="searchDepartement"><i class="bi bi-geo-alt me-1"></i>Département</label>
                                <input type="text" id="searchDepartement" placeholder="Ex: 75, Paris" autocomplete="off">
                                <div class="autocomplete-list" id="departement-autocomplete"></div>
                            </div>

                            <div class="search-field">
                                <label for="searchCanton"><i class="bi bi-pin-map me-1"></i>Canton</label>
                                <input type="text" id="searchCanton" placeholder="Ex: Canton de Paris" autocomplete="off">
                                <div class="autocomplete-list" id="canton-autocomplete-advanced"></div>
                            </div>

                            <div class="search-field">
                                <label for="searchCommune"><i class="bi bi-building me-1"></i>Commune</label>
                                <input type="text" id="searchCommune" placeholder="Ex: Paris, Lyon" autocomplete="off">
                                <div class="autocomplete-list" id="commune-autocomplete-advanced"></div>
                            </div>

                            <div class="search-field search-field-small">
                                <label for="searchNbHabitants"><i class="bi bi-people me-1"></i>Hab. max</label>
                                <input type="number" id="searchNbHabitants" placeholder="Max" min="0">
                            </div>
                        </div>

                        <div class="search-actions">
                            <button class="btn-search" id="btnAdvancedSearch">
                                <i class="bi bi-search me-1"></i>Rechercher
                            </button>
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

        // Filtrage des départements pour référents et membres
        window.USER_FILTER = {
            enabled: <?= $filterMenu ? 'true' : 'false' ?>,
            userType: <?= $currentUserType ?>,
            allowedDeptNumbers: <?= json_encode($userAllowedDeptNumbers) ?>,
            // Cantons en écriture pour les membres (type 4)
            writableCantons: <?= json_encode($userWritableCantons) ?>
        };
    </script>
    <script src="ressources/js/scripts-maires.js?v=<?= time() ?>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
