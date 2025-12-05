<?php
/**
 * Page de déconnexion
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

// Créer l'instance Logger (optionnel - doit être avant AppAuth pour le log de déconnexion)
try {
    $GLOBALS['logger'] = new Logger($pdo);
} catch (Exception $e) {
    $GLOBALS['logger'] = null;
}

// Créer l'instance AppAuth
$auth = new AppAuth($pdo, AUTH_ENABLED);

// Déconnexion (le logout() log automatiquement la déconnexion)
$auth->logout();

// Rediriger vers la page de connexion
header('Location: login.php');
exit;
