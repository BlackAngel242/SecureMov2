# 🤝 Contribuer à SecureMover

Merci de votre intérêt pour contribuer à SecureMover ! Ce document vous guide pour participer au développement.

---

## 📋 Table des Matières

1. [Code de Conduite](#code-de-conduite)
2. [Comment Contribuer](#comment-contribuer)
3. [Signaler un Bug](#signaler-un-bug)
4. [Proposer une Fonctionnalité](#proposer-une-fonctionnalité)
5. [Pull Requests](#pull-requests)
6. [Style de Code](#style-de-code)
7. [Tester vos Modifications](#tester-vos-modifications)
8. [Communauté](#communauté)

---

## 📜 Code de Conduite

En participant à ce projet, vous acceptez de maintenir un environnement respectueux et inclusif.

**Règles de base** :
- ✅ Soyez respectueux et professionnel
- ✅ Acceptez les critiques constructives
- ✅ Concentrez-vous sur ce qui est meilleur pour la communauté
- ❌ Pas de harcèlement, discrimination ou trolling
- ❌ Pas de spam ou publicité

---

## 🚀 Comment Contribuer

### 1. Fork le Projet

```bash
# Cliquez sur "Fork" sur GitHub ou :
git clone https://github.com/DrSmoke/SecureMover.git
cd SecureMover
```

### 2. Créez une Branche

```bash
# Pour une nouvelle fonctionnalité
git checkout -b feature/ma-fonctionnalite

# Pour un bug fix
git checkout -b fix/nom-du-bug

# Pour de la documentation
git checkout -b docs/amelioration-readme
```

### 3. Faites vos Modifications

- Suivez le [style de code](#style-de-code)
- Ajoutez des commentaires clairs
- Testez vos modifications

### 4. Commitez

Utilisez des messages de commit descriptifs selon la convention :

```bash
# Format
type(scope): description courte

# Exemples
feat(GUI): Ajout bouton annulation operation
fix(CLI): Correction bug detection profils
docs(README): Mise a jour guide installation
style(GUI): Amelioration theme sombre
refactor(Core): Optimisation fonction deplacement
test(CLI): Ajout tests unitaires profils
```

**Types de commit** :
- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation
- `style`: Mise en forme (pas de changement de code)
- `refactor`: Refactorisation
- `test`: Ajout/modification de tests
- `chore`: Tâches de maintenance

### 5. Poussez vers votre Fork

```bash
git push origin feature/ma-fonctionnalite
```

### 6. Ouvrez une Pull Request

1. Allez sur https://github.com/DrSmoke/SecureMover
2. Cliquez sur "New Pull Request"
3. Sélectionnez votre branche
4. Remplissez le template de PR (voir ci-dessous)

---

## 🐛 Signaler un Bug

**Avant de signaler** :
1. ✅ Vérifiez que le bug n'est pas déjà signalé dans [Issues](https://github.com/DrSmoke/SecureMover/issues)
2. ✅ Assurez-vous d'utiliser la dernière version
3. ✅ Testez avec une installation propre si possible

**Créer un rapport de bug** :

Allez sur [Issues](https://github.com/DrSmoke/SecureMover/issues/new) et utilisez ce template :

```markdown
**Description du Bug**
Une description claire et concise du problème.

**Étapes pour Reproduire**
1. Lancer SecureMover-GUI.exe
2. Sélectionner profil 'TestUser'
3. Cliquer sur DÉPLACER vers D:\
4. Observer l'erreur

**Comportement Attendu**
Le profil devrait être déplacé vers D:\ sans erreur.

**Comportement Actuel**
Message d'erreur : "Accès refusé au registre"

**Captures d'Écran**
[Si applicable, ajoutez des captures]

**Logs**
```
[Collez les logs du bouton EXPORTER]
```

**Environnement**
- SecureMover : v2.0.2
- Windows : 11 Pro 23H2 (Build 22631)
- PowerShell : 5.1.22621
- Mode : GUI / CLI
- Privilèges : Administrateur Oui/Non

**Informations Complémentaires**
Toute autre information pertinente.
```

---

## 💡 Proposer une Fonctionnalité

**Avant de proposer** :
1. ✅ Vérifiez que la fonctionnalité n'existe pas déjà
2. ✅ Consultez les [Issues](https://github.com/DrSmoke/SecureMover/issues) pour éviter les doublons
3. ✅ Réfléchissez à l'utilité pour la communauté

**Template de proposition** :

```markdown
**Problème à Résoudre**
Décrivez le besoin ou le problème que cette fonctionnalité résoudrait.

**Solution Proposée**
Comment vous imaginez que cette fonctionnalité fonctionne.

**Alternatives Considérées**
Autres façons de résoudre le problème.

**Cas d'Usage**
Exemples concrets d'utilisation.

**Bénéfices**
Qui bénéficiera de cette fonctionnalité et pourquoi.
```

**Labels à utiliser** :
- `enhancement` : Nouvelle fonctionnalité
- `documentation` : Amélioration de docs
- `question` : Question/discussion
- `help wanted` : Besoin d'aide

---

## 🔀 Pull Requests

### Template de Pull Request

```markdown
**Description**
Résumé des changements apportés.

**Type de Changement**
- [ ] Bug fix (changement qui corrige un problème)
- [ ] Nouvelle fonctionnalité (changement qui ajoute une fonctionnalité)
- [ ] Breaking change (changement qui casse la compatibilité)
- [ ] Documentation

**Motivation et Contexte**
Pourquoi ce changement est nécessaire ? Quel problème résout-il ?

**Comment a-t-il été Testé ?**
Décrivez les tests effectués :
- [ ] Tests manuels CLI
- [ ] Tests manuels GUI
- [ ] Tests sur Windows 10
- [ ] Tests sur Windows 11
- [ ] Tests en tant qu'admin
- [ ] Tests en tant qu'utilisateur standard

**Captures d'Écran** (si applicable)

**Checklist**
- [ ] Mon code suit le style du projet
- [ ] J'ai commenté les parties complexes
- [ ] J'ai mis à jour la documentation
- [ ] Mes changements ne génèrent pas de warnings
- [ ] J'ai testé sur Windows 10 et/ou 11
- [ ] J'ai vérifié qu'il n'y a pas de régression
```

### Processus de Review

1. **Soumission** : Votre PR est automatiquement vérifiée
2. **Review** : DrSmoke ou un mainteneur examine le code
3. **Feedback** : Des modifications peuvent être demandées
4. **Approbation** : Une fois validée, la PR est mergée
5. **Merci !** : Vous êtes ajouté aux contributeurs 🎉

**Temps de réponse** : Généralement 2-7 jours

---

## 🎨 Style de Code

### PowerShell

```powershell
# ✅ BON : Noms de fonctions clairs et descriptifs
function Move-UserProfile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserName,

        [Parameter(Mandatory=$true)]
        [string]$DestinationPath
    )

    # Code avec commentaires clairs
    Write-Verbose "Deplacement du profil $UserName vers $DestinationPath"

    # ...
}

# ❌ MAUVAIS : Noms cryptiques, pas de commentaires
function mvp {
    param($u,$d)
    # Code sans explication
}
```

**Conventions** :
- ✅ Utilisez `PascalCase` pour les fonctions : `Get-ProfilePath`
- ✅ Utilisez `camelCase` pour les variables : `$userName`
- ✅ Indentation : 4 espaces (pas de tabs)
- ✅ Commentaires en français pour ce projet
- ✅ Longueur de ligne max : 120 caractères
- ✅ Toujours utiliser `[CmdletBinding()]` pour les fonctions avancées

### XAML (GUI)

```xml
<!-- ✅ BON : Indentation claire, noms descriptifs -->
<Button x:Name="MoveProfileButton"
        Content="DÉPLACER"
        Style="{StaticResource ModernButton}"
        Margin="10,5"/>

<!-- ❌ MAUVAIS : Tout sur une ligne -->
<Button x:Name="btn1" Content="OK" Margin="5"/>
```

### Commits

```bash
# ✅ BON
feat(GUI): Ajout confirmation avant deplacement profil

Ajoute une boite de dialogue de confirmation avant de deplacer
un profil pour eviter les suppressions accidentelles.

Closes #42

# ❌ MAUVAIS
fix bug
```

---

## 🧪 Tester vos Modifications

### Tests Manuels Obligatoires

**Avant de soumettre une PR**, testez :

#### 1. Tests CLI

```powershell
# Test WhatIf (simulation)
.\SecureMover.ps1 -UserName "TestUser" -NewPath "D:\Profiles" -WhatIf

# Test réel (créez un profil de test !)
.\SecureMover.ps1 -UserName "TestUser" -NewPath "D:\Profiles"

# Test restauration
.\SecureMover.ps1 -UserName "TestUser" -Restore
```

#### 2. Tests GUI

- [ ] Lancement sans erreur
- [ ] ComboBox profils se remplit
- [ ] ComboBox disques se remplit
- [ ] Texte noir visible dans ComboBox
- [ ] Boutons DÉPLACER, RESTAURER, SAUVEGARDER, SIMULER fonctionnent
- [ ] Logs limités à 3 lignes
- [ ] Export logs (TXT, MD, HTML) fonctionne
- [ ] Barre de progression s'affiche

#### 3. Tests Exécutable

```powershell
cd Release
.\Build-Executable.ps1
# Tester l'exe généré
```

### Environnements de Test

Testez sur au moins un de ces environnements :

- **Windows 10** : Version 21H2 ou supérieure
- **Windows 11** : Version 22H2 ou supérieure
- **PowerShell** : 5.1 minimum
- **Privilèges** : Administrateur requis

### Créer un Profil de Test

```powershell
# NE JAMAIS tester sur un vrai profil utilisateur !
# Créez un profil de test :

net user TestSecureMover P@ssw0rd123 /add
# Ouvrez une session avec ce compte
# Puis testez SecureMover dessus
# Supprimez-le après : net user TestSecureMover /delete
```

---

## 🌍 Communauté

### Où Discuter ?

**GitHub Discussions** : https://github.com/DrSmoke/SecureMover/discussions
- Questions générales
- Partage d'expériences
- Tutoriels

**WhatsApp** : +242 066 50 72 75
- Contact direct avec DrSmoke
- Support urgent

### Contributeurs

Merci à tous les contributeurs ! 🙏

Votre nom sera ajouté ici après votre première contribution acceptée.

---

## 📚 Ressources Utiles

### Documentation PowerShell

- [PowerShell Documentation Officielle](https://docs.microsoft.com/powershell/)
- [WPF Tutorial](https://wpftutorial.net/)
- [PS2EXE GitHub](https://github.com/MScholtes/PS2EXE)

### Outils Recommandés

- **Visual Studio Code** avec extension PowerShell
- **Windows Terminal** pour tester
- **Git** pour le versioning

---

## 📞 Besoin d'Aide ?

**Questions sur le code** : Ouvrez une issue avec le label `question`
**Contact direct** : Voir `CONTACT.md`
**Documentation** : Consultez le `README.md`

---

## 🏆 Reconnaissance

Les contributeurs les plus actifs seront :
- Mentionnés dans le fichier `CONTRIBUTORS.md`
- Cités dans les release notes
- Ajoutés à la section remerciements

---

## ⚖️ Licence

En contribuant à SecureMover, vous acceptez que vos contributions soient sous licence **MIT**.

---

**Merci de contribuer à SecureMover !** 🚀

Ensemble, rendons la gestion des profils Windows plus facile pour tous.

---

**Dernière mise à jour** : 02/11/2025
**Maintainer** : DrSmoke
