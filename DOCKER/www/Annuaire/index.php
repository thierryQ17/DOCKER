<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

// Récupérer l'utilisateur connecté
$currentUser = $auth->getUser();
$userType = $currentUser['type'] ?? 4;

// Charger la configuration des menus
$menuConfig = json_decode(file_get_contents(__DIR__ . '/config/menus.json'), true);

// Récupérer l'environnement
$environnement = $menuConfig['environnement'] ?? 'dev';
$isDev = ($environnement === 'dev');

// Récupérer les pages par défaut selon le type d'utilisateur (desktop et mobile)
$defaultPages = $menuConfig['defaultPage'][(string)$userType] ?? $menuConfig['defaultPage']['4'];

// Pour les membres (type 4), afficher avec en-tête mais sans menu hamburger
if ($userType == 4):
    $userTypeLabel = 'Membre';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annuaire des Maires de France</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            overflow: hidden;
        }

        .app-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        /* Barre de navigation */
        .top-navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            height: 50px;
            <?php if ($isDev): ?>
            background: linear-gradient(135deg, #9b8bb8 0%, #7c6a9a 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
            position: relative;
            z-index: 1000;
            overflow: visible !important;
        }

        <?php if ($isDev): ?>
        /* Filigrane DEV */
        .dev-watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 150px;
            font-weight: 900;
            color: rgba(155, 139, 184, 0.15);
            pointer-events: none;
            z-index: 998;
            letter-spacing: 20px;
            user-select: none;
        }
        <?php endif; ?>

        .nav-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
        }

        .nav-brand:hover {
            color: white;
        }

        .nav-brand img {
            height: 36px;
            width: auto;
            filter: brightness(1.2);
        }

        .nav-brand-text {
            display: flex;
            flex-direction: column;
            line-height: 1.1;
        }

        .nav-brand-title {
            font-size: 14px;
            font-weight: 700;
        }

        .nav-brand-subtitle {
            font-size: 10px;
            font-weight: 400;
            opacity: 0.7;
        }

        /* Zone droite : utilisateur */
        .nav-right {
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
        }

        .btn-logout {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            background: rgba(40, 167, 69, 0.9);
            border: none;
            border-radius: 20px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            font-size: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        }

        .btn-logout:hover {
            background: rgba(40, 167, 69, 1);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
            color: white;
        }

        .btn-logout i {
            font-size: 14px;
        }

        /* Popup utilisateur */
        .user-profile-popup {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 8px;
            width: 240px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2), 0 2px 10px rgba(0, 0, 0, 0.1);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: opacity 0.3s ease, visibility 0.3s ease, transform 0.3s ease;
            z-index: 99999;
            pointer-events: none;
        }

        .user-profile-popup.active {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
            pointer-events: auto;
        }

        .popup-header {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            border-radius: 12px 12px 0 0;
        }

        .popup-avatar {
            width: 36px;
            height: 36px;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            flex-shrink: 0;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .popup-user-info {
            flex: 1;
            min-width: 0;
        }

        .popup-user-name {
            font-weight: 600;
            font-size: 13px;
            line-height: 1.2;
        }

        .popup-user-email {
            font-size: 11px;
            opacity: 0.85;
        }

        .popup-body {
            padding: 8px 12px;
            background: #f8f9fa;
        }

        .popup-info-row {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 4px 0;
            color: #495057;
            font-size: 12px;
        }

        .popup-info-row i {
            color: #17a2b8;
            font-size: 14px;
            width: 18px;
            text-align: center;
        }

        .popup-footer {
            padding: 8px 12px;
            border-top: 1px solid #e9ecef;
            border-radius: 0 0 12px 12px;
            background: white;
        }

        .popup-logout-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            width: 100%;
            padding: 8px 12px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 12px;
            transition: all 0.2s ease;
        }

        .popup-logout-btn:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        /* Contenu principal */
        .main-content {
            flex: 1;
            overflow: hidden;
            position: relative;
        }

        .content-iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }

        @media (max-width: 480px) {
            .nav-brand-text {
                display: none;
            }
        }

        /* Bouton Carte de France dans la navbar */
        .btn-map {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 12px;
            background: rgba(255, 255, 255, 0.15);
            border: none;
            border-radius: 20px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-map:hover {
            background: rgba(255, 255, 255, 0.25);
            color: white;
        }

        .btn-map img {
            width: 18px;
            height: auto;
            border-radius: 2px;
        }

        /* Modale Fullscreen */
        .fullscreen-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: white;
            z-index: 100000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .fullscreen-modal.show {
            opacity: 1;
            visibility: visible;
        }

        .fullscreen-modal-header {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            <?php if ($isDev): ?>
            background: linear-gradient(135deg, #9b8bb8 0%, #7c6a9a 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            color: white;
            z-index: 100001;
        }

        .fullscreen-modal-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 16px;
        }

        .fullscreen-modal-title img {
            width: 24px;
            height: auto;
            border-radius: 2px;
        }

        .btn-close-fullscreen {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-close-fullscreen:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .fullscreen-modal-content {
            position: absolute;
            top: 50px;
            left: 0;
            right: 0;
            bottom: 0;
            overflow: hidden;
        }

        .fullscreen-modal-iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <?php if ($isDev): ?>
        <div class="dev-watermark">DEV</div>
        <?php endif; ?>

        <!-- Barre de navigation -->
        <nav class="top-navbar">
            <div class="nav-left">
                <a href="#" class="nav-brand" title="Accueil" onclick="loadPage('accueil.php'); return false;">
                    <img src="ressources/images/logoUPR.png" alt="Logo UPR">
                    <div class="nav-brand-text">
                        <span class="nav-brand-title">Annuaire Maires</span>
                        <span class="nav-brand-subtitle">Parrainage 2027</span>
                    </div>
                </a>
                <!-- Bouton Carte de France -->
                <button class="btn-map" onclick="openFullscreenMap()" title="Carte de FRANCE">
                    <img src="ressources/images/france-flag.png" alt="">
                    <span>Carte</span>
                </button>
            </div>

            <div class="nav-right">
                <a href="#" class="btn-logout" title="Déconnexion">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
                <!-- Popup info utilisateur -->
                <div class="user-profile-popup">
                    <div class="popup-header">
                        <div class="popup-avatar">
                            <?= strtoupper(substr($currentUser['prenom'] ?? '', 0, 1) . substr($currentUser['nom'] ?? '', 0, 1)) ?>
                        </div>
                        <div class="popup-user-info">
                            <div class="popup-user-name"><?= htmlspecialchars(($currentUser['prenom'] ?? '') . ' ' . ($currentUser['nom'] ?? '')) ?></div>
                            <div class="popup-user-email"><?= htmlspecialchars($currentUser['email'] ?? '') ?></div>
                        </div>
                    </div>
                    <div class="popup-body">
                        <div class="popup-info-row">
                            <i class="bi bi-shield-check"></i>
                            <span><?= $userTypeLabel ?></span>
                        </div>
                        <?php if (!empty($currentUser['telephone'])): ?>
                        <div class="popup-info-row">
                            <i class="bi bi-telephone"></i>
                            <span><?= htmlspecialchars($currentUser['telephone']) ?></span>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="popup-footer">
                        <a href="logout.php" class="popup-logout-btn">
                            <i class="bi bi-box-arrow-right"></i>
                            Se déconnecter
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Contenu principal -->
        <div class="main-content">
            <iframe id="contentFrame" class="content-iframe"></iframe>
        </div>
    </div>

    <!-- Modale Fullscreen Carte de FRANCE -->
    <div class="fullscreen-modal" id="fullscreenModal">
        <div class="fullscreen-modal-header">
            <div class="fullscreen-modal-title">
                <img src="ressources/images/france-flag.png" alt="">
                <span>Carte de FRANCE</span>
            </div>
            <button class="btn-close-fullscreen" id="btnCloseFullscreen" title="Fermer">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="fullscreen-modal-content">
            <iframe id="fullscreenIframe" class="fullscreen-modal-iframe"></iframe>
        </div>
    </div>

    <script>
        // Fonction pour charger une page dans l'iframe (utilisée par accueil.php)
        function loadPage(page) {
            document.getElementById('contentFrame').src = page;
        }

        // Ouvrir la modale fullscreen avec la carte
        function openFullscreenMap() {
            const modal = document.getElementById('fullscreenModal');
            const iframe = document.getElementById('fullscreenIframe');
            if (iframe) iframe.src = 'circonscriptions_modale.php';
            if (modal) modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        // Fermer la modale fullscreen
        function closeFullscreenMap() {
            const modal = document.getElementById('fullscreenModal');
            const iframe = document.getElementById('fullscreenIframe');
            if (modal) modal.classList.remove('show');
            document.body.style.overflow = '';
            setTimeout(() => {
                if (iframe) iframe.src = '';
            }, 300);
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Charger la page d'accueil par défaut
            document.getElementById('contentFrame').src = 'accueil.php';

            // Ajouter event listener pour fermer la modale
            const btnCloseFullscreen = document.getElementById('btnCloseFullscreen');
            if (btnCloseFullscreen) {
                btnCloseFullscreen.addEventListener('click', closeFullscreenMap);
            }

            // Fermer la modale avec Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    const modal = document.getElementById('fullscreenModal');
                    if (modal && modal.classList.contains('show')) {
                        closeFullscreenMap();
                    }
                }
            });

            // Gestion popup utilisateur
            // Survol = affiche popup, Clic = déconnexion
            const btnLogout = document.querySelector('.nav-right .btn-logout');
            const popup = document.querySelector('.user-profile-popup');
            const navRight = document.querySelector('.nav-right');
            let closeTimeout = null;

            if (btnLogout && popup && navRight) {
                // Clic = déconnexion directe
                btnLogout.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.location.href = 'logout.php';
                });

                // Survol = affiche la popup
                navRight.addEventListener('mouseenter', function() {
                    if (closeTimeout) {
                        clearTimeout(closeTimeout);
                        closeTimeout = null;
                    }
                    popup.classList.add('active');
                });

                // Quitter la zone = ferme après 1 seconde
                navRight.addEventListener('mouseleave', function() {
                    closeTimeout = setTimeout(function() {
                        popup.classList.remove('active');
                    }, 1000);
                });
            }
        });
    </script>
</body>
</html>
<?php
    exit; // Arrêter l'exécution pour les membres
endif;

// Pour les autres types d'utilisateurs (Admin, Référent, etc.) - afficher un menu hamburger

// Déterminer le libellé du type d'utilisateur
$userTypeLabels = [
    1 => 'Admin Général',
    2 => 'Admin',
    3 => 'Référent',
    4 => 'Membre'
];
$userTypeLabel = $userTypeLabels[$userType] ?? 'Utilisateur';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annuaire des Maires de France</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            overflow: hidden;
        }

        .app-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        /* Barre de navigation */
        .top-navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            height: 50px;
            <?php if ($isDev): ?>
            background: linear-gradient(135deg, #9b8bb8 0%, #7c6a9a 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
            position: relative;
            z-index: 1000;
            overflow: visible !important;
        }

        <?php if ($isDev): ?>
        /* Filigrane DEV */
        .dev-watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 150px;
            font-weight: 900;
            color: rgba(155, 139, 184, 0.15);
            pointer-events: none;
            z-index: 998;
            letter-spacing: 20px;
            user-select: none;
        }
        <?php endif; ?>

        /* Zone gauche : hamburger + logo */
        .nav-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Bouton hamburger */
        .btn-hamburger {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.15);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-hamburger:hover {
            background: rgba(255, 255, 255, 0.25);
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
        }

        .nav-brand:hover {
            color: white;
        }

        .nav-brand img {
            height: 36px;
            width: auto;
            filter: brightness(1.2);
        }

        .nav-brand-text {
            display: flex;
            flex-direction: column;
            line-height: 1.1;
        }

        .nav-brand-title {
            font-size: 14px;
            font-weight: 700;
        }

        .nav-brand-subtitle {
            font-size: 10px;
            font-weight: 400;
            opacity: 0.7;
        }

        /* Zone droite : utilisateur */
        .nav-right {
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
        }

        .btn-logout {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            background: rgba(40, 167, 69, 0.9);
            border: none;
            border-radius: 20px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            font-size: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        }

        .btn-logout:hover {
            background: rgba(40, 167, 69, 1);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
            color: white;
        }

        .btn-logout i {
            font-size: 14px;
        }

        /* Popup utilisateur */
        .user-profile-popup {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 8px;
            width: 240px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2), 0 2px 10px rgba(0, 0, 0, 0.1);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: opacity 0.3s ease, visibility 0.3s ease, transform 0.3s ease;
            z-index: 99999;
            pointer-events: none;
        }

        .user-profile-popup.active {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
            pointer-events: auto;
        }

        .popup-header {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            border-radius: 12px 12px 0 0;
        }

        .popup-avatar {
            width: 36px;
            height: 36px;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            flex-shrink: 0;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .popup-user-info {
            flex: 1;
            min-width: 0;
        }

        .popup-user-name {
            font-weight: 600;
            font-size: 13px;
            line-height: 1.2;
        }

        .popup-user-email {
            font-size: 11px;
            opacity: 0.85;
        }

        .popup-body {
            padding: 8px 12px;
            background: #f8f9fa;
        }

        .popup-info-row {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 4px 0;
            color: #495057;
            font-size: 12px;
        }

        .popup-info-row i {
            color: #17a2b8;
            font-size: 14px;
            width: 18px;
            text-align: center;
        }

        .popup-footer {
            padding: 8px 12px;
            border-top: 1px solid #e9ecef;
            border-radius: 0 0 12px 12px;
            background: white;
        }

        .popup-logout-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            width: 100%;
            padding: 8px 12px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 12px;
            transition: all 0.2s ease;
        }

        .popup-logout-btn:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        /* ============================================
           MENU LATÉRAL (OFFCANVAS)
           ============================================ */
        .sidebar-menu {
            position: fixed;
            top: 0;
            left: -300px;
            width: 280px;
            height: 100vh;
            background: white;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15);
            z-index: 10000;
            transition: left 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .sidebar-menu.show {
            left: 0;
        }

        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .sidebar-overlay.show {
            opacity: 1;
            visibility: visible;
        }

        /* Header du menu latéral */
        .sidebar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 20px;
            <?php if ($isDev): ?>
            background: linear-gradient(135deg, #9b8bb8 0%, #7c6a9a 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            color: white;
        }

        .sidebar-header-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar-avatar {
            width: 42px;
            height: 42px;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
        }

        .sidebar-user-info {
            display: flex;
            flex-direction: column;
        }

        .sidebar-user-name {
            font-weight: 600;
            font-size: 14px;
        }

        .sidebar-user-role {
            font-size: 11px;
            opacity: 0.85;
        }

        .btn-close-sidebar {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s ease;
        }

        .btn-close-sidebar:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        /* Corps du menu */
        .sidebar-body {
            flex: 1;
            overflow-y: auto;
            padding: 10px 0;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 20px;
            color: #2d3748;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
            background: transparent;
            width: 100%;
            text-align: left;
        }

        .menu-item:hover {
            background: #f8f9fa;
            color: #17a2b8;
        }

        .menu-item.active {
            <?php if ($isDev): ?>
            background: rgba(155, 139, 184, 0.1);
            color: #7c6a9a;
            border-left: 3px solid #9b8bb8;
            <?php else: ?>
            background: rgba(23, 162, 184, 0.1);
            color: #17a2b8;
            border-left: 3px solid #17a2b8;
            <?php endif; ?>
        }

        .menu-item i {
            font-size: 18px;
            width: 24px;
            text-align: center;
            <?php if ($isDev): ?>
            color: #9b8bb8;
            <?php else: ?>
            color: #17a2b8;
            <?php endif; ?>
        }

        .menu-item:hover i {
            <?php if ($isDev): ?>
            color: #7c6a9a;
            <?php else: ?>
            color: #138496;
            <?php endif; ?>
        }

        /* Séparateur */
        .menu-separator {
            height: 1px;
            background: #e9ecef;
            margin: 10px 20px;
        }

        /* Footer du menu */
        .sidebar-footer {
            padding: 15px 20px;
            border-top: 1px solid #e9ecef;
        }

        .btn-logout-sidebar {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 12px 16px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-logout-sidebar:hover {
            background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        /* Contenu principal */
        .main-content {
            flex: 1;
            overflow: hidden;
        }

        .content-iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .top-navbar {
                padding: 0 10px;
                height: 45px;
            }

            .nav-brand img {
                height: 28px;
            }

            .nav-brand-title {
                font-size: 12px;
            }

            .nav-brand-subtitle {
                font-size: 9px;
            }

            .btn-hamburger {
                width: 36px;
                height: 36px;
                font-size: 18px;
            }

            .btn-logout span {
                display: none;
            }

            .btn-logout {
                padding: 8px 10px;
                border-radius: 50%;
            }

            .sidebar-menu {
                width: 260px;
            }
        }

        /* ============================================
           MODALE FULLSCREEN CARTE DE FRANCE
           ============================================ */
        .fullscreen-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: white;
            z-index: 100000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .fullscreen-modal.show {
            opacity: 1;
            visibility: visible;
        }

        .fullscreen-modal-header {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            <?php if ($isDev): ?>
            background: linear-gradient(135deg, #9b8bb8 0%, #7c6a9a 100%);
            <?php else: ?>
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            <?php endif; ?>
            color: white;
            z-index: 100001;
        }

        .fullscreen-modal-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 16px;
        }

        .fullscreen-modal-title img {
            width: 24px;
            height: auto;
            border-radius: 2px;
        }

        .btn-close-fullscreen {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-close-fullscreen:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .fullscreen-modal-content {
            position: absolute;
            top: 50px;
            left: 0;
            right: 0;
            bottom: 0;
            overflow: hidden;
        }

        .fullscreen-modal-iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <?php if ($isDev): ?>
        <!-- Filigrane DEV -->
        <div class="dev-watermark">DEV</div>
        <?php endif; ?>

        <!-- Overlay pour fermer le menu -->
        <div class="sidebar-overlay" id="sidebarOverlay"></div>

        <!-- Menu latéral -->
        <div class="sidebar-menu" id="sidebarMenu">
            <div class="sidebar-header">
                <div class="sidebar-header-info">
                    <div class="sidebar-avatar">
                        <?= strtoupper(substr($currentUser['prenom'] ?? '', 0, 1) . substr($currentUser['nom'] ?? '', 0, 1)) ?>
                    </div>
                    <div class="sidebar-user-info">
                        <span class="sidebar-user-name"><?= htmlspecialchars(($currentUser['prenom'] ?? '') . ' ' . ($currentUser['nom'] ?? '')) ?></span>
                        <span class="sidebar-user-role"><?= htmlspecialchars($userTypeLabel) ?></span>
                    </div>
                </div>
                <button class="btn-close-sidebar" id="btnCloseSidebar" title="Fermer">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="sidebar-body">
                <!-- Maires - pour tous -->
                <button class="menu-item" data-page="maires_responsive.php" onclick="loadPageFromMenu('maires_responsive.php')">
                    <i class="bi bi-building"></i>
                    <span>Maires</span>
                </button>

                <!-- Gestion Utilisateurs - Admin Général, Admin, Référent -->
                <?php if ($userType <= 3): ?>
                <button class="menu-item" data-page="gestionUtilisateurs.php" onclick="loadPageFromMenu('gestionUtilisateurs.php')">
                    <i class="bi bi-people-fill"></i>
                    <span>Gestion Utilisateurs</span>
                </button>
                <?php endif; ?>

                <!-- Rapport Référents - Admin Général, Admin, Référent -->
                <?php if ($userType <= 3): ?>
                <button class="menu-item" data-page="rapport_referent.php" onclick="loadPageFromMenu('rapport_referent.php')">
                    <i class="bi bi-graph-up-arrow"></i>
                    <span>Rapport Référents</span>
                </button>
                <?php endif; ?>

                <!-- Parrainages - Accessible à tous -->
                <button class="menu-item" data-page="parrainages.php" onclick="loadPageFromMenu('parrainages.php')">
                    <i class="bi bi-search-heart"></i>
                    <span>Parrainages 2017-2022</span>
                </button>

                <!-- Carte de FRANCE - Accessible à tous (Modale Fullscreen) -->
                <button class="menu-item" data-page="circonscriptions.php" onclick="openFullscreenMap()">
                    <img src="ressources/images/france-flag.png" alt="" style="width: 18px; height: auto; border-radius: 2px;">
                    <span>Carte de FRANCE</span>
                </button>

                <!-- Rapport Admin - Admin Général, Admin -->
                <?php if ($userType <= 2): ?>
                <button class="menu-item" data-page="rapport_Admin.php" onclick="loadPageFromMenu('rapport_Admin.php')">
                    <i class="bi bi-bar-chart-line-fill"></i>
                    <span>Rapport Admin</span>
                </button>
                <?php endif; ?>

                <!-- Logs d'activité - Admin Général uniquement -->
                <?php if ($userType == 1): ?>
                <button class="menu-item" data-page="logs.php" onclick="loadPageFromMenu('logs.php')">
                    <i class="bi bi-journal-text"></i>
                    <span>Logs d'activité</span>
                </button>
                <?php endif; ?>

                <!-- Séparateur -->
                <div class="menu-separator"></div>

                <!-- Aide - pour tous -->
                <button class="menu-item" data-page="aide.php" onclick="loadPageFromMenu('aide.php')">
                    <i class="bi bi-question-circle"></i>
                    <span>Aide</span>
                </button>
            </div>

            <div class="sidebar-footer">
                <a href="logout.php" class="btn-logout-sidebar">
                    <i class="bi bi-box-arrow-right"></i>
                    Se déconnecter
                </a>
            </div>
        </div>

        <!-- Barre de navigation -->
        <nav class="top-navbar">
            <div class="nav-left">
                <a href="#" class="nav-brand" title="Accueil" onclick="loadPage('accueil.php'); return false;">
                    <img src="ressources/images/logoUPR.png" alt="Logo UPR">
                    <div class="nav-brand-text">
                        <span class="nav-brand-title">Annuaire des Maires</span>
                        <span class="nav-brand-subtitle">Parrainage 2027</span>
                    </div>
                </a>
                <button class="btn-hamburger" id="btnHamburger" title="Menu">
                    <i class="bi bi-list"></i>
                </button>
            </div>

            <div class="nav-right">
                <a href="#" class="btn-logout" title="Info utilisateur">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
                <!-- Popup info utilisateur -->
                <div class="user-profile-popup">
                    <div class="popup-header">
                        <div class="popup-avatar">
                            <?= strtoupper(substr($currentUser['prenom'] ?? '', 0, 1) . substr($currentUser['nom'] ?? '', 0, 1)) ?>
                        </div>
                        <div class="popup-user-info">
                            <div class="popup-user-name"><?= htmlspecialchars(($currentUser['prenom'] ?? '') . ' ' . ($currentUser['nom'] ?? '')) ?></div>
                            <div class="popup-user-email"><?= htmlspecialchars($currentUser['email'] ?? '') ?></div>
                        </div>
                    </div>
                    <div class="popup-body">
                        <div class="popup-info-row">
                            <i class="bi bi-shield-check"></i>
                            <span><?= $userTypeLabel ?></span>
                        </div>
                        <?php if (!empty($currentUser['telephone'])): ?>
                        <div class="popup-info-row">
                            <i class="bi bi-telephone"></i>
                            <span><?= htmlspecialchars($currentUser['telephone']) ?></span>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="popup-footer">
                        <a href="logout.php" class="popup-logout-btn">
                            <i class="bi bi-box-arrow-right"></i>
                            Se déconnecter
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Contenu principal -->
        <div class="main-content">
            <iframe id="contentFrame" class="content-iframe"></iframe>
        </div>

    </div>

    <!-- Modale Fullscreen Carte de FRANCE (en dehors de app-container) -->
    <div class="fullscreen-modal" id="fullscreenModal">
        <div class="fullscreen-modal-header">
            <div class="fullscreen-modal-title">
                <img src="ressources/images/france-flag.png" alt="">
                <span>Carte de FRANCE</span>
            </div>
            <button class="btn-close-fullscreen" id="btnCloseFullscreen" title="Fermer">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="fullscreen-modal-content">
            <iframe id="fullscreenIframe" class="fullscreen-modal-iframe"></iframe>
        </div>
    </div>

    <script>
        const defaultPageDesktop = '<?= htmlspecialchars($defaultPages['desktop']) ?>';
        const defaultPageMobile = '<?= htmlspecialchars($defaultPages['mobile']) ?>';

        // Éléments du menu
        const sidebarMenu = document.getElementById('sidebarMenu');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        const btnHamburger = document.getElementById('btnHamburger');
        const btnCloseSidebar = document.getElementById('btnCloseSidebar');

        // Ouvrir le menu
        function openSidebar() {
            sidebarMenu.classList.add('show');
            sidebarOverlay.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        // Fermer le menu
        function closeSidebar() {
            sidebarMenu.classList.remove('show');
            sidebarOverlay.classList.remove('show');
            document.body.style.overflow = '';
        }

        // Events
        btnHamburger.addEventListener('click', openSidebar);
        btnCloseSidebar.addEventListener('click', closeSidebar);
        sidebarOverlay.addEventListener('click', closeSidebar);

        // Charger une page (sans fermer le menu)
        function loadPage(page) {
            const contentFrame = document.getElementById('contentFrame');
            const menuItems = document.querySelectorAll('.menu-item');

            // Retirer la classe active de tous les items
            menuItems.forEach(item => item.classList.remove('active'));

            // Ajouter la classe active à l'item correspondant
            const targetItem = document.querySelector(`.menu-item[data-page="${page}"]`);
            if (targetItem) {
                targetItem.classList.add('active');
            }

            // Charger la page dans l'iframe
            contentFrame.src = page;
        }

        // Charger une page depuis le menu (ferme le menu)
        function loadPageFromMenu(page) {
            loadPage(page);
            closeSidebar();
        }

        // ============================================
        // GESTION MODALE FULLSCREEN CARTE DE FRANCE
        // ============================================

        // Ouvrir la modale fullscreen avec la carte
        function openFullscreenMap() {
            closeSidebar();
            const modal = document.getElementById('fullscreenModal');
            const iframe = document.getElementById('fullscreenIframe');
            if (iframe) iframe.src = 'circonscriptions_modale.php';
            if (modal) modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        // Fermer la modale fullscreen
        function closeFullscreenMap() {
            const modal = document.getElementById('fullscreenModal');
            const iframe = document.getElementById('fullscreenIframe');
            if (modal) modal.classList.remove('show');
            document.body.style.overflow = '';
            // Vider l'iframe pour libérer les ressources
            setTimeout(() => {
                if (iframe) iframe.src = '';
            }, 300);
        }

        // Charger la page d'accueil au démarrage
        document.addEventListener('DOMContentLoaded', function() {
            // Ajouter event listener pour fermer la modale
            const btnCloseFullscreen = document.getElementById('btnCloseFullscreen');
            if (btnCloseFullscreen) {
                btnCloseFullscreen.addEventListener('click', closeFullscreenMap);
            }

            loadPage('accueil.php');

            // Fermer le menu ou la modale fullscreen avec Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    if (fullscreenModal.classList.contains('show')) {
                        closeFullscreenMap();
                    } else {
                        closeSidebar();
                    }
                }
            });

            // Gestion popup utilisateur
            // Survol = affiche popup, Clic = déconnexion
            const btnLogout = document.querySelector('.nav-right .btn-logout');
            const popup = document.querySelector('.user-profile-popup');
            const navRight = document.querySelector('.nav-right');
            let closeTimeout = null;

            if (btnLogout && popup && navRight) {
                // Clic = déconnexion directe
                btnLogout.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.location.href = 'logout.php';
                });

                // Survol = affiche la popup
                navRight.addEventListener('mouseenter', function() {
                    if (closeTimeout) {
                        clearTimeout(closeTimeout);
                        closeTimeout = null;
                    }
                    popup.classList.add('active');
                });

                // Quitter la zone = ferme après 1 seconde
                navRight.addEventListener('mouseleave', function() {
                    closeTimeout = setTimeout(function() {
                        popup.classList.remove('active');
                    }, 1000);
                });
            }
        });
    </script>
</body>
</html>
