# Script de correction d'encodage pour SecureMover.ps1
# Remplace les emojis par des equivalents ASCII sûrs

$scriptPath = "$PSScriptRoot\SecureMover.ps1"
$backupPath = "$PSScriptRoot\SecureMover.ps1.backup"

Write-Host "Correction BUG-001 : Encodage emojis" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Backup du fichier original
Write-Host "[1/3] Sauvegarde du fichier original..." -ForegroundColor Yellow
Copy-Item -Path $scriptPath -Destination $backupPath -Force
Write-Host "      Backup cree : $backupPath" -ForegroundColor Green

# Lire le contenu
Write-Host "[2/3] Lecture et correction du contenu..." -ForegroundColor Yellow
$content = Get-Content -Path $scriptPath -Raw -Encoding UTF8

# Remplacer les emojis par des equivalents ASCII
$replacements = @{
    '✅' = '[OK]'
    '❌' = '[ERREUR]'
    '⚠️' = '[!!]'
    'ℹ️' = '[INFO]'
    '⏳' = '[...]'
    '🎉' = '[SUCCES]'
    '📁' = '[DOSSIER]'
    '🔒' = '[SECURITE]'
    '👤' = '[UTILISATEUR]'
    '💻' = '[PC]'
    '➡️' = '->'
    '✔️' = '[V]'
    '✖️' = '[X]'
    '⭐' = '[*]'
    '❤️' = '[<3]'
    '🛡️' = '[PROTECTION]'
    '🔑' = '[CLE]'
    '⚙️' = '[CONFIG]'
    '🏠' = '[ACCUEIL]'
    '💾' = '[SAUVEGARDE]'
    '🔄' = '[RESTAURATION]'
    '🚪' = '[QUITTER]'
    '📋' = '[MENU]'
    '🔍' = '[RECHERCHE]'
    '⏰' = '[TEMPS]'
    '🔐' = '[SECURITE]'
}

foreach ($emoji in $replacements.Keys) {
    $ascii = $replacements[$emoji]
    $content = $content -replace [regex]::Escape($emoji), $ascii
    Write-Host "      Remplacement : $emoji -> $ascii" -ForegroundColor Gray
}

# Sauvegarder avec UTF-8 BOM
Write-Host "[3/3] Sauvegarde du fichier corrige..." -ForegroundColor Yellow
$utf8BOM = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText($scriptPath, $content, $utf8BOM)
Write-Host "      Fichier corrige sauvegarde avec UTF-8 BOM" -ForegroundColor Green

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Correction terminee avec succes !" -ForegroundColor Green
Write-Host "Backup disponible : $backupPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Vous pouvez maintenant lancer SecureMover.ps1" -ForegroundColor Green
