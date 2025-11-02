# Vérification de l'Exécutable SecureMover-GUI.exe

## Informations Fichier

**Date de compilation** : 02/11/2025 04:17:04

### Propriétés

| Propriété | Valeur |
|-----------|--------|
| **Nom** | SecureMover-GUI.exe |
| **Taille** | 60 416 bytes (59 KB) |
| **Version fichier** | 2.0.2.0 |
| **Version produit** | 2.0.2.0 |
| **Entreprise** | DrSmoke |
| **Description** | SecureMover v2.0.2 - by DrSmoke |

### Hash SHA256

```
6350fc2e87de815fef54331e2bf501b4586ba587ed0ffe14f5603fb6d55e770d
```

## Checklist de Tests

### Tests Basiques

- [ ] **Lancement** : L'exe se lance sans erreur
- [ ] **Élévation admin** : Demande UAC correctement
- [ ] **Interface** : Fenêtre WPF s'affiche (920x720)
- [ ] **Titre** : "SecureMover v2.0.2 - by DrSmoke"
- [ ] **Thème** : Dark theme (#1E1E1E) appliqué

### Tests ComboBox (UX fixes)

- [ ] **Profils** : Liste déroulante visible
- [ ] **Disques** : Liste déroulante visible
- [ ] **Texte fermé** : Texte NOIR sur fond BLANC
- [ ] **Texte sélectionné** : Visible et lisible
- [ ] **Hover** : Highlight bleu (#0E639C) fonctionne

### Tests Logs

- [ ] **Hauteur** : Limité à 3 lignes (~90px)
- [ ] **Auto-scroll** : Défilement automatique
- [ ] **Caractères** : [OK], [ERR], [WARN], [INFO] affichés
- [ ] **Bouton Export** : Présent et fonctionnel
- [ ] **Export TXT** : Fonctionne
- [ ] **Export MD** : Fonctionne
- [ ] **Export HTML** : Fonctionne

### Tests Boutons

- [ ] **DÉPLACER** : Bouton actif
- [ ] **RESTAURER** : Bouton actif
- [ ] **SAUVEGARDER** : Bouton actif
- [ ] **SIMULER** : Bouton actif (WhatIf)
- [ ] **EXPORTER** : Bouton logs actif

### Tests Fonctionnalités

- [ ] **Détection profils** : Liste profils chargée
- [ ] **Détection disques** : Liste disques chargée
- [ ] **Simulation** : Mode WhatIf fonctionne
- [ ] **Logs temps réel** : Messages apparaissent
- [ ] **Barre progression** : Affichée pendant opération

### Tests Standalone

- [ ] **Pas de PowerShell requis** : Fonctionne sans PS installé
- [ ] **Runtime embarqué** : Pas d'erreur de dépendance
- [ ] **Portable** : Copie sur autre PC fonctionne

## Résultats

**Date de test** : _À remplir_

**Testeur** : _À remplir_

**Statut global** :
- [ ] ✅ TOUS LES TESTS PASSENT
- [ ] ⚠️ TESTS PARTIELS (détails ci-dessous)
- [ ] ❌ ÉCHEC (détails ci-dessous)

### Notes

```
[Insérer notes de test ici]
```

### Problèmes Identifiés

```
[Insérer bugs/problèmes ici]
```

---

**Version du document** : 1.0.0
**Auteur** : DrSmoke
