<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  gerado.ncl - App NCL: Menu horizontal de canais com botoes (Ginga-NCL)

  Pedido do usuario: "cria um app NCL de menu horizontal de canais com
  botoes, usando as imagens dessa pasta".

  Imagens usadas (todas da propria pasta, 1280x720 = tela cheia; botoes 260x70):
    - fundo.png          -> fundo do menu (titulo + instrucoes)
    - btn-clima.png      -> botao CLIMA    (laranja)
    - btn-jogos.png      -> botao JOGOS    (azul)
    - btn-noticias.png   -> botao NOTICIAS (verde)
    - btn-sobre.png      -> botao SOBRE    (roxo)
    - tela-clima.png     -> tela cheia do canal CLIMA
    - tela-jogos.png     -> tela cheia do canal JOGOS
    - tela-noticias.png  -> tela cheia do canal NOTICIAS
    - tela-sobre.png     -> tela cheia do canal SOBRE

  Interacao (conforme a dica exibida no fundo):
    SETAS ESQ/DIR -> navega entre os 4 botoes (foco com borda branca)
    OK / ENTER    -> abre a tela cheia do canal em foco
    VERMELHO      -> volta da tela cheia para o menu
-->
<ncl id="menuCanais" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- fundo e telas cheias ocupam toda a area 1280x720 -->
      <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="1"/>
      <region id="rgTela"  left="0" top="0" width="1280" height="720" zIndex="10"/>

      <!-- 4 botoes de 260x70 alinhados horizontalmente (gap = 48px) -->
      <region id="rgBtnClima"    left="48"  top="400" width="260" height="70" zIndex="5"/>
      <region id="rgBtnJogos"    left="356" top="400" width="260" height="70" zIndex="5"/>
      <region id="rgBtnNoticias" left="664" top="400" width="260" height="70" zIndex="5"/>
      <region id="rgBtnSobre"    left="972" top="400" width="260" height="70" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Cada botao tem focusIndex + moveLeft/moveRight para a navegacao
           horizontal. A borda branca marca o botao em foco. -->
      <descriptor id="dBtnClima"    region="rgBtnClima"
                  focusIndex="1" moveRight="2"
                  focusBorderColor="white" focusBorderWidth="4"/>
      <descriptor id="dBtnJogos"    region="rgBtnJogos"
                  focusIndex="2" moveLeft="1" moveRight="3"
                  focusBorderColor="white" focusBorderWidth="4"/>
      <descriptor id="dBtnNoticias" region="rgBtnNoticias"
                  focusIndex="3" moveLeft="2" moveRight="4"
                  focusBorderColor="white" focusBorderWidth="4"/>
      <descriptor id="dBtnSobre"    region="rgBtnSobre"
                  focusIndex="4" moveLeft="3"
                  focusBorderColor="white" focusBorderWidth="4"/>

      <!-- As telas cheias recebem foco (focusIndex proprio) para que a
           tecla VERMELHO seja capturada enquanto elas estao ativas. -->
      <descriptor id="dTelaClima"    region="rgTela" focusIndex="5"/>
      <descriptor id="dTelaJogos"    region="rgTela" focusIndex="6"/>
      <descriptor id="dTelaNoticias" region="rgTela" focusIndex="7"/>
      <descriptor id="dTelaSobre"    region="rgTela" focusIndex="8"/>
    </descriptorBase>

    <connectorBase>
      <!-- Quando o fundo inicia: liga os 4 botoes e poe o foco no 1o. -->
      <causalConnector id="onBeginStartSet">
        <connectorParam name="var"/>
        <simpleCondition role="onBegin"/>
        <compoundAction operator="seq">
          <simpleAction role="start" max="unbounded"/>
          <simpleAction role="set" value="$var"/>
        </compoundAction>
      </causalConnector>

      <!-- OK sobre um botao em foco: para o menu, abre a tela cheia e
           move o foco para essa tela (para o VERMELHO funcionar la). -->
      <causalConnector id="onSelStopStartSet">
        <connectorParam name="var"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"  max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
          <simpleAction role="set"   value="$var"/>
        </compoundAction>
      </causalConnector>

      <!-- VERMELHO sobre a tela cheia: fecha a tela e volta o fundo
           (o fundo, ao iniciar, reconstroi o menu via onBeginStartSet). -->
      <causalConnector id="onKeyStopStart">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"  max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- O documento comeca pelo fundo do menu -->
    <port id="pStart" component="fundo"/>

    <!-- Controle de foco do Ginga -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Fundo do menu -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- Botoes do menu horizontal -->
    <media id="btnClima"    src="btn-clima.png"    descriptor="dBtnClima"/>
    <media id="btnJogos"    src="btn-jogos.png"    descriptor="dBtnJogos"/>
    <media id="btnNoticias" src="btn-noticias.png" descriptor="dBtnNoticias"/>
    <media id="btnSobre"    src="btn-sobre.png"    descriptor="dBtnSobre"/>

    <!-- Telas cheias de cada canal -->
    <media id="telaClima"    src="tela-clima.png"    descriptor="dTelaClima"/>
    <media id="telaJogos"    src="tela-jogos.png"    descriptor="dTelaJogos"/>
    <media id="telaNoticias" src="tela-noticias.png" descriptor="dTelaNoticias"/>
    <media id="telaSobre"    src="tela-sobre.png"    descriptor="dTelaSobre"/>

    <!-- ============ MONTAGEM DO MENU ============ -->
    <!-- Ao iniciar o fundo, liga os 4 botoes e foca o primeiro (idx 1) -->
    <link id="lMontaMenu" xconnector="onBeginStartSet">
      <bind role="onBegin" component="fundo"/>
      <bind role="start" component="btnClima"/>
      <bind role="start" component="btnJogos"/>
      <bind role="start" component="btnNoticias"/>
      <bind role="start" component="btnSobre"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="1"/>
      </bind>
    </link>

    <!-- ============ OK: ABRE A TELA DO CANAL ============ -->
    <link id="lAbreClima" xconnector="onSelStopStartSet">
      <bind role="onSelection" component="btnClima"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnClima"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnNoticias"/>
      <bind role="stop" component="btnSobre"/>
      <bind role="start" component="telaClima"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="5"/>
      </bind>
    </link>

    <link id="lAbreJogos" xconnector="onSelStopStartSet">
      <bind role="onSelection" component="btnJogos"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnClima"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnNoticias"/>
      <bind role="stop" component="btnSobre"/>
      <bind role="start" component="telaJogos"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="6"/>
      </bind>
    </link>

    <link id="lAbreNoticias" xconnector="onSelStopStartSet">
      <bind role="onSelection" component="btnNoticias"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnClima"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnNoticias"/>
      <bind role="stop" component="btnSobre"/>
      <bind role="start" component="telaNoticias"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="7"/>
      </bind>
    </link>

    <link id="lAbreSobre" xconnector="onSelStopStartSet">
      <bind role="onSelection" component="btnSobre"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="btnClima"/>
      <bind role="stop" component="btnJogos"/>
      <bind role="stop" component="btnNoticias"/>
      <bind role="stop" component="btnSobre"/>
      <bind role="start" component="telaSobre"/>
      <bind role="set" component="settings" interface="service.currentFocus">
        <bindParam name="var" value="8"/>
      </bind>
    </link>

    <!-- ============ VERMELHO: VOLTA PARA O MENU ============ -->
    <link id="lVoltaClima" xconnector="onKeyStopStart">
      <bind role="onSelection" component="telaClima">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="stop" component="telaClima"/>
      <bind role="start" component="fundo"/>
    </link>

    <link id="lVoltaJogos" xconnector="onKeyStopStart">
      <bind role="onSelection" component="telaJogos">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="stop" component="telaJogos"/>
      <bind role="start" component="fundo"/>
    </link>

    <link id="lVoltaNoticias" xconnector="onKeyStopStart">
      <bind role="onSelection" component="telaNoticias">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="stop" component="telaNoticias"/>
      <bind role="start" component="fundo"/>
    </link>

    <link id="lVoltaSobre" xconnector="onKeyStopStart">
      <bind role="onSelection" component="telaSobre">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="stop" component="telaSobre"/>
      <bind role="start" component="fundo"/>
    </link>

  </body>
</ncl>
