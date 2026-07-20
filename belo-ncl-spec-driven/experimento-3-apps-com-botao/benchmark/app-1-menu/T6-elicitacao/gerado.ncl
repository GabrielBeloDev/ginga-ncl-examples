<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  App de menu horizontal de canais com botoes navegaveis.
  Perfil EDTV, autocontido (regioes, descritores, conectores e elos inline).
  Gerado a partir de perguntas.md + respostas.md (T6-elicitacao).

  Ordem dos botoes (esquerda -> direita): JOGOS, NOTICIAS, CLIMA, SOBRE.
  Menu no rodape, centralizado sobre fundo.png. Navegacao horizontal circular.
  Foco inicial no botao 1 (JOGOS), borda amarela grossa.
  OK abre a tela-* correspondente em tela cheia (cobre o menu).
  Tecla VERMELHA (RED) fecha a tela e volta pro menu (foco preservado).
-->
<ncl id="menuCanais" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- Tela cheia base -->
      <region id="rgFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>

      <!-- Faixa de botoes no rodape: 4x260 = 1040; folga igual de 48px (5 gaps) -->
      <region id="rgBtnJogos"    left="48"  top="620" width="260" height="70" zIndex="1"/>
      <region id="rgBtnNoticias" left="356" top="620" width="260" height="70" zIndex="1"/>
      <region id="rgBtnClima"    left="664" top="620" width="260" height="70" zIndex="1"/>
      <region id="rgBtnSobre"    left="972" top="620" width="260" height="70" zIndex="1"/>

      <!-- Tela de canal: cobre tudo (menu some por baixo) -->
      <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Botoes navegaveis: focusIndex + move circular so na horizontal + foco amarelo -->
      <descriptor id="dBtnJogos" region="rgBtnJogos"
                  focusIndex="1" moveLeft="4" moveRight="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnNoticias" region="rgBtnNoticias"
                  focusIndex="2" moveLeft="1" moveRight="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnClima" region="rgBtnClima"
                  focusIndex="3" moveLeft="2" moveRight="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dBtnSobre" region="rgBtnSobre"
                  focusIndex="4" moveLeft="3" moveRight="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <descriptor id="dTela" region="rgTela"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK/ENTER: ao selecionar, inicia a tela -->
      <causalConnector id="cSelStart">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- Tecla VERMELHA: ao pressionar RED com o botao em foco, para a tela -->
      <causalConnector id="cSelStopKey">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- Componentes que aparecem no inicio precisam de port -->
    <port id="pSettings" component="mSettings"/>
    <port id="pFundo"    component="mFundo"/>
    <port id="pJogos"    component="mBtnJogos"/>
    <port id="pNoticias" component="mBtnNoticias"/>
    <port id="pClima"    component="mBtnClima"/>
    <port id="pSobre"    component="mBtnSobre"/>

    <!-- Foco inicial no botao 1 (JOGOS) -->
    <media id="mSettings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Fundo atras do menu -->
    <media id="mFundo" src="fundo.png" descriptor="dFundo"/>

    <!-- Botoes (ordem esquerda->direita: JOGOS, NOTICIAS, CLIMA, SOBRE) -->
    <media id="mBtnJogos"    src="btn-jogos.png"    descriptor="dBtnJogos"/>
    <media id="mBtnNoticias" src="btn-noticias.png" descriptor="dBtnNoticias"/>
    <media id="mBtnClima"    src="btn-clima.png"    descriptor="dBtnClima"/>
    <media id="mBtnSobre"    src="btn-sobre.png"    descriptor="dBtnSobre"/>

    <!-- Telas de canal (aparecem so no OK, sem port) -->
    <media id="mTelaJogos"    src="tela-jogos.png"    descriptor="dTela"/>
    <media id="mTelaNoticias" src="tela-noticias.png" descriptor="dTela"/>
    <media id="mTelaClima"    src="tela-clima.png"    descriptor="dTela"/>
    <media id="mTelaSobre"    src="tela-sobre.png"    descriptor="dTela"/>

    <!-- OK abre a tela correspondente em tela cheia -->
    <link xconnector="cSelStart">
      <bind role="onSelection" component="mBtnJogos"/>
      <bind role="start" component="mTelaJogos"/>
    </link>
    <link xconnector="cSelStart">
      <bind role="onSelection" component="mBtnNoticias"/>
      <bind role="start" component="mTelaNoticias"/>
    </link>
    <link xconnector="cSelStart">
      <bind role="onSelection" component="mBtnClima"/>
      <bind role="start" component="mTelaClima"/>
    </link>
    <link xconnector="cSelStart">
      <bind role="onSelection" component="mBtnSobre"/>
      <bind role="start" component="mTelaSobre"/>
    </link>

    <!-- Tecla VERMELHA (RED) fecha a tela aberta e volta pro menu -->
    <link xconnector="cSelStopKey">
      <bind role="onSelection" component="mBtnJogos">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTelaJogos"/>
    </link>
    <link xconnector="cSelStopKey">
      <bind role="onSelection" component="mBtnNoticias">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTelaNoticias"/>
    </link>
    <link xconnector="cSelStopKey">
      <bind role="onSelection" component="mBtnClima">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTelaClima"/>
    </link>
    <link xconnector="cSelStopKey">
      <bind role="onSelection" component="mBtnSobre">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="mTelaSobre"/>
    </link>

  </body>
</ncl>
