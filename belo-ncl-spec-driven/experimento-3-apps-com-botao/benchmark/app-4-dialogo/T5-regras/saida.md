# Saida (explicacao do que foi gerado)

## Resumo
Gerado `gerado.ncl`: documento NCL 3.0 perfil EDTV, autocontido, que reproduz um dialogo
"Deseja assinar o Canal Belo?" com dois botoes navegaveis SIM e NAO sobre `fundo.png`.
Setas ESQ/DIR alternam o foco entre os botoes; OK (ENTER) confirma; tecla VERMELHA volta.
Foco inicial no botao SIM.

## Imagens usadas (so as da pasta)
- `fundo.png`   -> tela do dialogo com a pergunta
- `btn-sim.png` -> botao SIM (focusIndex 1)
- `btn-nao.png` -> botao NAO (focusIndex 2)
- `tela-sim.png` -> resposta do SIM ('Assinatura confirmada!')
- `tela-nao.png` -> resposta do NAO ('Talvez depois')

## Como as regras spec-kit foram aplicadas
1. **EDTV autocontido**: `regionBase`, `descriptorBase`, `connectorBase` e os `link` estao
   todos inline no proprio documento; nenhuma base externa (importBase) e usada.
2. **So imagens da pasta**: cada `<media src>` referencia um dos 5 PNGs pelo nome.
3. **Ports do que aparece no inicio**: ha `<port>` para `settings`, `fundo`, `btnSim` e `btnNao`.
   As telas de resposta (`telaSim`/`telaNao`) NAO tem port de proposito — so surgem no OK.
4. **Botoes navegaveis**: descritores `dBtnSim` (focusIndex=1) e `dBtnNao` (focusIndex=2),
   ambos com `focusBorderColor="yellow"` e `focusBorderWidth="4"`. Navegacao circular:
   SIM `moveLeft/moveRight=2`, NAO `moveLeft/moveRight=1` (setas ESQ e DIR alternam os dois).
   `moveUp/moveDown` apontam para o proprio indice (sem vizinho vertical, o foco nao se perde).
5. **Foco inicial**: `<media type="application/x-ginga-settings">` com
   `service.currentFocus = "1"` (com port `pSettings`) -> comeca no botao SIM.
6. **OK (selecao)**: conector `onSelStart` = `onSelection` -> `start`. Dois links:
   SIM -> inicia `telaSim`; NAO -> inicia `telaNao`.
7. **Tecla VERMELHA (voltar)**: conector `onRedStop` com `<connectorParam name="tecla"/>` e
   `<simpleCondition role="onSelection" key="$tecla"/>` -> `stop`. Nos links, o `<bind>` da
   condicao leva `<bindParam name="tecla" value="RED"/>`. A condicao RED fica presa aos botoes
   (que mantem o foco enquanto a tela de resposta esta sobre eles), entao VERMELHO fecha a
   tela de resposta e revela o dialogo novamente.
8. **Transparencia**: nao foi necessaria, entao nenhum `descriptorParam` de transparency foi
   incluido (e, conforme a regra, jamais como atributo do descriptor).
9. **`<port id="entry">`**: aponta para o componente de entrada `fundo`.

## Fluxo de execucao
1. Abre: `fundo.png` + botoes SIM/NAO; foco no SIM (borda amarela).
2. ESQ/DIR: move o foco entre SIM e NAO (circular).
3. OK no SIM: mostra `tela-sim.png` ('Assinatura confirmada!') por cima (zIndex 3).
4. OK no NAO: mostra `tela-nao.png` ('Talvez depois') por cima.
5. VERMELHO: fecha a tela de resposta atual e volta ao dialogo.

## Validacao
- XML bem-formado verificado com parser Python (`xml.dom.minidom`) -> OK.
- z-index: fundo(1) < botoes(2) < telas de resposta(3), garantindo a resposta por cima.
