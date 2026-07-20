# Saída (explicação do NCL gerado)

Gerei `gerado.ncl`, um documento NCL 3.0 perfil EDTV autocontido, adaptando o exemplo few-shot de 2 para 4 botões.

## Imagens usadas (conferidas na pasta)
- Fundo: `fundo.png`
- Botões: `btn-jogos.png`, `btn-noticias.png`, `btn-clima.png`, `btn-sobre.png`
- Telas cheias: `tela-jogos.png`, `tela-noticias.png`, `tela-clima.png`, `tela-sobre.png`

## Layout (menu na base)
4 regiões lado a lado, todas com `top="82%"` e `height="12%"`, largura `21%`:
- JOGOS `left=3%`, NOTICIAS `left=27%`, CLIMA `left=51%`, SOBRE `left=75%`.

O fundo ocupa a tela toda (`rBg`, zIndex 0) e as telas cheias usam `rC` (100% x 100%, zIndex 5), sobrepondo tudo quando abertas.

## Foco e navegação circular (setas ESQUERDA/DIREITA)
Cada botão tem um `focusIndex` e os saltos `moveRight`/`moveLeft` fecham o ciclo:

| Botão    | focusIndex | moveLeft | moveRight |
|----------|-----------|----------|-----------|
| JOGOS    | 1         | 4        | 2         |
| NOTICIAS | 2         | 1        | 3         |
| CLIMA    | 3         | 2        | 4         |
| SOBRE    | 4         | 3        | 1         |

Assim, no JOGOS a seta ESQUERDA vai para SOBRE (4) e no SOBRE a seta DIREITA volta para JOGOS (1) — circular. Foco de todos com borda amarela (`focusBorderColor="yellow"`, `focusBorderWidth="4"`).

## Foco inicial
`media cfg` (`application/x-ginga-settings`) define `service.currentFocus = 1`, começando o foco no primeiro botão (JOGOS).

## OK abre tela cheia
4 links com o conector `cSel` (`onSelection` -> `start`): selecionar (OK) um botão dá `start` na tela cheia correspondente (`bJogos`->`tJogos`, etc.). As telas usam o descritor `dC` (região `rC` fullscreen).

## VERMELHO fecha e volta ao menu
4 links com o conector `cKey` (`onSelection key=$tecla` -> `stop`), parametrizados com `tecla=RED`: com a tela em foco, apertar VERMELHO dá `stop` na própria tela, revelando o menu de novo. Como a tela abre em fullscreen e recebe o foco, a tecla vermelha é capturada por ela.

## Estrutura
- `regionBase`: 6 regiões (fundo, container fullscreen, 4 botões).
- `descriptorBase`: `dBg`, `dC` e os 4 descritores de botão com navegação.
- `connectorBase`: `cSel` (seleção -> start) e `cKey` (seleção por tecla -> stop).
- `body`: ports iniciando fundo, settings e os 4 botões; 8 links (4 de abrir + 4 de fechar).

Todos os `src` referenciam apenas os arquivos presentes na pasta de trabalho, mantendo o documento autocontido.
