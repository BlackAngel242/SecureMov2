# Bug Tracker - SecureMover v2.0

**Responsable** : Alex Chen (Bug Manager)
**Date de Creation** : 2025-01-15
**Derniere Mise a Jour** : 2025-11-01
**Statut** : EN COURS DE RESOLUTION

---

## 🔴 Bugs Critiques (P0) - BLOQUANTS

**Nombre** : 0 ✅

*(Aucun bug critique actuellement)*

---

## 🟠 Bugs Majeurs (P1) - À CORRIGER IMMÉDIATEMENT

**Nombre** : 3 (6 initiaux, 3 résolus en v2.0.2)

---

### BUG-003 : Chemins >260 caracteres non supportes ✅

**Priorite** : P1 (MAJEUR)
**Status** : RESOLU (v2.0.2 - 2025-11-01)
**Reporter** : Sarah Chen (QA)
**Date** : 2025-01-15
**Assigne a** : Lead Developer
**Resolu par** : PATCH BUG-003 (v2.0.2)

**Description** :
Robocopy echoue sur les fichiers avec chemins >260 caracteres.

**Impact** :
- Echec de copie pour certains fichiers
- Utilisateurs avec structures profondes affectes
- Fichiers perdus ou inaccessibles

**Solution Proposee** :
Utiliser prefixe `\\?\` pour chemins longs dans Robocopy

**Code Fix** :
```powershell
# AVANT
$robocopyResult = robocopy $sourceFullPath $destFullPath /E /MOVE /NJH /NJS

# APRÈS
$longPathSource = "\\?\$($sourceFullPath.TrimStart('\'))"
$longPathDest = "\\?\$($destFullPath.TrimStart('\'))"
$robocopyResult = robocopy $longPathSource $longPathDest /E /MOVE /NJH /NJS
```

**Test Plan** :
- Créer fichier avec chemin >260 caractères
- Tester déplacement
- Vérifier succès

---

### BUG-004 : Operations simultanees non protegees

**Priorite** : P1 (MAJEUR)
**Status** : CONNU
**Reporter** : Sarah Chen (QA)
**Date** : 2025-01-15
**Assigne a** : Lead Developer
**ETA** : v2.1

**Description** :
Aucune protection contre le lancement de 2 instances simultanees du script.

**Impact** :
- Risque de corruption de donnees
- Conflits de fichiers
- Registre dans état incohérent

**Solution Proposee** :
Implementer mutex ou fichier lock pour exclusion mutuelle

**Code Fix** :
```powershell
# Au début du script
$mutexName = "Global\SecureMover_Mutex"
$mutex = New-Object System.Threading.Mutex($false, $mutexName)

if (-not $mutex.WaitOne(0)) {
    Write-Host "[ERREUR] Une instance de SecureMover est déjà en cours d'exécution." -ForegroundColor Red
    Write-Host "Veuillez attendre que l'autre instance se termine." -ForegroundColor Yellow
    exit 1
}

try {
    # Script principal
}
finally {
    $mutex.ReleaseMutex()
    $mutex.Dispose()
}
```

---

### UX-002 : Pas de verification espace disque disponible ✅

**Priorite** : P1 (MAJEUR) - CRITIQUE
**Status** : RESOLU (v2.0.2 - 2025-11-01)
**Reporter** : Bug Manager (Analyse PSScriptAnalyzer)
**Date** : 2025-11-01
**Assigne a** : Lead Developer
**Resolu par** : PATCH UX-002 (v2.0.2)

**Description** :
Le script ne vérifie pas si la destination a assez d'espace disque disponible avant
de commencer le déplacement.

**Impact** :
- Déplacement peut échouer à mi-parcours si disque plein
- Fichiers dans état incohérent (certains déplacés, d'autres non)
- Risque de PERTE DE DONNÉES

**Solution Proposee** :
Ajouter fonction Get-FolderSize et vérifier espace avant déplacement

**Code Fix** :
```powershell
function Get-FolderSize {
    param([string]$Path)
    $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum).Sum
    return $size
}

# Dans Move-UserProfile, avant le déplacement :
$sourceSize = Get-FolderSize -Path $selectedProfile.Path
$destDrive = Get-PSDrive $destinationDrive[0]
$availableSpace = $destDrive.Free

if ($sourceSize -gt $availableSpace) {
    Show-InfoBox -Lines @(
        "ESPACE DISQUE INSUFFISANT",
        "",
        "Taille du profil    : $([Math]::Round($sourceSize / 1GB, 2)) GB",
        "Espace disponible   : $([Math]::Round($availableSpace / 1GB, 2)) GB",
        "Espace manquant     : $([Math]::Round(($sourceSize - $availableSpace) / 1GB, 2)) GB"
    ) -BorderColor "Red"
    return
}
```

**Test Plan** :
- Tester avec disque ayant peu d'espace
- Vérifier blocage avant démarrage
- Vérifier message clair

---

### UX-008 : Pas de mode simulation (WhatIf) ✅

**Priorite** : P1 (MAJEUR)
**Status** : RESOLU (v2.0.2 - 2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**Assigne a** : Lead Developer
**Resolu par** : PATCH UX-008 (v2.0.2)

**Description** :
Impossible de simuler l'opération sans l'exécuter réellement.
Utilisateur ne peut pas tester ce qui serait fait avant de s'engager.

**Impact** :
- Pas de possibilité de "dry run"
- Utilisateur doit faire confiance aveuglément
- Pas de support du paramètre standard PowerShell `-WhatIf`

**Solution Proposee** :
Ajouter support paramètre -WhatIf

**Code Fix** :
```powershell
param(
    [switch]$NoExit,
    [switch]$WhatIf
)

function Move-UserProfile {
    if ($WhatIf) {
        Show-InfoBox -Lines @(
            "MODE SIMULATION (WhatIf)",
            "",
            "Voici ce qui SERAIT fait (sans modifications réelles) :",
            "1. Création dossier : $destinationPath",
            "2. Déplacement des 6 dossiers utilisateur",
            "3. Mise à jour du registre",
            "4. Sauvegarde registre",
            "",
            "Aucune modification n'a été effectuée."
        ) -BorderColor "Yellow"
        return
    }
    # Opération réelle...
}
```

---

### UX-010 : Chemins longs non gérés (Duplicate de BUG-003)

**Voir BUG-003**

---

### UX-011 : Pas de rollback automatique en cas d'échec ⚠️⚠️⚠️

**Priorite** : P1 (MAJEUR) - CRITIQUE
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**Assigne a** : Lead Developer
**ETA** : v2.1 (complexe, 3h de dev)

**Description** :
Si le déplacement échoue à mi-parcours (disque plein, erreur réseau, etc.),
les fichiers sont dans un état incohérent et aucun rollback automatique n'est effectué.

**Impact** :
- RISQUE CRITIQUE DE PERTE DE DONNÉES
- Certains dossiers déplacés, d'autres non
- Registre partiellement modifié
- Utilisateur peut perdre accès à ses fichiers

**Solution Proposee** :
Implémenter transaction-like behavior avec rollback automatique

**Code Fix** :
```powershell
function Move-UserProfile {
    $movedFolders = @()
    $registryChanges = @()

    try {
        foreach ($folder in $foldersToMove.Keys) {
            # Déplacer...
            $movedFolders += @{
                Name = $folder
                Source = $sourceFullPath
                Dest = $destFullPath
            }

            # Mise à jour registre...
            $registryChanges += @{
                Name = $foldersToMove[$folder]
                OldValue = $oldValue
                NewValue = $destFullPath
            }
        }

        Write-StatusMessage "Opération terminée avec succès" "Success"
    }
    catch {
        Write-StatusMessage "ERREUR DÉTECTÉE - Rollback en cours..." "Error"

        # ROLLBACK : Remettre les dossiers
        foreach ($folder in $movedFolders) {
            Write-StatusMessage "Restauration de $($folder.Name)..." "Progress"
            robocopy $folder.Dest $folder.Source /E /MOVE /NJH /NJS | Out-Null
        }

        # ROLLBACK : Restaurer le registre
        if ($registryBackupPath) {
            Restore-RegistrySettings -BackupPath $registryBackupPath
        }

        Write-StatusMessage "Rollback terminé - Système restauré" "Success"
        throw $_
    }
}
```

**Test Plan** :
- Simuler échec (débrancher disque externe)
- Vérifier rollback automatique
- Vérifier état cohérent après rollback

---

## 🟡 Bugs Moyens (P2) - Pour v2.1

**Nombre** : 9

---

### BUG-002 : Verification fichier .reg avant restauration

**Priorite** : P2 (MOYEN)
**Status** : IDENTIFIE
**Reporter** : Sarah Chen (QA)
**Date** : 2025-01-15
**Assigne a** : Lead Developer
**ETA** : v2.1

**Description** :
Lors de la restauration, le script n'affiche pas d'avertissement clair si aucune
sauvegarde .reg n'est disponible.

**Impact** :
- Risque de references incorrectes
- Experience utilisateur degradee

**Solution Proposee** :
```powershell
# Dans Restore-UserProfile
$backupFiles = Get-ChildItem -Path . -Filter "SecureMover_Backup_*.reg" | Sort-Object LastWriteTime -Descending

if ($backupFiles.Count -eq 0) {
    Show-InfoBox -Lines @(
        "AVERTISSEMENT : Aucune sauvegarde du registre trouvée",
        "",
        "Il est recommandé d'avoir une sauvegarde du registre avant de restaurer.",
        "Voulez-vous continuer quand même ? (risqué)"
    ) -BorderColor "Yellow"

    $choice = Read-Host "(O/N)"
    if ($choice -ne 'O') {
        return
    }
}
```

---

### BUG-PSA-003 : Fonctions sans ShouldProcess

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01
**Assigne a** : Lead Developer
**ETA** : v2.1

**Description** :
4 fonctions modifient l'état du système mais ne supportent pas `-WhatIf` et `-Confirm` :
- Set-ConsoleWindowSize
- Set-ConsoleWindowPosition
- Start-OperationWithAnimation
- Update-WindowsReferences

**Impact** :
- Pas de support des best practices PowerShell
- Pas de confirmation possible

**Solution** :
Ajouter `[CmdletBinding(SupportsShouldProcess=$true)]`

---

### BUG-PSA-007 : BOM Encoding peut-être manquant

**Priorite** : P2 (MOYEN)
**Status** : À VÉRIFIER
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01

**Description** :
PSScriptAnalyzer ne détecte pas le BOM UTF-8.

**Solution** :
Vérifier avec `file SecureMover.ps1` et réenregistrer avec UTF-8 with BOM si nécessaire.

---

### UX-001 : Messages d'erreur peu détaillés

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.1

**Description** :
Messages d'erreur manquent de détails pour aider l'utilisateur.

**Amélioration** :
Ajouter solutions et instructions dans tous les messages d'erreur.

---

### UX-003 : Pas de barre de progression globale

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.1

**Description** :
Utilisateur voit progression par dossier, mais pas progression globale (2/6, 5/6, etc.)

**Solution** :
Ajouter compteur "Dossier 3/6 (50%)"

---

### UX-005 : Confirmations trop nombreuses

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.1

**Description** :
3 confirmations pour une seule opération = frustrant

**Solution** :
Réduire à 1 seule confirmation finale avec récapitulatif complet

---

### UX-006 : Messages multilingues incohérents

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.1

**Description** :
Mélange de français et anglais dans les messages.

**Solution** :
Audit complet et harmonisation

---

### UX-007 : Pas de résumé post-opération

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.1

**Description** :
Après opération, pas de résumé clair de ce qui a été fait.

**Solution** :
Ajouter InfoBox avec résumé complet + prochaines étapes

---

### UX-009 : Logs peu détaillés

**Priorite** : P2 (MOYEN)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.1

**Description** :
Fichier SecureMover.log manque d'informations pour debug.

**Solution** :
Améliorer logging avec timestamps, tailles, vitesses, codes erreur

---

## 🔵 Bugs Mineurs (P3) - Polish / Nice to Have

**Nombre** : 7

---

### BUG-PSA-001 : Variable $isModernTerminal non utilisée

**Priorite** : P3 (MINEUR)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01
**Ligne** : 148

**Description** :
Variable assignée mais jamais utilisée.

**Solution** :
Utiliser la variable pour conditionner comportements OU ne pas assigner

**Effort** : 5 minutes

---

### BUG-PSA-002 : Variable $robocopyResult non utilisée (3 occurrences)

**Priorite** : P3 (MINEUR)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01
**Lignes** : 1187, 1351, 1493

**Description** :
Variable assignée mais jamais utilisée (seul $LASTEXITCODE est utilisé).

**Solution** :
```powershell
# Option 1 : Ne pas assigner
robocopy $source $dest /E /MOVE /NJH /NJS | Out-Null
$exitCode = $LASTEXITCODE

# Option 2 : Utiliser pour logging
$robocopyResult = robocopy $source $dest /E /MOVE /NJH /NJS
Write-Log "Robocopy: $robocopyResult"
```

**Effort** : 10 minutes

---

### BUG-PSA-004 : Noms de fonctions pluriels (6 fonctions)

**Priorite** : P3 (MINEUR)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01

**Description** :
PowerShell recommande noms singuliers pour cohérence.

**Fonctions concernées** :
- Test-WindowDimensions → Test-WindowDimension
- Test-AdminPrivileges → Test-AdminPrivilege
- Get-UserProfiles → Get-UserProfile
- Backup-RegistrySettings → Backup-RegistrySetting
- Restore-RegistrySettings → Restore-RegistrySetting
- Update-WindowsReferences → Update-WindowsReference

**Solution** :
Renommer en v2.2 avec alias pour compatibilité

**Effort** : 30 minutes

---

### BUG-PSA-005 : Verbe non approuvé (Handle-)

**Priorite** : P3 (MINEUR)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01
**Ligne** : 914

**Description** :
`Handle-RobocopyResult` utilise verbe non approuvé.

**Solution** :
Renommer en `Resolve-RobocopyResult` ou `Test-RobocopyResult`

**Effort** : 5 minutes

---

### UX-004 : Pas d'estimation temps restant

**Priorite** : P3 (MINEUR)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.2

**Description** :
Pas d'indication du temps restant pour les grosses opérations.

**Solution** :
Calculer temps moyen par dossier et estimer temps restant

**Effort** : 1 heure

---

### UX-012 : Accessibilité couleurs (daltoniens)

**Priorite** : P3 (MINEUR)
**Status** : NOUVEAU (2025-11-01)
**Reporter** : Bug Manager
**Date** : 2025-11-01
**ETA** : v2.2

**Description** :
Utilisation de couleurs seules pour communiquer l'état.

**Solution** :
Déjà partiellement implémenté avec icônes `[OK]`, `[ERREUR]`.
Vérifier cohérence partout.

**Effort** : 30 minutes

---

## ✅ Bugs Resolus

### BUG-001 : Erreur encodage emojis ✅

**Priorite** : P0 (CRITIQUE)
**Status** : RÉSOLU
**Date Resolution** : 2025-01-15 14:50
**Version** : v2.0.1
**Reporter** : Test automatique
**Resolveur** : Bug Manager

**Description** :
Emojis Unicode causaient erreur de parsing PowerShell.

**Fix** :
Remplacement emojis par ASCII ([OK], [ERREUR], etc.)

**Test** : VERIFIE ET FONCTIONNE

---

## 🚫 Bugs Rejetes / Won't Fix

### BUG-PSA-006 : Utilisation de Write-Host

**Priorite** : N/A
**Status** : WON'T FIX
**Reporter** : PSScriptAnalyzer
**Date** : 2025-11-01

**Raison** :
SecureMover est un script interactif (pas un module).
`Write-Host` est intentionnel pour l'UX (couleurs, formatage).
Acceptable depuis PowerShell 5.0.

---

## 📊 Statistiques Mises à Jour

| Categorie | Nombre |
|-----------|--------|
| **Total Bugs** | 22 |
| **P0 (Critique)** | 0 ✅ |
| **P1 (Majeur)** | 6 🔴 |
| **P2 (Moyen)** | 9 🟡 |
| **P3 (Mineur)** | 7 🔵 |
| **Resolus** | 1 ✅ |
| **Won't Fix** | 1 |
| **En cours** | 0 |
| **A faire** | 21 |
| **Taux Resolution** | 4.5% |

---

## 🎯 Prochaines Actions

### IMMEDIAT (Cette Semaine) - v2.0.2

1. ✅ Analyse PSScriptAnalyzer complète - FAIT
2. ✅ Documentation de tous les bugs - FAIT
3. 🔴 Corriger UX-002 (vérification espace disque) - EN COURS
4. 🔴 Corriger BUG-003 (chemins longs)
5. 🔴 Corriger UX-008 (mode WhatIf)
6. 🔴 Tester et valider les corrections
7. 🔴 Release v2.0.2 (patch critique)

### COURT TERME (2-3 semaines) - v2.1

8. Corriger tous les bugs P2
9. Implémenter UX-011 (rollback automatique)
10. Implémenter BUG-004 (mutex)
11. Améliorer UX globale
12. Tests automatisés (Pester)

### MOYEN TERME (1-2 mois) - v2.2

13. Corriger tous les bugs P3
14. Polish et professionnalisation
15. CI/CD
16. Publication PowerShell Gallery

---

## 📈 Évolution du Taux de Résolution

| Date | Bugs Totaux | Résolus | Taux |
|------|-------------|---------|------|
| 2025-01-15 | 4 | 1 | 25% |
| 2025-11-01 | 22 | 1 | 4.5% |
| 2025-11-08 (prévu) | 22 | 7 | 32% |
| 2025-12-01 (prévu) | 22 | 16 | 73% |

---

## 🔗 Documents Associés

- **RAPPORT_ANALYSE_CODE.md** - Analyse complète PSScriptAnalyzer
- **STRUCTURE_EQUIPE_RECOMMANDEE.md** - Équipe nécessaire pour résolutions
- **TODO_NEXT.md** - Plan d'action détaillé
- **JOURNAL_DE_BORD.txt** - Historique des sessions

---

**Responsable** : Alex Chen (Bug Manager)
**Derniere Mise a Jour** : 2025-11-01 13:00:00 UTC
**Prochaine Revue** : 2025-11-08 (après v2.0.2)
