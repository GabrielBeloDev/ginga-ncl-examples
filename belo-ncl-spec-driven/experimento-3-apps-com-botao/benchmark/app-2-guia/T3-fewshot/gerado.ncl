<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="guia" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
 <head>
  <regionBase>
   <region id="rBg" width="100%" height="100%" zIndex="0"/>
   <region id="rC" width="100%" height="100%" zIndex="5"/>
   <region id="r1" left="5%"  top="12%" width="40%" height="12%" zIndex="2"/>
   <region id="r2" left="5%"  top="28%" width="40%" height="12%" zIndex="2"/>
   <region id="r3" left="5%"  top="44%" width="40%" height="12%" zIndex="2"/>
   <region id="r4" left="5%"  top="60%" width="40%" height="12%" zIndex="2"/>
   <region id="r5" left="5%"  top="76%" width="40%" height="12%" zIndex="2"/>
  </regionBase>
  <descriptorBase>
   <descriptor id="dBg" region="rBg"/>
   <descriptor id="dC" region="rC"/>
   <descriptor id="d1" region="r1" focusIndex="1" moveUp="5" moveDown="2" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d2" region="r2" focusIndex="2" moveUp="1" moveDown="3" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d3" region="r3" focusIndex="3" moveUp="2" moveDown="4" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d4" region="r4" focusIndex="4" moveUp="3" moveDown="5" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d5" region="r5" focusIndex="5" moveUp="4" moveDown="1" focusBorderColor="yellow" focusBorderWidth="4"/>
  </descriptorBase>
  <connectorBase>
   <causalConnector id="cSel"><simpleCondition role="onSelection"/><simpleAction role="start"/></causalConnector>
   <causalConnector id="cKey"><connectorParam name="tecla"/><simpleCondition role="onSelection" key="$tecla"/><simpleAction role="stop"/></causalConnector>
  </connectorBase>
 </head>
 <body>
  <port id="pe" component="fundo"/>
  <port id="ps" component="cfg"/>
  <port id="p1" component="i1"/>
  <port id="p2" component="i2"/>
  <port id="p3" component="i3"/>
  <port id="p4" component="i4"/>
  <port id="p5" component="i5"/>
  <media id="cfg" type="application/x-ginga-settings"><property name="service.currentFocus" value="1"/></media>
  <media id="fundo" src="fundo.png" descriptor="dBg"/>
  <media id="i1" src="item-1.png" descriptor="d1"/>
  <media id="i2" src="item-2.png" descriptor="d2"/>
  <media id="i3" src="item-3.png" descriptor="d3"/>
  <media id="i4" src="item-4.png" descriptor="d4"/>
  <media id="i5" src="item-5.png" descriptor="d5"/>
  <media id="t1" src="tela-1.png" descriptor="dC"/>
  <media id="t2" src="tela-2.png" descriptor="dC"/>
  <media id="t3" src="tela-3.png" descriptor="dC"/>
  <media id="t4" src="tela-4.png" descriptor="dC"/>
  <media id="t5" src="tela-5.png" descriptor="dC"/>
  <link xconnector="cSel"><bind role="onSelection" component="i1"/><bind role="start" component="t1"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="i2"/><bind role="start" component="t2"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="i3"/><bind role="start" component="t3"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="i4"/><bind role="start" component="t4"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="i5"/><bind role="start" component="t5"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t1"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t1"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t2"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t2"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t3"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t3"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t4"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t4"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t5"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t5"/></link>
 </body>
</ncl>
