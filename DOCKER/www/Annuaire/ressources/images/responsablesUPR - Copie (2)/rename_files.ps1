# Script de renommage des fichiers PNG base sur responsablesUPR.json

$jsonPath = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\data\responsablesUPR.json"
$imgPath = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\ressources\images\responsablesUPR"

# Fonction pour normaliser les caracteres accentues
function Remove-Accents {
    param([string]$text)

    # Utiliser la normalisation Unicode
    $normalized = $text.Normalize([System.Text.NormalizationForm]::FormD)
    $sb = New-Object System.Text.StringBuilder

    foreach ($char in $normalized.ToCharArray()) {
        $unicodeCategory = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($char)
        if ($unicodeCategory -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($char)
        }
    }

    $result = $sb.ToString().Normalize([System.Text.NormalizationForm]::FormC)

    # Remplacements manuels pour les caracteres speciaux restants
    $result = $result -replace [char]0x0153, 'oe'  # oe ligature
    $result = $result -replace [char]0x0152, 'OE'  # OE ligature
    $result = $result -replace [char]0x00E6, 'ae'  # ae ligature
    $result = $result -replace [char]0x00C6, 'AE'  # AE ligature

    return $result
}

# Charger le JSON
Write-Host "Chargement du fichier JSON..." -ForegroundColor Cyan
$json = Get-Content $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host "Nombre d entrees dans le JSON: $($json.Count)" -ForegroundColor Yellow

# Lister les fichiers PNG existants
$pngFiles = Get-ChildItem -Path $imgPath -Filter "*.png" | Sort-Object Name

Write-Host "Nombre de fichiers PNG: $($pngFiles.Count)" -ForegroundColor Yellow
Write-Host ""

# Parcourir chaque entree JSON (index = numero fichier)
$compteur = 0
foreach ($item in $json) {
    $compteur++

    $nom = $item.nom
    $dept = $item.departement

    if (-not $nom) { continue }

    # Chercher le fichier correspondant (format: XXX_nom.png)
    $pattern = "{0:D3}_*" -f $compteur
    $fichierSource = $pngFiles | Where-Object { $_.Name -like $pattern }

    if (-not $fichierSource) {
        Write-Host "[$compteur] Fichier non trouve pour pattern: $pattern" -ForegroundColor DarkGray
        continue
    }

    # Extraire le numero de departement si commence par 02, 03, etc.
    $numDept = ""
    if ($dept -match "^(\d{2,3})\s*[-:.]?\s*") {
        $numDept = $matches[1]
    }

    # Construire le nouveau nom
    $nomClean = Remove-Accents $nom
    $nomClean = $nomClean -replace '[^a-zA-Z0-9\s\-]', ''
    $nomClean = $nomClean.Trim()

    if ($numDept) {
        $newName = "$numDept - $nomClean.png"
    } else {
        $newName = "$nomClean.png"
    }

    # Afficher et renommer
    $oldName = $fichierSource.Name

    if ($oldName -ne $newName) {
        Write-Host "[$compteur] " -ForegroundColor Cyan -NoNewline
        Write-Host "$oldName" -ForegroundColor Gray -NoNewline
        Write-Host " -> " -ForegroundColor Yellow -NoNewline
        Write-Host "$newName" -ForegroundColor Green

        # Renommer le fichier
        $newPath = Join-Path $imgPath $newName

        # Verifier si le fichier destination existe deja
        if (Test-Path $newPath) {
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($newName)
            $newName = "${baseName}_$compteur.png"
            $newPath = Join-Path $imgPath $newName
            Write-Host "         (doublon, renomme en: $newName)" -ForegroundColor DarkYellow
        }

        Rename-Item -Path $fichierSource.FullName -NewName $newName -ErrorAction SilentlyContinue
    } else {
        Write-Host "[$compteur] $oldName (inchange)" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " RENOMMAGE TERMINE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
