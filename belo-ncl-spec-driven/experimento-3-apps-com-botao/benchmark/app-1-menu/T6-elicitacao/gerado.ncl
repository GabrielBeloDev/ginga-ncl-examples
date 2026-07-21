<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="menuCanais" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo"       left="0"    top="0"   width="1920" height="1080" zIndex="0"/>
      <region id="rgBtnJogos"    left="300"  top="960" width="300"  height="80"   zIndex="1"/>
      <region id="rgBtnNoticias" left="640"  top="960" width="300"  height="80"   zIndex="1"/>
      <region id="rgBtnClima"    left="980"  top="960" width="300"  height="80"   zIndex="1"/>
      <region id="rgBtnSobre"    left="1320" top="960" width="300"  height="80"   zIndex="1"/>
      <region id="rgTela"        left="0"    top="0"   width="1920" height="1080" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>
      <descriptor id="dBtnJogos"    region="rgBtnJogos"    focusIndex="1"
        moveLeft="4" moveRight="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnNoticias" region="rgBtnNoticias" focusIndex="2"
        moveLeft="1" moveRight="3" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnClima"    region="rgBtnClima"    focusIndex="3"
        moveLeft="2" moveRight="4" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnSobre"    region="rgBtnSobre"    focusIndex="4"
        moveLeft="3" moveRight="1" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dTela" region="rgTela"/>
    </descriptorBase>

    <connectorBase>
      <causalConnector id="cOK">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>
      <causalConnector id="cVoltar">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>
  </head>

  <body>
    <port id="pFoco"     component="settings"/>
    <port id="pFundo"    component="fundo"/>
    <port id="pJogos"    component="btnJogos"/>
    <port id="pNoticias" component="btnNoticias"/>
    <port id="pClima"    component="btnClima"/>
    <port id="pSobre"    component="btnSobre"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <media id="btnJogos"    src="btn-jogos.png"    descriptor="dBtnJogos"/>
    <media id="btnNoticias" src="btn-noticias.png" descriptor="dBtnNoticias"/>
    <media id="btnClima"    src="btn-clima.png"    descriptor="dBtnClima"/>
    <media id="btnSobre"    src="btn-sobre.png"    descriptor="dBtnSobre"/>

    <media id="telaJogos"    src="tela-jogos.png"    descriptor="dTela"/>
    <media id="telaNoticias" src="tela-noticias.png" descriptor="dTela"/>
    <media id="telaClima"    src="tela-clima.png"    descriptor="dTela"/>
    <media id="telaSobre"    src="tela-sobre.png"    descriptor="dTela"/>

    <!-- OK: abre a tela cheia por cima do menu -->
    <link xconnector="cOK">
      <bind role="onSelection" component="btnJogos"/>
      <bind role="start" component="telaJogos"/>
    </link>
    <link xconnector="cOK">
      <bind role="onSelection" component="btnNoticias"/>
      <bind role="start" component="telaNoticias"/>
    </link>
    <link xconnector="cOK">
      <bind role="onSelection" component="btnClima"/>
      <bind role="start" component="telaClima"/>
    </link>
    <link xconnector="cOK">
      <bind role="onSelection" component="btnSobre"/>
      <bind role="start" component="telaSobre"/>
    </link>

    <!-- VERMELHA (RED): fecha a tela e volta ao menu -->
    <link xconnector="cVoltar">
      <bind role="onSelection" component="btnJogos">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaJogos"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="btnNoticias">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaNoticias"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="btnClima">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaClima"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="btnSobre">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaSobre"/>
    </link>
  </body>
</ncl>