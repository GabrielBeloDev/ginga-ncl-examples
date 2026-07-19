<?xml version="1.0" encoding="UTF-8"?>
<!--
  main.ncl - Programa interativo "Garrincha" em NCL 3.0 (perfil EDTV / Ginga).
  Todas as midias sao as da propria pasta. Conectores definidos inline para
  o documento ser autocontido (nao depende de connectorBase externo).

  Comportamento:
    - background.png ao fundo; animGar.mp4 quase em tela cheia por cima.
    - choro.mp4 (musica de fundo) comeca 5s depois do video.
    - ~12s: drible.mp4 num quadradinho no canto superior esquerdo.
    - ~40s: photo.png (meio transparente) aparece e desliza um pouco pra baixo.
    - barra de menu na base com 4 botoes (setas navegam, ENTER seleciona)
      que trocam a trilha: chorinho/rock/techno/cartoon.
    - ~metade do video: icon.png no canto superior direito; botao VERMELHO
      abre a propaganda (shoes.mp4 embaixo-esq + ptForm.htm na direita) e o
      video principal encolhe pra um cantinho; ao fim do shoes volta ao normal.
    - indicador de interatividade (intOn/intOff) no canto inferior direito,
      liga/desliga com o botao VERDE.
-->
<ncl id="main" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- musica de fundo: regiao atras de tudo (fica escondida pelo background) -->
      <region id="rgMusic" zIndex="0" left="0%"  top="0%"  width="100%" height="100%"/>
      <region id="rgBg"    zIndex="1" left="0%"  top="0%"  width="100%" height="100%"/>
      <!-- video principal quase em tela cheia -->
      <region id="rgVideo" zIndex="2" left="5%"  top="4%"  width="90%"  height="82%"/>
      <!-- quadradinho superior esquerdo -->
      <region id="rgDrible" zIndex="4" left="7%" top="8%"  width="26%"  height="30%"/>
      <region id="rgPhoto"  zIndex="4" left="7%" top="8%"  width="26%"  height="32%"/>
      <!-- icone de propaganda superior direito -->
      <region id="rgIcon"  zIndex="5" left="84%" top="7%"  width="12%"  height="15%"/>
      <!-- barra de menu na base, com 4 botoes -->
      <region id="rgMenu"  zIndex="6" left="0%"  top="87%" width="100%" height="13%">
        <region id="rgBtn1" zIndex="6" left="20%" top="15%" width="13%" height="70%"/>
        <region id="rgBtn2" zIndex="6" left="37%" top="15%" width="13%" height="70%"/>
        <region id="rgBtn3" zIndex="6" left="54%" top="15%" width="13%" height="70%"/>
        <region id="rgBtn4" zIndex="6" left="71%" top="15%" width="13%" height="70%"/>
      </region>
      <!-- propaganda: chuteira embaixo-esquerda + formulario na direita -->
      <region id="rgShoes" zIndex="7" left="4%"  top="48%" width="44%"  height="40%"/>
      <region id="rgForm"  zIndex="7" left="52%" top="8%"  width="44%"  height="78%"/>
      <!-- indicador de interatividade, canto inferior direito -->
      <region id="rgInt"   zIndex="8" left="90%" top="85%" width="9%"   height="12%"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="dMusic"  region="rgMusic"/>
      <descriptor id="dBg"     region="rgBg"/>
      <descriptor id="dVideo"  region="rgVideo"/>
      <descriptor id="dDrible" region="rgDrible"/>
      <descriptor id="dPhoto"  region="rgPhoto" transparency="0.4"/>
      <descriptor id="dIcon"   region="rgIcon"/>
      <!-- botoes do menu: navegaveis por setas (focusIndex + moveLeft/moveRight) -->
      <descriptor id="dBtn1" region="rgBtn1" focusIndex="1" moveRight="2"
                  focusBorderColor="yellow" focusBorderWidth="4" selBorderColor="green"/>
      <descriptor id="dBtn2" region="rgBtn2" focusIndex="2" moveLeft="1" moveRight="3"
                  focusBorderColor="yellow" focusBorderWidth="4" selBorderColor="green"/>
      <descriptor id="dBtn3" region="rgBtn3" focusIndex="3" moveLeft="2" moveRight="4"
                  focusBorderColor="yellow" focusBorderWidth="4" selBorderColor="green"/>
      <descriptor id="dBtn4" region="rgBtn4" focusIndex="4" moveLeft="3"
                  focusBorderColor="yellow" focusBorderWidth="4" selBorderColor="green"/>
      <descriptor id="dShoes" region="rgShoes"/>
      <descriptor id="dForm"  region="rgForm"/>
      <descriptor id="dIntOn"  region="rgInt"/>
      <descriptor id="dIntOff" region="rgInt"/>
    </descriptorBase>

    <connectorBase>
      <!-- onBegin -> start (com atraso) -->
      <causalConnector id="onBeginStartDelay">
        <connectorParam name="delay"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" delay="$delay"/>
      </causalConnector>

      <!-- onBegin -> set de propriedade com animacao (duracao) -->
      <causalConnector id="onBeginSetDur">
        <connectorParam name="var"/>
        <connectorParam name="duration"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="set" value="$var" duration="$duration"/>
      </causalConnector>

      <!-- ENTER sobre elemento em foco -> para varias / inicia varias (troca de trilha) -->
      <causalConnector id="onSelectionStopStart">
        <simpleCondition role="onSelection" key="ENTER"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"  max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
        </compoundAction>
      </causalConnector>

      <!-- tecla colorida -> inicia um ou mais componentes -->
      <causalConnector id="onKeySelectionStartN">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="start" max="unbounded"/>
      </causalConnector>

      <!-- tecla colorida -> set de propriedade -->
      <causalConnector id="onKeySelectionSet">
        <connectorParam name="keyCode"/>
        <connectorParam name="var"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="set" value="$var"/>
      </causalConnector>

      <!-- tecla colorida -> para um e inicia outro (toggle do indicador) -->
      <causalConnector id="onKeySelectionStopStart">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="seq">
          <simpleAction role="stop"  max="unbounded"/>
          <simpleAction role="start" max="unbounded"/>
        </compoundAction>
      </causalConnector>

      <!-- onEnd -> para componentes e restaura propriedade (fecha propaganda) -->
      <causalConnector id="onEndStopSet">
        <connectorParam name="var"/>
        <simpleCondition role="onEnd"/>
        <compoundAction operator="seq">
          <simpleAction role="stop" max="unbounded"/>
          <simpleAction role="set"  value="$var"/>
        </compoundAction>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- portas de entrada: o que ja comeca no arranque do programa -->
    <port id="pBg"    component="background"/>
    <port id="pVideo" component="videoGar"/>
    <port id="pBtn1"  component="btnChorinho"/>
    <port id="pBtn2"  component="btnRock"/>
    <port id="pBtn3"  component="btnTechno"/>
    <port id="pBtn4"  component="btnCartoon"/>
    <port id="pInt"   component="intOff"/>

    <!-- foco inicial no primeiro botao do menu -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="background" src="background.png" descriptor="dBg"/>

    <media id="videoGar" src="animGar.mp4" descriptor="dVideo">
      <property name="bounds"/>
    </media>

    <!-- trilhas sonoras (uma por genero) -->
    <media id="musChoro"   src="choro.mp4"   descriptor="dMusic"/>
    <media id="musRock"    src="rock.mp4"    descriptor="dMusic"/>
    <media id="musTechno"  src="techno.mp4"  descriptor="dMusic"/>
    <media id="musCartoon" src="cartoon.mp4" descriptor="dMusic"/>

    <media id="drible" src="drible.mp4" descriptor="dDrible"/>

    <media id="photo" src="photo.png" descriptor="dPhoto">
      <property name="top"/>
    </media>

    <media id="icon" src="icon.png" descriptor="dIcon"/>

    <!-- botoes do menu -->
    <media id="btnChorinho" src="chorinho.png" descriptor="dBtn1"/>
    <media id="btnRock"     src="rock.png"     descriptor="dBtn2"/>
    <media id="btnTechno"   src="techno.png"   descriptor="dBtn3"/>
    <media id="btnCartoon"  src="cartoon.png"  descriptor="dBtn4"/>

    <!-- propaganda -->
    <media id="shoes" src="shoes.mp4"  descriptor="dShoes"/>
    <media id="form"  src="ptForm.htm" descriptor="dForm"/>

    <!-- indicador de interatividade -->
    <media id="intOn"  src="intOn.png"  descriptor="dIntOn"/>
    <media id="intOff" src="intOff.png" descriptor="dIntOff"/>

    <!-- =============================== ELOS =============================== -->

    <!-- musica de fundo comeca 5s depois do video -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="delay" value="5s"/>
      <bind role="onBegin" component="videoGar"/>
      <bind role="start"   component="musChoro"/>
    </link>

    <!-- ~12s: clipe de drible no quadradinho -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="delay" value="12s"/>
      <bind role="onBegin" component="videoGar"/>
      <bind role="start"   component="drible"/>
    </link>

    <!-- ~40s: foto meio transparente aparece -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="delay" value="40s"/>
      <bind role="onBegin" component="videoGar"/>
      <bind role="start"   component="photo"/>
    </link>

    <!-- a foto desliza um pouco pra baixo (anima o 'top' em 3s) -->
    <link xconnector="onBeginSetDur">
      <linkParam name="var"      value="42%"/>
      <linkParam name="duration" value="3s"/>
      <bind role="onBegin" component="photo"/>
      <bind role="set"     component="photo" interface="top"/>
    </link>

    <!-- ~metade do video: aparece o icone de propaganda (ajuste o delay se quiser) -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="delay" value="60s"/>
      <bind role="onBegin" component="videoGar"/>
      <bind role="start"   component="icon"/>
    </link>

    <!-- menu: cada botao para as outras trilhas e inicia a sua -->
    <link xconnector="onSelectionStopStart">
      <bind role="onSelection" component="btnChorinho"/>
      <bind role="start" component="musChoro"/>
      <bind role="stop"  component="musRock"/>
      <bind role="stop"  component="musTechno"/>
      <bind role="stop"  component="musCartoon"/>
    </link>
    <link xconnector="onSelectionStopStart">
      <bind role="onSelection" component="btnRock"/>
      <bind role="start" component="musRock"/>
      <bind role="stop"  component="musChoro"/>
      <bind role="stop"  component="musTechno"/>
      <bind role="stop"  component="musCartoon"/>
    </link>
    <link xconnector="onSelectionStopStart">
      <bind role="onSelection" component="btnTechno"/>
      <bind role="start" component="musTechno"/>
      <bind role="stop"  component="musChoro"/>
      <bind role="stop"  component="musRock"/>
      <bind role="stop"  component="musCartoon"/>
    </link>
    <link xconnector="onSelectionStopStart">
      <bind role="onSelection" component="btnCartoon"/>
      <bind role="start" component="musCartoon"/>
      <bind role="stop"  component="musChoro"/>
      <bind role="stop"  component="musRock"/>
      <bind role="stop"  component="musTechno"/>
    </link>

    <!-- botao VERMELHO sobre o icone: abre a propaganda (chuteira + formulario) -->
    <link xconnector="onKeySelectionStartN">
      <linkParam name="keyCode" value="RED"/>
      <bind role="onSelection" component="icon"/>
      <bind role="start" component="shoes"/>
      <bind role="start" component="form"/>
    </link>

    <!-- ...e o video principal encolhe pra um cantinho -->
    <link xconnector="onKeySelectionSet">
      <linkParam name="keyCode" value="RED"/>
      <linkParam name="var"     value="4%,4%,40%,35%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="set" component="videoGar" interface="bounds"/>
    </link>

    <!-- quando a chuteira termina: fecha o formulario e o video volta ao normal -->
    <link xconnector="onEndStopSet">
      <linkParam name="var" value="5%,4%,90%,82%"/>
      <bind role="onEnd" component="shoes"/>
      <bind role="stop"  component="form"/>
      <bind role="set"   component="videoGar" interface="bounds"/>
    </link>

    <!-- indicador de interatividade: VERDE liga/desliga (alterna intOff <-> intOn) -->
    <link xconnector="onKeySelectionStopStart">
      <linkParam name="keyCode" value="GREEN"/>
      <bind role="onSelection" component="intOff"/>
      <bind role="stop"  component="intOff"/>
      <bind role="start" component="intOn"/>
    </link>
    <link xconnector="onKeySelectionStopStart">
      <linkParam name="keyCode" value="GREEN"/>
      <bind role="onSelection" component="intOn"/>
      <bind role="stop"  component="intOn"/>
      <bind role="start" component="intOff"/>
    </link>

  </body>
</ncl>
