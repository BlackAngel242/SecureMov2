<#
.SYNOPSIS
    SecureMover v2.0 - Déplace les dossiers utilisateur Windows vers une autre partition.

.DESCRIPTION
    Ce script guide l'utilisateur pour déplacer, restaurer ou sauvegarder ses dossiers personnels
    de manière sécurisée. Il vérifie les droits admin, demande confirmation, déplace les
    fichiers et met à jour le Registre Windows.

.PARAMETER NoExit
    Empêche la fermeture automatique du script à la fin.

.AUTHOR
    DrSmoke "un mbokatier bien engagé" & Assistant IA
#>

param(
    [switch]$NoExit
)

# -----------------------------------------------------------------------------------
# --- CONFIGURATION UTF-8 AVEC BOM POUR CURSOR PRO
# -----------------------------------------------------------------------------------

# Configuration UTF-8 avec BOM pour Cursor Pro
$OutputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()

# Configuration spécifique pour PowerShell et Cursor Pro
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $PSDefaultParameterValues['*:Encoding'] = 'utf8BOM'
}

# Forcer l'encodage des caractères spéciaux français
chcp 65001 | Out-Null

# Configuration spéciale pour Cursor Pro et encodage français
if ($env:TERM_PROGRAM -eq "vscode" -or $PSVersionTable.PSEdition -eq "Core") {
    # Configuration UTF-8 avec BOM pour Cursor Pro
    $OutputEncoding = [System.Text.UTF8Encoding]::new()
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
    [Console]::InputEncoding = [System.Text.UTF8Encoding]::new()

    # Correction des caractères français
    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8BOM'
    $PSDefaultParameterValues['Set-Content:Encoding'] = 'utf8BOM'

    # Configuration de la console pour les émojis
    if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        try {
            [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
            # Force l'utilisation d'UTF-8 pour les caractères spéciaux
            cmd /c "chcp 65001 >nul 2>&1"
        } catch {
            Write-Warning "Impossible de configurer l'encodage UTF-8"
        }
    }
}

# -----------------------------------------------------------------------------------
# --- GESTION INTELLIGENTE DE L'ENVIRONNEMENT D'EXÉCUTION
# -----------------------------------------------------------------------------------

# Variable globale pour les icônes
$script:icons = @{}

# Fonction pour détecter et configurer l'environnement d'exécution
function Initialize-ExecutionEnvironment {
    # CAS A : Windows Terminal détecté
    if ($env:WT_SESSION) {
        Write-Host "[OK] Windows Terminal detecte - Mode visuel complet active" -ForegroundColor Green

        # Configuration des icônes pour Windows Terminal
        $script:icons = @{
            ok = '[OK]'
            error = '[ERREUR]'
            warn = '[!!]'
            info = '[INFO]'
            loading = '[...]'
            success = '[SUCCES]'
            folder = '[DOSSIER]'
            lock = '[SECURITE]'
            user = '[UTILISATEUR]'
            computer = '[PC]'
            arrow = '->'
            check = '[V]'
            cross = '[X]'
            star = '[*]'
            heart = '[<3]'
            shield = '[PROTECTION]'
            key = '[CLE]'
            gear = '[CONFIG]'
            home = '[ACCUEIL]'
            backup = '[SAUVEGARDE]'
            restore = '[RESTAURATION]'
            quit = '[QUITTER]'
            menu = '[MENU]'
            search = '[RECHERCHE]'
            time = '[TEMPS]'
            security = '[SECURITE]'
        }

        Write-Host "[INFO] Icones configurees pour une experience visuelle optimale" -ForegroundColor Green
        return $true
    }

    # CAS B : Console basique détectée
    else {
        Write-Host "[!!] Console basique detectee - Affichage simplifie" -ForegroundColor Yellow

        # Configuration des icônes ASCII pour console basique
        $script:icons = @{
            ok = '[OK]'
            error = '[ERREUR]'
            warn = '[!!]'
            info = '[INFO]'
            loading = '[...]'
            success = '[SUCCES]'
            folder = '[DOSSIER]'
            lock = '[SECURITE]'
            user = '[UTILISATEUR]'
            computer = '[PC]'
            arrow = '->'
            check = '[V]'
            cross = '[X]'
            star = '[*]'
            heart = '[<3]'
            shield = '[PROTECTION]'
            key = '[CLE]'
            gear = '[CONFIG]'
            home = '[ACCUEIL]'
            backup = '[SAUVEGARDE]'
            restore = '[RESTAURATION]'
            quit = '[QUITTER]'
            menu = '[MENU]'
            search = '[RECHERCHE]'
            time = '[TEMPS]'
            security = '[SECURITE]'
        }

        Write-Host "[INFO] Icones ASCII configurees pour la compatibilite console" -ForegroundColor Green
        return $false
    }
}

# Initialisation de l'environnement d'exécution
$isModernTerminal = Initialize-ExecutionEnvironment

# -----------------------------------------------------------------------------------
# --- CONTRÔLE DE LA TAILLE DE FENÊTRE POUR SECUREMOVER V2.0
# -----------------------------------------------------------------------------------

# Configuration de la fenêtre console fixe
function Set-ConsoleWindowSize {
    param(
        [int]$Width = 80,
        [int]$Height = 40,
        [string]$Title = "SecureMover v2.0 - Deplacement Securise de Profils"
    )

    try {
        # Configuration pour PowerShell classique (Windows PowerShell)
        if ($PSVersionTable.PSVersion.Major -le 5) {
            # Définir la taille du buffer et de la fenêtre
            $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size($Width, 1000)
            $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($Width, $Height)

            # Définir le titre
            $host.UI.RawUI.WindowTitle = $Title

            # Désactiver le redimensionnement (méthode Windows API)
            Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class WindowAPI {
                    [DllImport("kernel32.dll")]
                    public static extern IntPtr GetConsoleWindow();

                    [DllImport("user32.dll")]
                    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter,
                                                         int X, int Y, int cx, int cy, uint uFlags);

                    [DllImport("user32.dll")]
                    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

                    [DllImport("user32.dll")]
                    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

                    public const int GWL_STYLE = -16;
                    public const int WS_THICKFRAME = 0x00040000;
                    public const int WS_MAXIMIZEBOX = 0x00010000;
                    public const int SWP_NOMOVE = 0x0002;
                    public const int SWP_NOSIZE = 0x0001;
                    public const int SWP_NOZORDER = 0x0004;
                    public const int SWP_FRAMECHANGED = 0x0020;
                }
"@

            # Obtenir le handle de la fenêtre console
            $consoleHandle = [WindowAPI]::GetConsoleWindow()

            # Obtenir le style actuel de la fenêtre
            $currentStyle = [WindowAPI]::GetWindowLong($consoleHandle, [WindowAPI]::GWL_STYLE)

            # Supprimer les styles qui permettent le redimensionnement
            $newStyle = $currentStyle -band (-bnot [WindowAPI]::WS_THICKFRAME) -band (-bnot [WindowAPI]::WS_MAXIMIZEBOX)

            # Appliquer le nouveau style
            [WindowAPI]::SetWindowLong($consoleHandle, [WindowAPI]::GWL_STYLE, $newStyle) | Out-Null

            # Forcer la mise à jour de la fenêtre
            [WindowAPI]::SetWindowPos($consoleHandle, [IntPtr]::Zero, 0, 0, 0, 0,
                                    [WindowAPI]::SWP_NOMOVE -bor [WindowAPI]::SWP_NOSIZE -bor
                                    [WindowAPI]::SWP_NOZORDER -bor [WindowAPI]::SWP_FRAMECHANGED) | Out-Null
        }

        # Configuration pour PowerShell Core (7+) et terminaux modernes
        else {
            # Pour PowerShell Core, utiliser les séquences d'échappement ANSI si supportées
            if ($env:TERM -or $env:WT_SESSION) {
                # Terminal Windows ou autres terminaux modernes
                Write-Host "`e]0;$Title`e\" -NoNewline

                # Essayer de définir la taille via les séquences d'échappement
                Write-Host "`e[8;$Height;${Width}t" -NoNewline
            }

            # Définir le titre via la variable d'environnement
            $env:TITLE = $Title
        }

        Write-Host "[OK] Fenetre configuree : ${Width}x${Height} (non-redimensionnable)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Warning "[WARN] Impossible de fixer la taille de la fenetre : $($_.Exception.Message)"
        Write-Host "[TIP] La fenetre restera redimensionnable." -ForegroundColor Yellow
        return $false
    }
}

# Fonction pour centrer la fenêtre sur l'écran
function Set-ConsoleWindowPosition {
    try {
        if ($PSVersionTable.PSVersion.Major -le 5) {
            Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class ScreenAPI {
                    [DllImport("user32.dll")]
                    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

                    [DllImport("user32.dll")]
                    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter,
                                                         int X, int Y, int cx, int cy, uint uFlags);

                    [DllImport("user32.dll")]
                    public static extern int GetSystemMetrics(int nIndex);

                    [DllImport("kernel32.dll")]
                    public static extern IntPtr GetConsoleWindow();

                    public struct RECT {
                        public int Left, Top, Right, Bottom;
                    }

                    public const int SM_CXSCREEN = 0;
                    public const int SM_CYSCREEN = 1;
                    public const uint SWP_NOZORDER = 0x0004;
                    public const uint SWP_NOSIZE = 0x0001;
                }
"@

            $consoleHandle = [ScreenAPI]::GetConsoleWindow()
            $rect = New-Object ScreenAPI+RECT

            if ([ScreenAPI]::GetWindowRect($consoleHandle, [ref]$rect)) {
                $windowWidth = $rect.Right - $rect.Left
                $windowHeight = $rect.Bottom - $rect.Top

                $screenWidth = [ScreenAPI]::GetSystemMetrics([ScreenAPI]::SM_CXSCREEN)
                $screenHeight = [ScreenAPI]::GetSystemMetrics([ScreenAPI]::SM_CYSCREEN)

                $x = ($screenWidth - $windowWidth) / 2
                $y = ($screenHeight - $windowHeight) / 2

                [ScreenAPI]::SetWindowPos($consoleHandle, [IntPtr]::Zero, $x, $y, 0, 0,
                                        [ScreenAPI]::SWP_NOZORDER -bor [ScreenAPI]::SWP_NOSIZE) | Out-Null

                Write-Host "[OK] Fenetre centree sur l'ecran" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Warning "[WARN] Impossible de centrer la fenetre : $($_.Exception.Message)"
    }
}

# Fonction pour vérifier si la taille de fenêtre est appropriée
function Test-WindowDimensions {
    param(
        [int]$RequiredWidth = 80,
        [int]$RequiredHeight = 40
    )

    try {
        if ($PSVersionTable.PSVersion.Major -le 5) {
            $currentWidth = $host.UI.RawUI.WindowSize.Width
            $currentHeight = $host.UI.RawUI.WindowSize.Height

            if ($currentWidth -lt $RequiredWidth -or $currentHeight -lt $RequiredHeight) {
                Write-Warning "[WARN] Taille de fenetre insuffisante detectee :"
                Write-Host "   Actuelle : ${currentWidth}x${currentHeight}" -ForegroundColor Red
                Write-Host "   Requise  : ${RequiredWidth}x${RequiredHeight}" -ForegroundColor Green
                Write-Host "[TIP] Tentative d'ajustement automatique..." -ForegroundColor Yellow

                return $false
            }

            Write-Host "[OK] Taille de fenetre appropriee : ${currentWidth}x${currentHeight}" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "[INFO] Verification de taille non disponible pour PowerShell Core" -ForegroundColor Cyan
            return $true
        }
    }
    catch {
        Write-Warning "[WARN] Impossible de verifier la taille de la fenetre"
        return $true
    }
}

# Fonction d'initialisation complète de la fenêtre
function Initialize-SecureMoverWindow {
    param(
        [int]$Width = 80,
        [int]$Height = 40,
        [switch]$CenterWindow,
        [switch]$TestDimensions
    )

    Write-Host "[INFO] Configuration de la fenetre SecureMover..." -ForegroundColor Cyan

    # Test des dimensions si demandé
    if ($TestDimensions) {
        $dimensionsOK = Test-WindowDimensions -RequiredWidth $Width -RequiredHeight $Height
        if (-not $dimensionsOK) {
            Write-Host "[WARN] Ajustement de la taille de fenetre necessaire" -ForegroundColor Yellow
        }
    }

    # Configuration de la taille fixe
    $windowConfigured = Set-ConsoleWindowSize -Width $Width -Height $Height

    # Centrage si demandé et si la configuration a réussi
    if ($CenterWindow -and $windowConfigured) {
        Start-Sleep -Milliseconds 500  # Petite pause pour laisser la fenêtre se redimensionner
        Set-ConsoleWindowPosition
    }

    # Configuration des couleurs par défaut
    if ($PSVersionTable.PSVersion.Major -le 5) {
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "White"
    }

    Write-Host "[OK] Configuration de la fenetre terminee !" -ForegroundColor Green
    Write-Host ""
}

# Fonction pour restaurer la fenêtre (à appeler en fin de script si nécessaire)
function Restore-ConsoleWindow {
    try {
        if ($PSVersionTable.PSVersion.Major -le 5) {
            Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class RestoreAPI {
                    [DllImport("kernel32.dll")]
                    public static extern IntPtr GetConsoleWindow();

                    [DllImport("user32.dll")]
                    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

                    [DllImport("user32.dll")]
                    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

                    public const int GWL_STYLE = -16;
                    public const int WS_THICKFRAME = 0x00040000;
                    public const int WS_MAXIMIZEBOX = 0x00010000;
                    public const int SWP_FRAMECHANGED = 0x0020;
                }
"@

            $consoleHandle = [RestoreAPI]::GetConsoleWindow()
            $currentStyle = [RestoreAPI]::GetWindowLong($consoleHandle, [RestoreAPI]::GWL_STYLE)

            # Restaurer les styles de redimensionnement
            $newStyle = $currentStyle -bor [RestoreAPI]::WS_THICKFRAME -bor [RestoreAPI]::WS_MAXIMIZEBOX
            [RestoreAPI]::SetWindowLong($consoleHandle, [RestoreAPI]::GWL_STYLE, $newStyle) | Out-Null

            Write-Host "[OK] Fenetre restauree (redimensionnement reactive)" -ForegroundColor Green
        }
    }
    catch {
        Write-Warning "[WARN] Impossible de restaurer la fenetre : $($_.Exception.Message)"
    }
}

# -----------------------------------------------------------------------------------
# --- FONCTIONS VISUELLES AMÉLIORÉES
# -----------------------------------------------------------------------------------

# Logo ASCII pour l'en-tête
function Show-SecureMoverLogo {
    $logo = @"
╔═══════════════════════════════════════════════════════════════════╗
║   ____                          __  __                           ║
║  / ___|  ___  ___ _   _ _ __ ___|  \/  | _____   _____ _ __        ║
║  \___ \ / _ \/ __| | | | '__/ _ \ |\/| |/ _ \ \ / / _ \ '__|       ║
║   ___) |  __/ (__| |_| | | |  __/ |  | | (_) \ V /  __/ |         ║
║  |____/ \___|\___|\__,_|_|  \___|_|  |_|\___/ \_/ \___|_|         ║
║                                                                   ║
║                        Version 2.0 Enhanced                      ║
║    $($script:icons.shield) Déplacement sécurisé des profils utilisateurs Windows $($script:icons.shield)    ║
╚═══════════════════════════════════════════════════════════════════╝
"@
    Write-Host $logo -ForegroundColor Cyan
}

# Animation de chargement
function Show-LoadingAnimation {
    param(
        [string]$Message = "Traitement en cours",
        [int]$Duration = 3
    )

    $symbols = @('|', '/', '-', '\')
    $counter = 0
    $endTime = (Get-Date).AddSeconds($Duration)

    while ((Get-Date) -lt $endTime) {
        $symbol = $symbols[$counter % $symbols.Length]
        Write-Host "`r$symbol $Message..." -NoNewline -ForegroundColor Yellow
        Start-Sleep -Milliseconds 200
        $counter++
    }
    Write-Host "`r$($script:icons.ok) $Message termine!            " -ForegroundColor Green
}

# Barre de progression stylisée
function Show-StylizedProgress {
    param(
        [int]$PercentComplete,
        [string]$Activity = "Operation",
        [string]$Status = "En cours"
    )

    $barLength = 50
    $filledLength = [math]::Floor(($PercentComplete / 100) * $barLength)
    $emptyLength = $barLength - $filledLength

    $progressBar = "█" * $filledLength + "░" * $emptyLength
    $percentText = "{0:00}%" -f $PercentComplete

    Write-Host "`r$($script:icons.loading) $Activity | [$progressBar] $percentText | $Status" -NoNewline -ForegroundColor Cyan

    if ($PercentComplete -eq 100) {
        Write-Host "`n$($script:icons.ok) Operation terminee avec succes!" -ForegroundColor Green
    }
}

# Messages d'état avec icônes
function Write-StatusMessage {
    param(
        [string]$Message,
        [ValidateSet("Info", "Success", "Warning", "Error", "Progress")]
        [string]$Type = "Info"
    )

    # Mapping des types vers les clés d'icônes
    $typeMapping = @{
        "Info"     = "info"
        "Success"  = "ok"
        "Warning"  = "warn"
        "Error"    = "error"
        "Progress" = "loading"
    }

    $colors = @{
        "Info"     = "White"
        "Success"  = "Green"
        "Warning"  = "Yellow"
        "Error"    = "Red"
        "Progress" = "Cyan"
    }

    $iconKey = $typeMapping[$Type]
    $icon = $script:icons[$iconKey]
    $color = $colors[$Type]

    Write-Host "$icon $Message" -ForegroundColor $color
}

# Séparateurs et encadrements stylisés
function Show-SectionHeader {
    param([string]$Title)

    $titleLength = $Title.Length
    $totalWidth = 70
    $padding = [math]::Max(0, ($totalWidth - $titleLength - 4) / 2)
    $leftPadding = [math]::Floor($padding)
    $rightPadding = [math]::Ceiling($padding)

    Write-Host "+$('=' * ($totalWidth - 2))+" -ForegroundColor Cyan
    Write-Host "|$(' ' * $leftPadding)$Title$(' ' * $rightPadding)|" -ForegroundColor Cyan
    Write-Host "+$('=' * ($totalWidth - 2))+" -ForegroundColor Cyan
}

function Show-InfoBox {
    param(
        [string[]]$Lines,
        [string]$BorderColor = "Yellow"
    )

    $maxLength = ($Lines | Measure-Object -Property Length -Maximum).Maximum
    $width = [math]::Max($maxLength + 4, 50)

    Write-Host "+$('-' * ($width - 2))+" -ForegroundColor $BorderColor
    foreach ($line in $Lines) {
        $padding = $width - $line.Length - 3
        Write-Host "| $line$(' ' * $padding)|" -ForegroundColor $BorderColor
    }
    Write-Host "+$('-' * ($width - 2))+" -ForegroundColor $BorderColor
}

# Animation pour les opérations longues
function Start-OperationWithAnimation {
    param(
        [scriptblock]$Operation,
        [string]$Description = "Operation"
    )

    $job = Start-Job -ScriptBlock $Operation

    $spinChars = @('|', '/', '-', '\')
    $counter = 0

    while ($job.State -eq "Running") {
        $char = $spinChars[$counter % 4]
        Write-Host "`r$char $Description en cours..." -NoNewline -ForegroundColor Yellow
        Start-Sleep -Milliseconds 250
        $counter++
    }

    $result = Receive-Job $job
    Remove-Job $job

    Write-Host "`r$($script:icons.ok) $Description termine!            " -ForegroundColor Green
    return $result
}

# Gestionnaire d'erreurs avec formatage
function Show-ErrorDialog {
    param(
        [string]$ErrorMessage,
        [string]$Suggestion = ""
    )

    Write-Host ""
    Write-Host "================================ ERREUR ================================" -ForegroundColor Red
    Write-Host "                                                                    " -ForegroundColor Red
    Write-Host "  $($script:icons.error) Une erreur s'est produite                                 " -ForegroundColor Red
    Write-Host "                                                                    " -ForegroundColor Red
    Write-Host "=======================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Details : $ErrorMessage" -ForegroundColor Red

    if ($Suggestion) {
        Write-Host ""
        Write-Host "$($script:icons.info) Suggestion : $Suggestion" -ForegroundColor Yellow
    }
    Write-Host ""
}

# -----------------------------------------------------------------------------------
# --- SUPPORT MULTILINGUE
# -----------------------------------------------------------------------------------

# Dictionnaires de langues
$lang_fr = @{
    welcomeMessage = "*** Bienvenue dans SecureMover v2.0 ***"
    menuTitle = "=== MENU PRINCIPAL ==="
    menuOption1 = "[1] Deplacer un Profil Utilisateur"
    menuOption2 = "[2] Restaurer un Profil Utilisateur a son emplacement d'origine"
    menuOption3 = "[3] Creer une sauvegarde d'un Profil sur un support externe"
    menuOption4 = "[4] Quitter"
    menuChoice = "Veuillez entrer votre choix (1-5): "
    adminRequired = "*** PRIVILEGES ADMINISTRATEUR REQUIS ***"
    adminExplanation = "Ce script necessite les privileges d'administrateur pour fonctionner."
    adminReloadQuestion = "Voulez-vous relancer automatiquement le script en mode administrateur ?"
    adminReloadChoice = "Entrez O pour Oui (relancer automatiquement) ou N pour Non (quitter)"
    adminReloading = "Relancement en mode administrateur..."
    adminReloadError = "Erreur lors du relancement automatique."
    operationCancelled = "Operation annulee par l'utilisateur."
    noProfilesFound = "Aucun profil utilisateur trouve."
    profileSelection = "=== SELECTION DU PROFIL UTILISATEUR ==="
    profileExplanation = "Veuillez selectionner le profil utilisateur sur lequel vous souhaitez travailler:"
    profileChoice = "Entrez le numero du profil (1-{0}): "
    operationSuccess = "*** OPERATION TERMINEE AVEC SUCCES ! ***"
    operationError = "Une erreur est survenue lors de l'operation."
    restartRequired = "IMPORTANT : Pour que toutes les modifications prennent effet, veuillez redemarrer votre ordinateur maintenant."
    pressEnterToClose = "Appuyez sur Entree pour fermer ce script."
    goodbye = "Au revoir !"
}

$lang_en = @{
    welcomeMessage = "*** Welcome to SecureMover v2.0 ***"
    menuTitle = "=== MAIN MENU ==="
    menuOption1 = "[1] Move a User Profile"
    menuOption2 = "[2] Restore a User Profile to its original location"
    menuOption3 = "[3] Create a backup of a Profile on external media"
    menuOption4 = "[4] Exit"
    menuChoice = "Please enter your choice (1-5): "
    adminRequired = "*** ADMINISTRATOR PRIVILEGES REQUIRED ***"
    adminExplanation = "This script requires administrator privileges to function."
    adminReloadQuestion = "Do you want to automatically restart the script in administrator mode?"
    adminReloadChoice = "Enter Y for Yes (restart automatically) or N for No (quit)"
    adminReloading = "Restarting in administrator mode..."
    adminReloadError = "Error during automatic restart."
    operationCancelled = "Operation cancelled by user."
    noProfilesFound = "No user profiles found."
    profileSelection = "=== USER PROFILE SELECTION ==="
    profileExplanation = "Please select the user profile you want to work with:"
    profileChoice = "Enter the profile number (1-{0}): "
    operationSuccess = "*** OPERATION COMPLETED SUCCESSFULLY! ***"
    operationError = "An error occurred during the operation."
    restartRequired = "IMPORTANT: For all changes to take effect, please restart your computer now."
    pressEnterToClose = "Press Enter to close this script."
    goodbye = "Goodbye!"
}

# Détection de la langue du système
$systemCulture = Get-Culture
if ($systemCulture.Name -like "fr*") {
    $lang = $lang_fr
} else {
    $lang = $lang_en
}

# -----------------------------------------------------------------------------------
# --- FONCTIONS UTILITAIRES
# -----------------------------------------------------------------------------------

# Fonction pour vérifier si le script est lancé en tant qu'administrateur
function Test-AdminPrivileges {
    try {
        $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
        return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    catch {
        Write-Warning "Impossible de vérifier les privilèges administrateur."
        return $false
    }
}

# Fonction de logging améliorée
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Utiliser les nouveaux messages d'état avec icônes
    switch ($Level) {
        "ERROR" { Write-StatusMessage $Message "Error" }
        "WARNING" { Write-StatusMessage $Message "Warning" }
        "SUCCESS" { Write-StatusMessage $Message "Success" }
        "INFO" { Write-StatusMessage $Message "Info" }
        default { Write-StatusMessage $Message "Info" }
    }

    # Écriture dans le fichier log
    try {
        $logPath = Join-Path -Path $PSScriptRoot -ChildPath "SecureMover.log"
        $logMessage | Out-File -FilePath $logPath -Append -Encoding UTF8
    }
    catch {
        Write-StatusMessage "Impossible d'écrire dans le fichier de log: $($_.Exception.Message)" "Warning"
    }
}

# Fonction pour lister les profils utilisateurs
function Get-UserProfiles {
    try {
        $usersPath = "C:\Users"
        $profiles = @()

        if (Test-Path -Path $usersPath) {
            $userFolders = Get-ChildItem -Path $usersPath -Directory | Where-Object {
                # Filtre les vrais profils utilisateurs (ceux avec NTUSER.DAT)
                $ntuserPath = Join-Path -Path $_.FullName -ChildPath "NTUSER.DAT"
                Test-Path -Path $ntuserPath
            }

            $profiles = $userFolders | ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.Name
                    Path = $_.FullName
                    NTUserPath = Join-Path -Path $_.FullName -ChildPath "NTUSER.DAT"
                }
            }
        }

        return $profiles
    }
    catch {
        Write-Log "Erreur lors de la récupération des profils: $($_.Exception.Message)" "ERROR"
        return @()
    }
}

# Fonction pour sélectionner un profil utilisateur
function Select-UserProfile {
    $profiles = Get-UserProfiles

    if ($profiles.Count -eq 0) {
        Write-Host $lang.noProfilesFound -ForegroundColor Red
        return $null
    }

    Write-Host $lang.profileSelection -ForegroundColor Cyan
    Write-Host $lang.profileExplanation -ForegroundColor White
    Write-Host

    for ($i = 0; $i -lt $profiles.Count; $i++) {
        Write-Host "$($i + 1). $($profiles[$i].Name)" -ForegroundColor Green
    }
    Write-Host

    do {
        $choice = Read-Host ($lang.profileChoice -f $profiles.Count)
        $index = [int]$choice - 1
    } while ($index -lt 0 -or $index -ge $profiles.Count)

    return $profiles[$index]
}

# Fonction pour sélectionner une partition de destination
function Select-DestinationDrive {
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -ne 'C:\' } | Select-Object -ExpandProperty Name

    if ($drives.Count -eq 0) {
        Write-Log "ERREUR : Aucune autre partition que C: n'a été trouvée." "ERROR"
        return $null
    }

    Write-Host
    Write-Host "Voici les partitions disponibles : $($drives -join ', ')" -ForegroundColor Green
    $destinationDrive = Read-Host "Veuillez entrer la lettre de la partition de destination (ex: D)"

    if (-not ($drives -contains $destinationDrive)) {
        Write-Log "ERREUR : Partition invalide sélectionnée: $destinationDrive" "ERROR"
        return $null
    }

    return $destinationDrive
}

# Fonction pour sélectionner un lecteur amovible
function Select-RemovableDrive {
    $removableDrives = Get-Volume | Where-Object { $_.DriveType -eq 'Removable' -and $_.DriveLetter } | Select-Object -ExpandProperty DriveLetter

    if ($removableDrives.Count -eq 0) {
        Write-StatusMessage "Aucun lecteur amovible détecté." "Warning"
        return $null
    }

    Write-Host ""
    Write-Host "Lecteurs amovibles détectés : $($removableDrives -join ', ')" -ForegroundColor Green

    if ($removableDrives.Count -eq 1) {
        $choice = Read-Host "Utiliser le lecteur $($removableDrives[0]) ? (O/N)"
        if ($choice -eq 'O' -or $choice -eq 'o') {
            return $removableDrives[0]
        }
    } else {
        for ($i = 0; $i -lt $removableDrives.Count; $i++) {
            Write-Host "$($i + 1). Lecteur $($removableDrives[$i])" -ForegroundColor Cyan
        }

        do {
            $choice = Read-Host "Entrez le numéro du lecteur (1-$($removableDrives.Count))"
            $index = [int]$choice - 1
        } while ($index -lt 0 -or $index -ge $removableDrives.Count)

        return $removableDrives[$index]
    }

    return $null
}

# Fonction de sauvegarde du registre avant modification
function Backup-RegistrySettings {
    param([string]$RegistryPath)

    try {
        $backupPath = Join-Path -Path $PSScriptRoot -ChildPath "SecureMover_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
        $registryData = Get-ItemProperty -Path $RegistryPath -ErrorAction Stop

        $backupContent = "Windows Registry Editor Version 5.00`n`n"
        $backupContent += "[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders]`n"

        foreach ($property in $registryData.PSObject.Properties) {
            if ($property.Name -notin @("PSPath", "PSParentPath", "PSChildName", "PSProvider")) {
                $backupContent += "`"$($property.Name)`"=`"$($property.Value)`"`n"
            }
        }

        $backupContent | Out-File -FilePath $backupPath -Encoding Unicode
        Write-Log "Sauvegarde du registre créée: $backupPath" "INFO"
        return $backupPath
    }
    catch {
        Write-Log "Erreur lors de la sauvegarde du registre: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Fonction de rollback
function Restore-RegistrySettings {
    param([string]$BackupPath)

    try {
        Write-StatusMessage "Restauration des paramètres du registre..." "Progress"

        # Import du fichier de sauvegarde
        $result = Start-Process -FilePath "regedit.exe" -ArgumentList "/s", "`"$BackupPath`"" -Wait -PassThru

        if ($result.ExitCode -eq 0) {
            Write-StatusMessage "Restauration du registre réussie" "Success"
            return $true
        } else {
            Write-StatusMessage "Erreur lors de la restauration du registre (Code: $($result.ExitCode))" "Error"
            return $false
        }
    }
    catch {
        Write-StatusMessage "Erreur lors de la restauration du registre: $($_.Exception.Message)" "Error"
        return $false
    }
}

# Fonction pour mettre à jour les références Windows
function Update-WindowsReferences {
    param([string]$NewPath)

    try {
        Write-Log "Mise à jour des références Windows..." "INFO"

        # 1. Rafraîchir l'Explorateur Windows
        Write-Log "Rafraîchissement de l'Explorateur Windows..." "INFO"
        Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Start-Process -FilePath "explorer.exe"

        # 2. Mettre à jour les raccourcis du Bureau
        Write-Log "Mise à jour des raccourcis du Bureau..." "INFO"
        $desktopPath = [Environment]::GetFolderPath("Desktop")
        Get-ChildItem -Path $desktopPath -Filter "*.lnk" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $shell = New-Object -ComObject WScript.Shell
                $shortcut = $shell.CreateShortcut($_.FullName)
                if ($shortcut.TargetPath -like "*$NewPath*") {
                    $shortcut.Save()
                }
            }
            catch {
                Write-Log "Erreur lors de la mise à jour du raccourci $($_.Name): $($_.Exception.Message)" "WARNING"
            }
        }

        # 3. Notifier Windows des changements
        Write-Log "Notification des changements à Windows..." "INFO"
        try {
            $SHChangeNotify = Add-Type -MemberDefinition @"
                [DllImport("shell32.dll")]
                public static extern void SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
"@ -Name "Win32" -Namespace "Win32Functions" -PassThru

            # SHCNE_ASSOCCHANGED = 0x08000000
            $SHChangeNotify::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)
        }
        catch {
            Write-Log "Erreur lors de la notification Windows: $($_.Exception.Message)" "WARNING"
        }

        Write-Log "Mise à jour des références Windows terminée" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Erreur lors de la mise à jour des références Windows: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Fonction améliorée pour gérer les erreurs Robocopy
function Handle-RobocopyResult {
    param(
        [int]$ExitCode,
        [string]$FolderName,
        [string]$Operation = "copie"
    )

    switch ($ExitCode) {
        0 {
            Write-StatusMessage "$Operation de $FolderName : Aucun fichier copié" "Info"
            return $true
        }
        1 {
            Write-StatusMessage "$Operation de $FolderName : Fichiers copiés avec succès" "Success"
            return $true
        }
        2 {
            Write-StatusMessage "$Operation de $FolderName : Fichiers supplémentaires ou dossiers détectés" "Info"
            return $true
        }
        3 {
            Write-StatusMessage "$Operation de $FolderName : Fichiers copiés et fichiers supplémentaires détectés" "Success"
            return $true
        }
        { $_ -in 4,5,6,7 } {
            Write-StatusMessage "$Operation de $FolderName : Réussie avec avertissements mineurs" "Warning"
            return $true
        }
        8 {
            Write-StatusMessage "$Operation de $FolderName : Échec - Fichiers non copiés" "Error"
            return $false
        }
        { $_ -gt 8 } {
            Write-StatusMessage "$Operation de $FolderName : Erreur critique (Code: $ExitCode)" "Error"
            return $false
        }
        default {
            Write-StatusMessage "$Operation de $FolderName : Code de sortie inattendu ($ExitCode)" "Warning"
            return $true
        }
    }
}

# -----------------------------------------------------------------------------------
# --- VÉRIFICATION DES PRÉREQUIS
# -----------------------------------------------------------------------------------

# Vérification des privilèges administrateur
if (-not (Test-AdminPrivileges)) {
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host $lang.adminRequired -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host
    Write-Host $lang.adminExplanation -ForegroundColor Yellow
    Write-Host $lang.adminReloadQuestion -ForegroundColor Cyan
    Write-Host
    $relaunchChoice = Read-Host $lang.adminReloadChoice

    if ($relaunchChoice -eq 'O' -or $relaunchChoice -eq 'Y') {
        Write-Host $lang.adminReloading -ForegroundColor Green
        try {
            # Relance le script avec les privilèges administrateur et ferme la fenêtre actuelle
            Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"" -Verb RunAs -Wait
            # Ferme la fenêtre PowerShell actuelle
            exit
        }
        catch {
            Write-Host $lang.adminReloadError -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit
        }
    } else {
        Write-Host $lang.operationCancelled -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        exit
    }
}

# Configuration de la fenêtre console
Initialize-SecureMoverWindow -Width 85 -Height 45 -CenterWindow -TestDimensions

Write-Log "Démarrage de SecureMover v2.0" "INFO"
Clear-Host

# -----------------------------------------------------------------------------------
# --- MENU PRINCIPAL
# -----------------------------------------------------------------------------------

function Show-MainMenu {
    Clear-Host
    Show-SecureMoverLogo

    Write-Host ""
    Write-Host "+---------------------------------------------------------------+" -ForegroundColor Cyan
    Write-Host "|                    Developpe par DrSmoke                      |" -ForegroundColor Cyan
    Write-Host "|                'un mbokatier bien engage' & IA                |" -ForegroundColor Cyan
    Write-Host "+---------------------------------------------------------------+" -ForegroundColor Cyan
    Write-Host ""

    Show-InfoBox -Lines @(
        "Ce script vous permet de securiser vos donnees personnelles en deplacant",
        "vos dossiers utilisateur (Documents, Images, Musique, etc.) vers une autre",
        "partition de votre disque dur. Cela protege vos donnees en cas de",
        "probleme avec le systeme d'exploitation."
    ) -BorderColor "Blue"

    Write-Host ""
    Write-Host "Dossiers deplaces :" -ForegroundColor Green
    Show-InfoBox -Lines @(
        "* Bureau (Desktop)",
        "* Documents",
        "* Telechargements (Downloads)",
        "* Images (Pictures)",
        "* Musique (Music)",
        "* Videos (Videos)"
    ) -BorderColor "Green"

    Write-Host ""
    Write-Host "Fonctionnalites de securite :" -ForegroundColor Green
    Show-InfoBox -Lines @(
        "* Sauvegarde automatique du registre Windows",
        "* Mise a jour des references Windows",
        "* Verification post-operation",
        "* Gestion d'erreurs robuste"
    ) -BorderColor "Yellow"

    Write-Host ""
    Write-Host "AVERTISSEMENTS IMPORTANTS :" -ForegroundColor Red
    Show-InfoBox -Lines @(
        "* Ce script necessite les privileges administrateur",
        "* Assurez-vous d'avoir suffisamment d'espace sur la partition de destination",
        "* Une sauvegarde du registre est creee automatiquement",
        "* Un redemarrage est recommande apres l'operation"
    ) -BorderColor "Red"

    Write-Host ""
    Write-Host "+==================== MENU PRINCIPAL ====================+" -ForegroundColor Yellow
    Write-Host "|                                                        |" -ForegroundColor Yellow
    Write-Host "|  $($script:icons.user) [1] Deplacer un Profil Utilisateur                 |" -ForegroundColor Green
    Write-Host "|  $($script:icons.restore) [2] Restaurer un Profil Utilisateur                |" -ForegroundColor Blue
    Write-Host "|  $($script:icons.backup) [3] Creer une sauvegarde d'un Profil               |" -ForegroundColor Magenta
    Write-Host "|  $($script:icons.info) [4] Aide et Informations                          |" -ForegroundColor Cyan
    Write-Host "|  $($script:icons.quit) [5] Quitter                                        |" -ForegroundColor Red
    Write-Host "|                                                        |" -ForegroundColor Yellow
    Write-Host "+========================================================+" -ForegroundColor Yellow
    Write-Host ""
}

# Fonction d'aide et informations
function Show-HelpMenu {
    Show-SectionHeader "AIDE ET INFORMATIONS"

    Show-InfoBox -Lines @(
        "GUIDE D'UTILISATION RAPIDE",
        "",
        "1. DÉPLACER UN PROFIL :",
        "   • Déplace vos dossiers personnels vers une autre partition",
        "   • Modifie le registre Windows pour la redirection",
        "   • Crée automatiquement une sauvegarde de sécurité",
        "",
        "2. RESTAURER UN PROFIL :",
        "   • Remet vos dossiers dans leur emplacement d'origine (C:\\Users)",
        "   • Restaure les paramètres du registre",
        "   • Nécessite une sauvegarde créée par ce script",
        "",
        "3. SAUVEGARDER UN PROFIL :",
        "   • Crée une copie de vos dossiers sans modifier le système",
        "   • Idéal avant de faire des modifications importantes",
        "   • Peut être fait sur un lecteur externe"
    ) -BorderColor "Blue"

    Write-Host ""
    Show-InfoBox -Lines @(
        "CONSEILS DE SÉCURITÉ",
        "",
        "• Toujours exécuter en tant qu'administrateur",
        "• Fermer tous les programmes avant l'opération",
        "• Vérifier l'espace disque disponible",
        "• Redémarrer après chaque opération",
        "• Conserver les fichiers de sauvegarde (.reg)"
    ) -BorderColor "Yellow"

    Write-Host ""
    Read-Host "Appuyez sur Entrée pour revenir au menu principal"
}

function Get-MenuChoice {
    do {
        $choice = Read-Host $lang.menuChoice
    } while ($choice -notin @('1', '2', '3', '4', '5'))

    return $choice
}

# -----------------------------------------------------------------------------------
# --- FONCTIONS DES OPTIONS DU MENU
# -----------------------------------------------------------------------------------

# Option 1: Déplacer un Profil Utilisateur
function Move-UserProfile {
    Show-SectionHeader "DÉPLACEMENT DE PROFIL UTILISATEUR"

    # Sélection du profil
    $selectedProfile = Select-UserProfile
    if (-not $selectedProfile) {
        return
    }

    # Sélection de la partition de destination
    $destinationDrive = Select-DestinationDrive
    if (-not $destinationDrive) {
        return
    }

    $destinationPath = "${destinationDrive}:\Users\$($selectedProfile.Name)"

    # Confirmation avec design amélioré
    Write-Host ""
    Show-InfoBox -Lines @(
        "RÉCAPITULATIF DE L'OPÉRATION",
        "",
        "Profil sélectionné   : $($selectedProfile.Name)",
        "Dossier source       : $($selectedProfile.Path)",
        "Dossier de destination : $destinationPath",
        "",
        "ATTENTION : L'action est sur le point de commencer et ne pourra pas être interrompue."
    ) -BorderColor "Cyan"

    Write-Host ""
    $finalConfirmation = Read-Host "Confirmez-vous cette opération ? (Entrez O pour Oui, N pour Non)"

    if ($finalConfirmation -ne 'O') {
        Write-StatusMessage "Opération annulée par l'utilisateur." "Warning"
        return
    }

    # Sauvegarde du registre avec animation
    Write-StatusMessage "Création de la sauvegarde du registre..." "Progress"
    Show-LoadingAnimation -Message "Sauvegarde du registre" -Duration 2
    $registryBackupPath = Backup-RegistrySettings -RegistryPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'

    try {
        # Création du dossier parent de destination
        if (-not (Test-Path -Path $destinationPath)) {
            Write-StatusMessage "Création du dossier de destination: $destinationPath" "Info"
            New-Item -Path $destinationPath -ItemType Directory | Out-Null
        }

        # Hash table des dossiers à déplacer
        $foldersToMove = @{
            'Desktop'    = 'Desktop';
            'Documents'  = 'Personal';
            'Downloads'  = '{374DE290-123F-4565-9164-39C4925E467B}';
            'Music'      = 'My Music';
            'Pictures'   = 'My Pictures';
            'Videos'     = 'My Video'
        }

        $registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
        $movedFolders = @()

        # Boucle sur chaque dossier pour le déplacer avec barre de progression stylisée
        $i = 1
        foreach ($folder in $foldersToMove.Keys) {
            Show-StylizedProgress -PercentComplete (($i / $foldersToMove.Count) * 100) -Activity "Déplacement des dossiers" -Status "Traitement de $folder..."

            $sourceFullPath = Join-Path -Path $selectedProfile.Path -ChildPath $folder
            $destFullPath = Join-Path -Path $destinationPath -ChildPath $folder

            if (Test-Path -Path $sourceFullPath) {
                Write-StatusMessage "Déplacement de $folder vers $destFullPath" "Progress"

                # Utilisation de Robocopy pour un déplacement robuste
                $robocopyResult = robocopy $sourceFullPath $destFullPath /E /MOVE /NJH /NJS
                $exitCode = $LASTEXITCODE

                if ($exitCode -le 7) {
                    Write-StatusMessage "Déplacement réussi de $folder (Code: $exitCode)" "Success"

                    # Mise à jour du Registre
                    try {
                        Set-ItemProperty -Path $registryPath -Name $foldersToMove[$folder] -Value $destFullPath -ErrorAction Stop

                        # Vérification post-opération
                        $newValue = Get-ItemProperty -Path $registryPath -Name $foldersToMove[$folder] -ErrorAction SilentlyContinue
                        if ($newValue -and $newValue.$($foldersToMove[$folder]) -eq $destFullPath) {
                            Write-StatusMessage "Mise à jour du registre pour $folder - SUCCESS" "Success"
                            $movedFolders += $folder
                        } else {
                            Write-StatusMessage "Mise à jour du registre pour $folder - WARNING (vérification échouée)" "Warning"
                        }
                    }
                    catch {
                        Write-StatusMessage "Erreur lors de la mise a jour du registre pour ${folder}: $($_.Exception.Message)" "Error"
                    }
                } else {
                    Write-StatusMessage "Erreur lors du déplacement de $folder (Code: $exitCode)" "Error"
                }
            } else {
                Write-StatusMessage "Dossier source inexistant: $sourceFullPath" "Warning"
            }
            $i++
        }

        Show-StylizedProgress -PercentComplete 100 -Activity "Déplacement des dossiers" -Status "Terminé"

        # Mise à jour des références Windows avec animation
        Write-Host ""
        Write-StatusMessage "Mise à jour des références Windows..." "Progress"
        Write-Host "Cette étape permet à Windows de reconnaître les nouveaux emplacements." -ForegroundColor White

        Show-LoadingAnimation -Message "Mise à jour des références Windows" -Duration 3
        Update-WindowsReferences -NewPath $destinationPath

        # Conclusion avec design amélioré
        Write-Host ""
        Show-InfoBox -Lines @(
            "$($script:icons.success) OPÉRATION TERMINÉE AVEC SUCCÈS ! $($script:icons.success)",
            "",
            "Dossiers déplacés: $($movedFolders.Count)",
            "Fichier de sauvegarde: $registryBackupPath",
            "Références Windows mises à jour",
            "",
            "IMPORTANT : Pour que toutes les modifications prennent effet,",
            "veuillez redémarrer votre ordinateur maintenant."
        ) -BorderColor "Green"

        Write-Log "Opération terminée avec succès. Dossiers déplacés: $($movedFolders -join ', ')" "SUCCESS"
    }
    catch {
        Write-StatusMessage "ERREUR CRITIQUE: $($_.Exception.Message)" "Error"
        Show-ErrorDialog -ErrorMessage $_.Exception.Message -Suggestion "Vérifiez les permissions et l'espace disque disponible"

        if ($registryBackupPath) {
            Write-Host ""
            $restoreChoice = Read-Host "Voulez-vous restaurer le registre ? (O/N)"
            if ($restoreChoice -eq 'O') {
                Restore-RegistrySettings -BackupPath $registryBackupPath
            }
        }
    }
}

# Option 2: Restaurer un Profil Utilisateur
function Restore-UserProfile {
    Show-SectionHeader "RESTAURATION DE PROFIL UTILISATEUR"

    # Recherche des profils déplacés
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -ne 'C:\' }
    $movedProfiles = @()

    Write-StatusMessage "Recherche des profils déplacés..." "Progress"
    Show-LoadingAnimation -Message "Analyse des partitions" -Duration 2

    foreach ($drive in $drives) {
        $usersPath = "$($drive.Name):\Users"
        if (Test-Path -Path $usersPath) {
            $userFolders = Get-ChildItem -Path $usersPath -Directory -ErrorAction SilentlyContinue
            foreach ($folder in $userFolders) {
                $movedProfiles += [PSCustomObject]@{
                    Name = $folder.Name
                    MovedPath = $folder.FullName
                    OriginalPath = "C:\Users\$($folder.Name)"
                    Drive = $drive.Name
                }
            }
        }
    }

    if ($movedProfiles.Count -eq 0) {
        Show-InfoBox -Lines @(
            "Aucun profil déplacé détecté sur les autres partitions.",
            "Vérifiez que les profils ont bien été déplacés avec ce script."
        ) -BorderColor "Red"
        return
    }

    # Affichage des profils trouvés
    Write-Host ""
    Write-StatusMessage "Profils déplacés détectés :" "Success"

    for ($i = 0; $i -lt $movedProfiles.Count; $i++) {
        Write-Host "$($i + 1). $($movedProfiles[$i].Name) (Partition $($movedProfiles[$i].Drive):)" -ForegroundColor Green
    }
    Write-Host ""

    # Sélection du profil
    do {
        $choice = Read-Host "Entrez le numéro du profil à restaurer (1-$($movedProfiles.Count))"
        $index = [int]$choice - 1
    } while ($index -lt 0 -or $index -ge $movedProfiles.Count)

    $selectedProfile = $movedProfiles[$index]

    # Recherche du fichier de sauvegarde du registre
    $backupFiles = Get-ChildItem -Path $PSScriptRoot -Filter "SecureMover_Backup_*.reg" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending

    # Confirmation avec récapitulatif
    Show-InfoBox -Lines @(
        "RÉCAPITULATIF DE LA RESTAURATION",
        "",
        "Profil à restaurer    : $($selectedProfile.Name)",
        "Emplacement actuel    : $($selectedProfile.MovedPath)",
        "Emplacement d'origine : $($selectedProfile.OriginalPath)",
        "Sauvegardes disponibles : $($backupFiles.Count)",
        "",
        "$($script:icons.warn) ATTENTION : Cette opération déplacera tous les fichiers vers C:\Users"
    ) -BorderColor "Yellow"

    Write-Host ""
    $finalConfirmation = Read-Host "Confirmez-vous cette restauration ? (Entrez O pour Oui, N pour Non)"

    if ($finalConfirmation -ne 'O') {
        Write-StatusMessage "Restauration annulée par l'utilisateur." "Warning"
        return
    }

    try {
        # Création du dossier d'origine s'il n'existe pas
        if (-not (Test-Path -Path $selectedProfile.OriginalPath)) {
            Write-StatusMessage "Création du dossier d'origine: $($selectedProfile.OriginalPath)" "Info"
            New-Item -Path $selectedProfile.OriginalPath -ItemType Directory -Force | Out-Null
        }

        # Déplacement des dossiers
        $foldersToRestore = @('Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Videos')
        $restoredFolders = @()

        $i = 1
        foreach ($folder in $foldersToRestore) {
            Show-StylizedProgress -PercentComplete (($i / $foldersToRestore.Count) * 100) -Activity "Restauration des dossiers" -Status "Traitement de $folder..."

            $sourcePath = Join-Path -Path $selectedProfile.MovedPath -ChildPath $folder
            $destPath = Join-Path -Path $selectedProfile.OriginalPath -ChildPath $folder

            if (Test-Path -Path $sourcePath) {
                Write-StatusMessage "Restauration de $folder..." "Progress"
                $robocopyResult = robocopy $sourcePath $destPath /E /MOVE /NJH /NJS
                $exitCode = $LASTEXITCODE

                if (Handle-RobocopyResult -ExitCode $exitCode -FolderName $folder -Operation "restauration") {
                    $restoredFolders += $folder
                }
            }
            $i++
        }

        Show-StylizedProgress -PercentComplete 100 -Activity "Restauration des dossiers" -Status "Terminé"

        # Restauration du registre si sauvegarde disponible
        if ($backupFiles.Count -gt 0) {
            Write-StatusMessage "Restauration du registre..." "Progress"
            Show-LoadingAnimation -Message "Restauration des clés de registre" -Duration 2

            $latestBackup = $backupFiles[0]
            if (Restore-RegistrySettings -BackupPath $latestBackup.FullName) {
                Write-StatusMessage "Registre restauré avec succès" "Success"
            } else {
                Write-StatusMessage "Erreur lors de la restauration du registre" "Warning"
            }
        }

        # Mise à jour des références Windows
        Write-StatusMessage "Mise à jour des références Windows..." "Progress"
        Show-LoadingAnimation -Message "Actualisation de l'Explorateur" -Duration 2
        Update-WindowsReferences -NewPath $selectedProfile.OriginalPath

        # Conclusion
        Show-InfoBox -Lines @(
            "$($script:icons.success) RESTAURATION TERMINÉE AVEC SUCCÈS ! $($script:icons.success)",
            "",
            "Dossiers restaurés: $($restoredFolders.Count)",
            "Emplacement: $($selectedProfile.OriginalPath)",
            "Registre restauré: $(if($backupFiles.Count -gt 0){'Oui'}else{'Non'})",
            "",
            "IMPORTANT : Redémarrez votre ordinateur pour finaliser les changements."
        ) -BorderColor "Green"

        Write-Log "Restauration terminée avec succès pour le profil $($selectedProfile.Name)" "SUCCESS"
    }
    catch {
        Write-StatusMessage "ERREUR CRITIQUE lors de la restauration: $($_.Exception.Message)" "Error"
        Show-ErrorDialog -ErrorMessage $_.Exception.Message -Suggestion "Vérifiez les permissions et l'espace disque disponible sur C:"
    }
}

# Option 3: Créer une sauvegarde
function Backup-UserProfile {
    Show-SectionHeader "SAUVEGARDE DE PROFIL UTILISATEUR"

    # Sélection du profil
    $selectedProfile = Select-UserProfile
    if (-not $selectedProfile) {
        return
    }

    # Sélection du lecteur de destination
    $destinationDrive = Select-RemovableDrive
    if (-not $destinationDrive) {
        # Si pas de lecteur amovible, proposer les autres partitions
        Write-StatusMessage "Aucun lecteur amovible détecté. Autres partitions disponibles :" "Warning"
        $destinationDrive = Select-DestinationDrive
        if (-not $destinationDrive) {
            return
        }
    }

    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $destinationPath = "${destinationDrive}:\SecureMover_Backup_$($selectedProfile.Name)_$timestamp"

    # Estimation de la taille
    Write-StatusMessage "Calcul de la taille des données à sauvegarder..." "Progress"
    Show-LoadingAnimation -Message "Analyse de l'espace requis" -Duration 2

    $totalSize = 0
    $foldersToBackup = @('Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Videos')

    foreach ($folder in $foldersToBackup) {
        $folderPath = Join-Path -Path $selectedProfile.Path -ChildPath $folder
        if (Test-Path -Path $folderPath) {
            try {
                $folderSize = (Get-ChildItem -Path $folderPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                $totalSize += $folderSize
            }
            catch {
                Write-StatusMessage "Impossible de calculer la taille de $folder" "Warning"
            }
        }
    }

    $totalSizeGB = [math]::Round($totalSize / 1GB, 2)

    # Vérification de l'espace disponible
    $availableSpace = (Get-PSDrive -Name $destinationDrive).Free
    $availableSpaceGB = [math]::Round($availableSpace / 1GB, 2)

    # Confirmation avec informations détaillées
    $spaceStatus = if ($availableSpace -gt ($totalSize * 1.1)) { "$($script:icons.check) Espace suffisant" } else { "$($script:icons.warn) Espace limite" }

    Show-InfoBox -Lines @(
        "RÉCAPITULATIF DE LA SAUVEGARDE",
        "",
        "Profil à sauvegarder  : $($selectedProfile.Name)",
        "Dossier source        : $($selectedProfile.Path)",
        "Destination           : $destinationPath",
        "Taille estimée        : $totalSizeGB GB",
        "Espace disponible     : $availableSpaceGB GB",
        "Statut                : $spaceStatus",
        "",
        "Cette sauvegarde N'AFFECTERA PAS votre système actuel."
    ) -BorderColor "Cyan"

    Write-Host ""
    $finalConfirmation = Read-Host "Confirmez-vous cette sauvegarde ? (Entrez O pour Oui, N pour Non)"

    if ($finalConfirmation -ne 'O') {
        Write-StatusMessage "Sauvegarde annulée par l'utilisateur." "Warning"
        return
    }

    try {
        # Création du dossier de destination
        Write-StatusMessage "Création du dossier de sauvegarde..." "Progress"
        New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null

        # Sauvegarde de chaque dossier
        $backedUpFolders = @()
        $i = 1

        foreach ($folder in $foldersToBackup) {
            Show-StylizedProgress -PercentComplete (($i / $foldersToBackup.Count) * 100) -Activity "Sauvegarde en cours" -Status "Copie de $folder..."

            $sourcePath = Join-Path -Path $selectedProfile.Path -ChildPath $folder
            $destPath = Join-Path -Path $destinationPath -ChildPath $folder

            if (Test-Path -Path $sourcePath) {
                Write-StatusMessage "Sauvegarde de $folder..." "Progress"

                # Utilisation de robocopy en mode copie (pas de déplacement)
                $robocopyResult = robocopy $sourcePath $destPath /E /COPY:DAT /R:3 /W:1 /NJH /NJS
                $exitCode = $LASTEXITCODE

                if (Handle-RobocopyResult -ExitCode $exitCode -FolderName $folder -Operation "sauvegarde") {
                    $backedUpFolders += $folder
                }
            } else {
                Write-StatusMessage "Dossier $folder inexistant - ignoré" "Warning"
            }
            $i++
        }

        Show-StylizedProgress -PercentComplete 100 -Activity "Sauvegarde en cours" -Status "Terminé"

        # Création d'un fichier d'informations
        $infoContent = @"
SecureMover v2.0 - Informations de Sauvegarde
=============================================

Profil sauvegardé : $($selectedProfile.Name)
Date de création  : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Dossiers inclus   : $($backedUpFolders -join ', ')
Taille totale     : $totalSizeGB GB
Source originale  : $($selectedProfile.Path)

Cette sauvegarde peut être restaurée manuellement en copiant
les dossiers vers leur emplacement d'origine.

IMPORTANT : Cette sauvegarde ne contient PAS les paramètres
du registre Windows. Pour une restauration complète, utilisez
l'option 'Restaurer un Profil' du script SecureMover.
"@

        $infoPath = Join-Path -Path $destinationPath -ChildPath "INFORMATIONS_SAUVEGARDE.txt"
        $infoContent | Out-File -FilePath $infoPath -Encoding UTF8

        # Conclusion
        Show-InfoBox -Lines @(
            "$($script:icons.success) SAUVEGARDE TERMINÉE AVEC SUCCÈS ! $($script:icons.success)",
            "",
            "Emplacement : $destinationPath",
            "Dossiers sauvegardés : $($backedUpFolders.Count)",
            "Taille finale : $totalSizeGB GB",
            "Fichier d'infos : INFORMATIONS_SAUVEGARDE.txt",
            "",
            "Votre système n'a PAS été modifié."
        ) -BorderColor "Green"

        Write-Log "Sauvegarde terminée avec succès pour le profil $($selectedProfile.Name)" "SUCCESS"
    }
    catch {
        Write-StatusMessage "ERREUR CRITIQUE lors de la sauvegarde: $($_.Exception.Message)" "Error"
        Show-ErrorDialog -ErrorMessage $_.Exception.Message -Suggestion "Vérifiez l'espace disque et les permissions sur le lecteur de destination"
    }
}

# -----------------------------------------------------------------------------------
# --- BOUCLE PRINCIPALE
# -----------------------------------------------------------------------------------

do {
    Show-MainMenu
    $choice = Get-MenuChoice

    switch ($choice) {
        '1' { Move-UserProfile }
        '2' { Restore-UserProfile }
        '3' { Backup-UserProfile }
        '4' { Show-HelpMenu }
        '5' {
            Write-Host $lang.goodbye -ForegroundColor Green
            break
        }
    }

    if ($choice -ne '5') {
        Write-Host
        if ($NoExit) {
            Read-Host $lang.pressEnterToClose
        } else {
            Start-Sleep -Seconds 3
        }
        Clear-Host
    }
} while ($choice -ne '5')

# Restauration de la fenêtre console (optionnel)
if ($PSVersionTable.PSVersion.Major -le 5) {
    Restore-ConsoleWindow
}
