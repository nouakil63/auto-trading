# Trading projects built on Jev (TypeSafe) and Laya (open source): inventory, how they work, and evidence of an edge

Research date: 2026-09-26. Jev launched 2026-09-15, so every project below is 1 to 11 days old. Method: I cloned the GitHub repos and read their READMEs, code and commit history at the SHAs listed. dev.to, learnwithmeai.com, jevlist.ai, mindstudio.ai, traderank.ai, madewithjev.com and youtube.com were blocked by the egress proxy, so for those I only have search-engine snippets, and I flag them as such.

## 1. jarrodwatts/jev-trader: how it works, and whether it shows any results

### Takeaway
jev-trader is a showcase demo built for one tweet. Its own spec says "the model is not trying to be profitable" and lists "no backtests" as a non-goal. It publishes no results. The public deployment runs the mock heuristic in dry-run, not Jev. The technical plumbing is careful (a 300 ms loop on Monad/Kuru). As evidence of trading edge it has nothing to offer.

### Cited findings
**Identity and licence**
- The repo describes itself as "One decision every Monad block. A TypeSafe Jev model watches the Kuru MON-USDC order book and answers buy or sell every ~300 ms. Every block posts a real post-only limit order on that side, one tick inside the touch, replacing the last one." — [README @ b587759](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/README.md)
- MIT licence, "Copyright (c) 2026 Jarrod Watts". — [LICENSE](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/LICENSE)
- All 12 commits are dated 2026-09-16. The last one (b587759, "Post-only limit orders every block: earn the spread instead of paying it") is co-authored by a Claude model. It removed the earlier hysteresis and the "decide every N blocks" logic. — [commit b587759](https://github.com/jarrodwatts/jev-trader/commit/b587759e459ea049590102e54a0b07800864cdc3)
- On 2026-09-20 the repo had about 1.3k stars and was "The template most projects below derive from". — [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)

**Purpose (the project's own words)**
- CLAUDE.md: "The demo exists to support this tweet. Every design or strategy change must keep all four claims true: > I built a trading bot with Jev! … Jev decides if it should "buy" or "sell" … executes real trades … It uses Monad to place the orders on Kuru's on-chain order book in every 300ms block." The non-negotiables include "Never decide every N blocks." — [CLAUDE.md](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/CLAUDE.md)
- SPEC.md gives the primary message as "This AI makes a real trade decision every 300 ms on Monad." The secondary punchline is "The AI costs less than the gas." (Jev inference for an hour ≈ $0.20; gas for the same hour ≈ $2–5.) — [SPEC.md](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/SPEC.md)
- The SPEC footer disclaimer is: "experimental demo, tiny bankroll, not financial advice, the model is not trying to be profitable." Its non-goals include "No historical analytics, no backtests, no strategy explanation." The success criterion is that a viewer "understands within three seconds that an AI is trading on a blockchain every fraction of a second … Then they share it." — [SPEC.md](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/SPEC.md)

**The question sent to Jev**
- There is one Choice question with two options, buy or sell. The question text is "Will MON be higher or lower than the current mid after `horizonBlocks` more blocks?" The goal text is "Trade MON-USDC on Kuru. Blocks are ~300ms; `horizonBlocks` (~30 s) is the horizon…". The criteria are "buy: mid more likely to be higher after `horizonBlocks` blocks, by more than the spread" and the mirror for sell. — [src/model.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/model.ts)
- There is a prompt/execution mismatch. The question's `timing` field still says "The order executes as an immediate-or-cancel market order in the next block", but execution now uses post-only limit orders. The AppitStudio catalog review also flags this ("This policy mismatch matters when interpreting decisions"). — [src/model.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/model.ts); [AppitStudio/awesome-jev review](https://github.com/AppitStudio/awesome-jev/blob/main/community/projects/tools/jev-trader.md)
- The question tells Jev which inputs to weight: "Taker flow is the strongest signal: `trades.cvdMon` … `depth` and `book` show resting liquidity … `returnsBps` and `recentMids` show the path over the horizon." — [src/model.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/model.ts)

**Inputs (the `TradeState` object)**
- The state contains:
  - mid and spreadBps;
  - bookImbalance within 1% of mid;
  - cumulative depth within 10/25/50 bps per side;
  - the top 5 book levels per side;
  - returnsBps over the last 1/5/20/100 blocks;
  - recentMids sampled every 5 blocks over the horizon;
  - taker trades over the horizon (count, buy/sell MON, CVD, VWAP, last price/side) and a recentTrades list;
  - the allowed sides.

  Position and last decision were deliberately removed so that "Jev judges the market only". There is no multi-hour price history and no higher-timeframe indicator. — [src/model.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/model.ts); [commit log](https://github.com/jarrodwatts/jev-trader/commits/main)
- Jev is called through the Vercel AI SDK: `experimental_evaluate` with `@ai-sdk/typesafe-ai`, `maxRetries: 0`, model `jev-latest`. — [src/model.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/model.ts)

**Cadence, execution and venue**
- Every block (about 300 ms) the model is asked about the move over `HORIZON_BLOCKS`, which defaults to 100 blocks (about 30 s).
- Each block posts one post-only limit order of `TRADE_SIZE_MON` (default 200 MON, Kuru's minimum), `QUOTE_INSIDE_TICKS` (default 1) inside the touch. It goes out in one `batchUpdate` that also cancels everything resting.
- `hold` appears only when the model misses the block ("late").
- Fills happen only when someone else's taker order hits the resting quote. — [README](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/README.md)
- The venue is Kuru's on-chain CLOB on Monad (chainId 143), market MON-USDC. Orders draw from a Kuru margin account, and the bot deposits `MARGIN_MON=600` and `MARGIN_USDC=20` at startup. — [.env.example](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/.env.example); [src/config.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/config.ts)
- The latency budget: the book read takes about 18 ms (p50). Measured with the mock model, the whole loop takes about 100 ms (p50), of which "80 ms of it the mock's inference stand-in". There is no published latency figure for real Jev. — [README](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/README.md)

**Dry-run mode and the mock model**
- "With no `PRIVATE_KEY` it dry-runs: real book, real decisions, simulated fills. Set `MODEL=jev` and `TYPESAFE_AI_API_KEY` to use Jev; the default `mock` is a momentum heuristic stand-in." In a dry run "the order rests for one block and a real print crossing its price fills it (`simulated: true`)". — [README](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/README.md)
- The mock computes a logistic of `returnsBps.last20/8 + bookImbalance*1.5 + flow*2 + noise`, where the noise is a hash of the block number scaled to ±1.5. It then sleeps 80 ms to imitate inference. — [src/model.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/model.ts)
- The public deployment is labelled "Deployed (dry run, mock model): https://jev-trader-production.up.railway.app". In other words, the public demo does not show Jev. — [README](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/README.md)

**Risk controls**
- The only controls are a position cap (`MAX_POSITION_MON=1000`) that steers orders to the reducing side, and margin availability. `BANKROLL_USD=100` is used only to compute pnlPct.
- There is no stop-loss, no drawdown halt and no daily loss limit (none found in `src/trader.ts`). — [.env.example](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/.env.example); [src/trader.ts](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/trader.ts)
- The AppitStudio review adds several points:
  - "Live mode can automatically deposit funds into Kuru margin and grant a large token allowance during startup."
  - "The model has only buy/sell choices and no uncertainty-based abstention."
  - "Errors are logged and the loop continues; existing resting orders are not comprehensively canceled."
  - "The dashboard API exposes wallet address, decisions, fills, and history without authentication." — [AppitStudio/awesome-jev review, 2026-09-19](https://github.com/AppitStudio/awesome-jev/blob/main/community/projects/tools/jev-trader.md)

**Published results**
- None. P&L exists only as a live counter on the dashboard. The verbatim quote the brief attributed to aowang-ai/jev-trade actually comes from the AppitStudio catalog review of **jarrodwatts/jev-trader**: "Its simulation is useful for understanding plumbing. It does not establish profitability, predictive accuracy, or readiness to trade funds." It also says: "Simulated fills, local accounting, and hard-coded inference-cost estimates are not realized trading returns or verified current pricing." — [AppitStudio/awesome-jev review](https://github.com/AppitStudio/awesome-jev/blob/main/community/projects/tools/jev-trader.md). The jevlist.ai page probably mirrors this text, but I could not fetch it (blocked).

### Inferences
- The design is optimised for virality: a visible decision every 300 ms. It is not optimised for edge. A 30-second horizon on an illiquid on-chain pair, with a two-way forced choice every block and no abstention, is the opposite of what a beginner doing 1h crypto trading should copy.
- The code is still useful as a reference for plumbing: the typed-question structure, the state serialisation, and the mock/dry-run separation.

### Gaps
- There is no public log of a real-Jev run: no hit rate, no P&L, no fill statistics. The deployed instance uses the mock.
- I could not access GitHub issues or discussions, because the API was blocked for this repo.

## 2. aowang-ai/jev-trade: live Jev trader on Hyperliquid

### Takeaway
jev-trade is a port of jev-trader to Hyperliquid perps (5 coins, 5 wallets). Jev picks long/short, open/close/hold, and even leverage. The public "live desk" runs on testnet. There is no stop-loss and, by design, no position cap. The repo publishes no performance results, backtest or accuracy numbers.

### Cited findings
**Identity and history**
- README: "I built a trading bot with Jev. Jev reads the Hyperliquid book every tick and answers buy, sell, or hold. The bot sends the order. Five coins, five wallets, real fills." It is "Based on jev-trader by Jarrod Watts (MIT). Venue is Hyperliquid, not Monad / Kuru." — [README @ a3f2f83](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/README.md)
- `web/public/llms.txt` states: "The public desk at https://www.jev-trade.com/ is a live testnet demo." The gist's "real fills" should therefore be read as testnet fills for the public desk. — [llms.txt](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/web/public/llms.txt)
- Commits run from 2026-09-18 to 2026-09-21, many co-authored with Cursor. On 2026-09-20 the repo had about 28 stars. — [commits](https://github.com/aowang-ai/jev-trade/commits/main); [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)
- CLAUDE.md has the same "core message" constraint as jev-trader: "The demo is a live Jev trading bot on Hyperliquid… Non-negotiables: Jev makes the buy/sell call (not code)… a Jev decision every tick, not every N ticks." — [CLAUDE.md](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/CLAUDE.md)

**The questions (three Choice questions per call)**
- The questions are deliberately minimal ("Labels and live fields only. No advice about when to pick an action"):
  - `bias`: "long or short BTC?"
  - `intent`: "open or hold BTC?" when flat, or "open, close, or hold BTC?" when in a position.
  - `leverage`: "cross leverage for BTC?", with rungs 1/2/3/5/10/20/40/50 up to the coin's max leverage.

  An unreadable side is mapped to hold. — [src/model.ts](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/src/model.ts); [src/plan.ts](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/src/plan.ts)
- The commit history shows the prompt was loosened to encourage trading: "Stop steering Jev toward hold" (ad8daf1) and "Let Jev decide without a fee-horizon hurdle" (4a95655). The fee hurdle was removed from the questions. — [commit ad8daf1](https://github.com/aowang-ai/jev-trade/commit/ad8daf1); [commit 4a95655](https://github.com/aowang-ai/jev-trade/commit/4a95655)
- Issue #1 was fixed in PR #3: "Fix unread Jev bias opening long". Before the fix, an unparseable answer defaulted to a long. — [commit d79acc8](https://github.com/aowang-ai/jev-trade/commit/d79acc8)

**Inputs**
- The inputs are the jev-trader book and tape fields, plus:
  - the live position (side, size, entry, leverage, liquidation price, distance in bps, unrealized P&L);
  - 1-minute indicators (SMA20/50, EMA20, RSI14, vol20, high/low20, range position);
  - asset context (mark, oracle, funding bps, premium, open interest, day volume, day change, max leverage).

  Wallet fills and lifetime P&L are kept out of the model state. — [src/model.ts](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/src/model.ts)

**Cadence and execution**
- Defaults: `TICK_MS=2000` (decision and requote), `PRICE_MS=200` (chart only, no Jev call), `QUOTE_USD=40` notional per tick. The `.env.example` comment says "No sleeve or position cap."
- An entry is "a post-only Alo quote one tick inside the touch". An exit is "an Ioc that crosses the touch" (`CLOSE_SLIPPAGE_BPS=5`). Hold sends no order and pulls any resting quote. — [README](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/README.md); [.env.example](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/.env.example)
- Code comment explaining the asymmetry: "Exits cross as Ioc takers: a resting exit only fills when the market moves your way, which caps winners at the spread and lets losers run." — [src/plan.ts](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/src/plan.ts)
- There is a 4,000 ms deadline on each Jev call, and retries are off. Providers are official TypeSafe (`systemOne`) or Vercel AI Gateway. An HTTP 402 (out of credits) pauses Jev. — [src/model.ts](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/src/model.ts); [commit 4a95655](https://github.com/aowang-ai/jev-trade/commit/4a95655)
- `HL_TESTNET=true` is the default. The README warns: "`HL_TESTNET=false` is mainnet. Do not flip that until you mean it." — [README](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/README.md)

**Risk controls**
- There is no stop-loss, no drawdown kill switch and no position cap; commit ecf6170 says "sleeves no longer cap exposure". Leverage up to the coin maximum is a model output. The only hard protection is Hyperliquid's own margin and liquidation. — [commit ecf6170](https://github.com/aowang-ai/jev-trade/commit/ecf6170); [src/plan.ts](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/src/plan.ts)
- There are 13 unit-test files (P&L, book, indicators, parsing), with CI on push. These test correctness of the plumbing, not performance. — [test/](https://github.com/aowang-ai/jev-trade/tree/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/test)

**Results and disclaimers**
- The README and llms.txt contain no results, accuracy figures, backtests or profitability disclaimer. The only claims are "real fills" and the live desk with P&L "from Hyperliquid". — [README](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/README.md)
- The awesome-jev list describes it as a "Hyperliquid trading desk where Jev answers Choice questions for long/short, open/close/hold, and leverage… Defaults to a dry run; a live key can place real orders." — [cobanov/awesome-jev](https://github.com/cobanov/awesome-jev)

### Inferences
- For a beginner this is the riskiest template in the inventory. It lets a model with no demonstrated predictive skill choose leverage on perps, with no stop and no cap, and the prompt was tuned to trade more.
- A testnet P&L on a dashboard running for a few days is not a track record. Testnet liquidity and fills also differ from mainnet.

### Gaps
- I could not see the numbers on the live desk (jev-trade.com): P&L, number of trades, how long it has run. I also could not tell whether any mainnet capital was ever deployed.
- I could not read the text of issue #1 (the GitHub API was blocked). Its content is inferred from the fix commit.

## 3. The drillan gist (surveyed 2026-09-20): every project listed and its claims

### Takeaway
The gist lists 14 content repos in two groups: "live trading / trading systems" and "forecasting / financial data". It also lists 3 empty placeholder repos. None of the trading repos in the gist reports a validated trading result. The only accuracy numbers in it are for **non-trading** classification tasks (BANKING77 at 92.40%, tax documents at 100%). The author's overall observation is: "Jev judges, code executes"; paper and dry-run are the default.

### Cited findings
All items below are from the raw gist file, [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150), unless marked otherwise.

**Live trading and trading systems**
- **jarrodwatts/jev-trader** (9/16, ★1.3k). Monad/Kuru MON-USDC market maker. Buy or sell every ~300 ms block, post-only orders. This is the reference template.
- **aowang-ai/jev-trade** (9/17, ★28). Hyperliquid port, five sleeves, "real fills".
- **OpenByteInc/QuantDinger** (repo from 2025, ★11.7k). "Open-source AI Trading OS… Added Jev post-release as a 'pre-trade decision gate' in front of the LLM gate. Largest Jev integration by stars." I did not verify this in QuantDinger's code.
- **buberlo/jev-trader** (9/19). A Python redesign with six atomic judgments (regime, direction, toxic_flow, liquidity_stressed, quote_environment, inventory_pressure), a policy engine, hard risk vetoes and a calibration log. The gist calls it the "Most rigorous architecture". Its only commit (2026-09-20) is "Initial scaffold". The paper loop runs on a synthetic/paper venue with Avellaneda-Stoikov pricing and fractional Kelly sizing. No results are published. Disclaimer: "Run in paper mode and testnet before risking capital, and never disable the risk engine." — [buberlo README](https://github.com/buberlo/jev-trader/blob/15d089e656d968fabb750bde8ebeec6d0da1ac7d/README.md)
- **zzsong1023/jev-market-reflex** (9/19). Kraken BTC/ETH/SOL → Jev BUY/SELL/HOLD → simulated portfolio. The README says: "Displayed P&L is a simulation diagnostic, not evidence that Jev predicts markets successfully." and "This is an AI systems demo, not a production trading system or a claim of profitable trading." — [zzsong README](https://github.com/zzsong1023/jev-market-reflex/blob/71f9140f6c0e2432da12636dd386afc1ec64bddd/README.md)
- **rnjsxodyd90/jev-trading-bot** ("Paperline", 9/19). Spot paper trading with $1,000 virtual on read-only Kuru MON/USDC data, with a loss halt, allocation caps and spread caps. The Jev adapter is optional. My clone failed (the repo may be private or deleted), so I could not verify it.
- **UditJain2622004/Jev-Trading** (9/19). SOL backtest experiments (grid and buy-the-dip) with result CSVs, "No README". Not inspected.
- **beto11-gif/jev-trading-backend** (9/18). Binance Spot data backend. Jev is "explicitly disabled via `DisabledJevAnalyzer` pending confirmed docs".

**Forecasting and financial data**
- **sosopop/jev_stock**. Hong Kong stock up/flat/down forecasts. This is the only gist entry with a measured directional accuracy; see section 5.
- **Gamma-Software/jev-signals-lab**. 12 Jev questions per snapshot feed a rule gate: `trend > .75 AND momentum > .70 AND relative strength > .65 AND event risk < .40 AND overextended < .80`. Its README says: "It does not establish predictive performance." and "Do not use its output to trade real money." — [Gamma-Software README](https://github.com/Gamma-Software/jev-signals-lab/blob/5567526f9c166c58784380da4c1340e79f42da52/README.md)
- **IslamBaraka90/jev-typesafe-real-financial-use-cases**. 50 demos plus a backtest lab on daily candles. No results are quoted in the gist, and I did not inspect it.
- **simonmesmith/jev-banking77-experiment**. "92.40% accuracy vs 93.66% for fine-tuned BERT (−1.26 pt), US$0.44 total test cost". This is intent classification, not trading.
- **adilmoujahid/jev-banking77-demo**. Next.js demo, no results.
- **kyotofin/tax-doc-classifier**. "100% strict accuracy on their corpus, ~$0.001/page". Document classification, not trading.

**Placeholders and the author's observations**
- Placeholders: `maxlibin/moomoo-jev-trader`, `Pastorkid/jevTradingBoth`, `hifizz/jev-finance-benchmark`.
- The author's patterns:
  1. "'Jev judges, code executes' is universal."
  2. There are two clusters: low-latency crypto and slower classification/forecasting.
  3. "Dry-run/paper-by-default is the norm — real orders require explicitly configured keys."
  4. There are no Polymarket, arbitrage, forex or DeFi projects yet.
- Ecosystem indexes: cobanov/awesome-jev (★204, "most carefully source-checked list") and everyinfra/jev-radar ("220+ projects claimed").

**A sourcing discrepancy**
- My WebFetch summary of the rendered gist page also listed erboland/jev-fund and antonellof/laya-trader as "community-mentioned". The raw gist file (cloned via git) does not contain them. They may come from gist comments, or the fetch summariser may have added them. Both repos exist and are covered in section 5 and below.
- **erboland/jev-fund**: "An open-source paper hedge fund… Jev … answers buy / sell / hold on a $100k long-only book", on delayed Yahoo prices, with paper fills only. Its launch post says: "Not a claim about alpha. The point is a public, inspectable decision loop and an honest P&L tape." — [jev-fund README](https://github.com/erboland/jev-fund/blob/2e6e0db6e35799d621f4053a0e9b60ba60e62e87/README.md); [docs/launch/reddit.md](https://github.com/erboland/jev-fund/blob/2e6e0db6e35799d621f4053a0e9b60ba60e62e87/docs/launch/reddit.md)

### Inferences
- The gist is an inventory of architectures, not of results. Its "most rigorous" label for buberlo refers to design; that repo is a one-commit scaffold with no measured output.

### Gaps
- I did not inspect QuantDinger's Jev gate, UditJain's result CSVs, IslamBaraka90's backtest lab, or rnjsxodyd90 (clone failed).

## 4. Articles, videos and social posts: what they claim

### Takeaway
Everything in this category is a tutorial, demo or marketing post. The one concrete performance remark (MindStudio's BTC test) is negative: the bot "wasn't performing well in its first hour". One DEV article headline ("67.8% hit rate") appears to repackage a number that the primary source attributes to a **mock**, not Jev.

### Cited findings
- **MindStudio, "12 Jev Use Cases Tested"** (from a search snippet; the page itself was blocked): "A bot re-ran Jev's up/down/hold classification on Bitcoin price data roughly once per second to drive real-time trade decisions… However, the creator noted this particular bot wasn't performing well in its first hour of testing, underscoring that speed doesn't guarantee trading accuracy." — [MindStudio](https://www.mindstudio.ai/blog/jev-use-cases-automation)
- **learnwithmeai, "Stop Trading on Vibes. I Built a Jev Bot That Decides Every…"** (search snippet only; blocked):
  - The bot "reads 18 Binance signals and decides every 5 seconds".
  - It uses five judgments: direction, regime, toxic flow, entry quality, inventory pressure. It trades if direction is not flat and 3 of 5 agree.
  - Every 30 minutes Qwen rewrites the rules, and a champion/challenger scheme keeps whichever version did better over a 30-minute window.
  - Setup prompts are given for Claude Code, Grok, and OpenClaw.

  The snippet shows no results. — [learnwithmeai](https://www.learnwithmeai.com/p/jev-trading-bot)
- **dev.to/nodefiend, "JEV assisted LLM Trading"**: blocked, and the search snippets give almost nothing. A search summary contained this line: "Every verdict lands in the same record as the real action and P&L, and if incoherent trades lose measurably more often than coherent ones, JEV graduates from observer to entry filter." That suggests Jev is used as an observer/coherence checker on LLM trades, but I cannot confirm the line comes from this article. — [dev.to/nodefiend](https://dev.to/nodefiend/jev-assisted-llm-trading-ofa)
- **dev.to/tank_wang, "Jev Decoded: 67.8% Hit Rate, Still Lost Money — What Real Quant Backtests Show"** (blocked; search summary only). The search summary attributes "67.8% directional accuracy on 339 decisions" to Waxmell114514/jev-trade "wired directly into NQ futures order book data".
  - This contradicts the primary source. In the Waxmell README the 67.8% over 339 calls is labelled `jev (mock)`. It was produced on a **synthetic** BTC tape with a deliberately planted edge, and the README says: "Numbers from it describe this repo's plumbing and nothing else."
  - Separately, a search result reports that "Jev averages 67.8% agreement with the reference answers" in TypeSafe's own benchmark. The number may have been conflated.
  - Sources: [DEV tank_wang](https://dev.to/tank_wang/jev-decoded-678-hit-rate-still-lost-money-what-real-quant-backtests-show-oc2); [Waxmell README](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md); [layer3labs search result](https://www.layer3labs.io/guides/jev-benchmarks)
- **jevlist.ai/projects/jev-trader** (blocked). The equivalent catalog text I found (AppitStudio/awesome-jev, reviewed 2026-09-19) says the project "does not establish profitability, predictive accuracy, or readiness to trade funds" and "No financial or performance claims were validated." — [AppitStudio review](https://github.com/AppitStudio/awesome-jev/blob/main/community/projects/tools/jev-trader.md)
- **YouTube**. Titles only, since the site was blocked:
  - "Jev Trader GitHub Tutorial: Build a Subsecond AI Trading Bot" — [video YIEHGt-9cS4](https://www.youtube.com/watch?v=YIEHGt-9cS4)
  - "Jev Trader GitHub on Monad: Under a 300ms - Optimize Jev Trader" — [video BRjhriItz-E](https://www.youtube.com/watch?v=BRjhriItz-E)
  - "Build a 24/7 AI Trading Bot With JEV" — [video 8DgRqDukf-U](https://www.youtube.com/watch?v=8DgRqDukf-U)

  They are setup tutorials for the jev-trader repo. I found no performance data.
- **X (@RohOnChain)**: "Jev is the FASTEST AI model ever built for trading It makes calibrated buy/sell decisions in under 100 ms… one real decision on every single block, 24/7". This is a speed claim with no performance evidence. — [X post](https://x.com/RohOnChain/status/2101311813908652069)
- **TradeRank.ai** (search snippets; blocked):
  - Jev "joined Season 9 mid-season on September 18, 2026, and is entered as a measured baseline rather than a contender".
  - Its gate is "opening positions only when the chance of a 7-day move one way is 0.80 or more with an expected return of at least 1.5%".
  - "the backtest says overconfidence gets Jev past the 0.80 gate, but on its first live run no asset cleared it."

  So there is no live trade to evaluate yet. — [TradeRank blog](https://www.traderank.ai/blog/what-is-jev-typesafe)

### Inferences
- The popular content stresses speed ("subsecond", "every block"). Speed is irrelevant to the question of edge, and at those cadences it makes the fee problem worse.

### Gaps
- I could not read the full text of the nodefiend, tank_wang and learnwithmeai articles, the MindStudio test, the TradeRank page, or the YouTube descriptions. Any numbers they contain beyond the snippets above are unverified.

## 5. Is there any rigorous backtest, out-of-sample test or significant live track record? What accuracy was measured against a coin flip or naive baseline?

### Takeaway
Yes. A handful of serious evaluations exist, and **every one finds no tradable edge for Jev or Laya as a price-direction predictor**:
- The most rigorous test (egrm07: real Jev 1.13.0, 10 input formats, hourly BTC, 65-day holdout) found **AUC 0.471–0.503** (a coin flip is 0.5), all Brier skill scores negative, and every policy losing money after 14 bps round-trip costs.
- A real-Jev news-overlay backtest (Spykoninho, in French) found Jev's contribution to be noise: −2.8, −2.1 and +4.9 points, with the sign flipping.
- A 3-class HK-stock test found 45% on n=120.
- The Laya bot (antonellof) did worse than plain indicator rules on crypto.

No statistically significant live track record exists for any Jev or Laya bot.

### Cited findings

**egrm07/jev_bitcoin_backtest: the strongest evidence**

Sources for this subsection: [README](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/README.md); [report](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/reports/JEV_BITCOIN_BACKTEST_2026-09-19.md)

- Headline verdict: "**No tested representation of Jev 1.13.0 demonstrated a tradable edge.** On the untouched holdout window, real-arm AUC ranged from 0.471 to 0.503, every Brier skill score was negative, and every policy lost money after a 14 bps round trip. The least-negative holdout result was `raw_ohlcv` with the linear policy at **−15.73%**, while simulated buy-and-hold returned **+25.55%**."
- Design:
  - Data: BTCUSDT 5-minute bars from Binance. The question is whether price will be up in 12 bars (1 hour), asked every 12 bars.
  - Ten ways of representing the state: raw OHLCV, returns, numeric indicators, English buckets, trendlines, prose, ASCII chart, hybrid, plus a `blank` control (no data) and a `leaky` control (answer embedded).
  - Dev window 2026-03-01 → 07-14 (3,252 decisions). Holdout 2026-07-15 → 09-18 (1,572 decisions).
  - Costs: 5 bps taker plus 2 bps slippage per side.
  - The pass criteria were block-permutation tests, Benjamini-Hochberg correction, replication on the holdout, a Sharpe confidence interval that excludes 0, and beating buy-and-hold.
- On the dev window every real arm had AUC **below** 0.5 (0.450–0.477), significant in the wrong direction. That means Jev's up-probability ranked moves slightly inversely. The holdout AUCs were 0.471–0.503, none significant. The `leaky` control scored AUC 1.000, which shows the harness can detect a signal when one exists.
- Dev-window net returns under the threshold policy ranged from −52% to −85% for the Jev arms, against −2.77% for buy-and-hold.
- The report notes that "With 3252 decisions … a Sharpe below roughly 3.28 is indistinguishable from luck here."
- The whole run cost $2.5848, with a mean latency of about 666 ms per call.
- Contamination warning: "Jev shipped on 2026-09-15 and its training data almost certainly contains BTC's price history… The only uncontaminated test is forward."

**Waxmell114514/jev-trade: HFT harness, market-making simulation, and real-Jev news and FX studies**

Source for this subsection: [README](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)

- *Directional loop.* The headline figures are "hit rate 67.8% over 339 calls" and "net −62.69" (gross +28.90, fees −91.60), with a break-even taker fee of 0.316 bps. These come from the **mock** provider on a **synthetic** tape with a planted edge. The README explains why this still loses: "A 67.8% hit rate and still a loss… **No amount of predictive accuracy survives costs that exceed the edge.**"
- *Baselines on the same synthetic tape.* Buy-and-hold made +101.75. Momentum, mean reversion, imbalance and random all lost more than the mock Jev did.
- *Calibration of the mock.* Predictions of 0.95 were realised 65% of the time.
- *Latency sweep (mock).* The hit rate when the decision is formed stays flat at about 63%. The hit rate at execution falls to 54.3% at 3,000 ms of added latency. The README summarises: "The answer was right about a tape that no longer exists."
- *Market making with real `jev-latest`, in simulation* (20 synthetic markets, 6,000 ticks each):

  | arm | mean net |
  |---|---|
  | naive | 1,755 |
  | vol-widening | 1,500 |
  | keyword rule | 8,820 |
  | jev | 5,829 |

  The README concludes: "**The keyword rule wins, and the gap is real.**" Jev's news-flagging precision was 97% and its recall 62%. With `--event-impact-bps 0`, Jev's false alarms cost 8× less than the keyword rule's.
- *Real crypto RSS news* (209 headlines, 58 hours): "Nothing clears the noise… **A headline arriving into a quiet tape predicts nothing**." Jev's top 40 headlines were followed by a move 2.5% of the time, against 5.0% for random moments.
- *Real Jev on Fed text, 2009–2026, graded on EURUSD ticks* (2,187 documents). The Jev "reader" arm made **+2 ± 2 bp at 15 minutes, 51% hit rate, z = +1.3**. The README says: "Two basis points with a standard error of two is not a result anyone should size a book on." The effect is gone by 30 seconds after release.
- *Live paper demo on BTC via Kraken.* Measured latency was "p50 386 ms · p95 490 ms · 0 dropped out of 366 decisions · 1093 input tokens per decision = $0.000046". The README calls it "a demo of a decision loop, not a trading result."
- *Sampling noise.* "Jev is a sampler. Re-drawing its answers moved a single configuration by ~30%."

**Spykoninho/trading-bot-jev: real Jev, French README, 4h trend-following plus a Jev news overlay**

Sources for this subsection: [README](https://github.com/Spykoninho/trading-bot-jev/blob/8d36bd257eec204fe6749b277a49e903b368b594/README.md); [docs/design.md](https://github.com/Spykoninho/trading-bot-jev/blob/8d36bd257eec204fe6749b277a49e903b368b594/docs/design.md)

- *Design.* The trend rule is: buy above EMA200 × 1.01, sell below EMA200 × 0.99, on 4h candles, for BTC/ETH/SOL on Bitvavo. Jev reads news only (crypto press, Trump, Fed, SEC, Binance announcements). It can shift the thresholds by at most ±0.5% and veto buys on regulatory risk. 49,496 historical texts were judged for about $2.50.
- *Default backtest* (USDC pairs, 2024-09-29 → 2026-09-19, 0.05% fees, 4 bp slippage):

  | variant | return | max drawdown | Sharpe |
  |---|---|---|---|
  | no news (pure EMA rule) | **+84.9%** | 26.2% | 1.39 |
  | bias + veto (with Jev) | +82.1% | | 1.35 |
  | buy-and-hold | −2.5% | 63.3% | |

  Verdict: "**Jev n'apporte rien de mesurable sur les prix.** L'écart avec « sans news » a été mesuré trois fois… **−2,8**, **−2,1**, **+4,9** points… le signe change, c'est du bruit." (Jev adds nothing measurable on prices; the gap was measured three times and the sign changes, so it is noise.)
- *Event study* (1,201 high-impact headlines). The price had already moved before publication. What remains after 1 hour is +0.032%, "loin sous les frais" (far below fees). The design doc adds: "Jev a classé sans erreur les 25 décisions de taux de la Fed, mais le prix les avait déjà intégrées." (Jev classified all 25 Fed rate decisions correctly, but the price had already absorbed them.)
- *The "Trump pro-crypto" rule.* +0.63% at 1 hour, p = 0.034, but n = 13. It is "une hypothèse, pas un résultat" (a hypothesis, not a result), since about ten subgroups were tested with no correction for multiple testing.
- *Trade profile of the EMA strategy.* 23.5% winning trades, and the 5 best trades make up 206% of cumulative gain. That is typical trend-following.

**sosopop/jev_stock: 3-class daily Hong Kong stock direction**
- On the latest 30 T+1 cases for each of 4 stocks, overall accuracy was **54/120 = 45.0%**. By stock: Xiaomi 40.0%, MiniMax 56.7%, Pop Mart 30.0%, MIXUE 53.3%.
- The README cautions: "These numbers describe this particular historical window and threshold. They are not a promise about future performance." It notes that Wilson 95% intervals are in the JSON output.
- The author warns that "`down: 0.68` … is not automatically a 68% historical win rate". — [README](https://github.com/sosopop/jev_stock/blob/81fa919795084ba942632d35c9986a1ece7162f9/README.md)

**antonellof/laya-trader: Laya, local and open source; 1h crypto and stocks; walk-forward tests**

Sources for this subsection: [README](https://github.com/antonellof/laya-trader/blob/5bb45d00fe17b1d2a1a395ddb71d72adef4c5c04/README.md); [docs/RESEARCH.md](https://github.com/antonellof/laya-trader/blob/5bb45d00fe17b1d2a1a395ddb71d72adef4c5c04/docs/RESEARCH.md)

- *Design.* One yes/no question returns P(bullish), in about 15 ms on Apple Silicon. Indicators on 1h candles are rendered as "Good: … Bad: …" sentences. Trading is paper only.
- *Crypto, fixed strategy, 9 unseen months (Dec 2025 – Sep 2026):*

  | variant | return |
  |---|---|
  | Laya signal | +0.5% |
  | same structure, plain trend votes instead of Laya | **+8.6%** |
  | buy-and-hold | −8.7% |

  The author writes: "**On crypto, the plain trend votes did better than Laya**… Laya's crypto signal isn't stable."
- *Prompt lab, crypto.* The 4h information coefficient was **−0.14** on the selection window and **+0.09** on the check window: the sign flips.
- *Stocks* (20 names, 9 months, 1h). Laya reversion made +10.3%, rules-only +8.2%, buy-and-hold +12.2%. The README summary says "Laya adds value over plain rules" for stocks, but this is a single comparison.
- *Last 30 days to 2026-09-25.* Crypto **−3.7%** against buy-and-hold **+13.1%**.
- *What failed.* The README lists: "fast trading on 1–15 minute candles (fees), leverage above 1×, tight stops". Futures at 2× and 3× lost 17–35%. The author's caveat: "single results move a lot between runs… Trust the direction of an effect, not the exact percentage."

**nighomni123/trading-bot: pre-registered gates; Jev slot filled by a mock**
- The plan's rule: "Jev is not being built to make money; Jev is being tested to determine whether it adds incremental decision value to an already-valid quantitative trading process."
- Ablation on 2024 validation data with 15-minute bars:
  - mock-Jev arm −0.8%, "via exposure cut only (win 48.3 vs 48.9 — no selectivity)";
  - a threshold variant reached a 55.8% win rate yet −0.35% net;
  - gate verdict: "edge does not survive costs → STOP".
- EXP-009 is also **STOP**, and Jev "not promoted". A live shadow test on 2026-09-22 made 0 entries. — [IMPLEMENTATION_PLAN.md](https://github.com/nighomni123/trading-bot/blob/86ad6b02870ca7258b9239cedee6c38cd4cbf94a/IMPLEMENTATION_PLAN.md)

**Why so few results are published**
- tyleree/jevbot: "Results stay private. TypeSafe's customer agreement (2.3(f)) forbids publishing benchmarks or performance information about the service, so no backtest or paper-trading results are ever committed here." That project is also unfinished: "There is **no runnable backtest or paper loop yet**." — [jevbot README](https://github.com/tyleree/jevbot/blob/9dd505192dff821b00ae2a8880bd9d4b2b5bf655/README.md)
- A search result on TypeSafe's terms reports clause MCA 2.3(f), "publish benchmarks or performance information about the Services", but advises checking the current terms. — [wunderlandmedia](https://wunderlandmedia.com/typesafe-ai-jev-terms-of-service-gdpr)
- Another search snippet states: "no independent benchmark of Jev exists as of September 2026, and every published performance metric originates from TypeSafe AI's internal dashboard." — [layer3labs](https://www.layer3labs.io/guides/jev-benchmarks)

### Inferences
- **Accuracy against a coin flip.**
  - The only large-sample, out-of-sample binary test on real Jev (egrm07, n=1,572 holdout) is at chance: AUC 0.471–0.503. On dev it was significantly worse than chance.
  - The 3-class HK test's 45% (n=120) is above the 33% uniform baseline but has a wide confidence interval, and no majority-class baseline is reported.
  - No project shows Jev beating a naive baseline on price direction after costs.
- **Where Jev does look good**, the result is about *reading*, not *predicting*: classifying Fed decisions without error, 97% precision on material headlines. But the market had usually already priced the information by the time the text was available through a public feed.
- **Structural issues** undermine any backtest claim:
  - training-data contamination (Jev was released 2026-09-15 and has probably seen the history);
  - sampling noise (about 30% swing on redraws);
  - the moving `jev-latest` alias;
  - ToS restrictions on publishing results.

  Only forward paper tests over months would be clean, and none exist yet.
- **For a beginner:** in every independent test, the plain indicator rule matched or beat the Jev/Laya-augmented version (Spykoninho, laya-trader crypto, nighomni123). The measurable gains came from structure: trend filter, 1h or 4h timeframe, low fees, 1× leverage.

### Gaps
- There is no forward, live (mainnet), multi-month track record for any Jev or Laya bot.
- I did not open the results of IslamBaraka90's backtest lab or UditJain's CSVs.
- I could not verify the exact text of TypeSafe's current customer agreement.
- Waxmell's HFT directional backtest with `--provider jev` (real model) is described as runnable, but I did not find a published real-Jev result for that directional arm.

## 6. Integration with freqtrade (FreqAI, custom strategy) or other open-source frameworks

### Takeaway
I found **no freqtrade or FreqAI integration** of Jev or Laya. The integrations that do exist are in other frameworks: TradingAgents (fork), QuantDinger, AlgoVault, and bespoke Python and TypeScript loops. Several projects use a "Jev as a gate or advisor over a deterministic strategy" pattern, which would transfer to a freqtrade `confirm_trade_entry` hook. Nobody has published that.

### Cited findings
- GitHub code search for "IStrategy typesafe jev" returned no relevant strategy files. "freqtrade typesafe jev" returned only awesome-lists, trending digests and radars, not code. — [GitHub code search](https://github.com/search?q=freqtrade+typesafe+jev&type=code)
- A web search for "freqtrade Jev TypeSafe strategy" found nothing specific. The summary says "the search results don't contain specific documentation about integrating Jev with Freqtrade". — [freqtrade strategy docs, returned as a generic hit](https://www.freqtrade.io/en/stable/strategy-customization/)
- **TradingAgents-Jev** (fork of TauricResearch/TradingAgents): "multi-agent LLM trading framework with TypeSafe Jev per-item sentiment judgments". The Sentiment Analyst judges each news item and social post with Jev. — [sushant-mishra-dtu/TradingAgents-Jev](https://github.com/sushant-mishra-dtu/TradingAgents-Jev)
- **QuantDinger** (★11.7k): Jev was added as a "pre-trade decision gate" in front of the LLM gate, according to the gist. Not verified in code. — [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)
- **AlgoVault integrations**: "Jev decides whether to act on a composite AlgoVault verdict … for a crypto perp market now… Read-only: it never places orders." — [cobanov/awesome-jev](https://github.com/cobanov/awesome-jev)
- **hwanjjang/kis-hl-trading-system**, issue #38: "Add Jev (TypeSafe AI) long/short/wait timing opinion as advisory evidence for strategy decisions". This is a proposal, not an implementation. — [issue #38](https://github.com/hwanjjang/kis-hl-trading-system/issues/38)
- **Laya as a drop-in replacement**: Ollaya and stuntd serve the open Laya model locally "behind TypeSafe-compatible `/v1/systemone`… endpoints, so existing Jev clients switch with `TYPESAFE_BASE_URL`". — [cobanov/awesome-jev](https://github.com/cobanov/awesome-jev)

### Inferences
- If the user wants to experiment inside freqtrade, the natural pattern would be:
  - keep a validated indicator strategy on 1h candles;
  - call Jev or local Laya only as a veto in `confirm_trade_entry`;
  - measure (strategy + veto) against (strategy alone) on the same data, as Spykoninho and nighomni123 did.

  Current evidence predicts the veto will add little or nothing.

### Gaps
- GitHub code search indexes default branches only, and results are capped. A private or unindexed freqtrade integration may exist.

## 7. Cost of running such a bot, and whether latency matters for 1h trading vs sub-second trading

### Takeaway
At a 1h cadence, Jev costs almost nothing: cents per month per pair. Latency (70 ms to about 1.5 s) is irrelevant against a 3,600-second bar. The costs that matter are exchange fees and slippage, which destroyed every high-frequency Jev experiment. At sub-second or per-block cadence, model costs reach dollars per day (plus about $2–5 per hour of gas on Monad). Latency then matters, but only because the edge being chased is smaller than the fees.

### Cited findings
- **Price.** $0.042 per million input tokens; output is free. This is hard-coded as `jevUsdPerMTok: 0.042` in both trader repos and cited as "Jev's documented $0.042 per million input tokens". — [jev-trader config](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/config.ts); [egrm07 README](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/README.md)
- **Tokens per decision, measured.**
  - Waxmell's live BTC demo: 1,093 input tokens, $0.000046 per decision. — [Waxmell README](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)
  - egrm07: about 1,050 tokens per decision for the `semantic` state (3,428,429 tokens / 3,252 decisions) and about 3,600 for `raw_ohlcv` (11,708,596 / 3,252). The full 10-arm backtest cost $2.58. — [egrm07 report](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/reports/JEV_BITCOIN_BACKTEST_2026-09-19.md)
  - Spykoninho: 49,496 news texts for about $2.50. — [Spykoninho README](https://github.com/Spykoninho/trading-bot-jev/blob/8d36bd257eec204fe6749b277a49e903b368b594/README.md)
- **jev-trader, per block.** "Jev inference for an hour ≈ $0.20; gas for the same hour ≈ $2–5." The env file says "Expect ~0.03 MON per block live" in gas. — [SPEC.md](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/SPEC.md); [.env.example](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/.env.example)
- **Latency, as claimed and as measured.**
  - TypeSafe reports "70–500 ms end-to-end" (cited in the Waxmell README).
  - Waxmell live: p50 386 ms, p95 490 ms. Fed documents: median 741 ms. — [Waxmell README](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)
  - egrm07: mean about 666 ms per call. — [egrm07 report](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/reports/JEV_BITCOIN_BACKTEST_2026-09-19.md)
  - nighomni123 full pipeline: 634–1,548 ms per bar. — [nighomni123 plan](https://github.com/nighomni123/trading-bot/blob/86ad6b02870ca7258b9239cedee6c38cd4cbf94a/IMPLEMENTATION_PLAN.md)
  - Laya running locally: about 15 ms on Apple Silicon, from a ~650 MB checkpoint, with no API cost. — [laya-trader README](https://github.com/antonellof/laya-trader/blob/5bb45d00fe17b1d2a1a395ddb71d72adef4c5c04/README.md)
- **Frequency and fees.** egrm07's `jev power` says "an edge is only tradable at BTCUSDT 5m if decisions are spaced about an hour apart — at every-bar frequency the 14 bps round trip eats any realistic signal." — [egrm07 README](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/README.md)
- **Waxmell's high-frequency loop** is only viable below a 0.316 bps taker fee: "a top-tier fee schedule or maker rebates, not a retail account". — [Waxmell README](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)
- **laya-trader.** On a 15-minute-candle run, "Fees were most of the loss: about a quarter of the capital every month". On the crypto futures variants, "Leverage above 1× destroyed crypto results." — [laya-trader RESEARCH.md](https://github.com/antonellof/laya-trader/blob/5bb45d00fe17b1d2a1a395ddb71d72adef4c5c04/docs/RESEARCH.md)
- **Latency does matter at sub-second scale, and only there.** In Waxmell's mock sweep, executed hit rate fell from 61.8% to 54.3% when 3 s of latency was added. On Fed text, the small edge "is gone in thirty seconds". — [Waxmell README](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)
- **Operational costs.** aowang-ai/jev-trade pauses Jev on HTTP 402 when credits run out. — [commit 4a95655](https://github.com/aowang-ai/jev-trade/commit/4a95655)

### Inferences (my arithmetic, using the measured token counts above)
- **1h timeframe, one pair, one call per closed candle:** 24 calls per day × 1,100–3,600 tokens is about 26k–86k tokens per day. That costs about $0.001–0.004 per day, or roughly **$0.03–0.11 per month**. Even with 3 pairs and several questions per call it stays under $1 per month.
- **One decision per second, one pair** (the MindStudio-style setup): 86,400 × 1,093 tokens is about 94M tokens per day, about **$4 per day or $120 per month**.
- **jev-trade defaults** (2 s tick × 5 coins = 216,000 calls per day): about $10–18 per day, assuming 1,100–2,000 tokens per call. The actual token count per call was not measured.
- **jev-trader per block:** about $4.80 per day for Jev plus about $48–120 per day for gas (from the SPEC's hourly figures).
- For the French beginner's 1h bot, the model's API cost and latency are negligible. What decides the P&L is fees (Binance spot taker about 0.1%) and whether the signal has any edge. The evidence above says Jev/Laya direction calls have none measurable.

### Gaps
- TypeSafe's current free-credit allowance and rate limits were not researched here; other notes cover the product.
- I have no measured token count for jev-trade's richer state, so the $10–18 per day figure is an estimate.
