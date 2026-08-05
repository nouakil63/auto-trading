"""Lanceur freqtrade hors-ligne : injecte des marchés statiques (BTC/USDT, ETH/USDT)
au lieu de les charger depuis l'API Binance (bloquée par la politique réseau).

Usage : offline_freqtrade.py <arguments freqtrade habituels>
"""
import sys


def _market(base: str) -> dict:
    symbol = f"{base}/USDT"
    return {
        "id": f"{base}USDT",
        "symbol": symbol,
        "base": base,
        "quote": "USDT",
        "baseId": base,
        "quoteId": "USDT",
        "active": True,
        "type": "spot",
        "spot": True,
        "margin": False,
        "swap": False,
        "future": False,
        "option": False,
        "contract": False,
        "settle": None,
        "settleId": None,
        "contractSize": None,
        "linear": None,
        "inverse": None,
        "taker": 0.001,
        "maker": 0.001,
        "percentage": True,
        "tierBased": False,
        "feeSide": "get",
        "expiry": None,
        "expiryDatetime": None,
        "strike": None,
        "optionType": None,
        # binance est en mode TICK_SIZE : ces valeurs sont des pas, pas des décimales
        "precision": {"amount": 1e-05, "price": 0.01, "base": 1e-08, "quote": 1e-08},
        "limits": {
            "leverage": {"min": None, "max": None},
            "amount": {"min": 1e-05, "max": 9000.0},
            "price": {"min": 0.01, "max": 1000000.0},
            "cost": {"min": 5.0, "max": 9000000.0},
            "market": {"min": 0.0, "max": 100.0},
        },
        "created": None,
        "info": {},
    }


MARKETS = {"BTC/USDT": _market("BTC"), "ETH/USDT": _market("ETH")}

CURRENCIES = {
    c: {"id": c, "code": c, "precision": 8, "active": True, "fee": None,
        "limits": {"amount": {"min": None, "max": None},
                   "withdraw": {"min": None, "max": None}}, "info": {}}
    for c in ("BTC", "ETH", "USDT")
}


def _patch():
    from freqtrade.exchange import exchange as ft_exchange
    from freqtrade.util import dt_ts

    def reload_markets(self, force=False, *, load_leverage_tiers=True):
        if self._markets:
            return None
        for api in filter(None, (self._api, self._api_async)):
            api.set_markets(MARKETS, CURRENCIES)
        self._markets = self._api.markets
        self._last_markets_refresh = dt_ts()
        return None

    ft_exchange.Exchange.reload_markets = reload_markets
    # validate_pricing interroge un ticker en ligne -> neutralisé (dry-run hors-ligne)
    ft_exchange.Exchange.validate_pricing = lambda self, pricing: None


if __name__ == "__main__":
    _patch()
    from freqtrade.main import main

    sys.argv[0] = "freqtrade"
    main(sys.argv[1:])
