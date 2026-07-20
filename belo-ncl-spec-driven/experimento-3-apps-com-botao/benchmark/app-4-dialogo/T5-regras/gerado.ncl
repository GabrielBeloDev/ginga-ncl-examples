<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="app-4-dialogo" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo"  left="0"   top="0"   width="100%" height="100%" zIndex="1"/>
      <region id="rgBtnSim" left="25%" top="60%" width="22%"  height="16%"  zIndex="2"/>
      <region id="rgBtnNao" left="53%" top="60%" width="22%"  height="16%"  zIndex="2"/>
      <region id="rgTela"   left="0"   top="0"   width="100%" height="100%" zIndex="3"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <descriptor id="dBtnSim" region="rgBtnSim"
                  focusIndex="1" moveLeft="2" moveRight="2" moveUp="1" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <descriptor id="dBtnNao" region="rgBtnNao"
                  focusIndex="2" moveLeft="1" moveRight="1" moveUp="2" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <descriptor id="dTelaSim" region="rgTela"/>
      <descriptor id="dTelaNao" region="rgTela"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK (ENTER): ao selecionar, inicia -->
      <causalConnector id="onSelStart">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- Tecla VERMELHA: ao selecionar com a tecla, para (volta) -->
      <causalConnector id="onRedStop">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>
  </head>

  <body>
    <!-- Componentes que aparecem no inicio precisam de <port> -->
    <port id="entry"      component="fundo"/>
    <port id="pSettings"  component="settings"/>
    <port id="pSim"       component="btnSim"/>
    <port id="pNao"       component="btnNao"/>

    <!-- Foco inicial no botao SIM (focusIndex=1) -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Fundo com a pergunta 'Deseja assinar o Canal Belo?' -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- Botoes navegaveis -->
    <media id="btnSim" src="btn-sim.png" descriptor="dBtnSim"/>
    <media id="btnNao" src="btn-nao.png" descriptor="dBtnNao"/>

    <!-- Telas de resposta (nao tem port: so aparecem no OK) -->
    <media id="telaSim" src="tela-sim.png" descriptor="dTelaSim"/>
    <media id="telaNao" src="tela-nao.png" descriptor="dTelaNao"/>

    <!-- OK no SIM -> mostra tela-sim.png ('Assinatura confirmada!') -->
    <link xconnector="onSelStart">
      <bind role="onSelection" component="btnSim"/>
      <bind role="start"       component="telaSim"/>
    </link>

    <!-- OK no NAO -> mostra tela-nao.png ('Talvez depois') -->
    <link xconnector="onSelStart">
      <bind role="onSelection" component="btnNao"/>
      <bind role="start"       component="telaNao"/>
    </link>

    <!-- VERMELHO com foco no SIM -> fecha tela-sim (volta ao dialogo) -->
    <link xconnector="onRedStop">
      <bind role="onSelection" component="btnSim">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaSim"/>
    </link>

    <!-- VERMELHO com foco no NAO -> fecha tela-nao (volta ao dialogo) -->
    <link xconnector="onRedStop">
      <bind role="onSelection" component="btnNao">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaNao"/>
    </link>
  </body>
</ncl>
