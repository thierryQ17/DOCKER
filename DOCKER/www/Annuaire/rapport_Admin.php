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

// Seuls les admins peuvent accéder (types 1 et 2)
if ($currentUserType > 2) {
    header('Location: index.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport Admin - Vue Globale</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --bg-gradient: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
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

        .btn-icon-action {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            color: white;
            width: 36px;
            height: 36px;
            padding: 0;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            font-size: 1rem;
            cursor: pointer;
        }

        .btn-icon-action:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: scale(1.05);
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

        /* Tree structure */
        .tree-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .dept-node {
            border-bottom: 1px solid #e2e8f0;
        }

        .dept-node:last-child {
            border-bottom: none;
        }

        .dept-header {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            cursor: pointer;
            transition: background 0.2s;
            gap: 0.75rem;
        }

        .dept-header:hover {
            background: #f8fafc;
        }

        .dept-header.collapsed .chevron {
            transform: rotate(-90deg);
        }

        .chevron {
            font-size: 0.9rem;
            color: #64748b;
            transition: transform 0.2s;
            width: 20px;
            text-align: center;
        }

        .dept-number-badge {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            min-width: 35px;
            text-align: center;
        }

        .dept-name {
            font-weight: 600;
            color: #1e293b;
            flex: 1;
            font-size: 0.9rem;
        }

        .dept-progress-badge {
            background: #ecfdf5;
            color: #047857;
            padding: 0.15rem 0.4rem;
            border-radius: 8px;
            font-size: 0.65rem;
            font-weight: 600;
            min-width: 38px;
            text-align: center;
            border: 1px solid #a7f3d0;
        }

        .dept-progress-badge.progress-low {
            background: #fef2f2;
            color: #b91c1c;
            border-color: #fecaca;
        }

        .dept-progress-badge.progress-medium {
            background: #fffbeb;
            color: #b45309;
            border-color: #fde68a;
        }

        .dept-progress-badge.progress-high {
            background: #ecfdf5;
            color: #047857;
            border-color: #a7f3d0;
        }

        .dept-stats-inline {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.75rem;
            color: #64748b;
        }

        .dept-stats-inline .stat {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .dept-stats-inline .stat-value {
            font-weight: 700;
        }

        .dept-stats-inline .progress-inline {
            width: 80px;
            height: 6px;
            background: #e2e8f0;
            border-radius: 3px;
            overflow: hidden;
        }

        .dept-stats-inline .progress-inline .fill {
            height: 100%;
            border-radius: 3px;
        }

        .dept-stats-inline .progress-pct {
            font-weight: 700;
            min-width: 35px;
            text-align: right;
        }

        .dept-content {
            display: none;
            padding: 0 1rem 1rem 2.5rem;
        }

        .dept-node.open .dept-content {
            display: block;
        }

        .referent-list {
            background: #f8fafc;
            border-radius: 8px;
            padding: 0.5rem;
        }

        .referent-item {
            padding: 0.4rem 0.75rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
            background: white;
            border-radius: 6px;
            margin-bottom: 0.35rem;
        }

        .referent-item:last-child {
            margin-bottom: 0;
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

        /* Modal communes */
        .modal-communes .modal-content {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        .modal-communes .modal-header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
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

        .no-referents {
            padding: 0.75rem;
            color: #9ca3af;
            font-style: italic;
            font-size: 0.8rem;
            text-align: center;
        }

        .summary-bar {
            background: white;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .summary-stat {
            text-align: center;
        }

        .summary-stat .value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e293b;
        }

        .summary-stat .label {
            font-size: 0.75rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .summary-stat.success .value {
            color: var(--success-color);
        }

        .summary-stat.warning .value {
            color: var(--warning-color);
        }

        @media (max-width: 768px) {
            .dept-stats-inline {
                display: none;
            }

            .summary-bar {
                justify-content: center;
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
                    <h1><i class="bi bi-diagram-3 me-2"></i>Rapport Admin</h1>
                    <p class="subtitle mb-0">Vue globale par département - Communes &lt; <?= $GLOBALS['filtreHabitants'] ?> hab.</p>
                </div>
                <div class="d-flex gap-2 align-items-center" style="margin-right: 40px;">
                    <button type="button" class="btn-icon-action" id="btnToggleAll" title="Tout fermer/ouvrir">
                        <i class="bi bi-arrows-collapse"></i>
                    </button>
                    <button type="button" class="btn-icon-action" id="btnExportCSV" title="Télécharger CSV">
                        <i class="bi bi-download"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <!-- Résumé global -->
        <div class="summary-bar" id="summaryBar">
            <div class="summary-stat">
                <div class="value" id="totalDepts">-</div>
                <div class="label">Départements</div>
            </div>
            <div class="summary-stat">
                <div class="value" id="totalCommunes">-</div>
                <div class="label">Communes &lt; <?= $GLOBALS['filtreHabitants'] ?></div>
            </div>
            <div class="summary-stat success">
                <div class="value" id="totalTraitees">-</div>
                <div class="label">Traitées</div>
            </div>
            <div class="summary-stat warning">
                <div class="value" id="totalRestantes">-</div>
                <div class="label">Restantes</div>
            </div>
            <div class="summary-stat">
                <div class="value" id="totalReferents">-</div>
                <div class="label">Équipes</div>
            </div>
            <div class="summary-stat" style="flex-grow: 1; max-width: 200px;">
                <div class="progress-bar-custom" style="height: 10px;">
                    <div class="fill" id="globalProgress" style="width: 0%"></div>
                </div>
                <div class="label"><span id="globalPct">0</span>% Global</div>
            </div>
        </div>

        <!-- Arbre des départements -->
        <div class="tree-container" id="deptTree">
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
            userType: <?= json_encode($currentUserType) ?>
        };

        // Configuration globale depuis menus.json
        const filtreHabitants = <?= $GLOBALS['filtreHabitants'] ?>;

        let allData = null;
        let allExpanded = false;

        // Charger les données
        async function loadData() {
            try {
                const response = await fetch('api.php?action=getStatsReferents');
                const data = await response.json();

                if (!data.success) {
                    throw new Error(data.error || 'Erreur lors du chargement');
                }

                allData = data;
                updateSummary();
                renderTree();

            } catch (error) {
                document.getElementById('deptTree').innerHTML = `
                    <div class="empty-state">
                        <i class="bi bi-exclamation-triangle"></i>
                        <p>Erreur lors du chargement des données</p>
                        <small>${error.message}</small>
                    </div>
                `;
            }
        }

        // Mettre à jour le résumé global
        function updateSummary() {
            const depts = allData.departements;
            const totalDepts = depts.length;
            const totalCommunes = depts.reduce((sum, d) => sum + d.total_communes_1000, 0);
            const totalTraitees = depts.reduce((sum, d) => sum + d.communes_traitees, 0);
            const totalReferents = depts.reduce((sum, d) => sum + d.referents.length, 0);
            const globalPct = totalCommunes > 0 ? Math.round((totalTraitees / totalCommunes) * 100) : 0;

            document.getElementById('totalDepts').textContent = totalDepts;
            document.getElementById('totalCommunes').textContent = totalCommunes;
            document.getElementById('totalTraitees').textContent = totalTraitees;
            document.getElementById('totalRestantes').textContent = totalCommunes - totalTraitees;
            document.getElementById('totalReferents').textContent = totalReferents;
            document.getElementById('globalPct').textContent = globalPct;

            const progressEl = document.getElementById('globalProgress');
            progressEl.style.width = `${globalPct}%`;
            progressEl.className = `fill ${getProgressClass(globalPct)}`;
        }

        // Afficher l'arbre
        function renderTree() {
            const container = document.getElementById('deptTree');
            const depts = allData.departements;

            if (depts.length === 0) {
                container.innerHTML = `
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <p>Aucun département trouvé</p>
                    </div>
                `;
                return;
            }

            container.innerHTML = depts.map((dept, index) => renderDeptNode(dept, index === 0)).join('');

            // Attacher les événements
            document.querySelectorAll('.dept-header').forEach(header => {
                header.addEventListener('click', function() {
                    const node = this.closest('.dept-node');
                    node.classList.toggle('open');
                    this.classList.toggle('collapsed');
                    updateToggleButton();
                });
            });
        }

        // Rendre un noeud département
        function renderDeptNode(dept, isFirstOpen) {
            const progressClass = getProgressClass(dept.pourcentage);

            const referentsHtml = dept.referents.length > 0
                ? dept.referents.map(ref => renderReferent(ref)).join('')
                : '<div class="no-referents">Aucun référent ou membre assigné</div>';

            return `
                <div class="dept-node ${isFirstOpen ? 'open' : ''}">
                    <div class="dept-header ${isFirstOpen ? '' : 'collapsed'}">
                        <i class="bi bi-chevron-down chevron"></i>
                        <span class="dept-number-badge">${dept.numero_departement}</span>
                        <span class="dept-name">${dept.nom_departement}</span>
                        <span class="dept-progress-badge ${progressClass}">${dept.pourcentage}%</span>
                        <div class="dept-stats-inline">
                            <span class="stat">
                                <i class="bi bi-houses"></i>
                                <span class="stat-value">${dept.total_communes_1000}</span>
                            </span>
                            <span class="stat" style="color: var(--success-color)">
                                <i class="bi bi-check-circle"></i>
                                <span class="stat-value">${dept.communes_traitees}</span>
                            </span>
                            <span class="stat">
                                <i class="bi bi-people"></i>
                                <span class="stat-value">${dept.referents.length}</span>
                            </span>
                            <div class="progress-inline">
                                <div class="fill ${progressClass}" style="width: ${dept.pourcentage}%"></div>
                            </div>
                            <span class="progress-pct" style="color: ${getProgressColor(dept.pourcentage)}">${dept.pourcentage}%</span>
                        </div>
                    </div>
                    <div class="dept-content">
                        <div class="referent-list">
                            ${referentsHtml}
                        </div>
                    </div>
                </div>
            `;
        }

        // Rendre un référent/membre
        function renderReferent(ref) {
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

            // Détail des statuts
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
                <div class="referent-item ${isMembre ? 'membre-item' : ''}">
                    <div class="referent-header">
                        <div class="referent-header-left">
                            <h4>${ref.prenom} ${ref.nom}</h4>
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

        // Toggle all departments
        function toggleAllDepts() {
            const nodes = document.querySelectorAll('.dept-node');
            const headers = document.querySelectorAll('.dept-header');

            allExpanded = !allExpanded;

            nodes.forEach(node => {
                if (allExpanded) {
                    node.classList.add('open');
                } else {
                    node.classList.remove('open');
                }
            });

            headers.forEach(header => {
                if (allExpanded) {
                    header.classList.remove('collapsed');
                } else {
                    header.classList.add('collapsed');
                }
            });

            updateToggleButton();
        }

        // Update toggle button state
        function updateToggleButton() {
            const btn = document.getElementById('btnToggleAll');
            const openNodes = document.querySelectorAll('.dept-node.open').length;
            const totalNodes = document.querySelectorAll('.dept-node').length;

            allExpanded = openNodes === totalNodes;

            btn.innerHTML = allExpanded
                ? '<i class="bi bi-arrows-collapse"></i>'
                : '<i class="bi bi-arrows-expand"></i>';

            btn.title = allExpanded ? 'Tout fermer' : 'Tout ouvrir';
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

            const depts = allData.departements;
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
                        0, 0, 0, 0, 0, 0, 0, 0
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
                    const cellStr = String(cell);
                    if (cellStr.includes(',') || cellStr.includes('"') || cellStr.includes('\n') || cellStr.includes('|')) {
                        return '"' + cellStr.replace(/"/g, '""') + '"';
                    }
                    return cellStr;
                }).join(';')
            ).join('\n');

            // Ajouter le BOM UTF-8 pour Excel
            const BOM = '\uFEFF';
            const blob = new Blob([BOM + csvContent], { type: 'text/csv;charset=utf-8;' });

            // Créer le lien de téléchargement
            const link = document.createElement('a');
            const date = new Date().toISOString().slice(0, 10);
            link.href = URL.createObjectURL(blob);
            link.download = `rapport_admin_global_${date}.csv`;

            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(link.href);
        }

        // Icônes de statut
        const STATUT_ICONS = {
            0: '',
            1: '📞',
            2: '📅',
            3: '🚫',
            4: '👍'
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

            document.getElementById('modalCommunesTitle').innerHTML = `
                <i class="bi bi-geo-alt-fill me-2"></i>${data.nom}
            `;

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

            const modal = new bootstrap.Modal(document.getElementById('modalCommunes'));
            modal.show();
        }

        // Charger au démarrage
        document.addEventListener('DOMContentLoaded', function() {
            loadData();
            document.getElementById('btnExportCSV').addEventListener('click', exportToCSV);
            document.getElementById('btnToggleAll').addEventListener('click', toggleAllDepts);
        });
    </script>
</body>
</html>
