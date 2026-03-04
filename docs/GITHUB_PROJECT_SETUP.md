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
Source de verite:
1. Champs Project, types d'items, schema de relation, milestones et politiques flux sont maintenus dans `docs/KANBAN_DISCIPLINE.md` sections 7 et 8.
2. Ce document ne duplique pas ces regles et se limite au setup/import/sync.

Parametres minimaux a verifier dans le Project:
1. `Status`, `Type`, `Area`, `Priority`, `Class of Service`, `Size`.
2. Champs texte: `PBS ID`, `Requirement ID`, `Feature ID`, `WBS ID`, `Test ID`, `Cycle`.
3. Champ issue: `Milestone`.

## 2.1 Milestones a creer (par repo)
Source de verite:
1. Le catalogue complet des milestones par repository est maintenu uniquement dans `docs/KANBAN_DISCIPLINE.md` section 8.1.

Regle:
1. Ne pas dupliquer la liste ici pour eviter les desynchronisations.
2. Toute modification de milestones doit etre faite dans `docs/KANBAN_DISCIPLINE.md` puis appliquee dans GitHub.

## 3. Import CSV - methode UI (si disponible)
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
8. Verifier que `Cycle` et `Milestone` sont bien renseignes apres sync.

## 4. Import fallback via GitHub CLI (sans import CSV natif)
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
  3. ajoute les issues au project,
  4. synchronise les champs project + milestones issue + relation `Parent Issue`.

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
5. Le mode `-SyncOnly` remplit les champs Project (`Type`, `Area`, `Priority`, `Class of Service`, `Size`, `Cycle`, IDs texte) a partir des CSV + labels + body des issues.
6. Le mode `-SyncOnly` assigne aussi les milestones au niveau issue et synchronise les liens `Parent Issue` selon `Epic -> Feature -> Requirement`.
7. Le script normalise le body des issues (separateur `|` remplace par retours a la ligne) en creation et en update.
8. L'option `-ArchiveDuplicates` est desactivee. Utiliser uniquement les modes de suppression (`-DeleteImportedIssues`, `-DeleteDuplicates`, `-DeleteAllIssues`).

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
