# Extraction des 100 premières MAIRIES du JSON vers CSV
$jsonPath = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\téléphone eMail et autre.json"
$csvPath = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\téléphone eMail et autre.csv"

Write-Host "Chargement du fichier JSON (219 Mo)... Patience..." -ForegroundColor Cyan
$json = Get-Content $jsonPath -Raw | ConvertFrom-Json
Write-Host "Fichier chargé. Nombre total de services: $($json.service.Count)" -ForegroundColor Green

# Extraire les 100 premières MAIRIES uniquement
$results = @()
$count = 0
$max = 1000000

foreach ($service in $json.service) {
    if ($count -ge $max) { break }

    # Filtrer uniquement les mairies (type_service_local = mairie)
    $pivot = $service.pivot | Select-Object -First 1
    if ($pivot.type_service_local -ne "mairie") {
        continue
    }

    # Extraire les données de l'adresse (premier élément du tableau)
    $adresse = $service.adresse | Select-Object -First 1

    $results += [PSCustomObject]@{
        nom_commune        = $adresse.nom_commune
        longitude          = $adresse.longitude
        latitude           = $adresse.latitude
        code_insee_commune = $service.code_insee_commune
        code_postal        = $adresse.code_postal
        telephone          = ($service.telephone | ForEach-Object { $_.valeur }) -join " | "
        adresse_courriel   = ($service.adresse_courriel) -join " | "
        siret              = $service.siret
        nom                = $service.nom
        site_internet      = ($service.site_internet | ForEach-Object { $_.valeur }) -join " | "
        plage_ouverture    = ($service.plage_ouverture | ForEach-Object { "$($_.nom_jour_debut)-$($_.nom_jour_fin): $($_.valeur_heure_debut_1)-$($_.valeur_heure_fin_1)" }) -join " | "
        telecopie          = ($service.telecopie | ForEach-Object { $_.valeur }) -join " | "
        numero_voie        = $adresse.numero_voie
        type_service_local = $pivot.type_service_local
    }

    $count++
    if ($count % 10 -eq 0) {
        Write-Host "Mairies traitées: $count / $max" -ForegroundColor Yellow
    }
}

# Exporter en CSV
$results | Export-Csv -Path $csvPath -Delimiter ";" -Encoding UTF8 -NoTypeInformation

Write-Host "`nExtraction terminée!" -ForegroundColor Green
Write-Host "Fichier généré: $csvPath" -ForegroundColor Cyan
Write-Host "Nombre d'enregistrements: $count" -ForegroundColor Cyan
