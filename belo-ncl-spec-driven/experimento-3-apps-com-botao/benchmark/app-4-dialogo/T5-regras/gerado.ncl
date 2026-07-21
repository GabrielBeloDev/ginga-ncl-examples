<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Dialogo 'Deseja assinar o Canal Belo?': 2 botoes SIM/NAO (setas esq/dir), OK abre tela-sim/tela-nao, VERMELHO volta. Foco no SIM. NCL 3.0 EDTV autocontido. -->
<ncl id="dialogoCanalBelo" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rFundo" width="100%" height="100%" zIndex="0"/>
      <region id="rTela" width="100%" height="100%" zIndex="5"/>
      <region id="rSim" left="28%" top="62%" width="18%" height="14%" zIndex="2"/>
      <region id="rNao" left="54%" top="62%" width="18%" height="14%" zIndex="2"/>
    </regionBase>
    <descriptorBase>
      <descriptor id="dFundo" region="rFundo"/>
      <descriptor id="dTela" region="rTela"/>
      <descriptor id="dSim" region="rSim" focusIndex="1" moveRight="2" moveLeft="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dNao" region="rNao" focusIndex="2" moveRight="1" moveLeft="1" focusBorderColor="yellow" focusBorderWidth="4"/>
    </descriptorBase>
    <connectorBase>
      <causalConnector id="onSelStart">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>
      <causalConnector id="onKeyStop">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>
  </head>
  <body>
    <port id="pEntrada" component="fundo"/>
    <port id="pSet" component="settings"/>
    <port id="pSim" component="bSim"/>
    <port id="pNao" component="bNao"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>
    <media id="bSim" src="btn-sim.png" descriptor="dSim"/>
    <media id="bNao" src="btn-nao.png" descriptor="dNao"/>
    <media id="telaSim" src="tela-sim.png" descriptor="dTela"/>
    <media id="telaNao" src="tela-nao.png" descriptor="dTela"/>

    <link xconnector="onSelStart"><bind role="onSelection" component="bSim"/><bind role="start" component="telaSim"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="bNao"/><bind role="start" component="telaNao"/></link>

    <link xconnector="onKeyStop"><bind role="onSelection" component="telaSim"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="telaSim"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="telaNao"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="telaNao"/></link>
  </body>
</ncl>
