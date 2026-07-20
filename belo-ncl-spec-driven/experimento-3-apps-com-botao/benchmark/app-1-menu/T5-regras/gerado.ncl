<?xml version="1.0" encoding="UTF-8"?>
<ncl id="app-1-menu" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- fundo ocupa a tela inteira, atras de tudo -->
      <region id="rgFundo" left="0" top="0" width="100%" height="100%" zIndex="0"/>

      <!-- tela cheia dos itens, na frente de tudo -->
      <region id="rgTela" left="0" top="0" width="100%" height="100%" zIndex="5"/>

      <!-- 4 botoes lado a lado na BASE da tela -->
      <region id="rgBtnJogos"    left="4%"  top="80%" width="21%" height="15%" zIndex="1"/>
      <region id="rgBtnNoticias" left="27%" top="80%" width="21%" height="15%" zIndex="1"/>
      <region id="rgBtnClima"    left="50%" top="80%" width="21%" height="15%" zIndex="1"/>
      <region id="rgBtnSobre"    left="73%" top="80%" width="21%" height="15%" zIndex="1"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- um unico descritor de tela cheia serve para os 4 itens (so 1 aparece por vez) -->
      <descriptor id="dTela" region="rgTela"/>

      <!-- botoes navegaveis: focusIndex + move* circular + borda de foco amarela -->
      <descriptor id="dBtnJogos" region="rgBtnJogos"
                  focusIndex="1" moveLeft="4" moveRight="2" moveUp="1" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnNoticias" region="rgBtnNoticias"
                  focusIndex="2" moveLeft="1" moveRight="3" moveUp="2" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnClima" region="rgBtnClima"
                  focusIndex="3" moveLeft="2" moveRight="4" moveUp="3" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnSobre" region="rgBtnSobre"
                  focusIndex="4" moveLeft="3" moveRight="1" moveUp="4" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK (selecao) abre a tela cheia do item -->
      <causalConnector id="cAbre">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- tecla VERMELHA fecha a tela cheia e volta ao menu.
           O foco NUNCA sai do botao, entao o onSelection(RED) do botao focado dispara o stop da tela. -->
      <causalConnector id="cVolta">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- ===== PORTS: tudo que aparece no inicio precisa de port ===== -->
    <port id="entry"        component="fundo"/>
    <port id="pSettings"    component="settings"/>
    <port id="pBtnJogos"    component="btnJogos"/>
    <port id="pBtnNoticias" component="btnNoticias"/>
    <port id="pBtnClima"    component="btnClima"/>
    <port id="pBtnSobre"    component="btnSobre"/>

    <!-- foco inicial no primeiro botao (JOGOS, focusIndex=1) -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- fundo -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- botoes do menu -->
    <media id="btnJogos"    src="btn-jogos.png"    descriptor="dBtnJogos"/>
    <media id="btnNoticias" src="btn-noticias.png" descriptor="dBtnNoticias"/>
    <media id="btnClima"    src="btn-clima.png"    descriptor="dBtnClima"/>
    <media id="btnSobre"    src="btn-sobre.png"    descriptor="dBtnSobre"/>

    <!-- telas cheias (sem port: so aparecem ao pressionar OK) -->
    <media id="telaJogos"    src="tela-jogos.png"    descriptor="dTela"/>
    <media id="telaNoticias" src="tela-noticias.png" descriptor="dTela"/>
    <media id="telaClima"    src="tela-clima.png"    descriptor="dTela"/>
    <media id="telaSobre"    src="tela-sobre.png"    descriptor="dTela"/>

    <!-- ===== OK: abre a tela cheia do item selecionado ===== -->
    <link xconnector="cAbre">
      <bind role="onSelection" component="btnJogos"/>
      <bind role="start"       component="telaJogos"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="btnNoticias"/>
      <bind role="start"       component="telaNoticias"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="btnClima"/>
      <bind role="start"       component="telaClima"/>
    </link>
    <link xconnector="cAbre">
      <bind role="onSelection" component="btnSobre"/>
      <bind role="start"       component="telaSobre"/>
    </link>

    <!-- ===== VERMELHA: fecha a tela cheia e volta ao menu ===== -->
    <link xconnector="cVolta">
      <bind role="onSelection" component="btnJogos">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaJogos"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="btnNoticias">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaNoticias"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="btnClima">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaClima"/>
    </link>
    <link xconnector="cVolta">
      <bind role="onSelection" component="btnSobre">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaSobre"/>
    </link>
  </body>
</ncl>
