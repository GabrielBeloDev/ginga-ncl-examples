<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  App NCL "Dialogo de decisao Sim/Nao" - Canal Belo
  Perfil NCL 3.0 EDTV, documento AUTOCONTIDO (regioes, descritores,
  conectores causais e elos inline). Usa somente as imagens da pasta.

  Fluxo aprovado na elicitacao (respostas.md):
   - Abre em fundo.png com SIM (esq) e NAO (dir) no meio da tela.
   - Foco inicial no SIM, borda amarela espessura 4.
   - Setas ESQUERDA/DIREITA alternam o foco (circular SIM <-> NAO).
   - OK no SIM  -> mostra tela-sim.png (tela cheia, dialogo some).
   - OK no NAO  -> mostra tela-nao.png (tela cheia, dialogo some).
   - Nas telas de resultado, VERMELHO volta pro dialogo (foco no SIM).
   - Na tela inicial, VERMELHO nao faz nada.
   - Canvas 1280x720.
-->
<ncl id="dialogoSimNao" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <regionBase>
      <region id="rgTela" left="0" top="0" width="1280" height="720" zIndex="0">
        <region id="rgFundo"     left="0"   top="0"   width="1280" height="720" zIndex="0"/>
        <region id="rgSim"       left="360" top="360" width="260"  height="64"  zIndex="1"/>
        <region id="rgNao"       left="660" top="360" width="260"  height="64"  zIndex="1"/>
        <region id="rgResultado" left="0"   top="0"   width="1280" height="720" zIndex="2"/>
      </region>
    </regionBase>

    <descriptorBase>
      <descriptor id="dFundo" region="rgFundo"/>

      <!-- Botao SIM: foco 1, vizinho (circular) e o NAO (2) -->
      <descriptor id="dSim" region="rgSim"
                  focusIndex="1" moveLeft="2" moveRight="2" moveUp="1" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <!-- Botao NAO: foco 2, vizinho (circular) e o SIM (1) -->
      <descriptor id="dNao" region="rgNao"
                  focusIndex="2" moveLeft="1" moveRight="1" moveUp="2" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <!-- Telas de resultado: focaveis (recebem a tecla VERMELHA), sem borda -->
      <descriptor id="dTelaSim" region="rgResultado" focusIndex="3" focusBorderWidth="0"/>
      <descriptor id="dTelaNao" region="rgResultado" focusIndex="4" focusBorderWidth="0"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK (selecao): para o dialogo, inicia a tela de resultado e move o foco pra ela -->
      <causalConnector id="cOKMostra">
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="stop"  max="unbounded" qualifier="par"/>
          <simpleAction role="start"/>
          <simpleAction role="set"   value="$foco"/>
        </compoundAction>
      </causalConnector>

      <!-- Tecla VERMELHA (voltar): para a tela de resultado, reinicia o dialogo e restaura o foco -->
      <causalConnector id="cVoltaVermelho">
        <connectorParam name="tecla"/>
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="start" max="unbounded" qualifier="par"/>
          <simpleAction role="set"   value="$foco"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>
  </head>

  <body>
    <!-- Portas: tudo que precisa aparecer no inicio tem um port -->
    <port id="pEntrada" component="fundo"/>
    <port id="pFoco"    component="settings"/>
    <port id="pSim"     component="btnSim"/>
    <port id="pNao"     component="btnNao"/>

    <!-- Foco inicial no botao SIM (focusIndex 1) -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <!-- Dialogo inicial -->
    <media id="fundo"  src="fundo.png"   descriptor="dFundo"/>
    <media id="btnSim" src="btn-sim.png" descriptor="dSim"/>
    <media id="btnNao" src="btn-nao.png" descriptor="dNao"/>

    <!-- Telas de resultado (iniciadas por elo) -->
    <media id="telaSim" src="tela-sim.png" descriptor="dTelaSim"/>
    <media id="telaNao" src="tela-nao.png" descriptor="dTelaNao"/>

    <!-- OK no SIM -> mostra tela-sim.png (dialogo some, foco vai pra tela 3) -->
    <link xconnector="cOKMostra">
      <bind role="onSelection" component="btnSim"/>
      <bind role="stop"        component="fundo"/>
      <bind role="stop"        component="btnSim"/>
      <bind role="stop"        component="btnNao"/>
      <bind role="start"       component="telaSim"/>
      <bind role="set"         component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="3"/>
      </bind>
    </link>

    <!-- OK no NAO -> mostra tela-nao.png (dialogo some, foco vai pra tela 4) -->
    <link xconnector="cOKMostra">
      <bind role="onSelection" component="btnNao"/>
      <bind role="stop"        component="fundo"/>
      <bind role="stop"        component="btnSim"/>
      <bind role="stop"        component="btnNao"/>
      <bind role="start"       component="telaNao"/>
      <bind role="set"         component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="4"/>
      </bind>
    </link>

    <!-- VERMELHO na tela-sim -> volta pro dialogo (foco restaurado no SIM = 1) -->
    <link xconnector="cVoltaVermelho">
      <bind role="onSelection" component="telaSim">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop"  component="telaSim"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnSim"/>
      <bind role="start" component="btnNao"/>
      <bind role="set"   component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="1"/>
      </bind>
    </link>

    <!-- VERMELHO na tela-nao -> volta pro dialogo (foco restaurado no SIM = 1) -->
    <link xconnector="cVoltaVermelho">
      <bind role="onSelection" component="telaNao">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop"  component="telaNao"/>
      <bind role="start" component="fundo"/>
      <bind role="start" component="btnSim"/>
      <bind role="start" component="btnNao"/>
      <bind role="set"   component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="1"/>
      </bind>
    </link>
  </body>
</ncl>
