# Saida - Guia vertical de programacao (NCL EDTV)

Gerei o `gerado.ncl` reproduzindo o app pedido: uma lista vertical de 5 itens
a esquerda sobre `fundo.png`, navegacao circular com CIMA/BAIXO, OK abre a tela
cheia do item e VERMELHO volta. O foco inicial fica no primeiro item.

## Imagens usadas (todas da pasta)

- `fundo.png` - fundo em tela cheia
- `item-1.png` .. `item-5.png` - itens da lista (18h Novela, 19h Jornal, 20h Futebol, 22h Filme, 23h Show)
- `tela-1.png` .. `tela-5.png` - tela cheia de cada item

## Layout (regioes)

- `rBg` e `rC`: tela cheia (100% x 100%). `rBg` (zIndex 0) para o fundo;
  `rC` (zIndex 5) para as telas cheias, que ficam por cima de tudo.
- `r1`..`r5`: coluna a esquerda (`left=5%`, `width=40%`, `height=12%`),
  empilhados verticalmente com `top` em 12%, 28%, 44%, 60% e 76%.

## Navegacao (foco)

Cada item tem `focusIndex` de 1 a 5. A navegacao circular e feita so com
`moveUp`/`moveDown` nos descritores:

- item 1: moveUp -> 5, moveDown -> 2
- item 2: moveUp -> 1, moveDown -> 3
- item 3: moveUp -> 2, moveDown -> 4
- item 4: moveUp -> 3, moveDown -> 5
- item 5: moveUp -> 4, moveDown -> 1

Assim, subir no primeiro leva ao ultimo e descer no ultimo leva ao primeiro
(circular). O foco inicial vem do `application/x-ginga-settings` com
`service.currentFocus = 1`.

## Interacao (links)

- `cSel` (onSelection -> start): OK/ENTER no item `iN` inicia a `telaN`,
  que aparece na regiao `rC` em tela cheia por cima da lista.
  Cinco links, um por item.
- `cKey` (onSelection com `key=$tecla` -> stop): com a tela aberta, a tecla
  `RED` (VERMELHO) para (`stop`) a tela, voltando para a lista com o foco
  preservado. Cinco links, um por tela.

## Estrutura

- Portas iniciam o fundo, o settings e os 5 itens (todos comecam juntos, a
  lista ja fica visivel e navegavel).
- Dois conectores reutilizaveis (`cSel` e `cKey`) atendem os 10 links,
  seguindo o mesmo estilo do exemplo de referencia, adaptado de 2 botoes
  horizontais para 5 itens verticais.

O documento e autocontido e usa apenas os arquivos presentes na pasta.
