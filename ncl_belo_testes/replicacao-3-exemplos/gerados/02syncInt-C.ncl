<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  Tributo ao Garrincha - documento Ginga-NCL autocontido (perfil EDTV / NCL 3.0)
  Reproduz: video principal em tela cheia com fundo + musica sincronizados,
  caixinhas com clipe/foto/icone e interacao com o botao VERMELHO que encolhe
  o video principal e roda o anuncio de tenis.
  Midias referenciadas por nome (pasta atual): animGar.mp4, background.png,
  choro.mp4, drible.mp4, photo.png, icon.png, shoes.mp4
-->
<ncl id="gingaGarrinchaTributo" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ============ REGIOES ============ -->
    <regionBase>
      <!-- fundo em tela cheia, atras de tudo -->
      <region id="rgBackground" left="0%" top="0%" width="100%" height="100%" zIndex="0"/>
      <!-- video principal em tela cheia -->
      <region id="rgMain" left="0%" top="0%" width="100%" height="100%" zIndex="1"/>
      <!-- caixinha canto superior esquerdo (clipe drible e depois a foto) -->
      <region id="rgTopLeft" left="4%" top="6%" width="30%" height="30%" zIndex="3"/>
      <!-- caixinha canto superior direito (icone / dica do botao) -->
      <region id="rgTopRight" left="80%" top="6%" width="15%" height="18%" zIndex="4"/>
      <!-- caixa inferior esquerda (anuncio de tenis) -->
      <region id="rgBottomLeft" left="4%" top="58%" width="34%" height="34%" zIndex="3"/>
    </regionBase>

    <!-- ============ DESCRITORES ============ -->
    <descriptorBase>
      <descriptor id="dBackground" region="rgBackground"/>
      <descriptor id="dMain" region="rgMain"/>
      <!-- choro.mp4 = so audio: descritor sem regiao (nao apresenta imagem) -->
      <descriptor id="dChoro"/>
      <descriptor id="dDrible" region="rgTopLeft"/>
      <!-- foto fica so uns segundos na mesma caixinha -->
      <descriptor id="dPhoto" region="rgTopLeft">
        <descriptorParam name="explicitDur" value="5s"/>
      </descriptor>
      <!-- icone e focavel (recebe o botao VERMELHO) e some sozinho apos alguns segundos -->
      <descriptor id="dIcon" region="rgTopRight" focusIndex="1">
        <descriptorParam name="explicitDur" value="8s"/>
      </descriptor>
      <descriptor id="dShoes" region="rgBottomLeft"/>
    </descriptorBase>

    <!-- ============ CONECTORES CAUSAIS ============ -->
    <connectorBase>
      <!-- ao atingir um ponto do video principal -> inicia uma midia -->
      <causalConnector id="cStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start"/>
      </causalConnector>
      <!-- ao terminar uma midia -> para outra -->
      <causalConnector id="cStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop"/>
      </causalConnector>
      <!-- selecao por tecla -> inicia -->
      <causalConnector id="cSelStart">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="start"/>
      </causalConnector>
      <!-- selecao por tecla -> para -->
      <causalConnector id="cSelStop">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="stop"/>
      </causalConnector>
      <!-- selecao por tecla -> atribui valor a uma propriedade -->
      <causalConnector id="cSelSet">
        <connectorParam name="keyCode"/>
        <connectorParam name="var"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>
      <!-- ao terminar uma midia -> atribui valor a uma propriedade -->
      <causalConnector id="cEndSet">
        <connectorParam name="var"/>
        <simpleCondition role="onEnd"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- o app comeca pelo video principal -->
    <port id="pStart" component="animGar"/>

    <!-- fundo (tela cheia, atras) -->
    <media id="background" src="background.png" descriptor="dBackground"/>

    <!-- musica (so audio) -->
    <media id="choro" src="choro.mp4" descriptor="dChoro"/>

    <!-- video principal: pontos de sincronismo + propriedades de layout p/ encolher -->
    <media id="animGar" src="animGar.mp4" descriptor="dMain">
      <area id="a05" begin="5s"/>
      <area id="a12" begin="12s"/>
      <area id="a40" begin="40s"/>
      <area id="a45" begin="45s"/>
      <property name="left"/>
      <property name="top"/>
      <property name="width"/>
      <property name="height"/>
    </media>

    <!-- clipe na caixinha superior esquerda -->
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>

    <!-- foto na mesma caixinha superior esquerda -->
    <media id="photo" src="photo.png" descriptor="dPhoto"/>

    <!-- icone (dica do botao VERMELHO) canto superior direito -->
    <media id="icon" src="icon.png" descriptor="dIcon"/>

    <!-- anuncio de tenis na caixa inferior esquerda -->
    <media id="shoes" src="shoes.mp4" descriptor="dShoes"/>

    <!-- ====================== SINCRONISMO ====================== -->

    <!-- ~5s: entram juntos o fundo e a musica -->
    <link xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="a05"/>
      <bind role="start" component="background"/>
    </link>
    <link xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="a05"/>
      <bind role="start" component="choro"/>
    </link>

    <!-- ~12s: clipe drible na caixinha superior esquerda -->
    <link xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="a12"/>
      <bind role="start" component="drible"/>
    </link>

    <!-- ~40s: foto na mesma caixinha (fica ~5s pelo explicitDur) -->
    <link xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="a40"/>
      <bind role="start" component="photo"/>
    </link>

    <!-- ~45s: icone pisca no canto superior direito (convite ao botao VERMELHO) -->
    <link xconnector="cStart">
      <bind role="onBegin" component="animGar" interface="a45"/>
      <bind role="start" component="icon"/>
    </link>

    <!-- fim do video principal: para fundo e musica (programa encerra) -->
    <link xconnector="cStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop" component="background"/>
    </link>
    <link xconnector="cStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop" component="choro"/>
    </link>

    <!-- ====================== INTERACAO (BOTAO VERMELHO) ====================== -->
    <!-- enquanto o icone esta na tela, VERMELHO: some o icone -->
    <link xconnector="cSelStop">
      <linkParam name="keyCode" value="RED"/>
      <bind role="onSelection" component="icon"/>
      <bind role="stop" component="icon"/>
    </link>

    <!-- ... encolhe o video principal p/ janelinha no canto superior esquerdo -->
    <link xconnector="cSelSet">
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="4%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="set" component="animGar" interface="left"/>
    </link>
    <link xconnector="cSelSet">
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="6%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="set" component="animGar" interface="top"/>
    </link>
    <link xconnector="cSelSet">
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="32%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="set" component="animGar" interface="width"/>
    </link>
    <link xconnector="cSelSet">
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var" value="32%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="set" component="animGar" interface="height"/>
    </link>

    <!-- ... e roda o anuncio de tenis na caixa inferior esquerda -->
    <link xconnector="cSelStart">
      <linkParam name="keyCode" value="RED"/>
      <bind role="onSelection" component="icon"/>
      <bind role="start" component="shoes"/>
    </link>

    <!-- fim do anuncio: o video principal volta a tela cheia -->
    <link xconnector="cEndSet">
      <linkParam name="var" value="0%"/>
      <bind role="onEnd" component="shoes"/>
      <bind role="set" component="animGar" interface="left"/>
    </link>
    <link xconnector="cEndSet">
      <linkParam name="var" value="0%"/>
      <bind role="onEnd" component="shoes"/>
      <bind role="set" component="animGar" interface="top"/>
    </link>
    <link xconnector="cEndSet">
      <linkParam name="var" value="100%"/>
      <bind role="onEnd" component="shoes"/>
      <bind role="set" component="animGar" interface="width"/>
    </link>
    <link xconnector="cEndSet">
      <linkParam name="var" value="100%"/>
      <bind role="onEnd" component="shoes"/>
      <bind role="set" component="animGar" interface="height"/>
    </link>

  </body>
</ncl>
