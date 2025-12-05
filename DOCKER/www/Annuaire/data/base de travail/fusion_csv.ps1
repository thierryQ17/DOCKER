# Script de fusion de 4 fichiers CSV sur la clé code_commune
# ETAPE 1: Fusion des 3 fichiers principaux (circonscriptions, communes, maires)
# ETAPE 2: Rattachement de la population (ignoré si code_commune non trouvé dans fusion principale)
# Génère un fichier x-fusion.csv et un rapport HTML détaillé

$file1 = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\1-circonscriptions_cantons.csv"
$file2 = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\2-communes.csv"
$file3 = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\3-maires.csv"
$file4 = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\4-population.csv"
$outputFile = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\x-fusion.csv"
$reportFile = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\x-fusion_rapport.html"

Write-Host "=== FUSION DES FICHIERS CSV ===" -ForegroundColor Cyan
Write-Host ""

# ============================================
# ETAPE 1: Lecture des 3 fichiers principaux
# ============================================
Write-Host "=== ETAPE 1: Fusion des 3 fichiers principaux ===" -ForegroundColor Yellow
Write-Host ""

Write-Host "Lecture de file1 (1-circonscriptions_cantons.csv)..." -ForegroundColor Yellow
$data1 = Import-Csv -Path $file1 -Delimiter ";" -Encoding UTF8
Write-Host "  -> $($data1.Count) lignes"

Write-Host "Lecture de file2 (2-communes.csv)..." -ForegroundColor Yellow
$data2 = Import-Csv -Path $file2 -Delimiter ";" -Encoding UTF8
Write-Host "  -> $($data2.Count) lignes"

Write-Host "Lecture de file3 (3-maires.csv)..." -ForegroundColor Yellow
$data3 = Import-Csv -Path $file3 -Delimiter ";" -Encoding UTF8
Write-Host "  -> $($data3.Count) lignes"

# Créer des hashtables pour recherche rapide (3 fichiers principaux)
$hash1 = @{}
foreach ($row in $data1) {
    $key = $row.code_commune
    if ($key -and -not $hash1.ContainsKey($key)) {
        $hash1[$key] = $row
    }
}

$hash2 = @{}
foreach ($row in $data2) {
    $key = $row.code_commune
    if ($key -and -not $hash2.ContainsKey($key)) {
        $hash2[$key] = $row
    }
}

$hash3 = @{}
foreach ($row in $data3) {
    $key = $row.code_commune
    if ($key -and -not $hash3.ContainsKey($key)) {
        $hash3[$key] = $row
    }
}

# Collecter les clés uniques des 3 fichiers principaux UNIQUEMENT
$mainKeys = @{}
$hash1.Keys | ForEach-Object { $mainKeys[$_] = $true }
$hash2.Keys | ForEach-Object { $mainKeys[$_] = $true }
$hash3.Keys | ForEach-Object { $mainKeys[$_] = $true }

Write-Host ""
Write-Host "Clés uniques (3 fichiers principaux): $($mainKeys.Count)" -ForegroundColor Green

# Initialiser les listes d'erreurs pour les 3 fichiers principaux
$errorsFile1 = @()
$errorsFile2 = @()
$errorsFile3 = @()
$fusionResult = @()
$perfectMatches3 = 0

# Fusion des 3 fichiers principaux
foreach ($key in $mainKeys.Keys) {
    $row1 = $hash1[$key]
    $row2 = $hash2[$key]
    $row3 = $hash3[$key]

    # Vérifier les erreurs (non-correspondances entre les 3 fichiers)
    if (-not $row1) {
        $errorsFile1 += $key
    }
    if (-not $row2) {
        $errorsFile2 += $key
    }
    if (-not $row3) {
        $errorsFile3 += $key
    }

    # Compter les correspondances parfaites (présent dans les 3)
    if ($row1 -and $row2 -and $row3) {
        $perfectMatches3++
    }

    # Créer l'objet fusionné
    $fusionRow = [ordered]@{
        code_commune = $key
    }

    # Ajouter colonnes de file1 (suffixe _file1)
    if ($row1) {
        foreach ($prop in $row1.PSObject.Properties) {
            if ($prop.Name -ne "code_commune") {
                $newName = ($prop.Name.ToLower()) + "_file1"
                $fusionRow[$newName] = $prop.Value
            }
        }
    }

    # Ajouter colonnes de file2 (suffixe _file2)
    if ($row2) {
        foreach ($prop in $row2.PSObject.Properties) {
            if ($prop.Name -ne "code_commune") {
                $newName = ($prop.Name.ToLower()) + "_file2"
                $fusionRow[$newName] = $prop.Value
            }
        }
    }

    # Ajouter colonnes de file3 (suffixe _file3)
    if ($row3) {
        foreach ($prop in $row3.PSObject.Properties) {
            if ($prop.Name -ne "code_commune") {
                $newName = ($prop.Name.ToLower()) + "_file3"
                $fusionRow[$newName] = $prop.Value
            }
        }
    }

    $fusionResult += [PSCustomObject]$fusionRow
}

Write-Host "  -> Fusion principale: $($fusionResult.Count) lignes"
Write-Host "  -> Correspondances parfaites (3 fichiers): $perfectMatches3"

# ============================================
# ETAPE 2: Rattachement de la population
# ============================================
Write-Host ""
Write-Host "=== ETAPE 2: Rattachement de la population ===" -ForegroundColor Yellow

Write-Host "Lecture de file4 (4-population.csv)..." -ForegroundColor Yellow
$data4 = Import-Csv -Path $file4 -Delimiter ";" -Encoding UTF8
Write-Host "  -> $($data4.Count) lignes"

# Créer hashtable pour la population
$hash4 = @{}
foreach ($row in $data4) {
    $key = $row.code_commune
    if ($key -and -not $hash4.ContainsKey($key)) {
        $hash4[$key] = $row
    }
}

# Rattacher la population - IGNORER les codes non trouvés dans la fusion principale
$populationFound = 0
$populationNotFound = @()
$populationIgnored = @()

# Codes dans file4 qui ne sont pas dans la fusion principale (ignorés)
foreach ($key in $hash4.Keys) {
    if (-not $mainKeys.ContainsKey($key)) {
        $populationIgnored += $key
    }
}

# Ajouter la colonne population à chaque ligne de la fusion
for ($i = 0; $i -lt $fusionResult.Count; $i++) {
    $key = $fusionResult[$i].code_commune
    $row4 = $hash4[$key]

    if ($row4) {
        $fusionResult[$i] | Add-Member -NotePropertyName "population_file4" -NotePropertyValue $row4.population -Force
        $populationFound++
    } else {
        $fusionResult[$i] | Add-Member -NotePropertyName "population_file4" -NotePropertyValue "" -Force
        $populationNotFound += $key
    }
}

Write-Host "  -> Population rattachée: $populationFound"
Write-Host "  -> Population non trouvée: $($populationNotFound.Count)"
Write-Host "  -> Population ignorée (code absent fusion): $($populationIgnored.Count)" -ForegroundColor DarkYellow

# ============================================
# EXPORT
# ============================================
Write-Host ""
Write-Host "Export du fichier x-fusion.csv..." -ForegroundColor Yellow
$fusionResult | Export-Csv -Path $outputFile -Delimiter ";" -NoTypeInformation -Encoding UTF8BOM
Write-Host "  -> $($fusionResult.Count) lignes exportées" -ForegroundColor Green

# ============================================
# RAPPORT HTML
# ============================================
Write-Host ""
Write-Host "Génération du rapport HTML..." -ForegroundColor Yellow

$totalErrorsMain = $errorsFile1.Count + $errorsFile2.Count + $errorsFile3.Count
$dateGeneration = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

# Fonction pour générer les lignes du tableau d'erreurs
function Get-ErrorTableRows {
    param($errors, $filename)
    $rows = ""
    foreach ($code in $errors | Sort-Object) {
        $rows += "<tr><td>$code</td><td>$filename</td></tr>`n"
    }
    return $rows
}

$htmlContent = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport de Fusion CSV</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        .header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
        }
        .header h1 { font-size: 1.8rem; margin-bottom: 10px; }
        .header .date { opacity: 0.8; font-size: 0.9rem; }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .stat-card .value { font-size: 2rem; font-weight: 700; color: #17a2b8; }
        .stat-card .label { color: #6c757d; font-size: 0.85rem; margin-top: 5px; }
        .stat-card.success .value { color: #28a745; }
        .stat-card.danger .value { color: #dc3545; }
        .stat-card.warning .value { color: #ffc107; }
        .stat-card.purple .value { color: #6f42c1; }
        .section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .section h2 {
            color: #2d3748;
            font-size: 1.2rem;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        .section h3 {
            color: #4a5568;
            font-size: 1rem;
            margin: 20px 0 10px 0;
        }
        .file-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .file-info .name { font-weight: 600; color: #2d3748; }
        .file-info .count {
            background: #17a2b8;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .file-info .errors {
            background: #dc3545;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .file-info .no-errors {
            background: #28a745;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .file-info .ignored {
            background: #6c757d;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .file-info .extract {
            background: #6f42c1;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .error-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .error-table th {
            background: #17a2b8;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        .error-table td { padding: 10px 12px; border-bottom: 1px solid #e9ecef; }
        .error-table tr:hover { background: #f8f9fa; }
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-file1 { background: #17a2b8; color: white; }
        .badge-file2 { background: #28a745; color: white; }
        .badge-file3 { background: #ffc107; color: #212529; }
        .badge-file4 { background: #6f42c1; color: white; }
        .badge-ignored { background: #6c757d; color: white; }
        .tabs { display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap; }
        .tab {
            padding: 10px 20px;
            background: #e9ecef;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
        }
        .tab:hover { background: #dee2e6; }
        .tab.active { background: #17a2b8; color: white; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .success-box {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .scroll-table { max-height: 400px; overflow-y: auto; }
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #17a2b8;
            padding: 15px;
            border-radius: 0 8px 8px 0;
            margin-bottom: 15px;
        }
        .warning-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            border-radius: 0 8px 8px 0;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Rapport de Fusion CSV</h1>
            <div class="date">Généré le $dateGeneration</div>
        </div>

        <div class="info-box">
            <strong>Processus de fusion en 2 étapes:</strong><br>
            1. Fusion des 3 fichiers principaux (circonscriptions, communes, maires)<br>
            2. Rattachement de la population (codes absents de la fusion = ignorés)
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="value">$($mainKeys.Count)</div>
                <div class="label">Clés fusion principale</div>
            </div>
            <div class="stat-card success">
                <div class="value">$perfectMatches3</div>
                <div class="label">Correspondances parfaites (3 fichiers)</div>
            </div>
            <div class="stat-card danger">
                <div class="value">$totalErrorsMain</div>
                <div class="label">Erreurs fusion principale</div>
            </div>
            <div class="stat-card purple">
                <div class="value">$populationFound</div>
                <div class="label">Population rattachée</div>
            </div>
            <div class="stat-card warning">
                <div class="value">$($populationIgnored.Count)</div>
                <div class="label">Population ignorée</div>
            </div>
            <div class="stat-card">
                <div class="value">$($fusionResult.Count)</div>
                <div class="label">Lignes finales</div>
            </div>
        </div>

        <div class="section">
            <h2>Fichiers sources</h2>

            <h3>Fichiers principaux (fusion obligatoire)</h3>
            <div class="file-info">
                <div>
                    <span class="badge badge-file1">file1</span>
                    <span class="name">1-circonscriptions_cantons.csv</span>
                </div>
                <div>
                    <span class="count">$($data1.Count) lignes</span>
                    $(if ($errorsFile1.Count -gt 0) { "<span class='errors'>$($errorsFile1.Count) manquants</span>" } else { "<span class='no-errors'>Complet</span>" })
                </div>
            </div>
            <div class="file-info">
                <div>
                    <span class="badge badge-file2">file2</span>
                    <span class="name">2-communes.csv</span>
                </div>
                <div>
                    <span class="count">$($data2.Count) lignes</span>
                    $(if ($errorsFile2.Count -gt 0) { "<span class='errors'>$($errorsFile2.Count) manquants</span>" } else { "<span class='no-errors'>Complet</span>" })
                </div>
            </div>
            <div class="file-info">
                <div>
                    <span class="badge badge-file3">file3</span>
                    <span class="name">3-maires.csv</span>
                </div>
                <div>
                    <span class="count">$($data3.Count) lignes</span>
                    $(if ($errorsFile3.Count -gt 0) { "<span class='errors'>$($errorsFile3.Count) manquants</span>" } else { "<span class='no-errors'>Complet</span>" })
                </div>
            </div>

            <h3>Fichier secondaire (rattachement)</h3>
            <div class="file-info">
                <div>
                    <span class="badge badge-file4">file4</span>
                    <span class="name">4-population.csv</span>
                    <span class="extract">colonne population uniquement</span>
                </div>
                <div>
                    <span class="count">$($data4.Count) lignes</span>
                    <span class="no-errors">$populationFound rattachés</span>
                    $(if ($populationIgnored.Count -gt 0) { "<span class='ignored'>$($populationIgnored.Count) ignorés</span>" })
                </div>
            </div>
        </div>

        <div class="section">
            <h2>Détail des non-correspondances</h2>

            $(if ($totalErrorsMain -eq 0 -and $populationNotFound.Count -eq 0 -and $populationIgnored.Count -eq 0) {
                "<div class='success-box'><div style='font-size:3rem'>OK</div><div>Aucune erreur - Fusion parfaite !</div></div>"
            } else {
                @"
            <div class="tabs">
                <button class="tab active" onclick="showTab('main')">Fusion principale ($totalErrorsMain)</button>
                <button class="tab" onclick="showTab('file1')">file1 ($($errorsFile1.Count))</button>
                <button class="tab" onclick="showTab('file2')">file2 ($($errorsFile2.Count))</button>
                <button class="tab" onclick="showTab('file3')">file3 ($($errorsFile3.Count))</button>
                <button class="tab" onclick="showTab('popnotfound')">Pop. non trouvée ($($populationNotFound.Count))</button>
                <button class="tab" onclick="showTab('popignored')">Pop. ignorée ($($populationIgnored.Count))</button>
            </div>

            <div id="tab-main" class="tab-content active">
                <p style="margin-bottom:15px;color:#6c757d;">Codes présents dans un fichier mais absents d'un autre (fusion principale)</p>
                <div class="scroll-table">
                    <table class="error-table">
                        <thead><tr><th>Code Commune</th><th>Fichier manquant</th></tr></thead>
                        <tbody>
                            $(Get-ErrorTableRows -errors $errorsFile1 -filename "<span class='badge badge-file1'>file1</span> 1-circonscriptions_cantons.csv")
                            $(Get-ErrorTableRows -errors $errorsFile2 -filename "<span class='badge badge-file2'>file2</span> 2-communes.csv")
                            $(Get-ErrorTableRows -errors $errorsFile3 -filename "<span class='badge badge-file3'>file3</span> 3-maires.csv")
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="tab-file1" class="tab-content">
                <div class="scroll-table">
                    <table class="error-table">
                        <thead><tr><th>Code Commune manquant dans file1 (1-circonscriptions_cantons.csv)</th></tr></thead>
                        <tbody>$($errorsFile1 | Sort-Object | ForEach-Object { "<tr><td>$_</td></tr>" })</tbody>
                    </table>
                </div>
            </div>

            <div id="tab-file2" class="tab-content">
                <div class="scroll-table">
                    <table class="error-table">
                        <thead><tr><th>Code Commune manquant dans file2 (2-communes.csv)</th></tr></thead>
                        <tbody>$($errorsFile2 | Sort-Object | ForEach-Object { "<tr><td>$_</td></tr>" })</tbody>
                    </table>
                </div>
            </div>

            <div id="tab-file3" class="tab-content">
                <div class="scroll-table">
                    <table class="error-table">
                        <thead><tr><th>Code Commune manquant dans file3 (3-maires.csv)</th></tr></thead>
                        <tbody>$($errorsFile3 | Sort-Object | ForEach-Object { "<tr><td>$_</td></tr>" })</tbody>
                    </table>
                </div>
            </div>

            <div id="tab-popnotfound" class="tab-content">
                <div class="warning-box">
                    Ces codes sont dans la fusion principale mais n'ont pas de population dans file4
                </div>
                <div class="scroll-table">
                    <table class="error-table">
                        <thead><tr><th>Code Commune sans population</th></tr></thead>
                        <tbody>$($populationNotFound | Sort-Object | ForEach-Object { "<tr><td>$_</td></tr>" })</tbody>
                    </table>
                </div>
            </div>

            <div id="tab-popignored" class="tab-content">
                <div class="warning-box">
                    Ces codes sont dans file4 (population) mais absents de la fusion principale - IGNORÉS
                </div>
                <div class="scroll-table">
                    <table class="error-table">
                        <thead><tr><th>Code Commune ignoré (absent de la fusion principale)</th></tr></thead>
                        <tbody>$($populationIgnored | Sort-Object | ForEach-Object { "<tr><td>$_</td></tr>" })</tbody>
                    </table>
                </div>
            </div>
"@
            })
        </div>

        <div class="section">
            <h2>Fichier généré</h2>
            <div class="file-info">
                <div><span class="name">x-fusion.csv</span></div>
                <div>
                    <span class="count">$($fusionResult.Count) lignes</span>
                    <span class="no-errors">UTF-8 BOM (Excel)</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.tab').forEach(el => el.classList.remove('active'));
            document.getElementById('tab-' + tabId).classList.add('active');
            event.target.classList.add('active');
        }
    </script>
</body>
</html>
"@

# Sauvegarder le rapport HTML
$htmlContent | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "  -> Rapport généré: $reportFile" -ForegroundColor Green

# Ouvrir le rapport dans le navigateur
Write-Host ""
Write-Host "Ouverture du rapport..." -ForegroundColor Cyan
Start-Process $reportFile

Write-Host ""
Write-Host "=== TERMINE ===" -ForegroundColor Green
Write-Host "Fichier fusionné: $outputFile"
Write-Host "Rapport HTML: $reportFile"
