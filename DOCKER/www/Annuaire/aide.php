<?php
// Authentification
require_once __DIR__ . '/auth_middleware.php';

// Récupérer les informations de l'utilisateur connecté
$currentUserType = $_SESSION['user_type'] ?? 0;
$currentUserId = $_SESSION['user_id'] ?? 0;
$currentUserPrenom = $_SESSION['user_prenom'] ?? '';
$currentUserNom = $_SESSION['user_nom'] ?? '';
$currentUserName = $currentUserPrenom . ' ' . $currentUserNom;

// Déterminer les sections à afficher selon le type d'utilisateur
// Type 5 (Président) a les mêmes droits que type 2 (Admin)
$showAdmin = ($currentUserType <= 2 || $currentUserType == 5); // Admin Général, Admin et Président
$showReferent = ($currentUserType <= 3 || $currentUserType == 5); // Admin + Référents + Président
$showMembre = true; // Tous les utilisateurs
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aide - Annuaire des Maires</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --bg-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
        }

        body {
            background: #f3f4f6;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
        }

        .page-header {
            background: var(--bg-gradient);
            color: white;
            padding: 0.75rem 0;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .page-header h1 {
            font-weight: 700;
            margin-bottom: 0;
            font-size: 1.4rem;
        }

        .page-header .subtitle {
            opacity: 0.9;
            font-size: 0.85rem;
        }

        .btn-close-page {
            position: fixed;
            top: 10px;
            right: 15px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.2s;
            z-index: 1000;
        }

        .btn-close-page:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: scale(1.1);
        }

        /* Navigation des sections */
        .section-nav {
            background: white;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .section-nav-btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: none;
            background: #f1f5f9;
            color: #64748b;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-nav-btn:hover {
            background: #e2e8f0;
            color: #1e293b;
        }

        .section-nav-btn.active {
            background: var(--bg-gradient);
            color: white;
        }

        .section-nav-btn i {
            font-size: 1.1rem;
        }

        /* Sections d'aide */
        .help-section {
            margin-bottom: 2rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.25rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid;
        }

        .section-header.admin {
            border-color: #ef4444;
        }

        .section-header.referent {
            border-color: #8b5cf6;
        }

        .section-header.membre {
            border-color: #06b6d4;
        }

        .section-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .section-icon.admin {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .section-icon.referent {
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
        }

        .section-icon.membre {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .section-subtitle {
            font-size: 0.85rem;
            color: #64748b;
            margin: 0;
        }

        /* Cartes d'aide */
        .help-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1rem;
        }

        .help-card {
            background: white;
            border-radius: 12px;
            padding: 1.25rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: all 0.2s;
            border-left: 4px solid transparent;
        }

        .help-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .help-card.admin {
            border-left-color: #ef4444;
        }

        .help-card.referent {
            border-left-color: #8b5cf6;
        }

        .help-card.membre {
            border-left-color: #06b6d4;
        }

        .help-card-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .help-card-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .help-card.admin .help-card-icon {
            background: #fef2f2;
            color: #ef4444;
        }

        .help-card.referent .help-card-icon {
            background: #f5f3ff;
            color: #8b5cf6;
        }

        .help-card.membre .help-card-icon {
            background: #ecfeff;
            color: #06b6d4;
        }

        .help-card-title {
            font-weight: 600;
            color: #1e293b;
            font-size: 1rem;
            margin: 0;
        }

        .help-card-content {
            color: #64748b;
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .help-card-content ul {
            margin: 0.5rem 0 0 0;
            padding-left: 1.25rem;
        }

        .help-card-content li {
            margin-bottom: 0.25rem;
        }

        .help-card-content .highlight {
            background: #fef3c7;
            padding: 0.1rem 0.3rem;
            border-radius: 4px;
            font-weight: 500;
        }

        .help-card-content .icon-example {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            background: #f1f5f9;
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-size: 0.85rem;
        }

        /* Légende des icônes */
        .legend-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 0.75rem;
            margin-top: 0.75rem;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 0.75rem;
            background: #f8fafc;
            border-radius: 8px;
            font-size: 0.85rem;
        }

        .legend-item .icon {
            font-size: 1.1rem;
        }

        /* Tips */
        .tip-box {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
            display: flex;
            gap: 0.75rem;
            align-items: flex-start;
        }

        .tip-box i {
            font-size: 1.25rem;
            color: #b45309;
        }

        .tip-box-content {
            font-size: 0.9rem;
            color: #92400e;
        }

        .tip-box-content strong {
            color: #78350f;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .help-cards {
                grid-template-columns: 1fr;
            }

            .section-nav {
                justify-content: flex-start;
                overflow-x: auto;
                flex-wrap: nowrap;
                padding-bottom: 0.5rem;
            }

            .section-nav-btn {
                white-space: nowrap;
            }
        }
    </style>
</head>
<body>
    <!-- Bouton fermer fixe en haut à droite -->
    <a href="maires_responsive.php" class="btn-close-page" title="Fermer">
        <i class="bi bi-x-lg"></i>
    </a>

    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="bi bi-question-circle me-2"></i>Centre d'aide</h1>
                    <p class="subtitle mb-0">Guide d'utilisation de l'Annuaire des Maires</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <!-- Navigation des sections -->
        <div class="section-nav">
            <?php if ($showAdmin): ?>
            <button class="section-nav-btn active" onclick="scrollToSection('admin')">
                <i class="bi bi-shield-lock"></i>
                <span>Administration</span>
            </button>
            <?php endif; ?>
            <?php if ($showReferent): ?>
            <button class="section-nav-btn <?= !$showAdmin ? 'active' : '' ?>" onclick="scrollToSection('referent')">
                <i class="bi bi-person-badge"></i>
                <span>Référents</span>
            </button>
            <?php endif; ?>
            <button class="section-nav-btn <?= !$showAdmin && !$showReferent ? 'active' : '' ?>" onclick="scrollToSection('membre')">
                <i class="bi bi-people"></i>
                <span>Membres</span>
            </button>
        </div>

        <?php if ($showAdmin): ?>
        <!-- Section Admin -->
        <div class="help-section" id="section-admin">
            <div class="section-header admin">
                <div class="section-icon admin">
                    <i class="bi bi-shield-lock"></i>
                </div>
                <div>
                    <h2 class="section-title">Administration</h2>
                    <p class="section-subtitle">Gestion globale de l'application et des utilisateurs</p>
                </div>
            </div>

            <div class="help-cards">
                <div class="help-card admin">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <h3 class="help-card-title">Gestion des utilisateurs</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Gérez les comptes utilisateurs de l'application :</p>
                        <ul>
                            <li>Créer de nouveaux utilisateurs (Référents, Membres)</li>
                            <li>Modifier les informations et mots de passe</li>
                            <li>Activer/désactiver des comptes</li>
                            <li>Attribuer des rôles et permissions</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card admin">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-geo-alt-fill"></i>
                        </div>
                        <h3 class="help-card-title">Attribution des cantons</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Assignez les cantons aux référents et membres :</p>
                        <ul>
                            <li>Sélectionnez un département</li>
                            <li>Cochez les cantons à attribuer</li>
                            <li>Un canton peut être attribué à plusieurs utilisateurs</li>
                            <li>Les communes sont automatiquement liées aux cantons</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card admin">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-diagram-3"></i>
                        </div>
                        <h3 class="help-card-title">Rapport Admin</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Vue globale de l'avancement par département :</p>
                        <ul>
                            <li>Arborescence des départements avec progression</li>
                            <li>Liste des référents et membres par département</li>
                            <li>Statistiques détaillées par statut</li>
                            <li>Export CSV des données</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card admin">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                        <h3 class="help-card-title">Rapport Référents</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Suivi détaillé de l'équipe terrain :</p>
                        <ul>
                            <li>Progression par département</li>
                            <li>Performance individuelle des référents</li>
                            <li>Détail des communes traitées</li>
                            <li>Filtrage par département</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="tip-box">
                <i class="bi bi-lightbulb-fill"></i>
                <div class="tip-box-content">
                    <strong>Astuce :</strong> Utilisez le bouton "Export CSV" dans les rapports pour générer des fichiers compatibles Excel et effectuer des analyses personnalisées.
                </div>
            </div>
        </div>
        <?php endif; ?>

        <?php if ($showReferent): ?>
        <!-- Section Référent -->
        <div class="help-section" id="section-referent">
            <div class="section-header referent">
                <div class="section-icon referent">
                    <i class="bi bi-person-badge"></i>
                </div>
                <div>
                    <h2 class="section-title">Référents</h2>
                    <p class="section-subtitle">Coordination et suivi des équipes terrain</p>
                </div>
            </div>

            <div class="help-cards">
                <div class="help-card referent">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-card-checklist"></i>
                        </div>
                        <h3 class="help-card-title">Suivi des membres</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Supervisez l'avancement de vos membres :</p>
                        <ul>
                            <li>Consultez la progression de chaque membre</li>
                            <li>Visualisez les communes assignées</li>
                            <li>Suivez les statuts de démarchage</li>
                            <li>Identifiez les communes en retard</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card referent">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <h3 class="help-card-title">Gestion de votre équipe</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Gérez les membres de vos cantons :</p>
                        <ul>
                            <li>Visualisez les membres de votre zone</li>
                            <li>Consultez leurs coordonnées</li>
                            <li>Ajoutez des commentaires internes</li>
                            <li>Suivez leur activité</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card referent">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-graph-up"></i>
                        </div>
                        <h3 class="help-card-title">Vos statistiques</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Accédez à vos indicateurs de performance :</p>
                        <ul>
                            <li>Nombre de communes traitées</li>
                            <li>Taux de progression par canton</li>
                            <li>Répartition des statuts</li>
                            <li>Comparaison avec les objectifs</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card referent">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-journal-text"></i>
                        </div>
                        <h3 class="help-card-title">Rapport d'activité</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Générez des rapports pour vos cantons :</p>
                        <ul>
                            <li>Accédez au Rapport Référents</li>
                            <li>Filtrez par votre département</li>
                            <li>Exportez les données en CSV</li>
                            <li>Partagez avec votre équipe</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="tip-box">
                <i class="bi bi-lightbulb-fill"></i>
                <div class="tip-box-content">
                    <strong>Astuce :</strong> Dans le rapport, cliquez sur <span class="highlight">[voir X]</span> pour afficher toutes les communes d'un référent/membre, organisées par circonscription.
                </div>
            </div>
        </div>
        <?php endif; ?>

        <!-- Section Membre -->
        <div class="help-section" id="section-membre">
            <div class="section-header membre">
                <div class="section-icon membre">
                    <i class="bi bi-people"></i>
                </div>
                <div>
                    <h2 class="section-title">Membres</h2>
                    <p class="section-subtitle">Démarchage et suivi des communes</p>
                </div>
            </div>

            <div class="help-cards">
                <div class="help-card membre">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-list-ul"></i>
                        </div>
                        <h3 class="help-card-title">Liste des maires</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Accédez à vos communes assignées :</p>
                        <ul>
                            <li><strong>Vue classique :</strong> tableau complet avec toutes les colonnes</li>
                            <li><strong>Vue responsive :</strong> fiches adaptées au mobile</li>
                            <li>Filtrez par département, canton, statut</li>
                            <li>Recherchez par nom de commune ou maire</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card membre">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <h3 class="help-card-title">Modifier une fiche</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Mettez à jour les informations d'un maire :</p>
                        <ul>
                            <li>Cliquez sur l'icône <span class="icon-example"><i class="bi bi-pencil"></i> modifier</span></li>
                            <li>Complétez les coordonnées (téléphone, email)</li>
                            <li>Changez le statut de démarchage</li>
                            <li>Ajoutez un commentaire</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card membre">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-tag-fill"></i>
                        </div>
                        <h3 class="help-card-title">Statuts de démarchage</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Utilisez les statuts pour suivre l'avancement :</p>
                        <div class="legend-grid">
                            <div class="legend-item">
                                <span class="icon">⚪</span>
                                <span>Non traitée</span>
                            </div>
                            <div class="legend-item">
                                <span class="icon">📞</span>
                                <span>Démarchage en cours</span>
                            </div>
                            <div class="legend-item">
                                <span class="icon">📅</span>
                                <span>RDV obtenu</span>
                            </div>
                            <div class="legend-item">
                                <span class="icon">🚫</span>
                                <span>Sans suite</span>
                            </div>
                            <div class="legend-item">
                                <span class="icon">👍</span>
                                <span>Promesse obtenue</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="help-card membre">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-funnel-fill"></i>
                        </div>
                        <h3 class="help-card-title">Filtres avancés</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Affinez votre liste de communes :</p>
                        <ul>
                            <li><strong>Par population :</strong> communes &lt; <?= $GLOBALS['filtreHabitants'] ?> hab.</li>
                            <li><strong>Par statut :</strong> non traitées, en cours, etc.</li>
                            <li><strong>Par canton :</strong> vos cantons assignés</li>
                            <li><strong>Recherche :</strong> nom de commune ou maire</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card membre">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-telephone-fill"></i>
                        </div>
                        <h3 class="help-card-title">Appel rapide</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Sur mobile, appelez directement depuis l'application :</p>
                        <ul>
                            <li>Cliquez sur le numéro de téléphone</li>
                            <li>L'appel se lance automatiquement</li>
                            <li>Après l'appel, mettez à jour le statut</li>
                        </ul>
                    </div>
                </div>

                <div class="help-card membre">
                    <div class="help-card-header">
                        <div class="help-card-icon">
                            <i class="bi bi-eye-fill"></i>
                        </div>
                        <h3 class="help-card-title">Icônes de permission</h3>
                    </div>
                    <div class="help-card-content">
                        <p>Dans les filtres, identifiez vos droits :</p>
                        <div class="legend-grid">
                            <div class="legend-item">
                                <i class="bi bi-pencil-fill text-primary"></i>
                                <span>Lecture et écriture</span>
                            </div>
                            <div class="legend-item">
                                <i class="bi bi-eye-fill text-secondary"></i>
                                <span>Consultation seule</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tip-box">
                <i class="bi bi-lightbulb-fill"></i>
                <div class="tip-box-content">
                    <strong>Astuce :</strong> Utilisez la vue "Responsive" sur mobile pour une navigation optimisée avec des fiches swipables et un accès rapide aux actions.
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function scrollToSection(section) {
            const element = document.getElementById('section-' + section);
            if (element) {
                const headerHeight = document.querySelector('.page-header').offsetHeight;
                const navHeight = document.querySelector('.section-nav').offsetHeight;
                const offset = headerHeight + navHeight + 20;

                window.scrollTo({
                    top: element.offsetTop - offset,
                    behavior: 'smooth'
                });

                // Mettre à jour le bouton actif
                document.querySelectorAll('.section-nav-btn').forEach(btn => {
                    btn.classList.remove('active');
                });
                event.target.closest('.section-nav-btn').classList.add('active');
            }
        }

        // Mise à jour du bouton actif au scroll
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('.help-section');
            const navButtons = document.querySelectorAll('.section-nav-btn');
            const headerHeight = document.querySelector('.page-header').offsetHeight;
            const navHeight = document.querySelector('.section-nav').offsetHeight;

            let current = '';

            sections.forEach(section => {
                const sectionTop = section.offsetTop - headerHeight - navHeight - 100;
                if (window.scrollY >= sectionTop) {
                    current = section.getAttribute('id').replace('section-', '');
                }
            });

            navButtons.forEach(btn => {
                btn.classList.remove('active');
                if (btn.textContent.toLowerCase().includes(current) ||
                    (current === 'admin' && btn.textContent.includes('Administration')) ||
                    (current === 'referent' && btn.textContent.includes('Référents')) ||
                    (current === 'membre' && btn.textContent.includes('Membres'))) {
                    btn.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>
