#!/usr/bin/env bash
# Déroulé guidé de la phase 1 sur macOS — une étape à la fois.
# Usage : ./scripts/phase1.sh <commande>   (lancer sans argument pour l'aide)
#
# Tout tourne en DRY-RUN (argent fictif). Aucune clé d'API n'est utilisée.

set -euo pipefail
cd "$(dirname "$0")/.."

CONFIG=/freqtrade/user_data/config.json

aide() {
    cat <<'EOF'
Usage : ./scripts/phase1.sh <commande>

  verifier   Vérifie les prérequis (Docker, git) et télécharge l'image freqtrade
  donnees    Télécharge l'historique BTC/USDT et ETH/USDT (1h + 4h, depuis 2023)
  backtest   Rejoue la stratégie SampleStrategy sur l'historique (frais inclus)
  demarrer   Démarre le bot en dry-run + l'interface web FreqUI
  statut     Affiche l'état du bot et les derniers logs
  arreter    Arrête le bot

Ordre conseillé : verifier → donnees → backtest → demarrer.
Vérifie que chaque étape se passe bien avant de lancer la suivante.
EOF
}

verifier() {
    echo "— Vérification des prérequis —"
    command -v git >/dev/null || { echo "❌ git introuvable. Installe les outils Xcode : xcode-select --install"; exit 1; }
    echo "✅ git : $(git --version)"
    command -v docker >/dev/null || { echo "❌ Docker introuvable. Installe Docker Desktop : https://www.docker.com/products/docker-desktop/"; exit 1; }
    docker info >/dev/null 2>&1 || { echo "❌ Docker est installé mais ne tourne pas. Lance l'application Docker Desktop puis réessaie."; exit 1; }
    echo "✅ Docker : $(docker --version)"
    echo "— Téléchargement de l'image officielle freqtrade (stable) —"
    docker compose pull
    echo "✅ Prérequis OK. Étape suivante : ./scripts/phase1.sh donnees"
}

donnees() {
    echo "— Téléchargement de l'historique de prix (données publiques, aucune clé) —"
    docker compose run --rm freqtrade download-data \
        --config "$CONFIG" \
        --pairs BTC/USDT ETH/USDT \
        --timeframes 1h 4h \
        --timerange 20230101-
    echo "✅ Données dans user_data/data/binance/. Étape suivante : ./scripts/phase1.sh backtest"
}

backtest() {
    echo "— Backtest de SampleStrategy (1h, depuis 2023, frais inclus) —"
    docker compose run --rm freqtrade backtesting \
        --config "$CONFIG" \
        --strategy SampleStrategy \
        --timeframe 1h \
        --timerange 20230101-
    echo "ℹ️  Pour interpréter ce tableau : docs/strategie-et-backtest.md (§4)."
}

demarrer() {
    echo "— Démarrage du bot en DRY-RUN (argent fictif) —"
    docker compose up -d
    echo "✅ Bot démarré."
    echo "   Interface web : http://127.0.0.1:8080"
    echo "   Identifiant : freqtrader — mot de passe : champ api_server.password de user_data/config.json"
    echo "   Suivre les logs : ./scripts/phase1.sh statut   |   Arrêter : ./scripts/phase1.sh arreter"
}

statut() {
    docker compose ps
    echo "— 20 dernières lignes de log —"
    docker compose logs --tail 20 freqtrade
}

arreter() {
    docker compose down
    echo "✅ Bot arrêté. (Le portefeuille fictif est conservé dans user_data/tradesv3.dryrun.sqlite.)"
}

case "${1:-}" in
    verifier|donnees|backtest|demarrer|statut|arreter) "$1" ;;
    *) aide ;;
esac
