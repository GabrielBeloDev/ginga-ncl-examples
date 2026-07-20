# Saida (resposta / explicacao)

Gerado o documento `gerado.ncl` (NCL 3.0, perfil EDTV, autocontido) reproduzindo a grade de apps 2x3 com navegacao por setas, OK abrindo a tela do app e VERMELHO voltando. XML validado como bem-formado.

## Imagens usadas (so as da pasta)
- `fundo.png` (1280x720) — plano de fundo.
- `app-1.png` a `app-6.png` (300x150 cada) — icones dos 6 apps.
- `tela-1.png` a `tela-6.png` (1280x720) — telas abertas por OK.

## Layout (grade 2 linhas x 3 colunas, canvas 1280x720)
Cada icone tem 300x150. Posicionamento (left, top):

| focus | app        | imagem    | left | top |
|-------|------------|-----------|------|-----|
| 1     | VIDEO      | app-1.png | 90   | 210 |
| 2     | MUSICA     | app-2.png | 490  | 210 |
| 3     | FOTOS      | app-3.png | 890  | 210 |
| 4     | JOGOS      | app-4.png | 90   | 450 |
| 5     | LOJA       | app-5.png | 490  | 450 |
| 6     | CONFIG     | app-6.png | 890  | 450 |

Fundo em `zIndex=0`, icones em `zIndex=1`, telas em `zIndex=5` (por cima).

## Como cada regra foi aplicada
- **Perfil EDTV / autocontido:** `xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`; `regionBase`, `descriptorBase`, `connectorBase` e todos os `link` inline no proprio documento.
- **Ports (aparece no inicio => precisa de port):** ha `<port>` para `fundo` (id `entry`), para o `settings` (foco) e para os 6 apps (`app1`..`app6`). As 6 telas NAO tem port (so surgem ao apertar OK).
- **Botao navegavel:** cada `dApp*` tem `focusIndex`, os quatro `move*` circulares e `focusBorderColor="yellow" focusBorderWidth="4"`.
- **Navegacao circular (grade 2x3):**
  - Esq/Dir dao a volta na linha: linha 1 = 1<->2<->3->1; linha 2 = 4<->5<->6->4.
  - Cima/Baixo alternam entre as duas linhas na mesma coluna (col 1: 1<->4; col 2: 2<->5; col 3: 3<->6).
- **Foco inicial no primeiro:** `<media type="application/x-ginga-settings">` com `service.currentFocus=1` (VIDEO), com port.
- **OK abre a tela:** conector `cAbre` (`onSelection` -> `start`); um `link` por app ligando `appN` (onSelection) ao `telaN` (start).
- **VERMELHO volta:** conector `cVolta` com `connectorParam name="tecla"`, `onSelection key="$tecla"` -> `stop`; um `link` por app com `<bindParam name="tecla" value="RED"/>` ligando o botao ao `stop` da respectiva tela. O foco permanece no botao que abriu a tela, entao o VERMELHO fecha exatamente aquela tela.
- **Transparencia:** nao foi usada (nao havia necessidade), evitando o atributo proibido no descriptor.
- **Port de entrada:** `<port id="entry" component="fundo"/>`.

## Fluxo de uso
1. Abre com o fundo + os 6 icones; foco no VIDEO (borda amarela).
2. Setas movem o foco pela grade (2 direcoes, circular).
3. OK no icone focado abre a tela cheia daquele app (`tela-N.png`).
4. VERMELHO fecha a tela e volta a grade.

## Validacao
- `python3 xml.dom.minidom` -> XML bem-formado.
- Contagem conferida: 6 descritores com `focusIndex`, 8 `<port>` (fundo+settings+6 apps), 12 `link` (6 OK + 6 VERMELHO), 6 midias de app e 6 de tela.
