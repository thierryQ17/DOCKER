# 04 - Structure du Projet

## 🎯 Objectifs
- Organiser les dossiers du projet sur le VPS
- Adapter le docker-compose.yml pour la production
- Configurer Nginx comme reverse proxy
- Préparer les fichiers de configuration

## 📋 Prérequis
- Git configuré (étape 03 complétée)
- Dépôt cloné ou à cloner

## 1. Structure des dossiers recommandée

```bash
# Se placer dans le dossier home
cd ~

# Créer la structure
mkdir -p projects/annuaire-maires
mkdir -p backups/database
mkdir -p logs
```

**Arborescence finale :**

```
/home/votrenom/
├── projects/
│   └── annuaire-maires/          # Votre projet principal
│       ├── docker-compose.yml
│       ├── .env
│       ├── .gitignore
│       ├── nginx/
│       │   └── conf.d/
│       │       └── default.conf
│       ├── php/
│       │   └── Dockerfile
│       ├── www/
│       │   └── Annuaire/
│       │       ├── maires.php
│       │       ├── api.php
│       │       └── ...
│       └── deploy.sh
├── backups/
│   └── database/
└── logs/
```

## 2. Cloner ou transférer le projet

### Option A : Cloner depuis GitHub

```bash
cd ~/projects
git clone git@github.com:votre-username/annuaire-maires.git
cd annuaire-maires
```

### Option B : Transférer depuis votre machine locale

**Sur votre machine Windows (PowerShell) :**

```powershell
# Depuis le dossier du projet local
cd "C:\DEV POWERSHELL\DOCKER"

# Transférer avec SCP
scp -r www/ votrenom@37.59.123.9:~/projects/annuaire-maires/
scp docker-compose.yml votrenom@37.59.123.9:~/projects/annuaire-maires/
```

## 3. Créer le docker-compose.yml pour production

```bash
cd ~/projects/annuaire-maires
nano docker-compose.yml
```

**Contenu adapté pour production :**

```yaml
version: '3.8'

services:
  # PHP-FPM
  php_fpm:
    build:
      context: ./php
      dockerfile: Dockerfile
    container_name: php_fpm_prod
    restart: unless-stopped
    volumes:
      - ./www:/var/www/html
    networks:
      - app_network
    depends_on:
      - mysql_db
    environment:
      - PHP_FPM_PM=dynamic
      - PHP_FPM_PM_MAX_CHILDREN=20
      - PHP_FPM_PM_START_SERVERS=2
      - PHP_FPM_PM_MIN_SPARE_SERVERS=1
      - PHP_FPM_PM_MAX_SPARE_SERVERS=3

  # Nginx
  nginx:
    image: nginx:alpine
    container_name: nginx_prod
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./www:/var/www/html:ro
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
      - ./logs/nginx:/var/log/nginx
    networks:
      - app_network
    depends_on:
      - php_fpm

  # MySQL
  mysql_db:
    image: mysql:8.0
    container_name: mysql_prod
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
      - ./backups/database:/backups
    networks:
      - app_network
    ports:
      - "127.0.0.1:3306:3306"  # Accessible uniquement en local
    command: --default-authentication-plugin=mysql_native_password

volumes:
  mysql_data:
    driver: local

networks:
  app_network:
    driver: bridge
```

## 4. Créer le Dockerfile PHP personnalisé

```bash
mkdir -p php
nano php/Dockerfile
```

**Contenu :**

```dockerfile
FROM php:8.2-fpm

# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo \
        pdo_mysql \
        mysqli \
        zip \
        intl \
        opcache

# Configuration PHP pour production
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache.ini

# Configuration PHP
RUN { \
    echo 'max_execution_time=300'; \
    echo 'memory_limit=256M'; \
    echo 'upload_max_filesize=20M'; \
    echo 'post_max_size=20M'; \
    echo 'display_errors=Off'; \
    echo 'error_reporting=E_ALL & ~E_DEPRECATED & ~E_STRICT'; \
    echo 'log_errors=On'; \
    echo 'error_log=/var/log/php_errors.log'; \
} > /usr/local/etc/php/conf.d/custom.ini

WORKDIR /var/www/html

EXPOSE 9000
```

## 5. Configuration Nginx

```bash
mkdir -p nginx/conf.d
nano nginx/conf.d/default.conf
```

**Contenu :**

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name 37.59.123.9;  # Remplacer par votre nom de domaine si vous en avez un

    root /var/www/html/Annuaire;
    index index.php index.html index.htm;

    # Logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log warn;

    # Sécurité : masquer la version de Nginx
    server_tokens off;

    # Taille maximale des uploads
    client_max_body_size 20M;

    # Gestion des fichiers statiques
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Bloquer l'accès aux fichiers sensibles
    location ~ /\.(?!well-known) {
        deny all;
    }

    location ~ /\.env {
        deny all;
    }

    location ~ /\.git {
        deny all;
    }

    # Traitement PHP
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass php_fpm_prod:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param PHP_VALUE "upload_max_filesize=20M \n post_max_size=20M";
        include fastcgi_params;

        # Timeouts
        fastcgi_read_timeout 300;
        fastcgi_send_timeout 300;
    }

    # Route par défaut
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Bloquer les requêtes vers wp-login.php (éviter les scans)
    location ~ /wp-login\.php {
        deny all;
    }
}
```

## 6. Créer le fichier .env

```bash
nano .env
```

**Contenu :**

```env
# Base de données MySQL
MYSQL_ROOT_PASSWORD=VotreMotDePasseRootTresSecurise123!
MYSQL_DATABASE=annuairesMairesDeFrance
MYSQL_USER=appuser
MYSQL_PASSWORD=VotreMotDePasseUserTresSecurise456!

# Application
APP_ENV=production
APP_DEBUG=false
APP_URL=http://37.59.123.9

# Timezone
TZ=Europe/Paris
```

**Sécuriser le fichier :**

```bash
chmod 600 .env
```

## 7. Mettre à jour .gitignore

```bash
nano .gitignore
```

**Contenu :**

```
# Environment files
.env
.env.local
.env.*.local

# Logs
logs/
*.log

# Backups
backups/

# Docker volumes data
mysql_data/

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Temporary files
*.tmp
*~
```

## 8. Créer le script de déploiement

```bash
nano deploy.sh
```

**Contenu :**

```bash
#!/bin/bash

set -e  # Arrêter en cas d'erreur

echo "========================================="
echo " 🚀 Déploiement de l'application"
echo "========================================="

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Vérifier qu'on est dans le bon dossier
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}Erreur: docker-compose.yml non trouvé${NC}"
    exit 1
fi

# Pull les dernières modifications
echo -e "${YELLOW}📥 Pull des modifications Git...${NC}"
git pull origin master || { echo -e "${RED}Erreur lors du git pull${NC}"; exit 1; }

# Arrêter les containers
echo -e "${YELLOW}⏹️  Arrêt des containers...${NC}"
docker compose down

# Rebuild et redémarrer
echo -e "${YELLOW}🔨 Build et démarrage des containers...${NC}"
docker compose up -d --build

# Attendre que les services soient prêts
echo -e "${YELLOW}⏳ Attente du démarrage des services...${NC}"
sleep 10

# Vérifier le statut
echo -e "${YELLOW}📊 Statut des containers:${NC}"
docker compose ps

# Vérifier les logs
echo -e "${YELLOW}📋 Derniers logs:${NC}"
docker compose logs --tail=20

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN} ✅ Déploiement terminé !${NC}"
echo -e "${GREEN}=========================================${NC}"

# Afficher l'URL
echo -e "Application disponible sur : ${GREEN}http://37.59.123.9${NC}"
```

**Rendre le script exécutable :**

```bash
chmod +x deploy.sh
```

## 9. Initialiser le dépôt Git (si nouveau projet)

```bash
# Initialiser Git
git init

# Ajouter les fichiers
git add .

# Premier commit
git commit -m "Initial commit - Configuration VPS production"

# Ajouter le remote
git remote add origin git@github.com:votre-username/annuaire-maires.git

# Push
git push -u origin master
```

## 10. Tester le déploiement

```bash
# Premier déploiement
./deploy.sh

# Vérifier que tout fonctionne
docker compose ps
docker compose logs -f

# Tester l'accès HTTP
curl http://localhost
```

## ✅ Checklist

- [ ] Structure de dossiers créée
- [ ] docker-compose.yml configuré pour production
- [ ] Dockerfile PHP créé
- [ ] Configuration Nginx créée
- [ ] Fichier .env créé et sécurisé
- [ ] .gitignore configuré
- [ ] Script deploy.sh créé et exécutable
- [ ] Dépôt Git initialisé (si nouveau)
- [ ] Premier déploiement testé

## 🔜 Étape suivante

Passer à [05-workflow-deploiement.md](05-workflow-deploiement.md) pour mettre en place le workflow complet.

## 📝 Notes

- **JAMAIS** commiter le fichier `.env` dans Git
- **Toujours** utiliser des mots de passe forts pour MySQL
- **Adapter** les chemins selon votre configuration
- **Tester** le déploiement avant de passer en production
