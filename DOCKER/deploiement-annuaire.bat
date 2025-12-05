@echo off
echo ========================================
echo  Deploiement Annuaire vers VPS
echo ========================================
echo.

powershell -ExecutionPolicy Bypass -Command "cd 'C:\DEV POWERSHELL\DOCKER\www'; Get-ChildItem -Path Annuaire -Recurse -Exclude '*.csv' | Where-Object { -not $_.PSIsContainer } | ForEach-Object { $dest = $_.FullName -replace [regex]::Escape('C:\DEV POWERSHELL\DOCKER\www\'), ''; Write-Host \"Copie: $dest\"; scp $_.FullName \"Qiou17@37.59.123.9:~/projects/annuaire-maires/www/$dest\" }"

echo.
echo ========================================
echo  Deploiement termine
echo ========================================
pause
