# Experimento: intenção → NCL (reproduzir o app `10menu`)

Objetivo: testar a tese do artigo — **uma descrição de intenção mais estruturada (uma "spec") gera um
NCL mais fiel ao original do que um prompt comum e vago?**

## Estrutura desta pasta

```
sdd-experimento-menu/
├── sets/                              ← ABRA O CLAUDE CODE AQUI (só tem as mídias)
│   └── (18 mídias: vídeos, imagens, áudios, formulários)
├── PROMPT-simples.md                  ← Prompt B: "porco" (curto e vago, como um usuário comum)
├── PROMPT-intermediario.md            ← Prompt C: porco + noção de espaço/tempo (posições e tempos aprox.)
├── PROMPT-detalhado.md                ← Prompt A: a "spec" (refinado, com posições/tempos/interações)
├── 10menu_ORIGINAL_para_comparar.ncl  ← o GABARITO (não fica dentro de sets/)
└── INSTRUCOES.md                      ← este arquivo
```

> O agente novo só pode ver as **mídias** (em `sets/`). O NCL original fica **fora** de `sets/` de
> propósito, pra o experimento ser honesto.

## Os três níveis (gradiente vago → spec)

| | Prompt | Nível de detalhe |
|---|--------|------------------|
| **B** | `PROMPT-simples.md` | "Porco": pedido curto e vago, como qualquer um digitaria (só o grosso). |
| **C** | `PROMPT-intermediario.md` | Meio-termo: tom casual + noção de espaço/tempo (cantos, base, "~40s"), sem números exatos. |
| **A** | `PROMPT-detalhado.md` | A **spec** do artigo: intenção estruturada (posições, tempos, durações e teclas precisas). |

A curva de fidelidade ao longo de **B → C → A** é o **argumento central do paper**: quanto mais a
intenção se aproxima de uma spec, mais fiel fica o NCL gerado.

## Passo a passo (faça para B, depois C, depois A)

1. **Abra um terminal** na pasta das mídias e inicie o Claude Code:
   ```bash
   cd /home/teleadm/Documents/sdd-experimento-menu/sets
   claude
   ```
   (Dica: faça cada teste num chat **novo/limpo**, pra um não influenciar o outro. Pode salvar os
   resultados como `app-B.ncl`, `app-C.ncl` e `app-A.ncl`.)
2. **Cole o prompt** correspondente (`PROMPT-simples.md` no B; `PROMPT-intermediario.md` no C;
   `PROMPT-detalhado.md` no A). O agente gera o `.ncl` ali, usando só as mídias que enxerga.
3. **Rode** o que ele gerou pra ver se funciona:
   ```bash
   ginga app-A.ncl     # (de dentro de sets/)
   ```
4. **Compare** com o gabarito `10menu_ORIGINAL_para_comparar.ncl`.
   - **O que importa:** equivalência de comportamento — layout (posições), linha do tempo (o que
     aparece quando) e interações (teclas → efeitos).
   - **Diferenças esperadas e OK:** o gerado referencia as mídias direto (`animGar.mp4`) e o original usa
     `../media/animGar.mp4`; o original **importa** os conectores de `causalConnBase.ncl`, o gerado
     provavelmente define os conectores **dentro** do arquivo. Isso não conta como erro.

## Como ler o resultado (para o artigo)

Para cada versão (A e B), anote comparando gerado × original:
- **Acertos:** regiões/posições corretas? mídias certas nos lugares certos? tempos batem? as 4 trilhas e
  a navegação por setas funcionam? a propaganda (RED) e o liga/desliga (INFO) funcionam?
- **Divergências / "chutes":** onde a intenção descrita **não** foi suficiente.

> A expectativa: **B (porco)** acerta o grosso (vídeo + música + menu) mas erra/ignora os detalhes
> (posições exatas, tempos, o drible/foto, a interatividade, a tecla certa, o idioma). **C (intermediário)**
> acerta os elementos e a posição grosseira, mas ainda erra os números/durações. **A (spec)** chega bem
> mais perto do original. Cada divergência que some ao subir de B → C → A é evidência de que **mais
> estrutura na intenção reduz o gap semântico** — exatamente a contribuição do paper.
