<?php
/**
 * API pour la recherche des parrainages
 */

header('Content-Type: application/json; charset=utf-8');

// Connexion à la base de données
$host = 'mysql_db';
$dbname = 'annuairesMairesDeFrance';
$username = 'root';
$password = 'root';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Erreur de connexion']);
    exit;
}

$action = $_GET['action'] ?? 'search';

switch ($action) {
    case 'stats':
        // Statistiques globales
        $stats = [];

        // Total
        $stmt = $pdo->query("SELECT COUNT(*) FROM t_parrainages");
        $stats['total'] = (int)$stmt->fetchColumn();

        // Par année
        $stmt = $pdo->query("SELECT COUNT(*) FROM t_parrainages WHERE annee = 2017");
        $stats['annee_2017'] = (int)$stmt->fetchColumn();

        $stmt = $pdo->query("SELECT COUNT(*) FROM t_parrainages WHERE annee = 2022");
        $stats['annee_2022'] = (int)$stmt->fetchColumn();

        // Nombre de candidats distincts
        $stmt = $pdo->query("SELECT COUNT(DISTINCT candidat_parraine) FROM t_parrainages");
        $stats['nb_candidats'] = (int)$stmt->fetchColumn();

        echo json_encode($stats);
        break;

    case 'search':
    default:
        // Recherche avec filtres
        $conditions = [];
        $params = [];

        // Filtre candidat (multi-select)
        if (!empty($_GET['candidat']) && is_array($_GET['candidat'])) {
            $placeholders = [];
            foreach ($_GET['candidat'] as $i => $candidat) {
                $placeholders[] = ":candidat$i";
                $params["candidat$i"] = $candidat;
            }
            $conditions[] = "candidat_parraine IN (" . implode(',', $placeholders) . ")";
        }

        // Filtre année
        if (!empty($_GET['annee'])) {
            $conditions[] = "annee = :annee";
            $params['annee'] = $_GET['annee'];
        }

        // Filtre département
        if (!empty($_GET['departement'])) {
            $conditions[] = "departement = :departement";
            $params['departement'] = $_GET['departement'];
        }

        // Filtre nom
        if (!empty($_GET['nom'])) {
            $conditions[] = "nom LIKE :nom";
            $params['nom'] = '%' . $_GET['nom'] . '%';
        }

        // Filtre commune
        if (!empty($_GET['commune'])) {
            $conditions[] = "commune LIKE :commune";
            $params['commune'] = '%' . $_GET['commune'] . '%';
        }

        // Filtre mandat
        if (!empty($_GET['mandat'])) {
            $conditions[] = "mandat LIKE :mandat";
            $params['mandat'] = '%' . $_GET['mandat'] . '%';
        }

        // Construire la requête
        $sql = "SELECT civilite, nom, prenom, mandat, commune, departement, candidat_parraine, annee
                FROM t_parrainages";

        if (!empty($conditions)) {
            $sql .= " WHERE " . implode(' AND ', $conditions);
        }

        $sql .= " ORDER BY annee DESC, departement, nom LIMIT 10000";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($results);
        break;
}
