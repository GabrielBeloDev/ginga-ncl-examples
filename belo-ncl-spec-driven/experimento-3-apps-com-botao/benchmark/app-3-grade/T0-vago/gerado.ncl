<?xml version="1.0" encoding="UTF-8"?>
<!--
  gerado.ncl
  App NCL/Ginga: grade de aplicativos 2x3 com botoes.
  Usa apenas as imagens da pasta:
    fundo.png            -> plano de fundo com cabecalho de instrucoes
    app-1..app-6.png     -> botoes 300x150 (VIDEO, MUSICA, FOTOS, JOGOS, LOJA, CONFIG)
    tela-1..tela-6.png   -> tela cheia de cada app (1280x720)
  Interacao:
    Setas (up/down/left/right) -> navega o foco entre os 6 botoes (com wrap)
    OK / ENTER                 -> abre a tela do app focado
    VERMELHO (RED)             -> volta da tela para a grade
  Layout 2 linhas x 3 colunas (1280x720):
    [ VIDEO ] [ MUSICA ] [ FOTOS  ]   -> indices de foco 1 2 3
    [ JOGOS ] [ LOJA   ] [ CONFIG ]   -> indices de foco 4 5 6
-->
<ncl id="gradeApps" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <region id="rgScreen" left="0" top="0" width="1280" height="720" zIndex="0">
        <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>
        <!-- Linha 1 -->
        <region id="rgApp1" left="95"  top="200" width="300" height="150" zIndex="1"/>
        <region id="rgApp2" left="490" top="200" width="300" height="150" zIndex="1"/>
        <region id="rgApp3" left="885" top="200" width="300" height="150" zIndex="1"/>
        <!-- Linha 2 -->
        <region id="rgApp4" left="95"  top="460" width="300" height="150" zIndex="1"/>
        <region id="rgApp5" left="490" top="460" width="300" height="150" zIndex="1"/>
        <region id="rgApp6" left="885" top="460" width="300" height="150" zIndex="1"/>
        <!-- Tela cheia dos apps abertos (fica por cima da grade) -->
        <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="5"/>
      </region>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Botoes: focusIndex 1..6 e navegacao com wrap. Borda de foco amarela. -->
      <descriptor id="dApp1" region="rgApp1" focusIndex="1"
                  moveRight="2" moveLeft="3" moveDown="4" moveUp="4"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp2" region="rgApp2" focusIndex="2"
                  moveRight="3" moveLeft="1" moveDown="5" moveUp="5"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp3" region="rgApp3" focusIndex="3"
                  moveRight="1" moveLeft="2" moveDown="6" moveUp="6"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp4" region="rgApp4" focusIndex="4"
                  moveRight="5" moveLeft="6" moveDown="1" moveUp="1"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp5" region="rgApp5" focusIndex="5"
                  moveRight="6" moveLeft="4" moveDown="2" moveUp="2"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dApp6" region="rgApp6" focusIndex="6"
                  moveRight="4" moveLeft="5" moveDown="3" moveUp="3"
                  focusBorderColor="yellow" focusBorderWidth="5"/>

      <!-- Telas cheias: focusIndex 101..106 (para receberem a tecla VERMELHO). -->
      <descriptor id="dTela1" region="rgTela" focusIndex="101"/>
      <descriptor id="dTela2" region="rgTela" focusIndex="102"/>
      <descriptor id="dTela3" region="rgTela" focusIndex="103"/>
      <descriptor id="dTela4" region="rgTela" focusIndex="104"/>
      <descriptor id="dTela5" region="rgTela" focusIndex="105"/>
      <descriptor id="dTela6" region="rgTela" focusIndex="106"/>
    </descriptorBase>

    <connectorBase>
      <!-- Ao iniciar, define o foco inicial. -->
      <causalConnector id="cOnBeginSet">
        <connectorParam name="valor"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$valor"/>
      </causalConnector>

      <!-- Selecao de tecla: inicia um no e ajusta o foco atual. -->
      <causalConnector id="cSelStartSet">
        <connectorParam name="tecla"/>
        <connectorParam name="valor"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="set" value="$valor"/>
        </compoundAction>
      </causalConnector>

      <!-- Selecao de tecla: para um no e ajusta o foco atual. -->
      <causalConnector id="cSelStopSet">
        <connectorParam name="tecla"/>
        <connectorParam name="valor"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$valor"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- Portas: tudo isto inicia com o documento. As telas NAO tem porta. -->
    <port id="pFundo" component="fundo"/>
    <port id="pApp1" component="app1"/>
    <port id="pApp2" component="app2"/>
    <port id="pApp3" component="app3"/>
    <port id="pApp4" component="app4"/>
    <port id="pApp5" component="app5"/>
    <port id="pApp6" component="app6"/>

    <!-- No de settings: guarda o foco atual. -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <media id="app1" src="app-1.png" descriptor="dApp1"/>
    <media id="app2" src="app-2.png" descriptor="dApp2"/>
    <media id="app3" src="app-3.png" descriptor="dApp3"/>
    <media id="app4" src="app-4.png" descriptor="dApp4"/>
    <media id="app5" src="app-5.png" descriptor="dApp5"/>
    <media id="app6" src="app-6.png" descriptor="dApp6"/>

    <media id="tela1" src="tela-1.png" descriptor="dTela1"/>
    <media id="tela2" src="tela-2.png" descriptor="dTela2"/>
    <media id="tela3" src="tela-3.png" descriptor="dTela3"/>
    <media id="tela4" src="tela-4.png" descriptor="dTela4"/>
    <media id="tela5" src="tela-5.png" descriptor="dTela5"/>
    <media id="tela6" src="tela-6.png" descriptor="dTela6"/>

    <!-- Foco inicial no botao 1 (VIDEO). -->
    <link xconnector="cOnBeginSet">
      <bind role="onBegin" component="fundo"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="1"/>
      </bind>
    </link>

    <!-- ABRIR: OK/ENTER no botao focado inicia a tela e move o foco para ela. -->
    <link xconnector="cSelStartSet">
      <bind role="onSelection" component="app1">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="start" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="101"/>
      </bind>
    </link>
    <link xconnector="cSelStartSet">
      <bind role="onSelection" component="app2">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="start" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="102"/>
      </bind>
    </link>
    <link xconnector="cSelStartSet">
      <bind role="onSelection" component="app3">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="start" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="103"/>
      </bind>
    </link>
    <link xconnector="cSelStartSet">
      <bind role="onSelection" component="app4">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="start" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="104"/>
      </bind>
    </link>
    <link xconnector="cSelStartSet">
      <bind role="onSelection" component="app5">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="start" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="105"/>
      </bind>
    </link>
    <link xconnector="cSelStartSet">
      <bind role="onSelection" component="app6">
        <bindParam name="tecla" value="ENTER"/>
      </bind>
      <bind role="start" component="tela6"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="106"/>
      </bind>
    </link>

    <!-- VOLTAR: VERMELHO na tela para a tela e devolve o foco ao botao de origem. -->
    <link xconnector="cSelStopSet">
      <bind role="onSelection" component="tela1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela1"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="1"/>
      </bind>
    </link>
    <link xconnector="cSelStopSet">
      <bind role="onSelection" component="tela2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela2"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="2"/>
      </bind>
    </link>
    <link xconnector="cSelStopSet">
      <bind role="onSelection" component="tela3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela3"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="3"/>
      </bind>
    </link>
    <link xconnector="cSelStopSet">
      <bind role="onSelection" component="tela4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela4"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="4"/>
      </bind>
    </link>
    <link xconnector="cSelStopSet">
      <bind role="onSelection" component="tela5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela5"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="5"/>
      </bind>
    </link>
    <link xconnector="cSelStopSet">
      <bind role="onSelection" component="tela6">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela6"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="valor" value="6"/>
      </bind>
    </link>

  </body>
</ncl>
