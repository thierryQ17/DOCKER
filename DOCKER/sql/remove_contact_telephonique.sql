-- Script de migration : Suppression de la colonne contact_telephonique
-- Date : 2025-01-19
-- Description : Retire la colonne contact_telephonique de la table demarchage car elle n'est plus utilisée

USE annuairesMairesDeFrance;

-- Vérifier que la colonne existe avant de la supprimer
ALTER TABLE demarchage
DROP COLUMN IF EXISTS contact_telephonique;

-- Afficher la structure de la table après modification
DESCRIBE demarchage;
