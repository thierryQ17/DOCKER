document.addEventListener('DOMContentLoaded', function() {
    // Constantes de configuration
    const CONFIG = {
        COLUMN_WIDTHS: {
            CHECKBOX: '50px',
            CIRCO: '18%',
            CANTON: '25%',
            HABITANTS: '100px'
        },
        PAGINATION: {
            PER_PAGE: 50,
            MAX_RESULTS: 100000
        },
        DELAYS: {
            DEBOUNCE: 200,
            MODAL_CLOSE: 100,
            AUTOCOMPLETE_SUBMIT: 100
        },
        MODAL: {
            WIDTH: '800px',
            MAX_HEIGHT: '85vh'
        },
        // Statuts de démarchage avec leurs labels et styles
        STATUTS_DEMARCHAGE: {
            0: { label: '', icon: '', style: '' },
            1: { label: 'Démarchage en cours', icon: '<i class="bi bi-telephone-fill"></i>', style: 'background-color: #d3d3d3;' },
            2: { label: 'Rendez-vous obtenu', icon: '<i class="bi bi-calendar-check-fill"></i>', style: 'background-color: #28a745; color: white; font-weight: bold;' },
            3: { label: 'Démarchage terminé (sans suite)', icon: '<i class="bi bi-x-circle-fill"></i>', style: 'color: red; text-decoration: line-through;' },
            4: { label: 'Promesse de parrainage', icon: '<i class="bi bi-hand-thumbs-up-fill"></i>', style: 'background-color: #e6d5f5; font-weight: bold;' }
        }
    };
    
    // Fonction pour afficher un bandeau de notification
    function showNotification(message, type = 'success', duration = 2000) {
        const notification = document.createElement('div');
        notification.className = `notification-banner ${type}`;
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: ${type === 'success' ? '#28a745' : '#dc3545'};
            color: white;
            padding: 20px 40px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 10000;
            animation: fadeIn 0.3s ease-in-out;
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.transition = 'opacity 0.3s ease-in-out';
            notification.style.opacity = '0';
            setTimeout(() => {
                if (notification.parentNode) {
                    document.body.removeChild(notification);
                }
            }, 300);
        }, duration);
    }

    // État global de l'application encapsulé
    const AppState = {
        currentRegion: '',
        currentDepartement: '',
        currentPage: 1,
        currentSearch: '',
        searchTimeout: null,
        currentMaireCleUnique: null,
        currentMaireId: null,
        // Filtres d'en-tête sauvegardés
        headerFilters: {
            circo: '',
            canton: '',
            commune: '',
            habitants: ''
        },
        // Données des maires actuellement affichés (pour export CSV)
        currentMairesData: []
    };
    
    // Gestionnaire pour l'accordéon de recherche avancée
    const searchAdvancedToggle = document.getElementById('searchAdvancedToggle');
    if (searchAdvancedToggle) {
        searchAdvancedToggle.addEventListener('click', function() {
            const searchAdvanced = document.getElementById('searchAdvanced');
            if (searchAdvanced) {
                searchAdvanced.classList.toggle('collapsed');
            }
        });
    }

    // Gestionnaire pour afficher/masquer le menu latéral
    const sidebarWrapper = document.querySelector('.sidebar-wrapper');
    const closeMenuStrip = document.getElementById('closeMenuStrip');
    const openMenuStrip = document.getElementById('openMenuStrip');
    const paginationFooter = document.getElementById('paginationFooter');

    if (closeMenuStrip && sidebarWrapper) {
        closeMenuStrip.addEventListener('click', function() {
            sidebarWrapper.classList.add('hidden');
            // Ajuster position du footer de pagination
            if (paginationFooter) {
                paginationFooter.style.left = '24px';
            }
        });
    }

    if (openMenuStrip && sidebarWrapper) {
        openMenuStrip.addEventListener('click', function() {
            sidebarWrapper.classList.remove('hidden');
            // Ajuster position du footer de pagination
            if (paginationFooter) {
                paginationFooter.style.left = '320px';
            }
        });
    }
    
    // Gestionnaire pour le bouton "Tout afficher" (délégation d'événements car le bouton est généré dynamiquement)
    document.addEventListener('click', function(e) {
        if (e.target.id === 'btnShowAll' || e.target.closest('#btnShowAll')) {
            // Vérifier si on est en mode recherche avancée
            const region = document.getElementById('searchRegion').value;
            const departement = document.getElementById('searchDepartement').value;
            const commune = document.getElementById('searchCommune').value;
            const canton = document.getElementById('searchCanton').value;
            const nbHabitants = document.getElementById('searchNbHabitants').value;
    
            if (region || departement || commune || canton || nbHabitants) {
                // Mode recherche avancée
                loadMairesAdvanced(region, departement, '', canton, commune, nbHabitants, true);
            } else if (AppState.currentDepartement) {
                // Mode département sélectionné dans le menu
                loadMaires(true);
            }
        }
    
        // Gestionnaire pour le bouton "Tout afficher" dans le menu
        if (e.target.id === 'btnShowAllMenu' || e.target.closest('#btnShowAllMenu')) {
            if (AppState.currentDepartement) {
                loadMaires(true);
            }
        }
    
        // Gestionnaire pour le bouton "Filtrer communes traitées" (recherche avancée)
        if (e.target.id === 'btnFilterDemarchage' || e.target.closest('#btnFilterDemarchage')) {
            filterDemarchageRows();
        }
    
        // Gestionnaire pour le bouton "Filtrer communes traitées" (menu)
        if (e.target.id === 'btnFilterDemarchageMenu' || e.target.closest('#btnFilterDemarchageMenu')) {
            filterDemarchageRows();
        }
    
        // Gestionnaire pour le bouton "Export Excel" (recherche avancée)
        if (e.target.id === 'btnExportExcel' || e.target.closest('#btnExportExcel')) {
            exportToExcel();
        }
    
        // Gestionnaire pour le bouton "Export Excel" (menu)
        if (e.target.id === 'btnExportExcelMenu' || e.target.closest('#btnExportExcelMenu')) {
            exportToExcel();
        }
    });

    // Gestionnaire de clic sur les régions
    document.querySelectorAll('.region-header').forEach(header => {
        header.addEventListener('click', function(e) {
            e.stopPropagation();
            const region = this.dataset.region;
            const departementsList = this.nextElementSibling;
            const isOpen = this.classList.contains('open');
            const isDomtom = this.classList.contains('domtom-header');
            const domtomRegions = this.dataset.domtomRegions;
    
            // Fermer toutes les autres régions
            document.querySelectorAll('.region-header').forEach(h => {
                if (h !== this) {
                    h.classList.remove('open', 'active');
                    h.nextElementSibling.classList.remove('open');
                    h.nextElementSibling.innerHTML = '';
                }
            });
    
            if (isOpen) {
                // Fermer la région
                this.classList.remove('open', 'active');
                departementsList.classList.remove('open');
                departementsList.innerHTML = '';
            } else {
                // Ouvrir la région et charger les départements
                this.classList.add('open', 'active');
                if (isDomtom && domtomRegions) {
                    // Cas DOM-TOM : charger tous les départements des régions d'outre-mer
                    loadDepartementsDomtom(domtomRegions, departementsList);
                } else if (region) {
                    // Cas normal : une seule région
                    loadDepartements(region, departementsList);
                }
            }
        });
    });
    
    // Fonction pour charger les départements DOM-TOM
    // Filtre les résultats selon USER_FILTER pour référents/membres
    function loadDepartementsDomtom(domtomRegionsJson, container) {
        const params = new URLSearchParams({
            action: 'getDepartements',
            domtom: domtomRegionsJson
        });

        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success && data.departements.length > 0) {
                    let html = '';
                    // Filtrer les départements selon les droits de l'utilisateur
                    let filteredDepts = data.departements;
                    if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
                        filteredDepts = data.departements.filter(dept =>
                            window.USER_FILTER.allowedDeptNumbers.includes(dept.numero_departement)
                        );
                    }

                    if (filteredDepts.length === 0) {
                        container.innerHTML = '<div style="padding: 10px; color: #666; font-style: italic;">Aucun département disponible</div>';
                        container.classList.add('open');
                        return;
                    }

                    filteredDepts.forEach(dept => {
                        html += `
                            <div class="departement-item" data-region="${escapeHtml(dept.region)}" data-dept-num="${escapeHtml(dept.numero_departement)}" data-dept-nom="${escapeHtml(dept.nom_departement)}">
                                <span class="departement-name">${escapeHtml(dept.numero_departement)} - ${escapeHtml(dept.nom_departement)}</span>
                                <span class="departement-count">${dept.nb_maires}</span>
                            </div>
                        `;
                    });
                    container.innerHTML = html;
                    container.classList.add('open');

                    // Ajouter les gestionnaires de clic sur les départements
                    attachDepartementClickHandlers(container);
                }
            })
            .catch(error => {
                // Erreur silencieuse
            });
    }

    // Fonction pour charger les départements d'une région
    // Filtre les résultats selon USER_FILTER pour référents/membres
    function loadDepartements(region, container) {
        const params = new URLSearchParams({
            action: 'getDepartements',
            region: region
        });

        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success && data.departements.length > 0) {
                    let html = '';
                    // Filtrer les départements selon les droits de l'utilisateur
                    let filteredDepts = data.departements;
                    if (window.USER_FILTER && window.USER_FILTER.enabled && window.USER_FILTER.allowedDeptNumbers.length > 0) {
                        filteredDepts = data.departements.filter(dept =>
                            window.USER_FILTER.allowedDeptNumbers.includes(dept.numero_departement)
                        );
                    }

                    if (filteredDepts.length === 0) {
                        container.innerHTML = '<div style="padding: 10px; color: #666; font-style: italic;">Aucun département disponible</div>';
                        container.classList.add('open');
                        return;
                    }

                    filteredDepts.forEach(dept => {
                        html += `
                            <div class="departement-item" data-region="${escapeHtml(region)}" data-dept-num="${escapeHtml(dept.numero_departement)}" data-dept-nom="${escapeHtml(dept.nom_departement)}">
                                <span class="departement-name">${escapeHtml(dept.numero_departement)} - ${escapeHtml(dept.nom_departement)}</span>
                                <span class="departement-count">${dept.nb_maires}</span>
                            </div>
                        `;
                    });
                    container.innerHTML = html;
                    container.classList.add('open');

                    // Ajouter les gestionnaires de clic sur les départements
                    attachDepartementClickHandlers(container);

                    // Si "Communes traitées" est coché, mettre à jour les compteurs
                    const communesTraitees = document.getElementById('communesTraitees');
                    if (communesTraitees && communesTraitees.checked) {
                        updateDepartementsStats(container);
                    }
                }
            })
            .catch(error => {
                // Erreur silencieuse
            });
    }
    
    // Fonction pour attacher les gestionnaires de clic sur les départements
    function attachDepartementClickHandlers(container) {
        container.querySelectorAll('.departement-item').forEach(deptItem => {
            deptItem.addEventListener('click', function(e) {
                e.stopPropagation();
    
                // Désactiver tous les autres départements
                document.querySelectorAll('.departement-item').forEach(d => d.classList.remove('active'));
                this.classList.add('active');
    
                // Charger les maires du département
                const region = this.dataset.region;
                const deptNum = this.dataset.deptNum;
                const deptNom = this.dataset.deptNom;
    
                AppState.currentRegion = region;
                AppState.currentDepartement = deptNum;
                AppState.currentPage = 1;
                loadMaires(true); // Toujours afficher toutes les communes du département
    
                // Charger les circonscriptions pour ce département
                loadCirconscriptions(region, deptNum);
    
                // Masquer la recherche avancée
                document.getElementById('searchAdvanced').style.display = 'none';
    
                // Mettre à jour le titre avec région et département
                document.getElementById('regionTitleText').textContent = `${region} - ${deptNom} (${deptNum})`;
            });
        });
    }
    
    // Recherche avancée
    const btnAdvancedSearch = document.getElementById('btnAdvancedSearch');
    if (btnAdvancedSearch) {
        btnAdvancedSearch.addEventListener('click', function() {
            performAdvancedSearch();
        });
    }

    // Fonction pour réinitialiser la recherche avancée
    function resetAdvancedSearch() {
        // Réinitialiser tous les champs
        document.getElementById('searchRegion').value = '';
        document.getElementById('searchDepartement').value = '';
        document.getElementById('searchCommune').value = '';
        document.getElementById('searchCanton').value = '';
        document.getElementById('searchNbHabitants').value = '';
    
        // Réinitialiser les variables
        AppState.currentRegion = '';
        AppState.currentDepartement = '';
        AppState.currentSearch = '';
        AppState.currentPage = 1;
    
        // Afficher la recherche avancée
        document.getElementById('searchAdvanced').style.display = 'block';
    
        // Afficher le message par défaut
        document.getElementById('resultsContainer').innerHTML = `
            <div class="empty-state">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <h3>Utilisez la recherche avancée</h3>
                <p>Utilisez les filtres ci-dessus ou sélectionnez une région dans le menu de gauche</p>
            </div>
        `;
    }
    
    // Permettre la recherche avec la touche Entrée uniquement
    ['searchRegion', 'searchDepartement', 'searchCommune', 'searchCanton', 'searchNbHabitants'].forEach(id => {
        const element = document.getElementById(id);

        if (element) {
            // Déclencher lors de la touche Entrée
            element.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performAdvancedSearch();
                }
            });
        }
    });
    
    // Autocomplétion pour la recherche avancée
    function setupAdvancedAutocomplete() {
        const advancedAutocompleteInputs = [
            { id: 'searchDepartement', type: 'departement', listId: 'departement-autocomplete' },
            { id: 'searchCanton', type: 'canton', listId: 'canton-autocomplete-advanced' },
            { id: 'searchCommune', type: 'commune', listId: 'commune-autocomplete-advanced' }
        ];
    
        advancedAutocompleteInputs.forEach(config => {
            const input = document.getElementById(config.id);
            const list = document.getElementById(config.listId);
    
            if (!input || !list) {
                // Élément non trouvé
                return;
            }
    
            let debounceTimer;
            let selectedIndex = -1;
    
            // Gestionnaire de saisie
            input.addEventListener('input', function() {
                clearTimeout(debounceTimer);
                const term = this.value.trim();

                // Permettre la recherche avec * (wildcard) - minimum 1 caractère si contient *
                const hasWildcard = term.includes('*');
                if (!hasWildcard && term.length < 2) {
                    list.classList.remove('active');
                    list.innerHTML = '';
                    return;
                }
                if (hasWildcard && term.length < 1) {
                    list.classList.remove('active');
                    list.innerHTML = '';
                    return;
                }

                // Récupérer la région sélectionnée pour filtrer les résultats
                const region = document.getElementById('searchRegion').value;

                debounceTimer = setTimeout(() => {
                    // Remplacer * par % pour la recherche SQL LIKE
                    // Si c'est juste *, on envoie %% pour matcher tout
                    let searchTerm = term.replace(/\*/g, '%');
                    if (searchTerm === '%') {
                        searchTerm = '%%';
                    }

                    const params = new URLSearchParams({
                        action: 'autocompleteAdvanced',
                        type: config.type,
                        term: searchTerm,
                        region: region
                    });

                    fetch(`api.php?${params.toString()}`)
                        .then(response => response.json())
                        .then(data => {
                            list.innerHTML = '';
                            selectedIndex = -1;

                            if (data.results && data.results.length > 0) {
                                data.results.forEach((result, index) => {
                                    const item = document.createElement('div');
                                    item.className = 'autocomplete-item';
                                    item.textContent = result;
                                    item.dataset.index = index;

                                    // Clic sur un élément
                                    item.addEventListener('click', function() {
                                        input.value = result;
                                        list.classList.remove('active');
                                        list.innerHTML = '';
                                    });

                                    list.appendChild(item);
                                });
                                list.classList.add('active');
                            } else {
                                list.classList.remove('active');
                            }
                        })
                        .catch(error => {});
                }, 300);
            });
    
            // Navigation au clavier
            input.addEventListener('keydown', function(e) {
                const items = list.querySelectorAll('.autocomplete-item');
    
                if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    selectedIndex = Math.min(selectedIndex + 1, items.length - 1);
                    updateSelection(items);
                } else if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    selectedIndex = Math.max(selectedIndex - 1, -1);
                    updateSelection(items);
                } else if (e.key === 'Enter' && selectedIndex >= 0) {
                    e.preventDefault();
                    input.value = items[selectedIndex].textContent;
                    list.classList.remove('active');
                    list.innerHTML = '';
                } else if (e.key === 'Escape') {
                    list.classList.remove('active');
                    list.innerHTML = '';
                }
            });
    
            function updateSelection(items) {
                items.forEach((item, index) => {
                    item.classList.toggle('selected', index === selectedIndex);
                });
                if (selectedIndex >= 0 && items[selectedIndex]) {
                    items[selectedIndex].scrollIntoView({ block: 'nearest' });
                }
            }
    
            // Fermer la liste si on clique ailleurs
            document.addEventListener('click', function(e) {
                if (e.target !== input && !list.contains(e.target)) {
                    list.classList.remove('active');
                }
            });
        });
    }
    
    // Initialiser l'autocomplétion
    setupAdvancedAutocomplete();
    
    function performAdvancedSearch() {
        const region = document.getElementById('searchRegion').value;
        const departement = document.getElementById('searchDepartement').value;
        const commune = document.getElementById('searchCommune').value;
        const canton = document.getElementById('searchCanton').value;
        const nbHabitants = document.getElementById('searchNbHabitants').value;
    
        // Vérifier qu'au moins un champ est rempli
        if (!region && !departement && !commune && !canton && !nbHabitants) {
            alert('Veuillez remplir au moins un critère de recherche');
            return;
        }
    
        // Mettre à jour le titre
        let titleText = 'Résultats de la recherche';
        if (region) titleText += ` - ${region}`;
        if (departement) titleText += ` - ${departement}`;
        if (commune) titleText += ` - ${commune}`;
        if (canton) titleText += ` - ${canton}`;
        if (nbHabitants) titleText += ` - ${parseInt(nbHabitants).toLocaleString('fr-FR')}+ habitants`;
        document.getElementById('regionTitleText').textContent = titleText;
    
        // Réinitialiser la pagination
        AppState.currentPage = 1;
    
        // Effectuer la recherche
        loadMairesAdvanced(region, departement, '', canton, commune, nbHabitants);
    }
    
    // Fonction pour charger les circonscriptions en fonction du département sélectionné
    function loadCirconscriptions(region = '', departement = '') {
        fetch(`api.php?action=getCirconscriptions&region=${encodeURIComponent(region)}&departement=${encodeURIComponent(departement)}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const datalist = document.getElementById('circonscriptions-datalist');
                    datalist.innerHTML = '';
                    data.circonscriptions.forEach(circo => {
                        const option = document.createElement('option');
                        option.value = circo;
                        datalist.appendChild(option);
                    });
                }
            })
            .catch(error => {});
    }
    
    // Fonction utilitaire pour obtenir les filtres actuels
    function getCurrentFilters() {
        const filters = {};
    
        // Contexte menu (département sélectionné)
        if (AppState.currentDepartement) {
            filters.departement = AppState.currentDepartement;
        }
    
        // Contexte recherche avancée
        const searchRegion = document.getElementById('searchRegion');
        const searchDepartement = document.getElementById('searchDepartement');
        const searchCirco = document.getElementById('searchCirco');
        const searchCanton = document.getElementById('searchCanton');
        const searchCommune = document.getElementById('searchCommune');
        const searchNbHabitants = document.getElementById('searchNbHabitants');
    
        if (searchRegion?.value) {
            filters.region = searchRegion.value;
        }
        if (searchDepartement?.value) {
            filters.departement = searchDepartement.value;
        }
        if (searchCirco?.value) {
            filters.circo = searchCirco.value;
        }
        if (searchCanton?.value) {
            filters.canton = searchCanton.value;
        }
        if (searchCommune?.value) {
            filters.commune = searchCommune.value;
        }
        if (searchNbHabitants?.value) {
            filters.nbHabitants = searchNbHabitants.value;
        }
    
        return filters;
    }
    
    // Fonction utilitaire pour générer les boutons d'action
    function generateActionButtons(context = 'advanced') {
        const buttons = [
            {
                id: context === 'menu' ? 'btnShowAllMenu' : 'btnShowAll',
                class: 'btn-all',
                style: 'padding: 5px 8px; background: #17a2b8; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 16px; flex-shrink: 0; line-height: 1;',
                title: 'Tout afficher',
                icon: '📋'
            },
            {
                id: context === 'menu' ? 'btnFilterDemarchageMenu' : 'btnFilterDemarchage',
                class: 'btn-filter',
                style: 'padding: 5px 8px; background: #28a745; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 16px; flex-shrink: 0; line-height: 1;',
                title: 'Filtrer communes traitées',
                icon: '🔍'
            },
            {
                id: context === 'menu' ? 'btnExportExcelMenu' : 'btnExportExcel',
                class: 'btn-export',
                style: 'padding: 5px 8px; background: #28a745; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 16px; flex-shrink: 0; line-height: 1;',
                title: 'Export CSV',
                icon: '📊'
            }
        ];

        return '<div style="display: flex; gap: 2px;">' +
            buttons.map(btn => `<button class="${btn.class}" id="${btn.id}" style="${btn.style}" title="${btn.title}">${btn.icon}</button>`).join('') +
            '</div>';
    }

    // Fonction pour construire l'en-tête du tableau avec filtres
    function buildTableHeader(context, savedFilters) {
        const config = {
            resetFunction: context === 'menu' ? 'resetFiltersMenu()' : 'resetHeaderFilters()'
        };

        let html = '<thead>';
        html += '<tr>';
        html += `<th style="width: 45px; text-align: left;">${generateActionButtons(context)}</th>`;
        html += '<th style="width: 40px;"></th>'; // Colonne pour filtre combiné (icône)
        html += '<th style="width: 50px; text-align: center;">Circo</th>';
        html += '<th style="width: 18%;">Canton</th>';
        html += '<th>Commune</th>';
        html += '<th style="width: 140px;">Habitants</th>';
        html += '</tr>';
        html += '<tr style="background: #f8f9fa;">';
        html += `<th style="width: 45px; text-align: left;"><button onclick="${config.resetFunction}" style="padding: 5px 6px; background: #17a2b8; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 11px; font-weight: 600; flex-shrink: 0;" title="Réinitialiser les filtres">↻</button></th>`;
        html += `<th style="width: 40px; position: relative;"><button id="btnFilterCombo" style="padding: 5px 8px; background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 14px;" title="Filtres cantons">⚙️</button><select id="tableFilterCombo" class="table-filter-combo" style="position: absolute; top: 100%; left: 0; min-width: 200px; padding: 5px; border: 2px solid #17a2b8; border-radius: 3px; font-size: 12px; background: white; font-weight: 500; color: #138496; display: none; z-index: 100;"><option value="">-- Sélectionner --</option></select></th>`;
        html += `<th style="width: 50px;"><input type="text" placeholder="N°" class="table-filter-input autocomplete-input" data-filter="circo" data-autocomplete-type="circo" style="width: 100%; padding: 5px; border: 1px solid #ddd; border-radius: 3px; font-size: 12px; text-align: center;" value="${escapeHtml(savedFilters.circo)}"></th>`;
        html += `<th style="width: 18%;"><input type="text" placeholder="Filtrer..." class="table-filter-input autocomplete-input" data-filter="canton" data-autocomplete-type="canton" style="width: 100%; padding: 5px; border: 1px solid #ddd; border-radius: 3px; font-size: 12px;" value="${escapeHtml(savedFilters.canton)}"></th>`;
        html += `<th><input type="text" placeholder="Filtrer..." class="table-filter-input autocomplete-input" data-filter="commune" data-autocomplete-type="commune" style="width: 100%; padding: 5px; border: 1px solid #ddd; border-radius: 3px; font-size: 12px;" value="${escapeHtml(savedFilters.commune)}"></th>`;
        html += `<th style="width: 140px;"><input type="number" placeholder="Max..." class="table-filter-input" data-filter="habitants" style="width: 100%; padding: 5px; border: 1px solid #ddd; border-radius: 3px; font-size: 12px;" value="${escapeHtml(savedFilters.habitants)}"></th>`;
        html += '</tr>';
        html += '</thead>';

        return html;
    }

    // Fonction pour construire une ligne du tableau
    function buildTableRow(maire) {
        // Déterminer le statut de démarchage (priorité au nouveau champ statut_demarchage)
        const statutDemarchage = maire.statut_demarchage || 0;

        // Cocher la case uniquement si un statut est sélectionné (statut > 0)
        const isChecked = statutDemarchage > 0 ? 'checked' : '';

        // Appliquer les couleurs selon le statut
        // Récupérer les infos du statut depuis CONFIG
        const statutInfo = CONFIG.STATUTS_DEMARCHAGE[parseInt(statutDemarchage)] || CONFIG.STATUTS_DEMARCHAGE[0];

        // Styles de ligne selon le statut
        let rowStyle = '';
        let textStyle = '';
        switch(parseInt(statutDemarchage)) {
            case 1: rowStyle = 'background-color: #d3d3d3;'; break;
            case 2: rowStyle = 'background-color: #cfe2ff;'; break;
            case 3: textStyle = 'color: red; text-decoration: line-through;'; break;
            case 4: rowStyle = 'background-color: #c8e6c9; font-weight: bold;'; textStyle = 'font-weight: bold;'; break;
        }

        // Icône selon le statut (utilise CONFIG)
        let statusIcon = '';
        if (statutInfo.icon) {
            const iconColor = parseInt(statutDemarchage) === 1 ? 'color: green;' : (parseInt(statutDemarchage) === 3 ? 'color: red;' : '');
            statusIcon = `<span style="${iconColor} font-size: 18px; margin-left: 5px; font-weight: bold; white-space: nowrap;" title="${statutInfo.label}">${statutInfo.icon}</span>`;
        }

        // Déterminer si la fiche est en écriture ou consultation selon le type d'utilisateur
        // Admin Gén (1) et Admin (2) : écriture sur tout
        // Référent (3) et Membre (4) : écriture uniquement sur leurs cantons autorisés
        let accessIcon = '';
        if (window.USER_FILTER && window.USER_FILTER.userType >= 1 && window.USER_FILTER.userType <= 4) {
            const userType = window.USER_FILTER.userType;

            if (userType === 1 || userType === 2) {
                // Admin Gén et Admin : écriture sur toutes les fiches
                accessIcon = `<i class="bi bi-pencil-fill" style="font-size: 14px; color: #28a745;" title="Écriture - Admin"></i>`;
            } else if (userType === 3 || userType === 4) {
                // Référent et Membre : vérifier les cantons autorisés
                const maireCanton = maire.canton || '';
                const writableCantons = window.USER_FILTER.writableCantons || [];
                const isWritable = writableCantons.some(canton =>
                    canton && maireCanton && canton.toLowerCase() === maireCanton.toLowerCase()
                );
                if (isWritable) {
                    accessIcon = `<i class="bi bi-pencil-fill" style="font-size: 14px; color: #28a745;" title="Écriture - Vous pouvez modifier cette fiche"></i>`;
                } else {
                    accessIcon = `<i class="bi bi-eye-fill" style="font-size: 14px; color: #6c757d; margin-left: 3px;" title="Consultation uniquement"></i>`;
                }
            }
        }

        let html = `<tr data-maire-id="${maire.id}" style="${rowStyle}">`;
        html += `<td style="width: 45px; text-align: center; white-space: nowrap;" onclick="event.stopPropagation();"><input type="checkbox" ${isChecked} disabled style="cursor: not-allowed; width: 16px; height: 16px;">${statusIcon}</td>`;
        html += `<td style="width: 40px; text-align: center;">${accessIcon}</td>`; // Colonne pour icône accès (écriture/consultation)
        html += `<td style="width: 50px; text-align: center; ${textStyle}" onclick="openMaireModal(${maire.id})">${escapeHtml((maire.circonscription || 'N/A').replace(/\D/g, '') || 'N/A')}</td>`;
        html += `<td style="width: 18%; ${textStyle}" onclick="openMaireModal(${maire.id})">${escapeHtml(maire.canton || 'N/A')}</td>`;
        html += `<td style="text-align: left; ${textStyle}" onclick="openMaireModal(${maire.id})">${escapeHtml(maire.ville)}</td>`;
        html += `<td style="width: 90px; text-align: right; ${textStyle}" onclick="openMaireModal(${maire.id})">${maire.nombre_habitants ? parseInt(maire.nombre_habitants).toLocaleString('fr-FR') : 'N/A'}</td>`;
        html += '</tr>';

        return html;
    }

    // Fonction pour construire la pagination dans le footer fixe
    function buildPagination(data, showAll, context) {
        const config = {
            pageFunction: context === 'menu' ? 'changePage' : 'changePageAdvanced'
        };

        const paginationFooter = document.getElementById('paginationFooter');

        // Vérifier que l'élément existe
        if (!paginationFooter) {
            return '';
        }

        if (!showAll && data.totalPages > 1) {
            // Afficher le footer avec la pagination
            paginationFooter.innerHTML = `
                <div class="pagination">
                    <button onclick="${config.pageFunction}(${data.page - 1})" ${data.page <= 1 ? 'disabled' : ''}>‹ Précédent</button>
                    <span class="page-info">Page ${data.page} / ${data.totalPages} (${data.total} maires)</span>
                    <button onclick="${config.pageFunction}(${data.page + 1})" ${data.page >= data.totalPages ? 'disabled' : ''}>Suivant ›</button>
                </div>
            `;
            paginationFooter.classList.add('active');
            return '';
        } else {
            // Masquer le footer et afficher le total dans le tableau
            paginationFooter.classList.remove('active');
            paginationFooter.innerHTML = '';
            return `<p style="text-align: center; color: #999; margin-top: 20px;">${data.total} maire(s) trouvé(s)</p>`;
        }
    }
    
    function loadMairesAdvanced(region, departement, circo, canton, commune, nbHabitants = '', showAll = false) {
        const resultsContainer = document.getElementById('resultsContainer');
    
        // Afficher le spinner
        resultsContainer.innerHTML = `
            <div class="loading">
                <div class="spinner"></div>
                <p>Recherche en cours...</p>
            </div>
        `;
    
        // Requête AJAX
        const params = new URLSearchParams({
            action: 'getMaires',
            region: region,
            departement: departement,
            circo: circo,
            canton: canton,
            commune: commune,
            nbHabitants: nbHabitants,
            page: AppState.currentPage,
            showAll: showAll ? '1' : '0'
        });
    
        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    displayMairesInContainer(data, showAll);
                } else {
                    resultsContainer.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les données</p></div>';
                }
            })
            .catch(error => {
                resultsContainer.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les données</p></div>';
            });
    }
    
    function displayMairesInContainer(data, showAll = false, context = 'advanced') {
        const resultsContainer = document.getElementById('resultsContainer');

        if (data.maires.length === 0) {
            resultsContainer.innerHTML = `
                <div class="empty-state">
                    <h3>Aucun résultat</h3>
                    <p>Aucun maire trouvé pour cette recherche</p>
                </div>
            `;
            return;
        }

        // Sauvegarder les valeurs des filtres d'en-tête avant de recréer le HTML
        // Mettre à jour AppState avec les valeurs actuelles ou garder les anciennes
        const circoInput = document.querySelector('[data-filter="circo"]');
        const cantonInput = document.querySelector('[data-filter="canton"]');
        const communeInput = document.querySelector('[data-filter="commune"]');
        const habitantsInput = document.querySelector('[data-filter="habitants"]');

        if (circoInput) AppState.headerFilters.circo = circoInput.value;
        if (cantonInput) AppState.headerFilters.canton = cantonInput.value;
        if (communeInput) AppState.headerFilters.commune = communeInput.value;
        if (habitantsInput) AppState.headerFilters.habitants = habitantsInput.value;

        const savedFilters = AppState.headerFilters;

        // Sauvegarder les données pour l'export CSV
        AppState.currentMairesData = data.maires;

        // Construire le tableau
        let html = '<div class="table-container"><table class="maires-table" style="width: 100%;">';
        html += buildTableHeader(context, savedFilters);
        html += '<tbody>';
        data.maires.forEach(maire => {
            html += buildTableRow(maire);
        });
        html += '</tbody></table></div>';

        // Ajouter la pagination
        html += buildPagination(data, showAll, context);

        resultsContainer.innerHTML = html;

        // Ajouter les event listeners pour les filtres de colonnes
        attachColumnFilterListeners();
    }
    
    function attachColumnFilterListeners() {
        const filterInputs = document.querySelectorAll('.table-filter-input');
        filterInputs.forEach(input => {
            // Déclencher uniquement lors de la touche Entrée
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyHeaderFilters();
                }
            });
        });

        // Gérer le bouton et la liste déroulante combinée
        const btnFilterCombo = document.getElementById('btnFilterCombo');
        const tableFilterCombo = document.getElementById('tableFilterCombo');

        if (btnFilterCombo && tableFilterCombo) {
            // Clic sur le bouton pour ouvrir/fermer le select
            btnFilterCombo.addEventListener('click', function(e) {
                e.stopPropagation();
                const isVisible = tableFilterCombo.style.display === 'block';
                tableFilterCombo.style.display = isVisible ? 'none' : 'block';
                if (!isVisible) {
                    tableFilterCombo.focus();
                    tableFilterCombo.size = Math.min(tableFilterCombo.options.length, 15);
                }
            });

            // Fermer le select si on clique ailleurs
            document.addEventListener('click', function(e) {
                if (e.target !== btnFilterCombo && e.target !== tableFilterCombo) {
                    tableFilterCombo.style.display = 'none';
                }
            });
        }

        if (tableFilterCombo && AppState.currentDepartement) {
            // Récupérer le seuil d'habitants depuis la configuration PHP
            const seuilCanton = window.SEUIL_HABITANTS_CANTON || 700;

            // Peupler avec l'option "CANTONS < XXX hab" et les cantons
            tableFilterCombo.innerHTML = '<option value="">-- Sélectionner --</option>';
            tableFilterCombo.innerHTML += `<option value="cantons700">CANTONS < ${seuilCanton} hab</option>`;
            tableFilterCombo.innerHTML += '<optgroup label="Cantons" id="cantonsGroup">';
            tableFilterCombo.innerHTML += '</optgroup>';

            // Charger les cantons du département actuel
            fetch(`api.php?action=autocomplete&type=canton&term=%%&departement=${encodeURIComponent(AppState.currentDepartement)}`)
                .then(response => response.json())
                .then(data => {
                    if (data.results && data.results.length > 0) {
                        const cantonsGroup = document.getElementById('cantonsGroup');
                        data.results.forEach(canton => {
                            const option = document.createElement('option');
                            option.value = `canton:${canton}`;
                            option.textContent = canton;
                            cantonsGroup.appendChild(option);
                        });
                    }
                })
                .catch(error => console.error('Erreur chargement cantons:', error));

            // Gérer l'événement de sélection
            tableFilterCombo.addEventListener('change', function() {
                const value = this.value;
                if (!value) return;

                // Vider les champs canton et habitants
                const cantonInput = document.querySelector('.table-filter-input[data-filter="canton"]');
                const habitantsInput = document.querySelector('.table-filter-input[data-filter="habitants"]');
                if (cantonInput) cantonInput.value = '';
                if (habitantsInput) habitantsInput.value = '';

                // Traiter la sélection
                if (value === 'cantons700') {
                    // Option "CANTONS < XXX hab" - filtre uniquement sur habitants
                    if (habitantsInput) habitantsInput.value = seuilCanton;
                } else {
                    // Option canton individuel - appliquer CANTON + HABITANTS XXX
                    const [type, filterValue] = value.split(':');
                    if (type === 'canton') {
                        if (cantonInput) cantonInput.value = filterValue;
                        if (habitantsInput) habitantsInput.value = seuilCanton;
                    }
                }

                // Déclencher la recherche
                applyHeaderFilters();

                // Réinitialiser la liste et cacher le menu
                this.value = '';
                this.style.display = 'none';
            });
        }

        // Ajouter l'autocomplétion pour les champs CIRCO, CANTON, COMMUNE
        const autocompleteInputs = document.querySelectorAll('.autocomplete-input');
        autocompleteInputs.forEach(input => {
            let debounceTimer;

            // Créer une dropdown personnalisée pour cet input
            let dropdown = input.parentNode.querySelector('.autocomplete-dropdown');
            if (!dropdown) {
                dropdown = document.createElement('div');
                dropdown.className = 'autocomplete-dropdown';
                input.parentNode.style.position = 'relative';
                input.parentNode.appendChild(dropdown);
            }

            // Fermer dropdown si clic ailleurs (une seule fois)
            const closeOnClickOutside = function(e) {
                if (!input.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.style.display = 'none';
                }
            };

            // Retirer ancien listener et ajouter le nouveau pour éviter les doublons
            document.removeEventListener('click', closeOnClickOutside);
            document.addEventListener('click', closeOnClickOutside);

            input.addEventListener('input', function(e) {
                clearTimeout(debounceTimer);
                const type = this.dataset.autocompleteType;
                const term = this.value.trim();

                // Permettre la recherche avec * (wildcard) - minimum 1 caractère si contient *
                const hasWildcard = term.includes('*');
                if (!hasWildcard && term.length < 2) {
                    dropdown.style.display = 'none';
                    return;
                }
                if (hasWildcard && term.length < 1) {
                    dropdown.style.display = 'none';
                    return;
                }

                // Utiliser le département courant
                if (!AppState.currentDepartement) {
                    dropdown.style.display = 'none';
                    return;
                }

                debounceTimer = setTimeout(() => {
                    // Remplacer * par % pour la recherche SQL LIKE
                    // Si c'est juste *, on envoie %% pour matcher tout
                    let searchTerm = term.replace(/\*/g, '%');
                    if (searchTerm === '%') {
                        searchTerm = '%%';
                    }

                    fetch(`api.php?action=autocomplete&type=${type}&term=${encodeURIComponent(searchTerm)}&departement=${encodeURIComponent(AppState.currentDepartement)}`)
                        .then(response => response.json())
                        .then(data => {
                            dropdown.innerHTML = '';

                            if (data.results && data.results.length > 0) {
                                data.results.forEach(result => {
                                    const item = document.createElement('div');
                                    item.className = 'autocomplete-item';
                                    item.textContent = result;
                                    item.addEventListener('click', function(e) {
                                        e.stopPropagation();
                                        input.value = result;
                                        dropdown.style.display = 'none';
                                        // Déclencher automatiquement la recherche
                                        applyHeaderFilters();
                                    });
                                    dropdown.appendChild(item);
                                });
                                dropdown.style.display = 'block';
                            } else {
                                dropdown.style.display = 'none';
                            }
                        })
                        .catch(error => {
                            console.error('Erreur autocomplete:', error);
                            dropdown.style.display = 'none';
                        });
                }, 300);
            });

            // Support clavier (Escape pour fermer)
            input.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    dropdown.style.display = 'none';
                }
            });
        });
    }
    
    function applyHeaderFilters() {
        // Sauvegarder les filtres dans AppState avant de continuer
        AppState.headerFilters.circo = document.querySelector('[data-filter="circo"]')?.value || '';
        AppState.headerFilters.canton = document.querySelector('[data-filter="canton"]')?.value || '';
        AppState.headerFilters.commune = document.querySelector('[data-filter="commune"]')?.value || '';
        AppState.headerFilters.habitants = document.querySelector('[data-filter="habitants"]')?.value || '';

        // Récupérer les valeurs des filtres d'en-tête
        const deptFilter = document.querySelector('[data-filter="departement"]')?.value || '';
        const circoFilter = AppState.headerFilters.circo;
        const communeFilter = AppState.headerFilters.commune;
        const cantonFilter = AppState.headerFilters.canton;
        const habitantsFilter = AppState.headerFilters.habitants;

        // Déterminer le contexte actuel
        let finalRegion = '';
        let finalDept = '';
        let finalCirco = '';
        let finalCommune = '';
        let finalCanton = '';
        let finalHabitants = '';

        // Si on est en mode département sélectionné (via le menu), rester dans ce mode
        if (AppState.currentDepartement) {
            // Mode: département sélectionné via le menu + filtres d'en-tête uniquement
            finalDept = deptFilter || AppState.currentDepartement;
            finalCirco = circoFilter;
            finalCommune = communeFilter;
            finalCanton = cantonFilter;
            finalHabitants = habitantsFilter;
        } else {
            // Mode: recherche avancée + filtres d'en-tête
            const region = document.getElementById('searchRegion')?.value || '';
            const departement = document.getElementById('searchDepartement')?.value || '';
            const commune = document.getElementById('searchCommune')?.value || '';
            const canton = document.getElementById('searchCanton')?.value || '';
            const nbHabitants = document.getElementById('searchNbHabitants')?.value || '';

            finalRegion = region;
            finalDept = deptFilter || departement;
            finalCirco = circoFilter;
            // Priorité aux filtres d'en-tête, sinon recherche avancée
            finalCommune = communeFilter || commune;
            finalCanton = cantonFilter || canton;
            finalHabitants = habitantsFilter || nbHabitants;
        }

        // Réinitialiser la page
        AppState.currentPage = 1;

        // Effectuer la recherche avec les filtres combinés - showAll = true pour afficher tous les résultats
        loadMairesAdvanced(finalRegion, finalDept, finalCirco, finalCanton, finalCommune, finalHabitants, true);
    }
    
    function resetHeaderFilters() {
        // Réinitialiser les filtres dans AppState
        AppState.headerFilters = {
            circo: '',
            canton: '',
            commune: '',
            habitants: ''
        };

        // Effacer tous les inputs de filtre d'en-tête
        document.querySelectorAll('.table-filter-input').forEach(input => {
            input.value = '';
        });

        // Recharger les données du département actuellement sélectionné
        if (AppState.currentDepartement && AppState.currentRegion) {
            AppState.currentPage = 1;
            loadMaires();
        }
    }

    function resetFiltersMenu() {
        // Réinitialiser les filtres dans AppState
        AppState.headerFilters = {
            circo: '',
            canton: '',
            commune: '',
            habitants: ''
        };

        // Effacer tous les inputs de filtre
        document.querySelectorAll('.table-filter-input').forEach(input => {
            input.value = '';
        });

        // Recharger les données du département actuellement sélectionné
        if (AppState.currentDepartement && AppState.currentRegion) {
            AppState.currentPage = 1;
            loadMaires();
        }
    }
    
    function changePageAdvanced(page) {
        AppState.currentPage = page;
        const region = document.getElementById('searchRegion').value;
        const departement = document.getElementById('searchDepartement').value;
        const commune = document.getElementById('searchCommune').value;
        const canton = document.getElementById('searchCanton').value;
        const nbHabitants = document.getElementById('searchNbHabitants').value;
        loadMairesAdvanced(region, departement, '', canton, commune, nbHabitants);
        // Scroll to top of results
        document.querySelector('.content-body').scrollTop = 0;
    }
    
    // Fonction pour charger les maires
    function loadMaires(showAll = false) {
        const resultsContainer = document.getElementById('resultsContainer');
    
        // Afficher le spinner
        resultsContainer.innerHTML = `
            <div class="loading">
                <div class="spinner"></div>
                <p>Chargement des maires...</p>
            </div>
        `;
    
        // Requête AJAX
        const params = new URLSearchParams({
            action: 'getMaires',
            departement: AppState.currentDepartement,
            search: AppState.currentSearch,
            page: AppState.currentPage,
            showAll: showAll ? '1' : '0'
        });
    
        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    displayMairesInContainer(data, showAll, 'menu');
                } else {
                    resultsContainer.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les données</p></div>';
                }
            })
            .catch(error => {
                resultsContainer.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les données</p></div>';
            });
    }
    
    // Changer de page
    function changePage(page) {
        AppState.currentPage = page;
        loadMaires();
        // Scroll vers le haut
        document.querySelector('.content-body').scrollTop = 0;
    }
    
    // Fonction pour échapper le HTML
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Fonction pour construire le titre de la modal
    function buildModalTitle(maire) {
        const titleText = maire.code_postal
            ? `${maire.ville.toUpperCase()} - ${maire.code_postal}`
            : maire.ville.toUpperCase();

        const cantonText = maire.canton ? ` - ${escapeHtml(maire.canton)}` : '';
        const subtitleText = `${escapeHtml(maire.region)} - ${escapeHtml(maire.circonscription || 'Non renseignée')}${cantonText} - ${escapeHtml(maire.nom_departement)}`;

        return `
            <div>${titleText || 'Détails du maire'}</div>
            <div style="font-size: 0.7em; font-weight: 400; color: white; margin-top: 5px;">${subtitleText}</div>
        `;
    }

    // Fonction pour construire le HTML des détails du maire
    function buildMaireDetailsHTML(maire) {
        let html = '<div class="maire-detail-grid">';

        html += `
            <div class="maire-detail-item" style="grid-column: span 1;">
                <div class="maire-detail-label">Maire</div>
                <div class="maire-detail-value ${!maire.nom_maire ? 'empty' : ''}" style="font-weight: 700; font-size: 1.2em;">${escapeHtml(maire.nom_maire || 'Non renseigné')}</div>
            </div>
        `;

        html += `
            <div class="maire-detail-item" style="grid-column: span 1;">
                <div class="maire-detail-label">Téléphone</div>
                <div class="maire-detail-value ${!maire.telephone ? 'empty' : ''}" style="white-space: nowrap;">
                    ${maire.telephone ? `<a href="tel:${escapeHtml(maire.telephone)}" style="white-space: nowrap;">${escapeHtml(maire.telephone)}</a>` : 'Non renseigné'}
                </div>
            </div>
        `;

        return html;
    }

    // Fonction helper pour générer les options du select statut démarchage
    function buildStatutDemarchageOptions() {
        let options = '<option value="0">-- Sélectionner --</option>';
        // Statuts 1, 2, 3
        for (let i = 1; i <= 3; i++) {
            const statut = CONFIG.STATUTS_DEMARCHAGE[i];
            options += `<option value="${i}" style="${statut.style}">${statut.label}</option>`;
        }
        // Séparateur
        options += '<option disabled>──────────</option>';
        // Statut 4 (Promesse de parrainage)
        const statut4 = CONFIG.STATUTS_DEMARCHAGE[4];
        options += `<option value="4" style="${statut4.style}">${statut4.label}</option>`;
        return options;
    }

    // Fonction pour construire le formulaire de démarchage
    // readOnly: si true, les champs sont désactivés (mode consultation pour les membres)
    function buildDemarchageFormHTML(readOnly = false) {
        const disabledAttr = readOnly ? 'disabled' : '';
        const readOnlyStyle = readOnly ? 'opacity: 0.7; cursor: not-allowed;' : '';
        const borderColor = readOnly ? '#6c757d' : '#17a2b8';
        const labelColor = readOnly ? '#6c757d' : '#17a2b8';

        // Message de consultation pour les membres
        const readOnlyBanner = readOnly ? `
            <div style="background: #fff3cd; border: 1px solid #ffc107; border-radius: 4px; padding: 8px 12px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                <i class="bi bi-eye-fill" style="font-size: 18px; color: #856404;"></i>
                <span style="font-size: 13px; color: #856404;">Mode consultation uniquement - Vous n'avez pas les droits d'écriture sur ce canton</span>
            </div>
        ` : '';

        // Bouton Enregistrer (masqué en mode consultation)
        const saveButton = readOnly ? '' : `
            <div style="display: flex; justify-content: flex-end;">
                <button type="button" onclick="saveDemarcheData()" style="padding: 10px 20px; background: #17a2b8; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.3s ease;">
                    Enregistrer
                </button>
            </div>
        `;

        return `
            <div class="full-width" style="position: relative; border: 2px solid ${borderColor}; border-radius: 8px; padding: 25px 15px 15px 15px; margin-top: 25px; grid-column: 1 / -1; ${readOnlyStyle}">
                <div style="position: absolute; top: -12px; left: 15px; background: white; padding: 0 10px;">
                    <label style="font-weight: 600; color: ${labelColor}; margin: 0;">
                        Démarchage de parrainage ${readOnly ? '(consultation)' : ''}
                    </label>
                </div>

                <div id="demarcheFields">
                    ${readOnlyBanner}
                    <div style="margin-bottom: 12px;">
                        <select id="statutDemarchage" style="width: 100%; padding: 10px; border: 2px solid ${borderColor}; border-radius: 4px; font-size: 14px; font-weight: 600; background: white; ${readOnlyStyle}" ${disabledAttr}>
                            ${buildStatutDemarchageOptions()}
                        </select>
                    </div>

                    <div style="margin-bottom: 12px; display: flex; align-items: center; gap: 10px;">
                        <label style="font-weight: 500; white-space: nowrap;">RDV :</label>
                        <input type="date" id="rdvDate" style="flex: 1; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; ${readOnlyStyle}" ${disabledAttr}>
                        <input type="time" id="rdvTime" style="padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; width: 120px; ${readOnlyStyle}" ${disabledAttr}>
                    </div>

                    <div style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 500; margin-bottom: 5px;">Commentaire :</label>
                        <textarea id="commentaire" rows="4" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; resize: vertical; ${readOnlyStyle}" placeholder="Saisissez votre commentaire..." ${disabledAttr}></textarea>
                    </div>

                    ${saveButton}
                </div>
            </div>
        `;
    }

    // Fonction pour construire les boutons d'actions de la modal
    function buildModalActionsHTML(maire) {
        let actionsHtml = '';

        if (maire.lien_google_maps) {
            actionsHtml += `<a href="${escapeHtml(maire.lien_google_maps)}" target="_blank" class="modal-btn primary">📍 Google Maps</a>`;
        }

        if (maire.lien_waze) {
            actionsHtml += `<a href="${escapeHtml(maire.lien_waze)}" target="_blank" class="modal-btn secondary">🚗 Waze</a>`;
        }

        if (maire.url_mairie) {
            actionsHtml += `<a href="${escapeHtml(maire.url_mairie)}" target="_blank" class="modal-btn info">🏛️ Mairie</a>`;
        }

        if (maire.email) {
            actionsHtml += `<a href="mailto:${escapeHtml(maire.email)}" class="modal-btn warning">✉️ Email</a>`;
        }

        return actionsHtml;
    }

    // Fonction pour ouvrir la modal avec les détails du maire
    function openMaireModal(maireId) {
        const modal = document.getElementById('maireModal');
        const modalBody = document.getElementById('modalBody');
        const modalActions = document.getElementById('modalActions');

        // Préparer le contenu du loader SANS afficher la modal
        modalBody.innerHTML = `
            <div class="loading">
                <div class="spinner"></div>
                <p>Chargement des détails...</p>
            </div>
        `;
        modalActions.innerHTML = '';

        // Requête AJAX pour récupérer les détails
        const params = new URLSearchParams({
            action: 'getMaireDetails',
            id: maireId
        });

        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success && data.maire) {
                    const maire = data.maire;

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

                    // Construire le titre
                    document.getElementById('modalTitle').innerHTML = buildModalTitle(maire);

                    // Construire le corps de la modal
                    const detailsHTML = buildMaireDetailsHTML(maire);
                    const demarchageHTML = buildDemarchageFormHTML(isReadOnly);
                    modalBody.innerHTML = detailsHTML + demarchageHTML + '</div>';

                    // Construire les boutons d'actions
                    modalActions.innerHTML = buildModalActionsHTML(maire);

                    // Charger les données de démarchage existantes
                    loadDemarcheData(maire.cle_unique, maireId);

                    // Afficher la modal après chargement du contenu
                    modal.classList.add('active');
                } else {
                    modalBody.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les détails</p></div>';
                    modal.classList.add('active');
                }
            })
            .catch(error => {
                modalBody.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les détails</p></div>';
                modal.classList.add('active');
            });
    }
    
    // Fonction pour fermer la modal
    function closeMaireModal() {
        document.getElementById('maireModal').classList.remove('active');
    }
    
    
    function loadDemarcheData(maireCleUnique, maireId) {
        AppState.currentMaireCleUnique = maireCleUnique;
        AppState.currentMaireId = maireId;

        const params = new URLSearchParams({
            action: 'getDemarchage',
            maire_cle_unique: maireCleUnique
        });

        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success && data.demarchage) {
                    const demarchage = data.demarchage;

                    // Déterminer le statut de démarchage
                    let statut = '0'; // Par défaut
                    if (demarchage.parrainage_obtenu == 1) {
                        statut = '4'; // Promesse de parrainage (nouvelle valeur)
                    } else if (demarchage.demarche_active == 1) {
                        // Utiliser le statut enregistré, ou par défaut "en cours"
                        statut = demarchage.statut_demarchage || '1';
                    }

                    document.getElementById('statutDemarchage').value = statut;

                    // Séparer la date et l'heure
                    if (demarchage.rdv_date) {
                        const rdvDateTime = new Date(demarchage.rdv_date);
                        const dateStr = rdvDateTime.toISOString().split('T')[0];
                        const timeStr = rdvDateTime.toTimeString().slice(0, 5);
                        document.getElementById('rdvDate').value = dateStr;
                        document.getElementById('rdvTime').value = timeStr;
                    } else {
                        document.getElementById('rdvDate').value = '';
                        document.getElementById('rdvTime').value = '';
                    }

                    document.getElementById('commentaire').value = demarchage.commentaire || '';
                }
            })
            .catch(error => {
                // Erreur silencieuse
            });
    }
    
    function saveDemarcheData() {
        if (!AppState.currentMaireCleUnique) {
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
        formData.append('maire_cle_unique', AppState.currentMaireCleUnique);
        formData.append('demarche_active', demarcheActive);
        formData.append('parrainage_obtenu', parrainageObtenu);
        formData.append('statut_demarchage', statutDemarchage);
        formData.append('rdv_date', rdvDateTime);
        formData.append('commentaire', commentaire);

        fetch('api.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(text => {
            try {
                const data = JSON.parse(text);
                if (data.success) {
                    // Mettre à jour la case à cocher et le style de la ligne dans le tableau
                    updateTableRow(AppState.currentMaireId, statutDemarchage);

                    // Mettre à jour les statistiques si "Communes traitées" est coché
                    const communesTraitees = document.getElementById('communesTraitees');
                    if (communesTraitees && communesTraitees.checked) {
                        loadStatsDemarchage();
                    }

                    // Fermer la modal
                    closeMaireModal();

                    // Afficher le message de succès après la fermeture
                    setTimeout(() => {
                        showNotification('Données enregistrées avec succès !', 'success');
                    }, 100);
                } else {
                    showNotification('Erreur lors de l\'enregistrement: ' + (data.error || 'Erreur inconnue'), 'error');
                }
            } catch (e) {
                // Erreur de parsing JSON
                alert('Erreur: réponse invalide du serveur');
            }
        })
        .catch(error => {
            alert('Erreur lors de l\'enregistrement des données');
        });
    }
    
    function updateTableRow(maireId, statutDemarchage) {
        // Trouver la ligne correspondante dans le tableau
        const row = document.querySelector(`tr[data-maire-id="${maireId}"]`);
        if (!row) return;

        const checkboxCell = row.querySelector('td:first-child');
        const checkbox = checkboxCell ? checkboxCell.querySelector('input[type="checkbox"]') : null;

        // Appliquer white-space: nowrap sur la cellule
        if (checkboxCell) {
            checkboxCell.style.whiteSpace = 'nowrap';
            checkboxCell.style.width = '70px';
        }

        // Cocher la case uniquement si un statut est sélectionné (statut > 0)
        if (checkbox) {
            checkbox.checked = parseInt(statutDemarchage) > 0;
        }

        // Ajouter/retirer les icônes selon le statut (utilise CONFIG)
        if (checkboxCell) {
            // Supprimer l'icône existante si elle existe
            const existingIcon = checkboxCell.querySelector('span');
            if (existingIcon) {
                existingIcon.remove();
            }

            // Ajouter l'icône selon le statut
            const statutInfo = CONFIG.STATUTS_DEMARCHAGE[parseInt(statutDemarchage)] || CONFIG.STATUTS_DEMARCHAGE[0];
            if (statutInfo.icon) {
                const statusIcon = document.createElement('span');
                const iconColor = parseInt(statutDemarchage) === 1 ? 'color: green;' : (parseInt(statutDemarchage) === 3 ? 'color: red;' : '');
                statusIcon.style.cssText = `${iconColor} font-size: 18px; margin-left: 5px; font-weight: bold; white-space: nowrap;`;
                statusIcon.title = statutInfo.label;
                statusIcon.textContent = statutInfo.icon;
                checkboxCell.appendChild(statusIcon);
            }
        }

        // Appliquer les couleurs selon le statut
        let rowStyle = '';
        let textStyle = '';
        switch(parseInt(statutDemarchage)) {
            case 1: rowStyle = 'background-color: #d3d3d3;'; break;
            case 2: rowStyle = 'background-color: #cfe2ff;'; break;
            case 3: textStyle = 'color: red; text-decoration: line-through;'; break;
            case 4: rowStyle = 'background-color: #c8e6c9; font-weight: bold;'; textStyle = 'font-weight: bold;'; break;
        }

        // Appliquer les styles à la ligne
        row.style.cssText = rowStyle;

        // Appliquer les styles de texte aux cellules (sauf la première et la deuxième colonne)
        const cells = row.querySelectorAll('td');
        cells.forEach((cell, index) => {
            if (index >= 2) { // Skip checkbox et colonne vide
                cell.style.cssText += textStyle;
            }
        });
    }
    
    // Fonction pour basculer l'affichage des communes traitées
    function toggleCommunesTraitees() {
        const isChecked = document.getElementById('communesTraitees').checked;
    
        if (isChecked) {
            // Charger et afficher les statistiques de démarchage
            loadStatsDemarchage();
        } else {
            // Recharger les statistiques normales (nombre total de communes)
            location.reload();
        }
    }
    
    // Fonction pour filtrer les lignes avec démarchage actif
    function filterDemarchageRows() {
        const resultsContainer = document.getElementById('resultsContainer');

        // Afficher le spinner
        resultsContainer.innerHTML = `
            <div class="loading">
                <div class="spinner"></div>
                <p>Chargement des communes traitées...</p>
            </div>
        `;

        // Construire les paramètres en fonction du contexte
        const params = new URLSearchParams({
            action: 'getMaires',
            filterDemarchage: '1',
            showAll: '1'
        });

        // Ajouter les filtres actuels
        const filters = getCurrentFilters();
        Object.keys(filters).forEach(key => {
            params.append(key, filters[key]);
        });

        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Ordre de priorité : 4 (Promesse de parrainage) → 1 (En cours) → 2 (RDV obtenu) → 3 (Terminé)
                    const priorityOrder = { 4: 1, 1: 2, 2: 3, 3: 4 };

                    // Trier les maires par statut de démarchage selon l'ordre de priorité
                    if (data.maires && data.maires.length > 0) {
                        data.maires.sort((a, b) => {
                            const statutA = parseInt(a.statut_demarchage) || 0;
                            const statutB = parseInt(b.statut_demarchage) || 0;
                            const priorityA = priorityOrder[statutA] || 999;
                            const priorityB = priorityOrder[statutB] || 999;
                            return priorityA - priorityB;
                        });
                    }

                    displayMairesInContainer(data, true);

                    if (data.maires.length === 0) {
                        resultsContainer.innerHTML = `
                            <div class="empty-state">
                                <h3>Aucune commune traitée</h3>
                                <p>Aucune commune avec démarchage actif trouvée</p>
                            </div>
                        `;
                    }
                } else {
                    resultsContainer.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les données</p></div>';
                }
            })
            .catch(error => {
                resultsContainer.innerHTML = '<div class="empty-state"><h3>Erreur</h3><p>Impossible de charger les données</p></div>';
            });
    }
    
    // Fonction pour exporter les données vers Excel
    function exportToExcel() {
        // Demander confirmation avant d'exporter
        if (!confirm('Voulez-vous générer le fichier CSV ?')) {
            return;
        }

        // Vérifier qu'il y a des données à exporter
        if (!AppState.currentMairesData || AppState.currentMairesData.length === 0) {
            alert('Aucune donnée à exporter');
            return;
        }

        // Récupérer les lignes visibles du tableau (après filtres d'en-tête)
        const table = document.querySelector('.maires-table');
        if (!table) {
            alert('Aucune donnée à exporter');
            return;
        }

        const visibleRows = table.querySelectorAll('tbody tr');
        const visibleMairesIds = [];

        // Récupérer les IDs des maires visibles
        visibleRows.forEach(row => {
            if (row.style.display !== 'none') {
                const maireId = row.getAttribute('data-maire-id');
                if (maireId) {
                    visibleMairesIds.push(parseInt(maireId));
                }
            }
        });

        if (visibleMairesIds.length === 0) {
            alert('Aucune donnée visible à exporter');
            return;
        }

        // Filtrer les données pour ne garder que les maires visibles
        const visibleMaires = AppState.currentMairesData.filter(maire =>
            visibleMairesIds.includes(maire.id)
        );

        // Créer le contenu CSV
        let csv = '\uFEFF'; // BOM UTF-8 pour Excel

        // En-têtes
        csv += 'Region;Departement;Circo;Canton;Commune;Nom du maire;Téléphone;Habitants;Statut démarchage;RDV;Commentaires\n';

        // Données
        visibleMaires.forEach(maire => {
            const region = maire.region || '';
            const departement = `${maire.numero_departement || ''} ${maire.nom_departement || ''}`.trim();
            const circo = maire.circonscription || '';
            const canton = maire.canton || '';
            const commune = maire.ville || '';
            const nomMaire = maire.nom_maire || '';
            const telephone = maire.telephone || '';
            const habitants = maire.nombre_habitants || '';
            // Utiliser CONFIG.STATUTS_DEMARCHAGE pour le label
            const statutInfo = CONFIG.STATUTS_DEMARCHAGE[parseInt(maire.statut_demarchage) || 0] || CONFIG.STATUTS_DEMARCHAGE[0];
            const statutDemarchage = statutInfo.label || '';
            const rdv = maire.rdv_date || '';
            const commentaires = (maire.commentaire || '').replace(/"/g, '""'); // Échapper les guillemets

            csv += `"${region}";"${departement}";"${circo}";"${canton}";"${commune}";"${nomMaire}";"${telephone}";"${habitants}";"${statutDemarchage}";"${rdv}";"${commentaires}"\n`;
        });

        // Créer le fichier et le télécharger
        downloadCSV(csv);
    }

    // Fonction helper pour télécharger le CSV
    function downloadCSV(csv) {
    
        // Créer le fichier et le télécharger
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);
    
        // Nom du fichier avec date
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
    
    }
    
    // Fonction pour mettre à jour les statistiques des départements d'un conteneur
    function updateDepartementsStats(container) {
        const params = new URLSearchParams({
            action: 'getStatsDemarchage'
        });
    
        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Mettre à jour les compteurs des départements dans le conteneur
                    container.querySelectorAll('.departement-item').forEach(deptItem => {
                        const deptNum = deptItem.getAttribute('data-dept-num');
                        const statDept = data.departements.find(d => d.numero_departement === deptNum);
    
                        if (statDept) {
                            const countElement = deptItem.querySelector('.departement-count');
                            if (countElement) {
                                countElement.textContent = statDept.nb_demarches;
                                countElement.style.backgroundColor = 'navy';
                                countElement.style.color = 'white';
                            }
                        }
                    });
                }
            })
            .catch(error => {
                // Erreur silencieuse
            });
    }
    
    // Fonction pour mettre à jour les compteurs des régions
    function updateRegionCounters(regions) {
        regions.forEach(region => {
            const regionHeaders = document.querySelectorAll(`.region-header[data-region="${region.region}"]`);

            regionHeaders.forEach(header => {
                const countElement = header.querySelector('.region-count');
                if (countElement) {
                    countElement.textContent = region.nb_demarches;
                    countElement.style.backgroundColor = 'navy';
                    countElement.style.color = 'white';
                }
            });
        });
    }

    // Fonction pour mettre à jour les compteurs des départements
    function updateDepartementCounters(departements) {
        departements.forEach(dept => {
            const deptElements = document.querySelectorAll(`.departement-item[data-dept-num="${dept.numero_departement}"]`);

            deptElements.forEach(elem => {
                const countElement = elem.querySelector('.departement-count');
                if (countElement) {
                    countElement.textContent = dept.nb_demarches;
                    countElement.style.backgroundColor = 'navy';
                    countElement.style.color = 'white';
                }
            });
        });
    }

    // Fonction pour charger les statistiques de démarchage
    function loadStatsDemarchage() {
        const params = new URLSearchParams({
            action: 'getStatsDemarchage'
        });

        fetch('api.php?' + params.toString())
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateRegionCounters(data.regions);
                    updateDepartementCounters(data.departements);
                }
            })
            .catch(error => {
                // Erreur silencieuse
            });
    }
    
    // Fermer la modal en cliquant sur l'overlay
    const maireModal = document.getElementById('maireModal');
    if (maireModal) {
        maireModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeMaireModal();
            }
        });
    }

    // Fermer la modal avec la touche Échap
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeMaireModal();
        }
    });

    // Mode département direct via URL
    if (window.DEPT_MODE && window.DEPT_MODE.enabled) {
        // Charger automatiquement le département
        setTimeout(() => {
            AppState.currentRegion = window.DEPT_MODE.region;
            AppState.currentDepartement = window.DEPT_MODE.numero;

            // Charger les maires du département directement
            loadMaires(window.DEPT_MODE.region, window.DEPT_MODE.numero, 'menu');
        }, 100);
    }

    // Exposer les fonctions nécessaires au scope global pour les onclick HTML
    window.resetAdvancedSearch = resetAdvancedSearch;
    window.closeMaireModal = closeMaireModal;
    window.openMaireModal = openMaireModal;
    window.changePageAdvanced = changePageAdvanced;
    window.changePage = changePage;
    window.resetHeaderFilters = resetHeaderFilters;
    window.resetFiltersMenu = resetFiltersMenu;
    window.toggleCommunesTraitees = toggleCommunesTraitees;
    window.saveDemarcheData = saveDemarcheData;

    // Exposer AppState et fonctions pour le menu arborescent
    window.AppState = AppState;
    window.loadMaires = loadMaires;
    window.loadMairesAdvanced = loadMairesAdvanced;
    window.loadCirconscriptions = loadCirconscriptions;
});
