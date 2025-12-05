-- Script pour ajouter le champ parrainage_obtenu à la table demarchage
ALTER TABLE `demarchage`
ADD COLUMN `parrainage_obtenu` TINYINT(1) NOT NULL DEFAULT 0 AFTER `contact_telephonique`;

-- Index pour améliorer les performances
CREATE INDEX `idx_parrainage_obtenu` ON `demarchage` (`parrainage_obtenu`);
