# Script pour ajouter la colonne codeCirconscription au fichier CSV
# Jointure sur codeDept + codeCommune (3 derniers chiffres)

$ErrorActionPreference = "Stop"

$csvMairies = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\toutesLesCommunesDeFranceAvecMaires.csv"
$csvCirco = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\Table_de_correspondance_circo_legislatives2017-1.csv"
$csvOutput = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\toutesLesCommunesDeFranceAvecMaires_NEW.csv"

Write-Host "=== AJOUT COLONNE CIRCONSCRIPTION ===" -ForegroundColor Cyan
Write-Host ""

# Charger le fichier de correspondance des circonscriptions
Write-Host "[1/4] Chargement du fichier de correspondance circonscriptions..."
$circoData = @{}
$circoLines = Get-Content $csvCirco -Encoding UTF8
$circoHeader = $circoLines[0] -split ";"

for ($i = 1; $i -lt $circoLines.Count; $i++) {
    $cols = $circoLines[$i] -split ";"
    if ($cols.Count -ge 5) {
        $codeDept = $cols[0].Trim()
        $codeCommune = $cols[2].Trim()
        $codeCirco = $cols[4].Trim()

        # Construire la clé : codeDept + codeCommune (format complet)
        # Le code commune dans circo est sur 3 chiffres, on doit reconstruire le code INSEE complet
        $codeInsee = $codeDept + $codeCommune.PadLeft(3, '0')

        if (-not $circoData.ContainsKey($codeInsee)) {
            $circoData[$codeInsee] = $codeCirco
        }
    }
}
Write-Host "   $($circoData.Count) correspondances chargees" -ForegroundColor Green

# Charger le fichier des mairies
Write-Host "[2/4] Chargement du fichier des mairies..."
$mairiesLines = Get-Content $csvMairies -Encoding UTF8
$totalLines = $mairiesLines.Count - 1
Write-Host "   $totalLines lignes a traiter" -ForegroundColor Green

# Preparer le fichier de sortie avec nouvelle colonne
Write-Host "[3/4] Ajout de la colonne codeCirconscription..."
$output = @()

# Header avec nouvelle colonne
$header = $mairiesLines[0] -replace "`r", ""
$output += "$header;codeCirconscription"

$matched = 0
$notMatched = 0

for ($i = 1; $i -lt $mairiesLines.Count; $i++) {
    $line = $mairiesLines[$i] -replace "`r", ""
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $cols = $line -split ";"
    $codeCommune = $cols[0].Trim()

    # Rechercher la circonscription
    $codeCirco = ""
    if ($circoData.ContainsKey($codeCommune)) {
        $codeCirco = $circoData[$codeCommune]
        $matched++
    } else {
        $notMatched++
    }

    $output += "$line;$codeCirco"

    if ($i % 5000 -eq 0) {
        Write-Host "   Traite: $i / $totalLines" -ForegroundColor Gray
    }
}

# Ecrire le fichier de sortie
Write-Host "[4/4] Ecriture du fichier..."
$output | Out-File -FilePath $csvOutput -Encoding UTF8

Write-Host ""
Write-Host "=== TERMINE ===" -ForegroundColor Cyan
Write-Host "Communes avec circonscription: $matched" -ForegroundColor Green
Write-Host "Communes sans circonscription: $notMatched" -ForegroundColor Yellow
Write-Host "Fichier genere: $csvOutput" -ForegroundColor Green
