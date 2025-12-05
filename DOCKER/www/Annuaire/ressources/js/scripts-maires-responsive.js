/**
 * SCRIPTS RESPONSIVE MOBILE-FIRST
 * Optimisé pour consultation tactile sur téléphone
 * Utilise Bootstrap 5.3 et API natives
 */

(function() {
    'use strict';

    // ==========================================
    // DÉTECTION IFRAME
    // ==========================================
    const isInIframe = window.self !== window.top;
    if (isInIframe) {
        document.body.classList.add('in-iframe');
    }

    // ==========================================
    // CONFIGURATION
    // ==========================================
    const CONFIG = {
        // Statuts de démarchage avec leurs labels et styles
        STATUTS_DEMARCHAGE: {
            0: { label: '', icon: '', style: '' },
            1: { label: 'Démarchage en cours', icon: '📞', style: 'background-color: #d3d3d3;' },
            2: { label: 'Rendez-vous obtenu', icon: '📅', style: 'background-color: #28a745; color: white; font-weight: bold;' },
            3: { label: 'Démarchage terminé (sans suite)', icon: '🚫', style: 'color: red; text-decoration: line-through;' },
            4: { label: 'Promesse de parrainage', icon: '👍', style: 'background-color: #e6d5f5; font-weight: bold;' }
        }
    };

    // ==========================================
    // ÉTAT GLOBAL
    // ==========================================
    const AppState = {
        currentRegion: '',
        currentDepartement: '',
        currentPage: 1,
        currentMaireId: null,
        currentMairesData: [],
        lastScrollPosition: 0,
        isLoading: false
    };

    // ==========================================
    // UTILITAIRES
    // ==========================================

    // Échapper HTML pour sécurité
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Afficher un toast/notification
    function showToast(message, type = 'info') {
        // Utiliser Bootstrap Toast si disponible, sinon alert simple
        console.log(`[${type.toUpperCase()}] ${message}`);
        // TODO: Implémenter toast Bootstrap si nécessaire
    }

    // Débounce pour optimiser les recherches
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    // ==========================================
    // NAVBAR SHRINK ON SCROLL
    // ==========================================

    const navbar = document.querySelector('.navbar');
    let lastScrollY = window.scrollY;
    let scrollThreshold = 50; // Pixels de scroll avant activation

    function handleNavbarScroll() {
        const currentScrollY = window.scrollY;

        if (currentScrollY > scrollThreshold) {
            navbar?.classList.add('navbar-compact');
        } else {
            navbar?.classList.remove('navbar-compact');
        }

        lastScrollY = currentScrollY;
    }

    // Throttle pour optimisation performance
    let navbarScrollTimeout;
    window.addEventListener('scroll', () => {
        if (!navbarScrollTimeout) {
            navbarScrollTimeout = setTimeout(() => {
                handleNavbarScroll();
                navbarScrollTimeout = null;
            }, 10);
        }
    }, { passive: true });

    // ==========================================
    // MENU SIDEBAR
    // ==========================================

    const menuToggle = document.getElementById('menuToggle');
    const sidebarMenu = document.getElementById('sidebarMenu');
    // Utiliser getOrCreateInstance pour préserver l'état 'show' défini en PHP
    const bsSidebar = bootstrap.Offcanvas.getOrCreateInstance(sidebarMenu);

    menuToggle?.addEventListener('click', () => {
        bsSidebar.show();
    });

    // ==========================================
    // PANNEAU DE RECHERCHE
    // ==========================================

    const searchToggle = document.getElementById('searchToggle');
    const searchPanel = document.getElementById('searchPanel');
    const searchOverlay = document.getElementById('searchOverlay');
    const searchClose = document.getElementById('searchClose');

    function openSearch() {
        searchPanel.classList.add('active');
        searchOverlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeSearch() {
        searchPanel.classList.remove('active');
        searchOverlay.classList.remove('active');
        document.body.style.overflow = '';
    }

    function toggleSearch() {
        if (searchPanel.classList.contains('active')) {
            closeSearch();
        } else {
            openSearch();
        }
    }

    searchToggle?.addEventListener('click', toggleSearch);
    searchClose?.addEventListener('click', closeSearch);
    searchOverlay?.addEventListener('click', closeSearch);

    // Fermer avec touche Escape
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && searchPanel.classList.contains('active')) {
            closeSearch();
        }
    });

    // ==========================================
    // GESTION DES RÉGIONS ET DÉPARTEMENTS
    // ==========================================

    // Charger les départements d'une région
    const regionsAccordion = document.getElementById('regionsAccordion');

    regionsAccordion?.addEventListener('shown.bs.collapse', function(event) {
        const button = event.target.previousElementSibling.querySelector('.accordion-button');
        const region = button?.getAttribute('data-region');
        const domtomRegions = button?.getAttribute('data-domtom-regions');
        const container = event.target.querySelector('[data-departements-container]');

        if (!container || container.hasChildNodes()) return;

        if (domtomRegions) {
            loadDomtomDepartements(JSON.parse(domtomRegions), container);
        } else if (region) {
            loadDepartements(region, container);
        }
    });

    // Charger départements d'une région
    // Filtre les résultats selon USER_FILTER pour référents/membres
    function loadDepartements(region, container) {
        container.innerHTML = '<div class="p-3 text-center"><div class="spinner-border spinner-border-sm text-primary"></div></div>';

        fetch(`api.php?action=getDepartements&region=${encodeURIComponent(region)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.departements) {
                    // Filtrer les départements selon les droits de l'utilisateur
                    let filteredDepts = data.departements;
                    if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
                        filteredDepts = data.departements.filter(dept =>
                            window.USER_FILTER.allowedDeptNumbers.includes(dept.numero_departement)
                        );
                    }

                    if (filteredDepts.length > 0) {
                        renderDepartements(filteredDepts, region, container);
                    } else {
                        container.innerHTML = '<div class="p-3 text-muted small">Aucun département autorisé</div>';
                    }
                } else {
                    container.innerHTML = '<div class="p-3 text-muted small">Aucun département</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                container.innerHTML = '<div class="p-3 text-danger small">Erreur de chargement</div>';
            });
    }

    // Charger départements DOM-TOM
    // Filtre les résultats selon USER_FILTER pour référents/membres
    function loadDomtomDepartements(regions, container) {
        container.innerHTML = '<div class="p-3 text-center"><div class="spinner-border spinner-border-sm text-primary"></div></div>';

        const promises = regions.map(region =>
            fetch(`api.php?action=getDepartements&region=${encodeURIComponent(region)}`)
                .then(response => response.json())
        );

        Promise.all(promises)
            .then(results => {
                let allDepts = results
                    .filter(data => data.success && data.departements)
                    .flatMap(data => data.departements.map(dept => ({
                        ...dept,
                        region: data.departements[0].region
                    })));

                // Filtrer les départements selon les droits de l'utilisateur
                if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
                    allDepts = allDepts.filter(dept =>
                        window.USER_FILTER.allowedDeptNumbers.includes(dept.numero_departement)
                    );
                }

                if (allDepts.length > 0) {
                    renderDepartements(allDepts, null, container);
                } else {
                    container.innerHTML = '<div class="p-3 text-muted small">Aucun département autorisé</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                container.innerHTML = '<div class="p-3 text-danger small">Erreur de chargement</div>';
            });
    }

    // Afficher les départements
    function renderDepartements(departements, region, container) {
        container.innerHTML = '';

        departements.forEach(dept => {
            const item = document.createElement('div');
            item.className = 'list-group-item d-flex justify-content-between align-items-center';

            // Partie gauche cliquable (nom du département)
            const deptLink = document.createElement('a');
            deptLink.href = '#';
            deptLink.className = 'text-decoration-none text-dark flex-grow-1';
            deptLink.innerHTML = `<span>${escapeHtml(dept.numero_departement)} - ${escapeHtml(dept.nom_departement)}</span>`;
            deptLink.addEventListener('click', (e) => {
                e.preventDefault();
                clearAllSearchFilters();
                loadMaires(dept.region || region, dept.numero_departement);
                bsSidebar.hide();
            });

            // Partie droite avec les icônes d'action
            const actionsDiv = document.createElement('div');
            actionsDiv.className = 'd-flex align-items-center gap-1';

            // Icône 1 : Communes traitées (rouge pastel)
            const btnTraitees = document.createElement('button');
            btnTraitees.className = 'btn btn-sm p-1 border-0';
            btnTraitees.style.cssText = 'width: 28px; height: 28px; border-radius: 4px; background: #f8d7da; color: #842029; border: 1px solid #f5c2c7;';
            btnTraitees.innerHTML = '<i class="bi bi-check2-all" style="font-size: 14px;"></i>';
            btnTraitees.title = 'Communes traitées';
            btnTraitees.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                loadCommunesTraiteesDept(dept.region || region, dept.numero_departement);
                bsSidebar.hide();
            });

            // Icône 2 : Mes fiches modifiables (vert pastel)
            const btnModifiables = document.createElement('button');
            btnModifiables.className = 'btn btn-sm p-1 border-0';
            btnModifiables.style.cssText = 'width: 28px; height: 28px; border-radius: 4px; background: #d1e7dd; color: #0f5132; border: 1px solid #badbcc;';
            btnModifiables.innerHTML = '<i class="bi bi-pencil-square" style="font-size: 14px;"></i>';
            btnModifiables.title = 'Mes fiches modifiables';
            btnModifiables.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                loadMesFichesModifiables(dept.region || region, dept.numero_departement);
                bsSidebar.hide();
            });

            // Badge du nombre de maires
            const badge = document.createElement('span');
            badge.className = 'badge bg-primary rounded-pill ms-1';
            badge.textContent = dept.nb_maires || 0;

            actionsDiv.appendChild(btnModifiables);
            actionsDiv.appendChild(btnTraitees);
            actionsDiv.appendChild(badge);

            item.appendChild(deptLink);
            item.appendChild(actionsDiv);
            container.appendChild(item);
        });
    }

    // Charger les communes traitées pour un département
    function loadCommunesTraiteesDept(region, departement) {
        console.log('loadCommunesTraiteesDept called:', region, departement);
        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        const params = new URLSearchParams({
            action: 'getMaires',
            region: region,
            departement: departement,
            filterDemarchage: '1',
            showAll: '1'
        });

        updateSearchHeader(`Communes traitées - Dép. ${departement}`);

        fetch(`api.php?${params.toString()}`)
            .then(response => response.json())
            .then(data => {
                console.log('loadCommunesTraiteesDept response:', data);
                AppState.isLoading = false;
                if (data.success && data.maires && data.maires.length > 0) {
                    AppState.currentMairesData = data.maires;
                    AppState.currentRegion = region;
                    AppState.currentDepartement = departement;
                    displayMairesCards(data);
                } else {
                    resultsContainer.innerHTML = '<div class="text-center py-4 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i>Aucune commune traitée dans ce département</div>';
                }
            })
            .catch(error => {
                console.error('loadCommunesTraiteesDept error:', error);
                AppState.isLoading = false;
                resultsContainer.innerHTML = '<div class="text-center py-4 text-danger">Erreur de chargement</div>';
            });
    }

    // Charger uniquement les fiches modifiables par l'utilisateur pour un département
    function loadMesFichesModifiables(region, departement) {
        console.log('loadMesFichesModifiables called:', region, departement);
        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        const params = new URLSearchParams({
            action: 'getMaires',
            region: region,
            departement: departement,
            showAll: '1'
        });

        updateSearchHeader(`Mes fiches modifiables - Dép. ${departement}`);

        fetch(`api.php?${params.toString()}`)
            .then(response => response.json())
            .then(data => {
                console.log('loadMesFichesModifiables response:', data);
                AppState.isLoading = false;
                if (data.success && data.maires) {
                    // Filtrer côté client pour ne garder que les fiches modifiables
                    let maires = data.maires;

                    // Si l'utilisateur est Référent (3) ou Membre (4), filtrer par cantons autorisés
                    if (window.USER_FILTER && (window.USER_FILTER.userType === 3 || window.USER_FILTER.userType === 4)) {
                        const writableCantons = window.USER_FILTER.writableCantons || [];
                        console.log('Filtering by writable cantons:', writableCantons);
                        maires = maires.filter(maire => {
                            const maireCanton = maire.canton || '';
                            return writableCantons.some(canton =>
                                canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                            );
                        });
                    }
                    // Admin (1, 2) voient tout - pas de filtre

                    AppState.currentMairesData = maires;
                    AppState.currentRegion = region;
                    AppState.currentDepartement = departement;

                    if (maires.length > 0) {
                        displayMairesCards({ success: true, maires: maires });
                    } else {
                        resultsContainer.innerHTML = '<div class="text-center py-4 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i>Aucune fiche modifiable dans ce département</div>';
                    }
                } else {
                    resultsContainer.innerHTML = '<div class="text-center py-4 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i>Aucun résultat</div>';
                }
            })
            .catch(error => {
                console.error('loadMesFichesModifiables error:', error);
                AppState.isLoading = false;
                resultsContainer.innerHTML = '<div class="text-center py-4 text-danger">Erreur de chargement</div>';
            });
    }

    // ==========================================
    // RÉINITIALISATION DES FILTRES
    // ==========================================

    function clearAllSearchFilters() {
        const searchRegion = document.getElementById('searchRegion');
        const searchDepartement = document.getElementById('searchDepartement');
        const searchCanton = document.getElementById('searchCanton');
        const searchCommune = document.getElementById('searchCommune');
        const searchNbHabitants = document.getElementById('searchNbHabitants');

        if (searchRegion) searchRegion.value = '';
        if (searchDepartement) searchDepartement.value = '';
        if (searchCanton) searchCanton.value = '';
        if (searchCommune) searchCommune.value = '';
        if (searchNbHabitants) searchNbHabitants.value = '';
    }

    // ==========================================
    // EN-TÊTE DE RECHERCHE (avec plier/déplier)
    // ==========================================

    // État du bandeau de recherche
    let searchHeaderCollapsed = false;

    function updateSearchHeader(searchText) {
        let searchHeader = document.getElementById('searchHeader');
        if (!searchHeader) {
            searchHeader = document.createElement('div');
            searchHeader.id = 'searchHeader';
            searchHeader.className = 'search-header-info';
            const mainContent = document.querySelector('.main-content');
            mainContent.insertBefore(searchHeader, mainContent.firstChild);
        }

        // Icône de chevron selon l'état
        const chevronIcon = searchHeaderCollapsed ? 'bi-chevron-down' : 'bi-chevron-up';

        // Bouton menu pour mode iframe
        const menuBtn = isInIframe ? `<button class="btn-menu-inline" id="menuToggleInline" type="button" aria-label="Menu"><i class="bi bi-list"></i></button>` : '';

        searchHeader.innerHTML = `
            ${menuBtn}
            <div class="search-header-content" style="cursor: pointer; display: flex; align-items: center; gap: 8px; flex: 1;" onclick="toggleSearchHeader()">
                <i class="bi bi-funnel-fill"></i>
                <span class="search-header-text" style="${searchHeaderCollapsed ? 'white-space: nowrap; overflow: hidden; text-overflow: ellipsis; flex: 1;' : 'flex: 1;'}">${escapeHtml(searchText)}</span>
                <i class="bi ${chevronIcon}" style="margin-left: auto;"></i>
            </div>
        `;
        searchHeader.style.display = 'flex';

        // Attacher l'événement au bouton menu inline
        const menuToggleInline = document.getElementById('menuToggleInline');
        if (menuToggleInline) {
            menuToggleInline.addEventListener('click', (e) => {
                e.stopPropagation();
                bsSidebar.show();
            });
        }

        // Appliquer le style plié si nécessaire
        if (searchHeaderCollapsed) {
            searchHeader.style.maxHeight = '40px';
            searchHeader.style.overflow = 'hidden';
        } else {
            searchHeader.style.maxHeight = 'none';
            searchHeader.style.overflow = 'visible';
        }
    }

    // Fonction globale pour plier/déplier le bandeau
    window.toggleSearchHeader = function() {
        searchHeaderCollapsed = !searchHeaderCollapsed;
        const searchHeader = document.getElementById('searchHeader');

        if (searchHeader) {
            const textSpan = searchHeader.querySelector('.search-header-text');
            const chevron = searchHeader.querySelector('.bi-chevron-up, .bi-chevron-down');

            if (searchHeaderCollapsed) {
                // Plier : une seule ligne avec ellipsis
                searchHeader.style.maxHeight = '40px';
                searchHeader.style.overflow = 'hidden';
                if (textSpan) {
                    textSpan.style.whiteSpace = 'nowrap';
                    textSpan.style.overflow = 'hidden';
                    textSpan.style.textOverflow = 'ellipsis';
                }
                if (chevron) {
                    chevron.classList.remove('bi-chevron-up');
                    chevron.classList.add('bi-chevron-down');
                }
            } else {
                // Déplier : afficher tout
                searchHeader.style.maxHeight = 'none';
                searchHeader.style.overflow = 'visible';
                if (textSpan) {
                    textSpan.style.whiteSpace = 'normal';
                    textSpan.style.overflow = 'visible';
                    textSpan.style.textOverflow = 'clip';
                }
                if (chevron) {
                    chevron.classList.remove('bi-chevron-down');
                    chevron.classList.add('bi-chevron-up');
                }
            }

            // Ajuster la position du tableau
            adjustTablePosition();
        }
    };

    // Ajuster la position du tableau selon l'état du bandeau
    function adjustTablePosition() {
        const searchHeader = document.getElementById('searchHeader');
        const tableContainer = document.querySelector('#resultsContainer > div');

        if (searchHeader && tableContainer) {
            // En mode iframe: pas de navbar (0px), sinon navbar = 56px
            const navbarHeight = isInIframe ? 0 : 56;
            const headerHeight = searchHeader.offsetHeight;
            const topOffset = navbarHeight + headerHeight;
            tableContainer.style.top = topOffset + 'px';
            tableContainer.style.height = `calc(100vh - ${topOffset}px)`;
        }
    }

    function hideSearchHeader() {
        const searchHeader = document.getElementById('searchHeader');
        if (searchHeader) {
            searchHeader.style.display = 'none';
        }
    }

    // ==========================================
    // CHARGEMENT DES MAIRES
    // ==========================================

    function loadMaires(region, departement, page = 1) {
        console.log('=== loadMaires called ===');
        console.log('Region:', region);
        console.log('Departement:', departement);
        console.log('Page:', page);

        if (AppState.isLoading) return;

        AppState.isLoading = true;
        AppState.currentRegion = region;
        AppState.currentDepartement = departement;
        AppState.currentPage = page;

        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';


        // Afficher l'en-tête de recherche
        updateSearchHeader(`${region} - Dép. ${departement}`);

        const params = new URLSearchParams({
            action: 'getMaires',
            region: region,
            departement: departement,
            page: page,
            showAll: '1'
        });

        // Appliquer le filtre habitants si défini (par défaut < filtreHabitants)
        if (FilterState.habitants) {
            params.append('nbHabitants', FilterState.habitants);
        }

        console.log('Fetching API with URL:', `api.php?${params.toString()}`);

        fetch(`api.php?${params.toString()}`)
            .then(response => {
                console.log('Response status:', response.status);
                return response.json();
            })
            .then(data => {
                AppState.isLoading = false;
                if (data.success && data.maires) {
                    // Mettre à jour l'en-tête avec le nombre de résultats
                    updateSearchHeader(`${region} - Dép. ${departement} (${data.maires.length} communes)`);
                    displayMairesCards(data);
                } else {
                    resultsContainer.innerHTML = '<div class="alert alert-warning m-3">Aucun maire trouvé</div>';
                }
            })
            .catch(error => {
                AppState.isLoading = false;
                console.error('Erreur catch:', error);
                resultsContainer.innerHTML = '<div class="alert alert-danger m-3">Erreur de chargement</div>';
            });
    }

    // ==========================================
    // AFFICHAGE DES MAIRES EN TABLEAU
    // ==========================================

    function displayMairesCards(data) {
        console.log('=== displayMairesCards called ===');
        console.log('Data:', data);

        const resultsContainer = document.getElementById('resultsContainer');
        console.log('resultsContainer:', resultsContainer);

        if (!data.maires || data.maires.length === 0) {
            console.log('No maires in data, showing empty message');
            resultsContainer.innerHTML = '<div class="alert alert-info m-3">Aucun maire trouvé</div>';
            return;
        }

        console.log('Displaying', data.maires.length, 'maires');

        // Sauvegarder les données
        AppState.currentMairesData = data.maires;

        // Construire le tableau avec le même style que la version desktop
        // navbar = 56px (sauf iframe), searchHeader = 40px
        // En mode iframe: pas de navbar, donc top = 40px
        // En mode normal: navbar + searchHeader = 96px
        const tableTop = isInIframe ? '40px' : '96px';
        const tableHeight = isInIframe ? 'calc(100vh - 40px)' : 'calc(100vh - 96px)';
        let html = `<div style="overflow-x: auto; height: ${tableHeight}; overflow-y: auto; position: fixed; top: ${tableTop}; left: 0; right: 0; background: white;"><table style="width: 100%; border-collapse: collapse; background: white;">`;

        // En-tête du tableau (sticky)
        html += '<thead style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); color: white; position: sticky; top: 0; z-index: 10;">';
        html += '<tr>';
        html += '<th style="padding: 12px 8px; text-align: center; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); cursor: pointer;" onclick="openFiltresModal(event)"><i class="bi bi-three-dots-vertical"></i></th>';
        // Colonne icône accès pour tous les utilisateurs authentifiés (types 1, 2, 3, 4)
        if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
            html += '<th style="padding: 12px 4px; text-align: center; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); width: 30px;"><i class="bi bi-lock" title="Accès"></i></th>';
        }
        html += '<th style="padding: 12px 8px; text-align: center; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Circo</th>';
        html += '<th style="padding: 12px 8px; text-align: left; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Canton</th>';
        html += '<th style="padding: 12px 8px; text-align: left; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Commune</th>';
        html += '<th style="padding: 12px 8px; text-align: right; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Hab.</th>';
        html += '</tr>';
        html += '</thead>';

        // Corps du tableau
        html += '<tbody>';
        data.maires.forEach(maire => {
            const statutDemarchage = parseInt(maire.statut_demarchage) || 0;
            const isChecked = statutDemarchage > 0 ? 'checked' : '';

            // Styles de ligne selon le statut
            let rowStyle = '';
            let textStyle = '';

            switch(statutDemarchage) {
                case 1: // Démarchage en cours - gris
                    rowStyle = 'background-color: #d3d3d3;';
                    break;
                case 2: // Rendez-vous obtenu - bleu pastel
                    rowStyle = 'background-color: #cfe2ff;';
                    break;
                case 3: // Démarchage terminé - rouge, barré
                    textStyle = 'color: red; text-decoration: line-through;';
                    break;
                case 4: // Promesse de parrainage - vert pastel, gras
                    rowStyle = 'background-color: #c8e6c9; font-weight: bold;';
                    textStyle = 'font-weight: bold;';
                    break;
            }

            // Icônes selon le statut
            let statusIcon = '';
            if (statutDemarchage === 1) {
                statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Démarchage en cours">📞</span>';
            } else if (statutDemarchage === 2) {
                statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Rendez-vous obtenu">📅</span>';
            } else if (statutDemarchage === 3) {
                statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Démarchage terminé">🚫</span>';
            } else if (statutDemarchage === 4) {
                statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Promesse de parrainage">👍</span>';
            }

            // Déterminer si la fiche est en écriture ou consultation selon le type d'utilisateur
            // Admin Gén (1) et Admin (2) : écriture sur tout
            // Référent (3) et Membre (4) : écriture uniquement sur leurs cantons autorisés
            let accessIcon = '';
            let isWritable = true; // Par défaut écriture
            if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
                const userType = window.USER_FILTER.userType;

                if (userType === 1 || userType === 2) {
                    // Admin Gén et Admin : écriture sur toutes les fiches
                    isWritable = true;
                    accessIcon = '<i class="bi bi-pencil-fill" style="font-size: 12px; color: #28a745;" title="Écriture - Admin"></i>';
                } else if (userType === 3 || userType === 4) {
                    // Référent et Membre : vérifier les cantons autorisés
                    const maireCanton = maire.canton || '';
                    const writableCantons = window.USER_FILTER.writableCantons || [];
                    isWritable = writableCantons.some(canton =>
                        canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                    );
                    if (isWritable) {
                        accessIcon = '<i class="bi bi-pencil-fill" style="font-size: 12px; color: #28a745;" title="Écriture - Vous pouvez modifier cette fiche"></i>';
                    } else {
                        accessIcon = '<i class="bi bi-lock-fill" style="font-size: 12px; color: #6c757d;" title="Consultation uniquement"></i>';
                    }
                }
            }

            html += `<tr data-maire-id="${maire.id}" data-writable="${isWritable}" style="${rowStyle} cursor: pointer; border-bottom: 1px solid #e9ecef;" onclick="openMaireModal(${maire.id})">`;
            html += `<td style="padding: 6px 4px; text-align: left; white-space: nowrap; font-size: 0.85rem;"><input type="checkbox" ${isChecked} disabled style="pointer-events: none; width: 15px; height: 15px; margin: 0; vertical-align: middle;">${statusIcon}</td>`;
            // Colonne icône accès pour tous les utilisateurs authentifiés
            if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
                html += `<td style="padding: 6px 4px; text-align: center; font-size: 0.85rem;">${accessIcon}</td>`;
            }
            html += `<td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem; text-align: center;">${escapeHtml((maire.circonscription || 'N/A').replace(/\D/g, '') || 'N/A')}</td>`;
            html += `<td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem;">${escapeHtml(maire.canton || 'N/A')}</td>`;
            html += `<td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem; font-weight: 500;">${escapeHtml(maire.ville)}</td>`;
            html += `<td style="padding: 10px 8px; text-align: right; ${textStyle} font-size: 0.85rem;">${maire.nombre_habitants ? parseInt(maire.nombre_habitants).toLocaleString('fr-FR') : 'N/A'}</td>`;
            html += '</tr>';
        });
        html += '</tbody>';
        html += '</table></div>';

        // Ajouter pagination
        if (data.totalPages > 1) {
            html += `
                <div class="pagination-mobile">
                    <button class="btn btn-outline-primary btn-sm"
                            onclick="changePage(${data.page - 1})"
                            ${data.page <= 1 ? 'disabled' : ''}>
                        <i class="bi bi-chevron-left"></i> Préc.
                    </button>
                    <span class="page-info">${data.page} / ${data.totalPages}</span>
                    <button class="btn btn-outline-primary btn-sm"
                            onclick="changePage(${data.page + 1})"
                            ${data.page >= data.totalPages ? 'disabled' : ''}>
                        Suiv. <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
            `;
        }


        console.log('Setting resultsContainer.innerHTML, HTML length:', html.length);
        resultsContainer.innerHTML = html;
        console.log('innerHTML set successfully');

        // Scroll vers le haut
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // ==========================================
    // MODAL MAIRE
    // ==========================================

    const maireModal = document.getElementById('maireModal');
    const bsMaireModal = new bootstrap.Modal(maireModal);

    window.openMaireModal = function(maireId) {
        AppState.currentMaireId = maireId;

        const modalBody = document.getElementById('modalBody');
        const modalTitle = document.getElementById('modalTitle');
        const modalActions = document.getElementById('modalActions');

        modalBody.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary"></div></div>';
        modalTitle.textContent = 'Chargement...';
        modalActions.innerHTML = '';

        bsMaireModal.show();

        fetch(`api.php?action=getMaireDetails&id=${maireId}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.maire) {
                    renderMaireModal(data.maire);
                } else {
                    modalBody.innerHTML = '<div class="alert alert-warning">Maire non trouvé</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                modalBody.innerHTML = '<div class="alert alert-danger">Erreur de chargement</div>';
            });
    };

    function renderMaireModal(maire) {
        const modalTitle = document.getElementById('modalTitle');
        const modalBody = document.getElementById('modalBody');
        const modalActions = document.getElementById('modalActions');

        // Déterminer si l'utilisateur a le droit d'écriture sur cette fiche
        // Admin Gén (1) et Admin (2) : écriture sur tout
        // Référent (3) et Membre (4) : écriture uniquement sur leurs cantons autorisés
        let isReadOnly = false;
        if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
            const userType = window.USER_FILTER.userType;

            if (userType === 1 || userType === 2) {
                // Admin Gén et Admin : écriture sur toutes les fiches
                isReadOnly = false;
            } else if (userType === 3 || userType === 4) {
                // Référent et Membre : vérifier les cantons autorisés
                const maireCanton = maire.canton || '';
                const writableCantons = window.USER_FILTER.writableCantons || [];
                const isWritable = writableCantons.some(canton =>
                    canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                );
                isReadOnly = !isWritable;
            }
        }

        // IMPORTANT: Enrichir avec les données de démarchage depuis AppState
        // car getMaireDetails ne retourne pas les données de démarchage
        const maireFromState = AppState.currentMairesData.find(m => m.id == maire.id);
        if (maireFromState) {
            // Récupérer rdv_date brut (peut être datetime "2025-11-20 14:30:00" ou juste date)
            let rdvDateRaw = maireFromState.rdv_date || maireFromState.demarche_data?.rdv_date || '';
            let rdvDate = '';
            let rdvTime = '';

            if (rdvDateRaw) {
                // Parser le datetime si format "YYYY-MM-DD HH:MM:SS"
                const parts = rdvDateRaw.split(' ');
                rdvDate = parts[0] || '';
                if (parts[1]) {
                    // Extraire HH:MM de HH:MM:SS
                    rdvTime = parts[1].substring(0, 5);
                }
            }

            // Copier les données de démarchage
            maire.demarche_data = {
                statut_demarchage: maireFromState.statut_demarchage || maireFromState.demarche_data?.statut_demarchage || 0,
                demarche_active: maireFromState.demarche_active || maireFromState.demarche_data?.demarche_active || 0,
                parrainage_obtenu: maireFromState.parrainage_obtenu || maireFromState.demarche_data?.parrainage_obtenu || 0,
                rdv_date: rdvDate,
                rdv_time: rdvTime,
                commentaire: maireFromState.commentaire || maireFromState.demarche_data?.commentaire || ''
            };
        }

        // Titre - récupérer nombre_habitants depuis AppState si non présent
        const nombreHabitants = maire.nombre_habitants || (maireFromState ? maireFromState.nombre_habitants : null);
        const cantonText = maire.canton ? ` • ${escapeHtml(maire.canton)}` : '';
        const habitantsText = nombreHabitants ? ` (${parseInt(nombreHabitants).toLocaleString('fr-FR')} hab.)` : '';
        modalTitle.innerHTML = `
            <div>${escapeHtml(maire.ville)} - ${maire.code_postal || ''}${habitantsText}</div>
            <small class="d-block mt-1 opacity-75" style="font-size: 0.8rem;">
                ${escapeHtml(maire.region)} • ${escapeHtml(maire.circonscription || 'N/A')}${cantonText}
            </small>
        `;

        // Corps - Bloc unique avec Maire, Téléphone et Email
        modalBody.innerHTML = `
            <div style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-radius: 12px; padding: 16px; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                    <div style="width: 50px; height: 50px; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="bi bi-person-fill" style="color: white; font-size: 1.5rem;"></i>
                    </div>
                    <div>
                        <div style="font-size: 0.7rem; color: #6c757d; text-transform: uppercase; letter-spacing: 0.5px;">Maire</div>
                        <div style="font-weight: 700; font-size: 1.2rem; color: #212529;">${escapeHtml(maire.nom_maire || 'Non renseigné')}</div>
                    </div>
                </div>

                <div style="border-top: 1px solid #dee2e6; padding-top: 12px; display: flex; flex-direction: column; gap: 10px;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style="width: 32px; height: 32px; background: #28a745; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-telephone-fill" style="color: white; font-size: 0.9rem;"></i>
                        </div>
                        <div style="flex: 1;">
                            ${maire.telephone
                                ? `<a href="tel:${escapeHtml(maire.telephone)}" style="color: #212529; text-decoration: none; font-weight: 500; font-size: 1rem;">${escapeHtml(maire.telephone)}</a>`
                                : '<span style="color: #6c757d; font-style: italic;">Non renseigné</span>'}
                        </div>
                    </div>

                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style="width: 32px; height: 32px; background: #dc3545; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-envelope-fill" style="color: white; font-size: 0.9rem;"></i>
                        </div>
                        <div style="flex: 1; overflow: hidden;">
                            ${maire.email
                                ? `<a href="mailto:${escapeHtml(maire.email)}" style="color: #212529; text-decoration: none; font-weight: 500; font-size: 0.95rem; word-break: break-all;">${escapeHtml(maire.email)}</a>`
                                : '<span style="color: #6c757d; font-style: italic;">Non renseigné</span>'}
                        </div>
                    </div>
                </div>
            </div>

            ${renderDemarchageForm(maire, isReadOnly)}
        `;

        // Actions
        modalActions.innerHTML = `
            ${maire.url_mairie ? `<a href="${escapeHtml(maire.url_mairie)}" target="_blank" class="btn btn-outline-primary btn-sm flex-fill"><i class="bi bi-globe"></i> Site</a>` : ''}
            ${maire.lien_google_maps ? `<a href="${escapeHtml(maire.lien_google_maps)}" target="_blank" class="btn btn-outline-success btn-sm flex-fill"><i class="bi bi-map"></i> Maps</a>` : ''}
            ${maire.lien_waze ? `<a href="${escapeHtml(maire.lien_waze)}" target="_blank" class="btn btn-outline-info btn-sm flex-fill"><i class="bi bi-signpost"></i> Waze</a>` : ''}
        `;
    }

    // Fonction helper pour générer les options du select statut démarchage
    function buildStatutDemarchageOptions(currentStatut) {
        let options = '<option value="0">-- Sélectionner --</option>';
        // Statuts 1, 2, 3
        for (let i = 1; i <= 3; i++) {
            const statut = CONFIG.STATUTS_DEMARCHAGE[i];
            const selected = currentStatut == i ? 'selected' : '';
            options += `<option value="${i}" style="${statut.style}" ${selected}>${statut.label}</option>`;
        }
        // Séparateur
        options += '<option disabled>──────────</option>';
        // Statut 4 (Promesse de parrainage)
        const statut4 = CONFIG.STATUTS_DEMARCHAGE[4];
        const selected4 = currentStatut == 4 ? 'selected' : '';
        options += `<option value="4" style="${statut4.style}" ${selected4}>${statut4.label}</option>`;
        return options;
    }

    // readOnly: si true, les champs sont désactivés (mode consultation pour les membres)
    function renderDemarchageForm(maire, readOnly = false) {
        const demarche = maire.demarche_data || {};
        const currentStatut = demarche.statut_demarchage || 0;
        const disabledAttr = readOnly ? 'disabled' : '';
        const readOnlyStyle = readOnly ? 'opacity: 0.7; cursor: not-allowed;' : '';
        const borderColor = readOnly ? '#6c757d' : '#17a2b8';
        const labelColor = readOnly ? '#6c757d' : '#17a2b8';

        // Bannière mode consultation
        const readOnlyBanner = readOnly ? `
            <div style="background: #fff3cd; border: 1px solid #ffc107; border-radius: 4px; padding: 8px 12px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                <i class="bi bi-eye-fill" style="color: #856404; font-size: 16px;"></i>
                <span style="color: #856404; font-size: 13px; font-weight: 500;">Mode consultation - Vous ne pouvez pas modifier cette fiche</span>
            </div>
        ` : '';

        // Bouton Enregistrer (masqué en mode consultation)
        const saveButton = readOnly ? '' : `
            <div style="display: flex; justify-content: flex-end;">
                <button type="button" onclick="saveDemarcheData()" style="padding: 10px 20px; background: #17a2b8; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer;">
                    Enregistrer
                </button>
            </div>
        `;

        return `
            <div style="position: relative; border: 2px solid ${borderColor}; border-radius: 8px; padding: 20px 12px 12px 12px; margin-top: 20px; ${readOnlyStyle}">
                <div style="position: absolute; top: -12px; left: 12px; background: white; padding: 0 8px;">
                    <label style="font-weight: 600; color: ${labelColor}; margin: 0; font-size: 0.9rem;">
                        Démarchage de parrainage ${readOnly ? '(consultation)' : ''}
                    </label>
                </div>

                <div id="demarcheFields">
                    ${readOnlyBanner}
                    <div style="margin-bottom: 12px;">
                        <select id="statutDemarchage" style="width: 100%; padding: 10px; border: 2px solid ${borderColor}; border-radius: 4px; font-size: 14px; font-weight: 600; background: white; ${readOnlyStyle}" ${disabledAttr}>
                            ${buildStatutDemarchageOptions(currentStatut)}
                        </select>
                    </div>

                    <div style="margin-bottom: 12px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                        <label style="font-weight: 500; white-space: nowrap;">RDV :</label>
                        <input type="date" id="rdvDate" value="${demarche.rdv_date || ''}" style="flex: 1; min-width: 130px; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; ${readOnlyStyle}" ${disabledAttr}>
                        <input type="time" id="rdvTime" value="${demarche.rdv_time || ''}" style="padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; width: 100px; ${readOnlyStyle}" ${disabledAttr}>
                    </div>

                    <div style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 500; margin-bottom: 5px;">Commentaire :</label>
                        <textarea id="commentaire" rows="6" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; resize: vertical; ${readOnlyStyle}" placeholder="Saisissez votre commentaire..." ${disabledAttr}>${escapeHtml(demarche.commentaire || '')}</textarea>
                    </div>

                    ${saveButton}
                </div>
            </div>
        `;
    }

    // ==========================================
    // SAUVEGARDE DÉMARCHAGE
    // ==========================================

    window.saveDemarcheData = function() {
        const maireCard = document.querySelector(`[data-maire-id="${AppState.currentMaireId}"]`);
        const maireCleUnique = AppState.currentMairesData.find(m => m.id == AppState.currentMaireId)?.cle_unique;

        if (!maireCleUnique) {
            alert('Erreur: Clé unique maire non trouvée');
            return;
        }

        const statutDemarchage = document.getElementById('statutDemarchage').value;
        const rdvDate = document.getElementById('rdvDate').value;
        const rdvTime = document.getElementById('rdvTime').value;
        const commentaire = document.getElementById('commentaire').value;

        // Déterminer demarche_active et parrainage_obtenu selon le statut
        let demarcheActive = 0;
        let parrainageObtenu = 0;

        if (statutDemarchage === '1' || statutDemarchage === '2' || statutDemarchage === '3') {
            demarcheActive = 1; // Démarchage actif (en cours, RDV obtenu ou terminé)
        } else if (statutDemarchage === '4') {
            demarcheActive = 1;
            parrainageObtenu = 1; // Promesse de parrainage
        }

        // Combiner date et heure
        let rdvDateTime = '';
        if (rdvDate) {
            rdvDateTime = rdvDate;
            if (rdvTime) {
                rdvDateTime += ' ' + rdvTime + ':00';
            } else {
                rdvDateTime += ' 00:00:00';
            }
        }

        const formData = new FormData();
        formData.append('action', 'saveDemarchage');
        formData.append('maire_cle_unique', maireCleUnique);
        formData.append('demarche_active', demarcheActive);
        formData.append('parrainage_obtenu', parrainageObtenu);
        formData.append('statut_demarchage', statutDemarchage);
        formData.append('rdv_date', rdvDateTime);
        formData.append('commentaire', commentaire);

        fetch('api.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Afficher notification de succès
                const notification = document.createElement('div');
                notification.style.cssText = 'position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #28a745; color: white; padding: 15px 30px; border-radius: 8px; font-weight: 600; z-index: 10000; box-shadow: 0 4px 12px rgba(0,0,0,0.3);';
                notification.textContent = 'Enregistré !';
                document.body.appendChild(notification);
                setTimeout(() => notification.remove(), 1500);

                // IMPORTANT: Mettre à jour les données locales pour que la fiche affiche les bonnes valeurs
                const maireIndex = AppState.currentMairesData.findIndex(m => m.id == AppState.currentMaireId);
                if (maireIndex !== -1) {
                    // Mettre à jour au niveau racine (c'est ce que displayMairesCards utilise)
                    AppState.currentMairesData[maireIndex].statut_demarchage = parseInt(statutDemarchage);
                    AppState.currentMairesData[maireIndex].demarche_active = demarcheActive;
                    AppState.currentMairesData[maireIndex].parrainage_obtenu = parrainageObtenu;
                    AppState.currentMairesData[maireIndex].rdv_date = rdvDateTime;
                    AppState.currentMairesData[maireIndex].commentaire = commentaire;

                    // Aussi dans demarche_data pour la modal
                    if (!AppState.currentMairesData[maireIndex].demarche_data) {
                        AppState.currentMairesData[maireIndex].demarche_data = {};
                    }
                    AppState.currentMairesData[maireIndex].demarche_data.statut_demarchage = parseInt(statutDemarchage);
                    AppState.currentMairesData[maireIndex].demarche_data.demarche_active = demarcheActive;
                    AppState.currentMairesData[maireIndex].demarche_data.parrainage_obtenu = parrainageObtenu;
                    AppState.currentMairesData[maireIndex].demarche_data.rdv_date = rdvDate;
                    AppState.currentMairesData[maireIndex].demarche_data.rdv_time = rdvTime;
                    AppState.currentMairesData[maireIndex].demarche_data.commentaire = commentaire;
                }

                // Mettre à jour la ligne du tableau - reconstruire la ligne complète
                const row = document.querySelector(`tr[data-maire-id="${AppState.currentMaireId}"]`);
                if (row && maireIndex !== -1) {
                    const maire = AppState.currentMairesData[maireIndex];
                    const statut = parseInt(statutDemarchage);
                    const isChecked = statut > 0 ? 'checked' : '';

                    // Styles de ligne selon le statut
                    let rowStyle = '';
                    let textStyle = '';
                    switch(statut) {
                        case 1: rowStyle = 'background-color: #d3d3d3;'; break;
                        case 2: rowStyle = 'background-color: #cfe2ff;'; break;
                        case 3: textStyle = 'color: red; text-decoration: line-through;'; break;
                        case 4: rowStyle = 'background-color: #c8e6c9; font-weight: bold;'; textStyle = 'font-weight: bold;'; break;
                    }

                    // Icône selon le statut
                    let statusIcon = '';
                    if (statut === 1) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Démarchage en cours">📞</span>';
                    else if (statut === 2) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Rendez-vous obtenu">📅</span>';
                    else if (statut === 3) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Démarchage terminé">🚫</span>';
                    else if (statut === 4) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Promesse de parrainage">👍</span>';

                    // Reconstruire le HTML de la ligne
                    row.style.cssText = rowStyle + ' cursor: pointer; border-bottom: 1px solid #e9ecef;';
                    row.innerHTML = `
                        <td style="padding: 6px 4px; text-align: left; white-space: nowrap; font-size: 0.85rem;"><input type="checkbox" ${isChecked} disabled style="pointer-events: none; width: 15px; height: 15px; margin: 0; vertical-align: middle;">${statusIcon}</td>
                        <td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem; text-align: center;">${escapeHtml((maire.circonscription || 'N/A').replace(/\D/g, '') || 'N/A')}</td>
                        <td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem;">${escapeHtml(maire.canton || 'N/A')}</td>
                        <td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem; font-weight: 500;">${escapeHtml(maire.ville)}</td>
                        <td style="padding: 10px 8px; text-align: right; ${textStyle} font-size: 0.85rem;">${maire.nombre_habitants ? parseInt(maire.nombre_habitants).toLocaleString('fr-FR') : 'N/A'}</td>
                    `;
                }

                // Fermer le modal
                bsMaireModal.hide();
            } else {
                alert('Erreur lors de l\'enregistrement');
            }
        })
        .catch(error => {
            alert('Erreur lors de l\'enregistrement');
        });
    };

    // ==========================================
    // RECHERCHE AVANCÉE
    // ==========================================

    const btnAdvancedSearch = document.getElementById('btnAdvancedSearch');

    // Gestion des interdépendances entre les champs de recherche
    const searchRegion = document.getElementById('searchRegion');
    const searchDepartement = document.getElementById('searchDepartement');
    const searchCanton = document.getElementById('searchCanton');
    const searchCommune = document.getElementById('searchCommune');

    // Filtrer les options en fonction de la région sélectionnée
    function filterOptionsByRegion() {
        const selectedRegion = searchRegion?.value || '';

        if (!selectedRegion) return;

        // Filtrer départements
        fetch(`api.php?action=getDepartements&region=${encodeURIComponent(selectedRegion)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.departements) {
                    const datalist = document.getElementById('departements-datalist');
                    datalist.innerHTML = '';
                    data.departements.forEach(dept => {
                        const option = document.createElement('option');
                        option.value = `${dept.numero_departement} - ${dept.nom_departement}`;
                        datalist.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Erreur filtrage départements:', error));

        // Filtrer cantons
        fetch(`api.php?action=getCantons&region=${encodeURIComponent(selectedRegion)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.cantons) {
                    const datalist = document.getElementById('cantons-datalist');
                    datalist.innerHTML = '';
                    data.cantons.forEach(canton => {
                        const option = document.createElement('option');
                        option.value = canton;
                        datalist.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Erreur filtrage cantons:', error));

        // Filtrer communes
        fetch(`api.php?action=getCommunes&region=${encodeURIComponent(selectedRegion)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.communes) {
                    const datalist = document.getElementById('communes-datalist');
                    datalist.innerHTML = '';
                    data.communes.forEach(commune => {
                        const option = document.createElement('option');
                        option.value = commune;
                        datalist.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Erreur filtrage communes:', error));
    }

    // Filtrer les cantons en fonction du département sélectionné
    function filterOptionsByDepartement() {
        const selectedDepartement = searchDepartement?.value || '';

        if (!selectedDepartement) return;

        // Extraire le numéro de département (ex: "60 - Oise" => "60")
        const deptMatch = selectedDepartement.match(/^(\d+)/);
        if (!deptMatch) return;

        const deptNumber = deptMatch[1];

        // Filtrer cantons par département
        fetch(`api.php?action=getCantons&departement=${encodeURIComponent(deptNumber)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.cantons) {
                    const datalist = document.getElementById('cantons-datalist');
                    datalist.innerHTML = '';
                    data.cantons.forEach(canton => {
                        const option = document.createElement('option');
                        option.value = canton;
                        datalist.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Erreur filtrage cantons par département:', error));

        // Filtrer communes par département
        fetch(`api.php?action=getCommunes&departement=${encodeURIComponent(deptNumber)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.communes) {
                    const datalist = document.getElementById('communes-datalist');
                    datalist.innerHTML = '';
                    data.communes.forEach(commune => {
                        const option = document.createElement('option');
                        option.value = commune;
                        datalist.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Erreur filtrage communes par département:', error));
    }

    function updateFieldsState() {
        const regionValue = searchRegion?.value || '';
        const departementValue = searchDepartement?.value || '';
        const cantonValue = searchCanton?.value || '';

        // Si Canton est rempli : désactiver Région et Département
        if (cantonValue) {
            if (searchRegion) {
                searchRegion.disabled = true;
                searchRegion.style.opacity = '0.5';
            }
            if (searchDepartement) {
                searchDepartement.disabled = true;
                searchDepartement.style.opacity = '0.5';
            }
        } else {
            if (searchRegion) {
                searchRegion.disabled = false;
                searchRegion.style.opacity = '1';
            }
            if (searchDepartement) {
                searchDepartement.disabled = false;
                searchDepartement.style.opacity = '1';
            }
        }
    }

    // Écouteurs d'événements pour mettre à jour l'état des champs
    searchRegion?.addEventListener('change', function() {
        // Effacer les autres champs quand on change de région
        if (searchDepartement) searchDepartement.value = '';
        if (searchCanton) searchCanton.value = '';
        if (searchCommune) searchCommune.value = '';
        if (document.getElementById('searchNbHabitants')) {
            document.getElementById('searchNbHabitants').value = '';
        }

        filterOptionsByRegion();
        updateFieldsState();
    });
    searchDepartement?.addEventListener('input', function() {
        // Effacer les champs canton et commune quand on change de département
        if (searchCanton) searchCanton.value = '';
        if (searchCommune) searchCommune.value = '';

        filterOptionsByDepartement();
        updateFieldsState();
    });
    searchCanton?.addEventListener('input', updateFieldsState);
    searchCommune?.addEventListener('input', updateFieldsState);

    // Gestion des boutons de suppression
    const clearRegionBtn = document.getElementById('clearRegion');
    const clearDepartementBtn = document.getElementById('clearDepartement');
    const clearCantonBtn = document.getElementById('clearCanton');
    const clearCommuneBtn = document.getElementById('clearCommune');

    // Afficher/masquer les boutons de suppression selon le contenu des champs
    function toggleClearButtons() {
        if (clearRegionBtn) {
            clearRegionBtn.style.display = searchRegion?.value ? 'block' : 'none';
        }
        if (clearDepartementBtn) {
            clearDepartementBtn.style.display = searchDepartement?.value ? 'block' : 'none';
        }
        if (clearCantonBtn) {
            clearCantonBtn.style.display = searchCanton?.value ? 'block' : 'none';
        }
        if (clearCommuneBtn) {
            clearCommuneBtn.style.display = searchCommune?.value ? 'block' : 'none';
        }
    }

    // Bouton de suppression Région - vide UNIQUEMENT DEPARTEMENT, CANTON, COMMUNE (garde REGION)
    clearRegionBtn?.addEventListener('click', function() {
        // NE PAS vider searchRegion
        if (searchDepartement) searchDepartement.value = '';
        if (searchCanton) searchCanton.value = '';
        if (searchCommune) searchCommune.value = '';
        toggleClearButtons();
        updateFieldsState();
    });

    // Bouton de suppression Département - vide UNIQUEMENT CANTON, COMMUNE (garde REGION et DEPARTEMENT)
    clearDepartementBtn?.addEventListener('click', function() {
        // NE PAS vider searchRegion ni searchDepartement
        if (searchCanton) searchCanton.value = '';
        if (searchCommune) searchCommune.value = '';
        toggleClearButtons();
        updateFieldsState();
    });

    // Bouton de suppression Canton - vide UNIQUEMENT COMMUNE (garde REGION, DEPARTEMENT et CANTON)
    clearCantonBtn?.addEventListener('click', function() {
        // NE PAS vider searchRegion, searchDepartement ni searchCanton
        if (searchCommune) searchCommune.value = '';
        toggleClearButtons();
        updateFieldsState();
    });

    // Bouton de suppression Commune
    clearCommuneBtn?.addEventListener('click', function() {
        if (searchCommune) searchCommune.value = '';
        toggleClearButtons();
        updateFieldsState();
    });

    // Mettre à jour la visibilité des boutons lors de la saisie
    searchRegion?.addEventListener('change', toggleClearButtons);
    searchDepartement?.addEventListener('input', toggleClearButtons);
    searchCanton?.addEventListener('input', toggleClearButtons);
    searchCommune?.addEventListener('input', toggleClearButtons);

    // Initialiser la visibilité des boutons
    toggleClearButtons();

    btnAdvancedSearch?.addEventListener('click', function() {
        performAdvancedSearch();
        closeSearch();
    });

    function performAdvancedSearch() {
        const region = document.getElementById('searchRegion').value;
        const departement = document.getElementById('searchDepartement').value;
        const canton = document.getElementById('searchCanton').value;
        const commune = document.getElementById('searchCommune').value;
        const nbHabitants = document.getElementById('searchNbHabitants').value;

        AppState.isLoading = true;
        AppState.currentPage = 1;

        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        // Construire le texte de recherche
        const searchParts = [];
        if (region) searchParts.push(`Région: ${region}`);
        if (departement) searchParts.push(`Dép.: ${departement}`);
        if (canton) searchParts.push(`Canton: ${canton}`);
        if (commune) searchParts.push(`Commune: ${commune}`);
        if (nbHabitants) searchParts.push(`Max ${nbHabitants} hab.`);

        updateSearchHeader(searchParts.length > 0 ? searchParts.join(' • ') : 'Recherche avancée');

        const params = new URLSearchParams({
            action: 'getMaires',
            page: 1,
            showAll: '1'
        });

        if (region) params.append('region', region);
        if (departement) params.append('departement', departement);
        if (canton) params.append('canton', canton);
        if (commune) params.append('commune', commune);
        if (nbHabitants) params.append('nbHabitants', nbHabitants);

        fetch(`api.php?${params.toString()}`)
            .then(response => response.json())
            .then(data => {
                AppState.isLoading = false;
                if (data.success && data.maires) {
                    displayMairesCards(data);
                } else {
                    resultsContainer.innerHTML = '<div class="alert alert-warning m-3">Aucun résultat</div>';
                }
            })
            .catch(error => {
                AppState.isLoading = false;
                console.error('Erreur:', error);
                resultsContainer.innerHTML = '<div class="alert alert-danger m-3">Erreur de recherche</div>';
            });
    }

    window.resetAdvancedSearch = function() {
        document.getElementById('searchRegion').value = '';
        document.getElementById('searchDepartement').value = '';
        document.getElementById('searchCanton').value = '';
        document.getElementById('searchCommune').value = '';
        document.getElementById('searchNbHabitants').value = '';

        // Réactiver tous les champs
        updateFieldsState();
    };

    // ==========================================
    // COMMUNES TRAITÉES
    // ==========================================

    window.toggleCommunesTraitees = function() {
        const isChecked = document.getElementById('communesTraitees').checked;

        AppState.isLoading = true;
        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        const params = new URLSearchParams({
            action: 'getMaires',
            filterDemarchage: '1',
            showAll: '1'
        });

        // Filtrer par les départements autorisés de l'utilisateur (référents/membres)
        if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
            // Envoyer tous les départements autorisés (pas de filtre région car multi-régions possible)
            params.append('departements', window.USER_FILTER.allowedDeptNumbers.join(','));
        } else {
            // Pour les admins : utiliser la sélection actuelle
            if (AppState.currentDepartement) {
                params.append('departement', AppState.currentDepartement);
            }
            if (AppState.currentRegion) {
                params.append('region', AppState.currentRegion);
            }
        }

        if (isChecked) {
            // Adapter le message selon le contexte
            let headerText = 'Communes traitées (démarchage actif)';
            if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
                headerText = `Communes traitées - Mes départements (${window.USER_FILTER.allowedDeptNumbers.join(', ')})`;
            } else if (AppState.currentDepartement) {
                headerText = `Communes traitées - Dép. ${AppState.currentDepartement}`;
            }
            updateSearchHeader(headerText);

            fetch(`api.php?${params.toString()}`)
                .then(response => response.json())
                .then(data => {
                    AppState.isLoading = false;
                    bsSidebar.hide();
                    if (data.success && data.maires && data.maires.length > 0) {
                        // Trier par statut : 4 (Promesse), 2 (RDV), 1 (En cours), 3 (Terminé)
                        const statutOrder = { 4: 1, 2: 2, 1: 3, 3: 4, 0: 5 };
                        data.maires.sort((a, b) => {
                            const orderA = statutOrder[a.statut_demarchage] || 5;
                            const orderB = statutOrder[b.statut_demarchage] || 5;
                            return orderA - orderB;
                        });
                        displayMairesCards(data);
                    } else {
                        resultsContainer.innerHTML = '<div class="alert alert-info m-3">Aucune commune traitée</div>';
                    }
                })
                .catch(error => {
                    AppState.isLoading = false;
                    resultsContainer.innerHTML = '<div class="alert alert-danger m-3">Erreur de chargement</div>';
                });
        } else {
            AppState.isLoading = false;
            hideSearchHeader();
            resultsContainer.innerHTML = `
                <div class="empty-state text-center py-5">
                    <i class="bi bi-search text-muted" style="font-size: 4rem;"></i>
                    <h5 class="mt-3 text-muted">Sélectionnez une région</h5>
                    <p class="text-muted small">Utilisez le menu ou la recherche</p>
                </div>
            `;
        }
    };

    // ==========================================
    // EXPORT CSV
    // ==========================================

    window.exportToExcel = function() {
        if (!confirm('Voulez-vous générer le fichier CSV ?')) {
            return;
        }

        if (!AppState.currentMairesData || AppState.currentMairesData.length === 0) {
            alert('Aucune donnée à exporter');
            return;
        }

        // Créer le CSV
        let csv = '\uFEFF'; // BOM UTF-8
        csv += 'Region;Departement;Circo;Canton;Commune;Nom du maire;Téléphone;Habitants;Démarchage actif;Parrainage obtenu;RDV;Commentaires\n';

        AppState.currentMairesData.forEach(maire => {
            const region = maire.region || '';
            const departement = `${maire.numero_departement || ''} ${maire.nom_departement || ''}`.trim();
            const circo = maire.circonscription || '';
            const canton = maire.canton || '';
            const commune = maire.ville || '';
            const nomMaire = maire.nom_maire || '';
            const telephone = maire.telephone || '';
            const habitants = maire.nombre_habitants || '';
            const demarchageActif = maire.demarche_active ? 'OUI' : 'NON';
            const parrainageObtenu = maire.parrainage_obtenu ? 'OUI' : 'NON';
            const rdv = maire.rdv_date || '';
            const commentaires = (maire.commentaire || '').replace(/"/g, '""');

            csv += `"${region}";"${departement}";"${circo}";"${canton}";"${commune}";"${nomMaire}";"${telephone}";"${habitants}";"${demarchageActif}";"${parrainageObtenu}";"${rdv}";"${commentaires}"\n`;
        });

        // Télécharger
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);

        const now = new Date();
        const dateStr = now.getFullYear() + '-' +
                      String(now.getMonth() + 1).padStart(2, '0') + '-' +
                      String(now.getDate()).padStart(2, '0') + '_' +
                      String(now.getHours()).padStart(2, '0') + '-' +
                      String(now.getMinutes()).padStart(2, '0');

        link.setAttribute('href', url);
        link.setAttribute('download', `export_maires_${dateStr}.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };

    // ==========================================
    // PAGINATION
    // ==========================================

    window.changePage = function(page) {
        if (page < 1 || AppState.isLoading) return;
        loadMaires(AppState.currentRegion, AppState.currentDepartement, page);
    };

    // ==========================================
    // MODE DÉPARTEMENT DIRECT
    // ==========================================

    if (window.DEPT_MODE && window.DEPT_MODE.enabled) {
        setTimeout(() => {
            loadMaires(window.DEPT_MODE.region, window.DEPT_MODE.numero);
        }, 100);
    }

    // ==========================================
    // OPTIMISATIONS PERFORMANCE
    // ==========================================

    // Lazy loading des images (si utilisé plus tard)
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    observer.unobserve(img);
                }
            });
        });

        document.querySelectorAll('img.lazy').forEach(img => imageObserver.observe(img));
    }

    // Désactiver will-change après animations
    setTimeout(() => {
        document.querySelectorAll('.maire-card, .search-panel, .offcanvas').forEach(el => {
            el.classList.add('loaded');
        });
    }, 2000);

    // ==========================================
    // MODAL FILTRES
    // ==========================================

    const filtresModal = document.getElementById('filtresModal');
    const bsFiltresModal = filtresModal ? new bootstrap.Modal(filtresModal) : null;

    // Récupérer le seuil d'habitants depuis la config globale (défini dans maires_responsive.php)
    const filtreHabitants = window.APP_CONFIG?.filtreHabitants || 1000;

    // État des filtres (par défaut < filtreHabitants)
    const FilterState = {
        circo: '',
        canton: '',
        commune: '',
        habitants: String(filtreHabitants)
    };

    // Ouvrir la modale de filtres
    window.openFiltresModal = function(event) {
        if (event) event.stopPropagation();
        if (bsFiltresModal) {
            // Restaurer les valeurs des filtres
            document.getElementById('filterCircoMobile').value = FilterState.circo;
            document.getElementById('filterCantonMobile').value = FilterState.canton;
            document.getElementById('filterCommuneMobile').value = FilterState.commune;
            document.getElementById('filterHabitantsMobile').value = FilterState.habitants;

            // Charger les cantons pour le filtre combo si un département est sélectionné
            if (AppState.currentDepartement) {
                loadCantonsForCombo();
            }

            bsFiltresModal.show();
        }
    };

    // Charger les cantons pour le filtre combo (filtrés < filtreHabitants)
    function loadCantonsForCombo() {
        const filterComboMobile = document.getElementById('filterComboMobile');

        if (!filterComboMobile) return;

        // Seuil d'habitants pour filtrer les cantons (utilise la config globale)
        filterComboMobile.innerHTML = `<option value="">-- Canton (communes < ${filtreHabitants} hab.) --</option>`;

        // Charger les cantons du département avec filtre < filtreHabitants
        fetch(`api.php?action=getCantons&departement=${encodeURIComponent(AppState.currentDepartement)}&maxHabitants=${filtreHabitants}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.cantons) {
                    data.cantons.forEach(canton => {
                        const option = document.createElement('option');
                        option.value = canton;
                        option.textContent = canton;
                        filterComboMobile.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Erreur chargement cantons:', error));
    }

    // Boutons d'action dans la modale
    document.getElementById('btnShowAllMobile')?.addEventListener('click', function() {
        // Réinitialiser les filtres et afficher tout
        FilterState.circo = '';
        FilterState.canton = '';
        FilterState.commune = '';
        FilterState.habitants = '';
        document.getElementById('filterCircoMobile').value = '';
        document.getElementById('filterCantonMobile').value = '';
        document.getElementById('filterCommuneMobile').value = '';
        document.getElementById('filterHabitantsMobile').value = '';

        if (AppState.currentRegion && AppState.currentDepartement) {
            loadMaires(AppState.currentRegion, AppState.currentDepartement);
        }
        bsFiltresModal.hide();
    });

    // Bouton "Communes traitées" - filtre les communes avec démarchage actif
    document.getElementById('btnFilterDemarchageMobile')?.addEventListener('click', function() {
        bsFiltresModal.hide();

        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        const params = new URLSearchParams();
        params.append('action', 'getMaires');
        params.append('filterDemarchage', '1');
        params.append('showAll', '1');

        // Si un département est sélectionné, filtrer dessus
        if (AppState.currentDepartement) {
            params.append('departement', AppState.currentDepartement);
            params.append('region', AppState.currentRegion);
            updateSearchHeader(`Communes traitées - Dép. ${AppState.currentDepartement}`);
        } else if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
            // Sinon utiliser les départements autorisés de l'utilisateur
            params.append('departements', window.USER_FILTER.allowedDeptNumbers.join(','));
            updateSearchHeader(`Communes traitées - Dép. ${window.USER_FILTER.allowedDeptNumbers.join(', ')}`);
        } else {
            alert('Veuillez d\'abord sélectionner un département.');
            return;
        }

        fetch(`api.php?${params.toString()}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.maires && data.maires.length > 0) {
                    // Trier par statut
                    const statutOrder = { 4: 1, 2: 2, 1: 3, 3: 4, 0: 5 };
                    data.maires.sort((a, b) => (statutOrder[a.statut_demarchage] || 5) - (statutOrder[b.statut_demarchage] || 5));
                    displayMairesCards(data);
                } else {
                    resultsContainer.innerHTML = '<div class="alert alert-info m-3">Aucune commune traitée</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                resultsContainer.innerHTML = '<div class="alert alert-danger m-3">Erreur de chargement</div>';
            });
    });

    // Bouton "Mes communes attitrées" - filtre les communes modifiables par l'utilisateur (avec le stylo)
    document.getElementById('btnMesCommunesMobile')?.addEventListener('click', function() {
        bsFiltresModal.hide();

        // Vérifier que l'utilisateur a des cantons en écriture
        if (!window.USER_FILTER || !window.USER_FILTER.writableCantons || window.USER_FILTER.writableCantons.length === 0) {
            alert('Vous n\'avez pas de communes attitrées en modification.');
            return;
        }

        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        // Charger les communes des départements autorisés
        const params = new URLSearchParams();
        params.append('action', 'getMaires');
        params.append('showAll', '1');

        // Utiliser les départements autorisés
        if (window.USER_FILTER.allowedDeptNumbers && window.USER_FILTER.allowedDeptNumbers.length > 0) {
            params.append('departements', window.USER_FILTER.allowedDeptNumbers.join(','));
        } else if (AppState.currentDepartement) {
            params.append('departement', AppState.currentDepartement);
            params.append('region', AppState.currentRegion);
        }

        updateSearchHeader(`Mes communes modifiables (${window.USER_FILTER.writableCantons.length} cantons)`);

        fetch(`api.php?${params.toString()}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.maires) {
                    // Filtrer côté client pour ne garder que les fiches des cantons modifiables
                    const writableCantons = window.USER_FILTER.writableCantons || [];
                    const maires = data.maires.filter(maire => {
                        const maireCanton = maire.canton || '';
                        return writableCantons.some(canton =>
                            canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                        );
                    });

                    if (maires.length > 0) {
                        displayMairesCards({ success: true, maires: maires });
                    } else {
                        resultsContainer.innerHTML = '<div class="alert alert-info m-3">Aucune commune modifiable trouvée</div>';
                    }
                } else {
                    resultsContainer.innerHTML = '<div class="alert alert-info m-3">Aucune commune trouvée</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                resultsContainer.innerHTML = '<div class="alert alert-danger m-3">Erreur de chargement</div>';
            });
    });

    document.getElementById('btnExportExcelMobile')?.addEventListener('click', function() {
        exportToExcel();
        bsFiltresModal.hide();
    });

    // Bouton "Toutes les fiches du département"
    document.getElementById('btnToutesFichesMobile')?.addEventListener('click', function() {
        bsFiltresModal.hide();

        // Vérifier qu'un département est sélectionné
        if (!AppState.currentDepartement) {
            alert('Veuillez d\'abord sélectionner un département dans le menu.');
            return;
        }

        // Charger toutes les fiches du département actuel
        loadMaires(AppState.currentRegion, AppState.currentDepartement);
    });

    // Bouton "Mes communes attitrées < filtreHabitants hab." - communes modifiables avec moins de X habitants
    document.getElementById('btnMesCommunes1000Mobile')?.addEventListener('click', function() {
        bsFiltresModal.hide();

        // Vérifier que l'utilisateur a des cantons en écriture
        if (!window.USER_FILTER || !window.USER_FILTER.writableCantons || window.USER_FILTER.writableCantons.length === 0) {
            alert('Vous n\'avez pas de communes attitrées en modification.');
            return;
        }

        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<div class="spinner-container"><div class="spinner-border text-primary"></div></div>';

        // Charger les communes des départements autorisés
        const params = new URLSearchParams();
        params.append('action', 'getMaires');
        params.append('showAll', '1');

        // Utiliser les départements autorisés
        if (window.USER_FILTER.allowedDeptNumbers && window.USER_FILTER.allowedDeptNumbers.length > 0) {
            params.append('departements', window.USER_FILTER.allowedDeptNumbers.join(','));
        } else if (AppState.currentDepartement) {
            params.append('departement', AppState.currentDepartement);
            params.append('region', AppState.currentRegion);
        }

        updateSearchHeader(`Mes communes < ${filtreHabitants} hab. (${window.USER_FILTER.writableCantons.length} cantons)`);

        fetch(`api.php?${params.toString()}`)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.maires) {
                    // Filtrer côté client : cantons modifiables ET < filtreHabitants
                    const writableCantons = window.USER_FILTER.writableCantons || [];
                    const maires = data.maires.filter(maire => {
                        const maireCanton = maire.canton || '';
                        const habitants = parseInt(maire.population) || 0;
                        const isWritable = writableCantons.some(canton =>
                            canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                        );
                        return isWritable && habitants < filtreHabitants;
                    });

                    if (maires.length > 0) {
                        displayMairesCards({ success: true, maires: maires });
                    } else {
                        resultsContainer.innerHTML = `<div class="alert alert-info m-3">Aucune commune modifiable < ${filtreHabitants} hab. trouvée</div>`;
                    }
                } else {
                    resultsContainer.innerHTML = '<div class="alert alert-info m-3">Aucune commune trouvée</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                resultsContainer.innerHTML = '<div class="alert alert-danger m-3">Erreur de chargement</div>';
            });
    });

    document.getElementById('btnResetFiltersMobile')?.addEventListener('click', function() {
        // Réinitialiser tous les champs
        FilterState.circo = '';
        FilterState.canton = '';
        FilterState.commune = '';
        FilterState.habitants = '';
        document.getElementById('filterCircoMobile').value = '';
        document.getElementById('filterCantonMobile').value = '';
        document.getElementById('filterCommuneMobile').value = '';
        document.getElementById('filterHabitantsMobile').value = '';
        document.getElementById('filterComboMobile').value = '';
    });

    document.getElementById('btnFilterComboMobile')?.addEventListener('click', function() {
        // Recharger les cantons quand on clique sur le bouton
        if (AppState.currentDepartement) {
            loadCantonsForCombo();
        }
    });

    // Changement dans le select combo - lance la recherche automatiquement
    document.getElementById('filterComboMobile')?.addEventListener('change', function() {
        const value = this.value;
        if (!value) return; // Ne rien faire si option vide sélectionnée

        if (value === 'cantons700') {
            document.getElementById('filterCantonMobile').value = '';
            document.getElementById('filterHabitantsMobile').value = String(filtreHabitants);
            FilterState.canton = '';
            FilterState.habitants = String(filtreHabitants);
        } else {
            // Canton sélectionné - garder le filtre < filtreHabitants
            document.getElementById('filterCantonMobile').value = value;
            document.getElementById('filterHabitantsMobile').value = String(filtreHabitants);
            FilterState.canton = value;
            FilterState.habitants = String(filtreHabitants);
        }

        // Sauvegarder les autres filtres
        FilterState.circo = document.getElementById('filterCircoMobile').value;
        FilterState.commune = document.getElementById('filterCommuneMobile').value;

        // Appliquer le filtrage et fermer la modale
        applyClientSideFilters();
        bsFiltresModal.hide();
    });

    // Appliquer les filtres
    document.getElementById('btnApplyFiltersMobile')?.addEventListener('click', function() {
        // Sauvegarder les valeurs des filtres
        FilterState.circo = document.getElementById('filterCircoMobile').value;
        FilterState.canton = document.getElementById('filterCantonMobile').value;
        FilterState.commune = document.getElementById('filterCommuneMobile').value;
        FilterState.habitants = document.getElementById('filterHabitantsMobile').value;

        // Appliquer le filtrage côté client sur les données actuelles
        applyClientSideFilters();

        bsFiltresModal.hide();
    });

    // Lancer la recherche avec la touche Entrée dans les champs de filtre
    ['filterCircoMobile', 'filterCantonMobile', 'filterCommuneMobile', 'filterHabitantsMobile'].forEach(fieldId => {
        document.getElementById(fieldId)?.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                // Fermer les suggestions d'autocomplétion
                closeAllAutocompleteLists();
                // Simuler le clic sur le bouton Appliquer
                document.getElementById('btnApplyFiltersMobile')?.click();
            }
        });
    });

    // ==========================================
    // AUTOCOMPLÉTION POUR LES FILTRES MOBILE
    // ==========================================

    // Configuration des champs avec autocomplétion
    const autocompleteConfig = {
        'filterCircoMobile': 'circo',
        'filterCantonMobile': 'canton',
        'filterCommuneMobile': 'commune'
    };

    // Fermer toutes les listes d'autocomplétion
    function closeAllAutocompleteLists(except) {
        const lists = document.querySelectorAll('.autocomplete-list-mobile');
        lists.forEach(list => {
            if (list !== except) {
                list.remove();
            }
        });
    }

    // Créer et afficher la liste d'autocomplétion (condensée)
    function showAutocompleteList(input, suggestions) {
        closeAllAutocompleteLists();

        if (!suggestions || suggestions.length === 0) return;

        const list = document.createElement('div');
        list.className = 'autocomplete-list-mobile';
        list.style.cssText = 'position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #17a2b8; border-radius: 3px; max-height: 150px; overflow-y: auto; z-index: 1050; box-shadow: 0 2px 6px rgba(0,0,0,0.15);';

        suggestions.forEach(item => {
            const option = document.createElement('div');
            option.style.cssText = 'padding: 4px 8px; cursor: pointer; font-size: 0.75rem; border-bottom: 1px solid #f0f0f0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';
            option.textContent = item;

            option.addEventListener('mouseenter', function() {
                this.style.backgroundColor = '#e3f2fd';
            });
            option.addEventListener('mouseleave', function() {
                this.style.backgroundColor = 'white';
            });
            option.addEventListener('click', function() {
                input.value = item;
                closeAllAutocompleteLists();

                // Mettre à jour le FilterState selon le champ
                if (input.id === 'filterCircoMobile') {
                    FilterState.circo = item;
                } else if (input.id === 'filterCantonMobile') {
                    FilterState.canton = item;
                } else if (input.id === 'filterCommuneMobile') {
                    FilterState.commune = item;
                }

                // Sauvegarder tous les filtres actuels
                FilterState.circo = document.getElementById('filterCircoMobile').value;
                FilterState.canton = document.getElementById('filterCantonMobile').value;
                FilterState.commune = document.getElementById('filterCommuneMobile').value;
                FilterState.habitants = document.getElementById('filterHabitantsMobile').value;

                // Lancer la recherche et fermer la modale
                applyClientSideFilters();
                bsFiltresModal.hide();
            });

            list.appendChild(option);
        });

        // Positionner la liste par rapport au conteneur parent
        const parent = input.parentElement;
        parent.style.position = 'relative';
        parent.appendChild(list);
    }

    // Debounce pour l'autocomplétion
    let autocompleteTimers = {};

    // Ajouter l'autocomplétion aux champs
    Object.keys(autocompleteConfig).forEach(fieldId => {
        const input = document.getElementById(fieldId);
        if (!input) return;

        input.addEventListener('input', function() {
            const term = this.value.trim();
            const type = autocompleteConfig[fieldId];

            // Annuler le timer précédent
            if (autocompleteTimers[fieldId]) {
                clearTimeout(autocompleteTimers[fieldId]);
            }

            // Fermer si moins de 2 caractères
            if (term.length < 2) {
                closeAllAutocompleteLists();
                return;
            }

            // Vérifier qu'un département est sélectionné
            if (!AppState.currentDepartement) {
                return;
            }

            // Lancer la requête après un délai
            autocompleteTimers[fieldId] = setTimeout(() => {
                fetch(`api.php?action=autocomplete&type=${type}&term=${encodeURIComponent(term)}&departement=${encodeURIComponent(AppState.currentDepartement)}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.results && data.results.length > 0) {
                            showAutocompleteList(input, data.results);
                        }
                    })
                    .catch(err => console.error('Erreur autocomplétion:', err));
            }, 200);
        });

        // Fermer sur perte de focus (avec délai pour permettre le clic)
        input.addEventListener('blur', function() {
            setTimeout(() => closeAllAutocompleteLists(), 200);
        });
    });

    // Fermer les listes quand on clique ailleurs
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.autocomplete-list-mobile') && !e.target.matches('input')) {
            closeAllAutocompleteLists();
        }
    });

    // Filtrage côté client
    function applyClientSideFilters() {
        if (!AppState.currentMairesData || AppState.currentMairesData.length === 0) {
            return;
        }

        const circoFilter = FilterState.circo.toLowerCase();
        const cantonFilter = FilterState.canton.toLowerCase();
        const communeFilter = FilterState.commune.toLowerCase();
        const habitantsFilter = FilterState.habitants ? parseInt(FilterState.habitants) : null;

        // Filtrer les données
        const filteredMaires = AppState.currentMairesData.filter(maire => {
            // Filtre circo
            if (circoFilter) {
                const circo = (maire.circonscription || '').replace(/\D/g, '');
                if (!circo.includes(circoFilter)) return false;
            }

            // Filtre canton
            if (cantonFilter) {
                const canton = (maire.canton || '').toLowerCase();
                if (!canton.includes(cantonFilter)) return false;
            }

            // Filtre commune
            if (communeFilter) {
                const commune = (maire.ville || '').toLowerCase();
                if (!commune.includes(communeFilter)) return false;
            }

            // Filtre habitants
            if (habitantsFilter !== null) {
                const habitants = parseInt(maire.nombre_habitants) || 0;
                if (habitants > habitantsFilter) return false;
            }

            return true;
        });

        // Afficher les résultats filtrés
        displayFilteredResults(filteredMaires);
    }

    // Afficher les résultats filtrés
    function displayFilteredResults(maires) {
        const resultsContainer = document.getElementById('resultsContainer');

        if (maires.length === 0) {
            resultsContainer.innerHTML = '<div class="alert alert-warning m-3">Aucun résultat avec ces filtres</div>';
            return;
        }

        // Reconstruire le tableau avec les maires filtrés
        // navbar = 56px (sauf iframe), searchHeader = 40px
        // En mode iframe: pas de navbar, donc top = 40px
        // En mode normal: navbar + searchHeader = 96px
        const tableTop = isInIframe ? '40px' : '96px';
        const tableHeight = isInIframe ? 'calc(100vh - 40px)' : 'calc(100vh - 96px)';
        let html = `<div style="overflow-x: auto; height: ${tableHeight}; overflow-y: auto; position: fixed; top: ${tableTop}; left: 0; right: 0; background: white;"><table style="width: 100%; border-collapse: collapse; background: white;">`;

        // En-tête
        html += '<thead style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); color: white; position: sticky; top: 0; z-index: 10;">';
        html += '<tr>';
        html += '<th style="padding: 12px 8px; text-align: center; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); cursor: pointer;" onclick="openFiltresModal(event)"><i class="bi bi-three-dots-vertical"></i></th>';
        // Colonne icône accès pour tous les utilisateurs authentifiés
        if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
            html += '<th style="padding: 12px 4px; text-align: center; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); width: 30px;"><i class="bi bi-lock" title="Accès"></i></th>';
        }
        html += '<th style="padding: 12px 8px; text-align: center; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Circo</th>';
        html += '<th style="padding: 12px 8px; text-align: left; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Canton</th>';
        html += '<th style="padding: 12px 8px; text-align: left; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Commune</th>';
        html += '<th style="padding: 12px 8px; text-align: right; font-size: 0.85rem; border-bottom: 2px solid #138496; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">Hab.</th>';
        html += '</tr>';
        html += '</thead>';

        // Corps
        html += '<tbody>';
        maires.forEach(maire => {
            const statutDemarchage = parseInt(maire.statut_demarchage) || 0;
            const isChecked = statutDemarchage > 0 ? 'checked' : '';

            let rowStyle = '';
            let textStyle = '';

            switch(statutDemarchage) {
                case 1: rowStyle = 'background-color: #d3d3d3;'; break;
                case 2: rowStyle = 'background-color: #cfe2ff;'; break;
                case 3: textStyle = 'color: red; text-decoration: line-through;'; break;
                case 4: rowStyle = 'background-color: #c8e6c9; font-weight: bold;'; textStyle = 'font-weight: bold;'; break;
            }

            let statusIcon = '';
            if (statutDemarchage === 1) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Démarchage en cours">📞</span>';
            else if (statutDemarchage === 2) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Rendez-vous obtenu">📅</span>';
            else if (statutDemarchage === 3) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Démarchage terminé">🚫</span>';
            else if (statutDemarchage === 4) statusIcon = '<span style="font-size: 16px; margin-left: 4px;" title="Promesse de parrainage">👍</span>';

            // Déterminer si la fiche est en écriture ou consultation
            let accessIcon = '';
            let isWritable = true;
            if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
                const userType = window.USER_FILTER.userType;
                if (userType === 1 || userType === 2) {
                    isWritable = true;
                    accessIcon = '<i class="bi bi-pencil-fill" style="font-size: 12px; color: #28a745;" title="Écriture - Admin"></i>';
                } else if (userType === 3 || userType === 4) {
                    const maireCanton = maire.canton || '';
                    const writableCantons = window.USER_FILTER.writableCantons || [];
                    isWritable = writableCantons.some(canton =>
                        canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                    );
                    if (isWritable) {
                        accessIcon = '<i class="bi bi-pencil-fill" style="font-size: 12px; color: #28a745;" title="Écriture - Vous pouvez modifier cette fiche"></i>';
                    } else {
                        accessIcon = '<i class="bi bi-lock-fill" style="font-size: 12px; color: #6c757d;" title="Consultation uniquement"></i>';
                    }
                }
            }

            html += `<tr data-maire-id="${maire.id}" data-writable="${isWritable}" style="${rowStyle} cursor: pointer; border-bottom: 1px solid #e9ecef;" onclick="openMaireModal(${maire.id})">`;
            html += `<td style="padding: 6px 4px; text-align: left; white-space: nowrap; font-size: 0.85rem;"><input type="checkbox" ${isChecked} disabled style="pointer-events: none; width: 15px; height: 15px; margin: 0; vertical-align: middle;">${statusIcon}</td>`;
            // Colonne icône accès
            if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
                html += `<td style="padding: 6px 4px; text-align: center; font-size: 0.85rem;">${accessIcon}</td>`;
            }
            html += `<td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem; text-align: center;">${escapeHtml((maire.circonscription || 'N/A').replace(/\D/g, '') || 'N/A')}</td>`;
            html += `<td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem;">${escapeHtml(maire.canton || 'N/A')}</td>`;
            html += `<td style="padding: 10px 8px; ${textStyle} font-size: 0.85rem; font-weight: 500;">${escapeHtml(maire.ville)}</td>`;
            html += `<td style="padding: 10px 8px; text-align: right; ${textStyle} font-size: 0.85rem;">${maire.nombre_habitants ? parseInt(maire.nombre_habitants).toLocaleString('fr-FR') : 'N/A'}</td>`;
            html += '</tr>';
        });
        html += '</tbody>';
        html += '</table></div>';

        resultsContainer.innerHTML = html;

        // Mettre à jour l'en-tête de recherche
        const filterParts = [];
        if (FilterState.circo) filterParts.push(`Circo: ${FilterState.circo}`);
        if (FilterState.canton) filterParts.push(`Canton: ${FilterState.canton}`);
        if (FilterState.commune) filterParts.push(`Commune: ${FilterState.commune}`);
        if (FilterState.habitants) filterParts.push(`Max ${FilterState.habitants} hab.`);

        if (filterParts.length > 0) {
            updateSearchHeader(`${AppState.currentRegion} - Dép. ${AppState.currentDepartement} • ${filterParts.join(' • ')} (${maires.length} communes)`);
        }
    }

    console.log('🚀 Scripts responsive chargés avec succès');

})();
