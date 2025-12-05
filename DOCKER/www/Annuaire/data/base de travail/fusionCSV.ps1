# Fusion de 3 fichiers CSV avec rapport HTML
# Clé de fusion: code_commune

$baseDir = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail"
$file1 = Join-Path $baseDir "1-mairieCommunes.csv"
$file2 = Join-Path $baseDir "2-maires.csv"
$file3 = Join-Path $baseDir "3-touteLaPopulationFrancaise.csv"
$outputFile = Join-Path $baseDir "toutesLesCommunesDeFranceAvecMaires.csv"
$reportFile = Join-Path $baseDir "rapport_fusion.html"

Write-Host "=== FUSION CSV ===" -ForegroundColor Cyan

# Charger les fichiers
Write-Host "Chargement fichiers..." -ForegroundColor Yellow
$data1 = Import-Csv -Path $file1 -Delimiter ";" -Encoding UTF8
$data2 = Import-Csv -Path $file2 -Delimiter ";" -Encoding UTF8
$data3 = Import-Csv -Path $file3 -Delimiter ";" -Encoding UTF8

Write-Host "  File1 (mairieCommunes): $($data1.Count) lignes" -ForegroundColor Gray
Write-Host "  File2 (maires): $($data2.Count) lignes" -ForegroundColor Gray
Write-Host "  File3 (population): $($data3.Count) lignes" -ForegroundColor Gray

# Créer des hashtables pour lookup rapide
$map1 = @{}
foreach ($row in $data1) { $map1[$row.code_commune] = $row }
$map2 = @{}
foreach ($row in $data2) { $map2[$row.code_commune] = $row }
$map3 = @{}
foreach ($row in $data3) { $map3[$row.code_commune] = $row }

# Collecter tous les code_commune uniques
$allCodes = @{}
$data1 | ForEach-Object { $allCodes[$_.code_commune] = $true }
$data2 | ForEach-Object { $allCodes[$_.code_commune] = $true }
$data3 | ForEach-Object { $allCodes[$_.code_commune] = $true }

Write-Host "Codes communes uniques: $($allCodes.Count)" -ForegroundColor Green

# Tracking des erreurs
$errorsFile1Only = @()
$errorsFile2Only = @()
$errorsFile3Only = @()
$errorsNoFile1 = @()
$errorsNoFile2 = @()
$errorsNoFile3 = @()

# Fusion
Write-Host "Fusion en cours..." -ForegroundColor Yellow
$fusionData = @()

foreach ($code in $allCodes.Keys | Sort-Object) {
    $row1 = $map1[$code]
    $row2 = $map2[$code]
    $row3 = $map3[$code]

    # Tracker les erreurs
    $hasFile1 = $null -ne $row1
    $hasFile2 = $null -ne $row2
    $hasFile3 = $null -ne $row3

    if ($hasFile1 -and -not $hasFile2 -and -not $hasFile3) { $errorsFile1Only += $code }
    if (-not $hasFile1 -and $hasFile2 -and -not $hasFile3) { $errorsFile2Only += $code }
    if (-not $hasFile1 -and -not $hasFile2 -and $hasFile3) { $errorsFile3Only += $code }
    if (-not $hasFile1) { $errorsNoFile1 += $code }
    if (-not $hasFile2) { $errorsNoFile2 += $code }
    if (-not $hasFile3) { $errorsNoFile3 += $code }

    # Créer ligne fusionnée
    $merged = [ordered]@{
        "code_commune" = $code
    }

    # Colonnes File1 (sauf code_commune)
    if ($row1) {
        $row1.PSObject.Properties | Where-Object { $_.Name -ne "code_commune" } | ForEach-Object {
            $merged["file1_$($_.Name)"] = $_.Value
        }
    } else {
        # Ajouter colonnes vides de file1
        $data1[0].PSObject.Properties | Where-Object { $_.Name -ne "code_commune" } | ForEach-Object {
            $merged["file1_$($_.Name)"] = ""
        }
    }

    # Colonnes File2 (sauf code_commune)
    if ($row2) {
        $row2.PSObject.Properties | Where-Object { $_.Name -ne "code_commune" } | ForEach-Object {
            $merged["file2_$($_.Name)"] = $_.Value
        }
    } else {
        $data2[0].PSObject.Properties | Where-Object { $_.Name -ne "code_commune" } | ForEach-Object {
            $merged["file2_$($_.Name)"] = ""
        }
    }

    # Colonnes File3 (sauf code_commune)
    if ($row3) {
        $row3.PSObject.Properties | Where-Object { $_.Name -ne "code_commune" } | ForEach-Object {
            $merged["file3_$($_.Name)"] = $_.Value
        }
    } else {
        $data3[0].PSObject.Properties | Where-Object { $_.Name -ne "code_commune" } | ForEach-Object {
            $merged["file3_$($_.Name)"] = ""
        }
    }

    $fusionData += [PSCustomObject]$merged
}

Write-Host "Lignes fusionnées: $($fusionData.Count)" -ForegroundColor Green

# Export CSV UTF-8 BOM
Write-Host "Export CSV..." -ForegroundColor Yellow
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$csvContent = ($fusionData | ConvertTo-Csv -Delimiter ";" -NoTypeInformation) -join "`r`n"
try {
    [System.IO.File]::WriteAllText($outputFile, $csvContent, $utf8Bom)
} catch {
    $outputFile = $outputFile -replace "\.csv$", "_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    [System.IO.File]::WriteAllText($outputFile, $csvContent, $utf8Bom)
}

# Générer rapport HTML
Write-Host "Génération rapport HTML..." -ForegroundColor Yellow

$completeFusion = $fusionData | Where-Object {
    $map1.ContainsKey($_.code_commune) -and $map2.ContainsKey($_.code_commune) -and $map3.ContainsKey($_.code_commune)
}

$html = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport de Fusion CSV</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; }
        .stats { display: flex; flex-wrap: wrap; gap: 15px; margin: 20px 0; }
        .stat-box { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; min-width: 200px; text-align: center; }
        .stat-box.success { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); }
        .stat-box.warning { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-box.error { background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%); }
        .stat-box h3 { margin: 0; font-size: 2em; }
        .stat-box p { margin: 5px 0 0 0; opacity: 0.9; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }
        th { background: #007bff; color: white; }
        tr:nth-child(even) { background: #f9f9f9; }
        .error-section { background: #fff3f3; border-left: 4px solid #dc3545; padding: 15px; margin: 15px 0; border-radius: 5px; }
        .warning-section { background: #fff8e6; border-left: 4px solid #ffc107; padding: 15px; margin: 15px 0; border-radius: 5px; }
        .success-section { background: #e8f5e9; border-left: 4px solid #28a745; padding: 15px; margin: 15px 0; border-radius: 5px; }
        .code-list { max-height: 300px; overflow-y: auto; background: #f8f9fa; padding: 10px; border-radius: 5px; font-family: monospace; font-size: 12px; }
        .timestamp { color: #888; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Rapport de Fusion CSV</h1>
        <p class="timestamp">Généré le $(Get-Date -Format "dd/MM/yyyy à HH:mm:ss")</p>

        <h2>Fichiers Sources</h2>
        <table>
            <tr><th>Fichier</th><th>Lignes</th><th>Préfixe colonnes</th></tr>
            <tr><td>1-mairieCommunes.csv</td><td>$($data1.Count)</td><td>file1_</td></tr>
            <tr><td>2-maires.csv</td><td>$($data2.Count)</td><td>file2_</td></tr>
            <tr><td>3-touteLaPopulationFrancaise.csv</td><td>$($data3.Count)</td><td>file3_</td></tr>
        </table>

        <h2>Statistiques de Fusion</h2>
        <div class="stats">
            <div class="stat-box success">
                <h3>$($allCodes.Count)</h3>
                <p>Codes communes uniques</p>
            </div>
            <div class="stat-box success">
                <h3>$($completeFusion.Count)</h3>
                <p>Fusions complètes (3 fichiers)</p>
            </div>
            <div class="stat-box warning">
                <h3>$($errorsNoFile1.Count)</h3>
                <p>Absents de File1</p>
            </div>
            <div class="stat-box warning">
                <h3>$($errorsNoFile2.Count)</h3>
                <p>Absents de File2</p>
            </div>
            <div class="stat-box warning">
                <h3>$($errorsNoFile3.Count)</h3>
                <p>Absents de File3</p>
            </div>
        </div>

        <h2>Détails des Erreurs</h2>

        <div class="error-section">
            <h3>Codes absents de File1 (mairieCommunes) - $($errorsNoFile1.Count) codes</h3>
            <p>Ces communes n'ont pas de données de mairie (adresse, téléphone, etc.)</p>
            <div class="code-list">$($errorsNoFile1 | Sort-Object | Select-Object -First 500 | ForEach-Object { "$_ " })</div>
            $(if ($errorsNoFile1.Count -gt 500) { "<p><em>... et $($errorsNoFile1.Count - 500) autres</em></p>" })
        </div>

        <div class="error-section">
            <h3>Codes absents de File2 (maires) - $($errorsNoFile2.Count) codes</h3>
            <p>Ces communes n'ont pas de données de maire</p>
            <div class="code-list">$($errorsNoFile2 | Sort-Object | Select-Object -First 500 | ForEach-Object { "$_ " })</div>
            $(if ($errorsNoFile2.Count -gt 500) { "<p><em>... et $($errorsNoFile2.Count - 500) autres</em></p>" })
        </div>

        <div class="error-section">
            <h3>Codes absents de File3 (population) - $($errorsNoFile3.Count) codes</h3>
            <p>Ces communes n'ont pas de données de population INSEE</p>
            <div class="code-list">$($errorsNoFile3 | Sort-Object | Select-Object -First 500 | ForEach-Object { "$_ " })</div>
            $(if ($errorsNoFile3.Count -gt 500) { "<p><em>... et $($errorsNoFile3.Count - 500) autres</em></p>" })
        </div>

        <div class="success-section">
            <h3>Fichier généré</h3>
            <p><strong>$outputFile</strong></p>
            <p>$($fusionData.Count) lignes - Encodage UTF-8 BOM (compatible Excel)</p>
        </div>
    </div>
</body>
</html>
"@

[System.IO.File]::WriteAllText($reportFile, $html, $utf8Bom)

Write-Host ""
Write-Host "=== RESUME ===" -ForegroundColor Cyan
Write-Host "Fusion: $($fusionData.Count) lignes" -ForegroundColor Green
Write-Host "Complètes (3 fichiers): $($completeFusion.Count)" -ForegroundColor Green
Write-Host "Fichier: $outputFile" -ForegroundColor Green
Write-Host "Rapport: $reportFile" -ForegroundColor Green

# Ouvrir le rapport
Start-Process $reportFile
