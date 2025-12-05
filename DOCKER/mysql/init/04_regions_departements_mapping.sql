SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Table de mapping entre régions et départements
DROP TABLE IF EXISTS regions_departements;

CREATE TABLE regions_departements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT NOT NULL,
    departement_id INT NOT NULL,
    UNIQUE KEY unique_mapping (region_id, departement_id),
    INDEX idx_region (region_id),
    INDEX idx_departement (departement_id),
    FOREIGN KEY (region_id) REFERENCES regions(id) ON DELETE CASCADE,
    FOREIGN KEY (departement_id) REFERENCES departements(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des mappings régions-départements basés sur les données existantes
INSERT INTO regions_departements (region_id, departement_id)
SELECT DISTINCT r.id, d.id
FROM departements d
INNER JOIN regions r ON d.region = r.nom_region
ORDER BY r.id, d.id;

COMMIT;
