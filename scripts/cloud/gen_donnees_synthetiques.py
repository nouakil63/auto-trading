"""Génère des données OHLCV synthétiques (marche aléatoire) pour valider la chaîne freqtrade.

AUCUNE signification de marché — uniquement pour tester que backtest/bot fonctionnent
dans un environnement où les API des exchanges sont bloquées.
"""
import numpy as np
import pandas as pd
from pathlib import Path

OUT = Path("user_data/data/binance")
OUT.mkdir(parents=True, exist_ok=True)

rng = np.random.default_rng(42)
start = pd.Timestamp("2023-01-01", tz="UTC")
end = pd.Timestamp("2026-08-05", tz="UTC")

PAIRS = {"BTC_USDT": 20000.0, "ETH_USDT": 1500.0}

for tf, freq in [("1h", "1h"), ("4h", "4h")]:
    dates = pd.date_range(start, end, freq=freq)
    n = len(dates)
    for name, p0 in PAIRS.items():
        # marche aléatoire log-normale + cycles marqués pour déclencher des signaux RSI
        t = np.arange(n)
        period = 24 * 14 if tf == "1h" else 6 * 14  # cycle ~2 semaines
        cycle = 0.10 * np.sin(2 * np.pi * t / period) + 0.05 * np.sin(2 * np.pi * t / (period * 3.7))
        rets = rng.normal(loc=0.0, scale=0.010 if tf == "1h" else 0.020, size=n)
        close = p0 * np.exp(np.cumsum(rets) * 0.15 + cycle)
        open_ = np.concatenate([[p0], close[:-1]])
        spread = np.abs(rng.normal(0, 0.004, size=n))
        high = np.maximum(open_, close) * (1 + spread)
        low = np.minimum(open_, close) * (1 - spread)
        vol = rng.uniform(100, 5000, size=n)
        df = pd.DataFrame(
            {"date": dates, "open": open_, "high": high, "low": low, "close": close, "volume": vol}
        )
        f = OUT / f"{name}-{tf}.feather"
        df.to_feather(f)
        print(f"{f} : {n} bougies, close final {close[-1]:.2f}")
