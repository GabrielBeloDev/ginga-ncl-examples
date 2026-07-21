<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Menu com 4 botoes navegaveis (setas ESQ/DIR circular), OK abre tela cheia, VERMELHO volta. NCL puro EDTV. -->
<ncl id="menu4botoes" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rBg" width="100%" height="100%" zIndex="0"/>
      <region id="rConteudo" width="100%" height="100%" zIndex="5"/>
      <region id="rB1" left="5%"  top="80%" width="20%" height="12%" zIndex="2"/>
      <region id="rB2" left="28%" top="80%" width="20%" height="12%" zIndex="2"/>
      <region id="rB3" left="51%" top="80%" width="20%" height="12%" zIndex="2"/>
      <region id="rB4" left="74%" top="80%" width="20%" height="12%" zIndex="2"/>
    </regionBase>
    <descriptorBase>
      <descriptor id="dBg" region="rBg"/>
      <descriptor id="dConteudo" region="rConteudo"/>
      <descriptor id="dB1" region="rB1" focusIndex="1" moveRight="2" moveLeft="4" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dB2" region="rB2" focusIndex="2" moveRight="3" moveLeft="1" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dB3" region="rB3" focusIndex="3" moveRight="4" moveLeft="2" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dB4" region="rB4" focusIndex="4" moveRight="1" moveLeft="3" focusBorderColor="yellow" focusBorderWidth="4"/>
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
    <port id="pB1" component="b1"/>
    <port id="pB2" component="b2"/>
    <port id="pB3" component="b3"/>
    <port id="pB4" component="b4"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="dBg"/>
    <media id="b1" src="btn-jogos.png"    descriptor="dB1"/>
    <media id="b2" src="btn-noticias.png" descriptor="dB2"/>
    <media id="b3" src="btn-clima.png"    descriptor="dB3"/>
    <media id="b4" src="btn-sobre.png"    descriptor="dB4"/>

    <media id="tela1" src="tela-jogos.png"    descriptor="dConteudo"/>
    <media id="tela2" src="tela-noticias.png" descriptor="dConteudo"/>
    <media id="tela3" src="tela-clima.png"    descriptor="dConteudo"/>
    <media id="tela4" src="tela-sobre.png"    descriptor="dConteudo"/>

    <!-- OK em cada botao abre a tela cheia correspondente -->
    <link xconnector="onSelStart"><bind role="onSelection" component="b1"/><bind role="start" component="tela1"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="b2"/><bind role="start" component="tela2"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="b3"/><bind role="start" component="tela3"/></link>
    <link xconnector="onSelStart"><bind role="onSelection" component="b4"/><bind role="start" component="tela4"/></link>

    <!-- VERMELHO fecha a tela e volta ao menu -->
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela1"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela1"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela2"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela2"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela3"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela3"/></link>
    <link xconnector="onKeyStop"><bind role="onSelection" component="tela4"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tela4"/></link>
  </body>
</ncl>
