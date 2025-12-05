# Script d'extraction des données de population depuis les fichiers INSEE
# Scanne tous les .xlsx du dossier INSEE_Population
# Extrait les onglets "Arrondissement", "Cantons et métropoles" et "Communes"
# Usage: .\extractPopulationINSEE.ps1 [-TestFile "dep01.xlsx"]

param(
    [string]$TestFile = ""  # Fichier unique pour test (ex: "dep01.xlsx")
)

$inputFolder = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\INSEE_Population"
$outputFile = "C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\base de travail\touteLaPopulationFrancaise.csv"

Write-Host "=== EXTRACTION POPULATION INSEE ===" -ForegroundColor Cyan
Write-Host "Source: $inputFolder" -ForegroundColor Gray
Write-Host ""

# Vérifier que le dossier existe
if (-not (Test-Path $inputFolder)) {
    Write-Host "ERREUR: Le dossier $inputFolder n'existe pas!" -ForegroundColor Red
    Write-Host "Exécutez d'abord telechargeFIchierXLSX.ps1 pour télécharger les fichiers." -ForegroundColor Yellow
    exit 1
}

# Lister les fichiers xlsx
if ($TestFile) {
    # Mode test: un seul fichier
    $testPath = Join-Path $inputFolder $TestFile
    if (-not (Test-Path $testPath)) {
        Write-Host "ERREUR: Le fichier $testPath n'existe pas!" -ForegroundColor Red
        exit 1
    }
    $xlsxFiles = @(Get-Item $testPath)
    Write-Host "MODE TEST: Traitement de $TestFile uniquement" -ForegroundColor Yellow
} else {
    # Mode normal: tous les fichiers
    $xlsxFiles = Get-ChildItem -Path $inputFolder -Filter "*.xlsx" | Sort-Object Name
}

$totalFiles = $xlsxFiles.Count

if ($totalFiles -eq 0) {
    Write-Host "ERREUR: Aucun fichier .xlsx trouvé dans $inputFolder" -ForegroundColor Red
    exit 1
}

Write-Host "Fichiers trouvés: $totalFiles" -ForegroundColor Green
Write-Host ""

# Initialiser Excel COM
Write-Host "Initialisation Excel..." -ForegroundColor Yellow
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
}
catch {
    Write-Host "ERREUR: Impossible d'initialiser Excel. Vérifiez qu'Excel est installé." -ForegroundColor Red
    exit 1
}

$allData = @()
$processedFiles = 0
$totalRows = 0
$errors = @()

foreach ($file in $xlsxFiles) {
    $processedFiles++
    Write-Host "[$processedFiles/$totalFiles] $($file.Name)... " -NoNewline

    try {
        # Ouvrir le fichier
        $workbook = $excel.Workbooks.Open($file.FullName)

        # ============================================
        # ETAPE 1: Extraire les noms d'arrondissements
        # ============================================
        $arrondissementMap = @{}
        $sheetArrond = $null
        foreach ($sheet in $workbook.Worksheets) {
            if ($sheet.Name -eq "Arrondissements") {
                $sheetArrond = $sheet
                break
            }
        }

        if ($null -ne $sheetArrond) {
            $headerRow = 8
            $usedRange = $sheetArrond.UsedRange
            $lastRow = $usedRange.Row + $usedRange.Rows.Count - 1

            # Mapping fixe: Col5=Code arrondissement, Col6=Nom de l'arrondissement
            $colCodeArrond = 5
            $colNomArrond = 6

            for ($row = $headerRow + 1; $row -le $lastRow; $row++) {
                $code = $sheetArrond.Cells.Item($row, $colCodeArrond).Text
                $nom = $sheetArrond.Cells.Item($row, $colNomArrond).Text
                if (-not [string]::IsNullOrWhiteSpace($code)) {
                    $arrondissementMap[$code] = $nom
                }
            }
        }

        # ============================================
        # ETAPE 2: Extraire les noms de cantons
        # ============================================
        $cantonMap = @{}
        $sheetCanton = $null
        foreach ($sheet in $workbook.Worksheets) {
            # Comparaison insensible aux accents (le nom peut varier selon l'encodage)
            if ($sheet.Name -like "Cantons et m*tropoles") {
                $sheetCanton = $sheet
                break
            }
        }

        if ($null -ne $sheetCanton) {
            $headerRow = 8
            $usedRange = $sheetCanton.UsedRange
            $lastRow = $usedRange.Row + $usedRange.Rows.Count - 1

            # Mapping fixe: Col4=Code canton, Col5=Nom du canton
            $colCodeCanton = 4
            $colNomCanton = 5

            for ($row = $headerRow + 1; $row -le $lastRow; $row++) {
                $code = $sheetCanton.Cells.Item($row, $colCodeCanton).Text
                $nom = $sheetCanton.Cells.Item($row, $colNomCanton).Text
                if (-not [string]::IsNullOrWhiteSpace($code)) {
                    $cantonMap[$code] = $nom
                }
            }
        }

        # ============================================
        # ETAPE 3: Extraire les communes
        # ============================================
        $sheetCommunes = $null
        foreach ($sheet in $workbook.Worksheets) {
            if ($sheet.Name -eq "Communes") {
                $sheetCommunes = $sheet
                break
            }
        }

        if ($null -eq $sheetCommunes) {
            Write-Host "Onglet 'Communes' non trouvé" -ForegroundColor Yellow
            $errors += "$($file.Name): Onglet 'Communes' non trouvé"
            $workbook.Close($false)
            continue
        }

        # Les colonnes sont dans un ordre fixe dans les fichiers INSEE (ligne 8)
        # Col1=Code région, Col2=Nom région, Col3=Code dept, Col4=Code arrond,
        # Col5=Code canton, Col6=Code commune, Col7=Nom commune,
        # Col8=Pop municipale, Col9=Pop comptée à part, Col10=Pop totale
        $headerRow = 8
        $usedRange = $sheetCommunes.UsedRange
        $lastRow = $usedRange.Row + $usedRange.Rows.Count - 1

        # Mapping fixe basé sur la structure INSEE
        $columnMap = @{
            "Code région" = 1
            "Nom de la région" = 2
            "Code département" = 3
            "Code arrondissement" = 4
            "Code canton" = 5
            "Code commune" = 6
            "Nom de la commune" = 7
            "Population municipale" = 8
            "Population comptée à part" = 9
            "Population totale" = 10
        }

        # Extraire les données (à partir de la ligne 9)
        $rowCount = 0
        for ($row = $headerRow + 1; $row -le $lastRow; $row++) {
            # Vérifier que la ligne contient des données (code commune non vide)
            $codeCommuneOriginal = $sheetCommunes.Cells.Item($row, $columnMap["Code commune"]).Text
            if ([string]::IsNullOrWhiteSpace($codeCommuneOriginal)) {
                continue
            }

            # Récupérer les valeurs
            $codeDept = $sheetCommunes.Cells.Item($row, $columnMap["Code département"]).Text
            $codeArrond = $sheetCommunes.Cells.Item($row, $columnMap["Code arrondissement"]).Text
            $codeCanton = $sheetCommunes.Cells.Item($row, $columnMap["Code canton"]).Text

            # Construire code_commune = Code département + Code commune
            $codeCommune = $codeDept + $codeCommuneOriginal

            # Récupérer les noms depuis les tables de référence
            $nomArrondissement = if ($arrondissementMap.ContainsKey($codeArrond)) { $arrondissementMap[$codeArrond] } else { "" }
            $nomCanton = if ($cantonMap.ContainsKey($codeCanton)) { $cantonMap[$codeCanton] } else { "" }

            # Créer l'objet de données
            $rowData = [ordered]@{
                "code_region" = $sheetCommunes.Cells.Item($row, $columnMap["Code région"]).Text
                "nom_region" = $sheetCommunes.Cells.Item($row, $columnMap["Nom de la région"]).Text
                "code_departement" = $codeDept
                "code_arrondissement" = $codeArrond
                "nom_arrondissement" = $nomArrondissement
                "code_canton" = $codeCanton
                "nom_canton" = $nomCanton
                "code_commune" = $codeCommune
                "nom_commune" = $sheetCommunes.Cells.Item($row, $columnMap["Nom de la commune"]).Text
                "population_totale" = $sheetCommunes.Cells.Item($row, $columnMap["Population totale"]).Text
            }

            $allData += [PSCustomObject]$rowData
            $rowCount++
        }

        $totalRows += $rowCount
        Write-Host "$rowCount communes (Arr: $($arrondissementMap.Count), Canton: $($cantonMap.Count))" -ForegroundColor Green

        $workbook.Close($false)
    }
    catch {
        Write-Host "ERREUR: $($_.Exception.Message)" -ForegroundColor Red
        $errors += "$($file.Name): $($_.Exception.Message)"
    }
}

# Fermer Excel
Write-Host ""
Write-Host "Fermeture Excel..." -ForegroundColor Yellow
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# Exporter en CSV UTF-8 BOM
Write-Host ""
Write-Host "Export CSV..." -ForegroundColor Yellow
# Export CSV avec UTF-8 BOM (compatible toutes versions PowerShell)
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$csvContent = ($allData | ConvertTo-Csv -Delimiter ";" -NoTypeInformation) -join "`r`n"
try {
    [System.IO.File]::WriteAllText($outputFile, $csvContent, $utf8Bom)
} catch {
    Write-Host "ERREUR: Impossible d'écrire le fichier (peut-être ouvert dans Excel?)" -ForegroundColor Red
    Write-Host "Tentative avec un nom alternatif..." -ForegroundColor Yellow
    $altFile = $outputFile -replace "\.csv$", "_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    [System.IO.File]::WriteAllText($altFile, $csvContent, $utf8Bom)
    $outputFile = $altFile
}

# Résumé
Write-Host ""
Write-Host "=== RESUME ===" -ForegroundColor Cyan
Write-Host "Fichiers traités: $processedFiles / $totalFiles" -ForegroundColor Green
Write-Host "Communes extraites: $totalRows" -ForegroundColor Green
Write-Host "Fichier généré: $outputFile" -ForegroundColor Green

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "Erreurs ($($errors.Count)):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

Write-Host ""
Write-Host "Terminé!" -ForegroundColor Green

# Ouvrir le fichier CSV
Start-Process $outputFile
