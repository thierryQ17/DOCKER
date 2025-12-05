# 09 - Troubleshooting - Résolution de Problèmes

## 🎯 Objectifs
- Diagnostiquer et résoudre les problèmes courants
- Comprendre les logs et messages d'erreur
- Récupérer d'incidents critiques
- Optimiser les performances

## 📋 Sommaire
1. [Problèmes de connexion SSH](#1-problèmes-de-connexion-ssh)
2. [Problèmes Docker](#2-problèmes-docker)
3. [Problèmes de base de données](#3-problèmes-de-base-de-données)
4. [Problèmes Nginx](#4-problèmes-nginx)
5. [Problèmes de performances](#5-problèmes-de-performances)
6. [Problèmes de firewall](#6-problèmes-de-firewall)
7. [Problèmes de stockage](#7-problèmes-de-stockage)
8. [Récupération après crash](#8-récupération-après-crash)

---

## 1. Problèmes de connexion SSH

### ❌ Erreur : "Connection refused"

**Symptômes :**
```
ssh: connect to host 37.59.123.9 port 22: Connection refused
```

**Diagnostic :**
```bash
# Vérifier si SSH est actif (depuis la console OVH)
sudo systemctl status sshd

# Vérifier le port d'écoute
sudo netstat -tulpn | grep ssh
```

**Solutions :**

```bash
# 1. Redémarrer SSH
sudo systemctl restart sshd

# 2. Vérifier le pare-feu
sudo ufw status
sudo ufw allow 22/tcp  # OU le port personnalisé

# 3. Vérifier la configuration SSH
sudo nano /etc/ssh/sshd_config
# S'assurer que : Port 22 (ou votre port)
#                 ListenAddress 0.0.0.0

# 4. Tester la configuration
sudo sshd -t

# 5. Redémarrer SSH
sudo systemctl restart sshd
```

### ❌ Erreur : "Permission denied (publickey)"

**Symptômes :**
```
Permission denied (publickey,password).
```

**Diagnostic :**
```bash
# Vérifier les clés SSH autorisées
cat ~/.ssh/authorized_keys

# Vérifier les permissions
ls -la ~/.ssh
# .ssh doit être 700
# authorized_keys doit être 600
```

**Solutions :**

```bash
# 1. Corriger les permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# 2. Vérifier le propriétaire
sudo chown -R $(whoami):$(whoami) ~/.ssh

# 3. Vérifier la configuration sshd
sudo nano /etc/ssh/sshd_config
# S'assurer que : PubkeyAuthentication yes

# 4. Vérifier les logs
sudo tail -f /var/log/auth.log
```

**Depuis Windows :**

```powershell
# Vérifier que la clé privée est utilisée
ssh -v votrenom@37.59.123.9
# L'option -v affiche les détails de connexion

# Spécifier explicitement la clé
ssh -i C:\Users\VotreNom\.ssh\id_ed25519 votrenom@37.59.123.9
```

### ❌ Connexion SSH lente

**Solutions :**

```bash
# Désactiver la résolution DNS inverse
sudo nano /etc/ssh/sshd_config
```

**Ajouter ou modifier :**
```
UseDNS no
```

```bash
sudo systemctl restart sshd
```

---

## 2. Problèmes Docker

### ❌ Erreur : "Cannot connect to the Docker daemon"

**Symptômes :**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Diagnostic :**
```bash
# Vérifier que Docker est actif
sudo systemctl status docker

# Vérifier les permissions
groups $USER
```

**Solutions :**

```bash
# 1. Démarrer Docker
sudo systemctl start docker

# 2. Ajouter l'utilisateur au groupe docker
sudo usermod -aG docker $USER

# 3. Se reconnecter ou recharger les groupes
newgrp docker

# 4. Redémarrer Docker si nécessaire
sudo systemctl restart docker
```

### ❌ Container qui redémarre constamment

**Symptômes :**
```bash
docker compose ps
# STATUS: Restarting (1) Less than a second ago
```

**Diagnostic :**

```bash
# Voir les logs du container
docker compose logs nom_du_service

# Voir les derniers logs
docker compose logs --tail=50 nom_du_service

# Suivre les logs en temps réel
docker compose logs -f nom_du_service
```

**Solutions courantes :**

**Pour PHP-FPM :**
```bash
# Vérifier la syntaxe PHP
docker exec php_fpm_prod php -l /var/www/html/Annuaire/maires.php

# Vérifier les extensions PHP
docker exec php_fpm_prod php -m
```

**Pour MySQL :**
```bash
# Vérifier les logs MySQL
docker logs mysql_prod

# Problèmes de permissions sur le volume
sudo chown -R 999:999 mysql_data/
```

**Pour Nginx :**
```bash
# Tester la configuration
docker exec nginx_prod nginx -t

# Vérifier les logs d'erreur
docker logs nginx_prod
```

### ❌ Erreur : "Port already in use"

**Symptômes :**
```
Error starting userland proxy: listen tcp 0.0.0.0:80: bind: address already in use
```

**Diagnostic :**

```bash
# Identifier le processus qui utilise le port
sudo lsof -i :80
# OU
sudo netstat -tulpn | grep :80
```

**Solutions :**

```bash
# 1. Arrêter le processus concurrent
sudo systemctl stop nginx  # Si Nginx système est installé

# 2. OU changer le port dans docker-compose.yml
ports:
  - "8080:80"  # Utiliser le port 8080 au lieu de 80

# 3. Tuer le processus (dernier recours)
sudo kill -9 <PID>
```

### ❌ Espace disque insuffisant

**Symptômes :**
```
Error: No space left on device
```

**Diagnostic :**

```bash
# Vérifier l'espace disque
df -h

# Vérifier l'utilisation Docker
docker system df

# Voir les détails
docker system df -v
```

**Solutions :**

```bash
# 1. Nettoyer les ressources Docker
docker system prune -a --volumes

# 2. Supprimer les images non utilisées
docker image prune -a

# 3. Supprimer les volumes non utilisés
docker volume prune

# 4. Supprimer les containers arrêtés
docker container prune

# 5. Nettoyer les logs Docker
sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"
```

### ❌ Erreur de build Docker

**Symptômes :**
```
ERROR [internal] load metadata for docker.io/library/php:8.2-fpm
```

**Solutions :**

```bash
# 1. Vérifier la connexion internet
ping -c 3 google.com

# 2. Vider le cache Docker
docker builder prune -a

# 3. Rebuild sans cache
docker compose build --no-cache

# 4. Vérifier le Dockerfile
cat php/Dockerfile
```

---

## 3. Problèmes de base de données

### ❌ MySQL ne démarre pas

**Diagnostic :**

```bash
# Vérifier les logs MySQL
docker logs mysql_prod

# Erreurs courantes :
# - "mysqld: Can't create directory" → Permissions
# - "InnoDB: redo log file" → Corruption
```

**Solutions :**

```bash
# 1. Vérifier les permissions du volume
sudo chown -R 999:999 /var/lib/docker/volumes/<volume_name>/_data

# 2. Si corruption, restaurer un backup
docker compose down
docker volume rm annuaire-maires_mysql_data
docker compose up -d
# Puis restaurer : ~/scripts/backup/restore-database.sh [backup_file]
```

### ❌ Erreur : "Too many connections"

**Symptômes :**
```
SQLSTATE[HY000] [1040] Too many connections
```

**Diagnostic :**

```bash
# Se connecter à MySQL
docker exec -it mysql_prod mysql -u root -p

# Vérifier les connexions
SHOW PROCESSLIST;
SHOW STATUS WHERE Variable_name = 'Threads_connected';
SHOW VARIABLES WHERE Variable_name = 'max_connections';
```

**Solutions :**

```sql
-- Augmenter max_connections (temporaire)
SET GLOBAL max_connections = 200;

-- Tuer les connexions dormantes
SHOW PROCESSLIST;
KILL <id>;
```

**Solution permanente :**

```bash
# Éditer docker-compose.yml
nano docker-compose.yml
```

```yaml
mysql_db:
  command: --default-authentication-plugin=mysql_native_password --max_connections=200
```

```bash
docker compose down
docker compose up -d
```

### ❌ Base de données corrompue

**Symptômes :**
```
InnoDB: Database page corruption on disk or a failed file read
```

**Solutions :**

```bash
# 1. Arrêter MySQL
docker compose stop mysql_db

# 2. Restaurer le dernier backup
~/scripts/backup/restore-database.sh ~/backups/database/backup_<date>.sql.gz

# 3. Si pas de backup récent, tenter une réparation
docker exec -it mysql_prod mysqlcheck -u root -p --auto-repair --all-databases
```

### ❌ Requêtes lentes

**Diagnostic :**

```sql
-- Activer le slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;

-- Voir les requêtes lentes
SELECT * FROM mysql.slow_log ORDER BY query_time DESC LIMIT 10;
```

**Solutions :**

```sql
-- Vérifier les index
SHOW INDEX FROM nom_table;

-- Ajouter un index si nécessaire
ALTER TABLE nom_table ADD INDEX idx_colonne (colonne);

-- Analyser une requête
EXPLAIN SELECT * FROM ...;
```

---

## 4. Problèmes Nginx

### ❌ Erreur 502 Bad Gateway

**Symptômes :**
Navigateur affiche "502 Bad Gateway"

**Diagnostic :**

```bash
# Vérifier que PHP-FPM est actif
docker ps | grep php_fpm

# Vérifier les logs Nginx
docker logs nginx_prod

# Vérifier les logs PHP-FPM
docker logs php_fpm_prod
```

**Solutions :**

```bash
# 1. Redémarrer PHP-FPM
docker compose restart php_fpm

# 2. Vérifier la configuration Nginx
docker exec nginx_prod nginx -t

# 3. Vérifier que le nom du service correspond
# Dans nginx/conf.d/default.conf :
fastcgi_pass php_fpm_prod:9000;  # Doit correspondre au nom du container

# 4. Redémarrer tous les services
docker compose restart
```

### ❌ Erreur 404 Not Found

**Diagnostic :**

```bash
# Vérifier les logs
docker logs nginx_prod

# Vérifier le document root
docker exec nginx_prod ls -la /var/www/html/Annuaire/
```

**Solutions :**

```bash
# Vérifier la configuration Nginx
docker exec nginx_prod cat /etc/nginx/conf.d/default.conf

# S'assurer que :
# - root pointe vers le bon dossier
# - Les fichiers existent dans le volume monté
# - Les permissions sont correctes
```

### ❌ Fichiers statiques non chargés

**Solutions :**

```nginx
# Dans nginx/conf.d/default.conf
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
    root /var/www/html/Annuaire;
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

```bash
# Recharger Nginx
docker compose restart nginx
```

---

## 5. Problèmes de performances

### ❌ Site très lent

**Diagnostic :**

```bash
# Vérifier les ressources
htop

# Vérifier les containers Docker
ctop

# Vérifier les requêtes MySQL lentes
docker exec -it mysql_prod mysql -u root -p
SHOW PROCESSLIST;
```

**Solutions :**

**1. Optimiser PHP-FPM :**

```dockerfile
# Dans php/Dockerfile
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=256'; \
    echo 'opcache.max_accelerated_files=10000'; \
} > /usr/local/etc/php/conf.d/opcache.ini
```

**2. Optimiser MySQL :**

```yaml
# Dans docker-compose.yml
mysql_db:
  command: >
    --default-authentication-plugin=mysql_native_password
    --innodb_buffer_pool_size=512M
    --max_connections=100
```

**3. Activer le cache Nginx :**

```nginx
# Dans nginx/conf.d/default.conf
location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### ❌ Mémoire saturée

**Diagnostic :**

```bash
# Vérifier la mémoire
free -h

# Voir qui consomme
ps aux --sort=-%mem | head -10

# Vérifier les containers
docker stats
```

**Solutions :**

```bash
# 1. Limiter la mémoire des containers
# Dans docker-compose.yml
services:
  php_fpm:
    deploy:
      resources:
        limits:
          memory: 512M

# 2. Redémarrer les containers gourmands
docker compose restart php_fpm

# 3. Augmenter le swap (si nécessaire)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## 6. Problèmes de firewall

### ❌ Site inaccessible après activation UFW

**Diagnostic :**

```bash
# Vérifier les règles UFW
sudo ufw status numbered

# Vérifier que les ports sont autorisés
sudo ufw status | grep -E "80|443"
```

**Solutions :**

```bash
# 1. Autoriser HTTP et HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 2. Recharger UFW
sudo ufw reload

# 3. Si toujours bloqué, désactiver temporairement
sudo ufw disable
# Tester l'accès
sudo ufw enable
```

### ❌ Docker contourne UFW

**Solution :**

```bash
# Éditer /etc/ufw/after.rules
sudo nano /etc/ufw/after.rules
```

**Ajouter à la fin :**

```
# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:DOCKER-USER - [0:0]

-A DOCKER-USER -j ufw-user-forward
-A DOCKER-USER -j RETURN

COMMIT
# END UFW AND DOCKER
```

```bash
# Redémarrer
sudo systemctl restart ufw
sudo systemctl restart docker
```

---

## 7. Problèmes de stockage

### ❌ Disque plein

**Diagnostic :**

```bash
# Vérifier l'espace
df -h

# Trouver les gros fichiers
sudo du -h / | sort -rh | head -20

# Analyser avec ncdu
ncdu /
```

**Solutions :**

```bash
# 1. Nettoyer les logs
sudo journalctl --vacuum-time=7d
sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"

# 2. Nettoyer Docker
docker system prune -a --volumes

# 3. Nettoyer les anciens backups
find ~/backups/database -name "*.sql.gz" -mtime +30 -delete

# 4. Nettoyer APT
sudo apt autoremove -y
sudo apt autoclean
```

### ❌ Volume Docker corrompu

**Solutions :**

```bash
# 1. Arrêter les containers
docker compose down

# 2. Sauvegarder les données si possible
docker run --rm -v annuaire-maires_mysql_data:/data -v $(pwd):/backup ubuntu tar czf /backup/mysql-backup.tar.gz /data

# 3. Recréer le volume
docker volume rm annuaire-maires_mysql_data
docker compose up -d

# 4. Restaurer les données
~/scripts/backup/restore-database.sh [backup_file]
```

---

## 8. Récupération après crash

### ⚠️ Serveur inaccessible

**Via la console OVH (KVM) :**

1. Se connecter à la console OVH
2. Accéder au KVM (clavier/vidéo/souris virtuel)
3. Se connecter avec root ou votre utilisateur

```bash
# Vérifier les services critiques
systemctl status docker
systemctl status nginx
systemctl status sshd

# Redémarrer si nécessaire
systemctl restart docker
systemctl restart sshd
```

### ⚠️ Tous les containers sont arrêtés

```bash
cd ~/projects/annuaire-maires

# Vérifier l'état
docker compose ps -a

# Voir les logs pour comprendre
docker compose logs

# Redémarrer
docker compose up -d

# Si échec, rebuild
docker compose up -d --build --force-recreate
```

### ⚠️ Restauration complète depuis backup

```bash
# 1. Arrêter les services
docker compose down

# 2. Lister les backups disponibles
ls -lh ~/backups/database/

# 3. Restaurer la base de données
~/scripts/backup/restore-database.sh ~/backups/database/backup_<date>.sql.gz

# 4. Restaurer les fichiers si nécessaire
cd ~
tar -xzf ~/backups/files/files_<date>.tar.gz

# 5. Redémarrer
cd ~/projects/annuaire-maires
docker compose up -d

# 6. Vérifier
docker compose ps
curl http://localhost
```

---

## 9. Commandes de diagnostic rapide

### Script de diagnostic complet

```bash
nano ~/scripts/utils/diagnose.sh
```

**Contenu :**

```bash
#!/bin/bash

echo "========================================="
echo " 🔍 DIAGNOSTIC COMPLET DU SERVEUR"
echo "========================================="
echo ""

echo "📊 SYSTÈME"
echo "Uptime: $(uptime -p)"
echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
echo ""

echo "💾 RESSOURCES"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
echo "RAM: $(free -h | awk 'NR==2{printf "%s/%s (%.0f%%)", $3, $2, $3*100/$2}')"
echo "Disque: $(df -h / | awk 'NR==2{printf "%s/%s (%s)", $3, $2, $5}')"
echo ""

echo "🐳 DOCKER"
docker compose ps
echo ""

echo "🔥 FIREWALL"
sudo ufw status | head -10
echo ""

echo "🌐 CONNECTIVITÉ"
if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200"; then
    echo "Application: ✅ Accessible"
else
    echo "Application: ❌ Inaccessible"
fi
echo ""

echo "📋 DERNIÈRES ERREURS (5)"
sudo journalctl -p err --since "1 hour ago" --no-pager | tail -5
echo ""

echo "========================================="
```

```bash
chmod +x ~/scripts/utils/diagnose.sh
```

---

## ✅ Checklist de dépannage

Avant d'appeler au secours, vérifier :

- [ ] Les containers Docker sont actifs (`docker compose ps`)
- [ ] Les logs ne montrent pas d'erreurs (`docker compose logs`)
- [ ] Le disque n'est pas plein (`df -h`)
- [ ] Les services système sont actifs (`systemctl status docker`)
- [ ] Le firewall autorise les ports nécessaires (`sudo ufw status`)
- [ ] La connexion réseau fonctionne (`ping google.com`)
- [ ] Les backups existent et sont récents (`ls -lh ~/backups/database/`)

---

## 📝 Notes importantes

- **Toujours** faire un backup avant toute manipulation critique
- **Documenter** chaque incident et sa résolution
- **Tester** les solutions sur un environnement de test si possible
- **Ne pas** forcer les opérations destructives sans comprendre
- **Garder** une copie des fichiers de configuration importants

---

## 🆘 Contacts et ressources

- **Documentation Docker** : https://docs.docker.com/
- **Documentation OVH** : https://help.ovhcloud.com/
- **Stack Overflow** : https://stackoverflow.com/
- **Forums Docker** : https://forums.docker.com/

---

## 🔄 Retour au début

Pour une vue d'ensemble complète du projet, retourner à [README.md](README.md)
