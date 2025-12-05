<?php
require_once __DIR__ . '/auth_middleware.php';

// Récupérer les informations de l'utilisateur connecté
$currentUser = $_SESSION['user'] ?? null;
if (!$currentUser) {
    header('Location: login.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Changer mon mot de passe - Annuaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .password-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-width: 500px;
            width: 100%;
        }

        .password-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .password-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }

        .password-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }

        .password-body {
            padding: 40px;
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .input-group {
            position: relative;
        }

        .input-group .btn-outline-secondary {
            border: 2px solid #e2e8f0;
            border-left: none;
            border-radius: 0 10px 10px 0;
            background: white;
            transition: all 0.3s;
        }

        .input-group .btn-outline-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e1;
        }

        .input-group .form-control {
            border-radius: 10px 0 0 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #e2e8f0;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 15px;
            color: #4a5568;
            transition: all 0.3s;
        }

        .btn-secondary:hover {
            background: #cbd5e1;
            color: #2d3748;
        }

        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            font-size: 14px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .password-requirements {
            background: #f7fafc;
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
            font-size: 13px;
        }

        .password-requirements h6 {
            font-size: 14px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
        }

        .password-requirements ul {
            margin: 0;
            padding-left: 20px;
            color: #4a5568;
        }

        .password-requirements li {
            margin-bottom: 5px;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
        }

        .back-link a:hover {
            color: #764ba2;
        }
    </style>
</head>
<body>
    <div class="password-card">
        <div class="password-header">
            <i class="bi bi-shield-lock" style="font-size: 48px;"></i>
            <h2>Changer mon mot de passe</h2>
            <p><?= htmlspecialchars($currentUser['prenom'] ?? '') ?> <?= htmlspecialchars($currentUser['nom'] ?? '') ?></p>
        </div>
        <div class="password-body">
            <div id="message"></div>

            <form id="changePasswordForm">
                <div class="mb-3">
                    <label for="currentPassword" class="form-label">Mot de passe actuel</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="currentPassword" required>
                        <button class="btn btn-outline-secondary" type="button" onclick="toggleVisibility('currentPassword', 'icon1')">
                            <i class="bi bi-eye" id="icon1"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="newPassword" class="form-label">Nouveau mot de passe</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="newPassword" required>
                        <button class="btn btn-outline-secondary" type="button" onclick="toggleVisibility('newPassword', 'icon2')">
                            <i class="bi bi-eye" id="icon2"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirmer le nouveau mot de passe</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="confirmPassword" required>
                        <button class="btn btn-outline-secondary" type="button" onclick="toggleVisibility('confirmPassword', 'icon3')">
                            <i class="bi bi-eye" id="icon3"></i>
                        </button>
                    </div>
                    <small id="passwordError" class="text-danger" style="display: none;">Les mots de passe ne correspondent pas</small>
                </div>

                <div class="password-requirements">
                    <h6><i class="bi bi-info-circle me-2"></i>Exigences du mot de passe</h6>
                    <ul>
                        <li>Au moins 6 caractères</li>
                        <li>Différent de l'ancien mot de passe</li>
                    </ul>
                </div>

                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle me-2"></i>Changer le mot de passe
                    </button>
                    <a href="index.php" class="btn btn-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Annuler
                    </a>
                </div>
            </form>

            <div class="back-link">
                <a href="index.php"><i class="bi bi-arrow-left me-1"></i>Retour à l'accueil</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        function toggleVisibility(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);

            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        }

        // Validation en temps réel
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordError = document.getElementById('passwordError');

        function validatePasswordMatch() {
            if (confirmPasswordInput.value && newPasswordInput.value !== confirmPasswordInput.value) {
                passwordError.style.display = 'block';
                confirmPasswordInput.classList.add('is-invalid');
            } else {
                passwordError.style.display = 'none';
                confirmPasswordInput.classList.remove('is-invalid');
            }
        }

        newPasswordInput.addEventListener('input', validatePasswordMatch);
        confirmPasswordInput.addEventListener('input', validatePasswordMatch);

        // Soumission du formulaire
        document.getElementById('changePasswordForm').addEventListener('submit', async function(e) {
            e.preventDefault();

            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // Validation
            if (newPassword !== confirmPassword) {
                showMessage('Les mots de passe ne correspondent pas', 'danger');
                return;
            }

            if (newPassword.length < 6) {
                showMessage('Le nouveau mot de passe doit contenir au moins 6 caractères', 'danger');
                return;
            }

            if (currentPassword === newPassword) {
                showMessage('Le nouveau mot de passe doit être différent de l\'ancien', 'danger');
                return;
            }

            try {
                const response = await fetch('api.php?action=changePassword', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        currentPassword: currentPassword,
                        newPassword: newPassword
                    })
                });

                const result = await response.json();

                if (result.success) {
                    showMessage('Mot de passe modifié avec succès ! Redirection...', 'success');
                    document.getElementById('changePasswordForm').reset();

                    // Redirection après 2 secondes
                    setTimeout(() => {
                        window.location.href = 'index.php';
                    }, 2000);
                } else {
                    showMessage(result.error || 'Erreur lors de la modification du mot de passe', 'danger');
                }
            } catch (error) {
                console.error('Erreur:', error);
                showMessage('Erreur de connexion au serveur', 'danger');
            }
        });

        function showMessage(message, type) {
            const messageDiv = document.getElementById('message');
            messageDiv.innerHTML = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
        }
    </script>
</body>
</html>
