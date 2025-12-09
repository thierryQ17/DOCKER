-- Ajout de la colonne 'image' à la table utilisateurs
-- Pour stocker le chemin vers l'image du responsable UPR

ALTER TABLE utilisateurs ADD COLUMN IF NOT EXISTS image VARCHAR(255) DEFAULT NULL AFTER commentaires;

-- Vérification
DESCRIBE utilisateurs;
