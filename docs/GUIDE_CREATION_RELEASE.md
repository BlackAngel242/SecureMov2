# 📦 Guide : Créer la Release v2.0.2 sur GitHub

Ce guide vous montre **pas à pas** comment publier SecureMover v2.0.2 sur GitHub.

---

## 📋 Fichiers à Uploader

Préparez ces **3 fichiers** sur votre bureau :

### 1. **SecureMover-GUI.exe** (170 KB)
📁 **Emplacement** : `C:\Users\DrSmoke\projet\Claude\SecureMover\Release\SecureMover-GUI.exe`

**Description** : Exécutable standalone avec interface graphique

### 2. **SecureMover-GUI.ps1** (35 KB)
📁 **Emplacement** : `C:\Users\DrSmoke\projet\Claude\SecureMover\SecureMover-GUI.ps1`

**Description** : Script PowerShell avec interface graphique

### 3. **SecureMover.ps1** (72 KB)
📁 **Emplacement** : `C:\Users\DrSmoke\projet\Claude\SecureMover\SecureMover.ps1`

**Description** : Script PowerShell en ligne de commande (CLI)

---

## 🚀 Étapes de Création de la Release

### Étape 1 : Aller sur GitHub Releases

1. Ouvrez votre navigateur
2. Allez sur : https://github.com/BlackAngel242/SecureMov2
3. Cliquez sur l'onglet **"Releases"** (à droite, sous "About")
4. Cliquez sur **"Create a new release"** (ou "Draft a new release")

### Étape 2 : Tag et Titre

**Choose a tag** :
- Cliquez sur la liste déroulante "Choose a tag"
- Tapez : `v2.0.2`
- Cliquez sur **"Create new tag: v2.0.2 on publish"**

**Release title** :
- Tapez : `SecureMover v2.0.2 - Interface Graphique + Exécutable Standalone`

### Étape 3 : Description de la Release

**Copiez-collez ce texte dans le champ "Describe this release"** :

```markdown
# 🚀 SecureMover v2.0.2 - Release Majeure !

**Première version avec interface graphique et exécutable standalone !**

---

## 📦 Téléchargements

Choisissez la version qui vous convient :

### ⭐ **SecureMover-GUI.exe** (RECOMMANDÉ)
- **Pour** : Utilisateurs qui veulent la simplicité maximale
- **Avantage** : Double-clic et c'est parti ! Pas besoin de PowerShell
- **Utilisation** : Double-cliquez sur le fichier

### 🎨 **SecureMover-GUI.ps1**
- **Pour** : Utilisateurs avec PowerShell, qui veulent l'interface graphique
- **Avantage** : Code source visible et modifiable
- **Utilisation** : Clic droit → "Exécuter avec PowerShell"

### 💻 **SecureMover.ps1**
- **Pour** : Professionnels IT et automatisation
- **Avantage** : Ligne de commande, déploiement GPO/SCCM
- **Utilisation** : `.\SecureMover.ps1 -UserName "Nom" -NewPath "D:\Profiles"`

---

## 🆕 Nouveautés v2.0.2

### Interface Graphique WPF
- ✅ Thème sombre minimaliste moderne
- ✅ ComboBox améliorées (texte noir visible)
- ✅ Logs optimisés (3 lignes + auto-scroll)
- ✅ Export logs (TXT, MD, HTML)
- ✅ Barre de progression en temps réel

### Exécutable Standalone
- ✅ Première version .exe officielle
- ✅ Icône personnalisée professionnelle
- ✅ Pas d'installation PowerShell requise
- ✅ Métadata intégrées

### Documentation Complète
- ✅ Guide de contact (WhatsApp, Email)
- ✅ Guide de contribution open-source
- ✅ 8 cas d'usage pratiques détaillés

---

## 📚 Documentation

- 📖 **README** : [Documentation complète](https://github.com/BlackAngel242/SecureMov2/blob/master/README.md)
- 🚀 **Démarrage rapide** : [QUICKSTART.md](https://github.com/BlackAngel242/SecureMov2/blob/master/QUICKSTART.md)
- 🎨 **Guide GUI** : [README_GUI.md](https://github.com/BlackAngel242/SecureMov2/blob/master/README_GUI.md)
- 💡 **Cas d'usage** : [CAS_USAGE.md](https://github.com/BlackAngel242/SecureMov2/blob/master/CAS_USAGE.md)

---

## 🔒 Sécurité

**SHA256 de SecureMover-GUI.exe** :
```
65013299b083541a0cad6ccaf0d4c4d1c8e8d3f36c7bde99f40bdfb2f3fefd55
```

Vérifiez avec :
```powershell
Get-FileHash SecureMover-GUI.exe -Algorithm SHA256
```

---

## 📞 Support

- 📱 **)
- 📧 **Email** : [GitHub Issues](https://github.com/BlackAngel242/SecureMov2/issues)
- 🐛 **Issues** : [GitHub Issues](https://github.com/BlackAngel242/SecureMov2/issues)

**Langue** : Français 🇫🇷

---

## ⚖️ Licence

**MIT License** - Gratuit et Open-Source

---

**🎉 Merci d'utiliser SecureMover !**

*Auteur : DrSmoke | Date : 02/11/2025*
```

### Étape 4 : Uploader les Fichiers

**Dans la section "Attach binaries"** en bas :

1. Cliquez sur **"Attach binaries by dropping them here or selecting them"**

2. **Uploadez ces 3 fichiers** (dans cet ordre) :
   - `SecureMover-GUI.exe`
   - `SecureMover-GUI.ps1`
   - `SecureMover.ps1`

3. **Attendez** que chaque fichier soit uploadé (barre verte)

### Étape 5 : Options

**Cochez ces options** :

- ✅ **"Set as the latest release"** (Définir comme dernière version)
- ❌ **"Set as a pre-release"** (NE PAS cocher - c'est une version stable)

### Étape 6 : Publier

1. **Vérifiez** que tout est correct :
   - Tag : `v2.0.2`
   - Titre : Correct
   - Description : Présente
   - 3 fichiers uploadés

2. Cliquez sur le gros bouton vert **"Publish release"**

---

## ✅ Vérification

Après publication, vérifiez que :

1. La release apparaît sur : https://github.com/BlackAngel242/SecureMov2/releases
2. Les 3 fichiers sont téléchargeables
3. Le badge "Latest" est visible
4. La description s'affiche correctement

---

## 📊 Après Publication

### Partagez la Release !

**URL de la release** :
```
https://github.com/BlackAngel242/SecureMov2/releases/tag/v2.0.2
```

**URL de téléchargement direct** :
```
https://github.com/BlackAngel242/SecureMov2/releases/download/v2.0.2/SecureMover-GUI.exe
https://github.com/BlackAngel242/SecureMov2/releases/download/v2.0.2/SecureMover-GUI.ps1
https://github.com/BlackAngel242/SecureMov2/releases/download/v2.0.2/SecureMover.ps1
```

### Mettez à jour le README

Ajoutez un badge de release dans `README.md` :

```markdown
[![Release](https://img.shields.io/github/v/release/BlackAngel242/SecureMov2)](https://github.com/BlackAngel242/SecureMov2/releases/latest)
```

---

## 🎯 Statistiques de Téléchargement

GitHub vous montrera automatiquement :
- Nombre de téléchargements par fichier
- Nombre de vues de la release
- Graphiques de popularité

---

## 🐛 En Cas de Problème

### Fichier trop gros
- **Max GitHub** : 2 GB par fichier
- **Vos fichiers** : < 1 MB (pas de problème)

### Release ne s'affiche pas
- Vérifiez que vous avez cliqué "Publish" (pas "Save draft")
- Attendez 1-2 minutes (cache GitHub)

### Modifier une release
- Allez sur la page de la release
- Cliquez "Edit release"
- Modifiez et re-publiez

---

## 💡 Conseils

1. **Testez les liens de téléchargement** après publication
2. **Téléchargez les fichiers** pour vérifier qu'ils ne sont pas corrompus
3. **Partagez l'URL** de la release sur WhatsApp/réseaux sociaux
4. **Créez une annonce** dans GitHub Discussions

---

**Bonne publication ! 🚀**

*Guide créé le 02/11/2025 par DrSmoke*
