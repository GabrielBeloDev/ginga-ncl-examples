<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  App: Guia de Programacao (lista vertical com botoes)
  Perfil: NCL 3.0 EDTV, autocontido (regioes, descritores, conectores e elos inline).
  Base: perguntas.md + respostas.md (usuario confirmou todos os defaults).
  Imagens: usadas SO as da pasta (fundo.png, item-1..5.png, tela-1..5.png).
  Resolucao alvo: 1280x720.
  Navegacao: setas CIMA/BAIXO, circular (esquerda/direita ignoradas).
  OK abre a tela de detalhe (item-N -> tela-N, tela cheia por cima).
  VERMELHO (RED) fecha o detalhe e volta pra lista, mantendo o foco no item.
-->
<ncl id="guiaProgramacao" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <region id="rgTela" width="1280" height="720">
        <!-- fundo com o cabecalho, sempre visivel atras da lista -->
        <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>

        <!-- coluna vertical a esquerda, abaixo do cabecalho (~110px do topo),
             botoes 520x70 (tamanho nativo, proporcao mantida), gap de 10px -->
        <region id="rgItem1" left="60" top="110" width="520" height="70" zIndex="1"/>
        <region id="rgItem2" left="60" top="190" width="520" height="70" zIndex="1"/>
        <region id="rgItem3" left="60" top="270" width="520" height="70" zIndex="1"/>
        <region id="rgItem4" left="60" top="350" width="520" height="70" zIndex="1"/>
        <region id="rgItem5" left="60" top="430" width="520" height="70" zIndex="1"/>

        <!-- tela de detalhe: tela cheia por cima de tudo (uma por vez) -->
        <region id="rgDetalhe" left="0" top="0" width="1280" height="720" zIndex="5"/>
      </region>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- botoes navegaveis: focusIndex + moveUp/moveDown circular,
           borda amarela espessura 4; esquerda/direita nao definidas (ignoradas) -->
      <descriptor id="dItem1" region="rgItem1"
                  focusIndex="1" moveUp="5" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem2" region="rgItem2"
                  focusIndex="2" moveUp="1" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem3" region="rgItem3"
                  focusIndex="3" moveUp="2" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem4" region="rgItem4"
                  focusIndex="4" moveUp="3" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem5" region="rgItem5"
                  focusIndex="5" moveUp="4" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <descriptor id="dTela1" region="rgDetalhe"/>
      <descriptor id="dTela2" region="rgDetalhe"/>
      <descriptor id="dTela3" region="rgDetalhe"/>
      <descriptor id="dTela4" region="rgDetalhe"/>
      <descriptor id="dTela5" region="rgDetalhe"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK (selecao): ao selecionar, inicia -->
      <causalConnector id="cSelecao">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- VERMELHO (voltar): selecao com a tecla RED -> para -->
      <causalConnector id="cVoltar">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- porta de entrada -->
    <port id="entry" component="fundo"/>
    <!-- foco inicial no item 1 -->
    <port id="pCfg" component="cfg"/>
    <!-- portas das medias que aparecem no inicio (senao nao aparecem) -->
    <port id="pItem1" component="item1"/>
    <port id="pItem2" component="item2"/>
    <port id="pItem3" component="item3"/>
    <port id="pItem4" component="item4"/>
    <port id="pItem5" component="item5"/>

    <!-- foco inicial: item 1 (18h Novela) -->
    <media id="cfg" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- fundo sempre visivel -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- botoes da lista (as proprias imagens item-N.png) -->
    <media id="item1" src="item-1.png" descriptor="dItem1"/>
    <media id="item2" src="item-2.png" descriptor="dItem2"/>
    <media id="item3" src="item-3.png" descriptor="dItem3"/>
    <media id="item4" src="item-4.png" descriptor="dItem4"/>
    <media id="item5" src="item-5.png" descriptor="dItem5"/>

    <!-- telas de detalhe (tela cheia, iniciam so via OK) -->
    <media id="tela1" src="tela-1.png" descriptor="dTela1"/>
    <media id="tela2" src="tela-2.png" descriptor="dTela2"/>
    <media id="tela3" src="tela-3.png" descriptor="dTela3"/>
    <media id="tela4" src="tela-4.png" descriptor="dTela4"/>
    <media id="tela5" src="tela-5.png" descriptor="dTela5"/>

    <!-- ITEM 1: OK abre tela-1 / RED fecha tela-1 -->
    <link xconnector="cSelecao">
      <bind role="onSelection" component="item1"/>
      <bind role="start" component="tela1"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="item1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela1"/>
    </link>

    <!-- ITEM 2 -->
    <link xconnector="cSelecao">
      <bind role="onSelection" component="item2"/>
      <bind role="start" component="tela2"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="item2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela2"/>
    </link>

    <!-- ITEM 3 -->
    <link xconnector="cSelecao">
      <bind role="onSelection" component="item3"/>
      <bind role="start" component="tela3"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="item3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela3"/>
    </link>

    <!-- ITEM 4 -->
    <link xconnector="cSelecao">
      <bind role="onSelection" component="item4"/>
      <bind role="start" component="tela4"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="item4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela4"/>
    </link>

    <!-- ITEM 5 -->
    <link xconnector="cSelecao">
      <bind role="onSelection" component="item5"/>
      <bind role="start" component="tela5"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="item5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela5"/>
    </link>
  </body>
</ncl>
