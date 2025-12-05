<?php
/**
 * Middleware d'authentification
 * À inclure en haut de chaque page protégée
 */

require_once __DIR__ . '/config/auth_config.php';
require_once __DIR__ . '/classes/AppAuth.php';
require_once __DIR__ . '/classes/Logger.php';

// Charger la configuration globale depuis menus.json
$menusConfig = json_decode(file_get_contents(__DIR__ . '/config/menus.json'), true);
$GLOBALS['filtreHabitants'] = $menusConfig['filtreHabitants'] ?? 1000;
$GLOBALS['environnement'] = $menusConfig['environnement'] ?? 'dev';

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

// Créer l'instance AppAuth
$auth = new AppAuth($pdo, AUTH_ENABLED);

// Créer l'instance Logger (disponible globalement - optionnel)
try {
    $GLOBALS['logger'] = new Logger($pdo);
} catch (Exception $e) {
    $GLOBALS['logger'] = null;
}

// Vérifier si la page actuelle est publique
$currentPage = basename($_SERVER['PHP_SELF']);
$publicPages = AUTH_PUBLIC_PAGES ?? [];

// Si l'auth est activée et la page n'est pas publique, vérifier la connexion
if (AUTH_ENABLED && !in_array($currentPage, $publicPages)) {
    if (!$auth->isLoggedIn()) {
        // Sauvegarder l'URL demandée pour redirection après connexion
        $_SESSION['redirect_after_login'] = $_SERVER['REQUEST_URI'];

        // Rediriger vers la page de connexion
        header('Location: ' . AUTH_LOGIN_PAGE);
        exit;
    }
}

// Nettoyer les sessions expirées (1% de chance à chaque requête)
if (rand(1, 100) === 1) {
    $auth->cleanExpiredSessions();
}
