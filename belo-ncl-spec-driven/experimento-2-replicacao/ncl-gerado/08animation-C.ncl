<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
  gen.ncl - Aplicacao Ginga-NCL (perfil NCL 3.0 EDTV), tema futebol.

  Documento AUTOCONTIDO: regioes, descritores, transicoes, regras,
  conectores causais e elos sao TODOS definidos aqui dentro. Nenhuma
  base externa e importada (sem <importBase>).

  Midias (referenciadas apenas pelo nome do arquivo, pasta sets-C):
    animGar.mp4    - video principal, tela cheia, fio da meada
    choro.mp4      - musica (SOMENTE audio, sem imagem => descritor sem regiao)
    background.png - imagem de fundo, camada mais debaixo (zIndex 0)
    drible.mp4     - clipe de drible, quadradinho sup. esquerdo, fade-in / wipe-out
    photo.png      - foto semi-transparente que desliza para baixo
    icon.png       - icone, canto sup. direito, convida a apertar VERMELHO
    shoes.mp4      - video de chuteiras, inferior esquerdo
    ptForm.htm     - formulario de compra em portugues (padrao)
    enForm.htm     - formulario de compra em ingles (se sistema em ingles)
-->
<ncl id="futebolAnim" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ============ REGIOES ============ -->
    <regionBase>
      <!-- Fundo: camada mais debaixo -->
      <region id="rgBg"     left="0"   top="0"   width="100%" height="100%" zIndex="0"/>
      <!-- Video principal: tela cheia; encolhe/cresce animando a propriedade bounds -->
      <region id="rgVideo"  left="0"   top="0"   width="100%" height="100%" zIndex="1"/>
      <!-- Chuteiras: canto inferior esquerdo -->
      <region id="rgShoes"  left="3%"  top="55%" width="42%"  height="40%"  zIndex="2"/>
      <!-- Formulario de compra: lado direito -->
      <region id="rgForm"   left="50%" top="0"   width="50%"  height="100%" zIndex="3"/>
      <!-- Drible: quadradinho no canto superior esquerdo -->
      <region id="rgDrible" left="3%"  top="5%"  width="30%"  height="30%"  zIndex="5"/>
      <!-- Foto: mesmo cantinho de cima a esquerda (ponto de partida do slide) -->
      <region id="rgPhoto"  left="3%"  top="5%"  width="30%"  height="35%"  zIndex="5"/>
      <!-- Icone: canto superior direito -->
      <region id="rgIcon"   left="75%" top="5%"  width="20%"  height="20%"  zIndex="6"/>
    </regionBase>

    <!-- ============ TRANSICOES (fade / wipe) ============ -->
    <transitionBase>
      <transition id="tFade" type="fade"    dur="1s"/>
      <transition id="tWipe" type="barWipe" subtype="leftToRight" dur="1s"/>
    </transitionBase>

    <!-- ============ DESCRITORES ============ -->
    <descriptorBase>
      <descriptor id="dBg"    region="rgBg"/>
      <descriptor id="dVideo" region="rgVideo"/>

      <!-- Musica: descritor SEM regiao => toca somente o audio, sem imagem -->
      <descriptor id="dMusic"/>

      <!-- Drible: entra com fade suave e sai com efeito de wipe -->
      <descriptor id="dDrible" region="rgDrible" transIn="tFade" transOut="tWipe"/>

      <!-- Foto: meio transparente (via descriptorParam, NAO como atributo direto)
           e fica na tela por poucos segundos -->
      <descriptor id="dPhoto" region="rgPhoto" explicitDur="6s">
        <descriptorParam name="transparency" value="0.5"/>
      </descriptor>

      <!-- Icone: aparece por alguns segundos convidando o VERMELHO; focusIndex
           deixa o icone focavel (robusto p/ selecao por tecla colorida) -->
      <descriptor id="dIcon" region="rgIcon" explicitDur="6s"
                  focusIndex="1" transIn="tFade" transOut="tFade"/>

      <!-- Chuteiras -->
      <descriptor id="dShoes" region="rgShoes"/>

      <!-- Formulario: ganha o foco (focusIndex=2) e fica um tempo aberto -->
      <descriptor id="dForm" region="rgForm" explicitDur="20s" focusIndex="2"/>
    </descriptorBase>

    <!-- ============ REGRAS (idioma do sistema) ============ -->
    <ruleBase>
      <rule id="rEnglish" var="system.language" comparator="eq" value="eng"/>
    </ruleBase>

    <!-- ============ CONECTORES CAUSAIS ============ -->
    <connectorBase>

      <!-- onBegin -> start (permite iniciar varias midias no mesmo elo) -->
      <causalConnector id="cBeginStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded"/>
      </causalConnector>

      <!-- onEnd -> stop (permite parar varias midias no mesmo elo) -->
      <causalConnector id="cEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded"/>
      </causalConnector>

      <!-- onBegin -> set (anima/atribui uma propriedade: valor + duracao) -->
      <causalConnector id="cBeginSet">
        <connectorParam name="valor"/>
        <connectorParam name="duracao"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$valor" duration="$duracao"/>
      </causalConnector>

      <!-- onSelection(VERMELHO): para o icone, encolhe o video (setBounds),
           inicia chuteiras+formulario (start) e move o foco p/ o form (setFoco).
           setBounds e setFoco sao atribuicoes (eventType=attribution). -->
      <causalConnector id="cRedInteract">
        <connectorParam name="bounds"/>
        <connectorParam name="dur"/>
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="setBounds" eventType="attribution" actionType="start"
                        value="$bounds" duration="$dur"/>
          <simpleAction role="start" max="unbounded"/>
          <simpleAction role="setFoco" eventType="attribution" actionType="start"
                        value="$foco"/>
        </compoundAction>
      </causalConnector>

      <!-- onEnd -> cresce o video de volta (set) e para as chuteiras (stop) -->
      <causalConnector id="cEndSetStop">
        <connectorParam name="valor"/>
        <connectorParam name="duracao"/>
        <simpleCondition role="onEnd"/>
        <compoundAction operator="par">
          <simpleAction role="set" value="$valor" duration="$duracao"/>
          <simpleAction role="stop"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>
  </head>

  <body>
    <!-- Ponto de entrada: o video principal e o fio da meada -->
    <port id="pStart" component="mainVideo"/>

    <!-- No de settings do Ginga: controla o foco corrente do sistema -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus"/>
    </media>

    <!-- Fundo (camada mais debaixo). Entra aos 5s, para no fim do video. -->
    <media id="background" src="background.png" descriptor="dBg"/>

    <!-- Musica (somente audio). Entra aos 5s, para no fim do video. -->
    <media id="music" src="choro.mp4" descriptor="dMusic"/>

    <!-- Video principal em tela cheia, com ancoras de tempo e bounds animavel -->
    <media id="mainVideo" src="animGar.mp4" descriptor="dVideo">
      <area id="aMusic"  begin="5s"/>
      <area id="aDrible" begin="12s"/>
      <area id="aPhoto"  begin="40s"/>
      <area id="aIcon"   begin="44s"/>
      <property name="bounds" value="0%,0%,100%,100%"/>
    </media>

    <!-- Clipe de drible: quadradinho superior esquerdo (fade-in / wipe-out) -->
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>

    <!-- Foto semi-transparente; comeca no topo e desliza para baixo -->
    <media id="photo" src="photo.png" descriptor="dPhoto">
      <property name="top" value="5%"/>
    </media>

    <!-- Icone (canto superior direito) convidando o botao VERMELHO -->
    <media id="icon" src="icon.png" descriptor="dIcon"/>

    <!-- Video de chuteiras (inferior esquerdo), aberto na interacao -->
    <media id="shoes" src="shoes.mp4" descriptor="dShoes"/>

    <!-- Formulario de compra: portugues por padrao; ingles se sistema em ingles -->
    <switch id="formSwitch">
      <defaultComponent component="ptForm"/>
      <bindRule rule="rEnglish" constituent="enForm"/>
      <media id="ptForm" src="ptForm.htm" descriptor="dForm"/>
      <media id="enForm" src="enForm.htm" descriptor="dForm"/>
    </switch>

    <!-- ============ ELOS ============ -->

    <!-- Aos 5s: entram juntos a musica (audio) e o fundo -->
    <link id="lStartMusicBg" xconnector="cBeginStart">
      <bind role="onBegin" component="mainVideo" interface="aMusic"/>
      <bind role="start"   component="music"/>
      <bind role="start"   component="background"/>
    </link>

    <!-- Aos 12s: entra o clipe de drible (fade-in pelo descritor) -->
    <link id="lStartDrible" xconnector="cBeginStart">
      <bind role="onBegin" component="mainVideo" interface="aDrible"/>
      <bind role="start"   component="drible"/>
    </link>

    <!-- Aos 40s: entra a foto semi-transparente -->
    <link id="lStartPhoto" xconnector="cBeginStart">
      <bind role="onBegin" component="mainVideo" interface="aPhoto"/>
      <bind role="start"   component="photo"/>
    </link>

    <!-- A foto desliza para baixo (anima a propriedade top de 5% -> 55%) -->
    <link id="lSlidePhoto" xconnector="cBeginSet">
      <bind role="onBegin" component="photo"/>
      <bind role="set"     component="photo" interface="top">
        <bindParam name="valor"   value="55%"/>
        <bindParam name="duracao" value="5s"/>
      </bind>
    </link>

    <!-- Logo em seguida (44s): pisca o icone no canto superior direito -->
    <link id="lStartIcon" xconnector="cBeginStart">
      <bind role="onBegin" component="mainVideo" interface="aIcon"/>
      <bind role="start"   component="icon"/>
    </link>

    <!-- Quando o icone aparece, o foco vai para ele (para o VERMELHO agir) -->
    <link id="lFocusIcon" xconnector="cBeginSet">
      <bind role="onBegin" component="icon"/>
      <bind role="set"     component="settings" interface="service.currentFocus">
        <bindParam name="valor"   value="1"/>
        <bindParam name="duracao" value="0s"/>
      </bind>
    </link>

    <!-- Interacao VERMELHO (enquanto o icone esta na tela):
         some o icone; encolhe o video p/ o canto sup. esquerdo (revela o fundo);
         toca as chuteiras embaixo a esquerda; abre o formulario a direita e
         passa o foco p/ ele. -->
    <link id="lRed" xconnector="cRedInteract">
      <bind role="onSelection" component="icon"/>
      <bind role="stop"        component="icon"/>
      <bind role="setBounds"   component="mainVideo" interface="bounds">
        <bindParam name="bounds" value="0%,0%,45%,45%"/>
        <bindParam name="dur"    value="1s"/>
      </bind>
      <bind role="start"   component="shoes"/>
      <bind role="start"   component="formSwitch"/>
      <bind role="setFoco" component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="2"/>
      </bind>
    </link>

    <!-- Fim do formulario: o video volta a preencher a tela; chuteiras param -->
    <link id="lFormEnd" xconnector="cEndSetStop">
      <bind role="onEnd" component="formSwitch"/>
      <bind role="set"   component="mainVideo" interface="bounds">
        <bindParam name="valor"   value="0%,0%,100%,100%"/>
        <bindParam name="duracao" value="1s"/>
      </bind>
      <bind role="stop"  component="shoes"/>
    </link>

    <!-- Fim do video principal: para a musica e o fundo -->
    <link id="lVideoEnd" xconnector="cEndStop">
      <bind role="onEnd" component="mainVideo"/>
      <bind role="stop"  component="music"/>
      <bind role="stop"  component="background"/>
    </link>

  </body>
</ncl>
