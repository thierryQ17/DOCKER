<?php
/**
 * Configuration de l'authentification
 */

// Activer/désactiver l'authentification
define('AUTH_ENABLED', true); // Mettre à false pour désactiver l'authentification

// Durée de la session "Remember me" en secondes (7 jours par défaut)
define('AUTH_REMEMBER_DURATION', 7 * 24 * 60 * 60); // 604800 secondes = 7 jours

// Nom du cookie "Remember me"
define('AUTH_REMEMBER_COOKIE', 'annuaire_remember');

// Durée de la session normale (2 heures)
define('AUTH_SESSION_DURATION', 2 * 60 * 60);

// Nombre maximum de tentatives de connexion avant blocage
define('AUTH_MAX_ATTEMPTS', 5);

// Durée du blocage après trop de tentatives (15 minutes)
define('AUTH_LOCKOUT_DURATION', 15 * 60);

// Pages publiques (qui ne nécessitent pas d'authentification)
define('AUTH_PUBLIC_PAGES', [
    'login.php',
    'api.php' // L'API gérera l'auth en interne
]);

// Redirection après connexion réussie
define('AUTH_REDIRECT_AFTER_LOGIN', 'index.php');

// Page de connexion
define('AUTH_LOGIN_PAGE', 'login.php');
