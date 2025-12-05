# Documentation Déploiement VPS OVH

Cette documentation décrit la procédure complète pour déployer votre application Docker sur un VPS OVH.

## 📚 Table des matières

1. [01-connexion-securisation.md](01-connexion-securisation.md) - Connexion initiale et sécurisation du VPS
2. [02-installation-docker.md](02-installation-docker.md) - Installation de Docker et Docker Compose
3. [03-configuration-git.md](03-configuration-git.md) - Configuration de Git et clés SSH
4. [04-structure-projet.md](04-structure-projet.md) - Organisation du projet et fichiers de configuration
5. [05-workflow-deploiement.md](05-workflow-deploiement.md) - Procédures de déploiement avec Git
6. [06-configuration-firewall.md](06-configuration-firewall.md) - Configuration du pare-feu UFW
7. [07-automatisation.md](07-automatisation.md) - Scripts d'automatisation et hooks Git
8. [08-monitoring-maintenance.md](08-monitoring-maintenance.md) - Surveillance et maintenance du serveur
9. [99-troubleshooting.md](99-troubleshooting.md) - Résolution de problèmes courants

## 🖥️ Informations VPS

- **Hostname**: vps-d2fe96de.vps.ovh.net
- **IPv4**: 37.59.123.9
- **IPv6**: 2001:41d0:305:2100::7d21
- **Utilisateur**: debian
- **OS**: Debian

## 🎯 Objectifs du projet

- Héberger l'application "Annuaire des Maires de France" avec Docker
- Utiliser Docker Compose pour gérer les services (PHP-FPM, Nginx, MySQL)
- Mettre en place un workflow de déploiement avec Git
- Sécuriser et monitorer le serveur

## 🚀 Démarrage rapide

```bash
# 1. Se connecter au VPS
ssh debian@37.59.123.9

# 2. Suivre les guides dans l'ordre numérique
# Commencer par 01-connexion-securisation.md

# 3. Une fois configuré, déployer avec :
cd ~/projects/annuaire-maires
./deploy.sh
```

## 📝 Notes importantes

- **Toujours** tester les commandes critiques avant de les exécuter en production
- **Sauvegarder** régulièrement la base de données
- **Documenter** toute modification de configuration
- **Ne jamais** committer les fichiers sensibles (.env, credentials)

## 🔗 Liens utiles

- [Documentation Docker](https://docs.docker.com/)
- [Documentation OVH VPS](https://help.ovhcloud.com/csm/fr-vps?id=kb_browse_cat&kb_category=bac9af63db3c9b50aa4ac87b1396197d)
- [Guide UFW](https://doc.ubuntu-fr.org/ufw)
