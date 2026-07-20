# Saida — Explicacao do NCL gerado (`gerado.ncl`)

Documento **NCL 3.0, perfil EDTV**, **autocontido** (regioes, descritores, conectores
causais e elos todos inline). Usa **somente** as imagens da pasta, referenciadas por nome.
Tudo derivado direto das respostas — nada foi inventado alem do respondido.

## Layout (rodape, centralizado)

Canvas 1280x720. Os 4 botoes de 260px ocupam 4x260 = 1040px. Sobram 240px,
divididos em **5 folgas iguais de 48px** (antes, entre e depois) -> centralizado
com espacamento uniforme:

| Botao | Imagem | left | top | tamanho |
|---|---|---|---|---|
| 1 JOGOS | `btn-jogos.png` | 48 | 620 | 260x70 |
| 2 NOTICIAS | `btn-noticias.png` | 356 | 620 | 260x70 |
| 3 CLIMA | `btn-clima.png` | 664 | 620 | 260x70 |
| 4 SOBRE | `btn-sobre.png` | 972 | 620 | 260x70 |

`top=620` deixa a faixa no rodape (620+70 = 690, com 30px de margem inferior).
`fundo.png` ocupa a tela toda em `zIndex=0`, os botoes em `zIndex=1` (por cima do fundo),
e a `tela-*` de canal em `zIndex=5` (cobre o menu inteiro).

## Foco inicial

`<media type="application/x-ginga-settings">` com
`<property name="service.currentFocus" value="1"/>` (com port) coloca o foco no
**botao 1 = JOGOS** ao abrir.

## Botoes navegaveis (foco horizontal circular)

Cada botao e uma `<media>` cujo descritor tem `focusIndex` e apontamentos
`moveLeft`/`moveRight` (so horizontal, como pedido; sem `moveUp`/`moveDown`),
formando ciclo:

| focusIndex | botao | moveLeft | moveRight |
|---|---|---|---|
| 1 | JOGOS | 4 (SOBRE) | 2 (NOTICIAS) |
| 2 | NOTICIAS | 1 (JOGOS) | 3 (CLIMA) |
| 3 | CLIMA | 2 (NOTICIAS) | 4 (SOBRE) |
| 4 | SOBRE | 3 (CLIMA) | 1 (JOGOS) |

Do ultimo (SOBRE) a seta direita volta pro primeiro (JOGOS) e vice-versa.
Destaque de foco: `focusBorderColor="yellow"` e `focusBorderWidth="4"` em todos.

## Ports (o que aparece no inicio)

Toda media inicial tem `<port>`: settings, `fundo.png` e os 4 botoes. As 4 telas de
canal **nao** tem port — elas so entram em cena via elo de selecao (OK).

## Selecao (OK / ENTER)

Conector `cSelStart`: `<simpleCondition role="onSelection"/> -> <simpleAction role="start"/>`.
Um elo por botao liga `onSelection` do botao ao `start` da `tela-*` correspondente
(JOGOS->tela-jogos, NOTICIAS->tela-noticias, CLIMA->tela-clima, SOBRE->tela-sobre).
Como a `tela-*` e 1280x720 opaca em `zIndex=5`, ela cobre o menu (o menu "some").

## Voltar (tecla VERMELHA / RED)

Conector `cSelStopKey` com `<connectorParam name="tecla"/>` +
`<simpleCondition role="onSelection" key="$tecla"/> -> <simpleAction role="stop"/>`.
Um elo por botao com `<bindParam name="tecla" value="RED"/>`. O botao continua sendo
o elemento em foco enquanto a tela esta aberta; ao apertar **RED**, o elo para (`stop`)
a tela, que sai de cena e revela o menu de novo, com o **foco preservado** no mesmo botao.
Fecha so a tela aberta; nao ha tela de menu separada.

## O que NAO entrou (conforme respostas)

- **Sem** titulo/logo (nao ha imagem de titulo na pasta e o usuario nao quis texto).
- **Sem** transparencia extra (os PNGs de botao ja sao RGBA; nenhum `descriptorParam
  transparency` foi usado).
- **Sem** audio/beep.
- **Sem** opcao de sair do app.
- **Sem** navegacao vertical (Cima/Baixo nao fazem nada).

## Arquivos

- `gerado.ncl` — o app NCL EDTV autocontido.
- `entrada.md` — pedido + perguntas + respostas.
- `saida.md` — esta explicacao.
