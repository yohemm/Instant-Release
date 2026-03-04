# InstantRelease - Technical Docs MVP (V1.0)

## 1. Objet
Definir l'architecture technique cible MVP couvrant:
1. ACTIONS (release orchestration),
2. API (services et endpoints),
3. APP (frontend de pilotage),
4. VITRINE (site acquisition/conversion).

## 2. Architecture cible (vue systeme)
Composants:
1. `instant-release_ACTIONS`: pipelines CI/release et evidence.
2. `instant-release_API`: contrats stats/config/executions + logique metier.
3. `instant-release_APP`: interface de pilotage consommatrice API.
4. `instant-release_VITRINE`: pages marketing + SEO + analytics.

Flux principal:
1. ACTIONS publie releases et metadata d'execution.
2. API expose stats/config/executions.
3. APP lit/edite via API (dashboard + config + logs).
4. VITRINE capte trafic, mesure conversion, pointe vers APP.

## 3. Decisions techniques MVP (Decision + Rationale + Impact)
| Domaine | Decision | Rationale | Impact |
|---|---|---|---|
| CI orchestration | GitHub Actions + repo ACTIONS | Coherence outillage existant | Execution standardisee multi-repo |
| API contracts | Endpoints versionnes par contrat | Stabilite front/back | Meilleure compatibilite cross-repo |
| Web app | APP consomme API via contrats explicites | Eviter couplage fort | Evolution API/APP controlable |
| Site vitrine | VITRINE separee du front APP | Objectifs marketing differents | KPI acquisition lisibles |
| Release governance | Deploy manuel + go/no-go | Maitrise risque | Cadence moindre mais plus sure |
| Observabilite | Metrics + logs + error tracking | Pilotage exploitation | Reduction MTTR |

## 4. Scope technique par repository
### 4.1 instant-release_ACTIONS
1. Contrat action stable (inputs/outputs).
2. Pre-flight, dry-run, idempotence.
3. Versioning/changelog/tag/release.
4. Qualite/securite/supply-chain checks.
5. Evidence package standard.

### 4.2 instant-release_API
1. Contrats endpoints:
   - stats,
   - configuration (read/write),
   - executions/releases.
2. Services metier avec tests unitaires.
3. Controllers couverts e2e.
4. Authentification/autorisation.

### 4.3 instant-release_APP
1. Dashboard:
   - metriques release/qualite/securite.
2. Console config:
   - edition + validation + tracabilite.
3. Journal runs:
   - filtres + detail run + erreurs/checks.

### 4.4 instant-release_VITRINE
1. Pages:
   - produit,
   - docs,
   - contact/conversion.
2. SEO:
   - metadata,
   - partage social,
   - indexation.
3. Analytics:
   - tunnel conversion,
   - KPI trafic.

## 5. Contrats d'interface MVP
### 5.1 API -> APP
1. Contrat stats stable.
2. Contrat configuration versionne.
3. Contrat executions versionne.
4. Gestion erreurs harmonisee.

### 5.2 VITRINE -> APP
1. CTA vers APP traceables.
2. Parametres de campagne (utm/refs) conserves.
3. KPI conversion relies aux evenements.

### 5.3 ACTIONS -> API/APP (observabilite release)
1. Publication metadata release/execution.
2. Correlation run id -> API logs -> APP affichage.

## 6. Strategie tests MVP
1. ACTIONS: integration workflows/modules.
2. API:
   - unitaires services,
   - e2e controllers.
3. APP/VITRINE:
   - quality gates CI,
   - tests fonctionnels critiques,
   - checks performance/SEO vitrine.
4. Cross-repo:
   - scenarios end-to-end avant go/no-go.

Reference de detail:
1. `docs/PAQ.md` section 8 et section 9.

## 7. KPI techniques par composant
### 7.1 ACTIONS
1. Taux runs reussis `{{KPI_ACT_RUN_SUCCESS}}`.
2. Temps median pipeline `{{KPI_ACT_DURATION}}`.
3. Completeness evidence `{{KPI_ACT_EVIDENCE}}`.

### 7.2 API
1. P95 latency `{{KPI_API_P95}}`.
2. Error rate `{{KPI_API_ERR}}`.
3. Coverage services/controllers `{{KPI_API_COVERAGE}}`.

### 7.3 APP
1. Error rate client `{{KPI_APP_ERR}}`.
2. Succes ecriture config `{{KPI_APP_CFG_OK}}`.
3. Temps chargement dashboard `{{KPI_APP_DASH_LOAD}}`.

### 7.4 VITRINE
1. Core Web Vitals `{{KPI_VIT_CWV}}`.
2. SEO indexation `{{KPI_VIT_INDEX}}`.
3. Conversion CTA `{{KPI_VIT_CTA}}`.

## 8. Risques techniques MVP
1. Couplage API/APP trop fort.
2. Dette tests e2e controllers.
3. Incoherence metadata release cross-repo.
4. KPI vitrine non instrumentes a temps.

Contremesures:
1. contrats explicites + traceability,
2. gates de test bloquants,
3. readiness cross-repo avant release,
4. ticket KPI dedie dans VITRINE.

## 9. Hors scope MVP
1. monorepo complet,
2. plugins avancés generiques,
3. autoscaling avance cloud managed,
4. CD full-auto production.

## 10. Version
- Version: `MVP-TECHDOCS-v1.0`
- Statut: `Propose - pret validation equipe`
- Date: `2026-03-04`
- Prochaine revue cible: `{{MVP_TECHDOCS_REVIEW_DATE}}`
