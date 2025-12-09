# Script de renommage des images PNG
# Format: Prenom.NOM.png ou XX_Prenom.NOM.png

$imgPath = "C:\DEV POWERSHELL\!!!Q17\DOCKER\www\Annuaire\ressources\images\responsablesUPR"

# Lister les images PNG
$images = Get-ChildItem -Path $imgPath -Filter "*.png"

Write-Host "Renommage des images..." -ForegroundColor Cyan
Write-Host "Nombre d images: $($images.Count)" -ForegroundColor Yellow
Write-Host ""

foreach ($img in $images) {
    $oldName = $img.Name
    $newName = $oldName

    # Verifier si commence par un numero de departement (XX - ou XXX - )
    if ($oldName -match '^(\d{2,3})\s*-\s*(.+)\.png$') {
        $numDept = $matches[1]
        $nomPartie = $matches[2]

        # Remplacer espaces par points, sauf entre mots du nom de famille (garder tirets)
        # Separer prenom et nom
        $parts = $nomPartie -split '\s+'
        $newNomPartie = $parts -join '.'

        # Remplacer les espaces dans les noms composes par des tirets
        # Ex: "DE VISMES" -> "DE-VISMES"
        # On garde les points entre prenom et nom

        $newName = "${numDept}_${newNomPartie}.png"
    } else {
        # Pas de numero, juste le nom
        # Ex: "Dimitri DE VISMES.png" -> "Dimitri.DE-VISMES.png"
        if ($oldName -match '^(.+)\.png$') {
            $nomPartie = $matches[1]
            $parts = $nomPartie -split '\s+'
            $newNomPartie = $parts -join '.'
            $newName = "${newNomPartie}.png"
        }
    }

    # Afficher et renommer si different
    if ($oldName -ne $newName) {
        Write-Host "$oldName" -ForegroundColor Gray -NoNewline
        Write-Host " -> " -ForegroundColor Yellow -NoNewline
        Write-Host "$newName" -ForegroundColor Green

        $newPath = Join-Path $imgPath $newName

        # Verifier doublon
        if (Test-Path $newPath) {
            Write-Host "  [!] Doublon detecte, ajout suffix" -ForegroundColor DarkYellow
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($newName)
            $newName = "${baseName}_dup.png"
            $newPath = Join-Path $imgPath $newName
        }

        Rename-Item -Path $img.FullName -NewName $newName -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "Renommage termine!" -ForegroundColor Green
