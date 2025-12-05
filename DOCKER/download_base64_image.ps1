# Script PowerShell pour extraire et sauvegarder les photos des responsables UPR
# Les images sont nommées avec le nom de la personne
# Usage: .\download_base64_image.ps1

param(
    [string]$Url = "https://www.upr.fr/responsables",
    [string]$OutputFolder = ".\images_upr"
)

# Creer le dossier de sortie
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
}

Write-Host "Telechargement de la page: $Url" -ForegroundColor Cyan

try {
    # Telecharger le contenu HTML
    $response = Invoke-WebRequest -Uri $Url -UseBasicParsing
    $html = $response.Content

    # Pattern pour trouver les blocs avec nom + image base64
    # Structure: <div class="b">NOM PRENOM</div> ... <img class="f" src="data:image/...">
    $pattern = '<div class="b">([^<]+)</div>.*?<img class="f" src="data:image/(webp|png|jpg|jpeg|gif);base64,([A-Za-z0-9+/=]+)"'

    $matches = [regex]::Matches($html, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if ($matches.Count -eq 0) {
        Write-Host "Aucune image avec nom trouvee. Essai avec pattern alternatif..." -ForegroundColor Yellow

        # Pattern alternatif: chercher dans les blocs responsablesv4-bloc
        $pattern2 = 'class="responsablesv4-bloc[^"]*"[^>]*>.*?<div class="b">([^<]+)</div>.*?<img[^>]+src="data:image/(webp|png|jpg|jpeg|gif);base64,([A-Za-z0-9+/=]+)"'
        $matches = [regex]::Matches($html, $pattern2, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    }

    if ($matches.Count -eq 0) {
        Write-Host "Toujours aucune correspondance. Tentative de parsing manuel..." -ForegroundColor Yellow

        # Extraire tous les noms (div class="b")
        $namesPattern = '<div class="b">([^<]+)</div>'
        $namesMatches = [regex]::Matches($html, $namesPattern)

        # Extraire toutes les images base64 (img class="f")
        $imagesPattern = '<img class="f"[^>]+src="data:image/(webp|png|jpg|jpeg|gif);base64,([A-Za-z0-9+/=]+)"'
        $imagesMatches = [regex]::Matches($html, $imagesPattern)

        Write-Host "Noms trouves: $($namesMatches.Count)" -ForegroundColor Cyan
        Write-Host "Images trouvees: $($imagesMatches.Count)" -ForegroundColor Cyan

        $count = [Math]::Min($namesMatches.Count, $imagesMatches.Count)

        if ($count -eq 0) {
            Write-Host "Aucune donnee trouvee." -ForegroundColor Red
            exit
        }

        Write-Host "Association de $count nom(s) avec image(s)..." -ForegroundColor Green

        for ($i = 0; $i -lt $count; $i++) {
            $name = $namesMatches[$i].Groups[1].Value.Trim()
            $format = $imagesMatches[$i].Groups[1].Value
            $base64Data = $imagesMatches[$i].Groups[2].Value

            # Nettoyer le nom pour le fichier
            $cleanName = $name -replace '[\\/:*?"<>|]', '_'
            $cleanName = $cleanName -replace '\s+', '_'

            # Extension
            $extension = switch ($format) {
                "webp" { "webp" }
                "png" { "png" }
                "jpg" { "jpg" }
                "jpeg" { "jpg" }
                "gif" { "gif" }
                default { "png" }
            }

            $filename = "$OutputFolder\$cleanName.$extension"

            try {
                $bytes = [Convert]::FromBase64String($base64Data)
                [System.IO.File]::WriteAllBytes($filename, $bytes)

                $size = [math]::Round($bytes.Length / 1024, 2)
                Write-Host "  [$($i+1)] $name -> $cleanName.$extension ($size Ko)" -ForegroundColor Green
            }
            catch {
                Write-Host "  [$($i+1)] Erreur pour $name : $_" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "Trouve $($matches.Count) personne(s) avec photo" -ForegroundColor Green

        $count = 0
        foreach ($match in $matches) {
            $count++
            $name = $match.Groups[1].Value.Trim()
            $format = $match.Groups[2].Value
            $base64Data = $match.Groups[3].Value

            # Nettoyer le nom pour le fichier
            $cleanName = $name -replace '[\\/:*?"<>|]', '_'
            $cleanName = $cleanName -replace '\s+', '_'

            # Extension
            $extension = switch ($format) {
                "webp" { "webp" }
                "png" { "png" }
                "jpg" { "jpg" }
                "jpeg" { "jpg" }
                "gif" { "gif" }
                default { "png" }
            }

            $filename = "$OutputFolder\$cleanName.$extension"

            try {
                $bytes = [Convert]::FromBase64String($base64Data)
                [System.IO.File]::WriteAllBytes($filename, $bytes)

                $size = [math]::Round($bytes.Length / 1024, 2)
                Write-Host "  [$count] $name -> $cleanName.$extension ($size Ko)" -ForegroundColor Green
            }
            catch {
                Write-Host "  [$count] Erreur pour $name : $_" -ForegroundColor Red
            }
        }
    }

    Write-Host "`nTermine! Images sauvegardees dans: $OutputFolder" -ForegroundColor Cyan

    # Compter les fichiers
    $files = Get-ChildItem $OutputFolder -File
    Write-Host "Total: $($files.Count) fichier(s)" -ForegroundColor Green

    # Ouvrir le dossier
    Start-Process explorer.exe $OutputFolder
}
catch {
    Write-Host "Erreur: $_" -ForegroundColor Red
}
