<#
.SYNOPSIS
    Extrait les circonscriptions legislatives depuis le Wiki OSM

.DESCRIPTION
    - Scanne la page https://wiki.openstreetmap.org/wiki/FR:Circonscriptions_legislatives_en_France
    - Extrait les colonnes Circonscription et Relation (une ligne par circonscription)
    - Calcule le nom du departement
    - Genere l'URL OpenStreetMap pour chaque relation
    - Exporte en CSV UTF-8 BOM compatible Excel

.NOTES
    =====================================================================
    URL OVERPASS TURBO - DOCUMENTATION
    =====================================================================

    Chaque ligne du CSV contient une URL Overpass Turbo qui affiche
    TOUTES les circonscriptions du departement concerne.

    Format de l'URL :
    https://overpass-turbo.eu/?Q=[out:json];(relation(ID1);relation(ID2);...;);out body geom;&R

    Structure de la requete :
    - [out:json]                         : Format de sortie JSON
    - (relation(ID1);relation(ID2);...;) : Liste des relations OSM du dept
    - out body geom;                     : Retourne le corps et la geometrie
    - &R                                 : Execute automatiquement la requete

    Exemple pour l'Ain (5 circonscriptions) :
    https://overpass-turbo.eu/?Q=[out:json];(relation(2187468);relation(2186337);relation(2186338);relation(2187249);relation(2186340););out body geom;&R
    =====================================================================

.EXAMPLE
    .\extract_circonscriptions_osm.ps1
    .\extract_circonscriptions_osm.ps1 -OutputPath "C:\data\circos.csv"
#>

param(
    [string]$OutputPath = ".\circonscriptions_osm.csv"
)

# Mapping des codes departement vers les noms
$departements = @{
    "001" = "Ain"; "002" = "Aisne"; "003" = "Allier"; "004" = "Alpes-de-Haute-Provence"
    "005" = "Hautes-Alpes"; "006" = "Alpes-Maritimes"; "007" = "Ardeche"; "008" = "Ardennes"
    "009" = "Ariege"; "010" = "Aube"; "011" = "Aude"; "012" = "Aveyron"
    "013" = "Bouches-du-Rhone"; "014" = "Calvados"; "015" = "Cantal"; "016" = "Charente"
    "017" = "Charente-Maritime"; "018" = "Cher"; "019" = "Correze"
    "02A" = "Corse-du-Sud"; "02B" = "Haute-Corse"
    "021" = "Cote-d'Or"; "022" = "Cotes-d'Armor"; "023" = "Creuse"; "024" = "Dordogne"
    "025" = "Doubs"; "026" = "Drome"; "027" = "Eure"; "028" = "Eure-et-Loir"
    "029" = "Finistere"; "030" = "Gard"; "031" = "Haute-Garonne"; "032" = "Gers"
    "033" = "Gironde"; "034" = "Herault"; "035" = "Ille-et-Vilaine"; "036" = "Indre"
    "037" = "Indre-et-Loire"; "038" = "Isere"; "039" = "Jura"; "040" = "Landes"
    "041" = "Loir-et-Cher"; "042" = "Loire"; "043" = "Haute-Loire"; "044" = "Loire-Atlantique"
    "045" = "Loiret"; "046" = "Lot"; "047" = "Lot-et-Garonne"; "048" = "Lozere"
    "049" = "Maine-et-Loire"; "050" = "Manche"; "051" = "Marne"; "052" = "Haute-Marne"
    "053" = "Mayenne"; "054" = "Meurthe-et-Moselle"; "055" = "Meuse"; "056" = "Morbihan"
    "057" = "Moselle"; "058" = "Nievre"; "059" = "Nord"; "060" = "Oise"
    "061" = "Orne"; "062" = "Pas-de-Calais"; "063" = "Puy-de-Dome"; "064" = "Pyrenees-Atlantiques"
    "065" = "Hautes-Pyrenees"; "066" = "Pyrenees-Orientales"; "067" = "Bas-Rhin"; "068" = "Haut-Rhin"
    "069" = "Rhone"; "070" = "Haute-Saone"; "071" = "Saone-et-Loire"; "072" = "Sarthe"
    "073" = "Savoie"; "074" = "Haute-Savoie"; "075" = "Paris"; "076" = "Seine-Maritime"
    "077" = "Seine-et-Marne"; "078" = "Yvelines"; "079" = "Deux-Sevres"; "080" = "Somme"
    "081" = "Tarn"; "082" = "Tarn-et-Garonne"; "083" = "Var"; "084" = "Vaucluse"
    "085" = "Vendee"; "086" = "Vienne"; "087" = "Haute-Vienne"; "088" = "Vosges"
    "089" = "Yonne"; "090" = "Territoire de Belfort"; "091" = "Essonne"; "092" = "Hauts-de-Seine"
    "093" = "Seine-Saint-Denis"; "094" = "Val-de-Marne"; "095" = "Val-d'Oise"
    "971" = "Guadeloupe"; "972" = "Martinique"; "973" = "Guyane"; "974" = "La Reunion"
    "975" = "Saint-Pierre-et-Miquelon"; "976" = "Mayotte"
    "977" = "Saint-Barthelemy"; "986" = "Wallis-et-Futuna"
    "987" = "Polynesie francaise"; "988" = "Nouvelle-Caledonie"
}

Write-Host "=== Extraction des circonscriptions OSM ===" -ForegroundColor Cyan
Write-Host ""

# URL de la page Wiki
$url = "https://wiki.openstreetmap.org/wiki/FR:Circonscriptions_l%C3%A9gislatives_en_France"

Write-Host "Telechargement de la page Wiki OSM..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 60
    $html = $response.Content
    Write-Host "Page telechargee avec succes ($($html.Length) caracteres)" -ForegroundColor Green
} catch {
    Write-Host "Erreur lors du telechargement: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Extraction des donnees du tableau..." -ForegroundColor Yellow

# Pattern pour extraire : <td>XXX-XX</td> suivi de sortkey avec le numero de relation
$rowPattern = '<tr>\s*<td>(\d{2,3}[AB]?-\d{2})\s*</td>\s*<td><span class="plainlinks"><bdi class="sortkey"[^>]*>(\d+)</bdi>'
$regexMatches = [regex]::Matches($html, $rowPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

Write-Host "Circonscriptions trouvees: $($regexMatches.Count)" -ForegroundColor Cyan

if ($regexMatches.Count -eq 0) {
    Write-Host "Aucune circonscription trouvee!" -ForegroundColor Red
    exit 1
}

# Construire la liste des circonscriptions
$circonscriptions = @()

foreach ($match in $regexMatches) {
    $circoCode = $match.Groups[1].Value.Trim()
    $relationId = $match.Groups[2].Value.Trim()

    # Extraire le code departement (partie avant le tiret)
    if ($circoCode -match '^(\d{2}[AB]|\d{3})-') {
        $deptCode = $Matches[1]
    } elseif ($circoCode -match '^(\d{2})-') {
        $deptCode = "0" + $Matches[1]
    } else {
        continue
    }

    $circonscriptions += [PSCustomObject]@{
        CircoCode = $circoCode
        RelationId = $relationId
        CodeDept = $deptCode
    }
}

# Compter les circonscriptions et regrouper les relations par departement
$deptCounts = @{}
$deptRelations = @{}
foreach ($circo in $circonscriptions) {
    if (-not $deptCounts.ContainsKey($circo.CodeDept)) {
        $deptCounts[$circo.CodeDept] = 0
        $deptRelations[$circo.CodeDept] = @()
    }
    $deptCounts[$circo.CodeDept]++
    $deptRelations[$circo.CodeDept] += $circo.RelationId
}

# Construire les URLs Overpass Turbo par departement
$deptOverpassUrls = @{}
foreach ($deptCode in $deptRelations.Keys) {
    $relationsStr = ($deptRelations[$deptCode] | ForEach-Object { "relation($_);" }) -join ""
    $deptOverpassUrls[$deptCode] = "https://overpass-turbo.eu/?Q=[out:json];($relationsStr);out body geom;&R"
}

# Construire le resultat final (une ligne par circonscription)
$results = @()

foreach ($circo in $circonscriptions) {
    $deptCode = $circo.CodeDept

    # Nom du departement
    $deptName = $departements[$deptCode]
    if (-not $deptName) {
        $deptName = "Departement $deptCode"
    }

    # Nombre de circonscriptions dans ce departement
    $nbCircos = $deptCounts[$deptCode]

    # URL OpenStreetMap (pour cette circonscription)
    $urlOSM = "https://www.openstreetmap.org/relation/$($circo.RelationId)"

    # URL Overpass Turbo (toutes les circos du departement)
    $urlOverpass = $deptOverpassUrls[$deptCode]

    $results += [PSCustomObject]@{
        CodeDepartement = $deptCode
        NomDepartement = $deptName
        NbCirconscriptions = $nbCircos
        Circonscription = $circo.CircoCode
        RelationOSM = $circo.RelationId
        UrlOpenStreetMap = $urlOSM
        UrlOverpassTurbo = $urlOverpass
    }
}

# Trier par code departement puis par circonscription
$results = $results | Sort-Object CodeDepartement, Circonscription

Write-Host ""
Write-Host "Resultats:" -ForegroundColor Green
Write-Host "  - Circonscriptions: $($results.Count)" -ForegroundColor Gray
Write-Host "  - Departements: $($deptCounts.Count)" -ForegroundColor Gray

# Export CSV avec BOM UTF-8 pour Excel
Write-Host ""
Write-Host "Export CSV..." -ForegroundColor Yellow

$csvPath = $OutputPath
if (-not [System.IO.Path]::IsPathRooted($csvPath)) {
    $csvPath = Join-Path $PSScriptRoot $OutputPath
}

# Ecrire avec BOM UTF-8
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$csvContent = $results | ConvertTo-Csv -NoTypeInformation -Delimiter ";"
[System.IO.File]::WriteAllLines($csvPath, $csvContent, $utf8Bom)

Write-Host "Fichier CSV cree: $csvPath" -ForegroundColor Green

# Afficher quelques exemples
Write-Host ""
Write-Host "=== Exemples (10 premieres lignes) ===" -ForegroundColor Cyan
$results | Select-Object -First 10 | Format-Table -AutoSize

Write-Host ""
Write-Host "=== Termine ===" -ForegroundColor Green
