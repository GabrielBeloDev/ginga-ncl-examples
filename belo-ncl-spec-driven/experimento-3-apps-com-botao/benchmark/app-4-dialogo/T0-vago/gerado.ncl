<?xml version="1.0" encoding="UTF-8"?>
<!--
  gerado.ncl
  App de dialogo de decisao Sim/Nao com botoes (Ginga-NCL 3.0 / EDTVProfile).

  Pedido: "cria um app NCL de dialogo de decisao Sim/Nao com botoes,
           usando as imagens dessa pasta".

  Imagens usadas (todas da propria pasta, nada externo):
    - fundo.png     (1280x720) pergunta "Deseja assinar o Canal Belo?" + dica de teclas
    - btn-sim.png   (320x90)   botao verde "SIM"
    - btn-nao.png   (320x90)   botao vermelho "NAO"
    - tela-sim.png  (1280x720) resultado "Assinatura confirmada!"
    - tela-nao.png  (1280x720) resultado "Talvez depois."

  Interacao (conforme dica exibida no fundo):
    SETAS <- ->  : movem o foco entre os botoes SIM e NAO
    OK / ENTER   : confirma a opcao focada -> mostra a tela de resultado
    VERMELHO     : nas telas de resultado, volta para o dialogo
-->
<ncl id="dialogoDecisao" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- Tela cheia para o fundo (com a pergunta) e para os botoes -->
      <region id="rgFundo" left="0" top="0" width="100%" height="100%" zIndex="0">
        <region id="rgBotaoSim" left="20%" top="47%" width="25%" height="12.5%" zIndex="2"/>
        <region id="rgBotaoNao" left="55%" top="47%" width="25%" height="12.5%" zIndex="2"/>
      </region>
      <!-- Tela cheia (por cima) para as telas de resultado -->
      <region id="rgResultado" left="0" top="0" width="100%" height="100%" zIndex="10"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Botoes navegaveis: foco 1 (SIM) <-> foco 2 (NAO), borda amarela no foco -->
      <descriptor id="dBotaoSim" region="rgBotaoSim"
                  focusIndex="1" moveRight="2"
                  focusBorderColor="yellow" focusBorderWidth="5"/>
      <descriptor id="dBotaoNao" region="rgBotaoNao"
                  focusIndex="2" moveLeft="1"
                  focusBorderColor="yellow" focusBorderWidth="5"/>

      <!-- Telas de resultado tambem recebem foco, para captar a tecla VERMELHO -->
      <descriptor id="dTelaSim" region="rgResultado" focusIndex="3"/>
      <descriptor id="dTelaNao" region="rgResultado" focusIndex="4"/>
    </descriptorBase>

    <connectorBase>
      <!-- onBegin -> set: usado para posicionar o foco inicial/estado -->
      <causalConnector id="onBeginSet">
        <connectorParam name="valor"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$valor"/>
      </causalConnector>

      <!-- onSelection (OK) -> para varios objetos e inicia outro -->
      <causalConnector id="onSelectionStopStart">
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="stop" max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
        </compoundAction>
      </causalConnector>

      <!-- onSelection de uma tecla especifica (VERMELHO) -> para e reinicia -->
      <causalConnector id="onKeySelectionStopStart">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="stop" max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- Inicio do documento: fundo + os dois botoes -->
    <port id="pFundo" component="fundo"/>
    <port id="pBotaoSim" component="botaoSim"/>
    <port id="pBotaoNao" component="botaoNao"/>

    <!-- Variavel de sistema que controla qual objeto esta focado -->
    <media id="ajustes" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <!-- Midias (todas as imagens sao locais, desta pasta) -->
    <media id="fundo"    src="fundo.png"    descriptor="dFundo"/>
    <media id="botaoSim" src="btn-sim.png"  descriptor="dBotaoSim"/>
    <media id="botaoNao" src="btn-nao.png"  descriptor="dBotaoNao"/>
    <media id="telaSim"  src="tela-sim.png" descriptor="dTelaSim"/>
    <media id="telaNao"  src="tela-nao.png" descriptor="dTelaNao"/>

    <!-- Foco inicial no botao SIM (focusIndex 1) quando o fundo aparece -->
    <link id="lFocoInicial" xconnector="onBeginSet">
      <bind role="onBegin" component="fundo"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="valor" value="1"/>
      </bind>
    </link>

    <!-- Ao mostrar a tela SIM, foca nela (focusIndex 3) para captar o VERMELHO -->
    <link id="lFocoTelaSim" xconnector="onBeginSet">
      <bind role="onBegin" component="telaSim"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="valor" value="3"/>
      </bind>
    </link>

    <!-- Ao mostrar a tela NAO, foca nela (focusIndex 4) para captar o VERMELHO -->
    <link id="lFocoTelaNao" xconnector="onBeginSet">
      <bind role="onBegin" component="telaNao"/>
      <bind role="set" component="ajustes" interface="service.currentFocus">
        <bindParam name="valor" value="4"/>
      </bind>
    </link>

    <!-- OK sobre SIM: some o dialogo e mostra "Assinatura confirmada!" -->
    <link id="lConfirmaSim" xconnector="onSelectionStopStart">
      <bind role="onSelection" component="botaoSim"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="botaoSim"/>
      <bind role="stop" component="botaoNao"/>
      <bind role="start" component="telaSim"/>
    </link>

    <!-- OK sobre NAO: some o dialogo e mostra "Talvez depois." -->
    <link id="lConfirmaNao" xconnector="onSelectionStopStart">
      <bind role="onSelection" component="botaoNao"/>
      <bind role="stop" component="fundo"/>
      <bind role="stop" component="botaoSim"/>
      <bind role="stop" component="botaoNao"/>
      <bind role="start" component="telaNao"/>
    </link>

    <!-- VERMELHO na tela SIM: volta ao dialogo -->
    <link id="lVoltaSim" xconnector="onKeySelectionStopStart">
      <bind role="onSelection" component="telaSim">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaSim"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="botaoSim"/>
      <bind role="start" component="botaoNao"/>
    </link>

    <!-- VERMELHO na tela NAO: volta ao dialogo -->
    <link id="lVoltaNao" xconnector="onKeySelectionStopStart">
      <bind role="onSelection" component="telaNao">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="telaNao"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="botaoSim"/>
      <bind role="start" component="botaoNao"/>
    </link>
  </body>
</ncl>
