/**
 * Scripts pour la page Gestion des Utilisateurs - Partie 2
 * Fonctions pour les arbres par region et les modales
 */

// Rendre l'arborescence des referents par region (Region > Referent > Departement > Canton > Membre)
function renderReferentsByRegionTree(referents, cantonsParDept = {}) {
    const container = document.getElementById('referentsTree');
    if (!container) return;

    const regionsMap = {};

    referents.forEach(ref => {
        const regionNom = ref.region_nom || 'Sans region';
        const userId = ref.id;
        const userName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
        const userEmail = ref.email || '';
        const deptNom = ref.departement_nom || 'Sans departement';
        const deptNum = ref.departement_numero || '';

        if (!regionsMap[regionNom]) {
            regionsMap[regionNom] = {};
        }
        if (!regionsMap[regionNom][userId]) {
            regionsMap[regionNom][userId] = {
                id: userId,
                name: userName,
                prenom: ref.prenom || '',
                nom: ref.nom || '',
                email: userEmail,
                departements: []
            };
        }
        const deptKey = `${deptNum} - ${deptNom}`;
        if (!regionsMap[regionNom][userId].departements.some(d => d.key === deptKey)) {
            regionsMap[regionNom][userId].departements.push({
                key: deptKey,
                numero: deptNum,
                nom: deptNom
            });
        }
    });

    const uniqueReferents = new Set();
    Object.values(regionsMap).forEach(region => {
        Object.keys(region).forEach(userId => uniqueReferents.add(userId));
    });
    document.getElementById('referentsCount').textContent = uniqueReferents.size;

    const sortedRegions = Object.keys(regionsMap).sort((a, b) => a.localeCompare(b, 'fr'));

    if (sortedRegions.length === 0) {
        container.innerHTML = '<div class="text-muted text-center py-3">Aucun referent trouve</div>';
        return;
    }

    let html = '';
    sortedRegions.forEach(regionNom => {
        const referentsInRegion = Object.values(regionsMap[regionNom]);
        referentsInRegion.sort((a, b) => (a.prenom || '').localeCompare(b.prenom || '', 'fr'));
        const regionNameEscaped = escapeHtml(regionNom).replace(/'/g, "\\'");

        html += `
            <div class="tree-node region-node">
                <div class="node-header" onclick="toggleNode(this)">
                    <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                    <i class="bi bi-geo-alt-fill node-icon"></i>
                    <span class="node-label region-name-clickable" onclick="showRegionReferentsModal(event, '${regionNameEscaped}')" title="Cliquer pour voir tous les referents">${escapeHtml(regionNom)}</span>
                    <span class="node-count">${referentsInRegion.length} referent${referentsInRegion.length > 1 ? 's' : ''}</span>
                </div>
                <div class="node-children">
        `;

        referentsInRegion.forEach(user => {
            const initials = ((user.prenom || '').charAt(0) + (user.nom || '').charAt(0)).toUpperCase();
            const depts = user.departements.sort((a, b) => a.nom.localeCompare(b.nom, 'fr'));

            html += `
                <div class="tree-node user-node">
                    <div class="node-header" onclick="toggleNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <span class="user-icon-small referent" onclick="expandUserTree(event)" title="Cliquer pour tout deplier">${initials}</span>
                        <span class="node-label clickable-referent" onclick="showReferentDetail(event, ${user.id})" title="Cliquer pour voir les details">${escapeHtml(user.name)}</span>
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
                                        <span class="node-label clickable-referent" onclick="showReferentDetail(event, ${ref.id})" title="Cliquer pour voir les details">${escapeHtml(refName)}</span>
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

// Rendre l'arborescence des membres (Utilisateur > Region/Departement > Canton)
function renderMembresTree(membres) {
    const container = document.getElementById('membresTree');
    if (!container) return;

    const usersMap = {};

    membres.forEach(membre => {
        const userId = membre.id;
        const userName = `${membre.prenom || ''} ${(membre.nom || '').toUpperCase()}`.trim();
        const userEmail = membre.email || '';
        const regionNom = membre.region_nom || 'Sans region';
        const deptNom = membre.departement_nom || 'Sans departement';
        const deptNum = membre.departement_numero || '';
        const cantonNom = membre.canton || 'Sans canton';

        const regionDeptKey = `${regionNom} / ${deptNum} - ${deptNom}`;

        if (!usersMap[userId]) {
            usersMap[userId] = {
                id: userId,
                name: userName,
                prenom: membre.prenom || '',
                nom: membre.nom || '',
                email: userEmail,
                regionsDepts: {}
            };
        }
        if (!usersMap[userId].regionsDepts[regionDeptKey]) {
            usersMap[userId].regionsDepts[regionDeptKey] = {
                region: regionNom,
                deptNum: deptNum,
                deptNom: deptNom,
                cantons: []
            };
        }
        if (!usersMap[userId].regionsDepts[regionDeptKey].cantons.includes(cantonNom)) {
            usersMap[userId].regionsDepts[regionDeptKey].cantons.push(cantonNom);
        }
    });

    const uniqueUsers = Object.values(usersMap);
    document.getElementById('membresCount').textContent = uniqueUsers.length;

    if (uniqueUsers.length === 0) {
        container.innerHTML = '<div class="text-muted text-center py-3">Aucun membre trouve</div>';
        return;
    }

    uniqueUsers.sort((a, b) => (a.prenom || '').localeCompare(b.prenom || '', 'fr'));

    let html = '';
    uniqueUsers.forEach(user => {
        const initials = ((user.prenom || '').charAt(0) + (user.nom || '').charAt(0)).toUpperCase();
        const sortedRegionsDepts = Object.keys(user.regionsDepts).sort((a, b) => a.localeCompare(b, 'fr'));

        html += `
            <div class="tree-node user-node">
                <div class="node-header" onclick="toggleNode(this)">
                    <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                    <span class="user-icon-small membre" onclick="expandUserTree(event)" title="Cliquer pour tout deplier">${initials}</span>
                    <span class="node-label">${escapeHtml(user.name)}</span>
                </div>
                <div class="node-children">
        `;

        sortedRegionsDepts.forEach(regionDeptKey => {
            const data = user.regionsDepts[regionDeptKey];
            const cantons = data.cantons.sort((a, b) => a.localeCompare(b, 'fr'));

            html += `
                <div class="tree-node region-dept-node">
                    <div class="node-header" onclick="toggleNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <i class="bi bi-geo-alt-fill node-icon"></i>
                        <span class="node-label">${escapeHtml(data.region)} / ${data.deptNum ? data.deptNum + ' - ' : ''}${escapeHtml(data.deptNom)}</span>
                        <span class="node-count">${cantons.length}</span>
                    </div>
                    <div class="node-children">
            `;

            cantons.forEach(canton => {
                html += `
                    <div class="tree-leaf canton-leaf">
                        <i class="bi bi-pin-map node-icon"></i>
                        <span class="node-label">${escapeHtml(canton)}</span>
                    </div>
                `;
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

// Rendu arbre Membres par region: Region > Membre > Departement > Canton
function renderMembresByRegionTree(membres) {
    const container = document.getElementById('membresTree');
    if (!container) return;

    const regionsMap = {};

    membres.forEach(membre => {
        const userId = membre.id;
        const userName = `${membre.prenom || ''} ${(membre.nom || '').toUpperCase()}`.trim();
        const userEmail = membre.email || '';
        const regionNom = membre.region_nom || 'Sans region';
        const deptNom = membre.departement_nom || 'Sans departement';
        const deptNum = membre.departement_numero || '';
        const deptKey = deptNum ? `${deptNum} - ${deptNom}` : deptNom;
        const cantonNom = membre.canton || 'Sans canton';

        if (!regionsMap[regionNom]) {
            regionsMap[regionNom] = {
                nom: regionNom,
                membres: {}
            };
        }

        if (!regionsMap[regionNom].membres[userId]) {
            regionsMap[regionNom].membres[userId] = {
                id: userId,
                name: userName,
                prenom: membre.prenom || '',
                nom: membre.nom || '',
                email: userEmail,
                departements: {}
            };
        }

        if (!regionsMap[regionNom].membres[userId].departements[deptKey]) {
            regionsMap[regionNom].membres[userId].departements[deptKey] = {
                nom: deptNom,
                numero: deptNum,
                cantons: []
            };
        }

        if (!regionsMap[regionNom].membres[userId].departements[deptKey].cantons.includes(cantonNom)) {
            regionsMap[regionNom].membres[userId].departements[deptKey].cantons.push(cantonNom);
        }
    });

    const allMembresIds = new Set();
    Object.values(regionsMap).forEach(region => {
        Object.keys(region.membres).forEach(id => allMembresIds.add(id));
    });
    document.getElementById('membresCount').textContent = allMembresIds.size;

    if (allMembresIds.size === 0) {
        container.innerHTML = '<div class="text-muted text-center py-3">Aucun membre trouve</div>';
        return;
    }

    const sortedRegions = Object.values(regionsMap).sort((a, b) => a.nom.localeCompare(b.nom, 'fr'));

    let html = '';
    sortedRegions.forEach(region => {
        const membresArray = Object.values(region.membres).sort((a, b) =>
            (a.prenom || '').localeCompare(b.prenom || '', 'fr')
        );

        html += `
            <div class="tree-node region-node">
                <div class="node-header" onclick="toggleNode(this)">
                    <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                    <i class="bi bi-map node-icon text-primary"></i>
                    <span class="node-label fw-bold">${escapeHtml(region.nom)}</span>
                    <span class="node-count">${membresArray.length} membre${membresArray.length > 1 ? 's' : ''}</span>
                </div>
                <div class="node-children">
        `;

        membresArray.forEach(membre => {
            const initials = ((membre.prenom || '').charAt(0) + (membre.nom || '').charAt(0)).toUpperCase();
            const sortedDepts = Object.keys(membre.departements).sort((a, b) => a.localeCompare(b, 'fr'));
            const totalCantons = Object.values(membre.departements).reduce((sum, d) => sum + d.cantons.length, 0);

            html += `
                <div class="tree-node membre-node">
                    <div class="node-header" onclick="toggleNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <span class="user-icon-small membre" onclick="expandUserTree(event)" title="Cliquer pour tout deplier">${initials}</span>
                        <span class="node-label">${escapeHtml(membre.name)}</span>
                        <span class="node-count">${totalCantons} canton${totalCantons > 1 ? 's' : ''}</span>
                    </div>
                    <div class="node-children">
            `;

            sortedDepts.forEach(deptKey => {
                const dept = membre.departements[deptKey];
                const sortedCantons = dept.cantons.sort((a, b) => a.localeCompare(b, 'fr'));

                html += `
                    <div class="tree-node dept-node">
                        <div class="node-header" onclick="toggleNode(this)">
                            <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                            <i class="bi bi-geo-alt-fill node-icon text-success"></i>
                            <span class="node-label">${escapeHtml(deptKey)}</span>
                            <span class="node-count">${sortedCantons.length}</span>
                        </div>
                        <div class="node-children">
                `;

                sortedCantons.forEach(canton => {
                    html += `
                        <div class="tree-leaf canton-leaf">
                            <i class="bi bi-pin-map node-icon"></i>
                            <span class="node-label">${escapeHtml(canton)}</span>
                        </div>
                    `;
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

        html += `
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}

// Afficher les details d'un referent
function showReferentDetail(event, referentId) {
    event.stopPropagation();

    if (!regionTreeData || !regionTreeData.referents) return;

    const container = document.getElementById('referentsTree');
    if (!container) return;

    const referentData = regionTreeData.referents.filter(r => r.id === referentId);
    if (referentData.length === 0) return;

    const ref = referentData[0];
    const userName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
    const userEmail = ref.email || '';
    const initials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();

    const deptsMap = {};
    referentData.forEach(r => {
        const deptKey = r.departement_numero ? `${r.departement_numero} - ${r.departement_nom}` : r.departement_nom || 'Sans departement';
        if (!deptsMap[deptKey]) {
            deptsMap[deptKey] = {
                numero: r.departement_numero || '',
                nom: r.departement_nom || 'Sans departement',
                cantons: {}
            };
        }
    });

    const cantonsParDept = regionTreeData.cantonsParDept || {};
    Object.keys(deptsMap).forEach(deptKey => {
        const dept = deptsMap[deptKey];
        const deptCantons = cantonsParDept[dept.numero] || {};
        dept.cantons = deptCantons;
    });

    let html = `
        <div class="referent-detail-header">
            <button class="back-btn" onclick="backToReferentsList()">
                <i class="bi bi-arrow-left"></i> Retour
            </button>
            <div class="referent-info">
                <span class="user-icon-small referent">${initials}</span>
                <div>
                    <strong>${escapeHtml(userName)}</strong>
                    <small style="opacity: 0.8; margin-left: 10px;">${escapeHtml(userEmail)}</small>
                </div>
            </div>
        </div>
    `;

    const sortedDepts = Object.keys(deptsMap).sort((a, b) => a.localeCompare(b, 'fr'));

    if (sortedDepts.length === 0) {
        html += '<div class="text-muted text-center py-3">Aucun departement assigne</div>';
    } else {
        sortedDepts.forEach(deptKey => {
            const dept = deptsMap[deptKey];
            const cantonNames = Object.keys(dept.cantons).sort((a, b) => a.localeCompare(b, 'fr'));
            const hasCantons = cantonNames.length > 0;

            if (hasCantons) {
                html += `
                    <div class="tree-node dept-node">
                        <div class="node-header" onclick="toggleNode(this)">
                            <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                            <i class="bi bi-building node-icon"></i>
                            <span class="node-label">${escapeHtml(deptKey)}</span>
                            <span class="node-count">${cantonNames.length} cantons</span>
                        </div>
                        <div class="node-children expanded">
                `;

                cantonNames.forEach(cantonName => {
                    const cantonData = dept.cantons[cantonName] || {};
                    const membres = Array.isArray(cantonData) ? cantonData : (cantonData.membres || []);
                    const referentsCanton = Array.isArray(cantonData) ? [] : (cantonData.referents || []);
                    const totalUsers = membres.length + referentsCanton.length;

                    if (totalUsers > 0) {
                        html += `
                            <div class="tree-node canton-node">
                                <div class="node-header" onclick="toggleNode(this)">
                                    <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                                    <i class="bi bi-pin-map node-icon"></i>
                                    <span class="node-label">${escapeHtml(cantonName)}</span>
                                    <span class="node-count">${totalUsers}</span>
                                </div>
                                <div class="node-children expanded">
                        `;

                        referentsCanton.forEach(ref => {
                            const refInitials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();
                            const refName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
                            html += `
                                <div class="tree-leaf referent-leaf">
                                    <span class="user-icon-tiny referent">${refInitials}</span>
                                    <span class="node-label clickable-referent" onclick="showReferentDetail(event, ${ref.id})" title="Cliquer pour voir les details">${escapeHtml(refName)}</span>
                                    <span class="badge bg-warning text-dark ms-1" style="font-size: 0.65rem;">Réf.</span>
                                </div>
                            `;
                        });

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
                        <span class="node-label">${escapeHtml(deptKey)}</span>
                    </div>
                `;
            }
        });
    }

    container.innerHTML = html;
}

// Retour a la liste des referents
function backToReferentsList() {
    if (regionTreeData) {
        if (currentReferentsView === 'region') {
            renderReferentsByRegionTree(regionTreeData.referents || [], regionTreeData.cantonsParDept || {});
        } else {
            renderReferentsTree(regionTreeData.referents || [], regionTreeData.cantonsParDept || {});
        }
    }
}

// Toggle pour les noeuds dans la modale
function toggleModalNode(headerElement) {
    const toggle = headerElement.querySelector('.node-toggle');
    const children = headerElement.nextElementSibling;
    const parentNode = headerElement.closest('.tree-node');

    if (toggle && children) {
        const isExpanding = !toggle.classList.contains('expanded');
        toggle.classList.toggle('expanded');
        children.classList.toggle('expanded');

        if (isExpanding && parentNode && parentNode.classList.contains('dept-node')) {
            children.querySelectorAll('.canton-node > .node-header > .node-toggle').forEach(cantonToggle => {
                cantonToggle.classList.add('expanded');
            });
            children.querySelectorAll('.canton-node > .node-children').forEach(cantonChildren => {
                cantonChildren.classList.add('expanded');
            });
        }
    }
}

// Ouvrir toutes les rubriques d'une carte
function expandAllInCard(button) {
    const card = button.closest('.referent-card');
    if (card) {
        card.querySelectorAll('.node-toggle').forEach(toggle => {
            toggle.classList.add('expanded');
        });
        card.querySelectorAll('.node-children').forEach(children => {
            children.classList.add('expanded');
        });
    }
}

// Fermer toutes les rubriques d'une carte
function collapseAllInCard(button) {
    const card = button.closest('.referent-card');
    if (card) {
        card.querySelectorAll('.node-toggle').forEach(toggle => {
            toggle.classList.remove('expanded');
        });
        card.querySelectorAll('.node-children').forEach(children => {
            children.classList.remove('expanded');
        });
    }
}

// Cacher l'overlay de detail (modale "Tous les referents")
function hideReferentDetailOverlay() {
    document.getElementById('referentDetailOverlay').style.display = 'none';
}

// Cacher l'overlay de detail (modale "Par region")
function hideRegionReferentDetailOverlay() {
    document.getElementById('regionReferentDetailOverlay').style.display = 'none';
}

// Cacher l'overlay de detail membre
function hideMembreDetailOverlay() {
    document.getElementById('membreDetailOverlay').style.display = 'none';
}
