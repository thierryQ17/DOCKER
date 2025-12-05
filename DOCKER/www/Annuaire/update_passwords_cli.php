<?php
/**
 * Script CLI de mise à jour de tous les mots de passe utilisateurs
 */

// Configuration database
$host = 'mysql';
$dbname = 'annuairesMairesDeFrance';
$username = 'testuser';
$password = 'testpass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "✓ Connexion à la base de données réussie\n\n";
} catch (PDOException $e) {
    die("✗ Erreur de connexion : " . $e->getMessage() . "\n");
}

// Nouveau mot de passe
$newPassword = 'bermuda';
$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

echo "Nouveau mot de passe : $newPassword\n";
echo "Hash bcrypt : " . substr($hashedPassword, 0, 40) . "...\n\n";

try {
    // Récupérer tous les utilisateurs
    $stmt = $pdo->query("
        SELECT u.id, u.nom, u.prenom, u.adresseMail, u.typeUtilisateur_id, u.actif,
               t.nom as type_nom, t.acronym as type_acronym
        FROM utilisateurs u
        LEFT JOIN typeUtilisateur t ON u.typeUtilisateur_id = t.id
        ORDER BY u.typeUtilisateur_id ASC, u.nom ASC
    ");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (count($users) === 0) {
        echo "⚠ Aucun utilisateur trouvé dans la base de données.\n";
        exit(0);
    }

    echo "Nombre d'utilisateurs trouvés : " . count($users) . "\n\n";
    echo "Mise à jour en cours...\n";
    echo str_repeat("-", 80) . "\n";

    // Mettre à jour tous les mots de passe
    $updateStmt = $pdo->prepare("UPDATE utilisateurs SET mdp = ? WHERE id = ?");
    $updateCount = 0;

    foreach ($users as $user) {
        $updateStmt->execute([$hashedPassword, $user['id']]);
        $updateCount++;

        $status = $user['actif'] == 1 ? "✓ Actif" : "✗ Inactif";
        $typeName = $user['type_nom'] ?? 'Type ' . $user['typeUtilisateur_id'];
        $typeAcronym = $user['type_acronym'] ?? '';

        printf(
            "[%2d] %-30s %-35s %-20s (%s) %s\n",
            $user['id'],
            $user['prenom'] . ' ' . $user['nom'],
            $user['adresseMail'],
            $typeName,
            $typeAcronym,
            $status
        );
    }

    echo str_repeat("-", 80) . "\n";
    echo "\n✓ SUCCÈS : $updateCount mot(s) de passe mis à jour avec le mot de passe '$newPassword'\n\n";

    // Afficher un résumé par type
    echo "Résumé par type d'utilisateur :\n";
    echo str_repeat("-", 80) . "\n";

    $typeStats = [];
    foreach ($users as $user) {
        $typeName = $user['type_nom'] ?? 'Type ' . $user['typeUtilisateur_id'];
        $typeAcronym = $user['type_acronym'] ?? '';
        $typeKey = $typeName . ($typeAcronym ? " ($typeAcronym)" : '');

        if (!isset($typeStats[$typeKey])) {
            $typeStats[$typeKey] = ['total' => 0, 'actif' => 0];
        }
        $typeStats[$typeKey]['total']++;
        if ($user['actif'] == 1) {
            $typeStats[$typeKey]['actif']++;
        }
    }

    foreach ($typeStats as $type => $stats) {
        printf("%-20s : %2d utilisateurs (%d actifs)\n", $type, $stats['total'], $stats['actif']);
    }

} catch (PDOException $e) {
    echo "\n✗ ERREUR : " . $e->getMessage() . "\n";
    exit(1);
}

echo "\n✓ Mise à jour terminée avec succès !\n";
?>
