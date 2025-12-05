<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

// Récupérer les informations de l'utilisateur connecté
$currentUserType = $_SESSION['user_type'] ?? 0;
$currentUserId = $_SESSION['user_id'] ?? 0;
$currentUserPrenom = $_SESSION['user_prenom'] ?? '';
$currentUserNom = $_SESSION['user_nom'] ?? '';
$currentUserName = $currentUserPrenom . ' ' . $currentUserNom;
$currentUserInitials = strtoupper(substr($currentUserPrenom, 0, 1) . substr($currentUserNom, 0, 1));

// Seuls les admins et référents peuvent accéder
if ($currentUserType > 3) {
    header('Location: index.php');
    exit;
}

// Pour les référents, récupérer leurs départements autorisés
$userAllowedDeptNumbers = [];
if ($currentUserType == 3) {
    $stmtDepts = $pdo->prepare("
        SELECT DISTINCT d.numero_departement
        FROM gestionDroits gd
        JOIN departements d ON gd.departement_id = d.id
        WHERE gd.utilisateur_id = ?
    ");
    $stmtDepts->execute([$currentUserId]);
    $userAllowedDeptNumbers = $stmtDepts->fetchAll(PDO::FETCH_COLUMN);
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport Référents - Communes &lt; <?= $GLOBALS['filtreHabitants'] ?> hab.</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        body {
            background: #f3f4f6;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
        }

        .page-header {
            background: var(--bg-gradient);
            color: white;
            padding: 0.75rem 0;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .page-header h1 {
            font-weight: 700;
            margin-bottom: 0;
            font-size: 1.4rem;
        }

        .page-header .subtitle {
            opacity: 0.9;
            font-size: 0.85rem;
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.2s;
            font-size: 0.85rem;
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
            color: white;
        }

        .btn-close-page {
            position: fixed;
            top: 10px;
            right: 15px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.2s;
            z-index: 1000;
        }

        .btn-close-page:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: scale(1.1);
        }

        .btn-close-page i {
            font-size: 1rem;
        }

        .btn-icon-export {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-icon-export:hover {
            background: rgba(255,255,255,0.25);
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .btn-icon-export i {
            font-size: 1.2rem;
        }

        .header-user {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255,255,255,0.2);
            padding: 0.35rem 0.75rem 0.35rem 0.35rem;
            border-radius: 25px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.25);
        }

        .header-avatar {
            width: 32px;
            height: 32px;
            min-width: 32px;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.8rem;
            color: #1e293b;
            box-shadow: 0 2px 8px rgba(0,0,0,0.25);
            border: 2px solid rgba(255,255,255,0.5);
        }

        .header-user-info {
            display: flex;
            flex-direction: column;
        }

        .header-user-name {
            font-weight: 600;
            font-size: 0.8rem;
            line-height: 1.1;
            color: white;
        }

        .header-user-role {
            font-size: 0.65rem;
            opacity: 0.85;
            color: rgba(255,255,255,0.9);
        }

        @media (max-width: 576px) {
            .header-user-info {
                display: none;
            }
            .header-user {
                padding: 0.2rem;
                background: transparent;
                border: none;
            }
            .header-avatar {
                width: 28px;
                height: 28px;
                min-width: 28px;
                font-size: 0.7rem;
            }
            .page-header h1 {
                font-size: 1.1rem;
            }
            .page-header .subtitle {
                font-size: 0.75rem;
            }
        }

        .dept-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .dept-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }

        .dept-header {
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
            color: white;
            padding: 1.25rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dept-header h3 {
            margin: 0;
            font-weight: 600;
            font-size: 1.25rem;
        }

        .dept-header .dept-number {
            background: rgba(255,255,255,0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        .dept-stats {
            display: flex;
            gap: 1.5rem;
            padding: 1rem 1.5rem;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .dept-stat {
            text-align: center;
        }

        .dept-stat .value {
            font-size: 1.5rem;
            font-weight: 700;
        }

        .dept-stat .label {
            font-size: 0.75rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .progress-bar-custom {
            height: 6px;
            background: #e2e8f0;
            border-radius: 3px;
            overflow: hidden;
            margin: 0.25rem 0;
        }

        .progress-bar-custom .fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        .progress-low { background: var(--danger-color); }
        .progress-medium { background: var(--warning-color); }
        .progress-high { background: var(--success-color); }

        .referent-list {
            padding: 0;
        }

        .referent-item {
            padding: 0.4rem 0.75rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }

        .referent-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.3rem;
        }

        .referent-header-left {
            display: flex;
            align-items: center;
            gap: 0.3rem;
            flex: 1;
        }

        .referent-header-right {
            display: flex;
            align-items: center;
            gap: 0.3rem;
            margin-left: auto;
        }

        .referent-header-left h4 {
            margin: 0;
            font-size: 0.65rem;
            font-weight: 600;
            color: #1e293b;
            display: inline;
        }

        .referent-item:last-child {
            border-bottom: none;
        }

        .referent-item.highlight {
            background: #fef3c7;
        }

        .referent-info .cantons {
            font-size: 0.65rem;
            color: #94a3b8;
        }

        .referent-info .cantons i {
            margin-right: 0.1rem;
        }

        .communes-list {
            font-size: 0.6rem;
            color: #78716c;
            line-height: 1.25;
            display: inline;
        }

        .communes-link {
            color: #0ea5e9;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            margin-left: 0.3rem;
            font-size: 0.55rem;
        }

        .communes-link:hover {
            text-decoration: underline;
            color: #0284c7;
        }

        /* Modal communes */
        .modal-communes .modal-content {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        .modal-communes .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 16px 16px 0 0;
            padding: 1rem 1.5rem;
        }

        .modal-communes .modal-header .btn-close {
            filter: brightness(0) invert(1);
            opacity: 0.8;
        }

        .modal-communes .modal-body {
            padding: 1rem;
            max-height: 60vh;
            overflow-y: auto;
        }

        .circo-group {
            margin-bottom: 0.75rem;
        }

        .circo-header {
            background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            color: #334155;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .circo-header i {
            color: #6366f1;
        }

        .circo-header .badge {
            background: #6366f1;
            color: white;
            font-size: 0.7rem;
            padding: 0.15rem 0.5rem;
            border-radius: 10px;
            margin-left: auto;
        }

        .communes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 0.35rem;
            padding-left: 0.5rem;
        }

        .commune-item {
            font-size: 0.75rem;
            color: #475569;
            padding: 0.25rem 0.5rem;
            background: #f8fafc;
            border-radius: 4px;
            border-left: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .commune-icon {
            font-size: 0.7rem;
        }

        .commune-item.statut-1 {
            border-left-color: #3b82f6;
            background: #eff6ff;
        }

        .commune-item.statut-2 {
            border-left-color: #10b981;
            background: #ecfdf5;
        }

        .commune-item.statut-3 {
            border-left-color: #ef4444;
            background: #fef2f2;
        }

        .commune-item.statut-4 {
            border-left-color: #f59e0b;
            background: #fffbeb;
        }

        .modal-communes .modal-footer {
            border-top: 1px solid #e2e8f0;
            padding: 0.75rem 1rem;
        }

        .modal-communes .total-info {
            font-size: 0.8rem;
            color: #64748b;
        }

        .referent-progress {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.65rem;
            margin: 0.25rem 0;
        }

        .referent-progress .progress-text {
            font-weight: 700;
            min-width: 35px;
        }

        .referent-progress .progress-bar-custom {
            flex: 1;
        }

        .referent-progress .detail {
            color: #64748b;
            font-size: 0.6rem;
        }

        .no-cantons {
            color: #9ca3af;
            font-style: italic;
        }

        .badge-role {
            display: inline-block;
            padding: 0.1rem 0.4rem;
            border-radius: 10px;
            font-size: 0.6rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.02em;
            margin-left: 0.4rem;
            vertical-align: middle;
        }

        .badge-referent {
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
            color: white;
        }

        .badge-membre {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
            color: white;
        }

        .membre-item {
            background: #f0fdfa;
            border-left: 2px solid #14b8a6;
        }

        .statuts-detail {
            display: inline-flex;
            flex-wrap: wrap;
            gap: 2px;
            margin-left: 0.5rem;
        }

        .statut-badge {
            display: inline-flex;
            align-items: center;
            gap: 1px;
            padding: 1px 4px;
            border-radius: 6px;
            font-size: 0.6rem;
            font-weight: 600;
        }

        .statut-encours {
            background: #dbeafe;
            color: #1e40af;
        }

        .statut-rdv {
            background: #d1fae5;
            color: #065f46;
        }

        .statut-sanssuite {
            background: #fee2e2;
            color: #991b1b;
        }

        .statut-promesse {
            background: #fef3c7;
            color: #92400e;
        }

        .statut-nontraite {
            background: #f1f5f9;
            color: #64748b;
        }

        .filter-section {
            background: white;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .loading {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }

        .loading i {
            font-size: 2rem;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #9ca3af;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .dept-stats {
                flex-wrap: wrap;
            }

            .referent-item {
                grid-template-columns: 1fr;
            }

            .referent-stats {
                text-align: left;
                margin-top: 0.5rem;
                padding-top: 0.5rem;
                border-top: 1px dashed #e2e8f0;
            }
        }
    </style>
</head>
<body>
    <!-- Bouton fermer fixe en haut à droite -->
    <a href="maires_responsive.php" class="btn-close-page" title="Fermer">
        <i class="bi bi-x-lg"></i>
    </a>

    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h1><i class="bi bi-graph-up-arrow me-2"></i>Rapport Équipes</h1>
                    <p class="subtitle mb-0">Progression des communes &lt; <?= $GLOBALS['filtreHabitants'] ?> hab. (Référents & Membres)</p>
                </div>
                <div class="d-flex gap-2 align-items-center">
                    <button type="button" class="btn-icon-export" id="btnExportCSV" title="Télécharger CSV">
                        <i class="bi bi-download"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <?php if ($currentUserType <= 2): ?>
        <!-- Filtre par département (admin uniquement) -->
        <div class="filter-section">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <label class="form-label mb-0"><i class="bi bi-funnel me-1"></i> Filtrer par département</label>
                </div>
                <div class="col-md-8">
                    <select class="form-select" id="filterDept">
                        <option value="">Tous les départements</option>
                    </select>
                </div>
            </div>
        </div>
        <?php endif; ?>

        <!-- Liste des départements -->
        <div id="deptList">
            <div class="loading">
                <i class="bi bi-arrow-repeat"></i>
                <p>Chargement des données...</p>
            </div>
        </div>
    </div>

    <!-- Modal Communes -->
    <div class="modal fade modal-communes" id="modalCommunes" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalCommunesTitle">
                        <i class="bi bi-geo-alt-fill me-2"></i>Communes
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
                </div>
                <div class="modal-body" id="modalCommunesBody">
                    <!-- Contenu généré dynamiquement -->
                </div>
                <div class="modal-footer">
                    <span class="total-info" id="modalCommunesTotal"></span>
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Configuration utilisateur
        const USER_CONFIG = {
            userId: <?= json_encode($currentUserId) ?>,
            userType: <?= json_encode($currentUserType) ?>,
            allowedDepts: <?= json_encode($userAllowedDeptNumbers) ?>
        };

        // Configuration globale depuis menus.json
        const filtreHabitants = <?= $GLOBALS['filtreHabitants'] ?>;

        let allData = null;

        // Charger les données
        async function loadData() {
            try {
                const response = await fetch('api.php?action=getStatsReferents');
                const data = await response.json();

                if (!data.success) {
                    throw new Error(data.error || 'Erreur lors du chargement');
                }

                allData = data;

                // Pour les référents, filtrer uniquement leurs départements
                if (USER_CONFIG.userType === 3 && USER_CONFIG.allowedDepts.length > 0) {
                    allData.departements = allData.departements.filter(dept =>
                        USER_CONFIG.allowedDepts.includes(dept.numero_departement)
                    );
                }

                populateFilter();
                renderDepartements();

            } catch (error) {
                console.error('Erreur:', error);
                document.getElementById('deptList').innerHTML = `
                    <div class="empty-state">
                        <i class="bi bi-exclamation-triangle"></i>
                        <p>Erreur lors du chargement des données</p>
                        <small>${error.message}</small>
                    </div>
                `;
            }
        }

        // Remplir le filtre département
        function populateFilter() {
            const select = document.getElementById('filterDept');
            if (!select) return;

            allData.departements.forEach(dept => {
                const option = document.createElement('option');
                option.value = dept.numero_departement;
                option.textContent = `${dept.numero_departement} - ${dept.nom_departement}`;
                select.appendChild(option);
            });

            select.addEventListener('change', renderDepartements);
        }

        // Afficher les départements
        function renderDepartements() {
            const container = document.getElementById('deptList');
            const filterValue = document.getElementById('filterDept')?.value || '';

            let depts = allData.departements;
            if (filterValue) {
                depts = depts.filter(d => d.numero_departement === filterValue);
            }

            if (depts.length === 0) {
                container.innerHTML = `
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <p>Aucun département trouvé</p>
                    </div>
                `;
                return;
            }

            container.innerHTML = depts.map(dept => renderDeptCard(dept)).join('');
        }

        // Rendre une carte département
        function renderDeptCard(dept) {
            const progressClass = getProgressClass(dept.pourcentage);

            const referentsHtml = dept.referents.length > 0
                ? dept.referents.map(ref => renderReferent(ref)).join('')
                : '<div class="referent-item"><div class="no-cantons">Aucun référent assigné</div></div>';

            return `
                <div class="dept-card">
                    <div class="dept-header">
                        <h3>${dept.nom_departement}</h3>
                        <span class="dept-number">${dept.numero_departement}</span>
                    </div>
                    <div class="dept-stats">
                        <div class="dept-stat">
                            <div class="value">${dept.total_communes_1000}</div>
                            <div class="label">Communes &lt; ${filtreHabitants}</div>
                        </div>
                        <div class="dept-stat">
                            <div class="value" style="color: var(--success-color)">${dept.communes_traitees}</div>
                            <div class="label">Traitées</div>
                        </div>
                        <div class="dept-stat">
                            <div class="value">${dept.total_communes_1000 - dept.communes_traitees}</div>
                            <div class="label">Restantes</div>
                        </div>
                        <div class="dept-stat" style="flex-grow: 1">
                            <div class="progress-bar-custom">
                                <div class="fill ${progressClass}" style="width: ${dept.pourcentage}%"></div>
                            </div>
                            <div class="label">${dept.pourcentage}% complété</div>
                        </div>
                    </div>
                    <div class="referent-list">
                        ${referentsHtml}
                    </div>
                </div>
            `;
        }

        // Rendre un référent/membre
        function renderReferent(ref) {
            const isCurrentUser = ref.id == USER_CONFIG.userId;
            const isMembre = ref.type_utilisateur === 4;
            const roleBadge = isMembre
                ? '<span class="badge-role badge-membre">Membre</span>'
                : '<span class="badge-role badge-referent">Référent</span>';

            // Format: X canton(s) - Y communes
            const cantonsText = ref.cantons.length > 0
                ? `<i class="bi bi-geo"></i> ${ref.cantons.length} canton(s) - ${ref.total_communes_1000} communes`
                : '<span class="no-cantons">Aucun canton attribué</span>';

            // Liste des communes (5 premières + lien voir tout)
            const maxDisplay = 5;
            let communesListHtml = '';
            if (ref.communes && ref.communes.length > 0) {
                const displayedCommunes = ref.communes.slice(0, maxDisplay).join(', ');
                const hasMore = ref.communes.length > maxDisplay;
                // Stocker les données dans un attribut data pour éviter les problèmes d'échappement
                const refDataJson = JSON.stringify({
                    nom: `${ref.prenom} ${ref.nom}`,
                    communes_by_circo: ref.communes_by_circo,
                    total: ref.total_communes_1000
                });
                const refDataAttr = refDataJson.replace(/"/g, '&quot;');
                communesListHtml = `
                    <span class="communes-list">${displayedCommunes}${hasMore ? '...' : ''}</span>
                    <a class="communes-link" data-communes="${refDataAttr}" onclick="showCommunesModal(this)">[voir ${ref.total_communes_1000}]</a>
                `;
            }

            // Détail des statuts (inline avec le nom)
            const nonTraitees = ref.total_communes_1000 - ref.communes_traitees;
            const statutsHtml = ref.nb_cantons > 0 ? `
                <span class="statuts-detail">
                    ${nonTraitees > 0 ? `<span class="statut-badge statut-nontraite" title="Non traitées">⚪${nonTraitees}</span>` : ''}
                    ${ref.en_cours > 0 ? `<span class="statut-badge statut-encours" title="Démarchage en cours">📞${ref.en_cours}</span>` : ''}
                    ${ref.rdv_obtenu > 0 ? `<span class="statut-badge statut-rdv" title="RDV obtenu">📅${ref.rdv_obtenu}</span>` : ''}
                    ${ref.sans_suite > 0 ? `<span class="statut-badge statut-sanssuite" title="Sans suite">🚫${ref.sans_suite}</span>` : ''}
                    ${ref.promesse > 0 ? `<span class="statut-badge statut-promesse" title="Promesse">👍${ref.promesse}</span>` : ''}
                </span>
            ` : '';

            // Progression compacte avec barre
            const progressClass = getProgressClass(ref.pourcentage);
            const progressHtml = ref.nb_cantons > 0 ? `
                <span class="referent-progress">
                    <span class="progress-text" style="color: ${getProgressColor(ref.pourcentage)}">${ref.pourcentage}%</span>
                    <div class="progress-bar-custom">
                        <div class="fill ${progressClass}" style="width: ${ref.pourcentage}%"></div>
                    </div>
                    <span class="detail">(${ref.communes_traitees}/${ref.total_communes_1000})</span>
                </span>
            ` : '';

            return `
                <div class="referent-item ${isCurrentUser ? 'highlight' : ''} ${isMembre ? 'membre-item' : ''}">
                    <div class="referent-header">
                        <div class="referent-header-left">
                            <h4>
                                ${isCurrentUser ? '<i class="bi bi-person-fill"></i>' : ''}
                                ${ref.prenom} ${ref.nom}
                            </h4>
                            ${roleBadge}
                        </div>
                        <div class="referent-header-right">
                            ${statutsHtml}
                        </div>
                    </div>
                    <div class="referent-info">
                        <div class="cantons">${cantonsText}</div>
                        ${progressHtml}
                        ${communesListHtml}
                    </div>
                </div>
            `;
        }

        // Obtenir la classe de progression
        function getProgressClass(pct) {
            if (pct >= 70) return 'progress-high';
            if (pct >= 30) return 'progress-medium';
            return 'progress-low';
        }

        // Obtenir la couleur de progression
        function getProgressColor(pct) {
            if (pct >= 70) return 'var(--success-color)';
            if (pct >= 30) return 'var(--warning-color)';
            return 'var(--danger-color)';
        }

        // Export CSV
        function exportToCSV() {
            if (!allData || !allData.departements || allData.departements.length === 0) {
                alert('Aucune donnée à exporter');
                return;
            }

            // Filtrer selon le département sélectionné (si admin)
            const filterValue = document.getElementById('filterDept')?.value || '';
            let depts = allData.departements;
            if (filterValue) {
                depts = depts.filter(d => d.numero_departement === filterValue);
            }

            // Préparer les données CSV
            const rows = [];

            // En-tête
            rows.push([
                'Département',
                'Num. Dépt',
                `Total < ${filtreHabitants} hab`,
                'Traitées Dépt',
                'Progression Dépt %',
                'Utilisateur',
                'Rôle',
                'Nb Cantons',
                'Communes',
                'Traitées',
                'En cours',
                'RDV',
                'Sans suite',
                'Promesses',
                'Progression %'
            ]);

            // Données
            depts.forEach(dept => {
                if (dept.referents.length === 0) {
                    rows.push([
                        dept.nom_departement,
                        dept.numero_departement,
                        dept.total_communes_1000,
                        dept.communes_traitees,
                        dept.pourcentage,
                        'Aucun utilisateur',
                        '',
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0
                    ]);
                } else {
                    dept.referents.forEach(ref => {
                        rows.push([
                            dept.nom_departement,
                            dept.numero_departement,
                            dept.total_communes_1000,
                            dept.communes_traitees,
                            dept.pourcentage,
                            `${ref.prenom} ${ref.nom}`,
                            ref.role,
                            ref.nb_cantons,
                            ref.total_communes_1000,
                            ref.communes_traitees,
                            ref.en_cours || 0,
                            ref.rdv_obtenu || 0,
                            ref.sans_suite || 0,
                            ref.promesse || 0,
                            ref.pourcentage
                        ]);
                    });
                }
            });

            // Convertir en CSV
            const csvContent = rows.map(row =>
                row.map(cell => {
                    // Échapper les guillemets et entourer de guillemets si nécessaire
                    const cellStr = String(cell);
                    if (cellStr.includes(',') || cellStr.includes('"') || cellStr.includes('\n') || cellStr.includes('|')) {
                        return '"' + cellStr.replace(/"/g, '""') + '"';
                    }
                    return cellStr;
                }).join(';') // Utiliser ; pour Excel FR
            ).join('\n');

            // Ajouter le BOM UTF-8 pour Excel
            const BOM = '\uFEFF';
            const blob = new Blob([BOM + csvContent], { type: 'text/csv;charset=utf-8;' });

            // Créer le lien de téléchargement
            const link = document.createElement('a');
            const date = new Date().toISOString().slice(0, 10);
            const deptSuffix = filterValue ? `_${filterValue}` : '';
            link.href = URL.createObjectURL(blob);
            link.download = `rapport_referents${deptSuffix}_${date}.csv`;

            // Déclencher le téléchargement
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(link.href);
        }

        // Icônes de statut
        const STATUT_ICONS = {
            0: '', // Non traitée - pas d'icône
            1: '📞', // En cours
            2: '📅', // RDV obtenu
            3: '🚫', // Sans suite
            4: '👍'  // Promesse
        };

        // Labels de statut pour les tooltips
        const STATUT_LABELS = {
            0: 'Non traitée',
            1: 'Démarchage en cours',
            2: 'RDV obtenu',
            3: 'Sans suite',
            4: 'Promesse'
        };

        // Afficher la modale des communes
        function showCommunesModal(element) {
            const data = JSON.parse(element.getAttribute('data-communes'));
            const communesByCirco = data.communes_by_circo;

            // Titre
            document.getElementById('modalCommunesTitle').innerHTML = `
                <i class="bi bi-geo-alt-fill me-2"></i>${data.nom}
            `;

            // Contenu - Arborescence par circo
            let bodyHtml = '';
            const circos = Object.keys(communesByCirco).sort();

            circos.forEach(circo => {
                const communes = communesByCirco[circo];
                bodyHtml += `
                    <div class="circo-group">
                        <div class="circo-header">
                            <i class="bi bi-diagram-3"></i>
                            <span>${circo}</span>
                            <span class="badge">${communes.length}</span>
                        </div>
                        <div class="communes-grid">
                            ${communes.map(c => {
                                const icon = STATUT_ICONS[c.statut] || '';
                                const statut = c.statut || 0;
                                const label = STATUT_LABELS[statut] || 'Non traitée';
                                return `<div class="commune-item statut-${statut}" title="${label}">${icon ? `<span class="commune-icon" title="${label}">${icon}</span>` : ''}${c.nom}</div>`;
                            }).join('')}
                        </div>
                    </div>
                `;
            });

            document.getElementById('modalCommunesBody').innerHTML = bodyHtml;
            document.getElementById('modalCommunesTotal').textContent = `Total: ${data.total} communes dans ${circos.length} circonscription(s)`;

            // Ouvrir la modale
            const modal = new bootstrap.Modal(document.getElementById('modalCommunes'));
            modal.show();
        }

        // Charger au démarrage
        document.addEventListener('DOMContentLoaded', function() {
            loadData();

            // Attacher l'événement au bouton export
            document.getElementById('btnExportCSV').addEventListener('click', exportToCSV);
        });
    </script>
</body>
</html>
