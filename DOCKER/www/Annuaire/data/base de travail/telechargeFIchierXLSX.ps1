# Script de téléchargement des fichiers Excel INSEE - Population légale 2021
# Source: https://www.insee.fr/fr/statistiques/7728806?sommaire=7728826

param(
    [string]$DownloadPath = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\INSEE_Population"
)

Write-Host "=== TELECHARGEMENT FICHIERS INSEE ===" -ForegroundColor Cyan
Write-Host "Source: https://www.insee.fr/fr/statistiques/7728806" -ForegroundColor Gray
Write-Host ""

# Créer le dossier de destination s'il n'existe pas
if (!(Test-Path $DownloadPath)) {
    New-Item -ItemType Directory -Path $DownloadPath | Out-Null
    Write-Host "Dossier créé : $DownloadPath" -ForegroundColor Green
}

# Liste des codes départements (métropole, Corse, outre-mer)
$deptCodes = @(
    '01','02','03','04','05','06','07','08','09','10',
    '11','12','13','14','15','16','17','18','19',
    '2A','2B',
    '21','22','23','24','25','26','27','28','29','30',
    '31','32','33','34','35','36','37','38','39','40',
    '41','42','43','44','45','46','47','48','49','50',
    '51','52','53','54','55','56','57','58','59','60',
    '61','62','63','64','65','66','67','68','69','70',
    '71','72','73','74','75','76','77','78','79','80',
    '81','82','83','84','85','86','87','88','89','90',
    '91','92','93','94','95',
    '971','972','973','974','976'
)

$baseUrl = "https://www.insee.fr/fr/statistiques/fichier/7728806/dep"
$total = $deptCodes.Count
$successCount = 0
$errorCount = 0
$errors = @()

foreach ($code in $deptCodes) {
    $index = $deptCodes.IndexOf($code) + 1
    $url = "$baseUrl$code.xlsx"
    $fileName = "dep$code.xlsx"
    $outPath = Join-Path $DownloadPath $fileName

    Write-Host "[$index/$total] $fileName... " -NoNewline

    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
        $successCount++
        Write-Host "OK" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host "ERREUR" -ForegroundColor Red
        $errors += "$code : $($_.Exception.Message)"
        # Supprimer le fichier partiel s'il existe
        if (Test-Path $outPath) { Remove-Item $outPath }
    }

    # Pause pour ne pas surcharger le serveur
    Start-Sleep -Milliseconds 100
}

# Résumé
Write-Host ""
Write-Host "=== RESUME ===" -ForegroundColor Cyan
Write-Host "Téléchargés: $successCount / $total" -ForegroundColor $(if ($successCount -eq $total) { "Green" } else { "Yellow" })

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "Erreurs ($errorCount):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

Write-Host ""
Write-Host "Destination: $DownloadPath" -ForegroundColor Green

# Ouvrir le dossier
explorer.exe $DownloadPath
