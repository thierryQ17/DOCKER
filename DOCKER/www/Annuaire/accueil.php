<?php
/**
 * Page d'accueil - Guide d'utilisation de l'application
 */
require_once __DIR__ . '/auth_middleware.php';

$currentUser = $auth->getUser();
$userType = $currentUser['type'] ?? 4;

// Charger les types d'utilisateurs depuis la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmtTypes = $pdo->query("SELECT id, nom FROM typeUtilisateur ORDER BY id");
    $userTypeLabels = $stmtTypes->fetchAll(PDO::FETCH_KEY_PAIR);
} catch (PDOException $e) {
    $userTypeLabels = [];
}

// Fallback si la table est vide ou erreur
if (empty($userTypeLabels)) {
    $userTypeLabels = [
        1 => 'Super Admin',
        2 => 'Admin',
        3 => 'Référent',
        4 => 'Membre'
    ];
}
$userTypeLabel = $userTypeLabels[$userType] ?? 'Utilisateur';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #17a2b8;
            --primary-dark: #138496;
        }

        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .welcome-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .welcome-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .welcome-header img {
            height: 100px;
            margin-bottom: 20px;
            padding: 15px 40px;
            background: linear-gradient(135deg, #1a9aaa 0%, #17a2b8 100%);
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(26, 154, 170, 0.3), 0 2px 8px rgba(0, 0, 0, 0.1);
            border: 2px solid rgba(26, 154, 170, 0.3);
        }

        .welcome-header h1 {
            color: #2d3748;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .welcome-header .subtitle {
            color: var(--primary-color);
            font-size: 1rem;
            font-weight: 600;
        }

        .welcome-header .user-welcome {
            margin-top: 15px;
            padding: 10px 20px;
            background: white;
            border-radius: 30px;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .welcome-header .user-welcome i {
            color: var(--primary-color);
        }

        .feature-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: all 0.2s ease;
            border-left: 4px solid transparent;
        }

        .feature-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }

        .feature-card.primary {
            border-left-color: var(--primary-color);
        }

        .feature-card.success {
            border-left-color: #28a745;
        }

        .feature-card.warning {
            border-left-color: #ffc107;
        }

        .feature-card.info {
            border-left-color: #6366f1;
        }

        .feature-card .icon {
            width: 45px;
            height: 45px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .feature-card.primary .icon {
            background: rgba(23, 162, 184, 0.1);
            color: var(--primary-color);
        }

        .feature-card.success .icon {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }

        .feature-card.warning .icon {
            background: rgba(255, 193, 7, 0.1);
            color: #d39e00;
        }

        .feature-card.info .icon {
            background: rgba(99, 102, 241, 0.1);
            color: #6366f1;
        }

        .feature-card h5 {
            font-size: 1rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .feature-card p {
            font-size: 0.85rem;
            color: #64748b;
            margin: 0;
            line-height: 1.5;
        }

        .quick-start {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
        }

        .quick-start h4 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .quick-start .step {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 12px;
        }

        .quick-start .step:last-child {
            margin-bottom: 0;
        }

        .quick-start .step-num {
            width: 24px;
            height: 24px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
            flex-shrink: 0;
        }

        .quick-start .step-text {
            font-size: 0.85rem;
            line-height: 1.5;
        }

        .btn-start {
            background: white;
            color: var(--primary-color);
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-start:hover {
            background: #f8f9fa;
            color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .tips-section {
            background: #fff3cd;
            border-radius: 12px;
            padding: 15px 20px;
            margin-top: 20px;
        }

        .tips-section h6 {
            color: #856404;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 0.9rem;
        }

        .tips-section ul {
            margin: 0;
            padding-left: 20px;
            font-size: 0.8rem;
            color: #856404;
        }

        .tips-section li {
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .welcome-container {
                padding: 20px 15px;
            }

            .welcome-header h1 {
                font-size: 1.4rem;
            }

            .feature-card {
                padding: 15px;
            }

            .quick-start {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <!-- En-tête de bienvenue -->
        <div class="welcome-header">
            <img src="ressources/images/logoUPR.png" alt="Logo UPR">
            <h1>Annuaire des Maires de France</h1>
            <div class="subtitle">Parrainage 2027</div>
            <div class="user-welcome">
                <i class="bi bi-person-circle me-2"></i>
                Bienvenue, <strong><?= htmlspecialchars($currentUser['prenom'] ?? '') ?> <?= htmlspecialchars($currentUser['nom'] ?? '') ?></strong>
                <span class="badge bg-info ms-2"><?= $userTypeLabel ?></span>
            </div>
        </div>

        <!-- Démarrage rapide -->
        <div class="quick-start">
            <h4><i class="bi bi-rocket-takeoff me-2"></i>Démarrage rapide</h4>
            <?php if ($userType == 4): // Membre ?>
            <div class="step">
                <div class="step-num">1</div>
                <div class="step-text">Cliquez sur le bouton <strong>"Accéder à l'annuaire"</strong> ci-dessous</div>
            </div>
            <div class="step">
                <div class="step-num">2</div>
                <div class="step-text">Sélectionnez une <strong>région</strong> puis un <strong>département</strong> pour voir les communes</div>
            </div>
            <div class="step">
                <div class="step-num">3</div>
                <div class="step-text">Cliquez sur une commune pour voir les détails du maire et enregistrer vos actions de démarchage</div>
            </div>
            <?php elseif ($userType == 3): // Référent ?>
            <div class="step">
                <div class="step-num">1</div>
                <div class="step-text">Cliquez sur <strong>"Maires"</strong> dans le menu pour accéder à l'annuaire des maires</div>
            </div>
            <div class="step">
                <div class="step-num">2</div>
                <div class="step-text">Votre département est <strong>pré-sélectionné</strong> - vous pouvez voir directement les communes assignées</div>
            </div>
            <div class="step">
                <div class="step-num">3</div>
                <div class="step-text">Suivez l'avancement de votre équipe via le bouton <strong>"Rapport"</strong> dans la barre de navigation</div>
            </div>
            <?php else: // Admin ?>
            <div class="step">
                <div class="step-num">1</div>
                <div class="step-text">Cliquez sur <strong>"Maires"</strong> dans le menu pour accéder à l'annuaire des maires</div>
            </div>
            <div class="step">
                <div class="step-num">2</div>
                <div class="step-text">Gérez les utilisateurs via le menu <strong>"Utilisateurs"</strong> et consultez les <strong>"Logs"</strong> d'activité</div>
            </div>
            <div class="step">
                <div class="step-num">3</div>
                <div class="step-text">Suivez les statistiques globales via le bouton <strong>"Rapport"</strong> dans la barre de navigation</div>
            </div>
            <?php endif; ?>
            <div class="text-center mt-4">
                <a href="#" onclick="parent.loadPage('maires_responsive.php'); return false;" class="btn-start">
                    <i class="bi bi-list-ul"></i>
                    Accéder à l'annuaire
                </a>
            </div>
        </div>

        <!-- Fonctionnalités -->
        <div class="row">
            <div class="col-md-6">
                <div class="feature-card primary d-flex gap-3">
                    <div class="icon">
                        <i class="bi bi-search"></i>
                    </div>
                    <div>
                        <h5>Recherche de maires</h5>
                        <p>Recherchez par nom de commune, nom du maire ou code postal. Utilisez les filtres pour affiner vos résultats.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="feature-card success d-flex gap-3">
                    <div class="icon">
                        <i class="bi bi-telephone"></i>
                    </div>
                    <div>
                        <h5>Démarchage téléphonique</h5>
                        <p>Enregistrez vos appels, notez les réponses des maires et suivez l'avancement de la campagne.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="feature-card warning d-flex gap-3">
                    <div class="icon">
                        <i class="bi bi-clipboard-check"></i>
                    </div>
                    <div>
                        <h5>Suivi des contacts</h5>
                        <p>Visualisez l'historique des échanges, les relances prévues et les engagements obtenus.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="feature-card info d-flex gap-3">
                    <div class="icon">
                        <i class="bi bi-bar-chart"></i>
                    </div>
                    <div>
                        <h5>Statistiques</h5>
                        <p>Consultez les rapports de progression par département et suivez les objectifs de la campagne.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Conseils -->
        <div class="tips-section">
            <h6><i class="bi bi-lightbulb me-2"></i>Conseils d'utilisation</h6>
            <ul>
                <li>Utilisez les <strong>filtres</strong> (communes traitées, à relancer, favorables) pour cibler vos appels</li>
                <li>Pensez à <strong>enregistrer vos notes</strong> après chaque contact pour un meilleur suivi</li>
                <?php if ($userType == 4): // Membre ?>
                <li>Sur mobile, le menu des régions s'ouvre en cliquant sur l'icône <i class="bi bi-list"></i> en haut à gauche</li>
                <li>Pour vous déconnecter, cliquez sur le bouton vert en haut à droite</li>
                <?php elseif ($userType == 3): // Référent ?>
                <li>Vous pouvez <strong>créer des membres</strong> pour votre département via le menu "Utilisateurs"</li>
                <li>Le <strong>rapport</strong> vous montre les statistiques de votre équipe et de votre département</li>
                <?php else: // Admin ?>
                <li>Gérez les <strong>utilisateurs</strong> (création, modification, désactivation) via le menu dédié</li>
                <li>Consultez les <strong>logs</strong> pour suivre l'activité et les connexions de l'application</li>
                <?php endif; ?>
            </ul>
        </div>
    </div>
</body>
</html>
