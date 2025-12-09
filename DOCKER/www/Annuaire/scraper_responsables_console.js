/**
 * Script à exécuter dans la console du navigateur sur https://www.upr.fr/responsables/
 * Copier-coller ce code dans la console (F12 > Console)
 */

(function() {
    const responsables = [];

    // Sélectionner tous les blocs responsablesv4-bloc
    const blocs = document.querySelectorAll('.responsablesv4-bloc');

    console.log(`Trouvé ${blocs.length} blocs de responsables`);

    blocs.forEach((bloc, index) => {
        const responsable = {
            image: '',
            nom: '',
            departement: '',
            email: ''
        };

        // Image (class="f" ou img dans le bloc)
        const img = bloc.querySelector('img.f') || bloc.querySelector('img');
        if (img) {
            responsable.image = img.src || img.getAttribute('data-src') || '';
        }

        // Nom (class="b")
        const nomEl = bloc.querySelector('.b');
        if (nomEl) {
            responsable.nom = nomEl.textContent.trim();
        }

        // Département (class="c")
        const deptEl = bloc.querySelector('.c');
        if (deptEl) {
            responsable.departement = deptEl.textContent.trim();
        }

        // Email (class="d" avec mailto)
        const emailEl = bloc.querySelector('.d a[href^="mailto:"]') || bloc.querySelector('a[href^="mailto:"]');
        if (emailEl) {
            responsable.email = emailEl.href.replace('mailto:', '');
        }

        // N'ajouter que si on a au moins un nom
        if (responsable.nom) {
            responsables.push(responsable);
        }
    });

    console.log(`Extrait ${responsables.length} responsables`);

    // Afficher les résultats
    console.table(responsables);

    // Créer un JSON téléchargeable
    const json = JSON.stringify({
        count: responsables.length,
        source: window.location.href,
        date_extraction: new Date().toISOString(),
        responsables: responsables
    }, null, 2);

    // Créer un lien de téléchargement
    const blob = new Blob([json], {type: 'application/json'});
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'responsables_upr.json';
    a.click();
    URL.revokeObjectURL(url);

    console.log('Fichier JSON téléchargé !');

    // Retourner aussi les données
    return responsables;
})();
