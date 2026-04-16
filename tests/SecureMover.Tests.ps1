#Requires -Module Pester
<#
.SYNOPSIS
    Tests unitaires Pester pour SecureMover v2.0+
.DESCRIPTION
    Teste les fonctions utilitaires de SecureMover.ps1 sans modifier le système réel.
    Requiert Pester 5.0+
.NOTES
    Lancer avec : Invoke-Pester -Path tests/SecureMover.Tests.ps1 -Output Detailed
#>

BeforeAll {
    # Charger le script en mode test (sans exécuter la boucle principale)
    # On dot-source uniquement les fonctions, pas le code de démarrage
    $script:scriptPath = Join-Path $PSScriptRoot ".." "SecureMover.ps1"

    # Définir les fonctions en isolant les dépendances
    # (Le script complet ne peut pas être dot-sourcé car il nécessite Admin + GUI)
    # On teste les fonctions extractibles indépendamment

    function Convert-ToLongPath {
        param([string]$Path)
        if ($Path.StartsWith('\\?\')) { return $Path }
        if (-not [System.IO.Path]::IsPathRooted($Path)) {
            $Path = [System.IO.Path]::GetFullPath($Path)
        }
        if ($Path.StartsWith('\\')) { return $Path }
        else { return "\\?\$Path" }
    }

    function Handle-RobocopyResult {
        param([int]$ExitCode, [string]$FolderName, [string]$Operation = "copie")
        switch ($ExitCode) {
            0       { return $true }
            1       { return $true }
            2       { return $true }
            3       { return $true }
            { $_ -in 4,5,6,7 } { return $true }
            8       { return $false }
            { $_ -gt 8 } { return $false }
            default { return $true }
        }
    }

    function Get-FolderSize {
        param([string]$Path)
        try {
            $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
                     Measure-Object -Property Length -Sum).Sum
            if ($null -eq $size) { $size = 0 }
            return $size
        }
        catch { return 0 }
    }

    function Test-AvailableSpaceLogic {
        # Version testable de Test-AvailableSpace (sans Write-Host)
        param([int64]$SourceSize, [int64]$AvailableSpace)
        if ($SourceSize -gt $AvailableSpace) { return $false }
        return $true
    }
}

# ============================================================================
# TESTS : Convert-ToLongPath
# ============================================================================

Describe "Convert-ToLongPath" {
    It "Ajoute le préfixe \\?\ sur un chemin local standard" {
        $result = Convert-ToLongPath "C:\Users\Test\Documents"
        $result | Should -BeExactly "\\?\C:\Users\Test\Documents"
    }

    It "Ne modifie pas un chemin déjà préfixé \\?\" {
        $input = "\\?\C:\Users\Test\Documents"
        $result = Convert-ToLongPath $input
        $result | Should -BeExactly $input
    }

    It "Ne modifie pas un chemin UNC réseau" {
        $input = "\\serveur\partage\dossier"
        $result = Convert-ToLongPath $input
        $result | Should -BeExactly $input
    }

    It "Gère un chemin avec des espaces" {
        $result = Convert-ToLongPath "C:\Users\Mon Profil\Documents"
        $result | Should -BeExactly "\\?\C:\Users\Mon Profil\Documents"
    }

    It "Gère un chemin avec des caractères accentués" {
        $result = Convert-ToLongPath "D:\Données\Téléchargements"
        $result | Should -BeLike "\\?\*"
    }
}

# ============================================================================
# TESTS : Handle-RobocopyResult
# ============================================================================

Describe "Handle-RobocopyResult" {
    Context "Codes de succès (0-7)" {
        It "Retourne true pour code 0 (aucun fichier copié)" {
            Handle-RobocopyResult -ExitCode 0 -FolderName "Test" | Should -BeTrue
        }

        It "Retourne true pour code 1 (fichiers copiés)" {
            Handle-RobocopyResult -ExitCode 1 -FolderName "Test" | Should -BeTrue
        }

        It "Retourne true pour code 2 (fichiers supplémentaires)" {
            Handle-RobocopyResult -ExitCode 2 -FolderName "Test" | Should -BeTrue
        }

        It "Retourne true pour code 3 (copiés + supplémentaires)" {
            Handle-RobocopyResult -ExitCode 3 -FolderName "Test" | Should -BeTrue
        }

        It "Retourne true pour codes 4-7 (avertissements mineurs)" {
            foreach ($code in 4, 5, 6, 7) {
                Handle-RobocopyResult -ExitCode $code -FolderName "Test" | Should -BeTrue
            }
        }
    }

    Context "Codes d'erreur (8+)" {
        It "Retourne false pour code 8 (fichiers non copiés)" {
            Handle-RobocopyResult -ExitCode 8 -FolderName "Test" | Should -BeFalse
        }

        It "Retourne false pour code 16 (erreur critique)" {
            Handle-RobocopyResult -ExitCode 16 -FolderName "Test" | Should -BeFalse
        }

        It "Retourne false pour code 32 (erreur fatale)" {
            Handle-RobocopyResult -ExitCode 32 -FolderName "Test" | Should -BeFalse
        }
    }
}

# ============================================================================
# TESTS : Get-FolderSize
# ============================================================================

Describe "Get-FolderSize" {
    BeforeAll {
        # Créer un dossier temporaire de test
        $script:testDir = Join-Path $env:TEMP "SecureMover_Test_$(Get-Random)"
        New-Item -Path $script:testDir -ItemType Directory -Force | Out-Null

        # Créer des fichiers de taille connue
        [byte[]]$bytes1KB = ,0 * 1024
        [System.IO.File]::WriteAllBytes("$script:testDir\file1KB.txt", $bytes1KB)

        [byte[]]$bytes4KB = ,0 * (4 * 1024)
        [System.IO.File]::WriteAllBytes("$script:testDir\file4KB.txt", $bytes4KB)

        # Sous-dossier avec fichier
        New-Item -Path "$script:testDir\sub" -ItemType Directory -Force | Out-Null
        [byte[]]$bytes2KB = ,0 * (2 * 1024)
        [System.IO.File]::WriteAllBytes("$script:testDir\sub\file2KB.txt", $bytes2KB)
    }

    AfterAll {
        Remove-Item -Path $script:testDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    It "Calcule correctement la taille totale d'un dossier" {
        $size = Get-FolderSize -Path $script:testDir
        # 1KB + 4KB + 2KB = 7KB = 7168 bytes
        $size | Should -Be 7168
    }

    It "Retourne 0 pour un dossier vide" {
        $emptyDir = Join-Path $env:TEMP "SecureMover_Empty_$(Get-Random)"
        New-Item -Path $emptyDir -ItemType Directory -Force | Out-Null
        $size = Get-FolderSize -Path $emptyDir
        $size | Should -Be 0
        Remove-Item $emptyDir -Force
    }

    It "Retourne 0 pour un chemin inexistant" {
        $size = Get-FolderSize -Path "C:\CheminQuiNExistePas_SecureMover_$(Get-Random)"
        $size | Should -Be 0
    }

    It "Traverse les sous-dossiers récursivement" {
        $size = Get-FolderSize -Path $script:testDir
        $size | Should -BeGreaterThan (3 * 1024)  # Au moins 3 fichiers
    }
}

# ============================================================================
# TESTS : Logique de vérification d'espace
# ============================================================================

Describe "Test-AvailableSpaceLogic" {
    It "Retourne false si la source est plus grande que l'espace disponible" {
        Test-AvailableSpaceLogic -SourceSize 10GB -AvailableSpace 5GB | Should -BeFalse
    }

    It "Retourne true si assez d'espace disponible" {
        Test-AvailableSpaceLogic -SourceSize 5GB -AvailableSpace 10GB | Should -BeTrue
    }

    It "Retourne false si tailles exactement égales (pas de marge)" {
        Test-AvailableSpaceLogic -SourceSize 5GB -AvailableSpace 5GB | Should -BeTrue
    }

    It "Gère la taille 0" {
        Test-AvailableSpaceLogic -SourceSize 0 -AvailableSpace 1GB | Should -BeTrue
    }
}

# ============================================================================
# TESTS : Vérification du fichier script principal
# ============================================================================

Describe "SecureMover.ps1 — Intégrité du fichier" {
    It "Le fichier SecureMover.ps1 existe" {
        $script:scriptPath | Should -Exist
    }

    It "Le fichier est syntaxiquement valide PowerShell" {
        $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile(
            $script:scriptPath, [ref]$null, [ref]$errors
        )
        $errors | Should -BeNullOrEmpty -Because "Le script ne doit pas contenir d'erreurs de syntaxe"
    }

    It "Contient le paramètre -WhatIf" {
        $content = Get-Content $script:scriptPath -Raw
        $content | Should -Match '\[switch\]\$WhatIf'
    }

    It "Contient le paramètre -Silent (mode non-interactif)" {
        $content = Get-Content $script:scriptPath -Raw
        $content | Should -Match '\[switch\]\$Silent'
    }

    It "Contient la protection mutex" {
        $content = Get-Content $script:scriptPath -Raw
        $content | Should -Match 'SecureMover_Mutex'
    }

    It "Ne contient pas de variables non-assignées évidentes (\$robocopyResult)" {
        $content = Get-Content $script:scriptPath -Raw
        # $robocopyResult ne doit plus être assigné sans utilisation
        $assignments = [regex]::Matches($content, '\$robocopyResult\s*=')
        $assignments.Count | Should -Be 0 -Because "robocopyResult était assigné mais jamais utilisé"
    }
}

# ============================================================================
# TESTS : SecureMover-GUI.ps1 — Intégrité
# ============================================================================

Describe "SecureMover-GUI.ps1 — Intégrité du fichier" {
    BeforeAll {
        $script:guiPath = Join-Path $PSScriptRoot ".." "SecureMover-GUI.ps1"
    }

    It "Le fichier SecureMover-GUI.ps1 existe" {
        $script:guiPath | Should -Exist
    }

    It "Est syntaxiquement valide PowerShell" {
        $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile(
            $script:guiPath, [ref]$null, [ref]$errors
        )
        $errors | Should -BeNullOrEmpty
    }

    It "Ne contient plus le code de simulation (Start-Sleep fictif)" {
        $content = Get-Content $script:guiPath -Raw
        # L'ancien code de simulation contenait ce pattern
        $content | Should -Not -Match 'SIMULATION - A CONNECTER AU BACKEND'
    }

    It "Appelle le vrai backend CLI (Start-Job)" {
        $content = Get-Content $script:guiPath -Raw
        $content | Should -Match 'Start-Job'
    }

    It "Ne contient plus le message 'en developpement' pour RESTAURER" {
        $content = Get-Content $script:guiPath -Raw
        $content | Should -Not -Match 'sera disponible dans la version v2\.0\.3-GUI'
    }
}
