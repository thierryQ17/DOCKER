-- Migration : Ajout du champ statut_demarchage
-- Date : 2025-01-20
-- Description : Ajout d'un champ pour suivre le statut détaillé du démarchage

-- Ajouter la colonne statut_demarchage
ALTER TABLE demarchage
ADD COLUMN statut_demarchage TINYINT(1) DEFAULT 0 AFTER parrainage_obtenu;

-- Valeurs possibles :
-- 0 = Aucun statut (par défaut)
-- 1 = Démarchage en cours (gris clair)
-- 2 = Rendez-vous obtenu (vert, gras)
-- 3 = Démarchage terminé (sans suite) (rouge, barré)
-- 4 = Parrainage obtenu (fond gris foncé, texte jaune, gras)

-- Commentaire sur la colonne
ALTER TABLE demarchage
MODIFY COLUMN statut_demarchage TINYINT(1) DEFAULT 0
COMMENT '0=Aucun, 1=En cours, 2=RDV obtenu, 3=Terminé sans suite, 4=Parrainage obtenu';
