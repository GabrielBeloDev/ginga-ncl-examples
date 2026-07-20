<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- App NCL 3.0 EDTV - Grade de aplicativos 2x3 (3 colunas x 2 linhas) com botoes navegaveis.
     Autocontido: regioes, descritores, conectores causais e elos inline.
     Referencia apenas as imagens da propria pasta.
     Navegacao: setas (circular) | OK: abre a tela de detalhe (app-N -> tela-N) | VERMELHO (RED): volta. -->
<ncl id="app-grade" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- Fundo cobrindo a tela toda (traz titulo e instrucoes de tecla) -->
      <region id="regFundo" left="0" top="0" width="1280" height="720" zIndex="0"/>

      <!-- Grade 3 colunas x 2 linhas, centralizada abaixo do cabecalho.
           Botoes 340x170. Colunas em x=90,470,850 | Linhas em y=200,440 -->
      <region id="regApp1" left="90"  top="200" width="340" height="170" zIndex="1"/>
      <region id="regApp2" left="470" top="200" width="340" height="170" zIndex="1"/>
      <region id="regApp3" left="850" top="200" width="340" height="170" zIndex="1"/>
      <region id="regApp4" left="90"  top="440" width="340" height="170" zIndex="1"/>
      <region id="regApp5" left="470" top="440" width="340" height="170" zIndex="1"/>
      <region id="regApp6" left="850" top="440" width="340" height="170" zIndex="1"/>

      <!-- Tela de detalhe: fullscreen por cima da grade -->
      <region id="regTela" left="0" top="0" width="1280" height="720" zIndex="2"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="regFundo"/>

      <!-- Botoes navegaveis: focusIndex + move* (circular) + borda amarela grossa no foco.
           Layout:  1 2 3
                    4 5 6
           Horizontal circular por linha; vertical circular por coluna (2 linhas: cima=baixo). -->
      <descriptor id="dApp1" region="regApp1"
                  focusIndex="1" moveLeft="3" moveRight="2" moveUp="4" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp2" region="regApp2"
                  focusIndex="2" moveLeft="1" moveRight="3" moveUp="5" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp3" region="regApp3"
                  focusIndex="3" moveLeft="2" moveRight="1" moveUp="6" moveDown="6"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp4" region="regApp4"
                  focusIndex="4" moveLeft="6" moveRight="5" moveUp="1" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp5" region="regApp5"
                  focusIndex="5" moveLeft="4" moveRight="6" moveUp="2" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="dApp6" region="regApp6"
                  focusIndex="6" moveLeft="5" moveRight="4" moveUp="3" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <!-- Telas de detalhe: focusIndex proprio (11..16) para receber foco ao abrir,
           permitindo que a tecla VERMELHA (onSelection key=RED) funcione. Sem borda de foco. -->
      <descriptor id="dTela1" region="regTela" focusIndex="11" focusBorderWidth="0"/>
      <descriptor id="dTela2" region="regTela" focusIndex="12" focusBorderWidth="0"/>
      <descriptor id="dTela3" region="regTela" focusIndex="13" focusBorderWidth="0"/>
      <descriptor id="dTela4" region="regTela" focusIndex="14" focusBorderWidth="0"/>
      <descriptor id="dTela5" region="regTela" focusIndex="15" focusBorderWidth="0"/>
      <descriptor id="dTela6" region="regTela" focusIndex="16" focusBorderWidth="0"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK (selecao) no botao: inicia a tela de detalhe E move o foco para a tela
           (fNew = focusIndex da tela), para o RED passar a valer na tela. -->
      <causalConnector id="cSelectOpen">
        <connectorParam name="fNew"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="set" value="$fNew"/>
        </compoundAction>
      </causalConnector>

      <!-- Tecla VERMELHA na tela de detalhe: para a tela E devolve o foco ao botao
           que a abriu (fBack = focusIndex do botao). -->
      <causalConnector id="cRedBack">
        <connectorParam name="tecla"/>
        <connectorParam name="fBack"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$fBack"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- Componentes que aparecem no inicio precisam de <port> -->
    <port id="pEntrada" component="fundo"/>
    <port id="pFoco"    component="ajustes"/>
    <port id="pApp1"    component="app-1"/>
    <port id="pApp2"    component="app-2"/>
    <port id="pApp3"    component="app-3"/>
    <port id="pApp4"    component="app-4"/>
    <port id="pApp5"    component="app-5"/>
    <port id="pApp6"    component="app-6"/>

    <!-- Foco inicial no primeiro botao (VIDEO / app-1) -->
    <media id="ajustes" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Fundo (titulo + instrucoes) -->
    <media id="fundo" src="fundo.png" descriptor="dFundo"/>

    <!-- Botoes da grade -->
    <media id="app-1" src="app-1.png" descriptor="dApp1"/>
    <media id="app-2" src="app-2.png" descriptor="dApp2"/>
    <media id="app-3" src="app-3.png" descriptor="dApp3"/>
    <media id="app-4" src="app-4.png" descriptor="dApp4"/>
    <media id="app-5" src="app-5.png" descriptor="dApp5"/>
    <media id="app-6" src="app-6.png" descriptor="dApp6"/>

    <!-- Telas de detalhe (sem port: so aparecem quando o OK abre) -->
    <media id="tela-1" src="tela-1.png" descriptor="dTela1"/>
    <media id="tela-2" src="tela-2.png" descriptor="dTela2"/>
    <media id="tela-3" src="tela-3.png" descriptor="dTela3"/>
    <media id="tela-4" src="tela-4.png" descriptor="dTela4"/>
    <media id="tela-5" src="tela-5.png" descriptor="dTela5"/>
    <media id="tela-6" src="tela-6.png" descriptor="dTela6"/>

    <!-- OK abre a tela do app focado: app-N -> tela-N e foca a tela (11..16) -->
    <link xconnector="cSelectOpen">
      <bind role="onSelection" component="app-1"/>
      <bind role="start" component="tela-1"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fNew" value="11"/>
      </bind>
    </link>
    <link xconnector="cSelectOpen">
      <bind role="onSelection" component="app-2"/>
      <bind role="start" component="tela-2"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fNew" value="12"/>
      </bind>
    </link>
    <link xconnector="cSelectOpen">
      <bind role="onSelection" component="app-3"/>
      <bind role="start" component="tela-3"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fNew" value="13"/>
      </bind>
    </link>
    <link xconnector="cSelectOpen">
      <bind role="onSelection" component="app-4"/>
      <bind role="start" component="tela-4"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fNew" value="14"/>
      </bind>
    </link>
    <link xconnector="cSelectOpen">
      <bind role="onSelection" component="app-5"/>
      <bind role="start" component="tela-5"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fNew" value="15"/>
      </bind>
    </link>
    <link xconnector="cSelectOpen">
      <bind role="onSelection" component="app-6"/>
      <bind role="start" component="tela-6"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fNew" value="16"/>
      </bind>
    </link>

    <!-- VERMELHA (RED) na tela: fecha a tela e devolve o foco ao botao que a abriu -->
    <link xconnector="cRedBack">
      <bind role="onSelection" component="tela-1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-1"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fBack" value="1"/>
      </bind>
    </link>
    <link xconnector="cRedBack">
      <bind role="onSelection" component="tela-2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-2"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fBack" value="2"/>
      </bind>
    </link>
    <link xconnector="cRedBack">
      <bind role="onSelection" component="tela-3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-3"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fBack" value="3"/>
      </bind>
    </link>
    <link xconnector="cRedBack">
      <bind role="onSelection" component="tela-4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-4"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fBack" value="4"/>
      </bind>
    </link>
    <link xconnector="cRedBack">
      <bind role="onSelection" component="tela-5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-5"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fBack" value="5"/>
      </bind>
    </link>
    <link xconnector="cRedBack">
      <bind role="onSelection" component="tela-6">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-6"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="fBack" value="6"/>
      </bind>
    </link>
  </body>
</ncl>
