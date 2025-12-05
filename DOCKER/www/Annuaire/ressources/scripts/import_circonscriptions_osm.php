<?php
/**
 * Import des donnees OSM dans t_circonscriptions
 * Regroupe les relations par departement
 */

// Connexion BDD
try {
    $pdo = new PDO(
        'mysql:host=mysql_db;dbname=annuairesMairesDeFrance;charset=utf8mb4',
        'root',
        'root',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    die("Erreur connexion BDD: " . $e->getMessage() . "\n");
}

// Lire le CSV
$csvPath = __DIR__ . '/circonscriptions_osm.csv';
if (!file_exists($csvPath)) {
    die("Fichier CSV non trouve: $csvPath\n");
}

echo "Lecture du CSV...\n";

$handle = fopen($csvPath, 'r');
// Ignorer BOM UTF-8
$bom = fread($handle, 3);
if ($bom !== "\xEF\xBB\xBF") {
    rewind($handle);
}

// Lire header
$header = fgetcsv($handle, 0, ';');
echo "Colonnes: " . implode(', ', $header) . "\n";

// Regrouper par departement
$deptData = [];
while (($row = fgetcsv($handle, 0, ';')) !== false) {
    $codeDeptCsv = $row[0]; // CodeDepartement du CSV (001, 02A, etc.)
    $relationOSM = $row[4]; // RelationOSM
    $urlOSM = $row[5]; // UrlOpenStreetMap
    $urlOverpass = $row[6]; // UrlOverpassTurbo

    // Convertir le code departement du CSV vers le format de la table
    // CSV: 001, 002... -> Table: 01, 02...
    // Mais garder 2A, 2B, 971, 972, etc.
    if (preg_match('/^0(\d{2})$/', $codeDeptCsv, $m)) {
        // 001 -> 01, 002 -> 02, etc.
        $codeDept = $m[1];
    } elseif (preg_match('/^0([2][AB])$/', $codeDeptCsv, $m)) {
        // 02A -> 2A, 02B -> 2B
        $codeDept = $m[1];
    } else {
        // 971, 972, 2A, 2B, etc. - garder tel quel
        $codeDept = $codeDeptCsv;
    }

    if (!isset($deptData[$codeDept])) {
        $deptData[$codeDept] = [
            'relations' => [],
            'urls_osm' => [],
            'url_overpass' => $urlOverpass
        ];
    }

    $deptData[$codeDept]['relations'][] = $relationOSM;
    $deptData[$codeDept]['urls_osm'][] = $urlOSM;
}
fclose($handle);

echo "Departements trouves: " . count($deptData) . "\n\n";

// Mettre a jour la table
$stmt = $pdo->prepare("
    UPDATE t_circonscriptions
    SET relation_osm = :relations,
        url_openstreetmap = :urls_osm,
        url_overpass_turbo = :url_overpass
    WHERE code_departement = :code_dept
");

$updated = 0;
$notFound = [];

foreach ($deptData as $codeDept => $data) {
    // Concatener les relations et URLs avec virgule
    $relationsStr = implode(',', $data['relations']);
    $urlsOsmStr = implode(',', $data['urls_osm']);

    $stmt->execute([
        'relations' => $relationsStr,
        'urls_osm' => $urlsOsmStr,
        'url_overpass' => $data['url_overpass'],
        'code_dept' => $codeDept
    ]);

    if ($stmt->rowCount() > 0) {
        $updated++;
        echo "OK: $codeDept (" . count($data['relations']) . " circos)\n";
    } else {
        $notFound[] = $codeDept;
    }
}

echo "\n=== Resultat ===\n";
echo "Departements mis a jour: $updated\n";

if (count($notFound) > 0) {
    echo "Non trouves dans t_circonscriptions: " . implode(', ', $notFound) . "\n";
}

echo "\nTermine!\n";
