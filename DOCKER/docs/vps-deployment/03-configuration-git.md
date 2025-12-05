# 03 - Configuration de Git

## 🎯 Objectifs
- Installer Git sur le VPS
- Configurer Git globalement
- Générer des clés SSH pour GitHub/GitLab
- Tester la connexion aux dépôts distants

## 📋 Prérequis
- Accès SSH au VPS
- Docker installé (étape 02 complétée)

## 1. Installation de Git

```bash
# Installer Git
sudo apt update
sudo apt install -y git

# Vérifier l'installation
git --version
# Devrait afficher : git version 2.x.x
```

## 2. Configuration globale de Git

### Définir votre identité

```bash
# Configurer le nom
git config --global user.name "Votre Nom"

# Configurer l'email
git config --global user.email "votre@email.com"

# Vérifier la configuration
git config --global --list
```

### Configurer l'éditeur par défaut

```bash
# Utiliser nano (plus simple)
git config --global core.editor "nano"

# OU vim si vous préférez
git config --global core.editor "vim"
```

### Autres configurations utiles

```bash
# Couleurs dans le terminal
git config --global color.ui auto

# Alias pratiques
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Gestion des fins de ligne
git config --global core.autocrlf input

# Cache des credentials (optionnel, 1 heure)
git config --global credential.helper 'cache --timeout=3600'
```

## 3. Génération des clés SSH

### Pourquoi des clés SSH ?
- **Sécurité** : Pas de mot de passe à saisir ou stocker
- **Automatisation** : Déploiements automatiques possibles
- **Authentification forte** : Clés cryptographiques

### Générer une paire de clés Ed25519

```bash
# Générer la clé (Ed25519 est plus sécurisée et performante que RSA)
ssh-keygen -t ed25519 -C "votre@email.com"

# Interaction :
# - Emplacement : [Entrée] pour accepter ~/.ssh/id_ed25519
# - Passphrase : RECOMMANDÉ d'en mettre une
```

### Alternative : Clé RSA (si Ed25519 non supporté)

```bash
# Générer une clé RSA 4096 bits
ssh-keygen -t rsa -b 4096 -C "votre@email.com"
```

### Vérifier les clés générées

```bash
# Lister les clés
ls -la ~/.ssh/

# Devrait afficher :
# id_ed25519      (clé privée - NE JAMAIS PARTAGER)
# id_ed25519.pub  (clé publique - à copier vers GitHub/GitLab)
```

### Afficher la clé publique

```bash
# Afficher le contenu de la clé publique
cat ~/.ssh/id_ed25519.pub

# OU copier dans le presse-papier (si xclip installé)
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

## 4. Ajouter la clé SSH à GitHub

### Méthode 1 : Via l'interface web GitHub

1. Copier le contenu de `~/.ssh/id_ed25519.pub`
2. Aller sur https://github.com/settings/keys
3. Cliquer sur "New SSH key"
4. Titre : "VPS OVH - Debian"
5. Coller la clé publique
6. Cliquer sur "Add SSH key"

### Méthode 2 : Via GitHub CLI (gh)

```bash
# Installer GitHub CLI
sudo apt install -y gh

# S'authentifier
gh auth login

# Suivre les instructions interactives
# - What account: GitHub.com
# - Preferred protocol: SSH
# - Upload SSH key: Yes
# - Title: VPS OVH

# Ajouter la clé
gh ssh-key add ~/.ssh/id_ed25519.pub --title "VPS OVH"
```

## 5. Ajouter la clé SSH à GitLab (si utilisé)

### Via l'interface web GitLab

1. Copier le contenu de `~/.ssh/id_ed25519.pub`
2. Aller sur https://gitlab.com/-/profile/keys
3. Coller la clé publique
4. Titre : "VPS OVH - Debian"
5. Date d'expiration : (optionnel)
6. Cliquer sur "Add key"

## 6. Tester la connexion SSH

### Test avec GitHub

```bash
# Tester la connexion
ssh -T git@github.com

# Devrait afficher :
# Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Test avec GitLab

```bash
# Tester la connexion
ssh -T git@gitlab.com

# Devrait afficher :
# Welcome to GitLab, @username!
```

### En cas d'erreur "Permission denied"

```bash
# Vérifier les permissions des clés
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Vérifier l'agent SSH
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Retester
ssh -T git@github.com
```

## 7. Configuration du fichier SSH config

### Créer le fichier de configuration SSH

```bash
# Créer ou éditer le fichier config
nano ~/.ssh/config
```

**Contenu recommandé :**

```
# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes

# GitLab
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes

# Serveur Git personnel (si vous en avez un)
Host git.monserveur.com
    HostName git.monserveur.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    Port 22
```

```bash
# Définir les permissions
chmod 600 ~/.ssh/config
```

## 8. Configurer l'agent SSH pour persister

### Ajouter au fichier .bashrc

```bash
# Éditer .bashrc
nano ~/.bashrc
```

**Ajouter à la fin du fichier :**

```bash
# Démarrer l'agent SSH
if [ -z "$SSH_AUTH_SOCK" ]; then
   eval `ssh-agent -s` > /dev/null 2>&1
   ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
fi
```

```bash
# Recharger .bashrc
source ~/.bashrc
```

## 9. Cloner un dépôt de test

### Tester le clonage

```bash
# Créer un dossier pour les projets
mkdir -p ~/projects
cd ~/projects

# Cloner un dépôt de test (remplacer par votre dépôt)
git clone git@github.com:votre-username/votre-repo.git

# Vérifier
cd votre-repo
git remote -v
git status
```

## 10. Configuration avancée

### Signer les commits avec GPG (optionnel mais recommandé)

```bash
# Installer GPG
sudo apt install -y gnupg

# Générer une clé GPG
gpg --full-generate-key

# Sélectionner :
# - Type : RSA and RSA
# - Taille : 4096
# - Validité : 0 (pas d'expiration)
# - Nom et email

# Lister les clés
gpg --list-secret-keys --keyid-format LONG

# Exporter la clé publique
gpg --armor --export VOTRE_KEY_ID

# Ajouter à GitHub dans Settings > SSH and GPG keys

# Configurer Git pour signer
git config --global user.signingkey VOTRE_KEY_ID
git config --global commit.gpgsign true
```

### Utiliser un .gitignore global

```bash
# Créer un .gitignore global
nano ~/.gitignore_global
```

**Contenu :**

```
# OS files
.DS_Store
Thumbs.db

# Editors
.vscode/
.idea/
*.swp
*.swo
*~

# Environment
.env
.env.local
.env.*.local

# Logs
*.log
logs/

# Dependencies
node_modules/
vendor/

# Build
dist/
build/
```

```bash
# Activer le .gitignore global
git config --global core.excludesfile ~/.gitignore_global
```

## ✅ Checklist

- [ ] Git installé
- [ ] Configuration globale définie (nom, email)
- [ ] Clés SSH générées
- [ ] Clé publique ajoutée à GitHub/GitLab
- [ ] Connexion SSH testée avec succès
- [ ] Fichier SSH config créé
- [ ] Agent SSH configuré
- [ ] Premier clone de dépôt réussi
- [ ] Alias Git configurés
- [ ] .gitignore global créé (optionnel)

## 🔜 Étape suivante

Passer à [04-structure-projet.md](04-structure-projet.md) pour organiser votre projet sur le VPS.

## 📝 Notes

- **JAMAIS** commiter ou partager votre clé privée (`id_ed25519`)
- **Toujours** protéger vos clés SSH avec une passphrase
- **Sauvegarder** vos clés dans un endroit sûr (gestionnaire de mots de passe, coffre-fort)
- **Révoquer** immédiatement une clé compromise sur GitHub/GitLab

## 🔧 Dépannage

### Erreur "Could not resolve hostname"
```bash
# Vérifier la connexion internet
ping -c 3 github.com

# Vérifier le DNS
cat /etc/resolv.conf
```

### Erreur "Permission denied (publickey)"
```bash
# Vérifier que la clé est ajoutée
ssh-add -l

# Si vide, ajouter la clé
ssh-add ~/.ssh/id_ed25519

# Vérifier le nom de la clé dans config
cat ~/.ssh/config
```
