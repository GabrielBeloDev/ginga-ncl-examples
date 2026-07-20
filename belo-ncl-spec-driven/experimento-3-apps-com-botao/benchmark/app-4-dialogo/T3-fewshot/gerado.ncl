<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="dialogoCanalBelo" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
 <head>
  <regionBase>
   <region id="rBg" width="100%" height="100%" zIndex="0"/>
   <region id="rTela" width="100%" height="100%" zIndex="5"/>
   <region id="rSim" left="20%" top="80%" width="25%" height="12%" zIndex="2"/>
   <region id="rNao" left="55%" top="80%" width="25%" height="12%" zIndex="2"/>
  </regionBase>
  <descriptorBase>
   <descriptor id="dBg" region="rBg"/>
   <descriptor id="dTela" region="rTela"/>
   <descriptor id="dSim" region="rSim" focusIndex="1" moveRight="2" moveLeft="2" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="dNao" region="rNao" focusIndex="2" moveRight="1" moveLeft="1" focusBorderColor="yellow" focusBorderWidth="4"/>
  </descriptorBase>
  <connectorBase>
   <causalConnector id="cSel"><simpleCondition role="onSelection"/><simpleAction role="start"/></causalConnector>
   <causalConnector id="cKey"><connectorParam name="tecla"/><simpleCondition role="onSelection" key="$tecla"/><simpleAction role="stop"/></causalConnector>
  </connectorBase>
 </head>
 <body>
  <port id="eFundo" component="fundo"/>
  <port id="eCfg" component="cfg"/>
  <port id="eSim" component="bSim"/>
  <port id="eNao" component="bNao"/>
  <media id="cfg" type="application/x-ginga-settings"><property name="service.currentFocus" value="1"/></media>
  <media id="fundo" src="fundo.png" descriptor="dBg"/>
  <media id="bSim" src="btn-sim.png" descriptor="dSim"/>
  <media id="bNao" src="btn-nao.png" descriptor="dNao"/>
  <media id="tSim" src="tela-sim.png" descriptor="dTela"/>
  <media id="tNao" src="tela-nao.png" descriptor="dTela"/>
  <link xconnector="cSel"><bind role="onSelection" component="bSim"/><bind role="start" component="tSim"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="bNao"/><bind role="start" component="tNao"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tSim"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tSim"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tNao"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tNao"/></link>
 </body>
</ncl>
