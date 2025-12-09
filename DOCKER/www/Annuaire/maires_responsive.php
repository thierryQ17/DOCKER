<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

// La connexion PDO est déjà créée dans auth_middleware.php
// On utilise la même instance $pdo

// Récupérer les informations de l'utilisateur connecté
$currentUserType = $_SESSION['user_type'] ?? 0;
$currentUserId = $_SESSION['user_id'] ?? 0;

// Charger les types d'utilisateurs depuis la base de données
try {
    $stmtTypes = $pdo->query("SELECT id, nom FROM typeUtilisateur ORDER BY id");
    $userTypeLabels = $stmtTypes->fetchAll(PDO::FETCH_KEY_PAIR);
} catch (PDOException $e) {
    $userTypeLabels = [];
}

// Fallback si la table est vide ou erreur
if (empty($userTypeLabels)) {
    $userTypeLabels = [
        1 => 'Admin Général',
        2 => 'Admin',
        3 => 'Référent',
        4 => 'Membre'
    ];
}

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

// Récupérer la région du premier département autorisé (pour auto-déplier le menu) via arborescence
$userFirstDeptRegion = null;
$userFirstDeptNumero = null;
$userFirstDeptNom = null;
if (!empty($userAllowedDeptNumbers)) {
    $stmtFirstDept = $pdo->prepare("
        SELECT
            p.libelle as region,
            a.reference_id as numero_departement,
            SUBSTRING(a.libelle, LOCATE(' - ', a.libelle) + 3) as nom_departement
        FROM arborescence a
        JOIN arborescence p ON a.parent_id = p.id
        WHERE a.type_element = 'departement' AND a.reference_id = ?
        LIMIT 1
    ");
    $stmtFirstDept->execute([$userAllowedDeptNumbers[0]]);
    $firstDeptData = $stmtFirstDept->fetch(PDO::FETCH_ASSOC);
    if ($firstDeptData) {
        $userFirstDeptRegion = $firstDeptData['region'];
        $userFirstDeptNumero = $firstDeptData['numero_departement'];
        $userFirstDeptNom = $firstDeptData['nom_departement'];
    }
}

// Détection du mode "département direct" via URL
$deptMode = isset($_GET['dept']) ? trim($_GET['dept']) : null;
$deptData = null;

if ($deptMode) {
    // Recherche via arborescence
    if (is_numeric($deptMode)) {
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
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>Annuaire Maires - Mobile</title>

    <!-- Bootstrap 5.3.2 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="ressources/css/styles-maires-responsive.css?v=<?= time() ?>">

    <!-- Preconnect pour optimisation -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
</head>
<body>
    <!-- Navbar - masquée si dans iframe -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top shadow-sm iframe-hide" id="mainNavbar" style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">
        <div class="container-fluid">
            <div class="d-flex align-items-center">
                <a href="maires_responsive.php" class="navbar-brand-logo d-flex align-items-center text-decoration-none">
                    <img src="ressources/images/logoUPR.png" alt="Logo UPR" style="height: 40px; width: auto; min-width: 40px; filter: brightness(1.2);" onerror="this.style.display='none'">
                    <div class="ms-2">
                        <div class="text-white fw-bold" style="font-size: 0.9rem; line-height: 1.1;">Annuaire Maires</div>
                        <div class="text-white-50" style="font-size: 0.7rem;">Parrainage 2027</div>
                    </div>
                </a>
                <button class="navbar-toggler border-0 ms-2" type="button" id="menuToggle" aria-label="Menu">
                    <i class="bi bi-list fs-3"></i>
                </button>
            </div>
            <?php if (AUTH_ENABLED && $auth->isLoggedIn()):
                $navUser = $auth->getUser();
            ?>
            <?php if ($currentUserType <= 3): ?>
            <a href="rapport_referent.php" class="btn-rapport-nav" title="Rapport Référents">
                <i class="bi bi-graph-up-arrow"></i>
                <span class="d-none d-md-inline ms-1">Rapport</span>
            </a>
            <?php endif; ?>
            <div class="user-profile-container">
                <a href="logout.php" class="btn-logout-nav" title="Déconnexion" id="btnLogout">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
                <!-- Popup info utilisateur -->
                <div class="user-profile-popup" id="userProfilePopup">
                    <div class="popup-header">
                        <div class="popup-avatar">
                            <?= strtoupper(substr($navUser['prenom'] ?? '', 0, 1) . substr($navUser['nom'] ?? '', 0, 1)) ?>
                        </div>
                        <div class="popup-user-info">
                            <div class="popup-user-name"><?= htmlspecialchars(($navUser['prenom'] ?? '') . ' ' . ($navUser['nom'] ?? '')) ?></div>
                            <div class="popup-user-email"><?= htmlspecialchars($navUser['email'] ?? '') ?></div>
                        </div>
                    </div>
                    <div class="popup-body">
                        <div class="popup-info-row">
                            <i class="bi bi-shield-check"></i>
                            <span><?= htmlspecialchars($userTypeLabels[$navUser['type'] ?? 4] ?? 'Membre') ?></span>
                        </div>
                        <?php if (!empty($navUser['telephone'])): ?>
                        <div class="popup-info-row">
                            <i class="bi bi-telephone"></i>
                            <span><?= htmlspecialchars($navUser['telephone']) ?></span>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="popup-footer">
                        <a href="logout.php" class="popup-logout-btn">
                            <i class="bi bi-box-arrow-right"></i>
                            Se déconnecter
                        </a>
                    </div>
                </div>
            </div>
            <?php endif; ?>
        </div>
    </nav>

    <!-- Sidebar Offcanvas -->
    <?php $showMenuOnLoad = !$deptMode; ?>
    <div class="offcanvas offcanvas-start" tabindex="-1" id="sidebarMenu">
        <!-- Header avec bouton fermer -->
        <div class="offcanvas-header-modern">
            <h5 class="offcanvas-title mb-0">Région(s) sélectionnée(s)</h5>
            <button type="button" class="btn-close-modern ms-auto" data-bs-dismiss="offcanvas" aria-label="Fermer">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="offcanvas-body p-0">
            <!-- Liste des régions -->
            <div class="accordion accordion-flush" id="regionsAccordion">
                <!-- Régions métropolitaines -->
                <?php foreach ($regions as $index => $region): ?>
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#region<?= $index ?>" data-region="<?= htmlspecialchars($region['region']) ?>">
                            <span class="me-auto"><?= htmlspecialchars($region['region']) ?></span>
                            <span class="badge bg-primary rounded-pill ms-2"><?= number_format($region['nb_maires']) ?></span>
                        </button>
                    </h2>
                    <div id="region<?= $index ?>" class="accordion-collapse collapse" data-bs-parent="#regionsAccordion">
                        <div class="accordion-body p-0">
                            <div class="list-group list-group-flush" data-departements-container></div>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>

                <!-- DOM-TOM -->
                <?php if (!empty($domtom)): ?>
                <div class="accordion-item border-top-2">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed bg-info-subtle" type="button"
                                data-bs-toggle="collapse" data-bs-target="#domtom"
                                data-domtom-regions='<?= htmlspecialchars(json_encode(array_column($domtom, 'region'))) ?>'>
                            <span class="me-auto"><i class="bi bi-globe-americas me-2"></i>DOM-TOM</span>
                            <span class="badge bg-info rounded-pill ms-2"><?= number_format(array_sum(array_column($domtom, 'nb_maires'))) ?></span>
                        </button>
                    </h2>
                    <div id="domtom" class="accordion-collapse collapse">
                        <div class="accordion-body p-0">
                            <div class="list-group list-group-flush" data-departements-container></div>
                        </div>
                    </div>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Contenu principal -->
    <main class="main-content">

        <!-- Résultats -->
        <div class="container-fluid px-2" id="resultsContainer">
            <div class="empty-state text-center py-5">
                <i class="bi bi-search text-muted" style="font-size: 4rem;"></i>
                <h5 class="mt-3 text-muted">Sélectionnez une région</h5>
                <p class="text-muted small">Utilisez le menu ou la recherche</p>
            </div>
        </div>
    </main>

    <!-- Modal Maire (Bottom Sheet) -->
    <div class="modal fade" id="maireModal" tabindex="-1">
        <div class="modal-dialog modal-fullscreen-sm-down modal-dialog-bottom">
            <div class="modal-content">
                <div class="modal-header text-white" style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); position: relative;">
                    <h5 class="modal-title" id="modalTitle">Détails du maire</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" title="Fermer la fiche" style="position: absolute; top: 55px; right: 12px;"></button>
                </div>
                <div class="modal-body" id="modalBody">
                    <!-- Contenu chargé dynamiquement -->
                </div>
                <div class="modal-footer" id="modalActions">
                    <!-- Boutons chargés dynamiquement -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Filtres (Bottom Sheet) -->
    <div class="modal fade" id="filtresModal" tabindex="-1">
        <div class="modal-dialog modal-fullscreen-sm-down modal-dialog-bottom">
            <div class="modal-content filter-modal-modern">
                <div class="modal-header filter-header-modern">
                    <div class="filter-toolbar">
                        <button class="filter-btn filter-btn-reset" id="btnResetFiltersMobile" title="Réinitialiser les filtres">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </button>
                        <button class="filter-btn filter-btn-list" id="btnShowAllMobile" title="Tout afficher">
                            <i class="bi bi-list-ul"></i>
                        </button>
                        <button class="filter-btn filter-btn-export" id="btnExportExcelMobile" title="Exporter en Excel">
                            <i class="bi bi-file-earmark-excel"></i>
                        </button>
                    </div>
                    <button type="button" class="filter-btn-close" data-bs-dismiss="modal" aria-label="Fermer">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
                <div class="modal-body filter-body-modern">
                    <!-- Liste déroulante pour filtre combiné cantons -->
                    <div class="filter-combo-container" id="filterComboContainer">
                        <select class="form-select filter-select-modern" id="filterComboMobile">
                            <option value="">-- Sélectionner un canton --</option>
                        </select>
                    </div>
                    <div class="filter-row">
                        <label class="filter-label">
                            <i class="bi bi-geo-alt"></i>
                            Circo
                        </label>
                        <input type="text" class="form-control filter-input-modern" id="filterCircoMobile" placeholder="N°...">
                    </div>
                    <div class="filter-row">
                        <label class="filter-label">
                            <i class="bi bi-pin-map"></i>
                            Canton
                        </label>
                        <input type="text" class="form-control filter-input-modern" id="filterCantonMobile" placeholder="Nom...">
                    </div>
                    <div class="filter-row">
                        <label class="filter-label">
                            <i class="bi bi-building"></i>
                            Commune
                        </label>
                        <input type="text" class="form-control filter-input-modern" id="filterCommuneMobile" placeholder="Nom...">
                    </div>
                    <div class="filter-row">
                        <label class="filter-label">
                            <i class="bi bi-people"></i>
                            Hab. max
                        </label>
                        <input type="number" class="form-control filter-input-modern" id="filterHabitantsMobile" placeholder="Max..." value="<?= $GLOBALS['filtreHabitants'] ?>">
                    </div>
                    <!-- Boutons d'action rapide (discrets en bas) -->
                    <div class="filter-quick-actions-bottom">
                        <button class="btn-quick-discrete" id="btnToutesFichesMobile">
                            <i class="bi bi-list-ul"></i>
                            <span>Toutes les fiches</span>
                        </button>
                        <button class="btn-quick-discrete" id="btnFilterDemarchageMobile">
                            <i class="bi bi-check2-square"></i>
                            <span>Communes traitées</span>
                        </button>
                        <button class="btn-quick-discrete" id="btnMesCommunesMobile">
                            <i class="bi bi-geo-alt-fill"></i>
                            <span>Mes communes attitrées</span>
                        </button>
                        <button class="btn-quick-discrete" id="btnMesCommunes1000Mobile">
                            <i class="bi bi-people"></i>
                            <span>Mes communes attitrées &lt; <?= $GLOBALS['filtreHabitants'] ?> hab.</span>
                        </button>
                    </div>
                </div>
                <div class="modal-footer filter-footer-modern">
                    <button type="button" class="btn-filter-cancel" data-bs-dismiss="modal">
                        Annuler
                    </button>
                    <button type="button" class="btn-filter-apply" id="btnApplyFiltersMobile">
                        <i class="bi bi-search me-1"></i>Appliquer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script>
        // Configuration globale depuis menus.json
        window.APP_CONFIG = {
            filtreHabitants: <?= $GLOBALS['filtreHabitants'] ?>
        };

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

        // Filtrage des départements pour référents et membres
        window.USER_FILTER = {
            enabled: <?= $filterMenu ? 'true' : 'false' ?>,
            userType: <?= $currentUserType ?>,
            allowedDeptNumbers: <?= json_encode($userAllowedDeptNumbers) ?>,
            // Cantons en écriture pour les membres (type 4)
            writableCantons: <?= json_encode($userWritableCantons) ?>,
            // Premier département autorisé (pour auto-déplier le menu)
            firstDeptRegion: <?= $userFirstDeptRegion ? "'" . htmlspecialchars($userFirstDeptRegion) . "'" : 'null' ?>,
            firstDeptNumero: <?= $userFirstDeptNumero ? "'" . htmlspecialchars($userFirstDeptNumero) . "'" : 'null' ?>,
            firstDeptNom: <?= $userFirstDeptNom ? "'" . htmlspecialchars($userFirstDeptNom) . "'" : 'null' ?>
        };
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="ressources/js/scripts-maires-responsive.js?v=<?= time() ?>"></script>

    <!-- Gestion popup profil utilisateur : survol = popup, clic = déconnexion -->
    <script>
    (function() {
        const btnLogout = document.getElementById('btnLogout');
        const popup = document.getElementById('userProfilePopup');
        const container = document.querySelector('.user-profile-container');
        let closeTimeout = null;

        if (!btnLogout || !popup || !container) return;

        // Clic = déconnexion directe
        btnLogout.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = 'logout.php';
        });

        // Survol = affiche la popup
        container.addEventListener('mouseenter', function() {
            if (closeTimeout) {
                clearTimeout(closeTimeout);
                closeTimeout = null;
            }
            popup.classList.add('active');
        });

        // Quitter la zone = ferme après 1 seconde
        container.addEventListener('mouseleave', function() {
            closeTimeout = setTimeout(function() {
                popup.classList.remove('active');
            }, 1000);
        });
    })();
    </script>

    <!-- Ouverture automatique du menu -->
    <?php if ($showMenuOnLoad): ?>
    <script>
    // Ouvrir le menu automatiquement via l'API Bootstrap
    var sidebar = document.getElementById('sidebarMenu');
    if (sidebar) {
        var bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(sidebar);
        bsOffcanvas.show();

        // Auto-déplier la région de l'utilisateur si définie
        if (window.USER_FILTER && window.USER_FILTER.firstDeptRegion) {
            // Attendre que le menu soit ouvert puis déplier la région
            sidebar.addEventListener('shown.bs.offcanvas', function autoExpandRegion() {
                // Trouver le bouton de la région correspondante
                var regionButtons = document.querySelectorAll('#regionsAccordion .accordion-button');
                regionButtons.forEach(function(btn) {
                    if (btn.getAttribute('data-region') === window.USER_FILTER.firstDeptRegion) {
                        // Déclencher le clic pour ouvrir l'accordion
                        if (btn.classList.contains('collapsed')) {
                            btn.click();
                        }
                    }
                });
                // Retirer l'écouteur après utilisation
                sidebar.removeEventListener('shown.bs.offcanvas', autoExpandRegion);
            }, { once: true });
        }
    }
    </script>
    <?php endif; ?>
</body>
</html>