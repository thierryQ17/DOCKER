# 02 - Installation de Docker et Docker Compose

## 🎯 Objectifs
- Installer Docker Engine sur Debian
- Installer Docker Compose Plugin
- Configurer Docker pour un usage non-root
- Vérifier l'installation

## 📋 Prérequis
- Accès SSH au VPS configuré (étape 01 complétée)
- Utilisateur non-root avec privilèges sudo

## 1. Installation des prérequis

```bash
# Mettre à jour les paquets
sudo apt update

# Installer les dépendances nécessaires
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common
```

## 2. Ajout du dépôt officiel Docker

### Créer le répertoire pour les clés GPG

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

### Ajouter la clé GPG officielle de Docker

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Définir les permissions
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### Ajouter le dépôt Docker aux sources APT

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

## 3. Installation de Docker

```bash
# Mettre à jour la liste des paquets
sudo apt update

# Installer Docker et ses composants
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
```

### Vérifier l'installation

```bash
# Version de Docker
docker --version
# Devrait afficher : Docker version 24.x.x, build xxxxx

# Version de Docker Compose
docker compose version
# Devrait afficher : Docker Compose version v2.x.x
```

## 4. Configuration de Docker

### Ajouter votre utilisateur au groupe docker

```bash
# Ajouter l'utilisateur actuel au groupe docker
sudo usermod -aG docker $USER

# Vérifier l'appartenance au groupe
groups $USER
# Devrait afficher : ... docker ...
```

### ⚠️ IMPORTANT : Activer les changements

```bash
# Option 1 : Se déconnecter et se reconnecter (recommandé)
exit
# Puis se reconnecter : ssh votrenom@37.59.123.9

# Option 2 : Utiliser newgrp (temporaire pour la session actuelle)
newgrp docker
```

### Tester Docker sans sudo

```bash
# Exécuter hello-world
docker run hello-world

# Devrait afficher :
# Hello from Docker!
# This message shows that your installation appears to be working correctly.
```

## 5. Configuration avancée de Docker

### Créer le fichier de configuration daemon.json

```bash
# Créer le répertoire si nécessaire
sudo mkdir -p /etc/docker

# Éditer le fichier de configuration
sudo nano /etc/docker/daemon.json
```

**Contenu recommandé :**

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "default-address-pools": [
    {
      "base": "172.17.0.0/16",
      "size": 24
    }
  ]
}
```

### Redémarrer Docker pour appliquer

```bash
# Redémarrer le service Docker
sudo systemctl restart docker

# Vérifier le statut
sudo systemctl status docker

# Vérifier la configuration
docker info | grep -A 5 "Storage Driver"
docker info | grep -A 3 "Log Driver"
```

## 6. Configuration du démarrage automatique

```bash
# Activer Docker au démarrage
sudo systemctl enable docker
sudo systemctl enable containerd

# Vérifier
systemctl is-enabled docker
systemctl is-enabled containerd
# Devrait afficher : enabled
```

## 7. Tests de fonctionnement

### Test 1 : Image hello-world

```bash
docker run hello-world
```

### Test 2 : Container interactif

```bash
# Lancer un container Ubuntu
docker run -it ubuntu:22.04 bash

# Dans le container :
cat /etc/os-release
exit
```

### Test 3 : Docker Compose

```bash
# Créer un dossier de test
mkdir -p ~/docker-test
cd ~/docker-test

# Créer un fichier docker-compose.yml simple
cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  test-nginx:
    image: nginx:alpine
    container_name: test-nginx
    ports:
      - "8080:80"
EOF

# Lancer le service
docker compose up -d

# Vérifier
docker compose ps

# Tester l'accès
curl http://localhost:8080

# Arrêter et nettoyer
docker compose down

# Retour au dossier home
cd ~
rm -rf ~/docker-test
```

## 8. Commandes Docker utiles

### Gestion des containers

```bash
# Lister les containers actifs
docker ps

# Lister tous les containers (même arrêtés)
docker ps -a

# Arrêter un container
docker stop <container_id>

# Supprimer un container
docker rm <container_id>

# Supprimer tous les containers arrêtés
docker container prune
```

### Gestion des images

```bash
# Lister les images
docker images

# Supprimer une image
docker rmi <image_id>

# Supprimer les images non utilisées
docker image prune -a
```

### Gestion des volumes

```bash
# Lister les volumes
docker volume ls

# Supprimer un volume
docker volume rm <volume_name>

# Supprimer les volumes non utilisés
docker volume prune
```

### Nettoyage global

```bash
# Nettoyer tout ce qui est inutilisé
docker system prune -a --volumes

# Voir l'espace disque utilisé par Docker
docker system df
```

## 9. Configuration des limites de ressources

### Limiter la mémoire Docker

```bash
# Éditer le fichier de service Docker
sudo nano /etc/systemd/system/docker.service.d/override.conf
```

**Contenu (optionnel) :**

```ini
[Service]
# Limiter la mémoire totale utilisée par Docker (exemple : 2 Go)
LimitMEMLOCK=infinity
LimitNOFILE=1048576
```

```bash
# Recharger systemd
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 10. Sécurité Docker

### Activer les fonctionnalités de sécurité

```bash
# Vérifier AppArmor
sudo aa-status

# Installer AppArmor si nécessaire
sudo apt install -y apparmor apparmor-utils

# Vérifier que Docker utilise AppArmor
docker info | grep -i security
```

### Configuration des logs audit

```bash
# Installer auditd
sudo apt install -y auditd

# Ajouter des règles pour Docker
sudo nano /etc/audit/rules.d/docker.rules
```

**Contenu :**

```
-w /usr/bin/docker -p wa -k docker
-w /var/lib/docker -p wa -k docker
-w /etc/docker -p wa -k docker
-w /lib/systemd/system/docker.service -p wa -k docker
-w /etc/systemd/system/docker.service -p wa -k docker
```

```bash
# Redémarrer auditd
sudo systemctl restart auditd
```

## ✅ Checklist

- [ ] Prérequis installés
- [ ] Dépôt Docker ajouté
- [ ] Docker Engine installé
- [ ] Docker Compose installé
- [ ] Utilisateur ajouté au groupe docker
- [ ] Docker fonctionne sans sudo
- [ ] Configuration daemon.json créée
- [ ] Démarrage automatique activé
- [ ] Tests de fonctionnement réussis
- [ ] Sécurité de base configurée

## 🔜 Étape suivante

Passer à [03-configuration-git.md](03-configuration-git.md) pour configurer Git et les clés SSH.

## 📝 Notes

- **Ne jamais** exécuter des images Docker non vérifiées en production
- **Toujours** limiter les ressources des containers
- **Mettre à jour** régulièrement Docker : `sudo apt update && sudo apt upgrade docker-ce`
- **Surveiller** l'espace disque : `docker system df`
