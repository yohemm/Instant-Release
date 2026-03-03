# PAQ - Plan d'Assurance Qualite - InstantRelease

## 1. Objet
Ce document definit le **Plan d'Assurance Qualite (PAQ) officiel** du programme InstantRelease.
Il precise:
1. comment l'equipe travaille,
2. quelles regles qualite sont obligatoires,
3. comment les livraisons sont validees,
4. quels seuils bloquent ou autorisent une release.

Ce PAQ est operationnel pour les 4 repositories:
- `instant-release_API`
- `instant-release_APP`
- `instant-release_ACTIONS`
- `instant-release_VITRINE`

## 2. References et regle de precedence
References normatives:
- `docs/OBS.md`
- `docs/WBS.md`
- `docs/PBS.md`
- `docs/KANBAN_DISCIPLINE.md`
- `docs/INFRA_SERVER_SYSTEM.md`
- `docs/HARDWARE_REQUIREMENTS.md`
- `docs/TRACEABILITY_MATRIX.md`
- `docs/FULL_DOCS.md`

Regles de precedence:
1. Organisation (roles, ownership, RACI): `docs/OBS.md` prevaut.
2. Flux Kanban (statuts, WIP, policy tickets): `docs/KANBAN_DISCIPLINE.md` prevaut.
3. En cas de conflit sur les regles qualite/tests/gates/release acceptance, **ce PAQ prevaut**.

Matrice de source unique:
| Theme | Source unique |
|---|---|
| Decoupage produit | `docs/PBS.md` |
| Decoupage travail/livrables | `docs/WBS.md` |
| Organisation, ownership, RACI, escalade | `docs/OBS.md` |
| Architecture infra serveur/systeme | `docs/INFRA_SERVER_SYSTEM.md` |
| Hardware requirements et budget materiel | `docs/HARDWARE_REQUIREMENTS.md` |
| Tracabilite operationnelle requirements->tests->evidence | `docs/TRACEABILITY_MATRIX.md` |
| Workflow Kanban, WIP, classes de service, tickets, automations, KPI flux | `docs/KANBAN_DISCIPLINE.md` |
| Politique qualite, tests, gates, supply chain, DoR/DoD, derogations qualite | `docs/PAQ.md` |

## 3. Baseline projet
| Element | Valeur |
|---|---|
| Equipe | Voir `docs/OBS.md` section 2 |
| Pilotage | Voir `docs/KANBAN_DISCIPLINE.md` sections 4, 5, 6 et 12 |
| Versioning | Independant par repository |
| Convention commit | Angular / Conventional Commits |
| Mode release | A la demande, a la feature, a la necessite |
| Mode pipeline | Push/merge = CI uniquement, deploiement manuel (`workflow_dispatch`) |
| Registre packages partage inter-repo | GitHub Packages prive (organisation) |
| Objectif coverage | 100% |

## 4. Organisation qualite (derivee OBS)
Source unique des responsabilites:
1. Ownership repository: `docs/OBS.md` section 5.
2. RACI par lot WBS: `docs/OBS.md` section 7.
3. RACI operationnel flux: `docs/OBS.md` section 8.

Regles qualite appliquees:
1. Toute derogation qualite doit etre approuvee par le manager et tracee.
2. Toute decision go/no-go doit etre reliee a une evidence package de release.
3. Aucun lot WBS ne peut etre ferme sans preuves test + CI.

## 5. Processus de developpement
### 5.1 Choix de methode
| Decision | Rationale | Impact |
|---|---|---|
| Kanban discipline multi-repo | Equipe reduite, flux continu, priorites variables | Priorisation continue, limitation WIP, reduction des blocages |
| Cadence de pilotage alignee Kanban | Besoin de pilotage frequent sans overhead Scrum lourd | Boucle courte de decision/replanification |

### 5.2 Workflow operationnel
Workflow officiel: voir `docs/KANBAN_DISCIPLINE.md` section 4.

Regles de qualite appliquees au workflow:
1. Passage vers `Ready` conditionne par DoR (section 11 de ce PAQ).
2. Passage vers `Done` conditionne par DoD (section 11 de ce PAQ).
3. Les politiques WIP et priorisation restent gerees uniquement dans le document Kanban.

## 6. Gestion de configuration (Git + CI + branches)
### 6.1 Strategie Git
| Decision | Rationale | Impact |
|---|---|---|
| `gitflow light` | Besoin d'environnement progressif (dev -> staging -> main) avec complexite maitrisee | Flux clair de promotion et limitation du risque de regression |
| Branches de travail `feat/*` et `fix/*` | Segmentation propre des changements | Tracabilite fine des evolutions/corrections |
| Branches d'integration `dev`, `staging`, `main` | Validation progressive avant production | Gates successives et go/no-go explicite |

Flux de merge officiel:
1. `feat/*` ou `fix/*` -> PR vers `dev`.
2. `dev` -> PR vers `staging` apres validation fonctionnelle.
3. `staging` -> PR vers `main` apres readiness release.
4. Correctif critique: `hotfix/*` -> `main`, puis back-merge vers `staging` et `dev`.

### 6.2 Convention commits
Convention obligatoire: Angular / Conventional Commits.

Types minimum:
- `feat:`
- `fix:`
- `docs:`
- `refactor:`
- `test:`
- `chore:`

Regles:
1. Message commit explicite et court.
2. Commit de merge direct sur `main` interdit.
3. Toute PR reference l'issue associee (`Closes #ID` ou `Refs #ID`).

### 6.3 Protection des branches (obligatoire)
Appliquees a `dev`, `staging`, `main`:
1. Push direct interdit.
2. PR obligatoire.
3. CI verte obligatoire avant merge.
4. Au moins 1 review approuvee.
5. Historique linearise (squash ou rebase selon repo policy).

### 6.4 Mode CI/CD applique (aligne infra)
1. Push/merge sur `feat/*`, `fix/*`, `dev`, `staging`, `main`:
   - CI uniquement (build/tests/scans), sans deploiement automatique.
2. Deploiement `staging`:
   - declenchement manuel via `workflow_dispatch` sur branche `staging`.
3. Deploiement `production`:
   - declenchement manuel via `workflow_dispatch` sur branche `main`,
   - apres decision go/no-go.

### 6.5 Registre packages prive (partage inter-repo)
1. Registre npm prive retenu: `GitHub Packages`.
2. Publication et consommation reservees aux membres de l'organisation GitHub.
3. Authentification via token GitHub (PAT) pour developpeurs et service CI.

## 7. Gestion tickets et tracabilite
Source unique du pilotage ticket:
1. Outils, champs, taxonomie, labels: `docs/KANBAN_DISCIPLINE.md` sections 7 et 8.
2. Workflow et automations: `docs/KANBAN_DISCIPLINE.md` sections 4, 5 et 9.
3. SLA par classe de service: `docs/KANBAN_DISCIPLINE.md` section 6.

Exigence qualite de tracabilite:
`PBS ID -> WBS ID -> Issue -> PR -> Test evidence -> Release`.

## 8. Strategie de test
### 8.1 Couches obligatoires
| Couche | Cible | Regle |
|---|---|---|
| Unitaires (services) | Services API + modules coeur | Obligatoire pour toute logique metier |
| End-to-end (controllers) | Controllers/API endpoints | Obligatoire pour toute evolution endpoint |
| Integration (workflows/modules) | CI/CD, scripts Bash, contrats I/O | Obligatoire pour tout changement ACTIONS/CI |
| Cross-repo E2E | Scenarios API + APP + ACTIONS + VITRINE | Obligatoire avant go/no-go multi-repo |

### 8.2 Mapping changement -> tests minimaux
| Changement | Tests minimaux |
|---|---|
| Service metier/API | Unitaires services |
| Controller/API endpoint | E2E controllers + unitaires associes |
| Workflow GitHub Action/Bash | Integration workflows/modules |
| Changement release/securite | Integration + checks securite + checks supply chain |

## 9. Gates qualite, securite et supply chain
### 9.1 Seuils bloquants
| Gate | Seuil | Blocage |
|---|---|---|
| Coverage | 100% | Bloquant |
| Tests obligatoires | 100% des suites attendues passent | Bloquant |
| Lint | 0 erreur bloquante | Bloquant |
| Securite dependances/code | `critical` only bloque | Bloquant sur severite `critical` |
| CI | Tous checks requis verts | Bloquant |

### 9.2 Exception coverage
| Decision | Rationale | Impact |
|---|---|---|
| Exception possible uniquement via validation manager | Maintenir exigence forte tout en gerant cas reel exceptionnel | Derogation encadree, non automatique |

Procedure derogation coverage:
1. Ouvrir issue `type/risk` ou `type/bug` liee a la PR.
2. Documenter ecart (pourcentage manque + cause + perimetre impacte).
3. Obtenir validation explicite manager.
4. Creer ticket de remediation date et priorise.
5. Interdire nouvelle derogation sur le meme perimetre sans remediation executee.

### 9.3 Supply chain obligatoire
| Controle | Portee obligatoire |
|---|---|
| SBOM | Au minimum `instant-release_ACTIONS`, `instant-release_API` |
| Provenance de build | Au minimum `instant-release_ACTIONS`, `instant-release_API` |
| Signature tags | Obligatoire sur les 4 repos |

Plan d'extension:
1. Etendre provenance a `instant-release_APP`.
2. Etendre provenance a `instant-release_VITRINE`.

## 10. Gestion des releases
### 10.1 Politique de cadence
| Decision | Rationale | Impact |
|---|---|---|
| Release par repo a la demande / a la feature / a la necessite | Alignement sur flux Kanban et priorites reel projet | Evite batches lourds, favorise livraison incremental |

### 10.2 Pipeline release minimal
1. Ticket en `Ready Release` avec DoD cochee.
2. Validation tests + CI + gates securite/supply chain.
3. Decision go/no-go (MGR + leads).
4. Deploiement manuel sur l'environnement cible (`workflow_dispatch`).
5. Verification post-deploiement.
6. Tag + release du repo concerne.
7. Evidence package archivee.
8. Cloture issue et passage `Done`.

### 10.3 Evidence package obligatoire
Contenu minimal:
1. Lien issue + PR mergee.
2. Resultats tests (unit/e2e/integration selon scope).
3. Resultat coverage.
4. Resultat scans securite.
5. Preuve SBOM/provenance/signature si applicable.
6. Tag/release URL.

## 11. Definition of Ready / Definition of Done consolidees
### 11.1 Definition of Ready (DoR)
Un ticket peut entrer en `Ready` seulement si:
1. Scope clair (in/out).
2. Repository et owner assignes.
3. PBS ID et WBS ID renseignes.
4. Acceptance criteria testables presents.
5. Test plan present.
6. Dependances explicites.

### 11.2 Definition of Done (DoD)
Un ticket peut entrer en `Done` seulement si:
1. Code/artefacts livres dans le repo cible.
2. Tests obligatoires executes et passes.
3. Coverage gate respectee ou derogation manager validee.
4. CI verte + securite/supply chain conformes.
5. Documentation mise a jour si impact.
6. Preuves jointes dans l'issue (PR, CI, release).

## 12. KPIs et pilotage qualite
| KPI qualite | Definition | Cible initiale |
|---|---|---|
| Coverage Compliance | % de tickets sans derogation coverage | >= 95% par cycle |
| Derogations ouvertes | Nombre de derogations qualite non fermees | 0 en fin de cycle |
| Security Critical Open | Vulns `critical` non corrigees | 0 avant release |
| Release Evidence Completeness | % de releases avec package complet | 100% |
| Retours post-release critiques | Incidents critiques apres release | 0 cible |

Regles:
1. Les KPI flux (lead time, throughput, WIP aging...) sont suivis dans `docs/KANBAN_DISCIPLINE.md` section 14.
2. Les KPI qualite ci-dessus sont revus a chaque Jour 3.
3. Recalibrage cibles qualite tous les 4 cycles mesures.

## 13. Gestion des exceptions et escalade
Toute derogation (test reporte, gate contournee, release forcee):
1. Est documentee dans l'issue.
2. Est approuvee par le manager.
3. Possede un ticket de remediation date.
4. Est revue en instance Jour 3 suivante.

Escalade:
1. Les niveaux N1/N2/N3 sont definis uniquement dans `docs/OBS.md` section 11.
2. Ce PAQ ne maintient pas de copie des delais d'escalade.

## 14. Maintenance documentaire
### 14.1 Structure et nommage
Regles:
1. Document management dans `docs/`.
2. Nommage uppercase snake case pour documents de reference: `PAQ.md`, `PBS.md`, `WBS.md`, `OBS.md`.
3. Une seule source de verite par sujet.

### 14.2 Versioning documentaire
Format version:
`<DOC>-v<major>.<minor>`

Regles:
1. `major`: rupture de regle/process.
2. `minor`: ajout/clarification sans rupture.
3. Historiser les changements dans section "Version" du document.

### 14.3 Cycle de revue
1. Revue hebdo documentaire (MGR + FS-L + DOP-L).
2. Revue immediate en cas de changement de gate/process.
3. Synchronisation obligatoire avec OBS/WBS/Kanban avant validation.

## 15. Criteres de fermeture PAQ
Le PAQ est considere valide si:
1. Tous les chapitres 1 a 15 sont renseignes sans trou.
2. Les seuils bloquants sont explicites et mesurables.
3. Les flux Git, tickets, tests et releases sont actionnables.
4. La coherence avec `OBS/WBS/PBS/KANBAN_DISCIPLINE` est verifiee.
5. Le manager valide la version et la date d'effet.

## 16. Version
- Version: `PAQ-v1.2`
- Statut: `Valide equipe - realigne infra/process/hardware`
- Date d'effet: `2026-03-03`
- Prochaine revue cible: `2026-03-17`
