-- Création de la table t_parrainages
-- Données issues du fichier parrainages_2017-2022.csv

CREATE TABLE IF NOT EXISTS t_parrainages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    civilite VARCHAR(10),
    nom VARCHAR(100),
    prenom VARCHAR(100),
    mandat VARCHAR(100),
    commune VARCHAR(255),
    departement VARCHAR(100),
    candidat_parraine VARCHAR(150),
    annee YEAR,
    INDEX idx_nom (nom),
    INDEX idx_departement (departement),
    INDEX idx_candidat (candidat_parraine),
    INDEX idx_annee (annee)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
