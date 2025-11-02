#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Script de compilation de SecureMover GUI en executable standalone
.DESCRIPTION
    Utilise PS2EXE pour compiler le script PowerShell en fichier .exe autonome
    Genere un executable qui peut etre distribue sans installer PowerShell
.NOTES
    Version      : 1.0.0
    Author       : DrSmoke
    Date         : 2025-11-01
    Requirement  : PS2EXE (installe automatiquement si absent)
#>

# Configuration
$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptRoot

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  SecureMover - Compilation Executable" -ForegroundColor Cyan
Write-Host "  Version 2.0.2 - by DrSmoke" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Parametres
$sourceScript = Join-Path $projectRoot "SecureMover-GUI.ps1"
$outputExe = Join-Path $scriptRoot "SecureMover-GUI.exe"
$iconFile = Join-Path $scriptRoot "SecureMover.ico"

# Verification fichier source
if (-not (Test-Path $sourceScript)) {
    Write-Host "[ERREUR] Fichier source introuvable: $sourceScript" -ForegroundColor Red
    exit 1
}

Write-Host "[1/5] Verification du fichier source..." -ForegroundColor Yellow
Write-Host "      Source : $sourceScript" -ForegroundColor Gray
Write-Host "      [OK] Fichier trouve" -ForegroundColor Green
Write-Host ""

# Verification/Installation de PS2EXE
Write-Host "[2/5] Verification de PS2EXE..." -ForegroundColor Yellow

$ps2exeInstalled = Get-Module -ListAvailable -Name ps2exe

if (-not $ps2exeInstalled) {
    Write-Host "      PS2EXE non installe. Installation en cours..." -ForegroundColor Yellow
    try {
        # Configurer PSGallery comme source fiable
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue

        # Installer PS2EXE
        Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
        Write-Host "      [OK] PS2EXE installe avec succes" -ForegroundColor Green
    }
    catch {
        Write-Host "      [ERREUR] Echec installation PS2EXE: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "      Solution manuelle:" -ForegroundColor Yellow
        Write-Host "      1. Ouvrez PowerShell en Administrateur" -ForegroundColor White
        Write-Host "      2. Executez: Install-Module -Name ps2exe -Scope CurrentUser" -ForegroundColor White
        Write-Host "      3. Relancez ce script" -ForegroundColor White
        exit 1
    }
}
else {
    Write-Host "      [OK] PS2EXE deja installe (version $($ps2exeInstalled.Version))" -ForegroundColor Green
}

# Importer le module
Import-Module ps2exe -ErrorAction Stop
Write-Host ""

# Nettoyage ancien exe si present
Write-Host "[3/5] Nettoyage des anciens fichiers..." -ForegroundColor Yellow
if (Test-Path $outputExe) {
    Remove-Item $outputExe -Force
    Write-Host "      [OK] Ancien executable supprime" -ForegroundColor Green
}
else {
    Write-Host "      [OK] Aucun ancien fichier" -ForegroundColor Green
}
Write-Host ""

# Compilation
Write-Host "[4/5] Compilation en cours..." -ForegroundColor Yellow
Write-Host "      Ceci peut prendre 30-60 secondes..." -ForegroundColor Gray
Write-Host ""

try {
    $params = @{
        InputFile = $sourceScript
        OutputFile = $outputExe
        NoConsole = $false  # Garder console pour voir les logs
        NoError = $false
        NoOutput = $false
        RequireAdmin = $true  # Requis pour SecureMover
        Title = "SecureMover v2.0.2 - by DrSmoke"
        Description = "Outil de deplacement de profils utilisateurs Windows"
        Company = "DrSmoke"
        Product = "SecureMover"
        Copyright = "MIT License - DrSmoke 2025"
        Version = "2.0.2.0"
        Verbose = $false
    }

    # Ajouter icone si presente
    if (Test-Path $iconFile) {
        $params.IconFile = $iconFile
        Write-Host "      [INFO] Icone personnalisee detectee et appliquee" -ForegroundColor Cyan
    }

    # Compilation
    Invoke-PS2EXE @params

    Write-Host ""
    Write-Host "      [OK] Compilation terminee avec succes !" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "      [ERREUR] Echec de la compilation: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Verification executable
Write-Host "[5/5] Verification de l'executable..." -ForegroundColor Yellow

if (Test-Path $outputExe) {
    $exeInfo = Get-Item $outputExe
    $exeSizeMB = [math]::Round($exeInfo.Length / 1MB, 2)

    Write-Host "      [OK] Executable cree avec succes !" -ForegroundColor Green
    Write-Host ""
    Write-Host "      Informations:" -ForegroundColor Cyan
    Write-Host "      - Fichier     : $($exeInfo.Name)" -ForegroundColor White
    Write-Host "      - Taille      : $exeSizeMB MB" -ForegroundColor White
    Write-Host "      - Emplacement : $($exeInfo.DirectoryName)" -ForegroundColor White
    Write-Host "      - Date        : $($exeInfo.LastWriteTime)" -ForegroundColor White
}
else {
    Write-Host "      [ERREUR] Executable non trouve apres compilation" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  COMPILATION REUSSIE !" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "L'executable est pret a etre utilise :" -ForegroundColor White
Write-Host "  $outputExe" -ForegroundColor Cyan
Write-Host ""
Write-Host "Distribution :" -ForegroundColor Yellow
Write-Host "  1. Copiez le fichier .exe sur n'importe quel PC Windows" -ForegroundColor White
Write-Host "  2. Double-cliquez pour lancer (admin requis)" -ForegroundColor White
Write-Host "  3. Aucune installation PowerShell necessaire !" -ForegroundColor White
Write-Host ""
Write-Host "Notes :" -ForegroundColor Yellow
Write-Host "  - L'executable contient tout le code necessaire" -ForegroundColor White
Write-Host "  - Privileges administrateur obligatoires" -ForegroundColor White
Write-Host "  - Compatible Windows 10/11" -ForegroundColor White
Write-Host ""

# Proposer de tester
$test = Read-Host "Voulez-vous tester l'executable maintenant ? (O/N)"
if ($test -eq 'O') {
    Write-Host ""
    Write-Host "Lancement de l'executable..." -ForegroundColor Cyan
    Start-Process -FilePath $outputExe -Verb RunAs
}

Write-Host ""
Write-Host "Appuyez sur Entree pour quitter..." -ForegroundColor Gray
Read-Host
