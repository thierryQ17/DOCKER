# Récapitulatif des Commandes VPS - UPR - Parrainage 2027 - Annuaire des Maires de France

Synchronisation sur 37.59.123.9
cd "C:\DEV POWERSHELL\DOCKER\www"
scp -r Annuaire/*.php Annuaire/*.css Annuaire/*.html Annuaire/ressources Qiou17@37.59.123.9:~/projects/annuaire-maires/www/Annuaire/

****** on exclu le répertoire data avec csv, json xlsx
cd "C:\DEV POWERSHELL\DOCKER\www"
Get-ChildItem -Path Annuaire -Recurse | Where-Object { -not $_.PSIsContainer -and $_.FullName -notlike "*\Annuaire\data\*" } | ForEach-Object {
    $dest = $_.FullName -replace [regex]::Escape("C:\DEV POWERSHELL\DOCKER\www\"), ""
    scp $_.FullName "Qiou17@37.59.123.9:~/projects/annuaire-maires/www/$dest"
}



## Informations de connexion

| Élément | Valeur |
|---------|--------|
| **IP VPS** | 37.59.123.9 |
| **Utilisateur** | Qiou17 |
| **OS** | Debian 13 (trixie) |
| **Application** | http://37.59.123.9/maires.php |

---

## 1. Commandes depuis Windows (PowerShell)

### Connexion SSH
```powershell
# Connexion au VPS
ssh Qiou17@37.59.123.9
```

### Transfert de fichiers (SCP)
```powershell
# Transférer le dossier www vers le VPS
scp -r www Qiou17@37.59.123.9:~/projects/annuaire-maires/

# Transférer un fichier spécifique
scp docker-compose.yml Qiou17@37.59.123.9:~/projects/annuaire-maires/

# Transférer le backup de la base de données
scp $env:USERPROFILE\backup.sql Qiou17@37.59.123.9:~/projects/annuaire-maires/
```

### Commande tout-en-un (si vous préférez enchaîner depuis PowerShell) :
# Export + Transfer
docker exec mysql_db mysqldump -uroot -proot annuairesMairesDeFrance > $env:USERPROFILE\backup.sql; scp $env:USERPROFILE\backup.sql Qiou17@37.59.123.9:~/projects/annuaire-maires/

Puis sur le VPS via SSH :

docker exec -i mysql_prod mysql -uroot -proot annuairesMairesDeFrance < ~/projects/annuaire-maires/backup.sql

### Export de la base de données locale
```powershell
# Exporter la base depuis Docker local
docker exec mysql_db mysqldump -uroot -proot annuairesMairesDeFrance > $env:USERPROFILE\backup.sql
```

---

## 2. Commandes sur le VPS

### Navigation
```bash
# Aller dans le dossier du projet
cd ~/projects/annuaire-maires
```

### Docker Compose - Gestion des containers

```bash
# Démarrer les containers
docker compose up -d

# Démarrer avec rebuild des images
docker compose up -d --build

# Arrêter les containers
docker compose down

# Arrêter et supprimer les volumes (ATTENTION: perte de données)
docker compose down -v

# Voir le statut des containers
docker compose ps

# Voir les logs de tous les containers
docker compose logs

# Voir les logs d'un container spécifique
docker compose logs nginx
docker compose logs php
docker compose logs mysql

# Suivre les logs en temps réel
docker compose logs -f

# Redémarrer un container
docker compose restart nginx
docker compose restart php
docker compose restart mysql
```

### MySQL - Gestion de la base de données

```bash
# Importer un backup dans MySQL
docker exec -i mysql_prod mysql -uroot -proot annuairesMairesDeFrance < ~/projects/annuaire-maires/backup.sql

# Se connecter à MySQL en ligne de commande
docker exec -it mysql_prod mysql -uroot -proot

# Voir les bases de données
docker exec mysql_prod mysql -uroot -proot -e "SHOW DATABASES;"

# Voir les tables d'une base
docker exec mysql_prod mysql -uroot -proot -e "USE annuairesMairesDeFrance; SHOW TABLES;"

# Compter les enregistrements
docker exec mysql_prod mysql -uroot -proot -e "USE annuairesMairesDeFrance; SELECT COUNT(*) FROM maires;"

# Exporter la base (backup)
docker exec mysql_prod mysqldump -uroot -proot annuairesMairesDeFrance > ~/backups/backup_$(date +%Y%m%d).sql
```

### Fichiers et configuration

```bash
# Éditer un fichier
nano ~/projects/annuaire-maires/.env
nano ~/projects/annuaire-maires/nginx/conf.d/default.conf

# Voir le contenu d'un fichier
cat ~/projects/annuaire-maires/.env

# Rechercher du texte dans les fichiers
grep -r "testuser" ~/projects/annuaire-maires/www/
```

### Vérifications système

```bash
# Voir l'espace disque
df -h

# Voir la mémoire
free -h

# Voir les processus
htop

# Voir les ports ouverts
sudo netstat -tulpn

# Vérifier fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

---

## 3. Workflow de déploiement

### Mise à jour du code (depuis Windows)
```powershell
# 1. Transférer les fichiers modifiés
scp -r www Qiou17@37.59.123.9:~/projects/annuaire-maires/
```

### Sur le VPS après transfert
```bash
# 2. Se connecter et redémarrer si nécessaire
cd ~/projects/annuaire-maires
docker compose restart php
```

### Synchronisation de la base de données

**Depuis Windows :**
```powershell
# Exporter la base locale
docker exec mysql_db mysqldump -uroot -proot annuairesMairesDeFrance > $env:USERPROFILE\backup.sql

# Transférer vers VPS
scp $env:USERPROFILE\backup.sql Qiou17@37.59.123.9:~/projects/annuaire-maires/
```

**Sur le VPS :**
```bash
# Importer la base
docker exec -i mysql_prod mysql -uroot -proot annuairesMairesDeFrance < ~/projects/annuaire-maires/backup.sql
```

---

## 4. Configuration actuelle

### Fichier .env
```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=annuairesMairesDeFrance
MYSQL_USER=testuser
MYSQL_PASSWORD=testpass
```

### Structure des dossiers sur le VPS
```
/home/Qiou17/
└── projects/
    └── annuaire-maires/
        ├── docker-compose.yml
        ├── .env
        ├── backup.sql
        ├── php/
        │   └── Dockerfile
        ├── nginx/
        │   └── conf.d/
        │       └── default.conf
        └── www/
            └── Annuaire/
                ├── maires.php
                ├── api.php
                └── ...
```

### Containers Docker
| Container | Image | Ports |
|-----------|-------|-------|
| nginx_prod | nginx:alpine | 80:80 |
| php_fpm_prod | annuaire-maires-php | 9000 |
| mysql_prod | mysql:8.0 | 127.0.0.1:3306 |

---

## 5. Dépannage

### Container qui ne démarre pas
```bash
# Voir les logs détaillés
docker compose logs mysql
docker compose logs php
docker compose logs nginx

# Reconstruire complètement
docker compose down
docker compose up -d --build
```

### Erreur de connexion MySQL
```bash
# Vérifier que MySQL est prêt
docker compose logs mysql | tail -20

# Tester la connexion
docker exec mysql_prod mysql -uroot -proot -e "SELECT 1;"
```

### Erreur 500 sur le site
```bash
# Vérifier les logs PHP
docker compose logs php

# Vérifier que les tables existent
docker exec mysql_prod mysql -uroot -proot -e "USE annuairesMairesDeFrance; SHOW TABLES;"
```

### Réinitialisation complète
```bash
# ATTENTION: Supprime toutes les données !
cd ~/projects/annuaire-maires
docker compose down -v
docker compose up -d --build

# Puis réimporter la base
docker exec -i mysql_prod mysql -uroot -proot annuairesMairesDeFrance < ~/projects/annuaire-maires/backup.sql
```

---

## 6. Commandes utiles Git (si configuré)

```bash
# Voir le statut
git status

# Récupérer les modifications
git pull origin master

# Voir les derniers commits
git log --oneline -10
```

---

## 7. Sécurité

### fail2ban
```bash
# Statut
sudo fail2ban-client status sshd

# Voir les IP bannies
sudo fail2ban-client status sshd | grep "Banned IP"

# Débannir une IP
sudo fail2ban-client set sshd unbanip <IP>
```

### Mise à jour système
```bash
sudo apt update && sudo apt upgrade -y
```

---

## Aide-mémoire rapide

| Action | Commande |
|--------|----------|
| Connexion VPS | `ssh Qiou17@37.59.123.9` |
| Aller au projet | `cd ~/projects/annuaire-maires` |
| Voir les containers | `docker compose ps` |
| Voir les logs | `docker compose logs -f` |
| Redémarrer tout | `docker compose restart` |
| Importer DB | `docker exec -i mysql_prod mysql -uroot -proot annuairesMairesDeFrance < backup.sql` |

---

*Document créé le 22/11/2025*
