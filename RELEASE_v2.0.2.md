# 🚀 SecureMover v2.0.2 - Release Notes

**Date de sortie** : 02 Novembre 2025
**Auteur** : DrSmoke
**Licence** : MIT (Gratuit et Open-Source)

---

## 📦 Fichiers Disponibles

Cette release contient **3 versions** de SecureMover. Choisissez celle qui correspond le mieux à vos besoins :

### 1️⃣ **SecureMover-GUI.exe** (170 KB) - ⭐ RECOMMANDÉ

**👉 Pour qui ?** Utilisateurs qui veulent la **simplicité maximale**

✅ **Avantages** :
- **Double-clic et c'est parti !** Aucune configuration
- Interface graphique moderne et intuitive
- Pas besoin d'installer PowerShell
- Fonctionne sur n'importe quel PC Windows 10/11
- Icône personnalisée professionnelle

❌ **Inconvénient** :
- Taille légèrement plus grande (170 KB vs 35 KB)

**Quand l'utiliser ?**
- ✅ Vous voulez la version la plus simple
- ✅ Vous n'êtes pas familier avec PowerShell
- ✅ Vous voulez distribuer facilement à d'autres personnes
- ✅ Usage ponctuel ou personnel

---

### 2️⃣ **SecureMover-GUI.ps1** (35 KB) - Interface Graphique

**👉 Pour qui ?** Utilisateurs qui **ont PowerShell** et veulent l'interface graphique

✅ **Avantages** :
- Interface graphique identique au .exe
- Fichier plus léger (35 KB)
- Code source visible et modifiable
- Idéal pour développement/personnalisation

❌ **Inconvénients** :
- Nécessite PowerShell 5.1+
- Lancement : clic droit → "Exécuter avec PowerShell"
- Nécessite privilèges administrateur

**Quand l'utiliser ?**
- ✅ Vous voulez voir/modifier le code source
- ✅ Vous êtes développeur ou IT pro
- ✅ Vous préférez les scripts aux exécutables
- ✅ Usage sur un PC où PowerShell est déjà configuré

---

### 3️⃣ **SecureMover.ps1** (72 KB) - Ligne de Commande (CLI)

**👉 Pour qui ?** Professionnels IT et **automatisation**

✅ **Avantages** :
- **Automatisation complète** via scripts
- **Déploiement GPO/SCCM/Intune** facile
- Paramètres en ligne de commande
- Mode silencieux disponible
- Logging détaillé

❌ **Inconvénients** :
- Interface texte uniquement (pas de GUI)
- Courbe d'apprentissage plus élevée
- Nécessite connaissance PowerShell

**Quand l'utiliser ?**
- ✅ Déploiement sur plusieurs PC (entreprise)
- ✅ Automatisation via tâches planifiées
- ✅ Intégration dans d'autres scripts
- ✅ Serveurs sans interface graphique

**Exemples d'utilisation** :
```powershell
# Déplacer un profil
.\SecureMover.ps1 -UserName "JohnDoe" -NewPath "D:\Profiles"

# Mode simulation
.\SecureMover.ps1 -UserName "JohnDoe" -NewPath "D:\Profiles" -WhatIf

# Restaurer un profil
.\SecureMover.ps1 -UserName "JohnDoe" -Restore
```

---

## 🎯 Tableau Comparatif Rapide

| Critère | .exe | GUI.ps1 | CLI.ps1 |
|---------|------|---------|---------|
| **Simplicité** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Interface** | Graphique | Graphique | Texte |
| **PowerShell requis** | ❌ Non | ✅ Oui | ✅ Oui |
| **Taille** | 170 KB | 35 KB | 72 KB |
| **Automatisation** | ❌ Non | ❌ Non | ✅ Oui |
| **Déploiement IT** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Pour débutants** | ✅ Parfait | ⭐⭐⭐ | ❌ Non |
| **Pour IT pros** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 💡 Recommandations

### 🏠 **Utilisateur particulier**
👉 Téléchargez **SecureMover-GUI.exe**
- Double-cliquez et suivez l'interface

### 💼 **Administrateur IT (1-10 PC)**
👉 Utilisez **SecureMover-GUI.ps1** ou **.exe**
- Interface pratique pour chaque PC

### 🏢 **Entreprise (10+ PC)**
👉 Déployez **SecureMover.ps1** (CLI)
- Automatisation GPO/SCCM
- Script de déploiement massif

### 👨‍💻 **Développeur**
👉 Prenez **SecureMover-GUI.ps1** ou **SecureMover.ps1**
- Code source modifiable
- Personnalisation possible

---

## 🆕 Nouveautés v2.0.2

### ✨ Interface Graphique (Nouvelle !)

- **WPF moderne** avec thème sombre minimaliste
- **ComboBox améliorées** : Texte noir sur fond blanc (visible !)
- **Logs optimisés** : Limités à 3 lignes avec auto-scroll
- **Export de logs** : TXT, Markdown, HTML
- **Barre de progression** : Suivi en temps réel
- **Titre personnalisé** : "SecureMover v2.0.2 - by DrSmoke"

### 🎨 Exécutable Standalone

- **Premier .exe officiel** : Pas d'installation PowerShell requise
- **Icône personnalisée** : "Move Folder Up" par Icojam
- **Build automatique** : Script `Build-Executable.ps1` inclus
- **Métadata intégrées** : Version, auteur, copyright

### 🔧 Améliorations CLI

- **Patches critiques** : Firewall, sécurité, performances
- **Détection améliorée** : Profils et disques
- **Logging enrichi** : Plus de détails et clarté
- **Gestion erreurs** : Robustesse accrue

### 📚 Documentation

- **CONTACT.md** : WhatsApp, Email, GitHub
- **CONTRIBUTING.md** : Guide contribution open-source complet
- **CAS_USAGE.md** : 8 cas pratiques avec ROI
- **README amélioré** : Navigation facilitée

---

## 📥 Installation et Utilisation

### Exécutable (.exe)

1. **Téléchargez** `SecureMover-GUI.exe`
2. **Double-cliquez** sur le fichier
3. **Acceptez** l'élévation administrateur (UAC)
4. **Utilisez** l'interface graphique

**Note** : Au premier lancement, Windows SmartScreen peut afficher un avertissement (normal, l'exe n'est pas signé). Cliquez sur "Informations complémentaires" puis "Exécuter quand même".

### Scripts PowerShell (.ps1)

1. **Téléchargez** le script souhaité
2. **Clic droit** → "Exécuter avec PowerShell"
3. **Acceptez** l'élévation administrateur

**OU** en ligne de commande :
```powershell
# GUI
.\SecureMover-GUI.ps1

# CLI
.\SecureMover.ps1 -UserName "VotreNom" -NewPath "D:\Profiles"
```

---

## 🔒 Sécurité et Hash

### Vérification de l'Exécutable

**SHA256 de SecureMover-GUI.exe** :
```
65013299b083541a0cad6ccaf0d4c4d1c8e8d3f36c7bde99f40bdfb2f3fefd55
```

**Vérifier le hash** (PowerShell) :
```powershell
Get-FileHash SecureMover-GUI.exe -Algorithm SHA256
```

Si le hash correspond, le fichier est authentique et non modifié.

---

## 📞 Support et Contact

### 👨‍💻 Auteur
**DrSmoke** - Développeur passionné d'automatisation Windows

### 💬 Contactez-moi
- 📱 **WhatsApp** : [+242 066 50 72 75](https://wa.me/242066507275)
- 📧 **Email** : smokesama242@gmail.com
- 🐛 **Issues** : [GitHub Issues](https://github.com/BlackAngel242/SecureMov2/issues)
- 💬 **Discussions** : [GitHub Discussions](https://github.com/BlackAngel242/SecureMov2/discussions)

**Langue** : Français 🇫🇷

---

## 🤝 Contribuer

SecureMover est **open-source** ! Vos contributions sont les bienvenues.

👉 **Guide complet** : [CONTRIBUTING.md](CONTRIBUTING.md)

---

## ⚖️ Licence

**MIT License** - Gratuit et libre d'utilisation

- ✅ Usage commercial autorisé
- ✅ Modification autorisée
- ✅ Distribution autorisée
- ✅ Usage privé autorisé

Voir fichier [LICENSE](LICENSE) pour les détails complets.

---

## 🙏 Remerciements

- **Microsoft** pour PowerShell et Robocopy
- **MScholtes** pour PS2EXE
- **Icojam** pour l'icône gratuite
- **Claude AI** pour l'assistance développement
- **La communauté PowerShell** pour l'inspiration

---

## ⚠️ Avertissement

**IMPORTANT** : SecureMover modifie le registre Windows et déplace des fichiers système.

**Recommandations avant utilisation** :
1. ✅ Créez une sauvegarde complète de votre système
2. ✅ Testez d'abord en mode simulation (WhatIf / SIMULER)
3. ✅ Lisez la documentation complète
4. ✅ Conservez les fichiers de sauvegarde `.reg` générés

**Utilisez à vos propres risques.** L'auteur ne peut être tenu responsable de toute perte de données.

---

## 📊 Statistiques du Projet

- **Lignes de code** : ~700 (après nettoyage)
- **Fichiers** : 26 essentiels
- **Documentation** : 10 fichiers
- **Langues** : Français (prioritaire)
- **Licence** : MIT (Open-Source)
- **Commits** : 10+

---

## 🔄 Prochaines Versions (Roadmap)

### v2.1.0 (Planifié)
- [ ] Support multi-langues (EN, ES)
- [ ] Signature numérique de l'exécutable
- [ ] Mode portable (USB)
- [ ] Tests automatisés

### v3.0.0 (Futur)
- [ ] Support profils cloud (OneDrive, Dropbox)
- [ ] Planification automatique
- [ ] Interface web (optionnelle)

---

**🎉 Merci d'utiliser SecureMover !**

*"Déplacez vos profils en toute sécurité, libérez de l'espace, gagnez du temps !"*

---

**Version** : 2.0.2
**Date** : 02/11/2025
**Auteur** : DrSmoke
**Contact** : WhatsApp +242 066 50 72 75
