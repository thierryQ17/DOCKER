/**
 * Scripts pour la page Gestion des Utilisateurs - Modales
 * Fonctions pour les modales de referents et membres
 */

// Variables pour les modales
let regionReferentsModal = null;
let referentDetailModal = null;
let allReferentsModal = null;
let allMembresModal = null;

// Afficher la modale avec tous les referents d'une region
function showRegionReferentsModal(event, regionName) {
    event.stopPropagation();

    if (!regionTreeData || !regionTreeData.referents) return;

    if (!regionReferentsModal) {
        regionReferentsModal = new bootstrap.Modal(document.getElementById('regionReferentsModal'));
    }

    const referentsOfRegion = regionTreeData.referents.filter(r => r.region_nom === regionName);

    const usersMap = {};
    referentsOfRegion.forEach(ref => {
        const userId = ref.id;
        if (!usersMap[userId]) {
            usersMap[userId] = {
                id: userId,
                prenom: ref.prenom || '',
                nom: ref.nom || '',
                email: ref.email || '',
                departements: []
            };
        }
        const deptKey = ref.departement_numero ? `${ref.departement_numero} - ${ref.departement_nom}` : ref.departement_nom || 'Sans departement';
        if (!usersMap[userId].departements.includes(deptKey)) {
            usersMap[userId].departements.push(deptKey);
        }
    });

    const users = Object.values(usersMap).sort((a, b) => (a.prenom || '').localeCompare(b.prenom || '', 'fr'));

    document.getElementById('regionReferentsModalTitle').innerHTML = `
        <i class="bi bi-geo-alt-fill me-2"></i>${escapeHtml(regionName)} - ${users.length} referent${users.length > 1 ? 's' : ''}
    `;

    const cantonsParDept = regionTreeData.cantonsParDept || {};
    let html = '<div class="referents-grid">';

    users.forEach(user => {
        const initials = ((user.prenom || '').charAt(0) + (user.nom || '').charAt(0)).toUpperCase();
        const userName = `${user.prenom || ''} ${(user.nom || '').toUpperCase()}`.trim();

        html += `
            <div class="referent-card">
                <div class="referent-card-header">
                    <div class="user-icon-medium">${initials}</div>
                    <div style="flex: 1;">
                        <div class="referent-name">${escapeHtml(userName)}</div>
                    </div>
                    <div class="card-expand-buttons">
                        <button type="button" class="btn-loupe" onclick="showReferentDetailInModal(${user.id})" title="Voir detail complet">
                            <i class="bi bi-search"></i>
                        </button>
                        <button type="button" class="btn-expand-all" onclick="expandAllInCard(this)" title="Tout ouvrir">
                            <i class="bi bi-plus-square"></i>
                        </button>
                        <button type="button" class="btn-collapse-all" onclick="collapseAllInCard(this)" title="Tout fermer">
                            <i class="bi bi-dash-square"></i>
                        </button>
                    </div>
                </div>
                <div class="referent-card-tree">
        `;

        user.departements.sort((a, b) => a.localeCompare(b, 'fr')).forEach(deptKey => {
            const deptNumMatch = deptKey.match(/^(\d+[A-B]?)/);
            const deptNum = deptNumMatch ? deptNumMatch[1] : '';
            const deptCantons = cantonsParDept[deptNum] || {};
            const cantonNames = Object.keys(deptCantons).sort((a, b) => a.localeCompare(b, 'fr'));

            html += `
                <div class="tree-node dept-node">
                    <div class="node-header" onclick="toggleModalNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <i class="bi bi-building node-icon text-primary"></i>
                        <span class="node-label">${escapeHtml(deptKey)}</span>
                        <span class="node-count">${cantonNames.length} canton${cantonNames.length > 1 ? 's' : ''}</span>
                    </div>
                    <div class="node-children">
            `;

            if (cantonNames.length > 0) {
                cantonNames.forEach(cantonName => {
                    const cantonData = deptCantons[cantonName] || {};
                    const membres = Array.isArray(cantonData) ? cantonData : (cantonData.membres || []);
                    const referentsCanton = Array.isArray(cantonData) ? [] : (cantonData.referents || []);
                    const totalUsers = membres.length + referentsCanton.length;

                    if (totalUsers > 0) {
                        html += `
                            <div class="tree-node canton-node">
                                <div class="node-header" onclick="toggleModalNode(this)">
                                    <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                                    <i class="bi bi-pin-map node-icon text-success"></i>
                                    <span class="node-label">${escapeHtml(cantonName)}</span>
                                    <span class="node-count">${totalUsers}</span>
                                </div>
                                <div class="node-children">
                        `;

                        referentsCanton.forEach(ref => {
                            const refInitials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();
                            const refName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
                            html += `
                                <div class="tree-leaf referent-leaf">
                                    <span class="user-icon-tiny referent">${refInitials}</span>
                                    <span class="node-label">${escapeHtml(refName)}</span>
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
                                <i class="bi bi-pin-map node-icon text-success"></i>
                                <span class="node-label">${escapeHtml(cantonName)}</span>
                            </div>
                        `;
                    }
                });
            } else {
                html += `<div class="text-muted small ps-4">Aucun canton assigne</div>`;
            }

            html += `
                    </div>
                </div>
            `;
        });

        html += `</div></div>`;
    });

    html += '</div>';

    html += `
        <div id="regionReferentDetailOverlay" style="display: none; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: white; z-index: 10; overflow-y: auto; padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #667eea;">
                <h5 style="margin: 0; color: #667eea;"><i class="bi bi-person-badge me-2"></i><span id="regionReferentDetailTitle">Detail du referent</span></h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="hideRegionReferentDetailOverlay()">
                    <i class="bi bi-x-lg"></i> Fermer
                </button>
            </div>
            <div id="regionReferentDetailContent"></div>
        </div>
    `;

    if (users.length === 0) {
        html = '<div class="text-muted text-center py-3">Aucun referent dans cette region</div>';
    }

    document.getElementById('regionReferentsModalBody').innerHTML = html;
    regionReferentsModal.show();
}

// Afficher la modale avec les details d'un referent
function showReferentModal(event, referentId) {
    event.stopPropagation();

    if (!regionTreeData || !regionTreeData.referents) return;

    if (!referentDetailModal) {
        referentDetailModal = new bootstrap.Modal(document.getElementById('referentDetailModal'));
    }

    const referentData = regionTreeData.referents.filter(r => r.id === referentId);
    if (referentData.length === 0) return;

    const ref = referentData[0];
    const userName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
    const initials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();

    const deptsMap = {};
    referentData.forEach(r => {
        const deptKey = r.departement_numero ? `${r.departement_numero} - ${r.departement_nom}` : r.departement_nom || 'Sans departement';
        const deptNum = r.departement_numero || '';
        if (!deptsMap[deptKey]) {
            deptsMap[deptKey] = {
                numero: deptNum,
                nom: r.departement_nom,
                region: r.region_nom
            };
        }
    });

    const depts = Object.keys(deptsMap).sort((a, b) => a.localeCompare(b, 'fr'));

    document.getElementById('referentDetailModalTitle').innerHTML = `
        <i class="bi bi-person-badge me-2"></i>${escapeHtml(userName)} - ${depts.length} departement${depts.length > 1 ? 's' : ''}
    `;

    const cantonsParDept = regionTreeData.cantonsParDept || {};
    let html = `
        <div class="referent-detail-card">
            <div class="referent-card-header" style="border-bottom: none; margin-bottom: 0; padding-bottom: 0;">
                <div class="user-icon-medium">${initials}</div>
                <div style="flex: 1;">
                    <div class="referent-name">${escapeHtml(userName)}</div>
                </div>
                <div class="card-expand-buttons">
                    <button type="button" class="btn-expand-all" onclick="expandAllInCard(this)" title="Tout ouvrir">
                        <i class="bi bi-plus-square"></i>
                    </button>
                    <button type="button" class="btn-collapse-all" onclick="collapseAllInCard(this)" title="Tout fermer">
                        <i class="bi bi-dash-square"></i>
                    </button>
                </div>
            </div>
            <div class="referent-card-tree" style="max-height: none;">
    `;

    depts.forEach(deptKey => {
        const deptNum = deptsMap[deptKey].numero;
        const deptCantons = cantonsParDept[deptNum] || {};
        const cantonNames = Object.keys(deptCantons).sort((a, b) => a.localeCompare(b, 'fr'));

        html += `
            <div class="tree-node dept-node">
                <div class="node-header" onclick="toggleModalNode(this)">
                    <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                    <i class="bi bi-building node-icon text-primary"></i>
                    <span class="node-label">${escapeHtml(deptKey)}</span>
                    <span class="node-count">${cantonNames.length} canton${cantonNames.length > 1 ? 's' : ''}</span>
                </div>
                <div class="node-children expanded">
        `;

        if (cantonNames.length > 0) {
            cantonNames.forEach(cantonName => {
                const cantonData = deptCantons[cantonName] || {};
                const membres = Array.isArray(cantonData) ? cantonData : (cantonData.membres || []);
                const referentsCanton = Array.isArray(cantonData) ? [] : (cantonData.referents || []);
                const totalUsers = membres.length + referentsCanton.length;
                if (totalUsers > 0) {
                    html += `
                        <div class="tree-node canton-node">
                            <div class="node-header" onclick="toggleModalNode(this)">
                                <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                                <i class="bi bi-pin-map node-icon text-success"></i>
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
                                <span class="node-label">${escapeHtml(refName)}</span>
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
                            <i class="bi bi-pin-map node-icon text-success"></i>
                            <span class="node-label">${escapeHtml(cantonName)}</span>
                        </div>
                    `;
                }
            });
        } else {
            html += `<div class="text-muted small ps-4">Aucun canton assigne</div>`;
        }

        html += `
                </div>
            </div>
        `;
    });

    html += `</div></div>`;

    document.getElementById('referentDetailModalBody').innerHTML = html;
    referentDetailModal.show();
}

// Afficher la modale avec tous les referents
function showAllReferentsModal() {
    if (!regionTreeData || !regionTreeData.referents) return;

    if (!allReferentsModal) {
        allReferentsModal = new bootstrap.Modal(document.getElementById('allReferentsModal'));
    }

    const referentsMap = {};
    regionTreeData.referents.forEach(r => {
        if (!referentsMap[r.id]) {
            referentsMap[r.id] = {
                id: r.id,
                nom: r.nom,
                prenom: r.prenom,
                departements: {}
            };
        }
        const deptKey = r.departement_numero ? `${r.departement_numero} - ${r.departement_nom}` : r.departement_nom || 'Sans departement';
        if (!referentsMap[r.id].departements[deptKey]) {
            referentsMap[r.id].departements[deptKey] = {
                numero: r.departement_numero || '',
                nom: r.departement_nom
            };
        }
    });

    const referents = Object.values(referentsMap).sort((a, b) => {
        const nameA = `${a.nom || ''} ${a.prenom || ''}`.toLowerCase();
        const nameB = `${b.nom || ''} ${b.prenom || ''}`.toLowerCase();
        return nameA.localeCompare(nameB, 'fr');
    });

    if (referents.length === 0) {
        document.getElementById('allReferentsModalBody').innerHTML = `
            <div class="text-muted text-center py-4">Aucun referent trouve</div>
        `;
        allReferentsModal.show();
        return;
    }

    const cantonsParDept = regionTreeData.cantonsParDept || {};

    let html = '<div class="referents-grid">';

    referents.forEach(ref => {
        const userName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
        const initials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();
        const depts = Object.keys(ref.departements).sort((a, b) => a.localeCompare(b, 'fr'));

        html += `
            <div class="referent-card">
                <div class="referent-card-header">
                    <div class="user-icon-medium">${initials}</div>
                    <div style="flex: 1;">
                        <div class="referent-name">${escapeHtml(userName)}</div>
                        <div class="referent-count">${depts.length} departement${depts.length > 1 ? 's' : ''}</div>
                    </div>
                    <div class="card-expand-buttons">
                        <button type="button" class="btn-loupe" onclick="showReferentDetailInModal(${ref.id})" title="Voir detail complet">
                            <i class="bi bi-search"></i>
                        </button>
                        <button type="button" class="btn-expand-all" onclick="expandAllInCard(this)" title="Tout ouvrir">
                            <i class="bi bi-plus-square"></i>
                        </button>
                        <button type="button" class="btn-collapse-all" onclick="collapseAllInCard(this)" title="Tout fermer">
                            <i class="bi bi-dash-square"></i>
                        </button>
                    </div>
                </div>
                <div class="referent-card-tree">
        `;

        depts.forEach(deptKey => {
            const deptNum = ref.departements[deptKey].numero;
            const deptCantons = cantonsParDept[deptNum] || {};
            const cantonNames = Object.keys(deptCantons).sort((a, b) => a.localeCompare(b, 'fr'));

            html += `
                <div class="tree-node dept-node">
                    <div class="node-header" onclick="toggleModalNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <i class="bi bi-building node-icon text-primary"></i>
                        <span class="node-label">${escapeHtml(deptKey)}</span>
                        <span class="node-count">${cantonNames.length} canton${cantonNames.length > 1 ? 's' : ''}</span>
                    </div>
                    <div class="node-children">
            `;

            if (cantonNames.length > 0) {
                cantonNames.forEach(cantonName => {
                    const membres = deptCantons[cantonName] || [];
                    if (membres.length > 0) {
                        html += `
                            <div class="tree-node canton-node">
                                <div class="node-header" onclick="toggleModalNode(this)">
                                    <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                                    <i class="bi bi-pin-map node-icon text-success"></i>
                                    <span class="node-label">${escapeHtml(cantonName)}</span>
                                    <span class="node-count">${membres.length}</span>
                                </div>
                                <div class="node-children">
                        `;

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
                                <i class="bi bi-pin-map node-icon text-success"></i>
                                <span class="node-label">${escapeHtml(cantonName)}</span>
                            </div>
                        `;
                    }
                });
            } else {
                html += `<div class="text-muted small ps-4">Aucun canton assigne</div>`;
            }

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

    html += '</div>';

    html += `
        <div id="referentDetailOverlay" style="display: none; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: white; z-index: 10; overflow-y: auto; padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #f6ad55;">
                <h5 style="margin: 0; color: #ed8936;"><i class="bi bi-person-badge me-2"></i><span id="referentDetailTitle">Detail du referent</span></h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="hideReferentDetailOverlay()">
                    <i class="bi bi-x-lg"></i> Fermer
                </button>
            </div>
            <div id="referentDetailContent"></div>
        </div>
    `;

    document.getElementById('allReferentsModalBody').innerHTML = html;
    allReferentsModal.show();
}

// Afficher le detail d'un referent dans l'overlay (fonctionne pour les 2 modales)
function showReferentDetailInModal(referentId) {
    if (!regionTreeData || !regionTreeData.referents) return;

    const referentData = regionTreeData.referents.filter(r => r.id === referentId);
    if (referentData.length === 0) return;

    const ref = referentData[0];
    const userName = `${ref.prenom || ''} ${(ref.nom || '').toUpperCase()}`.trim();
    const initials = ((ref.prenom || '').charAt(0) + (ref.nom || '').charAt(0)).toUpperCase();

    const deptsMap = {};
    referentData.forEach(r => {
        const deptKey = r.departement_numero ? `${r.departement_numero} - ${r.departement_nom}` : r.departement_nom || 'Sans departement';
        const deptNum = r.departement_numero || '';
        if (!deptsMap[deptKey]) {
            deptsMap[deptKey] = {
                numero: deptNum,
                nom: r.departement_nom
            };
        }
    });

    const depts = Object.keys(deptsMap).sort((a, b) => a.localeCompare(b, 'fr'));
    const cantonsParDept = regionTreeData.cantonsParDept || {};

    let overlayId, titleId, contentId;
    if (document.getElementById('allReferentsModal').classList.contains('show')) {
        overlayId = 'referentDetailOverlay';
        titleId = 'referentDetailTitle';
        contentId = 'referentDetailContent';
    } else {
        overlayId = 'regionReferentDetailOverlay';
        titleId = 'regionReferentDetailTitle';
        contentId = 'regionReferentDetailContent';
    }

    document.getElementById(titleId).textContent = `${userName} - ${depts.length} departement${depts.length > 1 ? 's' : ''}`;

    let html = `
        <div class="referent-detail-card" style="border: none; box-shadow: none;">
            <div class="referent-card-header" style="border-bottom: none; margin-bottom: 15px;">
                <div class="user-icon-medium" style="width: 60px; height: 60px; font-size: 24px;">${initials}</div>
                <div style="flex: 1;">
                    <div class="referent-name" style="font-size: 20px;">${escapeHtml(userName)}</div>
                    <div class="referent-count">${depts.length} departement${depts.length > 1 ? 's' : ''}</div>
                </div>
            </div>
            <div class="referent-card-tree" style="max-height: none;">
    `;

    depts.forEach(deptKey => {
        const deptNum = deptsMap[deptKey].numero;
        const deptCantons = cantonsParDept[deptNum] || {};
        const cantonNames = Object.keys(deptCantons).sort((a, b) => a.localeCompare(b, 'fr'));

        html += `
            <div class="tree-node dept-node">
                <div class="node-header" onclick="toggleModalNode(this)">
                    <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                    <i class="bi bi-building node-icon text-primary"></i>
                    <span class="node-label">${escapeHtml(deptKey)}</span>
                    <span class="node-count">${cantonNames.length} canton${cantonNames.length > 1 ? 's' : ''}</span>
                </div>
                <div class="node-children expanded">
        `;

        if (cantonNames.length > 0) {
            cantonNames.forEach(cantonName => {
                const cantonData = deptCantons[cantonName] || {};
                const membres = Array.isArray(cantonData) ? cantonData : (cantonData.membres || []);
                const referentsCanton = Array.isArray(cantonData) ? [] : (cantonData.referents || []);
                const totalUsers = membres.length + referentsCanton.length;
                if (totalUsers > 0) {
                    html += `
                        <div class="tree-node canton-node">
                            <div class="node-header" onclick="toggleModalNode(this)">
                                <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                                <i class="bi bi-pin-map node-icon text-success"></i>
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
                                <span class="node-label">${escapeHtml(refName)}</span>
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
                            <i class="bi bi-pin-map node-icon text-success"></i>
                            <span class="node-label">${escapeHtml(cantonName)}</span>
                        </div>
                    `;
                }
            });
        } else {
            html += `<div class="text-muted small ps-4">Aucun canton assigne</div>`;
        }

        html += `
                </div>
            </div>
        `;
    });

    html += `</div></div>`;

    document.getElementById(contentId).innerHTML = html;
    document.getElementById(overlayId).style.display = 'block';
}

// Afficher la modale avec tous les membres
function showAllMembresModal() {
    if (!regionTreeData || !regionTreeData.membres) return;

    if (!allMembresModal) {
        allMembresModal = new bootstrap.Modal(document.getElementById('allMembresModal'));
    }

    const membresMap = {};
    regionTreeData.membres.forEach(m => {
        if (!membresMap[m.id]) {
            membresMap[m.id] = {
                id: m.id,
                nom: m.nom,
                prenom: m.prenom,
                email: m.email,
                regions: {}
            };
        }
        const regionKey = m.region_nom || 'Sans region';
        if (!membresMap[m.id].regions[regionKey]) {
            membresMap[m.id].regions[regionKey] = {
                nom: m.region_nom,
                departements: {}
            };
        }
        const deptKey = m.departement_numero ? `${m.departement_numero} - ${m.departement_nom}` : m.departement_nom || 'Sans departement';
        if (!membresMap[m.id].regions[regionKey].departements[deptKey]) {
            membresMap[m.id].regions[regionKey].departements[deptKey] = {
                numero: m.departement_numero || '',
                nom: m.departement_nom,
                cantons: []
            };
        }
        if (m.canton && !membresMap[m.id].regions[regionKey].departements[deptKey].cantons.includes(m.canton)) {
            membresMap[m.id].regions[regionKey].departements[deptKey].cantons.push(m.canton);
        }
    });

    const membres = Object.values(membresMap).sort((a, b) => {
        const nameA = `${a.nom || ''} ${a.prenom || ''}`.toLowerCase();
        const nameB = `${b.nom || ''} ${b.prenom || ''}`.toLowerCase();
        return nameA.localeCompare(nameB, 'fr');
    });

    if (membres.length === 0) {
        document.getElementById('allMembresModalBody').innerHTML = `
            <div class="text-muted text-center py-4">Aucun membre trouve</div>
        `;
        allMembresModal.show();
        return;
    }

    let html = '<div class="referents-grid">';

    membres.forEach(membre => {
        const userName = `${membre.prenom || ''} ${(membre.nom || '').toUpperCase()}`.trim();
        const initials = ((membre.prenom || '').charAt(0) + (membre.nom || '').charAt(0)).toUpperCase();
        const regions = Object.keys(membre.regions).sort((a, b) => a.localeCompare(b, 'fr'));

        let totalCantons = 0;
        regions.forEach(regionKey => {
            Object.values(membre.regions[regionKey].departements).forEach(dept => {
                totalCantons += dept.cantons.length;
            });
        });

        html += `
            <div class="referent-card membre-card">
                <div class="referent-card-header">
                    <div class="user-icon-medium" style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);">${initials}</div>
                    <div style="flex: 1;">
                        <div class="referent-name">${escapeHtml(userName)}</div>
                        <div class="referent-count">${totalCantons} canton${totalCantons > 1 ? 's' : ''}</div>
                    </div>
                    <div class="card-expand-buttons">
                        <button type="button" class="btn-loupe" onclick="showMembreDetailInModal(${membre.id})" title="Voir detail complet" style="color: #38a169; border-color: #38a169;">
                            <i class="bi bi-search"></i>
                        </button>
                        <button type="button" class="btn-expand-all" onclick="expandAllInCard(this)" title="Tout ouvrir">
                            <i class="bi bi-plus-square"></i>
                        </button>
                        <button type="button" class="btn-collapse-all" onclick="collapseAllInCard(this)" title="Tout fermer">
                            <i class="bi bi-dash-square"></i>
                        </button>
                    </div>
                </div>
                <div class="referent-card-tree">
        `;

        regions.forEach(regionKey => {
            const regionData = membre.regions[regionKey];
            const depts = Object.keys(regionData.departements).sort((a, b) => a.localeCompare(b, 'fr'));

            html += `
                <div class="tree-node region-node">
                    <div class="node-header" onclick="toggleModalNode(this)">
                        <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                        <i class="bi bi-geo-alt node-icon text-info"></i>
                        <span class="node-label">${escapeHtml(regionKey)}</span>
                        <span class="node-count">${depts.length} dept.</span>
                    </div>
                    <div class="node-children">
            `;

            depts.forEach(deptKey => {
                const deptData = regionData.departements[deptKey];
                const cantons = deptData.cantons.sort((a, b) => a.localeCompare(b, 'fr'));

                html += `
                    <div class="tree-node dept-node">
                        <div class="node-header" onclick="toggleModalNode(this)">
                            <span class="node-toggle"><i class="bi bi-chevron-right"></i></span>
                            <i class="bi bi-building node-icon text-primary"></i>
                            <span class="node-label">${escapeHtml(deptKey)}</span>
                            <span class="node-count">${cantons.length} canton${cantons.length > 1 ? 's' : ''}</span>
                        </div>
                        <div class="node-children">
                `;

                if (cantons.length > 0) {
                    cantons.forEach(canton => {
                        html += `
                            <div class="tree-leaf canton-leaf">
                                <i class="bi bi-pin-map node-icon text-success"></i>
                                <span class="node-label">${escapeHtml(canton)}</span>
                            </div>
                        `;
                    });
                } else {
                    html += `<div class="text-muted small ps-4">Aucun canton assigne</div>`;
                }

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

    html += '</div>';

    html += `
        <div id="membreDetailOverlay" style="display: none; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: white; z-index: 10; overflow-y: auto; padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #38a169;">
                <h5 style="margin: 0; color: #38a169;"><i class="bi bi-person me-2"></i><span id="membreDetailTitle">Detail du membre</span></h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="hideMembreDetailOverlay()">
                    <i class="bi bi-x-lg"></i> Fermer
                </button>
            </div>
            <div id="membreDetailContent"></div>
        </div>
    `;

    document.getElementById('allMembresModalBody').innerHTML = html;
    allMembresModal.show();
}

// Afficher le detail d'un membre dans l'overlay
function showMembreDetailInModal(membreId) {
    if (!regionTreeData || !regionTreeData.membres) return;

    const membreData = regionTreeData.membres.filter(m => m.id === membreId);
    if (membreData.length === 0) return;

    const m = membreData[0];
    const userName = `${m.prenom || ''} ${(m.nom || '').toUpperCase()}`.trim();
    const initials = ((m.prenom || '').charAt(0) + (m.nom || '').charAt(0)).toUpperCase();

    const regionsMap = {};
    membreData.forEach(data => {
        const regionKey = data.region_nom || 'Sans region';
        if (!regionsMap[regionKey]) {
            regionsMap[regionKey] = { departements: {} };
        }
        const deptKey = data.departement_numero ? `${data.departement_numero} - ${data.departement_nom}` : data.departement_nom || 'Sans departement';
        if (!regionsMap[regionKey].departements[deptKey]) {
            regionsMap[regionKey].departements[deptKey] = { cantons: [] };
        }
        if (data.canton && !regionsMap[regionKey].departements[deptKey].cantons.includes(data.canton)) {
            regionsMap[regionKey].departements[deptKey].cantons.push(data.canton);
        }
    });

    const regions = Object.keys(regionsMap).sort((a, b) => a.localeCompare(b, 'fr'));

    let totalCantons = 0;
    regions.forEach(regionKey => {
        Object.values(regionsMap[regionKey].departements).forEach(dept => {
            totalCantons += dept.cantons.length;
        });
    });

    document.getElementById('membreDetailTitle').textContent = `${userName} - ${totalCantons} canton${totalCantons > 1 ? 's' : ''}`;

    let html = `
        <div class="referent-detail-card" style="border: none; box-shadow: none;">
            <div class="referent-card-header" style="border-bottom: none; margin-bottom: 15px;">
                <div class="user-icon-medium" style="width: 60px; height: 60px; font-size: 24px; background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);">${initials}</div>
                <div style="flex: 1;">
                    <div class="referent-name" style="font-size: 20px;">${escapeHtml(userName)}</div>
                    <div class="referent-count">${totalCantons} canton${totalCantons > 1 ? 's' : ''}</div>
                </div>
            </div>
            <div class="referent-card-tree" style="max-height: none;">
    `;

    regions.forEach(regionKey => {
        const regionData = regionsMap[regionKey];
        const depts = Object.keys(regionData.departements).sort((a, b) => a.localeCompare(b, 'fr'));

        html += `
            <div class="tree-node region-node">
                <div class="node-header" onclick="toggleModalNode(this)">
                    <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                    <i class="bi bi-geo-alt node-icon text-info"></i>
                    <span class="node-label">${escapeHtml(regionKey)}</span>
                    <span class="node-count">${depts.length} dept.</span>
                </div>
                <div class="node-children expanded">
        `;

        depts.forEach(deptKey => {
            const deptData = regionData.departements[deptKey];
            const cantons = deptData.cantons.sort((a, b) => a.localeCompare(b, 'fr'));

            html += `
                <div class="tree-node dept-node">
                    <div class="node-header" onclick="toggleModalNode(this)">
                        <span class="node-toggle expanded"><i class="bi bi-chevron-right"></i></span>
                        <i class="bi bi-building node-icon text-primary"></i>
                        <span class="node-label">${escapeHtml(deptKey)}</span>
                        <span class="node-count">${cantons.length} canton${cantons.length > 1 ? 's' : ''}</span>
                    </div>
                    <div class="node-children expanded">
            `;

            if (cantons.length > 0) {
                cantons.forEach(canton => {
                    html += `
                        <div class="tree-leaf canton-leaf">
                            <i class="bi bi-pin-map node-icon text-success"></i>
                            <span class="node-label">${escapeHtml(canton)}</span>
                        </div>
                    `;
                });
            } else {
                html += `<div class="text-muted small ps-4">Aucun canton assigne</div>`;
            }

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

    html += `</div></div>`;

    document.getElementById('membreDetailContent').innerHTML = html;
    document.getElementById('membreDetailOverlay').style.display = 'block';
}
