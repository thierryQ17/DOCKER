SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Table pour les circonscriptions avec foreign keys
DROP TABLE IF EXISTS circonscriptions;

CREATE TABLE circonscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT NOT NULL,
    departement_id INT NOT NULL,
    region VARCHAR(100) NOT NULL,
    numero_departement VARCHAR(10) NOT NULL,
    nom_departement VARCHAR(100) NOT NULL,
    circonscription VARCHAR(50) NOT NULL,
    canton VARCHAR(150) NOT NULL,
    INDEX idx_region_id (region_id),
    INDEX idx_departement_id (departement_id),
    INDEX idx_region (region),
    INDEX idx_numero_departement (numero_departement),
    INDEX idx_circonscription (circonscription),
    FOREIGN KEY (region_id) REFERENCES regions(id) ON DELETE CASCADE,
    FOREIGN KEY (departement_id) REFERENCES departements(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des données avec subqueries pour obtenir les foreign keys

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '1ere circo', 'Ambérieu-en-Bugey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '1ere circo', 'Attignat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '1ere circo', 'Belley'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '1ere circo', 'Bourg-en-Bresse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '1ere circo', 'Bourg-en-Bresse-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '2e circo', 'Bourg-en-Bresse-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '2e circo', 'Ceyzériat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '2e circo', 'Châtillon-sur-Chalaronne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '2e circo', 'Gex'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '2e circo', 'Lagnieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '3e circo', 'Meximieux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '3e circo', 'Miribel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '3e circo', 'Nantua'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '3e circo', 'Oyonnax'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '3e circo', 'Plateau d’Hauteville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '4e circo', 'Pont-d''Ain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '4e circo', 'Replonges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '4e circo', 'Saint-Étienne-du-Bois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '4e circo', 'Saint-Genis-Pouilly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '4e circo', 'Thoiry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '5e circo', 'Trévoux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '5e circo', 'Valserhône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '5e circo', 'Villars-les-Dombes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '01', 'Ain', '5e circo', 'Vonnas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '01' AND d.nom_departement = 'Ain' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Bellerive-sur-Allier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Bourbon-l''Archambault'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Commentry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Cusset'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Dompierre-sur-Besbre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Gannat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Huriel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '1ere circo', 'Lapalisse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Montluçon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Montluçon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Montluçon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Montluçon-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Montluçon-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Moulins'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Moulins-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '2e circo', 'Moulins-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '3e circo', 'Saint-Pourçain-sur-Sioule'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '3e circo', 'Souvigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '3e circo', 'Vichy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '3e circo', 'Vichy-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '3e circo', 'Vichy-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '03', 'Allier', '3e circo', 'Yzeure'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '03' AND d.nom_departement = 'Allier' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Annonay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Annonay-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Annonay-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Aubenas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Aubenas-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Aubenas-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '1ere circo', 'Berg-Helvie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Bourg-Saint-Andéol'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Guilherand-Granges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Haute-Ardèche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Haut-Eyrieux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Haut-Vivarais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Le Pouzin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '2e circo', 'Les Cévennes Ardéchoises'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '3e circo', 'Privas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '3e circo', 'Rhône-Eyrieux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '3e circo', 'Sarras'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '3e circo', 'Tournon-sur-Rhône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '07', 'Ardeche', '3e circo', 'Vallon-Pont-d''Arc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '07' AND d.nom_departement = 'Ardeche' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Arpajon-sur-Cère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Aurillac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Aurillac-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Mauriac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Maurs'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Murat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Naucelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '1ere circo', 'Neuvéglise-sur-Truyère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Riom-ès-Montagnes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Saint-Flour'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Saint-Flour-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Saint-Flour-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Saint-Paul-des-Landes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Vic-sur-Cère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '15', 'Cantal', '2e circo', 'Ydes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '15' AND d.nom_departement = 'Cantal' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '1ere circo', 'Bourg-de-Péage'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '1ere circo', 'Crest'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '1ere circo', 'Dieulefit'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '1ere circo', 'Drôme des collines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '1ere circo', 'Grignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '2e circo', 'Le Diois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '2e circo', 'Le Tricastin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '2e circo', 'Loriol-sur-Drôme'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '2e circo', 'Montélimar'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '2e circo', 'Montélimar-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '3e circo', 'Montélimar-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '3e circo', 'Nyons et Baronnies'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '3e circo', 'Romans-sur-Isère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '3e circo', 'Saint-Vallier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '3e circo', 'Tain-l''Hermitage'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '4e circo', 'Valence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '4e circo', 'Valence-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '4e circo', 'Valence-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '4e circo', 'Valence-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '26', 'Drome', '4e circo', 'Vercors-Monts du Matin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '26' AND d.nom_departement = 'Drome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '10e circo', 'Vienne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '10e circo', 'Voiron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '1ere circo', 'Bièvre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '1ere circo', 'Bourgoin-Jallieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '1ere circo', 'Chartreuse-Guiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '2e circo', 'Charvieu-Chavagneux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '2e circo', 'Échirolles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '2e circo', 'Fontaine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '3e circo', 'Fontaine-Seyssinet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '3e circo', 'Fontaine-Vercors'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '3e circo', 'Grenoble'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '4e circo', 'Grenoble-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '4e circo', 'La Tour-du-Pin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '4e circo', 'L''Isle-d''Abeau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '5e circo', 'La Verpillière'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '5e circo', 'Le Grand-Lemps'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '5e circo', 'Le Haut-Grésivaudan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '6e circo', 'Le Moyen Grésivaudan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '6e circo', 'Le Pont-de-Claix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '6e circo', 'Le Sud Grésivaudan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '7e circo', 'Matheysine-Trièves'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '7e circo', 'Meylan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '7e circo', 'Morestel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '8e circo', 'Oisans-Romanche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '8e circo', 'Roussillon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '8e circo', 'Saint-Martin-d''Hères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '9e circo', 'Tullins'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '9e circo', 'Vienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '38', 'Isere', '9e circo', 'Vienne-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '38' AND d.nom_departement = 'Isere' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '1ere circo', 'Andrézieux-Bouthéon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '1ere circo', 'Boën-sur-Lignon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '1ere circo', 'Charlieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '1ere circo', 'Feurs'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '2e circo', 'Firminy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '2e circo', 'Le Coteau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '2e circo', 'Le Pilat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '2e circo', 'Montbrison'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '3e circo', 'Renaison'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '3e circo', 'Rive-de-Gier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '3e circo', 'Roanne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '3e circo', 'Roanne-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '4e circo', 'Roanne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '4e circo', 'Saint-Chamond'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '4e circo', 'Saint-Étienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '4e circo', 'Saint-Etienne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '5e circo', 'Saint-Etienne-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '5e circo', 'Saint-Etienne-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '5e circo', 'Saint-Etienne-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '5e circo', 'Saint-Just-Saint-Rambert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '42', 'Loire', '6e circo', 'Sorbiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '42' AND d.nom_departement = 'Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Aurec-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Bas-en-Basset'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Boutières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Brioude'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Emblavez-et-Meygal'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Gorges de l''Allier-Gévaudan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Le Puy-en-Velay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Le Puy-en-Velay-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Le Puy-en-Velay-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '1ere circo', 'Le Puy-en-Velay-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Le Puy-en-Velay-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Les Deux Rivières et Vallées'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Mézenc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Monistrol-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Pays de Lafayette'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Plateau du Haut-Velay granitique'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Sainte-Florine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Saint-Paulien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Velay volcanique'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '43', 'Haute-Loire', '2e circo', 'Yssingeaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '43' AND d.nom_departement = 'Haute-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '1ere circo', 'Aigueperse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '1ere circo', 'Ambert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '1ere circo', 'Aubière'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '1ere circo', 'Beaumont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '1ere circo', 'Billom'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '1ere circo', 'Brassac-les-Mines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '2e circo', 'Cébazat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '2e circo', 'Chamalières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '2e circo', 'Châtel-Guyon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '2e circo', 'Clermont-Ferrand'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '2e circo', 'Cournon-d''Auvergne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '2e circo', 'Gerzat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '3e circo', 'Issoire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '3e circo', 'Le Sancy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '3e circo', 'Les Martres-de-Veyre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '3e circo', 'Les Monts du Livradois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '3e circo', 'Lezoux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '3e circo', 'Maringues'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '4e circo', 'Orcines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '4e circo', 'Pont-du-Château'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '4e circo', 'Riom'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '4e circo', 'Saint-Éloy-les-Mines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '4e circo', 'Saint-Georges-de-Mons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '4e circo', 'Saint-Ours'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '5e circo', 'Thiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '63', 'Puy-de-Dome', '5e circo', 'Vic-le-Comte'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '63' AND d.nom_departement = 'Puy-de-Dome' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '10e circo', 'Tarare'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '11e circo', 'Thizy-les-Bourgs'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '12e circo', 'Val d''Oingt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '13e circo', 'Vaugneray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '14e circo', 'Villefranche-sur-Saône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '1ere circo', 'Anse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '2e circo', 'Belleville-en-Beaujolais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '3e circo', 'Brignais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '4e circo', 'Genas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '5e circo', 'Gleizé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '6e circo', 'L''Arbresle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '7e circo', 'Lyon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '8e circo', 'Mornant'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '69', 'Rhone', '9e circo', 'Saint-Symphorien-d''Ozon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '69' AND d.nom_departement = 'Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '1ere circo', 'Aix-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '1ere circo', 'Aix-les-Bains-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '1ere circo', 'Aix-les-Bains-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '1ere circo', 'Albertville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '1ere circo', 'Albertville-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '1ere circo', 'Albertville-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '2e circo', 'Bourg-Saint-Maurice'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '2e circo', 'Bugey savoyard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '2e circo', 'Chambéry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '2e circo', 'Chambéry-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '2e circo', 'Chambéry-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '2e circo', 'Chambéry-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '3e circo', 'La Motte-Servolex'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '3e circo', 'La Ravoire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '3e circo', 'Le Pont-de-Beauvoisin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '3e circo', 'Modane'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '3e circo', 'Montmélian'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '3e circo', 'Moûtiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '4e circo', 'Saint-Alban-Leysse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '4e circo', 'Saint-Jean-de-Maurienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '4e circo', 'Saint-Pierre-d''Albigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '73', 'Savoie', '4e circo', 'Ugine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '73' AND d.nom_departement = 'Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '1ere circo', 'Annecy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '1ere circo', 'Annecy-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '1ere circo', 'Annecy-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '2e circo', 'Annecy-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '2e circo', 'Annecy-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '2e circo', 'Annemasse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '3e circo', 'Bonneville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '3e circo', 'Cluses'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '3e circo', 'Évian-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '4e circo', 'Faverges-Seythenex'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '4e circo', 'Gaillard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '4e circo', 'La Roche-sur-Foron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '5e circo', 'Le Mont-Blanc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '5e circo', 'Rumilly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '5e circo', 'Saint-Julien-en-Genevois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '6e circo', 'Sallanches'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '6e circo', 'Sciez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Auvergne-Rhone-Alpes', '74', 'Haute-Savoie', '6e circo', 'Thonon-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '74' AND d.nom_departement = 'Haute-Savoie' AND d.region = r.nom_region
WHERE r.nom_region = 'Auvergne-Rhone-Alpes';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Arnay-le-Duc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Auxonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Beaune'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Brazey-en-Plaine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Châtillon-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Chenôve'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Chevigny-Saint-Sauveur'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Dijon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Dijon-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Fontaine-lès-Dijon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Genlis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Is-sur-Tille'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Ladoix-Serrigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Longvic'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Montbard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Nuits-Saint-Georges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Saint-Apollinaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Semur-en-Auxois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '21', 'Cote-d-Or', 'A verifier', 'Talant'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '21' AND d.nom_departement = 'Cote-d-Or' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '1ere circo', 'Audincourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '1ere circo', 'Baume-les-Dames'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '1ere circo', 'Bavans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '1ere circo', 'Besançon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '2e circo', 'Besançon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '2e circo', 'Besançon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '2e circo', 'Besançon-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '2e circo', 'Besançon-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '3e circo', 'Besançon-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '3e circo', 'Besançon-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '3e circo', 'Bethoncourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '3e circo', 'Frasne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '4e circo', 'Maîche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '4e circo', 'Montbéliard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '4e circo', 'Morteau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '4e circo', 'Ornans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '5e circo', 'Pontarlier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '5e circo', 'Saint-Vit'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '5e circo', 'Valdahon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '25', 'Doubs', '5e circo', 'Valentigney'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '25' AND d.nom_departement = 'Doubs' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Arbois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Authume'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Bletterans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Champagnole'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Coteaux du Lizon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Dole'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '1ere circo', 'Dole-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Dole-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Hauts de Bienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Lons-le-Saunier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Lons-le-Saunier-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Lons-le-Saunier-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Moirans-en-Montagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '2e circo', 'Mont-sous-Vaudrey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '3e circo', 'Poligny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '3e circo', 'Saint-Amour'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '3e circo', 'Saint-Claude'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '3e circo', 'Saint-Laurent-en-Grandvaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '39', 'Jura', '3e circo', 'Tavaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '39' AND d.nom_departement = 'Jura' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Château-Chinon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Clamecy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Corbigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Cosne-Cours-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Decize'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Fourchambault'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Guérigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'Imphy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '1ere circo', 'La Charité-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Luzy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Nevers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Nevers-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Nevers-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Nevers-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Pouilly-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Saint-Pierre-le-Moûtier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '58', 'Nievre', '2e circo', 'Varennes-Vauzelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '58' AND d.nom_departement = 'Nievre' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Dampierre-sur-Salon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Fougerolles-Saint-Valbert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Gray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Héricourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Héricourt-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Héricourt-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Jussey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Lure'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Lure-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Lure-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '1ere circo', 'Luxeuil-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Marnay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Mélisey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Port-sur-Saône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Rioz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Saint-Loup-sur-Semouse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Scey-sur-Saône-et-Saint-Albin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Vesoul'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Vesoul-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Vesoul-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '70', 'Haute-Saone', '2e circo', 'Villersexel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '70' AND d.nom_departement = 'Haute-Saone' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Autun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Autun-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Autun-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Blanzy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Chagny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Chalon-sur-Saône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '1ere circo', 'Chalon-sur-Saône-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Chalon-sur-Saône-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Charolles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Chauffailles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Cluny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Cuiseaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Digoin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '2e circo', 'Gergy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'Givry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'Gueugnon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'Hurigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'La Chapelle-de-Guinchay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'Le Creusot'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'Le Creusot-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '3e circo', 'Le Creusot-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Louhans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Mâcon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Mâcon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Mâcon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Montceau-les-Mines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Ouroux-sur-Saône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '4e circo', 'Paray-le-Monial'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '5e circo', 'Pierre-de-Bresse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '5e circo', 'Saint-Rémy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '5e circo', 'Saint-Vallier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '71', 'Saone-et-Loire', '5e circo', 'Tournus'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '71' AND d.nom_departement = 'Saone-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Auxerre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Auxerre-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Auxerre-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Auxerre-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Auxerre-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Avallon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Brienon-sur-Armançon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '1ere circo', 'Chablis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Charny Orée de Puisaye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Cœur de Puisaye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Gâtinais en Bourgogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Joigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Joux-la-Ville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Migennes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Pont-sur-Yonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '2e circo', 'Saint-Florentin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Sens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Sens-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Sens-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Thorigny-sur-Oreuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Tonnerrois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Villeneuve-sur-Yonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '89', 'Yonne', '3e circo', 'Vincelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '89' AND d.nom_departement = 'Yonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '1ere circo', 'Bavilliers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '1ere circo', 'Belfort'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '1ere circo', 'Châtenois-les-Forges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '1ere circo', 'Delle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '2e circo', 'Giromagny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '2e circo', 'Grandvillars'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bourgogne-Franche-Comte', '90', 'Territoire-de-Belfort', '2e circo', 'Valdoie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '90' AND d.nom_departement = 'Territoire-de-Belfort' AND d.region = r.nom_region
WHERE r.nom_region = 'Bourgogne-Franche-Comte';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '1ere circo', 'Bégard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '1ere circo', 'Broons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '1ere circo', 'Callac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '1ere circo', 'Dinan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '1ere circo', 'Guerlédan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '1ere circo', 'Guingamp'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '2e circo', 'Lamballe-Armor'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '2e circo', 'Lannion'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '2e circo', 'Lanvallay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '2e circo', 'Loudéac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '2e circo', 'Paimpol'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '2e circo', 'Perros-Guirec'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '3e circo', 'Plaintel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '3e circo', 'Plancoët'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '3e circo', 'Plélo'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '3e circo', 'Plénée-Jugon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '3e circo', 'Pléneuf-Val-André'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '3e circo', 'Plérin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '4e circo', 'Pleslin-Trigavou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '4e circo', 'Plestin-les-Grèves'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '4e circo', 'Ploufragan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '4e circo', 'Plouha'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '4e circo', 'Rostrenen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '4e circo', 'Saint-Brieuc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '5e circo', 'Trégueux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '22', 'Cotes-d-Armor', '5e circo', 'Tréguier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '22' AND d.nom_departement = 'Cotes-d-Armor' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '1ere circo', 'Brest'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '1ere circo', 'Brest-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '1ere circo', 'Brest-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '1ere circo', 'Briec'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '2e circo', 'Carhaix-Plouguer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '2e circo', 'Concarneau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '2e circo', 'Crozon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '2e circo', 'Douarnenez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '3e circo', 'Fouesnant'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '3e circo', 'Guipavas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '3e circo', 'Landerneau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '3e circo', 'Landivisiau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '4e circo', 'Lesneven'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '4e circo', 'Moëlan-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '4e circo', 'Morlaix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '4e circo', 'Plabennec'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '5e circo', 'Plonéour-Lanvern'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '5e circo', 'Plouigneau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '5e circo', 'Pont-de-Buis-lès-Quimerch'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '5e circo', 'Pont-l''Abbé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '6e circo', 'Quimper'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '6e circo', 'Quimper-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '6e circo', 'Quimperlé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '6e circo', 'Saint-Pol-de-Léon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '29', 'Finistere', '7e circo', 'Saint-Renan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '29' AND d.nom_departement = 'Finistere' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '1ere circo', 'Bain-de-Bretagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '1ere circo', 'Betton'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '1ere circo', 'Bruz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '1ere circo', 'Châteaugiron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '2e circo', 'Combourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '2e circo', 'Dol-de-Bretagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '2e circo', 'Fougères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '2e circo', 'Fougères-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '3e circo', 'Fougères-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '3e circo', 'Guichen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '3e circo', 'Janzé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '3e circo', 'La Guerche-de-Bretagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '4e circo', 'Le Rheu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '4e circo', 'Liffré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '4e circo', 'Melesse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '4e circo', 'Montauban-de-Bretagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '5e circo', 'Montfort-sur-Meu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '5e circo', 'Redon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '5e circo', 'Rennes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '5e circo', 'Rennes-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '6e circo', 'Rennes-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '6e circo', 'Rennes-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '6e circo', 'Saint-Malo'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '6e circo', 'Saint-Malo-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '7e circo', 'Saint-Malo-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '7e circo', 'Val-Couesnon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '35', 'Ille-et-Vilaine', '7e circo', 'Vitré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '35' AND d.nom_departement = 'Ille-et-Vilaine' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '1ere circo', 'Auray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '1ere circo', 'Gourin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '1ere circo', 'Grand-Champ'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '1ere circo', 'Guer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '2e circo', 'Guidel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '2e circo', 'Hennebont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '2e circo', 'Lanester'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '2e circo', 'Lorient'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '3e circo', 'Lorient-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '3e circo', 'Moréac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '3e circo', 'Muzillac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '3e circo', 'Ploemeur'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '4e circo', 'Ploërmel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '4e circo', 'Pluvigner'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '4e circo', 'Pontivy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '4e circo', 'Questembert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '5e circo', 'Quiberon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '5e circo', 'Séné'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '5e circo', 'Vannes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '5e circo', 'Vannes-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Bretagne', '56', 'Morbihan', '6e circo', 'Vannes-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '56' AND d.nom_departement = 'Morbihan' AND d.region = r.nom_region
WHERE r.nom_region = 'Bretagne';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '1ere circo', 'Aubigny-sur-Nère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '1ere circo', 'Avord'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '1ere circo', 'Bourges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '1ere circo', 'Chârost'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '1ere circo', 'Châteaumeillant'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '1ere circo', 'Dun-sur-Auron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '2e circo', 'La Guerche-sur-l''Aubois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '2e circo', 'Mehun-sur-Yèvre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '2e circo', 'Osmery'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '2e circo', 'Saint-Amand-Montrond'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '2e circo', 'Saint-Doulchard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '2e circo', 'Saint-Germain-du-Puy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '3e circo', 'Saint-Martin-d''Auxigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '3e circo', 'Sancerre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '3e circo', 'Trouy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '3e circo', 'Vierzon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '18', 'Cher', '3e circo', 'Vierzon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '18' AND d.nom_departement = 'Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '1ere circo', 'Anet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '1ere circo', 'Auneau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '1ere circo', 'Brou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '1ere circo', 'Chartres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '1ere circo', 'Chartres-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '2e circo', 'Chartres-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '2e circo', 'Chartres-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '2e circo', 'Châteaudun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '2e circo', 'Dreux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '2e circo', 'Dreux-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '3e circo', 'Dreux-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '3e circo', 'Épernon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '3e circo', 'Illiers-Combray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '3e circo', 'Les Villages Vovéens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '3e circo', 'Lucé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '4e circo', 'Nogent-le-Rotrou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '28', 'Eure-et-Loir', '4e circo', 'Saint-Lubin-des-Joncherets'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '28' AND d.nom_departement = 'Eure-et-Loir' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'Ardentes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'Argenton-sur-Creuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'Buzançais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'Châteauroux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'Châteauroux-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'Issoudun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '1ere circo', 'La Châtre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '2e circo', 'Le Blanc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '2e circo', 'Levroux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '2e circo', 'Neuvy-Saint-Sépulchre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '2e circo', 'Saint-Gaultier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '2e circo', 'Saint-Maur'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '36', 'Indre', '2e circo', 'Valençay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '36' AND d.nom_departement = 'Indre' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '1ere circo', 'Amboise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '1ere circo', 'Ballan-Miré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '1ere circo', 'Bléré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '1ere circo', 'Château-Renault'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '2e circo', 'Chinon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '2e circo', 'Descartes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '2e circo', 'Joué-lès-Tours'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '2e circo', 'Langeais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '3e circo', 'Loches'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '3e circo', 'Montlouis-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '3e circo', 'Monts'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '3e circo', 'Saint-Cyr-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '4e circo', 'Sainte-Maure-de-Touraine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '4e circo', 'Saint-Pierre-des-Corps'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '4e circo', 'Tours'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '37', 'Indre-et-Loire', '4e circo', 'Vouvray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '37' AND d.nom_departement = 'Indre-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '1ere circo', 'Blois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '1ere circo', 'Blois-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '1ere circo', 'Blois-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '1ere circo', 'Chambord'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '1ere circo', 'La Beauce'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '1ere circo', 'La Sologne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '2e circo', 'Le Controis-en-Sologne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '2e circo', 'Le Perche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '2e circo', 'Montoire-sur-le-Loir'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '2e circo', 'Montrichard Val de Cher'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '2e circo', 'Romorantin-Lanthenay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '2e circo', 'Saint-Aignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '3e circo', 'Selles-sur-Cher'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '3e circo', 'Vendôme'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '3e circo', 'Veuzain-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '41', 'Loir-et-Cher', '3e circo', 'Vineuil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '41' AND d.nom_departement = 'Loir-et-Cher' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '1ere circo', 'Beaugency'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '1ere circo', 'Châlette-sur-Loing'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '1ere circo', 'Châteauneuf-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '1ere circo', 'Courtenay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '2e circo', 'Fleury-les-Aubrais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '2e circo', 'Gien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '2e circo', 'La Ferté-Saint-Aubin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '2e circo', 'Le Malesherbois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '3e circo', 'Lorris'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '3e circo', 'Meung-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '3e circo', 'Montargis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '3e circo', 'Olivet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '4e circo', 'Orléans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '4e circo', 'Orléans-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '4e circo', 'Pithiviers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '4e circo', 'Saint-Jean-de-Braye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '5e circo', 'Saint-Jean-de-la-Ruelle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '5e circo', 'Saint-Jean-le-Blanc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Centre-Val-de-Loire', '45', 'Loiret', '5e circo', 'Sully-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '45' AND d.nom_departement = 'Loiret' AND d.region = r.nom_region
WHERE r.nom_region = 'Centre-Val-de-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '1ere circo', 'Ajaccio'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '1ere circo', 'Ajaccio-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '1ere circo', 'Bavella'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '1ere circo', 'Grand Sud'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '1ere circo', 'Gravona-Prunelli'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '2e circo', 'Porto-Vecchio'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '2e circo', 'Sartenais-Valinco'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '2e circo', 'Sevi-Sorru-Cinarca'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2A', 'Corse-du-Sud', '2e circo', 'Taravo-Ornano'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2A' AND d.nom_departement = 'Corse-du-Sud' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Bastia'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Bastia-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Bastia-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Biguglia-Nebbio'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Borgo'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Calvi'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '1ere circo', 'Cap Corse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'Casinca-Fumalto'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'Castagniccia'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'Corte'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'Fiumorbo-Castello'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'Ghisonaccia'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'Golo-Morosaglia'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Corse', '2B', 'Haute-Corse', '2e circo', 'L''île-Rousse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '2B' AND d.nom_departement = 'Haute-Corse' AND d.region = r.nom_region
WHERE r.nom_region = 'Corse';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Attigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Bogny-sur-Meuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Carignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Charleville-Mézières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Charleville-Mézières-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Charleville-Mézières-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '1ere circo', 'Charleville-Mézières-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Charleville-Mézières-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Château-Porcien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Givet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Nouvion-sur-Meuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Rethel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Revin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '2e circo', 'Rocroi'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Sedan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Sedan-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Sedan-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Sedan-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Signy-l''Abbaye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Villers-Semeuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '08', 'Ardennes', '3e circo', 'Vouziers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '08' AND d.nom_departement = 'Ardennes' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '1ere circo', 'Aix-Villemaur-Pâlis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '1ere circo', 'Arcis-sur-Aube'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '1ere circo', 'Bar-sur-Aube'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '1ere circo', 'Bar-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '1ere circo', 'Brienne-le-Château'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '1ere circo', 'Creney-près-Troyes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '2e circo', 'Les Riceys'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '2e circo', 'Nogent-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '2e circo', 'Romilly-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '2e circo', 'Saint-André-les-Vergers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '2e circo', 'Saint-Lyé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '2e circo', 'Troyes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '3e circo', 'Troyes-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '3e circo', 'Troyes-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '3e circo', 'Troyes-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '10', 'Aube', '3e circo', 'Vendeuvre-sur-Barse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '10' AND d.nom_departement = 'Aube' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '1ere circo', 'Argonne Suippe et Vesle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '1ere circo', 'Bourgogne-Fresne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '1ere circo', 'Châlons-en-Champagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '1ere circo', 'Châlons-en-Champagne-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '2e circo', 'Châlons-en-Champagne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '2e circo', 'Châlons-en-Champagne-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '2e circo', 'Dormans-Paysages de Champagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '2e circo', 'Épernay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '3e circo', 'Épernay-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '3e circo', 'Épernay-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '3e circo', 'Fismes-Montagne de Reims'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '3e circo', 'Mourmelon-Vesle et Monts de Champagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '4e circo', 'Reims'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '4e circo', 'Reims-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '4e circo', 'Reims-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '4e circo', 'Reims-8'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '5e circo', 'Sermaize-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '5e circo', 'Sézanne-Brie et Champagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '5e circo', 'Vertus-Plaine Champenoise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '51', 'Marne', '5e circo', 'Vitry-le-François-Champagne et Der'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '51' AND d.nom_departement = 'Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Bologne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Bourbonne-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Chalindrey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Châteauvillain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Chaumont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Chaumont-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Chaumont-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Chaumont-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '1ere circo', 'Eurville-Bienville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Joinville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Langres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Nogent'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Poissons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Saint-Dizier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Saint-Dizier-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Saint-Dizier-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Villegusien-le-Lac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '52', 'Haute-Marne', '2e circo', 'Wassy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '52' AND d.nom_departement = 'Haute-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '1ere circo', 'Baccarat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '1ere circo', 'Entre Seille et Meurthe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '1ere circo', 'Grand Couronné'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '1ere circo', 'Jarny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '2e circo', 'Jarville-la-Malgrange'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '2e circo', 'Laxou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '2e circo', 'Le Nord-Toulois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '2e circo', 'Longwy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '3e circo', 'Lunéville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '3e circo', 'Lunéville-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '3e circo', 'Lunéville-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '3e circo', 'Meine au Saintois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '4e circo', 'Mont-Saint-Martin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '4e circo', 'Nancy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '4e circo', 'Neuves-Maisons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '4e circo', 'Pays de Briey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '5e circo', 'Pont-à-Mousson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '5e circo', 'Saint-Max'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '5e circo', 'Toul'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '5e circo', 'Val de Lorraine Sud'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '6e circo', 'Vandœuvre-lès-Nancy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '54', 'Meurthe-et-Moselle', '6e circo', 'Villerupt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '54' AND d.nom_departement = 'Meurthe-et-Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Ancerville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Bar-le-Duc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Bar-le-Duc-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Bar-le-Duc-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Belleville-sur-Meuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Bouligny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Clermont-en-Argonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Commercy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Dieue-sur-Meuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '1ere circo', 'Étain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Ligny-en-Barrois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Montmédy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Revigny-sur-Ornain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Saint-Mihiel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Stenay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Vaucouleurs'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Verdun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Verdun-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '55', 'Meuse', '2e circo', 'Verdun-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '55' AND d.nom_departement = 'Meuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '1ere circo', 'Algrange'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '1ere circo', 'Bitche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '1ere circo', 'Boulay-Moselle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '2e circo', 'Bouzonville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '2e circo', 'Fameck'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '2e circo', 'Faulquemont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '3e circo', 'Forbach'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '3e circo', 'Freyming-Merlebach'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '3e circo', 'Hayange'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '4e circo', 'Le Pays Messin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '4e circo', 'Le Saulnois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '4e circo', 'Le Sillon Mosellan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '5e circo', 'Les Coteaux de Moselle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '5e circo', 'Metz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '5e circo', 'Metzervisse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '6e circo', 'Montigny-lès-Metz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '6e circo', 'Phalsbourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '6e circo', 'Rombas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '7e circo', 'Saint-Avold'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '7e circo', 'Sarralbe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '7e circo', 'Sarrebourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '8e circo', 'Sarreguemines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '8e circo', 'Stiring-Wendel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '8e circo', 'Thionville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '57', 'Moselle', '9e circo', 'Yutz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '57' AND d.nom_departement = 'Moselle' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '1ere circo', 'Bischwiller'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '1ere circo', 'Bouxwiller'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '1ere circo', 'Brumath'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '2e circo', 'Erstein'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '2e circo', 'Haguenau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '2e circo', 'Hœnheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '3e circo', 'Illkirch-Graffenstaden'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '3e circo', 'Ingwiller'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '3e circo', 'Lingolsheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '4e circo', 'Molsheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '4e circo', 'Mutzig'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '4e circo', 'Obernai'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '5e circo', 'Reichshoffen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '5e circo', 'Saverne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '5e circo', 'Schiltigheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '6e circo', 'Sélestat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '6e circo', 'Strasbourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '6e circo', 'Val-de-Moder'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '67', 'Bas-Rhin', '7e circo', 'Wissembourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '67' AND d.nom_departement = 'Bas-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '1ere circo', 'Altkirch'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '1ere circo', 'Brunstatt-Didenheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '1ere circo', 'Cernay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '2e circo', 'Colmar'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '2e circo', 'Colmar-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '2e circo', 'Colmar-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '3e circo', 'Ensisheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '3e circo', 'Guebwiller'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '3e circo', 'Kingersheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '4e circo', 'Masevaux-Niederbruck'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '4e circo', 'Mulhouse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '4e circo', 'Mulhouse-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '5e circo', 'Rixheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '5e circo', 'Sainte-Marie-aux-Mines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '5e circo', 'Saint-Louis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '6e circo', 'Wintzenheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '68', 'Haut-Rhin', '6e circo', 'Wittenheim'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '68' AND d.nom_departement = 'Haut-Rhin' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '1ere circo', 'Bruyères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '1ere circo', 'Charmes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '1ere circo', 'Darney'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '1ere circo', 'Épinal'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '1ere circo', 'Épinal-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '2e circo', 'Épinal-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '2e circo', 'Gérardmer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '2e circo', 'Golbey'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '2e circo', 'La Bresse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '2e circo', 'Le Thillot'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '3e circo', 'Le Val-d''Ajol'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '3e circo', 'Mirecourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '3e circo', 'Neufchâteau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '3e circo', 'Raon-l''Etape'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '3e circo', 'Remiremont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '4e circo', 'Saint-Dié-des-Vosges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '4e circo', 'Saint-Dié-des-Vosges-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '4e circo', 'Saint-Dié-des-Vosges-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Grand-Est', '88', 'Vosges', '4e circo', 'Vittel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '88' AND d.nom_departement = 'Vosges' AND d.region = r.nom_region
WHERE r.nom_region = 'Grand-Est';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', '1ere circo', 'Chauny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', '1ere circo', 'Guise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', '2e circo', 'Laon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', '2e circo', 'Saint-Quentin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', '3e circo', 'Soissons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', '3e circo', 'Tergnier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Bohain-en-Vermandois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Château-Thierry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Essômes-sur-Marne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Fère-en-Tardenois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Hirson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Laon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Laon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Marle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Ribemont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Saint-Quentin-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Saint-Quentin-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Saint-Quentin-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Soissons-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Soissons-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Vervins'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Vic-sur-Aisne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Villeneuve-sur-Aisne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '02', 'Aisne', 'A verifier', 'Villers-Cotterêts'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '02' AND d.nom_departement = 'Aisne' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '10e circo', 'Grande-Synthe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '10e circo', 'Hazebrouck'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '11e circo', 'Lambersart'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '11e circo', 'Le Cateau-Cambrésis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '12e circo', 'Lille'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '12e circo', 'Lille-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '13e circo', 'Lille-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '13e circo', 'Lille-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '14e circo', 'Lille-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '14e circo', 'Lille-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '15e circo', 'Marly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '15e circo', 'Maubeuge'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '16e circo', 'Orchies'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '16e circo', 'Roubaix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '17e circo', 'Roubaix-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '17e circo', 'Saint-Amand-les-Eaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '18e circo', 'Sin-le-Noble'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '18e circo', 'Templeuve-en-Pévèle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '19e circo', 'Tourcoing'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '19e circo', 'Tourcoing-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '1ere circo', 'Aniche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '1ere circo', 'Annœullin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '20e circo', 'Valenciennes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '20e circo', 'Villeneuve-d''Ascq'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '21e circo', 'Wormhout'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '2e circo', 'Anzin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '2e circo', 'Armentières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '3e circo', 'Aulnoye-Aymeries'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '3e circo', 'Aulnoy-lez-Valenciennes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '4e circo', 'Avesnes-sur-Helpe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '4e circo', 'Bailleul'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '5e circo', 'Cambrai'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '5e circo', 'Caudry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '6e circo', 'Coudekerque-Branche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '6e circo', 'Croix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '7e circo', 'Denain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '7e circo', 'Douai'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '8e circo', 'Dunkerque'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '8e circo', 'Dunkerque-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '9e circo', 'Faches-Thumesnil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '59', 'Nord', '9e circo', 'Fourmies'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '59' AND d.nom_departement = 'Nord' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '1ere circo', 'Beauvais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '1ere circo', 'Beauvais-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '1ere circo', 'Beauvais-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '1ere circo', 'Chantilly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '2e circo', 'Chaumont-en-Vexin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '2e circo', 'Clermont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '2e circo', 'Compiègne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '2e circo', 'Compiègne-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '3e circo', 'Compiègne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '3e circo', 'Creil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '3e circo', 'Crépy-en-Valois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '3e circo', 'Estrées-Saint-Denis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '4e circo', 'Grandvilliers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '4e circo', 'Méru'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '4e circo', 'Montataire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '4e circo', 'Mouy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '5e circo', 'Nanteuil-le-Haudouin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '5e circo', 'Nogent-sur-Oise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '5e circo', 'Noyon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '5e circo', 'Pont-Sainte-Maxence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '6e circo', 'Saint-Just-en-Chaussée'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '6e circo', 'Senlis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '60', 'Oise', '6e circo', 'Thourotte'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '60' AND d.nom_departement = 'Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '10e circo', 'Marck'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '10e circo', 'Nœux-les-Mines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '10e circo', 'Outreau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '10e circo', 'Saint-Omer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '11e circo', 'Saint-Pol-sur-Ternoise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '11e circo', 'Wingles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '1ere circo', 'Aire-sur-la-Lys'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '1ere circo', 'Arras'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '1ere circo', 'Arras-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '1ere circo', 'Arras-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '2e circo', 'Arras-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '2e circo', 'Auchel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '2e circo', 'Auxi-le-Château'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '2e circo', 'Avesnes-le-Comte'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '3e circo', 'Avion'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '3e circo', 'Bapaume'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '3e circo', 'Berck'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '3e circo', 'Béthune'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '4e circo', 'Beuvry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '4e circo', 'Boulogne-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '4e circo', 'Boulogne-sur-Mer-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '4e circo', 'Boulogne-sur-Mer-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '5e circo', 'Brebières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '5e circo', 'Bruay-la-Buissière'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '5e circo', 'Bully-les-Mines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '5e circo', 'Calais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '6e circo', 'Calais-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '6e circo', 'Calais-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '6e circo', 'Carvin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '6e circo', 'Desvres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '7e circo', 'Douvrin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '7e circo', 'Étaples'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '7e circo', 'Fruges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '7e circo', 'Harnes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '8e circo', 'Hénin-Beaumont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '8e circo', 'Hénin-Beaumont-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '8e circo', 'Hénin-Beaumont-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '8e circo', 'Lens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '9e circo', 'Liévin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '9e circo', 'Lillers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '9e circo', 'Longuenesse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '62', 'Pas-de-Calais', '9e circo', 'Lumbres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '62' AND d.nom_departement = 'Pas-de-Calais' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', '1ere circo', 'Abbeville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', '2e circo', 'Amiens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', '3e circo', 'Amiens-7'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', '4e circo', 'Roye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Abbeville-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Abbeville-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Ailly-sur-Noye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Ailly-sur-Somme'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Albert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Amiens-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Amiens-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Amiens-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Amiens-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Amiens-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Corbie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Doullens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Flixecourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Friville-Escarbotin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Gamaches'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Ham'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Moreuil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Péronne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Poix-de-Picardie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Hauts-de-France', '80', 'Somme', 'A verifier', 'Rue'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '80' AND d.nom_departement = 'Somme' AND d.region = r.nom_region
WHERE r.nom_region = 'Hauts-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '75', 'Paris', '1ere circo', 'Paris'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '75' AND d.nom_departement = 'Paris' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '1ere circo', 'Champs-sur-Marne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '1ere circo', 'Chelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '1ere circo', 'Claye-Souilly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '2e circo', 'Combs-la-Ville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '2e circo', 'Coulommiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '2e circo', 'Fontainebleau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '3e circo', 'Fontenay-Trésigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '3e circo', 'La Ferté-sous-Jouarre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '3e circo', 'Lagny-sur-Marne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '4e circo', 'Meaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '4e circo', 'Melun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '4e circo', 'Mitry-Mory'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '5e circo', 'Montereau-Fault-Yonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '5e circo', 'Nangis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '5e circo', 'Nemours'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '6e circo', 'Ozoir-la-Ferrière'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '6e circo', 'Pontault-Combault'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '6e circo', 'Provins'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '7e circo', 'Saint-Fargeau-Ponthierry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '7e circo', 'Savigny-le-Temple'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '7e circo', 'Serris'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '8e circo', 'Torcy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '77', 'Seine-et-Marne', '8e circo', 'Villeparisis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '77' AND d.nom_departement = 'Seine-et-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '10e circo', 'Verneuil-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '10e circo', 'Versailles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '11e circo', 'Versailles-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '1ere circo', 'Aubergenville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '1ere circo', 'Bonnières-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '2e circo', 'Chatou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '2e circo', 'Conflans-Sainte-Honorine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '3e circo', 'Houilles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '3e circo', 'Le Chesnay-Rocquencourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '4e circo', 'Les Mureaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '4e circo', 'Limay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '5e circo', 'Mantes-la-Jolie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '5e circo', 'Maurepas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '6e circo', 'Montigny-le-Bretonneux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '6e circo', 'Plaisir'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '7e circo', 'Poissy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '7e circo', 'Rambouillet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '8e circo', 'Saint-Cyr-l''École'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '8e circo', 'Saint-Germain-en-Laye'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '9e circo', 'Sartrouville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '78', 'Yvelines', '9e circo', 'Trappes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '78' AND d.nom_departement = 'Yvelines' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '1ere circo', 'Arpajon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '1ere circo', 'Athis-Mons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '1ere circo', 'Brétigny-sur-Orge'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '2e circo', 'Brunoy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '2e circo', 'Corbeil-Essonnes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '2e circo', 'Dourdan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '3e circo', 'Draveil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '3e circo', 'Épinay-sous-Sénart'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '3e circo', 'Étampes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '4e circo', 'Évry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '4e circo', 'Gif-sur-Yvette'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '4e circo', 'Les Ulis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '5e circo', 'Longjumeau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '5e circo', 'Massy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '5e circo', 'Mennecy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '6e circo', 'Montgeron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '6e circo', 'Palaiseau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '6e circo', 'Ris-Orangis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '7e circo', 'Sainte-Geneviève-des-Bois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '7e circo', 'Savigny-sur-Orge'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '7e circo', 'Vigneux-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '8e circo', 'Viry-Châtillon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '91', 'Essonne', '8e circo', 'Yerres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '91' AND d.nom_departement = 'Essonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '10e circo', 'Nanterre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '10e circo', 'Nanterre-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '11e circo', 'Neuilly-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '11e circo', 'Rueil-Malmaison'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '12e circo', 'Saint-Cloud'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '1ere circo', 'Antony'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '1ere circo', 'Asnières-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '2e circo', 'Bagneux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '2e circo', 'Boulogne-Billancourt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '3e circo', 'Boulogne-Billancourt-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '3e circo', 'Châtenay-Malabry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '4e circo', 'Châtillon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '4e circo', 'Clamart'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '5e circo', 'Clichy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '5e circo', 'Colombes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '6e circo', 'Colombes-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '6e circo', 'Courbevoie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '7e circo', 'Courbevoie-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '7e circo', 'Gennevilliers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '8e circo', 'Issy-les-Moulineaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '8e circo', 'Levallois-Perret'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '9e circo', 'Meudon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '92', 'Hauts-de-Seine', '9e circo', 'Montrouge'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '92' AND d.nom_departement = 'Hauts-de-Seine' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '10e circo', 'Sevran'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '10e circo', 'Tremblay-en-France'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '11e circo', 'Villemomble'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '1ere circo', 'Aubervilliers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '1ere circo', 'Aulnay-sous-Bois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '2e circo', 'Bagnolet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '2e circo', 'Bobigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '3e circo', 'Bondy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '3e circo', 'Drancy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '4e circo', 'Épinay-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '4e circo', 'Gagny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '5e circo', 'La Courneuve'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '5e circo', 'Le Blanc-Mesnil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '6e circo', 'Livry-Gargan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '6e circo', 'Montreuil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '7e circo', 'Montreuil-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '7e circo', 'Noisy-le-Grand'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '8e circo', 'Pantin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '8e circo', 'Saint-Denis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '9e circo', 'Saint-Denis-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '93', 'Seine-Saint-Denis', '9e circo', 'Saint-Ouen-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '93' AND d.nom_departement = 'Seine-Saint-Denis' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '1ere circo', 'Alfortville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '1ere circo', 'Cachan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '1ere circo', 'Champigny-sur-Marne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '2e circo', 'Champigny-sur-Marne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '2e circo', 'Charenton-le-Pont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '2e circo', 'Choisy-le-Roi'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '3e circo', 'Créteil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '3e circo', 'Fontenay-sous-Bois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '3e circo', 'Ivry-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '4e circo', 'Le Kremlin-Bicêtre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '4e circo', 'L''Haÿ-les-Roses'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '4e circo', 'Maisons-Alfort'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '5e circo', 'Nogent-sur-Marne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '5e circo', 'Orly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '5e circo', 'Plateau briard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '6e circo', 'Saint-Maur-des-Fossés'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '6e circo', 'Saint-Maur-des-Fossés-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '6e circo', 'Thiais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '7e circo', 'Villejuif'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '7e circo', 'Villeneuve-Saint-Georges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '7e circo', 'Villiers-sur-Marne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '8e circo', 'Vincennes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '94', 'Val-de-Marne', '8e circo', 'Vitry-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '94' AND d.nom_departement = 'Val-de-Marne' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '1ere circo', 'Argenteuil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '1ere circo', 'Argenteuil-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '1ere circo', 'Argenteuil-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '2e circo', 'Cergy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '2e circo', 'Cergy-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '2e circo', 'Cergy-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '3e circo', 'Deuil-la-Barre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '3e circo', 'Domont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '3e circo', 'Ermont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '4e circo', 'Fosses'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '4e circo', 'Franconville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '4e circo', 'Garges-lès-Gonesse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '5e circo', 'Goussainville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '5e circo', 'Herblay-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '5e circo', 'L''Isle-Adam'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '6e circo', 'Montmorency'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '6e circo', 'Pontoise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '6e circo', 'Saint-Ouen-l''Aumône'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '7e circo', 'Sarcelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '7e circo', 'Taverny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '7e circo', 'Vauréal'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Ile-de-France', '95', 'Val-d-Oise', '8e circo', 'Villiers-le-Bel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '95' AND d.nom_departement = 'Val-d-Oise' AND d.region = r.nom_region
WHERE r.nom_region = 'Ile-de-France';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '1ere circo', 'Bayeux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '1ere circo', 'Cabourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '1ere circo', 'Caen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '1ere circo', 'Caen-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '1ere circo', 'Caen-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '2e circo', 'Caen-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '2e circo', 'Caen-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '2e circo', 'Condé-en-Normandie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '2e circo', 'Courseulles-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '2e circo', 'Évrecy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '3e circo', 'Falaise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '3e circo', 'Hérouville-Saint-Clair'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '3e circo', 'Honfleur-Deauville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '3e circo', 'Ifs'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '3e circo', 'Le Hom'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '4e circo', 'Les Monts d’Aunay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '4e circo', 'Les Monts d''Aunay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '4e circo', 'Lisieux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '4e circo', 'Livarot-Pays-d’Auge'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '4e circo', 'Mézidon Vallée d’Auge'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '5e circo', 'Ouistreham'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '5e circo', 'Pont-l''Évêque'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '5e circo', 'Thue-et-Mue'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '5e circo', 'Trévières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '5e circo', 'Troarn'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '14', 'Calvados', '6e circo', 'Vire-Normandie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '14' AND d.nom_departement = 'Calvados' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '1ere circo', 'Bernay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '1ere circo', 'Beuzeville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '1ere circo', 'Bourg-Achard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '1ere circo', 'Breteuil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '1ere circo', 'Brionne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '2e circo', 'Conches-en-Ouche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '2e circo', 'Évreux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '2e circo', 'Évreux-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '2e circo', 'Évreux-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '2e circo', 'Évreux-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '3e circo', 'Gaillon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '3e circo', 'Gisors'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '3e circo', 'Grand Bourgtheroulde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '3e circo', 'Le Neubourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '3e circo', 'Les Andelys'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '4e circo', 'Louviers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '4e circo', 'Mesnils-sur-Iton'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '4e circo', 'Pacy-sur-Eure'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '4e circo', 'Pont-Audemer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '4e circo', 'Pont-de-l''Arche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '5e circo', 'Romilly-sur-Andelle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '5e circo', 'Saint-André-de-l''Eure'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '5e circo', 'Val-de-Reuil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '5e circo', 'Verneuil d''Avre et d''Iton'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '27', 'Eure', '5e circo', 'Vernon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '27' AND d.nom_departement = 'Eure' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Agon-Coutainville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Avranches'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Bréhal'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Bricquebec-en-Cotentin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Carentan-les-Marais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Cherbourg-en-Cotentin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '1ere circo', 'Cherbourg-en-Cotentin-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'Cherbourg-en-Cotentin-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'Condé-sur-Vire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'Coutances'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'Créances'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'Granville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'Isigny-le-Buat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '2e circo', 'La Hague'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Le Mortainais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Les Pieux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Pont-Hébert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Pontorson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Quettreville-sur-Sienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Saint-Hilaire-du-Harcouët'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '3e circo', 'Saint-Lô'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '4e circo', 'Saint-Lô-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '4e circo', 'Saint-Lô-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '4e circo', 'Val-de-Saire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '4e circo', 'Valognes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '50', 'Manche', '4e circo', 'Villedieu-les-Poêles-Rouffigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '50' AND d.nom_departement = 'Manche' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Alençon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Alençon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Alençon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Argentan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Argentan-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Argentan-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Athis-Val de Rouvre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '1ere circo', 'Bagnoles de l’Orne Normandie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Bretoncelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Ceton'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Damigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Domfront en Poiraie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Écouves'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Flers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Flers-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '2e circo', 'Flers-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'La Ferté Macé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'L''Aigle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'Magny-le-Désert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'Mortagne-au-Perche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'Rai'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'Sées'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'Tourouvre au Perche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '61', 'Orne', '3e circo', 'Vimoutiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '61' AND d.nom_departement = 'Orne' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Barentin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Bois-Guillaume'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Bolbec'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Canteleu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Caudebec-lès-Elbeuf'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Darnétal'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Dieppe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Dieppe-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Dieppe-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Elbeuf'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Eu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Fécamp'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Gournay-en-Bray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Grand-Quevilly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Havre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Havre-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Havre-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Havre-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Mesnil-Esnard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Le Petit-Quevilly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Luneray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Mont-Saint-Aignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Neufchâtel-en-Bray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Notre-Dame-de-Bondeville'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Octeville-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Port-Jérôme-sur-Seine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Rouen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Saint-Étienne-du-Rouvray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Saint-Romain-de-Colbosc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Saint-Valery-en-Caux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Sotteville-lès-Rouen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Normandie', '76', 'Seine-Maritime', 'A verifier', 'Yvetot'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '76' AND d.nom_departement = 'Seine-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Normandie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Angoulême'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Angoulême-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Angoulême-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Angoulême-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Boëme-Echelle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Boixe-et-Manslois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Charente-Bonnieure'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '1ere circo', 'Charente-Champagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Charente-Nord'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Charente-Sud'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Charente-Vienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Cognac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Cognac-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Cognac-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Gond-Pontouvre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '2e circo', 'Jarnac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '3e circo', 'La Couronne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '3e circo', 'Terres-de-Haute-Charente'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '3e circo', 'Touvre-et-Braconne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '3e circo', 'Tude-et-Lavalette'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '3e circo', 'Val de Nouère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '16', 'Charente', '3e circo', 'Val de Tardoire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '16' AND d.nom_departement = 'Charente' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '1ere circo', 'Aytré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '1ere circo', 'Chaniers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '1ere circo', 'Châtelaillon-Plage'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '1ere circo', 'Jonzac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '1ere circo', 'L''Île d''Oléron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '2e circo', 'La Jarrie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '2e circo', 'La Rochelle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '2e circo', 'La Tremblade'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '2e circo', 'Lagord'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '2e circo', 'L''Île de Ré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '3e circo', 'Les Trois Monts'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '3e circo', 'Marans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '3e circo', 'Marennes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '3e circo', 'Matha'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '3e circo', 'Pons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '4e circo', 'Rochefort'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '4e circo', 'Royan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '4e circo', 'Saintes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '4e circo', 'Saint-Jean-d''Angély'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '4e circo', 'Saint-Porchaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '5e circo', 'Saintonge Estuaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '5e circo', 'Saujon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '5e circo', 'Surgères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '5e circo', 'Thénac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '17', 'Charente-Maritime', '5e circo', 'Tonnay-Charente'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '17' AND d.nom_departement = 'Charente-Maritime' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Allassac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Argentat-sur-Dordogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Brive-la-Gaillarde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Brive-la-Gaillarde-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Égletons'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Haute-Dordogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'L''Yssandonnais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Malemort'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '1ere circo', 'Midi Corrézien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Naves'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Plateau de Millevaches'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Sainte-Fortunade'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Saint-Pantaléon-de-Larche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Seilhac-Monédières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Tulle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Ussel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '19', 'Correze', '2e circo', 'Uzerche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '19' AND d.nom_departement = 'Correze' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Ahun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Aubusson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Auzances'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Bonnat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Bourganeuf'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Boussac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Dun-le-Palestel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Évaux-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Felletin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Gouzon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Guéret'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Guéret-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Guéret-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'La Souterraine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Le Grand-Bourg'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '23', 'Creuse', '1ere circo', 'Saint-Vaury'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '23' AND d.nom_departement = 'Creuse' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Bassillac et Auberoche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Bergerac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Bergerac-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Brantôme en Périgord'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Coulounieix-Chamiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Isle-Loue-Auvézère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '1ere circo', 'Isle-Manoire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Lalinde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Le Haut-Périgord Noir'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Montpon-Ménestérol'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Pays de la Force'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Pays de Montaigne et Gurson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Périgord Central'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '2e circo', 'Périgord Vert Nontronnais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Périgueux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Ribérac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Saint-Astier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Sanilhac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Sarlat-la-Canéda'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Sud-Bergeracois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '3e circo', 'Terrasson-Lavilledieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '4e circo', 'Thiviers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '4e circo', 'Trélissac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '4e circo', 'Vallée de l''Homme'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '4e circo', 'Vallée de l''Isle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '24', 'Dordogne', '4e circo', 'Vallée Dordogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '24' AND d.nom_departement = 'Dordogne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '10e circo', 'Pessac-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '10e circo', 'Pessac-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '10e circo', 'Saint-Médard-en-Jalles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '11e circo', 'Talence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '11e circo', 'Villenave-d''Ornon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '1ere circo', 'Andernos-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '1ere circo', 'Bègles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '1ere circo', 'Bordeaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '2e circo', 'Cenon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '2e circo', 'Créon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '2e circo', 'Gujan-Mestras'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '3e circo', 'La Brède'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '3e circo', 'L''Entre-Deux-Mers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '3e circo', 'L''Estuaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '4e circo', 'La Presqu''île'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '4e circo', 'La Teste-de-Buch'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '4e circo', 'Le Bouscat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '5e circo', 'Le Libournais-Fronsadais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '5e circo', 'Le Nord-Gironde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '5e circo', 'Le Nord-Libournais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '6e circo', 'Le Nord-Médoc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '6e circo', 'Le Réolais et Les Bastides'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '6e circo', 'Le Sud-Gironde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '7e circo', 'Le Sud-Médoc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '7e circo', 'Les Coteaux de Dordogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '7e circo', 'Les Landes des Graves'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '8e circo', 'Les Portes du Médoc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '8e circo', 'Lormont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '8e circo', 'Mérignac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '9e circo', 'Mérignac-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '9e circo', 'Mérignac-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '33', 'Gironde', '9e circo', 'Pessac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '33' AND d.nom_departement = 'Gironde' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '1ere circo', 'Adour Armagnac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '1ere circo', 'Chalosse Tursan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '1ere circo', 'Côte d''Argent'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '1ere circo', 'Coteau de Chalosse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '1ere circo', 'Dax'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '1ere circo', 'Dax-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '2e circo', 'Dax-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '2e circo', 'Grands Lacs'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '2e circo', 'Haute Lande Armagnac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '2e circo', 'Marensin Sud'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '2e circo', 'Mont-de-Marsan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '2e circo', 'Mont-de-Marsan-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '3e circo', 'Mont-de-Marsan-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '3e circo', 'Orthe et Arrigans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '3e circo', 'Pays morcenais tarusate'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '3e circo', 'Pays Tyrossais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '40', 'Landes', '3e circo', 'Seignanx'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '40' AND d.nom_departement = 'Landes' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'Agen'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'Agen-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'Agen-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'Agen-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'L''Albret'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'Lavardac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'Le Confluent'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '1ere circo', 'L''Ouest agenais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Le Fumélois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Le Haut Agenais Périgord'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Le Livradais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Le Pays de Serres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Le Sud-Est agenais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Le Val du Dropt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Les Coteaux de Guyenne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '2e circo', 'Les Forêts de Gascogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Marmande'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Marmande-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Marmande-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Tonneins'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Villeneuve-sur-Lot'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Villeneuve-sur-Lot-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '47', 'Lot-et-Garonne', '3e circo', 'Villeneuve-sur-Lot-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '47' AND d.nom_departement = 'Lot-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '1ere circo', 'Anglet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '1ere circo', 'Artix et Pays de Soubestre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '1ere circo', 'Baïgura et Mondarrain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '1ere circo', 'Bayonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '1ere circo', 'Bayonne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '2e circo', 'Biarritz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '2e circo', 'Billère et Coteaux de Jurançon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '2e circo', 'Hendaye-Côte Basque-Sud'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '2e circo', 'Le Cœur de Béarn'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '2e circo', 'Lescar, Gave et Terres du Pont-Long'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '3e circo', 'Montagne Basque'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '3e circo', 'Nive-Adour'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '3e circo', 'Oloron-Sainte-Marie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '3e circo', 'Oloron-Sainte-Marie-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '3e circo', 'Oloron-Sainte-Marie-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '4e circo', 'Orthez et Terres des Gaves et du Sel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '4e circo', 'Ouzom, Gave et Rives du Neez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '4e circo', 'Pau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '4e circo', 'Pau-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '4e circo', 'Pau-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '5e circo', 'Pau-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '5e circo', 'Pays de Bidache, Amikuze et Ostibarre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '5e circo', 'Pays de Morlaàs et du Montanérès'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '5e circo', 'Saint-Jean-de-Luz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '5e circo', 'Terres des Luys et Coteaux du Vic-Bilh'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '6e circo', 'Ustaritz-Vallées de Nive et Nivelle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '64', 'Pyrenees-Atlantiques', '6e circo', 'Vallées de l''Ousse et du Lagoin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '64' AND d.nom_departement = 'Pyrenees-Atlantiques' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '1ere circo', 'Autize-Egray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '1ere circo', 'Bressuire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '1ere circo', 'Celles-sur-Belle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '1ere circo', 'Cerizay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '1ere circo', 'Frontenay-Rohan-Rohan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '2e circo', 'La Gâtine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '2e circo', 'La Plaine Niortaise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '2e circo', 'Le Val de Thouet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '2e circo', 'Mauléon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '2e circo', 'Melle'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '3e circo', 'Mignon-et-Boutonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '3e circo', 'Niort'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '3e circo', 'Parthenay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '3e circo', 'Saint-Maixent-l''École'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '79', 'Deux-Sevres', '3e circo', 'Thouars'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '79' AND d.nom_departement = 'Deux-Sevres' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '1ere circo', 'Chasseneuil-du-Poitou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '1ere circo', 'Châtellerault'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '1ere circo', 'Châtellerault-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '1ere circo', 'Châtellerault-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '1ere circo', 'Châtellerault-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '2e circo', 'Chauvigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '2e circo', 'Civray'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '2e circo', 'Jaunay-Marigny'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '2e circo', 'Loudun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '2e circo', 'Lusignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '3e circo', 'Lussac-les-Châteaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '3e circo', 'Migné-Auxances'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '3e circo', 'Montmorillon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '3e circo', 'Poitiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '3e circo', 'Poitiers-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '4e circo', 'Poitiers-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '4e circo', 'Poitiers-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '4e circo', 'Poitiers-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '4e circo', 'Vivonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '86', 'Vienne', '4e circo', 'Vouneuil-sous-Biard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '86' AND d.nom_departement = 'Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '1ere circo', 'Aixe-sur-Vienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '1ere circo', 'Ambazac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '1ere circo', 'Bellac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '1ere circo', 'Châteauponsac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '2e circo', 'Condat-sur-Vienne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '2e circo', 'Couzeix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '2e circo', 'Eymoutiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '2e circo', 'Limoges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '3e circo', 'Limoges-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '3e circo', 'Limoges-9'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '3e circo', 'Panazol'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '3e circo', 'Rochechouart'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '4e circo', 'Saint-Junien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '4e circo', 'Saint-Léonard-de-Noblat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Nouvelle-Aquitaine', '87', 'Haute-Vienne', '4e circo', 'Saint-Yrieix-la-Perche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '87' AND d.nom_departement = 'Haute-Vienne' AND d.region = r.nom_region
WHERE r.nom_region = 'Nouvelle-Aquitaine';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Arize-Lèze'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Couserans Est'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Couserans Ouest'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Foix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Haute-Ariège'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Mirepoix'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '1ere circo', 'Pamiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Pamiers-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Pamiers-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Pays d''Olmes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Portes d''Ariège'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Portes du Couserans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Sabarthès'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '09', 'Ariege', '2e circo', 'Val d''Ariège'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '09' AND d.nom_departement = 'Ariege' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'Carcassonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'Carcassonne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'Carcassonne-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'La Haute-Vallée de l''Aude'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'La Malepère à la Montagne Noire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'La Montagne d''Alaric'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '1ere circo', 'La Piège au Razès'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'La Région Limouxine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'La Vallée de l''Orbiel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'Le Bassin chaurien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'Le Haut-Minervois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'Le Lézignanais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'Le Sud-Minervois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '2e circo', 'Les Basses Plaines de l''Aude'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '3e circo', 'Les Corbières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '3e circo', 'Les Corbières Méditerranée'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '3e circo', 'Narbonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '3e circo', 'Narbonne-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '11', 'Aude', '3e circo', 'Narbonne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '11' AND d.nom_departement = 'Aude' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Aubrac et Carladez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Aveyron et Tarn'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Causse-Comtal'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Causses-Rougiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Ceor-Ségala'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Enne et Alzou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Lot et Dourdou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '1ere circo', 'Lot et Montbazinois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Lot et Palanges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Lot et Truyère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Millau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Millau-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Millau-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Monts du Réquistanais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Nord-Lévezou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '2e circo', 'Raspes et Lévezou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Rodez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Rodez-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Rodez-Onet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Saint-Affrique'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Tarn et Causses'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Vallon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Villefranche-de-Rouergue'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '12', 'Aveyron', '3e circo', 'Villeneuvois et Villefranchois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '12' AND d.nom_departement = 'Aveyron' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '1ere circo', 'Aigues-Mortes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '1ere circo', 'Alès'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '1ere circo', 'Alès-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '1ere circo', 'Alès-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '2e circo', 'Alès-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '2e circo', 'Bagnols-sur-Cèze'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '2e circo', 'Beaucaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '2e circo', 'Calvisson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '3e circo', 'La Grand-Combe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '3e circo', 'Le Vigan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '3e circo', 'Marguerittes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '3e circo', 'Nîmes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '4e circo', 'Pont-Saint-Esprit'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '4e circo', 'Quissac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '4e circo', 'Redessan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '4e circo', 'Roquemaure'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '5e circo', 'Rousson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '5e circo', 'Saint-Gilles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '5e circo', 'Uzès'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '5e circo', 'Vauvert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '30', 'Gard', '6e circo', 'Villeneuve-lès-Avignon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '30' AND d.nom_departement = 'Gard' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '1ere circo', 'Auterive'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '1ere circo', 'Bagnères-de-Luchon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '1ere circo', 'Blagnac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '2e circo', 'Castanet-Tolosan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '2e circo', 'Castelginest'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '2e circo', 'Cazères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '3e circo', 'Escalquens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '3e circo', 'Léguevin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '3e circo', 'Muret'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '4e circo', 'Pechbonnieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '4e circo', 'Plaisance-du-Touch'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '4e circo', 'Portet-sur-Garonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '5e circo', 'Revel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '5e circo', 'Saint-Gaudens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '5e circo', 'Toulouse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '6e circo', 'Toulouse-10'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '6e circo', 'Toulouse-11'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '6e circo', 'Toulouse-7'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '7e circo', 'Toulouse-8'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '7e circo', 'Toulouse-9'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '7e circo', 'Tournefeuille'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '31', 'Haute-Garonne', '8e circo', 'Villemur-sur-Tarn'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '31' AND d.nom_departement = 'Haute-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Adour-Gersoise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Armagnac-Ténarèze'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Astarac-Gimone'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Auch'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Auch-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Auch-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Auch-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Baïse-Armagnac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '1ere circo', 'Fezensac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Fleurance-Lomagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Gascogne-Auscitaine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Gimone-Arrats'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Grand-Bas-Armagnac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Lectoure-Lomagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'L''Isle-Jourdain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Mirande-Astarac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Pardiac-Rivière-Basse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '32', 'Gers', '2e circo', 'Val de Save'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '32' AND d.nom_departement = 'Gers' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '1ere circo', 'Agde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '1ere circo', 'Béziers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '1ere circo', 'Béziers-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '2e circo', 'Béziers-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '2e circo', 'Béziers-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '2e circo', 'Cazouls-lès-Béziers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '3e circo', 'Clermont-l''Hérault'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '3e circo', 'Frontignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '3e circo', 'Gignac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '4e circo', 'Lattes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '4e circo', 'Le Crès'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '4e circo', 'Lodève'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '5e circo', 'Lunel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '5e circo', 'Mauguio'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '5e circo', 'Mèze'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '6e circo', 'Montpellier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '6e circo', 'Montpellier - Castelnau-le-Lez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '6e circo', 'Montpellier-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '7e circo', 'Pézenas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '7e circo', 'Pignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '7e circo', 'Saint-Gély-du-Fesc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '8e circo', 'Saint-Pons-de-Thomières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '34', 'Herault', '8e circo', 'Sète'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '34' AND d.nom_departement = 'Herault' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Cahors'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Cahors-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Cahors-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Cahors-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Causse et Bouriane'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Causse et Vallées'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Cère et Ségala'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Figeac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Figeac-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '1ere circo', 'Figeac-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Gourdon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Gramat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Lacapelle-Marival'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Luzech'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Marches du Sud-Quercy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Martel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Puy-l''Evêque'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Saint-Céré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '46', 'Lot', '2e circo', 'Souillac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '46' AND d.nom_departement = 'Lot' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Bourgs sur Colagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Florac Trois Rivières'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Grandrieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'La Canourgue'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Langogne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Le Collet-de-Dèze'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Marvejols'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Mende'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Peyre en Aubrac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Saint-Alban-sur-Limagnole'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Saint-Chély-d''Apcher'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '48', 'Lozere', '1ere circo', 'Saint-Etienne-du-Valdonnez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '48' AND d.nom_departement = 'Lozere' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '1ere circo', 'Aureilhan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '1ere circo', 'Bordères-sur-l''Echez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '1ere circo', 'La Haute-Bigorre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '1ere circo', 'La Vallée de la Barousse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '1ere circo', 'La Vallée de l''Arros et des Baïses'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '1ere circo', 'La Vallée des Gaves'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '2e circo', 'Les Coteaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '2e circo', 'Lourdes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '2e circo', 'Lourdes-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '2e circo', 'Lourdes-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '2e circo', 'Moyen Adour'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '2e circo', 'Neste, Aure et Louron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '3e circo', 'Ossun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '3e circo', 'Tarbes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '3e circo', 'Val d''Adour-Rustan-Madiranais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '65', 'Hautes-Pyrenees', '3e circo', 'Vic-en-Bigorre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '65' AND d.nom_departement = 'Hautes-Pyrenees' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '1ere circo', 'La Côte Sableuse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '1ere circo', 'La Côte Salanquaise'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '1ere circo', 'La Côte Vermeille'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '1ere circo', 'La Plaine d''Illibéris'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '2e circo', 'La Vallée de la Têt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '2e circo', 'La Vallée de l''Agly'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '2e circo', 'Le Canigou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '2e circo', 'Le Ribéral'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '3e circo', 'Les Aspres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '3e circo', 'Les Pyrénées catalanes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '3e circo', 'Perpignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '3e circo', 'Perpignan-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '4e circo', 'Perpignan-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '4e circo', 'Perpignan-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '4e circo', 'Perpignan-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '66', 'Pyrenees-Orientales', '4e circo', 'Vallespir-Albères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '66' AND d.nom_departement = 'Pyrenees-Orientales' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Albi'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Albi-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Albi-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Albi-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Carmaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Carmaux-1 Le Ségala'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '1ere circo', 'Carmaux-2 Vallée du Cérou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'Castres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'Castres-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'Castres-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'Gaillac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'Graulhet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'La Montagne noire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '2e circo', 'Lavaur Cocagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Le Haut Dadou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Le Pastel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Les Deux Rives'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Les Hautes Terres d''Oc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Les Portes du Tarn'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Mazamet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '3e circo', 'Mazamet-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '4e circo', 'Mazamet-2 Vallée du Thoré'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '4e circo', 'Plaine de l''Agoût'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '4e circo', 'Saint-Juéry'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '81', 'Tarn', '4e circo', 'Vignobles et Bastides'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '81' AND d.nom_departement = 'Tarn' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '1ere circo', 'Aveyron-Lère'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '1ere circo', 'Beaumont-de-Lomagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '1ere circo', 'Castelsarrasin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '1ere circo', 'Garonne-Lomagne-Brulhois'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '1ere circo', 'Moissac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '2e circo', 'Montauban'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '2e circo', 'Montech'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '2e circo', 'Pays de Serres Sud-Quercy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '2e circo', 'Quercy-Aveyron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '2e circo', 'Quercy-Rouergue'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '3e circo', 'Tarn-Tescou-Quercy vert'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '3e circo', 'Valence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Occitanie', '82', 'Tarn-et-Garonne', '3e circo', 'Verdun-sur-Garonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '82' AND d.nom_departement = 'Tarn-et-Garonne' AND d.region = r.nom_region
WHERE r.nom_region = 'Occitanie';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '1ere circo', 'Ancenis-Saint-Géréon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '1ere circo', 'Blain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '1ere circo', 'Carquefou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '2e circo', 'Châteaubriant'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '2e circo', 'Chaumes-en-Retz'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '2e circo', 'Clisson'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '3e circo', 'Guémené-Penfao'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '3e circo', 'Guérande'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '3e circo', 'La Baule-Escoublac'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '4e circo', 'La Chapelle-sur-Erdre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '4e circo', 'Machecoul-Saint-Même'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '4e circo', 'Nantes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '5e circo', 'Nort-sur-Erdre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '5e circo', 'Pontchâteau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '5e circo', 'Pornic'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '6e circo', 'Rezé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '6e circo', 'Rezé-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '6e circo', 'Saint-Brevin-les-Pins'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '7e circo', 'Saint-Herblain'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '7e circo', 'Saint-Herblain-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '7e circo', 'Saint-Herblain-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '8e circo', 'Saint-Nazaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '8e circo', 'Saint-Nazaire-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '8e circo', 'Saint-Philbert-de-Grand-Lieu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '9e circo', 'Saint-Sébastien-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '9e circo', 'Vallet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '44', 'Loire-Atlantique', '9e circo', 'Vertou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '44' AND d.nom_departement = 'Loire-Atlantique' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '1ere circo', 'Angers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '1ere circo', 'Angers-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '1ere circo', 'Angers-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '1ere circo', 'Angers-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '2e circo', 'Angers-5'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '2e circo', 'Angers-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '2e circo', 'Angers-7'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '2e circo', 'Beaufort-en-Anjou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '3e circo', 'Beaupréau-en-Mauges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '3e circo', 'Brissac Loire Aubance'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '3e circo', 'Chalonnes-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '3e circo', 'Chemillé-en-Anjou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '4e circo', 'Cholet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '4e circo', 'Cholet-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '4e circo', 'Doué-en-Anjou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '4e circo', 'Erdre-en-Anjou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '5e circo', 'Gennes-Val-de-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '5e circo', 'Les Ponts-de-Cé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '5e circo', 'Longué-Jumelles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '5e circo', 'Longuenée-en-Anjou'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '6e circo', 'Mauges-sur-Loire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '6e circo', 'Saumur'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '6e circo', 'Segré-en-Anjou Bleu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '6e circo', 'Sèvremoine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '49', 'Maine-et-Loire', '7e circo', 'Tiercé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '49' AND d.nom_departement = 'Maine-et-Loire' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '1ere circo', 'Bonchamp-lès-Laval'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '1ere circo', 'Château-Gontier-sur-Mayenne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '1ere circo', 'Château-Gontier-sur-Mayenne-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '1ere circo', 'Château-Gontier-sur-Mayenne-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '1ere circo', 'Cossé-le-Vivien'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '1ere circo', 'Ernée'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '2e circo', 'Évron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '2e circo', 'Gorron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '2e circo', 'Lassay-les-Châteaux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '2e circo', 'Laval'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '2e circo', 'L''Huisserie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '2e circo', 'Loiron-Ruillé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '3e circo', 'Mayenne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '3e circo', 'Meslay-du-Maine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '3e circo', 'Saint-Berthevin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '53', 'Mayenne', '3e circo', 'Villaines-la-Juhel'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '53' AND d.nom_departement = 'Mayenne' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '1ere circo', 'Bonnétable'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '1ere circo', 'Changé'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '1ere circo', 'Écommoy'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '1ere circo', 'La Ferté-Bernard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '2e circo', 'La Flèche'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '2e circo', 'La Suze-sur-Sarthe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '2e circo', 'Le Lude'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '2e circo', 'Le Mans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '3e circo', 'Le Mans-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '3e circo', 'Le Mans-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '3e circo', 'Le Mans-4'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '3e circo', 'Le Mans-6'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '4e circo', 'Le Mans-7'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '4e circo', 'Loué'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '4e circo', 'Mamers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '4e circo', 'Montval-sur-Loir'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '5e circo', 'Sablé-sur-Sarthe'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '5e circo', 'Saint-Calais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '5e circo', 'Savigné-l''Évêque'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '72', 'Sarthe', '5e circo', 'Sillé-le-Guillaume'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '72' AND d.nom_departement = 'Sarthe' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '1ere circo', 'Aizenay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '1ere circo', 'Challans'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '1ere circo', 'Chantonnay'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '1ere circo', 'Fontenay-le-Comte'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '2e circo', 'La Châtaigneraie'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '2e circo', 'La Roche-sur-Yon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '2e circo', 'La Roche-sur-Yon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '2e circo', 'L''île-d''Yeu'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '3e circo', 'La Roche-sur-Yon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '3e circo', 'Les Herbiers'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '3e circo', 'Les Sables-d''Olonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '3e circo', 'Luçon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '4e circo', 'Mareuil-sur-Lay-Dissais'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '4e circo', 'Montaigu-Vendée'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '4e circo', 'Mortagne-sur-Sèvre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '4e circo', 'Saint-Hilaire-de-Riez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '5e circo', 'Saint-Jean-de-Monts'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Pays-de-la-Loire', '85', 'Vendee', '5e circo', 'Talmont-Saint-Hilaire'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '85' AND d.nom_departement = 'Vendee' AND d.region = r.nom_region
WHERE r.nom_region = 'Pays-de-la-Loire';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Barcelonnette'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Castellane'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Château-Arnoux-Saint-Auban'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Digne-les-Bains'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Digne-les-Bains-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Digne-les-Bains-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Forcalquier'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Manosque'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '1ere circo', 'Manosque-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Manosque-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Manosque-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Oraison'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Reillanne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Riez'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Seyne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Sisteron'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '04', 'Alpes-de-Haute-Provence', '2e circo', 'Valensole'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '04' AND d.nom_departement = 'Alpes-de-Haute-Provence' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Briançon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Briançon-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Briançon-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Chorges'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Embrun'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Gap'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '1ere circo', 'Guillestre'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '2e circo', 'Laragne-Montéglin'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '2e circo', 'L''Argentière-la-Bessée'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '2e circo', 'Saint-Bonnet-en-Champsaur'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '2e circo', 'Serres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '2e circo', 'Tallard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '05', 'Hautes-Alpes', '2e circo', 'Veynes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '05' AND d.nom_departement = 'Hautes-Alpes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '1ere circo', 'Antibes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '1ere circo', 'Antibes-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '1ere circo', 'Antibes-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '2e circo', 'Beausoleil'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '2e circo', 'Cagnes-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '2e circo', 'Cagnes-sur-Mer-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '3e circo', 'Cannes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '3e circo', 'Contes'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '3e circo', 'Grasse'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '4e circo', 'Grasse-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '4e circo', 'Grasse-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '4e circo', 'Le Cannet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '5e circo', 'Mandelieu-la-Napoule'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '5e circo', 'Menton'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '5e circo', 'Nice'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '6e circo', 'Nice-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '6e circo', 'Nice-7'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '6e circo', 'Tourrette-Levens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '7e circo', 'Valbonne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '7e circo', 'Vence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '06', 'Alpes-Maritimes', '7e circo', 'Villeneuve-Loubet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '06' AND d.nom_departement = 'Alpes-Maritimes' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '1ere circo', 'Aix-en-Provence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '1ere circo', 'Allauch'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '2e circo', 'Arles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '2e circo', 'Aubagne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '3e circo', 'Berre-l''Étang'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '3e circo', 'Châteaurenard'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '4e circo', 'Gardanne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '4e circo', 'Istres'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '5e circo', 'La Ciotat'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '5e circo', 'Marignane'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '6e circo', 'Marseille'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '6e circo', 'Martigues'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '7e circo', 'Pélissanne'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '7e circo', 'Salon-de-Provence'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '8e circo', 'Salon-de-Provence-1'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '8e circo', 'Salon-de-Provence-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '9e circo', 'Trets'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '13', 'Bouches-du-Rhone', '9e circo', 'Vitrolles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '13' AND d.nom_departement = 'Bouches-du-Rhone' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '1ere circo', 'Brignoles'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '1ere circo', 'Draguignan'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '1ere circo', 'Flayosc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '2e circo', 'Fréjus'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '2e circo', 'Garéoult'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '2e circo', 'Hyères'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '3e circo', 'La Crau'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '3e circo', 'La Garde'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '3e circo', 'La Seyne-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '4e circo', 'La Seyne-sur-Mer-2'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '4e circo', 'Le Luc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '4e circo', 'Ollioules'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '5e circo', 'Roquebrune-sur-Argens'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '5e circo', 'Saint-Cyr-sur-Mer'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '5e circo', 'Saint-Maximin-la-Sainte-Baume'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '6e circo', 'Sainte-Maxime'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '6e circo', 'Saint-Raphaël'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '6e circo', 'Solliès-Pont'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '7e circo', 'Toulon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '7e circo', 'Toulon-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '83', 'Var', '7e circo', 'Vidauban'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '83' AND d.nom_departement = 'Var' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '1ere circo', 'Apt'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '1ere circo', 'Avignon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '1ere circo', 'Avignon-3'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '1ere circo', 'Bollène'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '2e circo', 'Carpentras'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '2e circo', 'Cavaillon'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '2e circo', 'Cheval-Blanc'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '2e circo', 'L''Isle-sur-la-Sorgue'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '3e circo', 'Le Pontet'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '3e circo', 'Monteux'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '3e circo', 'Orange'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '3e circo', 'Pernes-les-Fontaines'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '4e circo', 'Pertuis'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '4e circo', 'Sorgues'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '4e circo', 'Vaison-la-Romaine'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)
SELECT r.id, d.id, 'Provence-Alpes-Cote-d-Azur', '84', 'Vaucluse', '4e circo', 'Valréas'
FROM regions r
INNER JOIN departements d ON d.numero_departement = '84' AND d.nom_departement = 'Vaucluse' AND d.region = r.nom_region
WHERE r.nom_region = 'Provence-Alpes-Cote-d-Azur';

COMMIT;
