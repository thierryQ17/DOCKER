-- Creation de la table t_circonscriptions
-- Stockage des cartes de circonscriptions par departement

CREATE TABLE IF NOT EXISTS t_circonscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code_departement VARCHAR(5) NOT NULL,
    nom_departement VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    image_path VARCHAR(255),
    url_source VARCHAR(255),
    url_image_origine VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code (code_departement),
    INDEX idx_region (region),
    UNIQUE KEY uk_code_dept (code_departement)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
