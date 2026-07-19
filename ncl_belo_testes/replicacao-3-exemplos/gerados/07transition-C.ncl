<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  gen.ncl - Aplicacao Ginga-NCL AUTOCONTIDA (perfil NCL 3.0 EDTV)
  Documento unico: regioes, transicoes, descritores, regras e conectores
  causais definidos DENTRO deste arquivo (sem importBase / bases externas).
  Midias referenciadas por nome de arquivo (mesma pasta deste .ncl).
-->
<ncl id="genApp" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ================= REGIOES ================= -->
    <regionBase>
      <!-- Fundo cobrindo a tela inteira, atras de tudo -->
      <region id="rgBackground" left="0%" top="0%" width="100%" height="100%" zIndex="0"/>
      <!-- Video principal em tela cheia (geometria alterada em runtime via bounds) -->
      <region id="rgMain" left="0%" top="0%" width="100%" height="100%" zIndex="1"/>
      <!-- Janelinha no canto superior-esquerdo (drible e depois a foto) -->
      <region id="rgCorner" left="5%" top="8%" width="30%" height="28%" zIndex="3"/>
      <!-- Icone no canto superior-direito -->
      <region id="rgIcon" left="82%" top="8%" width="12%" height="12%" zIndex="6"/>
      <!-- Area inferior-esquerda (chuteiras) -->
      <region id="rgShoes" left="5%" top="70%" width="30%" height="25%" zIndex="4"/>
      <!-- Painel do formulario no lado direito -->
      <region id="rgForm" left="55%" top="10%" width="42%" height="80%" zIndex="5"/>
    </regionBase>

    <!-- ================= TRANSICOES ================= -->
    <transitionBase>
      <!-- entrada suave (fade) e saida em cortina (barWipe) -->
      <transition id="tFadeIn" type="fade" subtype="crossfade" dur="1s"/>
      <transition id="tBarWipe" type="barWipe" subtype="leftToRight" dur="1s"/>
    </transitionBase>

    <!-- ================= DESCRITORES ================= -->
    <descriptorBase>
      <descriptor id="dsBackground" region="rgBackground"/>
      <descriptor id="dsMain" region="rgMain"/>
      <!-- Drible: entra com fade suave e sai com efeito de cortina (barWipe) -->
      <descriptor id="dsDrible" region="rgCorner" explicitDur="8s"
                  transIn="tFadeIn" transOut="tBarWipe"/>
      <!-- Foto: aparece por instantes na mesma janelinha do canto -->
      <descriptor id="dsPhoto" region="rgCorner" explicitDur="4s"/>
      <!-- Icone: pisca por alguns segundos e e o alvo do botao VERMELHO -->
      <descriptor id="dsIcon" region="rgIcon" explicitDur="6s"
                  focusIndex="0" focusBorderColor="red" focusBorderWidth="4"/>
      <descriptor id="dsShoes" region="rgShoes"/>
      <descriptor id="dsForm" region="rgForm" explicitDur="15s"/>
      <!-- Trilha sonora: apenas som (descritor sem regiao visual) -->
      <descriptor id="dsChoro"/>
    </descriptorBase>

    <!-- ================= REGRAS (idioma do sistema) ================= -->
    <ruleBase>
      <rule id="rEnglish" var="system.language" comparator="eq" value="en"/>
    </ruleBase>

    <!-- ================= CONECTORES CAUSAIS ================= -->
    <connectorBase>

      <!-- onBegin -> start (com atraso parametrizavel) -->
      <causalConnector id="cStartDelay">
        <connectorParam name="delay"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" delay="$delay"/>
      </causalConnector>

      <!-- onEnd -> start -->
      <causalConnector id="cEndStart">
        <simpleCondition role="onEnd"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- onBegin -> set (usado p/ dar foco ao icone) -->
      <causalConnector id="cBeginSet">
        <connectorParam name="v"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$v"/>
      </causalConnector>

      <!-- onEnd -> stop (varios alvos em paralelo) -->
      <causalConnector id="cEndStopN">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onSelection(VERMELHO) -> para o icone, inicia midias e encolhe o video -->
      <causalConnector id="cRed">
        <connectorParam name="shrink"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="start" max="unbounded" qualifier="par"/>
          <simpleAction role="set" value="$shrink"/>
        </compoundAction>
      </causalConnector>

      <!-- onEnd -> para midia e restaura geometria (video volta a tela cheia) -->
      <causalConnector id="cEndStopSet">
        <connectorParam name="restore"/>
        <simpleCondition role="onEnd"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="set" value="$restore"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>
  </head>

  <body>

    <!-- Ponto de entrada: comeca tocando o video principal em tela cheia -->
    <port id="pInit" component="mAnim"/>

    <!-- Configuracoes do sistema (idioma e foco atual) -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="system.language"/>
      <property name="service.currentFocus"/>
    </media>

    <!-- Fundo cobrindo a tela inteira, la no fundo de tudo -->
    <media id="mBackground" src="background.png" descriptor="dsBackground"/>

    <!-- Video principal em tela cheia (bounds alterado em runtime p/ encolher/restaurar) -->
    <media id="mAnim" src="animGar.mp4" descriptor="dsMain">
      <property name="bounds"/>
    </media>

    <!-- Trilha sonora (apenas o som) -->
    <media id="mChoro" src="choro.mp4" descriptor="dsChoro"/>

    <!-- Janelinha do canto: primeiro o drible, depois a foto -->
    <media id="mDrible" src="drible.mp4" descriptor="dsDrible"/>
    <media id="mPhoto" src="photo.png" descriptor="dsPhoto"/>

    <!-- Icone do canto superior-direito -->
    <media id="mIcon" src="icon.png" descriptor="dsIcon"/>

    <!-- Chuteiras na area inferior-esquerda -->
    <media id="mShoes" src="shoes.mp4" descriptor="dsShoes"/>

    <!-- Formulario no painel da direita: EN se sistema em ingles, senao PT (padrao) -->
    <switch id="swForm">
      <bindRule constituent="mEnForm" rule="rEnglish"/>
      <defaultComponent component="mPtForm"/>
      <media id="mEnForm" src="enForm.htm" descriptor="dsForm"/>
      <media id="mPtForm" src="ptForm.htm" descriptor="dsForm"/>
    </switch>

    <!-- ================= ELOS (LINKS) ================= -->

    <!-- ~5s depois do inicio: entra o fundo atras de tudo -->
    <link xconnector="cStartDelay">
      <linkParam name="delay" value="5s"/>
      <bind role="onBegin" component="mAnim"/>
      <bind role="start" component="mBackground"/>
    </link>

    <!-- ~5s depois do inicio: comeca a musica (choro) -->
    <link xconnector="cStartDelay">
      <linkParam name="delay" value="5s"/>
      <bind role="onBegin" component="mAnim"/>
      <bind role="start" component="mChoro"/>
    </link>

    <!-- ~12s: drible na janelinha do canto (fade in / barWipe out) -->
    <link xconnector="cStartDelay">
      <linkParam name="delay" value="12s"/>
      <bind role="onBegin" component="mAnim"/>
      <bind role="start" component="mDrible"/>
    </link>

    <!-- ~40s: foto aparece por instantes na mesma janelinha do canto -->
    <link xconnector="cStartDelay">
      <linkParam name="delay" value="40s"/>
      <bind role="onBegin" component="mAnim"/>
      <bind role="start" component="mPhoto"/>
    </link>

    <!-- Logo apos a foto: o icone pisca no canto superior-direito -->
    <link xconnector="cEndStart">
      <bind role="onEnd" component="mPhoto"/>
      <bind role="start" component="mIcon"/>
    </link>

    <!-- Ao surgir, o icone recebe o foco (p/ que o VERMELHO seja entregue a ele) -->
    <link xconnector="cBeginSet">
      <linkParam name="v" value="0"/>
      <bind role="onBegin" component="mIcon"/>
      <bind role="set" component="settings" interface="service.currentFocus"/>
    </link>

    <!-- Interacao VERMELHO (enquanto o icone esta na tela):
         some com o icone, encolhe o video para a janelinha do canto (mesmo video,
         continua tocando), toca as chuteiras embaixo a esquerda e abre o
         formulario no painel da direita -->
    <link xconnector="cRed">
      <linkParam name="shrink" value="5%,8%,30%,28%"/>
      <bind role="onSelection" component="mIcon"/>
      <bind role="stop" component="mIcon"/>
      <bind role="start" component="mShoes"/>
      <bind role="start" component="swForm"/>
      <bind role="set" component="mAnim" interface="bounds"/>
    </link>

    <!-- O formulario fecha sozinho: para as chuteiras e o video volta a tela cheia -->
    <link xconnector="cEndStopSet">
      <linkParam name="restore" value="0%,0%,100%,100%"/>
      <bind role="onEnd" component="swForm"/>
      <bind role="stop" component="mShoes"/>
      <bind role="set" component="mAnim" interface="bounds"/>
    </link>

    <!-- Fim: quando o video principal acaba, corta junto a musica e o fundo -->
    <link xconnector="cEndStopN">
      <bind role="onEnd" component="mAnim"/>
      <bind role="stop" component="mChoro"/>
      <bind role="stop" component="mBackground"/>
    </link>

  </body>
</ncl>
