<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Guia de programacao: lista vertical de 5 itens (setas cima/baixo), OK abre, VERMELHO volta. NCL puro. -->
<ncl id="guia" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rBg" width="100%" height="100%" zIndex="0"/>
      <region id="rConteudo" width="100%" height="100%" zIndex="5"/>
      <region id="rI1" left="5%" top="14%" width="45%" height="12%" zIndex="2"/>
      <region id="rI2" left="5%" top="30%" width="45%" height="12%" zIndex="2"/>
      <region id="rI3" left="5%" top="46%" width="45%" height="12%" zIndex="2"/>
      <region id="rI4" left="5%" top="62%" width="45%" height="12%" zIndex="2"/>
      <region id="rI5" left="5%" top="78%" width="45%" height="12%" zIndex="2"/>
    </regionBase>
    <descriptorBase>
      <descriptor id="dBg" region="rBg"/>
      <descriptor id="dConteudo" region="rConteudo"/>
      <descriptor id="dI1" region="rI1" focusIndex="1" moveDown="2" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dI2" region="rI2" focusIndex="2" moveDown="3" moveUp="1" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dI3" region="rI3" focusIndex="3" moveDown="4" moveUp="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dI4" region="rI4" focusIndex="4" moveDown="5" moveUp="3" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dI5" region="rI5" focusIndex="5" moveDown="1" moveUp="4" focusBorderColor="yellow" focusBorderWidth="4"/>
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
    <port id="p1" component="i1"/>
    <port id="p2" component="i2"/>
    <port id="p3" component="i3"/>
    <port id="p4" component="i4"/>
    <port id="p5" component="i5"/>
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>
    <media id="fundo" src="fundo.png" descriptor="dBg"/>
    <media id="i1" src="item-1.png" descriptor="dI1"/>
    <media id="i2" src="item-2.png" descriptor="dI2"/>
    <media id="i3" src="item-3.png" descriptor="dI3"/>
    <media id="i4" src="item-4.png" descriptor="dI4"/>
    <media id="i5" src="item-5.png" descriptor="dI5"/>
    <media id="tela1" src="tela-1.png" descriptor="dConteudo"/>
    <media id="tela2" src="tela-2.png" descriptor="dConteudo"/>
    <media id="tela3" src="tela-3.png" descriptor="dConteudo"/>
    <media id="tela4" src="tela-4.png" descriptor="dConteudo"/>
    <media id="tela5" src="tela-5.png" descriptor="dConteudo"/>

    <link xconnector="onSelStart"><bind role="onSelection" component="i1"/><bind role="start" component="tela1"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="i2"/><bind role="start" component="tela2"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="i3"/><bind role="start" component="tela3"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="i4"/><bind role="start" component="tela4"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="i5"/><bind role="start" component="tela5"/></link>

    <link xconnector="onKeyStop"><bind role="onSelection" component="tela1"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela1"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela2"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela2"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela3"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela3"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela4"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela4"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela5"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela5"/></link>
  </body>
</ncl>
