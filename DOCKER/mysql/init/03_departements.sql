SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Table pour les départements
DROP TABLE IF EXISTS departements;

CREATE TABLE departements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_departement VARCHAR(10) NOT NULL,
    nom_departement VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    UNIQUE KEY unique_dept (numero_departement, nom_departement),
    INDEX idx_numero (numero_departement),
    INDEX idx_nom (nom_departement),
    INDEX idx_region (region)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des départements uniques

INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (1, '01', 'Ain', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (2, '02', 'Aisne', 'Hauts-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (3, '03', 'Allier', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (4, '04', 'Alpes-de-Haute-Provence', 'Provence-Alpes-Cote-d-Azur');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (5, '05', 'Hautes-Alpes', 'Provence-Alpes-Cote-d-Azur');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (6, '06', 'Alpes-Maritimes', 'Provence-Alpes-Cote-d-Azur');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (7, '07', 'Ardeche', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (8, '08', 'Ardennes', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (9, '09', 'Ariege', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (10, '10', 'Aube', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (11, '11', 'Aude', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (12, '12', 'Aveyron', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (13, '13', 'Bouches-du-Rhone', 'Provence-Alpes-Cote-d-Azur');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (14, '14', 'Calvados', 'Normandie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (15, '15', 'Cantal', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (16, '16', 'Charente', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (17, '17', 'Charente-Maritime', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (18, '18', 'Cher', 'Centre-Val-de-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (19, '19', 'Correze', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (20, '21', 'Cote-d-Or', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (21, '22', 'Cotes-d-Armor', 'Bretagne');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (22, '23', 'Creuse', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (23, '24', 'Dordogne', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (24, '25', 'Doubs', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (25, '26', 'Drome', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (26, '27', 'Eure', 'Normandie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (27, '28', 'Eure-et-Loir', 'Centre-Val-de-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (28, '29', 'Finistere', 'Bretagne');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (29, '2A', 'Corse-du-Sud', 'Corse');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (30, '2B', 'Haute-Corse', 'Corse');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (31, '30', 'Gard', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (32, '31', 'Haute-Garonne', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (33, '32', 'Gers', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (34, '33', 'Gironde', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (35, '34', 'Herault', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (36, '35', 'Ille-et-Vilaine', 'Bretagne');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (37, '36', 'Indre', 'Centre-Val-de-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (38, '37', 'Indre-et-Loire', 'Centre-Val-de-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (39, '38', 'Isere', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (40, '39', 'Jura', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (41, '40', 'Landes', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (42, '41', 'Loir-et-Cher', 'Centre-Val-de-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (43, '42', 'Loire', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (44, '43', 'Haute-Loire', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (45, '44', 'Loire-Atlantique', 'Pays-de-la-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (46, '45', 'Loiret', 'Centre-Val-de-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (47, '46', 'Lot', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (48, '47', 'Lot-et-Garonne', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (49, '48', 'Lozere', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (50, '49', 'Maine-et-Loire', 'Pays-de-la-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (51, '50', 'Manche', 'Normandie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (52, '51', 'Marne', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (53, '52', 'Haute-Marne', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (54, '53', 'Mayenne', 'Pays-de-la-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (55, '54', 'Meurthe-et-Moselle', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (56, '55', 'Meuse', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (57, '56', 'Morbihan', 'Bretagne');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (58, '57', 'Moselle', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (59, '58', 'Nievre', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (60, '59', 'Nord', 'Hauts-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (61, '60', 'Oise', 'Hauts-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (62, '61', 'Orne', 'Normandie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (63, '62', 'Pas-de-Calais', 'Hauts-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (64, '63', 'Puy-de-Dome', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (65, '64', 'Pyrenees-Atlantiques', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (66, '65', 'Hautes-Pyrenees', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (67, '66', 'Pyrenees-Orientales', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (68, '67', 'Bas-Rhin', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (69, '68', 'Haut-Rhin', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (70, '69', 'Rhone', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (71, '70', 'Haute-Saone', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (72, '71', 'Saone-et-Loire', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (73, '72', 'Sarthe', 'Pays-de-la-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (74, '73', 'Savoie', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (75, '74', 'Haute-Savoie', 'Auvergne-Rhone-Alpes');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (76, '75', 'Paris', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (77, '76', 'Seine-Maritime', 'Normandie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (78, '77', 'Seine-et-Marne', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (79, '78', 'Yvelines', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (80, '79', 'Deux-Sevres', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (81, '80', 'Somme', 'Hauts-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (82, '81', 'Tarn', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (83, '82', 'Tarn-et-Garonne', 'Occitanie');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (84, '83', 'Var', 'Provence-Alpes-Cote-d-Azur');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (85, '84', 'Vaucluse', 'Provence-Alpes-Cote-d-Azur');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (86, '85', 'Vendee', 'Pays-de-la-Loire');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (87, '86', 'Vienne', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (88, '87', 'Haute-Vienne', 'Nouvelle-Aquitaine');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (89, '88', 'Vosges', 'Grand-Est');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (90, '89', 'Yonne', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (91, '90', 'Territoire-de-Belfort', 'Bourgogne-Franche-Comte');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (92, '91', 'Essonne', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (93, '92', 'Hauts-de-Seine', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (94, '93', 'Seine-Saint-Denis', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (95, '94', 'Val-de-Marne', 'Ile-de-France');
INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (96, '95', 'Val-d-Oise', 'Ile-de-France');

COMMIT;
