# Saida (explicacao do gerado.ncl)

App "Guia — Hoje na TV" em NCL 3.0, perfil EDTV, autocontido, usando somente
as imagens da propria pasta.

## Imagens usadas (verificadas antes de gerar)

- `fundo.png` — 1280x720 (tela cheia, com o cabecalho "GUIA — HOJE NA TV").
- `item-1.png` a `item-5.png` — 520x70 cada (as 5 linhas da lista:
  18h Novela, 19h Jornal, 20h Futebol, 22h Filme, 23h Show).
- `tela-1.png` a `tela-5.png` — 1280x720 (a tela cheia de cada item).

## Layout

- `rgFundo` ocupa a tela toda (zIndex 0).
- Lista vertical a esquerda: itens de 520x70 em `left=60`, tops
  140 / 230 / 320 / 410 / 500 (abaixo da faixa do cabecalho), zIndex 2.
- `rgTela` (1280x720, zIndex 5) fica por cima de tudo quando um item e aberto.

## Foco e navegacao (CIMA/BAIXO circular)

Cada item tem `focusIndex` (1..5) no seu descriptor, com `moveUp`/`moveDown`
encadeados de forma circular:

- item1: up->5, down->2
- item2: up->1, down->3
- item3: up->2, down->4
- item4: up->3, down->5
- item5: up->4, down->1

Assim, CIMA no primeiro item vai para o ultimo e BAIXO no ultimo volta para o
primeiro. A moldura de foco e um retangulo amarelo (`focusBorderColor="yellow"`,
`focusBorderWidth="4"`). O motor de foco do Ginga trata as setas nativamente a
partir desses atributos.

## Foco inicial no primeiro item

Um `<media>` de settings expoe `service.currentFocus`. No `onBegin` do fundo, o
conector `onBeginSet` grava `service.currentFocus = "1"`, deixando o foco no
item 1 ao abrir o app.

## OK abre a tela cheia

Conector `onSelectionStartSet` (condicao `onSelection` = tecla OK/ENTER sobre o
item focado) executa em paralelo: `start` da `telaN` correspondente e grava
`service.currentFocus` no focusIndex da tela (11..15). Mover o foco para a tela
garante que ela receba a tecla VERMELHO em seguida.

## VERMELHO volta

Conector `onRedStopSet` (condicao `onSelection` com `key="RED"` sobre a tela
focada) executa em paralelo: `stop` da `telaN` (some a tela cheia) e devolve
`service.currentFocus` ao item de origem (1..5). Como a tela e opaca e esta em
zIndex maior, ela cobre a lista enquanto aberta; ao fechar, a lista reaparece
com o foco de volta no item que foi selecionado.

## Estrutura de conectores/links

- `onBeginSet` (1 link): foco inicial.
- `onSelectionStartSet` (5 links): OK por item -> abre tela + move foco.
- `onRedStopSet` (5 links): VERMELHO por tela -> fecha tela + volta foco.

Comportamento fiel a descricao: lista vertical de 5 itens a esquerda sobre o
fundo, navegacao circular por CIMA/BAIXO, OK abre a tela cheia, VERMELHO volta,
e foco inicial no primeiro item.
