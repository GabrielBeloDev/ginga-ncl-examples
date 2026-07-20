<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Grade 2x3 de aplicativos: navegacao em 2 direcoes (setas), OK abre, VERMELHO volta. NCL puro. -->
<ncl id="grade" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rBg" width="100%" height="100%" zIndex="0"/>
      <region id="rConteudo" width="100%" height="100%" zIndex="5"/>
      <region id="rA1" left="6%"  top="22%" width="26%" height="26%" zIndex="2"/>
      <region id="rA2" left="37%" top="22%" width="26%" height="26%" zIndex="2"/>
      <region id="rA3" left="68%" top="22%" width="26%" height="26%" zIndex="2"/>
      <region id="rA4" left="6%"  top="55%" width="26%" height="26%" zIndex="2"/>
      <region id="rA5" left="37%" top="55%" width="26%" height="26%" zIndex="2"/>
      <region id="rA6" left="68%" top="55%" width="26%" height="26%" zIndex="2"/>
    </regionBase>
    <descriptorBase>
      <descriptor id="dBg" region="rBg"/>
      <descriptor id="dConteudo" region="rConteudo"/>
      <descriptor id="dA1" region="rA1" focusIndex="1" moveRight="2" moveLeft="3" moveDown="4" moveUp="4" focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dA2" region="rA2" focusIndex="2" moveRight="3" moveLeft="1" moveDown="5" moveUp="5" focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dA3" region="rA3" focusIndex="3" moveRight="1" moveLeft="2" moveDown="6" moveUp="6" focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dA4" region="rA4" focusIndex="4" moveRight="5" moveLeft="6" moveDown="1" moveUp="1" focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dA5" region="rA5" focusIndex="5" moveRight="6" moveLeft="4" moveDown="2" moveUp="2" focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dA6" region="rA6" focusIndex="6" moveRight="4" moveLeft="5" moveDown="3" moveUp="3" focusBorderColor="yellow" focusBorderWidth="5"/>
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
    <port id="entry" component="fundo"/>
    <port id="pSet" component="settings"/>
    <port id="p1" component="a1"/>
    <port id="p2" component="a2"/>
    <port id="p3" component="a3"/>
    <port id="p4" component="a4"/>
    <port id="p5" component="a5"/>
    <port id="p6" component="a6"/>
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>
    <media id="fundo" src="fundo.png" descriptor="dBg"/>
    <media id="a1" src="app-1.png" descriptor="dA1"/>
    <media id="a2" src="app-2.png" descriptor="dA2"/>
    <media id="a3" src="app-3.png" descriptor="dA3"/>
    <media id="a4" src="app-4.png" descriptor="dA4"/>
    <media id="a5" src="app-5.png" descriptor="dA5"/>
    <media id="a6" src="app-6.png" descriptor="dA6"/>
    <media id="tela1" src="tela-1.png" descriptor="dConteudo"/>
    <media id="tela2" src="tela-2.png" descriptor="dConteudo"/>
    <media id="tela3" src="tela-3.png" descriptor="dConteudo"/>
    <media id="tela4" src="tela-4.png" descriptor="dConteudo"/>
    <media id="tela5" src="tela-5.png" descriptor="dConteudo"/>
    <media id="tela6" src="tela-6.png" descriptor="dConteudo"/>

    <link xconnector="onSelStart"><bind role="onSelection" component="a1"/><bind role="start" component="tela1"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="a2"/><bind role="start" component="tela2"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="a3"/><bind role="start" component="tela3"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="a4"/><bind role="start" component="tela4"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="a5"/><bind role="start" component="tela5"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="a6"/><bind role="start" component="tela6"/></link>

    <link xconnector="onKeyStop"><bind role="onSelection" component="tela1"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela1"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela2"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela2"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela3"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela3"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela4"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela4"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela5"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela5"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela6"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela6"/></link>
  </body>
</ncl>
