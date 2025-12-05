<?php
/**
 * Classe d'authentification pour l'application Annuaire des Maires
 * Avec système d'activation/désactivation
 */

class AppAuth {
    private $pdo;
    private $enabled;

    public function __construct($pdo, $enabled = true) {
        $this->pdo = $pdo;
        $this->enabled = $enabled;

        // Démarrer la session si elle n'est pas déjà démarrée
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        // Si l'auth est activée, vérifier le remember me token
        if ($this->enabled) {
            $this->checkRememberMeToken();
        }
    }

    /**
     * Vérifier si l'authentification est activée
     */
    public function isEnabled() {
        return $this->enabled;
    }

    /**
     * Vérifier si l'utilisateur est connecté
     */
    public function isLoggedIn() {
        if (!$this->enabled) {
            return true; // Toujours connecté si auth désactivée
        }

        // Vérifier la session
        if (isset($_SESSION['user_id']) && isset($_SESSION['user_logged_in'])) {
            // Vérifier l'expiration de la session
            if (isset($_SESSION['last_activity'])) {
                $timeout = AUTH_SESSION_DURATION ?? 7200;
                if (time() - $_SESSION['last_activity'] > $timeout) {
                    $this->logout();
                    return false;
                }
            }
            $_SESSION['last_activity'] = time();
            return true;
        }

        return false;
    }

    /**
     * Connexion utilisateur
     */
    public function login($email, $password, $remember = false) {
        if (!$this->enabled) {
            return ['success' => true, 'message' => 'Auth désactivée'];
        }

        try {
            // Vérifier les tentatives de connexion
            if ($this->isLockedOut($email)) {
                return [
                    'success' => false,
                    'error' => 'Trop de tentatives. Veuillez réessayer dans 15 minutes.'
                ];
            }

            // Récupérer l'utilisateur
            $stmt = $this->pdo->prepare("
                SELECT id, nom, prenom, adresseMail, pseudo, mdp, typeUtilisateur_id, actif
                FROM utilisateurs
                WHERE adresseMail = ?
            ");
            $stmt->execute([$email]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$user) {
                $this->recordFailedAttempt($email);
                return ['success' => false, 'error' => 'Email ou mot de passe incorrect'];
            }

            // Vérifier le mot de passe
            if (!password_verify($password, $user['mdp'])) {
                $this->recordFailedAttempt($email);
                return ['success' => false, 'error' => 'Email ou mot de passe incorrect'];
            }

            // Vérifier si l'utilisateur est actif
            if ($user['actif'] != 1) {
                // Logger la tentative de connexion d'un compte inactif
                if (isset($GLOBALS['logger'])) {
                    $GLOBALS['logger']->log(
                        'LOGIN_INACTIVE',
                        'AUTH',
                        "Tentative de connexion sur un compte inactif",
                        [
                            'utilisateur_id' => $user['id'],
                            'utilisateur_nom' => $user['prenom'] . ' ' . $user['nom'],
                            'utilisateur_type' => $user['typeUtilisateur_id'],
                            'statut' => 'FAILED'
                        ]
                    );
                }
                return [
                    'success' => false,
                    'error' => 'Votre compte a été désactivé. Veuillez contacter l\'administrateur pour le réactiver.',
                    'inactive' => true
                ];
            }

            // Connexion réussie - créer la session
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['user_email'] = $user['adresseMail'];
            $_SESSION['user_nom'] = $user['nom'];
            $_SESSION['user_prenom'] = $user['prenom'];
            $_SESSION['user_pseudo'] = $user['pseudo'];
            $_SESSION['user_type'] = $user['typeUtilisateur_id'];
            $_SESSION['user_logged_in'] = true;
            $_SESSION['last_activity'] = time();

            // Réinitialiser les tentatives échouées
            $this->clearFailedAttempts($email);

            // Si remember me, créer un token persistant
            if ($remember) {
                $this->createRememberMeToken($user['id']);
            }

            // Mettre à jour la dernière connexion
            $stmt = $this->pdo->prepare("
                UPDATE utilisateurs
                SET derniere_connexion = NOW()
                WHERE id = ?
            ");
            $stmt->execute([$user['id']]);

            // Logger la connexion réussie
            if (isset($GLOBALS['logger'])) {
                $GLOBALS['logger']->logLogin(
                    $user['id'],
                    $user['prenom'] . ' ' . $user['nom'],
                    $user['typeUtilisateur_id']
                );
            }

            return [
                'success' => true,
                'user' => [
                    'id' => $user['id'],
                    'nom' => $user['nom'],
                    'prenom' => $user['prenom'],
                    'email' => $user['adresseMail'],
                    'type' => $user['typeUtilisateur_id']
                ]
            ];

        } catch (Exception $e) {
            return ['success' => false, 'error' => 'Erreur serveur: ' . $e->getMessage()];
        }
    }

    /**
     * Déconnexion
     */
    public function logout() {
        if (!$this->enabled) {
            return true;
        }

        // Logger la déconnexion AVANT de détruire la session
        if (isset($GLOBALS['logger'])) {
            $GLOBALS['logger']->logLogout();
        }

        // Supprimer le remember me token
        if (isset($_COOKIE[AUTH_REMEMBER_COOKIE])) {
            $token = $_COOKIE[AUTH_REMEMBER_COOKIE];
            $this->deleteRememberMeToken($token);
            setcookie(AUTH_REMEMBER_COOKIE, '', time() - 3600, '/', '', false, true);
        }

        // Détruire la session
        $_SESSION = [];
        session_destroy();

        return true;
    }

    /**
     * Obtenir l'utilisateur connecté
     */
    public function getUser() {
        if (!$this->isLoggedIn()) {
            return null;
        }

        return [
            'id' => $_SESSION['user_id'] ?? null,
            'nom' => $_SESSION['user_nom'] ?? '',
            'prenom' => $_SESSION['user_prenom'] ?? '',
            'email' => $_SESSION['user_email'] ?? '',
            'pseudo' => $_SESSION['user_pseudo'] ?? '',
            'type' => $_SESSION['user_type'] ?? 0
        ];
    }

    /**
     * Obtenir l'ID de l'utilisateur connecté
     */
    public function getUserId() {
        return $_SESSION['user_id'] ?? null;
    }

    /**
     * Vérifier si l'utilisateur a un rôle spécifique
     */
    public function hasRole($roleId) {
        if (!$this->isLoggedIn()) {
            return false;
        }

        $userType = $_SESSION['user_type'] ?? 0;
        return $userType == $roleId;
    }

    /**
     * Vérifier si l'utilisateur est admin ou super admin
     */
    public function isAdmin() {
        if (!$this->isLoggedIn()) {
            return false;
        }

        $userType = $_SESSION['user_type'] ?? 0;
        return in_array($userType, [1, 2]); // 1 = Super Admin, 2 = Admin
    }

    /**
     * Créer un token "Remember me"
     */
    private function createRememberMeToken($userId) {
        try {
            // Générer un token sécurisé
            $selector = bin2hex(random_bytes(12));
            $token = bin2hex(random_bytes(32));
            $hashedToken = hash('sha256', $token);

            $expires = time() + (AUTH_REMEMBER_DURATION ?? 604800);

            // Créer la table si elle n'existe pas
            $this->pdo->exec("
                CREATE TABLE IF NOT EXISTS user_sessions (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    user_id INT NOT NULL,
                    selector VARCHAR(24) UNIQUE NOT NULL,
                    token VARCHAR(255) NOT NULL,
                    expires INT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
                    INDEX idx_selector (selector),
                    INDEX idx_expires (expires)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ");

            // Insérer le token
            $stmt = $this->pdo->prepare("
                INSERT INTO user_sessions (user_id, selector, token, expires)
                VALUES (?, ?, ?, ?)
            ");
            $stmt->execute([$userId, $selector, $hashedToken, $expires]);

            // Créer le cookie
            $cookieValue = $selector . ':' . $token;
            setcookie(
                AUTH_REMEMBER_COOKIE,
                $cookieValue,
                $expires,
                '/',
                '',
                false, // HTTPS only en production
                true   // HttpOnly
            );

        } catch (Exception $e) {
            error_log("Erreur création token remember me: " . $e->getMessage());
        }
    }

    /**
     * Vérifier le token "Remember me"
     */
    private function checkRememberMeToken() {
        if ($this->isLoggedIn()) {
            return; // Déjà connecté via session
        }

        if (!isset($_COOKIE[AUTH_REMEMBER_COOKIE])) {
            return;
        }

        try {
            $cookieValue = $_COOKIE[AUTH_REMEMBER_COOKIE];
            list($selector, $token) = explode(':', $cookieValue);

            if (!$selector || !$token) {
                return;
            }

            $hashedToken = hash('sha256', $token);

            // Récupérer le token de la base
            $stmt = $this->pdo->prepare("
                SELECT s.user_id, s.expires, u.*
                FROM user_sessions s
                JOIN utilisateurs u ON s.user_id = u.id
                WHERE s.selector = ? AND s.token = ?
            ");
            $stmt->execute([$selector, $hashedToken]);
            $session = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$session) {
                // Token invalide, supprimer le cookie
                setcookie(AUTH_REMEMBER_COOKIE, '', time() - 3600, '/', '', false, true);
                return;
            }

            // Vérifier l'expiration
            if ($session['expires'] < time()) {
                $this->deleteRememberMeToken($selector);
                setcookie(AUTH_REMEMBER_COOKIE, '', time() - 3600, '/', '', false, true);
                return;
            }

            // Token valide, reconnecter l'utilisateur
            $_SESSION['user_id'] = $session['id'];
            $_SESSION['user_email'] = $session['adresseMail'];
            $_SESSION['user_nom'] = $session['nom'];
            $_SESSION['user_prenom'] = $session['prenom'];
            $_SESSION['user_pseudo'] = $session['pseudo'];
            $_SESSION['user_type'] = $session['typeUtilisateur_id'];
            $_SESSION['user_logged_in'] = true;
            $_SESSION['last_activity'] = time();

        } catch (Exception $e) {
            error_log("Erreur vérification token remember me: " . $e->getMessage());
        }
    }

    /**
     * Supprimer un token "Remember me"
     */
    private function deleteRememberMeToken($selectorOrToken) {
        try {
            if (strpos($selectorOrToken, ':') !== false) {
                list($selector, $token) = explode(':', $selectorOrToken);
            } else {
                $selector = $selectorOrToken;
            }

            $stmt = $this->pdo->prepare("DELETE FROM user_sessions WHERE selector = ?");
            $stmt->execute([$selector]);
        } catch (Exception $e) {
            error_log("Erreur suppression token: " . $e->getMessage());
        }
    }

    /**
     * Enregistrer une tentative de connexion échouée
     */
    private function recordFailedAttempt($email) {
        try {
            // Créer la table si elle n'existe pas
            $this->pdo->exec("
                CREATE TABLE IF NOT EXISTS login_attempts (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    email VARCHAR(255) NOT NULL,
                    attempt_time INT NOT NULL,
                    ip_address VARCHAR(45),
                    INDEX idx_email_time (email, attempt_time)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ");

            $stmt = $this->pdo->prepare("
                INSERT INTO login_attempts (email, attempt_time, ip_address)
                VALUES (?, ?, ?)
            ");
            $stmt->execute([$email, time(), $_SERVER['REMOTE_ADDR'] ?? '']);

            // Logger l'échec de connexion
            if (isset($GLOBALS['logger'])) {
                $GLOBALS['logger']->logLoginFailed($email);
            }
        } catch (Exception $e) {
            // Pas de log d'erreur ici pour éviter la récursion
        }
    }

    /**
     * Vérifier si le compte est bloqué
     */
    private function isLockedOut($email) {
        try {
            $lockoutTime = time() - (AUTH_LOCKOUT_DURATION ?? 900);

            $stmt = $this->pdo->prepare("
                SELECT COUNT(*) as attempts
                FROM login_attempts
                WHERE email = ? AND attempt_time > ?
            ");
            $stmt->execute([$email, $lockoutTime]);
            $result = $stmt->fetch(PDO::FETCH_ASSOC);

            $maxAttempts = AUTH_MAX_ATTEMPTS ?? 5;
            return ($result['attempts'] ?? 0) >= $maxAttempts;

        } catch (Exception $e) {
            return false; // En cas d'erreur, ne pas bloquer
        }
    }

    /**
     * Obtenir le nombre de tentatives restantes pour un email
     */
    public function getRemainingAttempts($email) {
        try {
            $lockoutTime = time() - (AUTH_LOCKOUT_DURATION ?? 900);

            $stmt = $this->pdo->prepare("
                SELECT COUNT(*) as attempts
                FROM login_attempts
                WHERE email = ? AND attempt_time > ?
            ");
            $stmt->execute([$email, $lockoutTime]);
            $result = $stmt->fetch(PDO::FETCH_ASSOC);

            $maxAttempts = AUTH_MAX_ATTEMPTS ?? 5;
            $currentAttempts = $result['attempts'] ?? 0;
            $remaining = max(0, $maxAttempts - $currentAttempts);

            return [
                'current' => $currentAttempts,
                'max' => $maxAttempts,
                'remaining' => $remaining
            ];

        } catch (Exception $e) {
            return [
                'current' => 0,
                'max' => 5,
                'remaining' => 5
            ];
        }
    }

    /**
     * Réinitialiser les tentatives échouées
     */
    private function clearFailedAttempts($email) {
        try {
            $stmt = $this->pdo->prepare("DELETE FROM login_attempts WHERE email = ?");
            $stmt->execute([$email]);
        } catch (Exception $e) {
            error_log("Erreur réinitialisation tentatives: " . $e->getMessage());
        }
    }

    /**
     * Nettoyer les sessions expirées (à appeler périodiquement)
     */
    public function cleanExpiredSessions() {
        try {
            $stmt = $this->pdo->prepare("DELETE FROM user_sessions WHERE expires < ?");
            $stmt->execute([time()]);

            $stmt = $this->pdo->prepare("DELETE FROM login_attempts WHERE attempt_time < ?");
            $stmt->execute([time() - 86400]); // Supprimer les tentatives de plus de 24h
        } catch (Exception $e) {
            error_log("Erreur nettoyage sessions: " . $e->getMessage());
        }
    }
}
