# Refonte du Formulaire de Démarchage

## Date : 20 Janvier 2025

## Objectif
Simplifier et clarifier l'interface de démarchage en remplaçant le système de case à cocher + liste déroulante OUI/NON par une liste déroulante unique avec 3 statuts clairs.

## Modifications Interface

### Avant
```
☐ Démarchage de parrainage
    [OUI/NON ▼]  Parrainage obtenu
    RDV : [Date] [Heure]
    Commentaire : [Texte]
```

### Après (Version 2 - avec couleurs dans tableau)
```
Démarchage de parrainage
    [-- Sélectionner --                    ▼]
    ├─ Démarchage en cours
    ├─ Rendez-vous obtenu
    ├─ Démarchage terminé (sans suite)
    ├─ ────────── (séparateur)
    └─ Parrainage obtenu

    RDV : [Date] [Heure]
    Commentaire : [Texte]
```

**Couleurs appliquées dans le tableau de résultats :**
- Statut 1 (Démarchage en cours) : fond gris clair (#f0f0f0)
- Statut 2 (Rendez-vous obtenu) : fond vert clair (#d4edda), texte gras
- Statut 3 (Démarchage terminé) : texte rouge, barré
- Statut 4 (Parrainage obtenu) : fond gris foncé (#555), texte jaune (#ffd700), gras

## Changements Techniques

### 1. Base de Données

**Table : `demarchage`**

Nouveau champ ajouté :
```sql
statut_demarchage TINYINT(1) DEFAULT 0
```

Valeurs possibles :
- `0` : Aucun statut (par défaut, case non cochée dans tableau)
- `1` : Démarchage en cours (gris clair, case cochée)
- `2` : Rendez-vous obtenu (vert clair, gras, case cochée)
- `3` : Démarchage terminé sans suite (rouge, barré, case cochée)
- `4` : Parrainage obtenu (fond gris foncé, texte jaune, gras, case cochée)

**Migration SQL :**
```sql
ALTER TABLE demarchage
ADD COLUMN statut_demarchage TINYINT(1) DEFAULT 0 AFTER parrainage_obtenu;
```

### 2. Frontend (scripts-maires.js)

**Formulaire HTML modifié :**
- ❌ Supprimé : `<input type="checkbox" id="demarcheToggle">`
- ❌ Supprimé : `<select id="parrainageObtenu">` (OUI/NON)
- ❌ Supprimé : Label "Parrainage obtenu"
- ✅ Ajouté : `<select id="statutDemarchage">` avec 4 options

**Fonction `loadDemarcheData()` :**
- Lecture du champ `statut_demarchage` depuis API
- Conversion automatique des anciennes données :
  - `parrainage_obtenu = 1` → statut = 3
  - `demarche_active = 1` → statut = 1 (par défaut)

**Fonction `saveDemarcheData()` :**
- Récupération de la valeur `statutDemarchage`
- Calcul automatique de `demarche_active` et `parrainage_obtenu` selon statut :
  - Statut 1 ou 2 → `demarche_active = 1, parrainage_obtenu = 0`
  - Statut 3 → `demarche_active = 1, parrainage_obtenu = 1`
  - Statut 0 → `demarche_active = 0, parrainage_obtenu = 0`

### 3. Backend (api.php)

**Fonction `saveDemarchage()` :**
```php
$statutDemarchage = (int)($_POST['statut_demarchage'] ?? 0);

// UPDATE
UPDATE demarchage
SET demarche_active = ?,
    parrainage_obtenu = ?,
    statut_demarchage = ?,
    rdv_date = ?,
    commentaire = ?,
    updated_at = NOW()
WHERE maire_cle_unique = ?

// INSERT
INSERT INTO demarchage (
    maire_cle_unique,
    demarche_active,
    parrainage_obtenu,
    statut_demarchage,
    rdv_date,
    commentaire,
    created_at,
    updated_at
)
VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())
```

## Corrections Bonus

### Pagination Footer Fixe
- ✅ Footer positionné après sidebar : `left: 320px`
- ✅ Ajustement dynamique lors ouverture/fermeture menu :
  - Menu ouvert : `left: 320px`
  - Menu fermé : `left: 24px`
- ✅ Suppression du défilement horizontal

## Compatibilité Ascendante

Les anciennes données restent compatibles :
- Le champ `demarche_active` est toujours utilisé
- Le champ `parrainage_obtenu` est toujours utilisé
- Le nouveau champ `statut_demarchage` affine l'information

## Fichiers Modifiés

1. `www/Annuaire/ressources/js/scripts-maires.js`
   - Lignes 1129-1168 : Formulaire HTML
   - Lignes 1253-1297 : loadDemarcheData()
   - Lignes 1299-1339 : saveDemarcheData()

2. `www/Annuaire/api.php`
   - Lignes 88-135 : saveDemarchage()

3. `www/Annuaire/ressources/css/styles-maires.css`
   - Lignes 599-619 : Pagination footer fixe

4. `sql/add_statut_demarchage.sql` (nouveau)
   - Script de migration SQL

## Tests Recommandés

- [ ] Ouvrir modal maire existant sans démarchage
- [ ] Sélectionner "Démarchage en cours" et enregistrer
- [ ] Vérifier que le statut est bien sauvegardé
- [ ] Rouvrir la modal et vérifier que le statut affiché est correct
- [ ] Tester tous les statuts (1, 2, 3)
- [ ] Vérifier la compatibilité avec anciennes données
- [ ] Tester pagination footer avec menu ouvert/fermé

## Commits

- `711f9cf` : Refonte formulaire démarchage - Liste déroulante statuts
- `86f7151` : Ajout pagination dans footer fixe en bas d'écran
