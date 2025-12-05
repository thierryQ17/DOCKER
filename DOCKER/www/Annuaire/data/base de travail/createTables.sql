-- =============================================
-- Création des tables t_mairies et t_maires
-- =============================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS t_maires;
DROP TABLE IF EXISTS t_mairies;

-- =============================================
-- Table t_mairies
-- =============================================
CREATE TABLE t_mairies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codeCommune VARCHAR(10) NOT NULL UNIQUE,
    nomCommune VARCHAR(255),
    codePostal VARCHAR(10),
    adresseMairie VARCHAR(500),
    telephone VARCHAR(100),
    email VARCHAR(255),
    siteInternet VARCHAR(500),
    plageOuverture TEXT,
    longitude DOUBLE,
    latitude DOUBLE,
    codeArrondissement VARCHAR(10),
    nomArrondissement VARCHAR(255),
    codeCanton VARCHAR(10),
    nomCanton VARCHAR(255),
    codeRegion VARCHAR(5),
    nomRegion VARCHAR(255),
    codeDept VARCHAR(5),
    nomDept VARCHAR(255),
    nbHabitants INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code_commune (codeCommune),
    INDEX idx_code_dept (codeDept),
    INDEX idx_code_postal (codePostal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table t_maires
-- =============================================
CREATE TABLE t_maires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codeCommune VARCHAR(10) NOT NULL,
    nomMaire VARCHAR(255),
    prenomMaire VARCHAR(255),
    nomPrenom VARCHAR(500),
    codeSexe CHAR(1),
    dateNaissance DATE,
    metierMaire VARCHAR(500),
    dateDebutMandat DATE,
    dateDebutFonction DATE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code_commune (codeCommune),
    CONSTRAINT fk_maire_mairie FOREIGN KEY (codeCommune)
        REFERENCES t_mairies(codeCommune) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
