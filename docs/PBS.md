# PBS Definitif - InstantRelease Platform

## 1. Objet
Ce document est le **referentiel officiel PBS** (Product Breakdown Structure) pour InstantRelease, aligne sur la vision definitive cible de `docs/FULL_DOCS.md` et sur le perimetre confirme de l'equipe.

Le PBS decompose uniquement le **produit a livrer** (noms/livrables), sans decrire les taches d'execution (WBS).
Pour l'organisation et les responsabilites, la source de verite est `docs/OBS.md`.
Pour le decoupage du travail, la source de verite est `docs/WBS.md`.
Pour le pilotage Kanban (workflow/WIP/tickets), la source de verite est `docs/KANBAN_DISCIPLINE.md`.
Pour les politiques qualite/tests/gates/release, la source de verite est `docs/PAQ.md`.

## 2. Baseline validee
- Vision produit: version definitive cible (`FULL_DOCS`).
- Equipe:
  - 1 manager
  - 2 dev DevOps
  - 2 dev FullStack web
- Topologie de code source:
  - 4 repositories GitHub distincts:
    - `instant-release_API`
    - `instant-release_APP`
    - `instant-release_VITRINE`
    - `instant-release_ACTIONS`
- Perimetre:
  - DevOps: GitHub, Bash (versioning, changelog, tag, release, qualite, securite, deploiement optionnel), GitHub CI.
  - Web: site vitrine, application web de pilotage, API.
  - UX/UI et Marketing/Diffusion inclus comme sous-systemes produit.

## 3. Regles de decomposition
- Regle des 100%: les sous-elements couvrent totalement leur parent.
- Exclusivite mutuelle: un composant n'apparait qu'une seule fois.
- Livrables uniquement: aucun verbe d'activite dans le PBS.
- Granularite: detail jusqu'au niveau N3 (sous-composants) pour un pilotage exploitable.

## 4. Niveaux PBS
| Niveau | Definition |
|---|---|
| N0 | Produit final |
| N1 | Sous-systemes majeurs |
| N2 | Composants structurants par sous-systeme |
| N3 | Sous-composants livrables et observables |

## 5. Arborescence PBS complete
```text
N0 PF0 InstantRelease Platform
├─ N1 S1 DevOps CI/CD Core
│  ├─ N2 S1.C1 Integration GitHub
│  │  ├─ N3 S1.C1.SC1 Action GitHub (composite)
│  │  ├─ N3 S1.C1.SC2 Gestion auth/permissions/tokens
│  │  └─ N3 S1.C1.SC3 Interface API GitHub (tags/releases/workflow metadata)
│  ├─ N2 S1.C2 Moteur Bash de release
│  │  ├─ N3 S1.C2.SC1 Domaine configuration (.instantrelease.yml)
│  │  ├─ N3 S1.C2.SC2 Domaine versioning semver
│  │  ├─ N3 S1.C2.SC3 Domaine generation changelog
│  │  ├─ N3 S1.C2.SC4 Domaine tagging/release
│  │  └─ N3 S1.C2.SC5 Domaine garde-fous (dry-run/idempotence/retry)
│  ├─ N2 S1.C3 Orchestration GitHub CI
│  │  ├─ N3 S1.C3.SC1 Workflow pre-flight
│  │  ├─ N3 S1.C3.SC2 Workflow build/tests/quality gates
│  │  ├─ N3 S1.C3.SC3 Workflow security gates
│  │  ├─ N3 S1.C3.SC4 Workflow version/changelog/tag/release
│  │  └─ N3 S1.C3.SC5 Workflow deploiement/rollback (optionnel)
│  ├─ N2 S1.C4 Qualite et securite produit
│  │  ├─ N3 S1.C4.SC1 Suite tests unitaires (services)
│  │  ├─ N3 S1.C4.SC2 Suite tests end-to-end (controllers)
│  │  ├─ N3 S1.C4.SC3 Suite tests integration (workflows/modules)
│  │  ├─ N3 S1.C4.SC4 Socle couverture/linting
│  │  ├─ N3 S1.C4.SC5 Socle scans securite (deps/secrets/SAST)
│  │  └─ N3 S1.C4.SC6 Socle supply-chain (SBOM/provenance/signing)
│  ├─ N2 S1.C5 Extensibilite et observabilite
│  │  ├─ N3 S1.C5.SC1 Webhooks pre/post/failure
│  │  ├─ N3 S1.C5.SC2 Plugins/scripts externes
│  │  ├─ N3 S1.C5.SC3 Rapports conformite/deploiement
│  │  └─ N3 S1.C5.SC4 Export audit logs et artifacts
│  └─ N2 S1.C6 Packaging technique
│     ├─ N3 S1.C6.SC1 Structure scripts/modules/templates
│     ├─ N3 S1.C6.SC2 Sorties action (outputs standards)
│     └─ N3 S1.C6.SC3 Documentation d'integration workflow
├─ N1 S2 Plateforme Web (Site + App + API)
│  ├─ N2 S2.C1 Site vitrine
│  │  ├─ N3 S2.C1.SC1 Pages produit (valeur/fonctionnalites)
│  │  ├─ N3 S2.C1.SC2 Pages documentation publique
│  │  └─ N3 S2.C1.SC3 Pages contact/conversion
│  ├─ N2 S2.C2 Application web de pilotage
│  │  ├─ N3 S2.C2.SC1 Dashboard statistiques release/qualite/securite
│  │  ├─ N3 S2.C2.SC2 Console de modification de configuration
│  │  ├─ N3 S2.C2.SC3 Journal d'execution et statut des workflows
│  │  └─ N3 S2.C2.SC4 Console operationnelle (actions de controle)
│  ├─ N2 S2.C3 API metier
│  │  ├─ N3 S2.C3.SC1 API statistiques
│  │  ├─ N3 S2.C3.SC2 API configuration
│  │  ├─ N3 S2.C3.SC3 API executions/releases
│  │  └─ N3 S2.C3.SC4 API authentification/autorisation
│  └─ N2 S2.C4 Services transverses web
│     ├─ N3 S2.C4.SC1 Gestion et persistence des donnees metriques
│     ├─ N3 S2.C4.SC2 Journalisation et observabilite web
│     └─ N3 S2.C4.SC3 Contrats d'echange front/API
├─ N1 S3 Documentation et gouvernance projet
│  ├─ N2 S3.C1 Documentation technique
│  │  ├─ N3 S3.C1.SC1 Dossier architecture et flux
│  │  ├─ N3 S3.C1.SC2 Catalogue inputs/outputs/modules
│  │  └─ N3 S3.C1.SC3 Runbooks exploitation/release/deploy
│  ├─ N2 S3.C2 Documentation management
│  │  ├─ N3 S3.C2.SC1 PBS
│  │  ├─ N3 S3.C2.SC2 WBS
│  │  ├─ N3 S3.C2.SC3 OBS
│  │  ├─ N3 S3.C2.SC4 Quality Plan
│  │  ├─ N3 S3.C2.SC5 Definition of Done
│  │  └─ N3 S3.C2.SC6 Matrice tracabilite Features->Requirements->Tests
│  └─ N2 S3.C3 Gouvernance documentaire
│     ├─ N3 S3.C3.SC1 Convention de nommage et structure depot docs
│     ├─ N3 S3.C3.SC2 Versioning et cycle de revue documentaire
│     └─ N3 S3.C3.SC3 Journal des changements documentaires
├─ N1 S4 Design et Experience (UX/UI)
│  ├─ N2 S4.C1 Strategie UX
│  │  ├─ N3 S4.C1.SC1 Personae et profils d'usage
│  │  ├─ N3 S4.C1.SC2 Parcours utilisateurs cibles
│  │  └─ N3 S4.C1.SC3 Architecture d'information
│  ├─ N2 S4.C2 Systeme UI
│  │  ├─ N3 S4.C2.SC1 Design tokens (couleurs/typo/espaces)
│  │  ├─ N3 S4.C2.SC2 Bibliotheque composants UI
│  │  └─ N3 S4.C2.SC3 Patterns d'etat (loading/succes/erreur/vide)
│  └─ N2 S4.C3 Specifications d'interface
│     ├─ N3 S4.C3.SC1 Maquettes site vitrine
│     ├─ N3 S4.C3.SC2 Maquettes application de pilotage
│     ├─ N3 S4.C3.SC3 Regles accessibilite et ergonomie
│     └─ N3 S4.C3.SC4 Referentiel contenu UX (microcopy)
└─ N1 S5 Marketing et diffusion
   ├─ N2 S5.C1 Positionnement produit
   │  ├─ N3 S5.C1.SC1 Proposition de valeur
   │  ├─ N3 S5.C1.SC2 Message par cible
   │  └─ N3 S5.C1.SC3 Differenciateurs produit
   ├─ N2 S5.C2 Assets de diffusion
   │  ├─ N3 S5.C2.SC1 One-pager produit
   │  ├─ N3 S5.C2.SC2 Kit de lancement (visuels/annonces)
   │  └─ N3 S5.C2.SC3 Demos et captures produit
   ├─ N2 S5.C3 Canaux de diffusion
   │  ├─ N3 S5.C3.SC1 Presence GitHub (README, badges, releases)
   │  ├─ N3 S5.C3.SC2 Presence web (site et contenus SEO)
   │  └─ N3 S5.C3.SC3 Campagnes relationnelles (news, social, communiques)
   └─ N2 S5.C4 Mesure d'adoption
      ├─ N3 S5.C4.SC1 KPI d'adoption et de conversion
      ├─ N3 S5.C4.SC2 Tableau de suivi diffusion
      └─ N3 S5.C4.SC3 Boucle de feedback vers roadmap
```

## 6. Tableau detaille des descriptions (N1/N2)
| ID | Niveau | Element livrable | Description detaillee |
|---|---|---|---|
| PF0 | N0 | InstantRelease Platform | Produit final integre combinant automatisation DevOps CI/CD, surface web de pilotage, API metier, gouvernance documentaire, UX/UI et diffusion marche. |
| S1 | N1 | DevOps CI/CD Core | Sous-systeme qui industrialise le cycle release de bout en bout (pre-flight, build, tests, securite, versioning, release, deploy optionnel) avec controle qualité et traçabilite. |
| S1.C1 | N2 | Integration GitHub | Ensemble des livrables permettant l'execution native dans l'ecosysteme GitHub: action composite, securisation des acces, interactions API pour tags/releases/statuts. |
| S1.C2 | N2 | Moteur Bash de release | Coeur fonctionnel scriptable et versionnable qui porte la logique produit: configuration, bump semver, changelog, tagging, release, garde-fous. |
| S1.C3 | N2 | Orchestration GitHub CI | Definition livrable des workflows et de leurs points de controle, du pre-flight a la publication, avec chemins nominal et erreur. |
| S1.C4 | N2 | Qualite et securite produit | Composants de verification qui qualifient la livrabilite: tests unitaires services, tests end-to-end controllers, integration, lint/couverture, scans securite et livrables supply-chain. |
| S1.C5 | N2 | Extensibilite et observabilite | Capacites d'integration et de supervision: webhooks, plugins, rapports, audit exportable. |
| S1.C6 | N2 | Packaging technique | Structure du produit DevOps sous forme de modules/scripts/templates et documentation d'integration exploitable par les equipes cibles. |
| S2 | N1 | Plateforme Web | Sous-systeme offrant la couche de presentation et de pilotage du produit: site vitrine, application operationnelle et API associee. |
| S2.C1 | N2 | Site vitrine | Livrable de communication produit publique: proposition de valeur, documentation d'acces, points de conversion. |
| S2.C2 | N2 | Application web de pilotage | Livrable operationnel pour suivre les executions, consulter les metriques et piloter la configuration release sans intervention manuelle bas niveau. |
| S2.C3 | N2 | API metier | Livrable de services backend exposes a l'application et a d'autres integrations: stats, configuration, executions, controle d'acces. |
| S2.C4 | N2 | Services transverses web | Livrables de robustesse de la plateforme web: persistence metriques, journalisation, et contrats d'echange front/API. |
| S3 | N1 | Documentation et gouvernance projet | Sous-systeme assurant cadrage, alignement, exploitation et auditabilite continue du produit et du projet. |
| S3.C1 | N2 | Documentation technique | Corpus technique de reference (architecture, flux, modules, operations) necessaire a l'implementation et l'exploitation. |
| S3.C2 | N2 | Documentation management | Corpus de pilotage projet (PBS/WBS/OBS, plan qualite, DoD, tracabilite exigences/tests) pour decision et suivi. |
| S3.C3 | N2 | Gouvernance documentaire | Normes et mecanismes de maintenance documentaire garantissant coherence, revision et historisation. |
| S4 | N1 | Design et Experience (UX/UI) | Sous-systeme garantissant qualite d'usage, coherence visuelle et ergonomie de tous les livrables web. |
| S4.C1 | N2 | Strategie UX | Livrables de cadrage experience utilisateur: profils, parcours, architecture d'information. |
| S4.C2 | N2 | Systeme UI | Livrables de conception visuelle reutilisables: tokens, bibliotheque composants, patterns d'etat. |
| S4.C3 | N2 | Specifications d'interface | Livrables de conception detaillee des interfaces site/app avec exigences d'accessibilite et de clarté du contenu UX. |
| S5 | N1 | Marketing et diffusion | Sous-systeme qui transforme le produit en offre visible, compréhensible et adoptee par les cibles. |
| S5.C1 | N2 | Positionnement produit | Livrables de cadrage marche: promesse, message par cible, facteurs differenciants. |
| S5.C2 | N2 | Assets de diffusion | Ensemble des supports de lancement et demonstration destines a accelerer comprehension et adoption. |
| S5.C3 | N2 | Canaux de diffusion | Presence distribuee du produit sur canaux pertinents (GitHub, web, communication relationnelle). |
| S5.C4 | N2 | Mesure d'adoption | Livrables de pilotage de la traction: KPI, tableau de suivi, boucle de feedback produit. |

## 7. Catalogue detaille des sous-composants (N3)
### 7.1 S1 DevOps CI/CD Core
| ID | Sous-composant | Description detaillee |
|---|---|---|
| S1.C1.SC1 | Action GitHub (composite) | Package action reusable exposant inputs/outputs standards et sequence d'execution conforme au flux produit. |
| S1.C1.SC2 | Gestion auth/permissions/tokens | Definition des secrets, permissions minimales et regles d'acces aux operations Git/GitHub. |
| S1.C1.SC3 | Interface API GitHub | Ensemble des interactions API pour tags, releases, statuts et metadonnees d'execution. |
| S1.C2.SC1 | Domaine configuration | Modele de configuration unique et structurant du produit (`.instantrelease.yml`). |
| S1.C2.SC2 | Domaine versioning semver | Mecanisme de calcul de version a partir des commits et conventions semantiques. |
| S1.C2.SC3 | Domaine generation changelog | Production des notes de changement a partir de l'historique de commits/tags. |
| S1.C2.SC4 | Domaine tagging/release | Production des tags et publication de release avec notes associees. |
| S1.C2.SC5 | Domaine garde-fous | Mecanismes de surete d'execution: dry-run, idempotence, retry, gestion echec. |
| S1.C3.SC1 | Workflow pre-flight | Controle de preconditions avant execution principale (config, token, blocants). |
| S1.C3.SC2 | Workflow build/tests/quality | Chaine d'assurance qualite avant publication. |
| S1.C3.SC3 | Workflow security gates | Chaine de verification securite et conformite des dependances et du code. |
| S1.C3.SC4 | Workflow version/changelog/tag/release | Chaine de publication versionnee standardisee. |
| S1.C3.SC5 | Workflow deploiement/rollback | Chaine de mise en production et restauration conditionnelle. |
| S1.C4.SC1 | Suite tests unitaires (services) | Couverture unitaire des services metier (API et modules coeur) avec isolation des dependances. |
| S1.C4.SC2 | Suite tests end-to-end (controllers) | Validation des endpoints controllers de bout en bout (requete -> controleur -> service -> reponse). |
| S1.C4.SC3 | Suite tests integration (workflows/modules) | Validation des interactions entre modules Bash, workflows CI et contrats d'entrees/sorties. |
| S1.C4.SC4 | Socle couverture/linting | Metriques minimales de qualite code et style. |
| S1.C4.SC5 | Socle scans securite | Verification dependances, secrets et analyse statique. |
| S1.C4.SC6 | Socle supply-chain | Livrables SBOM, provenance et signature pour securiser la chaine logicielle de build et release. |
| S1.C5.SC1 | Webhooks | Points d'integration externes sur les moments critiques du workflow. |
| S1.C5.SC2 | Plugins externes | Capacite d'extension par scripts custom hors noyau. |
| S1.C5.SC3 | Rapports | Rapports de conformite/deploiement exploitables par management/ops. |
| S1.C5.SC4 | Audit logs et artifacts | Traces horodatees exportables pour audit et post-mortem. |
| S1.C6.SC1 | Structure scripts/modules/templates | Organisation produit en composants techniques maintenables. |
| S1.C6.SC2 | Sorties action | Contrat des outputs pour consommation par workflows aval. |
| S1.C6.SC3 | Documentation integration workflow | Guide d'usage et d'integration dans les pipelines clients. |

### 7.2 S2 Plateforme Web
| ID | Sous-composant | Description detaillee |
|---|---|---|
| S2.C1.SC1 | Pages produit | Presentation du produit, benefices, fonctionnalites, cas d'usage. |
| S2.C1.SC2 | Pages documentation publique | Acces a la documentation de demarrage et d'exploitation. |
| S2.C1.SC3 | Pages contact/conversion | Interfaces de contact, adoption et orientation utilisateur. |
| S2.C2.SC1 | Dashboard statistiques | Visualisation des indicateurs release, qualite et securite. |
| S2.C2.SC2 | Console configuration | Interface de consultation/modification de la configuration. |
| S2.C2.SC3 | Journal d'execution | Traçabilite visuelle des runs, statuts et incidents. |
| S2.C2.SC4 | Console operationnelle | Commandes de pilotage applicatif et suivi d'etat systeme. |
| S2.C3.SC1 | API statistiques | Exposition des metriques pour dashboard et analyses externes. |
| S2.C3.SC2 | API configuration | Exposition des operations de lecture/ecriture de configuration. |
| S2.C3.SC3 | API executions/releases | Exposition de l'historique de runs et informations de release. |
| S2.C3.SC4 | API auth/autorisation | Controle d'acces et droits sur operations API. |
| S2.C4.SC1 | Persistence metriques | Stockage durable des donnees de suivi et performance. |
| S2.C4.SC2 | Journalisation web | Traces techniques applicatives et operationnelles cote web/API. |
| S2.C4.SC3 | Contrats front/API | Schemas d'echanges stabilises entre UI et backend. |

### 7.3 S3 Documentation et gouvernance projet
| ID | Sous-composant | Description detaillee |
|---|---|---|
| S3.C1.SC1 | Dossier architecture et flux | Description des composants, flux d'execution et interactions techniques. |
| S3.C1.SC2 | Catalogue inputs/outputs/modules | Reference complete des entrees, sorties et modules du produit. |
| S3.C1.SC3 | Runbooks exploitation/release/deploy | Procedures operationnelles standard pour execution et incidents. |
| S3.C2.SC1 | PBS | Decoupage officiel du produit final. |
| S3.C2.SC2 | WBS | Decoupage officiel du travail et des lots livrables. |
| S3.C2.SC3 | OBS | Decoupage officiel des roles et responsabilites. |
| S3.C2.SC4 | Quality Plan | Regles process/outillage/qualite communes du projet. |
| S3.C2.SC5 | Definition of Done | Critere de fin mesurable pour user stories/features/livrables. |
| S3.C2.SC6 | Matrice de tracabilite | Lien explicite features -> requirements -> tests -> preuves. |
| S3.C3.SC1 | Convention nommage/structure docs | Normes de structuration du referentiel documentaire. |
| S3.C3.SC2 | Versioning et revue docs | Cycle de mise a jour/validation des documents. |
| S3.C3.SC3 | Journal des changements docs | Historique de decisions et evolutions documentaires. |

### 7.4 S4 Design et Experience (UX/UI)
| ID | Sous-composant | Description detaillee |
|---|---|---|
| S4.C1.SC1 | Personae et profils d'usage | Description des profils utilisateurs cibles et de leurs besoins. |
| S4.C1.SC2 | Parcours utilisateurs | Parcours de bout en bout sur site, app et operations de pilotage. |
| S4.C1.SC3 | Architecture d'information | Organisation de l'information et navigation cross-surfaces. |
| S4.C2.SC1 | Design tokens | Base visuelle unifiee (couleurs, typographies, espacements). |
| S4.C2.SC2 | Bibliotheque composants UI | Composants reutilisables garantissant coherence et vitesse de livraison. |
| S4.C2.SC3 | Patterns d'etat UI | Gestion normalisee des etats feedback utilisateur. |
| S4.C3.SC1 | Maquettes site vitrine | Specifications visuelles et structurelles des ecrans vitrine. |
| S4.C3.SC2 | Maquettes application | Specifications visuelles et structurelles des ecrans applicatifs. |
| S4.C3.SC3 | Regles accessibilite/ergonomie | Regles minimales d'usage, lisibilite et inclusivite. |
| S4.C3.SC4 | Referentiel microcopy | Corpus des textes interface pour coherence produit. |

### 7.5 S5 Marketing et diffusion
| ID | Sous-composant | Description detaillee |
|---|---|---|
| S5.C1.SC1 | Proposition de valeur | Definition formelle de la promesse produit et du probleme resolu. |
| S5.C1.SC2 | Message par cible | Adaptation du discours aux parties prenantes prioritaires. |
| S5.C1.SC3 | Differenciateurs | Positionnement comparatif et avantages distinctifs. |
| S5.C2.SC1 | One-pager produit | Support synthese de presentation pour usage interne/externe. |
| S5.C2.SC2 | Kit de lancement | Ensemble de contenus diffusion (visuels, annonces, scripts). |
| S5.C2.SC3 | Demos et captures | Materiaux de demonstration du produit en usage reel. |
| S5.C3.SC1 | Presence GitHub | Actifs de diffusion sur depot/release/readme/badges. |
| S5.C3.SC2 | Presence web SEO | Actifs de decouvrabilite via contenus web cibles. |
| S5.C3.SC3 | Campagnes relationnelles | Supports de communication continue vers la communaute/cibles. |
| S5.C4.SC1 | KPI adoption/conversion | Metriques officielles de traction produit. |
| S5.C4.SC2 | Tableau de suivi diffusion | Visualisation periodique des performances de diffusion. |
| S5.C4.SC3 | Boucle feedback roadmap | Integration des retours marche dans le pilotage evolutif. |

## 8. Topologie repositories et ancrage
| Repository | Domaine principal PBS | Contenu attendu |
|---|---|---|
| `instant-release_ACTIONS` | S1 DevOps CI/CD Core + S3 docs techniques de release | Action GitHub, scripts Bash, workflows CI, tests integration, controle qualite/securite/supply-chain |
| `instant-release_API` | S2.C3 API metier + S2.C4 services transverses | API stats/config/executions/auth, logique metier services, tests unitaires services et e2e controllers |
| `instant-release_APP` | S2.C2 app web de pilotage + S4 UX/UI app | dashboard, console configuration, journal executions, application des specs UI/UX |
| `instant-release_VITRINE` | S2.C1 site vitrine + S4 UX/UI vitrine + S5 diffusion | pages produit/docs/contact, assets marketing, contenu SEO et conversion |

### Trace existante dans le depot courant
Le depot courant couvre principalement le scope `instant-release_ACTIONS` et la base documentaire:
- DevOps CI/CD Core: `poc-action/action.yml`, `scripts/poc/main.sh`, `scripts/poc/lib/*.sh`, `tests_poc/*`, `.github/workflows/*`
- Documentation: `docs/FULL_DOCS.md`, `docs/TECHNICAL_DOCS.md`, `docs/ROADMAP.md`, `docs/PBS.md`, `help/Management-info-and-doc.md`
- Exigences/tests/tracabilite operationnelle: `docs/SFD_REQUIREMENTS.md`, `docs/TRACEABILITY_MATRIX.md`
- Hardware requirements: `docs/HARDWARE_REQUIREMENTS.md`
- Base web documentaire locale: `index.html`, `style.css`, `Doc-technique.html`, `README.md`

## 9. Perimetre et frontieres
### Inclus
- Tous les composants N1 a N3 definis dans ce document.
- Livrables DevOps, Web, API, Documentation, UX/UI et Marketing/Diffusion.
- Pilotage et coherence de livraison sur 4 repositories.

### Exclus
- Organisation des taches et charges (WBS).
- Affectation des roles (OBS).
- Ordonnancement detaille, budget, planning sprint.

## 10. Critere de fermeture du PBS
- Niveaux N0, N1, N2, N3 completes sans section inachevee.
- Aucun placeholder ou "a preciser" restant.
- Coherence explicite avec la vision `FULL_DOCS`.
- Validation manager + representants DevOps + representants Web.
