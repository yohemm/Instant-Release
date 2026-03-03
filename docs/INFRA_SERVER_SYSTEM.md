# INFRA SERVER & SYSTEM - InstantRelease

## 1. Objet
Ce document definit l'architecture cible **infrastructure serveur & systeme** du projet InstantRelease.
Il couvre:
1. orchestration et execution des services,
2. couche data,
3. reseau et securite,
4. automatisation CI/CD et deploiement,
5. observabilite et exploitation.

## 2. Perimetre
Applications ciblees:
1. `instant-release_VITRINE`
2. `instant-release_APP`
3. `instant-release_API`
4. `instant-release_ACTIONS` (automation CI/CD + scripts/pipelines infra)

Environnements:
1. Local
2. Staging
3. Production

Regle de coherence documentaire:
1. Ce document est la source de verite pour l'infra serveur/systeme.
2. `docs/PAQ.md` reste la source de verite pour les gates qualite/tests/release acceptance.
3. `docs/KANBAN_DISCIPLINE.md` reste la source de verite pour le workflow de pilotage.
4. `docs/OBS.md` reste la source de verite pour roles/RACI/escalade.
5. `docs/HARDWARE_REQUIREMENTS.md` est la source de verite pour sizing materiel et couts.

## 3. Decisions architecture (Decision + Rationale + Impact)
| Decision | Rationale | Impact |
|---|---|---|
| Local sans Kubernetes: Docker Compose uniquement | Simplicite dev et cycle court | Pas de complexite K8s en local |
| Orchestration serveur avec Minikube Kubernetes | Uniformiser deploiement staging/prod via K8s | Besoin de runbooks K8s serveur |
| Reverse proxy retenu: Traefik | Configuration dynamique et integration TLS | Point d'entree public vitrine/app + entree privee API |
| Packaging deploiement avec Helm | Parametrage par environnement simplifie | Versioning chart + rollback facilites |
| PostgreSQL: 1 service DB + 3 bases logiques | Simplifier operations et cout initial | Isolation logique dev/staging/prod, pas isolation infra complete |
| Hebergement retenu: VPS seul | Maitrise des couts et de l'exploitation | Pas de dependance cloud managed |
| Object storage retenu: MinIO (compatible S3) | Solution gratuite self-hosted sur VPS | Gestion operationnelle a assumer (backup/capacite) |
| Redis par environnement avec persistance adaptee | Adapter resilence au besoin reel de chaque env | Cout controle + resilence ciblee en prod |
| CI sur push, CD manuelle via GitHub Actions + Docker Action | Garder automatisation qualite tout en validant humainement les deploiements | Deploiement staging/prod declenche uniquement quand la branche est prete |
| Registre npm prive: GitHub Packages | Partager du code inter-repo sans exposition publique | Packages prives limites a l'organisation GitHub (token requis) |
| Terraform non retenu en v1 | Limiter complexite infra initiale | Provisionning majoritairement manuel/versionne |

## 4. Orchestration & serveurs (coeur)
### 4.1 Stack retenue
1. Local: Docker Compose uniquement (pas de cluster K8s local).
2. Serveurs: Minikube Kubernetes pour staging et production.
3. Reverse proxy: Traefik.
4. Helm pour deploiement des charts applicatifs et middleware sur K8s serveur.

### 4.2 Topologie cible
| Environnement | Runtime | Orchestrateur | Namespace | Hebergement |
|---|---|---|---|---|
| Local | Docker Compose | Aucun (sans K8s) | N/A | poste dev |
| Staging | Conteneurs sur serveur | Minikube K8s | `instant-staging` | VPS |
| Production | Conteneurs sur serveur | Minikube K8s | `instant-prod` | VPS |

Note:
1. En local, les services applicatifs tournent en compose.
2. En local, l'application consomme une base distante cote serveur.

### 4.3 Services deployes
| Service | Repo source | Staging serveur | Production serveur | Exposition |
|---|---|---|---|---|
| Vitrine | `instant-release_VITRINE` | oui | oui | public via Traefik |
| API | `instant-release_API` | oui | oui | prive (non public internet), acces interne via Traefik/reseau interne |
| App Web | `instant-release_APP` | oui | oui | public/controle via Traefik |
| Jobs/CD tooling | `instant-release_ACTIONS` | via GitHub Actions | via GitHub Actions | interne CI/CD |

## 5. Data layer
### 5.1 PostgreSQL - Politique finale backup DB
| Element | Regle |
|---|---|
| Type | PostgreSQL distant (service unique) |
| Topologie | 1 service DB pour le projet, 3 bases logiques |
| Bases logiques | `instant_dev`, `instant_staging`, `instant_prod` |
| Isolement | separation logique par base (pas une instance par env) |
| Usage | Donnees metier structurees (users, configs, historique) |
| Frequence backup | full dump quotidien a `02:00` (heure serveur) |
| Duplication | copie automatique sur un 2e emplacement |
| Integrite | `checksum` obligatoire apres chaque dump |
| Chiffrement | archives chiffrees au repos |

Valeurs finales retention (simples et maintenables):
1. Quotidien: conservation `35 jours`.
2. Hebdomadaire: conservation `12 mois`.
3. Mensuel (archive): conservation `10 ans`.
4. Politique de purge: suppression automatique au-dela des delais.

Valeurs finales RPO/RTO:
| Environnement | RPO max | RTO max |
|---|---|---|
| Dev | `<=24h` | `<=24h` |
| Staging | `<=24h` | `<=8h` |
| Prod | `<=24h` | `<=4h` |

Runbook minimal obligatoire:
1. Cron quotidien a `02:00` pour dump des 3 bases.
2. Duplication immediate vers emplacement secondaire.
3. Verification `checksum` + journalisation resultat (succes/echec).
4. Test de restauration sur staging `1 fois par mois`.
5. Revue trimestrielle de la politique de retention.

Alignement legal (ref. `docs/conservation des datas/`):
1. Comptable: `10 ans`.
2. Fiscal: `6 ans`.
3. Civil/commercial: `5 ans` (jusqu'a `10 ans` selon cas).
4. Regle projet retenue: archive mensuelle backup DB `10 ans` (regle unique conservative).

### 5.2 Redis
| Environnement | Mode | Persistance | Usage |
|---|---|---|---|
| Local (dev) | Single | No persistence | cache local, perte acceptable |
| Staging | Single | RDB | validation fonctionnelle/stabilite |
| Production | Sentinel | AOF + RDB | cache + sessions avec continuite de service |

Regle:
1. Le mode production est `Sentinel` (coherent avec hebergement VPS seul).

### 5.3 Object Storage
| Element | Regle |
|---|---|
| Technologie | `MinIO` (compatible API S3) |
| Usage | medias/fichiers utilisateurs, exports, artefacts metier |
| Buckets | `instant-dev-uploads`, `instant-staging-uploads`, `instant-prod-uploads`, `instant-dev-exports`, `instant-staging-exports`, `instant-prod-exports` |
| Cycle de vie | retention + archivage + purge automatique |

Policy Storage (MinIO):
1. Retention: conserver les fichiers critiques pendant `10 ans` (preuves, documents contractuels/comptables).
2. Archivage: deplacer les fichiers anciens vers un stockage plus lent/compresse si disponible sur le VPS.
3. Purge auto: activer suppression automatique des fichiers temporaires.
4. Regle obligatoire bucket exports: suppression automatique apres `24h`.

## 6. Reseau & securite
### 6.1 Entree reseau
1. Ingress Controller: `Traefik`.
2. Routage DNS:
   - `www.domain` -> Vitrine
   - `app.domain` -> App
   - `api.internal.domain` -> API (acces prive uniquement, non expose internet)
3. Cert-Manager + Let's Encrypt pour TLS automatique.

### 6.2 Secrets & identites
1. HashiCorp Vault pour secrets applicatifs et infra.
2. Interdiction des secrets en clair dans repo/fichiers valeurs Helm.
3. Rotation obligatoire des secrets critiques tous les `90 jours` (ou immediate apres incident).
4. Acces DB/Redis/Object storage par comptes de service dedies.

### 6.3 Hardening minimal
1. RBAC Kubernetes strict (least privilege).
2. NetworkPolicy activee entre namespaces/services.
3. Images basees sur tags immuables + scan vulnerabilites.
4. Pod security (non-root, filesystem read-only si possible).
5. Journalisation des acces d'admin et operations sensibles.

## 7. Automatisation (CI/CD & deployment)
### 7.1 Pipeline GitHub Actions
Regles de declenchement:
1. Push/merge sur `feat/*`, `fix/*`, `dev`, `staging`, `main` -> **CI uniquement** (build/test/scan), aucun deploiement automatique.
2. Deploiement Staging: declenchement manuel (`workflow_dispatch`) sur branche `staging` quand prete.
3. Deploiement Production: declenchement manuel (`workflow_dispatch`) sur branche `main` quand prete, avec validation humaine prealable.

Etapes pipeline standard:
1. Build image conteneur.
2. Tests obligatoires (selon `docs/PAQ.md`).
3. Scans securite/supply chain.
4. Push registry.
5. Si deploiement manuel declenche: deploy sur env cible via Docker Action (et scripts deploy versionnes).
6. Verification post-deploiement.
7. Evidence package (liens run, image digest, release, checks).

### 7.2 Strategie outillage deploiement
| Domaine | Outil cible | Statut |
|---|---|---|
| Build/push image | Docker (GitHub Action) | valide |
| CD staging/prod | Docker Action + scripts du repo `instant-release_ACTIONS` (declenchement manuel) | valide |
| Deploiement K8s serveur | Helm + kubectl | valide |
| Provisionning infra (Terraform/Pulumi) | non retenu en v1 | ferme |
| Gestion secrets runtime | Vault (+ integration K8s) | valide concept |

### 7.3 Registry et artefacts
1. Registry images: `GHCR`.
2. Tagging images: `app:<version>` + digest immuable.
3. Conservation artefacts CI: `30 jours`.
4. Registre npm prive inter-repo: `GitHub Packages` (scope organisation prive).
5. Acces package npm prive: token GitHub individuel (PAT) pour chaque developpeur/service CI.

## 8. Observabilite (monitoring, logs, erreurs)
### 8.1 Metrics
1. Prometheus collecte metriques infra + apps.
2. Grafana dashboards:
   - Cluster health
   - API latency/error rate
   - Web performance
   - Saturation (CPU/RAM)

### 8.2 Logs
1. Fluent-bit collecte logs pods/nodes.
2. Loki centralise et indexe.
3. Regle de retention logs:
   - staging: `30 jours`
   - production: `90 jours`

### 8.3 Error tracking
1. Sentry pour erreurs frontend (`APP`, `VITRINE`) et backend (`API`).
2. Alertes vers `email` (canal obligatoire).
3. Mapping incident -> issue GitHub obligatoire.

## 9. Risques infra principaux et mesures
| Risque | Impact | Mesure |
|---|---|---|
| Mauvaise isolation env | fuite/impact croise staging->prod | separation stricte instances et credentials |
| Secret leakage | compromission systeme | Vault + rotation + scan secrets CI |
| Incident cluster | indisponibilite service | replicas applicatives + autoscaling + runbooks de reprise |
| Absence de visibilite | MTTR eleve | stack observabilite complete + alertes |
| Drift de configuration | comportements non maitrises | scripts/manifests versionnes + reviews + pipeline CI/CD |

## 10. Plan de mise en place recommande
1. Phase 1 (foundation): Docker Compose local + connectivite DB distante + registry.
2. Phase 2 (staging): service staging serveur (vitrine + API privee), Redis single + RDB, Traefik + TLS + deploiement manuel staging.
3. Phase 3 (prod): service prod serveur (vitrine + API privee), Redis Sentinel + AOF/RDB, deploiement manuel production depuis `main`.
4. Phase 4 (ops): dashboards, alerting, runbooks incidents, revue capacite.

## 11. Version
- Version: `INFRA-v1.6`
- Statut: `Propre - aligne API privee + CI only push + CD manuelle + HWR`
- Date d'effet cible: `2026-03-03`
- Prochaine revue cible: `2026-03-17`
