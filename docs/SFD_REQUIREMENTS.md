# SFD REQUIREMENTS - InstantRelease

## 1. Objet
Ce document definit la specification fonctionnelle v1 sous la forme:
`Features -> Requirements -> Criteres d'acceptation -> Tests -> Priorite`.

Objectif:
1. rendre chaque exigence codable, testable et tracable,
2. aligner le backlog fonctionnel sur `docs/PBS.md`, `docs/WBS.md` et `docs/PAQ.md`,
3. fournir une base exploitable directement dans GitHub Issues/Project.

## 2. References (source de verite)
1. PBS: `docs/PBS.md`
2. WBS: `docs/WBS.md`
3. PAQ (tests/gates/DoR/DoD): `docs/PAQ.md`
4. Workflow tickets: `docs/KANBAN_DISCIPLINE.md`
5. Organisation: `docs/OBS.md`
6. Matrice operationnelle d'execution: `docs/TRACEABILITY_MATRIX.md`
7. Infra/deploiement: `docs/INFRA_SERVER_SYSTEM.md`

## 3. Conventions de tracabilite
1. IDs:
   - Feature: `F-XXX`
   - Requirement: `RQ-XXX`
   - Test: `T-XXX`
2. Format de trace obligatoire:
   - `Repository | PBS ID | WBS ID | Requirement ID | Test ID`
3. Regle qualite:
   - seuils bloquants et derogations: voir `docs/PAQ.md` section 9.
4. Regle release:
   - push/merge = CI uniquement, deploiement/release selon workflow manuel valide.

## 4. Catalogue des features v1
| Feature ID | Feature | Repository principal | PBS principal | WBS principal |
|---|---|---|---|---|
| F-ACT-01 | Contrat Action GitHub | `instant-release_ACTIONS` | `S1.C1.SC1` | `W2.1` |
| F-ACT-02 | Pre-flight et guardrails execution | `instant-release_ACTIONS` | `S1.C2.SC5` | `W2.2` |
| F-ACT-03 | Versioning/changelog/tag/release | `instant-release_ACTIONS` | `S1.C2.SC2/SC3/SC4` | `W2.3` |
| F-ACT-04 | Qualite/securite/supply-chain CI | `instant-release_ACTIONS` | `S1.C4.SC3/SC4/SC5/SC6` | `W2.4/W2.5` |
| F-ACT-05 | Observabilite et evidence release | `instant-release_ACTIONS` | `S1.C5.SC3/SC4` | `W2.6` |
| F-API-01 | Contrats API stats/config/executions | `instant-release_API` | `S2.C3.SC1/SC2/SC3` | `W3.1` |
| F-API-02 | Services metier API | `instant-release_API` | `S2.C3 + S1.C4.SC1` | `W3.2` |
| F-API-03 | Controllers API | `instant-release_API` | `S2.C3 + S1.C4.SC2` | `W3.3` |
| F-API-04 | Securite API (authN/authZ) | `instant-release_API` | `S2.C3.SC4` | `W3.4` |
| F-API-05 | Qualite et release API | `instant-release_API` | `S1.C4.SC4` | `W3.5/W3.6` |
| F-APP-01 | Dashboard App de pilotage | `instant-release_APP` | `S2.C2.SC1` | `W4.2` |
| F-APP-02 | Console de configuration App | `instant-release_APP` | `S2.C2.SC2` | `W4.3` |
| F-APP-03 | Journal d'execution App | `instant-release_APP` | `S2.C2.SC3` | `W4.4` |
| F-APP-04 | Qualite et release APP | `instant-release_APP` | `S1.C4.SC4` | `W4.5/W4.6` |
| F-VIT-01 | Pages vitrine | `instant-release_VITRINE` | `S2.C1.SC1/SC2/SC3` | `W5.2` |
| F-VIT-02 | SEO/analytics diffusion | `instant-release_VITRINE` | `S5.C3 + S5.C4` | `W5.4` |
| F-VIT-03 | Qualite et release VITRINE | `instant-release_VITRINE` | `S4.C3.SC3 + S1.C4.SC4` | `W5.5/W5.6` |
| F-X-01 | Integration cross-repo | `multi-repo` | `S2.C4.SC3` | `W6.1/W6.2` |
| F-X-02 | Readiness + evidence package | `multi-repo` | `S3.C2.SC5/SC6` | `W6.3/W6.4/W6.5` |
| F-DOC-01 | Tracabilite documentaire continue | `docs` | `S3.C2.SC6` | `W1.1/W1.4` |

## 5. Backlog Features -> Requirements -> Criteres -> Tests -> Priorite
| Feature | Requirement ID | Requirement | Critere d'acceptation | Test associe | Priorite | Traceabilite |
|---|---|---|---|---|---|---|
| F-ACT-01 | RQ-001 | L'action expose un contrat d'entree/sortie explicite et versionne. | `action.yml` contient les inputs/outputs obligatoires et la suite de contrat passe en CI. | T-001 (integration workflow contrat) | P0 | `instant-release_ACTIONS | S1.C1.SC1 | W2.1` |
| F-ACT-01 | RQ-002 | L'action echoue explicitement si un input obligatoire manque. | Execution sans input requis -> echec non ambigu avant etapes de build/release. | T-002 (integration negatif contrat) | P0 | `instant-release_ACTIONS | S1.C1.SC1 | W2.1` |
| F-ACT-02 | RQ-003 | Le pre-flight bloque un lancement release si le contexte Git n'est pas conforme. | Contexte non conforme (ex: branche non autorisee) -> abort avec message de cause. | T-003 (integration pre-flight) | P0 | `instant-release_ACTIONS | S1.C2.SC5 | W2.2` |
| F-ACT-02 | RQ-004 | Le mode `dry-run` ne cree ni tag ni release. | En `dry-run`, aucun artefact de release distant n'est cree. | T-004 (integration dry-run) | P0 | `instant-release_ACTIONS | S1.C2.SC5 | W2.2` |
| F-ACT-02 | RQ-005 | La relance du meme commit/version est idempotente. | Un second run identique ne cree pas de doublon et retourne un statut controle. | T-005 (integration idempotence) | P1 | `instant-release_ACTIONS | S1.C2.SC5 | W2.2` |
| F-ACT-03 | RQ-006 | Le calcul de version suit la convention de commits Angular. | Pour un jeu de commits de reference, la version calculee est conforme au semver attendu. | T-006 (tests unitaires versioning) | P0 | `instant-release_ACTIONS | S1.C2.SC2 | W2.3` |
| F-ACT-03 | RQ-007 | Le changelog est genere automatiquement depuis l'historique valide. | Le changelog est produit/mis a jour et exploitable comme note de release. | T-007 (integration changelog) | P0 | `instant-release_ACTIONS | S1.C2.SC3 | W2.3` |
| F-ACT-03 | RQ-008 | Tag et release publies portent la meme version. | Le tag et la release associee existent et reference la meme version. | T-008 (integration publication release) | P0 | `instant-release_ACTIONS | S1.C2.SC4 | W2.3` |
| F-ACT-04 | RQ-009 | Toute modification ACTIONS/CI declenche les tests d'integration workflows/modules. | PR impactant workflows/scripts ne peut pas merger sans suite integration verte. | T-009 (gating CI integration) | P0 | `instant-release_ACTIONS | S1.C4.SC3 | W2.4` |
| F-ACT-04 | RQ-010 | Les gates bloquants qualite/securite sont appliques conformement au PAQ. | Coverage 100%, tests 100%, lint 0 erreur, 0 vuln critical (sauf derogation coverage manager). | T-010 (verification matrice gates CI) | P0 | `instant-release_ACTIONS | S1.C4.SC4/SC5 | W2.4/W2.5` |
| F-ACT-04 | RQ-011 | Les controles supply-chain minimaux sont fournis sur releases ACTIONS. | Evidence release contient SBOM + provenance + verification signature tag. | T-011 (integration supply-chain evidence) | P0 | `instant-release_ACTIONS | S1.C4.SC6 | W2.5` |
| F-ACT-05 | RQ-012 | Chaque run exporte un rapport d'execution exploitable. | Un artefact de rapport est publie avec statut run + liens checks/release associes. | T-012 (integration reporting artefact) | P1 | `instant-release_ACTIONS | S1.C5.SC3 | W2.6` |
| F-ACT-05 | RQ-013 | Le package de preuves de release est archive pour audit. | Les liens issue/PR/CI/tests/securite/release sont presents et valides. | T-013 (audit checklist evidence) | P0 | `instant-release_ACTIONS | S1.C5.SC4 | W2.6` |
| F-API-01 | RQ-014 | Le contrat API `stats` est stable et teste. | Reponse conforme au schema de contrat documente, code HTTP attendu. | T-014 (e2e controllers stats + schema) | P0 | `instant-release_API | S2.C3.SC1 | W3.1` |
| F-API-01 | RQ-015 | Le contrat API `configuration` expose lecture et ecriture validees. | Lecture valide renvoie 2xx; ecriture invalide renvoie 4xx; ecriture valide persiste. | T-015 (e2e controllers config + unit services validation) | P0 | `instant-release_API | S2.C3.SC2 | W3.1` |
| F-API-01 | RQ-016 | Le contrat API `executions/releases` expose l'historique et les statuts. | Reponse conforme au schema et statuts dans l'enum metier autorise. | T-016 (e2e controllers executions) | P1 | `instant-release_API | S2.C3.SC3 | W3.1` |
| F-API-02 | RQ-017 | Toute logique metier service est couverte par tests unitaires. | Chaque service modifie possede des tests unitaires associes verts. | T-017 (unitaires services) | P0 | `instant-release_API | S1.C4.SC1 | W3.2` |
| F-API-02 | RQ-018 | Les tests unitaires services sont isoles des dependances externes. | La suite unitaire s'execute sans acces reseau externe (adapters/mockes). | T-018 (unitaires services isoles) | P1 | `instant-release_API | S1.C4.SC1 | W3.2` |
| F-API-03 | RQ-019 | Tout endpoint controller modifie est couvert par tests e2e. | Pour chaque endpoint modifie: au moins 1 scenario succes + 1 scenario erreur. | T-019 (e2e controllers matrice succes/erreur) | P0 | `instant-release_API | S1.C4.SC2 | W3.3` |
| F-API-03 | RQ-020 | Les erreurs API sont harmonisees entre controllers. | Format d'erreur et mapping codes HTTP conformes au contrat commun. | T-020 (e2e contrat erreurs) | P1 | `instant-release_API | S2.C3 | W3.3` |
| F-API-04 | RQ-021 | Les endpoints proteges imposent une authentification valide. | Requete non authentifiee refusee; requete authentifiee traitee selon contrat. | T-021 (e2e authN) | P0 | `instant-release_API | S2.C3.SC4 | W3.4` |
| F-API-04 | RQ-022 | Les permissions sont appliquees par role. | Role non autorise refuse, role autorise accepte sur meme endpoint. | T-022 (e2e authZ + unitaires policy) | P0 | `instant-release_API | S2.C3.SC4 | W3.4` |
| F-API-05 | RQ-023 | La release API reste independante des autres repos. | Tag/release API publies sans couplage de version obligatoire aux autres repos, apres deploiement manuel valide. | T-023 (integration pipeline release API) | P1 | `instant-release_API | S1.C4.SC4 | W3.6` |
| F-APP-01 | RQ-024 | Le dashboard affiche les metriques release/qualite/securite issues de l'API. | Ecran charge les donnees et affiche les indicateurs attendus sans erreur bloquante. | T-024 (e2e dashboard) | P1 | `instant-release_APP | S2.C2.SC1 | W4.2` |
| F-APP-01 | RQ-025 | Le dashboard gere etats `loading/empty/error`. | Les 3 etats sont rendus avec composants dedies et messages explicites. | T-025 (tests UI et e2e etats) | P1 | `instant-release_APP | S4.C2.SC3 | W4.2` |
| F-APP-02 | RQ-026 | La console permet modification de configuration avec validation complete. | Saisie invalide bloquee avec feedback; saisie valide appliquee et confirmee. | T-026 (e2e console config) | P0 | `instant-release_APP | S2.C2.SC2 | W4.3` |
| F-APP-02 | RQ-027 | Les modifications de configuration sont tracables dans l'app. | Toute modification validee cree une entree visible dans l'historique operationnel. | T-027 (e2e trace config->journal) | P1 | `instant-release_APP | S2.C2.SC2/SC3 | W4.3/W4.4` |
| F-APP-03 | RQ-028 | Le journal d'execution supporte filtres statut/periode. | Filtrage met a jour la liste conformement aux criteres selectionnes. | T-028 (e2e filtres journal) | P1 | `instant-release_APP | S2.C2.SC3 | W4.4` |
| F-APP-03 | RQ-029 | Le detail d'un run expose statut, erreurs et checks associes. | Selection d'un run ouvre une vue detaillee complete et coherente. | T-029 (e2e detail run) | P1 | `instant-release_APP | S2.C2.SC3 | W4.4` |
| F-APP-04 | RQ-030 | Les checks qualite APP sont bloquants avant merge/release. | Pipeline APP bloque si tests/lint/checks qualite obligatoires echouent. | T-030 (gating CI APP) | P0 | `instant-release_APP | S1.C4.SC4 | W4.5` |
| F-APP-04 | RQ-031 | La release APP est independante par repo/version. | Tag/release APP publies independamment apres deploiement manuel valide et gates verts. | T-031 (integration pipeline release APP) | P1 | `instant-release_APP | S1.C4.SC4 | W4.6` |
| F-VIT-01 | RQ-032 | La vitrine publie les pages produit/docs/contact-conversion. | Les routes cibles sont accessibles et la navigation entre pages est fonctionnelle. | T-032 (e2e smoke navigation vitrine) | P1 | `instant-release_VITRINE | S2.C1.SC1/SC2/SC3 | W5.2` |
| F-VIT-02 | RQ-033 | La vitrine expose metadata SEO/partage et suivi analytics conversion. | Metadata presentes dans build; evenement conversion emis sur CTA principal. | T-033 (integration metadata + e2e conversion tracking) | P1 | `instant-release_VITRINE | S5.C3/S5.C4 | W5.4` |
| F-VIT-03 | RQ-034 | Les checks qualite web vitrine sont bloquants en CI. | Le merge/release est bloque si checks qualite web obligatoires echouent. | T-034 (gating CI VITRINE) | P1 | `instant-release_VITRINE | S4.C3.SC3 + S1.C4.SC4 | W5.5` |
| F-VIT-03 | RQ-035 | La release VITRINE est independante par repo/version. | Tag/release VITRINE publies sans dependance de version globale unique, apres deploiement manuel valide. | T-035 (integration pipeline release VITRINE) | P1 | `instant-release_VITRINE | S1.C4.SC4 | W5.6` |
| F-X-01 | RQ-036 | Une matrice de compatibilite versions est maintenue par fenetre de release. | Chaque fenetre release contient une matrice API/APP/ACTIONS/VITRINE publiee. | T-036 (review documentaire + validation liens) | P0 | `multi-repo | S2.C4.SC3 | W6.1` |
| F-X-01 | RQ-037 | Les scenarios e2e cross-repo sont executes avant go/no-go. | Rapport cross-repo present et suites attendues passees avant decision release. | T-037 (suite e2e cross-repo) | P0 | `multi-repo | S1.C4.SC2/SC3 | W6.2` |
| F-X-02 | RQ-038 | La readiness review ne passe que avec evidence package complet. | Ticket readiness contient preuves minimales PAQ (tests, securite, releases, liens). | T-038 (checklist readiness audit) | P0 | `multi-repo | S3.C2.SC5 | W6.4/W6.5` |
| F-X-02 | RQ-039 | La conformite supply-chain consolidee est verifiee avant decision finale. | Rapport consolide SBOM/provenance/signing disponible pour les repos applicables. | T-039 (audit rapport supply-chain consolide) | P0 | `multi-repo | S1.C4.SC6 | W6.3` |
| F-DOC-01 | RQ-040 | Tout ticket `Ready` reference PBS ID, WBS ID et Test Plan. | Les champs obligatoires sont renseignes avant entree en colonne `Ready`. | T-040 (controle DoR sur ticket template) | P0 | `docs | S3.C2.SC6 | W1.1` |
| F-DOC-01 | RQ-041 | Toute nouvelle feature est ajoutee dans ce SFD avant implementation. | Presence `Feature ID + Requirement ID + Test ID` avant passage en `In Progress`. | T-041 (review documentaire SFD) | P1 | `docs | S3.C2.SC6 | W1.4` |

## 6. Regles d'utilisation dans GitHub Issues
1. 1 issue `Feature` par `Feature ID`.
2. 1 issue `Requirement` par `Requirement ID`.
3. Chaque issue `Requirement` contient:
   - `Repository`
   - `PBS ID`
   - `WBS ID`
   - `Acceptance Criteria`
   - `Test Plan` (incluant `Test ID`)
4. Toute PR reference au moins un `Requirement ID` via `Closes #...` ou `Refs #...`.

## 7. Version
- Version: `SFD-REQ-v1.1`
- Statut: `Proposition complete - realignee process CI/CD`
- Date: `2026-03-03`
