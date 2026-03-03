# HARDWARE REQUIREMENTS - InstantRelease

## 1. Objet
Ce document definit les besoins materiels minimaux et cibles du projet InstantRelease
pour les environnements `Local`, `Staging` et `Production`, avec modeles de couts
maintenables (placeholders explicites quand la valeur n'est pas encore fixee).

## 2. References et perimetre
References:
1. `docs/INFRA_SERVER_SYSTEM.md`
2. `docs/PAQ.md`
3. `docs/OBS.md`

Perimetre couvert:
1. Postes developpeurs (local).
2. Serveur(s) d'hebergement VPS (staging/prod).
3. Stockage DB/MinIO/backups.
4. Capacite minimale observabilite.

Hors perimetre:
1. Licences SaaS non materielles (outils collaboratifs).
2. Couts RH.

## 3. Hypotheses operationnelles
1. Hebergement retenu: VPS self-hosted.
2. API non publique internet (acces prive).
3. Push/merge: CI uniquement. Deploiements: manuels.
4. 1 service PostgreSQL avec 3 bases logiques (`dev/staging/prod`).
5. MinIO utilise comme object storage compatible S3.

## 4. Besoins materiels par environnement
| ID | Environnement | Composant | Specification minimale | Specification cible (recommandee) | Pourquoi | Quantite | Cout unitaire (EUR/mois) | Cout mensuel (EUR) |
|---|---|---|---|---|---|---|---|---|
| HW-LOC-01 | Local | Poste Dev FullStack/DevOps | CPU 4 vCPU, RAM 16 Go, SSD libre 50 Go | CPU 8 vCPU, RAM 32 Go, SSD libre 100 Go | Build local, Docker Compose, tests et debug | `{{nb_postes_dev}}` | `{{cout_poste_dev_mensuel}}` | `{{cout_total_postes_dev}}` |
| HW-LOC-02 | Local | Connectivite internet | 20 Mbps stable | 100 Mbps stable | Pull/push images, dependances, CI feedback rapide | `{{nb_postes_dev}}` | `{{cout_internet_par_poste}}` | `{{cout_total_internet}}` |
| HW-SRV-01 | Staging+Prod | VPS principal compute | `{{vps_main_min_vcpu}}` vCPU, `{{vps_main_min_ram}}` Go RAM | `{{vps_main_target_vcpu}}` vCPU, `{{vps_main_target_ram}}` Go RAM | Heberger VITRINE, APP, API, reverse proxy et services communs | `{{nb_vps_main}}` | `{{cout_vps_main_unitaire}}` | `{{cout_vps_main_total}}` |
| HW-SRV-02 | Staging+Prod | Stockage systeme VPS | `{{vps_main_min_storage_gb}}` Go SSD | `{{vps_main_target_storage_gb}}` Go SSD | Images conteneurs, logs, volumes applicatifs | `{{nb_vps_main}}` | `{{cout_storage_main_unitaire}}` | `{{cout_storage_main_total}}` |
| HW-DB-01 | Staging+Prod | Service PostgreSQL (host/instance) | `{{db_min_vcpu}}` vCPU, `{{db_min_ram}}` Go, `{{db_min_storage_gb}}` Go | `{{db_target_vcpu}}` vCPU, `{{db_target_ram}}` Go, `{{db_target_storage_gb}}` Go | Service DB unique + 3 bases logiques | `{{nb_db_instances}}` | `{{cout_db_unitaire}}` | `{{cout_db_total}}` |
| HW-DB-02 | Staging+Prod | Stockage backup DB secondaire | `{{backup_min_storage_gb}}` Go | `{{backup_target_storage_gb}}` Go | Duplication backup quotidienne + retention long terme | `{{nb_backup_targets}}` | `{{cout_backup_target_unitaire}}` | `{{cout_backup_total}}` |
| HW-OBJ-01 | Staging+Prod | MinIO (object storage) | `{{minio_min_storage_gb}}` Go | `{{minio_target_storage_gb}}` Go | Uploads + exports + retention/purge | `{{nb_minio_nodes}}` | `{{cout_minio_unitaire}}` | `{{cout_minio_total}}` |
| HW-OBS-01 | Staging+Prod | Observabilite (Prometheus/Grafana/Loki/Sentry relay) | `{{obs_min_vcpu}}` vCPU, `{{obs_min_ram}}` Go, `{{obs_min_storage_gb}}` Go | `{{obs_target_vcpu}}` vCPU, `{{obs_target_ram}}` Go, `{{obs_target_storage_gb}}` Go | Monitoring, logs centralises, alerting | `{{nb_obs_nodes}}` | `{{cout_obs_unitaire}}` | `{{cout_obs_total}}` |
| HW-NET-01 | Staging+Prod | DNS/TLS/egress reseau | Niveau de service de base | Niveau de service avec marge trafic | Exposition vitrine/app + API privee interne | `{{nb_env_actifs}}` | `{{cout_reseau_unitaire}}` | `{{cout_reseau_total}}` |

## 5. Materiel de securite et continuite
| ID | Besoin | Exigence minimale | Exigence cible | Cout placeholder |
|---|---|---|---|---|
| HW-SEC-01 | Stockage secrets | Vault operable + backup config | Vault HA/self-recovery | `{{cout_vault_mensuel}}` |
| HW-SEC-02 | Retention backups | Support retention daily/weekly/monthly | Retention conforme + verification restore mensuelle | `{{cout_retention_mensuel}}` |
| HW-DR-01 | Reprise incident | 1 cible de restauration testee mensuellement | 2 cibles (locale + secondaire) | `{{cout_dr_mensuel}}` |

## 6. Capacite et seuils de passage a l'echelle
| Metrique | Seuil d'alerte | Action |
|---|---|---|
| CPU moyenne VPS | `> {{cpu_alert_threshold}}%` sur 7 jours | augmenter vCPU ou separer charge |
| RAM moyenne VPS | `> {{ram_alert_threshold}}%` sur 7 jours | augmenter RAM ou isoler services |
| Stockage DB | `> {{db_storage_alert_threshold}}%` | etendre volume + revue retention |
| Stockage MinIO | `> {{minio_storage_alert_threshold}}%` | appliquer purge/archivage + extension volume |
| Temps restauration DB | `> {{rto_target_hours}}h` | revoir runbook et ressources I/O |

## 7. Budget previsionnel (placeholders)
| Poste budget | Cout mensuel (EUR) |
|---|---|
| Postes developpeurs | `{{cout_total_postes_dev}}` |
| Connectivite locale | `{{cout_total_internet}}` |
| VPS compute + storage | `{{cout_vps_main_total}} + {{cout_storage_main_total}}` |
| Service DB + backup | `{{cout_db_total}} + {{cout_backup_total}}` |
| MinIO storage | `{{cout_minio_total}}` |
| Observabilite | `{{cout_obs_total}}` |
| Reseau/DNS/TLS | `{{cout_reseau_total}}` |
| Securite/continuite | `{{cout_vault_mensuel}} + {{cout_retention_mensuel}} + {{cout_dr_mensuel}}` |
| Total mensuel estime | `{{cout_total_mensuel_estime}}` |
| Total annuel estime | `{{cout_total_annuel_estime}}` |

Regles calcul:
1. `cout_total_mensuel_estime = somme de tous les postes`.
2. `cout_total_annuel_estime = cout_total_mensuel_estime * 12`.
3. Garder une marge de capacite budgetaire: `{{budget_margin_percent}}%`.

## 8. Validation et maintenance
1. Mise a jour obligatoire a chaque changement d'architecture infra.
2. Revue budget/capacite tous les `{{hardware_review_period}}`.
3. Tout changement majeur doit etre reporte dans `INFRA` + `PAQ`.

## 9. Version
- Version: `HWR-v1.0`
- Statut: `Proposition operationnelle`
- Date d'effet: `2026-03-03`
