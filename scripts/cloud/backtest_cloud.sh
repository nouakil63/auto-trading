#!/usr/bin/env bash
# Validation de la chaîne freqtrade dans un environnement cloud SANS accès aux
# API des exchanges (bloquées par la politique réseau).
#
# ⚠️  Les données utilisées ici sont SYNTHÉTIQUES : le résultat du backtest n'a
#     AUCUNE signification de marché. Ce script prouve uniquement que
#     l'installation, la stratégie et le moteur de backtest fonctionnent.
#     Les vraies données et le vrai dry-run se font sur le Mac (voir README).
#
# Usage : ./scripts/cloud/backtest_cloud.sh [installer|donnees|backtest|webserver|tout]

set -euo pipefail
cd "$(dirname "$0")/../.."

VENV=.venv
PY="$VENV/bin/python"

installer() {
    echo "— Installation de freqtrade dans un venv Python (pas de Docker ici) —"
    [ -d "$VENV" ] || python3 -m venv "$VENV"
    "$VENV/bin/pip" install --quiet --upgrade pip
    "$VENV/bin/pip" install --quiet freqtrade
    "$VENV/bin/freqtrade" --version
    echo "✅ freqtrade installé."
}

donnees() {
    echo "— Génération de données OHLCV synthétiques (aucune valeur de marché) —"
    "$PY" scripts/cloud/gen_donnees_synthetiques.py
    echo "✅ Données dans user_data/data/binance/."
}

backtest() {
    echo "— Backtest SampleStrategy sur données SYNTHÉTIQUES (validation technique) —"
    "$PY" scripts/cloud/freqtrade_offline.py backtesting \
        --userdir user_data \
        --config user_data/config.json \
        --strategy SampleStrategy \
        --timeframe 1h \
        --timerange 20230101-
    echo "ℹ️  Résultat SANS signification de marché : données synthétiques."
}

webserver() {
    echo "— Serveur API freqtrade sur http://127.0.0.1:8080 (Ctrl+C pour arrêter) —"
    echo "  Identifiant : freqtrader — mot de passe : api_server.password de user_data/config.json"
    "$PY" scripts/cloud/freqtrade_offline.py webserver \
        --userdir user_data \
        --config user_data/config.json
}

tout() { installer; donnees; backtest; }

case "${1:-}" in
    installer|donnees|backtest|webserver|tout) "$1" ;;
    *)
        cat <<'EOF'
Usage : ./scripts/cloud/backtest_cloud.sh <commande>

  installer   Crée le venv Python et installe freqtrade (sans Docker)
  donnees     Génère des données synthétiques (AUCUNE valeur de marché)
  backtest    Backtest de validation technique sur ces données
  webserver   Démarre le serveur API freqtrade (port 8080, local)
  tout        installer + donnees + backtest

Le vrai parcours (vraies données, dry-run, FreqUI) reste celui du README, sur le Mac.
EOF
        ;;
esac
