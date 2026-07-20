<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  gen.ncl - Ginga-NCL (perfil NCL 3.0 EDTV), documento AUTOCONTIDO.

  App: video principal animGar.mp4 em tela cheia + musica choro.mp4 + fundo
       background.png por baixo. Durante o video pipocam extras (drible.mp4 e
       photo.png) num canto; depois surge/pisca um icone (icon.png) chamando
       pra apertar o botao VERMELHO. Ao apertar VERMELHO o video encolhe, toca
       shoes.mp4 e abre um formulario de compra do lado (ptForm.htm por padrao
       ou enForm.htm se o sistema estiver em ingles). No fim (video termina),
       corta a musica e o fundo.

  Regioes, descritores, conectores causais e elos definidos DENTRO deste arquivo
  (nao importa bases externas). Todas as midias sao referenciadas apenas pelo
  nome do arquivo, na mesma pasta deste .ncl.
-->
<ncl id="gen" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ===================== REGRAS (idioma do sistema) ===================== -->
    <ruleBase>
      <rule id="rPor" var="system.language" comparator="eq" value="por"/>
      <rule id="rEng" var="system.language" comparator="eq" value="eng"/>
    </ruleBase>

    <!-- ===================== REGIOES ===================== -->
    <regionBase>
      <!-- fundo em tela cheia (camada mais de baixo) -->
      <region id="rgBg"     left="0%"  top="0%"  width="100%" height="100%" zIndex="0"/>
      <!-- video principal em tela cheia (encolhe ao apertar VERMELHO via propriedade bounds) -->
      <region id="rgVideo"  left="0%"  top="0%"  width="100%" height="100%" zIndex="1"/>
      <!-- clipe shoes.mp4 (aparece apos o VERMELHO, com o video ja encolhido) -->
      <region id="rgShoes"  left="6%"  top="52%" width="46%" height="42%"  zIndex="2"/>
      <!-- clipe de drible pipocando num cantinho de baixo -->
      <region id="rgDrible" left="5%"  top="60%" width="32%" height="32%"  zIndex="3"/>
      <!-- foto pipocando num cantinho de cima -->
      <region id="rgPhoto"  left="68%" top="6%"  width="26%" height="30%"  zIndex="3"/>
      <!-- icone que chama/pisca pedindo o botao VERMELHO -->
      <region id="rgIcon"   left="42%" top="80%" width="16%" height="14%"  zIndex="4"/>
      <!-- formulario de compra do lado direito -->
      <region id="rgForm"   left="54%" top="6%"  width="42%" height="88%"  zIndex="5"/>
    </regionBase>

    <!-- ===================== DESCRITORES ===================== -->
    <descriptorBase>
      <descriptor id="dBg"     region="rgBg"/>
      <descriptor id="dVideo"  region="rgVideo"/>
      <!-- choro.mp4 usado como musica de fundo (sem regiao = so audio) -->
      <descriptor id="dChoro">
        <descriptorParam name="soundLevel" value="1.0"/>
      </descriptor>
      <descriptor id="dDrible" region="rgDrible"/>
      <descriptor id="dPhoto"  region="rgPhoto"/>
      <descriptor id="dShoes"  region="rgShoes"/>
      <!-- icone levemente translucido pra dar destaque de "chamada" (piscar) -->
      <descriptor id="dIcon"   region="rgIcon">
        <descriptorParam name="transparency" value="0"/>
      </descriptor>
      <descriptor id="dForm"   region="rgForm"/>
    </descriptorBase>

    <!-- ===================== CONECTORES CAUSAIS ===================== -->
    <connectorBase>

      <!-- ao iniciar A, inicia B -->
      <causalConnector id="onBeginStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- ao iniciar A, inicia B com atraso (pros extras/icone pipocarem depois) -->
      <causalConnector id="onBeginStartDelay">
        <connectorParam name="pDelay"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" delay="$pDelay" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- ao terminar A, para B (e C...) -> corta musica e fundo no fim -->
      <causalConnector id="onEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- selecao do botao VERMELHO: seta bounds (encolhe video), inicia shoes+form, para o icone -->
      <causalConnector id="onRedSelection">
        <connectorParam name="pBounds"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="par">
          <simpleAction role="set"   value="$pBounds"/>
          <simpleAction role="start" max="unbounded" qualifier="par"/>
          <simpleAction role="stop"  max="unbounded" qualifier="par"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>

  </head>

  <body>

    <!-- ponto de entrada: comeca pelo fundo -->
    <port id="pEntry" component="bg"/>

    <!-- variaveis de sistema (idioma) usadas pelas regras do switch -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="system.language"/>
    </media>

    <!-- ===================== MIDIAS ===================== -->
    <media id="bg"     src="background.png" descriptor="dBg"/>

    <media id="video"  src="animGar.mp4" descriptor="dVideo">
      <!-- propriedade usada pra encolher o video ao apertar VERMELHO (left,top,width,height) -->
      <property name="bounds"/>
    </media>

    <media id="choro"  src="choro.mp4"  descriptor="dChoro"/>
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>
    <media id="photo"  src="photo.png"  descriptor="dPhoto"/>
    <media id="icon"   src="icon.png"   descriptor="dIcon"/>
    <media id="shoes"  src="shoes.mp4"  descriptor="dShoes"/>

    <!-- formulario de compra: PT por padrao, EN se o sistema estiver em ingles -->
    <switch id="formSwitch">
      <bindRule constituent="ptForm" rule="rPor"/>
      <bindRule constituent="enForm" rule="rEng"/>
      <defaultComponent component="ptForm"/>
      <media id="ptForm" src="ptForm.htm" descriptor="dForm"/>
      <media id="enForm" src="enForm.htm" descriptor="dForm"/>
    </switch>

    <!-- ===================== ELOS (LINKS) ===================== -->

    <!-- fundo iniciou -> inicia o video principal -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="bg"/>
      <bind role="start"   component="video"/>
    </link>

    <!-- video iniciou -> inicia a musica por cima -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="video"/>
      <bind role="start"   component="choro"/>
    </link>

    <!-- video iniciou -> pipoca o clipe de drible num canto (apos 8s) -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="pDelay" value="8s"/>
      <bind role="onBegin" component="video"/>
      <bind role="start"   component="drible"/>
    </link>

    <!-- video iniciou -> pipoca a foto num canto (apos 8s) -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="pDelay" value="8s"/>
      <bind role="onBegin" component="video"/>
      <bind role="start"   component="photo"/>
    </link>

    <!-- video iniciou -> aparece/pisca o icone chamando o botao VERMELHO (apos 20s) -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="pDelay" value="20s"/>
      <bind role="onBegin" component="video"/>
      <bind role="start"   component="icon"/>
    </link>

    <!-- botao VERMELHO -> encolhe o video, toca shoes, abre o formulario e apaga o icone -->
    <link xconnector="onRedSelection">
      <linkParam name="pBounds" value="5%,5%,45%,45%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="set"   component="video" interface="bounds"/>
      <bind role="start" component="shoes"/>
      <bind role="start" component="formSwitch"/>
      <bind role="stop"  component="icon"/>
    </link>

    <!-- video terminou -> corta a musica e o fundo -->
    <link xconnector="onEndStop">
      <bind role="onEnd" component="video"/>
      <bind role="stop"  component="choro"/>
      <bind role="stop"  component="bg"/>
    </link>

  </body>
</ncl>
