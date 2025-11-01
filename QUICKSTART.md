# 🚀 Guide de Démarrage Rapide - SecureMover

**Démarrez en 5 minutes !**

---

## ⚡ Installation Express

### Étape 1 : Télécharger le script

Téléchargez `SecureMover.ps1` et placez-le dans un dossier de votre choix.

### Étape 2 : Lancer le script

**Méthode la plus simple** :
1. **Clic droit** sur `SecureMover.ps1`
2. Cliquez sur **"Exécuter avec PowerShell"**
3. Acceptez les privilèges administrateur si demandé

**Alternative** (si erreur de politique) :

Ouvrez PowerShell en tant qu'Admin et tapez :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Puis relancez le script.

---

## 📋 Utilisation Rapide

### Scénario 1 : Déplacer mes données vers D:

**Objectif** : Protéger vos données en les déplaçant sur une autre partition.

1. Lancez le script
2. Choisissez **[1] Deplacer un Profil Utilisateur**
3. Sélectionnez votre profil (généralement l'option 1)
4. Entrez **D** (ou la lettre de votre partition)
5. Vérifiez le récapitulatif et tapez **O** pour confirmer
6. Attendez la fin (5-30 min selon vos données)
7. **REDÉMARREZ votre ordinateur**

✅ **Terminé !** Vos fichiers sont maintenant sur D: et Windows les utilise automatiquement.

---

### Scénario 2 : Faire une sauvegarde sur clé USB

**Objectif** : Créer une copie de sécurité sans toucher au système.

1. **Insérez votre clé USB ou disque externe**
2. Lancez le script
3. Choisissez **[3] Creer une sauvegarde d'un Profil**
4. Sélectionnez votre profil
5. Sélectionnez le lecteur USB détecté
6. Confirmez avec **O**
7. Attendez la copie

✅ **Terminé !** Votre sauvegarde est sur la clé USB. Aucune modification système.

---

### Scénario 3 : Restaurer mes données à leur place d'origine

**Objectif** : Remettre tout comme avant (C:\Users).

1. Lancez le script
2. Choisissez **[2] Restaurer un Profil Utilisateur**
3. Sélectionnez le profil à restaurer
4. Confirmez avec **O**
5. Attendez la restauration
6. **REDÉMARREZ votre ordinateur**

✅ **Terminé !** Vos fichiers sont revenus en C:\Users.

---

## ⚠️ Points Importants

### Avant de Lancer le Script

- [ ] **Fermez TOUTES vos applications** (Word, Excel, Chrome, etc.)
- [ ] **Vérifiez l'espace disque** sur la partition de destination
- [ ] **Branchez votre ordinateur sur secteur** (portable)
- [ ] **Créez un point de restauration Windows** (recommandé)

### Pendant l'Opération

- ⏳ **NE PAS INTERROMPRE** le processus
- ⏳ **NE PAS ÉTEINDRE** l'ordinateur
- ⏳ Attendez le message de succès final

### Après l'Opération

- 🔄 **REDÉMARREZ TOUJOURS** votre ordinateur (sauf pour les sauvegardes)
- 💾 **Conservez les fichiers `.reg`** créés dans le dossier du script
- 📝 **Vérifiez le fichier log** en cas de problème

---

## ❓ Problèmes Fréquents

### "L'exécution de scripts est désactivée"

**Solution** :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Accès refusé"

**Solutions** :
1. Fermez **TOUTES** vos applications
2. Lancez le script **en tant qu'Administrateur**
3. Redémarrez et réessayez

### Les émojis ne s'affichent pas

**Solution** : Utilisez **Windows Terminal** au lieu de la console classique.

Téléchargez-le depuis le Microsoft Store : [Windows Terminal](https://aka.ms/terminal)

### "Espace disque insuffisant"

**Solutions** :
1. Nettoyez la partition de destination
2. Choisissez une autre partition avec plus d'espace
3. Utilisez l'outil de nettoyage Windows (cleanmgr)

---

## 📞 Besoin d'Aide ?

- 📖 **Documentation complète** : Lisez `README.md`
- 🐛 **Bug ou problème** : Vérifiez `SecureMover.log`
- 💬 **Questions** : Ouvrez une issue sur GitHub

---

## ✅ Checklist de Sécurité

Avant votre premier déplacement, vérifiez :

- [ ] J'ai lu ce guide
- [ ] J'ai fermé toutes mes applications
- [ ] J'ai vérifié l'espace disque disponible
- [ ] J'ai créé un point de restauration Windows
- [ ] Je suis prêt à redémarrer après l'opération

---

## 🎯 Prochaines Étapes

Après votre première utilisation :

1. 📚 Lisez le **README.md complet** pour découvrir toutes les fonctionnalités
2. 💾 Configurez des **sauvegardes régulières** avec l'option [3]
3. 🌟 Partagez SecureMover si vous l'avez trouvé utile !

---

<div align="center">

**Bon démarrage avec SecureMover ! 🛡️**

*En cas de doute, consultez la documentation complète.*

[📖 README Complet](README.md) | [🐛 Rapporter un Bug](https://github.com/DrSmoke/SecureMover/issues)

</div>
