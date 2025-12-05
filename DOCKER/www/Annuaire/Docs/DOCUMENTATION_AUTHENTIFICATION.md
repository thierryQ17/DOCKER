# Documentation - Système d'Authentification PHP

## Vue d'ensemble

Ce système d'authentification personnalisé a été développé pour l'application **Annuaire des Maires de France**. Il offre une solution complète et sécurisée avec activation/désactivation configurable, idéale pour les environnements de développement et de production.

## Table des matières

1. [Architecture](#architecture)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Structure de la base de données](#structure-de-la-base-de-données)
5. [Utilisation](#utilisation)
6. [Fonctionnalités de sécurité](#fonctionnalités-de-sécurité)
7. [API de la classe AppAuth](#api-de-la-classe-appauth)
8. [Gestion des utilisateurs](#gestion-des-utilisateurs)
9. [Dépannage](#dépannage)

---

## Architecture

Le système est composé de plusieurs fichiers travaillant ensemble :

```
www/Annuaire/
├── config/
│   └── auth_config.php          # Configuration centralisée
├── classes/
│   └── AppAuth.php              # Classe d'authentification principale
├── auth_middleware.php          # Middleware de protection des pages
├── login.php                    # Page de connexion
├── logout.php                   # Page de déconnexion
└── sql/
    └── add_derniere_connexion.sql  # Migration SQL
```

### Flux d'authentification

```
┌─────────────────┐
│  Utilisateur    │
│  accède à une   │
│  page protégée  │
└────────┬────────┘
         │
         ▼
┌─────────────────────┐
│ auth_middleware.php │ ◄─── Inclus en haut de chaque page protégée
└────────┬────────────┘
         │
         ▼
   ┌─────────────┐
   │  Connecté ? │
   └──────┬──────┘
          │
    ┌─────┴─────┐
    │           │
   OUI         NON
    │           │
    ▼           ▼
┌────────┐  ┌──────────────┐
│ Accès  │  │ Redirection  │
│ accordé│  │ vers login   │
└────────┘  └──────────────┘
```

---

## Installation

### 1. Prérequis

- **PHP** ≥ 7.4 (recommandé PHP 8.0+)
- **MySQL** ≥ 5.7 ou MariaDB ≥ 10.2
- Extensions PHP requises :
  - `pdo`
  - `pdo_mysql`
  - `session`
  - `mbstring`

### 2. Structure des fichiers

Copiez tous les fichiers d'authentification dans votre application :

```bash
# Fichiers de configuration
cp config/auth_config.php /votre/projet/config/

# Classe d'authentification
cp classes/AppAuth.php /votre/projet/classes/

# Pages et middleware
cp auth_middleware.php login.php logout.php /votre/projet/
```

### 3. Installation de la base de données

#### Option A : Migration SQL automatique

Exécutez le script SQL fourni :

```bash
mysql -u root -p annuairesMairesDeFrance < sql/add_derniere_connexion.sql
```

#### Option B : Via Docker (notre cas)

```bash
docker exec mysql_db bash -c "mysql -uroot -proot annuairesMairesDeFrance < /path/to/add_derniere_connexion.sql"
```

#### Option C : Création manuelle

Les tables nécessaires sont créées automatiquement par la classe `AppAuth` :
- `user_sessions` - Pour les tokens "Remember me"
- `login_attempts` - Pour la protection anti-brute-force

Seule la colonne `derniere_connexion` doit être ajoutée manuellement :

```sql
-- Ajouter la colonne derniere_connexion
ALTER TABLE utilisateurs
ADD COLUMN derniere_connexion DATETIME NULL AFTER actif;

-- Créer un index pour les performances
CREATE INDEX idx_derniere_connexion ON utilisateurs(derniere_connexion);
```

---

## Configuration

### Fichier principal : `config/auth_config.php`

```php
<?php
/**
 * Configuration de l'authentification
 */

// ===== ACTIVATION/DÉSACTIVATION =====
define('AUTH_ENABLED', true); // true = Auth activée, false = désactivée

// ===== DURÉES =====
define('AUTH_SESSION_DURATION', 2 * 60 * 60);      // Session normale : 2 heures
define('AUTH_REMEMBER_DURATION', 7 * 24 * 60 * 60); // Remember me : 7 jours

// ===== COOKIES =====
define('AUTH_REMEMBER_COOKIE', 'annuaire_remember'); // Nom du cookie

// ===== SÉCURITÉ =====
define('AUTH_MAX_ATTEMPTS', 5);         // Nombre de tentatives max
define('AUTH_LOCKOUT_DURATION', 15 * 60); // Durée du blocage : 15 minutes

// ===== PAGES PUBLIQUES =====
define('AUTH_PUBLIC_PAGES', [
    'login.php',
    'api.php'  // L'API peut être publique ou protégée selon vos besoins
]);

// ===== REDIRECTIONS =====
define('AUTH_REDIRECT_AFTER_LOGIN', 'maires_responsive.php');
define('AUTH_LOGIN_PAGE', 'login.php');
```

### Paramètres détaillés

| Paramètre | Type | Description | Valeur par défaut |
|-----------|------|-------------|-------------------|
| `AUTH_ENABLED` | boolean | Active/désactive l'authentification | `true` |
| `AUTH_SESSION_DURATION` | int | Durée de session en secondes | `7200` (2h) |
| `AUTH_REMEMBER_DURATION` | int | Durée du cookie "Remember me" en secondes | `604800` (7j) |
| `AUTH_REMEMBER_COOKIE` | string | Nom du cookie persistant | `'annuaire_remember'` |
| `AUTH_MAX_ATTEMPTS` | int | Tentatives de connexion avant blocage | `5` |
| `AUTH_LOCKOUT_DURATION` | int | Durée du blocage en secondes | `900` (15min) |
| `AUTH_PUBLIC_PAGES` | array | Pages accessibles sans authentification | `['login.php', 'api.php']` |
| `AUTH_REDIRECT_AFTER_LOGIN` | string | Page de redirection après connexion | `'maires_responsive.php'` |
| `AUTH_LOGIN_PAGE` | string | Page de connexion | `'login.php'` |

---

## Structure de la base de données

### Table `utilisateurs` (existante, modifiée)

```sql
CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    pseudo VARCHAR(50) NOT NULL UNIQUE,
    adresseMail VARCHAR(255) NOT NULL UNIQUE,
    mdp VARCHAR(255) NOT NULL,                    -- Hash bcrypt
    typeUtilisateur_id INT DEFAULT 4,
    actif TINYINT(1) DEFAULT 1,
    derniere_connexion DATETIME NULL,             -- ⭐ Nouvelle colonne
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_derniere_connexion (derniere_connexion)
);
```

### Table `user_sessions` (créée automatiquement)

Stocke les tokens "Remember me" pour la connexion persistante.

```sql
CREATE TABLE user_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    selector VARCHAR(24) UNIQUE NOT NULL,         -- Identifiant public du token
    token VARCHAR(255) NOT NULL,                  -- Hash SHA256 du token
    expires INT NOT NULL,                         -- Timestamp d'expiration
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    INDEX idx_selector (selector),
    INDEX idx_expires (expires)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Format du cookie** : `selector:token`
- Le `selector` est l'identifiant public (24 caractères hex)
- Le `token` est la clé secrète (64 caractères hex)
- Seul le hash SHA256 du token est stocké en base

### Table `login_attempts` (créée automatiquement)

Enregistre les tentatives de connexion échouées pour la protection anti-brute-force.

```sql
CREATE TABLE login_attempts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    attempt_time INT NOT NULL,                    -- Timestamp UNIX
    ip_address VARCHAR(45),                       -- IPv4 ou IPv6
    INDEX idx_email_time (email, attempt_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Schéma relationnel

```
┌─────────────────┐
│  utilisateurs   │
│  id (PK)        │
│  adresseMail    │
│  mdp            │
│  actif          │
│  derniere_...   │
└────────┬────────┘
         │ 1
         │
         │ N
    ┌────┴─────────────┐
    │                  │
┌───▼──────────┐  ┌───▼──────────────┐
│user_sessions │  │ login_attempts   │
│id (PK)       │  │ id (PK)          │
│user_id (FK)  │  │ email            │
│selector      │  │ attempt_time     │
│token (hash)  │  │ ip_address       │
│expires       │  └──────────────────┘
└──────────────┘
```

---

## Utilisation

### 1. Protéger une page

Pour protéger une page de votre application, ajoutez simplement le middleware en haut du fichier PHP :

```php
<?php
// En tout premier dans votre fichier
require_once __DIR__ . '/auth_middleware.php';

// Le reste de votre code
// La variable $auth est maintenant disponible
// L'utilisateur est automatiquement redirigé vers login si non connecté
?>
```

**Exemple complet** :

```php
<?php
// maires_responsive.php
require_once __DIR__ . '/auth_middleware.php';

// L'utilisateur est maintenant garanti d'être connecté
$currentUser = $auth->getUser();
?>
<!DOCTYPE html>
<html>
<head>
    <title>Page protégée</title>
</head>
<body>
    <h1>Bienvenue <?= htmlspecialchars($currentUser['prenom']) ?></h1>
    <a href="logout.php">Déconnexion</a>
</body>
</html>
```

### 2. Page de connexion

La page `login.php` est déjà fournie avec un design moderne. Voici le formulaire minimal si vous souhaitez personnaliser :

```php
<form method="POST" action="login.php">
    <input type="email" name="email" required placeholder="Email">
    <input type="password" name="password" required placeholder="Mot de passe">
    <label>
        <input type="checkbox" name="remember">
        Se souvenir de moi (7 jours)
    </label>
    <button type="submit">Connexion</button>
</form>
```

### 3. Afficher les informations utilisateur

```php
<?php
require_once __DIR__ . '/auth_middleware.php';

// Récupérer l'utilisateur connecté
$user = $auth->getUser();

echo "Bonjour " . htmlspecialchars($user['prenom']) . " " . htmlspecialchars($user['nom']);
echo "<br>Email : " . htmlspecialchars($user['email']);
echo "<br>Type : " . $user['type']; // 1=Super Admin, 2=Admin, 3=Référent, 4=Membre
?>
```

### 4. Vérifier les rôles

```php
<?php
require_once __DIR__ . '/auth_middleware.php';

// Vérifier si l'utilisateur est admin
if ($auth->isAdmin()) {
    echo "Accès admin autorisé";
} else {
    die("Accès réservé aux administrateurs");
}

// Vérifier un rôle spécifique
if ($auth->hasRole(1)) {
    echo "Vous êtes Super Admin";
}
?>
```

**Rôles disponibles** :
- `1` = Super Admin
- `2` = Admin
- `3` = Référent
- `4` = Membre

### 5. Déconnexion

Créez un simple lien vers `logout.php` :

```html
<a href="logout.php">Déconnexion</a>
```

Ou un bouton :

```html
<form method="post" action="logout.php">
    <button type="submit">Se déconnecter</button>
</form>
```

---

## Fonctionnalités de sécurité

### 1. Hashing des mots de passe

Le système utilise **bcrypt** via `password_hash()` de PHP :

```php
// Création d'un utilisateur
$hashedPassword = password_hash('motdepasse123', PASSWORD_DEFAULT);

// Vérification
if (password_verify($passwordInput, $user['mdp'])) {
    // Mot de passe correct
}
```

**Caractéristiques** :
- Algorithme : bcrypt (blowfish)
- Format : `$2y$10$...` (60 caractères)
- Coût : 10 (par défaut PHP)
- Salage automatique et unique par mot de passe

### 2. Protection anti-brute-force

Le système limite les tentatives de connexion :

```php
// Après 5 tentatives échouées
if ($failedAttempts >= 5) {
    // Blocage pendant 15 minutes
    return ['error' => 'Trop de tentatives. Réessayez dans 15 minutes.'];
}
```

**Fonctionnement** :
1. Chaque échec de connexion est enregistré avec timestamp
2. Comptage des tentatives sur les 15 dernières minutes
3. Si ≥ 5 tentatives : compte bloqué temporairement
4. Réinitialisation automatique après 15 minutes
5. Nettoyage automatique des anciennes entrées (>24h)

### 3. Tokens "Remember me" sécurisés

Le système utilise la méthode **selector:token** recommandée :

```php
// Génération
$selector = bin2hex(random_bytes(12));  // 24 caractères hex
$token = bin2hex(random_bytes(32));     // 64 caractères hex
$hashedToken = hash('sha256', $token);  // Stocké en base

// Cookie
setcookie('annuaire_remember', $selector . ':' . $token, ...);
```

**Sécurité** :
- Le token original n'est jamais stocké en base (seulement son hash SHA256)
- Si la base est compromise, les tokens ne peuvent pas être réutilisés
- Expiration automatique après 7 jours
- HttpOnly activé sur le cookie
- Suppression automatique des tokens expirés

### 4. Protection CSRF

Pour les formulaires sensibles, ajoutez une protection CSRF :

```php
<?php
// Générer un token
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
?>

<form method="POST">
    <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
    <!-- Vos champs -->
</form>

<?php
// Vérifier le token
if ($_POST['csrf_token'] !== $_SESSION['csrf_token']) {
    die('Token CSRF invalide');
}
?>
```

### 5. Session timeout

Les sessions expirent automatiquement après 2 heures d'inactivité :

```php
// Vérification automatique dans isLoggedIn()
if (isset($_SESSION['last_activity'])) {
    if (time() - $_SESSION['last_activity'] > AUTH_SESSION_DURATION) {
        $this->logout(); // Déconnexion automatique
        return false;
    }
}
$_SESSION['last_activity'] = time(); // Mise à jour du timestamp
```

---

## API de la classe AppAuth

### Constructeur

```php
__construct(PDO $pdo, bool $enabled = true)
```

**Paramètres** :
- `$pdo` : Instance PDO de connexion à la base de données
- `$enabled` : Active/désactive l'authentification (défaut: `true`)

**Exemple** :
```php
$auth = new AppAuth($pdo, AUTH_ENABLED);
```

---

### Méthodes publiques

#### `isEnabled(): bool`

Vérifie si l'authentification est activée.

```php
if ($auth->isEnabled()) {
    echo "Authentification active";
}
```

---

#### `isLoggedIn(): bool`

Vérifie si l'utilisateur est connecté.

```php
if ($auth->isLoggedIn()) {
    echo "Utilisateur connecté";
} else {
    header('Location: login.php');
    exit;
}
```

**Retour** :
- `true` : Utilisateur connecté (ou auth désactivée)
- `false` : Utilisateur non connecté

**Note** : Si `AUTH_ENABLED = false`, retourne toujours `true`.

---

#### `login(string $email, string $password, bool $remember = false): array`

Authentifie un utilisateur.

```php
$result = $auth->login('jean.dupont@email.fr', 'motdepasse123', true);

if ($result['success']) {
    header('Location: dashboard.php');
} else {
    echo "Erreur : " . $result['error'];
}
```

**Paramètres** :
- `$email` : Email de l'utilisateur
- `$password` : Mot de passe en clair
- `$remember` : Activer la connexion persistante (7 jours)

**Retour** :
```php
// Succès
[
    'success' => true,
    'user' => [
        'id' => 1,
        'nom' => 'Dupont',
        'prenom' => 'Jean',
        'email' => 'jean.dupont@email.fr',
        'type' => 4
    ]
]

// Échec
[
    'success' => false,
    'error' => 'Email ou mot de passe incorrect'
]

// Compte bloqué
[
    'success' => false,
    'error' => 'Trop de tentatives. Veuillez réessayer dans 15 minutes.'
]

// Compte désactivé
[
    'success' => false,
    'error' => 'Compte désactivé. Contactez l\'administrateur.'
]
```

---

#### `logout(): bool`

Déconnecte l'utilisateur.

```php
$auth->logout();
header('Location: login.php');
exit;
```

**Actions effectuées** :
1. Suppression du cookie "Remember me"
2. Suppression du token en base de données
3. Destruction de la session PHP
4. Retourne `true`

---

#### `getUser(): ?array`

Récupère les informations de l'utilisateur connecté.

```php
$user = $auth->getUser();

if ($user) {
    echo "Bienvenue " . $user['prenom'] . " " . $user['nom'];
    echo "<br>Email : " . $user['email'];
    echo "<br>Type : " . $user['type'];
}
```

**Retour** :
```php
[
    'id' => 1,
    'nom' => 'Dupont',
    'prenom' => 'Jean',
    'email' => 'jean.dupont@email.fr',
    'pseudo' => 'jdupont',
    'type' => 4
]
```

Retourne `null` si l'utilisateur n'est pas connecté.

---

#### `getUserId(): ?int`

Récupère l'ID de l'utilisateur connecté.

```php
$userId = $auth->getUserId();
// Exemple : 1
```

Retourne `null` si non connecté.

---

#### `hasRole(int $roleId): bool`

Vérifie si l'utilisateur a un rôle spécifique.

```php
if ($auth->hasRole(1)) {
    echo "Vous êtes Super Admin";
}

if ($auth->hasRole(3)) {
    echo "Vous êtes Référent";
}
```

**Rôles** :
- `1` = Super Admin
- `2` = Admin
- `3` = Référent
- `4` = Membre

---

#### `isAdmin(): bool`

Vérifie si l'utilisateur est admin ou super admin.

```php
if ($auth->isAdmin()) {
    // Afficher le panneau d'administration
    include 'admin_panel.php';
} else {
    die('Accès refusé');
}
```

**Retour** : `true` si type = 1 (Super Admin) ou 2 (Admin)

---

#### `cleanExpiredSessions(): void`

Nettoie les sessions expirées et les anciennes tentatives de connexion.

```php
$auth->cleanExpiredSessions();
```

**Actions** :
- Supprime les tokens "Remember me" expirés
- Supprime les tentatives de connexion de plus de 24h

**Note** : Cette méthode est appelée automatiquement avec 1% de probabilité à chaque requête via le middleware.

---

## Gestion des utilisateurs

### Créer un utilisateur

#### Via SQL direct

```sql
-- Générer un hash bcrypt pour le mot de passe
-- Utiliser PHP : password_hash('motdepasse', PASSWORD_DEFAULT)

INSERT INTO utilisateurs (nom, prenom, pseudo, adresseMail, mdp, typeUtilisateur_id, actif)
VALUES (
    'Dupont',
    'Jean',
    'jdupont',
    'jean.dupont@email.fr',
    '$2y$10$f7jbJDAKkeTMX5iWxTxayOhzODJVc1Zps8XFlfhJU5aM1p5vyAlGq',
    4,  -- Membre
    1   -- Actif
);
```

#### Via script PHP

```php
<?php
// create_user.php
require_once 'config/database.php';

$nom = 'Dupont';
$prenom = 'Jean';
$pseudo = 'jdupont';
$email = 'jean.dupont@email.fr';
$password = 'motdepasse123';
$type = 4; // Membre
$actif = 1;

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$stmt = $pdo->prepare("
    INSERT INTO utilisateurs (nom, prenom, pseudo, adresseMail, mdp, typeUtilisateur_id, actif)
    VALUES (?, ?, ?, ?, ?, ?, ?)
");

$stmt->execute([$nom, $prenom, $pseudo, $email, $hashedPassword, $type, $actif]);

echo "Utilisateur créé avec succès !";
echo "\nEmail : $email";
echo "\nMot de passe : $password";
?>
```

#### Via l'interface web

L'application dispose d'une page `gestionUtilisateurs.php` pour créer/éditer les utilisateurs via une interface graphique.

### Réinitialiser un mot de passe

```php
<?php
// reset_password.php
require_once 'config/database.php';

$userId = 1; // ID de l'utilisateur
$newPassword = 'nouveaumotdepasse';
$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

$stmt = $pdo->prepare("UPDATE utilisateurs SET mdp = ? WHERE id = ?");
$stmt->execute([$hashedPassword, $userId]);

echo "Mot de passe réinitialisé pour l'utilisateur ID $userId";
?>
```

### Activer/Désactiver un compte

```sql
-- Désactiver
UPDATE utilisateurs SET actif = 0 WHERE id = 1;

-- Activer
UPDATE utilisateurs SET actif = 1 WHERE id = 1;
```

Un compte désactivé (`actif = 0`) ne peut pas se connecter, même avec le bon mot de passe.

---

## Dépannage

### Problème : "Session déjà démarrée"

**Erreur** : `Warning: session_start(): A session had already been started`

**Solution** : Le middleware démarre automatiquement la session. Ne pas appeler `session_start()` dans vos pages.

```php
// ❌ Éviter
session_start();
require_once 'auth_middleware.php';

// ✅ Correct
require_once 'auth_middleware.php';
```

---

### Problème : Redirection infinie

**Symptôme** : La page se recharge indéfiniment.

**Causes possibles** :
1. La page de login elle-même n'est pas dans `AUTH_PUBLIC_PAGES`
2. Problème de permissions sur les sessions PHP

**Solution** :
```php
// Dans auth_config.php
define('AUTH_PUBLIC_PAGES', [
    'login.php',  // ⭐ Important !
    'api.php'
]);
```

Vérifier les permissions du dossier de sessions :
```bash
# Linux/Mac
ls -la /tmp/
sudo chmod 1777 /tmp/

# Ou configurer un dossier custom
# Dans php.ini ou .htaccess
session.save_path = "/path/to/sessions"
```

---

### Problème : "Trop de tentatives" même après 15 minutes

**Cause** : Les anciennes tentatives ne sont pas nettoyées.

**Solution** : Nettoyer manuellement la table :

```sql
-- Supprimer toutes les tentatives
DELETE FROM login_attempts;

-- Ou supprimer pour un email spécifique
DELETE FROM login_attempts WHERE email = 'test@example.com';
```

Ou via PHP :
```php
$auth->cleanExpiredSessions();
```

---

### Problème : Cookie "Remember me" ne fonctionne pas

**Causes possibles** :
1. Cookie HttpOnly bloqué par le navigateur
2. Domaine/chemin incorrect
3. Token expiré

**Diagnostic** :
```php
// Vérifier les cookies
var_dump($_COOKIE);

// Vérifier les tokens en base
SELECT * FROM user_sessions WHERE user_id = 1;
```

**Solution** :
```php
// Dans AppAuth.php, ligne ~250
setcookie(
    AUTH_REMEMBER_COOKIE,
    $cookieValue,
    $expires,
    '/',           // Chemin
    '',            // Domaine (vide = domaine actuel)
    false,         // HTTPS only (mettre true en production)
    true           // HttpOnly
);
```

---

### Problème : Mot de passe non reconnu

**Cause** : Le mot de passe n'est pas au format bcrypt.

**Vérification** :
```sql
SELECT id, pseudo, LEFT(mdp, 4) as hash_type, LENGTH(mdp) as hash_length
FROM utilisateurs
WHERE id = 1;
```

Résultat attendu :
- `hash_type` = `$2y$` (bcrypt)
- `hash_length` = 60

Si différent, réinitialiser le mot de passe :
```php
$hashedPassword = password_hash('motdepasse', PASSWORD_DEFAULT);
$pdo->prepare("UPDATE utilisateurs SET mdp = ? WHERE id = ?")->execute([$hashedPassword, 1]);
```

---

### Problème : AUTH_ENABLED ne fonctionne pas

**Vérification** :
```php
// En haut de votre page
require_once 'auth_middleware.php';
var_dump(AUTH_ENABLED);  // Doit afficher : bool(true) ou bool(false)
var_dump($auth->isEnabled());  // Même résultat
```

**Solution** : Vider le cache d'opcache PHP :
```php
opcache_reset();
```

Ou redémarrer PHP-FPM :
```bash
docker restart php_fpm
```

---

### Problème : Erreur "Table user_sessions doesn't exist"

**Cause** : Les tables auto-créées n'ont pas pu être générées.

**Solution** : Créer manuellement les tables :

```sql
-- Table user_sessions
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table login_attempts
CREATE TABLE IF NOT EXISTS login_attempts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    attempt_time INT NOT NULL,
    ip_address VARCHAR(45),
    INDEX idx_email_time (email, attempt_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## Cas d'usage avancés

### Désactiver l'authentification en développement

```php
// config/auth_config.php
define('AUTH_ENABLED', $_SERVER['HTTP_HOST'] !== 'localhost');
// Auth désactivée sur localhost, activée en production
```

### Forcer la déconnexion de tous les utilisateurs

```sql
-- Supprimer toutes les sessions
TRUNCATE TABLE user_sessions;
```

### Auditer les connexions

```sql
-- Afficher les dernières connexions
SELECT id, nom, prenom, adresseMail, derniere_connexion
FROM utilisateurs
WHERE derniere_connexion IS NOT NULL
ORDER BY derniere_connexion DESC
LIMIT 20;

-- Utilisateurs inactifs depuis 30 jours
SELECT id, nom, prenom, adresseMail, derniere_connexion
FROM utilisateurs
WHERE derniere_connexion < DATE_SUB(NOW(), INTERVAL 30 DAY)
   OR derniere_connexion IS NULL;
```

### Implémenter "Se souvenir de moi sur cet appareil uniquement"

Modifier le cookie pour être lié à un fingerprint :

```php
// Générer un fingerprint
$fingerprint = hash('sha256', $_SERVER['HTTP_USER_AGENT'] . $_SERVER['REMOTE_ADDR']);
$_SESSION['fingerprint'] = $fingerprint;

// Vérifier à chaque requête
if ($_SESSION['fingerprint'] !== $fingerprint) {
    $auth->logout();
}
```

---

## Conclusion

Ce système d'authentification offre :

- ✅ Sécurité renforcée (bcrypt, anti-brute-force, tokens sécurisés)
- ✅ Activation/désactivation facile pour le développement
- ✅ Connexion persistante "Remember me"
- ✅ Gestion des rôles utilisateurs
- ✅ Traçabilité (dernière connexion, tentatives échouées)
- ✅ Auto-création des tables nécessaires
- ✅ Interface utilisateur moderne et responsive

Pour toute question ou problème, consultez les logs d'erreur PHP :

```bash
# Dans Docker
docker logs php_fpm

# Ou dans les logs PHP
tail -f /var/log/php-fpm/error.log
```

---

**Version** : 1.0
**Date** : 26 novembre 2025
**Auteur** : Système d'authentification personnalisé pour Annuaire des Maires de France
