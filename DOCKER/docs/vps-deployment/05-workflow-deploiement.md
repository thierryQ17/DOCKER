# 05 - Workflow Git et Déploiement Continu

## 🎯 Objectifs
- Établir un workflow Git efficace
- Configurer le déploiement automatique
- Mettre en place des hooks Git
- Gérer les versions et les rollbacks

## 📋 Prérequis
- Structure projet créée (étape 04 complétée)
- Git configuré avec accès au dépôt distant
- Docker fonctionnel sur le VPS

## 1. Architecture du workflow Git

### Stratégie de branches

```
master (ou main)
  ├── production     # Déploiement automatique sur le VPS
  ├── staging        # Tests avant production
  └── develop        # Développement actif
      └── feature/*  # Branches de fonctionnalités
```

### Mise en place des branches

```bash
cd ~/projects/annuaire-maires

# Créer les branches si elles n'existent pas
git checkout -b develop
git checkout -b staging
git checkout -b production

# Pousser toutes les branches
git push -u origin develop
git push -u origin staging
git push -u origin production
```

## 2. Workflow de développement

### Sur votre machine locale (Windows)

```powershell
# Se placer dans le projet
cd "C:\DEV POWERSHELL\DOCKER"

# Créer une branche de fonctionnalité
git checkout develop
git pull origin develop
git checkout -b feature/nom-fonctionnalite

# Développer et tester localement
# ... faire vos modifications ...

# Commiter les changements
git add .
git commit -m "Ajout de la fonctionnalité X"

# Pousser la branche
git push -u origin feature/nom-fonctionnalite
```

### Fusion et tests

```powershell
# Fusionner dans develop
git checkout develop
git pull origin develop
git merge feature/nom-fonctionnalite
git push origin develop

# Tester en staging
git checkout staging
git pull origin staging
git merge develop
git push origin staging
```

## 3. Déploiement en production

### Méthode manuelle

**Sur le VPS :**

```bash
cd ~/projects/annuaire-maires

# S'assurer d'être sur la branche production
git checkout production

# Récupérer les dernières modifications
git pull origin production

# Exécuter le script de déploiement
./deploy.sh
```

### Méthode automatique avec Git hooks

#### Créer un hook post-receive

```bash
# Créer un dépôt bare pour recevoir les push
mkdir -p ~/git/annuaire-maires.git
cd ~/git/annuaire-maires.git
git init --bare

# Créer le hook post-receive
nano hooks/post-receive
```

**Contenu du hook :**

```bash
#!/bin/bash

# Configuration
WORK_TREE="/home/votrenom/projects/annuaire-maires"
GIT_DIR="/home/votrenom/git/annuaire-maires.git"
BRANCH="production"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW} 🚀 Déploiement automatique${NC}"
echo -e "${YELLOW}=========================================${NC}"

# Vérifier quelle branche a été pushée
while read oldrev newrev refname; do
    branch=$(git rev-parse --symbolic --abbrev-ref $refname)

    if [ "$branch" == "$BRANCH" ]; then
        echo -e "${GREEN}✓ Push détecté sur $BRANCH${NC}"

        # Checkout dans le working tree
        echo -e "${YELLOW}📥 Mise à jour des fichiers...${NC}"
        git --work-tree=$WORK_TREE --git-dir=$GIT_DIR checkout -f $BRANCH

        # Se placer dans le dossier de travail
        cd $WORK_TREE

        # Créer un backup de la base de données
        echo -e "${YELLOW}💾 Backup de la base de données...${NC}"
        timestamp=$(date +%Y%m%d_%H%M%S)
        docker exec mysql_prod mysqldump -u root -p${MYSQL_ROOT_PASSWORD} annuairesMairesDeFrance > ~/backups/database/backup_${timestamp}.sql

        # Redémarrer les containers
        echo -e "${YELLOW}🔄 Redémarrage des containers...${NC}"
        docker compose down
        docker compose up -d --build

        # Attendre que les services soient prêts
        echo -e "${YELLOW}⏳ Attente du démarrage...${NC}"
        sleep 10

        # Vérifier le statut
        echo -e "${YELLOW}📊 Statut des containers:${NC}"
        docker compose ps

        # Nettoyer les anciennes images
        echo -e "${YELLOW}🧹 Nettoyage...${NC}"
        docker image prune -f

        echo -e "${GREEN}=========================================${NC}"
        echo -e "${GREEN} ✅ Déploiement terminé !${NC}"
        echo -e "${GREEN}=========================================${NC}"
    else
        echo -e "${RED}✗ Branche $branch ignorée (seule $BRANCH est déployée)${NC}"
    fi
done
```

```bash
# Rendre le hook exécutable
chmod +x hooks/post-receive
```

#### Configurer le remote sur votre machine locale

**Sur Windows (PowerShell) :**

```powershell
cd "C:\DEV POWERSHELL\DOCKER"

# Ajouter le remote VPS
git remote add vps ssh://votrenom@37.59.123.9/home/votrenom/git/annuaire-maires.git

# Vérifier les remotes
git remote -v
# Devrait afficher :
# origin    git@github.com:... (fetch/push)
# vps       ssh://votrenom@37.59.123.9/... (fetch/push)
```

#### Déployer avec un simple push

```powershell
# Depuis votre machine locale
git checkout production
git merge staging  # Fusionner staging dans production
git push origin production  # Pousser vers GitHub
git push vps production      # Déployer sur le VPS (déclenchera le hook)
```

## 4. Script de déploiement amélioré

### Créer un script deploy.sh avancé

```bash
cd ~/projects/annuaire-maires
nano deploy.sh
```

**Contenu :**

```bash
#!/bin/bash

set -e  # Arrêter en cas d'erreur

# Configuration
BRANCH="${1:-production}"
WORK_DIR="/home/votrenom/projects/annuaire-maires"
BACKUP_DIR="/home/votrenom/backups/database"
MAX_BACKUPS=10

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions
log_info() { echo -e "${BLUE}ℹ ${1}${NC}"; }
log_success() { echo -e "${GREEN}✓ ${1}${NC}"; }
log_warning() { echo -e "${YELLOW}⚠ ${1}${NC}"; }
log_error() { echo -e "${RED}✗ ${1}${NC}"; }

# Banner
echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW} 🚀 Déploiement de l'application${NC}"
echo -e "${YELLOW} Branche: ${BRANCH}${NC}"
echo -e "${YELLOW}=========================================${NC}"

# Vérifier qu'on est dans le bon dossier
if [ ! -f "docker-compose.yml" ]; then
    log_error "docker-compose.yml non trouvé dans $(pwd)"
    exit 1
fi

# Charger les variables d'environnement
if [ -f ".env" ]; then
    source .env
    log_success "Variables d'environnement chargées"
else
    log_error "Fichier .env non trouvé"
    exit 1
fi

# Pull des dernières modifications
log_info "Récupération des dernières modifications..."
git fetch origin
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    log_warning "Passage de $CURRENT_BRANCH à $BRANCH"
    git checkout $BRANCH
fi

git pull origin $BRANCH || { log_error "Échec du git pull"; exit 1; }
log_success "Code mis à jour"

# Backup de la base de données
log_info "Sauvegarde de la base de données..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"

# Créer le dossier de backup s'il n'existe pas
mkdir -p $BACKUP_DIR

# Faire le backup
docker exec mysql_prod mysqldump \
    -u root \
    -p${MYSQL_ROOT_PASSWORD} \
    annuairesMairesDeFrance > $BACKUP_FILE 2>/dev/null || {
    log_warning "Base de données non accessible, poursuite du déploiement"
}

if [ -f "$BACKUP_FILE" ]; then
    log_success "Backup créé: $BACKUP_FILE"

    # Compresser le backup
    gzip $BACKUP_FILE
    log_success "Backup compressé"

    # Supprimer les anciens backups (garder les MAX_BACKUPS plus récents)
    cd $BACKUP_DIR
    ls -t backup_*.sql.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
    log_success "Anciens backups nettoyés (conservés: $MAX_BACKUPS)"
    cd $WORK_DIR
fi

# Arrêter les containers
log_info "Arrêt des containers..."
docker compose down
log_success "Containers arrêtés"

# Rebuild et redémarrer
log_info "Construction et démarrage des containers..."
docker compose up -d --build
log_success "Containers démarrés"

# Attendre que les services soient prêts
log_info "Attente du démarrage des services..."
for i in {1..30}; do
    if docker compose ps | grep -q "Up"; then
        break
    fi
    sleep 1
done

# Vérifier le statut des containers
log_info "Statut des containers:"
docker compose ps

# Vérifier la santé de l'application
log_info "Vérification de la santé de l'application..."
sleep 5

# Test HTTP
if curl -f -s http://localhost > /dev/null; then
    log_success "Application accessible"
else
    log_warning "Application peut-être inaccessible"
fi

# Nettoyer les ressources inutilisées
log_info "Nettoyage des ressources Docker..."
docker image prune -f > /dev/null 2>&1
docker volume prune -f > /dev/null 2>&1
log_success "Nettoyage effectué"

# Afficher les logs récents
log_info "Derniers logs:"
docker compose logs --tail=20

# Résumé
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN} ✅ Déploiement terminé avec succès !${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "${BLUE}Application: http://37.59.123.9${NC}"
echo -e "${BLUE}Backup: ${BACKUP_FILE}.gz${NC}"
echo -e "${BLUE}Branche: $BRANCH${NC}"
echo -e "${BLUE}Commit: $(git rev-parse --short HEAD)${NC}"
```

```bash
chmod +x deploy.sh
```

## 5. Gestion des versions avec tags

### Créer une version

**Sur votre machine locale :**

```powershell
# Se placer sur production
git checkout production

# Créer un tag annoté
git tag -a v1.0.0 -m "Version 1.0.0 - Première version stable"

# Pousser le tag
git push origin v1.0.0
```

### Lister les versions

```bash
# Lister tous les tags
git tag

# Afficher les détails d'un tag
git show v1.0.0

# Lister les tags avec leurs messages
git tag -n
```

### Déployer une version spécifique

```bash
# Sur le VPS
cd ~/projects/annuaire-maires

# Récupérer un tag spécifique
git fetch --tags
git checkout v1.0.0

# Déployer
./deploy.sh
```

## 6. Rollback en cas de problème

### Rollback rapide

```bash
# Sur le VPS
cd ~/projects/annuaire-maires

# Revenir au commit précédent
git log --oneline -5  # Voir les derniers commits
git checkout <commit-hash-precedent>

# Redéployer
./deploy.sh
```

### Rollback avec restauration de la base

```bash
# Arrêter les containers
docker compose down

# Restaurer un backup
BACKUP_FILE="~/backups/database/backup_20240115_143000.sql.gz"
gunzip -c $BACKUP_FILE | docker exec -i mysql_prod mysql -u root -p${MYSQL_ROOT_PASSWORD} annuairesMairesDeFrance

# Revenir au code correspondant
git checkout <commit-hash>

# Redémarrer
./deploy.sh
```

## 7. Hooks Git locaux (pre-commit)

### Sur votre machine locale

```powershell
cd "C:\DEV POWERSHELL\DOCKER"
cd .git\hooks

# Créer un fichier pre-commit (sans extension sous Windows, utiliser Git Bash ou créer manuellement)
```

**Sous Git Bash (Windows) :**

```bash
#!/bin/bash

echo "🔍 Vérification avant commit..."

# Vérifier qu'on ne commit pas de fichiers sensibles
FORBIDDEN_FILES=(".env" "*.sql" "*.sql.gz" "credentials.json")

for pattern in "${FORBIDDEN_FILES[@]}"; do
    if git diff --cached --name-only | grep -q "$pattern"; then
        echo "❌ ERREUR: Fichier sensible détecté: $pattern"
        echo "Utilisez .gitignore pour exclure ce fichier"
        exit 1
    fi
done

echo "✅ Vérifications OK"
exit 0
```

```bash
chmod +x pre-commit
```

## 8. Configuration CI/CD avec GitHub Actions (optionnel)

### Créer un workflow GitHub Actions

**Sur votre machine locale :**

```powershell
mkdir -p .github\workflows
cd .github\workflows
```

**Créer le fichier deploy.yml :**

```yaml
name: Deploy to VPS

on:
  push:
    branches:
      - production

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Deploy to VPS via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          port: 22
          script: |
            cd ~/projects/annuaire-maires
            git pull origin production
            ./deploy.sh production
```

### Configurer les secrets GitHub

1. Aller sur GitHub → Settings → Secrets and variables → Actions
2. Ajouter les secrets :
   - `VPS_HOST`: 37.59.123.9
   - `VPS_USER`: votrenom
   - `VPS_SSH_KEY`: Contenu de votre clé privée SSH

## 9. Monitoring du déploiement

### Créer un script de vérification post-déploiement

```bash
nano ~/scripts/check-deployment.sh
```

**Contenu :**

```bash
#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔍 Vérification du déploiement..."

# Vérifier les containers
if docker compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Containers actifs${NC}"
else
    echo -e "${RED}✗ Containers inactifs${NC}"
    exit 1
fi

# Vérifier Nginx
if curl -f -s http://localhost > /dev/null; then
    echo -e "${GREEN}✓ Nginx répond${NC}"
else
    echo -e "${RED}✗ Nginx ne répond pas${NC}"
    exit 1
fi

# Vérifier MySQL
if docker exec mysql_prod mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} ping 2>/dev/null | grep -q "alive"; then
    echo -e "${GREEN}✓ MySQL opérationnel${NC}"
else
    echo -e "${RED}✗ MySQL inaccessible${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Déploiement vérifié avec succès${NC}"
```

```bash
chmod +x ~/scripts/check-deployment.sh
```

## ✅ Checklist

- [ ] Workflow Git établi (branches develop, staging, production)
- [ ] Script deploy.sh créé et testé
- [ ] Hook post-receive configuré (optionnel)
- [ ] Remote VPS ajouté pour push direct
- [ ] Système de backup automatique fonctionnel
- [ ] Tags de version créés
- [ ] Procédure de rollback testée
- [ ] Pre-commit hook installé
- [ ] GitHub Actions configuré (optionnel)
- [ ] Script de vérification post-déploiement créé

## 🔜 Étape suivante

Passer à [06-configuration-firewall.md](06-configuration-firewall.md) pour sécuriser le serveur avec UFW.

## 📝 Notes

- **Toujours** tester le déploiement en staging avant production
- **Vérifier** que le backup s'est bien créé avant de déployer
- **Documenter** chaque déploiement avec des tags Git
- **Garder** au moins 10 backups de la base de données
- **Ne jamais** forcer un push sur production sans vérification
