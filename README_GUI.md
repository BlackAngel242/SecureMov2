# SecureMover GUI - Interface Graphique

![Version](https://img.shields.io/badge/version-2.0.2--GUI-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)
![WPF](https://img.shields.io/badge/UI-WPF-purple)

Interface graphique moderne avec thème sombre pour SecureMover - Déplacement de profils utilisateurs Windows.

---

## 🎨 Aperçu

**SecureMover GUI** offre une interface graphique WPF élégante et minimaliste avec thème sombre pour déplacer vos profils utilisateurs Windows sans ligne de commande.

### Caractéristiques

- ✨ **Interface WPF moderne** - Design professionnel et intuitif
- 🌙 **Thème sombre** - Confortable pour les yeux
- 📋 **Sélection visuelle** - Menus déroulants pour profils et disques
- 📊 **Indicateurs d'espace** - Visualisation temps réel de l'espace disponible
- 🔄 **Barre de progression** - Suivi des opérations en cours
- 📝 **Journal en temps réel** - Log de toutes les actions effectuées
- 🎯 **Boutons clairs** - Actions principales accessibles en un clic

---

## 🚀 Lancement Rapide

### Méthode 1 : Double-clic (Recommandé)

1. Faites un **clic droit** sur `SecureMover-GUI.ps1`
2. Sélectionnez **"Exécuter avec PowerShell"**
3. Acceptez l'élévation administrateur si demandée

### Méthode 2 : PowerShell

```powershell
# Depuis le dossier SecureMover
.\SecureMover-GUI.ps1
```

### Méthode 3 : Script de lancement

```powershell
# Utiliser le lanceur automatique
.\Lancer-GUI.bat
```

---

## 📖 Guide d'Utilisation

### Interface Principale

L'interface est divisée en sections claires :

#### 1. SÉLECTION DU PROFIL
- **Liste déroulante** des profils utilisateurs détectés
- Affiche le nom et le chemin de chaque profil
- Profils systèmes exclus automatiquement (Public, Default, etc.)

#### 2. DISQUE DE DESTINATION
- **Liste déroulante** des disques disponibles
- Affichage en temps réel :
  - Espace libre en GB
  - Pourcentage d'espace disponible
  - Indicateur coloré :
    - 🟢 **Vert** : >30% libre (Excellent)
    - 🟠 **Orange** : 15-30% libre (Attention)
    - 🔴 **Rouge** : <15% libre (Critique)

#### 3. ACTIONS PRINCIPALES

##### 🔵 DÉPLACER
- Déplace le profil sélectionné vers le disque de destination
- **ATTENTION** : Opération irréversible sans RESTAURER
- Nécessite confirmation avant exécution
- Redémarrage recommandé après

##### 🟢 RESTAURER
- Restaure un profil précédemment déplacé
- Ramène le profil à son emplacement d'origine `C:\Users`
- ⚠️ *Fonctionnalité en développement dans cette version GUI*

##### 🟡 SAUVEGARDER
- Crée une copie de sauvegarde du profil
- Utile avant déplacement ou pour archivage
- ⚠️ *Fonctionnalité en développement dans cette version GUI*

##### ⚪ SIMULER (WhatIf)
- **Mode simulation** sans modification système
- Affiche exactement ce qui serait effectué
- Idéal pour :
  - Tester avant déplacement réel
  - Formation utilisateurs
  - Vérifier impact opération
- Aucun risque, aucune modification

#### 4. JOURNAL D'ACTIVITÉ
- Affiche toutes les actions en temps réel
- Format horodaté avec codes :
  - `[INFO]` - Information générale
  - `[OK]` - Opération réussie
  - `[WARN]` - Avertissement
  - `[ERR]` - Erreur
- Défilement automatique
- Police monospace pour lisibilité

---

## 🔧 Configuration Requise

### Système
- **OS** : Windows 10 21H2+ ou Windows 11
- **PowerShell** : 5.1 ou supérieur
- **Framework** : .NET Framework 4.5+ (inclus dans Windows)
- **Privilèges** : Administrateur **REQUIS**

### Matériel
- **RAM** : 4 GB minimum
- **Disque** : Espace suffisant sur destination
- **Affichage** : 1280x720 minimum

---

## ⚙️ Fonctionnalités Techniques

### Backend
- Basé sur le script CLI `SecureMover.ps1`
- Utilise les mêmes fonctions robustes :
  - Vérification espace disque
  - Support chemins longs (>260 caractères)
  - Sauvegarde automatique registre
  - Gestion d'erreurs avancée

### Frontend WPF
- **XAML** pour le design
- **Thème personnalisé** sombre minimaliste
- **Styles modernes** avec effets hover
- **Responsive** - S'adapte aux actions
- **Asynchrone** - Interface réactive pendant opérations

### Sécurité
- ✅ Vérification privilèges administrateur
- ✅ Validation des entrées utilisateur
- ✅ Confirmation avant opérations critiques
- ✅ Sauvegarde registre automatique
- ✅ Logs détaillés de toutes actions

---

## 🎯 Cas d'Usage

### 1. Déplacement Simple
```
Scénario : Profil sur C:\ plein, déplacer vers D:\

1. Lancer SecureMover-GUI.ps1
2. Sélectionner le profil dans la liste
3. Sélectionner disque D:\ (vérifier espace vert/orange)
4. Cliquer "SIMULER" pour voir ce qui sera fait
5. Cliquer "DÉPLACER"
6. Confirmer l'opération
7. Attendre la fin (barre de progression)
8. Redémarrer le PC
```

### 2. Test Sans Risque
```
Scénario : Tester avant déplacement réel

1. Sélectionner profil et destination
2. Cliquer "SIMULER"
3. Lire le journal pour voir les actions
4. Décider si continuer ou non
```

### 3. Vérification Espace
```
Scénario : Vérifier quel disque a assez d'espace

1. Sélectionner le profil à déplacer
2. Parcourir les disques dans la liste déroulante
3. Observer l'indicateur d'espace coloré
4. Choisir le disque avec le plus d'espace libre
```

---

## 🐛 Dépannage

### La fenêtre ne s'ouvre pas
**Cause** : Pas de privilèges administrateur
**Solution** :
```powershell
# Relancer en admin
Start-Process powershell -Verb RunAs -ArgumentList "-File .\SecureMover-GUI.ps1"
```

### "Aucun profil détecté"
**Cause** : Problème accès C:\Users
**Solution** :
- Vérifier privilèges admin
- Vérifier que C:\Users existe et est accessible

### Erreur de syntaxe XAML
**Cause** : .NET Framework manquant ou version incorrecte
**Solution** :
```powershell
# Vérifier version .NET
[System.Environment]::Version

# Doit être >= 4.5
```

### Boutons grisés/désactivés
**Cause** : Profil ou disque non sélectionné
**Solution** : Sélectionner un élément dans chaque liste déroulante

---

## 🔄 Différences CLI vs GUI

| Fonctionnalité | CLI | GUI |
|----------------|-----|-----|
| **Mode déplacement** | ✅ Complet | ✅ Complet |
| **Mode restauration** | ✅ Complet | ⚠️ En développement |
| **Mode sauvegarde** | ✅ Complet | ⚠️ En développement |
| **Mode WhatIf** | ✅ Complet | ✅ Complet |
| **Sélection personnalisée dossiers** | ❌ | ❌ |
| **Interface** | Texte | Graphique |
| **Courbe d'apprentissage** | Moyenne | Faible |
| **Automatisation** | ✅ Facile | ❌ Difficile |

**Recommandation** :
- **GUI** pour usage interactif et utilisateurs non techniques
- **CLI** pour automatisation, scripts et toutes fonctionnalités

---

## 📝 Notes de Version GUI

### v2.0.2-GUI (2025-11-01)

**Nouveautés** :
- ✨ Première version de l'interface graphique
- 🌙 Thème sombre minimaliste
- 📊 Indicateurs visuels d'espace disque
- 🔄 Barre de progression pour opérations
- 📝 Journal temps réel
- 🎯 Mode simulation WhatIf graphique

**Limitations Actuelles** :
- ⚠️ Restauration : Interface affiche message "en développement"
- ⚠️ Sauvegarde : Interface affiche message "en développement"
- ⚠️ Déplacement : Simulation uniquement (backend à connecter)

**Prochaine Version GUI (v2.0.3-GUI)** :
- 🔌 Connexion complète au backend CLI
- ✅ Implémentation Restauration
- ✅ Implémentation Sauvegarde
- 🎨 Amélioration animations
- 📊 Graphiques d'espace disque

---

## 🤝 Contribution

Cette GUI est open source sous licence MIT. Contributions bienvenues !

### Améliorer la GUI
- Design XAML personnalisé
- Nouvelles fonctionnalités visuelles
- Traductions (actuellement FR uniquement)
- Thèmes alternatifs (clair, custom)

---

## 📞 Support

- **Documentation Complète** : README.md (script CLI)
- **Bugs GUI** : BUGS.md
- **Questions** : GitHub Issues

---

## 📄 Licence

MIT License - Voir fichier LICENSE

Copyright (c) 2025 DrSmoke

---

## 👨‍💻 Auteur

**DrSmoke** - "Un mbokatier bien engagé"
Avec l'assistance de Claude (Anthropic)

---

**Profitez de SecureMover GUI pour déplacer vos profils en toute simplicité ! 🚀**
