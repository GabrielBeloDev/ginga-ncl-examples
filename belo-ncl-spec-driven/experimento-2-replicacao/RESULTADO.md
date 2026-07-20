# Replicação do piloto em 3 novos exemplos

Depois do piloto `10menu` (n=1), replicamos o mesmo experimento — de forma **automatizada e cega** —
em **mais 3 aplicações NCL** do acervo: `02syncInt`, `07transition` e `08animation`. Isso leva a
evidência para **4 exemplos** no total.

## Como foi feito (automatizado, com agentes)

Um **workflow** orquestrou, para cada exemplo:
- um agente **analista** (com acesso ao original) que escreveu os **3 prompts de intenção** (níveis
  **B** porco, **C** intermediário, **A** spec) — em `prompts/`;
- **3 agentes geradores CEGOS** (Opus, contexto isolado, **sem** ver o original nem o histórico) que
  recriaram o `.ncl` só a partir do prompt + das mídias da pasta — em `ncl-gerado/`.

Depois rodamos cada `.ncl` gerado no **Ginga** (`figuras/`) e comparamos a estrutura com o original
(`gabaritos/`).

## Resultado 1 — validade técnica: **9/9 carregam e rodam** no Ginga

Todos os 9 documentos gerados **carregam e renderizam sem erro de parse**. Isso contrasta com o piloto
`10menu`, em que os níveis C e A quebravam por causa do atributo `transparency` mal colocado.

> **Por quê a diferença?** Desta vez o prompt dos geradores incluiu **uma regra do spec-kit** ("não use
> `transparency` como atributo do `<descriptor>`; use `<descriptorParam>`"). O resultado — 0 falhas de
> carregamento — é **evidência prática de que uma única regra de *pitfall* aumenta a confiabilidade**
> (apoia a ideia do spec-kit e da etapa de validação/correção, H3).

## Resultado 2 — fidelidade cresce com a estrutura (B < C < A), em **todos** os exemplos

Medindo quantos **instantes da linha do tempo** do original cada nível reproduz:

| Exemplo | B (porco) | C (intermediário) | A (spec) |
|---|:---:|:---:|:---:|
| **02syncInt** | 1/5 (20%) | 3/5 (60%) | **4/5 (80%)** |
| **07transition** | 0/5 (0%) | 2/5 (40%) | **5/5 (100%)** |
| **08animation** | 0/7 (0%) | 3/7 (43%) | **7/7 (100%)** |
| **Média** | **~7%** | **~48%** | **~93%** |

O padrão é **monotônico e limpo**: o nível **A (spec)** reproduz quase toda a linha do tempo do original;
o **B (porco)** *inventa* os tempos (ex.: 16s, 20s, 28s… no `07transition`); o **C** fica no meio.
Estrutura, mídias e regiões seguem o mesmo sentido — o nível **A** costuma bater exatamente o número de
mídias e regiões do original (ex.: `07transition` e `08animation`: A = 9 mídias / 6 regiões, iguais ao
original; B/C às vezes adicionam regiões a mais).

## Conclusão

- A hipótese **H1** (mais estrutura na intenção → mais fidelidade) se sustenta agora em **4 exemplos**,
  não só no piloto.
- A **regra de *pitfall*** do spec-kit, sozinha, levou as 9 gerações a **carregar** — um indício direto do
  valor do spec-kit (**H3**).
- **Ressalva:** ainda é **1 geração por nível** (sem as demais técnicas do benchmark — zero/one/few-shot,
  self-consistency — nem várias rodadas). Estes 3 exemplos são o **corpus-núcleo** do
  [benchmark](../02-benchmark-de-prompting.md); o próximo passo é rodar a matriz completa de técnicas.

---
*Artefatos: `prompts/` (os 3 prompts por exemplo, escritos pelo analista) · `ncl-gerado/` (os 9 `.ncl`
gerados pelos agentes cegos) · `gabaritos/` (os gabaritos) · `figuras/` (execução no Ginga).*
