# Saida (resposta / explicacao)

Gerei o app NCL/Ginga em `gerado.ncl` usando **apenas** as imagens presentes nesta pasta.

## O que foi feito

Uma grade de aplicativos **2x3** (2 linhas x 3 colunas = 6 botoes) sobre o `fundo.png`,
navegavel por controle remoto:

```
[ VIDEO ] [ MUSICA ] [ FOTOS  ]   foco 1  2  3
[ JOGOS ] [ LOJA   ] [ CONFIG ]   foco 4  5  6
```

- **Setas (cima/baixo/esquerda/direita):** movem o foco entre os 6 botoes, com "wrap"
  (das bordas volta para o outro lado). O botao focado ganha borda amarela.
- **OK / ENTER:** abre a tela cheia (`tela-N.png`) do app focado, por cima da grade.
- **VERMELHO (RED):** fecha a tela e volta para a grade, com o foco de volta no botao de origem.

## Como funciona (NCL)

- **regionBase:** `rgFundo` (tela toda, z=0), seis regioes `rgApp1..6` de 300x150 (z=1)
  posicionadas na grade, e `rgTela` (tela toda, z=5) para o app aberto ficar por cima.
- **descriptorBase:** cada botao tem `focusIndex` (1..6) e `moveUp/Down/Left/Right`
  definindo a navegacao com wrap, alem de `focusBorderColor="yellow"`. As telas tem
  `focusIndex` 101..106 para poderem receber a tecla VERMELHO enquanto abertas.
- **connectorBase:** tres conectores genericos:
  - `cOnBeginSet` (onBegin -> set) para definir o foco inicial;
  - `cSelStartSet` (onSelection + tecla -> start + set) para abrir a tela e mover o foco;
  - `cSelStopSet` (onSelection + tecla -> stop + set) para fechar e devolver o foco.
- **body:** um `media` de settings (`service.currentFocus`) guarda o foco; portas iniciam
  o fundo e os 6 botoes (as telas so iniciam sob demanda). Links:
  - 1 link define o foco inicial no botao 1;
  - 6 links de ENTER abrem cada tela e movem o foco para ela;
  - 6 links de RED fecham cada tela e devolvem o foco ao botao correspondente.

Ao abrir uma tela o foco vai para ela (indices 101..106) e, como as telas nao tem
propriedades de movimento, as setas ficam inertes durante a exibicao; isso evita foco
"fantasma" na grade escondida e garante que o VERMELHO seja entregue a tela em foco em
qualquer implementacao Ginga.

## Imagens usadas (todas desta pasta)

- `fundo.png` (1280x720) - plano de fundo com cabecalho de instrucoes.
- `app-1.png`..`app-6.png` (300x150) - botoes VIDEO, MUSICA, FOTOS, JOGOS, LOJA, CONFIG.
- `tela-1.png`..`tela-6.png` (1280x720) - tela cheia de cada app.

Nenhum texto/asset externo foi adicionado: os rotulos ja vem embutidos nas imagens.

## Validacao

- XML bem-formado (validado com parser). Perfil: NCL 3.0 EDTV.
- `src` das midias usa caminhos relativos (mesma pasta do `.ncl`), pronto para rodar
  com a grade e as imagens juntas.
