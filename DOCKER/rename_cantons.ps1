# Script pour renommer les fichiers cantons PNG
# Format: numDep_NomDept.png (sans "cantons")

$sourceDir = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\ressources\images\cartesCirconscriptionCantons"
$destDir = "$sourceDir\cantons"

# Créer le dossier destination s'il n'existe pas
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force
}

# Mapping des codes départements vers leurs noms
$departements = @{
    "01" = "Ain"
    "02" = "Aisne"
    "03" = "Allier"
    "04" = "Alpes-de-Haute-Provence"
    "05" = "Hautes-Alpes"
    "06" = "Alpes-Maritimes"
    "07" = "Ardeche"
    "08" = "Ardennes"
    "09" = "Ariege"
    "10" = "Aube"
    "11" = "Aude"
    "12" = "Aveyron"
    "13" = "Bouches-du-Rhone"
    "14" = "Calvados"
    "15" = "Cantal"
    "16" = "Charente"
    "17" = "Charente-Maritime"
    "18" = "Cher"
    "19" = "Correze"
    "21" = "Cote-dOr"
    "22" = "Cotes-dArmor"
    "23" = "Creuse"
    "24" = "Dordogne"
    "25" = "Doubs"
    "26" = "Drome"
    "27" = "Eure"
    "28" = "Eure-et-Loir"
    "29" = "Finistere"
    "2A" = "Corse-du-Sud"
    "2B" = "Haute-Corse"
    "30" = "Gard"
    "31" = "Haute-Garonne"
    "32" = "Gers"
    "33" = "Gironde"
    "34" = "Herault"
    "35" = "Ille-et-Vilaine"
    "36" = "Indre"
    "37" = "Indre-et-Loire"
    "38" = "Isere"
    "39" = "Jura"
    "40" = "Landes"
    "41" = "Loir-et-Cher"
    "42" = "Loire"
    "43" = "Haute-Loire"
    "44" = "Loire-Atlantique"
    "45" = "Loiret"
    "46" = "Lot"
    "47" = "Lot-et-Garonne"
    "48" = "Lozere"
    "49" = "Maine-et-Loire"
    "50" = "Manche"
    "51" = "Marne"
    "52" = "Haute-Marne"
    "53" = "Mayenne"
    "54" = "Meurthe-et-Moselle"
    "55" = "Meuse"
    "56" = "Morbihan"
    "57" = "Moselle"
    "58" = "Nievre"
    "59" = "Nord"
    "60" = "Oise"
    "61" = "Orne"
    "62" = "Pas-de-Calais"
    "63" = "Puy-de-Dome"
    "64" = "Pyrenees-Atlantiques"
    "65" = "Hautes-Pyrenees"
    "66" = "Pyrenees-Orientales"
    "67" = "Bas-Rhin"
    "68" = "Haut-Rhin"
    "69" = "Rhone"
    "70" = "Haute-Saone"
    "71" = "Saone-et-Loire"
    "72" = "Sarthe"
    "73" = "Savoie"
    "74" = "Haute-Savoie"
    "75" = "Paris"
    "76" = "Seine-Maritime"
    "77" = "Seine-et-Marne"
    "78" = "Yvelines"
    "79" = "Deux-Sevres"
    "80" = "Somme"
    "81" = "Tarn"
    "82" = "Tarn-et-Garonne"
    "83" = "Var"
    "84" = "Vaucluse"
    "85" = "Vendee"
    "86" = "Vienne"
    "87" = "Haute-Vienne"
    "88" = "Vosges"
    "89" = "Yonne"
    "90" = "Territoire-de-Belfort"
    "91" = "Essonne"
    "92" = "Hauts-de-Seine"
    "93" = "Seine-Saint-Denis"
    "94" = "Val-de-Marne"
    "95" = "Val-dOise"
    "971" = "Guadeloupe"
    "972" = "Martinique"
    "973" = "Guyane"
    "974" = "Reunion"
    "976" = "Mayotte"
}

# Compteurs
$copied = 0
$errors = 0

# Parcourir les fichiers PNG avec le pattern XX-Cantons-2019.png
Get-ChildItem -Path $sourceDir -Filter "*-Cantons-2019.png" | ForEach-Object {
    $fileName = $_.Name

    # Extraire le code département (2 ou 3 caractères avant le tiret)
    if ($fileName -match "^(\d{1,3}[AB]?)-Cantons") {
        $code = $Matches[1]
        # Ajouter le zéro devant si nécessaire (1 -> 01, etc.)
        if ($code.Length -eq 1) {
            $code = "0$code"
        }

        if ($departements.ContainsKey($code)) {
            $nomDept = $departements[$code]
            $newName = "${code}_${nomDept}.png"
            $destPath = Join-Path $destDir $newName

            Copy-Item -Path $_.FullName -Destination $destPath -Force
            Write-Host "[OK] $fileName -> $newName" -ForegroundColor Green
            $copied++
        } else {
            Write-Host "[WARN] Code inconnu: $code ($fileName)" -ForegroundColor Yellow
            $errors++
        }
    } else {
        Write-Host "[SKIP] Format non reconnu: $fileName" -ForegroundColor Gray
    }
}

Write-Host "`n=== TERMINE ===" -ForegroundColor Cyan
Write-Host "Fichiers copies: $copied" -ForegroundColor Green
Write-Host "Erreurs: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host "Destination: $destDir" -ForegroundColor Cyan
