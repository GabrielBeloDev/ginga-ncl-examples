<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  gen.ncl - Aplicacao Ginga-NCL autocontida (perfil NCL 3.0 EDTV)
  "Video do Garrincha" - sincronizacao interna + interatividade (tecla VERMELHA)

  Midias (referenciadas pelo nome do arquivo, sem subpasta):
    background.png  - fundo em tela cheia
    animGar.mp4     - video principal (Garrincha), tela cheia
    choro.mp4       - musica/choro tocando junto (audio)
    icon.png        - icone no canto durante o video (foco / tecla VERMELHA)
    shoes.mp4       - anuncio de tenis, disparado pela tecla VERMELHA
    drible.mp4      - clipe que "pipoca" ao longo do video
    photo.png       - foto que "pipoca" ao longo do video

  Tudo definido DENTRO do arquivo: regioes, descritores, conectores causais e elos.
  Sem importacao de bases externas.
-->
<ncl id="gen" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ================= REGIOES ================= -->
    <regionBase>
      <region id="rgBackground" left="0%"  top="0%"  width="100%" height="100%" zIndex="0"/>
      <region id="rgVideo"      left="0%"  top="0%"  width="100%" height="100%" zIndex="1"/>
      <region id="rgDrible"     left="4%"  top="66%" width="32%"  height="30%"  zIndex="2"/>
      <region id="rgPhoto"      left="64%" top="62%" width="32%"  height="34%"  zIndex="2"/>
      <region id="rgIcon"       left="82%" top="7%"  width="13%"  height="16%"  zIndex="3"/>
      <region id="rgShoes"      left="0%"  top="0%"  width="100%" height="100%" zIndex="5"/>
    </regionBase>

    <!-- ================= DESCRITORES ================= -->
    <descriptorBase>
      <descriptor id="dscBackground" region="rgBackground"/>
      <descriptor id="dscVideo"      region="rgVideo"/>
      <!-- musica: sem regiao, reproducao apenas de audio -->
      <descriptor id="dscMusic"/>
      <descriptor id="dscDrible"     region="rgDrible"/>
      <descriptor id="dscPhoto"      region="rgPhoto"/>
      <!-- icone focavel para receber a selecao da tecla VERMELHA -->
      <descriptor id="dscIcon"       region="rgIcon" focusIndex="1"/>
      <descriptor id="dscShoes"      region="rgShoes"/>
    </descriptorBase>

    <!-- ================= CONECTORES CAUSAIS ================= -->
    <connectorBase>

      <!-- onBegin de uma interface => start de 1..N componentes -->
      <causalConnector id="onBeginStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd de uma interface => stop de 1..N componentes -->
      <causalConnector id="onEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- selecao por tecla (keyCode) => start de 1 + stop de 1..N -->
      <causalConnector id="onKeySelectionStartStop">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="stop" max="unbounded" qualifier="par"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>

  </head>

  <body>

    <!-- Ao iniciar o documento, disparam juntos: fundo + video + musica -->
    <port id="pBackground" component="background"/>
    <port id="pVideo"      component="video"/>
    <port id="pMusic"      component="music"/>

    <!-- Fundo em tela cheia, atras de tudo -->
    <media id="background" src="background.png" descriptor="dscBackground"/>

    <!-- Musica (choro) tocando junto com o video -->
    <media id="music" src="choro.mp4" descriptor="dscMusic"/>

    <!-- Video principal com ancoras temporais para a sincronizacao interna -->
    <media id="video" src="animGar.mp4" descriptor="dscVideo">
      <area id="aDrible" begin="5s"  end="11s"/>   <!-- drible pipoca cedo   -->
      <area id="aIcon"   begin="15s" end="35s"/>   <!-- icone no meio do video-->
      <area id="aPhoto"  begin="22s" end="30s"/>   <!-- foto pipoca no meio   -->
    </media>

    <!-- Coisinhas que "pipocam" ao longo do video -->
    <media id="drible" src="drible.mp4" descriptor="dscDrible"/>
    <media id="photo"  src="photo.png"  descriptor="dscPhoto"/>

    <!-- Icone interativo no cantinho -->
    <media id="icon" src="icon.png" descriptor="dscIcon"/>

    <!-- Anuncio de tenis, disparado pela tecla VERMELHA -->
    <media id="shoes" src="shoes.mp4" descriptor="dscShoes"/>

    <!-- ================= ELOS (LINKS) ================= -->

    <!-- drible: aparece e some conforme a ancora aDrible -->
    <link id="lDribleOn" xconnector="onBeginStart">
      <bind role="onBegin" component="video" interface="aDrible"/>
      <bind role="start"   component="drible"/>
    </link>
    <link id="lDribleOff" xconnector="onEndStop">
      <bind role="onEnd" component="video" interface="aDrible"/>
      <bind role="stop"  component="drible"/>
    </link>

    <!-- icone: aparece no meio do video e some no fim da ancora aIcon -->
    <link id="lIconOn" xconnector="onBeginStart">
      <bind role="onBegin" component="video" interface="aIcon"/>
      <bind role="start"   component="icon"/>
    </link>
    <link id="lIconOff" xconnector="onEndStop">
      <bind role="onEnd" component="video" interface="aIcon"/>
      <bind role="stop"  component="icon"/>
    </link>

    <!-- foto: pipoca conforme a ancora aPhoto -->
    <link id="lPhotoOn" xconnector="onBeginStart">
      <bind role="onBegin" component="video" interface="aPhoto"/>
      <bind role="start"   component="photo"/>
    </link>
    <link id="lPhotoOff" xconnector="onEndStop">
      <bind role="onEnd" component="video" interface="aPhoto"/>
      <bind role="stop"  component="photo"/>
    </link>

    <!-- INTERATIVIDADE: apertar VERMELHO sobre o icone dispara o anuncio de tenis
         e pausa/encerra o conteudo principal (video, musica e icone) -->
    <link id="lRed" xconnector="onKeySelectionStartStop">
      <linkParam name="keyCode" value="RED"/>
      <bind role="onSelection" component="icon"/>
      <bind role="start"       component="shoes"/>
      <bind role="stop"        component="video"/>
      <bind role="stop"        component="music"/>
      <bind role="stop"        component="icon"/>
    </link>

    <!-- fim do anuncio => encerra o restante da aplicacao -->
    <link id="lShoesEnd" xconnector="onEndStop">
      <bind role="onEnd" component="shoes"/>
      <bind role="stop"  component="background"/>
      <bind role="stop"  component="drible"/>
      <bind role="stop"  component="photo"/>
    </link>

    <!-- fim natural do video (sem interacao) => encerra fundo e musica -->
    <link id="lVideoEnd" xconnector="onEndStop">
      <bind role="onEnd" component="video"/>
      <bind role="stop"  component="background"/>
      <bind role="stop"  component="music"/>
    </link>

  </body>
</ncl>
