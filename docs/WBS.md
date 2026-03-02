# WBS - Work Breakdown Structure

## 1. Objet
Ce document definit le **WBS officiel** du programme InstantRelease pour la version cible complete.
Il decompose le travail en lots livrables, alignes sur le PBS et exploitables dans GitHub Issues + GitHub Project.

## 2. Baseline validee
- Repositories:
  - `instant-release_API`
  - `instant-release_APP`
  - `instant-release_ACTIONS`
  - `instant-release_VITRINE`
- Strategie de versioning/release: voir `docs/PAQ.md` section 6 et section 10.
- Mode de pilotage: voir `docs/KANBAN_DISCIPLINE.md`.
- Politique qualite/release: definie dans `docs/PAQ.md` (source de verite).

## 3. Principes WBS
1. Decoupage par livrables et capacites observables.
2. Responsabilite explicite par lot et par repository.
   - L'allocation organisationnelle A/R/C/I detaillee est definie dans `docs/OBS.md` (source de verite).
3. Tracabilite mandatory:
   - Regle officielle definie dans `docs/PAQ.md` section 7.
4. Le lot transverse qualite/securite/integration est **fusionne** dans `W6`.
5. Pas de lot release autonome: la release est integree aux lots repo + validation `W6`.

## 4. Arborescence WBS
```text
W0 Pilotage programme multi-repo
|- W0.1 Cadence Kanban et gouvernance portfolio
|- W0.2 Gestion des risques, decisions et escalades
`- W0.3 Suivi KPI flux, qualite et livraison

W1 Exigences et gouvernance documentaire
|- W1.1 Structuration exigences et tracabilite
|- W1.2 Documentation management (WBS/OBS/DoD/Quality Plan)
|- W1.3 Gouvernance documentaire et conventions
`- W1.4 Alignement permanent PBS <-> WBS <-> backlog

W2 Repository instant-release_ACTIONS
|- W2.1 Contrat Action GitHub (inputs/outputs/comportements)
|- W2.2 Modules coeur (config, pre-flight, guardrails)
|- W2.3 Versioning/changelog/tag/release
|- W2.4 Gates qualite et tests integration workflows/modules
|- W2.5 Securite et supply chain (deps, SBOM, provenance, signing)
`- W2.6 Observabilite, reporting, hooks/plugins

W3 Repository instant-release_API
|- W3.1 Contrats API (routes, schemas, erreurs)
|- W3.2 Services metier + tests unitaires services
|- W3.3 Controllers + tests end-to-end controllers
|- W3.4 Authentification/autorisation et securite API
|- W3.5 Gates qualite (coverage, lint, CI)
`- W3.6 Packaging et release independante API

W4 Repository instant-release_APP
|- W4.1 Socle app et integration API
|- W4.2 Dashboard metriques release/qualite/securite
|- W4.3 Console de modification de configuration
|- W4.4 Journal d'execution et suivi statuts
|- W4.5 Qualite app (tests, lint, accessibilite, perf)
`- W4.6 Packaging et release independante APP

W5 Repository instant-release_VITRINE
|- W5.1 Architecture contenu et message produit
|- W5.2 Pages vitrine (produit, docs, contact, conversion)
|- W5.3 UX/UI vitrine et coherence design system
|- W5.4 SEO, analytics et assets de diffusion
|- W5.5 Qualite web (accessibilite, performance, validite)
`- W5.6 Packaging et release independante VITRINE

W6 Integration transverse qualite/securite
|- W6.1 Coordination dependances et compatibilite cross-repo
|- W6.2 Scenarios end-to-end cross-repo
|- W6.3 Conformite securite et supply chain consolidee
|- W6.4 Readiness review et go/no-go multi-repo
`- W6.5 Evidence package de livraison (preuves de conformite)
```

## 5. Dictionnaire des lots (niveau W0-W6)
| ID | Lot | Objectif | Livrables principaux | Validation de fin |
|---|---|---|---|---|
| W0 | Pilotage programme multi-repo | Piloter flux, capacite et priorites | portfolio GitHub Project, suivi KPI, registre risques/decisions | cadence stable + arbitrages traces |
| W1 | Exigences et gouvernance documentaire | Garantir coherences produit/projet | docs management a jour, matrice tracabilite, quality references | coherence PBS/WBS/OBS validee |
| W2 | instant-release_ACTIONS | Industrialiser le moteur release CI/CD | action contract, modules release, gates qualite/securite, reporting | pipeline release actionnel et auditable |
| W3 | instant-release_API | Livrer API robuste et testee | contrats API, services/controllers, auth, tests unit+e2e | endpoints valides + evidence tests |
| W4 | instant-release_APP | Livrer app de pilotage integree API | dashboard, console config, journal execution, qualite app | parcours critiques valides |
| W5 | instant-release_VITRINE | Livrer vitrine produit et diffusion | pages vitrine, assets diffusion, SEO/analytics | vitrine publiee et mesurable |
| W6 | Integration transverse qualite/securite | Verrouiller cohesion et conformite globales | scenarios cross-repo, controles supply chain, dossier preuves | readiness go/no-go validee |

## 6. Work packages detailles

### 6.1 W0 - Pilotage programme multi-repo
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W0.1 | Cadence et rituels Kanban portfolio | calendrier cycles, ordre du jour standard Jour 3 | aucune |
| W0.2 | Gestion risques/decisions/escalades | registre risques, journal decisions, plan mitigation | W0.1 |
| W0.3 | Pilotage KPI | dashboard lead time, throughput, aging, failure CI | W0.1 |

### 6.2 W1 - Exigences et gouvernance documentaire
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W1.1 | Exigences et tracabilite | matrice `Requirement -> Test -> Evidence` | W0.1 |
| W1.2 | Docs management | WBS/OBS/DoD/Quality Plan synchronises | W1.1 |
| W1.3 | Gouvernance documentaire | conventions nommage/versioning/review docs | W1.2 |
| W1.4 | Sync PBS/WBS/backlog | mapping `PBS ID -> WBS ID -> Issue labels` | W1.1, W1.2 |

### 6.3 W2 - instant-release_ACTIONS
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W2.1 | Contrat action | spec inputs/outputs, comportements nominal/erreur | W1.1 |
| W2.2 | Modules coeur | config/pre-flight/guardrails operationnels | W2.1 |
| W2.3 | Versioning + release | bump/changelog/tag/release fiables | W2.2 |
| W2.4 | Qualite et integration tests | tests integration workflows/modules passes | W2.2, W2.3 |
| W2.5 | Securite + supply chain | deps scan + SBOM + provenance + signing | W2.3 |
| W2.6 | Observabilite | rapports, logs audit, hooks/plugins | W2.4, W2.5 |

### 6.4 W3 - instant-release_API
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W3.1 | Contrats API | routes + schemas + codes erreur normalises | W1.1 |
| W3.2 | Services metier | logique metier + tests unitaires services | W3.1 |
| W3.3 | Controllers HTTP | endpoints + tests end-to-end controllers | W3.1, W3.2 |
| W3.4 | Securite API | authN/authZ + protections API | W3.1 |
| W3.5 | Qualite API | lint/coverage/CI gates API | W3.2, W3.3, W3.4 |
| W3.6 | Packaging release API | version/tag/release independante API | W3.5 |

### 6.5 W4 - instant-release_APP
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W4.1 | Socle APP + contrat API client | architecture app + client API stable | W3.1 |
| W4.2 | Dashboard | vues metriques release/qualite/securite | W4.1, W3.6 |
| W4.3 | Console config | ecrans edition/validation config | W4.1, W3.3 |
| W4.4 | Journal execution | timeline runs/statuts/erreurs | W4.1, W3.3, W2.6 |
| W4.5 | Qualite APP | tests/lint/accessibilite/performance | W4.2, W4.3, W4.4 |
| W4.6 | Packaging release APP | version/tag/release independante APP | W4.5 |

### 6.6 W5 - instant-release_VITRINE
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W5.1 | Strategie contenu | architecture info + messages par cible | W1.2 |
| W5.2 | Pages vitrine | pages produit/docs/contact/conversion | W5.1 |
| W5.3 | UX/UI vitrine | coherence design/accessibilite vitrine | W5.2 |
| W5.4 | SEO + diffusion | metadata, analytics, assets diffusion | W5.2 |
| W5.5 | Qualite web | checks perf/accessibilite/validite | W5.3, W5.4 |
| W5.6 | Packaging release vitrine | version/tag/release independante VITRINE | W5.5 |

### 6.7 W6 - Integration transverse qualite/securite
| WP | Description | Output attendu | Dependances |
|---|---|---|---|
| W6.1 | Compatibilite cross-repo | matrice compatibilite API/APP/ACTIONS/VITRINE | W2.6, W3.6, W4.6, W5.6 |
| W6.2 | Scenarios e2e cross-repo | scenarios bout-en-bout executes et traces | W6.1 |
| W6.3 | Conformite securite/supply-chain | rapport consolide deps/SBOM/provenance/signing | W2.5, W3.5, W4.5, W5.5 |
| W6.4 | Readiness review | decision go/no-go multi-repo | W6.2, W6.3 |
| W6.5 | Evidence package | package preuves (tests, rapports, releases, docs) | W6.4 |

## 7. Ancrage des activites de test dans le WBS
Ce WBS decrit **ou** les activites de test sont executees.  
Les regles qualite et seuils bloquants (coverage, severite securite, derogations) sont maintenus uniquement dans `docs/PAQ.md`.

| Type d'activite test | Lots/WP concernes |
|---|---|
| Tests unitaires services | `W3.2` |
| Tests end-to-end controllers | `W3.3` |
| Tests integration workflows/modules | `W2.4` |
| Scenarios end-to-end cross-repo | `W6.2` |

## 8. Ancrage release dans le WBS
Ce WBS decrit **ou** la release est produite et validee:
1. Production release par repository: `W2.3`, `W3.6`, `W4.6`, `W5.6`.
2. Validation transverse go/no-go: `W6.4`.
3. Package de preuves de livraison: `W6.5`.

Les politiques release (cadence, gates, evidence obligatoire) sont maintenues uniquement dans `docs/PAQ.md` et `docs/KANBAN_DISCIPLINE.md`.

## 9. Critere de fin par lot
| Lot | Critere de fin |
|---|---|
| W0 | Pilotage stable, KPI suivis, aucun blocage critique non traite |
| W1 | Docs management a jour et traces, matrice tracabilite complete |
| W2 | Pipeline ACTIONS complet avec controles qualite/securite/supply-chain |
| W3 | API stable avec tests unitaires services + e2e controllers passes |
| W4 | APP pilotage operationnelle et integree API, qualite validee |
| W5 | Vitrine publiee, qualite web validee, diffusion active |
| W6 | Compatibilite globale validee, readiness go/no-go OK, package preuves complet |

## 10. Ordonnancement recommande (premiere trajectoire)
1. Phase A: `W0 + W1` (cadrage et gouvernance)
2. Phase B: `W2 + W3` (socle release + API)
3. Phase C: `W4 + W5` (surfaces web)
4. Phase D: `W6` (integration transverse, readiness globale)

## 11. Mapping WBS -> Repositories
| WBS | Repository principal | Type de tickets attendu |
|---|---|---|
| W2.* | `instant-release_ACTIONS` | Feature, Requirement, Task, Bug, Incident |
| W3.* | `instant-release_API` | Feature, Requirement, Task, Bug |
| W4.* | `instant-release_APP` | Feature, Requirement, Task, Bug |
| W5.* | `instant-release_VITRINE` | Feature, Task, Documentation |
| W6.* | multi-repo | Feature parent + sous-tickets par repo |

## 12. Liens de reference
- PBS: `docs/PBS.md`
- OBS: `docs/OBS.md`
- PAQ: `docs/PAQ.md`
- Charte Kanban: `docs/KANBAN_DISCIPLINE.md`
- Vision cible: `docs/FULL_DOCS.md`
