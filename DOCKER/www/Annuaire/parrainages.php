<?php
/**
 * Page de recherche des parrainages 2017-2022
 * Accessible à tous les utilisateurs
 */

// Connexion à la base de données
$host = 'mysql_db';
$dbname = 'annuairesMairesDeFrance';
$username = 'root';
$password = 'root';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Récupérer la liste des candidats pour le filtre
$candidatsStmt = $pdo->query("SELECT DISTINCT candidat_parraine FROM t_parrainages ORDER BY candidat_parraine");
$candidats = $candidatsStmt->fetchAll(PDO::FETCH_COLUMN);

// Récupérer la liste des départements
$departementsStmt = $pdo->query("SELECT DISTINCT departement FROM t_parrainages WHERE departement != '' ORDER BY departement");
$departements = $departementsStmt->fetchAll(PDO::FETCH_COLUMN);

// Candidats par défaut
$candidatsDefaut = ['ASSELINEAU François', 'ARTHAUD Nathalie', 'DUPONT-AIGNAN Nicolas'];
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche Parrainages 2017-2022</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        /* Header sticky */
        .sticky-header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: #f0f2f5;
            padding: 10px 15px;
        }

        /* Header compact */
        .page-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border-radius: 8px;
            padding: 8px 15px;
            color: white;
            box-shadow: 0 2px 8px rgba(23, 162, 184, 0.3);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 15px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .page-header h1 i { font-size: 18px; }

        /* Search card collapsible */
        .search-card {
            background: white;
            border-radius: 12px;
            margin-top: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .search-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 15px;
            background: #f8f9fa;
            cursor: pointer;
            border-bottom: 1px solid #e9ecef;
        }

        .search-header:hover {
            background: #e9ecef;
        }

        .search-header h2 {
            margin: 0;
            font-size: 14px;
            font-weight: 600;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-header h2 i { color: #17a2b8; }

        .search-header .toggle-icon {
            transition: transform 0.3s ease;
        }

        .search-header.collapsed .toggle-icon {
            transform: rotate(-90deg);
        }

        .search-body {
            padding: 10px 15px;
            display: block;
        }

        .search-body.collapsed {
            display: none;
        }

        .filter-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .filter-group label {
            font-size: 10px;
            font-weight: 600;
            color: #6c757d;
            text-transform: uppercase;
            white-space: nowrap;
            margin: 0;
        }

        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #dee2e6;
            padding: 4px 8px;
            font-size: 12px;
            height: 30px;
        }

        .filter-group .form-control,
        .filter-group .form-select {
            min-width: 100px;
        }

        .btn-search {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border: none;
            border-radius: 6px;
            padding: 5px 12px;
            font-weight: 600;
            font-size: 11px;
            color: white;
            height: 30px;
        }

        .btn-reset {
            background: #e9ecef;
            border: none;
            border-radius: 6px;
            padding: 5px 10px;
            font-weight: 600;
            font-size: 11px;
            color: #495057;
            height: 30px;
        }

        /* Results container */
        .results-container {
            padding: 8px 10px;
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .results-header h3 {
            margin: 0;
            font-size: 12px;
            font-weight: 600;
            color: #495057;
        }

        .results-count {
            background: #17a2b8;
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: 600;
        }

        /* Tree view */
        .tree-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.08);
            max-height: calc(100vh - 200px);
            overflow-y: auto;
        }

        .tree-node {
            border-bottom: 1px solid #f0f0f0;
        }

        .tree-node:last-child {
            border-bottom: none;
        }

        .tree-header {
            display: flex;
            align-items: center;
            padding: 6px 10px;
            cursor: pointer;
            transition: background 0.2s;
            gap: 6px;
        }

        .tree-header:hover {
            background: #f8f9fa;
        }

        .tree-toggle {
            width: 16px;
            height: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #17a2b8;
            transition: transform 0.2s;
            font-size: 12px;
        }

        .tree-toggle.collapsed {
            transform: rotate(-90deg);
        }

        .tree-icon {
            width: 20px;
            height: 20px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
        }

        .tree-icon.candidat { background: #e8def8; color: #6f42c1; }
        .tree-icon.annee { background: #d1e7dd; color: #198754; }
        .tree-icon.dept { background: #cfe2ff; color: #0d6efd; }
        .tree-icon.circo { background: #fff3cd; color: #fd7e14; }

        .tree-label {
            flex: 1;
            font-weight: 500;
            font-size: 12px;
            color: #2d3748;
        }

        .tree-count {
            background: #e9ecef;
            color: #495057;
            padding: 1px 6px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: 600;
        }

        .tree-children {
            display: none;
            padding-left: 15px;
            background: #fafbfc;
        }

        .tree-children.expanded {
            display: block;
        }

        /* Container pour les 2 blocs années côte à côte */
        .years-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            padding: 5px;
        }

        .year-block {
            background: white;
            border-radius: 6px;
            border: 1px solid #dee2e6;
            overflow: hidden;
        }

        .year-block-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 5px 10px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            font-weight: 600;
            font-size: 12px;
        }

        .year-block-header .year-count {
            background: rgba(255,255,255,0.25);
            padding: 2px 6px;
            border-radius: 8px;
            font-size: 10px;
        }

        .year-block-filter {
            padding: 4px 6px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            position: relative;
        }

        .year-block-filter input {
            width: 100%;
            padding: 4px 8px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            font-size: 11px;
            background: white;
        }

        .year-block-filter input:focus {
            outline: none;
            border-color: #17a2b8;
            box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.2);
        }

        .autocomplete-list {
            position: absolute;
            top: 100%;
            left: 10px;
            right: 10px;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 1000;
            max-height: 180px;
            overflow-y: auto;
            display: none;
        }

        .autocomplete-list.show {
            display: block;
        }

        .autocomplete-item {
            padding: 4px 8px;
            cursor: pointer;
            font-size: 11px;
            border-bottom: 1px solid #f0f0f0;
        }

        .autocomplete-item:last-child {
            border-bottom: none;
        }

        .autocomplete-item:hover,
        .autocomplete-item.active {
            background: #17a2b8;
            color: white;
        }

        .autocomplete-item-all {
            color: #17a2b8;
            font-weight: 600;
        }

        .autocomplete-item-all:hover {
            background: #17a2b8;
            color: white;
        }

        .year-block-content {
            max-height: 400px;
            overflow-y: auto;
            padding: 3px;
        }

        /* Leaf items (parrains) - liste directe */
        .parrain-list {
            padding: 0;
        }

        .parrain-item {
            display: grid;
            grid-template-columns: 70px 110px 1fr;
            align-items: center;
            padding: 2px 6px;
            background: white;
            border-radius: 2px;
            margin-bottom: 1px;
            font-size: 11px;
            border: 1px solid #e9ecef;
            gap: 6px;
        }

        .parrain-item:hover {
            background: #f8f9fa;
            border-color: #dee2e6;
        }

        .parrain-dept {
            color: #0d6efd;
            font-weight: 500;
            font-size: 10px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .parrain-commune {
            color: #fd7e14;
            font-size: 10px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .parrain-nom {
            font-weight: 500;
            color: #2d3748;
            font-size: 11px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .parrain-nom .civilite {
            font-weight: 400;
            color: #6c757d;
        }

        .parrain-mandat {
            color: #6c757d;
            font-size: 13px;
        }

        /* Header de liste */
        .parrain-list-header {
            display: grid;
            grid-template-columns: 70px 110px 1fr;
            align-items: center;
            padding: 2px 6px;
            background: #e9ecef;
            border-radius: 2px;
            margin-bottom: 1px;
            font-size: 9px;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            gap: 6px;
        }

        /* Loading */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-overlay.show { display: flex; }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 20px 15px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 36px;
            opacity: 0.3;
            margin-bottom: 10px;
        }

        /* Select2 compact */
        .select2-container--bootstrap-5 .select2-selection {
            border: 1px solid #dee2e6;
            border-radius: 6px;
            min-height: 30px;
            padding: 0 4px;
        }

        .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__rendered {
            padding: 2px 4px;
        }

        .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice {
            background: #17a2b8;
            border: none;
            color: white;
            border-radius: 3px;
            padding: 1px 6px;
            font-size: 10px;
            margin: 2px;
        }

        .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice__remove {
            color: white;
            font-size: 12px;
            margin-right: 3px;
        }

        .select2-container--bootstrap-5 .select2-search--inline .select2-search__field {
            font-size: 11px;
            margin: 2px;
        }

        /* Responsive */
        @media (max-width: 991px) {
            .years-container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .sticky-header {
                padding: 8px 10px;
            }

            .page-header {
                padding: 10px 15px;
                flex-direction: column;
                align-items: flex-start;
            }

            .page-header h1 {
                font-size: 16px;
            }

            .page-header h1 i {
                font-size: 18px;
            }

            .filter-row {
                grid-template-columns: 1fr;
            }

            .search-body {
                padding: 10px;
            }

            .results-container {
                padding: 10px;
            }

            .tree-container {
                max-height: calc(100vh - 280px);
            }

            .tree-header {
                padding: 8px 10px;
            }

            .tree-children {
                padding-left: 10px;
            }

            .years-container {
                padding: 8px;
                gap: 10px;
            }

            .year-block-header {
                padding: 8px 12px;
                font-size: 14px;
                flex-wrap: wrap;
            }

            .year-block-content {
                max-height: 300px;
                padding: 5px;
            }

            /* Liste parrains responsive - garder 3 colonnes */
            .parrain-item {
                grid-template-columns: 50px 75px 1fr;
                gap: 3px;
                padding: 2px 4px;
                font-size: 9px;
            }

            .parrain-list-header {
                grid-template-columns: 50px 75px 1fr;
                gap: 3px;
                padding: 2px 4px;
                font-size: 7px;
            }

            .parrain-dept,
            .parrain-commune,
            .parrain-nom {
                font-size: 8px;
            }
        }

        @media (max-width: 576px) {
            .page-header h1 {
                font-size: 14px;
            }

            .search-header h2 {
                font-size: 13px;
            }

            .results-header h3 {
                font-size: 13px;
            }

            .results-count {
                font-size: 11px;
                padding: 3px 8px;
            }

            .tree-label {
                font-size: 13px;
            }

            .tree-count {
                font-size: 11px;
                padding: 2px 8px;
            }

            .btn-search, .btn-reset {
                width: 100%;
                margin-bottom: 5px;
            }

            .d-flex.gap-2 {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Loading overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Chargement...</span>
        </div>
    </div>

    <!-- Sticky Header -->
    <div class="sticky-header">
        <div class="page-header">
            <div class="header-left">
                <h1><i class="bi bi-search-heart"></i> Parrainages 2017-2022</h1>
            </div>
        </div>

        <!-- Search form collapsible -->
        <div class="search-card">
            <div class="search-header collapsed" id="searchHeader" onclick="toggleSearch()">
                <h2><i class="bi bi-funnel"></i> Filtres de recherche</h2>
                <i class="bi bi-chevron-down toggle-icon"></i>
            </div>
            <div class="search-body collapsed" id="searchBody">
                <form id="searchForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label>Candidat(s)</label>
                            <select class="form-select" id="filterCandidat" name="candidat[]" multiple>
                                <?php foreach ($candidats as $candidat): ?>
                                    <option value="<?= htmlspecialchars($candidat) ?>"
                                        <?= in_array($candidat, $candidatsDefaut) ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($candidat) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label>Année</label>
                            <select class="form-select" id="filterAnnee" name="annee">
                                <option value="">Toutes</option>
                                <option value="2022">2022</option>
                                <option value="2017">2017</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label>Département</label>
                            <select class="form-select" id="filterDepartement" name="departement">
                                <option value="">Tous</option>
                                <?php foreach ($departements as $dept): ?>
                                    <option value="<?= htmlspecialchars($dept) ?>"><?= htmlspecialchars($dept) ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                    <div class="filter-row">
                        <div class="filter-group">
                            <label>Nom</label>
                            <input type="text" class="form-control" id="filterNom" name="nom" placeholder="Rechercher...">
                        </div>
                        <div class="filter-group">
                            <label>Commune</label>
                            <input type="text" class="form-control" id="filterCommune" name="commune" placeholder="Rechercher...">
                        </div>
                        <div class="filter-group">
                            <label>Mandat</label>
                            <select class="form-select" id="filterMandat" name="mandat">
                                <option value="">Tous</option>
                                <option value="Maire">Maire</option>
                                <option value="Conseiller">Conseiller</option>
                                <option value="Député">Député</option>
                                <option value="Sénateur">Sénateur</option>
                            </select>
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-search">
                            <i class="bi bi-search"></i> Rechercher
                        </button>
                        <button type="button" class="btn btn-reset" id="btnReset">
                            <i class="bi bi-arrow-counterclockwise"></i> Reset
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Results -->
    <div class="results-container">
        <div class="results-header">
            <h3><i class="bi bi-diagram-3"></i> Résultats</h3>
            <span class="results-count" id="resultsCount">0 résultats</span>
        </div>
        <div class="tree-container" id="treeContainer">
            <div class="empty-state">
                <i class="bi bi-search"></i>
                <p>Lancez une recherche pour afficher les résultats</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        // Ordre personnalisé des candidats
        const candidatOrder = {
            'ASSELINEAU François': 1,
            'DUPONT-AIGNAN Nicolas': 2,
            'ARTHAUD Nathalie': 3
        };

        function toggleSearch() {
            const header = document.getElementById('searchHeader');
            const body = document.getElementById('searchBody');
            header.classList.toggle('collapsed');
            body.classList.toggle('collapsed');
        }

        function toggleNode(element) {
            const toggle = element.querySelector('.tree-toggle');
            const children = element.nextElementSibling;
            if (toggle) toggle.classList.toggle('collapsed');
            if (children && children.classList.contains('tree-children')) {
                children.classList.toggle('expanded');
            }
        }

        $(document).ready(function() {
            $('#filterCandidat').select2({
                theme: 'bootstrap-5',
                placeholder: 'Sélectionner...',
                allowClear: true,
                width: '100%'
            });

            // Charger immédiatement les 3 candidats par défaut (2017 + 2022)
            searchParrainages();
        });

        function formatNumber(num) {
            return new Intl.NumberFormat('fr-FR').format(num);
        }

        $('#searchForm').on('submit', function(e) {
            e.preventDefault();
            searchParrainages();
        });

        function searchParrainages() {
            const formData = {
                action: 'search',
                candidat: $('#filterCandidat').val(),
                annee: $('#filterAnnee').val(),
                departement: $('#filterDepartement').val(),
                nom: $('#filterNom').val(),
                commune: $('#filterCommune').val(),
                mandat: $('#filterMandat').val()
            };

            $('#loadingOverlay').addClass('show');

            $.ajax({
                url: 'api_parrainages.php',
                data: formData,
                success: displayTreeResults,
                complete: function() {
                    $('#loadingOverlay').removeClass('show');
                }
            });
        }

        function displayTreeResults(data) {
            const container = $('#treeContainer');
            const count = data.length;

            $('#resultsCount').text(formatNumber(count) + ' résultat' + (count > 1 ? 's' : ''));

            if (count === 0) {
                container.html('<div class="empty-state"><i class="bi bi-inbox"></i><p>Aucun résultat</p></div>');
                return;
            }

            // Organiser les données en arbre simplifié : Candidat > Année > Parrains
            const tree = {};

            data.forEach(row => {
                const candidat = row.candidat_parraine || 'Inconnu';
                const annee = row.annee || 'N/A';

                if (!tree[candidat]) tree[candidat] = {};
                if (!tree[candidat][annee]) tree[candidat][annee] = [];

                tree[candidat][annee].push(row);
            });

            // Trier les candidats selon l'ordre personnalisé
            const sortedCandidats = Object.keys(tree).sort((a, b) => {
                const orderA = candidatOrder[a] || 999;
                const orderB = candidatOrder[b] || 999;
                if (orderA !== orderB) return orderA - orderB;
                return a.localeCompare(b);
            });

            let html = '';

            sortedCandidats.forEach(candidat => {
                const annees = tree[candidat];
                // Compter le total des parrains pour ce candidat
                let candidatCount = 0;
                for (const a in annees) {
                    candidatCount += annees[a].length;
                }

                html += `
                    <div class="tree-node">
                        <div class="tree-header" onclick="toggleNode(this)">
                            <span class="tree-toggle collapsed"><i class="bi bi-chevron-down"></i></span>
                            <span class="tree-icon candidat"><i class="bi bi-person-fill"></i></span>
                            <span class="tree-label">${escapeHtml(candidat)}</span>
                            <span class="tree-count">${candidatCount}</span>
                        </div>
                        <div class="tree-children">
                            <div class="years-container">
                `;

                // Bloc 2022
                const parrains2022 = annees['2022'] || [];
                parrains2022.sort((a, b) => {
                    const deptCompare = (a.departement || '').localeCompare(b.departement || '');
                    if (deptCompare !== 0) return deptCompare;
                    const communeCompare = (a.commune || '').localeCompare(b.commune || '');
                    if (communeCompare !== 0) return communeCompare;
                    return (a.nom || '').localeCompare(b.nom || '');
                });

                // Extraire les départements uniques pour 2022
                const depts2022 = [...new Set(parrains2022.map(p => p.departement).filter(d => d))].sort();
                const blockId2022 = candidat.replace(/[^a-zA-Z0-9]/g, '_') + '_2022';
                const depts2022Json = JSON.stringify(depts2022).replace(/'/g, '&#39;');

                html += `
                    <div class="year-block">
                        <div class="year-block-header">
                            <span><i class="bi bi-calendar-event"></i> 2022</span>
                            <span class="year-count">${parrains2022.length} parrainages</span>
                        </div>
                        <div class="year-block-filter">
                            <input type="text"
                                   placeholder="Département..."
                                   data-block="${blockId2022}"
                                   data-depts='${depts2022Json}'
                                   onfocus="showAutocomplete(this)"
                                   oninput="filterAutocomplete(this)"
                                   onblur="setTimeout(() => hideAutocomplete(this), 200)">
                            <div class="autocomplete-list" id="autocomplete_${blockId2022}"></div>
                        </div>
                        <div class="year-block-content" id="${blockId2022}">
                            <div class="parrain-list">
                                <div class="parrain-list-header">
                                    <span>Département</span>
                                    <span>Commune</span>
                                    <span>Nom</span>
                                </div>
                `;

                parrains2022.forEach(p => {
                    const dept = p.departement || '';
                    const fullName = [p.civilite, p.prenom, p.nom].filter(Boolean).join(' ');
                    html += `
                        <div class="parrain-item" data-dept="${dept.replace(/"/g, '&quot;')}">
                            <span class="parrain-dept">${escapeHtml(dept)}</span>
                            <span class="parrain-commune" title="${escapeHtml(p.commune || '')}">${escapeHtml(p.commune || '')}</span>
                            <span class="parrain-nom">${escapeHtml(fullName)}</span>
                        </div>
                    `;
                });

                html += '</div></div></div>';

                // Bloc 2017
                const parrains2017 = annees['2017'] || [];
                parrains2017.sort((a, b) => {
                    const deptCompare = (a.departement || '').localeCompare(b.departement || '');
                    if (deptCompare !== 0) return deptCompare;
                    const communeCompare = (a.commune || '').localeCompare(b.commune || '');
                    if (communeCompare !== 0) return communeCompare;
                    return (a.nom || '').localeCompare(b.nom || '');
                });

                // Extraire les départements uniques pour 2017
                const depts2017 = [...new Set(parrains2017.map(p => p.departement).filter(d => d))].sort();
                const blockId2017 = candidat.replace(/[^a-zA-Z0-9]/g, '_') + '_2017';
                const depts2017Json = JSON.stringify(depts2017).replace(/'/g, '&#39;');

                html += `
                    <div class="year-block">
                        <div class="year-block-header">
                            <span><i class="bi bi-calendar-event"></i> 2017</span>
                            <span class="year-count">${parrains2017.length} parrainages</span>
                        </div>
                        <div class="year-block-filter">
                            <input type="text"
                                   placeholder="Département..."
                                   data-block="${blockId2017}"
                                   data-depts='${depts2017Json}'
                                   onfocus="showAutocomplete(this)"
                                   oninput="filterAutocomplete(this)"
                                   onblur="setTimeout(() => hideAutocomplete(this), 200)">
                            <div class="autocomplete-list" id="autocomplete_${blockId2017}"></div>
                        </div>
                        <div class="year-block-content" id="${blockId2017}">
                            <div class="parrain-list">
                                <div class="parrain-list-header">
                                    <span>Département</span>
                                    <span>Commune</span>
                                    <span>Nom</span>
                                </div>
                `;

                parrains2017.forEach(p => {
                    const dept = p.departement || '';
                    const fullName = [p.civilite, p.prenom, p.nom].filter(Boolean).join(' ');
                    html += `
                        <div class="parrain-item" data-dept="${dept.replace(/"/g, '&quot;')}">
                            <span class="parrain-dept">${escapeHtml(dept)}</span>
                            <span class="parrain-commune" title="${escapeHtml(p.commune || '')}">${escapeHtml(p.commune || '')}</span>
                            <span class="parrain-nom">${escapeHtml(fullName)}</span>
                        </div>
                    `;
                });

                html += '</div></div></div>';

                html += '</div></div></div>';
            });

            container.html(html);
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Afficher l'autocomplétion
        function showAutocomplete(input) {
            const blockId = input.dataset.block;
            let depts = [];
            try {
                depts = JSON.parse(input.dataset.depts || '[]');
            } catch(e) {
                console.error('Erreur parsing depts:', e, input.dataset.depts);
                return;
            }
            const listEl = document.getElementById('autocomplete_' + blockId);
            if (!listEl) return;

            const search = input.value.toLowerCase().trim();
            let filtered = depts.filter(d => d && d.toLowerCase().includes(search));

            // Limiter à 5 résultats
            filtered = filtered.slice(0, 5);

            let html = '';
            // Option "Tous les départements"
            const allItem = document.createElement('div');
            allItem.className = 'autocomplete-item autocomplete-item-all';
            allItem.textContent = 'Tous les départements';
            allItem.dataset.dept = '';
            allItem.onclick = function() { selectDeptFromItem(this); };

            listEl.innerHTML = '';
            listEl.appendChild(allItem);

            filtered.forEach(d => {
                const item = document.createElement('div');
                item.className = 'autocomplete-item';
                item.textContent = d;
                item.dataset.dept = d;
                item.onclick = function() { selectDeptFromItem(this); };
                listEl.appendChild(item);
            });

            listEl.classList.add('show');
        }

        // Sélection depuis un item d'autocomplétion
        function selectDeptFromItem(item) {
            const dept = item.dataset.dept || '';
            const filterDiv = item.closest('.year-block-filter');
            const input = filterDiv.querySelector('input');
            const blockId = input.dataset.block;

            input.value = dept;
            hideAutocomplete(input);
            filterYearBlock(blockId, dept);
        }

        // Filtrer l'autocomplétion pendant la saisie
        function filterAutocomplete(input) {
            showAutocomplete(input);
            // Filtrer en temps réel
            const blockId = input.dataset.block;
            const search = input.value.toLowerCase().trim();
            filterYearBlockBySearch(blockId, search);
        }

        // Cacher l'autocomplétion
        function hideAutocomplete(input) {
            const blockId = input.dataset.block;
            const listEl = document.getElementById('autocomplete_' + blockId);
            if (listEl) listEl.classList.remove('show');
        }

        // Filtrer par département exact
        function filterYearBlock(blockId, dept) {
            const container = document.getElementById(blockId);
            if (!container) return;

            const items = container.querySelectorAll('.parrain-item');
            items.forEach(item => {
                if (!dept || item.dataset.dept === dept) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        // Filtrer par recherche partielle
        function filterYearBlockBySearch(blockId, search) {
            const container = document.getElementById(blockId);
            if (!container) return;

            const items = container.querySelectorAll('.parrain-item');
            items.forEach(item => {
                const dept = (item.dataset.dept || '').toLowerCase();
                if (!search || dept.includes(search)) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        $('#btnReset').on('click', function() {
            $('#filterCandidat').val(null).trigger('change');
            $('#filterAnnee, #filterDepartement, #filterMandat').val('');
            $('#filterNom, #filterCommune').val('');
            $('#treeContainer').html('<div class="empty-state"><i class="bi bi-search"></i><p>Lancez une recherche</p></div>');
            $('#resultsCount').text('0 résultat');
        });
    </script>
</body>
</html>
