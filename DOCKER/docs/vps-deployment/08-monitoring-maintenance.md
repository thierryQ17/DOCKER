# 08 - Monitoring et Maintenance

## 🎯 Objectifs
- Mettre en place une surveillance complète du serveur
- Installer des outils de monitoring
- Configurer des alertes
- Établir une routine de maintenance

## 📋 Prérequis
- VPS configuré et sécurisé
- Scripts d'automatisation en place (étape 07)
- Accès SSH avec privilèges sudo

## 1. Installation des outils de monitoring

### Installer htop (monitoring interactif)

```bash
# Installer htop
sudo apt update
sudo apt install -y htop

# Lancer htop
htop
```

**Raccourcis htop :**
- `F1` : Aide
- `F2` : Configuration
- `F3` : Rechercher un processus
- `F4` : Filtrer
- `F5` : Vue arbre
- `F9` : Tuer un processus
- `F10` ou `q` : Quitter

### Installer ncdu (analyse disque)

```bash
# Installer ncdu (NCurses Disk Usage)
sudo apt install -y ncdu

# Analyser l'utilisation du disque
ncdu /

# Analyser un dossier spécifique
ncdu ~/projects
```

### Installer iotop (monitoring I/O)

```bash
# Installer iotop
sudo apt install -y iotop

# Lancer iotop
sudo iotop
```

## 2. Monitoring Docker avec ctop

### Installer ctop

```bash
# Télécharger ctop
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 \
    -O /usr/local/bin/ctop

# Rendre exécutable
sudo chmod +x /usr/local/bin/ctop

# Lancer ctop
ctop
```

**Raccourcis ctop :**
- `a` : Afficher tous les containers (même arrêtés)
- `s` : Trier
- `h` : Aide
- `q` : Quitter

## 3. Configuration de Netdata (monitoring avancé)

### Installation de Netdata

```bash
# Installer les dépendances
sudo apt install -y curl

# Installer Netdata (installation automatique)
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait

# OU installation manuelle avec plus de contrôle
wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh
```

### Configuration de Netdata

```bash
# Éditer la configuration principale
sudo nano /etc/netdata/netdata.conf
```

**Modifications recommandées :**

```ini
[global]
    # Limiter l'accès à localhost uniquement (sécurité)
    bind to = 127.0.0.1

    # Historique (1 heure par défaut, augmenter si besoin)
    history = 3600

[web]
    # Port d'écoute
    default port = 19999

    # Activer la compression
    enable gzip compression = yes
```

### Sécuriser l'accès à Netdata

#### Option 1 : Accès via tunnel SSH

**Depuis votre machine Windows (PowerShell) :**

```powershell
# Créer un tunnel SSH
ssh -L 19999:localhost:19999 votrenom@37.59.123.9

# Puis ouvrir dans le navigateur : http://localhost:19999
```

#### Option 2 : Nginx reverse proxy avec authentification

```bash
# Installer apache2-utils pour htpasswd
sudo apt install -y apache2-utils

# Créer un fichier de mots de passe
sudo htpasswd -c /etc/nginx/.htpasswd admin
```

**Créer la configuration Nginx pour Netdata :**

```bash
sudo nano /etc/nginx/sites-available/netdata
```

**Contenu :**

```nginx
server {
    listen 80;
    server_name monitoring.votredomaine.com;  # OU 37.59.123.9

    location /netdata/ {
        auth_basic "Monitoring Protégé";
        auth_basic_user_file /etc/nginx/.htpasswd;

        proxy_pass http://127.0.0.1:19999/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

```bash
# Activer la configuration
sudo ln -s /etc/nginx/sites-available/netdata /etc/nginx/sites-enabled/

# Tester la configuration
sudo nginx -t

# Recharger Nginx
sudo systemctl reload nginx

# Autoriser le port dans UFW si nécessaire
sudo ufw allow 'Nginx Full'
```

### Accéder à Netdata

- Via tunnel SSH : `http://localhost:19999`
- Via Nginx : `http://37.59.123.9/netdata/` (avec authentification)

## 4. Monitoring Docker avec Prometheus + Grafana (optionnel avancé)

### docker-compose.monitoring.yml

```bash
cd ~/projects/annuaire-maires
nano docker-compose.monitoring.yml
```

**Contenu :**

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    ports:
      - "127.0.0.1:9090:9090"
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=VotreMotDePasseSecurise123!
      - GF_USERS_ALLOW_SIGN_UP=false
    ports:
      - "127.0.0.1:3000:3000"
    networks:
      - monitoring
    depends_on:
      - prometheus

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - "127.0.0.1:9100:9100"
    networks:
      - monitoring

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    privileged: true
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports:
      - "127.0.0.1:8080:8080"
    networks:
      - monitoring

volumes:
  prometheus_data:
  grafana_data:

networks:
  monitoring:
    driver: bridge
```

### Configuration Prometheus

```bash
mkdir -p monitoring
nano monitoring/prometheus.yml
```

**Contenu :**

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  # Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter (métriques système)
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']

  # cAdvisor (métriques Docker)
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

### Démarrer le stack de monitoring

```bash
# Démarrer les services de monitoring
docker compose -f docker-compose.monitoring.yml up -d

# Vérifier le statut
docker compose -f docker-compose.monitoring.yml ps
```

### Accéder aux interfaces

**Via tunnel SSH (depuis Windows) :**

```powershell
# Tunnel pour Grafana
ssh -L 3000:localhost:3000 votrenom@37.59.123.9

# Tunnel pour Prometheus
ssh -L 9090:localhost:9090 votrenom@37.59.123.9
```

- **Grafana** : `http://localhost:3000` (admin / VotreMotDePasseSecurise123!)
- **Prometheus** : `http://localhost:9090`

### Configurer Grafana

1. Se connecter à Grafana (`http://localhost:3000`)
2. Aller dans **Configuration** → **Data Sources**
3. Cliquer sur **Add data source**
4. Sélectionner **Prometheus**
5. URL : `http://prometheus:9090`
6. Cliquer sur **Save & Test**

**Importer des dashboards :**

1. Aller dans **Dashboards** → **Import**
2. Importer les dashboards suivants (par ID) :
   - **1860** : Node Exporter Full
   - **193** : Docker Monitoring
   - **11074** : Node Exporter for Prometheus

## 5. Surveillance des logs

### Configurer journalctl

```bash
# Voir tous les logs système
sudo journalctl

# Logs en temps réel
sudo journalctl -f

# Logs d'un service spécifique
sudo journalctl -u docker
sudo journalctl -u nginx

# Logs depuis aujourd'hui
sudo journalctl --since today

# Logs des dernières 2 heures
sudo journalctl --since "2 hours ago"

# Logs avec niveau de priorité
sudo journalctl -p err  # Erreurs uniquement
```

### Script d'analyse des logs

```bash
nano ~/scripts/monitoring/analyze-logs.sh
```

**Contenu :**

```bash
#!/bin/bash

LOG_FILE="/home/$(whoami)/logs/log-analysis-$(date +%Y%m%d).log"

{
    echo "========================================="
    echo " 📋 ANALYSE DES LOGS"
    echo " Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================="
    echo ""

    echo "🔴 ERREURS SYSTÈME (24h)"
    sudo journalctl -p err --since "24 hours ago" --no-pager | tail -20
    echo ""

    echo "🐳 ERREURS DOCKER (24h)"
    sudo journalctl -u docker --since "24 hours ago" --no-pager | grep -i error | tail -20
    echo ""

    echo "🌐 ERREURS NGINX (24h)"
    sudo journalctl -u nginx --since "24 hours ago" --no-pager | grep -i error | tail -20
    echo ""

    echo "🔒 TENTATIVES SSH ÉCHOUÉES (24h)"
    sudo journalctl --since "24 hours ago" --no-pager | grep "Failed password" | tail -20
    echo ""

    echo "🛡️  FAIL2BAN BANS (24h)"
    sudo journalctl -u fail2ban --since "24 hours ago" --no-pager | grep "Ban" | tail -20
    echo ""

    echo "========================================="
} > "$LOG_FILE"

cat "$LOG_FILE"
```

```bash
chmod +x ~/scripts/monitoring/analyze-logs.sh
```

## 6. Alertes par email (optionnel)

### Installer et configurer ssmtp

```bash
# Installer ssmtp
sudo apt install -y ssmtp mailutils

# Configurer ssmtp
sudo nano /etc/ssmtp/ssmtp.conf
```

**Configuration pour Gmail :**

```
root=votre.email@gmail.com
mailhub=smtp.gmail.com:587
AuthUser=votre.email@gmail.com
AuthPass=VotreMotDePasseApplication
UseSTARTTLS=YES
FromLineOverride=YES
```

**Note** : Pour Gmail, créez un "mot de passe d'application" dans les paramètres de sécurité.

### Tester l'envoi d'email

```bash
# Envoyer un email de test
echo "Test de mail depuis le VPS" | mail -s "Test VPS" votre.email@gmail.com
```

### Script d'alerte

```bash
nano ~/scripts/monitoring/send-alert.sh
```

**Contenu :**

```bash
#!/bin/bash

ALERT_EMAIL="votre.email@gmail.com"
SUBJECT="$1"
MESSAGE="$2"

echo "$MESSAGE" | mail -s "[$HOSTNAME] $SUBJECT" "$ALERT_EMAIL"
```

```bash
chmod +x ~/scripts/monitoring/send-alert.sh
```

### Modifier les scripts pour envoyer des alertes

**Exemple dans check-resources.sh :**

```bash
alert() {
    log "🚨 ALERTE: $1"
    /home/$(whoami)/scripts/monitoring/send-alert.sh "Alerte Ressources" "$1"
}
```

## 7. Maintenance régulière

### Checklist de maintenance quotidienne

```bash
# 1. Vérifier les containers
docker compose ps

# 2. Vérifier les ressources
htop

# 3. Vérifier l'espace disque
df -h

# 4. Vérifier les logs récents
docker compose logs --tail=50

# 5. Vérifier les backups
ls -lh ~/backups/database/ | tail -5
```

### Checklist de maintenance hebdomadaire

```bash
# 1. Analyser les logs
~/scripts/monitoring/analyze-logs.sh

# 2. Vérifier les mises à jour
sudo apt update
apt list --upgradable

# 3. Nettoyer Docker
~/scripts/maintenance/cleanup-docker.sh

# 4. Vérifier le firewall
sudo ufw status

# 5. Vérifier Fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

### Checklist de maintenance mensuelle

```bash
# 1. Mettre à jour le système
~/scripts/maintenance/update-system.sh

# 2. Vérifier les certificats SSL (si utilisés)
# À adapter selon votre configuration

# 3. Tester la restauration d'un backup
# ~/scripts/backup/restore-database.sh [backup_file]

# 4. Analyser l'utilisation du disque
ncdu /

# 5. Revoir les logs UFW
sudo tail -100 /var/log/ufw.log

# 6. Vérifier les services au démarrage
systemctl list-unit-files --state=enabled
```

## 8. Tableaux de bord et rapports

### Créer un dashboard personnalisé

```bash
nano ~/scripts/monitoring/dashboard.sh
```

**Contenu :**

```bash
#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         📊 TABLEAU DE BORD VPS - ANNUAIRE MAIRES       ║${NC}"
echo -e "${BLUE}║         $(date '+%Y-%m-%d %H:%M:%S')                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Système
echo -e "${YELLOW}🖥️  SYSTÈME${NC}"
echo "Uptime          : $(uptime -p)"
echo "Load Average    : $(uptime | awk -F'load average:' '{print $2}')"
echo ""

# Ressources
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEM_USAGE=$(free | grep Mem | awk '{printf "%.1f", ($3/$2) * 100}')
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}')

echo -e "${YELLOW}💾 RESSOURCES${NC}"
printf "CPU             : %.1f%%\n" "$CPU_USAGE"
printf "Mémoire         : %.1f%%\n" "$MEM_USAGE"
echo "Disque          : $DISK_USAGE"
echo ""

# Docker
echo -e "${YELLOW}🐳 DOCKER CONTAINERS${NC}"
docker compose ps --format "table {{.Service}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Backups
echo -e "${YELLOW}💾 DERNIERS BACKUPS${NC}"
ls -lh ~/backups/database/*.sql.gz 2>/dev/null | tail -3 | awk '{print $9, "-", $5}'
echo ""

# Sécurité
echo -e "${YELLOW}🛡️  SÉCURITÉ${NC}"
FAIL2BAN_BANNED=$(sudo fail2ban-client status sshd 2>/dev/null | grep "Currently banned" | awk '{print $4}')
echo "IPs bannies     : ${FAIL2BAN_BANNED:-0}"
echo ""

# Site web
echo -e "${YELLOW}🌐 APPLICATION${NC}"
if curl -f -s http://localhost > /dev/null; then
    echo -e "Statut          : ${GREEN}✓ Accessible${NC}"
else
    echo -e "Statut          : ${RED}✗ Inaccessible${NC}"
fi
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
```

```bash
chmod +x ~/scripts/monitoring/dashboard.sh
```

### Créer un alias pour accès rapide

```bash
# Ajouter à ~/.bashrc
echo "alias dashboard='~/scripts/monitoring/dashboard.sh'" >> ~/.bashrc
source ~/.bashrc

# Utilisation
dashboard
```

## 9. Optimisation des performances

### Optimiser MySQL

```bash
# Se connecter au container MySQL
docker exec -it mysql_prod bash

# Lancer mysql
mysql -u root -p

# Vérifier la configuration
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'max_connections';

# Analyser les requêtes lentes
SHOW VARIABLES LIKE 'slow_query_log';
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

### Optimiser PHP-FPM

**Éditer le Dockerfile PHP ou créer un fichier de configuration :**

```dockerfile
# Dans php/Dockerfile, ajouter :
RUN { \
    echo 'pm = dynamic'; \
    echo 'pm.max_children = 20'; \
    echo 'pm.start_servers = 5'; \
    echo 'pm.min_spare_servers = 3'; \
    echo 'pm.max_spare_servers = 10'; \
    echo 'pm.max_requests = 500'; \
} > /usr/local/etc/php-fpm.d/zz-custom.conf
```

### Optimiser Nginx

```bash
# Éditer la configuration Nginx
sudo nano /etc/nginx/nginx.conf
```

**Ajouts recommandés :**

```nginx
http {
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;

    # Keep-alive
    keepalive_timeout 65;
    keepalive_requests 100;

    # File cache
    open_file_cache max=1000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
}
```

## ✅ Checklist

- [ ] htop, ncdu, iotop installés
- [ ] ctop installé pour Docker
- [ ] Netdata installé et configuré
- [ ] Accès sécurisé à Netdata via SSH ou Nginx
- [ ] Prometheus + Grafana installés (optionnel)
- [ ] Scripts d'analyse des logs créés
- [ ] Alertes email configurées (optionnel)
- [ ] Checklists de maintenance établies
- [ ] Dashboard personnalisé créé
- [ ] Optimisations appliquées

## 🔜 Étape suivante

Passer à [09-troubleshooting.md](09-troubleshooting.md) pour la résolution des problèmes courants.

## 📝 Notes

- **Surveiller** régulièrement les métriques système
- **Réagir** rapidement aux alertes
- **Documenter** les incidents et leurs résolutions
- **Optimiser** progressivement selon les besoins réels
