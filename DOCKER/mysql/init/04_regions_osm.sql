SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Ajouter les colonnes OSM et GeoJSON a la table regions (ignorer si existe deja)
-- Procedure pour ajouter une colonne seulement si elle n'existe pas
DELIMITER //
CREATE PROCEDURE AddColumnIfNotExists(
    IN tableName VARCHAR(100),
    IN columnName VARCHAR(100),
    IN columnDef VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = tableName
        AND COLUMN_NAME = columnName
    ) THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' ADD COLUMN ', columnName, ' ', columnDef);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

-- Ajouter les colonnes a regions
CALL AddColumnIfNotExists('regions', 'code_region', 'VARCHAR(10) DEFAULT NULL');
CALL AddColumnIfNotExists('regions', 'relation_osm', 'VARCHAR(50) DEFAULT NULL');
CALL AddColumnIfNotExists('regions', 'url_openstreetmap', 'TEXT DEFAULT NULL');
CALL AddColumnIfNotExists('regions', 'geojson', 'LONGTEXT DEFAULT NULL');

-- Ajouter les colonnes a departements
CALL AddColumnIfNotExists('departements', 'relation_osm', 'VARCHAR(50) DEFAULT NULL');
CALL AddColumnIfNotExists('departements', 'url_openstreetmap', 'TEXT DEFAULT NULL');
CALL AddColumnIfNotExists('departements', 'geojson', 'LONGTEXT DEFAULT NULL');

-- Supprimer la procedure
DROP PROCEDURE IF EXISTS AddColumnIfNotExists;

-- Mettre a jour les regions avec leurs IDs OpenStreetMap
-- Source: https://www.openstreetmap.org/relation/[id]

UPDATE regions SET code_region = '84', relation_osm = '3792877', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792877' WHERE nom_region = 'Auvergne-Rhone-Alpes';
UPDATE regions SET code_region = '27', relation_osm = '3792878', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792878' WHERE nom_region = 'Bourgogne-Franche-Comte';
UPDATE regions SET code_region = '53', relation_osm = '102740', url_openstreetmap = 'https://www.openstreetmap.org/relation/102740' WHERE nom_region = 'Bretagne';
UPDATE regions SET code_region = '24', relation_osm = '8640', url_openstreetmap = 'https://www.openstreetmap.org/relation/8640' WHERE nom_region = 'Centre-Val-de-Loire';
UPDATE regions SET code_region = '94', relation_osm = '76910', url_openstreetmap = 'https://www.openstreetmap.org/relation/76910' WHERE nom_region = 'Corse';
UPDATE regions SET code_region = '44', relation_osm = '3792876', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792876' WHERE nom_region = 'Grand-Est';
UPDATE regions SET code_region = '32', relation_osm = '3792883', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792883' WHERE nom_region = 'Hauts-de-France';
UPDATE regions SET code_region = '11', relation_osm = '8649', url_openstreetmap = 'https://www.openstreetmap.org/relation/8649' WHERE nom_region = 'Ile-de-France';
UPDATE regions SET code_region = '28', relation_osm = '3793170', url_openstreetmap = 'https://www.openstreetmap.org/relation/3793170' WHERE nom_region = 'Normandie';
UPDATE regions SET code_region = '75', relation_osm = '3792880', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792880' WHERE nom_region = 'Nouvelle-Aquitaine';
UPDATE regions SET code_region = '76', relation_osm = '3792879', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792879' WHERE nom_region = 'Occitanie';
UPDATE regions SET code_region = '52', relation_osm = '8650', url_openstreetmap = 'https://www.openstreetmap.org/relation/8650' WHERE nom_region = 'Pays-de-la-Loire';
UPDATE regions SET code_region = '93', relation_osm = '3792881', url_openstreetmap = 'https://www.openstreetmap.org/relation/3792881' WHERE nom_region = 'Provence-Alpes-Cote-d-Azur';

-- Mettre a jour les departements avec leurs IDs OpenStreetMap
UPDATE departements SET relation_osm = '7382', url_openstreetmap = 'https://www.openstreetmap.org/relation/7382' WHERE numero_departement = '01';
UPDATE departements SET relation_osm = '7836', url_openstreetmap = 'https://www.openstreetmap.org/relation/7836' WHERE numero_departement = '02';
UPDATE departements SET relation_osm = '7842', url_openstreetmap = 'https://www.openstreetmap.org/relation/7842' WHERE numero_departement = '03';
UPDATE departements SET relation_osm = '7630', url_openstreetmap = 'https://www.openstreetmap.org/relation/7630' WHERE numero_departement = '04';
UPDATE departements SET relation_osm = '7632', url_openstreetmap = 'https://www.openstreetmap.org/relation/7632' WHERE numero_departement = '05';
UPDATE departements SET relation_osm = '7643', url_openstreetmap = 'https://www.openstreetmap.org/relation/7643' WHERE numero_departement = '06';
UPDATE departements SET relation_osm = '7627', url_openstreetmap = 'https://www.openstreetmap.org/relation/7627' WHERE numero_departement = '07';
UPDATE departements SET relation_osm = '7360', url_openstreetmap = 'https://www.openstreetmap.org/relation/7360' WHERE numero_departement = '08';
UPDATE departements SET relation_osm = '7650', url_openstreetmap = 'https://www.openstreetmap.org/relation/7650' WHERE numero_departement = '09';
UPDATE departements SET relation_osm = '7370', url_openstreetmap = 'https://www.openstreetmap.org/relation/7370' WHERE numero_departement = '10';
UPDATE departements SET relation_osm = '7651', url_openstreetmap = 'https://www.openstreetmap.org/relation/7651' WHERE numero_departement = '11';
UPDATE departements SET relation_osm = '7656', url_openstreetmap = 'https://www.openstreetmap.org/relation/7656' WHERE numero_departement = '12';
UPDATE departements SET relation_osm = '7635', url_openstreetmap = 'https://www.openstreetmap.org/relation/7635' WHERE numero_departement = '13';
UPDATE departements SET relation_osm = '7426', url_openstreetmap = 'https://www.openstreetmap.org/relation/7426' WHERE numero_departement = '14';
UPDATE departements SET relation_osm = '7844', url_openstreetmap = 'https://www.openstreetmap.org/relation/7844' WHERE numero_departement = '15';
UPDATE departements SET relation_osm = '7400', url_openstreetmap = 'https://www.openstreetmap.org/relation/7400' WHERE numero_departement = '16';
UPDATE departements SET relation_osm = '7406', url_openstreetmap = 'https://www.openstreetmap.org/relation/7406' WHERE numero_departement = '17';
UPDATE departements SET relation_osm = '7350', url_openstreetmap = 'https://www.openstreetmap.org/relation/7350' WHERE numero_departement = '18';
UPDATE departements SET relation_osm = '7408', url_openstreetmap = 'https://www.openstreetmap.org/relation/7408' WHERE numero_departement = '19';
UPDATE departements SET relation_osm = '7377', url_openstreetmap = 'https://www.openstreetmap.org/relation/7377' WHERE numero_departement = '21';
UPDATE departements SET relation_osm = '7420', url_openstreetmap = 'https://www.openstreetmap.org/relation/7420' WHERE numero_departement = '22';
UPDATE departements SET relation_osm = '7409', url_openstreetmap = 'https://www.openstreetmap.org/relation/7409' WHERE numero_departement = '23';
UPDATE departements SET relation_osm = '7410', url_openstreetmap = 'https://www.openstreetmap.org/relation/7410' WHERE numero_departement = '24';
UPDATE departements SET relation_osm = '7379', url_openstreetmap = 'https://www.openstreetmap.org/relation/7379' WHERE numero_departement = '25';
UPDATE departements SET relation_osm = '7628', url_openstreetmap = 'https://www.openstreetmap.org/relation/7628' WHERE numero_departement = '26';
UPDATE departements SET relation_osm = '7428', url_openstreetmap = 'https://www.openstreetmap.org/relation/7428' WHERE numero_departement = '27';
UPDATE departements SET relation_osm = '7351', url_openstreetmap = 'https://www.openstreetmap.org/relation/7351' WHERE numero_departement = '28';
UPDATE departements SET relation_osm = '7421', url_openstreetmap = 'https://www.openstreetmap.org/relation/7421' WHERE numero_departement = '29';
UPDATE departements SET relation_osm = '76908', url_openstreetmap = 'https://www.openstreetmap.org/relation/76908' WHERE numero_departement = '2A';
UPDATE departements SET relation_osm = '76909', url_openstreetmap = 'https://www.openstreetmap.org/relation/76909' WHERE numero_departement = '2B';
UPDATE departements SET relation_osm = '7657', url_openstreetmap = 'https://www.openstreetmap.org/relation/7657' WHERE numero_departement = '30';
UPDATE departements SET relation_osm = '7658', url_openstreetmap = 'https://www.openstreetmap.org/relation/7658' WHERE numero_departement = '31';
UPDATE departements SET relation_osm = '7659', url_openstreetmap = 'https://www.openstreetmap.org/relation/7659' WHERE numero_departement = '32';
UPDATE departements SET relation_osm = '7411', url_openstreetmap = 'https://www.openstreetmap.org/relation/7411' WHERE numero_departement = '33';
UPDATE departements SET relation_osm = '7660', url_openstreetmap = 'https://www.openstreetmap.org/relation/7660' WHERE numero_departement = '34';
UPDATE departements SET relation_osm = '7422', url_openstreetmap = 'https://www.openstreetmap.org/relation/7422' WHERE numero_departement = '35';
UPDATE departements SET relation_osm = '7352', url_openstreetmap = 'https://www.openstreetmap.org/relation/7352' WHERE numero_departement = '36';
UPDATE departements SET relation_osm = '7353', url_openstreetmap = 'https://www.openstreetmap.org/relation/7353' WHERE numero_departement = '37';
UPDATE departements SET relation_osm = '7383', url_openstreetmap = 'https://www.openstreetmap.org/relation/7383' WHERE numero_departement = '38';
UPDATE departements SET relation_osm = '7380', url_openstreetmap = 'https://www.openstreetmap.org/relation/7380' WHERE numero_departement = '39';
UPDATE departements SET relation_osm = '7412', url_openstreetmap = 'https://www.openstreetmap.org/relation/7412' WHERE numero_departement = '40';
UPDATE departements SET relation_osm = '7354', url_openstreetmap = 'https://www.openstreetmap.org/relation/7354' WHERE numero_departement = '41';
UPDATE departements SET relation_osm = '7384', url_openstreetmap = 'https://www.openstreetmap.org/relation/7384' WHERE numero_departement = '42';
UPDATE departements SET relation_osm = '7848', url_openstreetmap = 'https://www.openstreetmap.org/relation/7848' WHERE numero_departement = '43';
UPDATE departements SET relation_osm = '7435', url_openstreetmap = 'https://www.openstreetmap.org/relation/7435' WHERE numero_departement = '44';
UPDATE departements SET relation_osm = '7355', url_openstreetmap = 'https://www.openstreetmap.org/relation/7355' WHERE numero_departement = '45';
UPDATE departements SET relation_osm = '7661', url_openstreetmap = 'https://www.openstreetmap.org/relation/7661' WHERE numero_departement = '46';
UPDATE departements SET relation_osm = '7413', url_openstreetmap = 'https://www.openstreetmap.org/relation/7413' WHERE numero_departement = '47';
UPDATE departements SET relation_osm = '7662', url_openstreetmap = 'https://www.openstreetmap.org/relation/7662' WHERE numero_departement = '48';
UPDATE departements SET relation_osm = '7436', url_openstreetmap = 'https://www.openstreetmap.org/relation/7436' WHERE numero_departement = '49';
UPDATE departements SET relation_osm = '7429', url_openstreetmap = 'https://www.openstreetmap.org/relation/7429' WHERE numero_departement = '50';
UPDATE departements SET relation_osm = '7362', url_openstreetmap = 'https://www.openstreetmap.org/relation/7362' WHERE numero_departement = '51';
UPDATE departements SET relation_osm = '7371', url_openstreetmap = 'https://www.openstreetmap.org/relation/7371' WHERE numero_departement = '52';
UPDATE departements SET relation_osm = '7437', url_openstreetmap = 'https://www.openstreetmap.org/relation/7437' WHERE numero_departement = '53';
UPDATE departements SET relation_osm = '7363', url_openstreetmap = 'https://www.openstreetmap.org/relation/7363' WHERE numero_departement = '54';
UPDATE departements SET relation_osm = '7364', url_openstreetmap = 'https://www.openstreetmap.org/relation/7364' WHERE numero_departement = '55';
UPDATE departements SET relation_osm = '7423', url_openstreetmap = 'https://www.openstreetmap.org/relation/7423' WHERE numero_departement = '56';
UPDATE departements SET relation_osm = '7365', url_openstreetmap = 'https://www.openstreetmap.org/relation/7365' WHERE numero_departement = '57';
UPDATE departements SET relation_osm = '7378', url_openstreetmap = 'https://www.openstreetmap.org/relation/7378' WHERE numero_departement = '58';
UPDATE departements SET relation_osm = '7838', url_openstreetmap = 'https://www.openstreetmap.org/relation/7838' WHERE numero_departement = '59';
UPDATE departements SET relation_osm = '7839', url_openstreetmap = 'https://www.openstreetmap.org/relation/7839' WHERE numero_departement = '60';
UPDATE departements SET relation_osm = '7430', url_openstreetmap = 'https://www.openstreetmap.org/relation/7430' WHERE numero_departement = '61';
UPDATE departements SET relation_osm = '7840', url_openstreetmap = 'https://www.openstreetmap.org/relation/7840' WHERE numero_departement = '62';
UPDATE departements SET relation_osm = '7850', url_openstreetmap = 'https://www.openstreetmap.org/relation/7850' WHERE numero_departement = '63';
UPDATE departements SET relation_osm = '7414', url_openstreetmap = 'https://www.openstreetmap.org/relation/7414' WHERE numero_departement = '64';
UPDATE departements SET relation_osm = '7663', url_openstreetmap = 'https://www.openstreetmap.org/relation/7663' WHERE numero_departement = '65';
UPDATE departements SET relation_osm = '7664', url_openstreetmap = 'https://www.openstreetmap.org/relation/7664' WHERE numero_departement = '66';
UPDATE departements SET relation_osm = '7366', url_openstreetmap = 'https://www.openstreetmap.org/relation/7366' WHERE numero_departement = '67';
UPDATE departements SET relation_osm = '7367', url_openstreetmap = 'https://www.openstreetmap.org/relation/7367' WHERE numero_departement = '68';
UPDATE departements SET relation_osm = '7385', url_openstreetmap = 'https://www.openstreetmap.org/relation/7385' WHERE numero_departement = '69';
UPDATE departements SET relation_osm = '7381', url_openstreetmap = 'https://www.openstreetmap.org/relation/7381' WHERE numero_departement = '70';
UPDATE departements SET relation_osm = '7386', url_openstreetmap = 'https://www.openstreetmap.org/relation/7386' WHERE numero_departement = '71';
UPDATE departements SET relation_osm = '7438', url_openstreetmap = 'https://www.openstreetmap.org/relation/7438' WHERE numero_departement = '72';
UPDATE departements SET relation_osm = '7387', url_openstreetmap = 'https://www.openstreetmap.org/relation/7387' WHERE numero_departement = '73';
UPDATE departements SET relation_osm = '7388', url_openstreetmap = 'https://www.openstreetmap.org/relation/7388' WHERE numero_departement = '74';
UPDATE departements SET relation_osm = '7444', url_openstreetmap = 'https://www.openstreetmap.org/relation/7444' WHERE numero_departement = '75';
UPDATE departements SET relation_osm = '7431', url_openstreetmap = 'https://www.openstreetmap.org/relation/7431' WHERE numero_departement = '76';
UPDATE departements SET relation_osm = '7445', url_openstreetmap = 'https://www.openstreetmap.org/relation/7445' WHERE numero_departement = '77';
UPDATE departements SET relation_osm = '7446', url_openstreetmap = 'https://www.openstreetmap.org/relation/7446' WHERE numero_departement = '78';
UPDATE departements SET relation_osm = '7401', url_openstreetmap = 'https://www.openstreetmap.org/relation/7401' WHERE numero_departement = '79';
UPDATE departements SET relation_osm = '7841', url_openstreetmap = 'https://www.openstreetmap.org/relation/7841' WHERE numero_departement = '80';
UPDATE departements SET relation_osm = '7665', url_openstreetmap = 'https://www.openstreetmap.org/relation/7665' WHERE numero_departement = '81';
UPDATE departements SET relation_osm = '7666', url_openstreetmap = 'https://www.openstreetmap.org/relation/7666' WHERE numero_departement = '82';
UPDATE departements SET relation_osm = '7636', url_openstreetmap = 'https://www.openstreetmap.org/relation/7636' WHERE numero_departement = '83';
UPDATE departements SET relation_osm = '7637', url_openstreetmap = 'https://www.openstreetmap.org/relation/7637' WHERE numero_departement = '84';
UPDATE departements SET relation_osm = '7439', url_openstreetmap = 'https://www.openstreetmap.org/relation/7439' WHERE numero_departement = '85';
UPDATE departements SET relation_osm = '7402', url_openstreetmap = 'https://www.openstreetmap.org/relation/7402' WHERE numero_departement = '86';
UPDATE departements SET relation_osm = '7415', url_openstreetmap = 'https://www.openstreetmap.org/relation/7415' WHERE numero_departement = '87';
UPDATE departements SET relation_osm = '7368', url_openstreetmap = 'https://www.openstreetmap.org/relation/7368' WHERE numero_departement = '88';
UPDATE departements SET relation_osm = '7389', url_openstreetmap = 'https://www.openstreetmap.org/relation/7389' WHERE numero_departement = '89';
UPDATE departements SET relation_osm = '7376', url_openstreetmap = 'https://www.openstreetmap.org/relation/7376' WHERE numero_departement = '90';
UPDATE departements SET relation_osm = '7447', url_openstreetmap = 'https://www.openstreetmap.org/relation/7447' WHERE numero_departement = '91';
UPDATE departements SET relation_osm = '7448', url_openstreetmap = 'https://www.openstreetmap.org/relation/7448' WHERE numero_departement = '92';
UPDATE departements SET relation_osm = '7449', url_openstreetmap = 'https://www.openstreetmap.org/relation/7449' WHERE numero_departement = '93';
UPDATE departements SET relation_osm = '7450', url_openstreetmap = 'https://www.openstreetmap.org/relation/7450' WHERE numero_departement = '94';
UPDATE departements SET relation_osm = '7451', url_openstreetmap = 'https://www.openstreetmap.org/relation/7451' WHERE numero_departement = '95';

COMMIT;
