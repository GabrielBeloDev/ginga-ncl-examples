# Entrada (pedido/instrução recebida)

Gere um documento NCL EDTV autocontido e salve em `/home/teleadm/Documents/NCL-files/belo-ncl-spec-driven/experimento-3-apps-com-botao/benchmark/app-1-menu/T3-fewshot/pasta-de-trabalho/gerado.ncl`, reproduzindo este app: Menu com 4 botoes na BASE da tela, lado a lado: JOGOS, NOTICIAS, CLIMA, SOBRE (imagens btn-jogos.png, btn-noticias.png, btn-clima.png, btn-sobre.png), sobre um fundo (fundo.png). Setas ESQUERDA/DIREITA movem o foco (circular); OK abre uma TELA CHEIA daquele item (tela-jogos.png, tela-noticias.png, tela-clima.png, tela-sobre.png); a tecla VERMELHA fecha a tela e volta ao menu. Foco comeca no primeiro botao.

EXEMPLO (pedido -> NCL), so pra referencia de estilo (adapte pro seu caso):
Pedido: menu com 2 botoes (A, B) lado a lado embaixo; setas esq/dir navegam; OK abre a tela do botao; VERMELHO volta. Imagens: fundo.png, btnA.png, btnB.png, telaA.png, telaB.png.
NCL:
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="ex" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
 <head>
  <regionBase>
   <region id="rBg" width="100%" height="100%" zIndex="0"/>
   <region id="rC" width="100%" height="100%" zIndex="5"/>
   <region id="rA" left="20%" top="80%" width="25%" height="12%" zIndex="2"/>
   <region id="rB" left="55%" top="80%" width="25%" height="12%" zIndex="2"/>
  </regionBase>
  <descriptorBase>
   <descriptor id="dBg" region="rBg"/><descriptor id="dC" region="rC"/>
   <descriptor id="dA" region="rA" focusIndex="1" moveRight="2" moveLeft="2" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="dB" region="rB" focusIndex="2" moveRight="1" moveLeft="1" focusBorderColor="yellow" focusBorderWidth="4"/>
  </descriptorBase>
  <connectorBase>
   <causalConnector id="cSel"><simpleCondition role="onSelection"/><simpleAction role="start"/></causalConnector>
   <causalConnector id="cKey"><connectorParam name="tecla"/><simpleCondition role="onSelection" key="$tecla"/><simpleAction role="stop"/></causalConnector>
  </connectorBase>
 </head>
 <body>
  <port id="e" component="fundo"/><port id="ps" component="cfg"/><port id="pa" component="ba"/><port id="pb" component="bb"/>
  <media id="cfg" type="application/x-ginga-settings"><property name="service.currentFocus" value="1"/></media>
  <media id="fundo" src="fundo.png" descriptor="dBg"/>
  <media id="ba" src="btnA.png" descriptor="dA"/><media id="bb" src="btnB.png" descriptor="dB"/>
  <media id="ta" src="telaA.png" descriptor="dC"/><media id="tb" src="telaB.png" descriptor="dC"/>
  <link xconnector="cSel"><bind role="onSelection" component="ba"/><bind role="start" component="ta"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="bb"/><bind role="start" component="tb"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="ta"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="ta"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tb"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tb"/></link>
 </body>
</ncl>
```
Use so as imagens da pasta. No fim, SALVE 3 arquivos nessa pasta com a ferramenta Write: `gerado.ncl` (o NCL), `entrada.md` (exatamente o pedido/instrucao que voce recebeu) e `saida.md` (sua resposta/explicacao). Liste a pasta antes pra ver as imagens. NAO leia pastas acima.
