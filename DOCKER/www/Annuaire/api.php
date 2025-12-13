<?php
/**
 * API REST pour l'application Annuaire des Maires de France
 * Centralise toutes les routes AJAX
 */

// Forcer l'encodage UTF-8
header('Content-Type: application/json; charset=utf-8');
mb_internal_encoding('UTF-8');

// Configuration de la base de données
// require_once __DIR__ . '/../../config/database.php'; // Commenté : fichier non monté dans Docker

// Configuration inline (utilisée car config/database.php non accessible dans Docker)
if (true || !isset($pdo)) {
    $host = 'mysql';
    $dbname = 'annuairesMairesDeFrance';
    $username = 'testuser';
    $password = 'testpass';

    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->exec("SET NAMES 'utf8mb4'");
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Database connection failed']);
        exit;
    }
}

// Header JSON par défaut
header('Content-Type: application/json');

// Charger la configuration globale depuis menus.json
$menusConfig = json_decode(file_get_contents(__DIR__ . '/config/menus.json'), true);
$GLOBALS['filtreHabitants'] = $menusConfig['filtreHabitants'] ?? 1000;

// Charger le Logger (optionnel - ne bloque pas si la table n'existe pas)
require_once __DIR__ . '/classes/Logger.php';
try {
    $GLOBALS['logger'] = new Logger($pdo);
} catch (Exception $e) {
    $GLOBALS['logger'] = null;
}

// Récupérer l'action (GET, POST ou JSON body)
$action = $_GET['action'] ?? $_POST['action'] ?? '';

// Lire le body JSON une seule fois et le stocker globalement
$GLOBALS['jsonInput'] = null;
$rawInput = file_get_contents('php://input');
if (!empty($rawInput)) {
    $GLOBALS['jsonInput'] = json_decode($rawInput, true);
}

// Si pas d'action trouvée, vérifier le body JSON
if (empty($action) && $GLOBALS['jsonInput'] && isset($GLOBALS['jsonInput']['action'])) {
    $action = $GLOBALS['jsonInput']['action'];
}

// Router les actions
switch ($action) {
    case 'saveDemarchage':
        saveDemarchage($pdo);
        break;

    case 'getDemarchage':
        getDemarchage($pdo);
        break;

    case 'getMaireDetails':
        getMaireDetails($pdo);
        break;

    case 'getStatsDemarchage':
        getStatsDemarchage($pdo);
        break;

    case 'getCirconscriptions':
        getCirconscriptions($pdo);
        break;

    case 'getMaires':
        getMaires($pdo);
        break;

    case 'autocomplete':
        autocomplete($pdo);
        break;

    case 'autocompleteAdvanced':
        autocompleteAdvanced($pdo);
        break;

    case 'getDepartements':
        getDepartements($pdo);
        break;

    case 'getCantons':
        getCantons($pdo);
        break;

    case 'getCommunes':
        getCommunes($pdo);
        break;

    // ===== ARBORESCENCE =====
    case 'getArborescence':
        getArborescence($pdo);
        break;

    case 'getArborescenceChildren':
        getArborescenceChildren($pdo);
        break;

    case 'getArborescenceNode':
        getArborescenceNode($pdo);
        break;

    case 'searchArborescence':
        searchArborescence($pdo);
        break;

    case 'getArborescenceStats':
        getArborescenceStats($pdo);
        break;

    // ===== GESTION DES DROITS =====
    case 'saveGestionDroits':
        saveGestionDroits($pdo);
        break;

    case 'getGestionDroits':
        getGestionDroits($pdo);
        break;

    case 'getDepartementId':
        getDepartementId($pdo);
        break;

    case 'getAllUtilisateurs':
        getAllUtilisateurs($pdo);
        break;

    case 'searchUtilisateurs':
        searchUtilisateurs($pdo);
        break;

    // ===== GESTION DES DROITS PAR CANTONS =====
    case 'getRegions':
        getRegions($pdo);
        break;

    case 'getDepartementsByRegion':
        getDepartementsByRegion($pdo);
        break;

    case 'getCircosByDepartement':
        getCircosByDepartement($pdo);
        break;

    case 'getCantonsByCirco':
        getCantonsByCirco($pdo);
        break;

    case 'getGestionDroitsCantons':
        getGestionDroitsCantons($pdo);
        break;

    case 'saveGestionDroitsCanton':
        saveGestionDroitsCanton($pdo);
        break;

    // ===== GESTION DES UTILISATEURS =====
    case 'getRegionsDepartements':
        getRegionsDepartements($pdo);
        break;

    case 'getUserDroits':
        getUserDroits($pdo);
        break;

    case 'getAllCantons':
        getAllCantons($pdo);
        break;

    case 'getUserCantons':
        getUserCantons($pdo);
        break;

    case 'saveUtilisateur':
        saveUtilisateur($pdo);
        break;

    case 'changePassword':
        changePassword($pdo);
        break;

    case 'saveUserDroits':
        saveUserDroits($pdo);
        break;

    case 'saveUserCantons':
        saveUserCantons($pdo);
        break;

    case 'deleteUtilisateur':
        deleteUtilisateur($pdo);
        break;

    case 'getUtilisateursParRegion':
        getUtilisateursParRegion($pdo);
        break;

    case 'saveMyCantons':
        saveMyCantons($pdo);
        break;

    case 'getStatsReferents':
        getStatsReferents($pdo);
        break;

    // ===== PARAMÈTRES =====
    case 'saveParameters':
        saveParameters($pdo);
        break;

    // ===== LOGS D'ACTIVITÉ =====
    case 'getLogs':
        getLogs($pdo);
        break;

    case 'getLogDetail':
        getLogDetail($pdo);
        break;

    case 'deleteLog':
        deleteLog($pdo);
        break;

    case 'purgeLogs':
        purgeLogs($pdo);
        break;

    // ===== TYPES UTILISATEURS =====
    case 'getTypeUtilisateurs':
        getTypeUtilisateurs($pdo);
        break;

    default:
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Invalid action']);
        exit;
}

/**
 * Enregistrer les données de démarchage
 */
function saveDemarchage($pdo) {
    $maireCleUnique = $_POST['maire_cle_unique'] ?? '';
    $demarcheActive = (int)($_POST['demarche_active'] ?? 0);
    $parrainageObtenu = (int)($_POST['parrainage_obtenu'] ?? 0);
    $statutDemarchage = (int)($_POST['statut_demarchage'] ?? 0);
    $rdvDate = (!empty($_POST['rdv_date'])) ? $_POST['rdv_date'] : null;
    $commentaire = $_POST['commentaire'] ?? '';

    if (empty($maireCleUnique)) {
        echo json_encode(['success' => false, 'error' => 'Clé unique maire invalide']);
        exit;
    }

    try {
        // Récupérer le nom de la commune pour le log
        $stmtMaire = $pdo->prepare("SELECT commune FROM maires WHERE cle_unique = ?");
        $stmtMaire->execute([$maireCleUnique]);
        $maireInfo = $stmtMaire->fetch(PDO::FETCH_ASSOC);
        $communeNom = $maireInfo['commune'] ?? $maireCleUnique;

        // Vérifier si un enregistrement existe déjà
        $stmt = $pdo->prepare("SELECT id FROM demarchage WHERE maire_cle_unique = ?");
        $stmt->execute([$maireCleUnique]);
        $existing = $stmt->fetch(PDO::FETCH_ASSOC);

        $isUpdate = (bool)$existing;

        if ($existing) {
            // Mise à jour
            $stmt = $pdo->prepare("
                UPDATE demarchage
                SET demarche_active = ?,
                    parrainage_obtenu = ?,
                    statut_demarchage = ?,
                    rdv_date = ?,
                    commentaire = ?,
                    updated_at = NOW()
                WHERE maire_cle_unique = ?
            ");
            $stmt->execute([$demarcheActive, $parrainageObtenu, $statutDemarchage, $rdvDate, $commentaire, $maireCleUnique]);
        } else {
            // Insertion
            $stmt = $pdo->prepare("
                INSERT INTO demarchage (maire_cle_unique, demarche_active, parrainage_obtenu, statut_demarchage, rdv_date, commentaire, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())
            ");
            $stmt->execute([$maireCleUnique, $demarcheActive, $parrainageObtenu, $statutDemarchage, $rdvDate, $commentaire]);
        }

        // Logger l'action
        if (isset($GLOBALS['logger'])) {
            try {
                $GLOBALS['logger']->logDemarchage(
                    $isUpdate ? 'update' : 'create',
                    $maireCleUnique,
                    $communeNom,
                    [
                        'demarche_active' => $demarcheActive,
                        'statut_demarchage' => $statutDemarchage,
                        'parrainage_obtenu' => $parrainageObtenu
                    ]
                );
            } catch (Exception $e) {
                // Ignorer les erreurs de log pour ne pas bloquer l'application
            }
        }

        echo json_encode(['success' => true, 'message' => 'Données enregistrées avec succès']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les données de démarchage
 */
function getDemarchage($pdo) {
    $maireCleUnique = $_GET['maire_cle_unique'] ?? '';

    if (empty($maireCleUnique)) {
        echo json_encode(['success' => false, 'error' => 'Clé unique maire invalide']);
        exit;
    }

    $stmt = $pdo->prepare("SELECT * FROM demarchage WHERE maire_cle_unique = ?");
    $stmt->execute([$maireCleUnique]);
    $demarchage = $stmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'demarchage' => $demarchage ?: null
    ]);
    exit;
}

/**
 * Récupérer les détails complets d'un maire
 */
function getMaireDetails($pdo) {
    $maireId = (int)($_GET['id'] ?? 0);

    if ($maireId <= 0) {
        echo json_encode(['success' => false, 'error' => 'ID invalide']);
        exit;
    }

    $stmt = $pdo->prepare("
        SELECT
            m.id,
            m.cle_unique,
            m.region,
            m.numero_departement,
            m.nom_departement,
            m.circonscription,
            m.canton,
            m.ville,
            m.code_postal,
            m.nom_maire,
            m.telephone,
            m.email,
            m.url_mairie,
            m.lien_google_maps,
            m.lien_waze
        FROM maires m
        WHERE m.id = ?
    ");
    $stmt->execute([$maireId]);
    $maire = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($maire) {
        echo json_encode(['success' => true, 'maire' => $maire]);
    } else {
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Maire non trouvé']);
    }
    exit;
}

/**
 * Récupérer les statistiques de démarchage (optimisé avec UNION)
 */
function getStatsDemarchage($pdo) {
    $stmt = $pdo->prepare("
        (SELECT
            'region' as type,
            m.region as key1,
            NULL as key2,
            COUNT(DISTINCT CASE WHEN d.demarche_active = 1 THEN m.id END) as nb_demarches
        FROM maires m
        LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique
        GROUP BY m.region)
        UNION ALL
        (SELECT
            'departement' as type,
            m.numero_departement as key1,
            m.nom_departement as key2,
            COUNT(DISTINCT CASE WHEN d.demarche_active = 1 THEN m.id END) as nb_demarches
        FROM maires m
        LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique
        GROUP BY m.numero_departement, m.nom_departement)
        ORDER BY type DESC, key1 ASC
    ");
    $stmt->execute();
    $allStats = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Séparer les résultats
    $statsRegions = [];
    $statsDepartements = [];

    foreach ($allStats as $stat) {
        if ($stat['type'] === 'region') {
            $statsRegions[] = [
                'region' => $stat['key1'],
                'nb_demarches' => $stat['nb_demarches']
            ];
        } else {
            $statsDepartements[] = [
                'numero_departement' => $stat['key1'],
                'nom_departement' => $stat['key2'],
                'nb_demarches' => $stat['nb_demarches']
            ];
        }
    }

    echo json_encode([
        'success' => true,
        'regions' => $statsRegions,
        'departements' => $statsDepartements
    ]);
    exit;
}

/**
 * Récupérer les circonscriptions d'un département
 */
function getCirconscriptions($pdo) {
    $departement = $_GET['departement'] ?? '';
    $region = $_GET['region'] ?? '';

    $whereClause = "WHERE 1=1";
    $params = [];

    if (!empty($region)) {
        $whereClause .= " AND region = ?";
        $params[] = $region;
    }

    if (!empty($departement)) {
        $whereClause .= " AND (numero_departement LIKE ? OR nom_departement LIKE ?)";
        $deptParam = "%$departement%";
        $params[] = $deptParam;
        $params[] = $deptParam;
    }

    $stmt = $pdo->prepare("
        SELECT DISTINCT circonscription
        FROM maires
        $whereClause
        AND circonscription IS NOT NULL
        AND circonscription != ''
        ORDER BY CAST(circonscription AS UNSIGNED) ASC
    ");
    $stmt->execute($params);
    $circonscriptions = $stmt->fetchAll(PDO::FETCH_COLUMN);

    // Convertir en format avec propriété 'numero' pour le frontend
    $result = array_map(function($c) {
        return ['numero' => $c];
    }, $circonscriptions);

    echo json_encode(['success' => true, 'circonscriptions' => $result]);
    exit;
}

/**
 * Récupérer les maires avec filtres
 */
function getMaires($pdo) {
    $departement = $_GET['departement'] ?? '';
    $departements = $_GET['departements'] ?? ''; // Liste de départements séparés par virgule
    $search = $_GET['search'] ?? '';
    $region = $_GET['region'] ?? '';
    $commune = $_GET['commune'] ?? '';
    $canton = $_GET['canton'] ?? '';
    $cantons = $_GET['cantons'] ?? ''; // Liste de cantons séparés par virgule
    $circo = $_GET['circo'] ?? '';
    $nbHabitants = (int)($_GET['nbHabitants'] ?? 0);
    $page = (int)($_GET['page'] ?? 1);
    $showAll = isset($_GET['showAll']) && $_GET['showAll'] === '1';
    $filterDemarchage = isset($_GET['filterDemarchage']) && $_GET['filterDemarchage'] === '1';
    $perPage = $showAll ? 100000 : 50;
    $offset = ($page - 1) * $perPage;

    $whereClause = "WHERE 1=1";
    $params = [];

    // Filtrer uniquement les communes avec démarchage actif
    if ($filterDemarchage) {
        $whereClause .= " AND COALESCE(d.demarche_active, 0) = 1";
    }

    // Recherche par région
    if (!empty($region)) {
        $whereClause .= " AND m.region = ?";
        $params[] = $region;
    }

    // Recherche par plusieurs départements (liste séparée par virgule)
    if (!empty($departements)) {
        $deptList = array_filter(array_map('trim', explode(',', $departements)));
        if (!empty($deptList)) {
            $placeholders = implode(',', array_fill(0, count($deptList), '?'));
            $whereClause .= " AND m.numero_departement IN ($placeholders)";
            $params = array_merge($params, $deptList);
        }
    }
    // Recherche par département unique (numéro ou nom)
    elseif (!empty($departement)) {
        $whereClause .= " AND (m.numero_departement LIKE ? OR m.nom_departement LIKE ?)";
        $deptParam = "%$departement%";
        $params[] = $deptParam;
        $params[] = $deptParam;
    }

    // Recherche par commune
    if (!empty($commune)) {
        $whereClause .= " AND m.ville LIKE ?";
        $params[] = "%$commune%";
    }

    // Recherche par plusieurs cantons (liste séparée par virgule)
    if (!empty($cantons)) {
        $cantonList = array_filter(array_map('trim', explode(',', $cantons)));
        if (!empty($cantonList)) {
            $placeholders = implode(',', array_fill(0, count($cantonList), '?'));
            $whereClause .= " AND m.canton IN ($placeholders)";
            $params = array_merge($params, $cantonList);
        }
    }
    // Recherche par canton unique
    elseif (!empty($canton)) {
        $whereClause .= " AND m.canton LIKE ?";
        $params[] = "%$canton%";
    }

    // Recherche par circonscription
    if (!empty($circo)) {
        $whereClause .= " AND m.circonscription LIKE ?";
        $params[] = "%$circo%";
    }

    // Recherche par nombre d'habitants (maximum)
    if ($nbHabitants > 0) {
        $whereClause .= " AND m.nombre_habitants <= ?";
        $params[] = $nbHabitants;
    }

    // Recherche globale (ancienne fonctionnalité)
    if (!empty($search)) {
        $whereClause .= " AND (m.ville LIKE ? OR m.nom_maire LIKE ? OR m.nom_departement LIKE ? OR m.circonscription LIKE ?)";
        $searchParam = "%$search%";
        $params = array_merge($params, [$searchParam, $searchParam, $searchParam, $searchParam]);
    }

    // Compter le total
    $countStmt = $pdo->prepare("SELECT COUNT(*) FROM maires m LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique $whereClause");
    $countStmt->execute($params);
    $total = $countStmt->fetchColumn();

    // Récupérer les maires
    $limitClause = $showAll ? "" : "LIMIT $perPage OFFSET $offset";
    $stmt = $pdo->prepare("
        SELECT
            m.id,
            m.cle_unique,
            m.region,
            m.numero_departement,
            m.nom_departement,
            m.circonscription,
            m.ville,
            m.canton,
            m.nombre_habitants,
            m.nom_maire,
            m.telephone,
            COALESCE(d.demarche_active, 0) as demarche_active,
            COALESCE(d.parrainage_obtenu, 0) as parrainage_obtenu,
            COALESCE(d.statut_demarchage, 0) as statut_demarchage,
            d.rdv_date,
            d.commentaire
        FROM maires m
        LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique
        $whereClause
        ORDER BY m.region ASC, m.nom_departement ASC, m.circonscription ASC, m.canton ASC, m.ville ASC
        $limitClause
    ");
    $stmt->execute($params);
    $maires = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'maires' => $maires,
        'total' => $total,
        'page' => $page,
        'perPage' => $perPage,
        'totalPages' => ceil($total / $perPage)
    ]);
    exit;
}

/**
 * Autocomplétion filtrée par département (pour menu)
 */
function autocomplete($pdo) {
    $type = $_GET['type'] ?? '';
    $term = $_GET['term'] ?? '';
    $departement = $_GET['departement'] ?? '';

    $results = [];

    if (!empty($term) && !empty($departement)) {
        // Détecter si le terme contient déjà des wildcards %
        $hasWildcard = strpos($term, '%') !== false;

        // Si le terme est %%, le remplacer par % (pour matcher tout)
        if ($term === '%%') {
            $term = '%';
        }

        // Définir la limite : 100 si wildcard, 20 sinon
        $limit = $hasWildcard ? 100 : 20;

        switch($type) {
            case 'circo':
                $stmt = $pdo->prepare("
                    SELECT DISTINCT circonscription
                    FROM maires
                    WHERE numero_departement = ?
                    AND circonscription IS NOT NULL
                    AND circonscription != ''
                    AND circonscription LIKE ?
                    ORDER BY circonscription ASC
                    LIMIT " . $limit . "
                ");
                // Gestion intelligente des wildcards
                if ($hasWildcard) {
                    // Si commence par % et ne finit pas par %, ajouter % à la fin
                    if (substr($term, 0, 1) === '%' && substr($term, -1) !== '%') {
                        $searchTerm = $term . '%';
                    }
                    // Si finit par % et ne commence pas par %, ajouter % au début
                    else if (substr($term, -1) === '%' && substr($term, 0, 1) !== '%') {
                        $searchTerm = '%' . $term;
                    }
                    // Sinon utiliser tel quel
                    else {
                        $searchTerm = $term;
                    }
                } else {
                    $searchTerm = $term . '%';
                }
                $stmt->execute([$departement, $searchTerm]);
                $results = $stmt->fetchAll(PDO::FETCH_COLUMN);
                break;

            case 'canton':
                $stmt = $pdo->prepare("
                    SELECT DISTINCT canton
                    FROM maires
                    WHERE numero_departement = ?
                    AND canton LIKE ?
                    ORDER BY canton ASC
                    LIMIT " . $limit . "
                ");
                // Gestion intelligente des wildcards
                if ($hasWildcard) {
                    // Si commence par % et ne finit pas par %, ajouter % à la fin
                    if (substr($term, 0, 1) === '%' && substr($term, -1) !== '%') {
                        $searchTerm = $term . '%';
                    }
                    // Si finit par % et ne commence pas par %, ajouter % au début
                    else if (substr($term, -1) === '%' && substr($term, 0, 1) !== '%') {
                        $searchTerm = '%' . $term;
                    }
                    // Sinon utiliser tel quel
                    else {
                        $searchTerm = $term;
                    }
                } else {
                    $searchTerm = '%' . $term . '%';
                }
                $stmt->execute([$departement, $searchTerm]);
                $results = $stmt->fetchAll(PDO::FETCH_COLUMN);
                break;

            case 'commune':
                $stmt = $pdo->prepare("
                    SELECT DISTINCT ville
                    FROM maires
                    WHERE numero_departement = ?
                    AND ville LIKE ?
                    ORDER BY ville ASC
                    LIMIT " . $limit . "
                ");
                // Gestion intelligente des wildcards
                if ($hasWildcard) {
                    // Si commence par % et ne finit pas par %, ajouter % à la fin
                    if (substr($term, 0, 1) === '%' && substr($term, -1) !== '%') {
                        $searchTerm = $term . '%';
                    }
                    // Si finit par % et ne commence pas par %, ajouter % au début
                    else if (substr($term, -1) === '%' && substr($term, 0, 1) !== '%') {
                        $searchTerm = '%' . $term;
                    }
                    // Sinon utiliser tel quel
                    else {
                        $searchTerm = $term;
                    }
                } else {
                    $searchTerm = '%' . $term . '%';
                }
                $stmt->execute([$departement, $searchTerm]);
                $results = $stmt->fetchAll(PDO::FETCH_COLUMN);
                break;
        }
    }

    echo json_encode(['results' => $results]);
    exit;
}

/**
 * Autocomplétion pour recherche avancée (sans filtre département)
 */
function autocompleteAdvanced($pdo) {
    $type = $_GET['type'] ?? '';
    $term = $_GET['term'] ?? '';
    $region = $_GET['region'] ?? '';

    $results = [];

    // Permettre la recherche avec wildcard % - minimum 1 caractère si contient %
    $hasWildcard = strpos($term, '%') !== false;
    $minLength = $hasWildcard ? 1 : 2;

    // Si le terme est %%, le remplacer par % (pour matcher tout)
    if ($term === '%%') {
        $term = '%';
    }

    if (!empty($term) && strlen($term) >= $minLength) {
        // Définir la limite : 100 si wildcard, 20 sinon
        $limit = $hasWildcard ? 100 : 20;

        switch($type) {
            case 'departement':
                // Gestion intelligente des wildcards
                if ($hasWildcard) {
                    if (substr($term, 0, 1) === '%' && substr($term, -1) !== '%') {
                        $searchTerm = $term . '%';
                    } else if (substr($term, -1) === '%' && substr($term, 0, 1) !== '%') {
                        $searchTerm = '%' . $term;
                    } else {
                        $searchTerm = $term;
                    }
                } else {
                    $searchTerm = '%' . $term . '%';
                }

                $whereClause = "WHERE (numero_departement LIKE ? OR nom_departement LIKE ?)";
                $params = [$searchTerm, $searchTerm];

                if (!empty($region)) {
                    $whereClause .= " AND region = ?";
                    $params[] = $region;
                }

                $stmt = $pdo->prepare("
                    SELECT DISTINCT CONCAT(numero_departement, ' - ', nom_departement) as dept
                    FROM maires
                    $whereClause
                    ORDER BY numero_departement ASC
                    LIMIT " . $limit . "
                ");
                $stmt->execute($params);
                $results = $stmt->fetchAll(PDO::FETCH_COLUMN);
                break;

            case 'canton':
                // Gestion intelligente des wildcards
                if ($hasWildcard) {
                    if (substr($term, 0, 1) === '%' && substr($term, -1) !== '%') {
                        $searchTerm = $term . '%';
                    } else if (substr($term, -1) === '%' && substr($term, 0, 1) !== '%') {
                        $searchTerm = '%' . $term;
                    } else {
                        $searchTerm = $term;
                    }
                } else {
                    $searchTerm = '%' . $term . '%';
                }

                $whereClause = "WHERE canton LIKE ?";
                $params = [$searchTerm];

                if (!empty($region)) {
                    $whereClause .= " AND region = ?";
                    $params[] = $region;
                }

                $stmt = $pdo->prepare("
                    SELECT DISTINCT canton
                    FROM maires
                    $whereClause
                    AND canton IS NOT NULL
                    AND canton != ''
                    ORDER BY canton ASC
                    LIMIT " . $limit . "
                ");
                $stmt->execute($params);
                $results = $stmt->fetchAll(PDO::FETCH_COLUMN);
                break;

            case 'commune':
                // Gestion intelligente des wildcards
                if ($hasWildcard) {
                    if (substr($term, 0, 1) === '%' && substr($term, -1) !== '%') {
                        $searchTerm = $term . '%';
                    } else if (substr($term, -1) === '%' && substr($term, 0, 1) !== '%') {
                        $searchTerm = '%' . $term;
                    } else {
                        $searchTerm = $term;
                    }
                } else {
                    $searchTerm = '%' . $term . '%';
                }

                $whereClause = "WHERE ville LIKE ?";
                $params = [$searchTerm];

                if (!empty($region)) {
                    $whereClause .= " AND region = ?";
                    $params[] = $region;
                }

                $stmt = $pdo->prepare("
                    SELECT DISTINCT ville
                    FROM maires
                    $whereClause
                    ORDER BY ville ASC
                    LIMIT " . $limit . "
                ");
                $stmt->execute($params);
                $results = $stmt->fetchAll(PDO::FETCH_COLUMN);
                break;
        }
    }

    echo json_encode(['results' => $results]);
    exit;
}

/**
 * Récupérer les départements d'une région
 */
function getDepartements($pdo) {
    $region = $_GET['region'] ?? '';
    $domtomRegions = isset($_GET['domtom']) ? json_decode($_GET['domtom'], true) : [];

    if (!empty($domtomRegions)) {
        // Cas DOM-TOM : récupérer tous les départements de ces régions
        $placeholders = str_repeat('?,', count($domtomRegions) - 1) . '?';
        $stmt = $pdo->prepare("
            SELECT
                numero_departement,
                nom_departement,
                region,
                COUNT(*) as nb_maires
            FROM maires
            WHERE region IN ($placeholders)
            GROUP BY numero_departement, nom_departement, region
            ORDER BY numero_departement ASC
        ");
        $stmt->execute($domtomRegions);
        $departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'departements' => $departements]);
    } elseif (!empty($region)) {
        // Cas normal : une seule région
        $stmt = $pdo->prepare("
            SELECT
                numero_departement,
                nom_departement,
                COUNT(*) as nb_maires
            FROM maires
            WHERE region = ?
            GROUP BY numero_departement, nom_departement
            ORDER BY numero_departement ASC
        ");
        $stmt->execute([$region]);
        $departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'departements' => $departements]);
    } else {
        echo json_encode(['success' => false, 'departements' => []]);
    }
    exit;
}

/**
 * Récupérer les cantons d'une région
 */
function getCantons($pdo) {
    $region = $_GET['region'] ?? '';
    $departement = $_GET['departement'] ?? '';
    $maxHabitants = isset($_GET['maxHabitants']) ? (int)$_GET['maxHabitants'] : null;

    // Accepter soit une région, soit un département
    if (empty($region) && empty($departement)) {
        echo json_encode(['success' => false, 'cantons' => []]);
        exit;
    }

    try {
        if (!empty($departement)) {
            // Filtrer par département
            if ($maxHabitants !== null) {
                // Filtrer les cantons ayant au moins une commune < maxHabitants
                $stmt = $pdo->prepare("
                    SELECT DISTINCT canton
                    FROM maires
                    WHERE numero_departement = ?
                      AND canton IS NOT NULL AND canton != ''
                      AND nombre_habitants < ?
                    ORDER BY canton ASC
                ");
                $stmt->execute([$departement, $maxHabitants]);
            } else {
                $stmt = $pdo->prepare("
                    SELECT DISTINCT canton
                    FROM maires
                    WHERE numero_departement = ? AND canton IS NOT NULL AND canton != ''
                    ORDER BY canton ASC
                ");
                $stmt->execute([$departement]);
            }
        } else {
            // Filtrer par région
            if ($maxHabitants !== null) {
                $stmt = $pdo->prepare("
                    SELECT DISTINCT canton
                    FROM maires
                    WHERE region = ?
                      AND canton IS NOT NULL AND canton != ''
                      AND nombre_habitants < ?
                    ORDER BY canton ASC
                ");
                $stmt->execute([$region, $maxHabitants]);
            } else {
                $stmt = $pdo->prepare("
                    SELECT DISTINCT canton
                    FROM maires
                    WHERE region = ? AND canton IS NOT NULL AND canton != ''
                    ORDER BY canton ASC
                ");
                $stmt->execute([$region]);
            }
        }

        $cantons = $stmt->fetchAll(PDO::FETCH_COLUMN);

        echo json_encode(['success' => true, 'cantons' => $cantons]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les communes d'une région ou d'un département
 */
function getCommunes($pdo) {
    $region = $_GET['region'] ?? '';
    $departement = $_GET['departement'] ?? '';

    // Accepter soit une région, soit un département
    if (empty($region) && empty($departement)) {
        echo json_encode(['success' => false, 'communes' => []]);
        exit;
    }

    try {
        if (!empty($departement)) {
            // Filtrer par département
            $stmt = $pdo->prepare("
                SELECT DISTINCT ville
                FROM maires
                WHERE numero_departement = ?
                ORDER BY ville ASC
            ");
            $stmt->execute([$departement]);
        } else {
            // Filtrer par région
            $stmt = $pdo->prepare("
                SELECT DISTINCT ville
                FROM maires
                WHERE region = ?
                ORDER BY ville ASC
            ");
            $stmt->execute([$region]);
        }

        $communes = $stmt->fetchAll(PDO::FETCH_COLUMN);

        echo json_encode(['success' => true, 'communes' => $communes]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

// ===================================================================
// FONCTIONS ARBORESCENCE (Nested Sets)
// ===================================================================

/**
 * Récupérer l'arborescence complète ou partielle
 * Paramètres:
 *   - niveau_max: niveau maximum à retourner (optionnel, défaut: tous)
 *   - parent_id: ID du noeud parent pour récupérer une sous-branche (optionnel)
 *   - type: type d'élément à filtrer (optionnel: region, departement, circonscription, canton)
 */
function getArborescence($pdo) {
    $niveauMax = isset($_GET['niveau_max']) ? (int)$_GET['niveau_max'] : null;
    $parentId = isset($_GET['parent_id']) ? (int)$_GET['parent_id'] : null;
    $type = $_GET['type'] ?? null;

    try {
        $whereClause = "WHERE niveau > 0"; // Exclure la racine
        $params = [];

        // Filtrer par niveau max
        if ($niveauMax !== null) {
            $whereClause .= " AND niveau <= ?";
            $params[] = $niveauMax;
        }

        // Filtrer par type
        if ($type !== null) {
            $whereClause .= " AND type_element = ?";
            $params[] = $type;
        }

        // Filtrer par sous-branche (descendants d'un parent)
        if ($parentId !== null) {
            $whereClause .= " AND borne_gauche > (SELECT borne_gauche FROM arborescence WHERE id = ?)
                             AND borne_droite < (SELECT borne_droite FROM arborescence WHERE id = ?)";
            $params[] = $parentId;
            $params[] = $parentId;
        }

        $stmt = $pdo->prepare("
            SELECT
                id,
                borne_gauche,
                borne_droite,
                niveau,
                libelle,
                type_element,
                reference_id,
                parent_id,
                cle_unique,
                (borne_droite - borne_gauche - 1) / 2 as nb_enfants
            FROM arborescence
            $whereClause
            ORDER BY borne_gauche
        ");
        $stmt->execute($params);
        $nodes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'nodes' => $nodes,
            'count' => count($nodes)
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les enfants directs d'un noeud
 * Paramètres:
 *   - parent_id: ID du noeud parent (obligatoire, 0 pour la racine)
 *   - cle_unique: alternative à parent_id, clé unique du parent
 */
function getArborescenceChildren($pdo) {
    $parentId = isset($_GET['parent_id']) ? (int)$_GET['parent_id'] : null;
    $cleUnique = $_GET['cle_unique'] ?? null;

    try {
        // Si clé unique fournie, récupérer l'ID
        if ($cleUnique !== null && $parentId === null) {
            $stmt = $pdo->prepare("SELECT id FROM arborescence WHERE cle_unique = ?");
            $stmt->execute([$cleUnique]);
            $parentId = $stmt->fetchColumn();

            if ($parentId === false) {
                echo json_encode(['success' => false, 'error' => 'Clé unique non trouvée']);
                exit;
            }
        }

        // Liste des régions DOM-TOM à regrouper
        $domtomRegions = ['Guadeloupe', 'Guyane', 'La Réunion', 'Martinique', 'Mayotte'];

        // Si parent_id = 0, récupérer les enfants de la racine (régions)
        if ($parentId === 0 || $parentId === null) {
            // Récupérer les régions métropolitaines (exclure DOM-TOM)
            $stmt = $pdo->prepare("
                SELECT
                    a.id,
                    a.niveau,
                    a.libelle,
                    a.type_element,
                    a.reference_id,
                    a.cle_unique,
                    (SELECT COUNT(*) FROM arborescence c WHERE c.parent_id = a.id AND c.type_element != 'circonscription') as nb_enfants
                FROM arborescence a
                WHERE a.parent_id = (SELECT id FROM arborescence WHERE type_element = 'racine' LIMIT 1)
                AND a.libelle NOT IN ('Guadeloupe', 'Guyane', 'La Réunion', 'Martinique', 'Mayotte')
                ORDER BY a.libelle
            ");
            $stmt->execute();
            $children = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Compter le total des départements DOM-TOM
            $stmtDomtom = $pdo->prepare("
                SELECT COUNT(*) as nb_enfants
                FROM arborescence a
                WHERE a.parent_id IN (
                    SELECT id FROM arborescence WHERE type_element = 'region' AND libelle IN ('Guadeloupe', 'Guyane', 'La Réunion', 'Martinique', 'Mayotte')
                )
                AND a.type_element = 'departement'
            ");
            $stmtDomtom->execute();
            $nbDomtom = $stmtDomtom->fetchColumn();

            // Ajouter la rubrique DOM-TOM à la fin
            $children[] = [
                'id' => -1, // ID virtuel pour DOM-TOM
                'niveau' => 1,
                'libelle' => '🌴 DOM-TOM',
                'type_element' => 'domtom',
                'reference_id' => 'domtom',
                'cle_unique' => 'domtom',
                'nb_enfants' => $nbDomtom
            ];

            echo json_encode([
                'success' => true,
                'children' => $children,
                'count' => count($children)
            ]);
            exit;
        } elseif ($parentId === -1) {
            // Charger les départements DOM-TOM
            $stmt = $pdo->prepare("
                SELECT
                    a.id,
                    a.niveau,
                    a.libelle,
                    a.type_element,
                    a.reference_id,
                    a.cle_unique,
                    (SELECT COUNT(*) FROM arborescence c WHERE c.parent_id = a.id AND c.type_element != 'circonscription') as nb_enfants
                FROM arborescence a
                WHERE a.parent_id IN (
                    SELECT id FROM arborescence WHERE type_element = 'region' AND libelle IN ('Guadeloupe', 'Guyane', 'La Réunion', 'Martinique', 'Mayotte')
                )
                AND a.type_element = 'departement'
                ORDER BY a.libelle
            ");
            $stmt->execute();
        } else {
            // Vérifier si le parent est un département (pour sauter les circonscriptions)
            $stmtParent = $pdo->prepare("SELECT type_element FROM arborescence WHERE id = ?");
            $stmtParent->execute([$parentId]);
            $parentType = $stmtParent->fetchColumn();

            if ($parentType === 'departement') {
                // Pour un département, récupérer directement les cantons (en sautant les circonscriptions)
                $stmt = $pdo->prepare("
                    SELECT
                        a.id,
                        a.niveau,
                        a.libelle,
                        a.type_element,
                        a.reference_id,
                        a.cle_unique,
                        (SELECT COUNT(*) FROM arborescence c WHERE c.parent_id = a.id) as nb_enfants
                    FROM arborescence a
                    WHERE a.parent_id IN (SELECT id FROM arborescence WHERE parent_id = ? AND type_element = 'circonscription')
                    AND a.type_element = 'canton'
                    ORDER BY a.libelle
                ");
                $stmt->execute([$parentId]);
            } else {
                // Comportement normal, mais exclure les circonscriptions
                $stmt = $pdo->prepare("
                    SELECT
                        a.id,
                        a.niveau,
                        a.libelle,
                        a.type_element,
                        a.reference_id,
                        a.cle_unique,
                        (SELECT COUNT(*) FROM arborescence c WHERE c.parent_id = a.id AND c.type_element != 'circonscription') as nb_enfants
                    FROM arborescence a
                    WHERE a.parent_id = ?
                    AND a.type_element != 'circonscription'
                    ORDER BY a.borne_gauche
                ");
                $stmt->execute([$parentId]);
            }
        }

        $children = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Reformater le libellé des départements : "01 - Ain" -> "Ain (01)"
        foreach ($children as &$child) {
            if ($child['type_element'] === 'departement' && preg_match('/^(\d+[A-B]?)\s*-\s*(.+)$/', $child['libelle'], $matches)) {
                $child['libelle'] = $matches[2] . ' (' . $matches[1] . ')';
            }
        }
        unset($child);

        echo json_encode([
            'success' => true,
            'children' => $children,
            'count' => count($children)
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer un noeud par son ID ou sa clé unique avec ses ancêtres (fil d'Ariane)
 * Paramètres:
 *   - id: ID du noeud
 *   - cle_unique: clé unique du noeud (alternative à id)
 *   - with_ancestors: inclure le fil d'Ariane (1/0, défaut: 1)
 */
function getArborescenceNode($pdo) {
    $nodeId = isset($_GET['id']) ? (int)$_GET['id'] : null;
    $cleUnique = $_GET['cle_unique'] ?? null;
    $withAncestors = !isset($_GET['with_ancestors']) || $_GET['with_ancestors'] !== '0';

    try {
        // Récupérer le noeud
        if ($cleUnique !== null) {
            $stmt = $pdo->prepare("
                SELECT id, borne_gauche, borne_droite, niveau, libelle, type_element, reference_id, parent_id, cle_unique
                FROM arborescence
                WHERE cle_unique = ?
            ");
            $stmt->execute([$cleUnique]);
        } elseif ($nodeId !== null) {
            $stmt = $pdo->prepare("
                SELECT id, borne_gauche, borne_droite, niveau, libelle, type_element, reference_id, parent_id, cle_unique
                FROM arborescence
                WHERE id = ?
            ");
            $stmt->execute([$nodeId]);
        } else {
            echo json_encode(['success' => false, 'error' => 'ID ou clé unique requis']);
            exit;
        }

        $node = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$node) {
            http_response_code(404);
            echo json_encode(['success' => false, 'error' => 'Noeud non trouvé']);
            exit;
        }

        $result = ['success' => true, 'node' => $node];

        // Récupérer les ancêtres (fil d'Ariane) via Nested Sets
        if ($withAncestors) {
            $stmt = $pdo->prepare("
                SELECT id, niveau, libelle, type_element, cle_unique
                FROM arborescence
                WHERE borne_gauche < ? AND borne_droite > ?
                ORDER BY borne_gauche
            ");
            $stmt->execute([$node['borne_gauche'], $node['borne_droite']]);
            $result['ancestors'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
        }

        echo json_encode($result);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Rechercher dans l'arborescence
 * Paramètres:
 *   - q: terme de recherche (obligatoire, min 2 caractères)
 *   - type: filtrer par type d'élément (optionnel)
 *   - limit: nombre max de résultats (défaut: 50)
 */
function searchArborescence($pdo) {
    $query = $_GET['q'] ?? '';
    $type = $_GET['type'] ?? null;
    $limit = isset($_GET['limit']) ? min((int)$_GET['limit'], 100) : 50;

    if (strlen($query) < 2) {
        echo json_encode(['success' => false, 'error' => 'Recherche trop courte (min 2 caractères)']);
        exit;
    }

    try {
        $whereClause = "WHERE libelle LIKE ? AND niveau > 0";
        $params = ['%' . $query . '%'];

        if ($type !== null) {
            $whereClause .= " AND type_element = ?";
            $params[] = $type;
        }

        $stmt = $pdo->prepare("
            SELECT
                a.id,
                a.niveau,
                a.libelle,
                a.type_element,
                a.reference_id,
                a.cle_unique,
                (a.borne_droite - a.borne_gauche - 1) / 2 as nb_enfants
            FROM arborescence a
            $whereClause
            ORDER BY
                CASE WHEN a.libelle LIKE ? THEN 0 ELSE 1 END,
                a.niveau,
                a.libelle
            LIMIT $limit
        ");
        $params[] = $query . '%'; // Priorité aux résultats qui commencent par le terme
        $stmt->execute($params);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Ajouter le fil d'Ariane pour chaque résultat
        foreach ($results as &$result) {
            $stmt2 = $pdo->prepare("
                SELECT libelle, type_element
                FROM arborescence
                WHERE borne_gauche < (SELECT borne_gauche FROM arborescence WHERE id = ?)
                AND borne_droite > (SELECT borne_droite FROM arborescence WHERE id = ?)
                AND niveau > 0
                ORDER BY niveau
            ");
            $stmt2->execute([$result['id'], $result['id']]);
            $ancestors = $stmt2->fetchAll(PDO::FETCH_ASSOC);
            $result['breadcrumb'] = array_column($ancestors, 'libelle');
        }

        echo json_encode([
            'success' => true,
            'results' => $results,
            'count' => count($results),
            'query' => $query
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les statistiques de l'arborescence
 */
function getArborescenceStats($pdo) {
    try {
        $stmt = $pdo->query("
            SELECT type_element, COUNT(*) as nb
            FROM arborescence
            WHERE niveau > 0
            GROUP BY type_element
            ORDER BY FIELD(type_element, 'region', 'departement', 'circonscription', 'canton')
        ");
        $stats = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);

        // Total des noeuds
        $total = array_sum($stats);

        // Vérifier l'intégrité du Nested Set
        $checkStmt = $pdo->query("
            SELECT COUNT(*) as errors
            FROM arborescence a1
            WHERE NOT EXISTS (
                SELECT 1 FROM arborescence a2
                WHERE a2.borne_gauche < a1.borne_gauche
                AND a2.borne_droite > a1.borne_droite
                AND a2.niveau = a1.niveau - 1
            )
            AND a1.niveau > 0
        ");
        $integrity = $checkStmt->fetch(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'stats' => $stats,
            'total' => $total,
            'integrity' => $integrity['errors'] == 0 ? 'OK' : 'ERRORS: ' . $integrity['errors']
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

// ===================================================================
// FONCTIONS GESTION DES DROITS
// ===================================================================

/**
 * Sauvegarder un droit pour un département
 * Paramètres POST:
 *   - departement_id: ID du département (table departements)
 *   - role: admin, referent ou membre
 *   - value: valeur à enregistrer (nom/email)
 */
function saveGestionDroits($pdo) {
    $departementId = (int)($_POST['departement_id'] ?? 0);
    $typeUtilisateurId = (int)($_POST['typeUtilisateur_id'] ?? 0);
    $utilisateurIds = $_POST['utilisateur_ids'] ?? ''; // Liste d'IDs séparés par virgules

    // Compatibilité avec l'ancienne API (role -> typeUtilisateur_id)
    if ($typeUtilisateurId === 0 && isset($_POST['role'])) {
        $roleMap = ['admin' => 2, 'referent' => 3, 'membre' => 4];
        $role = $_POST['role'] ?? '';
        $typeUtilisateurId = $roleMap[$role] ?? 0;
        $utilisateurIds = $_POST['value'] ?? '';
    }

    // Valider les paramètres
    if ($departementId <= 0) {
        echo json_encode(['success' => false, 'error' => 'ID de département requis']);
        exit;
    }

    if (!in_array($typeUtilisateurId, [2, 3, 4])) {
        echo json_encode(['success' => false, 'error' => 'Type utilisateur invalide (2=Admin, 3=Référent, 4=Membre)']);
        exit;
    }

    try {
        // Vérifier si le département existe
        $stmtCheck = $pdo->prepare("SELECT id FROM departements WHERE id = ?");
        $stmtCheck->execute([$departementId]);
        if (!$stmtCheck->fetch()) {
            echo json_encode(['success' => false, 'error' => 'Département non trouvé']);
            exit;
        }

        // Parser les IDs utilisateurs
        $userIds = array_filter(array_map('trim', preg_split('/[,;]/', $utilisateurIds)));

        // Supprimer les anciennes entrées pour ce département/type
        $stmtDelete = $pdo->prepare("DELETE FROM gestionAccesDepartements WHERE departement_id = ? AND typeUtilisateur_id = ?");
        $stmtDelete->execute([$departementId, $typeUtilisateurId]);

        // Insérer les nouvelles entrées
        if (!empty($userIds)) {
            $stmtInsert = $pdo->prepare("
                INSERT INTO gestionAccesDepartements (departement_id, utilisateur_id, typeUtilisateur_id)
                VALUES (?, ?, ?)
            ");
            foreach ($userIds as $userId) {
                if (is_numeric($userId)) {
                    $stmtInsert->execute([$departementId, (int)$userId, $typeUtilisateurId]);
                }
            }
        }

        echo json_encode(['success' => true, 'message' => 'Droits mis à jour', 'count' => count($userIds)]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer tous les droits par département
 * Nouvelle structure : jointure avec utilisateurs pour récupérer IDs et noms
 * Paramètres GET:
 *   - departement_id: ID du département (optionnel)
 *   - numero_departement: numéro du département (optionnel, alternative)
 */
function getGestionDroits($pdo) {
    $departementId = isset($_GET['departement_id']) ? (int)$_GET['departement_id'] : null;
    $numeroDepartement = $_GET['numero_departement'] ?? null;

    try {
        // Requête de base : récupérer tous les droits avec infos utilisateurs
        $sql = "
            SELECT
                g.departement_id,
                g.utilisateur_id,
                g.typeUtilisateur_id,
                u.prenom,
                u.nom,
                d.numero_departement,
                d.nom_departement,
                d.region
            FROM gestionAccesDepartements g
            JOIN departements d ON g.departement_id = d.id
            JOIN utilisateurs u ON g.utilisateur_id = u.id
        ";
        $params = [];

        if ($departementId) {
            $sql .= " WHERE g.departement_id = ?";
            $params[] = $departementId;
        } elseif ($numeroDepartement) {
            $sql .= " WHERE d.numero_departement = ?";
            $params[] = $numeroDepartement;
        }

        $sql .= " ORDER BY d.numero_departement, g.typeUtilisateur_id, u.nom, u.prenom";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Regrouper par département
        $droitsParDept = [];
        foreach ($rows as $row) {
            $deptNum = $row['numero_departement'];

            if (!isset($droitsParDept[$deptNum])) {
                $droitsParDept[$deptNum] = [
                    'departement_id' => $row['departement_id'],
                    'numero_departement' => $deptNum,
                    'nom_departement' => $row['nom_departement'],
                    'region' => $row['region'],
                    'admin_ids' => '',
                    'admin' => '',
                    'referent_ids' => '',
                    'referent' => '',
                    'membre_ids' => '',
                    'membre' => ''
                ];
            }

            $userId = $row['utilisateur_id'];
            $userName = $row['prenom'] . ' ' . $row['nom'];
            $typeId = $row['typeUtilisateur_id'];

            // Déterminer le champ selon le type
            $roleKey = '';
            switch ($typeId) {
                case 2: $roleKey = 'admin'; break;
                case 3: $roleKey = 'referent'; break;
                case 4: $roleKey = 'membre'; break;
            }

            if ($roleKey) {
                // Ajouter l'ID
                if (!empty($droitsParDept[$deptNum][$roleKey . '_ids'])) {
                    $droitsParDept[$deptNum][$roleKey . '_ids'] .= ', ';
                }
                $droitsParDept[$deptNum][$roleKey . '_ids'] .= $userId;

                // Ajouter le nom
                if (!empty($droitsParDept[$deptNum][$roleKey])) {
                    $droitsParDept[$deptNum][$roleKey] .= ', ';
                }
                $droitsParDept[$deptNum][$roleKey] .= $userName;
            }
        }

        // Retourner comme liste
        $droits = array_values($droitsParDept);

        echo json_encode(['success' => true, 'droits' => $droits]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer l'ID d'un département par son numéro
 * Paramètres GET:
 *   - numero_departement: numéro du département
 */
function getDepartementId($pdo) {
    $numeroDepartement = $_GET['numero_departement'] ?? '';

    if (empty($numeroDepartement)) {
        echo json_encode(['success' => false, 'error' => 'Numéro de département requis']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("SELECT id FROM departements WHERE numero_departement = ?");
        $stmt->execute([$numeroDepartement]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            echo json_encode(['success' => true, 'departement_id' => $result['id']]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Département non trouvé']);
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Rechercher des utilisateurs par type et terme de recherche
 * Paramètres GET:
 *   - type: 2 (Admin), 3 (Référent), 4 (Membre), 5 (Tous types actifs - pour responsables cantons)
 *   - q: terme de recherche (nom, prénom, pseudo ou email)
 */
/**
 * Récupérer tous les utilisateurs avec leurs statistiques
 * Filtré selon le rôle de l'utilisateur connecté :
 * - Super Admin (1) : voit tous les utilisateurs
 * - Admin (2) : voit uniquement les référents (3) et membres (4)
 * - Référent (3) : voit uniquement les membres (4) de ses départements
 * - Membre (4) : accès refusé
 */
function getAllUtilisateurs($pdo) {
    // Démarrer la session si nécessaire pour récupérer l'utilisateur connecté
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    // Récupérer le type d'utilisateur connecté
    $currentUserType = $_SESSION['user_type'] ?? 0;
    $currentUserId = $_SESSION['user_id'] ?? 0;

    // Les membres (4) n'ont pas accès à cette interface
    if ($currentUserType == 4) {
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    try {
        // Construire la requête selon le rôle
        $whereClause = "";
        $params = [];

        if ($currentUserType == 1 || $currentUserType == 5) {
            // Super Admin ou Président : voit tous les utilisateurs
            $whereClause = "";
        } elseif ($currentUserType == 2) {
            // Admin : voit uniquement les référents (3) et membres (4)
            $whereClause = "WHERE u.typeUtilisateur_id IN (3, 4)";
        } elseif ($currentUserType == 3) {
            // Référent : voit uniquement les membres (4) de ses départements
            // D'abord récupérer les départements du référent
            $stmtDepts = $pdo->prepare("
                SELECT DISTINCT departement_id
                FROM gestionAccesDepartements
                WHERE utilisateur_id = ?
            ");
            $stmtDepts->execute([$currentUserId]);
            $referentDepts = $stmtDepts->fetchAll(PDO::FETCH_COLUMN);

            if (empty($referentDepts)) {
                // Aucun département assigné, retourner liste vide
                echo json_encode(['success' => true, 'utilisateurs' => []], JSON_UNESCAPED_UNICODE);
                exit;
            }

            // Récupérer les membres qui ont des droits sur les mêmes départements
            $placeholders = str_repeat('?,', count($referentDepts) - 1) . '?';
            $whereClause = "WHERE u.typeUtilisateur_id = 4
                           AND u.id IN (
                               SELECT DISTINCT utilisateur_id
                               FROM gestionAccesDepartements
                               WHERE departement_id IN ($placeholders)
                           )";
            $params = $referentDepts;
        }

        $sql = "
            SELECT
                u.id,
                u.nom,
                u.prenom,
                u.pseudo,
                u.adresseMail as email,
                u.telephone,
                u.typeUtilisateur_id,
                u.departement_id,
                u.actif,
                u.commentaires,
                u.image,
                u.date_creation,
                u.date_modification
            FROM utilisateurs u
            $whereClause
            ORDER BY u.nom ASC, u.prenom ASC
        ";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $utilisateurs = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Pour chaque utilisateur, récupérer les départements et cantons
        foreach ($utilisateurs as &$user) {
            // Récupérer les départements (Menu)
            $stmtDepts = $pdo->prepare("
                SELECT DISTINCT CONCAT(d.nom_departement, ' (', d.numero_departement, ')') as dept_display
                FROM gestionAccesDepartements gd
                JOIN departements d ON gd.departement_id = d.id
                WHERE gd.utilisateur_id = ?
                ORDER BY dept_display
            ");
            $stmtDepts->execute([$user['id']]);
            $depts = $stmtDepts->fetchAll(PDO::FETCH_COLUMN);
            $user['departements'] = implode('<br>', $depts);
            $user['nb_departements'] = count($depts);

            // Récupérer les cantons
            $stmtCantons = $pdo->prepare("
                SELECT DISTINCT canton
                FROM gestionAccesCantons
                WHERE utilisateur_id = ?
                ORDER BY canton
            ");
            $stmtCantons->execute([$user['id']]);
            $cantons = $stmtCantons->fetchAll(PDO::FETCH_COLUMN);
            $user['cantons'] = implode('<br>', $cantons);
            $user['nb_cantons'] = count($cantons);
        }

        echo json_encode(['success' => true, 'utilisateurs' => $utilisateurs], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}

function searchUtilisateurs($pdo) {
    $type = isset($_GET['type']) ? (int)$_GET['type'] : null;
    $query = $_GET['q'] ?? '';

    if (!$type || !in_array($type, [2, 3, 4, 5])) {
        echo json_encode(['success' => false, 'error' => 'Type utilisateur invalide (2=Admin, 3=Référent, 4=Membre, 5=Tous)']);
        exit;
    }

    try {
        // Type 5 = rechercher dans Référents et Membres actifs (pour responsables cantons)
        if ($type === 5) {
            $sql = "
                SELECT id, nom, prenom, pseudo, adresseMail
                FROM utilisateurs
                WHERE typeUtilisateur_id IN (3, 4) AND actif = 1
            ";
            $params = [];
        } else {
            $sql = "
                SELECT id, nom, prenom, pseudo, adresseMail
                FROM utilisateurs
                WHERE typeUtilisateur_id = ? AND actif = 1
            ";
            $params = [$type];
        }

        if (!empty($query)) {
            $sql .= " AND (
                nom LIKE ? OR
                prenom LIKE ? OR
                pseudo LIKE ? OR
                adresseMail LIKE ? OR
                CONCAT(prenom, ' ', nom) LIKE ?
            )";
            $searchTerm = '%' . $query . '%';
            $params = array_merge($params, [$searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm]);
        }

        $sql .= " ORDER BY nom ASC, prenom ASC LIMIT 50";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $utilisateurs = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Formater pour l'autocomplete
        $results = array_map(function($u) {
            return [
                'id' => $u['id'],
                'label' => $u['prenom'] . ' ' . $u['nom'] . ' (' . $u['pseudo'] . ')',
                'value' => $u['prenom'] . ' ' . $u['nom'],
                'email' => $u['adresseMail'],
                'pseudo' => $u['pseudo']
            ];
        }, $utilisateurs);

        echo json_encode(['success' => true, 'utilisateurs' => $results], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
    exit;
}

// ===================================================================
// FONCTIONS GESTION DES DROITS PAR CANTONS
// ===================================================================

/**
 * Récupérer la liste des régions avec le nombre de départements
 */
function getRegions($pdo) {
    try {
        // Via arborescence
        $stmt = $pdo->query("
            SELECT
                a.libelle as region,
                COUNT(d.id) as nb_departements
            FROM arborescence a
            LEFT JOIN arborescence d ON d.parent_id = a.id AND d.type_element = 'departement'
            WHERE a.type_element = 'region'
            GROUP BY a.id, a.libelle
            ORDER BY a.libelle ASC
        ");
        $regions = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'regions' => $regions]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les départements d'une région avec le nombre de circonscriptions
 * Paramètres GET:
 *   - region: nom de la région
 */
function getDepartementsByRegion($pdo) {
    $region = $_GET['region'] ?? '';

    if (empty($region)) {
        echo json_encode(['success' => false, 'error' => 'Région requise']);
        exit;
    }

    try {
        // Via arborescence
        $stmt = $pdo->prepare("
            SELECT
                d.reference_id as numero_departement,
                SUBSTRING(d.libelle, LOCATE(' - ', d.libelle) + 3) as nom_departement,
                COUNT(c.id) as nb_circos
            FROM arborescence r
            JOIN arborescence d ON d.parent_id = r.id AND d.type_element = 'departement'
            LEFT JOIN arborescence c ON c.parent_id = d.id AND c.type_element = 'circonscription'
            WHERE r.type_element = 'region' AND r.libelle = ?
            GROUP BY d.id, d.reference_id, d.libelle
            ORDER BY d.reference_id ASC
        ");
        $stmt->execute([$region]);
        $departements = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'departements' => $departements]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les circonscriptions d'un département avec le nombre de cantons
 * Paramètres GET:
 *   - numero_departement: numéro du département
 */
function getCircosByDepartement($pdo) {
    $numeroDepartement = $_GET['numero_departement'] ?? '';

    if (empty($numeroDepartement)) {
        echo json_encode(['success' => false, 'error' => 'Numéro de département requis']);
        exit;
    }

    try {
        // Via arborescence
        $stmt = $pdo->prepare("
            SELECT
                c.libelle as circonscription,
                COUNT(ca.id) as nb_cantons
            FROM arborescence d
            JOIN arborescence c ON c.parent_id = d.id AND c.type_element = 'circonscription'
            LEFT JOIN arborescence ca ON ca.parent_id = c.id AND ca.type_element = 'canton'
            WHERE d.type_element = 'departement' AND d.reference_id = ?
            GROUP BY c.id, c.libelle
            ORDER BY CAST(c.libelle AS UNSIGNED) ASC, c.libelle ASC
        ");
        $stmt->execute([$numeroDepartement]);
        $circos = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'circos' => $circos]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les cantons d'une circonscription avec le nombre de communes
 * Paramètres GET:
 *   - numero_departement: numéro du département
 *   - circo: numéro de circonscription
 */
function getCantonsByCirco($pdo) {
    $numeroDepartement = $_GET['numero_departement'] ?? '';
    $circo = $_GET['circo'] ?? '';

    if (empty($numeroDepartement) || empty($circo)) {
        echo json_encode(['success' => false, 'error' => 'Numéro de département et circonscription requis']);
        exit;
    }

    try {
        // Via arborescence (nb_communes reste via maires car données spécifiques)
        $stmt = $pdo->prepare("
            SELECT
                ca.libelle as canton,
                COUNT(DISTINCT m.ville) as nb_communes
            FROM arborescence d
            JOIN arborescence c ON c.parent_id = d.id AND c.type_element = 'circonscription'
            JOIN arborescence ca ON ca.parent_id = c.id AND ca.type_element = 'canton'
            LEFT JOIN maires m ON m.numero_departement = d.reference_id AND m.canton = ca.libelle
            WHERE d.type_element = 'departement' AND d.reference_id = ? AND c.libelle = ?
            GROUP BY ca.id, ca.libelle
            ORDER BY ca.libelle ASC
        ");
        $stmt->execute([$numeroDepartement, $circo]);
        $cantons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'cantons' => $cantons]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer tous les droits par canton
 * Paramètres GET (optionnels):
 *   - numero_departement: filtrer par département
 *   - canton: filtrer par canton
 */
function getGestionDroitsCantons($pdo) {
    $numeroDepartement = $_GET['numero_departement'] ?? null;
    $canton = $_GET['canton'] ?? null;

    try {
        // Vérifier si la table existe
        $tableExists = $pdo->query("SHOW TABLES LIKE 'gestionAccesCantons'")->rowCount() > 0;

        if (!$tableExists) {
            // La table n'existe pas encore, retourner une liste vide
            echo json_encode(['success' => true, 'droits' => []]);
            exit;
        }

        $sql = "
            SELECT
                g.id,
                g.numero_departement,
                g.canton,
                g.utilisateur_id,
                u.prenom,
                u.nom
            FROM gestionAccesCantons g
            LEFT JOIN utilisateurs u ON g.utilisateur_id = u.id
            WHERE 1=1
        ";
        $params = [];

        if ($numeroDepartement) {
            $sql .= " AND g.numero_departement = ?";
            $params[] = $numeroDepartement;
        }

        if ($canton) {
            $sql .= " AND g.canton = ?";
            $params[] = $canton;
        }

        $sql .= " ORDER BY g.numero_departement, g.canton, u.nom, u.prenom";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Regrouper par canton
        $droitsParCanton = [];
        foreach ($rows as $row) {
            $key = $row['numero_departement'] . '_' . $row['canton'];

            if (!isset($droitsParCanton[$key])) {
                $droitsParCanton[$key] = [
                    'numero_departement' => $row['numero_departement'],
                    'canton' => $row['canton'],
                    'responsable_ids' => '',
                    'responsable' => ''
                ];
            }

            if ($row['utilisateur_id']) {
                $userId = $row['utilisateur_id'];
                $userName = $row['prenom'] . ' ' . $row['nom'];

                if (!empty($droitsParCanton[$key]['responsable_ids'])) {
                    $droitsParCanton[$key]['responsable_ids'] .= ', ';
                    $droitsParCanton[$key]['responsable'] .= ', ';
                }
                $droitsParCanton[$key]['responsable_ids'] .= $userId;
                $droitsParCanton[$key]['responsable'] .= $userName;
            }
        }

        $droits = array_values($droitsParCanton);

        echo json_encode(['success' => true, 'droits' => $droits]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Sauvegarder un responsable pour un canton
 * Paramètres POST:
 *   - numero_departement: numéro du département
 *   - canton: nom du canton
 *   - utilisateur_ids: IDs des utilisateurs responsables (séparés par virgules)
 */
function saveGestionDroitsCanton($pdo) {
    $numeroDepartement = $_POST['numero_departement'] ?? '';
    $canton = $_POST['canton'] ?? '';
    $utilisateurIds = $_POST['utilisateur_ids'] ?? '';

    if (empty($numeroDepartement) || empty($canton)) {
        echo json_encode(['success' => false, 'error' => 'Numéro de département et canton requis']);
        exit;
    }

    try {
        // Créer la table si elle n'existe pas
        $pdo->exec("
            CREATE TABLE IF NOT EXISTS gestionAccesCantons (
                id INT AUTO_INCREMENT PRIMARY KEY,
                numero_departement VARCHAR(10) NOT NULL,
                canton VARCHAR(255) NOT NULL,
                utilisateur_id INT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                INDEX idx_dept_canton (numero_departement, canton),
                INDEX idx_utilisateur (utilisateur_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ");

        // Parser les IDs utilisateurs
        $userIds = array_filter(array_map('trim', preg_split('/[,;]/', $utilisateurIds)));

        // Supprimer les anciennes entrées pour ce canton
        $stmtDelete = $pdo->prepare("DELETE FROM gestionAccesCantons WHERE numero_departement = ? AND canton = ?");
        $stmtDelete->execute([$numeroDepartement, $canton]);

        // Insérer les nouvelles entrées
        if (!empty($userIds)) {
            $stmtInsert = $pdo->prepare("
                INSERT INTO gestionAccesCantons (numero_departement, canton, utilisateur_id)
                VALUES (?, ?, ?)
            ");
            foreach ($userIds as $userId) {
                if (is_numeric($userId)) {
                    $stmtInsert->execute([$numeroDepartement, $canton, (int)$userId]);
                }
            }
        }

        echo json_encode(['success' => true, 'message' => 'Responsable(s) mis à jour', 'count' => count($userIds)]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

// ===================================================================
// FONCTIONS GESTION DES UTILISATEURS
// ===================================================================

/**
 * Récupérer les régions avec leurs départements (pour l'arborescence des droits utilisateurs)
 */
function getRegionsDepartements($pdo) {
    try {
        // Récupérer toutes les régions avec leurs départements
        $stmt = $pdo->query("
            SELECT DISTINCT
                m.region,
                m.numero_departement,
                m.nom_departement,
                d.id as departement_id
            FROM maires m
            LEFT JOIN departements d ON d.numero_departement = m.numero_departement
            WHERE m.region IS NOT NULL AND m.region != ''
            ORDER BY m.region ASC, m.numero_departement ASC
        ");
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Grouper par région
        $regionsByName = [];
        foreach ($rows as $row) {
            $regionName = $row['region'];

            if (!isset($regionsByName[$regionName])) {
                $regionsByName[$regionName] = [
                    'nom_region' => $regionName,
                    'departements' => []
                ];
            }

            // Éviter les doublons de départements
            $deptKey = $row['numero_departement'];
            if (!isset($regionsByName[$regionName]['departements'][$deptKey])) {
                $regionsByName[$regionName]['departements'][$deptKey] = [
                    'id' => $row['departement_id'],
                    'numero_departement' => $row['numero_departement'],
                    'nom_departement' => $row['nom_departement']
                ];
            }
        }

        // Convertir en tableau indexé
        $regions = [];
        foreach ($regionsByName as $region) {
            $region['departements'] = array_values($region['departements']);
            $regions[] = $region;
        }

        echo json_encode(['success' => true, 'regions' => $regions], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
    exit;
}

/**
 * Récupérer les droits d'un utilisateur (départements auxquels il a accès)
 * Paramètres GET:
 *   - userId: ID de l'utilisateur
 */
function getUserDroits($pdo) {
    $userId = isset($_GET['userId']) ? (int)$_GET['userId'] : 0;

    if ($userId <= 0) {
        echo json_encode(['success' => false, 'error' => 'ID utilisateur requis']);
        exit;
    }

    try {
        // Récupérer les IDs de départements (table departements) auxquels l'utilisateur a accès
        $stmt = $pdo->prepare("
            SELECT DISTINCT departement_id
            FROM gestionAccesDepartements
            WHERE utilisateur_id = ?
        ");
        $stmt->execute([$userId]);
        $departements = $stmt->fetchAll(PDO::FETCH_COLUMN);

        echo json_encode(['success' => true, 'departements' => $departements], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
    exit;
}

/**
 * Récupérer tous les cantons groupés par département
 */
function getAllCantons($pdo) {
    try {
        $stmt = $pdo->query("
            SELECT DISTINCT
                m.numero_departement,
                m.nom_departement,
                m.canton
            FROM maires m
            WHERE m.canton IS NOT NULL AND m.canton != ''
            ORDER BY m.numero_departement ASC, m.canton ASC
        ");
        $cantons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'cantons' => $cantons], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
    exit;
}

/**
 * Récupérer les cantons auxquels un utilisateur a accès
 * Paramètres GET:
 *   - userId: ID de l'utilisateur
 */
function getUserCantons($pdo) {
    $userId = isset($_GET['userId']) ? (int)$_GET['userId'] : 0;

    if ($userId <= 0) {
        echo json_encode(['success' => false, 'error' => 'ID utilisateur requis']);
        exit;
    }

    try {
        // Vérifier si la table existe
        $tableExists = $pdo->query("SHOW TABLES LIKE 'gestionAccesCantons'")->rowCount() > 0;

        if (!$tableExists) {
            echo json_encode(['success' => true, 'cantons' => []]);
            exit;
        }

        // Récupérer les cantons de l'utilisateur
        $stmt = $pdo->prepare("
            SELECT DISTINCT
                numero_departement,
                canton
            FROM gestionAccesCantons
            WHERE utilisateur_id = ?
            ORDER BY numero_departement ASC, canton ASC
        ");
        $stmt->execute([$userId]);
        $cantons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'cantons' => $cantons], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
    exit;
}

/**
 * Sauvegarder ou créer un utilisateur
 */
function saveUtilisateur($pdo) {
    header('Content-Type: application/json');

    try {
        $data = json_decode(file_get_contents('php://input'), true);

        $id = $data['id'] ?? null;
        $nom = trim($data['nom'] ?? '');
        $prenom = trim($data['prenom'] ?? '');
        $email = trim($data['email'] ?? '');
        $telephone = trim($data['telephone'] ?? '');
        $pseudo = trim($data['pseudo'] ?? '');
        $typeUtilisateur_id = intval($data['typeUtilisateur_id'] ?? 0);
        $departement_id = isset($data['departement_id']) && $data['departement_id'] !== '' ? intval($data['departement_id']) : null;
        $actif = intval($data['actif'] ?? 1);
        $commentaires = trim($data['commentaires'] ?? '');
        $password = $data['password'] ?? null;

        // Validation
        if (empty($nom) || empty($prenom) || empty($email) || empty($pseudo) || $typeUtilisateur_id === 0) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Champs obligatoires manquants']);
            exit;
        }

        // Validation du département obligatoire pour les Référents (type 3)
        if ($typeUtilisateur_id === 3 && empty($departement_id)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Le département est obligatoire pour un Référent']);
            exit;
        }

        // Vérifier l'unicité du pseudo
        $stmtCheckPseudo = $pdo->prepare("SELECT id FROM utilisateurs WHERE pseudo = ? AND id != ?");
        $stmtCheckPseudo->execute([$pseudo, $id ?? 0]);
        if ($stmtCheckPseudo->fetch()) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Ce pseudo est déjà utilisé par un autre utilisateur']);
            exit;
        }

        // Vérifier l'unicité de l'email
        $stmtCheckEmail = $pdo->prepare("SELECT id FROM utilisateurs WHERE adresseMail = ? AND id != ?");
        $stmtCheckEmail->execute([$email, $id ?? 0]);
        if ($stmtCheckEmail->fetch()) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Cette adresse email est déjà utilisée par un autre utilisateur']);
            exit;
        }

        if ($id) {
            // Mise à jour
            if (!empty($password)) {
                // Mise à jour avec mot de passe
                $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
                $stmt = $pdo->prepare("
                    UPDATE utilisateurs
                    SET nom = ?, prenom = ?, adresseMail = ?, telephone = ?, pseudo = ?,
                        typeUtilisateur_id = ?, departement_id = ?, actif = ?, commentaires = ?, mdp = ?
                    WHERE id = ?
                ");
                $stmt->execute([$nom, $prenom, $email, $telephone, $pseudo, $typeUtilisateur_id, $departement_id, $actif, $commentaires, $hashedPassword, $id]);
            } else {
                // Mise à jour sans mot de passe
                $stmt = $pdo->prepare("
                    UPDATE utilisateurs
                    SET nom = ?, prenom = ?, adresseMail = ?, telephone = ?, pseudo = ?,
                        typeUtilisateur_id = ?, departement_id = ?, actif = ?, commentaires = ?
                    WHERE id = ?
                ");
                $stmt->execute([$nom, $prenom, $email, $telephone, $pseudo, $typeUtilisateur_id, $departement_id, $actif, $commentaires, $id]);
            }

            // Logger la mise à jour
            if (isset($GLOBALS['logger'])) {
                $GLOBALS['logger']->logUserAction('update', $id, "$prenom $nom", [
                    'email' => $email,
                    'type' => $typeUtilisateur_id,
                    'actif' => $actif,
                    'password_changed' => !empty($password)
                ]);
            }

            echo json_encode(['success' => true, 'userId' => $id]);
        } else {
            // Création
            if (empty($password)) {
                http_response_code(400);
                echo json_encode(['success' => false, 'error' => 'Le mot de passe est obligatoire pour un nouvel utilisateur']);
                exit;
            }

            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $pdo->prepare("
                INSERT INTO utilisateurs (nom, prenom, adresseMail, telephone, pseudo, typeUtilisateur_id, departement_id, actif, commentaires, mdp)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $stmt->execute([$nom, $prenom, $email, $telephone, $pseudo, $typeUtilisateur_id, $departement_id, $actif, $commentaires, $hashedPassword]);

            $newId = $pdo->lastInsertId();

            // Logger la création
            if (isset($GLOBALS['logger'])) {
                $GLOBALS['logger']->logUserAction('create', $newId, "$prenom $nom", [
                    'email' => $email,
                    'type' => $typeUtilisateur_id,
                    'actif' => $actif
                ]);
            }

            echo json_encode(['success' => true, 'userId' => $newId]);
        }

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Changer le mot de passe de l'utilisateur connecté
 */
function changePassword($pdo) {
    header('Content-Type: application/json');

    // Démarrer la session si ce n'est pas déjà fait
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    try {
        // Vérifier que l'utilisateur est connecté
        if (!isset($_SESSION['user']['id'])) {
            http_response_code(401);
            echo json_encode(['success' => false, 'error' => 'Non authentifié']);
            exit;
        }

        $userId = intval($_SESSION['user']['id']);
        $data = json_decode(file_get_contents('php://input'), true);

        $currentPassword = $data['currentPassword'] ?? '';
        $newPassword = $data['newPassword'] ?? '';

        // Validation
        if (empty($currentPassword)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Mot de passe actuel manquant']);
            exit;
        }

        if (empty($newPassword)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Nouveau mot de passe manquant']);
            exit;
        }

        if (strlen($newPassword) < 6) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Le nouveau mot de passe doit contenir au moins 6 caractères']);
            exit;
        }

        // Récupérer le mot de passe actuel de l'utilisateur
        $stmt = $pdo->prepare("SELECT mdp FROM utilisateurs WHERE id = ?");
        $stmt->execute([$userId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            http_response_code(404);
            echo json_encode(['success' => false, 'error' => 'Utilisateur introuvable']);
            exit;
        }

        // Vérifier que le mot de passe actuel est correct
        if (!password_verify($currentPassword, $user['mdp'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Mot de passe actuel incorrect']);
            exit;
        }

        // Vérifier que le nouveau mot de passe est différent de l'ancien
        if (password_verify($newPassword, $user['mdp'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Le nouveau mot de passe doit être différent de l\'ancien']);
            exit;
        }

        // Hasher le nouveau mot de passe
        $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

        // Mettre à jour le mot de passe
        $stmt = $pdo->prepare("UPDATE utilisateurs SET mdp = ? WHERE id = ?");
        $stmt->execute([$hashedPassword, $userId]);

        // Logger le changement de mot de passe
        if (isset($GLOBALS['logger'])) {
            $GLOBALS['logger']->logUserAction('password_change', $userId, null, [
                'self_change' => true
            ]);
        }

        echo json_encode(['success' => true, 'message' => 'Mot de passe modifié avec succès']);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Sauvegarder les droits départements d'un utilisateur
 */
function saveUserDroits($pdo) {
    header('Content-Type: application/json');

    try {
        $data = json_decode(file_get_contents('php://input'), true);

        $userId = intval($data['userId'] ?? 0);
        $departements = $data['departements'] ?? [];

        if ($userId === 0) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID utilisateur manquant']);
            exit;
        }

        // Récupérer le type d'utilisateur
        $stmtType = $pdo->prepare("SELECT typeUtilisateur_id FROM utilisateurs WHERE id = ?");
        $stmtType->execute([$userId]);
        $typeUtilisateur = $stmtType->fetchColumn();

        if (!$typeUtilisateur) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Utilisateur introuvable']);
            exit;
        }

        // Récupérer les numéros des départements actuels pour comparaison
        $stmtOldDepts = $pdo->prepare("
            SELECT d.numero_departement
            FROM gestionAccesDepartements gd
            JOIN departements d ON gd.departement_id = d.id
            WHERE gd.utilisateur_id = ?
        ");
        $stmtOldDepts->execute([$userId]);
        $oldDeptNumbers = $stmtOldDepts->fetchAll(PDO::FETCH_COLUMN);

        // Récupérer les numéros des nouveaux départements
        $newDeptNumbers = [];
        if (!empty($departements)) {
            $placeholders = str_repeat('?,', count($departements) - 1) . '?';
            $stmtNewDepts = $pdo->prepare("SELECT numero_departement FROM departements WHERE id IN ($placeholders)");
            $stmtNewDepts->execute($departements);
            $newDeptNumbers = $stmtNewDepts->fetchAll(PDO::FETCH_COLUMN);
        }

        // Identifier les départements supprimés
        $removedDeptNumbers = array_diff($oldDeptNumbers, $newDeptNumbers);

        // Supprimer les cantons des départements qui ont été retirés
        if (!empty($removedDeptNumbers)) {
            $placeholders = str_repeat('?,', count($removedDeptNumbers) - 1) . '?';
            $params = array_merge([$userId], $removedDeptNumbers);
            $stmtDeleteCantons = $pdo->prepare("
                DELETE FROM gestionAccesCantons
                WHERE utilisateur_id = ? AND numero_departement IN ($placeholders)
            ");
            $stmtDeleteCantons->execute($params);
        }

        // Supprimer les anciens droits départements
        $stmt = $pdo->prepare("DELETE FROM gestionAccesDepartements WHERE utilisateur_id = ?");
        $stmt->execute([$userId]);

        // Insérer les nouveaux droits
        if (!empty($departements)) {
            $stmt = $pdo->prepare("
                INSERT INTO gestionAccesDepartements (utilisateur_id, departement_id, typeUtilisateur_id)
                VALUES (?, ?, ?)
            ");

            foreach ($departements as $deptId) {
                $stmt->execute([$userId, $deptId, $typeUtilisateur]);
            }
        }

        // Si aucun département n'est sélectionné, supprimer tous les cantons
        if (empty($departements)) {
            $stmtDeleteAllCantons = $pdo->prepare("DELETE FROM gestionAccesCantons WHERE utilisateur_id = ?");
            $stmtDeleteAllCantons->execute([$userId]);
        }

        // Logger la modification des droits départements
        if (isset($GLOBALS['logger'])) {
            $GLOBALS['logger']->logDroits('departements', $userId, [
                'departements' => $newDeptNumbers,
                'anciens_departements' => $oldDeptNumbers,
                'departements_supprimes' => array_values($removedDeptNumbers)
            ]);
        }

        echo json_encode(['success' => true]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Sauvegarder les droits cantons d'un utilisateur
 */
function saveUserCantons($pdo) {
    header('Content-Type: application/json');

    try {
        $data = json_decode(file_get_contents('php://input'), true);

        $userId = intval($data['userId'] ?? 0);
        $cantons = $data['cantons'] ?? [];

        if ($userId === 0) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID utilisateur manquant']);
            exit;
        }

        // Créer la table si elle n'existe pas
        $pdo->exec("
            CREATE TABLE IF NOT EXISTS gestionAccesCantons (
                id INT AUTO_INCREMENT PRIMARY KEY,
                utilisateur_id INT NOT NULL,
                numero_departement VARCHAR(3) NOT NULL,
                canton VARCHAR(255) NOT NULL,
                UNIQUE KEY unique_user_canton (utilisateur_id, numero_departement, canton),
                FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
            )
        ");

        // Supprimer les anciens droits
        $stmt = $pdo->prepare("DELETE FROM gestionAccesCantons WHERE utilisateur_id = ?");
        $stmt->execute([$userId]);

        // Insérer les nouveaux droits
        if (!empty($cantons)) {
            $stmt = $pdo->prepare("
                INSERT INTO gestionAccesCantons (utilisateur_id, numero_departement, canton)
                VALUES (?, ?, ?)
            ");

            foreach ($cantons as $canton) {
                $dept = $canton['numero_departement'] ?? '';
                $cantonName = $canton['canton'] ?? '';

                if (!empty($dept) && !empty($cantonName)) {
                    $stmt->execute([$userId, $dept, $cantonName]);
                }
            }
        }

        // Logger la modification des droits cantons
        if (isset($GLOBALS['logger'])) {
            $GLOBALS['logger']->logDroits('cantons', $userId, [
                'nb_cantons' => count($cantons),
                'cantons' => $cantons
            ]);
        }

        echo json_encode(['success' => true]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Supprimer un utilisateur (avec cascade sur gestionAccesDepartements et gestionAccesCantons)
 */
function deleteUtilisateur($pdo) {
    header('Content-Type: application/json');

    $id = isset($_GET['id']) ? intval($_GET['id']) : 0;

    if ($id <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'ID utilisateur invalide']);
        exit;
    }

    try {
        // Récupérer les infos de l'utilisateur avant suppression pour le log
        $stmtInfo = $pdo->prepare("SELECT nom, prenom, adresseMail FROM utilisateurs WHERE id = ?");
        $stmtInfo->execute([$id]);
        $userInfo = $stmtInfo->fetch(PDO::FETCH_ASSOC);

        // Supprimer les droits par cantons
        $stmt = $pdo->prepare("DELETE FROM gestionAccesCantons WHERE utilisateur_id = ?");
        $stmt->execute([$id]);

        // Supprimer les droits par départements
        $stmt = $pdo->prepare("DELETE FROM gestionAccesDepartements WHERE utilisateur_id = ?");
        $stmt->execute([$id]);

        // Supprimer l'utilisateur
        $stmt = $pdo->prepare("DELETE FROM utilisateurs WHERE id = ?");
        $stmt->execute([$id]);

        if ($stmt->rowCount() > 0) {
            // Logger la suppression
            if (isset($GLOBALS['logger']) && $userInfo) {
                $GLOBALS['logger']->logUserAction('delete', $id, $userInfo['prenom'] . ' ' . $userInfo['nom'], [
                    'email' => $userInfo['adresseMail']
                ]);
            }
            echo json_encode(['success' => true, 'message' => 'Utilisateur supprimé avec succès']);
        } else {
            http_response_code(404);
            echo json_encode(['success' => false, 'error' => 'Utilisateur non trouvé']);
        }

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les utilisateurs par région pour l'arborescence
 * Admin : tous les référents et membres
 * Référent : uniquement les membres de ses départements
 */
function getUtilisateursParRegion($pdo) {
    // Démarrer la session si elle n'est pas déjà démarrée
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $currentUserType = $_SESSION['user_type'] ?? 0;
    $currentUserId = $_SESSION['user_id'] ?? 0;

    // Seuls les admins (1, 2), référents (3) et président (5) peuvent accéder
    if (!in_array($currentUserType, [1, 2, 3, 5])) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    try {
        $referents = [];
        $membres = [];

        // Pour Admin, Super Admin et Président : récupérer tous les référents avec leurs départements
        if ($currentUserType == 1 || $currentUserType == 2 || $currentUserType == 5) {
            $stmtRef = $pdo->query("
                SELECT DISTINCT
                    u.id,
                    u.nom,
                    u.prenom,
                    u.adresseMail as email,
                    d.region as region_nom,
                    d.nom_departement as departement_nom,
                    d.numero_departement as departement_numero
                FROM utilisateurs u
                INNER JOIN gestionAccesDepartements gd ON u.id = gd.utilisateur_id
                INNER JOIN departements d ON gd.departement_id = d.id
                WHERE u.typeUtilisateur_id = 3
                AND u.actif = 1
                ORDER BY d.region, d.nom_departement, u.prenom, u.nom
            ");
            $referents = $stmtRef->fetchAll(PDO::FETCH_ASSOC);

            // Récupérer les cantons avec leurs membres pour chaque département des référents
            $stmtCantonsMembres = $pdo->query("
                SELECT DISTINCT
                    gdc.numero_departement as dept_numero,
                    gdc.canton,
                    m.id as membre_id,
                    m.nom as membre_nom,
                    m.prenom as membre_prenom,
                    m.adresseMail as membre_email,
                    m.typeUtilisateur_id as type_utilisateur
                FROM gestionAccesCantons gdc
                INNER JOIN utilisateurs m ON gdc.utilisateur_id = m.id
                WHERE m.typeUtilisateur_id IN (3, 4)
                AND m.actif = 1
                ORDER BY gdc.numero_departement, gdc.canton, m.typeUtilisateur_id, m.prenom, m.nom
            ");
            $cantonsMembres = $stmtCantonsMembres->fetchAll(PDO::FETCH_ASSOC);

            // Organiser les cantons/membres et référents par département
            $cantonsParDept = [];
            foreach ($cantonsMembres as $row) {
                $deptNum = $row['dept_numero'];
                $canton = $row['canton'];
                $typeUser = $row['type_utilisateur'];
                if (!isset($cantonsParDept[$deptNum])) {
                    $cantonsParDept[$deptNum] = [];
                }
                if (!isset($cantonsParDept[$deptNum][$canton])) {
                    $cantonsParDept[$deptNum][$canton] = ['membres' => [], 'referents' => []];
                }
                $userData = [
                    'id' => $row['membre_id'],
                    'nom' => $row['membre_nom'],
                    'prenom' => $row['membre_prenom'],
                    'email' => $row['membre_email']
                ];
                if ($typeUser == 3) {
                    $cantonsParDept[$deptNum][$canton]['referents'][] = $userData;
                } else {
                    $cantonsParDept[$deptNum][$canton]['membres'][] = $userData;
                }
            }
        }

        // Pour Admin, Super Admin et Président : récupérer tous les membres
        if ($currentUserType == 1 || $currentUserType == 2 || $currentUserType == 5) {
            $stmtMembres = $pdo->query("
                SELECT DISTINCT
                    u.id,
                    u.nom,
                    u.prenom,
                    u.adresseMail as email,
                    d.region as region_nom,
                    d.nom_departement as departement_nom,
                    d.numero_departement as departement_numero,
                    gdc.canton
                FROM utilisateurs u
                INNER JOIN gestionAccesCantons gdc ON u.id = gdc.utilisateur_id
                INNER JOIN departements d ON gdc.numero_departement COLLATE utf8mb4_unicode_ci = d.numero_departement
                WHERE u.typeUtilisateur_id = 4
                AND u.actif = 1
                ORDER BY d.region, d.nom_departement, gdc.canton, u.prenom, u.nom
            ");
            $membres = $stmtMembres->fetchAll(PDO::FETCH_ASSOC);
        }
        // Pour Référent : récupérer uniquement les membres de ses départements
        elseif ($currentUserType == 3) {
            // Récupérer les départements du référent
            $stmtDepts = $pdo->prepare("
                SELECT DISTINCT d.numero_departement
                FROM gestionAccesDepartements gd
                INNER JOIN departements d ON gd.departement_id = d.id
                WHERE gd.utilisateur_id = ?
            ");
            $stmtDepts->execute([$currentUserId]);
            $deptNumeros = $stmtDepts->fetchAll(PDO::FETCH_COLUMN);

            if (!empty($deptNumeros)) {
                $placeholders = str_repeat('?,', count($deptNumeros) - 1) . '?';
                $stmtMembres = $pdo->prepare("
                    SELECT DISTINCT
                        u.id,
                        u.nom,
                        u.prenom,
                        u.adresseMail as email,
                        d.region as region_nom,
                        d.nom_departement as departement_nom,
                        d.numero_departement as departement_numero,
                        gdc.canton
                    FROM utilisateurs u
                    INNER JOIN gestionAccesCantons gdc ON u.id = gdc.utilisateur_id
                    INNER JOIN departements d ON gdc.numero_departement COLLATE utf8mb4_unicode_ci = d.numero_departement
                    WHERE u.typeUtilisateur_id = 4
                    AND u.actif = 1
                    AND gdc.numero_departement COLLATE utf8mb4_unicode_ci IN ($placeholders)
                    ORDER BY d.region, d.nom_departement, gdc.canton, u.prenom, u.nom
                ");
                $stmtMembres->execute($deptNumeros);
                $membres = $stmtMembres->fetchAll(PDO::FETCH_ASSOC);
            }
        }

        echo json_encode([
            'success' => true,
            'referents' => $referents,
            'membres' => $membres,
            'cantonsParDept' => $cantonsParDept ?? []
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Enregistrer les cantons de l'utilisateur connecté (onglet "Mes accès")
 */
function saveMyCantons($pdo) {
    // Récupérer l'utilisateur connecté
    require_once __DIR__ . '/classes/AppAuth.php';
    require_once __DIR__ . '/config/auth_config.php';

    $auth = new AppAuth($pdo);
    if (!$auth->isLoggedIn()) {
        http_response_code(401);
        echo json_encode(['success' => false, 'error' => 'Non authentifié']);
        exit;
    }

    $currentUser = $auth->getUser();
    $currentUserId = $currentUser['id'];

    // Récupérer les données JSON (déjà parsées en haut du fichier)
    $input = $GLOBALS['jsonInput'] ?? [];
    $cantons = $input['cantons'] ?? [];

    try {
        $pdo->beginTransaction();

        // Supprimer tous les cantons existants de l'utilisateur
        $stmtDelete = $pdo->prepare("DELETE FROM gestionAccesCantons WHERE utilisateur_id = ?");
        $stmtDelete->execute([$currentUserId]);

        // Insérer les nouveaux cantons sélectionnés
        if (!empty($cantons)) {
            $stmtInsert = $pdo->prepare("
                INSERT INTO gestionAccesCantons (numero_departement, canton, utilisateur_id)
                VALUES (?, ?, ?)
            ");

            foreach ($cantons as $canton) {
                $stmtInsert->execute([
                    $canton['numero_departement'],
                    $canton['canton'],
                    $currentUserId
                ]);
            }
        }

        $pdo->commit();

        echo json_encode([
            'success' => true,
            'message' => 'Cantons enregistrés avec succès',
            'count' => count($cantons)
        ]);

    } catch (PDOException $e) {
        $pdo->rollBack();
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les statistiques de progression des référents pour les communes < filtreHabitants
 * Retourne les stats par département avec les cantons attribués
 * Le seuil d'habitants est configurable via menus.json => filtreHabitants
 */
function getStatsReferents($pdo) {
    // Démarrer la session si pas déjà fait
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    // Vérifier l'authentification via la session
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['user_type'])) {
        http_response_code(401);
        echo json_encode(['success' => false, 'error' => 'Non authentifié']);
        exit;
    }

    $currentUserId = $_SESSION['user_id'];
    $currentUserType = $_SESSION['user_type'];

    // Seuls les admins (1, 2) et référents (3) peuvent accéder
    if ($currentUserType > 3) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    try {
        // Récupérer tous les référents (3) ET membres (4) avec leurs départements et cantons
        $stmtReferents = $pdo->prepare("
            SELECT DISTINCT
                u.id as utilisateur_id,
                u.nom,
                u.prenom,
                u.pseudo,
                u.adresseMail,
                u.telephone,
                u.typeUtilisateur_id,
                d.numero_departement,
                d.nom_departement
            FROM utilisateurs u
            JOIN gestionAccesDepartements gd ON u.id = gd.utilisateur_id
            JOIN departements d ON gd.departement_id = d.id
            WHERE u.typeUtilisateur_id IN (3, 4)
            ORDER BY d.numero_departement, u.typeUtilisateur_id, u.nom, u.prenom
        ");
        $stmtReferents->execute();
        $referents = $stmtReferents->fetchAll(PDO::FETCH_ASSOC);

        // Organiser les données par département
        $statsByDept = [];

        foreach ($referents as $ref) {
            $numDept = $ref['numero_departement'];

            if (!isset($statsByDept[$numDept])) {
                // Stats du département pour communes < filtreHabitants hab avec détail par statut
                $filtreHab = $GLOBALS['filtreHabitants'];
                $stmtDeptStats = $pdo->prepare("
                    SELECT
                        COUNT(*) as total_communes,
                        COUNT(CASE WHEN d.demarche_active = 1 THEN 1 END) as communes_traitees,
                        COUNT(CASE WHEN d.statut_demarchage = 1 THEN 1 END) as en_cours,
                        COUNT(CASE WHEN d.statut_demarchage = 2 THEN 1 END) as rdv_obtenu,
                        COUNT(CASE WHEN d.statut_demarchage = 3 THEN 1 END) as sans_suite,
                        COUNT(CASE WHEN d.statut_demarchage = 4 THEN 1 END) as promesse
                    FROM maires m
                    LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique
                    WHERE m.numero_departement = ? AND m.nombre_habitants < ?
                ");
                $stmtDeptStats->execute([$numDept, $filtreHab]);
                $deptStats = $stmtDeptStats->fetch(PDO::FETCH_ASSOC);

                $statsByDept[$numDept] = [
                    'numero_departement' => $numDept,
                    'nom_departement' => $ref['nom_departement'],
                    'total_communes_1000' => (int)$deptStats['total_communes'],
                    'communes_traitees' => (int)$deptStats['communes_traitees'],
                    'en_cours' => (int)$deptStats['en_cours'],
                    'rdv_obtenu' => (int)$deptStats['rdv_obtenu'],
                    'sans_suite' => (int)$deptStats['sans_suite'],
                    'promesse' => (int)$deptStats['promesse'],
                    'pourcentage' => $deptStats['total_communes'] > 0
                        ? round(($deptStats['communes_traitees'] / $deptStats['total_communes']) * 100, 1)
                        : 0,
                    'referents' => []
                ];
            }

            // Récupérer les cantons du référent pour ce département
            $stmtCantons = $pdo->prepare("
                SELECT canton
                FROM gestionAccesCantons
                WHERE utilisateur_id = ? AND numero_departement = ?
            ");
            $stmtCantons->execute([$ref['utilisateur_id'], $numDept]);
            $cantons = $stmtCantons->fetchAll(PDO::FETCH_COLUMN);

            // Stats des cantons du référent (communes < filtreHabitants hab) avec détail par statut
            $totalCantonsCommunes = 0;
            $cantonsTraitees = 0;
            $cantonsEnCours = 0;
            $cantonsRdv = 0;
            $cantonsSansSuite = 0;
            $cantonsPromesse = 0;
            $communesList = [];

            if (!empty($cantons)) {
                $placeholders = str_repeat('?,', count($cantons) - 1) . '?';
                $params = array_merge([$numDept], $cantons);

                $stmtCantonStats = $pdo->prepare("
                    SELECT
                        COUNT(*) as total_communes,
                        COUNT(CASE WHEN d.demarche_active = 1 THEN 1 END) as communes_traitees,
                        COUNT(CASE WHEN d.statut_demarchage = 1 THEN 1 END) as en_cours,
                        COUNT(CASE WHEN d.statut_demarchage = 2 THEN 1 END) as rdv_obtenu,
                        COUNT(CASE WHEN d.statut_demarchage = 3 THEN 1 END) as sans_suite,
                        COUNT(CASE WHEN d.statut_demarchage = 4 THEN 1 END) as promesse
                    FROM maires m
                    LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique
                    WHERE m.numero_departement = ?
                    AND m.canton IN ($placeholders)
                    AND m.nombre_habitants < ?
                ");
                $stmtCantonStats->execute(array_merge($params, [$filtreHab]));
                $cantonStats = $stmtCantonStats->fetch(PDO::FETCH_ASSOC);

                $totalCantonsCommunes = (int)$cantonStats['total_communes'];
                $cantonsTraitees = (int)$cantonStats['communes_traitees'];
                $cantonsEnCours = (int)$cantonStats['en_cours'];
                $cantonsRdv = (int)$cantonStats['rdv_obtenu'];
                $cantonsSansSuite = (int)$cantonStats['sans_suite'];
                $cantonsPromesse = (int)$cantonStats['promesse'];

                // Récupérer la liste des communes (noms) triées par ordre alphabétique
                $stmtCommunes = $pdo->prepare("
                    SELECT DISTINCT m.commune
                    FROM maires m
                    WHERE m.numero_departement = ?
                    AND m.canton IN ($placeholders)
                    AND m.nombre_habitants < ?
                    ORDER BY m.commune ASC
                ");
                $stmtCommunes->execute(array_merge($params, [$filtreHab]));
                $communesList = $stmtCommunes->fetchAll(PDO::FETCH_COLUMN);

                // Récupérer les communes groupées par circonscription avec statut
                $stmtCommunesByCirco = $pdo->prepare("
                    SELECT m.circonscription, m.commune, COALESCE(d.statut_demarchage, 0) as statut
                    FROM maires m
                    LEFT JOIN demarchage d ON m.cle_unique = d.maire_cle_unique
                    WHERE m.numero_departement = ?
                    AND m.canton IN ($placeholders)
                    AND m.nombre_habitants < ?
                    ORDER BY m.circonscription ASC, m.commune ASC
                ");
                $stmtCommunesByCirco->execute(array_merge($params, [$filtreHab]));
                $communesByCircoRows = $stmtCommunesByCirco->fetchAll(PDO::FETCH_ASSOC);

                // Grouper par circo avec statut
                $communesByCirco = [];
                foreach ($communesByCircoRows as $row) {
                    $circo = $row['circonscription'] ?: 'Non définie';
                    if (!isset($communesByCirco[$circo])) {
                        $communesByCirco[$circo] = [];
                    }
                    // Vérifier si la commune n'est pas déjà ajoutée
                    $exists = false;
                    foreach ($communesByCirco[$circo] as $c) {
                        if ($c['nom'] === $row['commune']) {
                            $exists = true;
                            break;
                        }
                    }
                    if (!$exists) {
                        $communesByCirco[$circo][] = [
                            'nom' => $row['commune'],
                            'statut' => (int)$row['statut']
                        ];
                    }
                }
            }

            $statsByDept[$numDept]['referents'][] = [
                'id' => $ref['utilisateur_id'],
                'nom' => $ref['nom'],
                'prenom' => $ref['prenom'],
                'type_utilisateur' => (int)$ref['typeUtilisateur_id'],
                'role' => $ref['typeUtilisateur_id'] == 3 ? 'Référent' : 'Membre',
                'cantons' => $cantons,
                'nb_cantons' => count($cantons),
                'communes' => $communesList,
                'communes_by_circo' => $communesByCirco ?? [],
                'total_communes_1000' => $totalCantonsCommunes,
                'communes_traitees' => $cantonsTraitees,
                'en_cours' => $cantonsEnCours,
                'rdv_obtenu' => $cantonsRdv,
                'sans_suite' => $cantonsSansSuite,
                'promesse' => $cantonsPromesse,
                'pourcentage' => $totalCantonsCommunes > 0
                    ? round(($cantonsTraitees / $totalCantonsCommunes) * 100, 1)
                    : 0
            ];
        }

        // Convertir en tableau indexé
        $result = array_values($statsByDept);

        echo json_encode([
            'success' => true,
            'current_user_id' => $currentUserId,
            'current_user_type' => $currentUserType,
            'filtreHabitants' => $GLOBALS['filtreHabitants'],
            'departements' => $result
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer les logs d'activité (Admin Général uniquement)
 */
function getLogs($pdo) {
    // Vérifier la session
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $currentUserType = $_SESSION['user_type'] ?? 0;

    // Seul Admin Général (type 1) peut accéder aux logs
    if ($currentUserType != 1) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    try {
        $page = max(1, intval($_GET['page'] ?? 1));
        $perPage = min(100, max(10, intval($_GET['perPage'] ?? 50)));
        $offset = ($page - 1) * $perPage;

        // Filtres
        $categorie = trim($_GET['categorie'] ?? '');
        $action = trim($_GET['actionFilter'] ?? '');
        $statut = trim($_GET['statut'] ?? '');
        $utilisateur = trim($_GET['utilisateur'] ?? '');
        $dateDebut = trim($_GET['dateDebut'] ?? '');
        $dateFin = trim($_GET['dateFin'] ?? '');

        // Construction de la requête
        $where = [];
        $params = [];

        if (!empty($categorie)) {
            $where[] = "categorie = ?";
            $params[] = $categorie;
        }

        if (!empty($action)) {
            $where[] = "action = ?";
            $params[] = $action;
        }

        if (!empty($statut)) {
            $where[] = "statut = ?";
            $params[] = $statut;
        }

        if (!empty($utilisateur)) {
            $where[] = "utilisateur_nom LIKE ?";
            $params[] = "%$utilisateur%";
        }

        if (!empty($dateDebut)) {
            $where[] = "DATE(date_action) >= ?";
            $params[] = $dateDebut;
        }

        if (!empty($dateFin)) {
            $where[] = "DATE(date_action) <= ?";
            $params[] = $dateFin;
        }

        $whereClause = !empty($where) ? "WHERE " . implode(" AND ", $where) : "";

        // Compter le total
        $stmtCount = $pdo->prepare("SELECT COUNT(*) FROM logs_activite $whereClause");
        $stmtCount->execute($params);
        $total = $stmtCount->fetchColumn();

        // Récupérer les logs
        $sql = "SELECT id, date_action, utilisateur_id, utilisateur_nom, utilisateur_type,
                       action, categorie, description, entite_type, entite_id, entite_nom,
                       ip_address, statut, message_erreur
                FROM logs_activite
                $whereClause
                ORDER BY date_action DESC
                LIMIT $perPage OFFSET $offset";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $logs = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Statistiques pour la période
        $statsParams = [];
        $statsWhere = [];

        if (!empty($dateDebut)) {
            $statsWhere[] = "DATE(date_action) >= ?";
            $statsParams[] = $dateDebut;
        }

        if (!empty($dateFin)) {
            $statsWhere[] = "DATE(date_action) <= ?";
            $statsParams[] = $dateFin;
        }

        $statsWhereClause = !empty($statsWhere) ? "WHERE " . implode(" AND ", $statsWhere) : "";

        $stmtStats = $pdo->prepare("
            SELECT
                SUM(CASE WHEN categorie = 'AUTH' AND action = 'LOGIN' THEN 1 ELSE 0 END) as auth,
                SUM(CASE WHEN categorie = 'DEMARCHAGE' THEN 1 ELSE 0 END) as demarchage,
                SUM(CASE WHEN categorie = 'UTILISATEUR' THEN 1 ELSE 0 END) as utilisateur,
                SUM(CASE WHEN statut = 'FAILED' THEN 1 ELSE 0 END) as failed
            FROM logs_activite
            $statsWhereClause
        ");
        $stmtStats->execute($statsParams);
        $stats = $stmtStats->fetch(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'logs' => $logs,
            'total' => (int)$total,
            'page' => $page,
            'perPage' => $perPage,
            'stats' => $stats
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer le détail d'un log (Admin Général uniquement)
 */
function getLogDetail($pdo) {
    // Vérifier la session
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $currentUserType = $_SESSION['user_type'] ?? 0;

    // Seul Admin Général (type 1) peut accéder aux logs
    if ($currentUserType != 1) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    $logId = intval($_GET['id'] ?? 0);

    if ($logId <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'ID invalide']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("SELECT * FROM logs_activite WHERE id = ?");
        $stmt->execute([$logId]);
        $log = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$log) {
            http_response_code(404);
            echo json_encode(['success' => false, 'error' => 'Log non trouvé']);
            exit;
        }

        echo json_encode([
            'success' => true,
            'log' => $log
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Sauvegarder les paramètres dans menus.json (Admin Général uniquement)
 */
function saveParameters($pdo) {
    // Vérifier la session
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $currentUserType = $_SESSION['user_type'] ?? 0;

    // Seul Admin Général (type 1) peut modifier les paramètres
    if ($currentUserType != 1) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    // Récupérer les données JSON
    $data = $GLOBALS['jsonInput'] ?? [];
    $filtreHabitants = intval($data['filtreHabitants'] ?? 1000);
    $environnement = $data['environnement'] ?? 'dev';

    // Validation
    if ($filtreHabitants < 0) {
        $filtreHabitants = 0;
    }

    // Validation de l'environnement (doit être 'dev' ou 'prod')
    if (!in_array($environnement, ['dev', 'prod'])) {
        $environnement = 'dev';
    }

    try {
        // Lire le fichier menus.json existant
        $menusFile = __DIR__ . '/config/menus.json';
        $menusConfig = json_decode(file_get_contents($menusFile), true);

        if ($menusConfig === null) {
            echo json_encode(['success' => false, 'error' => 'Erreur lecture fichier de configuration']);
            exit;
        }

        // Mettre à jour les paramètres
        $menusConfig['filtreHabitants'] = $filtreHabitants;
        $menusConfig['environnement'] = $environnement;

        // Écrire le fichier avec un formatage lisible
        $jsonOutput = json_encode($menusConfig, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

        if (file_put_contents($menusFile, $jsonOutput) === false) {
            echo json_encode(['success' => false, 'error' => 'Erreur écriture fichier de configuration']);
            exit;
        }

        // Logger la modification
        if (isset($GLOBALS['logger'])) {
            $GLOBALS['logger']->log(
                'UPDATE_PARAMETERS',
                'GENERAL',
                "Modification des paramètres : filtreHabitants = $filtreHabitants, environnement = $environnement",
                ['donnees' => ['filtreHabitants' => $filtreHabitants, 'environnement' => $environnement]]
            );
        }

        echo json_encode([
            'success' => true,
            'message' => 'Paramètres enregistrés avec succès',
            'filtreHabitants' => $filtreHabitants,
            'environnement' => $environnement
        ]);

    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Supprimer un log individuel (Admin Général uniquement)
 */
function deleteLog($pdo) {
    // Vérifier la session
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $currentUserType = $_SESSION['user_type'] ?? 0;

    // Seul Admin Général (type 1) peut supprimer les logs
    if ($currentUserType != 1) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    // Récupérer les données JSON
    $data = $GLOBALS['jsonInput'] ?? [];
    $logId = intval($data['id'] ?? 0);

    if ($logId <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'ID invalide']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("DELETE FROM logs_activite WHERE id = ?");
        $stmt->execute([$logId]);

        $deleted = $stmt->rowCount();

        echo json_encode([
            'success' => true,
            'deleted' => $deleted
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Purger les anciens logs (Admin Général uniquement)
 */
function purgeLogs($pdo) {
    // Vérifier la session
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $currentUserType = $_SESSION['user_type'] ?? 0;

    // Seul Admin Général (type 1) peut purger les logs
    if ($currentUserType != 1) {
        http_response_code(403);
        echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
        exit;
    }

    // Récupérer les données JSON
    $data = $GLOBALS['jsonInput'] ?? [];
    $days = intval($data['days'] ?? 30);

    // Validation : minimum 7 jours
    if ($days < 7) {
        $days = 7;
    }

    try {
        // Calculer la date limite
        $dateLimit = date('Y-m-d H:i:s', strtotime("-{$days} days"));

        $stmt = $pdo->prepare("DELETE FROM logs_activite WHERE date_action < ?");
        $stmt->execute([$dateLimit]);

        $deleted = $stmt->rowCount();

        // Logger la purge
        if (isset($GLOBALS['logger'])) {
            $GLOBALS['logger']->log(
                'PURGE_LOGS',
                'GENERAL',
                "Purge des logs antérieurs à {$days} jours ({$deleted} supprimés)",
                ['donnees' => ['days' => $days, 'deleted' => $deleted, 'date_limit' => $dateLimit]]
            );
        }

        echo json_encode([
            'success' => true,
            'deleted' => $deleted,
            'days' => $days
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

/**
 * Récupérer tous les types d'utilisateurs
 */
function getTypeUtilisateurs($pdo) {
    try {
        $stmt = $pdo->query("SELECT id, nom, acronym FROM typeUtilisateur ORDER BY id");
        $types = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Mapping des classes CSS par défaut pour les types connus
        $classMapping = [
            1 => 'badge-super-admin',
            2 => 'badge-admin',
            3 => 'badge-referent',
            4 => 'badge-membre',
            5 => 'badge-president'
        ];

        // Construire un mapping id => données pour faciliter l'utilisation côté JS
        $typesMap = [];
        foreach ($types as $type) {
            $typesMap[$type['id']] = [
                'label' => $type['nom'],
                'acronym' => $type['acronym'] ?? '',
                'class' => $classMapping[$type['id']] ?? 'badge-role-' . $type['id']
            ];
        }

        echo json_encode(['success' => true, 'types' => $typesMap]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}
