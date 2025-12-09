<?php
/**
 * Script de mise à jour de tous les mots de passe utilisateurs
 * ATTENTION : Ce script doit être utilisé uniquement en environnement de test/développement
 */

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

// Charger les types d'utilisateurs depuis la base de données
try {
    $stmtTypes = $pdo->query("SELECT id, nom FROM typeUtilisateur ORDER BY id");
    $typeLabels = $stmtTypes->fetchAll(PDO::FETCH_KEY_PAIR);
} catch (PDOException $e) {
    $typeLabels = [];
}

// Fallback si la table est vide ou erreur
if (empty($typeLabels)) {
    $typeLabels = [
        1 => 'Super Admin',
        2 => 'Admin',
        3 => 'Référent',
        4 => 'Membre'
    ];
}

// Nouveau mot de passe
$newPassword = 'upr';
$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

echo "<!DOCTYPE html>
<html lang='fr'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Mise à jour des mots de passe</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css' rel='stylesheet'>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        .container {
            max-width: 800px;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        .alert {
            border-radius: 10px;
        }
        .user-row {
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
        }
        .user-row:last-child {
            border-bottom: none;
        }
        .badge {
            font-size: 11px;
        }
    </style>
</head>
<body>
    <div class='container'>
        <h1 class='text-center mb-4'>
            <i class='bi bi-key-fill me-2' style='color: #667eea;'></i>
            Mise à jour des mots de passe
        </h1>";

try {
    // Récupérer tous les utilisateurs
    $stmt = $pdo->query("
        SELECT id, nom, prenom, adresseMail, typeUtilisateur_id, actif
        FROM utilisateurs
        ORDER BY typeUtilisateur_id ASC, nom ASC
    ");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (count($users) === 0) {
        echo "<div class='alert alert-warning'>Aucun utilisateur trouvé dans la base de données.</div>";
    } else {
        // Mettre à jour tous les mots de passe
        $updateStmt = $pdo->prepare("UPDATE utilisateurs SET mdp = ? WHERE id = ?");
        $updateCount = 0;

        echo "<div class='alert alert-info mb-4'>
                <strong>Nouveau mot de passe :</strong> <code>$newPassword</code>
              </div>";

        echo "<h5 class='mb-3'>Utilisateurs mis à jour :</h5>";
        echo "<div class='mb-4'>";

        foreach ($users as $user) {
            $updateStmt->execute([$hashedPassword, $user['id']]);
            $updateCount++;

            $statusBadge = $user['actif'] == 1
                ? "<span class='badge bg-success'>Actif</span>"
                : "<span class='badge bg-secondary'>Inactif</span>";

            $typeBadge = "<span class='badge bg-primary'>" . htmlspecialchars($typeLabels[$user['typeUtilisateur_id']] ?? 'Type ' . $user['typeUtilisateur_id']) . "</span>";

            echo "<div class='user-row'>
                    <strong>" . htmlspecialchars($user['prenom'] . ' ' . $user['nom']) . "</strong>
                    <br>
                    <small class='text-muted'>" . htmlspecialchars($user['adresseMail']) . "</small>
                    <span class='ms-2'>$typeBadge $statusBadge</span>
                  </div>";
        }

        echo "</div>";

        echo "<div class='alert alert-success'>
                <strong>✓ Succès !</strong><br>
                $updateCount mot(s) de passe mis à jour avec succès.
              </div>";

        // Afficher un résumé
        echo "<div class='alert alert-info'>
                <strong>Résumé :</strong>
                <ul class='mb-0 mt-2'>
                    <li>Nombre d'utilisateurs : $updateCount</li>
                    <li>Nouveau mot de passe : <code>$newPassword</code></li>
                    <li>Hash bcrypt : <code style='font-size: 10px;'>" . substr($hashedPassword, 0, 30) . "...</code></li>
                </ul>
              </div>";
    }

} catch (PDOException $e) {
    echo "<div class='alert alert-danger'>
            <strong>Erreur !</strong><br>
            " . htmlspecialchars($e->getMessage()) . "
          </div>";
}

echo "
        <div class='text-center mt-4'>
            <a href='login_test.php' class='btn btn-primary me-2'>
                <i class='bi bi-box-arrow-in-right me-1'></i>
                Test de connexion
            </a>
            <a href='login.php' class='btn btn-outline-secondary'>
                <i class='bi bi-arrow-left me-1'></i>
                Connexion normale
            </a>
        </div>

        <div class='alert alert-warning mt-4 mb-0'>
            <strong>⚠️ ATTENTION :</strong> Ce script doit être utilisé uniquement en environnement de test/développement.
            En production, supprimez ce fichier immédiatement après utilisation.
        </div>
    </div>
</body>
</html>";
?>
