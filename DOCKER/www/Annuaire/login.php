<?php
/**
 * Page de connexion - Annuaire des Maires de France
 */

require_once __DIR__ . '/config/auth_config.php';
require_once __DIR__ . '/classes/AppAuth.php';
require_once __DIR__ . '/classes/Logger.php';

// Configuration database
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

// Créer l'instance Logger (optionnel)
try {
    $GLOBALS['logger'] = new Logger($pdo);
} catch (Exception $e) {
    $GLOBALS['logger'] = null;
}

// Créer l'instance AppAuth
$auth = new AppAuth($pdo, AUTH_ENABLED);

// Lire la configuration de l'environnement
$environnement = 'dev'; // Par défaut
$menusConfigPath = __DIR__ . '/config/menus.json';
if (file_exists($menusConfigPath)) {
    $menusConfig = json_decode(file_get_contents($menusConfigPath), true);
    if (isset($menusConfig['environnement'])) {
        $environnement = $menusConfig['environnement'];
    }
}
$isProd = ($environnement === 'prod');

// Si déjà connecté, rediriger
if ($auth->isLoggedIn()) {
    header('Location: ' . AUTH_REDIRECT_AFTER_LOGIN);
    exit;
}

$error = '';
$success = '';
$attemptsInfo = null;
$isInactive = false;

// Récupérer tous les utilisateurs actifs pour le mode TEST
$utilisateurs = [];
$typesUtilisateurs = [];
try {
    $stmt = $pdo->query("
        SELECT id, nom
        FROM typeUtilisateur
        ORDER BY id ASC
    ");
    $typesUtilisateurs = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    $typesUtilisateurs = [
        ['id' => 1, 'nom' => 'Super Admin'],
        ['id' => 2, 'nom' => 'Admin'],
        ['id' => 3, 'nom' => 'Référent'],
        ['id' => 4, 'nom' => 'Membre']
    ];
}

try {
    $stmt = $pdo->query("
        SELECT u.id, u.nom, u.prenom, u.adresseMail, u.typeUtilisateur_id, u.actif
        FROM utilisateurs u
        WHERE u.actif = 1
        ORDER BY u.prenom ASC, u.nom ASC
    ");
    $utilisateurs = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    // Ignorer l'erreur en mode PROD
}

// Traitement du formulaire de connexion
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $pwd = $_POST['password'] ?? '';
    $remember = isset($_POST['remember']);

    if (empty($email) || empty($pwd)) {
        $error = 'Veuillez remplir tous les champs';
    } else {
        $result = $auth->login($email, $pwd, $remember);

        if ($result['success']) {
            header('Location: ' . AUTH_REDIRECT_AFTER_LOGIN);
            exit;
        } else {
            $error = $result['error'] ?? 'Erreur de connexion';
            $isInactive = $result['inactive'] ?? false;

            // Récupérer les informations sur les tentatives restantes (sauf pour compte inactif)
            if (!empty($email) && !str_contains($error, 'Trop de tentatives') && !$isInactive) {
                $attemptsInfo = $auth->getRemainingAttempts($email);
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            <?php if ($isProd): ?>
            background: linear-gradient(135deg, #1a9aaa 0%, #17a2b8 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .login-container {
            width: 100%;
            max-width: 380px;
            padding: 15px;
        }

        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .login-header {
            <?php if ($isProd): ?>
            background: linear-gradient(135deg, #1a9aaa 0%, #17a2b8 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            color: white;
            padding: 25px 25px;
            text-align: center;
        }

        .login-header h1 {
            font-size: 22px;
            font-weight: 700;
            margin: 0 0 5px 0;
        }

        .login-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 12px;
        }

        .login-body {
            padding: 25px 25px;
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .form-label-compact {
            font-weight: 600;
            color: #2d3748;
            font-size: 12px;
            margin-bottom: 0;
            padding-top: 0;
            padding-bottom: 0;
        }

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 13px;
            transition: all 0.2s;
        }

        .form-control-sm, .form-select-sm {
            padding: 6px 10px;
            font-size: 12px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #17a2b8;
            box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.1);
        }

        .input-group {
            position: relative;
        }

        .input-group i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 18px;
        }

        .btn-login {
            <?php if ($isProd): ?>
            background: linear-gradient(135deg, #1a9aaa 0%, #17a2b8 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            border: none;
            border-radius: 8px;
            padding: 10px;
            font-size: 14px;
            font-weight: 600;
            color: white;
            width: 100%;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-login:hover {
            transform: translateY(-1px);
            <?php if ($isProd): ?>
            box-shadow: 0 6px 15px rgba(26, 154, 170, 0.4);
            <?php else: ?>
            box-shadow: 0 6px 15px rgba(23, 162, 184, 0.4);
            <?php endif; ?>
        }

        .form-check {
            padding-left: 1.8em;
        }

        .form-check-input:checked {
            <?php if ($isProd): ?>
            background-color: #1a9aaa;
            border-color: #1a9aaa;
            <?php else: ?>
            background-color: #17a2b8;
            border-color: #17a2b8;
            <?php endif; ?>
        }

        .alert {
            border-radius: 10px;
            border: none;
        }

        .alert-danger {
            background-color: #fee;
            color: #c33;
        }

        .alert-warning-inactive {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeeba 100%);
            color: #856404;
            border-left: 4px solid #ffc107;
            padding: 15px;
        }

        .alert-warning-inactive i.bi-person-x-fill {
            font-size: 1.5rem;
            color: #dc3545;
        }

        .mode-switch {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
            background: #f8f9fa;
            padding: 5px;
            border-radius: 8px;
        }

        .mode-switch button {
            flex: 1;
            padding: 6px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
            background: transparent;
            color: #718096;
        }

        .mode-switch button.active {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            box-shadow: 0 3px 8px rgba(23, 162, 184, 0.3);
        }

        .mode-switch button:hover:not(.active) {
            background: #e2e8f0;
        }

        .form-mode {
            display: none;
        }

        .form-mode.active {
            display: block;
        }

        .user-info {
            background: #f8f9fa;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 11px;
            display: none;
        }

        .user-info.show {
            display: block;
        }

        .user-info strong {
            color: #17a2b8;
        }

        /* Responsive pour mobile - garder labels sur la même ligne */
        @media (max-width: 480px) {
            .login-container {
                padding: 10px;
                max-width: 100%;
            }

            .login-card {
                border-radius: 15px;
            }

            .login-header {
                padding: 20px 15px;
            }

            .login-header h1 {
                font-size: 18px;
            }

            .login-body {
                padding: 20px 15px;
            }

            /* Garder les labels sur la même ligne */
            .mb-2.row .col-4 {
                flex: 0 0 35%;
                max-width: 35%;
            }

            .mb-2.row .col-8 {
                flex: 0 0 65%;
                max-width: 65%;
            }

            .form-label-compact {
                font-size: 10px;
            }

            .mb-3.row .col-8.offset-4 {
                margin-left: 35%;
                flex: 0 0 65%;
                max-width: 65%;
            }

            .mode-switch button {
                font-size: 11px;
                padding: 5px;
            }

            .btn-login {
                padding: 8px;
                font-size: 13px;
            }
        }

        <?php if (!AUTH_ENABLED): ?>
        .auth-disabled-banner {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            text-align: center;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        <?php endif; ?>
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Logo UPR en haut -->
        <div class="text-center mb-3">
            <img src="ressources/images/logoUPR.png" alt="Logo UPR" style="height: 55px; width: auto; filter: drop-shadow(0 4px 8px rgba(0,0,0,0.2));">
        </div>

        <?php if (!AUTH_ENABLED): ?>
        <div class="auth-disabled-banner">
            <i class="bi bi-info-circle me-2"></i>
            Mode développement : Authentification désactivée
        </div>
        <?php endif; ?>

        <div class="login-card">
            <div class="login-header">
                <h1><i class="bi bi-shield-lock me-2"></i>Connexion</h1>
                <p>Annuaire des Maires de France</p>
                <p style="font-size: 11px; opacity: 0.8; margin-top: 3px; font-weight: 700;">Parrainage 2027</p>
            </div>

            <div class="login-body">
                <?php if ($error): ?>
                <?php if ($isInactive): ?>
                <div class="alert alert-warning-inactive mb-3">
                    <div class="d-flex align-items-start gap-3">
                        <i class="bi bi-person-x-fill"></i>
                        <div>
                            <strong>Compte désactivé</strong>
                            <div style="font-size: 13px; margin-top: 5px;">
                                <?= htmlspecialchars($error) ?>
                            </div>
                        </div>
                    </div>
                </div>
                <?php else: ?>
                <div class="alert alert-danger mb-3">
                    <i class="bi bi-exclamation-triangle me-2"></i><?= htmlspecialchars($error) ?>
                    <?php if ($attemptsInfo && $attemptsInfo['remaining'] > 0): ?>
                    <div class="mt-2" style="font-size: 13px;">
                        <i class="bi bi-shield-exclamation me-1"></i>
                        Tentatives restantes : <strong><?= $attemptsInfo['current'] ?>/<?= $attemptsInfo['max'] ?></strong>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
                <?php endif; ?>

                <?php if ($success): ?>
                <div class="alert alert-success mb-3">
                    <i class="bi bi-check-circle me-2"></i><?= htmlspecialchars($success) ?>
                </div>
                <?php endif; ?>

                <!-- Switch PROD/TEST (masqué en mode prod) -->
                <?php if (!$isProd): ?>
                <div class="mode-switch">
                    <button type="button" class="mode-btn" data-mode="prod">
                        <i class="bi bi-shield-lock me-1"></i>PROD
                    </button>
                    <button type="button" class="mode-btn active" data-mode="test">
                        <i class="bi bi-bug me-1"></i>TEST
                    </button>
                </div>
                <?php endif; ?>

                <!-- Formulaire PROD (saisie manuelle) - actif par défaut en mode prod -->
                <form method="POST" action="" class="form-mode<?= $isProd ? ' active' : '' ?>" id="form-prod">
                    <div class="mb-2 row align-items-center">
                        <label for="email-prod" class="col-4 col-form-label form-label-compact">
                            <i class="bi bi-envelope me-1"></i>Email
                        </label>
                        <div class="col-8">
                            <input type="email" class="form-control form-control-sm" id="email-prod" name="email" required
                                   value="<?= htmlspecialchars($_POST['email'] ?? '') ?>"
                                   placeholder="votre@email.com">
                        </div>
                    </div>

                    <div class="mb-2 row align-items-center">
                        <label for="password-prod" class="col-4 col-form-label form-label-compact" style="white-space: nowrap;">
                            <i class="bi bi-lock me-1"></i>Mdp
                        </label>
                        <div class="col-8">
                            <input type="password" class="form-control form-control-sm" id="password-prod" name="password" required
                                   placeholder="••••••••">
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <div class="col-8 offset-4">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="remember-prod" name="remember">
                                <label class="form-check-label small" for="remember-prod">
                                    Se souvenir de moi
                                </label>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-login">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
                    </button>
                </form>

                <!-- Formulaire TEST (liste déroulante) - masqué en mode prod -->
                <?php if (!$isProd): ?>
                <form method="POST" action="" class="form-mode active" id="form-test">
                    <!-- Champ caché pour l'email sélectionné -->
                    <input type="hidden" id="email-test" name="email" required>

                    <!-- Président (type 5) -->
                    <div class="mb-2 row align-items-center">
                        <label for="select-type-5" class="col-4 col-form-label form-label-compact">
                            <i class="bi bi-star-fill text-purple me-1" style="color: #9b59b6;"></i>Président
                        </label>
                        <div class="col-8">
                            <select class="form-select form-select-sm user-select" id="select-type-5" data-type="5">
                                <option value="">---</option>
                                <?php foreach ($utilisateurs as $user): ?>
                                    <?php if ($user['typeUtilisateur_id'] == 5): ?>
                                <option value="<?= htmlspecialchars($user['adresseMail']) ?>">
                                    <?= htmlspecialchars($user['prenom'] . ' ' . $user['nom']) ?>
                                </option>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>

                    <!-- Super Admin (type 1) -->
                    <div class="mb-2 row align-items-center">
                        <label for="select-type-1" class="col-4 col-form-label form-label-compact">
                            <i class="bi bi-shield-fill text-danger me-1"></i>Super Admin
                        </label>
                        <div class="col-8">
                            <select class="form-select form-select-sm user-select" id="select-type-1" data-type="1">
                                <option value="">---</option>
                                <?php foreach ($utilisateurs as $user): ?>
                                    <?php if ($user['typeUtilisateur_id'] == 1): ?>
                                <option value="<?= htmlspecialchars($user['adresseMail']) ?>">
                                    <?= htmlspecialchars($user['prenom'] . ' ' . $user['nom']) ?>
                                </option>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>

                    <!-- Admin (type 2) -->
                    <div class="mb-2 row align-items-center">
                        <label for="select-type-2" class="col-4 col-form-label form-label-compact">
                            <i class="bi bi-shield-fill text-warning me-1"></i>Admin
                        </label>
                        <div class="col-8">
                            <select class="form-select form-select-sm user-select" id="select-type-2" data-type="2">
                                <option value="">---</option>
                                <?php foreach ($utilisateurs as $user): ?>
                                    <?php if ($user['typeUtilisateur_id'] == 2): ?>
                                <option value="<?= htmlspecialchars($user['adresseMail']) ?>">
                                    <?= htmlspecialchars($user['prenom'] . ' ' . $user['nom']) ?>
                                </option>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>

                    <!-- Référent (type 3) -->
                    <div class="mb-2 row align-items-center">
                        <label for="select-type-3" class="col-4 col-form-label form-label-compact">
                            <i class="bi bi-person-badge-fill text-info me-1"></i>Référent
                        </label>
                        <div class="col-8">
                            <select class="form-select form-select-sm user-select" id="select-type-3" data-type="3">
                                <option value="">---</option>
                                <?php foreach ($utilisateurs as $user): ?>
                                    <?php if ($user['typeUtilisateur_id'] == 3): ?>
                                <option value="<?= htmlspecialchars($user['adresseMail']) ?>">
                                    <?= htmlspecialchars($user['prenom'] . ' ' . $user['nom']) ?>
                                </option>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>

                    <!-- Membre (type 4) -->
                    <div class="mb-2 row align-items-center">
                        <label for="select-type-4" class="col-4 col-form-label form-label-compact">
                            <i class="bi bi-person-fill text-success me-1"></i>Membre
                        </label>
                        <div class="col-8">
                            <select class="form-select form-select-sm user-select" id="select-type-4" data-type="4">
                                <option value="">---</option>
                                <?php foreach ($utilisateurs as $user): ?>
                                    <?php if ($user['typeUtilisateur_id'] == 4): ?>
                                <option value="<?= htmlspecialchars($user['adresseMail']) ?>">
                                    <?= htmlspecialchars($user['prenom'] . ' ' . $user['nom']) ?>
                                </option>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>

                    <!-- Mot de passe -->
                    <div class="mb-2 row align-items-center">
                        <label for="password-test" class="col-4 col-form-label form-label-compact" style="white-space: nowrap;">
                            <i class="bi bi-lock me-1"></i>Mdp
                        </label>
                        <div class="col-8">
                            <input type="password" class="form-control form-control-sm" id="password-test" name="password" required
                                   value="upr" placeholder="••••••••">
                        </div>
                    </div>

                    <!-- Remember me -->
                    <div class="mb-3 row">
                        <div class="col-8 offset-4">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="remember-test" name="remember">
                                <label class="form-check-label small" for="remember-test">
                                    Se souvenir de moi
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Bouton connexion -->
                    <button type="submit" class="btn btn-login">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
                    </button>
                </form>
                <?php endif; ?>
            </div>
        </div>

        <div class="text-center mt-3" style="color: white; font-size: 12px; opacity: 0.8;">
            <i class="bi bi-shield-check me-1"></i>Connexion sécurisée
        </div>
    </div>

    <script>
        <?php if (!$isProd): ?>
        // Données des utilisateurs en JSON pour JavaScript
        const utilisateurs = <?= json_encode($utilisateurs) ?>;
        const typesUtilisateurs = <?= json_encode($typesUtilisateurs) ?>;

        // Gestion du switch PROD/TEST
        const modeButtons = document.querySelectorAll('.mode-btn');
        const formProd = document.getElementById('form-prod');
        const formTest = document.getElementById('form-test');

        modeButtons.forEach(button => {
            button.addEventListener('click', function() {
                const mode = this.getAttribute('data-mode');

                // Retirer la classe active de tous les boutons
                modeButtons.forEach(btn => btn.classList.remove('active'));

                // Ajouter la classe active au bouton cliqué
                this.classList.add('active');

                // Afficher/masquer les formulaires
                if (mode === 'prod') {
                    formProd.classList.add('active');
                    formTest.classList.remove('active');
                } else {
                    formProd.classList.remove('active');
                    formTest.classList.add('active');
                }
            });
        });

        // Gestion du formulaire TEST - 4 listes déroulantes par type
        const userSelects = document.querySelectorAll('.user-select');
        const emailHidden = document.getElementById('email-test');

        // Quand on sélectionne un utilisateur dans une liste, réinitialiser les autres et soumettre
        userSelects.forEach(select => {
            select.addEventListener('change', function() {
                if (this.value !== '') {
                    // Réinitialiser les autres selects
                    userSelects.forEach(otherSelect => {
                        if (otherSelect !== this) {
                            otherSelect.value = '';
                        }
                    });
                    // Mettre à jour le champ hidden avec l'email sélectionné
                    emailHidden.value = this.value;

                    // Soumettre automatiquement le formulaire test
                    const testForm = document.getElementById('form-test');
                    if (testForm) {
                        testForm.submit();
                    }
                } else {
                    // Si on désélectionne, vérifier si un autre est sélectionné
                    let foundEmail = '';
                    userSelects.forEach(s => {
                        if (s.value !== '') {
                            foundEmail = s.value;
                        }
                    });
                    emailHidden.value = foundEmail;
                }
            });
        });
        <?php endif; ?>

        // Gestion de la touche Entrée pour soumettre le formulaire actif
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                // Trouver le formulaire actif
                const activeForm = document.querySelector('.form-mode.active');
                if (activeForm) {
                    e.preventDefault();
                    activeForm.submit();
                }
            }
        });
    </script>
</body>
</html>
