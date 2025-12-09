<?php
/**
 * Scraper des responsables UPR depuis https://www.upr.fr/responsables/
 * Extrait : image, nom, département, email
 */

header('Content-Type: application/json; charset=utf-8');

// URL de la page
$url = 'https://www.upr.fr/responsables/';

// Options pour le contexte HTTP
$options = [
    'http' => [
        'method' => 'GET',
        'header' => [
            'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language: fr-FR,fr;q=0.9,en;q=0.8'
        ],
        'timeout' => 30
    ],
    'ssl' => [
        'verify_peer' => false,
        'verify_peer_name' => false
    ]
];

$context = stream_context_create($options);
$html = @file_get_contents($url, false, $context);

if ($html === false) {
    echo json_encode(['error' => 'Impossible de récupérer la page', 'url' => $url]);
    exit;
}

// Parser le HTML avec DOMDocument
libxml_use_internal_errors(true);
$dom = new DOMDocument();
$dom->loadHTML(mb_convert_encoding($html, 'HTML-ENTITIES', 'UTF-8'));
libxml_clear_errors();

$xpath = new DOMXPath($dom);

$responsables = [];

// Chercher tous les blocs responsablesv4-bloc
$blocs = $xpath->query("//div[contains(@class, 'responsablesv4-bloc')]");

foreach ($blocs as $bloc) {
    $responsable = [
        'image' => '',
        'nom' => '',
        'departement' => '',
        'email' => ''
    ];

    // Extraire l'image (img avec class="f" ou simplement img dans le bloc)
    $imgNodes = $xpath->query(".//img", $bloc);
    if ($imgNodes->length > 0) {
        $responsable['image'] = $imgNodes->item(0)->getAttribute('src');
    }

    // Extraire le nom (div ou élément avec class="b")
    $nomNodes = $xpath->query(".//*[contains(@class, 'b')]", $bloc);
    if ($nomNodes->length > 0) {
        $responsable['nom'] = trim($nomNodes->item(0)->textContent);
    }

    // Extraire le département (div ou élément avec class="c")
    $deptNodes = $xpath->query(".//*[contains(@class, 'c')]", $bloc);
    if ($deptNodes->length > 0) {
        $responsable['departement'] = trim($deptNodes->item(0)->textContent);
    }

    // Extraire l'email (div avec class="d" contenant un lien mailto)
    $emailNodes = $xpath->query(".//*[contains(@class, 'd')]//a[contains(@href, 'mailto:')]", $bloc);
    if ($emailNodes->length > 0) {
        $href = $emailNodes->item(0)->getAttribute('href');
        $responsable['email'] = str_replace('mailto:', '', $href);
    } else {
        // Alternative : chercher directement un mailto dans le bloc
        $mailtoNodes = $xpath->query(".//a[contains(@href, 'mailto:')]", $bloc);
        if ($mailtoNodes->length > 0) {
            $href = $mailtoNodes->item(0)->getAttribute('href');
            $responsable['email'] = str_replace('mailto:', '', $href);
        }
    }

    // N'ajouter que si on a au moins un nom
    if (!empty($responsable['nom'])) {
        $responsables[] = $responsable;
    }
}

// Résultat
$result = [
    'count' => count($responsables),
    'source' => $url,
    'date_extraction' => date('Y-m-d H:i:s'),
    'responsables' => $responsables
];

echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
