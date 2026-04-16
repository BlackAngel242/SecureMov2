# SecureMover - Version Executable Standalone

![Version](https://img.shields.io/badge/version-2.0.2-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![Type](https://img.shields.io/badge/type-Executable-green)

**Fichier unique autonome** de SecureMover GUI - Aucune installation requise !

---

## 📦 Contenu du Dossier

```
Release/
├── Build-Executable.ps1        # Script de compilation automatique
├── SecureMover-GUI.exe         # Executable compile (apres build)
├── SecureMover.ico             # Icone personnalisee (optionnel)
├── README_EXECUTABLE.md        # Ce fichier
└── BUILD_LOG.txt               # Journal de compilation (auto-genere)
```

---

## 🚀 Utilisation Rapide

### Option 1 : Utiliser l'Executable Pre-Compile

Si `SecureMover-GUI.exe` existe deja :

1. **Double-cliquez** sur `SecureMover-GUI.exe`
2. Acceptez l'elevation administrateur
3. L'interface graphique s'ouvre !

**C'est tout !** Aucune installation PowerShell necessaire.

---

### Option 2 : Compiler Vous-Meme

Si vous voulez compiler depuis le source :

1. **Clic droit** sur `Build-Executable.ps1`
2. Selectionnez **"Executer avec PowerShell"**
3. Acceptez l'elevation administrateur
4. Le script va :
   - Installer PS2EXE automatiquement si absent
   - Compiler le script GUI en .exe
   - Creer `SecureMover-GUI.exe` dans ce dossier
5. Testez l'executable genere

**Duree** : 1-2 minutes

---

## 🔧 Compilation Manuelle Avancee

Si vous preferez controler le processus :

```powershell
# 1. Installer PS2EXE (une seule fois)
Install-Module -Name ps2exe -Scope CurrentUser

# 2. Importer le module
Import-Module ps2exe

# 3. Compiler
Invoke-PS2EXE `
    -InputFile "..\SecureMover-GUI.ps1" `
    -OutputFile "SecureMover-GUI.exe" `
    -NoConsole $false `
    -RequireAdmin $true `
    -Title "SecureMover v2.0.2 - by DrSmoke" `
    -Version "2.0.2.0"
```

---

## 📋 Specifications de l'Executable

### Informations Generales

| Propriete | Valeur |
|-----------|--------|
| **Nom** | SecureMover-GUI.exe |
| **Taille** | ~8-12 MB (contient runtime PowerShell) |
| **Type** | Application Windows (Console visible) |
| **Architecture** | x64 (compatible x86) |
| **Signature** | Non signee (warning Windows normal) |

### Metadata Integrees

- **Titre** : SecureMover v2.0.2 - by DrSmoke
- **Description** : Outil de deplacement de profils utilisateurs Windows
- **Auteur** : DrSmoke
- **Copyright** : MIT License - DrSmoke 2025
- **Version** : 2.0.2.0

### Dependances

**Aucune !** L'executable contient :
- Runtime PowerShell embarque
- Toutes les fonctions GUI
- Assemblies WPF necessaires
- Code complet du script

---

## 🔒 Securite et Permissions

### Privileges Requis

- **Administrateur OBLIGATOIRE**
- Necessaire pour :
  - Modifier le registre Windows
  - Deplacer fichiers systeme
  - Acceder aux profils utilisateurs

### Windows SmartScreen

Au premier lancement, Windows peut afficher :

```
Windows a protege votre ordinateur
Executable non reconnu
```

**C'est NORMAL** - L'executable n'est pas signe numeriquement.

**Solution** :
1. Cliquez sur "Informations complementaires"
2. Cliquez sur "Executer quand meme"

**Alternative** : Signer l'executable avec un certificat code signing.

### Antivirus

Certains antivirus peuvent signaler :
- "Application inconnue"
- "Executable PowerShell compile"

**C'est normal** - Les scripts PowerShell compiles sont parfois detectes comme suspects.

**Solutions** :
- Ajouter a la liste blanche de l'antivirus
- Compiler depuis le source (option 2)
- Verifier le hash SHA256 du fichier

---

## 📦 Distribution

### Pour Utilisateurs Finaux

**Fichier a distribuer** :
```
SecureMover-GUI.exe (8-12 MB)
```

**Instructions** :
1. Copiez `SecureMover-GUI.exe` sur le PC cible
2. Double-cliquez
3. Acceptez les privileges admin
4. Utilisez l'interface

**Aucun fichier supplementaire requis !**

### Pour IT/Admins

**Deploiement GPO** :
```powershell
# Deployer via GPO startup script
Copy-Item "SecureMover-GUI.exe" "C:\Program Files\SecureMover\"
```

**Deploiement SCCM/Intune** :
- Type : Application Win32
- Ligne de commande : `SecureMover-GUI.exe`
- Detection : Fichier existe
- Privileges : Systeme

---

## 🧪 Tests et Validation

### Verifier l'Executable

```powershell
# Verifier proprietes
Get-Item SecureMover-GUI.exe | Format-List

# Calculer hash SHA256
Get-FileHash SecureMover-GUI.exe -Algorithm SHA256

# Verifier signature numerique
Get-AuthenticodeSignature SecureMover-GUI.exe
```

### Tester Fonctionnalites

1. **Lancement** : Double-clic fonctionne ?
2. **Interface** : GUI s'affiche correctement ?
3. **Selection** : ComboBox visibles (texte noir) ?
4. **Logs** : Journal limite a 3 lignes ?
5. **Export** : Bouton EXPORTER fonctionne ?
6. **Simulation** : Mode WhatIf operationnel ?

---

## 🐛 Depannage

### L'executable ne se lance pas

**Symptome** : Rien ne se passe au double-clic

**Solutions** :
1. Verifiez que vous etes administrateur
2. Clic droit > "Executer en tant qu'administrateur"
3. Verifiez que .NET Framework 4.5+ est installe

### Erreur "Fichier corrompu"

**Symptome** : Message d'erreur au lancement

**Solutions** :
1. Re-telecharger/recompiler l'executable
2. Verifier le hash SHA256
3. Desactiver temporairement l'antivirus

### Performance lente

**Symptome** : Lancement prend >10 secondes

**Raison** : C'est normal au premier lancement (extraction runtime)

**Solutions** :
- Attendre la fin du premier lancement
- Les lancements suivants seront plus rapides
- Ajouter exception antivirus

---

## 🔄 Mise a Jour

### Mettre a Jour l'Executable

Quand une nouvelle version du script GUI est disponible :

1. Supprimez l'ancien `SecureMover-GUI.exe`
2. Relancez `Build-Executable.ps1`
3. Nouveau exe genere automatiquement

### Versioning

Le numero de version est integre dans l'executable :
- **Version fichier** : 2.0.2.0
- **Version produit** : 2.0.2
- Visible dans Proprietes > Details

---

## 📊 Comparaison Script vs Executable

| Aspect | Script .ps1 | Executable .exe |
|--------|-------------|-----------------|
| **Taille** | ~30 KB | ~8-12 MB |
| **PowerShell requis** | OUI | NON |
| **Installation** | Aucune | Aucune |
| **Lancement** | Clic droit | Double-clic |
| **Distribution** | Source visible | Compile |
| **Modification** | Facile | Recompilation |
| **Performance** | Natif | Legerement plus lent |
| **Securite** | Source ouvert | Binaire |

**Recommandation** :
- **Developpement** : Utilisez le script .ps1
- **Production/Distribution** : Utilisez l'executable .exe

---

## 🛠️ Personnalisation

### Changer l'Icone

1. Creez/telechargez un fichier `.ico`
2. Nommez-le `SecureMover.ico`
3. Placez-le dans le dossier `Release/`
4. Recompilez avec `Build-Executable.ps1`

L'icone sera automatiquement integree !

### Modifier les Metadata

Editez `Build-Executable.ps1` lignes 70-78 :

```powershell
Title = "Votre Titre"
Description = "Votre Description"
Company = "Votre Societe"
Copyright = "Votre Copyright"
Version = "X.Y.Z.0"
```

---

## 📝 Notes Techniques

### PS2EXE - Comment ca marche ?

PS2EXE convertit les scripts PowerShell en executables .exe :

1. **Compilation** : Script converti en C# puis compile
2. **Runtime** : PowerShell runtime embarque dans l'exe
3. **Execution** : L'exe extrait et execute le script en memoire

**Avantages** :
- Fichier unique standalone
- Pas d'installation PowerShell
- Metadata Windows integrees
- Icone personnalisable

**Limites** :
- Taille plus grande (~8 MB)
- Premier lancement legerement plus lent
- Non signe par defaut

---

## 🌐 Ressources

### Documentation PS2EXE

- GitHub : https://github.com/MScholtes/PS2EXE
- PowerShell Gallery : https://www.powershellgallery.com/packages/ps2exe

### Outils Complementaires

- **Signature Code** : SignTool.exe (Windows SDK)
- **Editeur Icone** : IcoFX, RealWorld Icon Editor
- **Analyse Exe** : Dependency Walker, PE Explorer

---

## 📞 Support

- **Documentation Complete** : ../README.md
- **Documentation GUI** : ../README_GUI.md
- **Bugs** : ../BUGS.md
- **GitHub Issues** : https://github.com/BlackAngel242/SecureMov2/issues

---

## 📄 Licence

MIT License - Voir fichier LICENSE

Copyright (c) 2025 DrSmoke

---

## ✅ Checklist de Build

Avant de distribuer l'executable :

- [ ] Script source `SecureMover-GUI.ps1` a jour
- [ ] PS2EXE installe (`Get-Module ps2exe`)
- [ ] Compilation reussie (aucune erreur)
- [ ] Executable genere (`SecureMover-GUI.exe` existe)
- [ ] Taille correcte (~8-12 MB)
- [ ] Test lancement (double-clic fonctionne)
- [ ] Test interface (GUI s'affiche)
- [ ] Test fonctions (WhatIf, Export, etc.)
- [ ] Documentation a jour
- [ ] Hash SHA256 calcule et documente

---

**Version du document** : 1.0.0
**Date** : 2025-11-01
**Auteur** : DrSmoke

---

*"Un executable autonome pour faciliter le deploiement !"* 🚀
