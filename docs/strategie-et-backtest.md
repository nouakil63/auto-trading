# La stratégie d'exemple expliquée + comment lire un backtest

> Public visé : moi, débutant total en trading. Tout terme technique est défini
> à sa première utilisation.

---

## 1. D'où vient cette stratégie ?

`user_data/strategies/SampleStrategy.py` est la **copie conforme de la stratégie
d'exemple officielle** livrée avec freqtrade (fichier `templates/sample_strategy.py`,
version 2026.5.1). Une seule modification : le *timeframe* passe de 5 minutes à
1 heure (voir plus bas pourquoi).

C'est une stratégie **pédagogique** : elle existe pour apprendre à se servir de
l'outil, pas pour gagner de l'argent. Personne ne prétend qu'elle est rentable.

---

## 2. Les concepts de base

- **Bougie (candle)** : un résumé du prix sur une période donnée — prix d'ouverture,
  plus haut, plus bas, prix de clôture, volume échangé. C'est la matière première
  de toute stratégie.
- **Timeframe** : la durée d'une bougie. En 1h, chaque bougie résume une heure de
  marché. On a choisi 1h plutôt que 5m car : moins de bruit aléatoire, moins de
  trades donc moins de frais, et plus facile à superviser sans y passer la journée.
- **Indicateur technique** : un calcul mathématique sur les bougies passées, qui
  essaie de résumer une tendance. Important : un indicateur **décrit le passé**,
  il ne prédit rien. Tout le monde voit les mêmes indicateurs que nous.

### Les trois indicateurs utilisés par la stratégie

- **RSI** (Relative Strength Index) : note de 0 à 100 qui mesure si le prix a
  beaucoup monté (proche de 100, dit « suracheté ») ou beaucoup baissé (proche de 0,
  dit « survendu ») récemment. Convention courante : sous 30 = survendu, au-dessus
  de 70 = suracheté.
- **Bandes de Bollinger** : une moyenne du prix sur 20 bougies (la « bande du
  milieu ») entourée de deux bandes qui s'écartent quand le marché s'agite. Si le
  prix est sous la bande du milieu, il est « bas » par rapport à sa moyenne récente.
- **TEMA** (Triple Exponential Moving Average) : une moyenne mobile très réactive,
  utilisée ici pour savoir si le prix est en train de remonter ou de redescendre.

---

## 3. Les règles de la stratégie, en français

**Acheter quand** (toutes les conditions en même temps) :

1. le RSI repasse **au-dessus de 30** → le prix était survendu et semble rebondir ;
2. la TEMA est **sous** la bande du milieu de Bollinger → le prix est encore bas ;
3. la TEMA **remonte** par rapport à la bougie précédente → le rebond a commencé ;
4. le volume n'est pas nul → il y a réellement des échanges.

En une phrase : *« acheter un creux qui commence à remonter »*.

**Vendre quand** (signal de sortie) :

1. le RSI repasse **au-dessus de 70** → le prix est suracheté ;
2. la TEMA est **au-dessus** de la bande du milieu → le prix est haut ;
3. la TEMA **redescend** → le sommet semble passé.

**Garde-fous automatiques** (toujours actifs, même sans signal de vente) :

- **Stop-loss à -10 %** : si un trade perd 10 %, il est coupé. C'est le plafond de
  perte par trade.
- **ROI minimal dégressif** : prise de profit automatique à +4 % immédiatement,
  +2 % après 30 minutes, +1 % après 60 minutes. Sur du timeframe 1h, en pratique :
  dès qu'un trade affiche ~+1 % après sa première bougie, il est encaissé.

⚠️ **Déséquilibre à remarquer** (on l'a vu dans le test technique) : les gains sont
plafonnés vers +1 % mais la perte max est -10 %. Un seul stop-loss efface donc ~10
petits gains. C'est pour ça qu'un taux de réussite de 90 % peut quand même perdre de
l'argent. Leçon n°1 du trading : **le taux de réussite seul ne veut rien dire**.

---

## 4. Comment lire un rapport de backtest

Un **backtest** rejoue la stratégie sur des données passées, frais inclus. Voici les
lignes du rapport à regarder en priorité, dans l'ordre :

| Métrique | Ce que c'est | Comment juger |
|---|---|---|
| `Total profit %` | Gain/perte total sur la période | Seul, ça ne suffit pas — comparer à `Market change` |
| `Market change` | Ce qu'aurait fait un simple « acheter et garder » | **Si la stratégie fait moins que ça, elle n'apporte rien** : autant acheter et ne rien faire |
| `Absolute drawdown` | La pire dégringolade du portefeuille depuis un sommet | C'est la douleur max à encaisser. >20-30 % = très dur à tenir psychologiquement |
| `Total/Daily Avg Trades` | Nombre de trades | **< ~100 trades = résultat non significatif**, c'est peut-être de la chance |
| `Win%` | Taux de trades gagnants | Piège classique : 90 % de réussite peut perdre de l'argent (voir §3) |
| `Profit factor` | Gains totaux ÷ pertes totales | < 1 = perdant. Entre 1 et 1,15 = fragile (les frais réels le mangent). Méfiance si > 2 : souvent trop beau pour être vrai |
| `Expectancy` | Gain moyen espéré par trade | Négatif = chaque trade perd en moyenne → on ne lance pas |
| `Sharpe / Sortino / Calmar` | Gain rapporté au risque pris | Plus c'est haut mieux c'est ; négatif = perdant |

### Les trois questions à se poser devant un résultat

1. **Bat-il le simple « acheter et garder » ?** Sinon, la stratégie ne sert à rien.
2. **Y a-t-il assez de trades** pour que ce ne soit pas du hasard ?
3. **Tiendrais-je le drawdown** sans paniquer et tout couper au pire moment ?

### Les pièges à ne jamais oublier

- **Un bon backtest ne garantit rien.** Le passé ne se répète pas. Un backtest sert
  surtout à **éliminer** les stratégies perdantes, pas à prouver qu'une stratégie
  gagnera.
- **Le surajustement (overfitting)** : si on règle une stratégie jusqu'à ce qu'elle
  soit parfaite sur le passé, elle a appris le passé par cœur et échouera sur le
  futur. D'où la règle : tester sur plusieurs périodes différentes (phase 2).
- **Tester une seule période favorable** (ex. uniquement un marché haussier) donne
  une illusion de compétence.

---

## 5. Verdict honnête attendu pour SampleStrategy

Sur de vraies données, cette stratégie sera très probablement **médiocre ou
perdante** — c'est normal et c'est même le but : la phase 1 sert à valider
**l'outil**, pas à trouver une stratégie gagnante. La recherche de stratégies
sérieuses, testées sur plusieurs périodes, c'est la phase 2.
