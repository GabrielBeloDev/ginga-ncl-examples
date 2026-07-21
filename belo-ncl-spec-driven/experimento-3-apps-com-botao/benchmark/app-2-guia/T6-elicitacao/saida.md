```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="guia" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo" left="0%" top="0%" width="100%" height="100%" zIndex="0"/>
      <region id="rgItem1" left="5%" top="10%" width="30%" height="14%" zIndex="1"/>
      <region id="rgItem2" left="5%" top="26%" width="30%" height="14%" zIndex="1"/>
      <region id="rgItem3" left="5%" top="42%" width="30%" height="14%" zIndex="1"/>
      <region id="rgItem4" left="5%" top="58%" width="30%" height="14%" zIndex="1"/>
      <region id="rgItem5" left="5%" top="74%" width="30%" height="14%" zIndex="1"/>
      <region id="rgTela" left="0%" top="0%" width="100%" height="100%" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>
      <descriptor id="dItem1" region="rgItem1" focusIndex="1" moveUp="5" moveDown="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem2" region="rgItem2" focusIndex="2" moveUp="1" moveDown="3" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem3" region="rgItem3" focusIndex="3" moveUp="2" moveDown="4" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem4" region="rgItem4" focusIndex="4" moveUp="3" moveDown="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dItem5" region="rgItem5" focusIndex="5" moveUp="4" moveDown="1" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dTela" region="rgTela"/>
    </descriptorBase>

    <connectorBase>
      <causalConnector id="cSelect">
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
    <port id="pSettings" component="settings"/>
    <port id="pFundo" component="mFundo"/>
    <port id="pItem1" component="mItem1"/>
    <port id="pItem2" component="mItem2"/>
    <port id="pItem3" component="mItem3"/>
    <port id="pItem4" component="mItem4"/>
    <port id="pItem5" component="mItem5"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="mFundo" src="fundo.png" descriptor="dFundo"/>

    <media id="mItem1" src="item-1.png" descriptor="dItem1"/>
    <media id="mItem2" src="item-2.png" descriptor="dItem2"/>
    <media id="mItem3" src="item-3.png" descriptor="dItem3"/>
    <media id="mItem4" src="item-4.png" descriptor="dItem4"/>
    <media id="mItem5" src="item-5.png" descriptor="dItem5"/>

    <media id="mTela1" src="tela-1.png" descriptor="dTela"/>
    <media id="mTela2" src="tela-2.png" descriptor="dTela"/>
    <media id="mTela3" src="tela-3.png" descriptor="dTela"/>
    <media id="mTela4" src="tela-4.png" descriptor="dTela"/>
    <media id="mTela5" src="tela-5.png" descriptor="dTela"/>

    <link xconnector="cSelect">
      <bind role="onSelection" component="mItem1"/>
      <bind role="start" component="mTela1"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="mItem1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela1"/>
    </link>

    <link xconnector="cSelect">
      <bind role="onSelection" component="mItem2"/>
      <bind role="start" component="mTela2"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="mItem2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela2"/>
    </link>

    <link xconnector="cSelect">
      <bind role="onSelection" component="mItem3"/>
      <bind role="start" component="mTela3"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="mItem3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela3"/>
    </link>

    <link xconnector="cSelect">
      <bind role="onSelection" component="mItem4"/>
      <bind role="start" component="mTela4"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="mItem4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela4"/>
    </link>

    <link xconnector="cSelect">
      <bind role="onSelection" component="mItem5"/>
      <bind role="start" component="mTela5"/>
    </link>
    <link xconnector="cVoltar">
      <bind role="onSelection" component="mItem5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTela5"/>
    </link>
  </body>
</ncl>
```
