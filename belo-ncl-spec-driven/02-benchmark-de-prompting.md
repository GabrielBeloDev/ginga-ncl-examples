# Benchmark de Técnicas de Prompting para Geração de NCL

> **O que é este documento.** O desenho experimental (protocolo, matriz, métricas e ameaças à
> validade) para medir, de forma reprodutível, **quanto cada técnica de prompting reduz o "gap
> semântico"** entre a *intenção* do autor e o *código NCL* gerado por um LLM.
>
> **De onde ele parte.** Do piloto `10menu` (n=1, 3 níveis de intenção B→C→A), documentado em
> [`experimento-1-piloto-10menu/RESULTADO.md`](experimento-1-piloto-10menu/RESULTADO.md). O piloto mostrou que **mais
> estrutura na descrição → mais fidelidade**, e que uma **etapa de validação/correção** é necessária
> (o nível A/C só carregou depois de corrigir 1 atributo). Este benchmark generaliza aquele achado de
> um exemplo para uma avaliação com sinal estatístico.
>
> **Para onde ele vai.** Position/WIP paper (WebMedia). O objetivo não é um leaderboard de modelos, e
> sim **isolar o efeito da técnica de prompting** (com destaque para o fluxo *spec-driven + elicitação
> por perguntas* aprovado pelo orientador).

---

## 0. Hipóteses e perguntas de pesquisa

**Hipótese central (H1).** Técnicas que injetam estrutura antes de gerar o código — regras
*spec-driven* (spec-kit no system prompt) e **elicitação da spec por perguntas dirigidas** — produzem
NCL com **fidelidade maior ao gabarito** do que um prompt vago (zero-shot "de boa").

**Hipóteses secundárias.**

- **H2 (elicitação ≈ escrever a spec).** Elicitar a spec por **perguntas dirigidas** rende fidelidade
  comparável a entregar a spec completa de cara (nível A), com **menos esforço do usuário** — a
  diferença-chave em relação a "prompt → caixa-preta → NCL".
- **H3 (validação).** Uma etapa de **validação/correção automática** (rodar no Ginga + checar
  *pitfalls*) é **necessária**: recupera gerações que o parser estrito do Ginga abortaria por 1
  atributo — os erros sintáticos como o `transparency` (exatamente o caso C/A do piloto).
- **H4 (few-shot ancora sintaxe).** Exemplos `prompt→NCL` reduzem erros de **sintaxe/perfil** (validade
  técnica) mais do que aumentam fidelidade estrutural.

**Perguntas de pesquisa.**

- **RQ1.** Qual o ganho de **Fidelity Score** de cada técnica sobre a baseline zero-shot?
- **RQ2.** As **perguntas de esclarecimento** geradas pelo agente são relevantes, cobrem o que o
  gabarito precisa e são mínimas? (qualidade da elicitação)
- **RQ3.** Quantas **rodadas** até convergir e a que **custo** (tokens) por técnica?
- **RQ4.** O efeito da técnica **se sustenta** entre apps de complexidade e natureza diferentes
  (NCL declarativo puro vs. NCLua)?

---

## 1. Taxonomia das técnicas a comparar

Cada técnica é descrita **no contexto de gerar NCL** e com a justificativa de por que entra no
benchmark. A **variável independente principal** é *qual técnica* está em uso (ver §2). Da **T1** em
diante todas recebem a **mesma descrição de intenção do usuário** (um *brief* fixo, nível
"estruturado/C" — realista, ambíguo o bastante para dar espaço à elicitação), variando apenas o
*andaime* (exemplos, regras, perguntas, votação); a **T0** usa de propósito um *brief* **vago
("porco")**, para servir de piso. A etapa de **validação/correção no Ginga** (H3) é um **estágio
ortogonal do pipeline** (§4.6) aplicado sobre qualquer técnica, não um código de prompting à parte.

| ID | Técnica | O que muda no prompt |
|----|---------|----------------------|
| **T0** | Baseline vago ("porco") | *brief* vago; nenhum exemplo, nenhuma regra |
| **T1** | Zero-shot estruturado | *brief* estruturado; **sem** exemplos, **sem** spec-kit |
| **T2** | One-shot | brief + **1** par `prompt→NCL` |
| **T3** | Few-shot (k=3) | brief + **k** pares `prompt→NCL` |
| **T4** | Chain-of-thought / raciocínio explícito | brief + instrução para **planejar antes** (mídias→regiões→linha do tempo→interações→código) |
| **T5** | Spec-kit / rule-augmented (**SEM** elicitação) | **system prompt = spec-kit** (regras + template de plano) + brief |
| **T6** | Spec-kit + elicitação (**o fluxo do paper**) | spec-kit **elicitando** a spec por perguntas; um oráculo responde |
| **T7** | Few-shot + spec-kit + elicitação | pipeline com exemplos + regras + perguntas |
| **T8** | Self-consistency (votação de N) | qualquer técnica-base, mas **N gerações** e seleção/consenso |

### 1.1 Descrição e motivação de cada uma

- **T0 — Baseline vago ("porco").** O usuário só descreve a intenção de forma vaga; o LLM gera direto.
  **Baseline honesta**: é o que a maioria das pessoas faria correndo. No piloto, o nível B *rodou* mas
  **inventou o app** (3 janelas, propaganda aos 8s em vez de 45s, 0 switches). Serve de piso: todo
  ganho das outras técnicas se mede contra ele.

- **T1 — Zero-shot estruturado.** Sem exemplos e sem spec-kit, mas com a intenção já **estruturada** (o
  brief C). Mede o efeito da **estrutura da intenção sozinha** (H1) — é o análogo dos níveis C/A do
  piloto sem nenhum andaime adicional.

- **T2 — One-shot.** Um único exemplo `descrição→NCL` (de outro app, para não vazar o gabarito). Mostra
  ao modelo **a forma esperada** (perfil EDTV, regiões/descritores/conectores/elos). Motivação:
  quantificar o quanto **um só** exemplo já corrige erros de sintaxe/perfil.

- **T3 — Few-shot (k exemplos).** k pares `descrição→NCL` cobrindo padrões distintos (sincronismo por
  âncora, `switch`, menu por foco, transição). Motivação: NCL tem **idiomas recorrentes** (âncora
  `<area>` → `<link onBegin start>`, anel `focusIndex/moveLeft/moveRight`); exemplos ancoram esses
  idiomas. Hipótese H4: melhora **validade técnica** mais que fidelidade estrutural.

- **T4 — Chain-of-thought / raciocínio explícito.** O modelo primeiro **planeja** (lista mídias e
  papéis, deriva regiões e a linha do tempo, mapeia teclas→efeitos) e só então escreve o NCL. Como
  NCL é um grafo temporal (âncoras→links→ações), raciocinar o plano antes tende a **acertar a
  temporização** — a dimensão em que o piloto mais separou B de A.

- **T5 — Spec-kit / rule-augmented (sem elicitação).** Um **system prompt fixo** com (a) um **template
  de plano** que a IA *sempre* aplica e (b) um **conjunto de regras/pitfalls** do Ginga (ver
  [Apêndice A](#apêndice-a--spec-kit-semente-de-regras)), **mas sem perguntar** — gera direto a partir
  do brief. É o coração das regras: transforma conhecimento tácito ("transparency vai em
  `<descriptorParam>`, nunca como atributo do `<descriptor>`") em restrição explícita. Motivação
  direta: os erros do piloto (C/A abortando por 1 atributo) são **exatamente** o que uma regra evitaria.

- **T6 — Spec-kit + elicitação (o fluxo do paper).** Combinação canônica do paper: o spec-kit **decide
  o que perguntar** (as lacunas da spec viram perguntas dirigidas — "em que segundo a imagem
  aparece?", "qual canto?", "qual tecla ativa?"), um **oráculo** (§4.4) responde com fatos do gabarito,
  a IA gera. É a **hipótese principal (H2)** operacionalizada e a diferença conceitual do paper — a
  spec é **elicitada**, não escrita inteira de cara. O contraste **com vs. sem elicitação** (T6 vs.
  T5) é uma das comparações centrais (RQ2).

- **T7 — Few-shot + spec-kit + elicitação.** Acrescenta exemplos ao fluxo do paper. Testa se exemplos
  *somam* sobre regras+perguntas ou se há redundância (ablação).

- **T8 — Self-consistency (votação de N gerações).** Gera **N** vezes (temperatura > 0) e escolhe por
  **consenso estrutural** (ver §3.5) ou pela variante que passa na validação com maior FS. Compõe com
  qualquer técnica-base (ex.: T6/T7). Motivação: geração de código é estocástica; medir **variância** e
  se a votação estabiliza a fidelidade (e a que custo de tokens).

### 1.2 Ablação (para atribuir o efeito a cada componente)

```
T0  baseline vago ......................... piso
 └► T5  + regras (spec-kit) ............... efeito das REGRAS
      └► T6  + elicitação ................. efeito das PERGUNTAS  (fluxo do paper)
           └► T7  + few-shot ............. efeito dos EXEMPLOS
                └► T8  + self-consistência .. estabilização
   (validação/correção no Ginga = etapa ORTOGONAL do pipeline, §4.6 — recupera o gate do parser)
```

Rodar a cadeia como ablação permite dizer, no paper, **quanto de fidelidade cada bloco adiciona** —
não só "o sistema completo é melhor".

---

## 2. Matriz experimental

**Fatores.** `técnica × app × modelo × rodada`.

- **Variável independente principal:** a **técnica de prompting** (T0…T8 da §1). É o que queremos
  atribuir o efeito.
- **Fator secundário (co-variável):** o **modelo** (para checar se o efeito da técnica é robusto entre
  modelos; não é o foco).
- **Fator de blocagem:** o **app-alvo** (cada app é um "bloco"; comparamos técnicas *dentro* do mesmo
  app para controlar dificuldade).
- **Rodadas:** repetições por célula, para lidar com a **estocasticidade** da decodificação.
- **Mantidos constantes (controle):** o *brief* de intenção do usuário (nível C, o mesmo para todas as
  técnicas de um app **da T1 em diante**; a **T0** usa de propósito o *brief* vago como piso), o
  conjunto de mídias visível ao agente, o gabarito e o extrator de estrutura.

### 2.1 Apps candidatos (blocos)

Escolhidos do próprio repositório, **todos com gabarito e RFC** (spec estrutural pronta,
legível por máquina). Ordenados por complexidade; os 4 primeiros formam o **núcleo** (compartilham
o "esqueleto Garrincha" → gradiente de dificuldade controlado); os demais são **apps de estresse**
(estruturas independentes, incluindo NCLua) para testar generalização (RQ4).

| App | Caminho | Gabarito (RFC) | Linhas | Complexidade estrutural (do RFC) | Papel |
|-----|---------|----------------|:------:|----------------------------------|-------|
| **02syncInt** | `Primeiro joao/.../Exemplos/02syncInt.ncl` | [RFC-0004](../rfcs/0004-02-syncint.md) | 83 | 5 regiões, 7 mídias, âncoras 12/41/45–51s, 1 tecla (RED), 0 switch | núcleo — sincronismo puro |
| **07transition** | `.../Exemplos/07transition.ncl` | [RFC-0009](../rfcs/0009-07-transition.md) | 107 | + `transitionBase` (fade/barWipe), 1 switch (idioma), formReg | núcleo — transições |
| **08animation** | `.../Exemplos/08animation.ncl` | [RFC-0010](../rfcs/0010-08-animation.md) | 116 | + animação `set`/`duration` (`top`, `bounds`), 1 switch | núcleo — animação |
| **10menu** | `.../Exemplos/10menu.ncl` | [RFC-0012](../rfcs/0012-10-menu.md) | 217 | 11 regiões, 18 mídias, **2 switches**, menu por foco (anel), teclas ENTER/OK, INFO, RED, linha do tempo 5/12/41/45/51/64s, settings | núcleo — **app do piloto** |
| **A_Onda** | `A_Onda/A_Onda.ncl` | [RFC-0001](../rfcs/0001-a-onda.md) | 1562 | app educacional grande, muitas regiões/contextos | estresse — escala |
| **TVDQuiz** | `TVDQuiz/main.ncl` | [RFC-0016](../rfcs/0016-tvdquiz.md) | 104 (+NCLua) | quiz interativo em **NCLua** (Lua 5.3) | estresse — NCLua |
| **enquete-ncl** | `enquete-ncl/main.ncl` | [RFC-0017](../rfcs/0017-enquete.md) | 177 (+NCLua) | votação Sim/Não em **NCLua** | estresse — NCLua |
| **rss-reader** | `rss-reader/main.ncl` | [RFC-0018](../rfcs/0018-rss-reader.md) | 87 (+NCLua) | leitor RSS em **NCLua** | estresse — NCLua |

> **Nota sobre os apps NCLua.** Além do NCL, exigem gerar **Lua 5.3** correto (sem `module()`/`setfenv()`,
> `string.format("%d", …)` com inteiro). São o teste mais duro do spec-kit — as regras de Lua (Apêndice A,
> R11–R12) só "pagam" aqui. Recomenda-se incluir **pelo menos um** NCLua no design mínimo.

### 2.2 Modelos

Escolher **2–3** modelos de famílias diferentes para testar robustez do efeito da técnica (ex.: um
*frontier*, um *mid-tier*, opcionalmente um aberto). O ID/parâmetros exatos ficam registrados no
`config.yaml` da rodada (reprodutibilidade). **Temperatura:** fixa e baixa (ex.: 0.2) para T0–T7;
para **T8 (self-consistency)** usar temperatura > 0 (ex.: 0.7) e `N` gerações.

### 2.3 Rodadas

`r` repetições por célula (`técnica × app × modelo`), chats **novos/limpos** (sem memória entre
rodadas — §4). Para T8 (e qualquer técnica-base combinada com self-consistency), cada "rodada" já
contém `N` amostras internas + a seleção por consenso.

### 2.4 Tamanho da matriz

Matriz **completa** (referência): `9 técnicas × 8 apps × 3 modelos × 5 rodadas = 1080 células` — grande
demais para um WIP. O **design mínimo** com sinal está em §5.

---

## 3. Métricas

Duas famílias: **(A) qualidade do artefato** (o NCL gerado, resumido no *Fidelity Score*) e **(B)
qualidade/custo do processo** (perguntas, rodadas, tokens). Todas são **variáveis dependentes**.

### 3.1 Validade técnica — `V` ∈ [0, 1]

Mede se o documento **carrega e roda** no Ginga. Gradual (não só binária), porque o piloto mostrou
estados intermediários:

| `V` | Estado | Como é aferido (automático) |
|:---:|--------|-----------------------------|
| **0.0** | não carrega (parse abortado) | Ginga retorna erro de parse / documento não inicia |
| **0.5** | carrega mas com **erro de runtime** ou renderização parcial (mídia não abre, link quebrado, warning grave no log) | log com erro pós-parse; screenshot não bate com "algo renderizou" |
| **1.0** | carrega e **renderiza limpo** | sem erros de parse/runtime; screenshot mostra conteúdo |

> `V` é **binária no gate, gradual no meio**: 0 = abortou; 1 = limpo; 0.5 = zona cinza. O piloto ilustra:
> C/A **cru** ⇒ `V=0` (parser rejeitou `transparency` como atributo do `<descriptor>`); após corrigir 1
> atributo ⇒ `V=1`. É por isso que `V` entra como **multiplicador** do FS (§3.6): sem carregar, a
> fidelidade estrutural é irrelevante para o telespectador.

### 3.2 Fidelidade estrutural vs. gabarito — `S` ∈ [0, 100]

Soma ponderada de dimensões, cada uma pontuada 0–1 por rubrica com **crédito parcial**, comparando a
estrutura extraída do gerado com a do gabarito (extração automática, §4.5; gabarito = o `.ncl` original
+ os fatos tabelados no RFC). Pesos propostos (somam 100), com o racional:

| Dim. | Dimensão | Peso | O que compara | Rubrica de score (0–1) |
|:----:|----------|:----:|---------------|------------------------|
| **T** | Linha do tempo | **25** | quando cada mídia entra/sai (âncoras `begin/end`, `delay`, `explicitDur`, `duration`) | fração de eventos do gabarito reproduzidos **dentro de tolerância** (±1s ou marca exata: 5/12/41/45/51/64s) |
| **I** | Interações / teclas | **20** | mapeamento tecla→efeito (`onSelection key=…`; ENTER/OK, INFO, RED), navegação | fração de pares (tecla→ação) do gabarito presentes e corretos |
| **L** | Layout / topologia | **15** | arranjo relativo (que mídia em que zona: topo/base/cantos; aninhamento) | fração de mídias na **zona certa** + hierarquia de regiões correta |
| **Sw** | Switches / seleção | **15** | mecanismo de seleção (`<switch>` + regras) e quantidade/semântica | igualdade de contagem e de critério (foco/idioma) — crédito parcial por switch correto |
| **M** | Mídias usadas | **15** | conjunto de mídias e **papel** de cada uma | Jaccard(mídias gerado, gabarito) ponderado por papel correto (vídeo principal, trilha, botão…) |
| **R** | Regiões / posições exatas | **10** | coordenadas `left/top/width/height` | fração de regiões com posição dentro de tolerância (ex.: ±3 pontos percentuais) |

`S = 25·T + 20·I + 15·L + 15·Sw + 15·M + 10·R` (com cada dimensão em [0,1]).

**Racional dos pesos.** Linha do tempo e interações pesam mais porque **são a essência da TV
interativa** e foram onde o piloto mais separou vago de spec (B chutou 8s e 0 switch; A reproduziu a
timeline inteira — 5/12/41/45/51/64s — e 1 dos 2 switches do original). Posição *exata* pesa menos (10) que *topologia* (15): errar 87,5% por
85% é venial; colocar o menu no topo em vez da base não é. Os pesos são **hiperparâmetros** — a §5.2
exige **análise de sensibilidade** e reporte por dimensão, não só o agregado.

### 3.3 Qualidade das perguntas de esclarecimento — `CQS` ∈ [0, 100]

Só se aplica às técnicas com elicitação (T6, T7 — e qualquer composição com perguntas). Avalia o
**conjunto de perguntas** que o agente fez antes de gerar. Três sub-métricas (cada 0–1):

| Sub-métrica | Definição | Como medir |
|-------------|-----------|------------|
| **Relevância** | fração de perguntas **pertinentes** (sobre uma lacuna real da spec, respondível pelo gabarito) | juiz por rubrica; perguntas fora do escopo ou já respondidas no brief contam contra |
| **Cobertura** | fração das **dimensões que o gabarito precisa** (T/I/L/Sw/M/R) que foram **tocadas** por ≥1 pergunta | mapear cada pergunta a uma dimensão (Apêndice B); cobertura = dimensões-alvo perguntadas ÷ dimensões-alvo necessárias |
| **Minimalidade** | ausência de perguntas **redundantes/supérfluas** | 1 − (perguntas redundantes ÷ total); penaliza "20 perguntas" e "pergunta o que já foi dito" |

`CQS = 100 · (0.4·Cobertura + 0.35·Relevância + 0.25·Minimalidade)`.

> **Por que Cobertura pesa mais.** Uma pergunta que *falta* (ex.: nunca perguntar em que segundo a
> propaganda entra) custa fidelidade direto na dimensão T. A elegância do desenho: **cada dimensão do
> FS tem uma pergunta canônica** (Apêndice B) — a Cobertura mede se o agente perguntou o que o gabarito
> exige. Juiz: rubrica humana em amostra + LLM-as-judge no restante, com verificação cruzada (§5.2).

### 3.4 Custo do processo — rodadas e tokens

- **`R2C` (rodadas até convergir):** número de idas-e-voltas (gerar → validar/corrigir → re-gerar, e/ou
  ciclos de pergunta-resposta) até `V=1` **e** `S` estabilizar (Δ`S` < ε entre rodadas). Zero-shot
  ideal = 1; o fluxo com clarification tende a `R2C` maior por desenho — o ponto é o **trade-off**
  R2C↑ vs. FS↑.
- **Custo em tokens:** `tokens_in + tokens_out` somados em todas as rodadas/perguntas/gerações da
  célula (para T8, inclui as `N` amostras). Reportar **FS por 1k tokens** (eficiência) além do FS
  bruto — uma técnica que ganha 5 pontos de FS gastando 10× tokens pode não valer a pena.
- **Latência** (opcional): tempo de parede por célula.

### 3.5 Consenso para self-consistency (T8)

Com `N` gerações, a "estrutura de consenso" é obtida por **votação por dimensão**: para cada elemento
estrutural (uma âncora, um switch, um mapeamento de tecla), adota-se o valor **majoritário** entre as N
amostras; a amostra final escolhida é a que **mais se aproxima do consenso** *e* tem `V=1`. Reporta-se
também a **variância de `S`** entre as N amostras (mede instabilidade da técnica-base).

### 3.6 Fidelity Score agregado — `FS` ∈ [0, 100]

$$\text{FS} = V \times S$$

- Se **não carrega** (`V=0`) ⇒ **FS = 0** (fiel no papel, inútil na tela — captura o gate do parser
  estrito).
- Se **carrega limpo** (`V=1`) ⇒ FS = S (a fidelidade estrutural pura).
- Zona cinza (`V=0.5`) penaliza pela metade.

**Exemplo com o piloto** (reconstruindo os FS a partir da tabela de `RESULTADO.md`, ilustrativo):

| Versão | T | I | L | Sw | M | R | **S** | **V** (cru) | **FS cru** | **V** (pós-fix) | **FS pós-fix** |
|--------|:-:|:-:|:-:|:--:|:-:|:-:|:-----:|:-----------:|:----------:|:---------------:|:--------------:|
| **B (porco)** | ~0.1 | ~0 | 0 | 0 | 0.89 | ~0.2 | ~23 | 1.0 | **~23** | 1.0 | ~23 |
| **C (inter.)** | ~0 | — | 1.0 | 0 | 0.94 | — | ~52 | **0.0** | **0** | 1.0 | **~52** |
| **A (spec)** | 1.0 | — | 1.0 | 0.5 | 1.0 | — | ~78 | **0.0** | **0** | 1.0 | **~78** |

> Leitura: no cru, B "vence" no FS porque C/A **nem carregam** — o artefato mais fiel é inútil sem a
> etapa de validação/correção. **Pós-correção de 1 atributo**, a ordem se inverte para B < C < A,
> como a hipótese prevê. Esta tabela **é** a evidência de H1 **e** de H3 num só quadro — e é o formato
> de saída que o benchmark automatiza para cada célula (§4.5). *(Os valores de S acima são
> reconstruções aproximadas da tabela qualitativa do piloto, só para ilustrar a fórmula.)*

---

## 4. Protocolo

### 4.1 Princípio: agente **cego**

O agente que gera o NCL **nunca vê o gabarito** (nem o `.ncl` original, nem o RFC). Ele enxerga apenas:
(a) as **mídias** do app numa pasta isolada e (b) o **brief** de intenção (+ o andaime da técnica). É o
mesmo desenho do piloto ([`como-reproduzir.md`](experimento-1-piloto-10menu/como-reproduzir.md)): o original fica **fora** da
pasta de trabalho de propósito, para o experimento ser honesto (sem "colar").

### 4.2 Isolamento por pasta

Uma pasta por **célula** `(app × técnica × modelo × rodada)`:

```
runs/
  <app>/<tecnica>/<modelo>/r<k>/
    sets/            ← só as mídias (o que o agente vê)          [entrada, read-only]
    brief.md         ← a intenção nível C (mesma para todas as técnicas do app)
    system.md        ← spec-kit, se a técnica usa (T5/T6/T7)
    shots/           ← exemplos prompt→NCL, se few/one-shot (de OUTROS apps)
    app.ncl          ← SAÍDA do agente
    transcript.jsonl ← diálogo completo (inclui perguntas do clarification)
    ginga.log        ← SAÍDA da execução
    shot.png         ← screenshot pós-execução
    score.json       ← métricas extraídas (V, S por dim, FS, CQS, R2C, tokens)
gabaritos/           ← FORA de runs/: <app>.ncl + <app>.struct.json (extraído do RFC)  [nunca visível ao agente]
```

Regras: chats **novos/limpos** por rodada (sem memória cruzada); as mídias entram **read-only**; o
`gabaritos/` é lido **só** pelo scorer, nunca montado na pasta do agente.

### 4.3 Guarda do gabarito

Para cada app, o gabarito tem **duas formas**: o `.ncl` original (referência de execução) e um
`<app>.struct.json` — a **estrutura canônica** (regiões+coords, descritores, switches, mídias+papéis,
âncoras com tempos, mapeamentos tecla→ação) derivada do RFC correspondente. O `.struct.json` é o que o
scorer compara, dimensão por dimensão. Como os RFCs já tabelam tudo isso (ex.: RFC-0012 lista as 11
regiões, os 2 switches, a linha do tempo 5/12/41/45/51/64s e os links por tecla), a construção do gabarito
estruturado é **transcrição do RFC**, não julgamento subjetivo.

### 4.4 Oráculo (para o clarification loop)

Nas técnicas com elicitação (T6, T7), quem responde às perguntas do agente é um **oráculo** — um respondente
(humano ou LLM roteirizado) que **conhece o gabarito** e responde **apenas o que foi perguntado**, com
o fato correto, **sem oferecer informação não solicitada** (senão vaza a spec e contamina o
experimento). O oráculo registra: nº de perguntas, quais dimensões cobriram, quais fatos revelou. Essa
disciplina é o que torna a Cobertura/Minimalidade (§3.3) mensuráveis e justas.

### 4.5 Automação (rodar no Ginga + extrair a tabela)

O piloto já executou este ciclo **à mão** (rodar `ginga app.ncl`, inspecionar o log, comparar com o
gabarito, montar a tabela de fidelidade). O benchmark **formaliza** isso num harness. Componentes a
implementar em [`harness/`](./harness) (nomes sugeridos):

| Script | Função |
|--------|--------|
| `run_ginga.sh <cell>` | roda `ginga -s 960x540 app.ncl` sob **Xvfb** (headless), captura `stdout/stderr`→`ginga.log`, screenshot após *N*s→`shot.png` |
| `derive_V.py <cell>` | classifica `V∈{0,0.5,1}` a partir do log (regex de erros de parse/runtime) + heurística de "renderizou algo" no screenshot |
| `extract_structure.py <ncl>` | parseia o NCL (lxml) → `struct.json`: regiões/coords, descritores (focusIndex, transIn/Out, explicitDur), `<switch>`+regras, mídias+src, `<area>` begin/end, `<link>` (conector, keyCode, ações) |
| `score_fidelity.py <gerado.struct> <gabarito.struct>` | calcula T/I/L/Sw/M/R (§3.2) → `S` e `FS = V·S` |
| `score_questions.py <transcript> <gabarito.struct>` | mapeia perguntas→dimensões → Relevância/Cobertura/Minimalidade → `CQS` |
| `aggregate.py runs/` | consolida todas as `score.json` → **tabela mestra** (CSV + Markdown), médias±desvio por `técnica×app×modelo`, testes estatísticos |

Saída final = a **tabela de fidelidade generalizada** (o formato da tabela do piloto, agora com uma
linha por célula e o FS agregado), pronta para o paper.

> **Limite conhecido da automação:** o Ginga headless **não simula teclas do controle**
> ([`CODE-CHANGES.md`](../docs/CODE-CHANGES.md) já registra isso para o damasTV). Logo, a dimensão
> **I (interações)** é aferida **estaticamente** (presença/correção dos `<link>` com `key=…`
> mapeando tecla→ação no NCL), e não por execução dinâmica. Uma **amostra** de células passa por
> verificação manual com teclas para calibrar o proxy estático (§5.2).

### 4.6 Fluxo de uma célula (resumo)

```
1. Prepara pasta: monta sets/ (mídias) + brief.md (+ system.md/shots/ conforme a técnica).
2. Agente cego gera app.ncl (T6/T7: faz perguntas → oráculo responde → gera).
3. run_ginga → ginga.log + shot.png ; derive_V → V.
4. (validação) se V<1: corrige pitfall a partir do log, re-roda [conta em R2C].
5. extract_structure(app.ncl) e compara com gabaritos/<app>.struct.json → S, FS.
6. score_questions (se houver perguntas) → CQS ; contabiliza tokens/R2C.
7. Grava score.json.  aggregate.py junta tudo no fim.
```

---

## 5. Design mínimo e ameaças à validade

### 5.1 Design mínimo com sinal (para o WIP)

A matriz completa (1080 células) é inviável para um position/WIP paper. Proposta de **fração
suficiente para sinal**, priorizando a **cadeia de ablação** (que responde H1/H2/H3) sobre a largura:

- **Técnicas (5):** T0 (piso), T5 (regras/spec-kit), T6 (regras+elicitação = fluxo do paper), T7
  (+few-shot), T8 (self-consistency). Isto **é** a ablação da §1.2 + o contraste "com elicitação (T6)
  vs. sem (T5)". A etapa de validação/correção no Ginga é aplicada como **estágio ortogonal** do
  pipeline (§4.6) sobre as células com regras.
- **Apps (4):** os 3 núcleo com gradiente `02syncInt → 08animation → 10menu` **+ 1 NCLua** (ex.:
  `enquete-ncl`) para generalização (RQ4). 10menu é obrigatório (continuidade com o piloto).
- **Modelos (2):** um *frontier* + um *mid-tier*.
- **Rodadas (r=5):** por célula.

Tamanho: `5 × 4 × 2 × 5 = 200` células — factível e já dá poder.

**Justificativa do sinal.** A comparação é **pareada por app** (cada técnica corre no mesmo bloco), o
que remove a variância entre-apps e aumenta o poder. Com `r=5` por célula estima-se a variância
intra-técnica (a mesma que a self-consistency mede); pelo piloto, as diferenças de interesse são
**grandes** (layout certo/errado, 0 vs. 2 switches, tempo 8s vs. 45s) — ordem de **dezenas de pontos de
FS**, não de 2–3. Uma diferença de FS ≳ 10 pontos entre T0 e T6 é detectável com `n=5×4` por técnica
via teste não-paramétrico pareado (Wilcoxon) + correção para múltiplas comparações. Para o WIP, mesmo
`r=3` já **sinaliza** a curva de ablação; `r=5` dá barras de erro apresentáveis.

**Escada de execução (se o orçamento apertar):**
1. **Núcleo mínimo:** T0 vs. T6, em 10menu, 1 modelo, r=5 (replica e formaliza o piloto → 1 gráfico).
2. **+ Ablação:** adiciona T5, T7, T8 no mesmo app (a curva T0→T5→T6→T7→T8).
3. **+ Generalização:** repete a ablação nos outros 3 apps e no 2º modelo.

### 5.2 Ameaças à validade

**Validade de construto (o FS mede o que dizemos?).**
- Pesos de `S` são **arbitrários** → publicar **análise de sensibilidade** (variar pesos ±50% e mostrar
  que o *ranking* de técnicas é estável) e **sempre reportar por dimensão**, não só o agregado.
- **I aferida estaticamente** (sem teclas no headless, §4.5) → é um *proxy*; calibrar com uma amostra
  de execução manual com controle e reportar a concordância proxy↔dinâmico.
- **CQS via LLM-as-judge** pode ter viés → rubrica fixa, **dupla anotação** humana numa amostra
  (concordância inter-anotador / κ) e verificação cruzada do juiz-LLM contra o humano.

**Validade interna (o efeito é da técnica?).**
- **Vazamento entre rodadas** → chats novos/limpos, pasta isolada, sem memória (§4.2).
- **Vazamento pelo oráculo** → oráculo responde **só o perguntado**, sem volunteering (§4.4); logar
  cada fato revelado.
- **Confusão técnica×brief** → o brief é **o mesmo** (nível C) para todas as técnicas de um app **da T1
  em diante**; só o andaime muda (a **T0** usa de propósito o brief vago como piso). (Uma extensão pode
  cruzar `técnica × nível_de_brief`, mas isso multiplica a matriz.)

**Contaminação de dados (o maior risco aqui).**
- Os apps são uma **coleção histórica pública (2008–2012)** — o [`README`](../README.md) diz isso
  explicitamente. Um LLM pode **já ter visto** o `10menu.ncl`/`A_Onda.ncl` no treino, inflando a
  fidelidade artificialmente (não seria "geração a partir da intenção", e sim recuperação de memória).
  **Mitigações:** (i) renomear IDs/mídias e parafrasear o brief para descolar do original; (ii) medir a
  contaminação com um *probe* (pedir o app **só pelo nome**, sem mídias/brief, e ver se o modelo o
  reproduz); (iii) incluir **≥1 app novo** (autoral, nunca publicado) como controle; (iv) reportar o
  risco abertamente no paper. Este ponto **precisa** ir na seção de ameaças do artigo.

**Validade externa (generaliza?).**
- Os 4 apps núcleo **compartilham o esqueleto Garrincha** (mesmas mídias/regiões) → são **correlacionados**,
  não amostras independentes. Por isso o design mínimo inclui **NCLua** e recomenda um **app autoral**;
  o paper deve evitar afirmar generalização além do que os blocos independentes sustentam.
- Um domínio (TV interativa, perfil EDTV) e poucos modelos → escopo declarado como WIP.

**Validade de conclusão (estatística).**
- `n` pequeno + decodificação estocástica → `r≥5`, reportar média **±desvio**, testes **não-paramétricos
  pareados** e correção para múltiplas comparações; nunca concluir de 1 rodada.

**Ameaças de medição/ambiente.**
- Ginga/versão e mídia via **Git LFS** (vídeos podem faltar → falso `V=0`) → fixar versão do Ginga no
  `config.yaml`, garantir `git lfs pull`, e distinguir no log "mídia ausente" de "erro de NCL".
- Diferenças **esperadas e OK** (caminho `animGar.mp4` vs `../media/animGar.mp4`; conector inline vs
  `importBase`) **não** podem contar como erro — o `extract_structure.py` deve normalizar isso (já
  previsto no [`como-reproduzir.md`](experimento-1-piloto-10menu/como-reproduzir.md) do piloto).

---

## Apêndice A — Spec-kit (semente de regras)

Regras que o **system prompt** (T5/T6/T7) injeta. Vêm dos *pitfalls* reais achados neste repositório
([`CODE-CHANGES.md`](../docs/CODE-CHANGES.md), RFCs e o piloto). São o insumo direto para "quais
regras benchmarkar".

**Perfil e forma.**
- **R1.** NCL 3.0, perfil **EDTV**: `xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`.
- **R2.** Documento **autocontido** quando pedido: definir regiões, descritores, **conectores inline** e
  elos no próprio arquivo (não precisa `importBase` de `causalConnBase.ncl`).
- **R3.** Cada `<link>` liga **uma condição → uma ação** via conector causal.

**Pitfalls que o parser estrito do Ginga aborta (validade técnica).**
- **R4.** Transparência: usar `<descriptorParam name="transparency" value="0.6"/>` **dentro** do
  descritor — **nunca** `transparency=` como atributo do `<descriptor>`. *(foi o erro que derrubou C/A
  no piloto.)*
- **R5.** `<descriptorParam>` só aceita **`name`** e **`value`** — nada de `region` (erro real no
  damasTV).
- **R6.** IDs e `constituent` de `<bindRule>` são **case-sensitive** (`efeitovence` ≠ `efeitoVence`).
- **R7.** `<simpleCondition>` exige `eventType` (a ausência quebrou o FacebookNCL).
- **R8.** **Um atributo inválido aborta o carregamento inteiro** → *validar antes de entregar*.

**Semântica de mídia/layout.**
- **R9.** Áudio: um descritor **sem region** toca só o som (mesmo em `.mp4`) — usar para trilhas.
- **R10.** `bounds` = `left,top,width,height`; usar `explicitDur` para fixar tempo em tela de mídia
  estática; menu navegável = anel `focusIndex` + `moveLeft`/`moveRight`.

**NCLua (só apps Lua).**
- **R11.** Ginga atual = **Lua 5.3**: `module()`/`setfenv()` foram **removidos** (eram 5.1) — não usar
  (ou carregar `compat.lua`).
- **R12.** `string.format("%d", x)` exige **inteiro**: divisão gera float e quebra → `math.floor(...)`.

**Template de plano (o que o spec-kit sempre aplica antes de gerar).**
```
1. Liste as mídias e o PAPEL de cada uma (vídeo principal, trilha, botão, overlay, ícone…).
2. Derive as REGIÕES/descritores (posição + zIndex; áudio sem region).
3. Monte a LINHA DO TEMPO (âncoras <area> begin/end; delays; explicitDur; animações set/duration).
4. Mapeie as INTERAÇÕES (tecla → efeito) e a navegação de foco.
5. Decida SWITCHES (seleção por foco/idioma) e conectores/elos.
6. VALIDE contra R1–R12; rode no Ginga; corrija pitfalls; só então entregue.
```

## Apêndice B — Perguntas canônicas por dimensão (para o clarification loop)

Mapeamento **pergunta ↔ dimensão do FS** — a base para medir **Cobertura** (§3.3): o agente "cobre" uma
dimensão quando faz ≥1 pergunta que a resolve. É também o roteiro do oráculo.

| Dimensão | Pergunta canônica que o agente deveria fazer |
|----------|----------------------------------------------|
| **T** (tempo) | "Em que segundo cada mídia entra/sai? Há atraso (delay)? Duração fixa?" |
| **I** (teclas) | "Qual tecla ativa cada ação (ENTER/OK, INFO, RED, setas)? O que cada uma faz?" |
| **L** (topologia) | "Onde fica cada mídia — topo/base/canto? O que fica sobre o quê?" |
| **R** (posição) | "Posições/tamanhos exatos (left/top/width/height) das regiões?" |
| **Sw** (seleção) | "O conteúdo troca conforme foco/idioma/estado? Como?" |
| **M** (mídias/papéis) | "Qual arquivo é o vídeo principal, a trilha, os botões, os overlays?" |

Uma técnica de clarification **boa** faz poucas perguntas que, juntas, cobrem as dimensões que **aquele
gabarito** exige (10menu precisa de T/I/L/Sw/M/R; 02syncInt quase não tem Sw). Perguntar sobre uma
dimensão inexistente no app custa **Minimalidade**; deixar de perguntar uma dimensão presente custa
**Cobertura** — e, no fim, **FS**.
