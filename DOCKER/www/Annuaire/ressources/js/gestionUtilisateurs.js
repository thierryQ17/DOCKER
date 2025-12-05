/**
 * Scripts pour la page Gestion des Utilisateurs
 * Fichier extrait de gestionUtilisateurs.php
 */

let usersData = [];
let userModal = null;
let currentUserId = null;
let currentRoleFilter = null;
let originalCommentaires = ''; // Stocke les commentaires originaux sans le mot de passe

// Note: connectedUser est defini dans le PHP inline car il contient des donnees dynamiques

// Charger les utilisateurs
async function loadUsers() {
    const tbody = document.getElementById('usersTableBody');
    tbody.innerHTML = '<tr><td colspan="7" class="text-center"><i class="bi bi-arrow-repeat"></i> Chargement...</td></tr>';

    try {
        const response = await fetch('api.php?action=getAllUtilisateurs');
        const data = await response.json();

        if (data.success) {
            usersData = data.utilisateurs || [];
            renderUsersTable();
        } else {
            tbody.innerHTML = `<tr><td colspan="7" class="text-danger text-center">Erreur: ${data.error || 'Erreur inconnue'}</td></tr>`;
        }
    } catch (error) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-danger text-center">Erreur de chargement: ${error.message}</td></tr>`;
    }
}

// Afficher le tableau
function renderUsersTable(filteredData = null) {
    const data = filteredData || usersData;
    const tbody = document.getElementById('usersTableBody');

    if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">Aucun utilisateur trouve</td></tr>';
        return;
    }

    const roleNames = {
        1: { label: 'Super Admin', class: 'badge-super-admin' },
        2: { label: 'Admin', class: 'badge-admin' },
        3: { label: 'Referent', class: 'badge-referent' },
        4: { label: 'Membre', class: 'badge-membre' }
    };

    const sortedData = [...data].sort((a, b) => {
        const prenomA = (a.prenom || '').toLowerCase();
        const prenomB = (b.prenom || '').toLowerCase();
        return prenomA.localeCompare(prenomB, 'fr', { sensitivity: 'base' });
    });

    tbody.innerHTML = sortedData.map((user, index) => {
        const role = roleNames[user.typeUtilisateur_id] || { label: 'Inconnu', class: '' };
        const depts = user.departements || '-';
        const cantons = user.cantons || '-';
        const bgColor = index % 2 === 0 ? '#ffffff' : '#cce5ff';
        const bgColorDiv = index % 2 === 0 ? '#e8ecf0' : '#e6f3ff';
        const isActif = user.actif == 1;
        const statusBadge = isActif
            ? '<span class="badge bg-success">Actif</span>'
            : '<span class="badge bg-danger">Inactif</span>';

        // Extraire le département du nom s'il existe (format: NOM (Département))
        let nomBase = user.nom || '';
        let deptInName = '';
        const deptMatch = nomBase.match(/^(.+?)\s*\((.+)\)$/);
        if (deptMatch) {
            nomBase = deptMatch[1];
            deptInName = deptMatch[2];
        }

        const displayName = user.prenom && nomBase
            ? `${escapeHtml(user.prenom)} ${escapeHtml(nomBase.toUpperCase())}${deptInName ? `<span style="font-size: 0.75em; color: #666; font-weight: normal;"> (${escapeHtml(deptInName)})</span>` : ''}`
            : `${escapeHtml(nomBase || '')} ${escapeHtml(user.prenom || '')}`.trim() || '-';

        return `
            <tr onclick="editUser(${user.id})" style="cursor: pointer; background-color: ${bgColor};">
                <td style="vertical-align: top; background-color: ${bgColor} !important;">${displayName}</td>
                <td style="vertical-align: top; background-color: ${bgColor} !important;">${escapeHtml(user.email || '-')}</td>
                <td style="vertical-align: top; padding: 2px; background-color: ${bgColor} !important;">
                    <div style="font-size: 11px; max-width: 250px; max-height: 60px; overflow-y: auto; padding: 8px; line-height: 1.4; margin: 2px; background-color: ${bgColorDiv}; border-radius: 4px;">
                        ${depts}
                    </div>
                </td>
                <td style="vertical-align: top; padding: 2px; background-color: ${bgColor} !important;">
                    <div style="font-size: 11px; max-width: 250px; max-height: 60px; overflow-y: auto; padding: 8px; line-height: 1.4; margin: 2px; background-color: ${bgColorDiv}; border-radius: 4px;">
                        ${cantons}
                    </div>
                </td>
                <td style="vertical-align: top; background-color: ${bgColor} !important;"><span class="badge-role ${role.class}">${role.label}</span></td>
                <td style="vertical-align: top; background-color: ${bgColor} !important;">${statusBadge}</td>
                <td style="vertical-align: top; background-color: ${bgColor} !important;" onclick="event.stopPropagation()">
                    <button class="btn btn-sm" style="border: none; background: none; color: #dc3545; padding: 4px 8px;" onclick="deleteUser(${user.id})" title="Supprimer">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Echapper HTML
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Normaliser une chaine (retirer les accents)
function normalizeString(str) {
    return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
}

// Filtrer par role
function filterByRole(roleId) {
    if (currentRoleFilter === roleId) {
        currentRoleFilter = null;
        document.querySelectorAll('.stats-card .details .badge').forEach(badge => {
            badge.classList.remove('active');
        });
    } else {
        currentRoleFilter = roleId;
        document.querySelectorAll('.stats-card .details .badge').forEach(badge => {
            badge.classList.remove('active');
        });
        const activeBadge = document.getElementById(`badge-role-${roleId}`);
        if (activeBadge) {
            activeBadge.classList.add('active');
        }
    }
    filterUsers();
}

// Filtres avec recherche multi-criteres
function filterUsers() {
    const search = document.getElementById('searchUsers').value.trim();

    let dataToFilter = usersData;
    if (currentRoleFilter !== null) {
        dataToFilter = usersData.filter(user => user.typeUtilisateur_id == currentRoleFilter);
    }

    if (!search) {
        renderUsersTable(dataToFilter);
        return;
    }

    const searchTerms = search.toLowerCase().split(/\s+/).filter(term => term.length > 0);

    const filtered = dataToFilter.filter(user => {
        const roleNames = {
            1: 'super admin',
            2: 'admin',
            3: 'referent',
            4: 'membre'
        };
        const userRole = roleNames[user.typeUtilisateur_id] || '';
        const depts = user.departements ? user.departements.replace(/<br>/g, ' ').toLowerCase() : '';
        const cantons = user.cantons ? user.cantons.replace(/<br>/g, ' ').toLowerCase() : '';
        const userStatus = user.actif == 1 ? 'actif' : 'inactif';

        const combinedData = normalizeString([
            user.nom || '',
            user.prenom || '',
            user.pseudo || '',
            user.email || '',
            userRole,
            depts,
            cantons,
            userStatus
        ].join(' '));

        return searchTerms.every(term => {
            const normalizedTerm = normalizeString(term);
            return combinedData.includes(normalizedTerm);
        });
    });

    renderUsersTable(filtered);
}

// Attacher les evenements apres le chargement du DOM
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('searchUsers').addEventListener('input', filterUsers);

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && userModal && document.getElementById('userModal').classList.contains('show')) {
            userModal.hide();
        }
    });
});

// Actions
async function addUser() {
    currentUserId = null;
    originalCommentaires = ''; // Réinitialiser les commentaires originaux
    document.getElementById('userModalTitle').innerHTML = '<i class="bi bi-person-plus me-2"></i>Nouvel utilisateur';
    document.getElementById('userForm').reset();

    document.getElementById('userPassword').value = '';
    document.getElementById('userPasswordConfirm').value = '';
    document.getElementById('passwordError').style.display = 'none';
    document.getElementById('userPasswordConfirm').classList.remove('is-invalid');
    document.getElementById('passwordHint').textContent = 'Minimum 6 caracteres (obligatoire)';

    document.getElementById('generatedPassword').value = '';
    document.getElementById('copyPasswordBtn').disabled = true;
    document.getElementById('passwordComplexity').value = 'high';
    document.getElementById('userCommentaires').value = '';

    document.getElementById('menuTree').innerHTML = '<p class="text-muted">Selectionnez les departements auxquels l\'utilisateur aura acces</p>';
    document.getElementById('cantonTree').innerHTML = '<p class="text-muted">Selectionnez les cantons auxquels l\'utilisateur aura acces</p>';

    // Réinitialiser le champ département
    if (typeof setDepartementValue === 'function') {
        setDepartementValue('');
    } else {
        document.getElementById('userDepartement').value = '';
    }
    document.getElementById('departementRow').style.display = 'none';

    // Si l'utilisateur connecté est un référent, pré-sélectionner "Membre" par défaut
    if (connectedUser.type === 3) {
        document.getElementById('userType').value = '4';
    }

    // Afficher/masquer le champ département selon le type sélectionné
    toggleDepartementField();

    await loadMenuTree(0);
    await loadCantonTree(0);

    if (!userModal) {
        userModal = new bootstrap.Modal(document.getElementById('userModal'));
    }
    userModal.show();
}

// Charger l'arborescence Menu (Departements)
async function loadMenuTree(userId) {
    const menuTreeDiv = document.getElementById('menuTree');
    menuTreeDiv.innerHTML = '<p class="text-muted"><i class="bi bi-arrow-repeat"></i> Chargement de l\'arborescence...</p>';

    try {
        const response = await fetch('api.php?action=getRegionsDepartements');
        const data = await response.json();

        if (data.success) {
            const rightsResponse = await fetch(`api.php?action=getUserDroits&userId=${userId}`);
            const rightsData = await rightsResponse.json();
            let userDepts = rightsData.success ? rightsData.departements : [];

            // Si c'est un nouvel utilisateur (userId = 0) et que l'utilisateur connecté est un référent,
            // pré-cocher les départements du référent
            if (connectedUser.type === 3 && userId === 0 && userDepts.length === 0) {
                userDepts = connectedUser.allowedDepts || [];
            }

            let html = '<div style="padding: 5px;">';

            const domtomRegions = ['Guadeloupe', 'Guyane', 'La-Reunion', 'Martinique', 'Mayotte'];
            const metroRegions = [];
            const domtomDepts = [];

            const isReferent = connectedUser.type === 3;
            const isReferentCreatingNew = isReferent && userId === 0;
            const allowedDepts = connectedUser.allowedDepts || [];

            data.regions.forEach(region => {
                if (domtomRegions.includes(region.nom_region)) {
                    region.departements.forEach(dept => {
                        if (!isReferent || allowedDepts.includes(dept.id)) {
                            domtomDepts.push(dept);
                        }
                    });
                } else {
                    if (isReferent) {
                        const filteredDepts = region.departements.filter(dept => allowedDepts.includes(dept.id));
                        if (filteredDepts.length > 0) {
                            metroRegions.push({
                                nom_region: region.nom_region,
                                departements: filteredDepts
                            });
                        }
                    } else {
                        metroRegions.push(region);
                    }
                }
            });

            if (isReferent && metroRegions.length === 0 && domtomDepts.length === 0) {
                menuTreeDiv.innerHTML = '<p class="text-muted" style="padding: 15px; text-align: center;"><i class="bi bi-info-circle me-2"></i>Aucun departement disponible. Vos droits d\'acces sont limites a vos departements assignes.</p>';
                return;
            }

            metroRegions.forEach((region, regionIndex) => {
                const regionId = `region_${regionIndex}`;
                const checkedCount = region.departements.filter(dept => userDepts.includes(dept.id)).length;
                const headerBg = checkedCount > 0 ? 'background: linear-gradient(to right, #e3f2fd 0%, #bbdefb 100%);' : 'background: linear-gradient(to right, #f0f0f0 0%, #e8e8e8 100%);';

                html += `<div style="margin-bottom: 6px;">`;
                html += `<h6 style="cursor: pointer; user-select: none; padding: 8px; margin: -5px -10px 8px -10px; ${headerBg} border-radius: 4px; display: flex; align-items: center; justify-content: space-between;" onclick="toggleMenuRegion('${regionId}')">`;
                html += `<span><i class="bi bi-chevron-right me-1" id="icon_${regionId}"></i>${region.nom_region}</span>`;
                html += `<span style="display: flex; align-items: center; gap: 8px;">`;
                html += `<span style="display: ${checkedCount > 0 ? 'inline-block' : 'none'}; min-width: 32px; height: 22px; line-height: 22px; text-align: center; background: white; border: 1px solid #667eea; border-radius: 4px; font-size: 11px; font-weight: 700; color: #667eea; padding: 0 6px;" id="count_${regionId}">${checkedCount}</span>`;
                html += `<i class="bi bi-plus-square-fill icon-check-all" onclick="event.stopPropagation(); checkAllInRegion('${regionId}')" title="Cocher toutes les options"></i>`;
                html += `<i class="bi bi-dash-square-fill icon-uncheck-all" onclick="event.stopPropagation(); uncheckAllInRegion('${regionId}')" title="Decocher toutes les options"></i>`;
                html += `</span>`;
                html += `</h6>`;
                html += `<div id="${regionId}" style="margin-left: 15px; display: none;">`;
                region.departements.forEach(dept => {
                    const isChecked = userDepts.includes(dept.id);
                    const bgColor = isChecked ? 'background-color: #e3f2fd; border-left: 3px solid #667eea; padding-left: 8px;' : '';
                    html += `<div style="margin-bottom: 3px; ${bgColor}">`;
                    html += `<input type="checkbox" class="form-check-input me-1" id="dept_${dept.id}" value="${dept.id}" ${isChecked ? 'checked' : ''}>`;
                    html += `<label class="form-check-label" for="dept_${dept.id}">${dept.numero_departement} - ${dept.nom_departement}</label>`;
                    html += `</div>`;
                });
                html += `</div>`;
                html += `</div>`;
            });

            if (domtomDepts.length > 0) {
                const domtomId = 'region_domtom';
                const domtomCheckedCount = domtomDepts.filter(dept => userDepts.includes(dept.id)).length;
                const domtomHeaderBg = domtomCheckedCount > 0 ? 'background: linear-gradient(to right, #f3e5f5 0%, #e1bee7 100%);' : 'background: linear-gradient(to right, #f0f0f0 0%, #e8e8e8 100%);';

                html += `<div style="margin-bottom: 6px; margin-top: 10px; padding-top: 10px; border-top: 2px solid #e0e0e0;">`;
                html += `<h6 style="cursor: pointer; user-select: none; color: #764ba2; padding: 8px; margin: -5px -10px 8px -10px; ${domtomHeaderBg} border-radius: 4px; display: flex; align-items: center; justify-content: space-between;" onclick="toggleMenuRegion('${domtomId}')">`;
                html += `<span><i class="bi bi-chevron-right me-1" id="icon_${domtomId}"></i>DOM-TOM</span>`;
                html += `<span style="display: flex; align-items: center; gap: 8px;">`;
                html += `<span style="display: ${domtomCheckedCount > 0 ? 'inline-block' : 'none'}; min-width: 32px; height: 22px; line-height: 22px; text-align: center; background: white; border: 1px solid #764ba2; border-radius: 4px; font-size: 11px; font-weight: 700; color: #764ba2; padding: 0 6px;" id="count_${domtomId}">${domtomCheckedCount}</span>`;
                html += `<i class="bi bi-plus-square-fill icon-check-all" onclick="event.stopPropagation(); checkAllInRegion('${domtomId}')" title="Cocher toutes les options"></i>`;
                html += `<i class="bi bi-dash-square-fill icon-uncheck-all" onclick="event.stopPropagation(); uncheckAllInRegion('${domtomId}')" title="Decocher toutes les options"></i>`;
                html += `</span>`;
                html += `</h6>`;
                html += `<div id="${domtomId}" style="margin-left: 15px; display: none;">`;
                domtomDepts.forEach(dept => {
                    const isChecked = userDepts.includes(dept.id);
                    const bgColor = isChecked ? 'background-color: #f3e5f5; border-left: 3px solid #764ba2; padding-left: 8px;' : '';
                    html += `<div style="margin-bottom: 3px; ${bgColor}">`;
                    html += `<input type="checkbox" class="form-check-input me-1" id="dept_${dept.id}" value="${dept.id}" ${isChecked ? 'checked' : ''}>`;
                    html += `<label class="form-check-label" for="dept_${dept.id}">${dept.numero_departement} - ${dept.nom_departement}</label>`;
                    html += `</div>`;
                });
                html += `</div>`;
                html += `</div>`;
            }

            html += '</div>';
            menuTreeDiv.innerHTML = html;

            // Si c'est un nouvel utilisateur créé par un référent, ouvrir les régions avec des départements cochés
            if (isReferentCreatingNew && userDepts.length > 0) {
                document.querySelectorAll('#menuTree [id^="region_"]').forEach(regionDiv => {
                    const hasChecked = regionDiv.querySelectorAll('input[type="checkbox"]:checked').length > 0;
                    if (hasChecked) {
                        regionDiv.style.display = 'block';
                        const icon = document.getElementById('icon_' + regionDiv.id);
                        if (icon) {
                            icon.classList.remove('bi-chevron-right');
                            icon.classList.add('bi-chevron-down');
                        }
                    }
                });
            }

            document.querySelectorAll('#menuTree input[type="checkbox"]').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    updateRegionCounts();
                    loadCantonTree(currentUserId || 0);
                });
            });
        } else {
            menuTreeDiv.innerHTML = '<p class="text-danger">Erreur lors du chargement</p>';
        }
    } catch (error) {
        menuTreeDiv.innerHTML = `<p class="text-danger">Erreur: ${error.message}</p>`;
    }
}

// Mettre a jour les compteurs de toutes les regions
function updateRegionCounts() {
    document.querySelectorAll('[id^="count_region"]').forEach(countElement => {
        const regionId = countElement.id.replace('count_', '');
        const regionDiv = document.getElementById(regionId);

        if (regionDiv) {
            const checkedCount = regionDiv.querySelectorAll('input[type="checkbox"]:checked').length;
            countElement.textContent = checkedCount;
            countElement.style.display = checkedCount > 0 ? 'inline-block' : 'none';
        }
    });
}

// Toggle region dans l'arborescence Menu
function toggleMenuRegion(regionId) {
    const element = document.getElementById(regionId);
    const icon = document.getElementById('icon_' + regionId);

    if (element && icon) {
        const isHidden = element.style.display === 'none' || element.style.display === '';
        element.style.display = isHidden ? 'block' : 'none';

        const newIcon = document.createElement('i');
        newIcon.className = isHidden ? 'bi bi-chevron-down me-1' : 'bi bi-chevron-right me-1';
        newIcon.id = 'icon_' + regionId;
        icon.parentNode.replaceChild(newIcon, icon);
    }
}

// Cocher toutes les options d'une region
function checkAllInRegion(regionId) {
    const regionDiv = document.getElementById(regionId);
    if (regionDiv) {
        const checkboxes = regionDiv.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(cb => { cb.checked = true; });
        updateRegionCounts();
        loadCantonTree(currentUserId || 0);
    }
}

// Decocher toutes les options d'une region
function uncheckAllInRegion(regionId) {
    const regionDiv = document.getElementById(regionId);
    if (regionDiv) {
        const checkboxes = regionDiv.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(cb => { cb.checked = false; });
        updateRegionCounts();
        loadCantonTree(currentUserId || 0);
    }
}

// Charger l'arborescence Canton
async function loadCantonTree(userId) {
    const cantonTreeDiv = document.getElementById('cantonTree');
    cantonTreeDiv.innerHTML = '<p class="text-muted"><i class="bi bi-arrow-repeat"></i> Chargement de l\'arborescence...</p>';

    try {
        const regionsResponse = await fetch('api.php?action=getRegionsDepartements');
        const regionsData = await regionsResponse.json();

        if (!regionsData.success) {
            cantonTreeDiv.innerHTML = '<p class="text-danger">Erreur lors du chargement des departements</p>';
            return;
        }

        const deptIdToNumero = {};
        const deptIdToRegion = {};
        regionsData.regions.forEach(region => {
            region.departements.forEach(dept => {
                deptIdToNumero[dept.id] = dept.numero_departement;
                deptIdToRegion[dept.id] = region.nom_region;
            });
        });

        const checkedDepts = document.querySelectorAll('#menuTree input[type="checkbox"]:checked');
        let userDeptIds = Array.from(checkedDepts).map(cb => parseInt(cb.value));

        if (userDeptIds.length === 0) {
            cantonTreeDiv.innerHTML = '<p class="text-muted" style="padding: 15px; text-align: center;"><i class="bi bi-info-circle me-2"></i>Veuillez d\'abord selectionner des departements dans l\'onglet "Acces Menu"</p>';
            return;
        }

        const selectedDeptNumeros = userDeptIds.map(id => deptIdToNumero[id]).filter(n => n);

        if (selectedDeptNumeros.length === 0) {
            cantonTreeDiv.innerHTML = '<p class="text-muted" style="padding: 15px; text-align: center;"><i class="bi bi-info-circle me-2"></i>Aucun departement valide selectionne</p>';
            return;
        }

        const response = await fetch('api.php?action=getAllCantons');
        const data = await response.json();

        if (data.success) {
            const rightsResponse = await fetch(`api.php?action=getUserCantons&userId=${userId}`);
            const rightsData = await rightsResponse.json();
            const userCantons = rightsData.success ? rightsData.cantons : [];

            let html = '<div style="padding: 5px;">';
            const cantonsByDept = {};
            const deptNames = {};
            const deptRegions = {};

            userDeptIds.forEach(deptId => {
                const numeroDepart = deptIdToNumero[deptId];
                const regionName = deptIdToRegion[deptId];
                if (numeroDepart && regionName) {
                    deptRegions[numeroDepart] = regionName;
                }
            });

            data.cantons.forEach(canton => {
                if (selectedDeptNumeros.includes(canton.numero_departement)) {
                    if (!cantonsByDept[canton.numero_departement]) {
                        cantonsByDept[canton.numero_departement] = [];
                        deptNames[canton.numero_departement] = canton.nom_departement;
                    }
                    cantonsByDept[canton.numero_departement].push(canton);
                }
            });

            const domtomDepts = ['971', '972', '973', '974', '976'];
            const metroDepts = [];
            const domtomCantons = {};

            Object.keys(cantonsByDept).sort().forEach(dept => {
                if (domtomDepts.includes(dept)) {
                    domtomCantons[dept] = cantonsByDept[dept];
                } else {
                    metroDepts.push(dept);
                }
            });

            metroDepts.sort((a, b) => {
                const regionA = deptRegions[a] || '';
                const regionB = deptRegions[b] || '';
                const regionCompare = regionA.localeCompare(regionB, 'fr', { sensitivity: 'base' });
                if (regionCompare !== 0) return regionCompare;
                const nameA = deptNames[a] || '';
                const nameB = deptNames[b] || '';
                return nameA.localeCompare(nameB, 'fr', { sensitivity: 'base' });
            });

            metroDepts.forEach((dept, deptIndex) => {
                const deptId = `dept_canton_${deptIndex}`;
                const deptName = deptNames[dept] || '';
                const regionName = deptRegions[dept] || '';
                const checkedCount = cantonsByDept[dept].filter(canton =>
                    userCantons.some(uc => uc.canton === canton.canton && uc.numero_departement === dept)
                ).length;
                const headerBg = checkedCount > 0 ? 'background: linear-gradient(to right, #e3f2fd 0%, #bbdefb 100%);' : 'background: linear-gradient(to right, #f0f0f0 0%, #e8e8e8 100%);';

                html += `<div style="margin-bottom: 6px;">`;
                html += `<h6 style="cursor: pointer; user-select: none; padding: 8px; margin: -5px -10px 8px -10px; ${headerBg} border-radius: 4px; display: flex; align-items: center; justify-content: space-between;" onclick="toggleCantonDept('${deptId}')">`;
                html += `<span><i class="bi bi-chevron-right me-1" id="icon_${deptId}"></i>${regionName} - <strong>${dept} - ${deptName}</strong></span>`;
                html += `<span style="display: flex; align-items: center; gap: 8px;">`;
                html += `<span style="display: ${checkedCount > 0 ? 'inline-block' : 'none'}; min-width: 32px; height: 22px; line-height: 22px; text-align: center; background: white; border: 1px solid #667eea; border-radius: 4px; font-size: 11px; font-weight: 700; color: #667eea; padding: 0 6px;" id="count_${deptId}">${checkedCount}</span>`;
                html += `<i class="bi bi-plus-square-fill icon-check-all" onclick="event.stopPropagation(); checkAllInDept('${deptId}')" title="Cocher toutes les options"></i>`;
                html += `<i class="bi bi-dash-square-fill icon-uncheck-all" onclick="event.stopPropagation(); uncheckAllInDept('${deptId}')" title="Decocher toutes les options"></i>`;
                html += `</span>`;
                html += `</h6>`;
                html += `<div id="${deptId}" style="margin-left: 15px; display: none;">`;

                const sortedCantons = [...cantonsByDept[dept]].sort((a, b) => {
                    return a.canton.localeCompare(b.canton, 'fr', { sensitivity: 'base' });
                });
                sortedCantons.forEach(canton => {
                    const isChecked = userCantons.some(uc => uc.canton === canton.canton && uc.numero_departement === dept);
                    const bgColor = isChecked ? 'background-color: #e3f2fd; border-left: 3px solid #667eea; padding-left: 8px;' : '';
                    const circoLabel = canton.circonscription ? `${canton.circonscription} - ` : '';
                    html += `<div style="margin-bottom: 3px; ${bgColor}">`;
                    html += `<input type="checkbox" class="form-check-input me-1" id="canton_${dept}_${canton.canton.replace(/\s+/g, '_')}" data-dept="${dept}" data-canton="${canton.canton}" ${isChecked ? 'checked' : ''}>`;
                    html += `<label class="form-check-label" for="canton_${dept}_${canton.canton.replace(/\s+/g, '_')}">${circoLabel}<strong>${canton.canton}</strong></label>`;
                    html += `</div>`;
                });
                html += `</div>`;
                html += `</div>`;
            });

            if (Object.keys(domtomCantons).length > 0) {
                const domtomId = 'domtom_cantons';
                let domtomCheckedTotal = 0;

                Object.keys(domtomCantons).forEach(dept => {
                    domtomCheckedTotal += domtomCantons[dept].filter(canton =>
                        userCantons.some(uc => uc.canton === canton.canton && uc.numero_departement === dept)
                    ).length;
                });
                const domtomHeaderBg = domtomCheckedTotal > 0 ? 'background: linear-gradient(to right, #f3e5f5 0%, #e1bee7 100%);' : 'background: linear-gradient(to right, #f0f0f0 0%, #e8e8e8 100%);';

                html += `<div style="margin-bottom: 6px; margin-top: 10px; padding-top: 10px; border-top: 2px solid #e0e0e0;">`;
                html += `<h6 style="cursor: pointer; user-select: none; color: #764ba2; padding: 8px; margin: -5px -10px 8px -10px; ${domtomHeaderBg} border-radius: 4px; display: flex; align-items: center; justify-content: space-between;" onclick="toggleCantonDept('${domtomId}')">`;
                html += `<span><i class="bi bi-chevron-right me-1" id="icon_${domtomId}"></i>DOM-TOM</span>`;
                html += `<span style="display: flex; align-items: center; gap: 8px;">`;
                html += `<span style="display: ${domtomCheckedTotal > 0 ? 'inline-block' : 'none'}; min-width: 32px; height: 22px; line-height: 22px; text-align: center; background: white; border: 1px solid #764ba2; border-radius: 4px; font-size: 11px; font-weight: 700; color: #764ba2; padding: 0 6px;" id="count_${domtomId}">${domtomCheckedTotal}</span>`;
                html += `<i class="bi bi-plus-square-fill icon-check-all" onclick="event.stopPropagation(); checkAllInDept('${domtomId}')" title="Cocher toutes les options"></i>`;
                html += `<i class="bi bi-dash-square-fill icon-uncheck-all" onclick="event.stopPropagation(); uncheckAllInDept('${domtomId}')" title="Decocher toutes les options"></i>`;
                html += `</span>`;
                html += `</h6>`;
                html += `<div id="${domtomId}" style="margin-left: 15px; display: none;">`;

                Object.keys(domtomCantons).sort().forEach((dept, subIndex) => {
                    const subDeptId = `domtom_dept_${subIndex}`;
                    const subDeptName = deptNames[dept] || '';
                    const subRegionName = deptRegions[dept] || '';
                    const subCheckedCount = domtomCantons[dept].filter(canton =>
                        userCantons.some(uc => uc.canton === canton.canton && uc.numero_departement === dept)
                    ).length;
                    const subHeaderBg = subCheckedCount > 0 ? 'background: linear-gradient(to right, #f3e5f5 0%, #e1bee7 100%);' : 'background: linear-gradient(to right, #f5f0f7 0%, #ede8ef 100%);';

                    html += `<div style="margin-bottom: 5px; margin-top: 5px;">`;
                    html += `<h6 style="cursor: pointer; user-select: none; font-size: 0.85rem; padding: 6px; margin: 0 -5px 5px -5px; ${subHeaderBg} border-radius: 4px; display: flex; align-items: center; justify-content: space-between;" onclick="toggleCantonDept('${subDeptId}')">`;
                    html += `<span><i class="bi bi-chevron-right me-1" id="icon_${subDeptId}"></i>${subRegionName} - <strong>${dept} - ${subDeptName}</strong></span>`;
                    html += `<span style="display: flex; align-items: center; gap: 8px;">`;
                    html += `<span style="display: ${subCheckedCount > 0 ? 'inline-block' : 'none'}; min-width: 32px; height: 22px; line-height: 22px; text-align: center; background: white; border: 1px solid #764ba2; border-radius: 4px; font-size: 11px; font-weight: 700; color: #764ba2; padding: 0 6px;" id="count_${subDeptId}">${subCheckedCount}</span>`;
                    html += `<i class="bi bi-plus-square-fill icon-check-all" onclick="event.stopPropagation(); checkAllInDept('${subDeptId}')" title="Cocher toutes les options"></i>`;
                    html += `<i class="bi bi-dash-square-fill icon-uncheck-all" onclick="event.stopPropagation(); uncheckAllInDept('${subDeptId}')" title="Decocher toutes les options"></i>`;
                    html += `</span>`;
                    html += `</h6>`;
                    html += `<div id="${subDeptId}" style="margin-left: 15px; display: none;">`;

                    const sortedDomtomCantons = [...domtomCantons[dept]].sort((a, b) => {
                        return a.canton.localeCompare(b.canton, 'fr', { sensitivity: 'base' });
                    });
                    sortedDomtomCantons.forEach(canton => {
                        const isChecked = userCantons.some(uc => uc.canton === canton.canton && uc.numero_departement === dept);
                        const bgColor = isChecked ? 'background-color: #f3e5f5; border-left: 3px solid #764ba2; padding-left: 8px;' : '';
                        const circoLabel = canton.circonscription ? `${canton.circonscription} - ` : '';
                        html += `<div style="margin-bottom: 3px; ${bgColor}">`;
                        html += `<input type="checkbox" class="form-check-input me-1" id="canton_${dept}_${canton.canton.replace(/\s+/g, '_')}" data-dept="${dept}" data-canton="${canton.canton}" ${isChecked ? 'checked' : ''}>`;
                        html += `<label class="form-check-label" for="canton_${dept}_${canton.canton.replace(/\s+/g, '_')}">${circoLabel}<strong>${canton.canton}</strong></label>`;
                        html += `</div>`;
                    });
                    html += `</div>`;
                    html += `</div>`;
                });

                html += `</div>`;
                html += `</div>`;
            }
            html += '</div>';
            cantonTreeDiv.innerHTML = html;

            document.querySelectorAll('#cantonTree input[type="checkbox"]').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    updateCantonCounts();
                });
            });
        } else {
            cantonTreeDiv.innerHTML = '<p class="text-danger">Erreur lors du chargement</p>';
        }
    } catch (error) {
        cantonTreeDiv.innerHTML = `<p class="text-danger">Erreur: ${error.message}</p>`;
    }
}

// Mettre a jour les compteurs de tous les departements/cantons
function updateCantonCounts() {
    document.querySelectorAll('[id^="count_dept_canton"], [id^="count_domtom"]').forEach(countElement => {
        const deptId = countElement.id.replace('count_', '');
        const deptDiv = document.getElementById(deptId);

        if (deptDiv) {
            const checkedCount = deptDiv.querySelectorAll('input[type="checkbox"]:checked').length;
            countElement.textContent = checkedCount;
            countElement.style.display = checkedCount > 0 ? 'inline-block' : 'none';
        }
    });
}

// Toggle departement dans l'arborescence Canton
function toggleCantonDept(deptId) {
    const element = document.getElementById(deptId);
    const icon = document.getElementById('icon_' + deptId);

    if (element && icon) {
        const isHidden = element.style.display === 'none' || element.style.display === '';
        element.style.display = isHidden ? 'block' : 'none';

        const newIcon = document.createElement('i');
        newIcon.className = isHidden ? 'bi bi-chevron-down me-1' : 'bi bi-chevron-right me-1';
        newIcon.id = 'icon_' + deptId;
        icon.parentNode.replaceChild(newIcon, icon);
    }
}

// Cocher toutes les options d'un departement
function checkAllInDept(deptId) {
    const deptDiv = document.getElementById(deptId);
    if (deptDiv) {
        const checkboxes = deptDiv.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(cb => { cb.checked = true; });
        updateCantonCounts();
    }
}

// Decocher toutes les options d'un departement
function uncheckAllInDept(deptId) {
    const deptDiv = document.getElementById(deptId);
    if (deptDiv) {
        const checkboxes = deptDiv.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(cb => { cb.checked = false; });
        updateCantonCounts();
    }
}

async function editUser(id) {
    const user = usersData.find(u => u.id == id);
    if (!user) return;

    currentUserId = id;

    const prenom = user.prenom || '';
    const nom = (user.nom || '').toUpperCase();
    const titre = prenom && nom ? `Utilisateur : ${prenom} ${nom}` : 'Modifier l\'utilisateur';
    document.getElementById('userModalTitle').innerHTML = `<i class="bi bi-pencil me-2"></i>${titre}`;
    document.getElementById('userName').value = user.nom || '';
    document.getElementById('userFirstName').value = user.prenom || '';
    document.getElementById('userEmail').value = user.email || '';
    document.getElementById('userTelephone').value = user.telephone || '';
    document.getElementById('userPseudo').value = user.pseudo || '';
    document.getElementById('userType').value = user.typeUtilisateur_id || '';
    document.getElementById('userStatus').value = (user.actif !== undefined && user.actif !== null) ? user.actif : '1';
    document.getElementById('userCommentaires').value = user.commentaires || '';
    originalCommentaires = user.commentaires || ''; // Stocker les commentaires originaux

    // Charger le département si c'est un référent
    if (typeof setDepartementValue === 'function') {
        setDepartementValue(user.departement_id || '');
    } else {
        document.getElementById('userDepartement').value = user.departement_id || '';
    }
    toggleDepartementField();

    document.getElementById('userPassword').value = '';
    document.getElementById('userPasswordConfirm').value = '';
    document.getElementById('passwordError').style.display = 'none';
    document.getElementById('userPasswordConfirm').classList.remove('is-invalid');
    document.getElementById('passwordHint').textContent = 'Laisser vide pour ne pas changer';

    document.getElementById('generatedPassword').value = '';
    document.getElementById('copyPasswordBtn').disabled = true;
    document.getElementById('passwordComplexity').value = 'high';

    document.getElementById('info-tab').click();

    await loadMenuTree(id);
    await loadCantonTree(id);

    if (!userModal) {
        userModal = new bootstrap.Modal(document.getElementById('userModal'));
    }
    userModal.show();
}

async function deleteUser(id) {
    if (!confirm('Etes-vous sur de vouloir supprimer cet utilisateur ?\n\nCette action supprimera egalement tous les departements et cantons associes.')) return;

    try {
        const response = await fetch(`api.php?action=deleteUtilisateur&id=${id}`, {
            method: 'GET'
        });

        const result = await response.json();

        if (result.success) {
            alert('Utilisateur supprime avec succes');
            loadUsers();
        } else {
            alert('Erreur lors de la suppression : ' + (result.error || 'Erreur inconnue'));
        }
    } catch (error) {
        alert('Erreur lors de la suppression : ' + error.message);
    }
}

async function saveUser() {
    const toProperCase = (str) => {
        return str.toLowerCase().replace(/\b\w/g, char => char.toUpperCase());
    };

    const nom = document.getElementById('userName').value.trim().toUpperCase();
    const prenom = toProperCase(document.getElementById('userFirstName').value.trim());
    const email = document.getElementById('userEmail').value.trim();
    const telephone = document.getElementById('userTelephone').value.trim();
    const pseudo = document.getElementById('userPseudo').value.trim();
    const typeUtilisateur_id = document.getElementById('userType').value;
    const departement_id = document.getElementById('userDepartement').value;
    const actif = document.getElementById('userStatus').value;
    const commentaires = document.getElementById('userCommentaires').value.trim();
    const password = document.getElementById('userPassword').value;
    const passwordConfirm = document.getElementById('userPasswordConfirm').value;

    if (!nom || !prenom || !email || !pseudo || !typeUtilisateur_id) {
        alert('Veuillez remplir tous les champs obligatoires');
        return;
    }

    // Validation du département obligatoire pour les Référents
    if (typeUtilisateur_id === '3' && !departement_id) {
        alert('Le département est obligatoire pour un Référent');
        document.getElementById('userDepartement').focus();
        return;
    }

    // Validation de l'email
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
        alert('Veuillez saisir une adresse email valide (ex: nom@domaine.fr)');
        document.getElementById('userEmail').focus();
        return;
    }

    // Validation du téléphone (si renseigné)
    if (telephone) {
        // Nettoyer le numéro : garder uniquement les chiffres et le +
        const telClean = telephone.replace(/[\s.-]/g, '');
        // Format français : 10 chiffres commençant par 0, ou +33 suivi de 9 chiffres
        const telRegexFr = /^(0[1-9][0-9]{8}|\+33[1-9][0-9]{8})$/;
        if (!telRegexFr.test(telClean)) {
            alert('Veuillez saisir un numéro de téléphone valide\n\nFormats acceptés :\n- 0X XX XX XX XX (10 chiffres)\n- +33X XX XX XX XX (indicatif +33)');
            document.getElementById('userTelephone').focus();
            return;
        }
    }

    if (password || passwordConfirm) {
        if (password !== passwordConfirm) {
            document.getElementById('passwordError').style.display = 'block';
            document.getElementById('userPasswordConfirm').classList.add('is-invalid');
            alert('Les mots de passe ne correspondent pas');
            return;
        }

        if (password.length < 6) {
            alert('Le mot de passe doit contenir au moins 6 caracteres');
            return;
        }

        if (!currentUserId && !password) {
            alert('Le mot de passe est obligatoire pour un nouvel utilisateur');
            return;
        }
    } else if (!currentUserId) {
        alert('Le mot de passe est obligatoire pour un nouvel utilisateur');
        return;
    }

    document.getElementById('passwordError').style.display = 'none';
    document.getElementById('userPasswordConfirm').classList.remove('is-invalid');

    const departements = [];
    document.querySelectorAll('#menuTree input[type="checkbox"]:checked').forEach(checkbox => {
        departements.push(checkbox.value);
    });

    const cantons = [];
    document.querySelectorAll('#cantonTree input[type="checkbox"]:checked').forEach(checkbox => {
        const dept = checkbox.dataset.dept;
        const canton = checkbox.dataset.canton;
        if (dept && canton) {
            cantons.push({ numero_departement: dept, canton: canton });
        }
    });

    try {
        // Si mot de passe fourni, l'ajouter aux commentaires (création ou modification)
        // Utiliser originalCommentaires pour éviter la duplication (le mot de passe est déjà affiché dans le textarea)
        let finalCommentaires = originalCommentaires;
        if (password) {
            const dateStr = new Date().toLocaleDateString('fr-FR');
            const isNewUser = !currentUserId;
            const passwordLabel = isNewUser ? 'Mot de passe initial' : 'Mot de passe modifié';
            const passwordInfo = `${passwordLabel} (${dateStr}): ${password}`;
            finalCommentaires = passwordInfo + (originalCommentaires ? '\n\n' + originalCommentaires : '');
        }

        const userData = {
            id: currentUserId,
            nom,
            prenom,
            email,
            telephone,
            pseudo,
            typeUtilisateur_id,
            departement_id: departement_id || null,
            actif,
            commentaires: finalCommentaires,
            password: password || null
        };

        const userResponse = await fetch('api.php?action=saveUtilisateur', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(userData)
        });

        const userResult = await userResponse.json();
        if (!userResult.success) {
            alert('Erreur lors de la sauvegarde de l\'utilisateur : ' + (userResult.error || 'Erreur inconnue'));
            return;
        }

        const userId = userResult.userId || currentUserId;

        const deptsResponse = await fetch('api.php?action=saveUserDroits', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId, departements })
        });

        const deptsResult = await deptsResponse.json();
        if (!deptsResult.success) {
            alert('Erreur lors de la sauvegarde des droits departements : ' + (deptsResult.error || 'Erreur inconnue'));
            return;
        }

        const cantonsResponse = await fetch('api.php?action=saveUserCantons', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId, cantons })
        });

        const cantonsResult = await cantonsResponse.json();
        if (!cantonsResult.success) {
            alert('Erreur lors de la sauvegarde des droits cantons : ' + (cantonsResult.error || 'Erreur inconnue'));
            return;
        }

        if (userModal) {
            userModal.hide();
        }
        loadUsers();

    } catch (error) {
        alert('Erreur lors de la sauvegarde : ' + error.message);
    }
}

function exportUsers() {
    alert('Fonctionnalite en cours de developpement');
}

function refreshUsers() {
    loadUsers();
}

// Charger les iframes quand on change d'onglet
document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(button => {
    button.addEventListener('shown.bs.tab', function (event) {
        const targetId = event.target.getAttribute('data-bs-target');

        if (targetId === '#dept') {
            const iframe = document.getElementById('deptFrame');
            if (!iframe.src) {
                iframe.src = iframe.getAttribute('data-src');
            }
        } else if (targetId === '#canton') {
            const iframe = document.getElementById('cantonFrame');
            if (!iframe.src) {
                iframe.src = iframe.getAttribute('data-src');
            }
        }
    });
});

// Toggle password visibility
function togglePasswordVisibility(inputId, iconId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(iconId);

    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('bi-eye');
        icon.classList.add('bi-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('bi-eye-slash');
        icon.classList.add('bi-eye');
    }
}

// Generer un mot de passe securise
function generatePassword() {
    const complexity = document.getElementById('passwordComplexity').value;
    let length = 12;

    switch(complexity) {
        case 'medium': length = 8; break;
        case 'high': length = 12; break;
        case 'very-high': length = 16; break;
    }

    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#$%^&*()_+-=[]{}|;:,.<>?';

    let allChars = lowercase + uppercase + numbers;
    if (complexity === 'high' || complexity === 'very-high') {
        allChars += symbols;
    }

    let password = '';
    password += lowercase[Math.floor(Math.random() * lowercase.length)];
    password += uppercase[Math.floor(Math.random() * uppercase.length)];
    password += numbers[Math.floor(Math.random() * numbers.length)];

    if (complexity === 'high' || complexity === 'very-high') {
        password += symbols[Math.floor(Math.random() * symbols.length)];
    }

    for (let i = password.length; i < length; i++) {
        password += allChars[Math.floor(Math.random() * allChars.length)];
    }

    password = password.split('').sort(() => Math.random() - 0.5).join('');

    document.getElementById('generatedPassword').value = password;
    document.getElementById('copyPasswordBtn').disabled = false;
}

// Copier le mot de passe genere dans les deux champs
function copyGeneratedPassword() {
    const generatedPassword = document.getElementById('generatedPassword').value;

    if (!generatedPassword) {
        alert('Veuillez d\'abord generer un mot de passe');
        return;
    }

    const confirmed = confirm(
        'Voulez-vous utiliser ce mot de passe ?\n\n' +
        'Le mot de passe genere sera copie dans les deux champs.\n\n' +
        'Mot de passe : ' + generatedPassword
    );

    if (!confirmed) return;

    document.getElementById('userPassword').value = generatedPassword;
    document.getElementById('userPasswordConfirm').value = generatedPassword;
    document.getElementById('passwordError').style.display = 'none';
    document.getElementById('userPasswordConfirm').classList.remove('is-invalid');

    const btn = document.getElementById('copyPasswordBtn');
    const originalHTML = btn.innerHTML;
    btn.innerHTML = '<i class="bi bi-check-circle"></i> Copie!';
    btn.classList.remove('btn-success');
    btn.classList.add('btn-success');

    setTimeout(() => {
        btn.innerHTML = originalHTML;
    }, 2000);

    // Mettre à jour les commentaires avec le mot de passe
    updatePasswordInComments(generatedPassword);
}

// Mettre à jour le champ commentaires avec le mot de passe
function updatePasswordInComments(password) {
    const commentairesField = document.getElementById('userCommentaires');
    const dateStr = new Date().toLocaleDateString('fr-FR');
    const isNewUser = !currentUserId;
    const passwordLabel = isNewUser ? 'Mot de passe initial' : 'Mot de passe modifié';

    if (password && password.trim()) {
        const passwordInfo = `${passwordLabel} (${dateStr}): ${password}`;
        commentairesField.value = passwordInfo + (originalCommentaires ? '\n\n' + originalCommentaires : '');
    } else {
        // Si pas de mot de passe, restaurer les commentaires originaux
        commentairesField.value = originalCommentaires;
    }
}

// Validation en temps reel de la confirmation du mot de passe et mise à jour des commentaires
document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('userPassword');
    const passwordConfirmInput = document.getElementById('userPasswordConfirm');
    const passwordError = document.getElementById('passwordError');

    function validatePasswordMatch() {
        if (passwordConfirmInput.value && passwordInput.value !== passwordConfirmInput.value) {
            passwordError.style.display = 'block';
            passwordConfirmInput.classList.add('is-invalid');
        } else {
            passwordError.style.display = 'none';
            passwordConfirmInput.classList.remove('is-invalid');
        }
    }

    passwordInput.addEventListener('input', validatePasswordMatch);
    passwordConfirmInput.addEventListener('input', validatePasswordMatch);

    // Mettre à jour les commentaires quand le mot de passe est saisi manuellement
    passwordInput.addEventListener('input', function() {
        updatePasswordInComments(this.value);
    });
});

// =============================================
// Fonctions pour l'onglet "Utilisateurs par region"
// =============================================

let regionTreeLoaded = false;
let regionTreeData = null;
let currentReferentsView = 'referent';
let currentMembresView = 'membre';

// Charger les donnees quand on clique sur l'onglet
document.getElementById('region-tab').addEventListener('shown.bs.tab', function() {
    if (!regionTreeLoaded) {
        loadRegionTree();
        regionTreeLoaded = true;
    }
});

// Changer la vue des referents
function switchReferentsView(viewMode) {
    currentReferentsView = viewMode;

    const btnShowAll = document.getElementById('btnShowAllReferents');
    if (btnShowAll) {
        btnShowAll.style.display = (viewMode === 'referent') ? 'inline-block' : 'none';
    }

    if (regionTreeData) {
        const referentsTree = document.getElementById('referentsTree');
        if (referentsTree) {
            referentsTree.innerHTML = '<div class="text-center text-muted py-3"><i class="bi bi-arrow-repeat spin"></i> Chargement...</div>';
        }
        setTimeout(() => {
            if (viewMode === 'region') {
                renderReferentsByRegionTree(regionTreeData.referents || [], regionTreeData.cantonsParDept || {});
            } else {
                renderReferentsTree(regionTreeData.referents || [], regionTreeData.cantonsParDept || {});
            }
        }, 50);
    }
}

// Changer la vue des membres
function switchMembresView(viewMode) {
    currentMembresView = viewMode;

    const btnShowAllMembres = document.getElementById('btnShowAllMembres');
    if (btnShowAllMembres) {
        btnShowAllMembres.style.display = (viewMode === 'membre') ? 'inline-block' : 'none';
    }

    if (regionTreeData) {
        const membresTree = document.getElementById('membresTree');
        if (membresTree) {
            membresTree.innerHTML = '<div class="text-center text-muted py-3"><i class="bi bi-arrow-repeat spin"></i> Chargement...</div>';
        }
        setTimeout(() => {
            if (viewMode === 'region') {
                renderMembresByRegionTree(regionTreeData.membres || []);
            } else {
                renderMembresTree(regionTreeData.membres || []);
            }
        }, 50);
    }
}

// Charger l'arborescence des utilisateurs par region
async function loadRegionTree() {
    try {
        const response = await fetch('api.php?action=getUtilisateursParRegion');
        const data = await response.json();

        if (data.success) {
            regionTreeData = data;

            if (connectedUser.type === 1 || connectedUser.type === 2) {
                if (currentReferentsView === 'region') {
                    renderReferentsByRegionTree(data.referents || [], data.cantonsParDept || {});
                } else {
                    renderReferentsTree(data.referents || [], data.cantonsParDept || {});
                }
            }
            if (currentMembresView === 'region') {
                renderMembresByRegionTree(data.membres || []);
            } else {
                renderMembresTree(data.membres || []);
            }
        } else {
            const errorMsg = `<div class="alert alert-danger">Erreur: ${data.error || 'Erreur inconnue'}</div>`;
            if (document.getElementById('referentsTree')) {
                document.getElementById('referentsTree').innerHTML = errorMsg;
            }
            document.getElementById('membresTree').innerHTML = errorMsg;
        }
    } catch (error) {
        const errorMsg = `<div class="alert alert-danger">Erreur de chargement: ${error.message}</div>`;
        if (document.getElementById('referentsTree')) {
            document.getElementById('referentsTree').innerHTML = errorMsg;
        }
        document.getElementById('membresTree').innerHTML = errorMsg;
    }
}

// Rendre l'arborescence des referents (Utilisateur > Region > Departement > Cantons/Membres)
function renderReferentsTree(referents, cantonsParDept = {}) {
    const container = document.getElementById('referentsTree');
    if (!container) return;

    const usersMap = {};

    referents.forEach(ref => {
        const userId = ref.id;
        const userName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
        const userEmail = ref.email || '';
        const regionNom = ref.region_nom || 'Sans region';
        const deptNom = ref.departement_nom || 'Sans departement';
        const deptNum = ref.departement_numero || '';

        if (!usersMap[userId]) {
            usersMap[userId] = {
                id: userId,
                name: userName,
                prenom: ref.prenom || '',
                nom: ref.nom || '',
                email: userEmail,
                regions: {}
            };
        }
        if (!usersMap[userId].regions[regionNom]) {
            usersMap[userId].regions[regionNom] = [];
        }
        const deptKey = `${deptNum} - ${deptNom}`;
        if (!usersMap[userId].regions[regionNom].some(d => d.key === deptKey)) {
            usersMap[userId].regions[regionNom].push({
                key: deptKey,
                numero: deptNum,
                nom: deptNom
            });
        }
    });

    const uniqueUsers = Object.values(usersMap);
    document.getElementById('referentsCount').textContent = uniqueUsers.length;

    if (uniqueUsers.length === 0) {
        container.innerHTML = '<div class="text-muted text-center py-3">Aucun referent trouve</div>';
        return;
    }

    uniqueUsers.sort((a, b) => (a.prenom || '').localeCompare(b.prenom || '', 'fr'));

    let html = '';
    uniqueUsers.forEach(user => {
        const initials = ((user.prenom || '').charAt(0) + (user.nom || '').charAt(0)).toUpperCase();
        const sortedRegions = Object.keys(user.regions).sort((a, b) => a.localeCompare(b, 'fr'));

        html += `
            <div class="tree-node user-node">
                <div class="node-header" onclick="toggleNode(this)">
                    <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                    <span class="user-icon-small referent" onclick="expandUserTree(event)" title="Cliquer pour tout deplier">${initials}</span>
                    <span class="node-label clickable-referent" onclick="showReferentModal(event, ${user.id})">${escapeHtml(user.name)}</span>
                </div>
                <div class="node-children">
        `;

        sortedRegions.forEach(regionNom => {
            const depts = user.regions[regionNom].sort((a, b) => a.nom.localeCompare(b.nom, 'fr'));

            html += `
                <div class="tree-node region-node">
                    <div class="node-header" onclick="toggleNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <i class="bi bi-geo-alt-fill node-icon"></i>
                        <span class="node-label">${escapeHtml(regionNom)}</span>
                        <span class="node-count">${depts.length}</span>
                    </div>
                    <div class="node-children">
            `;

            depts.forEach(dept => {
                const deptCantons = cantonsParDept[dept.numero] || {};
                const cantonNames = Object.keys(deptCantons).sort((a, b) => a.localeCompare(b, 'fr'));
                const hasCantons = cantonNames.length > 0;

                if (hasCantons) {
                    html += `
                        <div class="tree-node dept-node">
                            <div class="node-header" onclick="toggleNode(this)">
                                <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                                <i class="bi bi-building node-icon"></i>
                                <span class="node-label">${dept.numero ? dept.numero + ' - ' : ''}${escapeHtml(dept.nom)}</span>
                                <span class="node-count">${cantonNames.length} cantons</span>
                            </div>
                            <div class="node-children">
                    `;

                    cantonNames.forEach(cantonName => {
                        const cantonData = deptCantons[cantonName] || {};
                        // Support ancien format (tableau) et nouveau format (objet avec membres/referents)
                        const membres = Array.isArray(cantonData) ? cantonData : (cantonData.membres || []);
                        const referentsCanton = Array.isArray(cantonData) ? [] : (cantonData.referents || []);
                        const totalUsers = membres.length + referentsCanton.length;
                        const hasUsers = totalUsers > 0;

                        if (hasUsers) {
                            html += `
                                <div class="tree-node canton-node">
                                    <div class="node-header" onclick="toggleNode(this)">
                                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                                        <i class="bi bi-pin-map node-icon"></i>
                                        <span class="node-label">${escapeHtml(cantonName)}</span>
                                        <span class="node-count">${totalUsers}</span>
                                    </div>
                                    <div class="node-children">
                            `;

                            // Afficher d'abord les référents du canton
                            referentsCanton.forEach(ref => {
                                const refInitials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();
                                const refName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
                                html += `
                                    <div class="tree-leaf referent-leaf">
                                        <span class="user-icon-tiny referent">${refInitials}</span>
                                        <span class="node-label clickable-referent" onclick="showReferentModal(event, ${ref.id})" title="Cliquer pour voir les details">${escapeHtml(refName)}</span>
                                        <span class="badge bg-warning text-dark ms-1" style="font-size: 0.65rem;">Réf.</span>
                                    </div>
                                `;
                            });

                            // Puis les membres
                            membres.forEach(membre => {
                                const membreInitials = ((membre.prenom || '').charAt(0) + (membre.nom || '').charAt(0)).toUpperCase();
                                const membreName = `${membre.prenom || ''} ${(membre.nom || '').toUpperCase()}`.trim();
                                html += `
                                    <div class="tree-leaf membre-leaf">
                                        <span class="user-icon-tiny membre">${membreInitials}</span>
                                        <span class="node-label">${escapeHtml(membreName)}</span>
                                    </div>
                                `;
                            });

                            html += `
                                    </div>
                                </div>
                            `;
                        } else {
                            html += `
                                <div class="tree-leaf canton-leaf">
                                    <i class="bi bi-pin-map node-icon"></i>
                                    <span class="node-label">${escapeHtml(cantonName)}</span>
                                </div>
                            `;
                        }
                    });

                    html += `
                            </div>
                        </div>
                    `;
                } else {
                    html += `
                        <div class="tree-leaf dept-leaf">
                            <i class="bi bi-building node-icon"></i>
                            <span class="node-label">${dept.numero ? dept.numero + ' - ' : ''}${escapeHtml(dept.nom)}</span>
                        </div>
                    `;
                }
            });

            html += `
                    </div>
                </div>
            `;
        });

        html += `
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}

// NOTE: Les fonctions restantes sont definies dans la suite du fichier
// pour la gestion des arbres par region, modales, etc.
// Voir gestionUtilisateurs_part2.js pour le reste

// Toggle pour ouvrir/fermer un noeud de l'arbre
function toggleNode(headerElement) {
    const toggle = headerElement.querySelector('.node-toggle');
    const children = headerElement.nextElementSibling;

    if (toggle && children) {
        toggle.classList.toggle('expanded');
        children.classList.toggle('expanded');
    }
}

// Deplier/replier toutes les branches d'un utilisateur (clic sur avatar)
function expandUserTree(event) {
    event.stopPropagation();

    const avatar = event.target.closest('.user-icon-small');
    const userNode = avatar.closest('.tree-node.user-node');

    if (!userNode) return;

    const mainToggle = userNode.querySelector(':scope > .node-header > .node-toggle');
    const isExpanded = mainToggle && mainToggle.classList.contains('expanded');

    const tabPane = userNode.closest('.tab-pane');
    if (tabPane) {
        tabPane.querySelectorAll('.node-toggle.expanded').forEach(toggle => {
            toggle.classList.remove('expanded');
        });
        tabPane.querySelectorAll('.node-children.expanded').forEach(children => {
            children.classList.remove('expanded');
        });
    }

    if (!isExpanded) {
        const allToggles = userNode.querySelectorAll('.node-toggle');
        const allChildren = userNode.querySelectorAll('.node-children');
        allToggles.forEach(toggle => toggle.classList.add('expanded'));
        allChildren.forEach(children => children.classList.add('expanded'));
    }
}

// Tout deplier
function expandAllRegionNodes() {
    document.querySelectorAll('#region .node-toggle').forEach(toggle => {
        toggle.classList.add('expanded');
    });
    document.querySelectorAll('#region .node-children').forEach(children => {
        children.classList.add('expanded');
    });
}

// Tout replier
function collapseAllRegionNodes() {
    document.querySelectorAll('#region .node-toggle').forEach(toggle => {
        toggle.classList.remove('expanded');
    });
    document.querySelectorAll('#region .node-children').forEach(children => {
        children.classList.remove('expanded');
    });
}

// Rafraichir les arbres
function refreshRegionTree() {
    const referentsTree = document.getElementById('referentsTree');
    const membresTree = document.getElementById('membresTree');

    if (referentsTree) {
        referentsTree.innerHTML = '<div class="text-center text-muted py-3"><i class="bi bi-arrow-repeat spin"></i> Chargement...</div>';
    }
    if (membresTree) {
        membresTree.innerHTML = '<div class="text-center text-muted py-3"><i class="bi bi-arrow-repeat spin"></i> Chargement...</div>';
    }

    loadRegionTree();
}

// =============================================
// Gestion du champ Département pour les Référents
// =============================================

// Afficher/masquer le champ département selon le type d'utilisateur
function toggleDepartementField() {
    const userType = document.getElementById('userType').value;
    const departementRow = document.getElementById('departementRow');
    const departementSelect = document.getElementById('userDepartement');
    const deptSearch = document.getElementById('deptSearch');

    if (userType === '3') { // Référent
        departementRow.style.display = 'flex';
        if (departementSelect) departementSelect.setAttribute('required', 'required');
    } else {
        departementRow.style.display = 'none';
        if (departementSelect) {
            departementSelect.removeAttribute('required');
            departementSelect.value = ''; // Réinitialiser la sélection
        }
        if (deptSearch) deptSearch.value = ''; // Réinitialiser le champ de recherche
    }
}

// Initialisation
loadUsers();
