# 07 - Automatisation et Scripts

## 🎯 Objectifs
- Automatiser les tâches récurrentes avec cron
- Créer des scripts de maintenance
- Automatiser les sauvegardes
- Mettre en place des alertes

## 📋 Prérequis
- VPS configuré et sécurisé
- Docker et application déployés
- Accès SSH avec privilèges sudo

## 1. Structure des scripts

### Créer la structure de dossiers

```bash
# Créer les dossiers pour les scripts
mkdir -p ~/scripts/{backup,monitoring,maintenance,utils}
mkdir -p ~/logs

# Structure finale :
# ~/scripts/
# ├── backup/         # Scripts de sauvegarde
# ├── monitoring/     # Scripts de surveillance
# ├── maintenance/    # Scripts de maintenance
# └── utils/          # Scripts utilitaires
```

## 2. Scripts de sauvegarde

### Script de backup de la base de données

```bash
nano ~/scripts/backup/backup-database.sh
```

**Contenu :**

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/home/$(whoami)/backups/database"
PROJECT_DIR="/home/$(whoami)/projects/annuaire-maires"
LOG_FILE="/home/$(whoami)/logs/backup.log"
MAX_BACKUPS=30  # Garder 30 backups (1 mois si quotidien)
MYSQL_CONTAINER="mysql_prod"

# Couleurs pour les logs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonction de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

# Début
log "========================================="
log "Début du backup de la base de données"
log "========================================="

# Charger les variables d'environnement
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
    log_success "Variables d'environnement chargées"
else
    log_error "Fichier .env non trouvé"
    exit 1
fi

# Vérifier que le container MySQL est actif
if ! docker ps | grep -q "$MYSQL_CONTAINER"; then
    log_error "Container MySQL non actif"
    exit 1
fi

# Créer le dossier de backup s'il n'existe pas
mkdir -p "$BACKUP_DIR"

# Générer le nom du fichier
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"

# Faire le dump MySQL
log "Création du dump MySQL..."
docker exec "$MYSQL_CONTAINER" mysqldump \
    -u root \
    -p"${MYSQL_ROOT_PASSWORD}" \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    "${MYSQL_DATABASE}" > "$BACKUP_FILE" 2>/dev/null

# Vérifier que le backup a réussi
if [ $? -eq 0 ] && [ -s "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log_success "Backup créé: $BACKUP_FILE ($BACKUP_SIZE)"

    # Compresser le backup
    log "Compression du backup..."
    gzip "$BACKUP_FILE"

    if [ $? -eq 0 ]; then
        COMPRESSED_SIZE=$(du -h "${BACKUP_FILE}.gz" | cut -f1)
        log_success "Backup compressé: ${BACKUP_FILE}.gz ($COMPRESSED_SIZE)"
    else
        log_error "Échec de la compression"
        exit 1
    fi
else
    log_error "Échec de la création du backup"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Supprimer les anciens backups
log "Nettoyage des anciens backups (conservation: $MAX_BACKUPS)..."
cd "$BACKUP_DIR"
DELETED_COUNT=$(ls -t backup_*.sql.gz 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | wc -l)

if [ "$DELETED_COUNT" -gt 0 ]; then
    ls -t backup_*.sql.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
    log_success "$DELETED_COUNT ancien(s) backup(s) supprimé(s)"
else
    log "Aucun ancien backup à supprimer"
fi

# Statistiques
TOTAL_BACKUPS=$(ls -1 backup_*.sql.gz 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sh . | cut -f1)

log "========================================="
log_success "Backup terminé avec succès"
log "Total backups: $TOTAL_BACKUPS"
log "Espace utilisé: $TOTAL_SIZE"
log "========================================="

exit 0
```

```bash
chmod +x ~/scripts/backup/backup-database.sh
```

### Script de backup des fichiers

```bash
nano ~/scripts/backup/backup-files.sh
```

**Contenu :**

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/home/$(whoami)/backups/files"
PROJECT_DIR="/home/$(whoami)/projects/annuaire-maires"
LOG_FILE="/home/$(whoami)/logs/backup.log"
MAX_BACKUPS=7  # Garder 7 backups de fichiers

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Début du backup des fichiers"
log "========================================="

# Créer le dossier de backup
mkdir -p "$BACKUP_DIR"

# Générer le nom de l'archive
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/files_${TIMESTAMP}.tar.gz"

# Créer l'archive (exclure certains dossiers)
log "Création de l'archive..."
tar -czf "$BACKUP_FILE" \
    --exclude='node_modules' \
    --exclude='vendor' \
    --exclude='.git' \
    --exclude='logs' \
    --exclude='backups' \
    -C "$(dirname $PROJECT_DIR)" \
    "$(basename $PROJECT_DIR)"

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log "✅ Archive créée: $BACKUP_FILE ($BACKUP_SIZE)"
else
    log "❌ Échec de la création de l'archive"
    exit 1
fi

# Supprimer les anciens backups
log "Nettoyage des anciens backups..."
cd "$BACKUP_DIR"
ls -t files_*.tar.gz 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm

log "✅ Backup des fichiers terminé"
log "========================================="
```

```bash
chmod +x ~/scripts/backup/backup-files.sh
```

## 3. Scripts de monitoring

### Script de surveillance des ressources

```bash
nano ~/scripts/monitoring/check-resources.sh
```

**Contenu :**

```bash
#!/bin/bash

# Configuration
LOG_FILE="/home/$(whoami)/logs/monitoring.log"
ALERT_EMAIL=""  # Optionnel : adresse email pour les alertes

# Seuils d'alerte
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=85

# Fonction de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

alert() {
    log "🚨 ALERTE: $1"
    # Optionnel : envoyer un email
    # echo "$1" | mail -s "Alerte VPS" "$ALERT_EMAIL"
}

# Vérifier l'utilisation CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
CPU_USAGE_INT=${CPU_USAGE%.*}

if [ "$CPU_USAGE_INT" -gt "$CPU_THRESHOLD" ]; then
    alert "CPU élevé: ${CPU_USAGE}%"
else
    log "CPU: ${CPU_USAGE}% ✓"
fi

# Vérifier l'utilisation mémoire
MEMORY_USAGE=$(free | grep Mem | awk '{print ($3/$2) * 100.0}')
MEMORY_USAGE_INT=${MEMORY_USAGE%.*}

if [ "$MEMORY_USAGE_INT" -gt "$MEMORY_THRESHOLD" ]; then
    alert "Mémoire élevée: ${MEMORY_USAGE}%"
else
    log "Mémoire: ${MEMORY_USAGE}% ✓"
fi

# Vérifier l'espace disque
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    alert "Disque plein: ${DISK_USAGE}%"
else
    log "Disque: ${DISK_USAGE}% ✓"
fi

# Vérifier les containers Docker
log "Vérification des containers Docker..."
cd /home/$(whoami)/projects/annuaire-maires

EXPECTED_CONTAINERS=3
RUNNING_CONTAINERS=$(docker compose ps --services --filter "status=running" | wc -l)

if [ "$RUNNING_CONTAINERS" -ne "$EXPECTED_CONTAINERS" ]; then
    alert "Containers Docker: $RUNNING_CONTAINERS/$EXPECTED_CONTAINERS actifs"
else
    log "Containers Docker: $RUNNING_CONTAINERS/$EXPECTED_CONTAINERS actifs ✓"
fi

# Vérifier la disponibilité du site
if curl -f -s http://localhost > /dev/null; then
    log "Site web: accessible ✓"
else
    alert "Site web inaccessible"
fi

log "========================================="
```

```bash
chmod +x ~/scripts/monitoring/check-resources.sh
```

### Script de vérification des logs d'erreurs

```bash
nano ~/scripts/monitoring/check-errors.sh
```

**Contenu :**

```bash
#!/bin/bash

LOG_FILE="/home/$(whoami)/logs/monitoring.log"
PROJECT_DIR="/home/$(whoami)/projects/annuaire-maires"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Vérification des erreurs dans les logs Docker..."

cd "$PROJECT_DIR"

# Vérifier les erreurs dans les logs des containers (dernière heure)
ERRORS=$(docker compose logs --since 1h | grep -iE "error|fatal|critical" | wc -l)

if [ "$ERRORS" -gt 0 ]; then
    log "🚨 $ERRORS erreur(s) détectée(s) dans les logs"
    docker compose logs --since 1h | grep -iE "error|fatal|critical" | tail -20 >> "$LOG_FILE"
else
    log "Aucune erreur détectée ✓"
fi
```

```bash
chmod +x ~/scripts/monitoring/check-errors.sh
```

## 4. Scripts de maintenance

### Script de nettoyage Docker

```bash
nano ~/scripts/maintenance/cleanup-docker.sh
```

**Contenu :**

```bash
#!/bin/bash

LOG_FILE="/home/$(whoami)/logs/maintenance.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Nettoyage Docker"
log "========================================="

# Espace avant nettoyage
BEFORE=$(docker system df | grep "Total" | awk '{print $4}')
log "Espace utilisé avant: $BEFORE"

# Supprimer les containers arrêtés
log "Suppression des containers arrêtés..."
docker container prune -f

# Supprimer les images non utilisées
log "Suppression des images non utilisées..."
docker image prune -a -f

# Supprimer les volumes non utilisés
log "Suppression des volumes non utilisés..."
docker volume prune -f

# Supprimer les réseaux non utilisés
log "Suppression des réseaux non utilisés..."
docker network prune -f

# Espace après nettoyage
AFTER=$(docker system df | grep "Total" | awk '{print $4}')
log "Espace utilisé après: $AFTER"

log "✅ Nettoyage terminé"
log "========================================="
```

```bash
chmod +x ~/scripts/maintenance/cleanup-docker.sh
```

### Script de mise à jour système

```bash
nano ~/scripts/maintenance/update-system.sh
```

**Contenu :**

```bash
#!/bin/bash

LOG_FILE="/home/$(whoami)/logs/maintenance.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Mise à jour du système"
log "========================================="

# Mettre à jour la liste des paquets
log "Mise à jour de la liste des paquets..."
sudo apt update | tee -a "$LOG_FILE"

# Vérifier les mises à jour disponibles
UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | wc -l)
log "$UPDATES mise(s) à jour disponible(s)"

if [ "$UPDATES" -gt 0 ]; then
    # Faire un backup avant la mise à jour
    log "Création d'un backup de sécurité..."
    /home/$(whoami)/scripts/backup/backup-database.sh

    # Installer les mises à jour
    log "Installation des mises à jour..."
    sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y | tee -a "$LOG_FILE"

    # Nettoyer
    log "Nettoyage..."
    sudo apt autoremove -y
    sudo apt autoclean

    log "✅ Mises à jour installées"

    # Vérifier si un redémarrage est nécessaire
    if [ -f /var/run/reboot-required ]; then
        log "🚨 ATTENTION: Redémarrage requis"
        log "Packages nécessitant un redémarrage:"
        cat /var/run/reboot-required.pkgs | tee -a "$LOG_FILE"
    fi
else
    log "✅ Système à jour"
fi

log "========================================="
```

```bash
chmod +x ~/scripts/maintenance/update-system.sh
```

## 5. Configuration des tâches cron

### Éditer le crontab

```bash
# Éditer le crontab de l'utilisateur
crontab -e
```

**Ajouter les lignes suivantes :**

```cron
# ========================================
# Automatisation VPS - Annuaire Maires
# ========================================

# Backup de la base de données (tous les jours à 2h00)
0 2 * * * /home/votrenom/scripts/backup/backup-database.sh

# Backup des fichiers (tous les dimanches à 3h00)
0 3 * * 0 /home/votrenom/scripts/backup/backup-files.sh

# Vérification des ressources (toutes les 15 minutes)
*/15 * * * * /home/votrenom/scripts/monitoring/check-resources.sh

# Vérification des erreurs (toutes les heures)
0 * * * * /home/votrenom/scripts/monitoring/check-errors.sh

# Nettoyage Docker (tous les lundis à 4h00)
0 4 * * 1 /home/votrenom/scripts/maintenance/cleanup-docker.sh

# Mise à jour système (tous les dimanches à 5h00)
0 5 * * 0 /home/votrenom/scripts/maintenance/update-system.sh

# Rotation des logs (premier jour du mois à 6h00)
0 6 1 * * find /home/votrenom/logs -name "*.log" -type f -mtime +30 -delete
```

### Syntaxe cron

```
* * * * * commande
│ │ │ │ │
│ │ │ │ └─── Jour de la semaine (0-7, 0 et 7 = dimanche)
│ │ │ └───── Mois (1-12)
│ │ └─────── Jour du mois (1-31)
│ └───────── Heure (0-23)
└─────────── Minute (0-59)
```

**Exemples :**

```cron
# Toutes les 5 minutes
*/5 * * * * commande

# Tous les jours à minuit
0 0 * * * commande

# Tous les lundis à 8h30
30 8 * * 1 commande

# Premier jour de chaque mois à 1h00
0 1 1 * * commande

# Du lundi au vendredi à 18h00
0 18 * * 1-5 commande
```

### Vérifier les tâches cron

```bash
# Lister les tâches cron
crontab -l

# Vérifier les logs cron
sudo tail -f /var/log/syslog | grep CRON
```

## 6. Script de restauration

### Script de restauration de base de données

```bash
nano ~/scripts/backup/restore-database.sh
```

**Contenu :**

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/home/$(whoami)/backups/database"
PROJECT_DIR="/home/$(whoami)/projects/annuaire-maires"
LOG_FILE="/home/$(whoami)/logs/restore.log"
MYSQL_CONTAINER="mysql_prod"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Vérifier qu'un fichier de backup est fourni
if [ -z "$1" ]; then
    echo "Usage: $0 <fichier_backup.sql.gz>"
    echo ""
    echo "Backups disponibles:"
    ls -lh "$BACKUP_DIR"/backup_*.sql.gz | tail -10
    exit 1
fi

BACKUP_FILE="$1"

# Vérifier que le fichier existe
if [ ! -f "$BACKUP_FILE" ]; then
    log "❌ Fichier non trouvé: $BACKUP_FILE"
    exit 1
fi

log "========================================="
log "Restauration de la base de données"
log "Fichier: $BACKUP_FILE"
log "========================================="

# Charger les variables d'environnement
source "$PROJECT_DIR/.env"

# Demander confirmation
read -p "⚠️  Cette opération va écraser la base actuelle. Continuer ? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "Restauration annulée"
    exit 0
fi

# Créer un backup de sécurité avant restauration
log "Création d'un backup de sécurité..."
/home/$(whoami)/scripts/backup/backup-database.sh

# Décompresser et restaurer
log "Restauration en cours..."
gunzip -c "$BACKUP_FILE" | docker exec -i "$MYSQL_CONTAINER" mysql \
    -u root \
    -p"${MYSQL_ROOT_PASSWORD}" \
    "${MYSQL_DATABASE}"

if [ $? -eq 0 ]; then
    log "✅ Restauration terminée avec succès"
else
    log "❌ Échec de la restauration"
    exit 1
fi

log "========================================="
```

```bash
chmod +x ~/scripts/backup/restore-database.sh
```

### Utilisation du script de restauration

```bash
# Lister les backups disponibles
ls -lh ~/backups/database/

# Restaurer un backup spécifique
~/scripts/backup/restore-database.sh ~/backups/database/backup_20240115_020000.sql.gz
```

## 7. Script de rapport quotidien

### Créer un script de rapport

```bash
nano ~/scripts/monitoring/daily-report.sh
```

**Contenu :**

```bash
#!/bin/bash

REPORT_FILE="/home/$(whoami)/logs/daily-report-$(date +%Y%m%d).log"

{
    echo "========================================="
    echo " 📊 RAPPORT QUOTIDIEN VPS"
    echo " Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================="
    echo ""

    echo "🖥️  SYSTÈME"
    echo "Uptime: $(uptime -p)"
    echo "Load average: $(uptime | awk -F'load average:' '{print $2}')"
    echo ""

    echo "💾 RESSOURCES"
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')%"
    echo "Mémoire: $(free -h | awk 'NR==2{printf "%.1f%%", $3*100/$2 }')"
    echo "Disque: $(df -h / | awk 'NR==2{print $5}')"
    echo ""

    echo "🐳 DOCKER"
    docker compose ps
    echo ""
    echo "Espace utilisé:"
    docker system df
    echo ""

    echo "📦 BACKUPS"
    echo "Derniers backups de base de données:"
    ls -lh ~/backups/database/*.sql.gz | tail -5
    echo ""

    echo "🔥 PARE-FEU"
    sudo ufw status numbered | head -20
    echo ""

    echo "⚠️  ERREURS RÉCENTES (24h)"
    grep -i error ~/logs/*.log 2>/dev/null | tail -10 || echo "Aucune erreur"
    echo ""

    echo "========================================="
} > "$REPORT_FILE"

cat "$REPORT_FILE"
```

```bash
chmod +x ~/scripts/monitoring/daily-report.sh
```

**Ajouter au crontab :**

```cron
# Rapport quotidien (tous les jours à 8h00)
0 8 * * * /home/votrenom/scripts/monitoring/daily-report.sh
```

## 8. Rotation des logs

### Configuration de logrotate

```bash
sudo nano /etc/logrotate.d/annuaire-maires
```

**Contenu :**

```
/home/votrenom/logs/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0644 votrenom votrenom
}
```

### Tester logrotate

```bash
# Tester la configuration
sudo logrotate -d /etc/logrotate.d/annuaire-maires

# Forcer la rotation
sudo logrotate -f /etc/logrotate.d/annuaire-maires
```

## ✅ Checklist

- [ ] Structure de dossiers scripts créée
- [ ] Script de backup base de données créé et testé
- [ ] Script de backup fichiers créé et testé
- [ ] Scripts de monitoring créés
- [ ] Scripts de maintenance créés
- [ ] Tâches cron configurées
- [ ] Script de restauration créé et testé
- [ ] Script de rapport quotidien configuré
- [ ] Rotation des logs configurée
- [ ] Tous les scripts ont les bonnes permissions (chmod +x)

## 🔜 Étape suivante

Passer à [08-monitoring-maintenance.md](08-monitoring-maintenance.md) pour mettre en place la surveillance avancée et la maintenance du serveur.

## 📝 Notes

- **Adapter** les chemins dans les scripts selon votre configuration
- **Tester** chaque script manuellement avant de l'ajouter au cron
- **Surveiller** les logs pour vérifier l'exécution des tâches
- **Documenter** les modifications apportées aux scripts
