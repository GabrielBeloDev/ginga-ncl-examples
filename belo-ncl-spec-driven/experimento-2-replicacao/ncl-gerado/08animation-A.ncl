<?xml version="1.0" encoding="UTF-8"?>
<!--
  gen.ncl - Documento Ginga-NCL autocontido (perfil NCL 3.0 EDTV)
  Reproduz a aplicacao de propaganda interativa descrita na spec.
  Todas as bases (regioes, descritores, transicoes, regras, conectores)
  sao definidas DENTRO deste proprio arquivo (nao importa bases externas).
  Midias referenciadas apenas pelo nome do arquivo (mesma pasta).
-->
<ncl id="genAd" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ================= REGIOES / LAYOUT (% da tela) ================= -->
    <regionBase>
      <!-- Fundo: tela cheia, camada mais baixa -->
      <region id="rgBackground" left="0%" top="0%" width="100%" height="100%" zIndex="1"/>
      <!-- Video principal: tela cheia, acima do fundo -->
      <region id="rgMainVideo" left="0%" top="0%" width="100%" height="100%" zIndex="2"/>
      <!-- Quadro superior-esquerdo: usado por drible.mp4 e photo.png -->
      <region id="rgFrame" left="5%" top="6.7%" width="18.5%" height="18.5%" zIndex="3"/>
      <!-- Icone interativo: canto superior-direito -->
      <region id="rgIcon" left="87.5%" top="11.7%" width="8.45%" height="6.7%" zIndex="3"/>
      <!-- Video do produto: regiao inferior-esquerda -->
      <region id="rgProduct" left="15%" top="60%" width="25%" height="25%" zIndex="3"/>
      <!-- Formulario: painel direito -->
      <region id="rgForm" left="57.25%" top="9.83%" width="37.75%" height="70.2%" zIndex="3"/>
    </regionBase>

    <!-- ================= DESCRITORES ================= -->
    <descriptorBase>
      <descriptor id="dBackground" region="rgBackground"/>
      <descriptor id="dMainVideo" region="rgMainVideo"/>
      <!-- Trilha musical: sem regiao => apenas audio, nao aparece na tela -->
      <descriptor id="dChoro"/>
      <!-- Clipe de drible com transicao de entrada (fade 2s) e saida (barWipe 1s) -->
      <descriptor id="dDrible" region="rgFrame" transIn="tFade" transOut="tBarWipe"/>
      <!-- Foto: transparencia 0.6 (via descriptorParam) e duracao explicita 5s -->
      <descriptor id="dPhoto" region="rgFrame" explicitDur="5s">
        <descriptorParam name="transparency" value="0.6"/>
      </descriptor>
      <!-- Icone: duracao explicita 6s (45s-51s) -->
      <descriptor id="dIcon" region="rgIcon" explicitDur="6s" focusIndex="1"/>
      <!-- Video do produto (shoes) -->
      <descriptor id="dProduct" region="rgProduct"/>
      <!-- Formulario: duracao explicita 15s, recebe foco -->
      <descriptor id="dForm" region="rgForm" explicitDur="15s" focusIndex="2"/>
    </descriptorBase>

    <!-- ================= TRANSICOES ================= -->
    <transitionBase>
      <transition id="tFade" type="fade" dur="2s"/>
      <transition id="tBarWipe" type="barWipe" dur="1s"/>
    </transitionBase>

    <!-- ================= REGRAS (idioma do formulario) ================= -->
    <ruleBase>
      <rule id="rEng" var="system.language" comparator="eq" value="eng"/>
    </ruleBase>

    <!-- ================= CONECTORES CAUSAIS ================= -->
    <connectorBase>

      <!-- onBegin -> start (aceita multiplos alvos em paralelo) -->
      <causalConnector id="onBeginStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> stop (aceita multiplos alvos em paralelo) -->
      <causalConnector id="onEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> set (atribui um valor) -->
      <causalConnector id="onEndSet">
        <connectorParam name="var"/>
        <simpleCondition role="onEnd"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>

      <!-- onBegin -> set animado (value/delay/duration) para deslizar a foto -->
      <causalConnector id="onBeginSetAnim">
        <connectorParam name="var"/>
        <connectorParam name="delay"/>
        <connectorParam name="duration"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$var" delay="$delay" duration="$duration"/>
      </causalConnector>

      <!-- Tecla VERMELHA sobre o icone: bloco de propaganda (acoes em sequencia) -->
      <causalConnector id="onSelectionAdBlock">
        <connectorParam name="boundsVal"/>
        <connectorParam name="focusVal"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="seq">
          <simpleAction role="stopIcon"   eventType="presentation" actionType="stop"/>
          <simpleAction role="setBounds"  eventType="attribution"  actionType="start" value="$boundsVal"/>
          <simpleAction role="startShoes" eventType="presentation" actionType="start"/>
          <simpleAction role="startForm"  eventType="presentation" actionType="start"/>
          <simpleAction role="setFocus"   eventType="attribution"  actionType="start" value="$focusVal"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>
  </head>

  <body>
    <!-- Ponto de entrada: o video principal inicia em t=0 -->
    <port id="pStart" component="animGar"/>

    <!-- Node de configuracao/ambiente (para mudar o foco) -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <!-- Fundo (entra em t=5s) -->
    <media id="background" src="background.png" descriptor="dBackground"/>

    <!-- Trilha musical, so audio (entra em t=5s) -->
    <media id="choro" src="choro.mp4" descriptor="dChoro"/>

    <!-- Video principal (fio condutor) com marcas temporais (ancoras) -->
    <media id="animGar" src="animGar.mp4" descriptor="dMainVideo">
      <area id="aStart"  begin="5s"/>
      <area id="aDrible" begin="12s"/>
      <area id="aPhoto"  begin="41s"/>
      <area id="aIcon"   begin="45s" end="51s"/>
      <property name="bounds"/>
    </media>

    <!-- Clipe curto de drible (quadro superior-esquerdo) -->
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>

    <!-- Foto (quadro superior-esquerdo); a propriedade top e animada -->
    <media id="photo" src="photo.png" descriptor="dPhoto">
      <property name="top"/>
    </media>

    <!-- Icone interativo (canto superior-direito) -->
    <media id="icon" src="icon.png" descriptor="dIcon"/>

    <!-- Video do produto (regiao inferior-esquerda) -->
    <media id="shoes" src="shoes.mp4" descriptor="dProduct"/>

    <!-- Formulario de compra: escolhe idioma (eng -> enForm, senao ptForm) -->
    <switch id="formSwitch">
      <defaultComponent component="formPt"/>
      <bindRule rule="rEng" constituent="formEn"/>
      <media id="formEn" src="enForm.htm" descriptor="dForm"/>
      <media id="formPt" src="ptForm.htm" descriptor="dForm"/>
    </switch>

    <!-- ================= ELOS (LINKS) ================= -->

    <!-- t=5s: inicia JUNTOS o fundo e o audio da trilha -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="aStart"/>
      <bind role="start" component="background"/>
      <bind role="start" component="choro"/>
    </link>

    <!-- t=12s: inicia o clipe de drible (fade in / barWipe out via descritor) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="aDrible"/>
      <bind role="start" component="drible"/>
    </link>

    <!-- t=41s: inicia a foto (transparencia 0.6, dur 5s) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="aPhoto"/>
      <bind role="start" component="photo"/>
    </link>

    <!-- Ao aparecer, a foto desliza: anima top -> 290 (delay 1s, dur 3s) -->
    <link xconnector="onBeginSetAnim">
      <bind role="onBegin" component="photo"/>
      <bind role="set" component="photo" interface="top">
        <bindParam name="var" value="290"/>
        <bindParam name="delay" value="1s"/>
        <bindParam name="duration" value="3s"/>
      </bind>
    </link>

    <!-- t=45s-51s: exibe o icone interativo (dur 6s) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="aIcon"/>
      <bind role="start" component="icon"/>
    </link>

    <!-- Tecla VERMELHA sobre o icone: para icone, encolhe video principal,
         inicia shoes, abre o formulario (15s) e passa o foco a ele -->
    <link xconnector="onSelectionAdBlock">
      <bind role="onSelection" component="icon"/>
      <bind role="stopIcon" component="icon"/>
      <bind role="setBounds" component="animGar" interface="bounds">
        <bindParam name="boundsVal" value="5%,6.67%,45%,45%"/>
      </bind>
      <bind role="startShoes" component="shoes"/>
      <bind role="startForm" component="formSwitch"/>
      <bind role="setFocus" component="settings" interface="service.currentFocus">
        <bindParam name="focusVal" value="2"/>
      </bind>
    </link>

    <!-- Fim do formulario (apos 15s): restaura os limites do video principal -->
    <link xconnector="onEndSet">
      <bind role="onEnd" component="formSwitch"/>
      <bind role="set" component="animGar" interface="bounds">
        <bindParam name="var" value="0,0,222.22%,222.22%"/>
      </bind>
    </link>

    <!-- Fim do video principal: para o fundo e a trilha -->
    <link xconnector="onEndStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop" component="background"/>
      <bind role="stop" component="choro"/>
    </link>

  </body>
</ncl>
