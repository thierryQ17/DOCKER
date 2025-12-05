# Script pour télécharger les cartes de circonscriptions législatives
# URL source : https://france.comersis.com/circonscriptions.php?dpt=XX
# Format fichiers : XX_nom-departement_N.jpg (minuscules)
# Export CSV UTF-8 BOM pour Excel

param(
    [Parameter(ParameterSetName='Single')]
    [string[]]$Departement,

    [Parameter(ParameterSetName='All')]
    [switch]$TousDepartements
)

$ErrorActionPreference = "Stop"

# Dossier de sortie
$outputDir = "c:\DEV POWERSHELL\DOCKER\www\Annuaire\ressources\images\cartesCirconscriptions"
$csvOutput = Join-Path $outputDir "urls_circonscriptions.csv"

# S'assurer que le dossier existe
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Dictionnaire des départements avec leurs noms
$departements = @{
    "01" = "ain"; "02" = "aisne"; "03" = "allier"; "04" = "alpes-de-haute-provence"; "05" = "hautes-alpes"
    "06" = "alpes-maritimes"; "07" = "ardeche"; "08" = "ardennes"; "09" = "ariege"; "10" = "aube"
    "11" = "aude"; "12" = "aveyron"; "13" = "bouches-du-rhone"; "14" = "calvados"; "15" = "cantal"
    "16" = "charente"; "17" = "charente-maritime"; "18" = "cher"; "19" = "correze"; "21" = "cote-dor"
    "22" = "cotes-darmor"; "23" = "creuse"; "24" = "dordogne"; "25" = "doubs"; "26" = "drome"
    "27" = "eure"; "28" = "eure-et-loir"; "29" = "finistere"; "2A" = "corse-du-sud"; "2B" = "haute-corse"
    "30" = "gard"; "31" = "haute-garonne"; "32" = "gers"; "33" = "gironde"; "34" = "herault"
    "35" = "ille-et-vilaine"; "36" = "indre"; "37" = "indre-et-loire"; "38" = "isere"; "39" = "jura"
    "40" = "landes"; "41" = "loir-et-cher"; "42" = "loire"; "43" = "haute-loire"; "44" = "loire-atlantique"
    "45" = "loiret"; "46" = "lot"; "47" = "lot-et-garonne"; "48" = "lozere"; "49" = "maine-et-loire"
    "50" = "manche"; "51" = "marne"; "52" = "haute-marne"; "53" = "mayenne"; "54" = "meurthe-et-moselle"
    "55" = "meuse"; "56" = "morbihan"; "57" = "moselle"; "58" = "nievre"; "59" = "nord"
    "60" = "oise"; "61" = "orne"; "62" = "pas-de-calais"; "63" = "puy-de-dome"; "64" = "pyrenees-atlantiques"
    "65" = "hautes-pyrenees"; "66" = "pyrenees-orientales"; "67" = "bas-rhin"; "68" = "haut-rhin"; "69" = "rhone"
    "70" = "haute-saone"; "71" = "saone-et-loire"; "72" = "sarthe"; "73" = "savoie"; "74" = "haute-savoie"
    "75" = "paris"; "76" = "seine-maritime"; "77" = "seine-et-marne"; "78" = "yvelines"; "79" = "deux-sevres"
    "80" = "somme"; "81" = "tarn"; "82" = "tarn-et-garonne"; "83" = "var"; "84" = "vaucluse"
    "85" = "vendee"; "86" = "vienne"; "87" = "haute-vienne"; "88" = "vosges"; "89" = "yonne"
    "90" = "territoire-de-belfort"; "91" = "essonne"; "92" = "hauts-de-seine"; "93" = "seine-saint-denis"
    "94" = "val-de-marne"; "95" = "val-doise"; "971" = "guadeloupe"; "972" = "martinique"
    "973" = "guyane"; "974" = "reunion"; "976" = "mayotte"
}

# Liste des départements à traiter
if ($TousDepartements) {
    $deptList = $departements.Keys | Sort-Object {
        if ($_ -match '^\d+$') { [int]$_ }
        elseif ($_ -eq '2A') { 200 }
        elseif ($_ -eq '2B') { 201 }
        else { 1000 + [int]($_ -replace '\D', '') }
    }
    Write-Host "Telechargement des cartes pour TOUS les departements ($($deptList.Count))" -ForegroundColor Cyan
} elseif ($Departement) {
    $deptList = $Departement
} else {
    Write-Host "Usage: .\downloadCarteCirconscription.ps1 -Departement 60" -ForegroundColor Yellow
    Write-Host "       .\downloadCarteCirconscription.ps1 -Departement @('60','80','04')" -ForegroundColor Yellow
    Write-Host "       .\downloadCarteCirconscription.ps1 -TousDepartements" -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TELECHARGEMENT CARTES CIRCONSCRIPTIONS" -ForegroundColor Cyan
Write-Host "  URL: circonscriptions.php" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Dossier de sortie: $outputDir" -ForegroundColor Gray
Write-Host ""

# Tableau pour stocker les URLs pour le CSV
$csvData = @()

# Traiter chaque département
foreach ($numDept in $deptList) {
    $numDept = $numDept.ToString().PadLeft(2, '0')

    # Récupérer le nom du département depuis le dictionnaire
    $nomDept = if ($departements.ContainsKey($numDept)) {
        $departements[$numDept]
    } else {
        "dept"
    }

    Write-Host "=== Departement $numDept ($nomDept) ===" -ForegroundColor Yellow

    try {
        # Étape 1: Récupérer la page HTML
        Write-Host "  [1/3] Recuperation de la page HTML..."
        $url = "https://france.comersis.com/circonscriptions.php?dpt=$numDept"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
        $html = $response.Content

        # Stocker l'URL de la page pour le CSV
        $csvData += [PSCustomObject]@{
            CodeDepartement = $numDept
            NomDepartement = $nomDept
            UrlPage = $url
            NbCirconscriptions = 0
            ImagesTelechargees = ""
        }

        # Étape 2: Chercher l'image globale "circonscriptions-de(s)-XXX.jpg" dans le DOM
        # Patterns possibles:
        #   - circonscriptions-de-l-Oise.jpg
        #   - circonscriptions-de-la-Somme.jpg
        #   - circonscriptions-des-Alpes-de-Haute-Provence.jpg
        #   - circonscriptions-des-Bouches-du-Rhone.jpg
        $imageUrl = ""
        $imageSrc = ""

        if ($html -match 'src="(map/circonscription/circonscriptions-d[^"]+\.jpg)"') {
            $imageSrc = $matches[1]
            $imageUrl = "https://france.comersis.com/$imageSrc"
            Write-Host "  [2/2] Image trouvee: $imageSrc" -ForegroundColor Green
        } else {
            Write-Host "  ATTENTION: Image circonscriptions-d*.jpg non trouvee" -ForegroundColor Red
            continue
        }

        # Étape 3: Télécharger l'image globale du département
        Write-Host "  [3/3] Telechargement de l'image..."
        $imagesTelechargees = @()
        $fileName = "${numDept}_${nomDept}.jpg"
        $filePath = Join-Path $outputDir $fileName

        try {
            $imageResponse = Invoke-WebRequest -Uri $imageUrl -UseBasicParsing -TimeoutSec 30
            [System.IO.File]::WriteAllBytes($filePath, $imageResponse.Content)
            $fileSize = [math]::Round((Get-Item $filePath).Length / 1KB, 1)
            Write-Host "        - $fileName ($fileSize KB)" -ForegroundColor Gray
            $imagesTelechargees += $fileName
        } catch {
            Write-Host "        - ERREUR: $fileName - $($_.Exception.Message)" -ForegroundColor Red
        }

        Write-Host "        => $($imagesTelechargees.Count) image(s) telechargee(s)" -ForegroundColor Green

        # Mettre à jour les données CSV
        $csvData[-1].NbCirconscriptions = 1
        $csvData[-1].ImagesTelechargees = ($imagesTelechargees -join "|")
        $csvData[-1] | Add-Member -NotePropertyName "UrlImage" -NotePropertyValue $imageUrl -Force

    } catch {
        Write-Host "  ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host ""
    # Petite pause pour ne pas surcharger le serveur
    Start-Sleep -Milliseconds 500
}

# Écrire le fichier CSV avec BOM UTF-8 pour Excel
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GENERATION DU FICHIER CSV" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Créer le contenu CSV avec BOM UTF-8
$csvContent = $csvData | ConvertTo-Csv -Delimiter ";" -NoTypeInformation

# Écrire avec BOM UTF-8
$utf8BOM = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllLines($csvOutput, $csvContent, $utf8BOM)

Write-Host "Fichier CSV genere: $csvOutput" -ForegroundColor Green
Write-Host "Encodage: UTF-8 avec BOM (compatible Excel)" -ForegroundColor Gray
Write-Host ""

# Résumé final
$totalImages = ($csvData | Measure-Object -Property NbCirconscriptions -Sum).Sum
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RESUME" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Departements traites: $($csvData.Count)" -ForegroundColor Green
Write-Host "Total images telechargees: $totalImages" -ForegroundColor Green
Write-Host "Fichier CSV: $csvOutput" -ForegroundColor Green
Write-Host ""
