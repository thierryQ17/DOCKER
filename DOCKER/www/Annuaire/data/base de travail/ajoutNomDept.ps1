# Script pour ajouter le nom du département dans le fichier population
# Clé: NumeroDept (départements.csv) = code_dept (population.csv)

$baseDir = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail"
$deptFile = Get-ChildItem -Path $baseDir -Filter "*partements.csv" | Select-Object -First 1
$popFile = Join-Path $baseDir "3-touteLaPopulationFrancaise.csv"
$outputFile = $popFile  # Remplace le fichier original

if (-not $deptFile) {
    Write-Host "ERREUR: Fichier départements.csv introuvable!" -ForegroundColor Red
    exit 1
}
$deptFile = $deptFile.FullName

Write-Host "=== AJOUT NOM DEPARTEMENT ===" -ForegroundColor Cyan

# Charger la table des départements
Write-Host "Chargement départements..." -ForegroundColor Yellow
$deptData = Import-Csv -Path $deptFile -Delimiter ";" -Encoding UTF8
$deptMap = @{}
foreach ($row in $deptData) {
    $deptMap[$row.NumeroDept] = $row.NomDept
}
Write-Host "  $($deptMap.Count) départements chargés" -ForegroundColor Green

# Charger et mettre à jour le fichier population
Write-Host "Mise à jour population..." -ForegroundColor Yellow
$popData = Import-Csv -Path $popFile -Delimiter ";" -Encoding UTF8
$updated = 0
foreach ($row in $popData) {
    if ($deptMap.ContainsKey($row.code_dept)) {
        $row.nom_dept = $deptMap[$row.code_dept]
        $updated++
    }
}
Write-Host "  $updated lignes mises à jour" -ForegroundColor Green

# Exporter avec UTF-8 BOM
Write-Host "Export CSV..." -ForegroundColor Yellow
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$csvContent = ($popData | ConvertTo-Csv -Delimiter ";" -NoTypeInformation) -join "`r`n"
try {
    [System.IO.File]::WriteAllText($outputFile, $csvContent, $utf8Bom)
} catch {
    Write-Host "Fichier verrouillé, écriture dans un nouveau fichier..." -ForegroundColor Yellow
    $outputFile = $popFile -replace "\.csv$", "_updated.csv"
    [System.IO.File]::WriteAllText($outputFile, $csvContent, $utf8Bom)
}

Write-Host ""
Write-Host "Terminé! Fichier: $outputFile" -ForegroundColor Green
