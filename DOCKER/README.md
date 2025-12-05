# Environnement Docker NGINX + PHP + MySQL + PHPMyAdmin

## Structure des dossiers

```
DOCKER/
├── docker-compose.yml
├── nginx/
│   └── conf.d/
│       └── default.conf
├── php/
│   └── Dockerfile
├── mysql/
│   ├── data/           (données MySQL)
│   └── init/
│       └── 01-init.sql
└── www/
    └── index.php
```

## Démarrage

Pour démarrer l'environnement complet:

```bash
docker-compose up -d
```

Pour construire et démarrer (si modifications):

```bash
docker-compose up -d --build
```

## Accès aux services

- **Application web**: http://localhost:81
- **PHPMyAdmin**: http://localhost:8080
- **MySQL**: localhost:3306

## Identifiants MySQL

- **Root**: root / root
- **Utilisateur**: testuser / testpass
- **Base de données**: TEST

## Commandes utiles

Arrêter les conteneurs:
```bash
docker-compose down
```

Voir les logs:
```bash
docker-compose logs -f
```

Redémarrer un service:
```bash
docker-compose restart nginx
```

Supprimer tout (y compris les volumes):
```bash
docker-compose down -v
```

## Fonctionnalités

Le formulaire PHP permet de:
- Saisir des informations (nom, email, message)
- Enregistrer dans la base de données TEST
- Afficher la liste des utilisateurs enregistrés
- Accéder à PHPMyAdmin pour gérer la base
