<?php
/**
 * Script de synchronisation des départements pour les référents
 *
 * Scanne tous les référents (typeUtilisateur_id = 3) qui ont un departement_id
 * dans leur fiche utilisateur et crée l'entrée correspondante dans gestionAccesDepartements
 * si elle n'existe pas déjà.
 */

header('Content-Type: text/html; charset=utf-8');
mb_internal_encoding('UTF-8');

// Configuration de la base de données
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->exec("SET NAMES 'utf8mb4'");
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

echo "<h1>Synchronisation des départements pour les référents</h1>";
echo "<hr>";

// Récupérer tous les référents (type 3) qui ont un departement_id
$stmtReferents = $pdo->query("
    SELECT
        u.id,
        u.prenom,
        u.nom,
        u.departement_id,
        d.numero_departement,
        d.nom_departement
    FROM utilisateurs u
    LEFT JOIN departements d ON u.departement_id = d.id
    WHERE u.typeUtilisateur_id = 3
    AND u.departement_id IS NOT NULL
    ORDER BY u.nom, u.prenom
");
$referents = $stmtReferents->fetchAll(PDO::FETCH_ASSOC);

echo "<p>Nombre de référents avec un département assigné : <strong>" . count($referents) . "</strong></p>";
echo "<hr>";

$inserted = 0;
$alreadyExists = 0;
$errors = [];

// Préparer les requêtes
$stmtCheck = $pdo->prepare("
    SELECT id FROM gestionAccesDepartements
    WHERE utilisateur_id = ? AND departement_id = ?
");

$stmtInsert = $pdo->prepare("
    INSERT INTO gestionAccesDepartements (utilisateur_id, departement_id, typeUtilisateur_id)
    VALUES (?, ?, 3)
");

echo "<table border='1' cellpadding='5' style='border-collapse: collapse; font-size: 12px;'>";
echo "<tr style='background: #333; color: white;'>";
echo "<th>#</th><th>Référent</th><th>Département</th><th>Statut</th>";
echo "</tr>";

foreach ($referents as $index => $ref) {
    $rowNum = $index + 1;
    $status = '';
    $statusColor = '';

    // Vérifier si l'entrée existe déjà dans gestionAccesDepartements
    $stmtCheck->execute([$ref['id'], $ref['departement_id']]);
    $exists = $stmtCheck->fetch();

    if ($exists) {
        $status = 'EXISTE DÉJÀ';
        $statusColor = 'orange';
        $alreadyExists++;
    } else {
        // Insérer l'entrée
        try {
            $stmtInsert->execute([$ref['id'], $ref['departement_id']]);
            $status = 'AJOUTÉ';
            $statusColor = 'green';
            $inserted++;
        } catch (PDOException $e) {
            $status = 'ERREUR: ' . $e->getMessage();
            $statusColor = 'red';
            $errors[] = "Ligne $rowNum: " . $e->getMessage();
        }
    }

    $deptDisplay = $ref['numero_departement']
        ? $ref['numero_departement'] . ' - ' . $ref['nom_departement']
        : 'ID: ' . $ref['departement_id'];

    echo "<tr>";
    echo "<td>$rowNum</td>";
    echo "<td>" . htmlspecialchars($ref['prenom'] . ' ' . $ref['nom']) . "</td>";
    echo "<td>" . htmlspecialchars($deptDisplay) . "</td>";
    echo "<td style='color: $statusColor; font-weight: bold;'>$status</td>";
    echo "</tr>";
}

echo "</table>";

echo "<hr>";
echo "<h2>Résumé</h2>";
echo "<ul>";
echo "<li><strong style='color: green;'>Ajoutés :</strong> $inserted</li>";
echo "<li><strong style='color: orange;'>Existaient déjà :</strong> $alreadyExists</li>";
echo "<li><strong style='color: red;'>Erreurs :</strong> " . count($errors) . "</li>";
echo "<li><strong>Total traités :</strong> " . count($referents) . "</li>";
echo "</ul>";

if (!empty($errors)) {
    echo "<h3>Détail des erreurs :</h3>";
    echo "<ul style='color: red;'>";
    foreach ($errors as $error) {
        echo "<li>" . htmlspecialchars($error) . "</li>";
    }
    echo "</ul>";
}

echo "<hr>";
echo "<p><a href='gestionUtilisateurs.php'>Retour à la gestion des utilisateurs</a></p>";
