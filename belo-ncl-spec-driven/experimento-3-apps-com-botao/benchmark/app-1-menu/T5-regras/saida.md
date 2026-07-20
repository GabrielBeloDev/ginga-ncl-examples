# Saída (explicação do `gerado.ncl`)

App reproduzido: **menu com 4 botões na base da tela** (JOGOS, NOTICIAS, CLIMA, SOBRE) sobre um fundo. Navegação circular com ESQUERDA/DIREITA, OK abre a tela cheia do item e a tecla VERMELHA fecha e volta ao menu. Foco inicial no primeiro botão.

## Imagens usadas (só as da pasta)
`fundo.png`, `btn-jogos.png`, `btn-noticias.png`, `btn-clima.png`, `btn-sobre.png`, `tela-jogos.png`, `tela-noticias.png`, `tela-clima.png`, `tela-sobre.png`.

## Como cada regra foi aplicada

- **Perfil EDTV autocontido**: `xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`, com `regionBase`, `descriptorBase` e `connectorBase` inline no `<head>` e todos os elos no `<body>`.

- **Regiões**: `rgFundo` (tela inteira, `zIndex=0`) atrás; `rgTela` (tela inteira, `zIndex=5`) na frente para as telas cheias; os 4 botões (`rgBtn*`, `zIndex=1`) lado a lado na base (`top=80% height=15%`, `left` 4% / 27% / 50% / 73%, `width=21%`).

- **Ports (aparecem no início)**: `entry`→`fundo`, `pSettings`→`settings`, e um port por botão. As 4 `tela*` **não** têm port — só surgem via ação `start` do OK.

- **Botões navegáveis**: cada botão tem `focusIndex` (1..4) e `moveLeft/moveRight/moveUp/moveDown` circulares (JOGOS.moveLeft=4/SOBRE, SOBRE.moveRight=1/JOGOS; `moveUp`/`moveDown` apontam para o próprio índice por ser menu de uma linha), com `focusBorderColor="yellow"` e `focusBorderWidth="4"`.

- **Foco inicial**: `<media type="application/x-ginga-settings">` com `service.currentFocus="1"` (JOGOS) e seu port `pSettings`.

- **OK (abrir)**: conector `cAbre` = `onSelection` → `start`; 4 elos ligam `onSelection` do botão a `start` da respectiva tela cheia.

- **VERMELHA (voltar)**: conector `cVolta` com `connectorParam name="tecla"`, `onSelection key="$tecla"` → `stop`; 4 elos com `bindParam tecla="RED"`. Detalhe importante de funcionamento: o **foco nunca sai do botão** (a tela cheia só cobre a área), então o `onSelection(RED)` do botão focado dispara o `stop` da tela correspondente, fechando-a e revelando o menu de novo.

- **Transparência**: não foi necessária, então não foi usada (a regra só pede `descriptorParam` caso fosse usar).

- **`<port id="entry">`**: aponta o componente de entrada (`fundo`).

## Fluxo de uso
1. App inicia mostrando fundo + 4 botões; foco em JOGOS (borda amarela).
2. ESQUERDA/DIREITA movem o foco de forma circular entre os botões.
3. OK no botão focado abre a tela cheia correspondente (por cima do menu).
4. VERMELHA fecha a tela cheia e volta ao menu, com o foco ainda no mesmo botão.

## Validação
XML checado como bem-formado (`xml.dom.minidom` parseou sem erros).
