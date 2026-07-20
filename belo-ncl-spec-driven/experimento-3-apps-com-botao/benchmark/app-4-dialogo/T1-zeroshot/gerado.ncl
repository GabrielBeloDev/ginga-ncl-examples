<?xml version="1.0" encoding="UTF-8"?>
<ncl id="dialogoCanalBelo" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo"  left="0"   top="0"   width="1280" height="720" zIndex="1"/>
      <region id="rgBtnSim" left="280" top="380" width="320"  height="90"  zIndex="2"/>
      <region id="rgBtnNao" left="680" top="380" width="320"  height="90"  zIndex="2"/>
      <region id="rgTela"   left="0"   top="0"   width="1280" height="720" zIndex="3"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>
      <descriptor id="dBtnSim" region="rgBtnSim"
                  focusIndex="idxSim" moveRight="idxNao"
                  focusBorderColor="yellow" focusBorderWidth="6"/>
      <descriptor id="dBtnNao" region="rgBtnNao"
                  focusIndex="idxNao" moveLeft="idxSim"
                  focusBorderColor="yellow" focusBorderWidth="6"/>
      <descriptor id="dTelaSim" region="rgTela" focusIndex="idxTelaSim" focusBorderWidth="0"/>
      <descriptor id="dTelaNao" region="rgTela" focusIndex="idxTelaNao" focusBorderWidth="0"/>
    </descriptorBase>

    <connectorBase>
      <!-- ao iniciar um objeto, ajusta o foco corrente -->
      <causalConnector id="onBeginSet">
        <connectorParam name="valor"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$valor"/>
      </causalConnector>

      <!-- ao selecionar (tecla), para objetos e inicia objetos -->
      <causalConnector id="onSelStopStart">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="stop"  max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>
  </head>

  <body>
    <!-- pontos de entrada: fundo + dois botoes iniciam juntos -->
    <port id="pFundo"  component="fundo"/>
    <port id="pBtnSim" component="btnSim"/>
    <port id="pBtnNao" component="btnNao"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="idxSim"/>
    </media>

    <media id="fundo"   src="fundo.png"    descriptor="dFundo"/>
    <media id="btnSim"  src="btn-sim.png"  descriptor="dBtnSim"/>
    <media id="btnNao"  src="btn-nao.png"  descriptor="dBtnNao"/>
    <media id="telaSim" src="tela-sim.png" descriptor="dTelaSim"/>
    <media id="telaNao" src="tela-nao.png" descriptor="dTelaNao"/>

    <!-- Foco inicial no SIM sempre que o dialogo (re)inicia -->
    <link xconnector="onBeginSet">
      <bind role="onBegin" component="fundo"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="idxSim"/>
      </bind>
    </link>

    <!-- OK no SIM -> esconde dialogo e mostra tela-sim -->
    <link xconnector="onSelStopStart">
      <bind role="onSelection" component="btnSim">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="stop"  component="fundo"/>
      <bind role="stop"  component="btnSim"/>
      <bind role="stop"  component="btnNao"/>
      <bind role="start" component="telaSim"/>
    </link>

    <!-- OK no NAO -> esconde dialogo e mostra tela-nao -->
    <link xconnector="onSelStopStart">
      <bind role="onSelection" component="btnNao">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="stop"  component="fundo"/>
      <bind role="stop"  component="btnSim"/>
      <bind role="stop"  component="btnNao"/>
      <bind role="start" component="telaNao"/>
    </link>

    <!-- da foco a tela-sim para que ela receba o VERMELHO -->
    <link xconnector="onBeginSet">
      <bind role="onBegin" component="telaSim"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="idxTelaSim"/>
      </bind>
    </link>

    <!-- da foco a tela-nao para que ela receba o VERMELHO -->
    <link xconnector="onBeginSet">
      <bind role="onBegin" component="telaNao"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="idxTelaNao"/>
      </bind>
    </link>

    <!-- VERMELHO na tela-sim -> volta ao dialogo -->
    <link xconnector="onSelStopStart">
      <bind role="onSelection" component="telaSim">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop"  component="telaSim"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnSim"/>
      <bind role="start" component="btnNao"/>
    </link>

    <!-- VERMELHO na tela-nao -> volta ao dialogo -->
    <link xconnector="onSelStopStart">
      <bind role="onSelection" component="telaNao">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop"  component="telaNao"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnSim"/>
      <bind role="start" component="btnNao"/>
    </link>
  </body>
</ncl>
