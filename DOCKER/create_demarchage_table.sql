-- Script de création de la table demarchage
CREATE TABLE IF NOT EXISTS `demarchage` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `maire_id` INT(11) NOT NULL,
  `demarche_active` TINYINT(1) NOT NULL DEFAULT 0,
  `contact_telephonique` TINYINT(1) NOT NULL DEFAULT 0,
  `rdv_date` DATE DEFAULT NULL,
  `commentaire` TEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_maire` (`maire_id`),
  CONSTRAINT `fk_demarchage_maire` FOREIGN KEY (`maire_id`) REFERENCES `maires` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index pour améliorer les performances
CREATE INDEX `idx_demarche_active` ON `demarchage` (`demarche_active`);
CREATE INDEX `idx_rdv_date` ON `demarchage` (`rdv_date`);
