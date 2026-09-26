# Jev et Laya classent vite, sans rien prédire

Ne mets ni Jev ni Laya au cœur de ton nouveau bot. Ce sont d'excellents **classifieurs de texte rapides**, pas des prédicteurs de prix, et **aucun des tests sérieux publiés en onze jours n'a trouvé d'avantage de trading une fois les frais payés**. Jev (« JEV AI ») est le modèle de décision fermé de TypeSafe AI, lancé le 15 septembre 2026 : on lui envoie un état en texte ou JSON avec des questions typées (oui/non, choix, note sur une échelle), et il renvoie des probabilités en quelques centaines de millisecondes pour 0,042 $ le million de tokens. Le « Layla » de ta question désigne en réalité **Laya**, son équivalent open source sous Apache 2.0, publié trois jours plus tard ; il tourne gratuitement sur un Mac mais se trompe beaucoup plus sans fine-tuning (**65,3 % de bonnes réponses contre 92,9 % pour Jev** sur le même banc d'essai indépendant). Le test le plus rigoureux, mené sur le BTC en 1h avec 65 jours de données jamais vues pendant la mise au point, donne à Jev une **AUC de 0,471 à 0,503, c'est-à-dire un pile ou face**, et toutes les politiques de trading y perdent de l'argent ; côté Laya, un simple vote d'indicateurs de tendance a fait mieux que le modèle sur la crypto. Les vrais dangers pour toi sont ailleurs : des tokens « $JEV » sans lien avec TypeSafe, des sites « JEV AI » qui n'appartiennent pas à l'éditeur, des robots de trading frauduleux signalés par l'AMF, et un cadre français qui a changé le 1er juillet 2026 avec la fin du régime PSAN, **le départ de Binance** et la disparition de l'USDT des plateformes agréées MiCA. Mon conseil : reconstruis un bot à règles fixes en 1h ou 4h, sans levier, sur une plateforme agréée MiCA (Kraken, Coinbase ou Bitstamp, statut à vérifier au registre ESMA) avec des paires en EUR ou USDC. Jev ou Laya ne pourront y entrer que plus tard, comme simples observateurs dont l'apport se mesure en A/B, avant de toucher un seul euro.

*Note de lecture. « (extrait) » signale un fait tiré uniquement d'un extrait de moteur de recherche, parce que la page n'a pas pu être ouverte. « À vérifier » signale un fait qu'aucune source primaire ou officielle ne confirme. Jev a 11 jours et Laya 8 : ce rapport est un instantané au 26 septembre 2026.*

## Deux classifieurs typés : Jev se loue à 0,042 $, Laya est gratuit et ouvert

### Jev : une API fermée qui remplit des cases de décision

**Jev est un modèle de décision fermé, accessible uniquement par API.** TypeSafe AI, une start-up de San Francisco dirigée par Diogo Almeida (ex-OpenAI et Google Brain), l'a ouvert en accès anticipé le **15 septembre 2026**, le jour même où elle sortait du mode furtif avec une levée d'amorçage d'environ **40 M$ menée par DCVC** *(extrait)* ([DataCamp](https://www.datacamp.com/blog/system-one-models-jev) ; [The Rundown AI](https://www.therundown.ai/news/typesafe-jev-ai-decisions-software)). Le « créateur de ChatGPT » des titres de presse est un raccourci marketing : Almeida est co-auteur des articles InstructGPT/RLHF et GPT-4 et a contribué à ChatGPT *(extrait)* ([AI Wiki](https://aiwiki.ai/wiki/diogo_almeida)), mais le présenter comme « co-inventeur du RLHF » est exagéré.

Le principe tient en une phrase : au lieu d'écrire du texte mot à mot, Jev reçoit un « état » et une série de questions, puis remplit toutes les réponses en une seule passe. Il existe trois types de questions ([awesome-typesafe-jev](https://github.com/AbdelStark/awesome-typesafe-jev) ; [Sanity](https://www.sanity.io/glossary/noul) *(extrait)*) :

| Type | Ce qu'on demande | Ce que Jev renvoie |
|---|---|---|
| **Noul** | oui ou non | une probabilité |
| **Choice** | une option dans une liste | le gagnant, une probabilité par option et une confiance |
| **Score** | une position sur une échelle ordonnée | une valeur pondérée et la distribution complète |

En pratique, c'est un classifieur « zéro-shot » très rapide, c'est-à-dire qui répond sans avoir été entraîné sur tes exemples. Il ne rédige rien, n'explique rien et ne lit ni image ni série numérique : les prix doivent être convertis en texte, dans un budget d'environ **32 000 tokens** par requête pour l'état et les questions *(extrait ; une autre source annonce 64 000 tokens, à vérifier)* ([Layer3 Labs](https://www.layer3labs.io/guides/jev-limits)).

### Accès, SDK et prix

L'accès passe par `api.typesafe.ai`, avec un SDK officiel Python (paquet `typesafe-sdk`, client `TypeSafeClient()`, méthode `system_one()`) et un SDK TypeScript (`@typesafe-ai/sdk`). La variable d'environnement officielle est **`TYPESAFE_API_KEY`** ; le `TYPESAFE_AI_API_KEY` qu'utilisent certains bots communautaires ne marche pas avec les SDK officiels ([SDK Python TypeSafe](https://github.com/typesafe-ai/typesafe-sdk-python)). Le modèle par défaut, l'alias `jev-latest`, pointait sur **jev-1.13.0** au 20 septembre *(extrait)* ([systemonemodels.org](https://systemonemodels.org/models/jev/)), et c'est cette version que les bancs d'essai indépendants ont testée. Jev est aussi revendu par des passerelles comme OpenRouter, Vercel AI Gateway ou Netlify *(extrait)* ([OpenRouter](https://openrouter.ai/typesafe/jev-1.13)). Le SDK Python a subi deux changements incompatibles en trois jours, la 0.6.0 le 15 septembre et la 0.7.0 le 18 *(extrait)* ([Jev Wiki](https://jevwiki.ai/wiki/reference/python-sdk-changelog.md)) : tout code doit figer ses versions.

Le prix affiché est de **0,042 $ par million de tokens en entrée, la sortie étant gratuite** *(extrait)* ([OpenRouter](https://openrouter.ai/typesafe/jev-1.13)), chiffre que les bots communautaires codent en dur ([jev-trader](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/src/config.ts)). Sur les conditions d'accès, les trois sources trouvées se contredisent, et toutes sont des extraits à vérifier sur console.typesafe.ai. La première affirme qu'il n'existe ni offre gratuite ni crédit d'essai, mais une liste d'attente ([Layer3 Labs](https://www.layer3labs.io/guides/jev-pricing)). La deuxième dit que les inscriptions ont ouvert le 20 septembre avec **5 $ de crédit offert, puis ont été suspendues le 22** face à la demande ([Firecrawl](https://www.firecrawl.dev/blog/what-is-jev)). La troisième annonce une disponibilité générale depuis le 22, sans liste d'attente ([jevaiguide](https://jevaiguide.com/jev-pricing/)).

Méfie-toi du nom « JEV AI ». jevai.me, jevaiguide.com, jev.pro et jevwiki.ai ne sont pas des sites de TypeSafe, et l'organisation GitHub officielle ne renvoie qu'à typesafe.ai ([GitHub TypeSafe](https://github.com/typesafe-ai)).

### Ce que Jev ne sait pas faire

Le marketing répète que Jev « ne peut pas halluciner » *(extrait)* ([DataCamp](https://www.datacamp.com/blog/system-one-models-jev)). Cela veut seulement dire qu'il ne peut pas sortir du format prévu : il peut très bien renvoyer **une réponse valide mais fausse, avec une forte confiance** *(extrait)* ([eesel AI](https://www.eesel.ai/blog/typesafe-jev-review)). Ses faiblesses documentées sont justement celles qui comptent en trading : **l'arithmétique, le comptage, les dates, le raisonnement en plusieurs étapes**, et les états encombrés d'informations inutiles ([rapport harrymunro](https://github.com/harrymunro/jev-laya-benchmark/blob/main/REPORT.md) ; [Layer3 Labs](https://www.layer3labs.io/guides/jev-limits) *(extrait)*).

Jev n'a aucune fonction dédiée aux séries temporelles ou à la finance. Les projets financiers calculent tous leurs indicateurs dans le code et ne transmettent à Jev que des faits déjà calculés ([gist drillan](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)). Enfin, les conditions d'utilisation, connues seulement par une analyse tierce, précisent que les réponses ne constituent pas un conseil financier et que le client reste seul responsable de leur évaluation *(extrait)* ([Wunderland Media](https://wunderlandmedia.com/typesafe-ai-jev-terms-of-service-gdpr)).

### Laya : l'équivalent ouvert, publié trois jours plus tard

**« Layla » désigne en réalité Laya**, l'équivalent open source de Jev ; un commentateur de Hacker News écrit d'ailleurs « layla the OSS version » *(extrait)* ([HN](https://news.ycombinator.com/item?id=49784949)). L'application mobile Layla, un assistant de discussion hors ligne, n'a aucun rapport ([layla-network.ai](https://www.layla-network.ai/)).

Laya a été publié le **18 septembre 2026**, trois jours après Jev, par Convai Innovations, la société de Nandakishor M, un ingénieur basé au Kerala, en Inde *(extrait pour l'identité)* ([PyPI laya](https://pypi.org/project/laya/) ; [GitHub NandhaKishorM/laya](https://github.com/NandhaKishorM/laya) ; [Analytics India Magazine](https://analyticsindiamag.com/news/optimization-algorithms-neural-networks)). Le code et les poids sont sous **licence Apache 2.0 standard, sans aucune clause qui restreigne l'usage commercial ou financier** ([LICENSE](https://github.com/NandhaKishorM/laya/blob/main/LICENSE)).

Techniquement, Laya est un encodeur affiné suivi d'une tête de décision, qui répond aux trois mêmes types de questions. Le « multilingue de ~421 M » souvent cité mélange deux modèles : celui de **421 M de paramètres (ModernBERT-large) est anglophone**, le multilingue fait **322 M (mmBERT-base)**, et un « routeur » logiciel choisit l'un ou l'autre selon la langue détectée ([PyPI laya](https://pypi.org/project/laya/)). Son serveur `laya.serve` expose la même adresse `POST /v1/systemone` que Jev, avec des réponses au même format : un code écrit pour Jev passe sur Laya en changeant simplement l'URL ([PyPI laya](https://pypi.org/project/laya/) ; [receptron/laya](https://github.com/receptron/laya)).

L'installation se fait par `pip install laya` (CPU, CUDA ou Apple MPS), et le modèle tourne hors ligne après le premier téléchargement. Sur Mac, le portage communautaire laya-mlx répond en **7 à 14 ms sur une puce M3 Max, avec moins de 1 Go de mémoire** ([laya-mlx](https://github.com/mizorewww/laya-mlx)), et en 42 ms sur M3 Pro ([harrymunro](https://github.com/harrymunro/jev-laya-benchmark)). Sa grande contrainte est la taille de l'entrée : environ **320 tokens d'état** pour le modèle anglais et 768 pour le multilingue ([PyPI laya](https://pypi.org/project/laya/)). Cela suffit pour décrire une poignée d'indicateurs, pas un historique de prix.

Le projet est aussi très jeune. Il affiche 25 132 étoiles GitHub en huit jours, mais **28 versions PyPI en six jours**, un statut « Beta » et des bogues ouverts sur les questions oui/non et sur les échelles ; sur Hacker News, certains le jugent « vibecoded » ([GitHub](https://github.com/NandhaKishorM/laya) ; [HN](https://news.ycombinator.com/item?id=49766903) *(extrait)*).

### Jev et Laya côte à côte

Les sources de ce tableau sont citées dans le texte du rapport.

| Critère | Jev (TypeSafe AI) | Laya (Convai Innovations) |
|---|---|---|
| Lancement | 15 sept. 2026, accès anticipé *(extrait)* | 18 sept. 2026 (GitHub, PyPI 0.1.0) |
| Nature | Modèle fermé, API seulement, architecture non publiée | Poids ouverts : encodeur 421 M (anglais) ou 322 M (multilingue) + tête de décision |
| Licence et conditions | Propriétaire. Pas de conseil financier, client seul responsable *(extrait)*. Publication de résultats possiblement interdite (clause 2.3(f), à vérifier) | Apache 2.0, aucune restriction d'usage |
| Accès | `api.typesafe.ai`, SDK Python/TS, clé `TYPESAFE_API_KEY`, passerelles OpenRouter/Vercel. Inscriptions suspendues le 22 sept. (à vérifier) | `pip install laya`, laya-mlx sur Mac, hors ligne, serveur compatible `/v1/systemone` |
| Prix | 0,042 $/M tokens en entrée, sortie gratuite *(extrait)*. Environ 0,03 à 0,11 $/mois pour un bot 1h sur une paire | 0 $ (ta machine) |
| Taille d'entrée | Environ 32 000 tokens (64 000 selon une source, à vérifier) | Environ 320 tokens d'état (anglais), 768 (multilingue) |
| Latence mesurée | 136 ms p50 (client à ~50 ms), 236 à 276 ms depuis la France, 386 à 666 ms dans des bots réels | 42 ms (M3 Pro), 7 à 14 ms (M3 Max), 33 à 40 ms (GPU T4). Plus lent que Jev au-delà de 3 ou 4 questions par requête |
| Précision zéro-shot (même banc indépendant) | **92,9 %** | **65,3 %** |
| Calibration brute | Trop sûr de lui (Choice : +15,3 points), corrigeable par régression isotonique | Trop sûr de lui tel que livré. Le modèle multilingue est livré sans calibration |
| Personnalisation | Aucune, les mêmes poids servent tout le monde *(extrait)* | Fine-tuning officiel (Kaggle 2×T4, 4 à 5 h) : de 0,362 à 0,766 sur typed-decisions |
| Stabilité | L'alias `jev-latest` change côté serveur. Deux versions du SDK incompatibles en 3 jours | 28 versions en 6 jours. Poids figeables, mais révision `main` non vérifiée (ticket #332) |
| Confidentialité | Données envoyées aux États-Unis. Rétention nulle réservée aux entreprises *(extrait)* | Tout reste en local |
| Résultat en trading | Aucun avantage (AUC de 0,471 à 0,503 sur BTC 1h hors échantillon) | Aucun avantage (battu par un simple vote de tendance sur la crypto) |

## Les « 400× moins cher » mesurent l'accord avec GPT-6, pas la justesse

### D'où viennent les chiffres de TypeSafe

Les multiplicateurs mis en avant par TypeSafe sont **193,6× plus rapide et 444,6× moins cher** *(extrait)* ([DEV, arifulislamat](https://dev.to/arifulislamat/typesafes-jev-model-is-it-really-193x-faster-and-444x-cheaper-56oa)). Ils sortent de « workflow evaluations » écrites par l'équipe de TypeSafe elle-même, où la **« bonne réponse » est la moyenne des réponses de GPT-6 Astra et de Fable 5.1** ; TypeSafe reconnaît d'ailleurs que ses multiplicateurs sont « on the higher end », dans le haut de la fourchette réaliste *(extrait)* ([jevaiguide, benchmarks](https://jevaiguide.com/jev-benchmarks/)). Autrement dit, ces chiffres mesurent à quel point Jev est d'accord, pour pas cher, avec les grands modèles, et non à quelle fréquence il a raison *(extrait)* ([eesel AI](https://www.eesel.ai/blog/typesafe-jev-review)).

Face à un petit modèle rapide plutôt qu'à un géant, l'écart fond : LiteLLM mesure Jev **5,43× plus rapide que Claude Haiku et 96 % moins cher** *(extrait, titre seulement)* ([LiteLLM](https://docs.litellm.ai/blog/jev-auto-router-benchmark)). Au 25 septembre, TypeSafe n'avait publié **aucun score sur un banc d'essai public standard** *(extrait)* ([eesel AI](https://www.eesel.ai/blog/typesafe-jev-review)).

### Ce que mesurent les tests indépendants

Le banc d'essai indépendant le plus complet a été réalisé par harrymunro le 21 septembre, sur 1 470 cas synthétiques et environ 3 400 décisions par modèle ([harrymunro](https://github.com/harrymunro/jev-laya-benchmark) ; [rapport](https://github.com/harrymunro/jev-laya-benchmark/blob/main/REPORT.md)) :

| Mesure | Jev | Laya |
|---|---|---|
| Bonnes réponses | **92,9 %** | **65,3 %** |
| Choice / Noul / Score | 99,3 / 98,6 / 76,1 % | 68,3 / 71,3 / 51,5 % |
| Une question (p50) | 135,6 ms, dont ~50 ms de réseau | 42 ms |
| 50 questions sur le même état | 170 ms | 1 002 ms |

Jev gagne les 19 questions du test avec des écarts statistiquement significatifs. Le test a toutefois deux limites : les données sont synthétiques, et il évite justement les faiblesses connues de Jev (comptage, dates). Le résultat dépend aussi énormément de la formulation : sur 2 000 e-mails de phishing, une question large obtient **62,6 %**, alors que la même tâche découpée en cinq questions étroites atteint **95,0 %** *(extrait)* ([XenoSpectrum](https://xenospectrum.com/en/jev-typesafe-bert-classifier-decomposition/)).

### Le README de Laya et les tests indépendants se contredisent

Le README officiel de Laya affirme que Laya bat Jev : 0,950 contre 0,910 sur AG News, 0,766 contre 0,727 sur typed-decisions, et « 7,8× plus rapide » (32,8 ms contre 236–276 ms) ([PyPI laya](https://pypi.org/project/laya/)). Ce tableau ne tient pas, et le README le reconnaît lui-même en plusieurs endroits. **Les chiffres de Jev n'y ont jamais été mesurés par l'équipe de Laya**, qui écrit « no TypeSafe API access ». AG News faisait partie des données d'entraînement de Laya. Le 0,766 vient d'un modèle affiné sur la partie entraînement de ce même test, alors que les modèles de base n'obtiennent que **0,362 et 0,352, sous la simple règle de la réponse majoritaire (0,461)**. Les auteurs écrivent eux-mêmes : « Laya is a fast base to specialise, not a zero-shot decision engine » (« Laya est une base rapide à spécialiser, pas un moteur de décision zéro-shot »), et le même README parle ailleurs de « 6 à 7× plus rapide ». Enfin, les 236 à 276 ms attribués à Jev ont été mesurés par des tiers, réseau compris et depuis la France ([AbdelStark/jev-benchmarks](https://github.com/AbdelStark/jev-benchmarks) ; [nibzard](https://github.com/nibzard/decision-model-benchmark)).

Mon verdict : **sans fine-tuning, Jev est nettement plus précis**. Laya est environ 3× plus rapide pour une question courte, mais plus lent dès 3 ou 4 questions par requête ([harrymunro](https://github.com/harrymunro/jev-laya-benchmark)). Sur 40 tickets de support en chinois, Jev obtient 78 % en 588 ms et Laya 57 % en 7,6 ms, tandis qu'une cascade qui confie à Jev les cas où Laya hésite atteint la précision de Jev ([yibie](https://github.com/yibie/laya-jev-lab)).

### Calibration : un « 0,8 » ne veut pas dire « 80 % de chances »

Aucun des deux modèles n'est calibré tel que livré. Sur 8 801 exemples de sentiment, l'étude AnthusAI mesure pour les questions Noul 79,0 % de confiance moyenne pour 72,3 % de justesse, et pour les questions Choice **91,4 % de confiance pour 76,1 % de justesse**. L'erreur de calibration (ECE) de **0,117** tombe à **0,008** après une régression isotonique, mais ce recalibrage est à refaire à chaque changement de formulation ou de version du modèle ([AnthusAI](https://github.com/AnthusAI/Jev-Calibration)). Pour Laya, le README admet que « both checkpoints are over-confident as shipped » ; le modèle multilingue est même livré sans aucune calibration ([PyPI laya](https://pypi.org/project/laya/)), et certains chiffres de calibration publiés ne se reproduisent plus ([ticket #208](https://github.com/NandhaKishorM/laya/issues/208)).

Alex Molas rappelle que la calibration dépend aussi de *tes* données : il faut traiter ces sorties comme des scores et les recalibrer sur tes propres exemples *(extrait)* ([alexmolas.com](https://www.alexmolas.com/2026/09/23/jev-cant-be-calibrated.html)). Selon un autre extrait dont la source exacte est à vérifier, Jev serait le moins fiable dans la zone 0,3 à 0,8, précisément là où se placent les seuils de trading ([LMSpedia](https://lmspedia.org/jev-limitations-calibration-confidence/)). Un auteur de bot le dit en toutes lettres : « down: 0.68 » n'est pas un taux de réussite historique de 68 % ([jev_stock](https://github.com/sosopop/jev_stock/blob/81fa919795084ba942632d35c9986a1ece7162f9/README.md)). **Aucun test de calibration sur des données de marché n'existe.**

## Onze jours de bots Jev et Laya, aucun avantage mesuré après frais

### Les bots les plus populaires sont des démos pensées pour les réseaux sociaux

**jarrodwatts/jev-trader** est le modèle que copient la plupart des projets, avec environ 1 300 étoiles au 20 septembre ([gist drillan](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)). Il a été conçu pour un tweet : toutes les ~300 ms, Jev choisit « buy » ou « sell » sur la paire MON-USDC de Kuru, sur la blockchain Monad. Sa propre spécification dit « the model is not trying to be profitable » (« le modèle n'essaie pas d'être rentable ») et exclut explicitement tout backtest ([SPEC.md](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/SPEC.md) ; [CLAUDE.md](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/CLAUDE.md)). Le déploiement public fait tourner une **heuristique factice en simulation, pas Jev** ([README](https://github.com/jarrodwatts/jev-trader/blob/b587759e459ea049590102e54a0b07800864cdc3/README.md)). Une revue indépendante conclut qu'il « does not establish profitability, predictive accuracy, or readiness to trade funds » : il ne prouve ni rentabilité, ni capacité de prédiction, ni aptitude à gérer de l'argent ([AppitStudio](https://github.com/AppitStudio/awesome-jev/blob/main/community/projects/tools/jev-trader.md)).

**aowang-ai/jev-trade** porte ce modèle sur les contrats perpétuels de Hyperliquid, et c'est le plus dangereux pour un débutant. Jev y choisit le sens de la position (long ou short), l'ouverture ou la fermeture, **et même l'effet de levier, jusqu'au maximum autorisé**. Il n'y a **ni stop-loss ni plafond de position** : « sleeves no longer cap exposure », les poches ne plafonnent plus l'exposition ([commit ecf6170](https://github.com/aowang-ai/jev-trade/commit/ecf6170)). La question posée à Jev a été retouchée pour le pousser à trader davantage, avec un commit intitulé « Stop steering Jev toward hold » ([commit ad8daf1](https://github.com/aowang-ai/jev-trade/commit/ad8daf1)), et un bogue ouvrait une position longue quand la réponse était illisible ([commit d79acc8](https://github.com/aowang-ai/jev-trade/commit/d79acc8)). Le « live desk » public tourne en réalité sur le réseau de test ([llms.txt](https://github.com/aowang-ai/jev-trade/blob/a3f2f834a1b97dd42fab1193814179ac2e96d7cd/web/public/llms.txt)), et le projet ne publie aucun résultat.

### Le test le plus rigoureux trouve un pile ou face

Le backtest **egrm07** est l'étude la plus solide. Il utilise le vrai Jev 1.13.0 pour prédire si le BTC sera en hausse une heure plus tard, avec dix façons de décrire le marché et deux contrôles : un état vide, et un état qui contient la réponse. La mise au point porte sur 3 252 décisions, la validation sur 1 572 décisions jamais vues, avec 14 points de base de frais par aller-retour ([rapport egrm07](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/reports/JEV_BITCOIN_BACKTEST_2026-09-19.md)).

Sur la période de validation, **l'AUC va de 0,471 à 0,503** (0,5 correspond au hasard), et **toutes les politiques de trading perdent de l'argent** : la meilleure fait **−15,73 % quand le simple achat-conservation fait +25,55 %**. Sur la période de mise au point, Jev se trompait même légèrement dans le mauvais sens, de façon significative (AUC de 0,450 à 0,477). Le contrôle qui contient la réponse obtient une AUC de 1,000, ce qui prouve que le banc d'essai sait détecter un signal quand il existe. L'étude entière a coûté 2,58 $. L'auteur ajoute un avertissement de fond : Jev a presque certainement vu l'historique du BTC pendant son entraînement, donc **seul un test sur des données futures est propre** ([README egrm07](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/README.md)).

### Jev lit bien les nouvelles, mais le marché les a déjà intégrées

Le projet **Spykoninho/trading-bot-jev**, documenté en français, teste le vrai Jev comme lecteur d'actualités posé sur une règle de tendance en 4h (moyenne mobile EMA200, BTC/ETH/SOL sur Bitvavo) ([README Spykoninho](https://github.com/Spykoninho/trading-bot-jev/blob/8d36bd257eec204fe6749b277a49e903b368b594/README.md)) :

| Variante | Rendement |
|---|---|
| Règle seule | **+84,9 %** |
| Règle + Jev | **+82,1 %** |
| Achat-conservation | −2,5 % |

Mesuré trois fois, l'écart dû à Jev vaut −2,8, −2,1 puis +4,9 points. L'auteur conclut : « **Jev n'apporte rien de mesurable sur les prix** […] le signe change, c'est du bruit. » Son étude d'événements sur 1 201 titres d'actualité importants donne la clé : il reste +0,032 % une heure après la publication, « loin sous les frais ». Jev a classé sans erreur les 25 décisions de taux de la Fed, « mais le prix les avait déjà intégrées » ([design.md](https://github.com/Spykoninho/trading-bot-jev/blob/8d36bd257eec204fe6749b277a49e903b368b594/docs/design.md)). Attention aussi à la règle de tendance elle-même : avec 23,5 % de trades gagnants et **5 trades qui font 206 % du gain total**, ce +84,9 % reste fragile.

**Waxmell114514/jev-trade** arrive au même constat par trois chemins ([README Waxmell](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)). En tenue de marché simulée, **une simple règle par mots-clés bat Jev** (8 820 contre 5 829). Sur de vraies dépêches crypto, « a headline arriving into a quiet tape predicts nothing » : un titre qui tombe sur un marché calme ne prédit rien. Sur 17 ans de textes de la Fed, Jev gagne **+2 ± 2 points de base à 15 minutes**, ce qui n'a rien de significatif.

### Laya ne fait pas mieux

Sur le projet **antonellof/laya-trader**, les notes de recherche rapportent deux lectures différentes. Selon un résumé, le projet annonce de +6 % à +26 % sur la crypto en 9 mois, face à un achat-conservation de −8 % à −12 %. Mais la comparaison à stratégie fixe du même dépôt donne un tout autre tableau ([README laya-trader](https://github.com/antonellof/laya-trader/blob/5bb45d00fe17b1d2a1a395ddb71d72adef4c5c04/README.md) ; [RESEARCH.md](https://github.com/antonellof/laya-trader/blob/5bb45d00fe17b1d2a1a395ddb71d72adef4c5c04/docs/RESEARCH.md)) :

| Variante (crypto, 9 mois) | Rendement |
|---|---|
| Signal Laya | **+0,5 %** |
| Même structure, simples votes d'indicateurs de tendance | **+8,6 %** |
| Achat-conservation | −8,7 % |

L'auteur écrit lui-même « On crypto, the plain trend votes did better than Laya » (sur la crypto, les simples votes de tendance ont fait mieux que Laya), et le reste du dépôt va dans le même sens. Le pouvoir prédictif du signal change de signe d'une période à l'autre (−0,14 puis +0,09). Sur les 30 derniers jours, le bot fait **−3,7 % contre +13,1 %** pour l'achat-conservation. Un levier de 2× ou 3× a fait perdre **17 à 35 %**, et en bougies de 15 minutes, les frais ont mangé environ un quart du capital chaque mois.

### Les autres projets et les chiffres mal relayés

Les autres projets confirment la tendance. **sosopop/jev_stock**, qui prédit trois classes (hausse, stable, baisse) pour des actions de Hong Kong, fait 45,0 % sur 120 cas, sans comparaison avec la classe majoritaire ([jev_stock](https://github.com/sosopop/jev_stock/blob/81fa919795084ba942632d35c9986a1ece7162f9/README.md)). **nighomni123/trading-bot**, qui avait fixé ses critères d'arrêt à l'avance, atteint 55,8 % de trades gagnants mais **−0,35 % net**, avec ce verdict : « edge does not survive costs → STOP » (l'avantage ne survit pas aux frais, on arrête) ([plan nighomni123](https://github.com/nighomni123/trading-bot/blob/86ad6b02870ca7258b9239cedee6c38cd4cbf94a/IMPLEMENTATION_PLAN.md)). Sur TradeRank, aucun actif n'a franchi le seuil de 0,80 fixé pour Jev *(extrait)* ([TradeRank](https://www.traderank.ai/blog/what-is-jev-typesafe)), et un bot BTC testé par MindStudio « wasn't performing well in its first hour » *(extrait)* ([MindStudio](https://www.mindstudio.ai/blog/jev-use-cases-automation)).

Méfie-toi aussi des chiffres qui circulent. Un article DEV titre sur un « 67,8 % de réussite » de Jev *(extrait)* ([DEV, tank_wang](https://dev.to/tank_wang/jev-decoded-678-hit-rate-still-lost-money-what-real-quant-backtests-show-oc2)). Or la source primaire attribue ce chiffre à un **modèle factice** tournant sur des données synthétiques où un avantage avait été planté exprès. Même ce 67,8 % perdait de l'argent, car « No amount of predictive accuracy survives costs that exceed the edge » : aucune précision ne survit à des frais supérieurs à l'avantage ([Waxmell](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)).

### Pourquoi si peu de résultats publiés, et aucune intégration freqtrade

Un projet affirme que le contrat client de TypeSafe (clause 2.3(f)) **interdit de publier des performances** ([jevbot](https://github.com/tyleree/jevbot/blob/9dd505192dff821b00ae2a8880bd9d4b2b5bf655/README.md) ; à vérifier sur le texte officiel). Un extrait prétend par ailleurs qu'aucun banc d'essai indépendant de Jev n'existe ([Layer3 Labs](https://www.layer3labs.io/guides/jev-benchmarks)) : c'est **faux**, puisque les dépôts GitHub cités plus haut en publient. Aucune intégration freqtrade ou FreqAI n'a été trouvée ([recherche GitHub](https://github.com/search?q=freqtrade+typesafe+jev&type=code)). Tous les projets suivent le même schéma, « Jev judges, code executes » (Jev juge, le code exécute), avec la simulation comme mode par défaut ([gist drillan](https://gist.github.com/drillan/6916b16e8ea31a8ec36c8f59d6483150)).

## Les vrais dangers : mémecoins « $JEV », faux services et fin du régime PSAN

### La hype a déjà fabriqué ses tokens

La presse crypto a transformé Jev en « narratif » d'investissement : TechFlow recense plus de 20 cas d'usage, des actifs « narratifs » et « près de 500 » projets open source *(extrait)* ([TechFlow](https://www.techflowpost.com/en-US/article/34173)). Plusieurs tokens surfent déjà sur le nom, tous connus par extraits. **JevBall** promet qu'un « JEV » gérerait un coffre alimenté par des taxes. **$JEVONS** promet un accès à des actions tokenisées NVDA et GOOGL, ce qui poserait probablement un problème au regard de la réglementation MiFID II (à vérifier). **JevPad** est un launchpad qui prélève 2 % de taxe sur chaque token lancé. Un **$JEV sur Solana** promet enfin les « picks » de Jev sur Telegram à qui détient 100 000 tokens ([jevonsol.com](https://www.jevonsol.com/)).

Un token $JEV a été relevé à **environ 11 354 $ de capitalisation**, à une date inconnue *(extrait)* ([Solana Compass](https://solanacompass.com/tokens/9qv5QVqdqcChSq77mhwgiQvwxyj518yEMmaAbjNFtaMa)). Surtout, **plusieurs contrats différents portent le même ticker « JEV »** ([Coinbase, page 1](https://www.coinbase.com/price/jev-solana-belnp2csawfhgr9prt2buoiktwypegymmancrwp6tgb-token) ; [Coinbase, page 2](https://www.coinbase.com/price/jev-solana-e7e8ca4f)). Aucun démenti de TypeSafe n'a été trouvé. Retiens une règle simple : **TypeSafe vend une API, pas un token**, donc tout « $JEV » est sans rapport avec le modèle.

### Les arnaques habituelles, adaptées à Jev

Les schémas classiques s'appliquent tels quels. L'AMF met en garde contre les robots de trading qui promettent **5 à 15 % par mois**, vendent des licences et renvoient vers des courtiers non autorisés *(extrait)* ([AMF](https://www.amf-france.org/en/news-publications/news-releases/amf-warns-public-about-fraudulent-investment-offers-through-trading-robots)). De faux bots Telegram réclament ta phrase de récupération (seed phrase) ([Kaspersky](https://www.kaspersky.com/blog/phishing-and-scam-in-telegram-2025/54090/)). La suspension des inscriptions du 22 septembre crée une rareté idéale pour vendre de fausses « clés Jev », même si aucun cas documenté n'a été trouvé à ce jour.

Deux autres signaux d'alarme méritent d'être connus. Un dépôt public automatise la création de comptes TypeSafe pour un « unlimited jev » ([typesafe_register](https://github.com/Futureppo/typesafe_register)) : c'est un abus des conditions d'utilisation, à ne pas utiliser. Et les forks quasi identiques de jev-trade se multiplient ([pozivo/jev-trade](https://github.com/pozivo/jev-trade)) : ne lance jamais l'un d'eux avec une vraie clé privée sans avoir lu tout son code.

### Avec Jev, ta stratégie part aux États-Unis ; avec Laya, elle reste chez toi

TypeSafe dit ne pas entraîner Jev sur les requêtes de ses clients (« the same weights serve every account », les mêmes poids servent tous les comptes). Mais la **rétention nulle des données est réservée aux clients entreprise**, le service tourne aux États-Unis, et les transferts depuis l'UE reposent sur des clauses contractuelles types *(extraits, à vérifier)* ([TypeSafe docs](https://docs.typesafe.ai/models) ; [Wunderland Media](https://wunderlandmedia.com/typesafe-ai-jev-terms-of-service-gdpr)). Si tu passes par OpenRouter ou Vercel, leurs propres règles de conservation s'ajoutent ([Vercel](https://vercel.com/changelog/typesafe-ai-jev-now-available-on-ai-gateway)).

Pour de simples données de marché, la confidentialité compte moins que la dépendance : un alias de version qui change sans prévenir, des inscriptions suspendues, ou un crédit épuisé. Dans ce dernier cas, jev-trade reçoit une erreur HTTP 402 et met Jev en pause ([commit 4a95655](https://github.com/aowang-ai/jev-trade/commit/4a95655)). Laya en local supprime ce risque, à condition de figer la révision exacte des poids, car le chargement par défaut pointe sur une branche modifiable sans vérification d'empreinte ([ticket #332](https://github.com/NandhaKishorM/laya/issues/332)).

### Depuis le 1er juillet 2026, Binance et l'USDT sortent du périmètre protégé

Toute cette section repose sur des extraits de recherche : le registre ESMA, l'AMF et impots.gouv n'ont pas pu être consultés directement.

Depuis le **1er juillet 2026**, seuls les prestataires agréés MiCA (PSCA, ou CASP en anglais) peuvent servir des clients en France, et les PSAN non agréés ont été radiés le 2 juillet ([AMF](https://www.amf-france.org/en/news-publications/news/end-mica-transitional-period-esma-sets-out-its-expectations-professionals-and-warns-retail-investors) ; [Village de la Justice](https://www.village-justice.com/articles/psan-mica-que-faire-avant-fin-periode-transitoire-1er-juillet-2026,57455.html) ; à vérifier sur la [liste AMF des radiations](https://www.amf-france.org/en/professionals/fintech/my-relations-amf/crypto-asset-service-provider-casp/list-dasps-delisted)). Binance a retiré sa demande d'agrément MiCA en Grèce le 24 juin, puis a écrit à ses clients français qu'il cesserait ses services en France au 1er juillet ([Euronews](https://www.euronews.com/business/2026/06/25/binance-to-halt-crypto-services-across-eu-countries-after-failing-to-secure-mica-approval) ; [CoinDesk](https://www.coindesk.com/policy/2026/06/26/binance-tells-eu-users-it-will-no-longer-provide-services-after-failing-to-secure-mica-license)). Une éventuelle demande d'agrément en France est évoquée mais reste à vérifier ([CASP Tracker](https://casptracker.eu/exchange/binance/)).

Kraken (agréé en Irlande), Coinbase et Bitstamp (agréés au Luxembourg) seraient agréés MiCA ([Tangem](https://tangem.com/en/learning-hub/post/is-kraken-mica-licensed/) ; [Paybis](https://paybis.com/blog/mica-licensed-crypto-exchanges/)), ce qui reste à vérifier au registre ESMA ; la date de « juin 2026 » avancée pour Coinbase est douteuse. **L'USDT n'est plus négociable pour les résidents de l'EEE sur ces plateformes** ([The Block](https://www.theblock.co/post/344182/binance-delist-tether-other-non-mica-compliant-stablecoins) ; [Eco](https://eco.com/support/en/articles/14796311-why-usdt-is-restricted-in-eu)), si bien que la paire BTC/USDT de ton ancien projet n'a plus de sens.

Hyperliquid et Kuru, les places qu'utilisent presque tous les bots Jev publics, fonctionnent sans vérification d'identité (KYC), hors supervision de l'AMF et **sans aucun recours** ([Cryptoactu](https://cryptoactu.com/avis/hyperliquid/)). Les sources se contredisent sur l'accès depuis la France. Les conditions d'utilisation de Hyperliquid n'excluent que les États-Unis, l'Ontario et les pays sous sanctions ([Hyperliquid Terms](https://app.hyperliquid.xyz/terms)), alors que des agrégateurs affirment que la France et l'UE sont exclues ([CoinPerps](https://www.coinperps.com/learn/hyperliquid-restricted-countries) ; [Datawallet](https://www.datawallet.com/crypto/hyperliquid-supported-and-restricted-countries)). C'est à vérifier ; pour Kuru, aucune condition d'utilisation n'a été trouvée.

### L'impôt prend 31,4 % d'un gain déjà improbable

Le prélèvement forfaitaire unique (PFU) serait passé à **31,4 %** en 2026, soit 12,8 % d'impôt sur le revenu et 18,6 % de prélèvements sociaux ([Ramify](https://www.ramify.fr/crypto/fiscalite) ; [MoneyVox](https://www.moneyvox.fr/impot/actualites/106566/impots-2026-pourquoi-vos-cryptos-risquent-etre-encore-plus-taxees) ; à vérifier sur impots.gouv.fr). Selon les règles de base, toutes à vérifier, l'impôt se déclenche au passage en euros ou lors d'un achat de bien ou de service, les échanges d'une crypto contre une autre ne sont pas imposés, et les cessions de 305 € par an ou moins sont exonérées. Il faut remplir le formulaire **2086** pour les cessions et le **3916-bis** pour chaque compte ouvert sur une plateforme étrangère ([Waltio](https://www.waltio.com/fr/tout-savoir-sur-la-fiscalite-crypto/) ; [article 150 VH bis du CGI](https://www.legifrance.gouv.fr/codes/id/LEGISCTA000050366754/2026-07-01)).

Il n'existe aucune doctrine officielle sur les perpétuels DeFi ([Calcunet](https://calcunet.fr/articles/defi-yield-farming-fiscalite-france-2026/)). Un bot qui passe des centaines d'ordres complique fortement le calcul du prix d'acquisition, et le risque d'une requalification en revenus professionnels (BNC) pour un trading automatisé habituel reste à vérifier.

## Reconstruire le bot : des règles d'abord, l'IA en observateur, des preuves avant le premier euro

### Quel rôle pour Jev et Laya ? Aucun dans la première version

Dans chaque test indépendant, la règle seule a égalé ou battu la version augmentée par Jev ou Laya (Spykoninho, laya-trader, nighomni123). Ce qui a amélioré les résultats, c'est la structure : un filtre de tendance, des bougies 1h ou 4h, des frais faibles, un levier de 1×.

Pour un débutant, la ressource rare n'est pas l'argent de l'API mais l'attention. Chaque heure passée à reformuler une question pour Jev ajoute un essai de plus, donc un risque de surapprentissage du backtest : plus on teste de variantes, plus la meilleure a de chances d'être un faux positif ([Bailey et López de Prado, Deflated Sharpe Ratio](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2460551) ; [probabilité de surapprentissage](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2326253)). La sensibilité de Jev à la formulation aggrave encore ce problème. Sur deux décennies et plus de 100 actifs, les avantages rapportés pour les stratégies à base de LLM « deteriorate significantly », ils se dégradent nettement *(extrait)* ([FINSABER, arXiv](https://arxiv.org/abs/2505.07078)).

### Si tu veux quand même expérimenter, plus tard

Si ta curiosité l'emporte, en phase 2 ou plus tard, utilise le **mode « observateur » (shadow)**. La stratégie à règles décide seule. Pour chaque signal, tu enregistres le verdict du modèle sans jamais agir dessus, par exemple avec une question Noul du type « ce contexte est-il défavorable à un achat ? ». Après plusieurs mois, tu compares la performance des trades que le modèle aurait bloqués à celle des trades qu'il aurait laissés passer, selon un critère de réussite écrit à l'avance, comme l'a fait nighomni123. Dans freqtrade, l'endroit naturel pour un tel veto serait `confirm_trade_entry` ; personne ne l'a encore publié.

Le choix entre les deux modèles est un compromis. **Jev** est bien meilleur sans entraînement et ne coûte presque rien à cette cadence : d'après les tokens mesurés par egrm07 et Waxmell (1 050 à 3 600 par décision), un bot 1h sur une paire consomme environ 0,03 à 0,11 $ par mois, selon mon calcul ([egrm07](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/reports/JEV_BITCOIN_BACKTEST_2026-09-19.md) ; [Waxmell](https://github.com/Waxmell114514/jev-trade/blob/daec9777deb407eca10f45c8e62e596ad1ef3c71/README.md)). Il faut alors figer une version précise, comme `jev-1.13` sur OpenRouter *(extrait)*, plutôt que `jev-latest`. **Laya** est gratuit, privé et figeable, mais il se trompe souvent sans entraînement et n'accepte qu'environ 320 tokens d'état. Pour qu'il soit utile, il faudrait un jeu de données étiqueté et un fine-tuning sur carte graphique NVIDIA ; le notebook officiel prend 4 à 5 heures sur deux T4 gratuites de Kaggle ([PyPI laya](https://pypi.org/project/laya/)).

Dans les deux cas, garde trois règles. Recalibre les probabilités par régression isotonique sur tes propres résultats avant de fixer un seuil ([AnthusAI](https://github.com/AnthusAI/Jev-Calibration)). Ne confie jamais au modèle la taille de position ni le levier. Et écris ton code pour le protocole `/v1/systemone` plutôt que pour un fournisseur, afin de pouvoir passer de l'un à l'autre en changeant une URL. L'espérance de ce projet est pédagogique, pas financière.

### Le choix de l'exchange

Ton ancienne configuration (Binance, BTC/USDT) est à abandonner, même pour la simulation, car ton backtest doit utiliser les données de la plateforme et de la devise sur lesquelles tu passeras réellement tes ordres. Choisis une plateforme agréée MiCA, Kraken, Coinbase ou Bitstamp, après vérification au registre ESMA et après avoir vérifié que ta bibliothèque de connexion la prend en charge. Utilise des paires **BTC/EUR ou BTC/USDC**, en **spot uniquement**, et garde les règles de ton ancien README : clé API sans droit de retrait, kill switch testé.

Évite Hyperliquid, Kuru et les DEX Solana pour un premier bot. Tu n'y aurais aucun recours en cas de problème, des passerelles (bridges) entre blockchains à gérer et une fiscalité floue ; et le levier au-delà de 1× a détruit les résultats de laya-trader. Vérifie enfin la grille de frais taker/maker : c'est elle, et non le coût de l'IA, qui décidera de ton résultat.

### Ce qu'il faut prouver avant le premier euro

Chaque étape doit être validée avant de passer à la suivante :

| Étape | Ce qu'il faut démontrer | Ce qui doit tout arrêter |
|---|---|---|
| 1. Banc d'essai | Il détecte un signal planté (contrôle « réponse incluse ») et donne le hasard sans données (contrôle « vide »), comme chez egrm07 | Un contrôle vide qui « gagne » : le banc d'essai ment |
| 2. Stratégie seule | Elle bat l'achat-conservation et une règle naïve sur une période jamais utilisée pour la mise au point, avec des frais et un glissement réalistes (au moins 14 points de base par aller-retour) | Une perte ou une sous-performance après frais |
| 3. Robustesse | Le gain garde le même signe sur plusieurs fenêtres successives (walk-forward), le nombre de variantes testées est noté, et le gain ne dépend pas de 5 trades | Un effet dont le signe change d'une fenêtre à l'autre |
| 4. Simulation prolongée | Plusieurs mois de dry-run sur la plateforme cible, avec un écart faible entre simulation et backtest | Une divergence persistante |
| 5. Module IA (facultatif) | La version « stratégie + veto » fait mieux que la stratégie seule sur des données futures, avec un modèle et une formulation figés et des probabilités recalibrées | Un écart de signe instable (cas Spykoninho) |
| 6. Garde-fous | Plafond de perte journalière, taille maximale et kill switch testés ; levier de 1× ; clé API sans droit de retrait | Toute protection non testée |
| 7. Après impôt | Une espérance positive après PFU, avec le suivi des formulaires 2086 et 3916-bis en place | Un gain net nul ou négatif |

Pourquoi des mois de simulation ? Avec 3 252 décisions, egrm07 calcule qu'un ratio de Sharpe inférieur à environ 3,28 reste indiscernable de la chance ([egrm07](https://github.com/egrm07/jev_bitcoin_backtest/blob/5d8e6d0450090c786b5c2d8aac3c3a643631ab4a/reports/JEV_BITCOIN_BACKTEST_2026-09-19.md)). Un bot 1h a besoin de beaucoup de temps pour produire assez de décisions et sortir du bruit.

## Conclusion

Le vrai talent de Jev, c'est la lecture : les 25 décisions de la Fed classées sans erreur, 97 % de précision sur les dépêches importantes. Ce talent bute sur un mur que la technologie ne franchira pas : **quand un texte public est lisible par un particulier, le prix a déjà bougé**. Jev est rapide *par rapport aux LLM*, pas *par rapport au marché*, où les professionnels réagissent en quelques dizaines de microsecondes sur les places les plus liquides *(extrait)* ([Budish, Cramton et Shim](https://academic.oup.com/qje/article/130/4/1547/1916146)). Un autre constat pèse lourd : une décision coûte presque rien, des centaines de dépôts existent, et pourtant aucun bénéfice vérifiable n'a été publié. Cette absence est déjà une information.

Ce que cet écosystème offre de plus utile à un débutant, ce n'est pas un modèle mais une méthode. Le banc d'essai d'egrm07, avec ses contrôles « vide » et « réponse incluse », et les critères d'arrêt fixés à l'avance par nighomni123 valent plus que Jev ou Laya pour ta reconstruction. Et comme Jev et Laya parlent le même protocole, les essayer plus tard coûtera une URL et quelques centimes. Rien ne presse : construis d'abord le banc d'essai qui saura te dire, le jour venu, qu'ils n'apportent rien.
