# Saida (explicacao do gerado.ncl)

Documento NCL EDTV autocontido gerado em `gerado.ncl`, reproduzindo a grade de aplicativos.

## Assets encontrados na pasta (usados diretamente)

- `fundo.png` — 1280x720, fundo em tela cheia com o titulo "APLICATIVOS".
- `app-1.png` .. `app-6.png` — 300x150, os botoes: VIDEO, MUSICA, FOTOS, JOGOS, LOJA, CONFIG.
- `tela-1.png` .. `tela-6.png` — 1280x720, a tela cheia de cada app aberto.

Os `src` sao relativos (mesmo diretorio do `.ncl`).

## Layout (regionBase)

Resolucao 1280x720. Grade 2x3 com botoes de 300x150:

```
Linha 1 (top=205):  VIDEO(95)   MUSICA(490)   FOTOS(885)
Linha 2 (top=450):  JOGOS(95)   LOJA(490)     CONFIG(885)
```

- `rgFundo` e `rgTela` ocupam a tela inteira (0,0,1280,720). `rgTela` tem `zIndex=5` para cobrir a grade quando um app abre.
- Cada botao tem sua regiao (zIndex=1) sobre o fundo (zIndex=0).

## Navegacao (foco em 2 eixos)

Cada botao tem um `descriptor` com `focusIndex` e as transicoes `moveUp/moveDown/moveLeft/moveRight`, montando a matriz:

```
1 2 3
4 5 6
```

Assim as setas CIMA/BAIXO/ESQ/DIR andam nas duas direcoes (horizontal e vertical). Nas bordas a transicao e omitida (o foco fica parado). O foco tem borda amarela (`focusBorderColor=yellow`, `focusBorderWidth=5`).

O foco inicial e o primeiro app (VIDEO): a media de settings define `service.currentFocus = 1`.

## Acoes (connectorBase + links)

Dois conectores causais reutilizados:

- `cAbre` — condicao `onSelection` (tecla OK sobre o botao em foco). Acao composta em paralelo: para a grade toda (fundo + 6 botoes), inicia a `tela-N` correspondente e move o foco para a tela (para ela capturar o VERMELHO). Um link por botao (`lAbre1`..`lAbre6`).
- `cVolta` — condicao `onSelection key="RED"` (VERMELHO sobre a tela aberta). Acao composta: para a tela, reinicia a grade (fundo + 6 botoes) e devolve o foco ao botao de origem. Um link por tela (`lVolta1`..`lVolta6`).

As telas recebem `focusIndex` (11..16) so para garantir o recebimento da tecla VERMELHO em qualquer implementacao Ginga; a borda de foco delas e 0 (invisivel).

## Fluxo

1. Documento inicia: portas ligam `fundo` + os 6 botoes; foco no botao 1 (VIDEO).
2. Setas navegam a grade nas 2 direcoes.
3. OK no botao em foco -> abre a `tela-N` em tela cheia (grade e ocultada/parada).
4. VERMELHO na tela -> volta para a grade, com o foco de volta no botao de origem.

XML validado como bem-formado.
