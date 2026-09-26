# Laya: the open-source "System 1" decision model (Convai Innovations), plus the "Layla" disambiguation

Research date: 2026-09-26. Laya is 8 days old, so everything below is a snapshot. Access notes: medium.com, dev.to, huggingface.co, news.ycombinator.com, flowtivity.ai, wilsonwu.me, eesel.ai and analyticsindiamag.com were all blocked by the network egress proxy. The primary sources I actually read are:
- the official README, which is published verbatim as the PyPI long description of `laya` 0.3.20 and read through the PyPI JSON API;
- GitHub repository metadata and issues, read through the GitHub API;
- the READMEs of community ports and of independent benchmark repos, read through raw.githubusercontent.com.

Claims that come only from search-result snippets are labelled as such.

## 1. Who built Laya, when it was released, where it lives, and its license

### Takeaway
Laya was built by Nandakishor M, founder of Convai Innovations in Kerala, India. It went public on 18 Sept 2026, three days after TypeSafe launched Jev. The weights are on Hugging Face under `convaiinnovations/laya` and the code is on GitHub at `NandhaKishorM/laya`. Everything is plain Apache 2.0: the license has no field-of-use clause and no commercial or financial restriction.

### Cited Findings
- **Developer:** the README's License section says "Apache 2.0. Developed by Convai Innovations." The PyPI package author is "Convai Innovations". — [Laya README / PyPI `laya`](https://pypi.org/project/laya/)
- **Person:** Nandakishor M, described as "a Kerala-based engineer and founder of ConvAI Innovations". *(Search snippet only; the article itself was blocked.)* — [Analytics India Magazine](https://analyticsindiamag.com/news/optimization-algorithms-neural-networks)
- The README links a Buy-Me-a-Coffee page for "nandakishorm" and a dev.to article by the author titled "I built non-autoregressive decision models a year ago, then a frontier lab called it a…". — [Laya README](https://pypi.org/project/laya/)
- **Official GitHub repo:** `NandhaKishorM/laya`, created 2026-09-18T04:46:33Z. — [GitHub](https://github.com/NandhaKishorM/laya)
- **First PyPI release:** `laya` 0.1.0 was uploaded 2026-09-18T04:38:51. There have been 28 releases since; the latest is 0.3.20, uploaded 2026-09-24. — [PyPI laya](https://pypi.org/project/laya/)
- **Relation to Jev's launch:** Laya was "released under Apache 2.0 on September 18, 2026, three days after TypeSafe AI launched Jev" *(search-result summary of secondary blogs)*. — [Mervin Praison](https://mer.vin/news/laya-the-33ms-open-source-decision-model-beating-jev/); [Zima blog](https://shop.zimaspace.com/blogs/tech-ai-hub/laya-open-source-decision-model-local-ai)
- **Jev's launch date:** TypeSafe introduced Jev on 15 Sept 2026 *(search snippet)*. — [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)
- **Pre-history claim:** the author says he began the work in April of the previous year (2025), while exploring how to detect hallucinations before an LLM finishes generating *(search snippet)*. — [Analytics India Magazine](https://analyticsindiamag.com/news/optimization-algorithms-neural-networks)
- **Hugging Face locations:**
  - Main model: `convaiinnovations/laya`.
  - Model pages for the variants: `convaiinnovations/laya-multilingual` and `convaiinnovations/laya-typed-decisions`.
  - In the SDK, the variants load as subfolders of the main repo: `laya.load("convaiinnovations/laya", subfolder="multilingual")` and `subfolder="typed-decisions"`.
  - Demo Space: `convaiinnovations/laya-demo`. There is also a Colab notebook and a docs site at nandhakishorm.github.io/laya.
  - Source for all of the above: [Laya README](https://pypi.org/project/laya/)
- **Official site:** laya.convaiinnovations.com, titled "Laya — 33ms Multilingual System 1 Decision Engine with Calibrated Probabilities" *(search result only; blocked)*. — [laya.convaiinnovations.com](https://laya.convaiinnovations.com/)
- **License file:** the repo's LICENSE is the standard "Apache License Version 2.0, January 2004" text. A grep for "financ", "trading", "prohibit", "restrict" and "acceptable use" returned 0 matches. — [LICENSE](https://github.com/NandhaKishorM/laya/blob/main/LICENSE)
- **Package metadata:** the PyPI classifier is "License :: OSI Approved :: Apache Software License" and the status is "Development Status :: 4 - Beta". — [PyPI laya](https://pypi.org/project/laya/)
- **Licenses of community ports:**
  - receptron's Node wrapper is MIT and states that "The Laya model weights are published by Convai Innovations under Apache 2.0." — [receptron/laya](https://github.com/receptron/laya)
  - laya-mlx is Apache-2.0, per the harrymunro benchmark's license note. — [harrymunro/jev-laya-benchmark](https://github.com/harrymunro/jev-laya-benchmark)

### Inferences
- Apache 2.0 allows commercial use, modification and redistribution, including in trading systems. It requires keeping the license and NOTICE, and it disclaims all warranty. I found no model-specific acceptable-use policy in the repo. The HF model card's license metadata could not be checked directly because huggingface.co was blocked.
- The public artifacts all date from 18 Sept 2026 or later, three days after Jev. The claim of work dating back a year is the author's own and is disputed on HN (see section 6).

### Gaps
- No arXiv or tech-report paper was found. The README describes the training method (RLCD) but links no paper. The dev.to post by the author could not be read.
- I could not open the HF model card itself: it may carry license metadata, a download count or likes that are not in the README.
- Convai Innovations' company size and funding are unknown.

## 2. Architecture, variants, and what "routed Laya" means

### Takeaway
Laya is a fine-tuned bidirectional encoder with a typed-decision head. It is not a generative LLM, and it answers `choice`, `score` and `noul` (yes/no) questions in one forward pass. The ~421M figure applies only to the English checkpoint, which is built on ModernBERT-large. The multilingual checkpoint is 322M (mmBERT-base). "Routed Laya" means the SDK's `Router`, which detects the script and language before inference and sends each request to the English or the multilingual checkpoint.

### Cited Findings
- **Official tagline:** "Multilingual, non-autoregressive System 1 decision engine. Typed decisions over 100+ languages in a single forward pass — 33 ms — trained with reinforcement learning against strictly proper scoring rules (RLCD), with a router that picks the right checkpoint per request." — [Laya README](https://pypi.org/project/laya/)
- **Three checkpoints:**

  | Checkpoint | Encoder | Params | Context | Use |
  |---|---|---|---|---|
  | `laya` | ModernBERT-large | 421M | 512 | English |
  | `laya-multilingual` | mmBERT-base | 322M | 1,024 (up to 8,192) | 100+ languages, 2x faster |
  | `laya-typed-decisions` | ModernBERT-large | 421M | 1,024 | Fine-tuned on the "typed-decisions" workflows |

  — [Laya README](https://pypi.org/project/laya/)
- **Question types:**
  - `choice`: a probability for each option.
  - `score`: an expected level on an ordinal rubric, plus the full distribution.
  - `noul`: a calibrated P(true).

  The input "state" can be text, an email, a ticket or a JSON document. "No text generation, so nothing to parse and nothing to hallucinate." — [Laya README](https://pypi.org/project/laya/); [receptron/laya](https://github.com/receptron/laya)
- **Internals:** the runtime is described as a bidirectional encoder, then a "decision Transformer", a scoring head and an action head. The laya-mlx port says it ports "the encoder, decision Transformer, scoring head and action head". — [laya-mlx](https://github.com/mizorewww/laya-mlx)
- The ONNX export combines "ModernBERT encoder + Laya's decision head" in one graph, plus tokenizer and calibration values. — [receptron/laya](https://github.com/receptron/laya)
- **Training (RLCD):** reinforcement learning with proper-scoring-rule rewards and a GRPO-style policy gradient, followed by calibration temperatures fitted per question type and option count. — [Laya README, Fine-Tuning](https://pypi.org/project/laya/)
- **How the Router works:**
  - It detects the script and language "in <0.5 ms pure Python before the forward pass" and sends non-English text to `laya-multilingual`.
  - Automatic routing chooses only between `english` and `multilingual`. `typed-decisions` is requested explicitly with `model="typed-decisions"`; the README also mentions an `auto_task_detection` option.
  - The lazy default keeps two checkpoints resident.
  - You can pass your own language ID with `lang_guess`.
  - Source: [Laya README](https://pypi.org/project/laya/)
- **Why routing exists:** the English checkpoint "collapses on non-Latin scripts (Khmer scores 0.000 accuracy at 0.952 confidence)". Across 51 languages it macro-averages 0.227 accuracy with a macro ECE of 0.733. — [Laya README](https://pypi.org/project/laya/)
- **Jev compatibility:** `laya.serve` exposes `POST /v1/systemone`, the same wire protocol as TypeSafe's hosted Jev API. The answer payload is "schema-identical" to Jev's, so existing Jev clients work. — [Laya README](https://pypi.org/project/laya/); [receptron/laya](https://github.com/receptron/laya)
- **Input limits:**
  - English checkpoint: `head_max_len`=192 tokens for options, about 320 tokens left for the state.
  - Multilingual and typed-decisions checkpoints: `head_max_len`=256, about 768 tokens for the state.
  - The model recommends fewer than about 20 options per `choice` question.

  — [Laya README](https://pypi.org/project/laya/); [receptron/laya](https://github.com/receptron/laya)
- **Long documents:** `laya-multilingual` reads up to 8,192 tokens with `max_len=8192`.
  - 16–18 of 20 requests were correct with up to about 4,000 tokens of text; beyond that, 8–17 of 20.
  - A 4,000-token input takes about 1.7 s (hardware cut off in the text).

  — [Laya README](https://pypi.org/project/laya/)

### Inferences
- The user's phrase "multilingual, ~421M" mixes two checkpoints. The 421M model is English-only; the multilingual model is 322M. "Routed Laya" is a software dispatcher over separate models, not a mixture-of-experts.
- Because the model is a classifier over options you define, it fits trading "gates" such as "P(bullish)?" or "does this news mention X?". It does not produce numeric forecasts or free-text reasoning.

### Gaps
- There is no parameter breakdown between the encoder and the decision head, and no disclosure of the training data mix beyond notes such as "in training mix" for AG News and BoolQ.
- The exact behaviour of `auto_task_detection` was not documented in the sections I read.

## 3. How to run it: Python, ONNX, browser, Mac, offline, and hardware

### Takeaway
You can run Laya with `pip install laya` on CPU, CUDA or Apple MPS. After the first download from Hugging Face it runs offline. There are unofficial ports for native Apple-Silicon MLX, Node/ONNX, the browser (WASM and WebGPU), Rust, Go, Zig and GGUF. On a MacBook it is practical: the MLX port measures 7–14 ms per short question on an M3 Max and 42 ms on an M3 Pro, with under 1 GB peak memory. Plain CPU gives roughly 0.2–0.5 s per request, and in-browser WASM about 1–5 s.

### Cited Findings
- **Official Python package:**
  - Install with `python -m pip install laya`; needs Python ≥3.10.
  - Dependencies: torch≥2.0, transformers≥4.48, safetensors, huggingface_hub, numpy.
  - Extras: `[serve]` (FastAPI HTTP server), `[mcp]` (MCP server), `[langchain]` and `[langgraph]`, `[onnx]` (ONNX Runtime), `[fast]` (TileLang CUDA fast path).
  - Also shipped: a CLI (`laya "text" --predict`), Docker Compose, a Nix flake and a local web GUI (`examples/server.py`).
  - `--device cuda|cpu|mps` is supported, so Apple GPUs work through PyTorch MPS. The TileLang fast path "falls back to the stock forward on CPU/MPS".
  - Source: [PyPI laya](https://pypi.org/project/laya/)
- **Offline use:** the checkpoint is downloaded from Hugging Face on first use; routing alone "works offline, no download". The mrjev.com reviewer ran it "on CPU, fully offline (`HF_HUB_OFFLINE=1`)". — [Laya README](https://pypi.org/project/laya/); [Issue #172](https://github.com/NandhaKishorM/laya/issues/172)
- **Official latency figures:**
  - T4 GPU, 1 question: 39.5 ms (`laya`) and 32.8 ms (`laya-multilingual`).
  - T4 GPU, 10 questions batched: 158.6 ms and 72.3 ms.
  - T4 GPU, 50 questions: 771 ms and 337 ms.
  - Throughput on one T4: 103–332 questions/s.
  - `Router(preload=True)`: "32.8 ms (GPU) / 193–464 ms (CPU)". The CPU model is not specified.
  - A cold checkpoint reload takes a median 7.4 s on CPU and 10.3 s on T4.
  - RTX 5060 Ti: about 10 ms per decision one at a time, about 1 ms per decision batched.
  - Source: [Laya README](https://pypi.org/project/laya/)
- **Mac: `laya-mlx`** (community, `mizorewww/laya-mlx`, "not an official Convai Innovations release"):
  - Install with `pip install laya-mlx`. Requires Apple Silicon, Python 3.11+ and macOS 14+.
  - M3 Max, FP16, one short question, p50: 13.42 ms for the 421M model and 7.39 ms for the 322M model.
  - Peak MLX memory: 943.6 MiB and 687.6 MiB.
  - 50-question throughput: 146.8 and 395.0 questions/s.
  - It matched upstream answers on 63/63 validation questions in FP32 and FP16.
  - Source: [laya-mlx](https://github.com/mizorewww/laya-mlx)
- **Independent Mac measurements:**
  - M3 Pro with laya-mlx: 42 ms p50 for a single question; each 421M MLX checkpoint is about 840 MB. — [harrymunro/jev-laya-benchmark](https://github.com/harrymunro/jev-laya-benchmark)
  - M4 Max: 7.6 ms per inference, about 700 MB first download, 30–80 s model load. — [yibie/laya-jev-lab](https://github.com/yibie/laya-jev-lab)
- **Mac: other runtimes**
  - `laya-apple` uses the MLX GPU and the Apple Neural Engine. — [Laya README, Community Tools](https://pypi.org/project/laya/)
  - `@receptron/laya` (Node ≥20, ONNX Runtime, no Python): fp32 ONNX weights of about 1.7 GB, "roughly 2 GB of RAM", and about 140 ms for 3 questions on an Apple-silicon CPU once warm. — [receptron/laya](https://github.com/receptron/laya)
- **Browser: `vishalmysore/layaForWeb`** (English checkpoint → ONNX Runtime Web):
  - WASM on CPU is the default; WebGPU is "experimental" and works only with the int4 build.
  - Builds: q8e8 about 440 MB, q4e8 about 290 MB.
  - A 3-question call takes about 2–5 s on a 2-core machine.
  - q4e8 matched PyTorch's top answer 97.9% of the time. In CI, q8e8 matched 11 of 12 questions.
  - Weights are cached in the browser's Cache Storage.
  - Source: [layaForWeb](https://github.com/vishalmysore/layaForWeb)
  - The author's Medium demo reports about 0.8–1.3 s per call on a desktop CPU *(search snippet; Medium blocked)*. — [Vishal Mysore, Medium](https://medium.com/@visrow/jev-vs-laya-live-demo-i-ran-a-421-million-parameter-ai-decision-model-inside-a-browser-tab-no-84b86bed1f10)
- **Browser: `kevala`**: a zero-dependency Rust engine compiled to WebAssembly, with WebGPU kernels. It downloads a 479 MB int8 Laya pack and runs "no model server, no API key". — [bvolpato/kevala](https://github.com/bvolpato/kevala)
- **Browser: `@r4ai/laya-web`**: ONNX Runtime Web with WebGPU and a WASM SIMD fallback. Files are about 501 MB of weights plus 393 MB of FP16 embeddings. — [r4ai/laya-web](https://github.com/r4ai/laya-web)
- **Other ports:** candle, Rust/Metal, Go ONNX, a Zig CPU runtime, GGUF via ggmlc, and Huawei Ascend. There is also a 1.58-bit ternary quantization that is 9.17x smaller at 81.2% agreement. — [GitHub search results](https://github.com/search?q=laya+decision+model&type=repositories); [Issue #37](https://github.com/NandhaKishorM/laya/issues/37); [laya-ternary-lite](https://github.com/xixi3548942758-design/laya-ternary-lite)
- **Jev-compatible local servers:** `ollaya` ("Ollama for decision models"), `1Panel-dev/laya-server`, `arbiter`, `sys1` and `laya-serve`. — [ollaya](https://github.com/ollaya-dev/ollaya); [1Panel laya-server](https://github.com/1Panel-dev/laya-server)

### Inferences
- For a trading bot on a MacBook, laya-mlx is the fastest path: about 10–40 ms per decision depending on the chip, and under 1 GB of RAM. The official PyTorch/MPS path works but has no published Mac latency. The browser is fine for demos but too slow for tick-level loops.
- A 16 GB Apple-Silicon MacBook is comfortably enough for inference. Fine-tuning is documented only on NVIDIA GPUs (see section 5).

### Gaps
- There is no official Apple-Silicon benchmark for the PyTorch MPS path.
- The CPU model behind "193–464 ms" is not stated.
- None of the MLX or browser ports are official; their fidelity relies on each port's own validation.

## 4. Performance vs Jev: the 32.8 ms claim, accuracy, calibration and their caveats

### Takeaway
The headline "32.8 ms vs Jev 236–276 ms (7.8x faster)" compares Laya's local forward pass on a T4 GPU, for the multilingual checkpoint, against Jev's hosted-API time including the network, measured by third parties. The Laya team admits it never measured Jev itself. Its accuracy "wins" over Jev rely on a checkpoint fine-tuned on the benchmark's own training split and on datasets that were in Laya's training mix. Independent head-to-heads that use zero-shot Laya find Jev clearly more accurate, with Laya about 3x faster on a single short question and slower on many-question requests.

### Cited Findings
- **Official comparison table** ("Laya (routed)" vs Jev 1.13.0):

  | Metric | Jev | Laya | Notes |
  |---|---|---|---|
  | typed-decisions | 0.727 | 0.766 | |
  | AG News | 0.910 | 0.950 | |
  | DAIR Emotion | 0.480 | 0.595 | |
  | Banking77 | 0.870 (72 labels) | 0.425 (77 labels) | Jev leads |
  | ECE | 0.246 | 0.081 | Laya's is "post-temperature" |
  | p50 latency, 1 question | 236–276 ms | 32.8 ms | "7.8× faster" |

  Cost: Jev $0.042 per 1M tokens; Laya $0 self-hosted. — [Laya README](https://pypi.org/project/laya/)
- **The authors' own caveat, verbatim:** "Jev figures are third-party published, never measured here (no TypeSafe API access), so sample sizes and prompts differ." — [Laya README](https://pypi.org/project/laya/)
- **Internal inconsistency:** the same README's speed section says Laya answers "roughly 6-7x faster", while the table says "7.8× faster". — [Laya README](https://pypi.org/project/laya/)
- **Where the Jev latency comes from:**
  - AbdelStark called Jev "as a hosted service from France" and got 236–256 ms p50 on 4- and 6-label tasks and 246 ms on 72 labels. Sample: 100 examples per condition, and the local comparator was GLiNER, not Laya. — [AbdelStark/jev-benchmarks](https://github.com/AbdelStark/jev-benchmarks)
  - nibzard measured Jev at 264–276 ms p50, "flat from 2 to 255 options". — [nibzard/decision-model-benchmark](https://github.com/nibzard/decision-model-benchmark)
- **Where Jev's accuracy and ECE come from:**
  - Jev's AG News 0.910, Banking77 0.870 and DAIR Emotion 0.480, plus the claim that Jev gave "zero probability on the true label for 16%" of DAIR examples, come from AbdelStark's n=100-per-condition pilot. — [AbdelStark/jev-benchmarks](https://github.com/AbdelStark/jev-benchmarks)
  - Jev's ECE of 0.246 comes from nibzard's forced-uncertainty suite ("jev admits on 49.7%, with the worst calibration error measured (ECE 0.246)"). — [nibzard/decision-model-benchmark](https://github.com/nibzard/decision-model-benchmark)
- **Training contamination:** in Laya's own English task table, AG News (0.947) and BoolQ are marked "in training mix". DAIR Emotion (0.573 for `laya`) is "held out". — [Laya README](https://pypi.org/project/laya/)
- **typed-decisions:**
  - The 0.766 comes from `laya-typed-decisions`, "the checkpoint fine-tuned on that benchmark's own training split".
  - The base checkpoints score 0.362 and 0.352, below the per-question majority baseline of 0.461 and near random (0.318).
  - The authors: "Laya is a fast base to specialise, not a zero-shot decision engine."
  - On the same benchmark Jev leads on soft accuracy (0.580 vs 0.471) and raw ECE (0.144 vs 0.213).
  - Source: [Laya README](https://pypi.org/project/laya/)
- **Calibration:**
  - "Both checkpoints are over-confident as shipped."
  - Refitting temperatures on held-out data moves mean ECE from 0.466 to 0.081 (`laya`) and from 0.314 to 0.106 (`laya-multilingual`).
  - "`laya-multilingual` ships with no fitted temperatures at all."
  - Source: [Laya README](https://pypi.org/project/laya/)
  - A contributor found that the committed 51-language ECE and confidence columns "no longer reproduce" after the temperature-clamp fix (#42). — [Issue #208](https://github.com/NandhaKishorM/laya/issues/208)
- **Independent head-to-head: harrymunro** (1,470 synthetic items, 3,386 judgments per backend; Laya run with laya-mlx on an M3 Pro, Jev 1.13 via API):

  | Measure | Jev | Laya |
  |---|---|---|
  | Judgments correct | 92.9% | 65.3% |
  | Choice / Noul / Score accuracy | 99.3 / 98.6 / 76.1 | 68.3 / 71.3 / 51.5 |
  | Single-question p50 | 136 ms (about 50 ms network) | 42 ms |
  | 50 questions on one state | 170 ms | 1,002 ms |

  "Jev won all 19 questions with paired confidence intervals excluding zero." Jev is faster above 3–4 questions per request and on states longer than Laya's 512-token window. — [harrymunro/jev-laya-benchmark](https://github.com/harrymunro/jev-laya-benchmark)
- **Independent head-to-head: yibie** (M4 Max, 40 Chinese support tickets):
  - Accuracy: Jev 78% at 588 ms, Laya 57% at 7.6 ms.
  - A cascade that escalates to Jev when Laya's confidence is below 0.60 matches Jev's accuracy, solves 45% of traffic locally and is about 1.8x faster.
  - Laya can be "confident-and-wrong" (0.923 confidence on a wrong label).
  - Its `noul` is "reliable for facts, useless for judgements".

  — [yibie/laya-jev-lab](https://github.com/yibie/laya-jev-lab)
- **Wider picture on Jev:** nibzard found Jev "mid-pack" on 77-way banking intent (76.3%) against constrained LLMs, and found a hard cap of 255 options. — [nibzard/decision-model-benchmark](https://github.com/nibzard/decision-model-benchmark)

### Inferences
- The latency gap is real but overstated.
  - The measurements differ in kind: a local GPU forward pass against hosted end-to-end time that includes the network.
  - The 32.8 ms is the multilingual checkpoint's T4 number. English input routes to the English checkpoint, which measures 39.5 ms (6.0–7.0x rather than 7.8x).
  - On a Mac, independent tests find about 3x (42 vs 136 ms).
  - Jev's latency depends heavily on where the client sits: 136 ms, 236–276 ms and 588 ms in the three independent measurements.
- The accuracy comparisons are not like-for-like: different samples, prompts and label counts, contaminated training sets, and ECE computed on different datasets. For zero-shot use, independent evidence favours Jev. Laya's advantage rests on fine-tuning plus temperature calibration on your own labelled data.
- For trading, Laya's shipped probabilities should not be treated as calibrated until temperatures are refit on in-domain held-out data.

### Gaps
- No independent, same-sample, same-prompt, zero-shot vs fine-tuned comparison on financial or news text exists yet.
- There is no official Mac or CPU accuracy parity report for the ports beyond their own fixtures.

## 5. Fine-tuning on custom labelled data

### Takeaway
Yes. Fine-tuning is the officially recommended path ("where most of the value is"). There is a Kaggle notebook that runs on free 2x T4 GPUs, and community tools train lightweight heads on the frozen encoder.

### Cited Findings
- **Official notebook:** `notebooks/laya_finetune_typed_decisions_2xT4_kaggle.ipynb`. It builds the dataset, trains with RLCD (proper-scoring-rule rewards, GRPO-style), fits calibration temperatures, evaluates and pushes to the Hub. It takes "roughly 4-5 hours for 4 epochs over ~30k questions" on 2x T4. — [Laya README](https://pypi.org/project/laya/)
- **Result on typed-decisions:** accuracy went from 0.362 (base) to 0.766 (fine-tuned). "All of the capability on this benchmark comes from fine-tuning." — [Laya README](https://pypi.org/project/laya/)
- **Worked example, browser-agent decision head:**
  - Hardware: a single 16 GB GPU, no paid API.
  - Element top-1 among about 45 candidates rose from 0.10 to 0.66; real-task success rose from 0% to 62%, at 17–23 ms per step.
  - Weights are at `cklxx/laya-browser`.
  - Source: [Laya README](https://pypi.org/project/laya/)
- **Community `stuntd`:** serves Laya behind the Jev API and "trains a head per decision on the frozen encoder from your own labelled rows, with a calibrated confidence threshold". On a 12-label intent task it went from 89.5% zero-shot to 100% trained. — [Laya README, Community Tools](https://pypi.org/project/laya/)
- **Community `dohnuts`:** LoRA and RLCD for small decision models. — [PsiACE/dohnuts](https://github.com/PsiACE/dohnuts)
- **Calibration caveat:** the notebook's calibration samples come from its training items, and the authors say to evaluate on separate held-out data. — [Laya README](https://pypi.org/project/laya/)
- **MLX and training:** laya-mlx is inference-only: "RLCD training and fine-tuning remain in the upstream project." — [laya-mlx](https://github.com/mizorewww/laya-mlx)

### Inferences
- A trading use case (for example labelled "bullish/bearish/neutral" news, or regime tags) would need a labelled dataset and an NVIDIA GPU (Kaggle, Colab or a cloud instance) for full RLCD fine-tuning. A frozen-encoder head like stuntd's is a cheaper option that could plausibly train on a Mac, though this is unverified.

### Gaps
- There is no documented Apple-Silicon or MLX fine-tuning path, and no guidance on the minimum dataset size.

## 6. Maturity: stars, issues, community activity, known bugs, reviews

### Takeaway
Adoption has been explosive: about 25k stars in 8 days and a large port ecosystem. The code is still very immature: 28 PyPI releases in 6 days, a "Beta" status, open correctness bugs, and benchmark numbers that contributors cannot reproduce. Reception is polarised; HN comments dispute whether the work predates Jev and describe it as "vibecoded".

### Cited Findings
- **GitHub (2026-09-26):** 25,132 stars, 2,179 forks, 164 open issues and PRs, created 2026-09-18. A search counts 117 issues, open and closed. — [GitHub NandhaKishorM/laya](https://github.com/NandhaKishorM/laya)
- **Release cadence:** 28 PyPI releases between 0.1.0 (2026-09-18) and 0.3.20 (2026-09-24). Classifier: "Development Status :: 4 - Beta". — [PyPI laya](https://pypi.org/project/laya/)
- **Ecosystem size:**
  - laya-mlx: 6,386 stars, created 2026-09-19.
  - receptron/laya: 482 stars.
  - ollaya: 275.
  - laya-playground: 159.
  - Plus dozens more: games (Snake, Doom, SMB3, T-Rex), browser agents, routers, Home Assistant and others.
  - Source: [GitHub search](https://github.com/search?q=laya+decision+model&type=repositories)
- **Known bugs and limitations, per the official "Honest limits" section and issues:**
  - [#156](https://github.com/NandhaKishorM/laya/issues/156), closed with a workaround: `noul` can follow its `true/false` or `yes/no` labels instead of the state, returning a confident "no" on clearly positive input "with confidence 1.0000".
  - [#131](https://github.com/NandhaKishorM/laya/issues/131), open: `laya-multilingual` "never selects the first-listed score option — in English too (0/290)".
  - #185: `action.act_probability` "carries no usable signal yet" (AUROC 0.30); gate on `confidence` instead (AUROC 0.77).
  - Ordinal `score` is the weakest primitive (SST-5 0.372).
  - With more than 20 options, accuracy drops sharply (Banking77 0.425).
  - Source for the list: [Laya README](https://pypi.org/project/laya/)
  - [#172](https://github.com/NandhaKishorM/laya/issues/172), closed: an independent reviewer for mrjev.com found the Router defaulting to `max_loaded=1`, which reloads on every script switch, and "Spanish and Italian route to the English model".
  - [#332](https://github.com/NandhaKishorM/laya/issues/332), open: runtime loading uses mutable `main` revisions without digest verification, a "Medium — model supply-chain integrity" issue.
  - [#208](https://github.com/NandhaKishorM/laya/issues/208), open: the 51-language ECE sweep no longer reproduces.
- **Hacker News:**
  - Nandakishor's post reached 1,231 points; "the pushback was that the concept has academic precursors and that TypeSafe's contribution was shipping a product" *(search snippet)*. — [Analytics India Magazine](https://analyticsindiamag.com/news/optimization-algorithms-neural-networks)
  - One HN comment: "And how is laya previous art? The project was vibecoded and posted yesterday." *(search-result title; HN blocked)* — [HN item 49766903](https://news.ycombinator.com/item?id=49766903)
- **Independent reviews:** see the harrymunro, yibie and AbdelStark/nibzard results in section 4. Secondary blog coverage (Flowtivity "Benchmarked Honestly", Wilson Wu, eesel, Wavect, systemonemodels.org) was found by search but could not be opened. — [Flowtivity](https://flowtivity.ai/blog/laya-open-source-jev-alternative/); [Wilson Wu](https://wilsonwu.me/en/blog/2026/jev-vs-laya/); [systemonemodels.org](https://systemonemodels.org/models/laya/)

### Inferences
- Star counts reflect hype around the Jev launch more than production readiness. The rapid releases and the open bugs in `noul`, `score` and Router behaviour mean that any trading use should pin a model revision and a package version, and should validate each question type on your own data.

### Gaps
- There is no download count from Hugging Face (blocked).
- There is no security audit beyond issue #332.
- The HN threads could not be read in full.

## 7. Laya-based trading projects (brief pointers only; covered in depth elsewhere)

### Takeaway
Several early, experimental Laya trading projects exist. All of them are paper trading or research. Laya is used only as a typed probability gate, and strategy and risk logic stay in deterministic code.

### Cited Findings
- **`antonellof/laya-trader`:**
  - Setup: paper trading with Laya MLX on crypto (Binance) and S&P 500 stocks (Yahoo Finance). It asks one `noul` question, P(bullish), about a sentence built from RSI, MACD and similar indicators, in about 15 ms on Apple Silicon.
  - Walk-forward results claimed: stocks about +10–12% against buy-and-hold at +12–18%; crypto +6% to +26% against buy-and-hold at −8% to −12%, over 9 months.
  - Leverage of 2x–3x "lost heavily in tests". "Paper trading only… Not financial advice."
  - Source: [laya-trader](https://github.com/antonellof/laya-trader)
- **Other projects:**
  - `harveybc/news-signal`: typed Laya news features for "auditable shadow-trading research".
  - `gillmoreno/openjev`: a toy trading tick.
  - `Omniaeye/omnia-trading`: market and risk assessment.
  - `antonBy77/moex-wall-trader`: MOEX order-book walls, with a Laya "AI gate A/B" in DRY_RUN.
  - Source: [GitHub search "laya trading"](https://github.com/search?q=laya+trading&type=repositories)
- **Survey of Jev finance projects:** "every project gives Jev only typed judgments (Choice/Noul/Score) over compact state; thresholds, risk vetoes, and order placement stay in deterministic code" *(search snippet)*. — [drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)

### Inferences
- The laya-trader stock results underperform buy-and-hold. The crypto results come from a single 9-month window during which buy-and-hold was negative. Treat all of this as anecdotal.

### Gaps
- There is no independent verification of any Laya trading performance.

## 8. "Layla" disambiguation: what does "JEV AI et Layla" refer to?

### Takeaway
In the context "JEV AI et Layla", "Layla" almost certainly means Laya: the open-source counterpart to Jev, which people often misspell. At least one HN commenter writes "layla the OSS version". I found no product called "Layla" connected to Jev, TypeSafe or AI trading. The existing Layla products are unrelated.

### Cited Findings
- A Hacker News comment in the Jev discussion reads: "The way I see this (I havent played around with Jev or layla the OSS version) is…" *(search-result title; HN blocked)*. — [HN item 49784949](https://news.ycombinator.com/item?id=49784949)
- A search for `"Jev" "Layla" IA trading` returned only Jev and Laya projects (jev-trader, laya-trader, laya-vs-jev, the NandhaKishorM/laya repo) and no separate "Layla" trading product. — [Search results incl. drillan gist](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150); [virajbhartiya/laya-vs-jev](https://github.com/virajbhartiya/laya-vs-jev)
- A search for "Layla AI trading bot" found no product of that name; the results were only the Layla chatbot apps and generic trading bots. — [Koinly AI trading bots list](https://koinly.io/blog/ai-trading-bots-tools/); [Layla app](https://www.layla-network.ai/)
- **Unrelated Layla products:**
  - **Layla (layla-network.ai):** a "Private Offline AI Assistant for Android & iOS". It runs local LLMs (GGUF, LiteRT-LM, ExecuTorch) and Stable Diffusion on the phone, with agents, roleplay and Live2D characters. It is a generative chat app, not a decision model, and has no Jev link. — [layla-network.ai](https://www.layla-network.ai/); [Layla features](https://blog.layla-network.ai/features); [Google Play](https://play.google.com/store/apps/details?id=com.layla)
  - **Dyldan/Layla-AI:** an "Artificial Intelligence helper bot" on GitHub, unrelated. — [GitHub Dyldan/Layla-AI](https://github.com/Dyldan/Layla-AI)
  - Coincidental noise: a YouTube video titled "Layla - by JEV Jazz trio", a music cover with no AI connection. — [YouTube](https://www.youtube.com/watch?v=macLKQwuFTg)
  - `mohamedrams777/intern_trading-laya-X-mohi-`, created Nov 2025, is an "intern projet based on the trading ai chat bot". It predates the Laya model, and "laya" there is apparently a person's name. — [GitHub](https://github.com/mohamedrams777/intern_trading-laya-X-mohi-)

### Inferences
- "JEV AI et Layla" = TypeSafe's Jev (closed, hosted) + Convai's Laya (open, local). The pairing "Jev and Laya" is ubiquitous in September 2026 coverage and repos ("laya-vs-jev", "Jev vs Laya"). An unrelated offline chatbot would not naturally be paired with Jev in a trading context.

### Gaps
- I could not confirm the user's original source for the phrase "JEV AI et Layla". If it came from a French video or post, that source would settle the question definitively.
- Other namesakes, such as game engines or companies named "Laya", were not checked.
