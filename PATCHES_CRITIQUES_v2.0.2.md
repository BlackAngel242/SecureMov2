# Patches Critiques pour SecureMover v2.0.2

**Date** : 2025-11-01
**Auteur** : Lead Developer + Bug Manager
**Version Cible** : v2.0.2 (Patch Release)
**Priorité** : HAUTE - Bugs P1

---

## 📋 Vue d'Ensemble

Ce document contient les patches pour corriger les 3 bugs critiques P1 les plus urgents et les plus sûrs à implémenter :

1. ✅ **UX-002** : Vérification espace disque disponible (CRITIQUE)
2. ✅ **BUG-003** : Support des chemins >260 caractères
3. ✅ **UX-008** : Mode simulation (WhatIf)

**Bugs P1 reportés à v2.1** (trop complexes pour patch rapide) :
- ⏸️ **UX-011** : Rollback automatique (3h de dev, tests approfondis requis)
- ⏸️ **BUG-004** : Mutex protection (peut causer problèmes système)

---

## 🔧 PATCH #1 : Vérification Espace Disque (UX-002)

**Priorité** : P1 - CRITIQUE ⚠️⚠️
**Effort** : 30 minutes
**Risque** : Faible (ajout de code, pas de modification existante)

### Problème

Le script ne vérifie pas si assez d'espace disponible avant de déplacer.
Risque : Déplacement échoue à mi-parcours → données incohérentes.

### Solution

Ajouter fonction `Get-FolderSize` et vérifier l'espace avant démarrage.

### Code à Ajouter

```powershell
# =============================================================================
# PATCH UX-002 : Vérification Espace Disque
# Ajouter cette fonction APRÈS la ligne ~910 (avant Move-UserProfile)
# =============================================================================

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
```

### Modifications dans Move-UserProfile

```powershell
# =============================================================================
# Dans la fonction Move-UserProfile (autour de la ligne 1113)
# Ajouter APRÈS la sélection de destination, AVANT la confirmation finale
# =============================================================================

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

    # ============== NOUVEAU CODE UX-002 ==============
    # Vérification de l'espace disque disponible
    Write-Host ""
    Write-StatusMessage "Vérification de l'espace disque disponible..." "Progress"

    $sourceSize = Get-FolderSize -Path $selectedProfile.Path

    if ($sourceSize -gt 0) {
        $spaceCheckResult = Test-AvailableSpace -SourceSize $sourceSize -DestinationDrive $destinationDrive

        if (-not $spaceCheckResult) {
            Write-StatusMessage "Opération annulée : espace disque insuffisant." "Error"
            return
        }
    }
    else {
        Write-StatusMessage "Avertissement : Impossible de calculer la taille du profil. Vérification d'espace ignorée." "Warning"
    }
    # ============== FIN NOUVEAU CODE ==============

    # Confirmation avec design amélioré (CODE EXISTANT, ne pas modifier)
    Write-Host ""
    Show-InfoBox -Lines @(
        "RÉCAPITULATIF DE L'OPÉRATION",
        "",
        "Profil sélectionné   : $($selectedProfile.Name)",
        "Dossier source       : $($selectedProfile.Path)",
        "Dossier de destination : $destinationPath",
        # ============== NOUVEAU : Ajout taille ==============
        "Taille du profil     : $([Math]::Round($sourceSize / 1GB, 2)) GB",
        # ============== FIN NOUVEAU ==============
        "",
        "ATTENTION : L'action est sur le point de commencer et ne pourra pas être interrompue."
    ) -BorderColor "Cyan"

    # ... reste du code existant sans modification ...
}
```

### Tests Requis

```powershell
# Test 1 : Profil normal avec assez d'espace
# Résultat attendu : Opération continue normalement

# Test 2 : Disque presque plein (< taille profil)
# Résultat attendu : Erreur affichée, opération bloquée

# Test 3 : Disque avec < 10% espace libre après
# Résultat attendu : Avertissement, demande confirmation

# Test 4 : Profil vide ou très petit
# Résultat attendu : Vérification OK, opération continue
```

---

## 🔧 PATCH #2 : Support Chemins Longs (BUG-003)

**Priorité** : P1 - MAJEUR
**Effort** : 20 minutes
**Risque** : Faible (modification ciblée dans robocopy)

### Problème

Robocopy échoue sur fichiers avec chemins >260 caractères (limite Windows classique).

### Solution

Utiliser le préfixe `\\?\` pour activer le support des chemins longs Windows.

### Code à Modifier

```powershell
# =============================================================================
# PATCH BUG-003 : Support Chemins Longs
# =============================================================================

# Ajouter cette fonction HELPER
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

# ====================================================================
# MODIFIER dans Move-UserProfile (autour de la ligne 1187)
# Rechercher : robocopy $sourceFullPath $destFullPath
# Remplacer par le code ci-dessous
# ====================================================================

# AVANT (ligne ~1187)
$robocopyResult = robocopy $sourceFullPath $destFullPath /E /MOVE /NJH /NJS
$exitCode = $LASTEXITCODE

# APRÈS
# Support des chemins longs (>260 caractères) - Patch BUG-003
$longPathSource = Convert-ToLongPath -Path $sourceFullPath
$longPathDest = Convert-ToLongPath -Path $destFullPath

Write-Log "Robocopy: $longPathSource -> $longPathDest"
robocopy $longPathSource $longPathDest /E /MOVE /NJH /NJS | Out-Null
$exitCode = $LASTEXITCODE


# ====================================================================
# MODIFIER dans Restore-UserProfile (autour de la ligne 1351)
# ====================================================================

# AVANT (ligne ~1351)
$robocopyResult = robocopy $currentPath $originalPath /E /MOVE /NJH /NJS
$exitCode = $LASTEXITCODE

# APRÈS
# Support des chemins longs - Patch BUG-003
$longPathCurrent = Convert-ToLongPath -Path $currentPath
$longPathOriginal = Convert-ToLongPath -Path $originalPath

Write-Log "Robocopy (restore): $longPathCurrent -> $longPathOriginal"
robocopy $longPathCurrent $longPathOriginal /E /MOVE /NJH /NJS | Out-Null
$exitCode = $LASTEXITCODE


# ====================================================================
# MODIFIER dans Backup-UserProfile (autour de la ligne 1493)
# ====================================================================

# AVANT (ligne ~1493)
$robocopyResult = robocopy $currentPath $backupFolderPath /E /COPY:DAT /NJH /NJS
$exitCode = $LASTEXITCODE

# APRÈS
# Support des chemins longs - Patch BUG-003
$longPathCurrent = Convert-ToLongPath -Path $currentPath
$longPathBackup = Convert-ToLongPath -Path $backupFolderPath

Write-Log "Robocopy (backup): $longPathCurrent -> $longPathBackup"
robocopy $longPathCurrent $longPathBackup /E /COPY:DAT /NJH /NJS | Out-Null
$exitCode = $LASTEXITCODE
```

### Tests Requis

```powershell
# Test 1 : Créer fichier avec chemin très long
New-Item -Path "C:\Users\Test\Documents\Dossier1\Dossier2\...\FichierAvecNomTresLongEtCheminDepasse260Caracteres.txt" -ItemType File -Force

# Test 2 : Tester déplacement
# Résultat attendu : Succès même avec chemin > 260 caractères

# Test 3 : Vérifier chemins UNC non cassés
# Résultat attendu : Chemins réseau fonctionnent toujours
```

---

## 🔧 PATCH #3 : Mode Simulation WhatIf (UX-008)

**Priorité** : P1 - MAJEUR
**Effort** : 45 minutes
**Risque** : Faible (ajout paramètre, pas de modification logique)

### Problème

Impossible de simuler l'opération sans l'exécuter réellement.
Utilisateurs doivent faire confiance aveuglément.

### Solution

Ajouter support du paramètre `-WhatIf` standard PowerShell.

### Code à Ajouter

```powershell
# =============================================================================
# PATCH UX-008 : Mode Simulation (WhatIf)
# =============================================================================

# ====================================================================
# MODIFIER les paramètres du script (ligne 17)
# ====================================================================

# AVANT
param(
    [switch]$NoExit
)

# APRÈS
param(
    [switch]$NoExit,
    [switch]$WhatIf  # Nouveau paramètre pour simulation
)

# ====================================================================
# AJOUTER message d'info si mode WhatIf activé (après ligne 148)
# ====================================================================

# Initialisation de l'environnement d'exécution
$isModernTerminal = Initialize-ExecutionEnvironment

# ============== NOUVEAU CODE ==============
# Afficher avertissement si mode simulation
if ($WhatIf) {
    Write-Host ""
    Show-InfoBox -Lines @(
        "MODE SIMULATION ACTIVÉ (WhatIf)",
        "",
        "Ce script s'exécute en mode simulation.",
        "AUCUNE modification ne sera effectuée sur votre système.",
        "",
        "Vous verrez ce qui SERAIT fait, sans que cela ne soit réellement exécuté.",
        "",
        "Pour exécuter réellement, relancez sans le paramètre -WhatIf"
    ) -BorderColor "Yellow"
    Write-Host ""
}
# ============== FIN NOUVEAU CODE ==============


# ====================================================================
# MODIFIER fonction Move-UserProfile (début de la fonction, ligne ~1113)
# ====================================================================

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

    # Vérification espace (patch UX-002)
    # ... code existant ...

    # ============== NOUVEAU CODE UX-008 ==============
    # Si mode WhatIf, afficher simulation et sortir
    if ($WhatIf) {
        Write-Host ""
        Show-InfoBox -Lines @(
            "SIMULATION : DÉPLACEMENT DE PROFIL",
            "",
            "Voici ce qui SERAIT fait (aucune modification réelle) :",
            "",
            "1. CRÉATION DOSSIER",
            "   $destinationPath",
            "",
            "2. DÉPLACEMENT DE 6 DOSSIERS UTILISATEUR :",
            "   • Desktop    : $($selectedProfile.Path)\Desktop",
            "   • Documents  : $($selectedProfile.Path)\Documents",
            "   • Downloads  : $($selectedProfile.Path)\Downloads",
            "   • Music      : $($selectedProfile.Path)\Music",
            "   • Pictures   : $($selectedProfile.Path)\Pictures",
            "   • Videos     : $($selectedProfile.Path)\Videos",
            "",
            "3. MISE À JOUR DU REGISTRE",
            "   Clé : HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders",
            "   6 valeurs seraient modifiées",
            "",
            "4. SAUVEGARDE DU REGISTRE",
            "   Fichier : SecureMover_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg",
            "",
            "5. MISE À JOUR RÉFÉRENCES WINDOWS",
            "   • Rafraîchissement de l'Explorateur",
            "   • Notification système des changements",
            "",
            "=== FIN DE LA SIMULATION ===",
            "",
            "Aucune modification n'a été effectuée.",
            "Pour exécuter réellement, relancez sans -WhatIf"
        ) -BorderColor "Yellow"
        Write-Host ""
        Write-StatusMessage "Mode simulation terminé." "Info"
        return
    }
    # ============== FIN NOUVEAU CODE ==============

    # Confirmation et exécution réelle (CODE EXISTANT, ne pas modifier)
    # ...
}


# ====================================================================
# MODIFIER fonction Restore-UserProfile (ligne ~1258)
# ====================================================================

function Restore-UserProfile {
    Show-SectionHeader "RESTAURATION DE PROFIL UTILISATEUR"

    # ... code sélection profil ...

    # ============== NOUVEAU CODE UX-008 ==============
    if ($WhatIf) {
        Write-Host ""
        Show-InfoBox -Lines @(
            "SIMULATION : RESTAURATION DE PROFIL",
            "",
            "Voici ce qui SERAIT fait :",
            "",
            "1. Restauration des dossiers vers C:\Users\$($selectedProfile.Name)",
            "2. Restauration du registre depuis le dernier backup",
            "3. Mise à jour des références Windows",
            "",
            "Aucune modification n'a été effectuée (mode simulation)."
        ) -BorderColor "Yellow"
        Write-Host ""
        return
    }
    # ============== FIN NOUVEAU CODE ==============

    # ... reste du code ...
}


# ====================================================================
# MODIFIER fonction Backup-UserProfile (ligne ~1401)
# ====================================================================

function Backup-UserProfile {
    Show-SectionHeader "SAUVEGARDE DE PROFIL UTILISATEUR"

    # ... code sélection ...

    # ============== NOUVEAU CODE UX-008 ==============
    if ($WhatIf) {
        Write-Host ""
        Show-InfoBox -Lines @(
            "SIMULATION : SAUVEGARDE DE PROFIL",
            "",
            "Voici ce qui SERAIT fait :",
            "",
            "1. Copie du profil vers : $destinationPath",
            "2. Création d'un fichier d'information",
            "3. Sauvegarde du registre",
            "",
            "Aucune modification n'a été effectuée (mode simulation)."
        ) -BorderColor "Yellow"
        Write-Host ""
        return
    }
    # ============== FIN NOUVEAU CODE ==============

    # ... reste du code ...
}
```

### Tests Requis

```powershell
# Test 1 : Lancer en mode WhatIf
.\SecureMover.ps1 -WhatIf

# Résultat attendu :
# - Message d'avertissement au démarrage
# - Simulation affichée sans aucune modification
# - Pas de fichiers déplacés
# - Pas de registre modifié

# Test 2 : Lancer normalement
.\SecureMover.ps1

# Résultat attendu :
# - Opération normale (modifications réelles)

# Test 3 : Vérifier chaque fonction (Move, Restore, Backup) en WhatIf
# Résultat attendu : Toutes affichent simulation
```

---

## 📦 Instructions d'Application

### Méthode Manuelle (Recommandée pour test)

1. **Créer une sauvegarde**
   ```powershell
   Copy-Item SecureMover.ps1 SecureMover.ps1.backup
   ```

2. **Ouvrir SecureMover.ps1 dans VS Code/Cursor**

3. **Appliquer les patches dans l'ordre** :
   - Patch #1 (UX-002) : Ajouter fonctions Get-FolderSize et Test-AvailableSpace
   - Patch #2 (BUG-003) : Modifier les 3 appels robocopy
   - Patch #3 (UX-008) : Ajouter paramètre -WhatIf et conditions

4. **Vérifier l'encodage** : UTF-8 with BOM

5. **Sauvegarder**

6. **Tester chaque patch individuellement**

### Méthode Automatisée (Future)

Un script `Apply-Patches.ps1` sera créé pour automatiser l'application.

---

## ✅ Checklist de Validation

Avant de marquer les bugs comme résolus :

### Patch #1 (UX-002)
- [ ] Fonction Get-FolderSize ajoutée
- [ ] Fonction Test-AvailableSpace ajoutée
- [ ] Vérification intégrée dans Move-UserProfile
- [ ] Testé avec disque plein → Erreur affichée
- [ ] Testé avec espace OK → Opération continue
- [ ] Message clair et informatif

### Patch #2 (BUG-003)
- [ ] Fonction Convert-ToLongPath ajoutée
- [ ] 3 appels robocopy modifiés (Move, Restore, Backup)
- [ ] Testé avec chemin > 260 caractères → Succès
- [ ] Testé avec chemin normal → Aucune régression
- [ ] Chemins UNC (réseau) toujours fonctionnels

### Patch #3 (UX-008)
- [ ] Paramètre -WhatIf ajouté
- [ ] Message d'avertissement au démarrage
- [ ] Simulation dans Move-UserProfile
- [ ] Simulation dans Restore-UserProfile
- [ ] Simulation dans Backup-UserProfile
- [ ] Testé : aucune modification en mode -WhatIf
- [ ] Testé : opération normale sans -WhatIf

---

## 📊 Impact Attendu

### Avant Patches

| Métrique | Valeur |
|----------|--------|
| Bugs P0 | 0 |
| Bugs P1 | 6 |
| Risque perte données | ÉLEVÉ (UX-002, BUG-003) |
| Confiance utilisateur | MOYENNE |

### Après Patches

| Métrique | Valeur |
|----------|--------|
| Bugs P0 | 0 |
| Bugs P1 | 3 (-50%) ✅ |
| Risque perte données | FAIBLE ✅ |
| Confiance utilisateur | HAUTE ✅ |

---

## 🚀 Prochaines Étapes

Après application de ces patches :

1. ✅ Tester en conditions réelles
2. ✅ Mettre à jour BUGS.md (marquer UX-002, BUG-003, UX-008 comme RÉSOLUS)
3. ✅ Mettre à jour VERSION.txt (2.0.1 → 2.0.2)
4. ✅ Mettre à jour CHANGELOG.md (ajouter v2.0.2)
5. ✅ Créer commit Git
6. ✅ Release v2.0.2

Puis planifier v2.1 avec :
- UX-011 : Rollback automatique
- BUG-004 : Mutex protection
- Tous les bugs P2

---

**Document Créé Par** : Lead Developer
**Validé Par** : Bug Manager (Alex Chen)
**Date** : 2025-11-01
**Version** : 1.0

---
