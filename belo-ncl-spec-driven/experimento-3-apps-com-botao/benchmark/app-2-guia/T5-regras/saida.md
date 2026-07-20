# Saida - App 2 (Guia vertical) - T5-regras

Gerei `gerado.ncl`: documento NCL 3.0 perfil EDTV, autocontido (regioes, descritores, conectores causais e elos todos inline no proprio arquivo). Usei somente as imagens da pasta, referenciadas por nome. XML validado como bem-formado.

## Imagens da pasta (usadas)
- `fundo.png` - fundo em tela cheia
- `item-1.png` .. `item-5.png` - os 5 itens da lista (18h Novela, 19h Jornal, 20h Futebol, 22h Filme, 23h Show)
- `tela-1.png` .. `tela-5.png` - tela cheia de cada item

## Como as regras foram aplicadas

### Layout (lista VERTICAL a esquerda sobre o fundo)
- `rgFundo` ocupa 100% x 100% (zIndex 0).
- 5 regioes empilhadas na coluna esquerda: `rgItem1..5` em `left="5%"`, largura 38%, altura 13%, com `top` crescente (12%, 27%, 42%, 57%, 72%) -> lista vertical.
- `rgTela` em tela cheia (zIndex 5), reaproveitada pelas 5 telas (so uma aparece por vez).

### Botao navegavel (foco amarelo, navegacao circular CIMA/BAIXO)
- Cada item e uma `<media>` com descritor proprio contendo `focusIndex="N"`, `focusBorderColor="yellow"` e `focusBorderWidth="4"`.
- Como a lista e vertical, a navegacao usa `moveUp`/`moveDown` circulares:
  - item1: up->5, down->2
  - item2: up->1, down->3
  - item3: up->2, down->4
  - item4: up->3, down->5
  - item5: up->4, down->1

### Foco inicial no primeiro item
- `<media type="application/x-ginga-settings">` com `<property name="service.currentFocus" value="1"/>`, e com `<port id="pSettings">`.

### Ports (o que aparece no inicio)
- `pSettings` (settings), `entry` (fundo, componente de entrada) e `pItem1..5` (os 5 itens). As telas NAO tem port, entao comecam escondidas e so surgem no OK.

### OK abre a tela cheia
- Conector `onSelectionStart`: `<simpleCondition role="onSelection"/> -> <simpleAction role="start"/>`.
- 5 elos: `onSelection` no `item-i` -> `start` no `tela-i`.

### VERMELHO volta
- Conector `onKeySelectionStop`: `<connectorParam name="tecla"/>` + `<simpleCondition role="onSelection" key="$tecla"/> -> stop`.
- 5 elos: `onSelection` no `tela-i` com `<bindParam name="tecla" value="RED"/>` -> `stop` no `tela-i` (fecha a tela e volta para a lista).

## Fluxo de uso
1. Abre com o fundo + os 5 itens; foco amarelo no item 1.
2. CIMA/BAIXO movem o foco de forma circular pela lista.
3. OK no item focado abre a `tela-i` em tela cheia.
4. VERMELHO fecha a tela cheia e volta para a lista.

## Observacao tecnica
As telas compartilham o descritor `descTela` (mesma regiao fullscreen) porque nunca ficam visiveis simultaneamente; isso mantem o documento enxuto sem quebrar nenhuma regra.
