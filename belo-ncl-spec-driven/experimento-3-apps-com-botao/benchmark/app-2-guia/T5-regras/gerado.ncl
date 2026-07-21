<?xml version="1.0" encoding="UTF-8"?>
<ncl id="listaVertical" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo" left="0%" top="0%" width="100%" height="100%" zIndex="0"/>
      <region id="rgItem1" left="4%" top="8%"  width="34%" height="14%" zIndex="1"/>
      <region id="rgItem2" left="4%" top="24%" width="34%" height="14%" zIndex="1"/>
      <region id="rgItem3" left="4%" top="40%" width="34%" height="14%" zIndex="1"/>
      <region id="rgItem4" left="4%" top="56%" width="34%" height="14%" zIndex="1"/>
      <region id="rgItem5" left="4%" top="72%" width="34%" height="14%" zIndex="1"/>
      <region id="rgTela"  left="0%" top="0%" width="100%" height="100%" zIndex="2"/>
    </regionBase>
    <descriptorBase>
      <descriptor id="dsFundo" region="rgFundo"/>
      <descriptor id="dsItem1" region="rgItem1" focusIndex="1" moveUp="5" moveDown="2" moveLeft="1" moveRight="1" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dsItem2" region="rgItem2" focusIndex="2" moveUp="1" moveDown="3" moveLeft="2" moveRight="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dsItem3" region="rgItem3" focusIndex="3" moveUp="2" moveDown="4" moveLeft="3" moveRight="3" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dsItem4" region="rgItem4" focusIndex="4" moveUp="3" moveDown="5" moveLeft="4" moveRight="4" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dsItem5" region="rgItem5" focusIndex="5" moveUp="4" moveDown="1" moveLeft="5" moveRight="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dsTela1" region="rgTela"/>
      <descriptor id="dsTela2" region="rgTela"/>
      <descriptor id="dsTela3" region="rgTela"/>
      <descriptor id="dsTela4" region="rgTela"/>
      <descriptor id="dsTela5" region="rgTela"/>
    </descriptorBase>
    <connectorBase>
      <causalConnector id="cnOnSelStart">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>
      <causalConnector id="cnOnKeyStop">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>
  </head>
  <body>
    <port id="pFundo" component="fundo"/>
    <port id="pSettings" component="settings"/>
    <port id="pItem1" component="item1"/>
    <port id="pItem2" component="item2"/>
    <port id="pItem3" component="item3"/>
    <port id="pItem4" component="item4"/>
    <port id="pItem5" component="item5"/>

    <media id="fundo" src="fundo.png" descriptor="dsFundo"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="item1" src="item-1.png" descriptor="dsItem1"/>
    <media id="item2" src="item-2.png" descriptor="dsItem2"/>
    <media id="item3" src="item-3.png" descriptor="dsItem3"/>
    <media id="item4" src="item-4.png" descriptor="dsItem4"/>
    <media id="item5" src="item-5.png" descriptor="dsItem5"/>

    <media id="tela1" src="tela-1.png" descriptor="dsTela1"/>
    <media id="tela2" src="tela-2.png" descriptor="dsTela2"/>
    <media id="tela3" src="tela-3.png" descriptor="dsTela3"/>
    <media id="tela4" src="tela-4.png" descriptor="dsTela4"/>
    <media id="tela5" src="tela-5.png" descriptor="dsTela5"/>

    <link xconnector="cnOnSelStart">
      <bind role="onSelection" component="item1"/>
      <bind role="start" component="tela1"/>
    </link>
    <link xconnector="cnOnKeyStop">
      <bind role="onSelection" component="item1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela1"/>
    </link>

    <link xconnector="cnOnSelStart">
      <bind role="onSelection" component="item2"/>
      <bind role="start" component="tela2"/>
    </link>
    <link xconnector="cnOnKeyStop">
      <bind role="onSelection" component="item2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela2"/>
    </link>

    <link xconnector="cnOnSelStart">
      <bind role="onSelection" component="item3"/>
      <bind role="start" component="tela3"/>
    </link>
    <link xconnector="cnOnKeyStop">
      <bind role="onSelection" component="item3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela3"/>
    </link>

    <link xconnector="cnOnSelStart">
      <bind role="onSelection" component="item4"/>
      <bind role="start" component="tela4"/>
    </link>
    <link xconnector="cnOnKeyStop">
      <bind role="onSelection" component="item4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela4"/>
    </link>

    <link xconnector="cnOnSelStart">
      <bind role="onSelection" component="item5"/>
      <bind role="start" component="tela5"/>
    </link>
    <link xconnector="cnOnKeyStop">
      <bind role="onSelection" component="item5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela5"/>
    </link>
  </body>
</ncl>
