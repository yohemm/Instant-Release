# DOC - Guide de navigation documentaire (InstantRelease)

## 1. Objectif
Ce fichier est le point d'entree documentaire du projet.
Il indique:
1. quel document lire selon le besoin,
2. quelle est la source de verite par sujet,
3. dans quel ordre lire la documentation.

Regle generale:
1. En cas de conflit entre documents, suivre la source de verite indiquee ici.

## 2. Sources de verite (par domaine)
| Domaine | Document source | Usage |
|---|---|---|
| Vision fonctionnelle et produit | [docs/PBS.md](docs/PBS.md) | ce que le produit contient |
| Plan de travail et lots | [docs/WBS.md](docs/WBS.md) | ce qui doit etre realise et dans quel lot |
| Exigences testables | [docs/SFD_REQUIREMENTS.md](docs/SFD_REQUIREMENTS.md) | features -> requirements -> tests -> priorites |
| Tracabilite operationnelle | [docs/TRACEABILITY_MATRIX.md](docs/TRACEABILITY_MATRIX.md) | preuve de lien requirement -> test -> evidence |
| Organisation et responsabilites | [docs/OBS.md](docs/OBS.md) | roles, ownership, RACI, escalade |
| Methode qualite et governance delivery | [docs/PAQ.md](docs/PAQ.md) | methode officielle, DoR/DoD, gates, release |
| Workflow Kanban et pilotage flux | [docs/KANBAN_DISCIPLINE.md](docs/KANBAN_DISCIPLINE.md) | statuts, WIP, classes de service, champs project |
| Risques et contingence | [docs/RISK_MANAGEMENT_PLAN.md](docs/RISK_MANAGEMENT_PLAN.md) | registre risque, KRIs, escalade, reprise |
| Setup du GitHub Project | [docs/GITHUB_PROJECT_SETUP.md](docs/GITHUB_PROJECT_SETUP.md) | import CSV, script, sync project |
| Infrastructure serveur/systeme | [docs/INFRA_SERVER_SYSTEM.md](docs/INFRA_SERVER_SYSTEM.md) | architecture infra, data layer, reseau, observabilite |
| Besoins materiels / budget | [docs/HARDWARE_REQUIREMENTS.md](docs/HARDWARE_REQUIREMENTS.md) | besoins hardware + placeholders couts |
| Roadmap (index) | [docs/ROADMAP.md](docs/ROADMAP.md) | point d'entree POC/MVP |
| Roadmap POC | [docs/POC/ROADMAP.md](docs/POC/ROADMAP.md) | planning specifique POC ACTIONS |
| Roadmap MVP | [docs/MVP/ROADMAP.md](docs/MVP/ROADMAP.md) | planning produit complet ACTIONS/API/APP/VITRINE |
| Technical docs (index) | [docs/TECHNICAL_DOCS.md](docs/TECHNICAL_DOCS.md) | point d'entree POC/MVP |
| Technical docs POC | [docs/POC/TECHNICAL_DOCS.md](docs/POC/TECHNICAL_DOCS.md) | design technique POC ACTIONS |
| Technical docs MVP | [docs/MVP/TECHNICAL_DOCS.md](docs/MVP/TECHNICAL_DOCS.md) | design technique MVP complet multi-repo |
| Reference detaillee action | [docs/FULL_DOCS.md](docs/FULL_DOCS.md) | reference exhaustive de l'action InstantRelease |

## 3. Parcours de lecture recommande
### 3.1 Nouveau collaborateur (onboarding rapide)
1. `DOC.md` (ce document)
2. [docs/PAQ.md](docs/PAQ.md)
3. [docs/KANBAN_DISCIPLINE.md](docs/KANBAN_DISCIPLINE.md)
4. [docs/OBS.md](docs/OBS.md)
5. [docs/ROADMAP.md](docs/ROADMAP.md)
6. [docs/GITHUB_PROJECT_SETUP.md](docs/GITHUB_PROJECT_SETUP.md)

### 3.2 Product/Function
1. [docs/PBS.md](docs/PBS.md)
2. [docs/WBS.md](docs/WBS.md)
3. [docs/SFD_REQUIREMENTS.md](docs/SFD_REQUIREMENTS.md)
4. [docs/TRACEABILITY_MATRIX.md](docs/TRACEABILITY_MATRIX.md)

### 3.3 Qualite/Risque/Release
1. [docs/PAQ.md](docs/PAQ.md)
2. [docs/RISK_MANAGEMENT_PLAN.md](docs/RISK_MANAGEMENT_PLAN.md)
3. [docs/KANBAN_DISCIPLINE.md](docs/KANBAN_DISCIPLINE.md)
4. [docs/TRACEABILITY_MATRIX.md](docs/TRACEABILITY_MATRIX.md)

### 3.4 Infra/Tech
1. [docs/INFRA_SERVER_SYSTEM.md](docs/INFRA_SERVER_SYSTEM.md)
2. [docs/HARDWARE_REQUIREMENTS.md](docs/HARDWARE_REQUIREMENTS.md)
3. [docs/TECHNICAL_DOCS.md](docs/TECHNICAL_DOCS.md)
4. [docs/FULL_DOCS.md](docs/FULL_DOCS.md)

## 4. Regles de maintenance documentaire
1. Une information de gouvernance ne doit exister que dans une seule source de verite.
2. Les autres documents doivent pointer vers la source, sans dupliquer la regle.
3. Toute modification de process doit mettre a jour:
   - `docs/PAQ.md` (si qualite/methode),
   - `docs/KANBAN_DISCIPLINE.md` (si flux/tickets),
   - `docs/OBS.md` (si role/escalade),
   - `docs/RISK_MANAGEMENT_PLAN.md` (si risque/contingence).
4. Toute nouvelle feature doit etre tracee dans:
   - `docs/SFD_REQUIREMENTS.md`,
   - `docs/TRACEABILITY_MATRIX.md`.
5. Toute divergence detectee doit ouvrir un ticket `type/documentation`.

## 5. Checklist de coherence avant validation
1. La regle modifiee a une source de verite unique.
2. Les references inter-docs pointent vers la bonne section.
3. Les placeholders restants sont explicites et assumes.
4. Les documents de pilotage (`PAQ`, `KANBAN`, `OBS`, `RISK`) sont coherents entre eux.
5. Le flux GitHub Project est aligne avec les docs (`GITHUB_PROJECT_SETUP`, `KANBAN`).

## 6. Version
- Version: `DOC-v1.0`
- Statut: `Operationnel`
- Date: `2026-03-04`
