SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Table pour les régions
DROP TABLE IF EXISTS regions;

CREATE TABLE regions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_region VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_nom_region (nom_region)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des régions uniques

INSERT INTO regions (id, nom_region) VALUES (1, 'Auvergne-Rhone-Alpes');
INSERT INTO regions (id, nom_region) VALUES (2, 'Bourgogne-Franche-Comte');
INSERT INTO regions (id, nom_region) VALUES (3, 'Bretagne');
INSERT INTO regions (id, nom_region) VALUES (4, 'Centre-Val-de-Loire');
INSERT INTO regions (id, nom_region) VALUES (5, 'Corse');
INSERT INTO regions (id, nom_region) VALUES (6, 'Grand-Est');
INSERT INTO regions (id, nom_region) VALUES (7, 'Hauts-de-France');
INSERT INTO regions (id, nom_region) VALUES (8, 'Ile-de-France');
INSERT INTO regions (id, nom_region) VALUES (9, 'Normandie');
INSERT INTO regions (id, nom_region) VALUES (10, 'Nouvelle-Aquitaine');
INSERT INTO regions (id, nom_region) VALUES (11, 'Occitanie');
INSERT INTO regions (id, nom_region) VALUES (12, 'Pays-de-la-Loire');
INSERT INTO regions (id, nom_region) VALUES (13, 'Provence-Alpes-Cote-d-Azur');

COMMIT;
