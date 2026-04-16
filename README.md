# SecureMover

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![Version](https://img.shields.io/badge/Version-2.0-orange.svg)](https://github.com/BlackAngel242/SecureMov2/releases)

Outil PowerShell pour déplacer, restaurer et sauvegarder les dossiers utilisateurs Windows vers une partition séparée — de manière sécurisée et réversible.

---

## Table des matières

- [Pourquoi SecureMover ?](#pourquoi-securemover-)
- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Sécurité](#sécurité)
- [Roadmap](#roadmap)
- [Contribution](#contribution)
- [Licence](#licence)

---

## Pourquoi SecureMover ?

Quand Windows est sur C:, vos données personnelles y sont aussi. Un crash, une réinstallation, ou un disque saturé — et tout peut disparaître.

- **Isolation** : vos fichiers sont sur une partition distincte, protégés des réinstallations système
- **Transparence** : Windows et vos applications ne voient aucune différence (registre mis à jour)
- **Réversible** : la restauration complète remet tout en place en un clic
- **Rapide** : transfert via `Robocopy`, outil officiel Microsoft

---

## Fonctionnalités

| Fonctionnalité | Description |
|----------------|-------------|
| **Déplacement sécurisé** | Déplace Desktop, Documents, Downloads, Pictures, Music, Videos vers une autre partition |
| **Restauration complète** | Remet les dossiers à leur emplacement d'origine (`C:\Users`) |
| **Sauvegarde externe** | Copie les dossiers sur un lecteur externe sans toucher au système |
| **Sauvegarde du registre** | Backup automatique des clés Windows avant toute modification |
| **Interface multilingue** | Support FR/EN avec détection automatique |
| **Logging détaillé** | Journal horodaté de toutes les opérations dans `SecureMover.log` |
| **Détection terminal** | Adaptation automatique des icônes (Windows Terminal vs console classique) |

---

## Prérequis

- **OS** : Windows 10 / 11 (ou Windows 7/8.1 avec PowerShell 5.1+)
- **PowerShell** : 5.1 ou supérieur

  ```powershell
  $PSVersionTable.PSVersion
  ```

- **Droits** : Administrateur (le script peut se relancer automatiquement)
- **Espace** : Taille des dossiers utilisateurs × 1.5 sur la partition cible

---

## Installation

```bash
git clone https://github.com/BlackAngel242/SecureMov2.git
cd SecureMov2
```

Si PowerShell bloque l'exécution :

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Utilisation

### Lancement

```powershell
# Clic droit sur SecureMover.ps1 > "Exécuter avec PowerShell"

# Ou depuis un terminal admin :
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PWD\SecureMover.ps1`"" -Verb RunAs
```

### Demo — Écran d'accueil

```
╔═══════════════════════════════════════════════════════════════════╗
║   ____                          __  __                           ║
║  / ___|  ___  ___ _   _ _ __ ___|  \/  | _____   _____ _ __     ║
║  \___ \ / _ \/ __| | | | '__/ _ \ |\/| |/ _ \ \ / / _ \ '__|   ║
║   ___) |  __/ (__| |_| | | |  __/ |  | | (_) \ V /  __/ |      ║
║  |____/ \___|\___|\__,_|_|  \___|_|  |_|\___/ \_/ \___|_|      ║
║                                                                   ║
║                      Version 2.0 Enhanced                        ║
║          Deplacement securise des profils utilisateurs           ║
╚═══════════════════════════════════════════════════════════════════╝
```

### Menu principal

```
+==================== MENU PRINCIPAL ====================+
|                                                        |
|  [1] Deplacer un Profil Utilisateur                   |
|  [2] Restaurer un Profil Utilisateur                  |
|  [3] Creer une sauvegarde d'un Profil                 |
|  [4] Aide et Informations                             |
|  [5] Quitter                                           |
|                                                        |
+========================================================+
```

### Barre de progression

```
[####################......] 75% | Traitement de Pictures...
Operation terminee avec succes!
```

### Options

| Option | Action |
|--------|--------|
| **[1] Déplacer** | Sélectionner un profil, choisir la partition cible, confirmer. Redémarrage requis. |
| **[2] Restaurer** | Détection automatique des profils déplacés, remise en place + restauration registre. |
| **[3] Sauvegarder** | Copie vers lecteur externe sans modifier le système. Idéal avant toute opération. |

---

## Sécurité

| Mesure | Détail |
|--------|--------|
| **Vérification admin** | Contrôle obligatoire au démarrage, relancement automatique si nécessaire |
| **Backup registre** | Fichier `.reg` horodaté créé avant toute modification |
| **Validation espace** | Calcul de l'espace requis, arrêt si insuffisant |
| **Permissions** | Test d'écriture sur la partition cible avant de commencer |
| **Gestion d'erreurs** | Try-Catch sur toutes les opérations critiques, rollback possible |
| **Robocopy** | Outil Microsoft officiel, retry intégré, préservation des métadonnées |

**Fichiers générés :**

```
SecureMover_Backup_YYYYMMDD_HHMMSS.reg   # Sauvegarde registre (conserver 30 jours min)
SecureMover.log                           # Journal des opérations
```

> **Disclaimer** : Ce script modifie le registre Windows et déplace des fichiers. Des sauvegardes automatiques sont créées, mais l'auteur ne peut être tenu responsable de toute perte de données. Testez d'abord sur un profil non-critique.

---

## Roadmap

| Version | Statut | Fonctionnalités |
|---------|--------|-----------------|
| **2.0** | Stable | Interface FR/EN, restauration, sauvegarde, logging, animations |
| **2.1** | En cours | Sélection de dossiers individuels, mode silencieux, multi-profils simultanés |
| **3.0** | Planifié | GUI WPF, sauvegardes planifiées, compression, statistiques d'espace |

---

## Contribution

Les contributions sont les bienvenues.

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour le guide complet.

```bash
git checkout -b feature/ma-fonctionnalite
git commit -m "feat: description courte"
git push origin feature/ma-fonctionnalite
# Ouvrir une Pull Request sur GitHub
```

**Contributions acceptées** : corrections de bugs, nouvelles fonctionnalités, documentation, traductions, tests.

Pour toute question ou signalement de bug : [GitHub Issues](https://github.com/BlackAngel242/SecureMov2/issues)

---

## Licence

Ce projet est sous licence **MIT** — voir [LICENSE](LICENSE).

---

<div align="center">

*"Protegez vos donnees, securisez votre avenir"*

[Retour en haut](#securemover)

</div>
