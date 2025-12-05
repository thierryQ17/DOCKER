# Documentation API - Annuaire des Maires de France

**Base URL:** `http://localhost:81/annuaire/api.php`

Cette API REST centralise toutes les opérations AJAX de l'application. Toutes les routes retournent du JSON avec `Content-Type: application/json`.

---

## Table des matières

1. [saveDemarchage](#1-savedemarchage-post)
2. [getDemarchage](#2-getdemarchage-get)
3. [getMaireDetails](#3-getmairedetails-get)
4. [getStatsDemarchage](#4-getstatsdemarchage-get)
5. [getCirconscriptions](#5-getcirconscriptions-get)
6. [getMaires](#6-getmaires-get)
7. [autocomplete](#7-autocomplete-get)
8. [autocompleteAdvanced](#8-autocompleteadvanced-get)
9. [getDepartements](#9-getdepartements-get)
10. [Gestion des erreurs](#gestion-des-erreurs)

---

## 1. saveDemarchage (POST)

Enregistrer ou mettre à jour les données de démarchage d'un maire.

### URL
```
POST http://localhost:81/annuaire/api.php
```

### Paramètres POST (FormData)
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `saveDemarchage` |
| `maire_cle_unique` | string | ✅ | Clé unique du maire (ex: `amberieuenbugey_01`) |
| `demarche_active` | int | ❌ | 0 ou 1 (défaut: 0) |
| `parrainage_obtenu` | int | ❌ | 0 ou 1 (défaut: 0) |
| `contact_tel` | int | ❌ | 0 ou 1 (défaut: 0) |
| `rdv_date` | datetime | ❌ | Format: `YYYY-MM-DD HH:MM:SS` |
| `commentaire` | string | ❌ | Texte libre |

### Réponse (200 OK)
```json
{
  "success": true,
  "message": "Données enregistrées avec succès"
}
```

### Exemple JavaScript
```javascript
const formData = new FormData();
formData.append('action', 'saveDemarchage');
formData.append('maire_cle_unique', 'amberieuenbugey_01');
formData.append('demarche_active', 1);
formData.append('parrainage_obtenu', 0);
formData.append('contact_tel', 1);
formData.append('rdv_date', '2025-11-20 14:30:00');
formData.append('commentaire', 'RDV confirmé avec le maire');

fetch('api.php', {
    method: 'POST',
    body: formData
})
.then(response => response.json())
.then(data => console.log(data));
```

---

## 2. getDemarchage (GET)

Récupérer les données de démarchage d'un maire spécifique.

### URL
```
GET http://localhost:81/annuaire/api.php?action=getDemarchage&maire_cle_unique=savignies_60
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `getDemarchage` |
| `maire_cle_unique` | string | ✅ | Clé unique du maire |

### Réponse (200 OK)
```json
{
  "success": true,
  "demarchage": {
    "id": 1,
    "maire_cle_unique": "savignies_60",
    "demarche_active": 1,
    "contact_telephonique": 0,
    "parrainage_obtenu": 0,
    "rdv_date": null,
    "commentaire": "",
    "created_at": "2025-11-17 15:16:59",
    "updated_at": "2025-11-17 16:09:28"
  }
}
```

*Note: Si aucune donnée n'existe, `demarchage` sera `null`.*

### Exemple JavaScript
```javascript
fetch('api.php?action=getDemarchage&maire_cle_unique=savignies_60')
    .then(response => response.json())
    .then(data => {
        if (data.demarchage) {
            console.log('Démarchage actif:', data.demarchage.demarche_active);
        }
    });
```

---

## 3. getMaireDetails (GET)

Récupérer les détails complets d'un maire par son ID.

### URL
```
GET http://localhost:81/annuaire/api.php?action=getMaireDetails&id=1
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `getMaireDetails` |
| `id` | int | ✅ | ID numérique du maire |

### Réponse (200 OK)
```json
{
  "success": true,
  "maire": {
    "id": 1,
    "cle_unique": "amberieuenbugey_01",
    "region": "Auvergne-Rhone-Alpes",
    "numero_departement": "01",
    "nom_departement": "Ain",
    "circonscription": "5e circonscription",
    "ville": "Ambérieu-en-Bugey",
    "code_postal": "01500",
    "nom_maire": "Jean DUPONT",
    "telephone": "04 XX XX XX XX",
    "email": "mairie@exemple.fr",
    "url_mairie": "https://www.amberieu-en-bugey.fr",
    "lien_google_maps": "https://maps.google.com/?q=...",
    "lien_waze": "https://waze.com/ul?ll=..."
  }
}
```

### Réponse (404 Not Found)
```json
{
  "success": false,
  "error": "Maire non trouvé"
}
```

### Exemple JavaScript
```javascript
fetch('api.php?action=getMaireDetails&id=1')
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            console.log('Maire:', data.maire.nom_maire);
            console.log('Ville:', data.maire.ville);
        }
    });
```

---

## 4. getStatsDemarchage (GET)

Récupérer les statistiques de démarchage par région et département.

### URL
```
GET http://localhost:81/annuaire/api.php?action=getStatsDemarchage
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `getStatsDemarchage` |

### Réponse (200 OK)
```json
{
  "success": true,
  "regions": [
    {
      "region": "Auvergne-Rhone-Alpes",
      "nb_demarches": 15
    },
    {
      "region": "Bretagne",
      "nb_demarches": 8
    },
    {
      "region": "Hauts-de-France",
      "nb_demarches": 23
    }
  ],
  "departements": [
    {
      "numero_departement": "01",
      "nom_departement": "Ain",
      "nb_demarches": 3
    },
    {
      "numero_departement": "60",
      "nom_departement": "Oise",
      "nb_demarches": 5
    }
  ]
}
```

### Exemple JavaScript
```javascript
fetch('api.php?action=getStatsDemarchage')
    .then(response => response.json())
    .then(data => {
        console.log('Statistiques par région:', data.regions);
        console.log('Statistiques par département:', data.departements);

        // Trouver la région avec le plus de démarchages
        const topRegion = data.regions.reduce((max, r) =>
            r.nb_demarches > max.nb_demarches ? r : max
        );
        console.log('Région top:', topRegion.region, topRegion.nb_demarches);
    });
```

---

## 5. getCirconscriptions (GET)

Récupérer les circonscriptions électorales d'un département ou d'une région.

### URL
```
GET http://localhost:81/annuaire/api.php?action=getCirconscriptions&departement=75
GET http://localhost:81/annuaire/api.php?action=getCirconscriptions&region=Ile-de-France&departement=75
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `getCirconscriptions` |
| `departement` | string | ❌ | Numéro ou nom du département |
| `region` | string | ❌ | Nom de la région |

### Réponse (200 OK)
```json
{
  "success": true,
  "circonscriptions": [
    "1re circonscription",
    "2e circonscription",
    "3e circonscription",
    "4e circonscription",
    "5e circonscription"
  ]
}
```

### Exemple JavaScript
```javascript
fetch('api.php?action=getCirconscriptions&departement=60')
    .then(response => response.json())
    .then(data => {
        console.log('Circonscriptions de l\'Oise:', data.circonscriptions);
    });
```

---

## 6. getMaires (GET)

Récupérer une liste de maires avec filtres avancés et pagination.

### URL de base
```
GET http://localhost:81/annuaire/api.php?action=getMaires
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `getMaires` |
| `region` | string | ❌ | Nom de la région |
| `departement` | string | ❌ | Numéro ou nom du département |
| `commune` | string | ❌ | Nom de la commune |
| `canton` | string | ❌ | Nom du canton |
| `circo` | string | ❌ | Circonscription |
| `nbHabitants` | int | ❌ | Nombre max d'habitants |
| `search` | string | ❌ | Recherche globale (ville, maire, département, circonscription) |
| `page` | int | ❌ | Numéro de page (défaut: 1) |
| `showAll` | string | ❌ | `1` pour afficher tous les résultats (pas de pagination) |
| `filterDemarchage` | string | ❌ | `1` pour filtrer uniquement les communes avec démarchage actif |

### Exemples d'URLs

**Par région :**
```
http://localhost:81/annuaire/api.php?action=getMaires&region=Bretagne&page=1
```

**Par département :**
```
http://localhost:81/annuaire/api.php?action=getMaires&departement=60&page=1
```

**Par commune :**
```
http://localhost:81/annuaire/api.php?action=getMaires&commune=Paris&page=1
```

**Filtres combinés :**
```
http://localhost:81/annuaire/api.php?action=getMaires&region=Ile-de-France&departement=75&commune=Paris&nbHabitants=10000
```

**Uniquement communes avec démarchage actif :**
```
http://localhost:81/annuaire/api.php?action=getMaires&filterDemarchage=1&region=Hauts-de-France
```

**Tout afficher (sans pagination) :**
```
http://localhost:81/annuaire/api.php?action=getMaires&departement=60&showAll=1
```

### Réponse (200 OK)
```json
{
  "success": true,
  "maires": [
    {
      "id": 1,
      "cle_unique": "amberieuenbugey_01",
      "region": "Auvergne-Rhone-Alpes",
      "numero_departement": "01",
      "nom_departement": "Ain",
      "circonscription": "5e circonscription",
      "ville": "Ambérieu-en-Bugey",
      "canton": "Canton d'Ambérieu-en-Bugey",
      "nombre_habitants": 15000,
      "nom_maire": "Jean DUPONT",
      "demarche_active": 1,
      "parrainage_obtenu": 0
    },
    {
      "id": 2,
      "cle_unique": "ambronay_01",
      "region": "Auvergne-Rhone-Alpes",
      "numero_departement": "01",
      "nom_departement": "Ain",
      "circonscription": "5e circonscription",
      "ville": "Ambronay",
      "canton": "Canton d'Ambérieu-en-Bugey",
      "nombre_habitants": 2500,
      "nom_maire": "Marie MARTIN",
      "demarche_active": 0,
      "parrainage_obtenu": 0
    }
  ],
  "total": 387,
  "page": 1,
  "perPage": 50,
  "totalPages": 8
}
```

### Exemple JavaScript
```javascript
const params = new URLSearchParams({
    action: 'getMaires',
    region: 'Bretagne',
    page: 1
});

fetch('api.php?' + params.toString())
    .then(response => response.json())
    .then(data => {
        console.log(`Total: ${data.total} maires`);
        console.log(`Pages: ${data.totalPages}`);
        console.log('Résultats page 1:', data.maires);

        // Afficher les maires avec démarchage actif
        const mairesAvecDemarchage = data.maires.filter(m => m.demarche_active === 1);
        console.log('Maires démarchés:', mairesAvecDemarchage.length);
    });
```

---

## 7. autocomplete (GET)

Autocomplétion filtrée par département (utilisée dans le menu latéral).

### URL
```
GET http://localhost:81/annuaire/api.php?action=autocomplete&type=commune&term=Par&departement=75
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `autocomplete` |
| `type` | string | ✅ | `circo`, `canton` ou `commune` |
| `term` | string | ✅ | Terme de recherche |
| `departement` | string | ✅ | Numéro du département (ex: `75`, `60`) |

### Types disponibles
- `circo` : Circonscriptions électorales
- `canton` : Cantons
- `commune` : Communes

### Exemples d'URLs

**Circonscriptions :**
```
http://localhost:81/annuaire/api.php?action=autocomplete&type=circo&term=1&departement=60
```

**Cantons :**
```
http://localhost:81/annuaire/api.php?action=autocomplete&type=canton&term=Canton&departement=75
```

**Communes :**
```
http://localhost:81/annuaire/api.php?action=autocomplete&type=commune&term=Beauv&departement=60
```

### Réponse (200 OK)
```json
{
  "results": [
    "Beauvais",
    "Beauvoir"
  ]
}
```

### Exemple JavaScript
```javascript
// Autocomplétion lors de la saisie dans un input
document.getElementById('communeInput').addEventListener('input', function(e) {
    const term = e.target.value;
    const departement = '60';

    if (term.length >= 2) {
        fetch(`api.php?action=autocomplete&type=commune&term=${term}&departement=${departement}`)
            .then(response => response.json())
            .then(data => {
                console.log('Suggestions:', data.results);
                // Afficher les résultats dans une dropdown
            });
    }
});
```

---

## 8. autocompleteAdvanced (GET)

Autocomplétion pour la recherche avancée (sans filtre département obligatoire).

### URL
```
GET http://localhost:81/annuaire/api.php?action=autocompleteAdvanced&type=departement&term=Oi
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `autocompleteAdvanced` |
| `type` | string | ✅ | `departement`, `canton` ou `commune` |
| `term` | string | ✅ | Terme de recherche (min 2 caractères) |
| `region` | string | ❌ | Nom de la région (filtre optionnel) |

### Types disponibles
- `departement` : Départements (format: `60 - Oise`)
- `canton` : Cantons
- `commune` : Communes

### Exemples d'URLs

**Départements :**
```
http://localhost:81/annuaire/api.php?action=autocompleteAdvanced&type=departement&term=75
http://localhost:81/annuaire/api.php?action=autocompleteAdvanced&type=departement&term=Oi
```

**Cantons (avec filtre région) :**
```
http://localhost:81/annuaire/api.php?action=autocompleteAdvanced&type=canton&term=Canton&region=Ile-de-France
```

**Communes (avec filtre région) :**
```
http://localhost:81/annuaire/api.php?action=autocompleteAdvanced&type=commune&term=Paris&region=Ile-de-France
```

### Réponse (200 OK)
```json
{
  "results": [
    "60 - Oise",
    "75 - Paris"
  ]
}
```

### Exemple JavaScript
```javascript
// Autocomplétion départements
document.getElementById('departementInput').addEventListener('input', function(e) {
    const term = e.target.value;

    if (term.length >= 2) {
        fetch(`api.php?action=autocompleteAdvanced&type=departement&term=${term}`)
            .then(response => response.json())
            .then(data => {
                console.log('Départements suggérés:', data.results);
            });
    }
});
```

---

## 9. getDepartements (GET)

Récupérer les départements d'une région (ou plusieurs régions pour DOM-TOM).

### URL simple (une région)
```
GET http://localhost:81/annuaire/api.php?action=getDepartements&region=Bretagne
```

### URL DOM-TOM (plusieurs régions)
```
GET http://localhost:81/annuaire/api.php?action=getDepartements&domtom=["Guadeloupe","Martinique","Guyane","La-Reunion","Mayotte"]
```

### Paramètres GET
| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `action` | string | ✅ | Doit être `getDepartements` |
| `region` | string | ❌ | Nom de la région (mode simple) |
| `domtom` | string | ❌ | JSON array des régions DOM-TOM (mode multiple) |

### Réponse (200 OK) - Région simple
```json
{
  "success": true,
  "departements": [
    {
      "numero_departement": "22",
      "nom_departement": "Côtes-d'Armor",
      "nb_maires": 348
    },
    {
      "numero_departement": "29",
      "nom_departement": "Finistère",
      "nb_maires": 277
    },
    {
      "numero_departement": "35",
      "nom_departement": "Ille-et-Vilaine",
      "nb_maires": 333
    },
    {
      "numero_departement": "56",
      "nom_departement": "Morbihan",
      "nb_maires": 249
    }
  ]
}
```

### Réponse (200 OK) - DOM-TOM
```json
{
  "success": true,
  "departements": [
    {
      "numero_departement": "971",
      "nom_departement": "Guadeloupe",
      "region": "Guadeloupe",
      "nb_maires": 32
    },
    {
      "numero_departement": "972",
      "nom_departement": "Martinique",
      "region": "Martinique",
      "nb_maires": 34
    },
    {
      "numero_departement": "973",
      "nom_departement": "Guyane",
      "region": "Guyane",
      "nb_maires": 22
    },
    {
      "numero_departement": "974",
      "nom_departement": "La Réunion",
      "region": "La-Reunion",
      "nb_maires": 24
    },
    {
      "numero_departement": "976",
      "nom_departement": "Mayotte",
      "region": "Mayotte",
      "nb_maires": 17
    }
  ]
}
```

### Exemple JavaScript - Région simple
```javascript
fetch('api.php?action=getDepartements&region=Bretagne')
    .then(response => response.json())
    .then(data => {
        console.log('Départements de Bretagne:', data.departements);

        // Calculer le total de maires
        const totalMaires = data.departements.reduce((sum, d) => sum + d.nb_maires, 0);
        console.log('Total maires en Bretagne:', totalMaires);
    });
```

### Exemple JavaScript - DOM-TOM
```javascript
const domtomRegions = ['Guadeloupe', 'Martinique', 'Guyane', 'La-Reunion', 'Mayotte'];

fetch('api.php?action=getDepartements&domtom=' + encodeURIComponent(JSON.stringify(domtomRegions)))
    .then(response => response.json())
    .then(data => {
        console.log('Départements DOM-TOM:', data.departements);

        // Afficher par région
        data.departements.forEach(dept => {
            console.log(`${dept.region}: ${dept.nb_maires} maires`);
        });
    });
```

---

## Gestion des erreurs

Toutes les routes retournent une structure JSON avec `success: false` en cas d'erreur.

### Format de réponse d'erreur
```json
{
  "success": false,
  "error": "Message d'erreur décrivant le problème"
}
```

### Codes HTTP d'erreur
| Code | Description | Cas d'usage |
|------|-------------|-------------|
| **400** | Bad Request | Action invalide ou paramètres manquants |
| **404** | Not Found | Ressource non trouvée (ex: maire inexistant) |
| **500** | Internal Server Error | Erreur de connexion à la base de données ou erreur PDO |

### Exemples d'erreurs

**Action invalide (400) :**
```json
{
  "success": false,
  "error": "Invalid action"
}
```

**Paramètre manquant (400) :**
```json
{
  "success": false,
  "error": "Clé unique maire invalide"
}
```

**Maire non trouvé (404) :**
```json
{
  "success": false,
  "error": "Maire non trouvé"
}
```

**Erreur base de données (500) :**
```json
{
  "success": false,
  "error": "SQLSTATE[23000]: Integrity constraint violation: ..."
}
```

### Exemple de gestion d'erreur en JavaScript
```javascript
fetch('api.php?action=getMaireDetails&id=99999')
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            console.log('Maire:', data.maire);
        } else {
            console.error('Erreur API:', data.error);
        }
    })
    .catch(error => {
        console.error('Erreur réseau:', error);
    });
```

---

## Résumé des routes

| Route | Méthode | URL | Description |
|-------|---------|-----|-------------|
| **saveDemarchage** | POST | `api.php` | Enregistrer données démarchage |
| **getDemarchage** | GET | `api.php?action=getDemarchage&maire_cle_unique=...` | Récupérer données démarchage |
| **getMaireDetails** | GET | `api.php?action=getMaireDetails&id=...` | Détails complets d'un maire |
| **getStatsDemarchage** | GET | `api.php?action=getStatsDemarchage` | Statistiques démarchage |
| **getCirconscriptions** | GET | `api.php?action=getCirconscriptions&departement=...` | Liste circonscriptions |
| **getMaires** | GET | `api.php?action=getMaires&...` | Liste maires avec filtres |
| **autocomplete** | GET | `api.php?action=autocomplete&type=...&term=...&departement=...` | Autocomplétion (menu) |
| **autocompleteAdvanced** | GET | `api.php?action=autocompleteAdvanced&type=...&term=...` | Autocomplétion (recherche) |
| **getDepartements** | GET | `api.php?action=getDepartements&region=...` | Liste départements d'une région |

---

## Notes techniques

### Configuration base de données
L'API utilise une configuration inline pour la connexion à la base de données MySQL via Docker :

```php
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';
```

### Encodage
- Toutes les requêtes et réponses utilisent l'encodage **UTF-8**
- Les accents et caractères spéciaux sont correctement gérés

### Performance
- **Pagination** : Les routes `getMaires` retournent 50 résultats par défaut
- **Limite autocomplétion** : 20 résultats maximum
- **Optimisation** : `getStatsDemarchage` utilise une requête UNION optimisée

### Sécurité
- Toutes les requêtes SQL utilisent des **prepared statements** (protection contre injection SQL)
- Validation des paramètres côté serveur
- Gestion des exceptions PDO avec try/catch

---

**Version :** 1.0
**Dernière mise à jour :** 18 novembre 2025
**Auteur :** Système de gestion Annuaire des Maires de France
