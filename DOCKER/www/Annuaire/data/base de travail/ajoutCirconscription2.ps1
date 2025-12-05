# Script pour ajouter la colonne Circonscription au fichier CSV
# Extraction du numéro depuis "1ère circonscription" => 1, "10ème circonscription" => 10
$ErrorActionPreference = "Stop"

$csvBureaux = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\3-bureauxDeVote-circonscriptions.csv"
$csvMairies = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\5-toutesLesCommunesDeFranceAvecMaires.csv"
$csvOutput = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\6-toutesLesCommunesDeFranceAvecMaires.csv"
$htmlReport = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\rapportCircoBUG.html"

Write-Host "=== AJOUT COLONNE CIRCONSCRIPTION ===" -ForegroundColor Cyan
Write-Host ""

# =============================================
# ETAPE 1: Charger le fichier des bureaux de vote
# =============================================
Write-Host "[1/4] Chargement du fichier des bureaux de vote..."
$circoData = @{}
$circoDetails = @{}
$bureauxLines = Get-Content $csvBureaux -Encoding UTF8
$bureauxHeader = $bureauxLines[0] -split ";"

# Format: codeDepartement;nomDepartement;codeCirconscription;nomCirconscription;codeCommune;nomCommune
for ($i = 1; $i -lt $bureauxLines.Count; $i++) {
    $line = $bureauxLines[$i] -replace "`r", ""
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $cols = $line -split ";"
    if ($cols.Count -ge 6) {
        $codeCommune = $cols[4].Trim()
        $nomCirconscription = $cols[3].Trim()
        $codeCirconscription = $cols[2].Trim()
        $nomDept = $cols[1].Trim()

        # Extraire le numéro de circonscription (1ère => 1, 10ème => 10)
        if ($nomCirconscription -match '^(\d+)') {
            $numCirco = $matches[1]

            if (-not $circoData.ContainsKey($codeCommune)) {
                $circoData[$codeCommune] = $numCirco
                $circoDetails[$codeCommune] = @{
                    NumCirco = $numCirco
                    NomCirco = $nomCirconscription
                    CodeCirco = $codeCirconscription
                    NomDept = $nomDept
                }
            }
        }
    }
}
Write-Host "   $($circoData.Count) correspondances chargees" -ForegroundColor Green

# =============================================
# ETAPE 2: Charger et traiter le fichier des mairies
# =============================================
Write-Host "[2/4] Chargement du fichier des mairies..."
$mairiesLines = Get-Content $csvMairies -Encoding UTF8
$totalLines = $mairiesLines.Count - 1
Write-Host "   $totalLines lignes a traiter" -ForegroundColor Green

# =============================================
# ETAPE 3: Ajouter la colonne Circonscription
# =============================================
Write-Host "[3/4] Ajout de la colonne Circonscription..."
$output = @()
$matched = @()
$notMatched = @()

# Header avec nouvelle colonne
$header = $mairiesLines[0] -replace "`r", ""
# Supprimer BOM si présent
$header = $header -replace '^\xEF\xBB\xBF', ''
$output += "$header;Circonscription"

# Parser le header pour trouver les colonnes utiles
$headerCols = $header -split ";"
$colIndex = @{}
for ($j = 0; $j -lt $headerCols.Count; $j++) {
    $colIndex[$headerCols[$j]] = $j
}

for ($i = 1; $i -lt $mairiesLines.Count; $i++) {
    $line = $mairiesLines[$i] -replace "`r", ""
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $cols = $line -split ";"
    $codeCommune = $cols[0].Trim()

    # Récupérer infos pour le rapport
    $nomCommune = if ($colIndex.ContainsKey('file3_nom_commune')) { $cols[$colIndex['file3_nom_commune']] } else { "" }
    $codeDept = if ($colIndex.ContainsKey('file3_code_dept')) { $cols[$colIndex['file3_code_dept']] } else { "" }
    $nomDept = if ($colIndex.ContainsKey('file3_nom_dept')) { $cols[$colIndex['file3_nom_dept']] } else { "" }
    $nomCanton = if ($colIndex.ContainsKey('file3_nom_canton')) { $cols[$colIndex['file3_nom_canton']] } else { "" }
    $population = if ($colIndex.ContainsKey('file3_population')) { $cols[$colIndex['file3_population']] } else { "" }

    # Rechercher la circonscription
    $numCirco = ""
    if ($circoData.ContainsKey($codeCommune)) {
        $numCirco = $circoData[$codeCommune]
        $matched += [PSCustomObject]@{
            CodeCommune = $codeCommune
            NomCommune = $nomCommune
            CodeDept = $codeDept
            NomDept = $nomDept
            Circonscription = $numCirco
        }
    } else {
        $notMatched += [PSCustomObject]@{
            CodeCommune = $codeCommune
            NomCommune = $nomCommune
            CodeDept = $codeDept
            NomDept = $nomDept
            NomCanton = $nomCanton
            Population = $population
        }
    }

    $output += "$line;$numCirco"

    if ($i % 5000 -eq 0) {
        Write-Host "   Traite: $i / $totalLines" -ForegroundColor Gray
    }
}

# Ecrire le fichier de sortie
Write-Host "[4/4] Ecriture des fichiers..."
$output | Out-File -FilePath $csvOutput -Encoding UTF8

# =============================================
# GENERATION DU RAPPORT HTML
# =============================================
Write-Host ""
Write-Host "Generation du rapport HTML..." -ForegroundColor Yellow

# Grouper les non-matchés par département
$byDept = $notMatched | Group-Object -Property CodeDept | Sort-Object {
    $name = $_.Name
    if ($name -match '^\d+$') { [int]$name } else { $name }
}

# Stats par département
$statsByDept = @{}
foreach ($dept in $byDept) {
    $deptName = ($dept.Group | Select-Object -First 1).NomDept
    $statsByDept[$dept.Name] = @{
        NomDept = $deptName
        Count = $dept.Count
        Communes = $dept.Group
    }
}

$html = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport - Communes sans correspondance Circonscription</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        header {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            padding: 30px 40px;
        }
        h1 {
            margin: 0 0 10px 0;
            font-size: 28px;
            font-weight: 600;
        }
        .subtitle { opacity: 0.9; font-size: 14px; }
        .content { padding: 30px 40px; }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            border-left: 4px solid #3498db;
        }
        .summary-card.error { border-left-color: #e74c3c; }
        .summary-card.success { border-left-color: #27ae60; }
        .summary-card.warning { border-left-color: #f39c12; }
        .summary-card .number {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
        }
        .summary-card .label {
            font-size: 12px;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .note {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            padding: 15px 20px;
            margin-bottom: 30px;
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }
        .note-icon { font-size: 24px; }
        .note-content h4 { margin: 0 0 8px 0; color: #856404; }
        .note-content ul { margin: 0; padding-left: 20px; color: #856404; }

        .dept-section {
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
        }
        .dept-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 15px 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .dept-header:hover { background: linear-gradient(135deg, #34495e 0%, #2c3e50 100%); }
        .dept-title { font-weight: 600; font-size: 16px; }
        .dept-count {
            background: rgba(255,255,255,0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        .dept-content { display: none; }
        .dept-content.open { display: block; }

        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #f8f9fa;
            color: #495057;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #dee2e6;
        }
        td {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        tr:hover td { background: #f8f9fa; }

        .code { font-family: 'Consolas', monospace; color: #6c757d; }
        .population { text-align: right; }

        footer {
            background: #f8f9fa;
            padding: 20px 40px;
            text-align: center;
            color: #6c757d;
            font-size: 13px;
            border-top: 1px solid #dee2e6;
        }

        .toggle-all {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .toggle-all:hover { background: #2980b9; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🔍 Rapport - Communes sans correspondance Circonscription</h1>
            <div class="subtitle">Analyse de la jointure entre les fichiers de communes et de bureaux de vote</div>
        </header>

        <div class="content">
            <div class="summary-grid">
                <div class="summary-card success">
                    <div class="number">$($matched.Count)</div>
                    <div class="label">Communes avec circo</div>
                </div>
                <div class="summary-card error">
                    <div class="number">$($notMatched.Count)</div>
                    <div class="label">Communes sans circo</div>
                </div>
                <div class="summary-card warning">
                    <div class="number">$($byDept.Count)</div>
                    <div class="label">Departements concernes</div>
                </div>
                <div class="summary-card">
                    <div class="number">$([math]::Round(($matched.Count / ($matched.Count + $notMatched.Count)) * 100, 1))%</div>
                    <div class="label">Taux de correspondance</div>
                </div>
            </div>

            <div class="note">
                <div class="note-icon">⚠️</div>
                <div class="note-content">
                    <h4>Causes possibles des non-correspondances</h4>
                    <ul>
                        <li><strong>Communes nouvelles</strong> - Creees apres 2022 (fusions de communes)</li>
                        <li><strong>Codes INSEE modifies</strong> - Suite a des reorganisations administratives</li>
                        <li><strong>Communes deleguees</strong> - Integrees dans une commune nouvelle</li>
                        <li><strong>Differences de sources</strong> - Decalages entre les fichiers officiels</li>
                    </ul>
                </div>
            </div>

            <button class="toggle-all" onclick="toggleAll()">📂 Deployer/Replier tout</button>

"@

foreach ($dept in $byDept) {
    $deptCode = $dept.Name
    $deptName = ($dept.Group | Select-Object -First 1).NomDept
    $deptCount = $dept.Count

    $html += @"
            <div class="dept-section">
                <div class="dept-header" onclick="toggleDept(this)">
                    <span class="dept-title">$deptCode - $deptName</span>
                    <span class="dept-count">$deptCount commune(s)</span>
                </div>
                <div class="dept-content">
                    <table>
                        <tr>
                            <th>Code INSEE</th>
                            <th>Commune</th>
                            <th>Canton</th>
                            <th>Population</th>
                        </tr>
"@

    foreach ($commune in ($dept.Group | Sort-Object NomCommune)) {
        $html += @"
                        <tr>
                            <td class="code">$($commune.CodeCommune)</td>
                            <td>$($commune.NomCommune)</td>
                            <td>$($commune.NomCanton)</td>
                            <td class="population">$($commune.Population)</td>
                        </tr>
"@
    }

    $html += @"
                    </table>
                </div>
            </div>
"@
}

$html += @"
        </div>

        <footer>
            Rapport genere le $(Get-Date -Format "dd/MM/yyyy a HH:mm:ss") |
            Source: 3-bureauxDeVote-circonscriptions.csv → 5-toutesLesCommunesDeFranceAvecMaires.csv
        </footer>
    </div>

    <script>
        function toggleDept(header) {
            const content = header.nextElementSibling;
            content.classList.toggle('open');
        }

        function toggleAll() {
            const contents = document.querySelectorAll('.dept-content');
            const allOpen = Array.from(contents).every(c => c.classList.contains('open'));
            contents.forEach(c => {
                if (allOpen) {
                    c.classList.remove('open');
                } else {
                    c.classList.add('open');
                }
            });
        }
    </script>
</body>
</html>
"@

$html | Out-File -FilePath $htmlReport -Encoding UTF8

Write-Host ""
Write-Host "=== TERMINE ===" -ForegroundColor Cyan
Write-Host "Communes avec circonscription: $($matched.Count)" -ForegroundColor Green
Write-Host "Communes sans circonscription: $($notMatched.Count)" -ForegroundColor Yellow
Write-Host "Taux de correspondance: $([math]::Round(($matched.Count / ($matched.Count + $notMatched.Count)) * 100, 2))%" -ForegroundColor Cyan
Write-Host ""
Write-Host "Fichier CSV genere: $csvOutput" -ForegroundColor Green
Write-Host "Rapport HTML genere: $htmlReport" -ForegroundColor Green
