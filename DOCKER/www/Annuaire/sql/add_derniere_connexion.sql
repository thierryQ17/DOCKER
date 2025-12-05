-- Ajouter la colonne derniere_connexion à la table utilisateurs
-- Note: Vérifier si la colonne existe avant d'exécuter

ALTER TABLE utilisateurs
ADD COLUMN derniere_connexion DATETIME NULL AFTER actif;

-- Créer un index pour les performances
CREATE INDEX idx_derniere_connexion ON utilisateurs(derniere_connexion);

-- Afficher la structure mise à jour
DESCRIBE utilisateurs;
