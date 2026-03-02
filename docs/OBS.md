# OBS - Organization Breakdown Structure

## 1. Objet
Ce document definit l'**OBS officiel** du programme InstantRelease.
Il precise:
1. la structure organisationnelle,
2. les roles et prerogatives,
3. les responsabilites par repository et par lot WBS,
4. les regles de decision, d'interface et d'escalade.

Ce document est aligne avec:
- `docs/PBS.md`
- `docs/WBS.md`
- `docs/KANBAN_DISCIPLINE.md`
- `docs/PAQ.md`

Frontiere documentaire:
1. `docs/OBS.md` est la source unique pour roles, ownership, RACI et escalade.
2. Les politiques qualite/tests/gates/DoR-DoD sont maintenues dans `docs/PAQ.md`.
3. Le workflow board/WIP/tickets est maintenu dans `docs/KANBAN_DISCIPLINE.md`.

## 2. Baseline organisationnelle
- Equipe totale: 5 personnes.
  - 1 manager
  - 2 dev DevOps
  - 2 dev FullStack web
- Repositories:
  - `instant-release_API`
  - `instant-release_APP`
  - `instant-release_ACTIONS`
  - `instant-release_VITRINE`
- Versioning: voir `docs/PAQ.md` section 6.
- Mode de pilotage: voir `docs/KANBAN_DISCIPLINE.md`.

## 3. Arborescence OBS
```text
O0 Programme InstantRelease
|- O1 Management et gouvernance
|  `- O1.1 Manager programme (MGR)
|- O2 Engineering DevOps
|  |- O2.1 DevOps Lead (DOP-L)
|  `- O2.2 DevOps Engineer (DOP-E)
|- O3 Engineering Web/API
|  |- O3.1 FullStack Lead (FS-L)
|  `- O3.2 FullStack Engineer (FS-E)
`- O4 Fonctions transverses (sans headcount dedie)
   |- O4.1 Qualite et tests
   |- O4.2 Securite et supply chain
   |- O4.3 UX/UI
   `- O4.4 Marketing et diffusion
```

## 4. Fiches de role

### 4.1 MGR - Manager programme
| Element | Definition |
|---|---|
| Mission | Piloter la trajectoire produit/projet, arbitrer les priorites, garantir la coherence PBS/WBS/OBS/PAQ. |
| Perimetre principal | W0, W1, gouvernance multi-repo, decision release go/no-go. |
| Droits de decision | Arbitrage final priorites, acceptation derrogations, go/no-go final. |
| Livrables responsables | Gouvernance, suivi KPI, validation docs management. |
| Interfaces cles | DOP-L, FS-L, equipe complete. |

### 4.2 DOP-L - DevOps Lead
| Element | Definition |
|---|---|
| Mission | Porter l'architecture CI/CD, la fiabilite release, la securite supply-chain et la coherence ACTIONS. |
| Perimetre principal | `instant-release_ACTIONS`, W2, contribution W6. |
| Droits de decision | Choix techniques DevOps, strategie pipeline, gates qualite/securite (avec validation MGR). |
| Livrables responsables | Workflows, scripts, controles qualite/securite, readiness technique. |
| Interfaces cles | MGR, DOP-E, FS-L, FS-E. |

### 4.3 DOP-E - DevOps Engineer
| Element | Definition |
|---|---|
| Mission | Implementer et maintenir les composants CI/CD, observabilite et outillage automation. |
| Perimetre principal | W2 execution, support W6, support integration APP/API. |
| Droits de decision | Decisions d'implementation dans le cadre technique valide par DOP-L. |
| Livrables responsables | Scripts, tests integration workflows/modules, maintenance pipelines. |
| Interfaces cles | DOP-L, FS-L, FS-E. |

### 4.4 FS-L - FullStack Lead
| Element | Definition |
|---|---|
| Mission | Piloter les choix techniques web/API, garantir contrats API et coherence UX/UI applicative. |
| Perimetre principal | `instant-release_API`, `instant-release_VITRINE`, contribution architecture `instant-release_APP`, W3/W5. |
| Droits de decision | Choix techniques API/Web, standards de dev web, validation contrats inter-repo cote applicatif. |
| Livrables responsables | Contrats API, architecture web, coherence technique surfaces. |
| Interfaces cles | MGR, FS-E, DOP-L, DOP-E. |

### 4.5 FS-E - FullStack Engineer
| Element | Definition |
|---|---|
| Mission | Implementer les fonctionnalites APP/VITRINE/API, realiser les tests applicatifs et stabiliser l'integration. |
| Perimetre principal | `instant-release_APP`, contribution API/VITRINE, W4 execution. |
| Droits de decision | Decisions d'implementation dans le cadre defini par FS-L. |
| Livrables responsables | Features front/app, tests associes, correction defects applicatifs. |
| Interfaces cles | FS-L, DOP-L, DOP-E. |

## 5. Ownership par repository
| Repository | Accountable (A) | Responsible (R) | Support principal | Backup technique |
|---|---|---|---|---|
| `instant-release_ACTIONS` | MGR | DOP-L | DOP-E | FS-L |
| `instant-release_API` | MGR | FS-L | FS-E | DOP-L |
| `instant-release_APP` | MGR | FS-E | FS-L | DOP-E |
| `instant-release_VITRINE` | MGR | FS-L | FS-E | MGR |

Regles:
1. Chaque ticket a un owner unique.
2. Chaque repository a un backup explicite.
3. Toute modification cross-repo reference un ticket parent de coordination.

## 6. Responsabilites des fonctions transverses (O4)
| Fonction transverse | A | R | C | I |
|---|---|---|---|---|
| Qualite et tests | MGR | DOP-L, FS-L | DOP-E, FS-E | equipe |
| Securite et supply chain | MGR | DOP-L | DOP-E, FS-L | equipe |
| UX/UI | MGR | FS-L | FS-E | DOP-L, DOP-E |
| Marketing et diffusion | MGR | FS-L | FS-E | DOP-L, DOP-E |

## 7. RACI par lot WBS (W0 -> W6)
| Lot WBS | MGR | DOP-L | DOP-E | FS-L | FS-E |
|---|---|---|---|---|---|
| W0 Pilotage programme multi-repo | A/R | C | I | C | I |
| W1 Exigences et gouvernance documentaire | A | C | I | R | C |
| W2 instant-release_ACTIONS | A | R | C | C | I |
| W3 instant-release_API | A | C | I | R | C |
| W4 instant-release_APP | A | C | I | R | C |
| W5 instant-release_VITRINE | A | I | I | R | C |
| W6 Integration transverse qualite/securite | A | R | C | C | C |

Lecture:
- A = Accountable (validation finale)
- R = Responsible (execution principale)
- C = Consulted
- I = Informed

## 8. RACI operationnel (flux Kanban)
| Activite | MGR | DOP-L | DOP-E | FS-L | FS-E |
|---|---|---|---|---|---|
| Priorisation portfolio | A/R | C | I | C | I |
| Qualification des issues | A | R | C | R | C |
| Implementation | I | R | R | R | R |
| Review technique croisee | C | R | C | R | C |
| Validation tests/gates | C | R | C | R | C |
| Decision release go/no-go | A/R | R | C | R | I |
| Gestion incidents critiques | A | R | C | R | C |
| Gestion derrogations | A/R | C | I | C | I |

## 9. Gouvernance et instances
| Instance | Participants | Frequence | Objectif | Sortie attendue |
|---|---|---|---|---|
| Revue Jour 3 (Kanban) | MGR, DOP-L, DOP-E, FS-L, FS-E | chaque cycle | prioriser, debloquer, decider | plan du cycle suivant + actions |
| Revue readiness multi-repo | MGR, DOP-L, FS-L (+ equipe) | avant release transverse | valider W6.4 | decision go/no-go |
| Revue risques/escalade | MGR + leads | hebdo ou a la demande | traiter blocages critiques | decision tracee + mitigation |
| Revue documentaire | MGR, FS-L, DOP-L | hebdo | coherence PBS/WBS/OBS/PAQ | docs mises a jour |

## 10. Regles d'interface et communication
1. Les regles de structure des issues et du workflow board sont maintenues dans `docs/KANBAN_DISCIPLINE.md`.
2. Les sujets cross-repo passent par un ticket parent de coordination.
3. Toute PR reference l'issue associee (`Closes #ID` ou `Refs #ID`).
4. Les decisions structurantes sont journalisees dans le backlog/documentation.
5. Les preuves qualite et criteres de fin sont gouvernes par `docs/PAQ.md`.

## 11. Escalade
| Niveau | Condition | Delai cible | Owner |
|---|---|---|---|
| N1 Technique | blocage implementation/review | < 1 jour ouvre | DOP-L ou FS-L |
| N2 Projet | blocage cross-repo, conflit priorite | < 1 cycle | MGR |
| N3 Critique | incident securite/release, risque livraison majeur | immediate | MGR (decision finale) |

## 12. Risques organisationnels et mesures
| Risque | Impact | Mesure de maitrise |
|---|---|---|
| SPOF sur un role cle | retard ou blocage | backup par repository + review croisee obligatoire |
| Surcharge MGR | ralentissement decisionnel | delegation operationnelle aux leads, escalade uniquement sur arbitres |
| Incoherence cross-repo | regressions integration | ticket parent + W6.2 scenarios cross-repo obligatoires |
| Derive documentaire | perte de tracabilite | revue documentaire hebdo + mapping PBS/WBS/issues |

## 13. Criteres de fermeture OBS
1. Tous les lots W0-W6 ont un A et un R clairs.
2. Les ownership repository sont valides par equipe.
3. Les regles d'escalade sont connues et appliquees.
4. Le RACI operationnel est coherent avec Kanban discipline.
5. OBS synchronise avec PBS/WBS/PAQ.
