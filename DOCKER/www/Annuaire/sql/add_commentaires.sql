-- Ajouter la colonne commentaires à la table utilisateurs
-- Note: Vérifier si la colonne existe avant d'exécuter

ALTER TABLE utilisateurs
ADD COLUMN commentaires TEXT NULL AFTER actif;

-- Afficher la structure mise à jour
DESCRIBE utilisateurs;
