# InstantRelease - Roadmap d'execution

Objectif: piloter l'execution technique POC sans dupliquer les regles deja gouvernees par PAQ/Kanban/OBS.

## 0. Cadre documentaire (source de verite)
1. Regles process/qualite/gates/DoD: `docs/PAQ.md`.
2. Workflow Kanban, statuts, WIP, SLA, automations: `docs/KANBAN_DISCIPLINE.md`.
3. Organisation et responsabilites: `docs/OBS.md`.
4. Design technique POC: `docs/TECHNICAL_DOCS.md`.

## 1. Flux MVP cible
1. Charger config.
2. Verifier pre-requis.
3. Calculer version.
4. Generer changelog.
5. Creer tag + release.

## 2. Lots et statut
| Lot | Perimetre | Statut | Evidence attendue | Cible |
|---|---|---|---|---|
| L1 POC livrable | config + version + changelog + tag + release + dry-run | En cours | run E2E sur repo test + release creee | `{{cycle_L1}}` |
| L2 Qualite/robustesse | validation schema, gestion erreurs, logs audit/debug | A planifier | PR + tests integration + logs verifiables | `{{cycle_L2}}` |
| L3 Securite/compliance | scans dependances, scans secrets, rapport audit JSON | A planifier | pipeline CI avec rapports attaches | `{{cycle_L3}}` |
| L4 Extensibilite | webhooks pre/post, plugins pre/post, hooks on-failure | A planifier | demo fonctionnelle sur repo sandbox | `{{cycle_L4}}` |
| L5 Vision long terme | monorepo, matrices de deploiement, supply-chain etendue, rapports multi-formats | Backlog | specs valides + decoupage WBS associe | `{{cycle_L5}}` |

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
