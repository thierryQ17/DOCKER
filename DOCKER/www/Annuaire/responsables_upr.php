<?php
/**
 * Page d'affichage des responsables UPR
 */

// Charger les données (utiliser le JSON nettoyé si disponible)
$jsonFile = __DIR__ . '/data/responsablesUPR_clean.json';
if (!file_exists($jsonFile)) {
    $jsonFile = __DIR__ . '/data/responsablesUPR.json';
}

$responsables = [];
if (file_exists($jsonFile)) {
    $responsables = json_decode(file_get_contents($jsonFile), true) ?? [];
}

// Regrouper par département
$parDepartement = [];
foreach ($responsables as $r) {
    $dept = $r['departement'] ?? 'Autres';
    if (empty($dept)) $dept = 'National';
    if (!isset($parDepartement[$dept])) {
        $parDepartement[$dept] = [];
    }
    $parDepartement[$dept][] = $r;
}
ksort($parDepartement);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsables UPR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .page-header {
            background: linear-gradient(135deg, #002654 0%, #003d82 100%);
            padding: 15px 20px;
            color: white;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .page-header h1 {
            margin: 0;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stats-bar {
            background: white;
            padding: 10px 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .stat-value {
            font-weight: 700;
            color: #002654;
        }

        .content {
            padding: 15px;
        }

        .dept-section {
            margin-bottom: 20px;
        }

        .dept-header {
            background: linear-gradient(135deg, #002654 0%, #003d82 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 8px 8px 0 0;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dept-count {
            background: rgba(255,255,255,0.2);
            padding: 2px 10px;
            border-radius: 10px;
            font-size: 12px;
        }

        .responsables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 10px;
            background: white;
            padding: 10px;
            border-radius: 0 0 8px 8px;
            border: 1px solid #dee2e6;
            border-top: none;
        }

        .responsable-card {
            display: flex;
            gap: 12px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            transition: all 0.2s;
        }

        .responsable-card:hover {
            background: #e9ecef;
            border-color: #002654;
        }

        .responsable-photo {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            background: #dee2e6;
            flex-shrink: 0;
        }

        .responsable-photo.no-photo {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #6c757d;
        }

        .responsable-info {
            flex: 1;
            min-width: 0;
        }

        .responsable-nom {
            font-weight: 600;
            font-size: 14px;
            color: #2d3748;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .responsable-dept {
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 6px;
        }

        .responsable-email {
            font-size: 11px;
        }

        .responsable-email a {
            color: #002654;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .responsable-email a:hover {
            text-decoration: underline;
        }

        .search-box {
            background: white;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
        }

        .search-box input:focus {
            outline: none;
            border-color: #002654;
            box-shadow: 0 0 0 3px rgba(0, 38, 84, 0.1);
        }

        @media (max-width: 768px) {
            .responsables-grid {
                grid-template-columns: 1fr;
            }

            .responsable-card {
                padding: 8px;
            }

            .responsable-photo {
                width: 50px;
                height: 50px;
            }
        }
    </style>
</head>
<body>
    <div class="page-header">
        <h1><i class="bi bi-people-fill"></i> Responsables UPR</h1>
    </div>

    <div class="stats-bar">
        <div class="stat-item">
            <i class="bi bi-person-badge"></i>
            <span>Total:</span>
            <span class="stat-value"><?= count($responsables) ?></span>
        </div>
        <div class="stat-item">
            <i class="bi bi-geo-alt"></i>
            <span>Départements:</span>
            <span class="stat-value"><?= count($parDepartement) ?></span>
        </div>
    </div>

    <div class="content">
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Rechercher un responsable (nom, département, email)...">
        </div>

        <div id="responsablesContainer">
            <?php foreach ($parDepartement as $dept => $membres): ?>
            <div class="dept-section" data-dept="<?= htmlspecialchars(strtolower($dept)) ?>">
                <div class="dept-header">
                    <span><i class="bi bi-geo-alt-fill"></i> <?= htmlspecialchars($dept) ?></span>
                    <span class="dept-count"><?= count($membres) ?></span>
                </div>
                <div class="responsables-grid">
                    <?php foreach ($membres as $r): ?>
                    <div class="responsable-card"
                         data-nom="<?= htmlspecialchars(strtolower($r['nom'] ?? '')) ?>"
                         data-email="<?= htmlspecialchars(strtolower($r['email'] ?? '')) ?>">
                        <?php if (!empty($r['image']) && strpos($r['image'], 'data:') !== 0): ?>
                            <img src="<?= htmlspecialchars($r['image']) ?>" alt="" class="responsable-photo">
                        <?php elseif (!empty($r['image'])): ?>
                            <img src="<?= htmlspecialchars($r['image']) ?>" alt="" class="responsable-photo">
                        <?php else: ?>
                            <div class="responsable-photo no-photo"><i class="bi bi-person"></i></div>
                        <?php endif; ?>
                        <div class="responsable-info">
                            <div class="responsable-nom"><?= htmlspecialchars($r['nom'] ?? 'Inconnu') ?></div>
                            <div class="responsable-dept"><?= htmlspecialchars($r['departement'] ?? '') ?></div>
                            <?php if (!empty($r['email'])): ?>
                            <div class="responsable-email">
                                <a href="mailto:<?= htmlspecialchars($r['email']) ?>">
                                    <i class="bi bi-envelope"></i>
                                    <?= htmlspecialchars($r['email']) ?>
                                </a>
                            </div>
                            <?php endif; ?>
                        </div>
                    </div>
                    <?php endforeach; ?>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>

    <script>
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const search = e.target.value.toLowerCase().trim();
            const sections = document.querySelectorAll('.dept-section');

            sections.forEach(section => {
                const dept = section.dataset.dept;
                const cards = section.querySelectorAll('.responsable-card');
                let visibleCount = 0;

                cards.forEach(card => {
                    const nom = card.dataset.nom;
                    const email = card.dataset.email;
                    const matches = !search ||
                                    nom.includes(search) ||
                                    email.includes(search) ||
                                    dept.includes(search);

                    card.style.display = matches ? '' : 'none';
                    if (matches) visibleCount++;
                });

                // Cacher la section si aucune carte visible
                section.style.display = visibleCount > 0 ? '' : 'none';

                // Mettre à jour le compteur
                const countEl = section.querySelector('.dept-count');
                if (countEl && search) {
                    countEl.textContent = visibleCount;
                }
            });
        });
    </script>
</body>
</html>
