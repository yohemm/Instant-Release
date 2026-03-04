# InstantRelease - Documentation technique (POC)

## 0. Cadre documentaire (source de verite)
Ce document decrit uniquement le **design technique POC** de `instant-release_ACTIONS`.

Regles de precedence:
1. Process, qualite, gates, DoR/DoD, derogations: `docs/PAQ.md`.
2. Workflow tickets/Kanban/WIP/Project: `docs/KANBAN_DISCIPLINE.md`.
3. Organisation/RACI/escalade: `docs/OBS.md`.
4. Vision long terme produit: `docs/FULL_DOCS.md`.
5. Planification d'execution: `docs/POC/ROADMAP.md`.
6. Maitrise des risques: `docs/RISK_MANAGEMENT_PLAN.md`.

Regle d'alignement intention:
1. Les choix techniques de ce document doivent etre alignes sur les intentions officielles du projet (`docs/PAQ.md` section 2.1).
2. La methode appliquee reste le modele hybride defini dans `docs/PAQ.md` section 2.2.

## 1. Perimetre POC et objectifs
InstantRelease est une GitHub Action (composite) qui automatise un cycle de release.

Objectifs POC:
1. prouver un flux release de bout en bout,
2. valider le versioning base commits,
3. generer changelog + tag + release,
4. centraliser la configuration dans `.instantrelease.yml`.

Hors scope POC:
1. monorepo avance,
2. matrices d'environnements complexes,
3. reporting avance,
4. ecosysteme plugins/webhooks complet.

## 1.1 Justification des choix techniques (catalogue officiel)
Regle:
1. Chaque techno utilisee doit avoir `Decision + Rationale + Alternatives ecartees + Impact + Date de revue`.
2. Les details d'implementation infra restent dans `docs/INFRA_SERVER_SYSTEM.md` (source de verite infra).

### 1.1.1 Stack POC (instant-release_ACTIONS)
| Domaine | Decision (techno retenue) | Rationale | Alternatives ecartees | Impact | Date de revue |
|---|---|---|---|---|---|
| Runtime action | GitHub Action composite + scripts Bash | Portable, simple a maintenir, execution native GitHub | JS action unique, Docker action monolithique | + lisible/modulaire; - discipline shell requise | `2026-03-18` |
| Orchestration CI | GitHub Actions | Integration native repos/protections/environnements | Jenkins, GitLab CI | + zero infra CI a operer; - dependance GitHub | `2026-03-18` |
| Versioning commits | Convention Angular/Conventional Commits | Deterministe pour bump auto + changelog | Commits libres, SemVer manuel | + automatisation fiable; - rigueur equipe obligatoire | `2026-03-18` |
| Config action | YAML (`.instantrelease.yml`) | Lisible, diffable, versionnable | JSON, env vars only | + configuration centralisee; - validation schema a maintenir | `2026-03-18` |
| Changelog | Generation auto depuis historique Git | Trace release standardisee | Changelog manuel | + gain temps et coherence; - qualite depend des commits | `2026-03-18` |
| Publication release | Git tags + GitHub Releases | Standard ecosysteme GitHub | Notes manuelles sans release objects | + auditabilite; - besoin pre-flight idempotence strict | `2026-03-18` |
| Tests locaux | Bash + Docker local | Reproductibilite rapide des checks POC | execution locale uniquement host | + isolation; - maintenance scripts de test | `2026-03-18` |
| Gestion packages partages | GitHub Packages (npm prive) | Coherent avec ecosysteme GitHub et controle d'acces org | Verdaccio, npm Enterprise | + integration simple; - dependance permissions GH | `2026-03-18` |
| Gestion tickets | GitHub Issues + GitHub Project | Unifie planning/trace multi-repo | Jira/Trello separes | + source unique; - besoin discipline champs | `2026-03-18` |

### 1.1.2 Plateforme projet (hors implementation POC directe)
| Domaine | Decision (techno retenue) | Rationale | Alternatives ecartees | Impact | Date de revue |
|---|---|---|---|---|---|
| Conteneurisation locale | Docker Compose (sans K8s local) | Simplicite dev et demarrage rapide | Minikube/Kind local | + faible friction dev; - ecart runtime vs serveur | `2026-03-24` |
| Orchestration serveur | Minikube K8s sur VPS (staging/prod) | Uniformiser deploiement K8s avec cout maitrise | K3s, cluster managed cloud direct | + standard K8s; - charge ops sur equipe | `2026-03-24` |
| Ingress/reverse proxy | Traefik | Routage dynamique + integration TLS | Nginx ingress | + config flexible; - courbe apprentissage rules | `2026-03-24` |
| Packaging K8s | Helm | Versionning chart et rollback simplifie | manifests purs | + deploiement parametrable; - maintenance chart | `2026-03-24` |
| Base de donnees | PostgreSQL (1 service, 3 bases logiques) | Cout/ops reduits au stade actuel | 1 instance par env | + simplicite; - isolation infra partielle | `2026-03-24` |
| Cache/session | Redis (mode selon env) | Performance API + sessions resilientes | cache in-memory applicatif | + rapidite; - exploitation supplementaire | `2026-03-24` |
| Object storage | MinIO (S3 compatible, self-hosted) | Cout zero licence + controle donnees | AWS S3 managed | + souverainete/cout; - maintenance stockage | `2026-03-24` |
| Secrets | HashiCorp Vault | gestion centralisee des secrets | secrets en variables CI seulement | + posture securite forte; - complexite ops | `2026-03-24` |
| Registry images | GHCR | proche GitHub Actions et permissions org | Docker Hub prive | + integration native; - quota/policy GHCR | `2026-03-24` |
| Observabilite metrics | Prometheus + Grafana | standard open-source monitoring | SaaS monitoring unique | + controle complet; - maintenance dashboards | `2026-03-24` |
| Observabilite logs | Fluent-bit + Loki | centralisation logs economique | ELK complet | + cout contenu; - tuning retention requis | `2026-03-24` |
| Error tracking | Sentry | alerting applicatif front/back rapide | logs seuls sans tracker | + reduction MTTR; - hygiene alerting necessaire | `2026-03-24` |

### 1.1.3 Regle de decision future (nouvelles technos)
Pour toute nouvelle techno:
1. creer une ligne dans ce catalogue avant adoption generale,
2. lier l'issue de decision (`type/documentation` ou `type/risk` si risque fort),
3. definir une date de revue explicite,
4. verifier alignement avec `PAQ` (qualite) et `RISK_MANAGEMENT_PLAN` (risque).

## 2. Architecture et flux d'execution
### 2.1 Vue d'ensemble
L'action lit la configuration et orchestre des etapes conditionnelles. L'execution est lineaire avec arrets explicites sur echec.

### 2.2 Flux principal
1. Charger `.instantrelease.yml`.
2. Verifier pre-requis (token, branche, etat repo).
3. Calculer la version.
4. Generer changelog.
5. Creer tag Git.
6. Creer release GitHub.

### 2.3 Flux techniques optionnels
1. build / tests / lint,
2. scans dependances / secrets,
3. etapes de deploiement post-release.

Note: le **mode de deploiement projet** est gouverne par `docs/PAQ.md` (push/merge = CI uniquement, deploiement manuel).

## 3. Configuration `.instantrelease.yml` (champ par champ)
### 3.1 Git
- `git.user-name`
- `git.user-email`
- `git.auto-commit`
- `git.auto-push`
- `git.target-branch`

### 3.2 Versioning
- `versioning.initial-version`
- `versioning.bump` (`auto|major|minor|patch|none`)
- `versioning.detect-bump`
- `versioning.indicators.major`
- `versioning.indicators.minor`
- `versioning.indicators.patch`
- `versioning.version-prefix`
- `versioning.verify-tag-exists`

### 3.3 Changelog
- `changelog.generate`
- `changelog.file`
- `changelog.template`
- `changelog.append-mode` (`prepend|append|replace`)
- `changelog.include-contributors`
- `changelog.include-stats`

### 3.4 Release
- `release.create-tag`
- `release.create-release`
- `release.release-draft`
- `release.release-prerelease`
- `release.prerelease-suffix`
- `release.tag-delete-on-failure`

### 3.5 Build
- `build.enabled`
- `build.command`
- `build.artifact-path`
- `build.upload-artifact`

### 3.6 Tests
- `tests.enabled`
- `tests.unit-tests-command`
- `tests.coverage-threshold`
- `tests.lint-enabled`
- `tests.lint-command`

### 3.7 Security
- `security.dependency-scan`
- `security.secret-scan`
- `security.commit-signature-check`

Note: les seuils/severites bloquantes sont definis uniquement dans `docs/PAQ.md`.

### 3.8 Deployment
- `deployment.enabled`
- `deployment.environment`
- `deployment.command`
- `deployment.post-deploy-validation`
- `deployment.post-deploy-check-url`

### 3.9 Webhooks
- `webhooks.pre-flight.enabled`
- `webhooks.pre-flight.url`
- `webhooks.pre-flight.retry-attempts`
- `webhooks.pre-flight.timeout`
- `webhooks.post-release.enabled`
- `webhooks.post-release.url`
- `webhooks.post-release.retry-attempts`
- `webhooks.post-release.timeout`

### 3.10 Plugins
- `plugins.pre-flight.enabled`
- `plugins.pre-flight.script`
- `plugins.pre-flight.timeout`
- `plugins.post-release.enabled`
- `plugins.post-release.script`
- `plugins.post-release.timeout`

### 3.11 Debug
- `debug`
- `dry-run`

## 4. Structure de fichiers cible (POC)
```
instantrelease/
|-- action.yml
|-- .instantrelease.yml
|-- scripts/
|   |-- pre-flight.sh
|   |-- webhook-call.sh
|   |-- build/
|   |   |-- build.sh
|   |   |-- generate-checksum.sh
|   |   `-- generate-version-file.sh
|   |-- tests/
|   |   |-- unit-tests.sh
|   |   |-- coverage-check.sh
|   |   `-- lint.sh
|   |-- security/
|   |   |-- dependency-scan.sh
|   |   |-- secret-scan.sh
|   |   `-- commit-signature-check.sh
|   |-- versioning/
|   |   |-- calculate-version.sh
|   |   |-- detect-bump-type.sh
|   |   `-- validate-semver.sh
|   |-- changelog/
|   |   |-- generate-changelog.sh
|   |   `-- extract-changelog.sh
|   |-- release/
|   |   |-- create-tag.sh
|   |   |-- auto-commit.sh
|   |   `-- create-release.sh
|   |-- deploy/
|   |   |-- pre-deploy-check.sh
|   |   |-- post-deploy-validation.sh
|   |   `-- rollback.sh
|   `-- reporting/
|       |-- generate-reports.sh
|       |-- compliance-report.sh
|       `-- audit-log-export.sh
|-- templates/
|   |-- changelog-default.hbs
|   |-- compliance-report.hbs
|   `-- pre-flight-summary.hbs
|-- tests/
    |-- unit/
    `-- integration/
```

## 5. Modules prevus
### 5.1 Existant POC
1. lecture config YAML,
2. calcul version basique,
3. generation changelog basique,
4. creation tag + release (GitHub API).

### 5.2 A venir
1. validation schema YAML,
2. systeme plugins pre/post,
3. scans securite avances,
4. generation SBOM,
5. rapports d'audit.

## 6. Comportements techniques attendus
### 6.1 Versioning
1. base commits (convention Angular),
2. priorite `major > minor > patch`,
3. fallback `initial-version` si aucun tag.

### 6.2 Changelog
1. genere depuis le dernier tag,
2. rendu Markdown via template.

### 6.3 Release
1. tag `version-prefix + version`,
2. release avec notes extraites du changelog.

## 7. Execution des tests POC
### 7.1 Local bash
```bash
bash tests_poc/run.sh
```

### 7.2 Local Docker isole
```bash
bash scripts/run-tests-docker.sh
```

### 7.3 Local Docker silencieux
```bash
bash scripts/run-tests-docker.sh --quiet
```

### 7.4 CI
- `.github/workflows/poc-tests-minimal.yml`
- `.github/workflows/poc-tests-verbose.yml`

## 8. Limites POC
1. pas de monorepo,
2. pas de matrice multi-environnements,
3. pas de reporting avance complet,
4. pas de framework plugins complet.

Backlog et priorisation: voir `docs/POC/ROADMAP.md`.
