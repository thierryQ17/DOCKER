<?php
/**
 * Script pour générer responsablesUPR_sansImage.json
 * Retire toutes les entrées "image" du fichier source
 */

$sourceFile = __DIR__ . '/responsablesUPR.json';
$outputFile = __DIR__ . '/responsablesUPR_sansImage.json';

echo "Lecture du fichier source...\n";

// Lire le fichier JSON
$jsonContent = file_get_contents($sourceFile);
if ($jsonContent === false) {
    die("Erreur: Impossible de lire le fichier source\n");
}

// Supprimer le BOM UTF-8 si present
$jsonContent = preg_replace('/^\xEF\xBB\xBF/', '', $jsonContent);

// Decoder le JSON
$data = json_decode($jsonContent, true);
if ($data === null) {
    die("Erreur JSON: " . json_last_error_msg() . "\n");
}

echo "Nombre d'entrees: " . count($data) . "\n";

// Retirer les images de chaque entree
$count = 0;
foreach ($data as &$item) {
    if (isset($item['image'])) {
        unset($item['image']);
        $count++;
    }
}
unset($item);

echo "Images retirees: $count\n";

// Encoder en JSON avec formatage
$outputJson = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

// Ecrire le fichier de sortie
$result = file_put_contents($outputFile, $outputJson);
if ($result === false) {
    die("Erreur: Impossible d'ecrire le fichier de sortie\n");
}

$sizeOriginal = filesize($sourceFile);
$sizeNew = filesize($outputFile);
$reduction = round((1 - $sizeNew / $sizeOriginal) * 100, 1);

echo "\n=== TERMINE ===\n";
echo "Fichier genere: $outputFile\n";
echo "Taille originale: " . number_format($sizeOriginal / 1024, 1) . " Ko\n";
echo "Nouvelle taille: " . number_format($sizeNew / 1024, 1) . " Ko\n";
echo "Reduction: $reduction%\n";
