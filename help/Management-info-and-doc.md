Pour faire un bon **PBS (Product Breakdown Structure)**, il faut d'abord comprendre sa philosophie : c'est une liste de **"noms"**, pas de "verbes". On ne décrit pas les actions (le travail), mais les **composants physiques ou logiques** qui constituent le produit final.

Voici une documentation simple pour construire et présenter un PBS efficace.

---

## 1. Ce qu'il faut mettre (Le contenu)

Un PBS doit être hiérarchique et exhaustif. On décompose du plus gros vers le plus petit :

* **Le Produit Final (Niveau 0) :** Le nom du projet (ex: *Instant-Release*).
* **Les Sous-systèmes (Niveau 1) :** Les grands ensembles autonomes (ex: *Le Logiciel, Le Matériel, La Documentation*).
* **Les Composants (Niveau 2) :** Les pièces qui forment les sous-systèmes (ex: *L'Interface, La Base de données*).
* **Les Sous-composants (Niveau 3) :** Le dernier niveau de détail (ex: *Le Module de login, Le Script d'installation*).

### La règle d'or : "L'objet, pas l'action"

| ❌ Ce qu'il ne faut PAS mettre (Tâches) | ✅ Ce qu'il FAUT mettre (Livrables) |
| --- | --- |
| Coder l'interface | Interface Utilisateur (UI) |
| Tester les bugs | Rapport de tests |
| Configurer le serveur | Environnement d'hébergement |
| Former les clients | Guide de formation |

---

## 2. Ce qu'il faut dire (La présentation orale)

Si tu dois présenter ton PBS à un jury ou à ton équipe, structure ton discours ainsi :

### A. L'objectif de la vue d'ensemble

> "Ce PBS représente l'inventaire complet de tout ce que nous devons livrer pour que le projet soit considéré comme terminé. C'est la 'liste des pièces' de notre produit."

### B. La logique de décomposition

> "Nous avons divisé le produit en **X pôles majeurs**. Le premier pôle concerne la partie **technique interne**, le second l'**interface utilisateur**, et les derniers concernent les **livrables de support** (documentation, marketing)."

### C. La délimitation du périmètre

> "Chaque bloc que vous voyez ici est un livrable tangible. Si un élément n'est pas dans ce schéma, il ne fait pas partie du périmètre de livraison de l'équipe."

### D. La transition vers l'action (Le lien avec le WBS)

> "Une fois ce catalogue de produits validé, nous allons pouvoir lister les tâches nécessaires pour construire chacun de ces éléments (ce qui deviendra notre WBS)."

---

## 3. Les 3 critères d'un PBS réussi

1. **La règle des 100% :** La somme des sous-éléments doit représenter 100% du produit parent. Si tu additionnes tes composants "Web" et "CLI", tu dois avoir ton produit entier.
2. **Exclusivité mutuelle :** Un composant ne peut pas se retrouver à deux endroits différents du schéma. Chaque bloc est unique.
3. **Livrables uniquement :** Si tu ne peux pas "toucher" ou "voir" l'élément (un fichier, un document, une puce électronique, une interface), c'est probablement une tâche et non un produit.

---

**Veux-tu que je reprenne ton schéma PlantUML précédent pour vérifier s'il respecte scrupuleusement ces définitions ?**