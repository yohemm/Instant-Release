# InstantRelease - Roadmap d'execution

Objectif: piloter l'execution technique POC sans dupliquer les regles deja gouvernees par PAQ/Kanban/OBS.

## 0. Cadre documentaire (source de verite)
1. Regles process/qualite/gates/DoD: `docs/PAQ.md`.
2. Workflow Kanban, statuts, WIP, SLA, automations: `docs/KANBAN_DISCIPLINE.md`.
3. Organisation et responsabilites: `docs/OBS.md`.
4. Design technique POC: `docs/POC/TECHNICAL_DOCS.md`.
5. Intentions officielles de la methode projet: `docs/PAQ.md` section 2.1.
6. Maitrise des risques et contingence: `docs/RISK_MANAGEMENT_PLAN.md`.

## 0.1 Regle d'alignement roadmap -> intentions
1. Chaque lot doit contribuer explicitement a au moins une intention PAQ.
2. Si un lot n'aligne aucune intention prioritaire, il reste en backlog.
3. Toute re-priorisation de lot doit mentionner l'intention cible impactee.

## 0.2 Mode planning actuel (sans deadline officielle)
Contexte:
1. Aucune date contractuelle/externe n'est imposee a ce stade.
2. Le projet est en phase dominante documentation.

Decision:
1. Pilotage en timeline relative, basee sur des cycles (`{{CYCLE_01}}`, `{{CYCLE_02}}`, ...).
2. Aucune promesse de date calendaire tant qu'aucune contrainte formelle n'est emise.

Definition du cycle:
1. `2 jours execution + 3e jour pilotage/reunion` (cadence Kanban validee).

Regles:
1. La roadmap est priorisee en ordre de passage (`Now`, `Next`, `Later`) et non en dates.
2. Un item passe au cycle suivant seulement si les criteres de completion sont atteints.
3. La conversion `Cycle -> Date` est activee uniquement a reception d'une contrainte externe formelle.

## 0.3 Timeline relative Doc/Dev (stream de travail)
| Stream | Horizon | Perimetre | Capacite cible | Cible |
|---|---|---|---|---|
| Documentation | Now | Alignement PAQ/Kanban/Risk/Setup + coherence sources de verite | 100% capacite equipe | `{{CYCLE_01}}` |
| Documentation | Next | Consolidation SFD/Traceability/Runbooks + nettoyage placeholders critiques | 80-100% capacite | `{{CYCLE_02}}` |
| Documentation | Later | Optimisation gouvernance et preparation scale (7 personnes) | 40-60% capacite | `{{CYCLE_03+}}` |
| Developpement | Now | Aucun developpement prioritaire (phase doc) | 0-20% capacite (correctifs mineurs) | `{{CYCLE_01}}` |
| Developpement | Next | Reprise progressive selon readiness documentaire | 20-50% capacite | `{{CYCLE_02}}` |
| Developpement | Later | Execution lots produit selon WBS/SFD | >=50% capacite | `{{CYCLE_03+}}` |

Regle capacitaire:
1. Tant qu'aucune deadline externe n'existe, la capacite reste orientee documentation.
2. Toute augmentation du stream dev doit etre justifiee en reunion Jour 3.

## 0.4 Trigger de bascule vers timeline datee
La roadmap passe en mode date (calendaire) si au moins un trigger est vrai:
1. Deadline client/formation/jury officiellement communiquee.
2. Date de release contractuelle imposee.
3. Dependance externe avec fenetre fixe (integration, audit, evenement).

Actions de bascule:
1. Remplacer placeholders `{{CYCLE_xx}}` par dates cibles.
2. Rebaseliner capacite doc/dev par semaine.
3. Revalider milestones de release par repo.

## 1. Flux POC cible
1. Charger config.
2. Verifier pre-requis.
3. Calculer version.
4. Generer changelog.
5. Creer tag + release.

## 2. Lots et statut
| Lot | Perimetre | Statut | Evidence attendue | Cible |
|---|---|---|---|---|
| L1 POC livrable | config + version + changelog + tag + release + dry-run | En cours | run E2E sur repo test + release creee | `{{CYCLE_01}}` |
| L2 Qualite/robustesse | validation schema, gestion erreurs, logs audit/debug | A planifier | PR + tests integration + logs verifiables | `{{CYCLE_02}}` |
| L3 Securite/compliance | scans dependances, scans secrets, rapport audit JSON | A planifier | pipeline CI avec rapports attaches | `{{CYCLE_03}}` |
| L4 Extensibilite | webhooks pre/post, plugins pre/post, hooks on-failure | A planifier | demo fonctionnelle sur repo sandbox | `{{CYCLE_04}}` |
| L5 Vision long terme | monorepo, matrices de deploiement, supply-chain etendue, rapports multi-formats | Backlog | specs valides + decoupage WBS associe | `{{CYCLE_05}}` |

## 2.1 Mapping lots -> milestones repo
| Lot | Repo principal | Milestone fonctionnelle | Milestone release |
|---|---|---|---|
| L1 POC livrable | `instant-release_ACTIONS` | `ACTIONS-M2-VERSIONING-CHANGELOG-RELEASE` | `ACTIONS-v{{ACTIONS_VERSION_01}}` |
| L2 Qualite/robustesse | `instant-release_ACTIONS` | `ACTIONS-M3-QUALITY-GATES-CI` | `ACTIONS-v{{ACTIONS_VERSION_02}}` |
| L3 Securite/compliance | `instant-release_ACTIONS` | `ACTIONS-M4-SUPPLY-CHAIN-EVIDENCE` | `ACTIONS-v{{ACTIONS_VERSION_03}}` |
| L4 Extensibilite | `instant-release_ACTIONS` | `ACTIONS-M5-RELEASE-HARDENING` | `ACTIONS-v{{ACTIONS_VERSION_04}}` |
| L5 Vision long terme | `instant-release_ACTIONS` + cross-repo | `{{MILESTONE_LONG_TERM_01}}` | `{{MILESTONE_RELEASE_LONG_TERM_01}}` |

Regles:
1. Chaque ticket roadmap porte un `Cycle` + une `Milestone`.
2. Le `Cycle` peut changer si glissement; la `Milestone` reste stable tant que l'objectif ne change pas.
3. La milestone release se ferme uniquement apres preuves CI/tests/release.

## 3. Checklist operationnelle immediate
1. Finaliser `create-release` dans le flux POC si non termine.
2. Fermer les ecarts L1 avec preuve (issue/PR/run/release).
3. Decouper L2 en issues atomiques (1 issue = 1 resultat testable).
4. Planifier L3 avec outillage concret par repo.
5. Revue Jour 3: go/no-go passage L1 -> L2.

## 4. Definition de completion roadmap
Un lot est clos seulement si:
1. l'evidence attendue est disponible et verifiable,
2. les tickets associes sont en `Done`,
3. les preuves CI/tests sont liees,
4. la documentation impactee est mise a jour.

## 5. Version
- Version: `ROADMAP-v2.0`
- Statut: `Nettoye et aligne`
- Date d'effet: `2026-03-03`
- Prochaine revue cible: `{{date_prochaine_revue}}`
