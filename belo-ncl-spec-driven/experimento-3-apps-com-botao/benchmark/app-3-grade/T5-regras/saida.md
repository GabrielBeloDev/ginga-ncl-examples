<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Grade 2x3 (6 apps) sobre fundo.png: navegacao por setas, OK abre a tela do app, VERMELHO volta. NCL puro EDTV. -->
<ncl id="grade6" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rBg" width="100%" height="100%" zIndex="0"/>
      <region id="rConteudo" width="100%" height="100%" zIndex="5"/>
      <!-- Linha 1 -->
      <region id="rApp1" left="10%" top="20%" width="20%" height="22%" zIndex="2"/>
      <region id="rApp2" left="40%" top="20%" width="20%" height="22%" zIndex="2"/>
      <region id="rApp3" left="70%" top="20%" width="20%" height="22%" zIndex="2"/>
      <!-- Linha 2 -->
      <region id="rApp4" left="10%" top="55%" width="20%" height="22%" zIndex="2"/>
      <region id="rApp5" left="40%" top="55%" width="20%" height="22%" zIndex="2"/>
      <region id="rApp6" left="70%" top="55%" width="20%" height="22%" zIndex="2"/>
    </regionBase>
    <descriptorBase>
      <descriptor id="dBg" region="rBg"/>
      <descriptor id="dConteudo" region="rConteudo"/>
      <!-- Grade circular: 1 2 3 / 4 5 6 -->
      <descriptor id="dApp1" region="rApp1" focusIndex="1" moveRight="2" moveLeft="3" moveDown="4" moveUp="4" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp2" region="rApp2" focusIndex="2" moveRight="3" moveLeft="1" moveDown="5" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp3" region="rApp3" focusIndex="3" moveRight="1" moveLeft="2" moveDown="6" moveUp="6" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp4" region="rApp4" focusIndex="4" moveRight="5" moveLeft="6" moveUp="1" moveDown="1" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp5" region="rApp5" focusIndex="5" moveRight="6" moveLeft="4" moveUp="2" moveDown="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp6" region="rApp6" focusIndex="6" moveRight="4" moveLeft="5" moveUp="3" moveDown="3" focusBorderColor="yellow" focusBorderWidth="4"/>
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
    <port id="pApp1" component="app1"/>
    <port id="pApp2" component="app2"/>
    <port id="pApp3" component="app3"/>
    <port id="pApp4" component="app4"/>
    <port id="pApp5" component="app5"/>
    <port id="pApp6" component="app6"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="dBg"/>

    <media id="app1" src="app-1.png" descriptor="dApp1"/>
    <media id="app2" src="app-2.png" descriptor="dApp2"/>
    <media id="app3" src="app-3.png" descriptor="dApp3"/>
    <media id="app4" src="app-4.png" descriptor="dApp4"/>
    <media id="app5" src="app-5.png" descriptor="dApp5"/>
    <media id="app6" src="app-6.png" descriptor="dApp6"/>

    <media id="tela1" src="tela-1.png" descriptor="dConteudo"/>
    <media id="tela2" src="tela-2.png" descriptor="dConteudo"/>
    <media id="tela3" src="tela-3.png" descriptor="dConteudo"/>
    <media id="tela4" src="tela-4.png" descriptor="dConteudo"/>
    <media id="tela5" src="tela-5.png" descriptor="dConteudo"/>
    <media id="tela6" src="tela-6.png" descriptor="dConteudo"/>

    <!-- OK em cada app abre a tela correspondente -->
    <link xconnector="onSelStart"><bind role="onSelection" component="app1"/><bind role="start" component="tela1"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="app2"/><bind role="start" component="tela2"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="app3"/><bind role="start" component="tela3"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="app4"/><bind role="start" component="tela4"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="app5"/><bind role="start" component="tela5"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="app6"/><bind role="start" component="tela6"/></link>

    <!-- VERMELHO fecha a tela e volta a grade -->
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela1"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela1"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela2"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela2"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela3"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela3"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela4"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela4"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela5"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela5"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela6"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela6"/></link>
  </body>
</ncl>
