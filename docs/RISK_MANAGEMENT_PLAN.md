# RISK MANAGEMENT PLAN - InstantRelease

## 1. Objet
Ce document definit la politique officielle de maitrise des risques du projet InstantRelease.
Il couvre l'identification, l'evaluation, le traitement, le suivi et l'escalade des risques sur l'ensemble du perimetre multi-repo.

Objectif principal:
1. reduire la probabilite d'echec delivery, qualite, securite et exploitation,
2. rendre les decisions de mitigation explicites et tracables,
3. standardiser la reponse aux incidents et aux risques emergents.

## 2. Perimetre
Repositories couverts:
1. `instant-release_ACTIONS`
2. `instant-release_API`
3. `instant-release_APP`
4. `instant-release_VITRINE`

Environnements couverts:
1. local
2. staging
3. production

Domaines de risques couverts:
1. produit et exigences
2. planning et delivery
3. organisation et capacite equipe
4. qualite, tests et dette technique
5. CI/CD, release et supply chain
6. infrastructure, securite et donnees
7. exploitation, observabilite et continuité
8. conformite et contraintes legales
9. dependances externes (GitHub, registry, VPS, etc.)
10. documentation et gouvernance

## 3. References et precedence
Documents de reference:
1. `docs/PAQ.md`
2. `docs/KANBAN_DISCIPLINE.md`
3. `docs/OBS.md`
4. `docs/INFRA_SERVER_SYSTEM.md`
5. `docs/SFD_REQUIREMENTS.md`
6. `docs/TRACEABILITY_MATRIX.md`
7. `docs/ROADMAP.md`

Regles de precedence:
1. roles, responsabilites, escalade: `docs/OBS.md` prevaut.
2. workflow tickets, classes de service, WIP, SLA flux: `docs/KANBAN_DISCIPLINE.md` prevaut.
3. regles qualite/tests/gates/DoR/DoD: `docs/PAQ.md` prevaut.
4. ce document prevaut pour la methode de gestion de risque et le registre des risques.

## 4. Principes directeurs
1. Transparence: aucun risque critique ne reste implicite.
2. Prevention avant correction: traiter les causes racines le plus tot possible.
3. Ownership unique: chaque risque a un owner nominal.
4. Evidence-based: decision basee sur KRI/KPI et faits observables.
5. Proportionnalite: effort de mitigation ajuste au niveau de risque.
6. Amelioration continue: revision du dispositif tous les cycles.

## 5. Roles et responsabilites (RACI risque)
| Activite | Manager | DevOps | FullStack |
|---|---|---|---|
| Validation methode et seuils | A/R | C | C |
| Qualification d'un risque | A | R | R |
| Mise en place mitigation | C | R | R |
| Suivi KRI/KPI risque | A/R | C | C |
| Decision go/no-go en cas de risque ouvert | A/R | R | C |
| Escalade externe (incident majeur) | A/R | C | C |

Notes:
1. `A` = accountable, `R` = responsible, `C` = consulted.
2. le detail organisationnel reste dans `docs/OBS.md`.

## 6. Methode de gestion de risque
Cycle de gestion:
1. Identifier le risque (ticket `type/risk`).
2. Qualifier (cause, trigger, impact, owner, dependances).
3. Evaluer (probabilite, impact, score).
4. Decider la strategie (eviter, reduire, transferer, accepter).
5. Planifier actions preventives + contingence.
6. Suivre KRIs et statut a chaque cycle.
7. Cloturer avec evidence ou requalifier.

## 7. Echelle d'evaluation
### 7.1 Probabilite (P)
| Score | Definition |
|---|---|
| 1 | Rare (peu probable sur 6 mois) |
| 2 | Faible |
| 3 | Possible |
| 4 | Probable |
| 5 | Quasi certain |

### 7.2 Impact (I)
Impact global = impact max observe parmi delivery/qualite/securite/conformite/ops.

| Score | Definition |
|---|---|
| 1 | Mineur, recuperable sans impact planning |
| 2 | Limite, impact local |
| 3 | Significatif, impact lot/cycle |
| 4 | Majeur, impact release ou service |
| 5 | Critique, impact business/securite/conformite |

### 7.3 Score
Formule:
1. `Score = P x I` (1..25)

Classes:
1. `Low`: 1-5
2. `Moderate`: 6-10
3. `High`: 11-15
4. `Critical`: 16-25

## 8. Seuils de tolerance et regles de decision
1. Aucun risque `Critical` non traite n'est accepte pour une release production.
2. Risque `High` accepte seulement avec plan de contingence valide + date de remediation.
3. Risque `Moderate` monitorable si KRI sous seuil d'alerte.
4. Risque `Low` suivi passif, revue periodique.

Regles de blocage:
1. securite `critical` ouverte: blocage release (aligne PAQ).
2. absence de rollback teste pour changement critique: blocage release.
3. absence d'evidence package complete: blocage passage `Ready Release -> Done`.

## 9. Taxonomie officielle des risques
Codes categories:
1. `REQ` exigences/produit
2. `PLN` planning/capacite
3. `ORG` organisation/knowledge
4. `QLT` qualite/tests
5. `REL` release/CD
6. `SCM` supply chain logicielle
7. `INF` infrastructure/systeme
8. `SEC` securite
9. `DAT` donnees/backup/DR
10. `OPS` observabilite/exploitation
11. `CMP` conformite/legal
12. `DOC` documentation/gouvernance
13. `EXT` dependances externes

## 10. Registre de risques initial (baseline v1)
Statut:
1. `Open`, `Mitigating`, `Monitoring`, `Accepted`, `Closed`.

| Risk ID | Cat | Risque | P | I | Score | Classe | Owner | Preventif | Contingence | Trigger principal | Statut |
|---|---|---|---:|---:|---:|---|---|---|---|---|---|
| R-REQ-01 | REQ | Requirements incomplets avant implementation | 3 | 4 | 12 | High | Manager | DoR strict + SFD obligatoire | geler scope lot + ticket clarification | ticket sans acceptance testable | Open |
| R-REQ-02 | REQ | Derive fonctionnelle entre repos | 3 | 4 | 12 | High | FullStack | parent issues + traceability matrix | rollback feature partielle | ecart API/APP en review | Open |
| R-PLN-01 | PLN | Surcharge WIP et baisse throughput | 4 | 3 | 12 | High | Manager | limites WIP appliquees | stop pull nouveau travail | depassement WIP 2 cycles | Open |
| R-PLN-02 | PLN | Glissement planning cross-repo | 3 | 4 | 12 | High | Manager | checkpoint dependances Jour 3 | replanification cycle + descoping | parent issue bloquee > 1 cycle | Open |
| R-ORG-01 | ORG | Bus factor eleve sur ACTIONS | 3 | 4 | 12 | High | DevOps | review croisee + runbooks | freeze release scope ACTIONS | indisponibilite owner principal | Open |
| R-ORG-02 | ORG | Onboarding lent nouveaux membres | 2 | 3 | 6 | Moderate | Manager | kit onboarding + templates | binomage temporaire | tickets reouverts par incomprehension | Open |
| R-QLT-01 | QLT | Couverture reelle insuffisante malgre objectif 100% | 3 | 4 | 12 | High | DevOps | gates coverage + revue derogations | blocage merge/release | derogations recurrentes | Open |
| R-QLT-02 | QLT | Tests e2e controllers manquants | 3 | 4 | 12 | High | FullStack | mapping changement->tests PAQ | revert endpoint casse | endpoint modifie sans e2e | Open |
| R-QLT-03 | QLT | Faux positifs CI ralentissant flux | 3 | 3 | 9 | Moderate | DevOps | stabilisation pipelines | relance controlee + quarantine test | failure rate CI > seuil | Open |
| R-REL-01 | REL | Erreur humaine en deploiement manuel | 3 | 5 | 15 | High | DevOps | checklist go/no-go + runbook | rollback immediat | ecart entre procedure et execution | Open |
| R-REL-02 | REL | Incoherence versions inter-repo | 3 | 4 | 12 | High | Manager | fenetre release + evidence cross-repo | gel release secondaire | mismatch contrat version | Open |
| R-SCM-01 | SCM | Compromission dependance tierce | 2 | 5 | 10 | Moderate | DevOps | scan deps + pinning + review updates | blocage release + patch | alerte vuln crit dependance | Open |
| R-SCM-02 | SCM | Absence de preuve provenance exploitable | 2 | 4 | 8 | Moderate | DevOps | evidence package standard | release conditionnelle interne | package incomplet | Open |
| R-INF-01 | INF | Saturation ressources VPS | 3 | 4 | 12 | High | DevOps | monitoring capacite + quotas | scale vertical + purge | CPU/RAM soutenue > seuil | Open |
| R-INF-02 | INF | Point unique de defaillance infra | 3 | 5 | 15 | High | DevOps | durcissement + runbook reprise | mode degrade + restauration | indisponibilite noeud principal | Open |
| R-SEC-01 | SEC | Secret leakage (repo/CI/logs) | 2 | 5 | 10 | Moderate | DevOps | Vault/policies + scan secrets | rotation d'urgence | detection secret expose | Open |
| R-SEC-02 | SEC | Vuln critical non corrigee | 2 | 5 | 10 | Moderate | DevOps | gate securite bloquant | stop release + hotfix | report critical ouvert | Open |
| R-DAT-01 | DAT | Backup DB inutilisable a la restauration | 2 | 5 | 10 | Moderate | DevOps | test restore mensuel | procedure recovery prioritaire | echec test restore | Open |
| R-DAT-02 | DAT | Perte de donnees > RPO cible | 2 | 5 | 10 | Moderate | DevOps | cron backup + duplication + checksum | restauration dernier backup valide | echec backup quotidien | Open |
| R-OPS-01 | OPS | Observabilite insuffisante (MTTR eleve) | 3 | 4 | 12 | High | DevOps | dashboards + alerting Sentry/Loki | cellule incident dediee | incident sans trace root cause | Open |
| R-OPS-02 | OPS | Alert fatigue / alertes non actionnables | 3 | 3 | 9 | Moderate | DevOps | tuning seuils + routing | priorisation manuelle incidents | hausse alertes sans action | Open |
| R-CMP-01 | CMP | Non conformite retention donnees | 2 | 4 | 8 | Moderate | Manager | policy retention explicite | purge corrective + audit | ecart detecte en revue | Open |
| R-CMP-02 | CMP | Preuves d'audit incompletes | 3 | 4 | 12 | High | Manager | package evidence obligatoire | reconstitution evidence pre-release | ticket Done sans preuves | Open |
| R-DOC-01 | DOC | Divergence entre docs sources | 3 | 3 | 9 | Moderate | Manager | source unique + revue mensuelle | gel merge doc conflictuelle | contradiction detectee review | Open |
| R-DOC-02 | DOC | Evolution process non documentee | 3 | 3 | 9 | Moderate | Manager | template RFC/decision | corrective doc cycle suivant | ecart process terrain/doc | Open |
| R-EXT-01 | EXT | Incident GitHub (API/Actions/Project) | 3 | 4 | 12 | High | DevOps | fallback procedure manuelle | plan B hors automation | indispo GitHub status | Open |
| R-EXT-02 | EXT | Indisponibilite registry packages | 2 | 4 | 8 | Moderate | DevOps | cache dependances + mirrors legers | freeze release dependante | echec pulls/publish packages | Open |

## 11. KRIs (Key Risk Indicators) et seuils
| KRI | Definition | Seuil alerte | Seuil critique | Action |
|---|---|---|---|---|
| WIP Aging | age des items `In Progress` | > 1 cycle | > 2 cycles | escalade Jour 3 + replanif |
| Blocked Count | nb items `Blocked` | > 3 | > 5 | task-force debloquage |
| CI Failure Rate | % runs CI en echec | > 15% | > 25% | stabilisation pipeline immediate |
| Coverage Derogations | nb derogations ouvertes | > 0 fin cycle | > 2 | blocage release scope impacte |
| Critical Vulns Open | nb critical ouvertes | >= 1 | >= 1 | blocage release immediat |
| Evidence Completeness | % releases avec preuves completes | < 100% | < 95% | no-go release suivante |
| Backup Success | % backups quotidiens reussis | < 100% sur 7j | < 95% sur 7j | escalade infra |
| Restore Test Success | test restore mensuel | echec unique | 2 echecs consecutifs | plan remediation DR |

## 12. Rituels de revue risque
1. Daily async: signalement des nouveaux risques/blocages.
2. Revue Jour 3:
   - top risques ouverts,
   - evolution KRIs,
   - decisions mitigation/no-go.
3. Revue mensuelle:
   - recalibrage score P/I,
   - fermeture/requalification risques,
   - verification coherence documentaire.

Artefacts obligatoires:
1. compte-rendu de revue risque par cycle,
2. top 5 risques actifs,
3. plan d'action priorise.

## 13. Processus d'escalade
Niveaux:
1. `N1` equipe execution (resolution locale).
2. `N2` manager + leads (arbitrage scope/priorite).
3. `N3` decision exceptionnelle (go/no-go, derogation majeure).

Delais cibles:
1. risque `Critical`: traitement initial < 4h ouvrees.
2. risque `High`: plan mitigation valide < 24h ouvrees.
3. risque `Moderate`: planifie dans le cycle.

## 14. Plan de contingence et reprise
Contingences minimales:
1. rollback applicatif par repo (runbook obligatoire).
2. rollback configuration et secrets.
3. procedure fallback en cas d'indisponibilite GitHub.
4. procedure de restoration DB selon RPO/RTO cibles.
5. communication incident interne (canal `EMAIL`).

Checklists d'activation:
1. qualifier severite (`S1/S2/S3`),
2. nommer Incident Owner,
3. figer changements non urgents,
4. lancer plan de reprise adapte,
5. publier postmortem et actions correctives.

## 15. Cartographie des risques par repository
| Repo | Risques dominants |
|---|---|
| `instant-release_ACTIONS` | SCM, REL, QLT, EXT |
| `instant-release_API` | REQ, QLT, SEC, DAT |
| `instant-release_APP` | REQ, QLT, REL, OPS |
| `instant-release_VITRINE` | QLT, REL, OPS, CMP |

## 16. Exigences de ticket `type/risk`
Champs obligatoires:
1. `Risk ID`
2. `Categorie`
3. `Statement` (cause -> evenement -> impact)
4. `Probabilite` (1..5)
5. `Impact` (1..5)
6. `Score` et classe
7. `Owner`
8. `Mitigation plan`
9. `Contingence`
10. `KRI associe`
11. `Date de revue`

Template minimal:
```md
Risk ID: R-XXX-##
Categorie: {{REQ|PLN|ORG|...}}
Statement: Si {{cause}}, alors {{evenement}}, ce qui entraine {{impact}}.
Probabilite: {{1..5}}
Impact: {{1..5}}
Score: {{P x I}}
Owner: {{role/personne}}
Mitigation: {{actions preventives}}
Contingence: {{plan B}}
KRI: {{indicateur + seuil}}
Review Date: {{YYYY-MM-DD}}
```

## 17. Critere de cloture d'un risque
Un risque passe `Closed` seulement si:
1. le trigger n'est plus actif,
2. les actions de mitigation sont executees,
3. la preuve objective est jointe (KRI revenu sous seuil),
4. la validation manager est explicite.

Si non:
1. basculer en `Monitoring` ou `Accepted` avec justification datee.

## 18. Plan d'implementation (v1)
Cycle `{{CYCLE_01}}`:
1. creer labels/tickets `type/risk` pour le top 10.
2. nommer owner par risque High/Critical.
3. activer dashboard KRI minimum.

Cycle `{{CYCLE_02}}`:
1. tester scenario rollback et restore.
2. valider checklists incident et go/no-go.
3. reduire au moins 2 risques High.

Cycle `{{CYCLE_03}}`:
1. audit interne du dispositif risque.
2. recalibrer scoring et seuils KRI.
3. publier rapport de maturite.

## 19. Parametres calibres (baseline actuelle)
1. `incident_channel`: `EMAIL`.
2. `astreinte_model`: `Aucune astreinte formelle (projet de cours)`.
3. `legal_jurisdiction`: `France / Union Europeenne`.
4. `external_sla_targets`: `Aucun engagement contractuel externe a ce stade`.

## 20. Version
- Version: `RMP-v1.0`
- Statut: `Propose - pret validation equipe`
- Date d'effet cible: `2026-03-04`
- Prochaine revue cible: `{{date_revue_risque_+14j}}`
