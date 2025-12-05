<?php
/**
 * Corrige les relation_osm des departements en utilisant Overpass API
 * pour trouver les bons IDs basés sur les codes ISO3166-2
 *
 * Usage: php fix_osm_relations.php
 */

set_time_limit(0);

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

echo "=== Correction des relation_osm des departements ===\n\n";

// Récupérer tous les départements
$stmt = $pdo->query("SELECT id, numero_departement, nom_departement, relation_osm FROM departements ORDER BY numero_departement");
$departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Departements a verifier: " . count($departements) . "\n\n";

$updateStmt = $pdo->prepare("UPDATE departements SET relation_osm = :relation_osm WHERE id = :id");

$updated = 0;
$errors = [];

foreach ($departements as $index => $dept) {
    $numDept = $dept['numero_departement'];

    // Format ISO3166-2 pour la France: FR-01, FR-02, FR-2A, FR-2B, etc.
    $isoCode = 'FR-' . $numDept;

    echo sprintf("[%d/%d] %s - %s... ",
        $index + 1,
        count($departements),
        $numDept,
        $dept['nom_departement']
    );

    // Requête Overpass pour trouver la relation avec le bon code ISO
    $query = "[out:json][timeout:30];rel[\"ISO3166-2\"=\"$isoCode\"][\"admin_level\"=\"6\"];out ids;";

    $url = 'https://overpass-api.de/api/interpreter';

    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $url,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => 'data=' . urlencode($query),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 60,
        CURLOPT_HTTPHEADER => [
            'Content-Type: application/x-www-form-urlencoded',
            'User-Agent: AnnuaireMaires/1.0'
        ]
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);

    if ($error) {
        echo "ERREUR cURL: $error\n";
        $errors[] = "$numDept: $error";
        sleep(5);
        continue;
    }

    if ($httpCode !== 200) {
        echo "ERREUR HTTP $httpCode\n";
        $errors[] = "$numDept: HTTP $httpCode";
        sleep(5);
        continue;
    }

    $data = json_decode($response, true);

    if (!$data || empty($data['elements'])) {
        echo "Pas de resultat\n";
        $errors[] = "$numDept: Pas de relation trouvee";
        sleep(2);
        continue;
    }

    $newRelationId = $data['elements'][0]['id'];
    $oldRelationId = $dept['relation_osm'];

    if ($newRelationId == $oldRelationId) {
        echo "OK (deja correct: $newRelationId)\n";
    } else {
        try {
            $updateStmt->execute([
                'relation_osm' => $newRelationId,
                'id' => $dept['id']
            ]);
            echo "MIS A JOUR: $oldRelationId -> $newRelationId\n";
            $updated++;
        } catch (PDOException $e) {
            echo "ERREUR BDD: " . $e->getMessage() . "\n";
            $errors[] = "$numDept: " . $e->getMessage();
        }
    }

    // Pause pour éviter le rate limiting
    sleep(2);
}

echo "\n=== Resultat ===\n";
echo "Mis a jour: $updated departements\n";

if (!empty($errors)) {
    echo "\nErreurs:\n";
    foreach ($errors as $err) {
        echo "  - $err\n";
    }
}

echo "\nTermine!\n";
