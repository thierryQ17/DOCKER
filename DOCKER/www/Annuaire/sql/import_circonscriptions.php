<?php
/**
 * Script d'import des donnees CSV dans la table t_circonscriptions
 */

// Mapping departement -> region
$regionsMapping = [
    '01' => 'Auvergne-Rhone-Alpes',
    '03' => 'Auvergne-Rhone-Alpes',
    '07' => 'Auvergne-Rhone-Alpes',
    '15' => 'Auvergne-Rhone-Alpes',
    '26' => 'Auvergne-Rhone-Alpes',
    '38' => 'Auvergne-Rhone-Alpes',
    '42' => 'Auvergne-Rhone-Alpes',
    '43' => 'Auvergne-Rhone-Alpes',
    '63' => 'Auvergne-Rhone-Alpes',
    '69' => 'Auvergne-Rhone-Alpes',
    '73' => 'Auvergne-Rhone-Alpes',
    '74' => 'Auvergne-Rhone-Alpes',
    '21' => 'Bourgogne-Franche-Comte',
    '25' => 'Bourgogne-Franche-Comte',
    '39' => 'Bourgogne-Franche-Comte',
    '58' => 'Bourgogne-Franche-Comte',
    '70' => 'Bourgogne-Franche-Comte',
    '71' => 'Bourgogne-Franche-Comte',
    '89' => 'Bourgogne-Franche-Comte',
    '90' => 'Bourgogne-Franche-Comte',
    '22' => 'Bretagne',
    '29' => 'Bretagne',
    '35' => 'Bretagne',
    '56' => 'Bretagne',
    '18' => 'Centre-Val de Loire',
    '28' => 'Centre-Val de Loire',
    '36' => 'Centre-Val de Loire',
    '37' => 'Centre-Val de Loire',
    '41' => 'Centre-Val de Loire',
    '45' => 'Centre-Val de Loire',
    '2A' => 'Corse',
    '2B' => 'Corse',
    '08' => 'Grand Est',
    '10' => 'Grand Est',
    '51' => 'Grand Est',
    '52' => 'Grand Est',
    '54' => 'Grand Est',
    '55' => 'Grand Est',
    '57' => 'Grand Est',
    '67' => 'Grand Est',
    '68' => 'Grand Est',
    '88' => 'Grand Est',
    '02' => 'Hauts-de-France',
    '59' => 'Hauts-de-France',
    '60' => 'Hauts-de-France',
    '62' => 'Hauts-de-France',
    '80' => 'Hauts-de-France',
    '75' => 'Ile-de-France',
    '77' => 'Ile-de-France',
    '78' => 'Ile-de-France',
    '91' => 'Ile-de-France',
    '92' => 'Ile-de-France',
    '93' => 'Ile-de-France',
    '94' => 'Ile-de-France',
    '95' => 'Ile-de-France',
    '14' => 'Normandie',
    '27' => 'Normandie',
    '50' => 'Normandie',
    '61' => 'Normandie',
    '76' => 'Normandie',
    '16' => 'Nouvelle-Aquitaine',
    '17' => 'Nouvelle-Aquitaine',
    '19' => 'Nouvelle-Aquitaine',
    '23' => 'Nouvelle-Aquitaine',
    '24' => 'Nouvelle-Aquitaine',
    '33' => 'Nouvelle-Aquitaine',
    '40' => 'Nouvelle-Aquitaine',
    '47' => 'Nouvelle-Aquitaine',
    '64' => 'Nouvelle-Aquitaine',
    '79' => 'Nouvelle-Aquitaine',
    '86' => 'Nouvelle-Aquitaine',
    '87' => 'Nouvelle-Aquitaine',
    '09' => 'Occitanie',
    '11' => 'Occitanie',
    '12' => 'Occitanie',
    '30' => 'Occitanie',
    '31' => 'Occitanie',
    '32' => 'Occitanie',
    '34' => 'Occitanie',
    '46' => 'Occitanie',
    '48' => 'Occitanie',
    '65' => 'Occitanie',
    '66' => 'Occitanie',
    '81' => 'Occitanie',
    '82' => 'Occitanie',
    '44' => 'Pays de la Loire',
    '49' => 'Pays de la Loire',
    '53' => 'Pays de la Loire',
    '72' => 'Pays de la Loire',
    '85' => 'Pays de la Loire',
    '04' => 'Provence-Alpes-Cote d\'Azur',
    '05' => 'Provence-Alpes-Cote d\'Azur',
    '06' => 'Provence-Alpes-Cote d\'Azur',
    '13' => 'Provence-Alpes-Cote d\'Azur',
    '83' => 'Provence-Alpes-Cote d\'Azur',
    '84' => 'Provence-Alpes-Cote d\'Azur',
    '971' => 'Outre-Mer',
    '972' => 'Outre-Mer',
    '973' => 'Outre-Mer',
    '974' => 'Outre-Mer',
    '976' => 'Outre-Mer'
];

// Noms des departements
$nomsDepartements = [
    '01' => 'Ain', '02' => 'Aisne', '03' => 'Allier', '04' => 'Alpes-de-Haute-Provence',
    '05' => 'Hautes-Alpes', '06' => 'Alpes-Maritimes', '07' => 'Ardeche', '08' => 'Ardennes',
    '09' => 'Ariege', '10' => 'Aube', '11' => 'Aude', '12' => 'Aveyron',
    '13' => 'Bouches-du-Rhone', '14' => 'Calvados', '15' => 'Cantal', '16' => 'Charente',
    '17' => 'Charente-Maritime', '18' => 'Cher', '19' => 'Correze', '21' => 'Cote-d\'Or',
    '22' => 'Cotes-d\'Armor', '23' => 'Creuse', '24' => 'Dordogne', '25' => 'Doubs',
    '26' => 'Drome', '27' => 'Eure', '28' => 'Eure-et-Loir', '29' => 'Finistere',
    '2A' => 'Corse-du-Sud', '2B' => 'Haute-Corse',
    '30' => 'Gard', '31' => 'Haute-Garonne', '32' => 'Gers', '33' => 'Gironde',
    '34' => 'Herault', '35' => 'Ille-et-Vilaine', '36' => 'Indre', '37' => 'Indre-et-Loire',
    '38' => 'Isere', '39' => 'Jura', '40' => 'Landes', '41' => 'Loir-et-Cher',
    '42' => 'Loire', '43' => 'Haute-Loire', '44' => 'Loire-Atlantique', '45' => 'Loiret',
    '46' => 'Lot', '47' => 'Lot-et-Garonne', '48' => 'Lozere', '49' => 'Maine-et-Loire',
    '50' => 'Manche', '51' => 'Marne', '52' => 'Haute-Marne', '53' => 'Mayenne',
    '54' => 'Meurthe-et-Moselle', '55' => 'Meuse', '56' => 'Morbihan', '57' => 'Moselle',
    '58' => 'Nievre', '59' => 'Nord', '60' => 'Oise', '61' => 'Orne',
    '62' => 'Pas-de-Calais', '63' => 'Puy-de-Dome', '64' => 'Pyrenees-Atlantiques',
    '65' => 'Hautes-Pyrenees', '66' => 'Pyrenees-Orientales', '67' => 'Bas-Rhin',
    '68' => 'Haut-Rhin', '69' => 'Rhone', '70' => 'Haute-Saone', '71' => 'Saone-et-Loire',
    '72' => 'Sarthe', '73' => 'Savoie', '74' => 'Haute-Savoie', '75' => 'Paris',
    '76' => 'Seine-Maritime', '77' => 'Seine-et-Marne', '78' => 'Yvelines',
    '79' => 'Deux-Sevres', '80' => 'Somme', '81' => 'Tarn', '82' => 'Tarn-et-Garonne',
    '83' => 'Var', '84' => 'Vaucluse', '85' => 'Vendee', '86' => 'Vienne',
    '87' => 'Haute-Vienne', '88' => 'Vosges', '89' => 'Yonne', '90' => 'Territoire de Belfort',
    '91' => 'Essonne', '92' => 'Hauts-de-Seine', '93' => 'Seine-Saint-Denis',
    '94' => 'Val-de-Marne', '95' => 'Val-d\'Oise',
    '971' => 'Guadeloupe', '972' => 'Martinique', '973' => 'Guyane',
    '974' => 'La Reunion', '976' => 'Mayotte'
];

try {
    $pdo = new PDO(
        'mysql:host=mysql_db;dbname=annuairesMairesDeFrance;charset=utf8mb4',
        'root',
        'root',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    // Vider la table
    $pdo->exec("TRUNCATE TABLE t_circonscriptions");

    // Lire le CSV
    $csvFile = __DIR__ . '/../ressources/images/cartesCirconscriptions/urls_circonscriptions.csv';

    if (!file_exists($csvFile)) {
        die("Fichier CSV non trouve: $csvFile\n");
    }

    $handle = fopen($csvFile, 'r');
    if (!$handle) {
        die("Impossible d'ouvrir le fichier CSV\n");
    }

    // Ignorer l'en-tete (avec BOM)
    $header = fgetcsv($handle, 0, ';');

    $stmt = $pdo->prepare("
        INSERT INTO t_circonscriptions
        (code_departement, nom_departement, region, image_path, url_source, url_image_origine)
        VALUES (?, ?, ?, ?, ?, ?)
    ");

    $count = 0;
    while (($data = fgetcsv($handle, 0, ';')) !== false) {
        if (count($data) < 6) continue;

        $codeDept = trim($data[0], '"');
        $nomDeptCsv = trim($data[1], '"');
        $urlPage = trim($data[2], '"');
        $imageFilename = trim($data[4], '"');
        $urlImage = trim($data[5], '"');

        // Utiliser le nom propre du departement
        $nomDept = $nomsDepartements[$codeDept] ?? ucfirst($nomDeptCsv);
        $region = $regionsMapping[$codeDept] ?? 'Autre';
        $imagePath = "ressources/images/cartesCirconscriptions/{$imageFilename}";

        $stmt->execute([
            $codeDept,
            $nomDept,
            $region,
            $imagePath,
            $urlPage,
            $urlImage
        ]);
        $count++;
    }

    fclose($handle);

    echo "Import termine: $count lignes inserees.\n";

    // Verification
    $result = $pdo->query("SELECT COUNT(*) as total FROM t_circonscriptions")->fetch();
    echo "Verification: {$result['total']} enregistrements dans la table.\n";

    // Afficher par region
    echo "\nRepartition par region:\n";
    $regions = $pdo->query("SELECT region, COUNT(*) as nb FROM t_circonscriptions GROUP BY region ORDER BY region")->fetchAll();
    foreach ($regions as $r) {
        echo "  - {$r['region']}: {$r['nb']} departements\n";
    }

} catch (PDOException $e) {
    die("Erreur PDO: " . $e->getMessage() . "\n");
}
