<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="grade" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
 <head>
  <regionBase>
   <region id="rBg" width="100%" height="100%" zIndex="0"/>
   <region id="rC" width="100%" height="100%" zIndex="5"/>
   <region id="r1" left="8%"  top="28%" width="24%" height="22%" zIndex="2"/>
   <region id="r2" left="38%" top="28%" width="24%" height="22%" zIndex="2"/>
   <region id="r3" left="68%" top="28%" width="24%" height="22%" zIndex="2"/>
   <region id="r4" left="8%"  top="58%" width="24%" height="22%" zIndex="2"/>
   <region id="r5" left="38%" top="58%" width="24%" height="22%" zIndex="2"/>
   <region id="r6" left="68%" top="58%" width="24%" height="22%" zIndex="2"/>
  </regionBase>
  <descriptorBase>
   <descriptor id="dBg" region="rBg"/>
   <descriptor id="dC" region="rC"/>
   <descriptor id="d1" region="r1" focusIndex="1" moveRight="2" moveLeft="3" moveDown="4" moveUp="4" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d2" region="r2" focusIndex="2" moveRight="3" moveLeft="1" moveDown="5" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d3" region="r3" focusIndex="3" moveRight="1" moveLeft="2" moveDown="6" moveUp="6" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d4" region="r4" focusIndex="4" moveRight="5" moveLeft="6" moveDown="1" moveUp="1" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d5" region="r5" focusIndex="5" moveRight="6" moveLeft="4" moveDown="2" moveUp="2" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="d6" region="r6" focusIndex="6" moveRight="4" moveLeft="5" moveDown="3" moveUp="3" focusBorderColor="yellow" focusBorderWidth="4"/>
  </descriptorBase>
  <connectorBase>
   <causalConnector id="cSel"><simpleCondition role="onSelection"/><simpleAction role="start"/></causalConnector>
   <causalConnector id="cKey"><connectorParam name="tecla"/><simpleCondition role="onSelection" key="$tecla"/><simpleAction role="stop"/></causalConnector>
  </connectorBase>
 </head>
 <body>
  <port id="e" component="fundo"/>
  <port id="ps" component="cfg"/>
  <port id="p1" component="a1"/>
  <port id="p2" component="a2"/>
  <port id="p3" component="a3"/>
  <port id="p4" component="a4"/>
  <port id="p5" component="a5"/>
  <port id="p6" component="a6"/>
  <media id="cfg" type="application/x-ginga-settings"><property name="service.currentFocus" value="1"/></media>
  <media id="fundo" src="fundo.png" descriptor="dBg"/>
  <media id="a1" src="app-1.png" descriptor="d1"/>
  <media id="a2" src="app-2.png" descriptor="d2"/>
  <media id="a3" src="app-3.png" descriptor="d3"/>
  <media id="a4" src="app-4.png" descriptor="d4"/>
  <media id="a5" src="app-5.png" descriptor="d5"/>
  <media id="a6" src="app-6.png" descriptor="d6"/>
  <media id="t1" src="tela-1.png" descriptor="dC"/>
  <media id="t2" src="tela-2.png" descriptor="dC"/>
  <media id="t3" src="tela-3.png" descriptor="dC"/>
  <media id="t4" src="tela-4.png" descriptor="dC"/>
  <media id="t5" src="tela-5.png" descriptor="dC"/>
  <media id="t6" src="tela-6.png" descriptor="dC"/>
  <link xconnector="cSel"><bind role="onSelection" component="a1"/><bind role="start" component="t1"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="a2"/><bind role="start" component="t2"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="a3"/><bind role="start" component="t3"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="a4"/><bind role="start" component="t4"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="a5"/><bind role="start" component="t5"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="a6"/><bind role="start" component="t6"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t1"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t1"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t2"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t2"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t3"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t3"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t4"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t4"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t5"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t5"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="t6"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="t6"/></link>
 </body>
</ncl>
