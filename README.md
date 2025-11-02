# SecureMover 🛡️

**Version 2.0 Enhanced**

Un script PowerShell professionnel pour déplacer, restaurer et sauvegarder de manière sécurisée les dossiers utilisateurs Windows vers une autre partition.

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://www.microsoft.com/windows)

---

## 📋 Table des Matières

- [Vue d'ensemble](#-vue-densemble)
- [Fonctionnalités](#-fonctionnalités)
- [Pourquoi SecureMover ?](#-pourquoi-securemover-)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Captures d'écran](#-captures-décran)
- [Architecture](#-architecture)
- [Sécurité](#-sécurité)
- [FAQ](#-faq)
- [Dépannage](#-dépannage)
- [Cas d'Usage Pratiques](#-cas-dusage-pratiques)
- [Contribution](#-contribution)
- [Auteurs](#-auteurs)
- [Contact & Support](#-contact--support)
- [Licence](#-licence)

---

## 🎯 Vue d'ensemble

**SecureMover** est un outil PowerShell professionnel qui permet de déplacer vos dossiers personnels Windows (Documents, Images, Bureau, etc.) vers une partition séparée de votre disque dur. Cela protège vos données en cas de crash système, réinstallation de Windows ou problème avec le disque système.

**🆕 Version 2.0.2** : Maintenant avec **interface graphique (GUI)** moderne et **exécutable standalone** !

### Problème résolu

Lorsque Windows est installé sur le disque C:, vos données personnelles (documents, photos, vidéos) sont stockées au même endroit. En cas de :
- 💥 Crash du système d'exploitation
- 🔄 Nécessité de réinstaller Windows
- 💾 Disque C: saturé (plus de place !)
- 🦠 Infection par ransomware ciblant C:

**Vos données risquent d'être perdues !**

SecureMover résout ce problème en déplaçant vos données vers une partition séparée (D:, E:, etc.) tout en maintenant la transparence pour Windows et vos applications.

**💡 Cas d'usage populaires** : Libérer de l'espace sur C:, migration SSD, gestion multi-utilisateurs, entreprises, cybercafés, écoles...
👉 **Voir tous les cas pratiques** : [CAS_USAGE.md](CAS_USAGE.md)

---

## ✨ Fonctionnalités

### 🔄 Fonctionnalités Principales

| Fonctionnalité | Description |
|----------------|-------------|
| **Déplacement Sécurisé** | Déplace vos dossiers utilisateurs vers une autre partition avec `Robocopy` |
| **Restauration Complète** | Remet vos dossiers à leur emplacement d'origine en un clic |
| **Sauvegarde Externe** | Crée une copie de vos dossiers sur un lecteur externe sans modifier le système |
| **Interface Multilingue** | Support Français/Anglais avec détection automatique |
| **Gestion du Registre** | Sauvegarde et restauration automatique des clés de registre Windows |

### 🎨 Interface Utilisateur

- **Logo ASCII stylisé** avec bordures élégantes
- **Animations de chargement** pour les opérations longues
- **Barres de progression** avec pourcentage et statut
- **Messages colorés** avec icônes (émojis ou ASCII selon le terminal)
- **Boîtes d'information** pour les récapitulatifs et avertissements
- **Détection automatique** du type de terminal (Windows Terminal vs Console basique)

### 🔒 Sécurité Avancée

- ✅ Vérification des privilèges administrateur avec relancement auto
- ✅ Sauvegarde automatique du registre Windows avant modification
- ✅ Vérification de l'espace disque disponible
- ✅ Validation des permissions sur les dossiers cibles
- ✅ Gestion d'erreurs robuste avec rollback possible
- ✅ Logging détaillé de toutes les opérations

### 📁 Dossiers Gérés

Le script gère les dossiers utilisateurs suivants :

- 🖥️ **Bureau** (Desktop)
- 📄 **Documents** (Documents)
- 📥 **Téléchargements** (Downloads)
- 🖼️ **Images** (Pictures)
- 🎵 **Musique** (Music)
- 🎬 **Vidéos** (Videos)

---

## 🤔 Pourquoi SecureMover ?

### Avantages

1. **Protection des données** : Vos fichiers sont isolés du système d'exploitation
2. **Réinstallation facile** : Réinstallez Windows sans perdre vos données
3. **Gestion de l'espace** : Libérez de l'espace sur votre partition système
4. **Rapidité** : Utilise `Robocopy` pour des transferts ultra-rapides
5. **Transparence** : Vos applications continuent de fonctionner normalement
6. **Réversible** : Fonction de restauration complète incluse

### Comparaison avec les alternatives

| Méthode | Avantages | Inconvénients |
|---------|-----------|---------------|
| **SecureMover** | ✅ Automatique<br>✅ Sécurisé<br>✅ Réversible<br>✅ Gratuit | ⚠️ Nécessite PowerShell |
| **Déplacement Manuel** | ✅ Gratuit | ❌ Complexe<br>❌ Risque d'erreurs<br>❌ Chronophage |
| **Lien Symbolique** | ✅ Flexible | ❌ Complexe<br>❌ Problèmes de permissions |
| **Services Cloud** | ✅ Accessible partout | ❌ Payant<br>❌ Nécessite Internet<br>❌ Vie privée |

---

## 📋 Prérequis

### Système

- **OS** : Windows 10/11 (ou Windows 7/8.1 avec PowerShell 5.1+)
- **PowerShell** : Version 5.1 ou supérieure
- **Droits** : Privilèges Administrateur (le script peut se relancer automatiquement)
- **Partitions** : Au moins une partition autre que C: avec espace suffisant

### Vérifier votre version PowerShell

Ouvrez PowerShell et tapez :

```powershell
$PSVersionTable.PSVersion
```

Vous devriez voir `5.1` ou supérieur.

### Espace Disque Requis

Le script calcule automatiquement l'espace nécessaire, mais prévoyez :
- Minimum : Taille de vos dossiers utilisateurs + 10% de marge
- Recommandé : Taille de vos dossiers × 1.5

---

## 🚀 Installation

### Méthode 1 : Téléchargement Direct

1. Téléchargez le fichier `SecureMover.ps1` depuis ce dépôt
2. Placez-le dans un dossier de votre choix (ex : `C:\Tools\SecureMover\`)
3. C'est tout ! Le script est prêt à l'emploi

### Méthode 2 : Clone Git

```bash
git clone https://github.com/DrSmoke/SecureMover.git
cd SecureMover
```

### Configuration de l'Exécution PowerShell

Si vous obtenez une erreur de politique d'exécution, exécutez en tant qu'Admin :

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 💻 Utilisation

### Lancement du Script

#### Option 1 : Clic Droit (Recommandé)

1. Faites un **clic droit** sur `SecureMover.ps1`
2. Sélectionnez **"Exécuter avec PowerShell"**
3. Si demandé, acceptez les privilèges administrateur

#### Option 2 : PowerShell Terminal

```powershell
# Naviguer vers le dossier du script
cd C:\Path\To\SecureMover

# Lancer le script
.\SecureMover.ps1
```

#### Option 3 : Lancement en Admin (Recommandé)

```powershell
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PWD\SecureMover.ps1`"" -Verb RunAs
```

### Interface du Menu Principal

Une fois lancé, vous verrez un menu avec 5 options :

```
+==================== MENU PRINCIPAL ====================+
|                                                        |
|  👤 [1] Deplacer un Profil Utilisateur                |
|  🔄 [2] Restaurer un Profil Utilisateur               |
|  💾 [3] Creer une sauvegarde d'un Profil              |
|  ℹ️ [4] Aide et Informations                          |
|  🚪 [5] Quitter                                        |
|                                                        |
+========================================================+
```

### Guide d'Utilisation par Fonction

#### 📤 Option 1 : Déplacer un Profil

Cette option déplace vos dossiers utilisateurs vers une autre partition.

**Étapes :**
1. Sélectionnez le profil utilisateur (généralement le vôtre)
2. Choisissez la partition de destination (ex: D:, E:)
3. Vérifiez le récapitulatif affiché
4. Confirmez l'opération
5. Le script :
   - Crée une sauvegarde du registre
   - Déplace les dossiers avec `Robocopy`
   - Met à jour le registre Windows
   - Rafraîchit les références système
6. **Redémarrez votre ordinateur** pour finaliser

**Durée estimée** : 5-30 minutes selon la taille des données

#### 📥 Option 2 : Restaurer un Profil

Cette option remet vos dossiers à leur emplacement d'origine (C:\Users).

**Étapes :**
1. Le script détecte automatiquement les profils déplacés
2. Sélectionnez le profil à restaurer
3. Confirmez l'opération
4. Le script :
   - Déplace les dossiers vers C:\Users
   - Restaure le registre depuis la sauvegarde
   - Met à jour les références Windows
5. **Redémarrez votre ordinateur**

**Note** : Nécessite un fichier de sauvegarde `.reg` créé lors du déplacement initial

#### 💾 Option 3 : Créer une Sauvegarde

Cette option crée une copie de vos dossiers **sans modifier le système**.

**Étapes :**
1. Sélectionnez le profil à sauvegarder
2. Choisissez le lecteur de destination (amovible recommandé)
3. Le script calcule la taille nécessaire
4. Vérifiez l'espace disponible
5. Confirmez la sauvegarde
6. Le script copie tous les dossiers et crée un fichier d'informations

**Idéal pour** :
- Sauvegardes régulières
- Avant une opération risquée
- Archivage sur disque externe

#### ℹ️ Option 4 : Aide

Affiche un guide détaillé de toutes les fonctionnalités.

---

## 📸 Captures d'écran

### Écran d'Accueil

```
╔═══════════════════════════════════════════════════════════════════╗
║   ____                          __  __                           ║
║  / ___|  ___  ___ _   _ _ __ ___|  \/  | _____   _____ _ __        ║
║  \___ \ / _ \/ __| | | | '__/ _ \ |\/| |/ _ \ \ / / _ \ '__|       ║
║   ___) |  __/ (__| |_| | | |  __/ |  | | (_) \ V /  __/ |         ║
║  |____/ \___|\___|\__,_|_|  \___|_|  |_|\___/ \_/ \___|_|         ║
║                                                                   ║
║                        Version 2.0 Enhanced                      ║
║    🛡️ Déplacement sécurisé des profils utilisateurs Windows 🛡️    ║
╚═══════════════════════════════════════════════════════════════════╝
```

### Barre de Progression

```
⏳ Déplacement des dossiers | [██████████████████████░░░░░░] 75% | Traitement de Pictures...
✅ Operation terminee avec succes!
```

---

## 🏗️ Architecture

### Structure du Projet

```
SecureMover/
│
├── SecureMover.ps1          # Script principal
├── README.md                # Ce fichier
├── LICENSE                  # Licence MIT
├── secure mover.txt         # Documentation v1.0 (référence)
├── SecureMover_v2.txt       # Code source v2.0 (référence)
│
└── Fichiers Générés (après exécution) :
    ├── SecureMover.log                    # Journal des opérations
    └── SecureMover_Backup_YYYYMMDD_HHMMSS.reg  # Sauvegardes registre
```

### Flux d'Exécution

```
┌─────────────────────────┐
│  Lancement du script    │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Vérification Admin     │◄──── Relancement automatique si nécessaire
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Initialisation         │
│  - Encodage UTF-8       │
│  - Icônes adaptatives   │
│  - Configuration fenêtre│
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Menu Principal         │◄────┐
│  (Boucle interactive)   │     │
└──────────┬──────────────┘     │
           │                     │
           ▼                     │
     ┌────────────┐             │
     │ Choix 1-5  │             │
     └──┬─────────┘             │
        │                        │
   ┌────┼────┬────┬────┐        │
   │    │    │    │    │        │
   ▼    ▼    ▼    ▼    ▼        │
  [1]  [2]  [3]  [4]  [5]       │
 Move Rest. Bckp Help Exit      │
   │    │    │    │             │
   │    │    │    └─────────────┘
   │    │    │
   └────┴────┴──────► Opérations avec :
                      - Validation
                      - Sauvegarde registre
                      - Robocopy
                      - Mise à jour système
                      - Logging
```

### Composants Principaux

| Module | Responsabilité |
|--------|----------------|
| **Configuration** | Encodage UTF-8, détection terminal, initialisation fenêtre |
| **Interface** | Logo, animations, barres de progression, boîtes d'info |
| **Sécurité** | Vérification admin, sauvegarde registre, gestion erreurs |
| **Profils** | Détection, sélection, validation profils utilisateurs |
| **Stockage** | Sélection partitions, vérification espace, validation |
| **Opérations** | Déplacement, restauration, sauvegarde avec Robocopy |
| **Registre** | Backup, modification, restauration clés Windows |
| **Logging** | Enregistrement actions, gestion fichier log |

---

## 🔒 Sécurité

### Mesures de Sécurité Implémentées

1. **Privilèges Administrateur**
   - Vérification obligatoire au démarrage
   - Relancement automatique en mode admin si nécessaire
   - Refus d'exécution sans privilèges suffisants

2. **Sauvegarde du Registre**
   - Backup automatique avant toute modification
   - Format `.reg` standard Windows
   - Horodatage unique pour chaque sauvegarde
   - Restauration manuelle ou automatique possible

3. **Validation des Données**
   - Vérification de l'existence des dossiers sources
   - Calcul de l'espace disque requis
   - Test des permissions d'écriture
   - Confirmation utilisateur à chaque étape critique

4. **Gestion des Erreurs**
   - Try-Catch sur toutes les opérations critiques
   - Messages d'erreur détaillés avec suggestions
   - Possibilité de rollback en cas d'échec
   - Logging de toutes les exceptions

5. **Robocopy**
   - Utilisation de l'outil Microsoft officiel
   - Options de retry et de gestion d'erreurs
   - Préservation des métadonnées (dates, attributs)
   - Codes de sortie analysés et gérés

### Fichiers de Sauvegarde

Les fichiers de sauvegarde du registre sont créés ici :
```
<Dossier du script>\SecureMover_Backup_YYYYMMDD_HHMMSS.reg
```

**Conservation recommandée** : Au moins 30 jours après l'opération

### Logging

Toutes les opérations sont enregistrées dans :
```
<Dossier du script>\SecureMover.log
```

Format :
```
[2025-01-15 14:30:22] [INFO] Démarrage de SecureMover v2.0
[2025-01-15 14:30:45] [SUCCESS] Sauvegarde du registre créée
[2025-01-15 14:32:10] [INFO] Déplacement de Desktop vers D:\Users\John\Desktop
```

---

## ❓ FAQ

### Q1 : Le script fonctionne-t-il sur Windows 11 ?

**Réponse** : Oui, parfaitement ! SecureMover est compatible Windows 10, Windows 11, et même Windows 7/8.1 avec PowerShell 5.1+.

### Q2 : Mes applications vont-elles continuer à fonctionner ?

**Réponse** : Oui ! Le script met à jour le registre Windows, donc vos applications utiliseront automatiquement les nouveaux emplacements. C'est totalement transparent.

### Q3 : Puis-je annuler le déplacement ?

**Réponse** : Absolument ! Utilisez l'option **[2] Restaurer un Profil** pour remettre vos dossiers à leur emplacement d'origine. Le script restaurera également le registre depuis la sauvegarde.

### Q4 : Que se passe-t-il si je n'ai pas assez d'espace ?

**Réponse** : Le script calcule l'espace nécessaire et vous avertit si l'espace est insuffisant. L'opération ne démarre pas si la vérification échoue.

### Q5 : Dois-je fermer mes applications ?

**Réponse** : **Oui, fortement recommandé !** Fermez toutes les applications utilisant vos dossiers (Word, Excel, navigateurs, etc.) pour éviter les conflits de fichiers.

### Q6 : Le script modifie-t-il mon système de façon permanente ?

**Réponse** : Le déplacement modifie le registre, mais c'est réversible. La fonction de restauration remet tout comme avant. Les sauvegardes (option 3) ne modifient rien du tout.

### Q7 : Puis-je déplacer uniquement certains dossiers ?

**Réponse** : Actuellement, le script déplace tous les dossiers standards. Une future version pourrait offrir une sélection personnalisée.

### Q8 : Le script fonctionne-t-il en ligne de commande ?

**Réponse** : Non, c'est un script interactif qui nécessite des entrées utilisateur. Mais vous pouvez facilement le modifier pour le rendre scriptable.

### Q9 : Que faire si j'obtiens une erreur "script non signé" ?

**Réponse** : Exécutez en tant qu'Admin :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Q10 : Les émojis ne s'affichent pas correctement

**Réponse** : Utilisez **Windows Terminal** au lieu de la console PowerShell classique. Le script détecte automatiquement le type de terminal et adapte l'affichage.

---

## 🔧 Dépannage

### Problème : "Impossible de charger le fichier car l'exécution de scripts est désactivée"

**Solution** :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problème : Les accents ne s'affichent pas correctement

**Causes possibles** :
1. Encodage du fichier incorrect
2. Console pas configurée en UTF-8

**Solution** :
1. Vérifiez que `SecureMover.ps1` est encodé en **UTF-8 with BOM**
2. Le script configure automatiquement UTF-8, mais vous pouvez forcer :
   ```powershell
   chcp 65001
   ```

### Problème : "Accès refusé" lors du déplacement

**Causes** :
- Applications ouvertes utilisant les dossiers
- Permissions insuffisantes
- Fichiers système verrouillés

**Solution** :
1. Fermez **TOUTES** vos applications
2. Lancez le script en tant qu'Admin
3. Si le problème persiste, redémarrez en mode sans échec et réessayez

### Problème : La fenêtre se ferme immédiatement

**Solution** :
Utilisez le paramètre `-NoExit` :
```powershell
.\SecureMover.ps1 -NoExit
```

### Problème : Robocopy échoue avec un code d'erreur 8+

**Causes** :
- Espace disque insuffisant
- Chemin trop long (> 260 caractères)
- Fichiers corrompus

**Solution** :
1. Vérifiez l'espace disponible
2. Consultez le fichier `SecureMover.log` pour les détails
3. Utilisez la restauration du registre si nécessaire

### Problème : Le menu principal ne s'affiche pas correctement

**Solution** :
1. Agrandissez la fenêtre PowerShell à au moins 85×45 caractères
2. Le script tente de le faire automatiquement, mais vous pouvez ajuster manuellement

---

## 💡 Cas d'Usage Pratiques

SecureMover est utilisé dans de nombreuses situations réelles ! Voici quelques exemples :

### 🏠 Particuliers

- **Disque C: saturé** → Libérez 50-200 Go en déplaçant vos profils vers D:
- **Migration SSD** → Gardez Windows sur le SSD rapide, profils sur HDD spacieux
- **Multi-utilisateurs** → Gérez facilement plusieurs profils familiaux

### 🏢 Professionnels

- **Entreprises** → Déploiement automatisé sur 50-500 PC via GPO/SCCM
- **Cybercafés** → Gestion intelligente des profils clients temporaires
- **Écoles** → Organisation des profils étudiants par semestre

### 💻 IT & Développeurs

- **Réparation PC** → Intervention rapide (30 min) sans réinstallation
- **Environnements de test** → Profils isolés pour chaque environnement
- **Optimisation** → Séparation code source (SSD) et dépendances (HDD)

👉 **Découvrez tous les cas d'usage détaillés** : [CAS_USAGE.md](CAS_USAGE.md)

**Bénéfices réels** :
- 💾 Libération d'espace : +50 à +500 Go selon le profil
- 💰 Économies : 0-500€ (évite achats SSD/disques)
- ⚡ Gain de temps : 10 min vs 2-3h de réinstallation
- 🔒 Sécurité : Sauvegarde automatique avant chaque opération

---

## 🤝 Contribution

Les contributions sont les bienvenues ! SecureMover est un projet **open-source**.

👉 **Guide complet de contribution** : [CONTRIBUTING.md](CONTRIBUTING.md)

**En résumé** :
1. 🍴 Fork le projet
2. 🌿 Créez une branche (`git checkout -b feature/MaFonctionnalite`)
3. ✍️ Commitez (`git commit -m 'feat: Ma fonctionnalité'`)
4. 📤 Push (`git push origin feature/MaFonctionnalite`)
5. 🔀 Ouvrez une Pull Request

**Besoin d'aide ?** Contactez-moi sur WhatsApp : [+242 066 50 72 75](https://wa.me/242066507275)

---

## 👨‍💻 Auteurs

**DrSmoke** - *"un mbokatier bien engagé"*
- 💼 Développement principal et maintenance
- 🎨 Design de l'interface (CLI + GUI)
- 📖 Documentation complète
- 📱 Contact WhatsApp : [+242 066 50 72 75](https://wa.me/242066507275)
- 🌍 Basé au Congo 🇨🇬

👉 **Plus d'infos** : [CONTACT.md](CONTACT.md)

**Assistant IA (Claude Code)**
- 🤖 Assistance au développement
- 🔧 Optimisations techniques
- 📝 Aide à la documentation

---

## 🗺️ Feuille de Route

### Version 2.0 ✅ (Actuelle)
- ✅ Interface multilingue (FR/EN)
- ✅ Menu interactif complet
- ✅ Fonction de restauration
- ✅ Sauvegarde externe
- ✅ Gestion avancée des erreurs
- ✅ Logging détaillé
- ✅ Animations et barres de progression
- ✅ Adaptation automatique du terminal

### Version 2.1 🔄 (En cours)
- 🔄 Sélection personnalisée des dossiers
- 🔄 Mode silencieux/automatisé
- 🔄 Support des profils multiples simultanés
- 🔄 Vérification d'intégrité post-opération

### Version 3.0 🔮 (Futur)
- 🔮 Interface graphique (GUI) avec WPF
- 🔮 Planification de sauvegardes automatiques
- 🔮 Compression des sauvegardes
- 🔮 Support des dossiers personnalisés
- 🔮 Statistiques d'utilisation de l'espace
- 🔮 Mode de migration pour nouveau PC

---

## 📄 Licence

Ce projet est sous licence **MIT** - voir le fichier [LICENSE](LICENSE) pour plus de détails.

```
MIT License

Copyright (c) 2025 DrSmoke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## 🙏 Remerciements

- **Microsoft** pour PowerShell et Robocopy
- **La communauté PowerShell** pour l'inspiration et les bonnes pratiques
- **Tous les testeurs** qui ont contribué à améliorer la stabilité

---

## 📞 Contact & Support

### 👨‍💻 Auteur

**DrSmoke** - Développeur passionné par l'automatisation Windows

### 💬 Me Contacter

- 📱 **WhatsApp** : [+242 066 50 72 75](https://wa.me/242066507275)
- 🐛 **Bugs** : [Ouvrir une issue](https://github.com/DrSmoke/SecureMover/issues)
- 💬 **Questions** : [Discussions](https://github.com/DrSmoke/SecureMover/discussions)
- 📧 **Email** : drsmoke@example.com

**Langues** : Français 🇫🇷

👉 **Plus d'infos** : Voir [CONTACT.md](CONTACT.md) pour tous les moyens de contact

### 🤝 Contribuer

SecureMover est **open-source** ! Vos contributions sont les bienvenues :

- 🍴 **Fork** le projet sur GitHub
- 🌿 **Créez** une branche pour votre fonctionnalité
- ✍️ **Commitez** vos modifications
- 📤 **Ouvrez** une Pull Request

👉 **Guide complet** : [CONTRIBUTING.md](CONTRIBUTING.md)

**Contributions acceptées** :
- ✅ Corrections de bugs
- ✅ Nouvelles fonctionnalités
- ✅ Documentation et traductions
- ✅ Amélioration UX/UI
- ✅ Tests et rapports de bugs

---

## ⚠️ Disclaimer

**IMPORTANT** : Ce script modifie le registre Windows et déplace des fichiers système. Bien qu'il soit conçu pour être sûr et inclut des sauvegardes automatiques, **l'auteur ne peut être tenu responsable de toute perte de données**.

**Recommandations** :
1. ✅ Créez une sauvegarde complète de votre système avant utilisation
2. ✅ Testez d'abord sur un profil non-critique
3. ✅ Lisez entièrement la documentation
4. ✅ Conservez les fichiers de sauvegarde `.reg` générés

**Utilisez ce script à vos propres risques.**

---

<div align="center">

**Fait avec ❤️ par DrSmoke**

*"Protégez vos données, sécurisez votre avenir"*

[⬆ Retour en haut](#securemover-️)

</div>
