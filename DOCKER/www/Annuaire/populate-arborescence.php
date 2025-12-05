<?php
/**
 * Script de peuplement de la table arborescence avec le modèle Nested Sets (Ensembles Imbriqués)
 *
 * Structure hiérarchique (SANS les communes):
 * - Racine (France)
 *   - Régions
 *     - Départements
 *       - Circonscriptions
 *         - Cantons
 */

set_time_limit(0);
ini_set('memory_limit', '256M');

// Configuration de la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'root';
$password = 'root';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Fonction pour générer une clé unique textuelle
function generateCleUnique($type, $elements) {
    $elements = array_map(function($e) {
        $e = mb_strtolower($e, 'UTF-8');
        $e = preg_replace('/[^a-z0-9]+/u', '-', $e);
        $e = trim($e, '-');
        return $e;
    }, $elements);

    return $type . ':' . implode('/', $elements);
}

echo "<pre>";
echo "=== Peuplement de la table arborescence (sans communes) ===\n\n";

// Vider la table
$pdo->exec("TRUNCATE TABLE arborescence");
echo "Table arborescence vidée.\n\n";

// Récupérer toutes les données hiérarchiques
echo "Récupération des données...\n";

// Compteur global pour les bornes
$borneCounter = 1;

// Préparer le statement d'insertion
$insertStmt = $pdo->prepare("
    INSERT INTO arborescence (borne_gauche, borne_droite, niveau, libelle, type_element, reference_id, parent_id, cle_unique)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
");

// ===== RACINE =====
$racineGauche = $borneCounter++;
$racineId = null;

// 1. Récupérer les régions (DOM-TOM à la fin)
$domtomList = ['Guadeloupe', 'Guyane', 'La-Reunion', 'Martinique', 'Mayotte'];
$regions = $pdo->query("
    SELECT DISTINCT region
    FROM maires
    WHERE region IS NOT NULL AND region != ''
    ORDER BY
        CASE WHEN region IN ('Guadeloupe', 'Guyane', 'La-Reunion', 'Martinique', 'Mayotte') THEN 1 ELSE 0 END,
        region
")->fetchAll(PDO::FETCH_COLUMN);

echo "- " . count($regions) . " régions\n";

$regionIds = [];

foreach ($regions as $region) {
    // ===== RÉGION =====
    $regionGauche = $borneCounter++;

    // Récupérer les départements de cette région
    $depts = $pdo->prepare("
        SELECT DISTINCT numero_departement, nom_departement
        FROM maires
        WHERE region = ? AND numero_departement IS NOT NULL
        ORDER BY numero_departement
    ");
    $depts->execute([$region]);
    $departements = $depts->fetchAll(PDO::FETCH_ASSOC);

    $deptIds = [];

    foreach ($departements as $dept) {
        $deptNum = $dept['numero_departement'];
        $deptNom = $dept['nom_departement'];

        // ===== DÉPARTEMENT =====
        $deptGauche = $borneCounter++;

        // Récupérer les circonscriptions de ce département
        $circos = $pdo->prepare("
            SELECT DISTINCT circonscription
            FROM maires
            WHERE region = ? AND numero_departement = ? AND circonscription IS NOT NULL
            ORDER BY circonscription
        ");
        $circos->execute([$region, $deptNum]);
        $circonscriptions = $circos->fetchAll(PDO::FETCH_COLUMN);

        $circoIds = [];

        foreach ($circonscriptions as $circo) {
            // ===== CIRCONSCRIPTION =====
            $circoGauche = $borneCounter++;

            // Récupérer les cantons de cette circonscription
            $cantons = $pdo->prepare("
                SELECT DISTINCT canton
                FROM maires
                WHERE region = ? AND numero_departement = ? AND circonscription = ? AND canton IS NOT NULL AND canton != ''
                ORDER BY canton
            ");
            $cantons->execute([$region, $deptNum, $circo]);
            $cantonsData = $cantons->fetchAll(PDO::FETCH_COLUMN);

            $cantonIds = [];

            foreach ($cantonsData as $canton) {
                // ===== CANTON (niveau feuille) =====
                $cantonGauche = $borneCounter++;
                $cantonDroite = $borneCounter++;

                // Utiliser un hash court pour garantir l'unicité (gère les cas de caractères spéciaux différents)
                $cantonHash = substr(md5($canton), 0, 8);
                $cleUnique = generateCleUnique('canton', [$region, $deptNum, $circo, $cantonHash]);
                $insertStmt->execute([$cantonGauche, $cantonDroite, 4, $canton, 'canton', $canton, null, $cleUnique]);
                $cantonIds[] = $pdo->lastInsertId();
            }

            // Fermer la circonscription
            $circoDroite = $borneCounter++;
            $cleUnique = generateCleUnique('circonscription', [$region, $deptNum, $circo]);
            $insertStmt->execute([$circoGauche, $circoDroite, 3, $circo, 'circonscription', $circo, null, $cleUnique]);
            $circoId = $pdo->lastInsertId();
            $circoIds[] = $circoId;

            // Mettre à jour les parent_id des cantons
            if (!empty($cantonIds)) {
                $pdo->exec("UPDATE arborescence SET parent_id = $circoId WHERE id IN (" . implode(',', $cantonIds) . ")");
            }
        }

        // Fermer le département
        $deptDroite = $borneCounter++;
        $libelle = $deptNum . ' - ' . $deptNom;
        $cleUnique = generateCleUnique('departement', [$region, $deptNum]);
        $insertStmt->execute([$deptGauche, $deptDroite, 2, $libelle, 'departement', $deptNum, null, $cleUnique]);
        $deptId = $pdo->lastInsertId();
        $deptIds[] = $deptId;

        // Mettre à jour les parent_id des circonscriptions
        if (!empty($circoIds)) {
            $pdo->exec("UPDATE arborescence SET parent_id = $deptId WHERE id IN (" . implode(',', $circoIds) . ")");
        }
    }

    // Fermer la région
    $regionDroite = $borneCounter++;
    $cleUnique = generateCleUnique('region', [$region]);
    $insertStmt->execute([$regionGauche, $regionDroite, 1, $region, 'region', $region, null, $cleUnique]);
    $regionId = $pdo->lastInsertId();
    $regionIds[] = $regionId;

    // Mettre à jour les parent_id des départements
    if (!empty($deptIds)) {
        $pdo->exec("UPDATE arborescence SET parent_id = $regionId WHERE id IN (" . implode(',', $deptIds) . ")");
    }

    echo "  - $region : " . count($departements) . " départements\n";
}

// Fermer la racine
$racineDroite = $borneCounter++;
$insertStmt->execute([$racineGauche, $racineDroite, 0, 'France', 'racine', null, null, 'racine:france']);
$racineId = $pdo->lastInsertId();

// Mettre à jour les parent_id des régions
if (!empty($regionIds)) {
    $pdo->exec("UPDATE arborescence SET parent_id = $racineId WHERE id IN (" . implode(',', $regionIds) . ")");
}

// Statistiques finales
$stats = $pdo->query("
    SELECT type_element, COUNT(*) as nb
    FROM arborescence
    GROUP BY type_element
    ORDER BY FIELD(type_element, 'racine', 'region', 'departement', 'circonscription', 'canton')
")->fetchAll(PDO::FETCH_ASSOC);

echo "\n=== Statistiques ===\n";
$total = 0;
foreach ($stats as $stat) {
    echo "- {$stat['type_element']}: {$stat['nb']}\n";
    $total += $stat['nb'];
}
echo "- TOTAL: $total noeuds\n";

// Vérifier l'intégrité du Nested Set
$checkIntegrity = $pdo->query("
    SELECT COUNT(*) as errors
    FROM arborescence a1
    WHERE NOT EXISTS (
        SELECT 1 FROM arborescence a2
        WHERE a2.borne_gauche < a1.borne_gauche
        AND a2.borne_droite > a1.borne_droite
        AND a2.niveau = a1.niveau - 1
    )
    AND a1.niveau > 0
")->fetch(PDO::FETCH_ASSOC);

echo "\n=== Vérification intégrité ===\n";
if ($checkIntegrity['errors'] == 0) {
    echo "OK - Structure Nested Sets valide\n";
} else {
    echo "ATTENTION - {$checkIntegrity['errors']} erreurs détectées\n";
}

// Exemples de clés uniques
echo "\n=== Exemples de clés uniques ===\n";
$examples = $pdo->query("
    SELECT cle_unique, libelle, type_element, niveau
    FROM arborescence
    ORDER BY niveau, RAND()
    LIMIT 15
")->fetchAll(PDO::FETCH_ASSOC);

foreach ($examples as $ex) {
    echo "- [N{$ex['niveau']}:{$ex['type_element']}] {$ex['libelle']}\n  Clé: {$ex['cle_unique']}\n";
}

echo "\n=== Terminé ===\n";
echo "</pre>";
?>
