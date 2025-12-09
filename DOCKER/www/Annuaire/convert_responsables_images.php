<?php
/**
 * Script de conversion des images base64 en fichiers PNG/WEBP
 * Exécuter via Docker : docker exec php_fpm php //var/www/html/Annuaire/convert_responsables_images.php
 */

$inputFile = __DIR__ . '/data/responsablesUPR.json';
$outputDir = __DIR__ . '/ressources/images/responsablesUPR';
$outputJson = __DIR__ . '/data/responsablesUPR_clean.json';

// Créer le dossier de sortie
if (!is_dir($outputDir)) {
    mkdir($outputDir, 0755, true);
    echo "Dossier créé: $outputDir\n";
}

// Lire le JSON source
$jsonContent = file_get_contents($inputFile);
if ($jsonContent === false) {
    die("Erreur: Impossible de lire $inputFile\n");
}

$responsables = json_decode($jsonContent, true);
if ($responsables === null) {
    die("Erreur: JSON invalide\n");
}

echo "Nombre de responsables: " . count($responsables) . "\n";

// Vérifier si GD est disponible
$hasGD = function_exists('imagecreatefromstring');
echo "Extension GD: " . ($hasGD ? "OUI" : "NON") . "\n";

$converted = 0;
$errors = 0;

foreach ($responsables as $index => &$responsable) {
    $image = $responsable['image'] ?? '';

    if (empty($image)) {
        $responsable['image'] = '';
        continue;
    }

    // Vérifier si c'est une image base64
    if (strpos($image, 'data:image/') === 0) {
        if (preg_match('/^data:image\/(\w+);base64,(.+)$/', $image, $matches)) {
            $imageType = $matches[1]; // webp, png, jpeg
            $base64Data = $matches[2];
            $imageData = base64_decode($base64Data);

            if ($imageData === false) {
                $errors++;
                continue;
            }

            // Nom de fichier basé sur le nom
            $safeName = preg_replace('/[^a-zA-Z0-9_-]/', '_', $responsable['nom'] ?? 'inconnu');
            $safeName = strtolower(preg_replace('/_+/', '_', trim($safeName, '_')));

            // Si GD disponible, convertir en PNG
            if ($hasGD) {
                $filename = sprintf('%03d_%s.png', $index + 1, $safeName);
                $filepath = $outputDir . '/' . $filename;

                $imgResource = @imagecreatefromstring($imageData);
                if ($imgResource !== false) {
                    imagepng($imgResource, $filepath, 6);
                    imagedestroy($imgResource);
                    $responsable['image'] = 'ressources/images/responsablesUPR/' . $filename;
                    $converted++;
                    echo "[$index] PNG: $filename\n";
                } else {
                    // Fallback: sauvegarder tel quel
                    $filename = sprintf('%03d_%s.%s', $index + 1, $safeName, $imageType);
                    $filepath = $outputDir . '/' . $filename;
                    file_put_contents($filepath, $imageData);
                    $responsable['image'] = 'ressources/images/responsablesUPR/' . $filename;
                    $converted++;
                    echo "[$index] $imageType: $filename\n";
                }
            } else {
                // Sans GD: sauvegarder le fichier tel quel (webp, png, etc.)
                $filename = sprintf('%03d_%s.%s', $index + 1, $safeName, $imageType);
                $filepath = $outputDir . '/' . $filename;

                if (file_put_contents($filepath, $imageData)) {
                    $responsable['image'] = 'ressources/images/responsablesUPR/' . $filename;
                    $converted++;
                    echo "[$index] $imageType: $filename\n";
                } else {
                    echo "[$index] ERREUR: " . ($responsable['nom'] ?? 'Inconnu') . "\n";
                    $errors++;
                }
            }
        }
    }
}

// Sauvegarder le nouveau JSON
file_put_contents($outputJson, json_encode($responsables, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

echo "\n=== RÉSUMÉ ===\n";
echo "Images converties: $converted\n";
echo "Erreurs: $errors\n";
echo "JSON nettoyé: $outputJson\n";

// Taille des fichiers
$inputSize = filesize($inputFile);
$outputSize = filesize($outputJson);
echo "JSON original: " . number_format($inputSize / 1024 / 1024, 2) . " MB\n";
echo "JSON nettoyé: " . number_format($outputSize / 1024, 2) . " KB\n";
