# Auto-trading — outil personnel de trading crypto automatisé

Outil de trading crypto automatisé **pour usage personnel uniquement**, construit sur
[freqtrade](https://www.freqtrade.io). Tout tourne en **dry-run** (argent fictif) :
aucune clé d'API privée n'est nécessaire, aucun argent réel n'est engagé.

> ⚠️ **Rappel honnête** : ce robot n'est pas une machine à imprimer de l'argent.
> Il exécute une stratégie, il n'en garantit pas la rentabilité. Son rôle est de
> **tester honnêtement** des stratégies en simulation. Tant qu'une stratégie n'a pas
> fait ses preuves en backtest **et** en simulation prolongée, on n'engage pas un euro.

---

## État du projet — Phase 1

| Étape | Statut |
|---|---|
| Structure du projet + `.gitignore` (aucun secret versionné) | ✅ Fait |
| Configuration dry-run (BTC/USDT, ETH/USDT, 1000 USDT fictifs) | ✅ Fait |
| Stratégie d'exemple officielle freqtrade (copiée du paquet officiel, pas d'internet) | ✅ Fait |
| Validation technique : config + stratégie + moteur de backtest | ✅ Vérifié (voir note*) |
| Téléchargement de vraies données de marché | ⬜ À faire **sur ton Mac** (étape 2) |
| Backtest sur données réelles | ⬜ À faire sur ton Mac (étape 3) |
| Bot en dry-run + interface web FreqUI | ⬜ À faire sur ton Mac (étape 4) |

\* La validation technique a été faite dans un environnement cloud où les API des
exchanges sont bloquées : le backtest y a tourné sur des **données synthétiques**,
uniquement pour prouver que la chaîne complète fonctionne. **Ce résultat n'a aucune
signification de marché.** Les vraies données seront téléchargées sur ton Mac.

---

## Structure du dépôt

```
auto-trading/
├── docker-compose.yml          # Lancement du bot en dry-run via Docker
├── user_data/
│   ├── config.json             # Config freqtrade : dry_run=true, AUCUNE clé d'exchange
│   ├── strategies/
│   │   └── SampleStrategy.py   # Stratégie d'exemple officielle de freqtrade
│   ├── data/                   # Données de marché téléchargées (non versionnées)
│   └── logs/                   # Logs du bot (non versionnés)
├── docs/
│   └── strategie-et-backtest.md  # La stratégie expliquée + comment lire un backtest
├── scripts/
│   └── phase1.sh               # Déroulé guidé des étapes ci-dessous (optionnel)
└── .gitignore                  # Exclut secrets, données, logs, bases SQLite
```

---

## Mise en route sur ton Mac

> 🧭 Chaque étape ci-dessous peut aussi se lancer via `./scripts/phase1.sh`
> (sans argument pour l'aide : `verifier` → `donnees` → `backtest` → `demarrer`).
> Les commandes complètes restent détaillées ici pour que tu voies toujours
> exactement ce qui s'exécute.

### Étape 0 — Prérequis

- **Docker Desktop pour Mac** : [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
  Vérifie qu'il tourne : `docker info` ne doit pas afficher d'erreur.
- **git** : fourni avec les outils Xcode (`xcode-select --install` si besoin).

```bash
git clone <url-de-ce-depot> auto-trading
cd auto-trading
docker compose pull   # télécharge l'image officielle freqtrade (stable)
```

### Étape 1 — (déjà fait) Configuration

`user_data/config.json` est déjà prêt :

- `"dry_run": true` → **argent fictif**, le bot ne peut rien acheter de réel.
- `"dry_run_wallet": 1000` → portefeuille simulé de 1 000 USDT.
- `"stake_amount": 100` + `"max_open_trades": 3` → au plus 3 positions de 100 USDT
  fictifs chacune (on ne mise jamais tout d'un coup, même en simulation).
- Exchange `binance` **sans aucune clé** : en dry-run, freqtrade ne lit que les prix
  publics. Le choix de l'exchange n'est pas définitif, on le revalidera ensemble
  avant toute phase réelle.
- Paires : `BTC/USDT` et `ETH/USDT` (les deux plus liquides, parfaites pour apprendre).

### Étape 2 — Télécharger l'historique des prix

3 ans de bougies 1h et 4h pour nos deux paires (~ quelques minutes, données publiques
gratuites) :

```bash
docker compose run --rm freqtrade download-data \
  --config /freqtrade/user_data/config.json \
  --pairs BTC/USDT ETH/USDT \
  --timeframes 1h 4h \
  --timerange 20230101-
```

Les données arrivent dans `user_data/data/binance/` (exclues de git : volumineuses et
re-téléchargeables à volonté).

### Étape 3 — Lancer un backtest

Un **backtest** = rejouer la stratégie sur le passé pour voir ce qu'elle *aurait*
donné, frais de transaction inclus.

```bash
docker compose run --rm freqtrade backtesting \
  --config /freqtrade/user_data/config.json \
  --strategy SampleStrategy \
  --timeframe 1h \
  --timerange 20230101-
```

👉 Pour comprendre la stratégie et lire le tableau de résultats (profit, drawdown,
nombre de trades…), lis [`docs/strategie-et-backtest.md`](docs/strategie-et-backtest.md).

> Un bon backtest ne garantit rien ; un mauvais backtest, lui, est un signal d'arrêt
> fiable. On s'en sert surtout pour **éliminer** les mauvaises stratégies.

### Étape 4 — Lancer le bot en dry-run + interface web

```bash
docker compose up -d        # démarre le bot en arrière-plan
docker compose logs -f      # suivre les logs (Ctrl+C pour quitter l'affichage)
```

Interface web **FreqUI** : ouvre [http://127.0.0.1:8080](http://127.0.0.1:8080)

- Identifiant : `freqtrader` — mot de passe : voir `api_server.password` dans
  `user_data/config.json`.
- Ces identifiants ne protègent que l'interface web **locale** (le port n'est ouvert
  que sur 127.0.0.1, rien n'est accessible depuis l'extérieur). Ce ne sont **pas**
  des clés d'exchange. Tu peux les changer dans `config.json` à tout moment.

Tu y verras le portefeuille fictif, les trades simulés, les graphiques. Laisse tourner
quelques jours/semaines et observe.

```bash
docker compose down         # arrêter le bot
```

---

## Règles de sécurité (non négociables)

1. **Dry-run d'abord, toujours.** Aucun passage en réel sans validation explicite
   après des semaines de simulation concluante.
2. **Aucune clé privée en dry-run.** Le jour du réel (pas maintenant) : clés en
   permissions *lecture + trading* uniquement, **jamais** la permission de retrait.
3. **Aucun secret versionné** : le `.gitignore` exclut `.env`, `config-live*.json`,
   `config-private*.json`, `config-secret*.json` — toute future config réelle devra
   utiliser un de ces noms.
4. Avant tout argent réel : plafond de perte journalière, taille de position limitée,
   kill switch — mis en place **et testés** d'abord (phase 4).
5. Jamais de stratégie téléchargée d'internet sans lecture complète du code ensemble.

---

## Prochaines phases (pour mémoire, pas maintenant)

- **Phase 2** : tester des stratégies mécaniques connues, backtests multi-périodes,
  hyperopt avec prudence (risque de surajustement).
- **Phase 3** : dry-run prolongé, comparaison simulation vs backtest.
- **Phase 4** : garde-fous réels (limites de perte, kill switch) + tests.
- **Phase 5** : éventuel petit capital réel, décision manuelle et consciente.
