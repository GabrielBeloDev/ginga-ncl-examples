<?xml version="1.0" encoding="UTF-8"?>
<!--
  Guia de programacao (lista vertical) com botoes.
  Assets usados (todos desta pasta):
    - fundo.png    (1280x720)  cabecalho "GUIA - HOJE NA TV" + area da lista
    - item-1.png .. item-5.png (520x70)   botoes da lista
    - tela-1.png .. tela-5.png (1280x720) telas de detalhe (uma por item)

  Interacao:
    - CURSOR_UP / CURSOR_DOWN : navega pela lista (com wrap no topo/fim)
    - OK (ENTER)             : abre a tela de detalhe do item focado
    - VERMELHO (RED)         : volta da tela de detalhe para a lista
-->
<ncl id="guia" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- fundo em tela cheia -->
      <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>

      <!-- 5 itens da lista, 520x70, empilhados verticalmente e centralizados -->
      <region id="rgItem1" left="380" top="130" width="520" height="70" zIndex="1"/>
      <region id="rgItem2" left="380" top="230" width="520" height="70" zIndex="1"/>
      <region id="rgItem3" left="380" top="330" width="520" height="70" zIndex="1"/>
      <region id="rgItem4" left="380" top="430" width="520" height="70" zIndex="1"/>
      <region id="rgItem5" left="380" top="530" width="520" height="70" zIndex="1"/>

      <!-- tela de detalhe cobre tudo (acima da lista) -->
      <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- descritores focaveis: focusIndex + moveUp/moveDown montam a navegacao
           vertical (5 volta pro 1 e 1 volta pro 5). Borda amarela marca o foco. -->
      <descriptor id="dItem1" region="rgItem1" focusIndex="1" moveUp="5" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dItem2" region="rgItem2" focusIndex="2" moveUp="1" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dItem3" region="rgItem3" focusIndex="3" moveUp="2" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dItem4" region="rgItem4" focusIndex="4" moveUp="3" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dItem5" region="rgItem5" focusIndex="5" moveUp="4" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="5"/>

      <!-- telas de detalhe: focaveis (para o RED disparar onSelection nelas),
           sem move (setas nao fazem nada no detalhe) e sem borda de foco -->
      <descriptor id="dTela1" region="rgTela" focusIndex="11" focusBorderWidth="0"/>
      <descriptor id="dTela2" region="rgTela" focusIndex="12" focusBorderWidth="0"/>
      <descriptor id="dTela3" region="rgTela" focusIndex="13" focusBorderWidth="0"/>
      <descriptor id="dTela4" region="rgTela" focusIndex="14" focusBorderWidth="0"/>
      <descriptor id="dTela5" region="rgTela" focusIndex="15" focusBorderWidth="0"/>
    </descriptorBase>

    <connectorBase>
      <!-- ao iniciar, define o foco (grava um valor em service.currentFocus) -->
      <causalConnector id="cOnBeginSet">
        <connectorParam name="var"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>

      <!-- OK no item: inicia a tela de detalhe e move o foco para ela -->
      <causalConnector id="cOnOkStartSet">
        <connectorParam name="var"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="seq">
          <simpleAction role="start"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>

      <!-- tecla (RED) na tela: para a tela e devolve o foco para o item -->
      <causalConnector id="cOnKeyStopSet">
        <connectorParam name="tecla"/>
        <connectorParam name="var"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- fundo + itens iniciam junto com o documento -->
    <port id="pFundo" component="fundo"/>
    <port id="pItem1" component="item1"/>
    <port id="pItem2" component="item2"/>
    <port id="pItem3" component="item3"/>
    <port id="pItem4" component="item4"/>
    <port id="pItem5" component="item5"/>

    <!-- no de configuracao: guarda qual elemento esta com o foco -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <media id="item1" src="item-1.png" descriptor="dItem1"/>
    <media id="item2" src="item-2.png" descriptor="dItem2"/>
    <media id="item3" src="item-3.png" descriptor="dItem3"/>
    <media id="item4" src="item-4.png" descriptor="dItem4"/>
    <media id="item5" src="item-5.png" descriptor="dItem5"/>

    <media id="tela1" src="tela-1.png" descriptor="dTela1"/>
    <media id="tela2" src="tela-2.png" descriptor="dTela2"/>
    <media id="tela3" src="tela-3.png" descriptor="dTela3"/>
    <media id="tela4" src="tela-4.png" descriptor="dTela4"/>
    <media id="tela5" src="tela-5.png" descriptor="dTela5"/>

    <!-- foco inicial: item 1 -->
    <link xconnector="cOnBeginSet">
      <bind role="onBegin" component="fundo"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="1"/>
      </bind>
    </link>

    <!-- OK em cada item abre a tela correspondente e foca nela (focusIndex 11..15) -->
    <link xconnector="cOnOkStartSet">
      <bind role="onSelection" component="item1"/>
      <bind role="start" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="11"/>
      </bind>
    </link>
    <link xconnector="cOnOkStartSet">
      <bind role="onSelection" component="item2"/>
      <bind role="start" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="12"/>
      </bind>
    </link>
    <link xconnector="cOnOkStartSet">
      <bind role="onSelection" component="item3"/>
      <bind role="start" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="13"/>
      </bind>
    </link>
    <link xconnector="cOnOkStartSet">
      <bind role="onSelection" component="item4"/>
      <bind role="start" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="14"/>
      </bind>
    </link>
    <link xconnector="cOnOkStartSet">
      <bind role="onSelection" component="item5"/>
      <bind role="start" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="15"/>
      </bind>
    </link>

    <!-- VERMELHO em cada tela para a tela e devolve o foco ao item de origem -->
    <link xconnector="cOnKeyStopSet">
      <bind role="onSelection" component="tela1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="1"/>
      </bind>
    </link>
    <link xconnector="cOnKeyStopSet">
      <bind role="onSelection" component="tela2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="2"/>
      </bind>
    </link>
    <link xconnector="cOnKeyStopSet">
      <bind role="onSelection" component="tela3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="3"/>
      </bind>
    </link>
    <link xconnector="cOnKeyStopSet">
      <bind role="onSelection" component="tela4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="4"/>
      </bind>
    </link>
    <link xconnector="cOnKeyStopSet">
      <bind role="onSelection" component="tela5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="5"/>
      </bind>
    </link>

  </body>
</ncl>
