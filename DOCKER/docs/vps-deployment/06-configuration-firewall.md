# 06 - Configuration du Firewall UFW

## 🎯 Objectifs
- Installer et configurer UFW (Uncomplicated Firewall)
- Définir des règles de sécurité strictes
- Protéger les services exposés
- Gérer les accès autorisés

## 📋 Prérequis
- Accès SSH au VPS
- Docker et services déployés
- Compréhension des ports utilisés

## 1. Installation d'UFW

```bash
# Installer UFW
sudo apt update
sudo apt install -y ufw

# Vérifier la version
ufw version
```

## 2. Configuration de base

### ⚠️ IMPORTANT : Autoriser SSH AVANT d'activer UFW

```bash
# Autoriser SSH sur le port par défaut (22)
sudo ufw allow 22/tcp

# OU si vous avez changé le port SSH (exemple: 2222)
sudo ufw allow 2222/tcp
```

### Définir les politiques par défaut

```bash
# Bloquer tout le trafic entrant par défaut
sudo ufw default deny incoming

# Autoriser tout le trafic sortant par défaut
sudo ufw default allow outgoing

# Vérifier la configuration
sudo ufw status verbose
```

## 3. Règles pour les services web

### HTTP et HTTPS

```bash
# Autoriser HTTP (port 80)
sudo ufw allow 80/tcp

# Autoriser HTTPS (port 443)
sudo ufw allow 443/tcp

# OU utiliser les profils prédéfinis
sudo ufw allow 'Nginx Full'
# 'Nginx Full' = ports 80 et 443
# 'Nginx HTTP' = port 80 uniquement
# 'Nginx HTTPS' = port 443 uniquement
```

### Vérifier les profils disponibles

```bash
# Lister les profils d'applications
sudo ufw app list

# Afficher les détails d'un profil
sudo ufw app info 'Nginx Full'
```

## 4. Règles pour MySQL

### Bloquer MySQL depuis Internet (recommandé)

```bash
# MySQL ne doit PAS être accessible depuis Internet
# Laisser accessible uniquement en localhost (déjà configuré dans docker-compose.yml)
# Pas de règle UFW nécessaire
```

### Autoriser MySQL depuis des IPs spécifiques (si nécessaire)

```bash
# Autoriser depuis une IP spécifique
sudo ufw allow from 192.168.1.100 to any port 3306

# Autoriser depuis un sous-réseau
sudo ufw allow from 192.168.1.0/24 to any port 3306
```

## 5. Règles avancées

### Limiter les tentatives de connexion SSH

```bash
# Limiter les connexions SSH (protection contre brute-force)
sudo ufw limit ssh

# OU sur un port personnalisé
sudo ufw limit 2222/tcp
```

### Autoriser le ping (ICMP)

```bash
# Éditer le fichier de configuration
sudo nano /etc/ufw/before.rules
```

**Vérifier que ces lignes existent (normalement déjà présentes) :**

```
# ok icmp codes for INPUT
-A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-input -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-input -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT
```

### Bloquer une adresse IP spécifique

```bash
# Bloquer une IP malveillante
sudo ufw deny from 203.0.113.100

# Bloquer un sous-réseau
sudo ufw deny from 203.0.113.0/24
```

### Autoriser votre IP locale uniquement

```bash
# Autoriser SSH uniquement depuis votre IP fixe
sudo ufw allow from VOTRE_IP_PUBLIQUE to any port 2222 proto tcp

# Bloquer SSH pour toutes les autres IPs
sudo ufw deny 2222/tcp
```

## 6. Règles pour Docker

### Autoriser les réseaux Docker

```bash
# Autoriser les connexions sur le réseau Docker
sudo ufw allow from 172.17.0.0/16

# OU pour le réseau spécifique de votre application
sudo ufw allow from 172.18.0.0/16
```

### Configuration UFW avec Docker

**⚠️ IMPORTANT** : Par défaut, Docker peut contourner les règles UFW.

**Corriger ce comportement :**

```bash
# Éditer la configuration Docker
sudo nano /etc/docker/daemon.json
```

**Ajouter ou modifier :**

```json
{
  "iptables": true,
  "ip-forward": true,
  "ip-masq": true
}
```

**Éditer le fichier UFW pour Docker :**

```bash
sudo nano /etc/ufw/after.rules
```

**Ajouter à la fin du fichier :**

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
# Redémarrer UFW et Docker
sudo systemctl restart ufw
sudo systemctl restart docker
```

## 7. Activer et gérer UFW

### Activer UFW

```bash
# Activer le firewall
sudo ufw enable

# Confirmer avec 'y'
# Message : Firewall is active and enabled on system startup
```

### Vérifier le statut

```bash
# Statut général
sudo ufw status

# Statut détaillé
sudo ufw status verbose

# Statut numéroté (pour suppression)
sudo ufw status numbered
```

### Recharger UFW

```bash
# Recharger les règles
sudo ufw reload
```

### Désactiver temporairement UFW

```bash
# Désactiver (pas recommandé en production)
sudo ufw disable
```

## 8. Gestion des règles

### Supprimer une règle

```bash
# Méthode 1 : Par numéro
sudo ufw status numbered
sudo ufw delete 5  # Supprimer la règle numéro 5

# Méthode 2 : Par description
sudo ufw delete allow 80/tcp
```

### Insérer une règle à une position spécifique

```bash
# Insérer une règle en première position
sudo ufw insert 1 allow from 192.168.1.100 to any port 22
```

### Réinitialiser toutes les règles

```bash
# Réinitialiser UFW (supprime toutes les règles)
sudo ufw reset
```

## 9. Logging et surveillance

### Activer les logs

```bash
# Activer le logging
sudo ufw logging on

# Définir le niveau de log
sudo ufw logging low     # Minimal
sudo ufw logging medium  # Recommandé
sudo ufw logging high    # Verbeux
sudo ufw logging full    # Tout
```

### Consulter les logs

```bash
# Voir les logs en temps réel
sudo tail -f /var/log/ufw.log

# Voir les dernières connexions bloquées
sudo grep -i block /var/log/ufw.log | tail -20

# Voir les connexions autorisées
sudo grep -i allow /var/log/ufw.log | tail -20
```

### Analyser les tentatives d'intrusion

```bash
# Compter les tentatives par IP
sudo awk '/BLOCK/ {print $11}' /var/log/ufw.log | sort | uniq -c | sort -nr | head -10

# Voir les ports les plus scannés
sudo awk '/BLOCK/ {print $9}' /var/log/ufw.log | sort | uniq -c | sort -nr | head -10
```

## 10. Configuration complète recommandée

### Script de configuration UFW

```bash
nano ~/scripts/configure-firewall.sh
```

**Contenu :**

```bash
#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW} 🛡️  Configuration UFW${NC}"
echo -e "${YELLOW}=========================================${NC}"

# Vérifier si UFW est installé
if ! command -v ufw &> /dev/null; then
    echo -e "${RED}UFW n'est pas installé${NC}"
    exit 1
fi

# Désactiver UFW temporairement
echo -e "${YELLOW}Désactivation temporaire d'UFW...${NC}"
sudo ufw --force disable

# Réinitialiser UFW
echo -e "${YELLOW}Réinitialisation des règles...${NC}"
sudo ufw --force reset

# Politiques par défaut
echo -e "${YELLOW}Configuration des politiques par défaut...${NC}"
sudo ufw default deny incoming
sudo ufw default allow outgoing

# SSH (adapter le port si nécessaire)
SSH_PORT="${1:-22}"
echo -e "${YELLOW}Autorisation SSH sur le port $SSH_PORT...${NC}"
sudo ufw limit $SSH_PORT/tcp comment 'SSH with rate limiting'

# HTTP et HTTPS
echo -e "${YELLOW}Autorisation HTTP/HTTPS...${NC}"
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Réseau Docker
echo -e "${YELLOW}Autorisation réseau Docker...${NC}"
sudo ufw allow from 172.17.0.0/16 comment 'Docker network'

# Logging
echo -e "${YELLOW}Activation du logging...${NC}"
sudo ufw logging medium

# Activer UFW
echo -e "${YELLOW}Activation d'UFW...${NC}"
sudo ufw --force enable

# Afficher le statut
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN} ✅ Configuration terminée${NC}"
echo -e "${GREEN}=========================================${NC}"
sudo ufw status verbose

echo -e "${YELLOW}⚠️  Testez votre connexion SSH avant de fermer cette session !${NC}"
```

```bash
chmod +x ~/scripts/configure-firewall.sh
```

### Exécution

```bash
# Avec SSH sur port 22 (par défaut)
~/scripts/configure-firewall.sh

# Avec SSH sur port personnalisé
~/scripts/configure-firewall.sh 2222
```

## 11. Règles IPv6

### Activer IPv6 dans UFW

```bash
# Éditer la configuration UFW
sudo nano /etc/default/ufw
```

**Vérifier ou modifier :**

```
IPV6=yes
```

```bash
# Redémarrer UFW
sudo ufw disable
sudo ufw enable
```

### Règles IPv6 spécifiques

```bash
# Autoriser SSH en IPv6
sudo ufw allow from 2001:41d0:305:2100::7d21 to any port 22

# Bloquer une adresse IPv6
sudo ufw deny from 2001:db8::1
```

## 12. Fail2ban avec UFW

### Configuration de Fail2ban pour UFW

```bash
# Éditer la configuration Fail2ban
sudo nano /etc/fail2ban/jail.local
```

**Ajouter ou modifier :**

```ini
[DEFAULT]
# Utiliser UFW comme action par défaut
banaction = ufw

[sshd]
enabled = true
port = 2222  # Adapter selon votre port SSH
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
action = ufw
```

```bash
# Redémarrer Fail2ban
sudo systemctl restart fail2ban

# Vérifier le statut
sudo fail2ban-client status sshd
```

## 13. Tests de sécurité

### Tester les ports ouverts

**Depuis votre machine locale :**

```powershell
# Tester avec nmap (si installé)
nmap -sS -p 1-65535 37.59.123.9

# Tester des ports spécifiques
Test-NetConnection -ComputerName 37.59.123.9 -Port 80
Test-NetConnection -ComputerName 37.59.123.9 -Port 443
Test-NetConnection -ComputerName 37.59.123.9 -Port 3306
```

**Sur le VPS :**

```bash
# Vérifier les ports en écoute
sudo netstat -tulpn | grep LISTEN

# OU avec ss (plus moderne)
sudo ss -tulpn | grep LISTEN
```

### Tester UFW

```bash
# Vérifier qu'une connexion est bloquée
sudo ufw deny from 1.2.3.4
# Tenter de se connecter depuis 1.2.3.4 → doit échouer

# Supprimer la règle de test
sudo ufw delete deny from 1.2.3.4
```

## 14. Bonnes pratiques

### Règles à appliquer

- ✅ **Toujours** autoriser SSH AVANT d'activer UFW
- ✅ **Limiter** les tentatives SSH avec `ufw limit`
- ✅ **Ne jamais** exposer MySQL sur Internet
- ✅ **Activer** le logging pour surveiller les tentatives
- ✅ **Documenter** chaque règle avec `comment`
- ✅ **Tester** les règles avant de les appliquer en production
- ✅ **Garder** une session SSH ouverte lors des tests

### Règles à éviter

- ❌ **Ne pas** activer UFW sans avoir autorisé SSH
- ❌ **Ne pas** ouvrir tous les ports par défaut
- ❌ **Ne pas** autoriser MySQL (3306) depuis Internet
- ❌ **Ne pas** ignorer les logs de tentatives d'intrusion
- ❌ **Ne pas** oublier les règles IPv6 si activé

## ✅ Checklist

- [ ] UFW installé
- [ ] Politiques par défaut configurées (deny incoming, allow outgoing)
- [ ] SSH autorisé et limité (rate limiting)
- [ ] HTTP (80) et HTTPS (443) autorisés
- [ ] MySQL bloqué depuis Internet
- [ ] Réseau Docker autorisé
- [ ] Logging activé (niveau medium)
- [ ] IPv6 configuré si nécessaire
- [ ] Fail2ban intégré avec UFW
- [ ] Tests de sécurité effectués
- [ ] Documentation des règles

## 🔜 Étape suivante

Passer à [07-automatisation.md](07-automatisation.md) pour mettre en place les scripts d'automatisation et cron jobs.

## 📝 Notes

- **Conserver** une session SSH ouverte lors des modifications d'UFW
- **Sauvegarder** la configuration UFW : `sudo cp -r /etc/ufw /etc/ufw.backup`
- **Vérifier** régulièrement les logs : `sudo tail -f /var/log/ufw.log`
- **Adapter** les règles selon vos besoins spécifiques

## 🔧 Dépannage

### Problème : Connexion SSH perdue après activation UFW

```bash
# Solution : Se connecter via la console OVH (KVM)
# Puis désactiver UFW
sudo ufw disable

# Ajouter la règle SSH
sudo ufw allow 22/tcp

# Réactiver UFW
sudo ufw enable
```

### Problème : Docker ne fonctionne plus

```bash
# Vérifier les règles Docker
sudo iptables -L DOCKER-USER -n

# Recharger UFW et Docker
sudo systemctl restart ufw
sudo systemctl restart docker
```

### Problème : Site web inaccessible

```bash
# Vérifier que les ports HTTP/HTTPS sont autorisés
sudo ufw status | grep -E "80|443"

# Si manquants, ajouter :
sudo ufw allow 'Nginx Full'
sudo ufw reload
```
