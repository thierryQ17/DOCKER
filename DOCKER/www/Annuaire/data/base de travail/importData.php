<?php
/**
 * Import ultra-performant des données CSV vers t_mairies et t_maires
 * Utilise des insertions par batch de 1000 lignes
 *
 * Usage: php importData.php
 */

ini_set('memory_limit', '512M');
set_time_limit(0);

// Configuration base de données
$dbHost = 'mysql_db';
$dbName = 'annuairesMairesDeFrance';
$dbUser = 'root';
$dbPass = 'root';

$csvFile = __DIR__ . '/toutesLesCommunesDeFranceAvecMaires.csv';
$sqlFile = __DIR__ . '/createTables.sql';

echo "=== IMPORT DONNÉES MAIRIES/MAIRES ===\n\n";

try {
    // Connexion PDO avec options performantes
    $pdo = new PDO(
        "mysql:host=$dbHost;dbname=$dbName;charset=utf8mb4",
        $dbUser,
        $dbPass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => false
        ]
    );
    echo "[OK] Connexion à la base de données\n";

    // Créer les tables
    echo "[...] Création des tables...\n";
    $sql = file_get_contents($sqlFile);
    $pdo->exec($sql);
    echo "[OK] Tables créées\n";

    // Désactiver les vérifications pour performance
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 0");
    $pdo->exec("SET UNIQUE_CHECKS = 0");
    $pdo->beginTransaction();

    // Lire le CSV
    echo "[...] Lecture du fichier CSV...\n";
    $handle = fopen($csvFile, 'r');
    if (!$handle) {
        throw new Exception("Impossible d'ouvrir le fichier CSV");
    }

    // Lire l'en-tête
    $header = fgetcsv($handle, 0, ';');
    if (!$header) {
        throw new Exception("Impossible de lire l'en-tête du CSV");
    }

    // Supprimer le BOM UTF-8 si présent
    $header[0] = preg_replace('/^\xEF\xBB\xBF/', '', $header[0]);

    // Mapping des colonnes (index dans le CSV)
    $colIndex = array_flip($header);

    // Debug: afficher les colonnes trouvées
    echo "Colonnes trouvées: " . implode(', ', array_keys($colIndex)) . "\n";

    // Préparer les données
    $mairiesData = [];
    $mairesData = [];
    $lineCount = 0;
    $batchSize = 1000;

    echo "[...] Traitement des données...\n";

    while (($row = fgetcsv($handle, 0, ';')) !== false) {
        $lineCount++;

        $codeCommune = $row[$colIndex['code_commune']] ?? '';
        if (empty($codeCommune)) continue;

        // Données mairie
        $longitude = $row[$colIndex['file1_longitude']] ?? '';
        $latitude = $row[$colIndex['file1_latitude']] ?? '';
        $population = $row[$colIndex['file3_population']] ?? '';

        // Nettoyer la population (enlever espaces)
        $population = preg_replace('/\s+/', '', $population);

        $mairiesData[] = [
            'codeCommune' => $codeCommune,
            'nomCommune' => $row[$colIndex['file3_nom_commune']] ?? '',
            'codePostal' => $row[$colIndex['file1_code_postal']] ?? '',
            'adresseMairie' => $row[$colIndex['file1_numero_voie']] ?? '',
            'telephone' => $row[$colIndex['file1_telephone']] ?? '',
            'email' => $row[$colIndex['file1_adresse_courriel']] ?? '',
            'siteInternet' => $row[$colIndex['file1_site_internet']] ?? '',
            'plageOuverture' => $row[$colIndex['file1_plage_ouverture']] ?? '',
            'longitude' => is_numeric($longitude) ? $longitude : null,
            'latitude' => is_numeric($latitude) ? $latitude : null,
            'codeArrondissement' => $row[$colIndex['file3_code_arrond']] ?? '',
            'nomArrondissement' => $row[$colIndex['file3_nom_arrond']] ?? '',
            'codeCanton' => $row[$colIndex['file3_code_canton']] ?? '',
            'nomCanton' => $row[$colIndex['file3_nom_canton']] ?? '',
            'codeRegion' => $row[$colIndex['file3_code_region']] ?? '',
            'nomRegion' => $row[$colIndex['file3_nom_region']] ?? '',
            'codeDept' => $row[$colIndex['file3_code_dept']] ?? '',
            'nomDept' => $row[$colIndex['file3_nom_dept']] ?? '',
            'nbHabitants' => is_numeric($population) ? (int)$population : null
        ];

        // Données maire
        $nomMaire = $row[$colIndex['file2_Nom du maire']] ?? '';
        if (!empty($nomMaire)) {
            $dateNaissance = $row[$colIndex['file2_Date de naissance']] ?? '';
            // Convertir date DD/MM/YYYY en YYYY-MM-DD
            if (preg_match('/^(\d{2})\/(\d{2})\/(\d{4})$/', $dateNaissance, $m)) {
                $dateNaissance = "{$m[3]}-{$m[2]}-{$m[1]}";
            } else {
                $dateNaissance = null;
            }

            $mairesData[] = [
                'codeCommune' => $codeCommune,
                'nomMaire' => $nomMaire,
                'prenomMaire' => $row[$colIndex['file2_Prénom du maire']] ?? '',
                'codeSexe' => $row[$colIndex['file2_Code sexe']] ?? '',
                'dateNaissance' => $dateNaissance,
                'metierMaire' => $row[$colIndex['file2_Libellé de la catégorie socio-professionnelle']] ?? ''
            ];
        }

        // Afficher progression
        if ($lineCount % 5000 == 0) {
            echo "  Lignes traitées: $lineCount\n";
        }
    }
    fclose($handle);

    echo "[OK] $lineCount lignes lues\n";
    echo "  - Mairies: " . count($mairiesData) . "\n";
    echo "  - Maires: " . count($mairesData) . "\n";

    // =============================================
    // INSERTION PAR BATCH - MAIRIES
    // =============================================
    echo "\n[...] Insertion des mairies par batch de $batchSize...\n";

    $insertedMairies = 0;
    $chunks = array_chunk($mairiesData, $batchSize);

    foreach ($chunks as $chunkIndex => $chunk) {
        $values = [];
        $params = [];
        $i = 0;

        foreach ($chunk as $row) {
            $values[] = "(
                :codeCommune$i, :nomCommune$i, :codePostal$i, :adresseMairie$i,
                :telephone$i, :email$i, :siteInternet$i, :plageOuverture$i,
                :longitude$i, :latitude$i, :codeArrondissement$i, :nomArrondissement$i,
                :codeCanton$i, :nomCanton$i, :codeRegion$i, :nomRegion$i, :codeDept$i, :nomDept$i, :nbHabitants$i
            )";

            $params["codeCommune$i"] = $row['codeCommune'];
            $params["nomCommune$i"] = $row['nomCommune'];
            $params["codePostal$i"] = $row['codePostal'];
            $params["adresseMairie$i"] = $row['adresseMairie'];
            $params["telephone$i"] = $row['telephone'];
            $params["email$i"] = $row['email'];
            $params["siteInternet$i"] = $row['siteInternet'];
            $params["plageOuverture$i"] = $row['plageOuverture'];
            $params["longitude$i"] = $row['longitude'];
            $params["latitude$i"] = $row['latitude'];
            $params["codeArrondissement$i"] = $row['codeArrondissement'];
            $params["nomArrondissement$i"] = $row['nomArrondissement'];
            $params["codeCanton$i"] = $row['codeCanton'];
            $params["nomCanton$i"] = $row['nomCanton'];
            $params["codeRegion$i"] = $row['codeRegion'];
            $params["nomRegion$i"] = $row['nomRegion'];
            $params["codeDept$i"] = $row['codeDept'];
            $params["nomDept$i"] = $row['nomDept'];
            $params["nbHabitants$i"] = $row['nbHabitants'];
            $i++;
        }

        $sql = "INSERT INTO t_mairies (
            codeCommune, nomCommune, codePostal, adresseMairie,
            telephone, email, siteInternet, plageOuverture,
            longitude, latitude, codeArrondissement, nomArrondissement,
            codeCanton, nomCanton, codeRegion, nomRegion, codeDept, nomDept, nbHabitants
        ) VALUES " . implode(',', $values);

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);

        $insertedMairies += count($chunk);
        echo "  Mairies insérées: $insertedMairies / " . count($mairiesData) . "\r";
    }
    echo "\n[OK] $insertedMairies mairies insérées\n";

    // Commit mairies
    $pdo->commit();
    $pdo->beginTransaction();

    // =============================================
    // INSERTION PAR BATCH - MAIRES
    // =============================================
    echo "\n[...] Insertion des maires par batch de $batchSize...\n";

    // Réactiver FK pour les maires
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 1");

    $insertedMaires = 0;
    $skippedMaires = 0;
    $chunks = array_chunk($mairesData, $batchSize);

    foreach ($chunks as $chunk) {
        $values = [];
        $params = [];
        $i = 0;

        foreach ($chunk as $row) {
            $values[] = "(
                :codeCommune$i, :nomMaire$i, :prenomMaire$i,
                :codeSexe$i, :dateNaissance$i, :metierMaire$i
            )";

            $params["codeCommune$i"] = $row['codeCommune'];
            $params["nomMaire$i"] = $row['nomMaire'];
            $params["prenomMaire$i"] = $row['prenomMaire'];
            $params["codeSexe$i"] = $row['codeSexe'];
            $params["dateNaissance$i"] = $row['dateNaissance'];
            $params["metierMaire$i"] = $row['metierMaire'];
            $i++;
        }

        $sql = "INSERT IGNORE INTO t_maires (
            codeCommune, nomMaire, prenomMaire,
            codeSexe, dateNaissance, metierMaire
        ) VALUES " . implode(',', $values);

        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute($params);
            $insertedMaires += $stmt->rowCount();
        } catch (PDOException $e) {
            $skippedMaires += count($chunk);
        }

        echo "  Maires insérés: $insertedMaires\r";
    }
    echo "\n[OK] $insertedMaires maires insérés";
    if ($skippedMaires > 0) {
        echo " ($skippedMaires ignorés - commune inexistante)";
    }
    echo "\n";

    // Finaliser
    $pdo->commit();
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 1");
    $pdo->exec("SET UNIQUE_CHECKS = 1");

    // Stats finales
    $countMairies = $pdo->query("SELECT COUNT(*) FROM t_mairies")->fetchColumn();
    $countMaires = $pdo->query("SELECT COUNT(*) FROM t_maires")->fetchColumn();

    echo "\n=== RÉSUMÉ ===\n";
    echo "t_mairies: $countMairies enregistrements\n";
    echo "t_maires: $countMaires enregistrements\n";
    echo "\n[OK] Import terminé avec succès!\n";

} catch (Exception $e) {
    echo "\n[ERREUR] " . $e->getMessage() . "\n";
    exit(1);
}
