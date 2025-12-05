<?php
/**
 * Classe Logger - Système de logging des activités
 * Annuaire des Maires de France - Parrainage 2027
 */

class Logger {

    private $pdo;

    // Catégories d'actions
    const CAT_AUTH = 'AUTH';
    const CAT_DEMARCHAGE = 'DEMARCHAGE';
    const CAT_UTILISATEUR = 'UTILISATEUR';
    const CAT_DROITS = 'DROITS';
    const CAT_EXPORT = 'EXPORT';
    const CAT_CONSULTATION = 'CONSULTATION';
    const CAT_GENERAL = 'GENERAL';

    // Actions prédéfinies
    const ACTION_LOGIN = 'LOGIN';
    const ACTION_LOGOUT = 'LOGOUT';
    const ACTION_LOGIN_FAILED = 'LOGIN_FAILED';
    const ACTION_SAVE_DEMARCHAGE = 'SAVE_DEMARCHAGE';
    const ACTION_UPDATE_DEMARCHAGE = 'UPDATE_DEMARCHAGE';
    const ACTION_CREATE_USER = 'CREATE_USER';
    const ACTION_UPDATE_USER = 'UPDATE_USER';
    const ACTION_DELETE_USER = 'DELETE_USER';
    const ACTION_ASSIGN_CANTON = 'ASSIGN_CANTON';
    const ACTION_REMOVE_CANTON = 'REMOVE_CANTON';
    const ACTION_ASSIGN_DEPT = 'ASSIGN_DEPT';
    const ACTION_REMOVE_DEPT = 'REMOVE_DEPT';
    const ACTION_EXPORT_CSV = 'EXPORT_CSV';
    const ACTION_VIEW_REPORT = 'VIEW_REPORT';
    const ACTION_VIEW_FICHE = 'VIEW_FICHE';

    // Statuts
    const STATUS_SUCCESS = 'SUCCESS';
    const STATUS_FAILED = 'FAILED';
    const STATUS_WARNING = 'WARNING';

    /**
     * Constructeur
     */
    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    /**
     * Enregistrer une action dans les logs
     *
     * @param string $action Type d'action (LOGIN, SAVE_DEMARCHAGE, etc.)
     * @param string $categorie Catégorie (AUTH, DEMARCHAGE, etc.)
     * @param string|null $description Description textuelle de l'action
     * @param array $options Options supplémentaires:
     *   - utilisateur_id: ID de l'utilisateur (auto-détecté si non fourni)
     *   - utilisateur_nom: Nom de l'utilisateur
     *   - utilisateur_type: Type d'utilisateur (1-4)
     *   - entite_type: Type d'entité concernée (maire, utilisateur, etc.)
     *   - entite_id: ID de l'entité
     *   - entite_nom: Nom de l'entité
     *   - donnees: Données supplémentaires (sera converti en JSON)
     *   - statut: SUCCESS, FAILED, WARNING
     *   - message_erreur: Message d'erreur si échec
     * @return bool
     */
    public function log(string $action, string $categorie = self::CAT_GENERAL, ?string $description = null, array $options = []): bool {
        try {
            // Récupérer les infos utilisateur depuis la session si non fourni
            $utilisateurId = $options['utilisateur_id'] ?? ($_SESSION['user_id'] ?? null);
            $utilisateurNom = $options['utilisateur_nom'] ?? null;
            $utilisateurType = $options['utilisateur_type'] ?? ($_SESSION['user_type'] ?? null);

            // Si on a l'ID mais pas le nom, récupérer depuis la session ou la base
            if ($utilisateurId && !$utilisateurNom && isset($_SESSION['user_nom'])) {
                $utilisateurNom = $_SESSION['user_prenom'] . ' ' . $_SESSION['user_nom'];
            }

            // Récupérer IP et User-Agent
            $ipAddress = $this->getClientIP();
            $userAgent = substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500);

            // Préparer les données JSON si fournies
            $donneesJson = null;
            if (!empty($options['donnees'])) {
                $donneesJson = json_encode($options['donnees'], JSON_UNESCAPED_UNICODE);
            }

            $stmt = $this->pdo->prepare("
                INSERT INTO logs_activite (
                    utilisateur_id, utilisateur_nom, utilisateur_type,
                    action, categorie, description,
                    entite_type, entite_id, entite_nom,
                    ip_address, user_agent, donnees_json,
                    statut, message_erreur
                ) VALUES (
                    ?, ?, ?,
                    ?, ?, ?,
                    ?, ?, ?,
                    ?, ?, ?,
                    ?, ?
                )
            ");

            $stmt->execute([
                $utilisateurId,
                $utilisateurNom,
                $utilisateurType,
                $action,
                $categorie,
                $description,
                $options['entite_type'] ?? null,
                $options['entite_id'] ?? null,
                $options['entite_nom'] ?? null,
                $ipAddress,
                $userAgent,
                $donneesJson,
                $options['statut'] ?? self::STATUS_SUCCESS,
                $options['message_erreur'] ?? null
            ]);

            return true;

        } catch (PDOException $e) {
            // En cas d'erreur de log, on ne bloque pas l'application
            error_log("Erreur Logger: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Raccourci pour log de connexion
     * Si aucun paramètre fourni, utilise les données de la session
     */
    public function logLogin(?int $userId = null, ?string $userName = null, ?int $userType = null): bool {
        // Utiliser les données de session si non fournies
        $userId = $userId ?? ($_SESSION['user_id'] ?? null);
        $userName = $userName ?? (isset($_SESSION['user_prenom']) ? $_SESSION['user_prenom'] . ' ' . $_SESSION['user_nom'] : null);
        $userType = $userType ?? ($_SESSION['user_type'] ?? null);

        return $this->log(
            self::ACTION_LOGIN,
            self::CAT_AUTH,
            "Connexion de l'utilisateur",
            [
                'utilisateur_id' => $userId,
                'utilisateur_nom' => $userName,
                'utilisateur_type' => $userType
            ]
        );
    }

    /**
     * Raccourci pour log de déconnexion
     */
    public function logLogout(): bool {
        return $this->log(
            self::ACTION_LOGOUT,
            self::CAT_AUTH,
            "Déconnexion de l'utilisateur"
        );
    }

    /**
     * Raccourci pour log de connexion échouée
     */
    public function logLoginFailed(string $pseudo, string $raison = 'Identifiants incorrects'): bool {
        return $this->log(
            self::ACTION_LOGIN_FAILED,
            self::CAT_AUTH,
            "Tentative de connexion échouée pour: $pseudo",
            [
                'statut' => self::STATUS_FAILED,
                'message_erreur' => $raison,
                'donnees' => ['pseudo_tente' => $pseudo]
            ]
        );
    }

    /**
     * Raccourci pour log de démarchage
     */
    public function logDemarchage(string $action, string $maireCleUnique, string $communeNom, array $donnees = []): bool {
        $actionType = ($action === 'create') ? self::ACTION_SAVE_DEMARCHAGE : self::ACTION_UPDATE_DEMARCHAGE;
        $description = ($action === 'create')
            ? "Création d'un démarchage pour $communeNom"
            : "Mise à jour du démarchage pour $communeNom";

        return $this->log(
            $actionType,
            self::CAT_DEMARCHAGE,
            $description,
            [
                'entite_type' => 'maire',
                'entite_id' => $maireCleUnique,
                'entite_nom' => $communeNom,
                'donnees' => $donnees
            ]
        );
    }

    /**
     * Raccourci pour log d'export CSV
     */
    public function logExport(string $typeExport, int $nbLignes = 0): bool {
        return $this->log(
            self::ACTION_EXPORT_CSV,
            self::CAT_EXPORT,
            "Export CSV: $typeExport ($nbLignes lignes)",
            [
                'donnees' => [
                    'type_export' => $typeExport,
                    'nb_lignes' => $nbLignes
                ]
            ]
        );
    }

    /**
     * Raccourci pour log de gestion utilisateur
     */
    public function logUserAction(string $action, int $targetUserId, ?string $targetUserName = null, array $details = []): bool {
        $actionMap = [
            'create' => self::ACTION_CREATE_USER,
            'update' => self::ACTION_UPDATE_USER,
            'delete' => self::ACTION_DELETE_USER,
            'password_change' => 'PASSWORD_CHANGE'
        ];

        $userName = $targetUserName ?? "Utilisateur #$targetUserId";

        $descriptionMap = [
            'create' => "Création de l'utilisateur $userName",
            'update' => "Modification de l'utilisateur $userName",
            'delete' => "Suppression de l'utilisateur $userName",
            'password_change' => "Changement de mot de passe pour $userName"
        ];

        return $this->log(
            $actionMap[$action] ?? 'USER_ACTION',
            self::CAT_UTILISATEUR,
            $descriptionMap[$action] ?? "Action sur l'utilisateur $userName",
            [
                'entite_type' => 'utilisateur',
                'entite_id' => (string)$targetUserId,
                'entite_nom' => $userName,
                'donnees' => $details
            ]
        );
    }

    /**
     * Raccourci pour log d'attribution de droits
     * @param string $type 'departements' ou 'cantons'
     * @param int $userId ID de l'utilisateur concerné
     * @param array $details Détails des droits modifiés
     */
    public function logDroits(string $type, int $userId, array $details = []): bool {
        $actionType = ($type === 'cantons') ? self::ACTION_ASSIGN_CANTON : self::ACTION_ASSIGN_DEPT;

        $description = ($type === 'cantons')
            ? "Modification des droits cantons pour l'utilisateur #$userId"
            : "Modification des droits départements pour l'utilisateur #$userId";

        return $this->log(
            $actionType,
            self::CAT_DROITS,
            $description,
            [
                'entite_type' => 'utilisateur',
                'entite_id' => (string)$userId,
                'donnees' => $details
            ]
        );
    }

    /**
     * Récupérer l'IP du client
     */
    private function getClientIP(): string {
        $headers = [
            'HTTP_CF_CONNECTING_IP',     // Cloudflare
            'HTTP_X_FORWARDED_FOR',      // Proxy
            'HTTP_X_FORWARDED',
            'HTTP_X_CLUSTER_CLIENT_IP',
            'HTTP_FORWARDED_FOR',
            'HTTP_FORWARDED',
            'REMOTE_ADDR'
        ];

        foreach ($headers as $header) {
            if (!empty($_SERVER[$header])) {
                $ip = $_SERVER[$header];
                // Si plusieurs IPs (proxy chain), prendre la première
                if (strpos($ip, ',') !== false) {
                    $ip = trim(explode(',', $ip)[0]);
                }
                // Valider le format IP
                if (filter_var($ip, FILTER_VALIDATE_IP)) {
                    return $ip;
                }
            }
        }

        return '0.0.0.0';
    }

    /**
     * Récupérer les logs avec filtres
     */
    public function getLogs(array $filtres = [], int $limit = 100, int $offset = 0): array {
        $where = ['1=1'];
        $params = [];

        if (!empty($filtres['utilisateur_id'])) {
            $where[] = 'utilisateur_id = ?';
            $params[] = $filtres['utilisateur_id'];
        }

        if (!empty($filtres['action'])) {
            $where[] = 'action = ?';
            $params[] = $filtres['action'];
        }

        if (!empty($filtres['categorie'])) {
            $where[] = 'categorie = ?';
            $params[] = $filtres['categorie'];
        }

        if (!empty($filtres['date_debut'])) {
            $where[] = 'date_action >= ?';
            $params[] = $filtres['date_debut'];
        }

        if (!empty($filtres['date_fin'])) {
            $where[] = 'date_action <= ?';
            $params[] = $filtres['date_fin'];
        }

        if (!empty($filtres['statut'])) {
            $where[] = 'statut = ?';
            $params[] = $filtres['statut'];
        }

        $sql = "SELECT * FROM logs_activite WHERE " . implode(' AND ', $where)
             . " ORDER BY date_action DESC LIMIT $limit OFFSET $offset";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Compter les logs avec filtres
     */
    public function countLogs(array $filtres = []): int {
        $where = ['1=1'];
        $params = [];

        if (!empty($filtres['utilisateur_id'])) {
            $where[] = 'utilisateur_id = ?';
            $params[] = $filtres['utilisateur_id'];
        }

        if (!empty($filtres['categorie'])) {
            $where[] = 'categorie = ?';
            $params[] = $filtres['categorie'];
        }

        $sql = "SELECT COUNT(*) FROM logs_activite WHERE " . implode(' AND ', $where);

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);

        return (int)$stmt->fetchColumn();
    }
}
