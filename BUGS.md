# Bug Tracker - SecureMover v2.0

**Responsable** : Alex Chen (Bug Manager)
**Date de Creation** : 2025-01-15
**Statut** : EN COURS DE RESOLUTION

---

## Bugs Actifs

### BUG-001 : CRITIQUE - Erreur d'encodage emojis (ligne 76-100) ✅ RÉSOLU

**Priorite** : P0 (BLOQUANT)
**Status** : RÉSOLU
**Reporter** : Test automatique
**Date** : 2025-01-15 14:40
**Resolu le** : 2025-01-15 14:50

**Description** :
Les emojis dans la configuration des icones (lignes 76-100) causaient une erreur
de parsing PowerShell. Le fichier n'etait pas correctement encode.

**Erreur d'origine** :
```
Jeton inattendu dans l'expression ou l'instruction.
Le litteral de hachage est incomplet.
```

**Solution Implementee** :
Remplacement de tous les emojis Unicode par des equivalents ASCII simples :
- ✅ -> [OK]
- ❌ -> [ERREUR]
- ⚠️ -> [!!]
- 🎉 -> [SUCCES]
- etc.

**Resultat** :
Script demarre correctement et fonctionne comme prevu.

**Testeur** : Bug Manager
**Version Fix** : v2.0.1

---

### BUG-002 : Verification fichier .reg avant restauration

**Priorite** : P2 (MOYEN)
**Status** : IDENTIFIE (QA Report)
**Reporter** : Sarah Chen (QA)
**Date** : 2025-01-15

**Description** :
Lors de la restauration, le script n'affiche pas d'avertissement clair si aucune
sauvegarde .reg n'est disponible (TC-048).

**Impact** :
- Risque de references incorrectes
- Experience utilisateur degradee

**Solution Proposee** :
Ajouter avertissement explicite ou bloquer operation si pas de .reg

**Assigne a** : Lead Developer
**ETA** : v2.1

---

### BUG-003 : Chemins >260 caracteres non supportes

**Priorite** : P1 (MAJEUR)
**Status** : CONNU (QA Report - TC-128)
**Reporter** : Sarah Chen (QA)
**Date** : 2025-01-15

**Description** :
Robocopy echoue sur les fichiers avec chemins >260 caracteres.

**Impact** :
- Echec de copie pour certains fichiers
- Utilisateurs avec structures profondes affectes

**Solution Proposee** :
Utiliser prefixe `\\?\` pour chemins longs dans Robocopy

**Assigne a** : Lead Developer
**ETA** : v2.1

---

### BUG-004 : Operations simultanees non protegees

**Priorite** : P1 (MAJEUR)
**Status** : CONNU (QA Report - TC-202)
**Reporter** : Sarah Chen (QA)
**Date** : 2025-01-15

**Description** :
Aucune protection contre le lancement de 2 instances simultanees du script.

**Impact** :
- Risque de corruption de donnees
- Conflits de fichiers

**Solution Proposee** :
Implementer mutex ou fichier lock pour exclusion mutuelle

**Assigne a** : Lead Developer
**ETA** : v2.1

---

## Bugs Resolus

### BUG-001 : Erreur encodage emojis ✅
- **Date Resolution** : 2025-01-15 14:50
- **Version** : v2.0.1
- **Impact** : Critique (script ne demarrait pas)
- **Fix** : Remplacement emojis par ASCII
- **Testeur** : Bug Manager
- **Status** : VERIFIE ET FONCTIONNE

---

## Bugs Rejetes / Won't Fix

*(Aucun)*

---

## Statistiques

| Categorie | Nombre |
|-----------|--------|
| **Total Bugs** | 4 |
| **P0 (Critique)** | 0 ✅ |
| **P1 (Majeur)** | 2 |
| **P2 (Moyen)** | 1 |
| **P3 (Mineur)** | 0 |
| **Resolus** | 1 ✅ |
| **En cours** | 0 |
| **A faire** | 3 |
| **Taux Resolution** | 25% |

---

## Prochaines Actions

1. [IMMEDIAT] Corriger BUG-001 (encodage emojis)
2. [IMMEDIAT] Tester le script apres correction
3. [v2.1] Implementer fixes pour BUG-002, 003, 004

---

**Derniere Mise a Jour** : 2025-01-15 14:40:00 UTC
