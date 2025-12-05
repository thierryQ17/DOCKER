# Proposition de Schéma Relationnel Normalisé

## Situation Actuelle

### Tables existantes

**t_mairies** (35 268 enregistrements)
| Colonne | Type | Description |
|---------|------|-------------|
| id | INT | Clé primaire |
| codeCommune | VARCHAR(10) | Code INSEE unique |
| nomCommune | VARCHAR(255) | Nom de la commune |
| codePostal | VARCHAR(10) | Code postal |
| adresseMairie | VARCHAR(500) | Adresse |
| telephone | VARCHAR(100) | Téléphone |
| email | VARCHAR(255) | Email |
| siteInternet | VARCHAR(500) | Site web |
| plageOuverture | TEXT | Horaires |
| longitude | DOUBLE | Coordonnée GPS |
| latitude | DOUBLE | Coordonnée GPS |
| codeArrondissement | VARCHAR(10) | Code arrondissement |
| nomArrondissement | VARCHAR(255) | Nom arrondissement |
| codeCanton | VARCHAR(10) | Code canton |
| nomCanton | VARCHAR(255) | Nom canton |
| codeRegion | VARCHAR(5) | Code région |
| nomRegion | VARCHAR(255) | Nom région |
| codeDept | VARCHAR(5) | Code département |
| nomDept | VARCHAR(255) | Nom département |
| nbHabitants | INT | Population |
| createdAt | TIMESTAMP | Date création |

**t_maires** (34 865 enregistrements)
| Colonne | Type | Description |
|---------|------|-------------|
| id | INT | Clé primaire |
| codeCommune | VARCHAR(10) | FK vers t_mairies |
| nomMaire | VARCHAR(255) | Nom |
| prenomMaire | VARCHAR(255) | Prénom |
| nomPrenom | VARCHAR(500) | Nom complet formaté |
| codeSexe | CHAR(1) | M/F |
| dateNaissance | DATE | Date de naissance |
| metierMaire | VARCHAR(500) | Profession |
| dateDebutMandat | DATE | Début mandat |
| dateDebutFonction | DATE | Début fonction |
| createdAt | TIMESTAMP | Date création |

---

## Schéma Relationnel Proposé (Normalisé)

### Diagramme des Relations

```
┌─────────────┐
│   Regions   │
│─────────────│
│ PK codeRegion
│    nomRegion│
└──────┬──────┘
       │ 1
       │
       │ N
┌──────┴──────┐
│ Departements│
│─────────────│
│ PK codeDept │
│    nomDept  │
│ FK codeRegion
└──────┬──────┘
       │ 1
       │
       │ N
┌──────┴──────┐
│   Cantons   │
│─────────────│
│ PK id       │
│    codeCanton
│    nomCanton│
│ FK codeDept │
└──────┬──────┘
       │ 1
       │
       │ N
┌──────┴──────┐
│   Mairies   │
│─────────────│
│ PK codeCommune
│    nomCommune
│    ...       │
│ FK cantonId │
└──────┬──────┘
       │ 1
       │
       │ 1
┌──────┴──────┐
│   Maires    │
│─────────────│
│ PK id       │
│    nomMaire │
│    ...       │
│ FK codeCommune
└─────────────┘
```

---

## Définition des Tables

### 1. Table `Regions`

```sql
CREATE TABLE Regions (
    codeRegion VARCHAR(5) PRIMARY KEY,
    nomRegion VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_nom_region (nomRegion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Volumétrie estimée :** 18 enregistrements

---

### 2. Table `Departements`

```sql
CREATE TABLE Departements (
    codeDept VARCHAR(5) PRIMARY KEY,
    nomDept VARCHAR(255) NOT NULL,
    codeRegion VARCHAR(5) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_nom_dept (nomDept),
    INDEX idx_code_region (codeRegion),

    CONSTRAINT fk_dept_region
        FOREIGN KEY (codeRegion) REFERENCES Regions(codeRegion)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Volumétrie estimée :** 101 enregistrements

---

### 3. Table `Cantons`

```sql
CREATE TABLE Cantons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codeCanton VARCHAR(10) NOT NULL,
    nomCanton VARCHAR(255) NOT NULL,
    codeDept VARCHAR(5) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_canton_dept (codeCanton, codeDept),
    INDEX idx_nom_canton (nomCanton),
    INDEX idx_code_dept (codeDept),

    CONSTRAINT fk_canton_dept
        FOREIGN KEY (codeDept) REFERENCES Departements(codeDept)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Volumétrie estimée :** ~2 000 enregistrements (cantons uniques par département)

---

### 4. Table `Mairies`

```sql
CREATE TABLE Mairies (
    codeCommune VARCHAR(10) PRIMARY KEY,
    nomCommune VARCHAR(255) NOT NULL,
    codePostal VARCHAR(10),
    adresseMairie VARCHAR(500),
    telephone VARCHAR(100),
    email VARCHAR(255),
    siteInternet VARCHAR(500),
    plageOuverture TEXT,
    longitude DOUBLE,
    latitude DOUBLE,
    nbHabitants INT,
    codeArrondissement VARCHAR(10),
    nomArrondissement VARCHAR(255),
    cantonId INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_nom_commune (nomCommune),
    INDEX idx_code_postal (codePostal),
    INDEX idx_canton (cantonId),
    INDEX idx_nb_habitants (nbHabitants),

    CONSTRAINT fk_mairie_canton
        FOREIGN KEY (cantonId) REFERENCES Cantons(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Volumétrie :** 35 268 enregistrements

---

### 5. Table `Maires`

```sql
CREATE TABLE Maires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codeCommune VARCHAR(10) NOT NULL UNIQUE,
    nomMaire VARCHAR(255) NOT NULL,
    prenomMaire VARCHAR(255),
    nomPrenom VARCHAR(500),
    codeSexe CHAR(1),
    dateNaissance DATE,
    metierMaire VARCHAR(500),
    dateDebutMandat DATE,
    dateDebutFonction DATE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_nom_maire (nomMaire),
    INDEX idx_nom_prenom (nomPrenom(100)),

    CONSTRAINT fk_maire_mairie
        FOREIGN KEY (codeCommune) REFERENCES Mairies(codeCommune)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Volumétrie :** 34 865 enregistrements

---

## Requêtes de Migration

### Peuplement des tables depuis t_mairies / t_maires

```sql
-- 1. Régions
INSERT INTO Regions (codeRegion, nomRegion)
SELECT DISTINCT codeRegion, nomRegion
FROM t_mairies
WHERE codeRegion IS NOT NULL AND codeRegion != '';

-- 2. Départements
INSERT INTO Departements (codeDept, nomDept, codeRegion)
SELECT DISTINCT codeDept, nomDept, codeRegion
FROM t_mairies
WHERE codeDept IS NOT NULL AND codeDept != '';

-- 3. Cantons
INSERT INTO Cantons (codeCanton, nomCanton, codeDept)
SELECT DISTINCT codeCanton, nomCanton, codeDept
FROM t_mairies
WHERE codeCanton IS NOT NULL AND codeCanton != '';

-- 4. Mairies
INSERT INTO Mairies (codeCommune, nomCommune, codePostal, adresseMairie,
    telephone, email, siteInternet, plageOuverture, longitude, latitude,
    nbHabitants, codeArrondissement, nomArrondissement, cantonId)
SELECT
    m.codeCommune, m.nomCommune, m.codePostal, m.adresseMairie,
    m.telephone, m.email, m.siteInternet, m.plageOuverture,
    m.longitude, m.latitude, m.nbHabitants,
    m.codeArrondissement, m.nomArrondissement,
    c.id
FROM t_mairies m
JOIN Cantons c ON c.codeCanton = m.codeCanton AND c.codeDept = m.codeDept;

-- 5. Maires
INSERT INTO Maires (codeCommune, nomMaire, prenomMaire, nomPrenom,
    codeSexe, dateNaissance, metierMaire, dateDebutMandat, dateDebutFonction)
SELECT codeCommune, nomMaire, prenomMaire, nomPrenom,
    codeSexe, dateNaissance, metierMaire, dateDebutMandat, dateDebutFonction
FROM t_maires;
```

---

## Exemples de Requêtes

### Obtenir toutes les informations d'une commune avec hiérarchie

```sql
SELECT
    m.nomCommune,
    m.codePostal,
    m.telephone,
    m.email,
    m.nbHabitants,
    c.nomCanton,
    d.nomDept,
    r.nomRegion,
    ma.nomPrenom AS maire,
    ma.metierMaire
FROM Mairies m
JOIN Cantons c ON m.cantonId = c.id
JOIN Departements d ON c.codeDept = d.codeDept
JOIN Regions r ON d.codeRegion = r.codeRegion
LEFT JOIN Maires ma ON m.codeCommune = ma.codeCommune
WHERE m.nomCommune = 'Angy';
```

### Statistiques par région

```sql
SELECT
    r.nomRegion,
    COUNT(DISTINCT d.codeDept) AS nb_departements,
    COUNT(DISTINCT c.id) AS nb_cantons,
    COUNT(DISTINCT m.codeCommune) AS nb_communes,
    SUM(m.nbHabitants) AS population_totale
FROM Regions r
JOIN Departements d ON r.codeRegion = d.codeRegion
JOIN Cantons c ON d.codeDept = c.codeDept
JOIN Mairies m ON c.id = m.cantonId
GROUP BY r.codeRegion, r.nomRegion
ORDER BY population_totale DESC;
```

### Liste des maires d'un département

```sql
SELECT
    m.nomCommune,
    ma.nomPrenom AS maire,
    ma.dateDebutMandat,
    m.nbHabitants
FROM Mairies m
JOIN Cantons c ON m.cantonId = c.id
JOIN Maires ma ON m.codeCommune = ma.codeCommune
WHERE c.codeDept = '60'
ORDER BY m.nbHabitants DESC;
```

---

## Avantages du Schéma Normalisé

| Aspect | Avant | Après |
|--------|-------|-------|
| **Redondance** | Nom région/dept répété 35 268 fois | Stocké 1 seule fois |
| **Intégrité** | Risque d'incohérence | Garantie par FK |
| **Maintenance** | Modifier partout | Modifier 1 fois |
| **Espace disque** | ~15 Mo pour noms redondants | ~50 Ko |
| **Requêtes** | Filtres sur chaînes | Filtres sur FK (plus rapide) |

---

## Volumétrie Estimée

| Table | Enregistrements |
|-------|-----------------|
| Regions | 18 |
| Departements | 101 |
| Cantons | ~2 000 |
| Mairies | 35 268 |
| Maires | 34 865 |

---

*Document généré le 2 décembre 2025*
