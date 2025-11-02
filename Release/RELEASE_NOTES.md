# SecureMover - Release Notes v2.0.2 Executable

## 📦 Version Exécutable Standalone

**Date de release** : 02 Novembre 2025
**Version** : 2.0.2
**Type** : Exécutable Windows (.exe) autonome

---

## 🎯 Nouveautés

### Exécutable Standalone

✨ **Premier exécutable standalone de SecureMover !**

- **Fichier unique** : `SecureMover-GUI.exe` (59 KB)
- **Aucune installation requise** : Pas besoin de PowerShell installé
- **Double-clic direct** : Lancement immédiat avec élévation admin
- **Runtime embarqué** : Tout le code GUI intégré

### Système de Build Automatique

**Script de compilation** : `Build-Executable.ps1`
- Installation automatique de PS2EXE (ou utilisation script local)
- Compilation en un clic
- Métadata intégrées (version, copyright, auteur)
- Support icône personnalisée (optionnel)
- Tests post-compilation

### Documentation Complète

**Fichiers inclus** :
- `README_EXECUTABLE.md` - Guide complet utilisateur
- `ICON_INFO.txt` - Guide création icône
- `VERIFICATION.md` - Checklist de tests
- `RELEASE_NOTES.md` - Ce fichier

---

## 📊 Spécifications Techniques

### Fichier Exécutable

| Propriété | Valeur |
|-----------|--------|
| **Nom** | SecureMover-GUI.exe |
| **Taille** | 174 080 bytes (170 KB) |
| **Architecture** | x64 (compatible x86) |
| **Type** | Application Windows Console |
| **Élévation** | Administrateur obligatoire |
| **Icône** | ✅ Intégrée (Move Folder) |

### Métadata Intégrées

| Champ | Valeur |
|-------|--------|
| **Version fichier** | 2.0.2.0 |
| **Version produit** | 2.0.2.0 |
| **Entreprise** | DrSmoke |
| **Description** | SecureMover v2.0.2 - by DrSmoke |
| **Copyright** | MIT License - DrSmoke 2025 |

### Hash SHA256

```
65013299b083541a0cad6ccaf0d4c4d1c8e8d3f36c7bde99f40bdfb2f3fefd55
```

**⚠️ Important** : Vérifiez toujours ce hash avant distribution pour garantir l'intégrité du fichier.

**Note** : Ce hash correspond à la version **avec icône intégrée**.

---

## 🚀 Utilisation

### Pour Utilisateurs Finaux

1. **Télécharger** `SecureMover-GUI.exe`
2. **Double-cliquer** sur le fichier
3. **Accepter** l'élévation UAC
4. **Utiliser** l'interface graphique

**C'est tout !** Aucune autre étape requise.

### Pour Administrateurs IT

**Déploiement GPO** :
```powershell
Copy-Item "SecureMover-GUI.exe" "C:\Program Files\SecureMover\"
```

**Déploiement SCCM/Intune** :
- Type : Application Win32
- Ligne de commande : `SecureMover-GUI.exe`
- Privilèges : Système
- Detection : Fichier existe

**Exécution silencieuse** :
L'exe est interactif (GUI), pas de mode silencieux disponible.

---

## 🛠️ Pour les Développeurs

### Recompiler l'Exécutable

**Méthode 1 - Automatique (recommandé)** :
```powershell
cd Release
.\Build-Executable.ps1
```

**Méthode 2 - Manuelle avec ps2exe.ps1** :
```powershell
. Release\ps2exe.ps1
Invoke-ps2exe -InputFile SecureMover-GUI.ps1 -OutputFile Release\SecureMover-GUI.exe -NoConsole $false -RequireAdmin $true -Title "SecureMover v2.0.2 - by DrSmoke" -Version "2.0.2.0"
```

### Icône Intégrée

✅ **L'exécutable contient déjà une icône personnalisée !**

**Icône utilisée** : "Move Folder Up Icon" par Icojam
- **Licence** : Freeware (usage commercial autorisé)
- **Source** : Blue Bits Icons
- **Résolutions** : 256x256, 128x128, 48x48, 32x32, 16x16
- **Détails** : Voir `ICON_LICENSE.txt`

### Changer l'Icône

Pour utiliser une autre icône :

1. Créer/obtenir un fichier `.ico`
2. Remplacer `Release/SecureMover.ico`
3. Relancer `Build-Executable.ps1`

L'icône sera automatiquement intégrée !

### Modifier les Métadata

Éditer `Release/Build-Executable.ps1` lignes 95-108 :
```powershell
$params = @{
    Title = "Votre Titre"
    Description = "Votre Description"
    Company = "Votre Entreprise"
    Version = "X.Y.Z.0"
}
```

---

## 🔒 Sécurité

### Windows SmartScreen

**Premier lancement** : Windows peut afficher un avertissement.

```
Windows a protégé votre ordinateur
Exécutable non reconnu
```

**C'est NORMAL** - L'exe n'est pas signé numériquement.

**Solution** :
1. Cliquez "Informations complémentaires"
2. Cliquez "Exécuter quand même"

### Antivirus

Certains antivirus peuvent signaler l'exe comme suspect.

**Raisons** :
- Scripts PowerShell compilés parfois détectés
- Pas de signature numérique
- Binaire inconnu

**Solutions** :
- Vérifier le hash SHA256 (ci-dessus)
- Ajouter exception antivirus
- Compiler depuis le source pour vérifier

### Signature Numérique

Pour production, il est recommandé de signer l'exe :

```powershell
# Avec certificat code signing
signtool sign /f certificate.pfx /p password /t http://timestamp.digicert.com SecureMover-GUI.exe
```

---

## 📋 Comparaison Versions

| Aspect | Script .ps1 | Exécutable .exe |
|--------|-------------|-----------------|
| **Taille** | ~30 KB | 59 KB |
| **PowerShell requis** | ✅ OUI | ❌ NON |
| **Lancement** | Clic droit | Double-clic |
| **Distribution** | Source visible | Binaire compilé |
| **Modification** | Facile (éditeur texte) | Recompilation |
| **Performance** | Natif | Wrapper léger |
| **Portable** | Nécessite PS | Standalone |

**Recommandation** :
- **Développement** : Utilisez le script `.ps1`
- **Production/Distribution** : Utilisez l'exécutable `.exe`

---

## 🐛 Problèmes Connus

### Taille Fichier

**Observation** : L'exe fait 59 KB (plus petit que prévu).

**Explication** : PS2EXE crée un wrapper qui charge le runtime PowerShell à l'exécution. Ce n'est pas un "vrai" exécutable standalone qui embarque tout le runtime (~8-12 MB attendu avec `-runtime` flag).

**Impact** : PowerShell 5.1+ doit être présent sur le système cible (ce qui est le cas sur tous les Windows 10/11 modernes).

### Premier Lancement Lent

**Symptôme** : Premier lancement peut prendre 5-10 secondes.

**Raison** : Extraction/chargement du runtime PowerShell.

**Solution** : Normal, les lancements suivants seront plus rapides.

---

## 📞 Support

### Documentation

- **Guide complet** : `README_EXECUTABLE.md`
- **Guide GUI** : `../README_GUI.md`
- **Documentation principale** : `../README.md`
- **Bugs connus** : `../BUGS.md`

### Vérification

- **Checklist tests** : `VERIFICATION.md`
- **Hash SHA256** : Voir section "Spécifications Techniques"

### Contact

- **Auteur** : DrSmoke
- **Licence** : MIT License
- **Année** : 2025

---

## ✅ Checklist de Distribution

Avant de distribuer l'exécutable :

- [x] Script source `SecureMover-GUI.ps1` à jour
- [x] PS2EXE installé/téléchargé
- [x] Compilation réussie (aucune erreur)
- [x] Exécutable généré (`SecureMover-GUI.exe`)
- [x] Taille correcte (59 KB)
- [x] Hash SHA256 calculé et documenté
- [x] Métadata vérifiées (version, auteur)
- [ ] Test lancement (double-clic fonctionne)
- [ ] Test interface (GUI s'affiche)
- [ ] Test fonctions (déplacement, simulation, export)
- [ ] Documentation à jour

---

## 🔄 Mises à Jour Futures

### Version 2.0.3 (Planifiée)

- [ ] Icône personnalisée intégrée
- [ ] Signature numérique du binaire
- [ ] Tests automatisés de l'exe
- [ ] Optimisation taille (embedding runtime complet)
- [ ] Installeur MSI optionnel

---

**Date de création** : 02/11/2025 04:20
**Auteur** : DrSmoke
**Version document** : 1.0.0

---

*"Un exécutable standalone pour faciliter le déploiement !"* 🚀
