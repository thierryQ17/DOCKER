-- Script pour modifier la table demarchage pour supporter 5 RDV
ALTER TABLE `demarchage`
DROP COLUMN `rdv_date`,
ADD COLUMN `rdv_date_1` DATETIME DEFAULT NULL AFTER `parrainage_obtenu`,
ADD COLUMN `rdv_date_2` DATETIME DEFAULT NULL AFTER `rdv_date_1`,
ADD COLUMN `rdv_date_3` DATETIME DEFAULT NULL AFTER `rdv_date_2`,
ADD COLUMN `rdv_date_4` DATETIME DEFAULT NULL AFTER `rdv_date_3`,
ADD COLUMN `rdv_date_5` DATETIME DEFAULT NULL AFTER `rdv_date_4`;

-- Index pour améliorer les performances
CREATE INDEX `idx_rdv_date_1` ON `demarchage` (`rdv_date_1`);
CREATE INDEX `idx_rdv_date_2` ON `demarchage` (`rdv_date_2`);
CREATE INDEX `idx_rdv_date_3` ON `demarchage` (`rdv_date_3`);
CREATE INDEX `idx_rdv_date_4` ON `demarchage` (`rdv_date_4`);
CREATE INDEX `idx_rdv_date_5` ON `demarchage` (`rdv_date_5`);
