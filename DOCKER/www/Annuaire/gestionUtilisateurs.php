<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

/**
 * Interface complète de gestion des utilisateurs
 * Centralise la gestion des utilisateurs et leurs droits
 *
 * Contrôle d'accès par rôle :
 * - Super Admin (1) : voit tous les utilisateurs
 * - Admin (2) : voit uniquement les référents et membres
 * - Référent (3) : voit uniquement les membres de ses départements
 * - Membre (4) : accès interdit
 */

// Forcer l'encodage UTF-8
header('Content-Type: text/html; charset=utf-8');
mb_internal_encoding('UTF-8');

// Configuration de la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->exec("SET NAMES 'utf8mb4'");
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Récupérer les informations de l'utilisateur connecté
$currentUserType = $_SESSION['user_type'] ?? 0;
$currentUserId = $_SESSION['user_id'] ?? 0;
$currentUserName = ($_SESSION['user_prenom'] ?? '') . ' ' . ($_SESSION['user_nom'] ?? '');

// Les membres (4) n'ont pas accès à cette interface
if ($currentUserType == 4) {
    header('Location: maires_responsive.php');
    exit;
}

// Charger les types d'utilisateurs depuis la base de données
$stmtTypes = $pdo->query("SELECT id, nom FROM typeUtilisateur ORDER BY id");
$userTypes = $stmtTypes->fetchAll(PDO::FETCH_KEY_PAIR);

// Fallback si la table est vide
if (empty($userTypes)) {
    $userTypes = [
        1 => 'Super DUPOND',
        2 => 'Admin',
        3 => 'Référent',
        4 => 'Membre'
    ];
}

// Pour compatibilité avec l'ancien code
$roleLabels = $userTypes;

// Pour les référents, récupérer leurs départements autorisés (IDs)
$referentAllowedDepts = [];
if ($currentUserType == 3) {
    $stmtDepts = $pdo->prepare("
        SELECT DISTINCT departement_id
        FROM gestionAccesDepartements
        WHERE utilisateur_id = ?
    ");
    $stmtDepts->execute([$currentUserId]);
    $referentAllowedDepts = $stmtDepts->fetchAll(PDO::FETCH_COLUMN);
}

// Statistiques globales - filtrées selon le rôle de l'utilisateur connecté
if ($currentUserType == 1) {
    // Super Admin : voit tous les utilisateurs
    $statsUtilisateurs = $pdo->query("
        SELECT
            COUNT(*) as total,
            COUNT(CASE WHEN typeUtilisateur_id = 1 THEN 1 END) as super_admin,
            COUNT(CASE WHEN typeUtilisateur_id = 2 THEN 1 END) as admin,
            COUNT(CASE WHEN typeUtilisateur_id = 3 THEN 1 END) as referent,
            COUNT(CASE WHEN typeUtilisateur_id = 4 THEN 1 END) as membre,
            COUNT(CASE WHEN typeUtilisateur_id = 5 THEN 1 END) as president
        FROM utilisateurs
    ")->fetch(PDO::FETCH_ASSOC);
} elseif ($currentUserType == 2) {
    // Admin : voit uniquement les référents (3) et membres (4)
    $statsUtilisateurs = $pdo->query("
        SELECT
            COUNT(*) as total,
            0 as super_admin,
            0 as admin,
            COUNT(CASE WHEN typeUtilisateur_id = 3 THEN 1 END) as referent,
            COUNT(CASE WHEN typeUtilisateur_id = 4 THEN 1 END) as membre,
            0 as president
        FROM utilisateurs
        WHERE typeUtilisateur_id IN (3, 4)
    ")->fetch(PDO::FETCH_ASSOC);
} elseif ($currentUserType == 3) {
    // Référent : voit uniquement les membres (4) de ses départements
    $stmtReferentDepts = $pdo->prepare("
        SELECT DISTINCT departement_id FROM gestionAccesDepartements WHERE utilisateur_id = ?
    ");
    $stmtReferentDepts->execute([$currentUserId]);
    $referentDepts = $stmtReferentDepts->fetchAll(PDO::FETCH_COLUMN);

    if (!empty($referentDepts)) {
        $placeholders = str_repeat('?,', count($referentDepts) - 1) . '?';
        $stmtStats = $pdo->prepare("
            SELECT
                COUNT(DISTINCT u.id) as total,
                0 as super_admin,
                0 as admin,
                0 as referent,
                COUNT(DISTINCT u.id) as membre,
                0 as president
            FROM utilisateurs u
            WHERE u.typeUtilisateur_id = 4
            AND u.id IN (
                SELECT DISTINCT utilisateur_id
                FROM gestionAccesDepartements
                WHERE departement_id IN ($placeholders)
            )
        ");
        $stmtStats->execute($referentDepts);
        $statsUtilisateurs = $stmtStats->fetch(PDO::FETCH_ASSOC);
    } else {
        $statsUtilisateurs = ['total' => 0, 'super_admin' => 0, 'admin' => 0, 'referent' => 0, 'membre' => 0, 'president' => 0];
    }
} else {
    $statsUtilisateurs = ['total' => 0, 'super_admin' => 0, 'admin' => 0, 'referent' => 0, 'membre' => 0, 'president' => 0];
}

$statsDroits = $pdo->query("
    SELECT
        COUNT(DISTINCT departement_id) as nb_departements,
        COUNT(DISTINCT utilisateur_id) as nb_utilisateurs_avec_droits
    FROM gestionAccesDepartements
")->fetch(PDO::FETCH_ASSOC);

$statsDroitsCantons = $pdo->query("
    SELECT
        COUNT(DISTINCT canton) as nb_cantons,
        COUNT(DISTINCT utilisateur_id) as nb_responsables
    FROM gestionAccesCantons
    WHERE utilisateur_id IS NOT NULL
")->fetch(PDO::FETCH_ASSOC);

// Récupérer les accès de l'utilisateur connecté (pour l'onglet "Mes accès")
$myDepartements = [];
$myCantons = [];

// Départements de l'utilisateur connecté (consultation)
$stmtMyDepts = $pdo->prepare("
    SELECT DISTINCT d.numero_departement, d.nom_departement, d.region
    FROM gestionAccesDepartements gd
    JOIN departements d ON gd.departement_id = d.id
    WHERE gd.utilisateur_id = ?
    ORDER BY d.region ASC, d.numero_departement ASC
");
$stmtMyDepts->execute([$currentUserId]);
$myDepartements = $stmtMyDepts->fetchAll(PDO::FETCH_ASSOC);

// Cantons sélectionnés par l'utilisateur connecté
$stmtMyCantons = $pdo->prepare("
    SELECT DISTINCT canton, numero_departement
    FROM gestionAccesCantons
    WHERE utilisateur_id = ?
");
$stmtMyCantons->execute([$currentUserId]);
$myCantons = $stmtMyCantons->fetchAll(PDO::FETCH_ASSOC);
$mySelectedCantons = array_map(fn($c) => $c['numero_departement'] . '|' . $c['canton'], $myCantons);

// Tous les cantons disponibles dans les départements autorisés
$allCantonsForMyDepts = [];
if (!empty($myDepartements)) {
    $deptNumbers = array_column($myDepartements, 'numero_departement');
    $placeholders = implode(',', array_fill(0, count($deptNumbers), '?'));
    $stmtAllCantons = $pdo->prepare("
        SELECT DISTINCT m.canton, m.numero_departement, m.nom_departement, m.circonscription
        FROM maires m
        WHERE m.numero_departement IN ($placeholders)
        ORDER BY m.numero_departement ASC, m.canton ASC
    ");
    $stmtAllCantons->execute($deptNumbers);
    $allCantonsForMyDepts = $stmtAllCantons->fetchAll(PDO::FETCH_ASSOC);
}

// Récupérer la liste des départements pour le formulaire (DOM-TOM à la fin)
$allDepartements = $pdo->query("
    SELECT id, numero_departement, nom_departement, region
    FROM departements
    ORDER BY
        CASE WHEN numero_departement LIKE '97%' OR numero_departement LIKE '98%' THEN 1 ELSE 0 END,
        numero_departement ASC
")->fetchAll(PDO::FETCH_ASSOC);

?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Utilisateurs - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="ressources/css/gestionUtilisateurs.css?v=<?= time() ?>">
</head>
<body>
    <nav class="navbar navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-people-fill me-2"></i>Gestion des Utilisateurs
            </a>
        </div>
    </nav>

    <a href="maires_responsive.php" class="btn-back-round" title="Retour">
        <i class="bi bi-arrow-left"></i>
    </a>

    <div class="main-container">
        <!-- Dashboard Cards - Condensé -->
        <div class="row g-2 mb-3 justify-content-center">
            <div class="col-12">
                <div class="stats-card users" style="text-align: center; padding: 10px 20px;">
                    <div style="display: flex; align-items: center; justify-content: center; gap: 20px; flex-wrap: wrap;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div class="icon" style="margin-bottom: 0; width: 40px; height: 40px; font-size: 18px;">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div class="number" style="margin-bottom: 0; font-size: 24px;"><?= number_format($statsUtilisateurs['total'], 0, ',', ' ') ?></div>
                            <div class="label" style="font-size: 14px; text-transform: none; margin-bottom: 0;">Utilisateurs</div>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                            <?php if ($currentUserType == 1): // Super Admin voit tous les badges ?>
                            <span class="badge badge-president" onclick="filterByRole(5)" id="badge-role-5" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Président: <?= $statsUtilisateurs['president'] ?></span>
                            <span class="badge badge-super-admin" onclick="filterByRole(1)" id="badge-role-1" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Super DUPOND: <?= $statsUtilisateurs['super_admin'] ?></span>
                            <span class="badge badge-admin" onclick="filterByRole(2)" id="badge-role-2" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Admin: <?= $statsUtilisateurs['admin'] ?></span>
                            <span class="badge badge-referent" onclick="filterByRole(3)" id="badge-role-3" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Référent: <?= $statsUtilisateurs['referent'] ?></span>
                            <span class="badge badge-membre" onclick="filterByRole(4)" id="badge-role-4" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Membre: <?= $statsUtilisateurs['membre'] ?></span>
                            <?php elseif ($currentUserType == 2): // Admin voit référents et membres ?>
                            <span class="badge badge-referent" onclick="filterByRole(3)" id="badge-role-3" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Référent: <?= $statsUtilisateurs['referent'] ?></span>
                            <span class="badge badge-membre" onclick="filterByRole(4)" id="badge-role-4" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Membre: <?= $statsUtilisateurs['membre'] ?></span>
                            <?php elseif ($currentUserType == 3): // Référent voit uniquement les membres ?>
                            <span class="badge badge-membre" onclick="filterByRole(4)" id="badge-role-4" title="Cliquer pour filtrer" style="font-size: 11px; padding: 4px 8px;">Membre: <?= $statsUtilisateurs['membre'] ?></span>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Onglets -->
        <div class="custom-tabs">
            <ul class="nav nav-tabs" id="userTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="list-tab" data-bs-toggle="tab" data-bs-target="#list" type="button" role="tab">
                        <i class="bi bi-list-ul"></i>Liste des utilisateurs
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="region-tab" data-bs-toggle="tab" data-bs-target="#region" type="button" role="tab">
                        <i class="bi bi-diagram-3"></i>Utilisateurs par région
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="myaccess-tab" data-bs-toggle="tab" data-bs-target="#myaccess" type="button" role="tab">
                        <i class="bi bi-key"></i>Mes accès
                    </button>
                </li>
                <?php if ($currentUserType == 1): // Onglet Paramètres visible uniquement pour Super Admin ?>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="params-tab" data-bs-toggle="tab" data-bs-target="#params" type="button" role="tab">
                        <i class="bi bi-gear"></i>Paramètres
                    </button>
                </li>
                <?php endif; ?>
            </ul>
            <div class="tab-content">
                <!-- Liste des utilisateurs -->
                <div class="tab-pane fade show active" id="list" role="tabpanel">
                    <div class="quick-actions mb-4">
                        <button class="btn btn-primary" onclick="addUser()">
                            <i class="bi bi-plus-circle"></i>Nouvel utilisateur
                        </button>
                        <button class="btn btn-outline-primary" onclick="exportUsers()">
                            <i class="bi bi-download"></i>Exporter la liste
                        </button>
                        <button class="btn btn-outline-secondary" onclick="refreshUsers()">
                            <i class="bi bi-arrow-clockwise"></i>Actualiser
                        </button>
                    </div>

                    <div class="filters-bar">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-12">
                                <div class="search-box">
                                    <i class="bi bi-search"></i>
                                    <input type="text" class="form-control" id="searchUsers" placeholder="Rechercher un utilisateur...">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="users-table">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Email</th>
                                    <th>Menu/Départements</th>
                                    <th>Gestion Cantons</th>
                                    <th>Rôle</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="usersTableBody">
                                <tr>
                                    <td colspan="7" class="text-center">
                                        <i class="bi bi-arrow-repeat spin"></i> Chargement...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Utilisateurs par région -->
                <div class="tab-pane fade" id="region" role="tabpanel">
                    <div class="region-tree-container">
                        <div class="region-tree-header mb-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="bi bi-info-circle text-muted me-2"></i>
                                    <span class="text-muted">Vue en consultation uniquement - Arborescence des utilisateurs par région</span>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-secondary btn-sm" onclick="expandAllRegionNodes()">
                                        <i class="bi bi-arrows-expand"></i> Tout déplier
                                    </button>
                                    <button class="btn btn-outline-secondary btn-sm" onclick="collapseAllRegionNodes()">
                                        <i class="bi bi-arrows-collapse"></i> Tout replier
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Colonne Référents (visible pour Admin seulement) -->
                            <?php if ($currentUserType == 1 || $currentUserType == 2): ?>
                            <div class="col-md-6">
                                <div class="region-tree-section">
                                    <h6 class="section-title">
                                        <i class="bi bi-person-badge text-warning me-2"></i>Référents
                                        <span class="badge bg-warning text-dark ms-2" id="referentsCount">0</span>
                                        <div class="ms-auto d-flex align-items-center gap-3">
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="referentsViewMode" id="viewByReferent" value="referent" checked onchange="switchReferentsView('referent')">
                                                <label class="form-check-label small" for="viewByReferent">Par référent</label>
                                                <button type="button" class="btn btn-sm btn-link p-0 ms-1" id="btnShowAllReferents" onclick="showAllReferentsModal()" title="Voir tous les référents">
                                                    <i class="bi bi-grid-3x2-gap-fill text-warning"></i>
                                                </button>
                                            </div>
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="referentsViewMode" id="viewByRegion" value="region" onchange="switchReferentsView('region')">
                                                <label class="form-check-label small" for="viewByRegion">Par région</label>
                                            </div>
                                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="refreshRegionTree()" title="Rafraîchir">
                                                <i class="bi bi-arrow-clockwise"></i>
                                            </button>
                                        </div>
                                    </h6>
                                    <div id="referentsTree" class="tree-container">
                                        <div class="text-center text-muted py-3">
                                            <i class="bi bi-arrow-repeat spin"></i> Chargement...
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <?php endif; ?>

                            <!-- Colonne Membres -->
                            <div class="col-md-<?= ($currentUserType == 1 || $currentUserType == 2) ? '6' : '12' ?>">
                                <div class="region-tree-section">
                                    <h6 class="section-title">
                                        <i class="bi bi-people text-success me-2"></i>Membres
                                        <span class="badge bg-success ms-2" id="membresCount">0</span>
                                        <div class="ms-auto d-flex align-items-center gap-3">
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="membresViewMode" id="viewByMembre" value="membre" checked onchange="switchMembresView('membre')">
                                                <label class="form-check-label small" for="viewByMembre">Par membre</label>
                                                <button type="button" class="btn btn-sm btn-link p-0 ms-1" id="btnShowAllMembres" onclick="showAllMembresModal()" title="Voir tous les membres">
                                                    <i class="bi bi-grid-3x2-gap-fill text-success"></i>
                                                </button>
                                            </div>
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="membresViewMode" id="viewByRegionMembre" value="region" onchange="switchMembresView('region')">
                                                <label class="form-check-label small" for="viewByRegionMembre">Par région</label>
                                            </div>
                                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="refreshRegionTree()" title="Rafraîchir">
                                                <i class="bi bi-arrow-clockwise"></i>
                                            </button>
                                        </div>
                                    </h6>
                                    <div id="membresTree" class="tree-container">
                                        <div class="text-center text-muted py-3">
                                            <i class="bi bi-arrow-repeat spin"></i> Chargement...
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Mes accès -->
                <div class="tab-pane fade" id="myaccess" role="tabpanel">
                    <div class="row g-4">
                        <!-- Départements en consultation -->
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-header bg-info text-white">
                                    <i class="bi bi-eye me-2"></i>Départements <span class="badge bg-white text-info ms-2"><?= count($myDepartements) ?></span>
                                    <small class="d-block mt-1 opacity-75">Consultation uniquement</small>
                                </div>
                                <div class="card-body" style="max-height: 400px; overflow-y: auto;">
                                    <?php if (empty($myDepartements)): ?>
                                        <div class="text-muted text-center py-3">
                                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                            Aucun département attribué
                                        </div>
                                    <?php else: ?>
                                        <?php
                                        $currentRegion = null;
                                        foreach ($myDepartements as $dept):
                                            if ($currentRegion !== $dept['region']):
                                                if ($currentRegion !== null) echo '</ul>';
                                                $currentRegion = $dept['region'];
                                        ?>
                                        <h6 class="text-secondary mt-3 mb-2"><i class="bi bi-geo-alt me-1"></i><?= htmlspecialchars($dept['region']) ?></h6>
                                        <ul class="list-group list-group-flush">
                                        <?php endif; ?>
                                            <li class="list-group-item d-flex justify-content-between align-items-center py-2">
                                                <span>
                                                    <span class="badge bg-primary me-2"><?= htmlspecialchars($dept['numero_departement']) ?></span>
                                                    <?= htmlspecialchars($dept['nom_departement']) ?>
                                                </span>
                                                <i class="bi bi-eye text-info" title="Consultation"></i>
                                            </li>
                                        <?php endforeach; ?>
                                        <?php if (!empty($myDepartements)) echo '</ul>'; ?>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>

                        <!-- Cantons en modification -->
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                                    <div>
                                        <i class="bi bi-pencil-square me-2"></i>Cantons
                                        <span class="badge bg-white text-success ms-2" id="myAccessSelectedCount"><?= count($myCantons) ?></span>
                                        <small class="d-block mt-1 opacity-75">Cocher les cantons à modifier</small>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-light" id="btnSaveMyCantons" onclick="saveMyCantons()" title="Enregistrer les modifications">
                                        <i class="bi bi-check-lg me-1"></i>Enregistrer
                                    </button>
                                </div>
                                <div class="card-body p-0" style="max-height: 500px; overflow-y: auto;">
                                    <?php if (empty($allCantonsForMyDepts)): ?>
                                        <div class="text-muted text-center py-3">
                                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                            Aucun canton disponible
                                        </div>
                                    <?php else: ?>
                                        <?php
                                        $currentDept = null;
                                        $deptCantonCount = [];
                                        // Compter les cantons par département
                                        foreach ($allCantonsForMyDepts as $canton) {
                                            $dept = $canton['numero_departement'];
                                            if (!isset($deptCantonCount[$dept])) $deptCantonCount[$dept] = ['total' => 0, 'selected' => 0];
                                            $deptCantonCount[$dept]['total']++;
                                            $cantonKey = $dept . '|' . $canton['canton'];
                                            if (in_array($cantonKey, $mySelectedCantons)) $deptCantonCount[$dept]['selected']++;
                                        }

                                        foreach ($allCantonsForMyDepts as $canton):
                                            $cantonKey = $canton['numero_departement'] . '|' . $canton['canton'];
                                            $isSelected = in_array($cantonKey, $mySelectedCantons);

                                            if ($currentDept !== $canton['numero_departement']):
                                                if ($currentDept !== null) echo '</div></div>';
                                                $currentDept = $canton['numero_departement'];
                                                $deptStats = $deptCantonCount[$currentDept];
                                        ?>
                                        <div class="dept-section" data-dept="<?= htmlspecialchars($currentDept) ?>">
                                            <div class="dept-header d-flex justify-content-between align-items-center p-2 bg-light border-bottom" style="cursor: pointer;" onclick="toggleDeptSection(this)">
                                                <div>
                                                    <i class="bi bi-chevron-down me-1 dept-chevron"></i>
                                                    <span class="badge bg-primary me-1"><?= htmlspecialchars($currentDept) ?></span>
                                                    <strong><?= htmlspecialchars($canton['nom_departement']) ?></strong>
                                                </div>
                                                <div>
                                                    <span class="badge bg-success dept-selected-count"><?= $deptStats['selected'] ?></span>
                                                    <span class="text-muted small">/ <?= $deptStats['total'] ?></span>
                                                    <button type="button" class="btn btn-xs btn-outline-success ms-2" onclick="event.stopPropagation(); selectAllDept('<?= htmlspecialchars($currentDept) ?>')" title="Tout sélectionner">
                                                        <i class="bi bi-check-all"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-xs btn-outline-secondary" onclick="event.stopPropagation(); deselectAllDept('<?= htmlspecialchars($currentDept) ?>')" title="Tout désélectionner">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="dept-cantons p-2" style="display: block;">
                                        <?php endif; ?>
                                                <div class="form-check py-1 border-bottom">
                                                    <input class="form-check-input canton-checkbox" type="checkbox"
                                                           id="mycanton_<?= htmlspecialchars($cantonKey) ?>"
                                                           data-dept="<?= htmlspecialchars($canton['numero_departement']) ?>"
                                                           data-canton="<?= htmlspecialchars($canton['canton']) ?>"
                                                           <?= $isSelected ? 'checked' : '' ?>
                                                           onchange="updateCantonCounts()">
                                                    <label class="form-check-label w-100" for="mycanton_<?= htmlspecialchars($cantonKey) ?>" style="cursor: pointer;">
                                                        <small class="text-muted"><?= htmlspecialchars($canton['circonscription'] ?? '') ?>e circo -</small>
                                                        <?= htmlspecialchars($canton['canton']) ?>
                                                    </label>
                                                </div>
                                        <?php endforeach; ?>
                                        <?php if ($currentDept !== null) echo '</div></div>'; ?>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <?php if ($currentUserType == 1): // Contenu onglet Paramètres ?>
                <!-- Paramètres -->
                <div class="tab-pane fade" id="params" role="tabpanel">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-secondary text-white">
                                    <i class="bi bi-sliders me-2"></i>Paramètres généraux
                                </div>
                                <div class="card-body">
                                    <form id="paramsForm">
                                        <div class="mb-3">
                                            <label class="form-label" for="filtreHabitants">
                                                <i class="bi bi-people me-1"></i>Filtre habitants (communes)
                                            </label>
                                            <div class="input-group">
                                                <input type="number" class="form-control" id="filtreHabitants"
                                                       value="<?= $GLOBALS['filtreHabitants'] ?? 1000 ?>"
                                                       min="0" step="100">
                                                <span class="input-group-text">habitants</span>
                                            </div>
                                            <small class="text-muted">
                                                Affiche uniquement les communes avec moins de X habitants dans les filtres rapides.
                                            </small>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label" for="environnement">
                                                <i class="bi bi-gear me-1"></i>Environnement
                                            </label>
                                            <select class="form-select" id="environnement">
                                                <option value="dev" <?= ($GLOBALS['environnement'] ?? 'dev') === 'dev' ? 'selected' : '' ?>>
                                                    DEV - Mode développement (onglets Prod/Test visibles)
                                                </option>
                                                <option value="prod" <?= ($GLOBALS['environnement'] ?? 'dev') === 'prod' ? 'selected' : '' ?>>
                                                    PROD - Mode production (connexion simplifiée)
                                                </option>
                                            </select>
                                            <small class="text-muted">
                                                En mode PROD, la page de connexion affiche uniquement le formulaire standard (email/mdp).
                                            </small>
                                        </div>
                                        <div class="d-flex justify-content-end">
                                            <button type="button" class="btn btn-primary" onclick="saveParameters()">
                                                <i class="bi bi-check-lg me-1"></i>Enregistrer les paramètres
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-info text-white">
                                    <i class="bi bi-info-circle me-2"></i>Informations
                                </div>
                                <div class="card-body">
                                    <p class="mb-2"><strong>Configuration actuelle :</strong></p>
                                    <ul class="list-unstyled">
                                        <li><i class="bi bi-check-circle text-success me-2"></i>Filtre habitants : <strong id="currentFiltreHabitants"><?= $GLOBALS['filtreHabitants'] ?? 1000 ?></strong></li>
                                        <li><i class="bi bi-<?= ($GLOBALS['environnement'] ?? 'dev') === 'prod' ? 'shield-check text-success' : 'bug text-warning' ?> me-2"></i>Environnement : <strong id="currentEnvironnement"><?= strtoupper($GLOBALS['environnement'] ?? 'dev') ?></strong></li>
                                    </ul>
                                    <hr>
                                    <p class="text-muted small mb-0">
                                        <i class="bi bi-lightbulb me-1"></i>
                                        Ces paramètres sont stockés dans le fichier <code>config/menus.json</code>
                                        et sont appliqués à toute l'application.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Modale Utilisateur -->
    <div class="modal fade" id="userModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalTitle">
                        <i class="bi bi-person-plus me-2"></i>Nouvel utilisateur
                    </h5>
                    <span class="badge-role ms-2" id="userModalRoleBadge" style="display: none;"></span>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- Onglets -->
                    <ul class="nav nav-tabs mb-3" id="userModalTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button" role="tab">
                                <i class="bi bi-person-circle me-1"></i>Informations
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button" role="tab">
                                <i class="bi bi-shield-lock me-1"></i>Mot de passe
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="menu-tab" data-bs-toggle="tab" data-bs-target="#menu" type="button" role="tab">
                                <i class="bi bi-diagram-3 me-1"></i>Accès Menu
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="canton-tab" data-bs-toggle="tab" data-bs-target="#canton" type="button" role="tab">
                                <i class="bi bi-geo-alt me-1"></i>Accès Canton
                            </button>
                        </li>
                    </ul>

                    <!-- Contenu des onglets -->
                    <div class="tab-content" id="userModalTabContent">
                        <!-- Onglet Informations -->
                        <div class="tab-pane fade show active" id="info" role="tabpanel">
                            <form id="userForm">
                                <div class="d-flex gap-3">
                                    <!-- Formulaire à gauche -->
                                    <div class="compact-form flex-grow-1">
                                        <div class="form-row">
                                            <label class="form-label-inline">Prénom</label>
                                            <input type="text" class="form-control form-control-sm" id="userFirstName" required>
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline">Nom</label>
                                            <input type="text" class="form-control form-control-sm" id="userName" required>
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline">Email</label>
                                            <input type="email" class="form-control form-control-sm" id="userEmail" required>
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline">Téléphone</label>
                                            <input type="tel" class="form-control form-control-sm" id="userTelephone" placeholder="Ex: 06 12 34 56 78">
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline">Pseudo</label>
                                            <input type="text" class="form-control form-control-sm" id="userPseudo" required>
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline">Type</label>
                                            <select class="form-select form-select-sm" id="userType" required onchange="toggleDepartementField()">
                                                <?php if ($currentUserType == 1): // Super Admin peut créer tous les types ?>
                                                <option value="">Sélectionner...</option>
                                                <?php foreach ($userTypes as $typeId => $typeName): ?>
                                                <option value="<?= $typeId ?>"><?= htmlspecialchars($typeName) ?></option>
                                                <?php endforeach; ?>
                                                <?php elseif ($currentUserType == 2): // Admin peut créer référents et membres ?>
                                                <option value="">Sélectionner...</option>
                                                <option value="3"><?= htmlspecialchars($userTypes[3] ?? 'Référent') ?></option>
                                                <option value="4"><?= htmlspecialchars($userTypes[4] ?? 'Membre') ?></option>
                                                <?php elseif ($currentUserType == 3): // Référent peut créer uniquement des membres ?>
                                                <option value="4" selected><?= htmlspecialchars($userTypes[4] ?? 'Membre') ?></option>
                                                <?php endif; ?>
                                            </select>
                                        </div>
                                        <div class="form-row" id="departementRow" style="display: none;">
                                            <label class="form-label-inline">Département <span class="text-danger">*</span></label>
                                            <div class="dept-autocomplete" style="flex: 1; position: relative;">
                                                <input type="text" class="form-control form-control-sm" id="deptSearch" placeholder="Tapez pour rechercher..." autocomplete="off">
                                                <input type="hidden" id="userDepartement">
                                                <div id="deptDropdown" class="dept-dropdown"></div>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline">Statut</label>
                                            <select class="form-select form-select-sm" id="userStatus" required>
                                                <option value="1">Actif</option>
                                                <option value="0">Inactif</option>
                                            </select>
                                        </div>
                                        <div class="form-row">
                                            <label class="form-label-inline" style="align-self: flex-start; padding-top: 6px;">Commentaires</label>
                                            <textarea class="form-control form-control-sm" id="userCommentaires" rows="2" placeholder="Informations complémentaires..."></textarea>
                                        </div>
                                    </div>
                                    <!-- Photo à droite -->
                                    <div class="user-photo-container" style="flex-shrink: 0;">
                                        <div class="user-photo-box" id="userPhotoBox">
                                            <img src="" alt="Photo" id="userPhotoPreview" style="display: none;">
                                            <div class="user-photo-placeholder" id="userPhotoPlaceholder">
                                                <i class="bi bi-person-circle"></i>
                                                <span>Pas de photo</span>
                                            </div>
                                        </div>
                                        <input type="hidden" id="userImage">
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Onglet Mot de passe -->
                        <div class="tab-pane fade" id="password" role="tabpanel">
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <div class="password-generator-section" style="background: #f8fafc; padding: 12px; border-radius: 6px; border: 1px solid #e2e8f0; margin-bottom: 12px;">
                                        <div class="d-flex align-items-center justify-content-between mb-2">
                                            <label class="form-label mb-0" style="font-size: 12px;">
                                                <i class="bi bi-key me-1"></i>Générateur de mot de passe
                                            </label>
                                            <select class="form-select form-select-sm" id="passwordComplexity" style="width: auto; font-size: 12px;">
                                                <option value="medium">Moyen (8 caractères)</option>
                                                <option value="high" selected>Élevé (12 caractères)</option>
                                                <option value="very-high">Très élevé (16 caractères)</option>
                                            </select>
                                        </div>
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control" id="generatedPassword" readonly placeholder="Cliquez sur Générer" style="font-family: monospace; font-size: 12px;">
                                            <button class="btn btn-primary" type="button" onclick="generatePassword()" title="Générer un mot de passe">
                                                <i class="bi bi-arrow-clockwise"></i> Générer
                                            </button>
                                            <button class="btn btn-success" type="button" onclick="copyGeneratedPassword()" title="Copier dans les champs mot de passe" id="copyPasswordBtn" disabled>
                                                <i class="bi bi-clipboard-check"></i> Utiliser
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Mot de passe</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="userPassword" placeholder="Minimum 6 caractères">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility('userPassword', 'togglePasswordIcon1')">
                                            <i class="bi bi-eye" id="togglePasswordIcon1"></i>
                                        </button>
                                    </div>
                                    <small class="text-muted" id="passwordHint">Laisser vide pour ne pas changer</small>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Confirmer le mot de passe</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="userPasswordConfirm" placeholder="Répéter le mot de passe">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility('userPasswordConfirm', 'togglePasswordIcon2')">
                                            <i class="bi bi-eye" id="togglePasswordIcon2"></i>
                                        </button>
                                    </div>
                                    <small class="text-danger" id="passwordError" style="display: none;">Les mots de passe ne correspondent pas</small>
                                </div>
                            </div>
                        </div>

                        <!-- Onglet Accès Menu -->
                        <div class="tab-pane fade" id="menu" role="tabpanel">
                            <div id="menuTree" style="max-height: 400px; overflow-y: auto;">
                                <p class="text-muted">Chargement de l'arborescence...</p>
                            </div>
                        </div>

                        <!-- Onglet Accès Canton -->
                        <div class="tab-pane fade" id="canton" role="tabpanel">
                            <div id="cantonTree" style="max-height: 400px; overflow-y: auto;">
                                <p class="text-muted">Chargement de l'arborescence...</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" onclick="saveUser()">
                        <i class="bi bi-check-circle me-1"></i>Enregistrer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modale Référents par Région -->
    <div class="modal fade" id="regionReferentsModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <h5 class="modal-title" id="regionReferentsModalTitle">
                        <i class="bi bi-geo-alt-fill me-2"></i>Référents de la région
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="regionReferentsModalBody">
                    <!-- Contenu généré dynamiquement -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modale Détail Référent -->
    <div class="modal fade" id="referentDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white;">
                    <h5 class="modal-title" id="referentDetailModalTitle">
                        <i class="bi bi-person-badge me-2"></i>Détail du référent
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="referentDetailModalBody">
                    <!-- Contenu généré dynamiquement -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modale Tous les Référents -->
    <div class="modal fade" id="allReferentsModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #f6ad55 0%, #ed8936 100%); color: white;">
                    <h5 class="modal-title">
                        <i class="bi bi-grid-3x2-gap-fill me-2"></i>Tous les référents
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="allReferentsModalBody">
                    <!-- Contenu généré dynamiquement -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modale Tous les Membres -->
    <div class="modal fade" id="allMembresModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white;">
                    <h5 class="modal-title">
                        <i class="bi bi-grid-3x2-gap-fill me-2"></i>Tous les membres
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="allMembresModalBody">
                    <!-- Contenu généré dynamiquement -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Donnees PHP injectees dans le JS -->
    <script>
        const connectedUser = {
            id: <?= $currentUserId ?>,
            type: <?= $currentUserType ?>,
            name: '<?= addslashes($currentUserName) ?>',
            allowedDepts: <?= json_encode(array_map('intval', $referentAllowedDepts)) ?>
        };
    </script>
    <!-- Scripts externes -->
    <script src="ressources/js/gestionUtilisateurs.js?v=<?= time() ?>"></script>
    <script src="ressources/js/gestionUtilisateurs_part2.js?v=<?= time() ?>"></script>
    <script src="ressources/js/gestionUtilisateurs_modals.js?v=<?= time() ?>"></script>

    <!-- Initialisation des tabs Bootstrap -->
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Fonction pour activer un tab-pane
        function activateTab(tabButton, containerId) {
            const target = document.querySelector(tabButton.dataset.bsTarget);
            if (target) {
                // Masquer tous les tab-pane du container
                document.querySelectorAll(containerId + ' .tab-pane').forEach(function(pane) {
                    pane.classList.remove('show', 'active');
                });
                // Désactiver tous les boutons
                document.querySelectorAll(containerId.replace('.tab-content', '') + ' .nav-link').forEach(function(btn) {
                    btn.classList.remove('active');
                });
                // Activer le bouton cliqué
                tabButton.classList.add('active');
                // Afficher le tab-pane cible
                target.classList.add('show', 'active');
            }
        }

        // Initialiser les tabs de la page principale (.custom-tabs)
        const mainTabEls = document.querySelectorAll('#userTabs button[data-bs-toggle="tab"]');
        mainTabEls.forEach(function(tabEl) {
            tabEl.addEventListener('click', function(event) {
                event.preventDefault();
                activateTab(this, '.custom-tabs .tab-content');
            });
        });

        // Initialiser les tabs du modal utilisateur
        const modalTabEls = document.querySelectorAll('#userModalTabs button[data-bs-toggle="tab"]');
        modalTabEls.forEach(function(tabEl) {
            tabEl.addEventListener('click', function(event) {
                event.preventDefault();
                activateTab(this, '#userModalTabContent');
            });
        });

        // S'assurer que les premiers onglets sont actifs au démarrage
        const firstMainPane = document.querySelector('.custom-tabs .tab-content .tab-pane');
        if (firstMainPane) {
            firstMainPane.classList.add('show', 'active');
        }

        const firstModalPane = document.querySelector('#userModalTabContent .tab-pane');
        if (firstModalPane) {
            firstModalPane.classList.add('show', 'active');
        }
    });

    // =============================================
    // Gestion des cantons dans "Mes accès"
    // =============================================

    // Toggle département section (replier/déplier)
    function toggleDeptSection(headerEl) {
        const section = headerEl.closest('.dept-section');
        const cantons = section.querySelector('.dept-cantons');
        const chevron = section.querySelector('.dept-chevron');

        if (cantons.style.display === 'none') {
            cantons.style.display = 'block';
            chevron.classList.remove('bi-chevron-right');
            chevron.classList.add('bi-chevron-down');
        } else {
            cantons.style.display = 'none';
            chevron.classList.remove('bi-chevron-down');
            chevron.classList.add('bi-chevron-right');
        }
    }

    // Sélectionner tous les cantons d'un département
    function selectAllDept(deptNum) {
        const section = document.querySelector(`.dept-section[data-dept="${deptNum}"]`);
        if (section) {
            section.querySelectorAll('.canton-checkbox').forEach(cb => cb.checked = true);
            updateCantonCounts();
        }
    }

    // Désélectionner tous les cantons d'un département
    function deselectAllDept(deptNum) {
        const section = document.querySelector(`.dept-section[data-dept="${deptNum}"]`);
        if (section) {
            section.querySelectorAll('.canton-checkbox').forEach(cb => cb.checked = false);
            updateCantonCounts();
        }
    }

    // Mettre à jour les compteurs
    function updateCantonCounts() {
        let totalSelected = 0;

        // Compter par département
        document.querySelectorAll('.dept-section').forEach(section => {
            const deptNum = section.dataset.dept;
            const checkboxes = section.querySelectorAll('.canton-checkbox');
            const selectedCount = Array.from(checkboxes).filter(cb => cb.checked).length;

            // Mettre à jour le badge du département
            const badge = section.querySelector('.dept-selected-count');
            if (badge) badge.textContent = selectedCount;

            totalSelected += selectedCount;
        });

        // Mettre à jour le compteur total
        const totalBadge = document.getElementById('myAccessSelectedCount');
        if (totalBadge) totalBadge.textContent = totalSelected;
    }

    // Enregistrer les cantons sélectionnés
    function saveMyCantons() {
        const btn = document.getElementById('btnSaveMyCantons');
        const originalHtml = btn.innerHTML;
        btn.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Enregistrement...';
        btn.disabled = true;

        // Collecter les cantons sélectionnés
        const selectedCantons = [];
        document.querySelectorAll('.canton-checkbox:checked').forEach(cb => {
            selectedCantons.push({
                numero_departement: cb.dataset.dept,
                canton: cb.dataset.canton
            });
        });

        // Envoyer au serveur
        fetch('api.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                action: 'saveMyCantons',
                cantons: selectedCantons
            })
        })
        .then(response => response.json())
        .then(data => {
            btn.innerHTML = originalHtml;
            btn.disabled = false;

            if (data.success) {
                // Afficher une notification de succès
                showToast('Cantons enregistrés avec succès', 'success');
            } else {
                showToast(data.error || 'Erreur lors de l\'enregistrement', 'danger');
            }
        })
        .catch(error => {
            btn.innerHTML = originalHtml;
            btn.disabled = false;
            showToast('Erreur de connexion', 'danger');
        });
    }

    // Fonction pour afficher un toast de notification
    function showToast(message, type = 'info') {
        // Créer le conteneur si inexistant
        let container = document.getElementById('toastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toastContainer';
            container.className = 'toast-container position-fixed top-0 end-0 p-3';
            container.style.zIndex = '9999';
            document.body.appendChild(container);
        }

        const toastId = 'toast_' + Date.now();
        const bgClass = type === 'success' ? 'bg-success' : type === 'danger' ? 'bg-danger' : 'bg-info';
        const icon = type === 'success' ? 'check-circle' : type === 'danger' ? 'exclamation-triangle' : 'info-circle';

        const toastHtml = `
            <div id="${toastId}" class="toast align-items-center text-white ${bgClass} border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="bi bi-${icon} me-2"></i>${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', toastHtml);

        const toastEl = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastEl, { autohide: true, delay: 3000 });
        toast.show();

        toastEl.addEventListener('hidden.bs.toast', () => toastEl.remove());
    }

    // =============================================
    // Sauvegarde des paramètres (Admin Général)
    // =============================================
    function saveParameters() {
        const filtreHabitants = document.getElementById('filtreHabitants').value;
        const environnement = document.getElementById('environnement').value;

        fetch('api.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                action: 'saveParameters',
                filtreHabitants: parseInt(filtreHabitants) || 1000,
                environnement: environnement || 'dev'
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Paramètres enregistrés avec succès', 'success');
                // Mettre à jour l'affichage
                document.getElementById('currentFiltreHabitants').textContent = filtreHabitants;
                document.getElementById('currentEnvironnement').textContent = environnement.toUpperCase();
            } else {
                showToast(data.error || 'Erreur lors de l\'enregistrement', 'danger');
            }
        })
        .catch(error => {
            showToast('Erreur de connexion', 'danger');
        });
    }

    // =============================================
    // Autocomplétion Département
    // =============================================
    const allDepartements = <?= json_encode($allDepartements, JSON_UNESCAPED_UNICODE) ?>;

    const deptSearch = document.getElementById('deptSearch');
    const deptDropdown = document.getElementById('deptDropdown');
    const userDepartement = document.getElementById('userDepartement');

    function renderDeptDropdown(filter = '') {
        const search = filter.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        let html = '';

        const filtered = allDepartements.filter(d => {
            const num = d.numero_departement.toLowerCase();
            const nom = d.nom_departement.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            const displayFormat = (nom + ' (' + num + ')').toLowerCase();
            return num.includes(search) || nom.includes(search) || displayFormat.includes(search);
        });

        if (filtered.length === 0) {
            html = '<div class="dept-no-result">Aucun résultat</div>';
        } else {
            // Liste compacte sans regroupement par région
            filtered.forEach(d => {
                html += `<div class="dept-item" data-id="${d.id}" data-text="${d.nom_departement} (${d.numero_departement})"><span class="dept-num">${d.numero_departement}</span><span class="dept-name">${d.nom_departement}</span></div>`;
            });
        }

        deptDropdown.innerHTML = html;
        deptDropdown.style.display = 'block';

        // Event listeners pour les items
        deptDropdown.querySelectorAll('.dept-item').forEach(item => {
            item.addEventListener('click', () => {
                userDepartement.value = item.dataset.id;
                deptSearch.value = item.dataset.text;
                deptDropdown.style.display = 'none';
            });
        });
    }

    deptSearch.addEventListener('focus', () => renderDeptDropdown(deptSearch.value));
    deptSearch.addEventListener('input', () => renderDeptDropdown(deptSearch.value));

    document.addEventListener('click', (e) => {
        if (!e.target.closest('.dept-autocomplete')) {
            deptDropdown.style.display = 'none';
        }
    });

    // Fonction pour définir la valeur du département (utilisée lors de l'édition)
    function setDepartementValue(id) {
        userDepartement.value = id || '';
        if (id) {
            const dept = allDepartements.find(d => d.id == id);
            if (dept) {
                deptSearch.value = dept.nom_departement + ' (' + dept.numero_departement + ')';
            }
        } else {
            deptSearch.value = '';
        }
    }
    </script>
</body>
</html>
<?php /* FIN DU FICHIER - CODE JS EXTERNALISE */ ?>
