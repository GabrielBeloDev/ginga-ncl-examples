<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="guiaHojeNaTV" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- Fundo em tela cheia (1280x720) -->
      <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>

      <!-- Lista vertical de 5 itens (520x70) a esquerda, abaixo do cabecalho -->
      <region id="rgItem1" left="60" top="140" width="520" height="70" zIndex="2"/>
      <region id="rgItem2" left="60" top="230" width="520" height="70" zIndex="2"/>
      <region id="rgItem3" left="60" top="320" width="520" height="70" zIndex="2"/>
      <region id="rgItem4" left="60" top="410" width="520" height="70" zIndex="2"/>
      <region id="rgItem5" left="60" top="500" width="520" height="70" zIndex="2"/>

      <!-- Tela cheia do item selecionado (fica por cima de tudo) -->
      <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Cada item e focavel; moveUp/moveDown fazem a navegacao circular -->
      <descriptor id="dItem1" region="rgItem1" focusIndex="1" moveUp="5" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem2" region="rgItem2" focusIndex="2" moveUp="1" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem3" region="rgItem3" focusIndex="3" moveUp="2" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem4" region="rgItem4" focusIndex="4" moveUp="3" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem5" region="rgItem5" focusIndex="5" moveUp="4" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <!-- Telas cheias tambem recebem foco para capturar o VERMELHO -->
      <descriptor id="dTela1" region="rgTela" focusIndex="11"/>
      <descriptor id="dTela2" region="rgTela" focusIndex="12"/>
      <descriptor id="dTela3" region="rgTela" focusIndex="13"/>
      <descriptor id="dTela4" region="rgTela" focusIndex="14"/>
      <descriptor id="dTela5" region="rgTela" focusIndex="15"/>
    </descriptorBase>

    <connectorBase>
      <!-- Ao iniciar, define o foco inicial (grava service.currentFocus) -->
      <causalConnector id="onBeginSet">
        <connectorParam name="var"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>

      <!-- OK sobre um item: abre a tela cheia e move o foco para ela -->
      <causalConnector id="onSelectionStartSet">
        <connectorParam name="var"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>

      <!-- VERMELHO sobre a tela cheia: fecha a tela e volta o foco ao item -->
      <causalConnector id="onRedStopSet">
        <connectorParam name="var"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- Pontos de entrada: fundo + os 5 itens aparecem no inicio -->
    <port id="pFundo" component="fundo"/>
    <port id="pItem1" component="item1"/>
    <port id="pItem2" component="item2"/>
    <port id="pItem3" component="item3"/>
    <port id="pItem4" component="item4"/>
    <port id="pItem5" component="item5"/>

    <!-- No de configuracao para controlar o foco corrente -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <!-- Fundo -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- Itens da lista -->
    <media id="item1" src="item-1.png" descriptor="dItem1"/>
    <media id="item2" src="item-2.png" descriptor="dItem2"/>
    <media id="item3" src="item-3.png" descriptor="dItem3"/>
    <media id="item4" src="item-4.png" descriptor="dItem4"/>
    <media id="item5" src="item-5.png" descriptor="dItem5"/>

    <!-- Telas cheias (iniciam ocultas, so aparecem no OK) -->
    <media id="tela1" src="tela-1.png" descriptor="dTela1"/>
    <media id="tela2" src="tela-2.png" descriptor="dTela2"/>
    <media id="tela3" src="tela-3.png" descriptor="dTela3"/>
    <media id="tela4" src="tela-4.png" descriptor="dTela4"/>
    <media id="tela5" src="tela-5.png" descriptor="dTela5"/>

    <!-- Foco inicial no primeiro item -->
    <link xconnector="onBeginSet">
      <bind role="onBegin" component="fundo"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="1"/>
      </bind>
    </link>

    <!-- OK abre a tela cheia do item e move o foco para a tela -->
    <link xconnector="onSelectionStartSet">
      <bind role="onSelection" component="item1"/>
      <bind role="start" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="11"/>
      </bind>
    </link>
    <link xconnector="onSelectionStartSet">
      <bind role="onSelection" component="item2"/>
      <bind role="start" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="12"/>
      </bind>
    </link>
    <link xconnector="onSelectionStartSet">
      <bind role="onSelection" component="item3"/>
      <bind role="start" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="13"/>
      </bind>
    </link>
    <link xconnector="onSelectionStartSet">
      <bind role="onSelection" component="item4"/>
      <bind role="start" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="14"/>
      </bind>
    </link>
    <link xconnector="onSelectionStartSet">
      <bind role="onSelection" component="item5"/>
      <bind role="start" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="15"/>
      </bind>
    </link>

    <!-- VERMELHO fecha a tela cheia e devolve o foco ao item correspondente -->
    <link xconnector="onRedStopSet">
      <bind role="onSelection" component="tela1" key="RED"/>
      <bind role="stop" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="1"/>
      </bind>
    </link>
    <link xconnector="onRedStopSet">
      <bind role="onSelection" component="tela2" key="RED"/>
      <bind role="stop" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="2"/>
      </bind>
    </link>
    <link xconnector="onRedStopSet">
      <bind role="onSelection" component="tela3" key="RED"/>
      <bind role="stop" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="3"/>
      </bind>
    </link>
    <link xconnector="onRedStopSet">
      <bind role="onSelection" component="tela4" key="RED"/>
      <bind role="stop" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="4"/>
      </bind>
    </link>
    <link xconnector="onRedStopSet">
      <bind role="onSelection" component="tela5" key="RED"/>
      <bind role="stop" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="5"/>
      </bind>
    </link>

  </body>
</ncl>
