# Script d'export des responsables UPR en CSV et JSON

$jsonPath = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\data\responsablesUPR.json"
$imgPath = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\ressources\images\responsablesUPR"
$outputCsv = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\data\responsables_export.csv"
$outputJson = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\data\responsables_export.json"

# Fonction pour normaliser les caracteres accentues
function Remove-Accents {
    param([string]$text)
    $normalized = $text.Normalize([System.Text.NormalizationForm]::FormD)
    $sb = New-Object System.Text.StringBuilder
    foreach ($char in $normalized.ToCharArray()) {
        $unicodeCategory = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($char)
        if ($unicodeCategory -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($char)
        }
    }
    $result = $sb.ToString().Normalize([System.Text.NormalizationForm]::FormC)
    $result = $result -replace [char]0x0153, 'oe'
    $result = $result -replace [char]0x0152, 'OE'
    return $result
}

# Charger le JSON
Write-Host "Chargement du fichier JSON..." -ForegroundColor Cyan
$json = Get-Content $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json

# Lister les images disponibles
$images = Get-ChildItem -Path $imgPath -Filter "*.png" | Select-Object -ExpandProperty Name

Write-Host "Nombre d entrees JSON: $($json.Count)" -ForegroundColor Yellow
Write-Host "Nombre d images PNG: $($images.Count)" -ForegroundColor Yellow
Write-Host ""

$resultats = @()
$compteur = 0
$imagesNonTrouvees = 0

foreach ($item in $json) {
    $compteur++

    $nomComplet = $item.nom
    $dept = $item.departement
    $email = $item.email

    if (-not $nomComplet) { continue }

    # Separer prenom et nom
    $parts = $nomComplet -split '\s+'
    $prenomParts = @()
    $nomParts = @()

    foreach ($part in $parts) {
        if ($part -ceq $part.ToUpper() -and $part -match '^[A-Z\-]+$') {
            $nomParts += $part
        } else {
            $prenomParts += $part
        }
    }

    $prenom = ($prenomParts -join ' ').Trim()
    $nom = ($nomParts -join ' ').Trim()

    if (-not $nom -and $prenom) {
        $nom = $prenom
        $prenom = ""
    }

    # Determiner le role
    $role = 2  # Admin par defaut
    if ($dept -match '^\d{2,3}\s*:\s*\w+') {
        $role = 3  # Referent
    }

    # Construire le nom de fichier image attendu
    # Format: XX_Prenom.NOM.png ou Prenom.NOM.png
    $imageFile = ""

    # Normaliser le nom complet pour la recherche
    $nomCompletNormalized = Remove-Accents $nomComplet
    $nomCompletNormalized = $nomCompletNormalized -replace '[^a-zA-Z0-9\s\-]', ''
    $nomCompletNormalized = $nomCompletNormalized.Trim()

    # Remplacer espaces par points
    $nomFormatted = ($nomCompletNormalized -split '\s+') -join '.'

    # Extraire le numero de departement
    $numDept = ""
    if ($dept -match '^(\d{2,3})\s*:') {
        $numDept = $matches[1]
    }

    # Chercher l'image avec le nouveau format
    $matchedImage = $null

    if ($numDept) {
        # Format: XX_Prenom.NOM.png
        $searchPattern = "${numDept}_${nomFormatted}.png"
        $matchedImage = $images | Where-Object { $_ -eq $searchPattern }

        if (-not $matchedImage) {
            # Essayer recherche partielle par nom de famille
            $nomNormalized = Remove-Accents $nom
            $matchedImage = $images | Where-Object { $_ -like "${numDept}_*" -and $_ -like "*$nomNormalized*" } | Select-Object -First 1
        }
    }

    # Si pas trouve, chercher par nom seul (sans numero)
    if (-not $matchedImage) {
        $searchPattern = "${nomFormatted}.png"
        $matchedImage = $images | Where-Object { $_ -eq $searchPattern }
    }

    # Recherche par nom de famille
    if (-not $matchedImage -and $nom) {
        $nomNormalized = Remove-Accents $nom
        $matchedImage = $images | Where-Object { $_ -like "*$nomNormalized*" } | Select-Object -First 1
    }

    if ($matchedImage) {
        $imageFile = "ressources/images/responsablesUPR/$matchedImage"
    } else {
        $imagesNonTrouvees++
    }

    # Affichage
    $roleLabel = if ($role -eq 3) { "Referent" } else { "Admin" }
    $roleColor = if ($role -eq 3) { "Green" } else { "Yellow" }
    $imgStatus = if ($imageFile) { "[IMG OK]" } else { "[IMG --]" }
    $imgColor = if ($imageFile) { "Green" } else { "Red" }

    Write-Host "[$compteur] " -ForegroundColor Cyan -NoNewline
    Write-Host "$imgStatus " -ForegroundColor $imgColor -NoNewline
    Write-Host "$prenom " -ForegroundColor White -NoNewline
    Write-Host "$nom" -ForegroundColor Green -NoNewline
    Write-Host " | $roleLabel" -ForegroundColor $roleColor

    $resultats += [PSCustomObject]@{
        Nom         = $nom
        Prenom      = $prenom
        Departement = $dept
        Email       = if ($email) { $email } else { "" }
        Image       = $imageFile
        Role        = $role
    }
}

# Export CSV avec UTF8 BOM (compatible Excel)
Write-Host ""
Write-Host "Export CSV..." -ForegroundColor Cyan
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$csvContent = $resultats | ConvertTo-Csv -NoTypeInformation -Delimiter ";"
[System.IO.File]::WriteAllLines($outputCsv, $csvContent, $utf8Bom)

# Export JSON
Write-Host "Export JSON..." -ForegroundColor Cyan
$exportJson = [PSCustomObject]@{
    DateExport = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Total = $resultats.Count
    Referents = ($resultats | Where-Object { $_.Role -eq 3 }).Count
    Admins = ($resultats | Where-Object { $_.Role -eq 2 }).Count
    ImagesNonTrouvees = $imagesNonTrouvees
    Donnees = $resultats
}
$exportJson | ConvertTo-Json -Depth 5 | Out-File -FilePath $outputJson -Encoding UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " EXPORT TERMINE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total              : $($resultats.Count)" -ForegroundColor White
Write-Host "Referents          : $(($resultats | Where-Object { $_.Role -eq 3 }).Count)" -ForegroundColor Green
Write-Host "Admins             : $(($resultats | Where-Object { $_.Role -eq 2 }).Count)" -ForegroundColor Yellow
Write-Host "Images non trouvees: $imagesNonTrouvees" -ForegroundColor Red
Write-Host ""
Write-Host "[OK] CSV : $outputCsv" -ForegroundColor Green
Write-Host "[OK] JSON: $outputJson" -ForegroundColor Green
