📋 Ce que contient la roadmap :
# Phase 1 - ESSENTIEL (2-3h)
   Fichiers 01 à 04 uniquement
   Site en ligne et fonctionnel
   Sécurité de base

# Phase 2 - RECOMMANDÉ (1-2h)
   Fichier 06 (firewall)
   Fichier 07 (backups uniquement)
   Protection et sauvegardes

# Phases 3-4 - OPTIONNEL
   Seulement si vous en avez vraiment besoin
   Workflow avancé, monitoring, etc.

# Phase 5 - RÉFÉRENCE
   Troubleshooting à consulter en cas de problème
   
[Ma recommandation] : Commencer uniquement par la Phase 1 (fichiers 01-04). Une fois le site en ligne, vous verrez si vous avez besoin du reste. Êtes-vous prêt à démarrer la Phase 1 fichier par fichier ?

-------------------------------------------------------------------------

# 🗺️ ROADMAP - Plan de Déploiement Recommandé

## 📊 Vue d'ensemble

Ce document vous guide pour déployer votre application sur le VPS OVH **de manière progressive et pragmatique**, sans vous surcharger de tâches inutiles au démarrage.

---

## 🎯 Phase 1 : Déploiement Minimal Fonctionnel

**Objectif** : Site en ligne, accessible et sécurisé au minimum
**Durée estimée** : 2-3 heures
**Priorité** : 🔴 ESSENTIEL

### Étapes obligatoires

| Fichier | Titre | Temps | Pourquoi c'est indispensable |
|---------|-------|-------|------------------------------|
| [01-connexion-securisation.md](01-connexion-securisation.md) | Connexion et sécurisation | 45 min | ⚠️ Sans cela, votre serveur est vulnérable |
| [02-installation-docker.md](02-installation-docker.md) | Installation Docker | 30 min | 🐳 Docker est la base de votre application |
| [03-configuration-git.md](03-configuration-git.md) | Configuration Git | 30 min | 📦 Pour déployer et mettre à jour votre code |
| [04-structure-projet.md](04-structure-projet.md) | Structure du projet | 1h | 🏗️ Pour que l'application fonctionne |

### ✅ Checklist Phase 1

À la fin de cette phase, vous devez avoir :
- [ ] Connexion SSH sécurisée avec clés
- [ ] Utilisateur non-root créé
- [ ] fail2ban installé et actif
- [ ] Docker et Docker Compose fonctionnels
- [ ] Git configuré avec accès GitHub
- [ ] Application déployée et accessible via `http://37.59.123.9`
- [ ] Base de données MySQL opérationnelle
- [ ] Nginx servant correctement les pages

### 🧪 Test de validation Phase 1

```bash
# Sur le VPS, vérifier que tout fonctionne :
docker compose ps    # Tous les containers doivent être "Up"
curl http://localhost    # Doit afficher du HTML
docker exec mysql_prod mysql -u root -p -e "SHOW DATABASES;"    # Doit lister les bases
```

**Depuis votre navigateur** :
- Accéder à `http://37.59.123.9` → Doit afficher votre application

---

## 🛡️ Phase 2 : Sécurisation et Fiabilité

**Objectif** : Protéger le serveur et sauvegarder les données
**Durée estimée** : 1-2 heures
**Priorité** : 🟡 FORTEMENT RECOMMANDÉ
**Quand** : Dans les 2-3 jours suivant la Phase 1

### Étapes recommandées

| Fichier | Titre | Sections à suivre | Temps | Pourquoi |
|---------|-------|-------------------|-------|----------|
| [06-configuration-firewall.md](06-configuration-firewall.md) | Configuration UFW | Sections 1 à 5 | 45 min | 🔥 Protection réseau essentielle |
| [07-automatisation.md](07-automatisation.md) | Scripts de backup | Sections 1, 2 et 5 uniquement | 45 min | 💾 Sauvegardes automatiques des données |

### ✅ Checklist Phase 2

À la fin de cette phase, vous devez avoir :
- [ ] UFW installé et actif
- [ ] Ports HTTP (80) et HTTPS (443) autorisés
- [ ] Port SSH protégé avec rate limiting
- [ ] MySQL non accessible depuis Internet
- [ ] Script de backup base de données créé et testé
- [ ] Cron configuré pour backup quotidien à 2h00
- [ ] Au moins 1 backup de test créé et validé

### 🧪 Test de validation Phase 2

```bash
# Vérifier le firewall
sudo ufw status    # Doit afficher "active" et les règles

# Vérifier les backups
ls -lh ~/backups/database/    # Doit contenir au moins 1 fichier .sql.gz

# Tester la restauration
~/scripts/backup/restore-database.sh ~/backups/database/backup_XXXXX.sql.gz
```

---

## ⚙️ Phase 3 : Workflow et Déploiement Continu

**Objectif** : Faciliter les mises à jour
**Durée estimée** : 1-2 heures
**Priorité** : 🟢 OPTIONNEL
**Quand** : Si vous faites des mises à jour fréquentes (> 1 par semaine)

### Étapes optionnelles

| Fichier | Titre | Utilité |
|---------|-------|---------|
| [05-workflow-deploiement.md](05-workflow-deploiement.md) | Workflow Git | Si vous avez plusieurs environnements (dev/staging/prod) |

### Sections utiles du fichier 05

**À faire uniquement si besoin** :
- ✅ **Section 1** : Architecture des branches → Si vous travaillez en équipe
- ✅ **Section 4** : Script deploy.sh amélioré → Si vous déployez souvent
- ❌ **Section 3** : Déploiement automatique avec hooks → Avancé, pas indispensable
- ❌ **Section 8** : GitHub Actions → Avancé, pas indispensable

### ✅ Checklist Phase 3

À la fin de cette phase, vous devez avoir :
- [ ] Branches Git organisées (develop, production)
- [ ] Script deploy.sh fonctionnel
- [ ] Backup automatique avant chaque déploiement
- [ ] Procédure de rollback testée

---

## 📊 Phase 4 : Monitoring et Surveillance

**Objectif** : Surveiller le serveur et détecter les problèmes
**Durée estimée** : 2-3 heures
**Priorité** : 🟢 OPTIONNEL
**Quand** : Si votre site devient critique ou a beaucoup de trafic

### Étapes optionnelles

| Fichier | Titre | Utilité |
|---------|-------|---------|
| [07-automatisation.md](07-automatisation.md) | Scripts monitoring | Sections 3 et 4 uniquement |
| [08-monitoring-maintenance.md](08-monitoring-maintenance.md) | Monitoring avancé | Selon vos besoins |

### Outils recommandés (par ordre de complexité)

1. **Niveau basique** :
   - htop, ncdu, ctop (Section 1 du fichier 08)
   - Script check-resources.sh (Section 3 du fichier 07)

2. **Niveau intermédiaire** :
   - Netdata (Section 3 du fichier 08)
   - Alertes email (Section 6 du fichier 08)

3. **Niveau avancé** :
   - Prometheus + Grafana (Section 4 du fichier 08)
   - Dashboard personnalisé (Section 8 du fichier 08)

### ✅ Checklist Phase 4

Choisir **selon vos besoins** :
- [ ] htop installé pour monitoring manuel
- [ ] Script de vérification des ressources en cron (toutes les 15 min)
- [ ] Netdata installé et accessible (optionnel)
- [ ] Alertes email configurées (optionnel)
- [ ] Prometheus + Grafana (optionnel avancé)

---

## 🆘 Phase 5 : Troubleshooting

**Objectif** : Résoudre les problèmes quand ils surviennent
**Priorité** : 📘 DOCUMENTATION DE RÉFÉRENCE
**Quand** : **À consulter uniquement en cas de problème**

| Fichier | Utilité |
|---------|---------|
| [09-troubleshooting.md](09-troubleshooting.md) | Guide de dépannage à consulter si besoin |

**Ne PAS suivre ce fichier étape par étape**, mais le consulter comme une documentation de référence quand vous rencontrez un problème.

---

## 📅 Planning recommandé

### Semaine 1
- **Jour 1** : Phase 1 (fichiers 01-04) → Site en ligne
- **Jour 2** : Tests et validation du site
- **Jour 3** : Phase 2 (firewall + backups) → Sécurisation

### Semaine 2-4
- **Selon besoins** : Phase 3 (workflow) si mises à jour fréquentes
- **Optionnel** : Phase 4 (monitoring) si trafic important

### En continu
- Consulter Phase 5 (troubleshooting) en cas de problème
- Maintenance régulière (voir fichier 08, section 7)

---

## 🎓 Ce que vous pouvez IGNORER au début

### Sections non critiques du fichier 05 (Workflow)
- ❌ Hooks Git post-receive (section 3)
- ❌ GitHub Actions (section 8)
- ❌ Tags et versions (section 5) → Utile plus tard

### Sections non critiques du fichier 07 (Automatisation)
- ❌ Scripts de monitoring (section 3) → Uniquement si trafic important
- ❌ Scripts de maintenance avancée (section 4)
- ❌ Rotation des logs (section 8) → Le système le fait déjà par défaut

### Sections non critiques du fichier 08 (Monitoring)
- ❌ Prometheus + Grafana (section 4) → Complexe, inutile au début
- ❌ Alertes email (section 6) → Optionnel
- ❌ Optimisation avancée (section 9) → Uniquement si problèmes de performance

---

## 🚦 Comment choisir ?

### Faire la Phase 1 si :
✅ Vous voulez juste mettre votre site en ligne

### Ajouter la Phase 2 si :
✅ Vous avez des données importantes
✅ Vous ne voulez pas tout perdre en cas de problème

### Ajouter la Phase 3 si :
✅ Vous faites des mises à jour régulières (> 1/semaine)
✅ Vous travaillez en équipe
✅ Vous voulez un workflow professionnel

### Ajouter la Phase 4 si :
✅ Votre site a du trafic important
✅ Vous devez garantir une disponibilité élevée
✅ Vous voulez anticiper les problèmes
✅ Vous êtes curieux et voulez apprendre

---

## 💡 Conseils pratiques

### ✅ À FAIRE
- Commencer par la Phase 1
- Tester chaque étape avant de passer à la suivante
- Faire des backups avant toute manipulation importante
- Documenter vos propres notes au fur et à mesure

### ❌ À ÉVITER
- Vouloir tout faire d'un coup
- Sauter des étapes de la Phase 1
- Copier-coller sans comprendre
- Négliger les backups (Phase 2)

---

## 📞 Besoin d'aide ?

Si vous êtes bloqué, consultez :
1. **D'abord** : [09-troubleshooting.md](09-troubleshooting.md) pour votre problème spécifique
2. **Ensuite** : Les logs Docker (`docker compose logs`)
3. **Enfin** : Les forums Docker, Stack Overflow, etc.

---

## 🎯 Résumé ultra-rapide

| Phase | Fichiers | Temps | Quand | Priorité |
|-------|----------|-------|-------|----------|
| **Phase 1** | 01-02-03-04 | 2-3h | Maintenant | 🔴 OBLIGATOIRE |
| **Phase 2** | 06 + 07 (backups) | 1-2h | Jours suivants | 🟡 RECOMMANDÉ |
| **Phase 3** | 05 | 1-2h | Si besoin | 🟢 OPTIONNEL |
| **Phase 4** | 07-08 (monitoring) | 2-3h | Si besoin | 🟢 OPTIONNEL |
| **Phase 5** | 09 | - | En cas de problème | 📘 RÉFÉRENCE |

---

**👉 Prêt à commencer ? Passez au fichier [01-connexion-securisation.md](01-connexion-securisation.md)**
