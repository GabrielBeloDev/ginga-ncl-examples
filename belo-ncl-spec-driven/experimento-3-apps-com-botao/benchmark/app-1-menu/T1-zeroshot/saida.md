# Saida (explicacao do gerado.ncl)

Documento NCL EDTV autocontido (`NCL3.0/EDTVProfile`) que reproduz o menu com 4 botoes na base da tela.

## Imagens usadas (todas da propria pasta)

- `fundo.png` — fundo em tela cheia
- `btn-jogos.png`, `btn-noticias.png`, `btn-clima.png`, `btn-sobre.png` — os 4 botoes
- `tela-jogos.png`, `tela-noticias.png`, `tela-clima.png`, `tela-sobre.png` — as 4 telas cheias

## Layout

- Uma `region` raiz `rgScreen` (100% x 100%) contendo:
  - `rgFundo` — tela inteira, `zIndex=0`.
  - 4 regioes de botao (`rgBtnJogos`, `rgBtnNoticias`, `rgBtnClima`, `rgBtnSobre`) na base
    (`top=80%`, `height=16%`), lado a lado em `left` 3% / 27% / 51% / 75%, `zIndex=2`.
  - `rgTelaCheia` — tela inteira, `zIndex=5` (fica por cima do menu quando aberta).

## Foco e navegacao (setas ESQUERDA/DIREITA, circular)

- Feito de forma declarativa pelos descritores dos botoes, via `focusIndex` + `moveLeft`/`moveRight`:
  - JOGOS `focusIndex=1` (moveLeft=4, moveRight=2)
  - NOTICIAS `focusIndex=2` (moveLeft=1, moveRight=3)
  - CLIMA `focusIndex=3` (moveLeft=2, moveRight=4)
  - SOBRE `focusIndex=4` (moveLeft=3, moveRight=1)
- O anel `1 -> 2 -> 3 -> 4 -> 1` (e o inverso) da a navegacao **circular**.
- Destaque do foco: `focusBorderColor=yellow`, `focusBorderWidth=5`.

## Foco inicial no primeiro botao

- `<media application/x-ginga-settings>` com a propriedade `service.currentFocus`.
- Link `lInit` (`onBeginSet`): quando `btnJogos` comeca, faz `set service.currentFocus = 1`,
  colocando o foco no primeiro botao (JOGOS).

## OK abre a tela cheia

- Um link por botao (`onSelectionStartSet`): condicao `onSelection` (tecla OK, padrao) sobre o botao
  dispara duas acoes em sequencia: `start` da tela correspondente + `set service.currentFocus` para o
  `focusIndex` da tela (10=jogos, 11=noticias, 12=clima, 13=sobre). Assim o foco vai pra tela cheia,
  e as setas ficam inertes (a tela nao tem `moveLeft/Right`).

## Tecla VERMELHA fecha e volta ao menu

- Um link por tela (`onKeySelectionStopSet`): condicao `onSelection` com `key=RED` sobre a tela
  dispara `stop` da tela + `set service.currentFocus` de volta ao botao de origem
  (1=jogos, 2=noticias, 3=clima, 4=sobre), voltando ao menu com o foco no botao que abriu a tela.

## Conectores (connectorBase, no proprio documento — autocontido)

- `onBeginSet` — `onBegin` -> `set` (foco inicial).
- `onSelectionStartSet` — `onSelection` -> `start` + `set` (abre tela + move foco).
- `onKeySelectionStopSet` — `onSelection key=$keyCode` -> `stop` + `set` (fecha + devolve foco).

## Fluxo resumido

1. Documento inicia: fundo + 4 botoes na base; foco em JOGOS.
2. ESQUERDA/DIREITA circulam o foco entre os 4 botoes.
3. OK no botao focado abre a tela cheia daquele item (foco vai pra tela).
4. VERMELHA na tela fecha ela e devolve o foco ao botao de origem no menu.
