<?xml version="1.0" encoding="UTF-8"?>
<!--
  gen.ncl  -  Ginga-NCL / NCL 3.0 EDTV Profile
  Documento AUTOCONTIDO (regioes, descritores, conectores causais e elos
  definidos aqui dentro; nenhuma base externa importada).

  App reproduzido:
    - Toca o video principal animGar.mp4 em tela cheia com a musica de fundo
      choro.mp4.
    - Ao longo do video pipocam detalhes no canto: drible.mp4, photo.png e
      icon.png (com fade in/out).
    - Enquanto icon.png esta na tela, se o usuario apertar o botao VERMELHO
      abre a propaganda: o video principal encolhe num canto e aparecem
      shoes.mp4 + o formulario (ptForm.htm em portugues / enForm.htm em ingles,
      escolhido por system.language).
    - Passado um tempo (fim de shoes.mp4) tudo volta ao normal: o video
      principal volta a tela cheia e o formulario e encerrado.
    - No fim, quando animGar.mp4 termina, a musica choro.mp4 e parada junto.
-->
<ncl id="gen" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <ruleBase>
      <rule id="rPor" var="system.language" comparator="eq" value="por"/>
      <rule id="rEng" var="system.language" comparator="eq" value="eng"/>
    </ruleBase>

    <transitionBase>
      <transition id="tFadeIn"  type="fade" dur="1s"/>
      <transition id="tFadeOut" type="fade" dur="1s"/>
    </transitionBase>

    <regionBase>
      <!-- Video principal em tela cheia -->
      <region id="rgVideo" left="0%"  top="0%"  width="100%" height="100%" zIndex="1"/>
      <!-- Fundo para a musica (mp4 usado como audio); fica atras de tudo -->
      <region id="rgBg"    left="0%"  top="0%"  width="100%" height="100%" zIndex="0"/>
      <!-- Detalhes que pipocam no canto -->
      <region id="rgDrible" left="70%" top="70%" width="25%" height="25%" zIndex="5"/>
      <region id="rgPhoto"  left="4%"  top="64%" width="22%" height="30%" zIndex="5"/>
      <region id="rgIcon"   left="82%" top="6%"  width="12%" height="16%" zIndex="6"/>
      <!-- Propaganda -->
      <region id="rgShoes"  left="55%" top="10%" width="40%" height="45%" zIndex="4"/>
      <region id="rgForm"   left="5%"  top="45%" width="90%" height="50%" zIndex="4"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dMain"   region="rgVideo"/>
      <descriptor id="dChoro"  region="rgBg"/>
      <descriptor id="dDrible" region="rgDrible" transIn="tFadeIn" transOut="tFadeOut"/>
      <descriptor id="dPhoto"  region="rgPhoto"  transIn="tFadeIn" transOut="tFadeOut"/>
      <descriptor id="dIcon"   region="rgIcon"   transIn="tFadeIn" transOut="tFadeOut" focusIndex="1"/>
      <!-- explicitDur limita a propaganda; ao terminar dispara o fechamento -->
      <descriptor id="dShoes"  region="rgShoes"  explicitDur="15s"/>
      <descriptor id="dForm"   region="rgForm"/>
    </descriptorBase>

    <connectorBase>
      <!-- onBegin -> start -->
      <causalConnector id="cStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> stop -->
      <causalConnector id="cStopOnEnd">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- Tecla colorida -> encolhe o video, abre shoes e o formulario -->
      <causalConnector id="cOpenAd">
        <connectorParam name="keyCode"/>
        <connectorParam name="newBounds"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="par">
          <simpleAction role="setBounds"  value="$newBounds" eventType="attribution"  actionType="start"/>
          <simpleAction role="startShoes" eventType="presentation" actionType="start"/>
          <simpleAction role="startForm"  eventType="presentation" actionType="start"/>
        </compoundAction>
      </causalConnector>

      <!-- Fim da propaganda -> volta o video pra tela cheia e para o formulario -->
      <causalConnector id="cCloseAd">
        <connectorParam name="fullBounds"/>
        <simpleCondition role="onEnd"/>
        <compoundAction operator="par">
          <simpleAction role="setBounds" value="$fullBounds" eventType="attribution"  actionType="start"/>
          <simpleAction role="stopForm"  eventType="presentation" actionType="stop"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- Ponto de entrada da aplicacao -->
    <port id="pInit" component="animGar"/>

    <!-- Video principal, com propriedade de bounds (para encolher/voltar)
         e ancoras temporais onde pipocam os detalhes -->
    <media id="animGar" src="animGar.mp4" descriptor="dMain">
      <property name="bounds"/>
      <area id="aDrible" begin="8s"  end="16s"/>
      <area id="aPhoto"  begin="20s" end="28s"/>
      <area id="aIcon"   begin="32s" end="50s"/>
    </media>

    <!-- Musica de fundo -->
    <media id="choro" src="choro.mp4" descriptor="dChoro"/>

    <!-- Detalhes de canto -->
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>
    <media id="photo"  src="photo.png"  descriptor="dPhoto"/>
    <media id="icon"   src="icon.png"   descriptor="dIcon"/>

    <!-- Video da propaganda -->
    <media id="shoes" src="shoes.mp4" descriptor="dShoes"/>

    <!-- Formulario da propaganda: escolhe idioma por system.language -->
    <switch id="formSwitch">
      <defaultComponent component="ptForm"/>
      <bindRule rule="rPor" constituent="ptForm"/>
      <bindRule rule="rEng" constituent="enForm"/>
      <media id="ptForm" src="ptForm.htm" descriptor="dForm"/>
      <media id="enForm" src="enForm.htm" descriptor="dForm"/>
    </switch>

    <!-- ================= ELOS ================= -->

    <!-- Comeca a musica junto com o video principal -->
    <link id="lMusic" xconnector="cStart">
      <bind role="onBegin" component="animGar"/>
      <bind role="start"   component="choro"/>
    </link>

    <!-- drible pipoca no canto -->
    <link id="lDribleIn" xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="aDrible"/>
      <bind role="start"   component="drible"/>
    </link>
    <link id="lDribleOut" xconnector="cStopOnEnd">
      <bind role="onEnd" component="animGar" interface="aDrible"/>
      <bind role="stop"  component="drible"/>
    </link>

    <!-- photo pipoca no canto -->
    <link id="lPhotoIn" xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="aPhoto"/>
      <bind role="start"   component="photo"/>
    </link>
    <link id="lPhotoOut" xconnector="cStopOnEnd">
      <bind role="onEnd" component="animGar" interface="aPhoto"/>
      <bind role="stop"  component="photo"/>
    </link>

    <!-- icon pipoca no canto (janela em que o VERMELHO abre a propaganda) -->
    <link id="lIconIn" xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="aIcon"/>
      <bind role="start"   component="icon"/>
    </link>
    <link id="lIconOut" xconnector="cStopOnEnd">
      <bind role="onEnd" component="animGar" interface="aIcon"/>
      <bind role="stop"  component="icon"/>
    </link>

    <!-- VERMELHO sobre o icon: abre a propaganda -->
    <link id="lOpenAd" xconnector="cOpenAd">
      <bind role="onSelection" component="icon">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="setBounds" component="animGar" interface="bounds">
        <bindParam name="newBounds" value="5%,5%,30%,30%"/>
      </bind>
      <bind role="startShoes" component="shoes"/>
      <bind role="startForm"  component="formSwitch"/>
    </link>

    <!-- Fim de shoes: fecha a propaganda e volta tudo ao normal -->
    <link id="lCloseAd" xconnector="cCloseAd">
      <bind role="onEnd" component="shoes"/>
      <bind role="setBounds" component="animGar" interface="bounds">
        <bindParam name="fullBounds" value="0%,0%,100%,100%"/>
      </bind>
      <bind role="stopForm" component="formSwitch"/>
    </link>

    <!-- Fim do video principal leva a musica junto -->
    <link id="lEndApp" xconnector="cStopOnEnd">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop"  component="choro"/>
    </link>

  </body>
</ncl>
