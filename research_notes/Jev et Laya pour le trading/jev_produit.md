# Jev (TypeSafe AI): product and technology profile (as of 2026-09-26)

Method note for the report writer: the network proxy blocked direct page fetches for typesafe.ai, dev.to, Wikipedia, MarkTechPost, MindStudio, DataCamp, flaviocopes.com and openrouter.ai. So I could not open TypeSafe's own website, docs, pricing page, blog or ToS directly. I did fully read these pages: GitHub pages (the TypeSafe org, the official Python SDK README, the harrymunro benchmark README + REPORT.md, the AbdelStark "awesome" field guide, the AnthusAI calibration study) and one GitHub gist. Everything else comes from search-engine result snippets. Those items are tagged **[S]**. For [S] items the cited URL is the most likely origin among the results returned, but the snippet was machine-summarised and I could not open the page to check it. Treat [S] items as lower-confidence. Note also that many SEO/lookalike domains exist (jevtypesafe.org, jevtypesafeai.com, jevaiguide.com, jev.pro, jevmanual.com, jevwiki.ai, jev-ai.dev, jevai.me "JEV AI"). **None of them are TypeSafe properties**. The GitHub org lists only https://typesafe.ai/ as the official site.

## 1. Who is TypeSafe AI (founders, funding, launch date, location)?

### Takeaway
TypeSafe AI is a San Francisco startup led by co-founder/CEO Diogo Almeida (ex-OpenAI, ex-Google Brain). It came out of stealth on 15 Sept 2026 with a ~$40M seed round led by DCVC and early access to Jev. Calling Almeida a "ChatGPT co-creator" stretches the record. He is a credited co-author on InstructGPT/RLHF, ChatGPT and GPT-4 work, but saying he "co-invented RLHF" is an overclaim.

### Cited Findings
- Jev went into early access on **15 Sept 2026**, the same day TypeSafe came out of stealth with a **$40M seed round led by DCVC** [S] — [DataCamp](https://www.datacamp.com/blog/system-one-models-jev); [The Rundown AI](https://www.therundown.ai/news/typesafe-jev-ai-decisions-software)
- The Rundown describes TypeSafe as "the startup from former OpenAI researcher and ChatGPT contributor Diogo Almeida" [S] — [The Rundown AI](https://www.therundown.ai/news/typesafe-jev-ai-decisions-software)
- Almeida is described as co-founder and CEO of TypeSafe AI and a former researcher at Google Brain and OpenAI. He is a "co-author on GPT-4, ChatGPT, and the RLHF and InstructGPT papers". Jev was announced "after two years in stealth" [S] — [AI Wiki: Diogo Almeida](https://aiwiki.ai/wiki/diogo_almeida); [AI Wiki: TypeSafe AI](https://aiwiki.ai/wiki/typesafe_ai); [LinkedIn](https://www.linkedin.com/in/diogomda/)
- Some coverage inflates the claim to "co-invented RLHF and InstructGPT" [S] — [explainx.ai](https://explainx.ai/blog/typesafe-ai-jev-system-one-models-launch-2026). At least one outlet misspells his name as "Diego Almeida" [S] — [MindStudio](https://www.mindstudio.ai/blog/jev-system-one-model-launch)
- Location: the team works in person five days a week in **San Francisco**, in an office "near the Embarcadero station" [S] — [TypeSafe Team page](https://typesafe.ai/team). The GitHub org gives its location as "United States of America" — [github.com/typesafe-ai](https://github.com/typesafe-ai)
- GitHub org self-description: "TypeSafe is building a new kind of AI model - System One - for native machine use, optimized for speed, reliability, and cost." — [github.com/typesafe-ai](https://github.com/typesafe-ai)
- Early traction: by **18 Sept 2026** Vercel said Jev was the fastest-adopted model in AI Gateway history [S] — [Startup Fortune](https://startupfortune.com/typesafe-ais-decision-model-jev-becomes-vercels-fastest-adopted-launch/)

### Inferences
- The founder's background is broadly supported: InstructGPT (2022) lists a Diogo Almeida among its authors, and several independent profiles agree. "ChatGPT co-creator" is marketing shorthand. The fair wording is "co-author of the InstructGPT/RLHF paper and a contributor to ChatGPT/GPT-4". RLHF as a technique predates InstructGPT (Christiano et al., 2017), so "co-invented RLHF" should be treated as an overclaim.
- The GitHub org holds forks of **LLaDA** ("Large Language Diffusion Models") and **vLLM** — [github.com/typesafe-ai](https://github.com/typesafe-ai). This hints at interest in non-autoregressive/diffusion architectures and in inference serving. It is not confirmation of Jev's architecture.

### Gaps
- Other co-founders, headcount, and investors beyond DCVC: not found in accessible sources.
- I could not read the official launch blog post ([typesafe.ai/blog/introducing-system-one-models-and-jev](https://typesafe.ai/blog/introducing-system-one-models-and-jev)) directly. The date and funding figures come from secondary coverage.

## 2. What exactly does Jev do, how does it work, and what inputs does it accept?

### Takeaway
Jev is a closed, API-only "System One" decision model. It takes text/JSON "state" plus up to ~32 typed questions and answers all of them in one parallel, non-autoregressive pass. There are three question types: **Noul** (yes/no → probability), **Choice** (pick one option → winner + per-option probabilities + confidence) and **Score** (rate on an ordered rubric → weighted value + distribution + confidence). It never generates free text. Input is text only, with a budget of roughly 32K tokens for state plus question definitions.

### Cited Findings
- Jev is a "System 1" model that outputs decisions directly as probabilities/confidence scores instead of predicting the next token autoregressively. It takes unstructured program state and returns typed, probabilistic decisions "in a single parallel pass" [S] — [MindStudio](https://www.mindstudio.ai/blog/jev-system-one-model-launch); [DataCamp](https://www.datacamp.com/blog/system-one-models-jev)
- It "scores every possible answer in the schema in a single parallel forward pass". It never runs a decoding sampler and "simply populates an array of float probabilities and typed indices" [S] — [explainx.ai](https://explainx.ai/blog/typesafe-ai-jev-system-one-models-launch-2026)
- The official core primitives are **Choice, Score and Noul** — [AbdelStark/awesome-typesafe-jev](https://github.com/AbdelStark/awesome-typesafe-jev)
- **Noul** = yes/no. It returns a single probability in [0,1] that the answer is yes and carries **no separate confidence value**, because distance from 0.5 plays that role. **Choice** picks one option and returns the winner, a probability for every option and a confidence value. **Score** rates the state against ordered rubric levels and returns a probability-weighted value, the full distribution and a confidence value [S] — [Sanity glossary: Noul](https://www.sanity.io/glossary/noul); [Jev Manual (unofficial)](https://jevmanual.com/manual/primitives/noul/)
- Official Python SDK call shape: `client.system_one(state={...}, questions={"category": Choice(instructions="...", criteria={"billing": None, "technical": None, "other": None})})`, read back via `response.choices["category"].choice` — [typesafe-ai/typesafe-sdk-python](https://github.com/typesafe-ai/typesafe-sdk-python)
- Inputs: "Jev reads text only: a string, a JSON object or a JSON array of text". The request budget is about **32,000 tokens (~150,000 English characters)**, shared by the state and all question definitions [S] — [Layer3 Labs: Jev limits](https://www.layer3labs.io/guides/jev-limits); [OpenTweet limits](https://opentweet.io/jev/limits)
- A community PR enforces a hard **32,768-token** state window client-side ("refuse states over the 32,768-token window before the request") [S] — [lucasmartins-ai/lcc PR #16](https://github.com/lucasmartins-ai/lcc/pull/16). Another snippet cites a "64,000-token context window with a 32,000-token budget for state" [S] — [Sanity glossary](https://www.sanity.io/glossary/jev-typesafe-ai-model). The 64K figure is **unverified/contradictory**.
- Per-request limits (gateway): **max 32 questions per request, 64 options per Choice, 2–10 levels per Score** [S] — [Layer3 Labs](https://www.layer3labs.io/guides/jev-limits). This conflicts with another snippet saying a Choice supports **up to 255 options** [S] — [Sanity glossary: Noul](https://www.sanity.io/glossary/noul). The likely explanation is that the API and gateway limits differ; this is unconfirmed.
- Adding questions to a batch raises token usage slightly but leaves latency "largely unchanged", because all questions are evaluated in parallel against the shared state [S] — [OpenTweet limits](https://opentweet.io/jev/limits)
- Target uses per TypeSafe/press: real-time loops (games, robots, simulations), sorting requests, scoring records, screening LLM outputs for jailbreaks [S] — [The Rundown AI](https://www.therundown.ai/news/typesafe-jev-ai-decisions-software); [MindStudio](https://www.mindstudio.ai/blog/jev-system-one-model-launch)
- Jev is **closed**: API only, no published weights. Community projects build open substitutes, e.g. "SemIf-OpenJev" ("Semantic ifs from open models, on a 3090 at home. Independent; not affiliated with Jev or TypeSafe", ~4.3k stars) — [GitHub search results](https://github.com/TheoLeeCJ/SemIf-OpenJev)

### Inferences
- In practice Jev behaves like a very fast, general-purpose zero-shot classifier/scorer with typed outputs. Several commentators frame it as "the comeback of classifiers" or a BERT-style classifier [S] — [XenoSpectrum](https://xenospectrum.com/en/jev-typesafe-bert-classifier-decomposition/); [AI-ML Companion](https://aimlcompanion.ai/blog/jev-system-one-model-classifier-returns-2026). This fits the single-forward-pass description.
- It takes no images, audio or binary numeric tensors. Numbers and time series have to be serialised as text/JSON inside the state (see section 7).

### Gaps
- Model size, architecture details (encoder? diffusion? multiple heads?), training data and training method were not found in any accessible source. The official blog and docs were blocked.
- It is unclear whether the 32K budget is a hard server-side limit or a gateway limit, and whether a 64K window exists.
- I could not open the DEV article comparing Jev and Laya ([dev.to/jamilxt](https://dev.to/jamilxt/jev-vs-laya-the-same-ai-idea-one-closed-and-one-open-3c6e)) because dev.to was blocked. Its "closed vs open" framing matches the findings above.

## 3. API access: endpoints, SDKs, auth, rate limits, versions, changelog

### Takeaway
Access is through TypeSafe's own API (`https://api.typesafe.ai`, console at console.typesafe.ai) with official TypeScript and Python SDKs, and through gateways (Vercel AI Gateway, OpenRouter, Netlify, others). The official env var is **`TYPESAFE_API_KEY`**, not `TYPESAFE_AI_API_KEY`. The current model is **jev-1.13.0** (alias `jev-latest`). The Python SDK was at **0.7.1** (21 Sept 2026). Rate limits are not clearly published.

### Cited Findings
- Official SDKs: JS/TS **`@typesafe-ai/sdk`** (Node.js 20+) and Python **`typesafe-sdk`** (Python 3.10+), plus **`system-one-adapter-python`**, a "drop-in TypeSafeClient replacement backed by LLM APIs" (OpenAI/Anthropic-compatible) — [AbdelStark/awesome-typesafe-jev](https://github.com/AbdelStark/awesome-typesafe-jev); [github.com/typesafe-ai](https://github.com/typesafe-ai)
- Official repos and activity as of 26 Sept 2026: `typesafe-sdk-js` (TypeScript, 242 stars, last updated 15 Sept), `typesafe-sdk-python` (229 stars, 21 Sept), `system-one-adapter-python` (300 stars, 22 Sept), `skills` ("Agent skills for building with TypeSafe's System One API", 2,165 stars) — [github.com/typesafe-ai](https://github.com/typesafe-ai)
- Official Python install: `uv add typesafe-sdk`. Env var: **`TYPESAFE_API_KEY`**. Client: `TypeSafeClient()`. Method: `system_one()`. Docs: docs.typesafe.ai, docs.typesafe.ai/sdk/python — [typesafe-ai/typesafe-sdk-python](https://github.com/typesafe-ai/typesafe-sdk-python)
- Official links: docs.typesafe.ai, docs.typesafe.ai/api (API reference), console.typesafe.ai, evals.typesafe.ai — [AbdelStark/awesome-typesafe-jev](https://github.com/AbdelStark/awesome-typesafe-jev). API base: `https://api.typesafe.ai` [S] — [search result set incl. apimaster.ai](https://apimaster.ai/blog/jev-api)
- Model version: the SDK defaults to the `jev-latest` alias, "currently jev-1.13.0", and needs Node.js 20+. TypeSafe's llms.txt lists **SDK changelogs only**, and no model version above 1.13.0 had appeared as of 20 Sept 2026 [S] — [systemonemodels.org](https://systemonemodels.org/models/jev/); [Jev Wiki (unofficial) Python SDK changelog](https://jevwiki.ai/wiki/reference/python-sdk-changelog.md). The independent benchmarks of 21 Sept tested **1.13.0** — [harrymunro REPORT.md](https://github.com/harrymunro/jev-laya-benchmark/blob/main/REPORT.md); [AnthusAI/Jev-Calibration](https://github.com/AnthusAI/Jev-Calibration)
- Python SDK changelog: **0.6.0 (2026-09-15)** breaking change, `Score.criteria` became an ordered sequence instead of an int-keyed dict. **0.7.0 (2026-09-18)** breaking change, serialization moved from msgspec to pydantic and `system_one(..., response_model=...)` was added. **0.7.1 (2026-09-21)** is current [S] — [Jev Wiki Python SDK changelog](https://jevwiki.ai/wiki/reference/python-sdk-changelog.md)
- Gateways: Vercel AI Gateway as `typesafe-ai/jev` (callable from AI SDK 7's `evaluate`). OpenRouter lists `jev-latest` and `jev-1.13`. Also Netlify AI Gateway, Pydantic AI docs, and B.AI API [S] — [OpenRouter Jev 1.13](https://openrouter.ai/typesafe/jev-1.13); [Netlify changelog](https://www.netlify.com/changelog/typesafe-jev-ai-gateway/); [Pydantic docs](https://pydantic.dev/docs/ai/models/typesafe/); [KuCoin news](https://www.kucoin.com/news/flash/typesafe-ai-model-jev-launches-on-b-ai-api-with-0-042-1m-token-input-cost)
- OpenRouter also lists a separate "**Jev Router**" product (model router, "picks models for free, with a claimed million-token window") [S] — [RuntimeWire](https://runtimewire.com/article/typesafe-jev-router-openrouter-launch); [OpenRouter Jev Router](https://openrouter.ai/typesafe/jev-router)
- Rate limits: one source reports account limits of **250,000 tokens/s and 1,200 requests/min**. Another says TypeSafe "does not publish a specific numeric rate limit anywhere obviously discoverable in its primary documentation" [S] — [OpenTweet limits](https://opentweet.io/jev/limits); [Layer3 Labs pricing](https://www.layer3labs.io/guides/jev-pricing)
- Observed throughput: **72 items/s at 32 requests in flight** (independent) — [harrymunro/jev-laya-benchmark](https://github.com/harrymunro/jev-laya-benchmark)

### Inferences
- The `TYPESAFE_AI_API_KEY` name in the brief is probably a community/third-party convention. Code should use `TYPESAFE_API_KEY` to work with the official SDKs.
- SDK breaking changes landed within 3 days of launch (0.6.0 → 0.7.0), so pin SDK versions.
- The model is also on third-party gateways, where latency, limits and data handling depend on the intermediary.

### Gaps
- REST endpoint paths, request/response JSON schema, and error codes (beyond a community page about `max_tokens_exceeded`, [jevaiguide](https://jevaiguide.com/errors/max-tokens-exceeded/)): official API reference not accessible.
- Latest JS SDK version number: not found.
- Official rate-limit tiers: not verifiable.

## 4. Pricing, free tier, and the "200x faster / 400x cheaper than GPT-6 Astra" claim

### Takeaway
List price is **$0.042 per million input tokens, output free**. On 20 Sept, signups opened with **$5 free credit** (~120M tokens), then paused on 22 Sept under demand; sources disagree about waitlist vs general availability. The "200x/400x" figures round TypeSafe's own **193.6x faster / 444.6x cheaper** headline. Those come from in-house "workflow evaluations" where the "correct" answer is the average of GPT-6 Astra and Fable 5.1. That measures agreement with frontier LLMs, not ground-truth accuracy, and TypeSafe itself calls the multiples "on the higher end".

### Cited Findings
- **$0.042 / 1M input tokens; output $0.00** [S] — [OpenRouter Jev 1.13](https://openrouter.ai/typesafe/jev-1.13); [DataCamp](https://www.datacamp.com/blog/system-one-models-jev); [jevaiguide pricing](https://jevaiguide.com/jev-pricing/). One aggregator lists **$0.05/M** [S] — [apimodels.app](https://apimodels.app/access/jev-api), which looks like rounding or a reseller markup.
- Free tier and access timeline (contradictory):
  - "TypeSafe AI documents no free tier and offers no free trial credits… early-access waitlist" [S] — [Layer3 Labs](https://www.layer3labs.io/guides/jev-pricing).
  - "Signups opened to everyone on **20 Sept** at console.typesafe.ai with **$5 in credit** (~**120 million tokens**), then **paused new signups on 22 Sept** under demand" [S] — [Firecrawl](https://www.firecrawl.dev/blog/what-is-jev); [OpenRouter blog](https://openrouter.ai/blog/insights/what-is-jev/).
  - Another says Jev was "generally available as of 22 September 2026… an active API key immediately, with no waitlist" [S] — [jevaiguide](https://jevaiguide.com/jev-pricing/).
- A public repo "typesafe_register" ("typesafe.ai registration machine… unlimited jev", created 21 Sept) automates account creation — [GitHub search](https://github.com/Futureppo/typesafe_register)
- Zero data retention is **enterprise plan only**, on request [S] — [jevaiguide ZDR FAQ](https://jevaiguide.com/faq/does-jev-train-on-your-data/)
- Official speed/cost claims as reported: "20–200x faster (70 ms–500 ms vs. 3–329 seconds) and 40–400x cheaper" [S] — [Flowtivity](https://flowtivity.ai/blog/jev-typesafe-ai-decision-model/); [DataCamp Jev vs GPT-6 Astra](https://www.datacamp.com/blog/typesafe-jev-vs-gpt-6-astra). Headline figures: **up to 193.6x faster and 444.6x cheaper** [S] — [DEV: arifulislamat](https://dev.to/arifulislamat/typesafes-jev-model-is-it-really-193x-faster-and-444x-cheaper-56oa); [jevaiguide benchmarks](https://jevaiguide.com/jev-benchmarks/)
- Press versions of the multiple vary: "40x–200x faster" [S] — [DataCamp](https://www.datacamp.com/blog/system-one-models-jev); "up to 100x faster and 100x cheaper" [S] — [MindStudio](https://www.mindstudio.ai/blog/jev-system-one-model-launch); "200x faster & 400x cheaper than frontier models" [S] — [Generative AI pub (Jim Clyde Monge)](https://generativeai.pub/new-jev-model-is-insane-200x-faster-400x-cheaper-than-frontier-models-4c595a3abe55?gi=77a63472a3fc)
- Methodology behind the multiples: TypeSafe's "workflow evaluations" use a fixed program ("compute graph") that breaks a business task into many small questions. Every model answers the same decomposed questions. The **reference answer is the average of GPT-6 Astra and Fable 5.1**. The workflows were written by TypeSafe's own model-capabilities team, and TypeSafe says the multiples "are on the higher end" of real-world expectations. Other comparison models cited include GPT-5.6 Terra and DeepSeek [S] — [jevaiguide benchmarks](https://jevaiguide.com/jev-benchmarks/); [Build Fast with AI review](https://blog.buildfastwithai.com/jev-ai-review); [jev.com.tr](https://jev.com.tr/en/benchmarks/)
- Critique: comparing against an average of LLMs is circular ("if the smartest models are wrong, matching them is not a win"). The benchmark "measures how cheaply Jev agrees with frontier LLMs, not how often Jev is right" [S] — [eesel AI review](https://www.eesel.ai/blog/typesafe-jev-review); [jevaiguide benchmarks](https://jevaiguide.com/jev-benchmarks/)
- "Jev and Astra do not compete for the same call: Jev is a decision function, Astra is a generalist agent" [S] — [OrcaRouter](https://www.orcarouter.ai/blog/jev-vs-gpt-6-astra)
- LiteLLM's router benchmark: "JEV Classifier: 5.43x as fast as Haiku, 96% lower cost" (title only; details not read) [S] — [LiteLLM blog](https://docs.litellm.ai/blog/jev-auto-router-benchmark)

### Inferences
- The "400x cheaper" figure mostly reflects the pricing structure (free output, very low input price) against the output-token costs of frontier reasoning models on decomposed workflows. Realistic cost multiples against a small fast LLM (e.g. LiteLLM's ~5x faster and 96% cheaper vs Haiku) are far smaller than the headline.
- For budgeting: 1M input tokens ≈ $0.042. A 2K-token state with 5 questions costs about $0.0001 per call.

### Gaps
- The official pricing page and the enterprise/volume price list could not be verified directly. Whether signups had reopened after 22 Sept is unknown.

## 5. Performance: latency, accuracy, calibration, benchmarks (official vs independent)

### Takeaway
Official claim: **70–500 ms** per call. The only independent study I could fully read measured a single-question **p50 135.6 ms / p95 255.6 ms** (21 Sept, ~50 ms RTT) and 50 questions in 170 ms. I found no source for the "236–276 ms p50" figure in the brief; it may come from the DEV Jev-vs-Laya article, which I could not open. Accuracy on synthetic classification tasks is high (92.9%), but it depends heavily on how the question is phrased (62.6% → 95.0% on phishing when the task is decomposed). Raw probabilities are **overconfident**, especially for Choice (+15.3 pts). As of 25 Sept, TypeSafe had published **no scores on standard public benchmarks**.

### Cited Findings
**Official claims**
- "Answers all of them in one parallel pass in **70 to 500 milliseconds**" [S] — [explainx.ai](https://explainx.ai/blog/typesafe-ai-jev-system-one-models-launch-2026); [The Rundown AI](https://www.therundown.ai/news/typesafe-jev-ai-decisions-software)
- Headline calibration/hallucination claim: Jev "mathematically cannot hallucinate or produce type errors" [S] — [DataCamp](https://www.datacamp.com/blog/system-one-models-jev)
- TypeSafe "still has not published Jev's scores on standard public benchmarks (checked September 25, 2026)" [S] — [eesel AI](https://www.eesel.ai/blog/typesafe-jev-review) / [Firecrawl](https://www.firecrawl.dev/blog/what-is-jev). TypeSafe runs an evals site at evals.typesafe.ai — [AbdelStark/awesome-typesafe-jev](https://github.com/AbdelStark/awesome-typesafe-jev)

**Independent: harrymunro/jev-laya-benchmark (run 2026-09-21, Jev 1.13.0 via api.typesafe.ai, client Apple M3 Pro, ~50 ms warm RTT)** — [README](https://github.com/harrymunro/jev-laya-benchmark); [REPORT.md](https://github.com/harrymunro/jev-laya-benchmark/blob/main/REPORT.md)
- 1,470 synthetic items, 8 typed-decision tasks, 3,386 judgments per backend.
- Latency, single question: Jev **p50 135.6 ms / p95 255.6 ms**, of which about 50 ms is network. Laya 421M (local) 41.9/43.0 ms.
- 50 questions on one state: Jev **170 ms total (3.4 ms/question)** vs Laya 1,002 ms.
- Throughput: Jev 72 items/s at 32 in flight.
- Overall accuracy: **Jev 92.9%** vs Laya 65.3%. By type, Choice/Noul/Score: **99.3 / 98.6 / 76.1%**. By task: triage 90.1%, moderation 92.0%, routing 88.1%, claims 100%, reviews 83.2%, guard 94.2%. "Jev won all 19 questions with paired confidence intervals excluding zero."
- Calibration (Noul): Brier 0.002–0.024, with predicted positive rates matching gold within one point.
- Long context (needle): Jev correct at all lengths from 100 to 4,000 tokens. Multilingual (7 languages, 128 items): 100% on intent and urgency.
- Caveats: synthetic data. Residual errors cluster at **ordinal label boundaries** (Score). The suite "did not target" Jev's documented weaknesses in **counting, dates and multi-hop reasoning**.

**Independent: AnthusAI/Jev-Calibration (Jev 1.13.0)** — [GitHub](https://github.com/AnthusAI/Jev-Calibration); [Anthus blog](https://anth.us/blog/can-you-trust-jev-confidence/)
- 8,801 sentiment examples (5,280 calibration / 3,521 test).
- Raw Noul: mean confidence **79.0% vs accuracy 72.3% (+6.7 pts)**. Raw Choice: **91.4% vs 76.1% (+15.3 pts)**.
- Raw ECE **0.117** (MCE 0.265, Brier 0.162). After Platt scaling ECE 0.052. After **isotonic regression ECE 0.008**.
- Isotonic beat Platt at calibration sets from 20 to 5,280 examples. Raw ECE varied 0.064–0.160 across question wordings.
- Caveats: one constructed dataset and one model version. "Calibration is question-specific; recalibration required if wording or model changes." Probabilities are rounded to 2 decimals.

**Other independent results [S]**
- On a 2,000-email phishing set, one broad question scored **62.6%**. The same task split into five narrow questions, with weights fitted on 1,000 labelled examples, scored **95.0%** [S] — [THE D*AI*LY BRIEF (beri.net)](https://www.beri.net/article/typesafe-jev-typed-decision-model-calibration-decomposition-shadow-eval); [XenoSpectrum](https://xenospectrum.com/en/jev-typesafe-bert-classifier-decomposition/)
- An out-of-distribution calibration study on 900 synthetic support tickets measured **ECE 0.107**, 4.4x the 0.024 noise floor [S] — [prefactor.tech](https://prefactor.tech/blog/jev-calibrated-confidence-is-not-correctness) (attribution uncertain)
- JevBench, a reproducible benchmark for Jev-class models, was posted to Hacker News on **22 Sept 2026** [S] — [Benchmark Heaven JevBench](https://benchmarkheaven.com/jev-models)
- Recommended benchmark hygiene: report wall-clock p50/p95, client region, provider route, concurrency, timeouts, retries, cold starts, and whether network time was subtracted [S] — [jevtypesafeai.com benchmark (unofficial)](https://www.jevtypesafeai.com/jev/benchmark)

### Inferences
- The observed latency, roughly 135 ms p50 and 255 ms p95 from a client about 50 ms away, sits in the low part of the official 70–500 ms range. Gateway routing (Vercel/OpenRouter) and distance from US data centres (e.g. from France) will add tens of ms. A p50 of 236–276 ms from Europe or through a gateway would be plausible but is **unverified**.
- Noul (binary) is the most reliable question type. Score (ordinal) is the weakest (76.1%). Choice confidence is the most overconfident. Any threshold-based automation should first calibrate on labelled in-domain data (isotonic worked best).
- The strongest independent accuracy numbers come from synthetic, fairly easy classification tasks. There is no independent evidence yet on hard, real-world or numeric decisions.

### Gaps
- No source found for the "~236–276 ms p50" figure. I could not open the DEV Jev-vs-Laya article, which may contain it.
- There are no official public-benchmark scores (MMLU-style or classification suites). evals.typesafe.ai content was not accessible.
- No independent latency measurements from Europe were found.

## 6. Documented limitations, failure modes, terms of service, data privacy, EU/France availability

### Takeaway
"Cannot hallucinate" only means "cannot return an out-of-schema value". Jev can still return a wrong valid answer with high confidence. Documented weaknesses are arithmetic/counting, dates, multi-hop reasoning, large irrelevant state, and ordinal boundaries. The ToS, as analysed by third parties, disclaims accuracy and professional (including **financial**) advice and puts evaluation responsibility on the customer. TypeSafe says it doesn't train on customer data. The service runs in the US, EU transfers rely on SCCs, and ZDR is enterprise-only. No EU- or France-specific restriction was found.

### Cited Findings
- TypeSafe's 0% hallucination figure counts **schema violations**, which are always zero by construction. "It can't emit an invalid type, but it can still emit a wrong valid value." On Hacker News the main question was whether Jev can be "confidently wrong" [S] — [eesel AI](https://www.eesel.ai/blog/typesafe-jev-review); [OpenTweet: can Jev hallucinate](https://opentweet.io/answers/can-jev-hallucinate)
- Documented weakness "with **arithmetic and large irrelevant state**" [S] — [Layer3 Labs limits](https://www.layer3labs.io/guides/jev-limits). Also counting, dates and multi-hop reasoning — [harrymunro REPORT.md](https://github.com/harrymunro/jev-laya-benchmark/blob/main/REPORT.md)
- Guidance in the curated field guide: model answers need application-side validation and thresholds. "Measure Jev's error and abstention rates on your own cases before automating a consequential step". "Five documented failure modes" span routing, calibration, sorting and agent actions — [AbdelStark/awesome-typesafe-jev](https://github.com/AbdelStark/awesome-typesafe-jev)
- Decomposition sensitivity: accuracy swings with how the question is asked (62.6% vs 95.0%) [S] — [XenoSpectrum](https://xenospectrum.com/en/jev-typesafe-bert-classifier-decomposition/)
- ToS (as analysed by third parties; the official ToS was not accessible):
  - Content "does not constitute legal, medical, **financial**, security, or other professional advice" and is not a guarantee of model outcomes.
  - "THE SERVICES MAY PRODUCE INACCURATE OR ERRONEOUS OUTPUT"; "CUSTOMER IS RESPONSIBLE FOR INDEPENDENTLY EVALUATING THE OUTPUT."
  - No acceptable-use policy, prohibited-application list, high-risk-use ban or human-oversight requirement.
  - [S] — [Wunderland Media: TypeSafe AI Jev ToS, EU read](https://wunderlandmedia.com/typesafe-ai-jev-terms-of-service-gdpr)
- Data: TypeSafe says it does not use customer input to train its models. **Zero data retention only on the enterprise plan**, on request. The service runs in the **United States**. EU transfers rely on the **Standard Contractual Clauses** in its Data Processing Addendum [S] — [Wunderland Media](https://wunderlandmedia.com/typesafe-ai-jev-terms-of-service-gdpr); [jevaiguide ZDR FAQ](https://jevaiguide.com/faq/does-jev-train-on-your-data/)
- Third parties offer EU-hosted, zero-retention "Jev-compatible" alternative models, which implies no EU-hosted official Jev [S] — [HostYourAI](https://hostyourai.com/en/jev)
- Caution: "JEV AI Terms of Service" at jevai.me [S] ([jevai.me/terms](https://jevai.me/terms)) is **not** a TypeSafe domain and should not be taken as the official ToS.

### Inferences
- For trading use, the ToS stance means the user alone is liable for losses, and TypeSafe explicitly disclaims financial advice. No explicit trading prohibition was found. The reported lack of any AUP/prohibited-use list suggests trading is not specifically banned, but this is **unverified against the primary ToS**.
- For an individual in France: nothing indicates geo-blocking, but data goes to the US under SCCs. That matters mostly if personal data is in the state; for pure market data it is less relevant.

### Gaps
- Primary ToS/Privacy Policy/DPA text (typesafe.ai) could not be accessed. The quotes above come via third-party analysis.
- No explicit statement found on EU/France availability, AI Act positioning, or data-retention period for non-enterprise users.

## 7. Does Jev do anything specific for numerical/financial time series?

### Takeaway
No. Jev has no documented time-series, numeric or finance-specific capability. It is a text/JSON state classifier with a documented weakness in arithmetic, counting and dates. Community finance projects compute all features in code and give Jev compact, pre-computed facts to make typed judgments (regime, direction, etc.). Its outputs are model probabilities, not calibrated win rates.

### Cited Findings
- Input is text only (string/JSON), with no native numeric or time-series modality [S] — [Layer3 Labs limits](https://www.layer3labs.io/guides/jev-limits)
- Because of the arithmetic weakness, "numeric work stays in existing tools, with Jev receiving already computed facts" [S] — [search results incl. jev_stock / shipwithjev](https://www.shipwithjev.com/builds/jev-stock)
- "A response such as 'down: 0.68' is a model probability for the supplied question, not automatically a 68% historical win rate, and 'confidence: 0.52' is not a calibrated 52% chance of being correct" [S] — [sosopop/jev_stock](https://github.com/sosopop/jev_stock)
- Survey of Jev finance/trading projects (20 Sept 2026): two clusters. (a) Low-latency crypto trading that relies on the 70–500 ms latency ("not suitable for sub-50ms execution"). (b) Slower financial classification/forecasting. "Every project gives Jev only typed judgments over compact state; thresholds, risk vetoes, and order placement stay in deterministic code." — [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)
- TypeSafe's marketed use cases are games, robots, simulations, triage, scoring and guardrails. No finance-specific feature was found in official or press descriptions [S] — [MindStudio](https://www.mindstudio.ai/blog/jev-system-one-model-launch); [The Rundown AI](https://www.therundown.ai/news/typesafe-jev-ai-decisions-software)
- Independent benchmarks have not tested numeric or time-series tasks ("did not target… counting, dates") — [harrymunro REPORT.md](https://github.com/harrymunro/jev-laya-benchmark/blob/main/REPORT.md)

### Inferences
- For trading, Jev fits best as a fast semantic layer, e.g. classifying news or regime descriptions. It should sit on top of numeric features computed in code, and it should not be used as a forecaster on raw price series.
- Latency (~100–500 ms plus network) rules out HFT-style use but is fine for decisions on the scale of minutes or bars.
- Any trading use should calibrate probabilities on backtested labels (e.g. with isotonic regression, per the AnthusAI study) before using them as sizing inputs.

### Gaps
- No evidence found of any predictive skill on financial time series (independent or official). Trading bot projects are left to the other researcher.
