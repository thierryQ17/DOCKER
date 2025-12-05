<?php
/**
 * Script pour télécharger les cartes des cantons depuis Wikimedia Commons
 *
 * Sources:
 * - PNG: XX-Cantons-2019.png
 * - SVG: Arrondissements_et_cantons_de_[article]_NOM.svg
 *
 * Usage: php download_canton_maps.php [dept_code]
 */

ini_set('display_errors', 1);
error_reporting(E_ALL);
set_time_limit(0);

// Répertoire de destination (chemin Linux pour Docker)
$destDir = '/var/www/html/Annuaire/ressources/images/cartesCirconscriptionCantons/';
if (!is_dir($destDir)) {
    mkdir($destDir, 0777, true);
}

// Liste des départements avec article et nom pour les URLs Wikipedia
$departements = [
    '01' => ['article' => "l'", 'nom' => 'Ain'],
    '02' => ['article' => "l'", 'nom' => 'Aisne'],
    '03' => ['article' => "l'", 'nom' => 'Allier'],
    '04' => ['article' => 'des ', 'nom' => 'Alpes-de-Haute-Provence'],
    '05' => ['article' => 'des ', 'nom' => 'Hautes-Alpes'],
    '06' => ['article' => 'des ', 'nom' => 'Alpes-Maritimes'],
    '07' => ['article' => "l'", 'nom' => 'Ardèche'],
    '08' => ['article' => 'des ', 'nom' => 'Ardennes'],
    '09' => ['article' => "l'", 'nom' => 'Ariège'],
    '10' => ['article' => "l'", 'nom' => 'Aube'],
    '11' => ['article' => "l'", 'nom' => 'Aude'],
    '12' => ['article' => "l'", 'nom' => 'Aveyron'],
    '13' => ['article' => 'des ', 'nom' => 'Bouches-du-Rhône'],
    '14' => ['article' => 'du ', 'nom' => 'Calvados'],
    '15' => ['article' => 'du ', 'nom' => 'Cantal'],
    '16' => ['article' => 'la ', 'nom' => 'Charente'],
    '17' => ['article' => 'la ', 'nom' => 'Charente-Maritime'],
    '18' => ['article' => 'du ', 'nom' => 'Cher'],
    '19' => ['article' => 'la ', 'nom' => 'Corrèze'],
    '2A' => ['article' => 'la ', 'nom' => 'Corse-du-Sud'],
    '2B' => ['article' => 'la ', 'nom' => 'Haute-Corse'],
    '21' => ['article' => 'la ', 'nom' => "Côte-d'Or"],
    '22' => ['article' => 'des ', 'nom' => "Côtes-d'Armor"],
    '23' => ['article' => 'la ', 'nom' => 'Creuse'],
    '24' => ['article' => 'la ', 'nom' => 'Dordogne'],
    '25' => ['article' => 'du ', 'nom' => 'Doubs'],
    '26' => ['article' => 'la ', 'nom' => 'Drôme'],
    '27' => ['article' => "l'", 'nom' => 'Eure'],
    '28' => ['article' => "l'", 'nom' => 'Eure-et-Loir'],
    '29' => ['article' => 'du ', 'nom' => 'Finistère'],
    '30' => ['article' => 'du ', 'nom' => 'Gard'],
    '31' => ['article' => 'la ', 'nom' => 'Haute-Garonne'],
    '32' => ['article' => 'du ', 'nom' => 'Gers'],
    '33' => ['article' => 'la ', 'nom' => 'Gironde'],
    '34' => ['article' => "l'", 'nom' => 'Hérault'],
    '35' => ['article' => "l'", 'nom' => 'Ille-et-Vilaine'],
    '36' => ['article' => "l'", 'nom' => 'Indre'],
    '37' => ['article' => "l'", 'nom' => 'Indre-et-Loire'],
    '38' => ['article' => "l'", 'nom' => 'Isère'],
    '39' => ['article' => 'du ', 'nom' => 'Jura'],
    '40' => ['article' => 'des ', 'nom' => 'Landes'],
    '41' => ['article' => 'du ', 'nom' => 'Loir-et-Cher'],
    '42' => ['article' => 'la ', 'nom' => 'Loire'],
    '43' => ['article' => 'la ', 'nom' => 'Haute-Loire'],
    '44' => ['article' => 'la ', 'nom' => 'Loire-Atlantique'],
    '45' => ['article' => 'du ', 'nom' => 'Loiret'],
    '46' => ['article' => 'du ', 'nom' => 'Lot'],
    '47' => ['article' => 'du ', 'nom' => 'Lot-et-Garonne'],
    '48' => ['article' => 'la ', 'nom' => 'Lozère'],
    '49' => ['article' => 'du ', 'nom' => 'Maine-et-Loire'],
    '50' => ['article' => 'la ', 'nom' => 'Manche'],
    '51' => ['article' => 'la ', 'nom' => 'Marne'],
    '52' => ['article' => 'la ', 'nom' => 'Haute-Marne'],
    '53' => ['article' => 'la ', 'nom' => 'Mayenne'],
    '54' => ['article' => 'la ', 'nom' => 'Meurthe-et-Moselle'],
    '55' => ['article' => 'la ', 'nom' => 'Meuse'],
    '56' => ['article' => 'du ', 'nom' => 'Morbihan'],
    '57' => ['article' => 'la ', 'nom' => 'Moselle'],
    '58' => ['article' => 'la ', 'nom' => 'Nièvre'],
    '59' => ['article' => 'du ', 'nom' => 'Nord'],
    '60' => ['article' => "l'", 'nom' => 'Oise'],
    '61' => ['article' => "l'", 'nom' => 'Orne'],
    '62' => ['article' => 'du ', 'nom' => 'Pas-de-Calais'],
    '63' => ['article' => 'du ', 'nom' => 'Puy-de-Dôme'],
    '64' => ['article' => 'des ', 'nom' => 'Pyrénées-Atlantiques'],
    '65' => ['article' => 'des ', 'nom' => 'Hautes-Pyrénées'],
    '66' => ['article' => 'des ', 'nom' => 'Pyrénées-Orientales'],
    '67' => ['article' => 'du ', 'nom' => 'Bas-Rhin'],
    '68' => ['article' => 'du ', 'nom' => 'Haut-Rhin'],
    '69' => ['article' => 'du ', 'nom' => 'Rhône'],
    '70' => ['article' => 'la ', 'nom' => 'Haute-Saône'],
    '71' => ['article' => 'la ', 'nom' => 'Saône-et-Loire'],
    '72' => ['article' => 'la ', 'nom' => 'Sarthe'],
    '73' => ['article' => 'la ', 'nom' => 'Savoie'],
    '74' => ['article' => 'la ', 'nom' => 'Haute-Savoie'],
    '75' => ['article' => '', 'nom' => 'Paris'],
    '76' => ['article' => 'la ', 'nom' => 'Seine-Maritime'],
    '77' => ['article' => 'la ', 'nom' => 'Seine-et-Marne'],
    '78' => ['article' => 'des ', 'nom' => 'Yvelines'],
    '79' => ['article' => 'des ', 'nom' => 'Deux-Sèvres'],
    '80' => ['article' => 'la ', 'nom' => 'Somme'],
    '81' => ['article' => 'du ', 'nom' => 'Tarn'],
    '82' => ['article' => 'du ', 'nom' => 'Tarn-et-Garonne'],
    '83' => ['article' => 'du ', 'nom' => 'Var'],
    '84' => ['article' => 'du ', 'nom' => 'Vaucluse'],
    '85' => ['article' => 'la ', 'nom' => 'Vendée'],
    '86' => ['article' => 'la ', 'nom' => 'Vienne'],
    '87' => ['article' => 'la ', 'nom' => 'Haute-Vienne'],
    '88' => ['article' => 'des ', 'nom' => 'Vosges'],
    '89' => ['article' => "l'", 'nom' => 'Yonne'],
    '90' => ['article' => 'du ', 'nom' => 'Territoire de Belfort'],
    '91' => ['article' => "l'", 'nom' => 'Essonne'],
    '92' => ['article' => 'des ', 'nom' => 'Hauts-de-Seine'],
    '93' => ['article' => 'la ', 'nom' => 'Seine-Saint-Denis'],
    '94' => ['article' => 'du ', 'nom' => 'Val-de-Marne'],
    '95' => ['article' => 'du ', 'nom' => "Val-d'Oise"],
    '971' => ['article' => 'la ', 'nom' => 'Guadeloupe'],
    '972' => ['article' => 'la ', 'nom' => 'Martinique'],
    '973' => ['article' => 'la ', 'nom' => 'Guyane'],
    '974' => ['article' => 'La ', 'nom' => 'Réunion'],
    '976' => ['article' => '', 'nom' => 'Mayotte']
];

/**
 * Calcule le hash MD5 pour obtenir le chemin Wikimedia Commons
 */
function getWikimediaPath($filename) {
    $hash = md5($filename);
    return substr($hash, 0, 1) . '/' . substr($hash, 0, 2);
}

/**
 * Télécharge un fichier depuis une URL
 */
function downloadFile($url, $destPath, $verbose = true) {
    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_TIMEOUT => 120,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_HTTPHEADER => [
            'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        ]
    ]);

    $content = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);

    if ($verbose && $error) {
        echo "    CURL Error: {$error}\n";
    }

    if ($httpCode === 200 && $content && strlen($content) > 1000) {
        file_put_contents($destPath, $content);
        return true;
    }

    if ($verbose) {
        echo "    HTTP {$httpCode}, taille: " . strlen($content) . " bytes\n";
    }

    return false;
}

/**
 * Construit l'URL Wikimedia Commons pour un fichier
 */
function getWikimediaUrl($filename) {
    $path = getWikimediaPath($filename);
    return "https://upload.wikimedia.org/wikipedia/commons/{$path}/" . rawurlencode($filename);
}

echo "=== Téléchargement des cartes des cantons ===\n";
echo "Destination: {$destDir}\n\n";

// Paramètre département (optionnel)
$targetDept = isset($argv[1]) ? $argv[1] : null;

$stats = [
    'png_ok' => 0,
    'png_err' => 0,
    'svg_ok' => 0,
    'svg_err' => 0
];

foreach ($departements as $code => $info) {
    $code = (string)$code; // Forcer en string pour comparaison
    if ($targetDept && $code !== $targetDept) {
        continue;
    }

    $article = $info['article'];
    $nom = $info['nom'];

    echo "[{$code}] {$nom}\n";

    // 1. Télécharger PNG XX-Cantons-2019.png
    $pngFilename = "{$code}-Cantons-2019.png";
    $pngDest = $destDir . $pngFilename;

    if (file_exists($pngDest) && filesize($pngDest) > 10000) {
        echo "  PNG: Déjà téléchargé (" . round(filesize($pngDest) / 1024) . " KB)\n";
        $stats['png_ok']++;
    } else {
        $pngUrl = getWikimediaUrl($pngFilename);
        echo "  PNG: Téléchargement...\n";

        if (downloadFile($pngUrl, $pngDest)) {
            echo "  PNG: OK (" . round(filesize($pngDest) / 1024) . " KB)\n";
            $stats['png_ok']++;
        } else {
            echo "  PNG: ERREUR - {$pngFilename}\n";
            $stats['png_err']++;
            // Supprimer fichier vide ou invalide
            if (file_exists($pngDest) && filesize($pngDest) < 1000) {
                unlink($pngDest);
            }
        }
    }

    // 2. Télécharger SVG Arrondissements_et_cantons_de_XXX.svg
    $svgDest = $destDir . "{$code}-Arrondissements_cantons.svg";

    if (file_exists($svgDest) && filesize($svgDest) > 1000) {
        echo "  SVG: Déjà téléchargé (" . round(filesize($svgDest) / 1024) . " KB)\n";
        $stats['svg_ok']++;
    } else {
        // Construire toutes les variantes possibles de noms de fichiers
        // Nom sans accents pour certaines variantes
        $nomSansAccents = strtr($nom, [
            'é' => 'e', 'è' => 'e', 'ê' => 'e', 'ë' => 'e',
            'à' => 'a', 'â' => 'a', 'ä' => 'a',
            'î' => 'i', 'ï' => 'i',
            'ô' => 'o', 'ö' => 'o',
            'ù' => 'u', 'û' => 'u', 'ü' => 'u',
            'ç' => 'c', 'œ' => 'oe',
            'É' => 'E', 'È' => 'E', 'Ê' => 'E',
            'À' => 'A', 'Â' => 'A',
            'Î' => 'I', 'Ô' => 'O', 'Ù' => 'U', 'Û' => 'U',
            'Ç' => 'C'
        ]);

        $variantes = [
            // Format standard avec article
            "Arrondissements_et_cantons_de_{$article}{$nom}.svg",
            "Arrondissements_et_cantons_de_" . trim($article) . "{$nom}.svg",
            "Arrondissements_et_cantons_de_" . str_replace(' ', '_', $article) . "{$nom}.svg",
            // Variantes d'articles
            "Arrondissements_et_cantons_de_l'{$nom}.svg",
            "Arrondissements_et_cantons_d'{$nom}.svg",
            "Arrondissements_et_cantons_de_la_{$nom}.svg",
            "Arrondissements_et_cantons_du_{$nom}.svg",
            "Arrondissements_et_cantons_des_{$nom}.svg",
            // Avec apostrophe typographique
            "Arrondissements_et_cantons_de_l'{$nom}.svg",
            "Arrondissements_et_cantons_d'{$nom}.svg",
            // Avec espace au lieu d'underscore après "de"
            "Arrondissements_et_cantons_de l'{$nom}.svg",
            "Arrondissements_et_cantons_de la {$nom}.svg",
            "Arrondissements_et_cantons_du {$nom}.svg",
            "Arrondissements_et_cantons_des {$nom}.svg",
            // Format "Cantons de X"
            "Cantons_de_{$nom}.svg",
            "Cantons_de_{$article}{$nom}.svg",
            "Cantons_de_" . trim($article) . "{$nom}.svg",
            "Cantons_{$nom}.svg",
            "Cantons_{$article}{$nom}.svg",
            // Format "Cantons de X (Région, France)"
            "Cantons_de_{$nom}_(France).svg",
            // Format "Carte cantons 2015 X"
            "Carte_cantons_2015_{$nom}.svg",
            // Variantes sans accents
            "Arrondissements_et_cantons_de_{$article}{$nomSansAccents}.svg",
            "Arrondissements_et_cantons_des_{$nomSansAccents}.svg",
            "Cantons_de_{$nomSansAccents}.svg",
        ];

        // Dédupliquer
        $variantes = array_unique($variantes);

        echo "  SVG: Recherche...\n";

        $found = false;
        foreach ($variantes as $var) {
            $varUrl = getWikimediaUrl($var);
            if (downloadFile($varUrl, $svgDest, false)) {
                echo "  SVG: OK - '{$var}' (" . round(filesize($svgDest) / 1024) . " KB)\n";
                $stats['svg_ok']++;
                $found = true;
                break;
            }
        }

        if (!$found) {
            echo "  SVG: Non trouvé (testé " . count($variantes) . " variantes)\n";
            $stats['svg_err']++;
            // Supprimer fichier vide ou invalide
            if (file_exists($svgDest) && filesize($svgDest) < 1000) {
                unlink($svgDest);
            }
        }
    }

    // Pause entre départements
    usleep(200000); // 0.2 seconde
}

echo "\n=== RÉSUMÉ ===\n";
echo "PNG Cantons-2019: {$stats['png_ok']} OK, {$stats['png_err']} erreurs\n";
echo "SVG Arrondissements: {$stats['svg_ok']} OK, {$stats['svg_err']} erreurs\n";
echo "\nFichiers dans: {$destDir}\n";
