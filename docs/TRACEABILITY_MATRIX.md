# MATRICE DE TRACABILITE OPERATIONNELLE - InstantRelease

## 1. Objet
Ce document est la matrice operationnelle officielle de tracabilite.
Il couvre le chainage complet:
`Feature -> Requirement -> Test -> Evidence -> Release`.

Source des exigences: `docs/SFD_REQUIREMENTS.md`.
Regles qualite/gates: `docs/PAQ.md`.

## 2. Regles d'exploitation
1. Une ligne = un `Requirement ID` (`RQ-*`).
2. Aucune implementation ne passe en `In Progress` sans colonne `Issue Requirement` renseignee.
3. Une PR doit referencer son requirement (`Closes #...` ou `Refs #...`).
4. Le passage en `Ready Release` exige `Evidence test/CI` renseignee.
5. Le passage en `Done` exige `Evidence release` renseignee si applicable.
6. Pour tout requirement livre, `Evidence release` inclut le lien de run de deploiement/release manuel.
7. Les champs dynamiques `{{...}}` doivent etre remplaces au fil du flux.

## 3. Matrice active
| Requirement ID | Feature ID | Repository | PBS ID | WBS ID | Test ID | Type de test | Priorite | Gate obligatoire | Owner R (OBS) | Issue Requirement | PR | Evidence test/CI | Evidence release | Statut |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| RQ-001 | F-ACT-01 | instant-release_ACTIONS | S1.C1.SC1 | W2.1 | T-001 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-001}} | {{pr:RQ-001}} | {{ci_or_test:T-001}} | {{release_if_applicable:RQ-001}} | Backlog Qualifie |
| RQ-002 | F-ACT-01 | instant-release_ACTIONS | S1.C1.SC1 | W2.1 | T-002 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-002}} | {{pr:RQ-002}} | {{ci_or_test:T-002}} | {{release_if_applicable:RQ-002}} | Backlog Qualifie |
| RQ-003 | F-ACT-02 | instant-release_ACTIONS | S1.C2.SC5 | W2.2 | T-003 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-003}} | {{pr:RQ-003}} | {{ci_or_test:T-003}} | {{release_if_applicable:RQ-003}} | Backlog Qualifie |
| RQ-004 | F-ACT-02 | instant-release_ACTIONS | S1.C2.SC5 | W2.2 | T-004 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-004}} | {{pr:RQ-004}} | {{ci_or_test:T-004}} | {{release_if_applicable:RQ-004}} | Backlog Qualifie |
| RQ-005 | F-ACT-02 | instant-release_ACTIONS | S1.C2.SC5 | W2.2 | T-005 | Integration workflows/modules | P1 | PAQ 9.1 | DOP-L | {{issue_req:RQ-005}} | {{pr:RQ-005}} | {{ci_or_test:T-005}} | {{release_if_applicable:RQ-005}} | Backlog Qualifie |
| RQ-006 | F-ACT-03 | instant-release_ACTIONS | S1.C2.SC2 | W2.3 | T-006 | Unitaires services | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-006}} | {{pr:RQ-006}} | {{ci_or_test:T-006}} | {{release_if_applicable:RQ-006}} | Backlog Qualifie |
| RQ-007 | F-ACT-03 | instant-release_ACTIONS | S1.C2.SC3 | W2.3 | T-007 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-007}} | {{pr:RQ-007}} | {{ci_or_test:T-007}} | {{release_if_applicable:RQ-007}} | Backlog Qualifie |
| RQ-008 | F-ACT-03 | instant-release_ACTIONS | S1.C2.SC4 | W2.3 | T-008 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-008}} | {{pr:RQ-008}} | {{ci_or_test:T-008}} | {{release_if_applicable:RQ-008}} | Backlog Qualifie |
| RQ-009 | F-ACT-04 | instant-release_ACTIONS | S1.C4.SC3 | W2.4 | T-009 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-009}} | {{pr:RQ-009}} | {{ci_or_test:T-009}} | {{release_if_applicable:RQ-009}} | Backlog Qualifie |
| RQ-010 | F-ACT-04 | instant-release_ACTIONS | S1.C4.SC4/SC5 | W2.4/W2.5 | T-010 | Technique mixte | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-010}} | {{pr:RQ-010}} | {{ci_or_test:T-010}} | {{release_if_applicable:RQ-010}} | Backlog Qualifie |
| RQ-011 | F-ACT-04 | instant-release_ACTIONS | S1.C4.SC6 | W2.5 | T-011 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-011}} | {{pr:RQ-011}} | {{ci_or_test:T-011}} | {{release_if_applicable:RQ-011}} | Backlog Qualifie |
| RQ-012 | F-ACT-05 | instant-release_ACTIONS | S1.C5.SC3 | W2.6 | T-012 | Integration workflows/modules | P1 | PAQ 9.1 | DOP-L | {{issue_req:RQ-012}} | {{pr:RQ-012}} | {{ci_or_test:T-012}} | {{release_if_applicable:RQ-012}} | Backlog Qualifie |
| RQ-013 | F-ACT-05 | instant-release_ACTIONS | S1.C5.SC4 | W2.6 | T-013 | Review/Audit | P0 | DoR/DoD + workflow Kanban | DOP-L | {{issue_req:RQ-013}} | {{pr:RQ-013}} | {{ci_or_test:T-013}} | {{release_if_applicable:RQ-013}} | Backlog Qualifie |
| RQ-014 | F-API-01 | instant-release_API | S2.C3.SC1 | W3.1 | T-014 | E2E controllers/UI | P0 | PAQ 9.1 | FS-L | {{issue_req:RQ-014}} | {{pr:RQ-014}} | {{ci_or_test:T-014}} | {{release_if_applicable:RQ-014}} | Backlog Qualifie |
| RQ-015 | F-API-01 | instant-release_API | S2.C3.SC2 | W3.1 | T-015 | E2E + unitaires | P0 | PAQ 9.1 | FS-L | {{issue_req:RQ-015}} | {{pr:RQ-015}} | {{ci_or_test:T-015}} | {{release_if_applicable:RQ-015}} | Backlog Qualifie |
| RQ-016 | F-API-01 | instant-release_API | S2.C3.SC3 | W3.1 | T-016 | E2E controllers/UI | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-016}} | {{pr:RQ-016}} | {{ci_or_test:T-016}} | {{release_if_applicable:RQ-016}} | Backlog Qualifie |
| RQ-017 | F-API-02 | instant-release_API | S1.C4.SC1 | W3.2 | T-017 | Unitaires services | P0 | PAQ 9.1 | FS-L | {{issue_req:RQ-017}} | {{pr:RQ-017}} | {{ci_or_test:T-017}} | {{release_if_applicable:RQ-017}} | Backlog Qualifie |
| RQ-018 | F-API-02 | instant-release_API | S1.C4.SC1 | W3.2 | T-018 | Unitaires services | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-018}} | {{pr:RQ-018}} | {{ci_or_test:T-018}} | {{release_if_applicable:RQ-018}} | Backlog Qualifie |
| RQ-019 | F-API-03 | instant-release_API | S1.C4.SC2 | W3.3 | T-019 | E2E controllers/UI | P0 | PAQ 9.1 | FS-L | {{issue_req:RQ-019}} | {{pr:RQ-019}} | {{ci_or_test:T-019}} | {{release_if_applicable:RQ-019}} | Backlog Qualifie |
| RQ-020 | F-API-03 | instant-release_API | S2.C3 | W3.3 | T-020 | E2E controllers/UI | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-020}} | {{pr:RQ-020}} | {{ci_or_test:T-020}} | {{release_if_applicable:RQ-020}} | Backlog Qualifie |
| RQ-021 | F-API-04 | instant-release_API | S2.C3.SC4 | W3.4 | T-021 | E2E controllers/UI | P0 | PAQ 9.1 | FS-L | {{issue_req:RQ-021}} | {{pr:RQ-021}} | {{ci_or_test:T-021}} | {{release_if_applicable:RQ-021}} | Backlog Qualifie |
| RQ-022 | F-API-04 | instant-release_API | S2.C3.SC4 | W3.4 | T-022 | E2E + unitaires | P0 | PAQ 9.1 | FS-L | {{issue_req:RQ-022}} | {{pr:RQ-022}} | {{ci_or_test:T-022}} | {{release_if_applicable:RQ-022}} | Backlog Qualifie |
| RQ-023 | F-API-05 | instant-release_API | S1.C4.SC4 | W3.6 | T-023 | Integration workflows/modules | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-023}} | {{pr:RQ-023}} | {{ci_or_test:T-023}} | {{release_if_applicable:RQ-023}} | Backlog Qualifie |
| RQ-024 | F-APP-01 | instant-release_APP | S2.C2.SC1 | W4.2 | T-024 | E2E controllers/UI | P1 | PAQ 9.1 | FS-E | {{issue_req:RQ-024}} | {{pr:RQ-024}} | {{ci_or_test:T-024}} | {{release_if_applicable:RQ-024}} | Backlog Qualifie |
| RQ-025 | F-APP-01 | instant-release_APP | S4.C2.SC3 | W4.2 | T-025 | E2E controllers/UI | P1 | PAQ 9.1 | FS-E | {{issue_req:RQ-025}} | {{pr:RQ-025}} | {{ci_or_test:T-025}} | {{release_if_applicable:RQ-025}} | Backlog Qualifie |
| RQ-026 | F-APP-02 | instant-release_APP | S2.C2.SC2 | W4.3 | T-026 | E2E controllers/UI | P0 | PAQ 9.1 | FS-E | {{issue_req:RQ-026}} | {{pr:RQ-026}} | {{ci_or_test:T-026}} | {{release_if_applicable:RQ-026}} | Backlog Qualifie |
| RQ-027 | F-APP-02 | instant-release_APP | S2.C2.SC2/SC3 | W4.3/W4.4 | T-027 | E2E controllers/UI | P1 | PAQ 9.1 | FS-E | {{issue_req:RQ-027}} | {{pr:RQ-027}} | {{ci_or_test:T-027}} | {{release_if_applicable:RQ-027}} | Backlog Qualifie |
| RQ-028 | F-APP-03 | instant-release_APP | S2.C2.SC3 | W4.4 | T-028 | E2E controllers/UI | P1 | PAQ 9.1 | FS-E | {{issue_req:RQ-028}} | {{pr:RQ-028}} | {{ci_or_test:T-028}} | {{release_if_applicable:RQ-028}} | Backlog Qualifie |
| RQ-029 | F-APP-03 | instant-release_APP | S2.C2.SC3 | W4.4 | T-029 | E2E controllers/UI | P1 | PAQ 9.1 | FS-E | {{issue_req:RQ-029}} | {{pr:RQ-029}} | {{ci_or_test:T-029}} | {{release_if_applicable:RQ-029}} | Backlog Qualifie |
| RQ-030 | F-APP-04 | instant-release_APP | S1.C4.SC4 | W4.5 | T-030 | Integration workflows/modules | P0 | PAQ 9.1 | FS-E | {{issue_req:RQ-030}} | {{pr:RQ-030}} | {{ci_or_test:T-030}} | {{release_if_applicable:RQ-030}} | Backlog Qualifie |
| RQ-031 | F-APP-04 | instant-release_APP | S1.C4.SC4 | W4.6 | T-031 | Integration workflows/modules | P1 | PAQ 9.1 | FS-E | {{issue_req:RQ-031}} | {{pr:RQ-031}} | {{ci_or_test:T-031}} | {{release_if_applicable:RQ-031}} | Backlog Qualifie |
| RQ-032 | F-VIT-01 | instant-release_VITRINE | S2.C1.SC1/SC2/SC3 | W5.2 | T-032 | E2E controllers/UI | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-032}} | {{pr:RQ-032}} | {{ci_or_test:T-032}} | {{release_if_applicable:RQ-032}} | Backlog Qualifie |
| RQ-033 | F-VIT-02 | instant-release_VITRINE | S5.C3/S5.C4 | W5.4 | T-033 | E2E controllers/UI | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-033}} | {{pr:RQ-033}} | {{ci_or_test:T-033}} | {{release_if_applicable:RQ-033}} | Backlog Qualifie |
| RQ-034 | F-VIT-03 | instant-release_VITRINE | S4.C3.SC3 + S1.C4.SC4 | W5.5 | T-034 | Integration workflows/modules | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-034}} | {{pr:RQ-034}} | {{ci_or_test:T-034}} | {{release_if_applicable:RQ-034}} | Backlog Qualifie |
| RQ-035 | F-VIT-03 | instant-release_VITRINE | S1.C4.SC4 | W5.6 | T-035 | Integration workflows/modules | P1 | PAQ 9.1 | FS-L | {{issue_req:RQ-035}} | {{pr:RQ-035}} | {{ci_or_test:T-035}} | {{release_if_applicable:RQ-035}} | Backlog Qualifie |
| RQ-036 | F-X-01 | multi-repo | S2.C4.SC3 | W6.1 | T-036 | Review/Audit | P0 | DoR/DoD + workflow Kanban | DOP-L | {{issue_req:RQ-036}} | {{pr:RQ-036}} | {{ci_or_test:T-036}} | {{release_if_applicable:RQ-036}} | Backlog Qualifie |
| RQ-037 | F-X-01 | multi-repo | S1.C4.SC2/SC3 | W6.2 | T-037 | E2E cross-repo | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-037}} | {{pr:RQ-037}} | {{ci_or_test:T-037}} | {{release_if_applicable:RQ-037}} | Backlog Qualifie |
| RQ-038 | F-X-02 | multi-repo | S3.C2.SC5 | W6.4/W6.5 | T-038 | Review/Audit | P0 | DoR/DoD + workflow Kanban | DOP-L | {{issue_req:RQ-038}} | {{pr:RQ-038}} | {{ci_or_test:T-038}} | {{release_if_applicable:RQ-038}} | Backlog Qualifie |
| RQ-039 | F-X-02 | multi-repo | S1.C4.SC6 | W6.3 | T-039 | Integration workflows/modules | P0 | PAQ 9.1 | DOP-L | {{issue_req:RQ-039}} | {{pr:RQ-039}} | {{ci_or_test:T-039}} | {{release_if_applicable:RQ-039}} | Backlog Qualifie |
| RQ-040 | F-DOC-01 | docs | S3.C2.SC6 | W1.1 | T-040 | Review/Audit | P0 | DoR/DoD + workflow Kanban | FS-L | {{issue_req:RQ-040}} | {{pr:RQ-040}} | {{ci_or_test:T-040}} | {{release_if_applicable:RQ-040}} | Backlog Qualifie |
| RQ-041 | F-DOC-01 | docs | S3.C2.SC6 | W1.4 | T-041 | Review/Audit | P1 | DoR/DoD + workflow Kanban | FS-L | {{issue_req:RQ-041}} | {{pr:RQ-041}} | {{ci_or_test:T-041}} | {{release_if_applicable:RQ-041}} | Backlog Qualifie |

## 4. Vue de couverture v1
### 4.1 Distribution des requirements
| Axe | Valeur |
|---|---|
| Total requirements | 41 |
| P0 | 24 |
| P1 | 17 |

### 4.2 Distribution par repository
| Repository | Nb requirements |
|---|---|
| `instant-release_ACTIONS` | 13 |
| `instant-release_API` | 10 |
| `instant-release_APP` | 8 |
| `instant-release_VITRINE` | 4 |
| `multi-repo` | 4 |
| `docs` | 2 |

## 5. Critere de validite de la matrice
1. 100% des `RQ-*` du SFD sont presents ici.
2. Chaque ligne possede `Repository + PBS ID + WBS ID + Test ID`.
3. Aucun requirement `Done` sans evidence test/CI renseignee.
4. Aucun requirement lie a release sans evidence release renseignee.
5. Mise a jour obligatoire a chaque cycle Jour 3.

## 6. Version
- Version: `TRACE-v1.1`
- Statut: `Operationnel - realigne process CI/CD`
- Date d'effet: `2026-03-03`
