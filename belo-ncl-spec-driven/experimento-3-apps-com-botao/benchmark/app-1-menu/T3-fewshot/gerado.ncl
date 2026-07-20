<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="menu4" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
 <head>
  <regionBase>
   <region id="rBg" width="100%" height="100%" zIndex="0"/>
   <region id="rC" width="100%" height="100%" zIndex="5"/>
   <region id="rJogos"    left="3%"  top="82%" width="21%" height="12%" zIndex="2"/>
   <region id="rNoticias" left="27%" top="82%" width="21%" height="12%" zIndex="2"/>
   <region id="rClima"    left="51%" top="82%" width="21%" height="12%" zIndex="2"/>
   <region id="rSobre"    left="75%" top="82%" width="21%" height="12%" zIndex="2"/>
  </regionBase>
  <descriptorBase>
   <descriptor id="dBg" region="rBg"/>
   <descriptor id="dC" region="rC"/>
   <descriptor id="dJogos"    region="rJogos"    focusIndex="1" moveRight="2" moveLeft="4" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="dNoticias" region="rNoticias" focusIndex="2" moveRight="3" moveLeft="1" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="dClima"    region="rClima"    focusIndex="3" moveRight="4" moveLeft="2" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="dSobre"    region="rSobre"    focusIndex="4" moveRight="1" moveLeft="3" focusBorderColor="yellow" focusBorderWidth="4"/>
  </descriptorBase>
  <connectorBase>
   <causalConnector id="cSel"><simpleCondition role="onSelection"/><simpleAction role="start"/></causalConnector>
   <causalConnector id="cKey"><connectorParam name="tecla"/><simpleCondition role="onSelection" key="$tecla"/><simpleAction role="stop"/></causalConnector>
  </connectorBase>
 </head>
 <body>
  <port id="e"  component="fundo"/>
  <port id="ps" component="cfg"/>
  <port id="p1" component="bJogos"/>
  <port id="p2" component="bNoticias"/>
  <port id="p3" component="bClima"/>
  <port id="p4" component="bSobre"/>
  <media id="cfg" type="application/x-ginga-settings"><property name="service.currentFocus" value="1"/></media>
  <media id="fundo" src="fundo.png" descriptor="dBg"/>
  <media id="bJogos"    src="btn-jogos.png"    descriptor="dJogos"/>
  <media id="bNoticias" src="btn-noticias.png" descriptor="dNoticias"/>
  <media id="bClima"    src="btn-clima.png"    descriptor="dClima"/>
  <media id="bSobre"    src="btn-sobre.png"    descriptor="dSobre"/>
  <media id="tJogos"    src="tela-jogos.png"    descriptor="dC"/>
  <media id="tNoticias" src="tela-noticias.png" descriptor="dC"/>
  <media id="tClima"    src="tela-clima.png"    descriptor="dC"/>
  <media id="tSobre"    src="tela-sobre.png"    descriptor="dC"/>
  <link xconnector="cSel"><bind role="onSelection" component="bJogos"/><bind role="start" component="tJogos"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="bNoticias"/><bind role="start" component="tNoticias"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="bClima"/><bind role="start" component="tClima"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="bSobre"/><bind role="start" component="tSobre"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tJogos"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tJogos"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tNoticias"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tNoticias"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tClima"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tClima"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tSobre"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tSobre"/></link>
 </body>
</ncl>
