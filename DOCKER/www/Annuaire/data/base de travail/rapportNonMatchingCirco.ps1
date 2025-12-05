# Script pour générer un rapport HTML des communes sans circonscription
$ErrorActionPreference = "Stop"

$csvMairies = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\toutesLesCommunesDeFranceAvecMaires_NEW.csv"
$htmlOutput = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\RapportNonMatchingCirco.html"

Write-Host "=== RAPPORT COMMUNES SANS CIRCONSCRIPTION ===" -ForegroundColor Cyan

# Charger le CSV
$lines = Get-Content $csvMairies -Encoding UTF8
$header = $lines[0] -split ";"

# Trouver les index des colonnes
$colNames = @{}
for ($i = 0; $i -lt $header.Count; $i++) {
    $colNames[$header[$i]] = $i
}

# Collecter les communes sans circonscription
$nonMatching = @()

for ($i = 1; $i -lt $lines.Count; $i++) {
    $line = $lines[$i] -replace "`r", ""
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $cols = $line -split ";"
    $codeCirco = $cols[-1].Trim()  # Dernière colonne = codeCirconscription

    if ([string]::IsNullOrWhiteSpace($codeCirco)) {
        $nonMatching += [PSCustomObject]@{
            CodeCommune = $cols[0]
            NomCommune = $cols[$colNames['file3_nom_commune']]
            CodePostal = $cols[$colNames['file1_code_postal']]
            CodeDept = $cols[$colNames['file3_code_dept']]
            NomDept = $cols[$colNames['file3_nom_dept']]
            NomCanton = $cols[$colNames['file3_nom_canton']]
            Population = $cols[$colNames['file3_population']]
        }
    }
}

Write-Host "Communes sans circonscription: $($nonMatching.Count)" -ForegroundColor Yellow

# Grouper par département
$byDept = $nonMatching | Group-Object -Property CodeDept | Sort-Object Name

# Générer le HTML
$html = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Communes sans circonscription législative</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        h1 { color: #333; border-bottom: 3px solid #e74c3c; padding-bottom: 10px; }
        h2 { color: #2c3e50; margin-top: 30px; background: #ecf0f1; padding: 10px; border-radius: 5px; }
        .summary { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .summary h3 { margin-top: 0; color: #e74c3c; }
        table { border-collapse: collapse; width: 100%; background: #fff; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th { background: #3498db; color: white; padding: 12px 8px; text-align: left; }
        td { padding: 8px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f1f8ff; }
        .dept-header { background: #2c3e50; color: white; }
        .count { font-weight: bold; color: #e74c3c; }
        .note { background: #fff3cd; border: 1px solid #ffc107; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <h1>🏛️ Communes sans correspondance de circonscription législative</h1>

    <div class="summary">
        <h3>Résumé</h3>
        <p><strong>Total communes sans circonscription :</strong> <span class="count">$($nonMatching.Count)</span></p>
        <p><strong>Départements concernés :</strong> $($byDept.Count)</p>
        <p><strong>Date du rapport :</strong> $(Get-Date -Format "dd/MM/yyyy HH:mm")</p>
    </div>

    <div class="note">
        <strong>ℹ️ Note :</strong> Ces communes n'ont pas de correspondance dans le fichier de référence des circonscriptions législatives 2017.
        Cela peut être dû à :
        <ul>
            <li>Communes créées après 2017 (fusions, communes nouvelles)</li>
            <li>Codes INSEE modifiés</li>
            <li>Différences de codification entre les sources</li>
        </ul>
    </div>
"@

foreach ($dept in $byDept) {
    $deptName = ($dept.Group | Select-Object -First 1).NomDept
    $html += @"

    <h2>$($dept.Name) - $deptName ($($dept.Count) communes)</h2>
    <table>
        <tr>
            <th>Code INSEE</th>
            <th>Commune</th>
            <th>Code Postal</th>
            <th>Canton</th>
            <th>Population</th>
        </tr>
"@

    foreach ($commune in ($dept.Group | Sort-Object NomCommune)) {
        $html += @"
        <tr>
            <td>$($commune.CodeCommune)</td>
            <td>$($commune.NomCommune)</td>
            <td>$($commune.CodePostal)</td>
            <td>$($commune.NomCanton)</td>
            <td>$($commune.Population)</td>
        </tr>
"@
    }

    $html += "    </table>`n"
}

$html += @"
</body>
</html>
"@

# Écrire le fichier
$html | Out-File -FilePath $htmlOutput -Encoding UTF8

Write-Host ""
Write-Host "Rapport généré: $htmlOutput" -ForegroundColor Green
