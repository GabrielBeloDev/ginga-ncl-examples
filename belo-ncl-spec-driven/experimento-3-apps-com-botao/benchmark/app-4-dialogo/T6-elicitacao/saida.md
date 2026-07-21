```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="dialogoSimNao" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgFundo"  left="0"   top="0"   width="1280" height="720" zIndex="0"/>
      <region id="rgBtnSim" left="380" top="590" width="220"  height="90"  zIndex="1"/>
      <region id="rgBtnNao" left="680" top="590" width="220"  height="90"  zIndex="1"/>
      <region id="rgTela"   left="0"   top="0"   width="1280" height="720" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>
      <descriptor id="dBtnSim" region="rgBtnSim"
                  focusIndex="1" moveLeft="2" moveRight="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnNao" region="rgBtnNao"
                  focusIndex="2" moveLeft="1" moveRight="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dTelaSim" region="rgTela" focusIndex="3"/>
      <descriptor id="dTelaNao" region="rgTela" focusIndex="4"/>
    </descriptorBase>

    <connectorBase>
      <causalConnector id="cAbreComFoco">
        <connectorParam name="idxFoco"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="set" value="$idxFoco"/>
        </compoundAction>
      </causalConnector>

      <causalConnector id="cVoltaComFoco">
        <connectorParam name="tecla"/>
        <connectorParam name="idxFoco"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$idxFoco"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>
  </head>

  <body>
    <port id="pSettings" component="settings"/>
    <port id="pFundo"    component="fundo"/>
    <port id="pBtnSim"   component="btnSim"/>
    <port id="pBtnNao"   component="btnNao"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="fundo"   src="fundo.png"    descriptor="dFundo"/>
    <media id="btnSim"  src="btn-sim.png"  descriptor="dBtnSim"/>
    <media id="btnNao"  src="btn-nao.png"  descriptor="dBtnNao"/>
    <media id="telaSim" src="tela-sim.png" descriptor="dTelaSim"/>
    <media id="telaNao" src="tela-nao.png" descriptor="dTelaNao"/>

    <link xconnector="cAbreComFoco">
      <bind role="onSelection" component="btnSim"/>
      <bind role="start" component="telaSim"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="idxFoco" value="3"/>
      </bind>
    </link>

    <link xconnector="cAbreComFoco">
      <bind role="onSelection" component="btnNao"/>
      <bind role="start" component="telaNao"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="idxFoco" value="4"/>
      </bind>
    </link>

    <link xconnector="cVoltaComFoco">
      <bind role="onSelection" component="telaSim">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaSim"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="idxFoco" value="1"/>
      </bind>
    </link>

    <link xconnector="cVoltaComFoco">
      <bind role="onSelection" component="telaNao">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaNao"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="idxFoco" value="1"/>
      </bind>
    </link>
  </body>
</ncl>
```
