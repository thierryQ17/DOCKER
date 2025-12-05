# Extraire les en-têtes de colonnes
$file = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\toutesLesCommunesDeFranceAvecMaires.csv"
$outputFile = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\mappingEnteteColonne.csv"

# Lire la première ligne (en-têtes)
$firstLine = Get-Content $file -First 1 -Encoding UTF8
$headers = $firstLine -split ";" | ForEach-Object { $_ -replace '"', '' }

# Créer le CSV avec numéro et nom
$result = @()
$i = 1
foreach ($h in $headers) {
    $result += [PSCustomObject]@{
        "numero" = $i
        "nom_colonne" = $h
    }
    $i++
}

# Export UTF-8 BOM
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$csvContent = ($result | ConvertTo-Csv -Delimiter ";" -NoTypeInformation) -join "`r`n"
[System.IO.File]::WriteAllText($outputFile, $csvContent, $utf8Bom)

Write-Host "$($headers.Count) colonnes exportées vers mappingEnteteColonne.csv" -ForegroundColor Green
