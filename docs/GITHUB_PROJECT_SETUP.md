# GITHUB PROJECT SETUP - InstantRelease

## 1. Fichiers CSV a importer
Tous les CSV sont centralises dans `docs/github_project_csv/`.

1. Epics:
   - `docs/github_project_csv/GITHUB_PROJECT_EPICS_IMPORT.csv` (7 items)
2. Features parents:
   - `docs/github_project_csv/GITHUB_PROJECT_FEATURES_IMPORT.csv` (20 items)
3. Requirements:
   - `docs/github_project_csv/GITHUB_PROJECT_REQUIREMENTS_IMPORT.csv` (41 items)
4. Documentation:
   - `docs/github_project_csv/GITHUB_PROJECT_DOCUMENTATION_IMPORT.csv` (6 items)

Ordre recommande:
1. importer `EPICS`,
2. importer `FEATURES`,
3. importer `REQUIREMENTS`,
4. importer `DOCUMENTATION`.

## 2. Setup initial du Project
Configurer un project unique portfolio (multi-repo) avec les champs de `docs/KANBAN_DISCIPLINE.md` section 8:
1. `Status` (single select): Backlog Qualifie, Ready, In Progress, Review, Ready Release, Blocked, Done
2. `Type` (single select): Epic, Feature, Requirement, Task, Bug, Incident, Risk, Documentation
3. `Repository` (si champ custom active): instant-release_API, instant-release_APP, instant-release_VITRINE, instant-release_ACTIONS
4. `Area` (single select): DevOps, Web, API, UX/UI, Marketing, Docs
5. `Priority` (single select): P0, P1, P2, P3
6. `Class of Service` (single select): Expedite, Fixed Date, Standard, Intangible
7. `PBS ID` (text)
8. `Requirement ID` (text)
9. `Feature ID` (text)
10. `WBS ID` (text)
11. `Test ID` (text)
12. `Size` (single select): XS, S, M, L
13. `Cycle` (text)

## 3. Import CSV - methode UI (si disponible dans ton interface)
1. Ouvrir le Project.
2. Importer `GITHUB_PROJECT_EPICS_IMPORT.csv`.
3. Verifier mapping colonne->champ (noms de colonnes deja alignes).
4. Importer `GITHUB_PROJECT_FEATURES_IMPORT.csv`.
5. Importer `GITHUB_PROJECT_REQUIREMENTS_IMPORT.csv`.
6. Importer `GITHUB_PROJECT_DOCUMENTATION_IMPORT.csv`.
7. Controler:
   - total items attendus: `74`
   - `Type=Epic`: `7`
   - `Type=Feature`: `20`
   - `Type=Requirement`: `41`
   - `Type=Documentation`: `6`

## 4. Import fallback (sans import CSV natif) via GitHub CLI
Prerequis:
1. installer `gh` CLI.
2. authentifier avec scope projet:
   - `gh auth refresh -s project`
3. disposer du project title exact.
4. droits `write` sur les 4 repositories (creation labels/issues).

Script PowerShell (Windows) recommande:
- fichier: `setup_project.ps1` (ou `docs/setup_project.ps1`)
- ce script:
  1. synchronise les labels manquants,
  2. importe epics + features + requirements + documentation,
  3. ajoute les issues au project.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\setup_project.ps1
```

Backfill des colonnes Project (sans recreer d'issues):
```powershell
.\setup_project.ps1 -SyncOnly
```

Reset cible (supprime uniquement les issues provenant des CSV import):
```powershell
.\setup_project.ps1 -DeleteImportedIssues -SyncOnly
```

Reset total (supprime toutes les issues des 4 repos):
```powershell
.\setup_project.ps1 -DeleteAllIssues -SyncOnly
```

Repair si le Project ne charge plus (`This project failed to load`):
```powershell
.\setup_project.ps1 -ResetProjectItems -SyncOnly
```

Puis reimport propre:
```powershell
.\setup_project.ps1
```

Note:
1. Cette methode remplit a coup sur `Type/Area/Priority` via labels et ajoute les items au project.
2. Les colonnes custom texte (`PBS ID`, `WBS ID`, `Requirement ID`, `Feature ID`, `Test ID`) sont dans le CSV et dans le body issue; si besoin, completer ces colonnes en bulk-edit dans le project.
3. La creation des labels est idempotente: relancer le script ne casse pas les labels existants.
4. Si un repo est inaccessible, le script affiche un warning et continue sur les autres repos.
5. Le mode `-SyncOnly` remplit les champs Project (`Type`, `Area`, `Priority`, `Class of Service`, `Size`, IDs texte) a partir des CSV + labels + body des issues.
6. L'option `-ArchiveDuplicates` est desactivee. Utiliser uniquement les modes de suppression (`-DeleteImportedIssues`, `-DeleteDuplicates`, `-DeleteAllIssues`).

## 4.1 Depannage rapide
Erreur type:
`Impossible de lister les labels pour <org>/<repo>`

Checklist:
1. verifier l'auth:
   - `gh auth status`
2. rafraichir les scopes:
   - `gh auth refresh -s repo -s project`
3. verifier l'acces repo:
   - `gh repo view yohemm/instant-release_VITRINE`
4. verifier le droit ecriture (`push`) sur le repo:
   - `gh api repos/yohemm/instant-release_VITRINE --jq .permissions.push`
   - attendu: `true`
5. verifier la valeur de `$Org` dans `setup_project.ps1`.

Si `gh repo view` echoue sur un repo:
1. corriger les droits GitHub (read/write sur le repo),
2. ou laisser le script continuer (les items de ce repo seront skip).

## 5. Setup automations du project
Aligner avec `docs/KANBAN_DISCIPLINE.md` section 9:
1. item cree -> `Backlog Qualifie`
2. PR ouverte liee -> `In Progress`
3. PR en review -> `Review`
4. PR mergee (CI verte) -> `Ready Release`
5. deploiement/release manuelle + close issue -> `Done`
6. label `status/blocked` -> `Blocked`

## 6. Verification finale
Checklist:
1. Tous les items ont `Type`, `Priority`, `Area` (et `Repository` si ce champ custom est active).
2. Aucune issue `Requirement` sans `Requirement ID`.
3. Les items `Ready Release` ont evidence test/CI.
4. Les items `Done` ont evidence release (run manuel + lien release).

## 7. Version
- Version: `GPS-v1.1`
- Statut: `Operationnel`
- Date: `2026-03-03`
