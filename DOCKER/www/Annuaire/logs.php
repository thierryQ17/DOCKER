<?php
/**
 * Interface de consultation des logs d'activité
 * Accessible uniquement pour Admin Général (type 1)
 */

require_once __DIR__ . '/auth_middleware.php';

// Vérifier que l'utilisateur est Admin Général
$currentUserType = $_SESSION['user_type'] ?? 0;
$currentUserId = $_SESSION['user_id'] ?? 0;

if ($currentUserType != 1) {
    header('Location: index.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logs d'activité - Administration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #6366f1;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
        }

        body {
            background: #f1f5f9;
            min-height: 100vh;
        }

        .page-header {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 50%, #818cf8 100%);
            color: white;
            padding: 0.6rem 0;
            margin-bottom: 0.75rem;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.25);
        }

        .page-header h1 {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
        }

        .page-header .subtitle {
            opacity: 0.85;
            font-size: 0.75rem;
            margin: 0;
        }

        .btn-close-page {
            position: fixed;
            top: 0.5rem;
            right: 0.5rem;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            transition: all 0.2s ease;
            text-decoration: none;
            font-size: 0.8rem;
        }

        .btn-close-page:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: scale(1.1);
        }

        .filters-card {
            background: white;
            border-radius: 8px;
            padding: 0.5rem 0.75rem;
            margin-bottom: 0.5rem;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        }

        .filter-group {
            display: flex;
            flex-wrap: wrap;
            gap: 0.4rem;
            align-items: center;
        }

        .filter-item {
            flex: 1;
            min-width: 110px;
        }

        .filter-item label {
            display: none;
        }

        .filter-item select,
        .filter-item input {
            font-size: 0.75rem;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
            padding: 0.3rem 0.5rem;
            width: 100%;
            height: 30px;
        }

        .filter-item select:focus,
        .filter-item input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.1);
            outline: none;
        }

        .btn-filter {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.3rem 0.75rem;
            border-radius: 4px;
            font-weight: 500;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            transition: all 0.2s;
            height: 30px;
        }

        .btn-filter:hover {
            background: #4f46e5;
            color: white;
        }

        .btn-reset {
            background: #f1f5f9;
            color: #64748b;
            border: 1px solid #e2e8f0;
            padding: 0.3rem 0.5rem;
            border-radius: 4px;
            font-weight: 500;
            transition: all 0.2s;
            height: 30px;
            font-size: 0.75rem;
        }

        .btn-reset:hover {
            background: #e2e8f0;
            color: #475569;
        }

        .stats-row {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            flex-wrap: wrap;
        }

        .stat-card {
            background: white;
            border-radius: 6px;
            padding: 0.4rem 0.75rem;
            flex: 1;
            min-width: 80px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stat-card .value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
            line-height: 1;
        }

        .stat-card .label {
            font-size: 0.65rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            line-height: 1.1;
        }

        .stat-card.auth .value { color: var(--info-color); }
        .stat-card.demarchage .value { color: var(--success-color); }
        .stat-card.utilisateur .value { color: var(--primary-color); }
        .stat-card.failed .value { color: var(--danger-color); }

        .logs-table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table {
            margin: 0;
            font-size: 0.75rem;
        }

        .table thead th {
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            font-weight: 600;
            color: #475569;
            padding: 0.4rem 0.5rem;
            white-space: nowrap;
            font-size: 0.7rem;
        }

        .table tbody td {
            padding: 0.35rem 0.5rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .table tbody tr:hover {
            background: #f8fafc;
        }

        .badge-action {
            padding: 0.15rem 0.35rem;
            border-radius: 3px;
            font-size: 0.6rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .badge-LOGIN { background: #dbeafe; color: #1e40af; }
        .badge-LOGOUT { background: #e0e7ff; color: #3730a3; }
        .badge-LOGIN_FAILED { background: #fee2e2; color: #b91c1c; }
        .badge-LOGIN_INACTIVE { background: #fef3c7; color: #92400e; }
        .badge-SAVE_DEMARCHAGE,
        .badge-UPDATE_DEMARCHAGE { background: #d1fae5; color: #065f46; }
        .badge-CREATE_USER { background: #ccfbf1; color: #0f766e; }
        .badge-UPDATE_USER { background: #fef3c7; color: #92400e; }
        .badge-DELETE_USER { background: #fecaca; color: #991b1b; }
        .badge-ASSIGN_DEPT,
        .badge-ASSIGN_CANTON { background: #e9d5ff; color: #6b21a8; }
        .badge-PASSWORD_CHANGE { background: #fce7f3; color: #9d174d; }

        .badge-categorie {
            padding: 0.1rem 0.3rem;
            border-radius: 3px;
            font-size: 0.55rem;
            font-weight: 500;
        }

        .badge-AUTH { background: #dbeafe; color: #1e40af; }
        .badge-DEMARCHAGE { background: #d1fae5; color: #065f46; }
        .badge-UTILISATEUR { background: #fef3c7; color: #92400e; }
        .badge-DROITS { background: #e9d5ff; color: #6b21a8; }
        .badge-EXPORT { background: #fce7f3; color: #9d174d; }

        .badge-statut {
            padding: 0.1rem 0.3rem;
            border-radius: 3px;
            font-size: 0.55rem;
            font-weight: 600;
        }

        .badge-SUCCESS { background: #d1fae5; color: #065f46; }
        .badge-FAILED { background: #fee2e2; color: #b91c1c; }
        .badge-WARNING { background: #fef3c7; color: #92400e; }

        .user-info {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
        }

        .user-info .name {
            font-weight: 500;
            color: #1e293b;
            font-size: 0.72rem;
        }

        .user-info .role {
            font-size: 0.6rem;
            color: #94a3b8;
        }

        .entity-info {
            max-width: 150px;
        }

        .entity-info .type {
            font-size: 0.55rem;
            color: #94a3b8;
            text-transform: uppercase;
        }

        .entity-info .name {
            font-size: 0.7rem;
            color: #475569;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .ip-info {
            font-family: monospace;
            font-size: 0.65rem;
            color: #64748b;
        }

        .date-info {
            white-space: nowrap;
            line-height: 1.2;
        }

        .date-info .date {
            font-weight: 500;
            color: #1e293b;
            font-size: 0.72rem;
        }

        .date-info .time {
            font-size: 0.6rem;
            color: #94a3b8;
        }

        .pagination-container {
            padding: 0.4rem 0.75rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #e2e8f0;
        }

        .pagination-info {
            font-size: 0.7rem;
            color: #64748b;
        }

        .pagination .page-link {
            border-radius: 4px;
            margin: 0 1px;
            border: none;
            color: #475569;
            padding: 0.2rem 0.5rem;
            font-size: 0.7rem;
        }

        .pagination .page-link:hover {
            background: #e2e8f0;
        }

        .pagination .page-item.active .page-link {
            background: var(--primary-color);
            color: white;
        }

        .btn-details {
            padding: 0.1rem 0.3rem;
            font-size: 0.6rem;
            border-radius: 3px;
        }

        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
        }

        .empty-state {
            text-align: center;
            padding: 1.5rem;
            color: #94a3b8;
        }

        .empty-state i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        /* Modal détails */
        .modal-details .modal-header {
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: white;
        }

        .detail-row {
            display: flex;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            width: 140px;
            font-weight: 600;
            color: #64748b;
            font-size: 0.85rem;
        }

        .detail-value {
            flex: 1;
            color: #1e293b;
            font-size: 0.85rem;
        }

        .json-viewer {
            background: #1e293b;
            color: #a5f3fc;
            padding: 1rem;
            border-radius: 8px;
            font-family: monospace;
            font-size: 0.8rem;
            max-height: 200px;
            overflow: auto;
            white-space: pre-wrap;
        }

        @media (max-width: 992px) {
            .page-header .stats-row {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .filter-item {
                min-width: 48% !important;
            }

            .table-responsive {
                font-size: 0.7rem;
            }

            .page-header h1 {
                font-size: 0.95rem;
            }
        }
    </style>
</head>
<body>
    <a href="gestionUtilisateurs.php" class="btn-close-page" title="Fermer">
        <i class="bi bi-x-lg"></i>
    </a>

    <div class="page-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1><i class="bi bi-journal-text me-2"></i>Logs d'activité</h1>
                <p class="subtitle">Historique des actions utilisateurs</p>
            </div>
            <div class="stats-row mb-0" style="gap: 0.5rem;">
                <div class="stat-card auth" style="padding: 0.4rem 1rem;">
                    <div class="value" id="statAuth" style="font-size: 1.3rem;">-</div>
                    <div class="label" style="font-size: 0.7rem;">Connexions</div>
                </div>
                <div class="stat-card demarchage" style="padding: 0.4rem 1rem;">
                    <div class="value" id="statDemarchage" style="font-size: 1.3rem;">-</div>
                    <div class="label" style="font-size: 0.7rem;">Démarchages</div>
                </div>
                <div class="stat-card utilisateur" style="padding: 0.4rem 1rem;">
                    <div class="value" id="statUtilisateur" style="font-size: 1.3rem;">-</div>
                    <div class="label" style="font-size: 0.7rem;">Actions</div>
                </div>
                <div class="stat-card failed" style="padding: 0.4rem 1rem;">
                    <div class="value" id="statFailed" style="font-size: 1.3rem;">-</div>
                    <div class="label" style="font-size: 0.7rem;">Échecs</div>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-3">
        <!-- Filtres -->
        <div class="filters-card">
            <div class="filter-group">
                <div class="filter-item" style="min-width: 100px;">
                    <select id="filterCategorie" class="form-select">
                        <option value="">Catégorie</option>
                        <option value="AUTH">Auth</option>
                        <option value="DEMARCHAGE">Démarchage</option>
                        <option value="UTILISATEUR">Utilisateurs</option>
                        <option value="DROITS">Droits</option>
                        <option value="EXPORT">Export</option>
                    </select>
                </div>
                <div class="filter-item" style="min-width: 120px;">
                    <select id="filterAction" class="form-select">
                        <option value="">Action</option>
                        <option value="LOGIN">Connexion</option>
                        <option value="LOGOUT">Déconnexion</option>
                        <option value="LOGIN_FAILED">Échec connexion</option>
                        <option value="LOGIN_INACTIVE">Compte inactif</option>
                        <option value="SAVE_DEMARCHAGE">Sauv. démarchage</option>
                        <option value="UPDATE_DEMARCHAGE">MAJ démarchage</option>
                        <option value="CREATE_USER">Création user</option>
                        <option value="UPDATE_USER">Modif user</option>
                        <option value="DELETE_USER">Suppr user</option>
                        <option value="PASSWORD_CHANGE">Chg. mdp</option>
                        <option value="ASSIGN_DEPT">Attrib. dépt</option>
                        <option value="ASSIGN_CANTON">Attrib. canton</option>
                    </select>
                </div>
                <div class="filter-item" style="min-width: 80px;">
                    <select id="filterStatut" class="form-select">
                        <option value="">Statut</option>
                        <option value="SUCCESS">Succès</option>
                        <option value="FAILED">Échec</option>
                        <option value="WARNING">Warning</option>
                    </select>
                </div>
                <div class="filter-item" style="min-width: 100px;">
                    <input type="text" id="filterUtilisateur" class="form-control" placeholder="Utilisateur...">
                </div>
                <div class="filter-item" style="min-width: 110px;">
                    <input type="date" id="filterDateDebut" class="form-control" title="Date début">
                </div>
                <div class="filter-item" style="min-width: 110px;">
                    <input type="date" id="filterDateFin" class="form-control" title="Date fin">
                </div>
                <div class="filter-item" style="flex: 0; min-width: auto;">
                    <div class="d-flex gap-1">
                        <button class="btn-filter" onclick="loadLogs()">
                            <i class="bi bi-search"></i>
                        </button>
                        <button class="btn-reset" onclick="resetFilters()">
                            <i class="bi bi-x-circle"></i>
                        </button>
                        <button class="btn-reset" onclick="showPurgeModal()" title="Purger les anciens logs" style="color: #dc3545;">
                            <i class="bi bi-trash3"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tableau des logs -->
        <div class="logs-table-container position-relative">
            <div class="loading-overlay" id="loadingOverlay" style="display: none;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Chargement...</span>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table" id="logsTable">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Utilisateur</th>
                            <th>Action</th>
                            <th>Catégorie</th>
                            <th>Entité</th>
                            <th>Statut</th>
                            <th>IP</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="logsTableBody">
                        <!-- Données chargées dynamiquement -->
                    </tbody>
                </table>
            </div>

            <div class="pagination-container">
                <div class="pagination-info" id="paginationInfo">
                    Affichage de 0 à 0 sur 0 entrées
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0" id="pagination">
                        <!-- Pagination générée dynamiquement -->
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <!-- Modal détails -->
    <div class="modal fade modal-details" id="modalDetails" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-info-circle me-2"></i>Détails du log</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="modalDetailsBody">
                    <!-- Contenu chargé dynamiquement -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal purge -->
    <div class="modal fade" id="modalPurge" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white py-2">
                    <h6 class="modal-title"><i class="bi bi-trash3 me-2"></i>Purger les logs</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small mb-2">Supprimer les logs antérieurs à :</p>
                    <select id="purgeDays" class="form-select form-select-sm mb-3">
                        <option value="0">Tout supprimer</option>
                        <option value="1">1 jour</option>
                        <option value="2">2 jours</option>
                        <option value="7">7 jours</option>
                        <option value="30" selected>30 jours</option>
                        <option value="60">60 jours</option>
                        <option value="90">90 jours</option>
                        <option value="180">6 mois</option>
                        <option value="365">1 an</option>
                    </select>
                    <div class="alert alert-warning py-2 small mb-0">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        Cette action est irréversible !
                    </div>
                </div>
                <div class="modal-footer py-2">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-sm btn-danger" onclick="confirmPurge()">
                        <i class="bi bi-trash3 me-1"></i>Purger
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal confirmation suppression -->
    <div class="modal fade" id="modalDeleteConfirm" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white py-2">
                    <h6 class="modal-title"><i class="bi bi-trash3 me-2"></i>Supprimer ce log ?</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small mb-0">Voulez-vous vraiment supprimer ce log ?</p>
                </div>
                <div class="modal-footer py-2">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-sm btn-danger" id="btnConfirmDelete">
                        <i class="bi bi-trash3 me-1"></i>Supprimer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentPage = 1;
        const perPage = 50;
        let totalLogs = 0;

        // Charger les logs au démarrage
        document.addEventListener('DOMContentLoaded', function() {
            // Définir la date de fin à aujourd'hui
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('filterDateFin').value = today;

            // Date début = il y a 7 jours
            const weekAgo = new Date();
            weekAgo.setDate(weekAgo.getDate() - 7);
            document.getElementById('filterDateDebut').value = weekAgo.toISOString().split('T')[0];

            loadLogs();
        });

        async function loadLogs() {
            const overlay = document.getElementById('loadingOverlay');
            overlay.style.display = 'flex';

            const params = new URLSearchParams({
                action: 'getLogs',
                page: currentPage,
                perPage: perPage,
                categorie: document.getElementById('filterCategorie').value,
                actionFilter: document.getElementById('filterAction').value,
                statut: document.getElementById('filterStatut').value,
                utilisateur: document.getElementById('filterUtilisateur').value,
                dateDebut: document.getElementById('filterDateDebut').value,
                dateFin: document.getElementById('filterDateFin').value
            });

            try {
                const response = await fetch('api.php?' + params.toString());
                const data = await response.json();

                if (data.success) {
                    renderLogs(data.logs);
                    totalLogs = data.total;
                    updatePagination(data.total, data.page, data.perPage);
                    updateStats(data.stats);
                } else {
                    showError(data.error || 'Erreur lors du chargement');
                }
            } catch (error) {
                showError('Erreur de connexion');
                console.error(error);
            } finally {
                overlay.style.display = 'none';
            }
        }

        function renderLogs(logs) {
            const tbody = document.getElementById('logsTableBody');

            if (!logs || logs.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                <p>Aucun log trouvé pour ces critères</p>
                            </div>
                        </td>
                    </tr>
                `;
                return;
            }

            tbody.innerHTML = logs.map(log => {
                const date = new Date(log.date_action);
                const dateStr = date.toLocaleDateString('fr-FR');
                const timeStr = date.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });

                return `
                    <tr>
                        <td>
                            <div class="date-info">
                                <div class="date">${dateStr}</div>
                                <div class="time">${timeStr}</div>
                            </div>
                        </td>
                        <td>
                            <div class="user-info">
                                <span class="name">${escapeHtml(log.utilisateur_nom || 'Système')}</span>
                                <span class="role">${getRoleName(log.utilisateur_type)}</span>
                            </div>
                        </td>
                        <td>
                            <span class="badge-action badge-${log.action}">${log.action}</span>
                        </td>
                        <td>
                            <span class="badge-categorie badge-${log.categorie}">${log.categorie}</span>
                        </td>
                        <td>
                            <div class="entity-info">
                                ${log.entite_type ? `<div class="type">${log.entite_type}</div>` : ''}
                                <div class="name" title="${escapeHtml(log.entite_nom || '')}">${escapeHtml(log.entite_nom || '-')}</div>
                            </div>
                        </td>
                        <td>
                            <span class="badge-statut badge-${log.statut}">${log.statut}</span>
                        </td>
                        <td>
                            <span class="ip-info">${log.ip_address || '-'}</span>
                        </td>
                        <td>
                            <div class="d-flex gap-1">
                                <button class="btn btn-sm btn-outline-secondary btn-details" onclick="showDetails(${log.id})" title="Détails">
                                    <i class="bi bi-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger btn-details" onclick="confirmDeleteLog(${log.id})" title="Supprimer">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
            }).join('');
        }

        function getRoleName(type) {
            const roles = {
                1: 'Admin Général',
                2: 'Admin',
                3: 'Référent',
                4: 'Membre'
            };
            return roles[type] || 'Inconnu';
        }

        function updateStats(stats) {
            document.getElementById('statAuth').textContent = stats?.auth || 0;
            document.getElementById('statDemarchage').textContent = stats?.demarchage || 0;
            document.getElementById('statUtilisateur').textContent = stats?.utilisateur || 0;
            document.getElementById('statFailed').textContent = stats?.failed || 0;
        }

        function updatePagination(total, page, perPage) {
            const start = (page - 1) * perPage + 1;
            const end = Math.min(page * perPage, total);

            document.getElementById('paginationInfo').textContent =
                `Affichage de ${total > 0 ? start : 0} à ${end} sur ${total} entrées`;

            const totalPages = Math.ceil(total / perPage);
            const pagination = document.getElementById('pagination');

            let html = '';

            // Bouton précédent
            html += `
                <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="goToPage(${page - 1}); return false;">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
            `;

            // Pages
            const maxVisible = 5;
            let startPage = Math.max(1, page - Math.floor(maxVisible / 2));
            let endPage = Math.min(totalPages, startPage + maxVisible - 1);

            if (endPage - startPage < maxVisible - 1) {
                startPage = Math.max(1, endPage - maxVisible + 1);
            }

            if (startPage > 1) {
                html += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(1); return false;">1</a></li>`;
                if (startPage > 2) {
                    html += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
                }
            }

            for (let i = startPage; i <= endPage; i++) {
                html += `
                    <li class="page-item ${i === page ? 'active' : ''}">
                        <a class="page-link" href="#" onclick="goToPage(${i}); return false;">${i}</a>
                    </li>
                `;
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    html += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
                }
                html += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(${totalPages}); return false;">${totalPages}</a></li>`;
            }

            // Bouton suivant
            html += `
                <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="goToPage(${page + 1}); return false;">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            `;

            pagination.innerHTML = html;
        }

        function goToPage(page) {
            if (page < 1) return;
            currentPage = page;
            loadLogs();
        }

        function resetFilters() {
            document.getElementById('filterCategorie').value = '';
            document.getElementById('filterAction').value = '';
            document.getElementById('filterStatut').value = '';
            document.getElementById('filterUtilisateur').value = '';

            const today = new Date().toISOString().split('T')[0];
            document.getElementById('filterDateFin').value = today;

            const weekAgo = new Date();
            weekAgo.setDate(weekAgo.getDate() - 7);
            document.getElementById('filterDateDebut').value = weekAgo.toISOString().split('T')[0];

            currentPage = 1;
            loadLogs();
        }

        async function showDetails(logId) {
            try {
                const response = await fetch(`api.php?action=getLogDetail&id=${logId}`);
                const data = await response.json();

                if (data.success) {
                    const log = data.log;
                    const date = new Date(log.date_action);

                    let html = `
                        <div class="detail-row">
                            <div class="detail-label">ID</div>
                            <div class="detail-value">#${log.id}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Date</div>
                            <div class="detail-value">${date.toLocaleString('fr-FR')}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Utilisateur</div>
                            <div class="detail-value">${escapeHtml(log.utilisateur_nom || 'Système')} (${getRoleName(log.utilisateur_type)})</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Action</div>
                            <div class="detail-value"><span class="badge-action badge-${log.action}">${log.action}</span></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Catégorie</div>
                            <div class="detail-value"><span class="badge-categorie badge-${log.categorie}">${log.categorie}</span></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Statut</div>
                            <div class="detail-value"><span class="badge-statut badge-${log.statut}">${log.statut}</span></div>
                        </div>
                    `;

                    if (log.description) {
                        html += `
                            <div class="detail-row">
                                <div class="detail-label">Description</div>
                                <div class="detail-value">${escapeHtml(log.description)}</div>
                            </div>
                        `;
                    }

                    if (log.entite_type) {
                        html += `
                            <div class="detail-row">
                                <div class="detail-label">Entité</div>
                                <div class="detail-value">
                                    <strong>${log.entite_type}</strong>: ${escapeHtml(log.entite_nom || '')}
                                    ${log.entite_id ? `(ID: ${log.entite_id})` : ''}
                                </div>
                            </div>
                        `;
                    }

                    html += `
                        <div class="detail-row">
                            <div class="detail-label">Adresse IP</div>
                            <div class="detail-value"><code>${log.ip_address || '-'}</code></div>
                        </div>
                    `;

                    if (log.user_agent) {
                        html += `
                            <div class="detail-row">
                                <div class="detail-label">User Agent</div>
                                <div class="detail-value" style="font-size: 0.75rem; word-break: break-all;">${escapeHtml(log.user_agent)}</div>
                            </div>
                        `;
                    }

                    if (log.donnees_json) {
                        let jsonData;
                        try {
                            jsonData = typeof log.donnees_json === 'string'
                                ? JSON.parse(log.donnees_json)
                                : log.donnees_json;
                        } catch (e) {
                            jsonData = log.donnees_json;
                        }
                        html += `
                            <div class="detail-row">
                                <div class="detail-label">Données JSON</div>
                                <div class="detail-value">
                                    <div class="json-viewer">${JSON.stringify(jsonData, null, 2)}</div>
                                </div>
                            </div>
                        `;
                    }

                    if (log.message_erreur) {
                        html += `
                            <div class="detail-row">
                                <div class="detail-label">Erreur</div>
                                <div class="detail-value text-danger">${escapeHtml(log.message_erreur)}</div>
                            </div>
                        `;
                    }

                    document.getElementById('modalDetailsBody').innerHTML = html;
                    new bootstrap.Modal(document.getElementById('modalDetails')).show();
                }
            } catch (error) {
                console.error('Erreur:', error);
            }
        }

        function showError(message) {
            const tbody = document.getElementById('logsTableBody');
            tbody.innerHTML = `
                <tr>
                    <td colspan="8">
                        <div class="empty-state text-danger">
                            <i class="bi bi-exclamation-triangle"></i>
                            <p>${escapeHtml(message)}</p>
                        </div>
                    </td>
                </tr>
            `;
        }

        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // ========== Gestion suppression ==========
        let logToDelete = null;

        function confirmDeleteLog(logId) {
            logToDelete = logId;
            new bootstrap.Modal(document.getElementById('modalDeleteConfirm')).show();
        }

        document.getElementById('btnConfirmDelete').addEventListener('click', async function() {
            if (!logToDelete) return;

            try {
                const response = await fetch('api.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ action: 'deleteLog', id: logToDelete })
                });
                const data = await response.json();

                bootstrap.Modal.getInstance(document.getElementById('modalDeleteConfirm')).hide();

                if (data.success) {
                    showToast('Log supprimé', 'success');
                    loadLogs();
                } else {
                    showToast(data.error || 'Erreur de suppression', 'danger');
                }
            } catch (error) {
                showToast('Erreur de connexion', 'danger');
            }
            logToDelete = null;
        });

        // ========== Gestion purge ==========
        function showPurgeModal() {
            new bootstrap.Modal(document.getElementById('modalPurge')).show();
        }

        async function confirmPurge() {
            const days = parseInt(document.getElementById('purgeDays').value);

            try {
                const response = await fetch('api.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ action: 'purgeLogs', days: days })
                });
                const data = await response.json();

                bootstrap.Modal.getInstance(document.getElementById('modalPurge')).hide();

                if (data.success) {
                    showToast(`${data.deleted} logs supprimés`, 'success');
                    loadLogs();
                } else {
                    showToast(data.error || 'Erreur de purge', 'danger');
                }
            } catch (error) {
                showToast('Erreur de connexion', 'danger');
            }
        }

        // ========== Toast notification ==========
        function showToast(message, type = 'info') {
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

            const toastHtml = `
                <div id="${toastId}" class="toast align-items-center text-white ${bgClass} border-0" role="alert">
                    <div class="d-flex">
                        <div class="toast-body">${escapeHtml(message)}</div>
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
    </script>
</body>
</html>
