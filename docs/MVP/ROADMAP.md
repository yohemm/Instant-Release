# InstantRelease - Roadmap MVP (V1.0)

## 1. Objet
Planifier l'execution du MVP complet sur 4 repositories:
1. `instant-release_ACTIONS`
2. `instant-release_API`
3. `instant-release_APP`
4. `instant-release_VITRINE`

## 2. Cadre
References:
1. `docs/PAQ.md`
2. `docs/KANBAN_DISCIPLINE.md`
3. `docs/OBS.md`
4. `docs/RISK_MANAGEMENT_PLAN.md`
5. `docs/SFD_REQUIREMENTS.md`

Mode planning:
1. Timeline relative par cycles (`{{CYCLE_01}}...`).
2. Bascule en dates reelles lors d'une contrainte externe formelle.

## 3. Scope MVP
### 3.1 ACTIONS
1. Contrat action et pre-flight.
2. Versioning/changelog/tag/release.
3. Gates qualite/securite/supply-chain.
4. Evidence package de release.

### 3.2 API
1. Endpoints stats/config/executions.
2. Services metier testables.
3. Controllers e2e.
4. Securite authN/authZ.

### 3.3 APP
1. Dashboard pilotage.
2. Console de configuration.
3. Journal d'execution.
4. Integration des donnees API.

### 3.4 VITRINE
1. Pages produit/docs/contact.
2. SEO technique (metadata/indexation).
3. Analytics conversion.
4. Qualite front (CI/lint/tests) et readiness release.

## 4. Lots MVP par repository
| Lot | Repo | Objectif | Cible |
|---|---|---|---|
| M1 | ACTIONS | Contrat + pre-flight + idempotence | `{{CYCLE_01}}` |
| M2 | ACTIONS | Versioning/changelog/release stabilises | `{{CYCLE_02}}` |
| M3 | API | Contrats API + services + controllers e2e | `{{CYCLE_02}}` |
| M4 | APP | Dashboard + config + logs d'execution | `{{CYCLE_03}}` |
| M5 | VITRINE | Pages + SEO + analytics conversion | `{{CYCLE_03}}` |
| M6 | X-REPO | Integration cross-repo + readiness + evidence | `{{CYCLE_04}}` |

## 5. Mapping cycles -> milestones
| Cycle | ACTIONS | API | APP | VITRINE |
|---|---|---|---|---|
| `{{CYCLE_01}}` | `ACTIONS-M1-CONTRACT-PREFLIGHT` | `API-M1-CONTRATS-ENDPOINTS` (kickoff) | `APP-M1-DASHBOARD` (kickoff) | `VITRINE-M1-PAGES-CORE` (kickoff) |
| `{{CYCLE_02}}` | `ACTIONS-M2-VERSIONING-CHANGELOG-RELEASE` | `API-M2-SERVICES-UNIT-TESTS` | `APP-M2-CONFIG-CONSOLE` | `VITRINE-M2-SEO-ANALYTICS` |
| `{{CYCLE_03}}` | `ACTIONS-M3-QUALITY-GATES-CI` | `API-M3-CONTROLLERS-E2E` | `APP-M3-RUN-LOGS` | `VITRINE-M3-QUALITY-RELEASE-READY` |
| `{{CYCLE_04}}` | `ACTIONS-M5-RELEASE-HARDENING` | `API-M5-QUALITY-RELEASE-READY` | `APP-M4-QUALITY-RELEASE-READY` | `VITRINE-M3-QUALITY-RELEASE-READY` |

## 6. KPI MVP
### 6.1 KPI globaux
1. Lead time median <= `{{KPI_LEAD_TIME_TARGET}}`.
2. Failure rate CI < `{{KPI_CI_FAILURE_TARGET}}`.
3. Evidence completeness = 100%.
4. Critical vulns open = 0 avant release.

### 6.2 KPI VITRINE (acquisition/conversion)
1. `{{KPI_VIT_CVR}}` conversion contact/CTA.
2. `{{KPI_VIT_BOUNCE}}` taux de rebond.
3. `{{KPI_VIT_CORE_WEB_VITALS}}` performance vitale web.
4. `{{KPI_VIT_SEO_INDEX}}` couverture indexation.

### 6.3 KPI API
1. `{{KPI_API_P95_LATENCY}}`.
2. `{{KPI_API_ERROR_RATE}}`.
3. `{{KPI_API_E2E_PASSRATE}}`.

### 6.4 KPI APP
1. `{{KPI_APP_DATA_FRESHNESS}}` fraicheur donnees dashboard.
2. `{{KPI_APP_ERROR_RATE}}`.
3. `{{KPI_APP_CONFIG_SUCCESS_RATE}}`.

## 7. Definition de completion MVP
Le MVP est atteint si:
1. Les lots M1 a M6 sont en `Done`.
2. Les requirements critiques (`P0`) ont preuves de test.
3. Les KPIs minimaux sont instrumentes et suivis.
4. La release cross-repo est validee via evidence package.

## 8. Risques de planning MVP
1. Dependances cross-repo non synchronisees.
2. Saturation capacite equipe sur cycles M2-M4.
3. Derive scope sur APP/API.
4. Instrumentation KPI vitrine incomplete.

Mitigation:
1. revue dependances a chaque Jour 3,
2. WIP strict,
3. slicing requirements plus fin,
4. ticket docs/KPI dedie par stream.

## 9. Version
- Version: `MVP-ROADMAP-v1.0`
- Statut: `Propose - pret validation equipe`
- Date: `2026-03-04`
- Prochaine revue cible: `{{MVP_ROADMAP_REVIEW_DATE}}`
