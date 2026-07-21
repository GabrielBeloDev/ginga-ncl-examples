<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="appGrade" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo" left="0%" top="0%" width="100%" height="100%" zIndex="0"/>
      <region id="rgApp1" left="8%"  top="18%" width="26%" height="30%" zIndex="1"/>
      <region id="rgApp2" left="37%" top="18%" width="26%" height="30%" zIndex="1"/>
      <region id="rgApp3" left="66%" top="18%" width="26%" height="30%" zIndex="1"/>
      <region id="rgApp4" left="8%"  top="55%" width="26%" height="30%" zIndex="1"/>
      <region id="rgApp5" left="37%" top="55%" width="26%" height="30%" zIndex="1"/>
      <region id="rgApp6" left="66%" top="55%" width="26%" height="30%" zIndex="1"/>
      <region id="rgDetalhe" left="0%" top="0%" width="100%" height="100%" zIndex="2"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>
      <descriptor id="dApp1" region="rgApp1" focusIndex="1"
        moveRight="2" moveLeft="3" moveUp="4" moveDown="4"
        focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp2" region="rgApp2" focusIndex="2"
        moveRight="3" moveLeft="1" moveUp="5" moveDown="5"
        focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp3" region="rgApp3" focusIndex="3"
        moveRight="1" moveLeft="2" moveUp="6" moveDown="6"
        focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp4" region="rgApp4" focusIndex="4"
        moveRight="5" moveLeft="6" moveUp="1" moveDown="1"
        focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp5" region="rgApp5" focusIndex="5"
        moveRight="6" moveLeft="4" moveUp="2" moveDown="2"
        focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp6" region="rgApp6" focusIndex="6"
        moveRight="4" moveLeft="5" moveUp="3" moveDown="3"
        focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dTela1" region="rgDetalhe"/>
      <descriptor id="dTela2" region="rgDetalhe"/>
      <descriptor id="dTela3" region="rgDetalhe"/>
      <descriptor id="dTela4" region="rgDetalhe"/>
      <descriptor id="dTela5" region="rgDetalhe"/>
      <descriptor id="dTela6" region="rgDetalhe"/>
    </descriptorBase>

    <connectorBase>
      <causalConnector id="conSelecao">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>
      <causalConnector id="conVoltar">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>
  </head>

  <body>
    <port id="pSettings" component="mSettings"/>
    <port id="pFundo" component="mFundo"/>
    <port id="pApp1" component="mApp1"/>
    <port id="pApp2" component="mApp2"/>
    <port id="pApp3" component="mApp3"/>
    <port id="pApp4" component="mApp4"/>
    <port id="pApp5" component="mApp5"/>
    <port id="pApp6" component="mApp6"/>

    <media id="mSettings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="mFundo" src="fundo.png" descriptor="dFundo"/>

    <media id="mApp1" src="app-1.png" descriptor="dApp1"/>
    <media id="mApp2" src="app-2.png" descriptor="dApp2"/>
    <media id="mApp3" src="app-3.png" descriptor="dApp3"/>
    <media id="mApp4" src="app-4.png" descriptor="dApp4"/>
    <media id="mApp5" src="app-5.png" descriptor="dApp5"/>
    <media id="mApp6" src="app-6.png" descriptor="dApp6"/>

    <media id="mTela1" src="tela-1.png" descriptor="dTela1"/>
    <media id="mTela2" src="tela-2.png" descriptor="dTela2"/>
    <media id="mTela3" src="tela-3.png" descriptor="dTela3"/>
    <media id="mTela4" src="tela-4.png" descriptor="dTela4"/>
    <media id="mTela5" src="tela-5.png" descriptor="dTela5"/>
    <media id="mTela6" src="tela-6.png" descriptor="dTela6"/>

    <link xconnector="conSelecao">
      <bind role="onSelection" component="mApp1"/>
      <bind role="start" component="mTela1"/>
    </link>
    <link xconnector="conVoltar">
      <bind role="onSelection" component="mApp1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela1"/>
    </link>

    <link xconnector="conSelecao">
      <bind role="onSelection" component="mApp2"/>
      <bind role="start" component="mTela2"/>
    </link>
    <link xconnector="conVoltar">
      <bind role="onSelection" component="mApp2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela2"/>
    </link>

    <link xconnector="conSelecao">
      <bind role="onSelection" component="mApp3"/>
      <bind role="start" component="mTela3"/>
    </link>
    <link xconnector="conVoltar">
      <bind role="onSelection" component="mApp3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela3"/>
    </link>

    <link xconnector="conSelecao">
      <bind role="onSelection" component="mApp4"/>
      <bind role="start" component="mTela4"/>
    </link>
    <link xconnector="conVoltar">
      <bind role="onSelection" component="mApp4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela4"/>
    </link>

    <link xconnector="conSelecao">
      <bind role="onSelection" component="mApp5"/>
      <bind role="start" component="mTela5"/>
    </link>
    <link xconnector="conVoltar">
      <bind role="onSelection" component="mApp5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela5"/>
    </link>

    <link xconnector="conSelecao">
      <bind role="onSelection" component="mApp6"/>
      <bind role="start" component="mTela6"/>
    </link>
    <link xconnector="conVoltar">
      <bind role="onSelection" component="mApp6">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela6"/>
    </link>
  </body>
</ncl>
