<?xml version="1.0" encoding="UTF-8"?>
<ncl id="gradeApps" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- Fundo em tela cheia (1280x720) -->
      <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>

      <!-- Grade 2 linhas x 3 colunas, botoes de 300x150 -->
      <!-- Linha 1 -->
      <region id="rgApp1" left="95"  top="205" width="300" height="150" zIndex="1"/>
      <region id="rgApp2" left="490" top="205" width="300" height="150" zIndex="1"/>
      <region id="rgApp3" left="885" top="205" width="300" height="150" zIndex="1"/>
      <!-- Linha 2 -->
      <region id="rgApp4" left="95"  top="450" width="300" height="150" zIndex="1"/>
      <region id="rgApp5" left="490" top="450" width="300" height="150" zIndex="1"/>
      <region id="rgApp6" left="885" top="450" width="300" height="150" zIndex="1"/>

      <!-- Tela do app aberto, cobre tudo (zIndex maior) -->
      <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Descritores dos botoes: foco navegavel em 2 eixos (CIMA/BAIXO/ESQ/DIR).
           Grade de indices:
             1 2 3
             4 5 6                                                       -->
      <descriptor id="dApp1" region="rgApp1" focusIndex="1"
                  moveRight="2" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp2" region="rgApp2" focusIndex="2"
                  moveLeft="1" moveRight="3" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp3" region="rgApp3" focusIndex="3"
                  moveLeft="2" moveDown="6"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp4" region="rgApp4" focusIndex="4"
                  moveUp="1" moveRight="5"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp5" region="rgApp5" focusIndex="5"
                  moveUp="2" moveLeft="4" moveRight="6"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp6" region="rgApp6" focusIndex="6"
                  moveUp="3" moveLeft="5"
                  focusBorderColor="yellow" focusBorderWidth="5"/>

      <!-- Telas dos apps: focaveis (focusIndex 11..16) para capturar o VERMELHO -->
      <descriptor id="dTela1" region="rgTela" focusIndex="11" focusBorderWidth="0"/>
      <descriptor id="dTela2" region="rgTela" focusIndex="12" focusBorderWidth="0"/>
      <descriptor id="dTela3" region="rgTela" focusIndex="13" focusBorderWidth="0"/>
      <descriptor id="dTela4" region="rgTela" focusIndex="14" focusBorderWidth="0"/>
      <descriptor id="dTela5" region="rgTela" focusIndex="15" focusBorderWidth="0"/>
      <descriptor id="dTela6" region="rgTela" focusIndex="16" focusBorderWidth="0"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK sobre o botao em foco: para a grade, abre a tela e foca a tela -->
      <causalConnector id="cAbre">
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="stop" max="unbounded"/>
          <simpleAction role="start"/>
          <simpleAction role="set" value="$foco"/>
        </compoundAction>
      </causalConnector>

      <!-- VERMELHO sobre a tela aberta: fecha a tela, volta a grade e refoca o botao -->
      <causalConnector id="cVolta">
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="start" max="unbounded"/>
          <simpleAction role="set" value="$foco"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- Foco inicial no primeiro app (VIDEO / focusIndex 1) -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Fundo -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- Botoes da grade -->
    <media id="btnVideo"  src="app-1.png" descriptor="dApp1"/>
    <media id="btnMusica" src="app-2.png" descriptor="dApp2"/>
    <media id="btnFotos"  src="app-3.png" descriptor="dApp3"/>
    <media id="btnJogos"  src="app-4.png" descriptor="dApp4"/>
    <media id="btnLoja"   src="app-5.png" descriptor="dApp5"/>
    <media id="btnConfig" src="app-6.png" descriptor="dApp6"/>

    <!-- Telas dos apps (iniciam paradas; abertas pelo OK) -->
    <media id="tela1" src="tela-1.png" descriptor="dTela1"/>
    <media id="tela2" src="tela-2.png" descriptor="dTela2"/>
    <media id="tela3" src="tela-3.png" descriptor="dTela3"/>
    <media id="tela4" src="tela-4.png" descriptor="dTela4"/>
    <media id="tela5" src="tela-5.png" descriptor="dTela5"/>
    <media id="tela6" src="tela-6.png" descriptor="dTela6"/>

    <!-- Portas: a grade (fundo + 6 botoes) inicia com o documento -->
    <port id="pFundo" component="fundo"/>
    <port id="p1" component="btnVideo"/>
    <port id="p2" component="btnMusica"/>
    <port id="p3" component="btnFotos"/>
    <port id="p4" component="btnJogos"/>
    <port id="p5" component="btnLoja"/>
    <port id="p6" component="btnConfig"/>

    <!-- ================= OK: abre a tela do app ================= -->
    <link xconnector="cAbre" id="lAbre1">
      <linkParam name="foco" value="11"/>
      <bind role="onSelection" component="btnVideo"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnVideo"/>
      <bind role="stop" component="btnMusica"/>
      <bind role="stop" component="btnFotos"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnLoja"/>
      <bind role="stop" component="btnConfig"/>
      <bind role="start" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cAbre" id="lAbre2">
      <linkParam name="foco" value="12"/>
      <bind role="onSelection" component="btnMusica"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnVideo"/>
      <bind role="stop" component="btnMusica"/>
      <bind role="stop" component="btnFotos"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnLoja"/>
      <bind role="stop" component="btnConfig"/>
      <bind role="start" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cAbre" id="lAbre3">
      <linkParam name="foco" value="13"/>
      <bind role="onSelection" component="btnFotos"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnVideo"/>
      <bind role="stop" component="btnMusica"/>
      <bind role="stop" component="btnFotos"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnLoja"/>
      <bind role="stop" component="btnConfig"/>
      <bind role="start" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cAbre" id="lAbre4">
      <linkParam name="foco" value="14"/>
      <bind role="onSelection" component="btnJogos"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnVideo"/>
      <bind role="stop" component="btnMusica"/>
      <bind role="stop" component="btnFotos"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnLoja"/>
      <bind role="stop" component="btnConfig"/>
      <bind role="start" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cAbre" id="lAbre5">
      <linkParam name="foco" value="15"/>
      <bind role="onSelection" component="btnLoja"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnVideo"/>
      <bind role="stop" component="btnMusica"/>
      <bind role="stop" component="btnFotos"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnLoja"/>
      <bind role="stop" component="btnConfig"/>
      <bind role="start" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cAbre" id="lAbre6">
      <linkParam name="foco" value="16"/>
      <bind role="onSelection" component="btnConfig"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnVideo"/>
      <bind role="stop" component="btnMusica"/>
      <bind role="stop" component="btnFotos"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnLoja"/>
      <bind role="stop" component="btnConfig"/>
      <bind role="start" component="tela6"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <!-- ================= VERMELHO: volta para a grade ================= -->
    <link xconnector="cVolta" id="lVolta1">
      <linkParam name="foco" value="1"/>
      <bind role="onSelection" component="tela1"/>
      <bind role="stop" component="tela1"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnVideo"/>
      <bind role="start" component="btnMusica"/>
      <bind role="start" component="btnFotos"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnLoja"/>
      <bind role="start" component="btnConfig"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cVolta" id="lVolta2">
      <linkParam name="foco" value="2"/>
      <bind role="onSelection" component="tela2"/>
      <bind role="stop" component="tela2"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnVideo"/>
      <bind role="start" component="btnMusica"/>
      <bind role="start" component="btnFotos"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnLoja"/>
      <bind role="start" component="btnConfig"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cVolta" id="lVolta3">
      <linkParam name="foco" value="3"/>
      <bind role="onSelection" component="tela3"/>
      <bind role="stop" component="tela3"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnVideo"/>
      <bind role="start" component="btnMusica"/>
      <bind role="start" component="btnFotos"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnLoja"/>
      <bind role="start" component="btnConfig"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cVolta" id="lVolta4">
      <linkParam name="foco" value="4"/>
      <bind role="onSelection" component="tela4"/>
      <bind role="stop" component="tela4"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnVideo"/>
      <bind role="start" component="btnMusica"/>
      <bind role="start" component="btnFotos"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnLoja"/>
      <bind role="start" component="btnConfig"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cVolta" id="lVolta5">
      <linkParam name="foco" value="5"/>
      <bind role="onSelection" component="tela5"/>
      <bind role="stop" component="tela5"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnVideo"/>
      <bind role="start" component="btnMusica"/>
      <bind role="start" component="btnFotos"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnLoja"/>
      <bind role="start" component="btnConfig"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <link xconnector="cVolta" id="lVolta6">
      <linkParam name="foco" value="6"/>
      <bind role="onSelection" component="tela6"/>
      <bind role="stop" component="tela6"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnVideo"/>
      <bind role="start" component="btnMusica"/>
      <bind role="start" component="btnFotos"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnLoja"/>
      <bind role="start" component="btnConfig"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

  </body>
</ncl>
