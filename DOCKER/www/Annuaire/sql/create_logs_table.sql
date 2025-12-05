-- ============================================
-- Table des logs d'activité
-- Annuaire des Maires de France - Parrainage 2027
-- ============================================

USE annuairesMairesDeFrance;

CREATE TABLE IF NOT EXISTS logs_activite (
    id INT AUTO_INCREMENT PRIMARY KEY,

    -- Informations temporelles
    date_action DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Utilisateur concerné
    utilisateur_id INT NULL,
    utilisateur_nom VARCHAR(100) NULL,
    utilisateur_type INT NULL,

    -- Type d'action
    action VARCHAR(50) NOT NULL,
    -- Types possibles: LOGIN, LOGOUT, LOGIN_FAILED,
    -- SAVE_DEMARCHAGE, UPDATE_DEMARCHAGE, DELETE_DEMARCHAGE,
    -- CREATE_USER, UPDATE_USER, DELETE_USER,
    -- ASSIGN_CANTON, REMOVE_CANTON, ASSIGN_DEPT, REMOVE_DEPT,
    -- EXPORT_CSV, VIEW_REPORT, etc.

    -- Catégorie d'action
    categorie VARCHAR(30) NOT NULL DEFAULT 'GENERAL',
    -- Catégories: AUTH, DEMARCHAGE, UTILISATEUR, DROITS, EXPORT, CONSULTATION

    -- Détails de l'action
    description TEXT NULL,

    -- Entité concernée (maire, utilisateur, département, etc.)
    entite_type VARCHAR(50) NULL,
    entite_id VARCHAR(100) NULL,
    entite_nom VARCHAR(255) NULL,

    -- Données techniques
    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(500) NULL,

    -- Données JSON pour informations supplémentaires
    donnees_json JSON NULL,

    -- Résultat de l'action
    statut ENUM('SUCCESS', 'FAILED', 'WARNING') DEFAULT 'SUCCESS',
    message_erreur TEXT NULL,

    -- Index pour recherches rapides
    INDEX idx_date_action (date_action),
    INDEX idx_utilisateur (utilisateur_id),
    INDEX idx_action (action),
    INDEX idx_categorie (categorie),
    INDEX idx_entite (entite_type, entite_id),
    INDEX idx_statut (statut),

    -- Clé étrangère vers utilisateurs (optionnelle car l'utilisateur peut être supprimé)
    CONSTRAINT fk_logs_utilisateur
        FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateurs(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Vue pour faciliter la consultation des logs
-- ============================================

CREATE OR REPLACE VIEW v_logs_activite AS
SELECT
    l.id,
    l.date_action,
    DATE_FORMAT(l.date_action, '%d/%m/%Y %H:%i:%s') AS date_formatee,
    l.utilisateur_id,
    COALESCE(l.utilisateur_nom, CONCAT(u.prenom, ' ', u.nom), 'Système') AS utilisateur,
    CASE l.utilisateur_type
        WHEN 1 THEN 'Admin Général'
        WHEN 2 THEN 'Admin'
        WHEN 3 THEN 'Référent'
        WHEN 4 THEN 'Membre'
        ELSE 'Inconnu'
    END AS role_utilisateur,
    l.action,
    l.categorie,
    l.description,
    l.entite_type,
    l.entite_id,
    l.entite_nom,
    l.ip_address,
    l.statut,
    l.message_erreur
FROM logs_activite l
LEFT JOIN utilisateurs u ON l.utilisateur_id = u.id
ORDER BY l.date_action DESC;

-- ============================================
-- Procédure pour nettoyer les anciens logs (optionnel)
-- Garde les logs des 6 derniers mois par défaut
-- ============================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS nettoyer_logs_anciens(IN mois_conservation INT)
BEGIN
    IF mois_conservation IS NULL OR mois_conservation < 1 THEN
        SET mois_conservation = 6;
    END IF;

    DELETE FROM logs_activite
    WHERE date_action < DATE_SUB(NOW(), INTERVAL mois_conservation MONTH);

    SELECT ROW_COUNT() AS logs_supprimes;
END //

DELIMITER ;

-- ============================================
-- Exemple d'utilisation:
-- CALL nettoyer_logs_anciens(6); -- Supprime les logs de plus de 6 mois
-- ============================================
