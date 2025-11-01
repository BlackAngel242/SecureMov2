# ==============================================================================
# SecureMover v2.0.2 - PATCHES CRITIQUES
# ==============================================================================
# Ce fichier contient les nouvelles fonctions à ajouter au script principal
# Date : 2025-11-01
# Patches appliqués : UX-002, BUG-003, UX-008
# ==============================================================================

# ------------------------------------------------------------------------------
# PATCH UX-002 : Vérification Espace Disque
# ------------------------------------------------------------------------------

function Get-FolderSize {
    <#
    .SYNOPSIS
        Calcule la taille totale d'un dossier et ses sous-dossiers.
    .DESCRIPTION
        Parcourt récursivement le dossier et additionne la taille de tous les fichiers.
    .PARAMETER Path
        Chemin du dossier à mesurer
    .OUTPUTS
        Taille en octets (Int64)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    try {
        Write-StatusMessage "Calcul de la taille du profil..." "Progress"

        $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
                 Measure-Object -Property Length -Sum).Sum

        if ($null -eq $size) {
            $size = 0
        }

        Write-StatusMessage "Taille calculée : $([Math]::Round($size / 1GB, 2)) GB" "Info"
        return $size
    }
    catch {
        Write-StatusMessage "Erreur lors du calcul de taille : $($_.Exception.Message)" "Warning"
        return 0
    }
}

function Test-AvailableSpace {
    <#
    .SYNOPSIS
        Vérifie si assez d'espace disque disponible.
    .PARAMETER SourceSize
        Taille des données à déplacer (octets)
    .PARAMETER DestinationDrive
        Lettre du disque de destination (ex: "D")
    .OUTPUTS
        $true si assez d'espace, $false sinon
    #>
    param(
        [Parameter(Mandatory=$true)]
        [int64]$SourceSize,

        [Parameter(Mandatory=$true)]
        [string]$DestinationDrive
    )

    try {
        # Obtenir l'espace disponible sur le disque
        $destDrive = Get-PSDrive -Name $DestinationDrive[0] -PSProvider FileSystem -ErrorAction Stop
        $availableSpace = $destDrive.Free
        $totalSpace = $destDrive.Used + $destDrive.Free

        # Calculer pourcentage d'espace libre après opération
        $spaceAfterMove = $availableSpace - $SourceSize
        $percentFreeAfter = ($spaceAfterMove / $totalSpace) * 100

        # Afficher statistiques
        Show-InfoBox -Lines @(
            "VÉRIFICATION DE L'ESPACE DISQUE",
            "",
            "Disque destination  : $DestinationDrive:\",
            "Taille du profil    : $([Math]::Round($SourceSize / 1GB, 2)) GB",
            "Espace disponible   : $([Math]::Round($availableSpace / 1GB, 2)) GB",
            "Espace après copie  : $([Math]::Round($spaceAfterMove / 1GB, 2)) GB",
            "% libre après       : $([Math]::Round($percentFreeAfter, 1))%"
        ) -BorderColor "Cyan"

        # VÉRIFICATION 1 : Espace insuffisant
        if ($SourceSize -gt $availableSpace) {
            $missingSpace = $SourceSize - $availableSpace
            Show-InfoBox -Lines @(
                "ERREUR : ESPACE DISQUE INSUFFISANT",
                "",
                "Taille du profil    : $([Math]::Round($SourceSize / 1GB, 2)) GB",
                "Espace disponible   : $([Math]::Round($availableSpace / 1GB, 2)) GB",
                "Espace manquant     : $([Math]::Round($missingSpace / 1GB, 2)) GB",
                "",
                "SOLUTION :",
                "1. Libérez au moins $([Math]::Round($missingSpace / 1GB, 2)) GB sur le disque $DestinationDrive:\",
                "2. Ou choisissez un autre disque de destination",
                "3. Ou supprimez des fichiers inutiles du profil avant de déplacer"
            ) -BorderColor "Red"
            return $false
        }

        # VÉRIFICATION 2 : Avertissement si < 10% libre après
        if ($percentFreeAfter -lt 10) {
            Write-Host ""
            Write-StatusMessage "AVERTISSEMENT : Moins de 10% d'espace libre après l'opération ($([Math]::Round($percentFreeAfter, 1))%)" "Warning"
            Write-Host "Il est recommandé de garder au moins 10-15% d'espace libre pour les performances." -ForegroundColor Yellow
            Write-Host ""

            $continue = Read-Host "Voulez-vous continuer quand même ? (O/N)"
            if ($continue -ne 'O') {
                Write-StatusMessage "Opération annulée par l'utilisateur." "Info"
                return $false
            }
        }
        # VÉRIFICATION 3 : Avertissement si < 20% libre après
        elseif ($percentFreeAfter -lt 20) {
            Write-StatusMessage "Note : Il restera $([Math]::Round($percentFreeAfter, 1))% d'espace libre après l'opération." "Info"
        }

        Write-StatusMessage "Vérification espace : OK" "Success"
        return $true
    }
    catch {
        Write-StatusMessage "Erreur lors de la vérification d'espace : $($_.Exception.Message)" "Error"
        return $false
    }
}

# ------------------------------------------------------------------------------
# PATCH BUG-003 : Support Chemins Longs
# ------------------------------------------------------------------------------

function Convert-ToLongPath {
    <#
    .SYNOPSIS
        Convertit un chemin en format long path pour Windows
    .PARAMETER Path
        Chemin à convertir
    .OUTPUTS
        Chemin avec préfixe \\?\ si nécessaire
    #>
    param([string]$Path)

    # Si le chemin commence déjà par \\?\, ne rien faire
    if ($Path.StartsWith('\\?\')) {
        return $Path
    }

    # Convertir chemin relatif en absolu
    if (-not [System.IO.Path]::IsPathRooted($Path)) {
        $Path = [System.IO.Path]::GetFullPath($Path)
    }

    # Ajouter le préfixe pour chemins longs
    # Attention : robocopy n'aime pas \\?\UNC\, donc garder UNC paths normaux
    if ($Path.StartsWith('\\')) {
        # Chemin UNC (réseau), ne pas modifier
        return $Path
    }
    else {
        # Chemin local, ajouter \\?\
        return "\\?\$Path"
    }
}
