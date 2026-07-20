<?xml version="1.0" encoding="UTF-8"?>
<ncl id="menuApp" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <region id="rgScreen" left="0" top="0" width="100%" height="100%">
        <region id="rgFundo"       left="0"   top="0"   width="100%" height="100%" zIndex="0"/>
        <region id="rgBtnJogos"    left="3%"  top="80%" width="22%"  height="16%"  zIndex="2"/>
        <region id="rgBtnNoticias" left="27%" top="80%" width="22%"  height="16%"  zIndex="2"/>
        <region id="rgBtnClima"    left="51%" top="80%" width="22%"  height="16%"  zIndex="2"/>
        <region id="rgBtnSobre"    left="75%" top="80%" width="22%"  height="16%"  zIndex="2"/>
        <region id="rgTelaCheia"   left="0"   top="0"   width="100%" height="100%" zIndex="5"/>
      </region>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <descriptor id="dBtnJogos"    region="rgBtnJogos"    focusIndex="1" moveLeft="4" moveRight="2"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dBtnNoticias" region="rgBtnNoticias" focusIndex="2" moveLeft="1" moveRight="3"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dBtnClima"    region="rgBtnClima"    focusIndex="3" moveLeft="2" moveRight="4"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dBtnSobre"    region="rgBtnSobre"    focusIndex="4" moveLeft="3" moveRight="1"
                  focusBorderColor="yellow" focusBorderWidth="5"/>

      <descriptor id="dTelaJogos"    region="rgTelaCheia" focusIndex="10"/>
      <descriptor id="dTelaNoticias" region="rgTelaCheia" focusIndex="11"/>
      <descriptor id="dTelaClima"    region="rgTelaCheia" focusIndex="12"/>
      <descriptor id="dTelaSobre"    region="rgTelaCheia" focusIndex="13"/>
    </descriptorBase>

    <connectorBase>
      <!-- Da foco inicial quando um objeto comeca -->
      <causalConnector id="onBeginSet">
        <connectorParam name="var"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>

      <!-- OK sobre o botao: abre a tela cheia e move o foco pra ela -->
      <causalConnector id="onSelectionStartSet">
        <connectorParam name="var"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="seq">
          <simpleAction role="start"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>

      <!-- Tecla colorida sobre a tela: fecha e devolve o foco ao menu -->
      <causalConnector id="onKeySelectionStopSet">
        <connectorParam name="var"/>
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- Objetos iniciados junto com o documento -->
    <port id="pFundo"       component="fundo"/>
    <port id="pBtnJogos"    component="btnJogos"/>
    <port id="pBtnNoticias" component="btnNoticias"/>
    <port id="pBtnClima"    component="btnClima"/>
    <port id="pBtnSobre"    component="btnSobre"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <media id="btnJogos"    src="btn-jogos.png"    descriptor="dBtnJogos"/>
    <media id="btnNoticias" src="btn-noticias.png" descriptor="dBtnNoticias"/>
    <media id="btnClima"    src="btn-clima.png"    descriptor="dBtnClima"/>
    <media id="btnSobre"    src="btn-sobre.png"    descriptor="dBtnSobre"/>

    <media id="telaJogos"    src="tela-jogos.png"    descriptor="dTelaJogos"/>
    <media id="telaNoticias" src="tela-noticias.png" descriptor="dTelaNoticias"/>
    <media id="telaClima"    src="tela-clima.png"    descriptor="dTelaClima"/>
    <media id="telaSobre"    src="tela-sobre.png"    descriptor="dTelaSobre"/>

    <!-- Foco inicial no primeiro botao (JOGOS) -->
    <link id="lInit" xconnector="onBeginSet">
      <bind role="onBegin" component="btnJogos"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="var" value="1"/>
    </link>

    <!-- OK abre a tela cheia de cada item -->
    <link id="lOpenJogos" xconnector="onSelectionStartSet">
      <bind role="onSelection" component="btnJogos"/>
      <bind role="start" component="telaJogos"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="var" value="10"/>
    </link>

    <link id="lOpenNoticias" xconnector="onSelectionStartSet">
      <bind role="onSelection" component="btnNoticias"/>
      <bind role="start" component="telaNoticias"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="var" value="11"/>
    </link>

    <link id="lOpenClima" xconnector="onSelectionStartSet">
      <bind role="onSelection" component="btnClima"/>
      <bind role="start" component="telaClima"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="var" value="12"/>
    </link>

    <link id="lOpenSobre" xconnector="onSelectionStartSet">
      <bind role="onSelection" component="btnSobre"/>
      <bind role="start" component="telaSobre"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="var" value="13"/>
    </link>

    <!-- Tecla VERMELHA fecha a tela e volta ao menu (foco no botao de origem) -->
    <link id="lCloseJogos" xconnector="onKeySelectionStopSet">
      <bind role="onSelection" component="telaJogos"/>
      <bind role="stop" component="telaJogos"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="1"/>
    </link>

    <link id="lCloseNoticias" xconnector="onKeySelectionStopSet">
      <bind role="onSelection" component="telaNoticias"/>
      <bind role="stop" component="telaNoticias"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="2"/>
    </link>

    <link id="lCloseClima" xconnector="onKeySelectionStopSet">
      <bind role="onSelection" component="telaClima"/>
      <bind role="stop" component="telaClima"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="3"/>
    </link>

    <link id="lCloseSobre" xconnector="onKeySelectionStopSet">
      <bind role="onSelection" component="telaSobre"/>
      <bind role="stop" component="telaSobre"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="4"/>
    </link>

  </body>
</ncl>
