# 01 - Connexion et Sécurisation Initiale

## 🎯 Objectifs
- Établir la première connexion SSH au VPS
- Mettre à jour le système
- Créer un utilisateur non-root
- Sécuriser l'accès SSH

## 📋 Prérequis
- Accès SSH depuis votre machine Windows
- Informations de connexion VPS

## 1. Première connexion SSH

### Depuis Windows PowerShell

```powershell
# Connexion avec IPv4
ssh debian@37.59.123.9

# OU avec IPv6
ssh debian@2001:41d0:305:2100::7d21
```

### Vérification de la connexion

```bash
# Une fois connecté, vérifier les informations système
uname -a
cat /etc/os-release
```

## 2. Mise à jour du système

```bash
# Mettre à jour la liste des paquets
sudo apt update

# Installer les mises à jour
sudo apt upgrade -y

# Nettoyer les paquets inutiles
sudo apt autoremove -y
sudo apt autoclean
```

## 3. Création d'un utilisateur non-root

### Pourquoi ?
- Meilleure sécurité (éviter d'utiliser root)
- Traçabilité des actions
- Limitation des risques en cas de compromission

### Création de l'utilisateur

```bash
# Créer un nouvel utilisateur (remplacer 'votrenom' par votre nom)
sudo adduser votreutil

# Exemple d'interaction :
# - Mot de passe : choisir un mot de passe fort
# - Nom complet : [Entrée pour passer]
# - Autres infos : [Entrée pour tout passer]
```

### Ajout aux groupes sudo

```bash
# Donner les privilèges sudo
sudo usermod -aG sudo votrenom

# Vérifier l'appartenance aux groupes
groups votrenom
# Devrait afficher : votrenom : votrenom sudo
```

### Copie des clés SSH (optionnel mais recommandé)

```bash
# Copier le dossier .ssh vers le nouvel utilisateur
sudo rsync --archive --chown=votrenom:votrenom ~/.ssh /home/votrenom/

# Vérifier les permissions
sudo ls -la /home/votrenom/.ssh/
```

## 4. Configuration SSH sécurisée

### Générer des clés SSH sur votre machine Windows

**Sur votre machine Windows (PowerShell) :**

```powershell
# Générer une paire de clés Ed25519 (plus sécurisée que RSA)
ssh-keygen -t ed25519 -C "votre@email.com"

# Emplacement par défaut : C:\Users\VotreNom\.ssh\id_ed25519
# Entrer une passphrase forte

# Copier la clé publique vers le VPS
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh debian@37.59.123.9 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Sécuriser le fichier de configuration SSH

**Sur le VPS :**

```bash
# Sauvegarder la configuration actuelle
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Éditer la configuration
sudo nano /etc/ssh/sshd_config
```

**Modifications recommandées :**

```bash
# Désactiver la connexion root
PermitRootLogin no

# Désactiver l'authentification par mot de passe (après avoir testé les clés SSH)
PasswordAuthentication no

# Autoriser uniquement votre utilisateur
AllowUsers votrenom

# Changer le port SSH (optionnel mais recommandé)
Port 2222

# Désactiver l'authentification par clavier interactif
ChallengeResponseAuthentication no

# Activer la connexion par clé publique
PubkeyAuthentication yes

# Limiter les tentatives de connexion
MaxAuthTries 3

# Timeout de session inactive
ClientAliveInterval 300
ClientAliveCountMax 2
```

### Redémarrer le service SSH

```bash
# Vérifier la configuration (important !)
sudo sshd -t

# Si pas d'erreur, redémarrer SSH
sudo systemctl restart sshd

# Vérifier le statut
sudo systemctl status sshd
```

### ⚠️ IMPORTANT : Tester avant de se déconnecter

**Dans une NOUVELLE fenêtre PowerShell :**

```powershell
# Si vous avez changé le port
ssh -p 2222 votrenom@37.59.123.9

# Sinon
ssh votrenom@37.59.123.9
```

**Si la connexion fonctionne :**
- ✅ La configuration est OK
- Vous pouvez fermer l'ancienne session

**Si la connexion ne fonctionne pas :**
- ⚠️ NE PAS fermer l'ancienne session
- Vérifier la configuration
- Corriger les erreurs

## 5. Configuration de fail2ban (protection contre brute-force)

```bash
# Installer fail2ban
sudo apt install -y fail2ban

# Créer une configuration locale
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Éditer la configuration
sudo nano /etc/fail2ban/jail.local
```

**Configuration pour SSH :**

```ini
[sshd]
enabled = true
port = 2222  # Ou 22 si vous n'avez pas changé le port
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

```bash
# Redémarrer fail2ban
sudo systemctl restart fail2ban

# Vérifier le statut
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

## 6. Vérifications finales

```bash
# Vérifier les utilisateurs avec sudo
getent group sudo

# Vérifier les connexions SSH actives
who

# Vérifier les logs SSH
sudo tail -f /var/log/auth.log

# Vérifier le port SSH en écoute
sudo netstat -tulpn | grep ssh
# OU
sudo ss -tulpn | grep ssh
```

## ✅ Checklist

- [ ] Connexion SSH établie
- [ ] Système mis à jour
- [ ] Nouvel utilisateur créé avec privilèges sudo
- [ ] Clés SSH générées et copiées
- [ ] Configuration SSH sécurisée
- [ ] Service SSH redémarré
- [ ] Connexion avec le nouvel utilisateur testée
- [ ] fail2ban installé et configuré
- [ ] Accès root désactivé

## 🔜 Étape suivante

Une fois cette étape validée, passer à [02-installation-docker.md](02-installation-docker.md)

## 📝 Notes

- **Conservez** une copie de votre clé privée SSH en lieu sûr
- **Documentez** les modifications apportées à sshd_config
- **Testez** toujours une nouvelle connexion avant de fermer la session active
