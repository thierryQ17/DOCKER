<?php
/**
 * Script d'import des responsables UPR depuis le fichier JSON
 * Mapping JSON -> Table utilisateurs
 * TOUS les enregistrements sont importés (même sans email)
 *
 * Usage CLI: php import_responsables_upr.php
 * Usage Web: Accéder à cette page (réservé admin)
 */

// Forcer l'encodage UTF-8
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

// Charger le fichier JSON
$jsonFile = __DIR__ . '/data/responsables_export.json';
if (!file_exists($jsonFile)) {
    die("Fichier JSON introuvable: $jsonFile");
}

$jsonContent = file_get_contents($jsonFile);

// Supprimer le BOM UTF-8 si présent
$jsonContent = preg_replace('/^\xEF\xBB\xBF/', '', $jsonContent);

$data = json_decode($jsonContent, true);

if (!$data || !isset($data['Donnees'])) {
    die("Erreur de lecture du fichier JSON. JSON Error: " . json_last_error_msg());
}

// D'abord, ajouter la colonne image si elle n'existe pas
try {
    $pdo->exec("ALTER TABLE utilisateurs ADD COLUMN image VARCHAR(255) DEFAULT NULL");
    echo "<p style='color: green;'>Colonne 'image' ajoutée à la table utilisateurs.</p>";
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'Duplicate column') !== false) {
        echo "<p style='color: orange;'>Colonne 'image' existe déjà.</p>";
    } else {
        echo "<p style='color: red;'>Erreur lors de l'ajout de la colonne image: " . $e->getMessage() . "</p>";
    }
}

// Récupérer les départements existants pour le mapping
$stmtDepts = $pdo->query("SELECT id, numero_departement FROM departements");
$departementsMap = [];
while ($row = $stmtDepts->fetch(PDO::FETCH_ASSOC)) {
    $departementsMap[$row['numero_departement']] = $row['id'];
}

/**
 * Extraire le code département depuis le champ "Departement" du JSON
 * Ex: "02 : Aisne" -> "02"
 *     "972 : Martinique" -> "972"
 *     "Président" -> null
 */
function extractDepartementCode($departementStr) {
    if (preg_match('/^(\d{2,3})\s*:/', $departementStr, $matches)) {
        return $matches[1];
    }
    if (preg_match('/^(20)\s*:/', $departementStr, $matches)) {
        return $matches[1];
    }
    return null;
}

/**
 * Parser le nom complet quand le prénom est vide
 * Ex: "Nelly PATÉ" -> ["PATÉ", "Nelly"]
 */
function parseNomComplet($nom, $prenom) {
    $nom = trim($nom);
    $prenom = trim($prenom);

    if (!empty($prenom)) {
        return [$nom, $prenom];
    }

    $parts = explode(' ', $nom, 2);
    if (count($parts) === 2) {
        return [trim($parts[1]), trim($parts[0])];
    }

    return [$nom, $prenom];
}

/**
 * Générer un pseudo unique à partir du prénom et nom
 */
function generatePseudo($prenom, $nom, $pdo, &$existingPseudos) {
    $prenomClean = preg_replace('/[^a-zA-Z]/', '', removeAccents($prenom));
    $nomClean = preg_replace('/[^a-zA-Z]/', '', removeAccents($nom));

    $basePseudo = strtolower($prenomClean . '.' . $nomClean);
    if (empty($basePseudo)) {
        $basePseudo = 'user' . rand(1000, 9999);
    }

    $pseudo = $basePseudo;
    $counter = 1;

    while (true) {
        if (in_array($pseudo, $existingPseudos)) {
            $pseudo = $basePseudo . $counter;
            $counter++;
            continue;
        }

        $stmt = $pdo->prepare("SELECT id FROM utilisateurs WHERE pseudo = ?");
        $stmt->execute([$pseudo]);
        if (!$stmt->fetch()) {
            break;
        }
        $pseudo = $basePseudo . $counter;
        $counter++;
    }

    $existingPseudos[] = $pseudo;
    return $pseudo;
}

/**
 * Supprimer les accents
 */
function removeAccents($string) {
    $accents = ['À','Á','Â','Ã','Ä','Å','à','á','â','ã','ä','å','Ò','Ó','Ô','Õ','Ö','Ø','ò','ó','ô','õ','ö','ø','È','É','Ê','Ë','è','é','ê','ë','Ç','ç','Ì','Í','Î','Ï','ì','í','î','ï','Ù','Ú','Û','Ü','ù','ú','û','ü','ÿ','Ñ','ñ'];
    $normal = ['A','A','A','A','A','A','a','a','a','a','a','a','O','O','O','O','O','O','o','o','o','o','o','o','E','E','E','E','e','e','e','e','C','c','I','I','I','I','i','i','i','i','U','U','U','U','u','u','u','u','y','N','n'];
    return str_replace($accents, $normal, $string);
}

echo "<h1>Import des responsables UPR</h1>";
echo "<p>Fichier source: $jsonFile</p>";
echo "<p>Nombre d'enregistrements: " . count($data['Donnees']) . "</p>";
echo "<hr>";

$inserted = 0;
$updated = 0;
$errors = [];
$existingPseudos = [];

// Préparer les requêtes
$stmtCheckPseudo = $pdo->prepare("SELECT id FROM utilisateurs WHERE pseudo = ?");
$stmtInsert = $pdo->prepare("
    INSERT INTO utilisateurs (nom, prenom, pseudo, adresseMail, telephone, mdp, date_creation, actif, commentaires, typeUtilisateur_id, departement_id, image)
    VALUES (?, ?, ?, ?, '', ?, NOW(), 1, ?, ?, ?, ?)
");
$stmtUpdate = $pdo->prepare("
    UPDATE utilisateurs
    SET nom = ?, prenom = ?, typeUtilisateur_id = ?, departement_id = ?, image = ?, commentaires = ?
    WHERE pseudo = ?
");

// Hasher le mot de passe par défaut
$defaultPassword = password_hash('upr', PASSWORD_DEFAULT);

echo "<table border='1' cellpadding='5' style='border-collapse: collapse; font-size: 12px;'>";
echo "<tr style='background: #333; color: white;'>";
echo "<th>#</th><th>Nom</th><th>Prénom</th><th>Pseudo</th><th>Email</th><th>Département</th><th>Role</th><th>Image</th><th>Statut</th>";
echo "</tr>";

foreach ($data['Donnees'] as $index => $item) {
    $rowNum = $index + 1;

    // Parser nom/prénom (avec trim pour supprimer espaces)
    list($nom, $prenom) = parseNomComplet($item['Nom'], $item['Prenom']);
    $nom = trim($nom);
    $prenom = trim($prenom);

    $email = trim($item['Email'] ?? '');
    $departementStr = $item['Departement'] ?? '';
    $role = intval($item['Role']);
    $image = $item['Image'] ?? '';

    // Extraire le code département
    $deptCode = extractDepartementCode($departementStr);
    $departement_id = null;

    if ($deptCode !== null) {
        if ($deptCode === '20') {
            $departement_id = $departementsMap['2A'] ?? $departementsMap['2B'] ?? null;
        } else {
            $departement_id = $departementsMap[$deptCode] ?? null;
        }
    }

    // Générer le pseudo
    $pseudo = generatePseudo($prenom, $nom, $pdo, $existingPseudos);

    // Commentaires
    $commentaires = "Mot de passe : upr";
    if (!empty($departementStr) && $deptCode === null) {
        $commentaires .= " | Fonction: " . $departementStr;
    }

    // Vérifier si le pseudo existe déjà (pour mise à jour)
    $stmtCheckPseudo->execute([$pseudo]);
    $existing = $stmtCheckPseudo->fetch(PDO::FETCH_ASSOC);

    $status = '';
    $statusColor = '';

    if ($existing) {
        // Mise à jour
        try {
            $stmtUpdate->execute([$nom, $prenom, $role, $departement_id, $image, $commentaires, $pseudo]);
            $status = 'MAJ';
            $statusColor = 'blue';
            $updated++;
        } catch (PDOException $e) {
            $status = 'ERREUR: ' . $e->getMessage();
            $statusColor = 'red';
            $errors[] = "Ligne $rowNum: " . $e->getMessage();
        }
    } else {
        // Insertion
        try {
            $stmtInsert->execute([
                $nom,
                $prenom,
                $pseudo,
                $email,
                $defaultPassword,
                $commentaires,
                $role,
                $departement_id,
                $image
            ]);
            $status = 'INSERE';
            $statusColor = 'green';
            $inserted++;
        } catch (PDOException $e) {
            $status = 'ERREUR: ' . $e->getMessage();
            $statusColor = 'red';
            $errors[] = "Ligne $rowNum ($nom $prenom): " . $e->getMessage();
        }
    }

    $emailDisplay = !empty($email) ? htmlspecialchars($email) : '<span style="color:#999;">-</span>';

    echo "<tr>";
    echo "<td>$rowNum</td>";
    echo "<td>" . htmlspecialchars($nom) . "</td>";
    echo "<td>" . htmlspecialchars($prenom) . "</td>";
    echo "<td><code>" . htmlspecialchars($pseudo) . "</code></td>";
    echo "<td>$emailDisplay</td>";
    echo "<td>" . htmlspecialchars($departementStr) . " <small style='color:#666;'>(" . ($deptCode ?? '-') . " -> " . ($departement_id ?? 'NULL') . ")</small></td>";
    echo "<td>$role</td>";
    echo "<td>" . (!empty($image) ? '<span style="color:green;">Oui</span>' : '<span style="color:#ccc;">Non</span>') . "</td>";
    echo "<td style='color: $statusColor; font-weight: bold;'>$status</td>";
    echo "</tr>";
}

echo "</table>";

echo "<hr>";
echo "<h2>Résumé</h2>";
echo "<ul>";
echo "<li><strong style='color: green;'>Insérés:</strong> $inserted</li>";
echo "<li><strong style='color: blue;'>Mis à jour:</strong> $updated</li>";
echo "<li><strong style='color: red;'>Erreurs:</strong> " . count($errors) . "</li>";
echo "<li><strong>Total traités:</strong> " . ($inserted + $updated + count($errors)) . " / " . count($data['Donnees']) . "</li>";
echo "</ul>";

if (!empty($errors)) {
    echo "<h3>Détail des erreurs:</h3>";
    echo "<ul style='color: red;'>";
    foreach ($errors as $error) {
        echo "<li>" . htmlspecialchars($error) . "</li>";
    }
    echo "</ul>";
}

echo "<p><a href='gestionUtilisateurs.php'>Retour à la gestion des utilisateurs</a></p>";
