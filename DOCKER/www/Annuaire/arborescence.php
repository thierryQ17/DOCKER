<?php
/**
 * Page d'affichage du menu arborescent basé sur la table arborescence (Nested Sets)
 * Version SYNCHRONE - charge tout au démarrage
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

// Récupérer l'arborescence complète triée par borne_gauche
$stmt = $pdo->query("
    SELECT id, borne_gauche, borne_droite, niveau, libelle, type_element, reference_id, cle_unique
    FROM arborescence
    WHERE niveau > 0
    ORDER BY borne_gauche
");
$nodes = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Compter le nombre d'éléments par type
$stats = $pdo->query("
    SELECT type_element, COUNT(*) as nb
    FROM arborescence
    WHERE niveau > 0
    GROUP BY type_element
    ORDER BY FIELD(type_element, 'region', 'departement', 'circonscription', 'canton')
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
            <a class="navbar-brand" href="maires-responsive.php">
                <i class="bi bi-diagram-3 me-2"></i>Arborescence
            </a>
            <a href="maires-responsive.php" class="btn btn-outline-light btn-sm">
                <i class="bi bi-arrow-left me-1"></i>Retour
            </a>
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
                <i class="bi bi-geo-alt text-warning"></i>
                <span>Circonscriptions</span>
                <span class="badge bg-warning text-dark"><?= number_format($stats['circonscription'] ?? 0) ?></span>
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
                    <input type="text" id="searchInput" class="form-control" placeholder="Rechercher...">
                </div>
                <button class="btn-expand-all" onclick="expandAll()">
                    <i class="bi bi-arrows-expand me-1"></i>Tout déplier
                </button>
                <button class="btn-expand-all" onclick="collapseAll()" style="background: #6c757d;">
                    <i class="bi bi-arrows-collapse me-1"></i>Tout replier
                </button>
            </div>

            <!-- Arbre -->
            <div id="treeRoot">
                <?php
                // Construire l'arbre HTML
                $stack = [];
                $prevLevel = 0;

                foreach ($nodes as $node) {
                    $level = $node['niveau'];
                    $type = $node['type_element'];
                    $hasChildren = ($node['borne_droite'] - $node['borne_gauche']) > 1;

                    // Fermer les niveaux précédents si nécessaire
                    while ($prevLevel >= $level && !empty($stack)) {
                        echo '</ul></li>';
                        array_pop($stack);
                        $prevLevel--;
                    }

                    // Icône selon le type
                    $icons = [
                        'region' => 'bi-globe',
                        'departement' => 'bi-building',
                        'circonscription' => 'bi-geo-alt',
                        'canton' => 'bi-pin-map'
                    ];
                    $icon = $icons[$type] ?? 'bi-folder';

                    // Nombre d'enfants
                    $childCount = ($node['borne_droite'] - $node['borne_gauche'] - 1) / 2;

                    echo '<li class="tree-item level-' . $level . '" data-type="' . $type . '" data-label="' . htmlspecialchars(strtolower($node['libelle'])) . '">';
                    echo '<div class="tree-item-content" onclick="toggleNode(this)">';
                    echo '<span class="tree-toggle ' . ($hasChildren ? '' : 'no-children') . '"><i class="bi bi-chevron-right"></i></span>';
                    echo '<span class="tree-icon ' . $type . '"><i class="bi ' . $icon . '"></i></span>';
                    echo '<span class="tree-label">' . htmlspecialchars($node['libelle']) . '</span>';
                    if ($hasChildren && $childCount > 0) {
                        echo '<span class="tree-badge">' . number_format($childCount) . '</span>';
                    }
                    echo '</div>';

                    if ($hasChildren) {
                        echo '<ul class="tree-node tree-children">';
                        array_push($stack, $level);
                        $prevLevel = $level;
                    } else {
                        echo '</li>';
                    }
                }

                // Fermer tous les niveaux restants
                while (!empty($stack)) {
                    echo '</ul></li>';
                    array_pop($stack);
                }
                ?>
            </div>
        </div>
    </div>

    <script>
        // Toggle d'un noeud
        function toggleNode(element) {
            const toggle = element.querySelector('.tree-toggle');
            const children = element.nextElementSibling;

            if (toggle.classList.contains('no-children')) return;

            toggle.classList.toggle('expanded');
            if (children && children.classList.contains('tree-children')) {
                children.classList.toggle('expanded');
            }
        }

        // Tout déplier
        function expandAll() {
            document.querySelectorAll('.tree-toggle:not(.no-children)').forEach(toggle => {
                toggle.classList.add('expanded');
            });
            document.querySelectorAll('.tree-children').forEach(children => {
                children.classList.add('expanded');
            });
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

        // Recherche
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const query = e.target.value.toLowerCase().trim();
            const items = document.querySelectorAll('.tree-item');

            if (query === '') {
                // Réinitialiser
                items.forEach(item => {
                    item.style.display = '';
                    const label = item.querySelector('.tree-label');
                    label.innerHTML = label.textContent;
                });
                collapseAll();
                return;
            }

            // Chercher et afficher les correspondances
            items.forEach(item => {
                const label = item.querySelector('.tree-label');
                const text = label.textContent;
                const lowerText = text.toLowerCase();

                if (lowerText.includes(query)) {
                    item.style.display = '';
                    // Surligner
                    const regex = new RegExp('(' + query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
                    label.innerHTML = text.replace(regex, '<span class="highlight">$1</span>');

                    // Déplier les parents
                    let parent = item.parentElement;
                    while (parent) {
                        if (parent.classList.contains('tree-children')) {
                            parent.classList.add('expanded');
                            const prevToggle = parent.previousElementSibling?.querySelector('.tree-toggle');
                            if (prevToggle) prevToggle.classList.add('expanded');
                        }
                        parent = parent.parentElement;
                    }
                } else {
                    item.style.display = 'none';
                    label.innerHTML = text;
                }
            });
        });

        // Déplier le premier niveau au chargement
        document.querySelectorAll('.level-1 > .tree-item-content .tree-toggle').forEach(toggle => {
            // Ne pas déplier automatiquement pour de meilleures performances
        });
    </script>
</body>
</html>
