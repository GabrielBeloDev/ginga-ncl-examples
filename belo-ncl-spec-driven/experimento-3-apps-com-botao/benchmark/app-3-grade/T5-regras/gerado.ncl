<?xml version="1.0" encoding="UTF-8"?>
<!--
  App: Grade de apps 2 linhas x 3 colunas (6 apps)
  Linha 1: VIDEO (app-1)  MUSICA (app-2)  FOTOS (app-3)
  Linha 2: JOGOS (app-4)  LOJA   (app-5)  CONFIG (app-6)
  Fundo: fundo.png
  Navegacao: setas CIMA/BAIXO/ESQ/DIR (circular, 2 direcoes)
  OK: abre a tela do app (tela-1..tela-6)
  VERMELHO: volta (fecha a tela)
  Foco inicial: primeiro app (VIDEO)
  Perfil: NCL 3.0 EDTV, autocontido.
-->
<ncl id="grade" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>
      <!-- Linha 1 -->
      <region id="rgApp1" left="90"  top="210" width="300" height="150" zIndex="1"/>
      <region id="rgApp2" left="490" top="210" width="300" height="150" zIndex="1"/>
      <region id="rgApp3" left="890" top="210" width="300" height="150" zIndex="1"/>
      <!-- Linha 2 -->
      <region id="rgApp4" left="90"  top="450" width="300" height="150" zIndex="1"/>
      <region id="rgApp5" left="490" top="450" width="300" height="150" zIndex="1"/>
      <region id="rgApp6" left="890" top="450" width="300" height="150" zIndex="1"/>
      <!-- Tela cheia dos apps -->
      <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Botoes navegaveis: focusIndex + moves circulares (grade 2x3) -->
      <descriptor id="dApp1" region="rgApp1" focusIndex="1"
                  moveLeft="3" moveRight="2" moveUp="4" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp2" region="rgApp2" focusIndex="2"
                  moveLeft="1" moveRight="3" moveUp="5" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp3" region="rgApp3" focusIndex="3"
                  moveLeft="2" moveRight="1" moveUp="6" moveDown="6"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp4" region="rgApp4" focusIndex="4"
                  moveLeft="6" moveRight="5" moveUp="1" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp5" region="rgApp5" focusIndex="5"
                  moveLeft="4" moveRight="6" moveUp="2" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp6" region="rgApp6" focusIndex="6"
                  moveLeft="5" moveRight="4" moveUp="3" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <descriptor id="dTela" region="rgTela"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK: seleciona o app -> abre a tela -->
      <causalConnector id="cAbre">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- Tecla VERMELHA: volta -> fecha a tela -->
      <causalConnector id="cVolta">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- Componente de entrada -->
    <port id="entry" component="fundo"/>
    <!-- Foco inicial no primeiro app -->
    <port id="pFoco" component="settings"/>
    <!-- Apps aparecem no inicio: cada um precisa de <port> -->
    <port id="pApp1" component="app1"/>
    <port id="pApp2" component="app2"/>
    <port id="pApp3" component="app3"/>
    <port id="pApp4" component="app4"/>
    <port id="pApp5" component="app5"/>
    <port id="pApp6" component="app6"/>

    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Linha 1 -->
    <media id="app1" src="app-1.png" descriptor="dApp1"/> <!-- VIDEO  -->
    <media id="app2" src="app-2.png" descriptor="dApp2"/> <!-- MUSICA -->
    <media id="app3" src="app-3.png" descriptor="dApp3"/> <!-- FOTOS  -->
    <!-- Linha 2 -->
    <media id="app4" src="app-4.png" descriptor="dApp4"/> <!-- JOGOS  -->
    <media id="app5" src="app-5.png" descriptor="dApp5"/> <!-- LOJA   -->
    <media id="app6" src="app-6.png" descriptor="dApp6"/> <!-- CONFIG -->

    <!-- Telas dos apps (sem port: so aparecem ao apertar OK) -->
    <media id="tela1" src="tela-1.png" descriptor="dTela"/>
    <media id="tela2" src="tela-2.png" descriptor="dTela"/>
    <media id="tela3" src="tela-3.png" descriptor="dTela"/>
    <media id="tela4" src="tela-4.png" descriptor="dTela"/>
    <media id="tela5" src="tela-5.png" descriptor="dTela"/>
    <media id="tela6" src="tela-6.png" descriptor="dTela"/>

    <!-- OK abre a tela de cada app -->
    <link xconnector="cAbre">
      <bind role="onSelection" component="app1"/>
      <bind role="start" component="tela1"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="app2"/>
      <bind role="start" component="tela2"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="app3"/>
      <bind role="start" component="tela3"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="app4"/>
      <bind role="start" component="tela4"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="app5"/>
      <bind role="start" component="tela5"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="app6"/>
      <bind role="start" component="tela6"/>
    </link>

    <!-- VERMELHO fecha a tela (foco permanece no app que a abriu) -->
    <link xconnector="cVolta">
      <bind role="onSelection" component="app1"><bindParam name="tecla" value="RED"/></bind>
      <bind role="stop" component="tela1"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="app2"><bindParam name="tecla" value="RED"/></bind>
      <bind role="stop" component="tela2"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="app3"><bindParam name="tecla" value="RED"/></bind>
      <bind role="stop" component="tela3"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="app4"><bindParam name="tecla" value="RED"/></bind>
      <bind role="stop" component="tela4"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="app5"><bindParam name="tecla" value="RED"/></bind>
      <bind role="stop" component="tela5"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="app6"><bindParam name="tecla" value="RED"/></bind>
      <bind role="stop" component="tela6"/>
    </link>

  </body>
</ncl>
