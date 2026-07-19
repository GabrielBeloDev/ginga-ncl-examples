<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- ===================================================================== -->
<!--  Garrincha - Aplicacao interativa de TV Digital                       -->
<!--  Documento NCL 3.0 EDTVProfile, autocontido.                          -->
<!-- ===================================================================== -->
<ncl id="appGarrincha" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ============================================================= -->
    <!--  REGRAS  (idioma do formulario: PT por padrao, EN se ingles)  -->
    <!-- ============================================================= -->
    <ruleBase>
      <rule id="rEn" var="system.language" comparator="eq" value="en"/>
      <rule id="rPt" var="system.language" comparator="ne" value="en"/>
    </ruleBase>

    <!-- ============================================================= -->
    <!--  TRANSICOES  (fade de entrada / wipe de saida do drible)      -->
    <!-- ============================================================= -->
    <transitionBase>
      <transition id="tFadeIn"  type="fade"    subtype="crossfade"   dur="2s"/>
      <transition id="tWipeOut" type="barWipe" subtype="leftToRight" dur="1s"/>
    </transitionBase>

    <!-- ============================================================= -->
    <!--  REGIOES  (tela = 100% x 100%)                                -->
    <!-- ============================================================= -->
    <regionBase>
      <region id="rgBackground"    left="0%"     top="0%"     width="100%"   height="100%"  zIndex="0"/>
      <region id="rgVideo"         left="0%"     top="0%"     width="100%"   height="88%"   zIndex="1"/>
      <region id="rgSquare"        left="5%"     top="6.7%"   width="18.5%"  height="18.5%" zIndex="3"/>
      <region id="rgIcon"          left="87.5%"  top="11.7%"  width="8.5%"   height="6.7%"  zIndex="3"/>
      <region id="rgShoes"         left="15%"    top="60%"    width="25%"    height="25%"   zIndex="4"/>
      <region id="rgForm"          left="57.25%" top="9.83%"  width="37.75%" height="70.2%" zIndex="5"/>
      <region id="rgInteractivity" left="92.5%"  top="91.7%"  width="5%"     height="6.5%"  zIndex="3"/>
      <region id="rgChorinho"      left="2.5%"   top="91.7%"  width="11.7%"  height="6.5%"  zIndex="2"/>
      <region id="rgRock"          left="25%"    top="91.7%"  width="11.7%"  height="6.5%"  zIndex="2"/>
      <region id="rgTechno"        left="47.5%"  top="91.7%"  width="11.7%"  height="6.5%"  zIndex="2"/>
      <region id="rgCartoon"       left="70%"    top="91.7%"  width="11.7%"  height="6.5%"  zIndex="2"/>
    </regionBase>

    <!-- ============================================================= -->
    <!--  DESCRITORES                                                  -->
    <!-- ============================================================= -->
    <descriptorBase>
      <descriptor id="dBackground" region="rgBackground"/>
      <descriptor id="dVideo"      region="rgVideo"/>

      <!-- trilhas sonoras (audio, sem regiao) -->
      <descriptor id="dChoro"/>
      <descriptor id="dRock"/>
      <descriptor id="dTechno"/>
      <descriptor id="dCartoon"/>

      <!-- quadradinho: drible (com transicoes) e foto (semitransparente) -->
      <descriptor id="dDrible" region="rgSquare" transIn="tFadeIn" transOut="tWipeOut"/>
      <descriptor id="dPhoto"  region="rgSquare" transparency="0.4"/>

      <!-- propaganda -->
      <descriptor id="dIcon"  region="rgIcon"/>
      <descriptor id="dShoes" region="rgShoes"/>
      <descriptor id="dForm"  region="rgForm" explicitDur="15s"/>

      <!-- indicador de interatividade -->
      <descriptor id="dIntOn"  region="rgInteractivity"/>
      <descriptor id="dIntOff" region="rgInteractivity"/>

      <!-- botoes do menu de trilhas (navegaveis com setas, foco circular) -->
      <descriptor id="dBtChorinho" region="rgChorinho" focusIndex="1"
                  moveLeft="4" moveRight="2" focusBorderColor="yellow"/>
      <descriptor id="dBtRock"     region="rgRock"     focusIndex="2"
                  moveLeft="1" moveRight="3" focusBorderColor="yellow"/>
      <descriptor id="dBtTechno"   region="rgTechno"   focusIndex="3"
                  moveLeft="2" moveRight="4" focusBorderColor="yellow"/>
      <descriptor id="dBtCartoon"  region="rgCartoon"  focusIndex="4"
                  moveLeft="3" moveRight="1" focusBorderColor="yellow"/>
    </descriptorBase>

    <!-- ============================================================= -->
    <!--  CONECTORES CAUSAIS                                           -->
    <!-- ============================================================= -->
    <connectorBase>

      <!-- onBegin -> inicia N nos -->
      <causalConnector id="onBeginStartN">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onBegin -> para N nos -->
      <causalConnector id="onBeginStopN">
        <simpleCondition role="onBegin"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> para N nos -->
      <causalConnector id="onEndStopN">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- onEnd -> atribui valor a uma propriedade -->
      <causalConnector id="onEndSet">
        <connectorParam name="val"/>
        <simpleCondition role="onEnd"/>
        <simpleAction role="set" value="$val"/>
      </causalConnector>

      <!-- onBegin (com atraso) -> anima uma propriedade em 'dur' -->
      <causalConnector id="onBeginSetAnim">
        <connectorParam name="val"/>
        <connectorParam name="delay"/>
        <connectorParam name="dur"/>
        <simpleCondition role="onBegin" delay="$delay"/>
        <simpleAction role="set" value="$val" duration="$dur"/>
      </causalConnector>

      <!-- onBegin + teste de propriedade -> inicia -->
      <causalConnector id="onBeginTestStart">
        <connectorParam name="expected"/>
        <compoundCondition operator="and">
          <simpleCondition role="onBegin"/>
          <assessmentStatement comparator="eq">
            <attributeAssessment role="test" eventType="attribution"
                                 attributeType="nodeProperty"/>
            <valueAssessment value="$expected"/>
          </assessmentStatement>
        </compoundCondition>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- tecla -> inicia N nos -->
      <causalConnector id="onKeyStartN">
        <connectorParam name="keyCode"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="start" max="unbounded" qualifier="par"/>
      </causalConnector>

      <!-- tecla -> atribui valor a uma propriedade -->
      <causalConnector id="onKeySet">
        <connectorParam name="keyCode"/>
        <connectorParam name="val"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <simpleAction role="set" value="$val"/>
      </causalConnector>

      <!-- tecla -> para (self), inicia (outro), atribui (estado)  [INFO] -->
      <causalConnector id="onKeyStopStartSet">
        <connectorParam name="keyCode"/>
        <connectorParam name="val"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="start"/>
          <simpleAction role="set" value="$val"/>
        </compoundAction>
      </causalConnector>

      <!-- tecla -> atribui + para N   [Chorinho: volume cheio + para alternativas] -->
      <causalConnector id="onKeySetStop">
        <connectorParam name="keyCode"/>
        <connectorParam name="val"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="par">
          <simpleAction role="set" value="$val"/>
          <simpleAction role="stop" max="unbounded" qualifier="par"/>
        </compoundAction>
      </causalConnector>

      <!-- tecla -> atribui + para N + inicia  [Rock/Techno/Cartoon] -->
      <causalConnector id="onKeySetStopStart">
        <connectorParam name="keyCode"/>
        <connectorParam name="val"/>
        <simpleCondition role="onSelection" key="$keyCode"/>
        <compoundAction operator="par">
          <simpleAction role="set" value="$val"/>
          <simpleAction role="stop" max="unbounded" qualifier="par"/>
          <simpleAction role="start"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>
  </head>

  <!-- =============================================================== -->
  <!--  CORPO                                                          -->
  <!-- =============================================================== -->
  <body>

    <!-- ponto de entrada: video principal -->
    <port id="pStart" component="mainVideo"/>

    <!-- variaveis globais / foco inicial -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
      <property name="interactive" value="true"/>
    </media>

    <!-- video principal (desenho do Garrincha) + linha do tempo -->
    <media id="mainVideo" src="animGar.mp4" descriptor="dVideo">
      <property name="width"  value="100%"/>
      <property name="height" value="88%"/>
      <area id="seg5"  begin="5s"/>
      <area id="seg12" begin="12s"/>
      <area id="seg41" begin="41s"/>
      <area id="seg45" begin="45s" end="51s"/>
      <area id="seg64" begin="64s"/>
    </media>

    <!-- fundo -->
    <media id="background" src="background.png" descriptor="dBackground"/>

    <!-- trilhas sonoras -->
    <media id="choro" src="choro.mp4" descriptor="dChoro">
      <property name="soundLevel" value="1"/>
    </media>
    <media id="rock"    src="rock.mp4"    descriptor="dRock"/>
    <media id="techno"  src="techno.mp4"  descriptor="dTechno"/>
    <media id="cartoon" src="cartoon.mp4" descriptor="dCartoon"/>

    <!-- botoes do menu -->
    <media id="btChorinho" src="chorinho.png" descriptor="dBtChorinho"/>
    <media id="btRock"     src="rock.png"     descriptor="dBtRock"/>
    <media id="btTechno"   src="techno.png"   descriptor="dBtTechno"/>
    <media id="btCartoon"  src="cartoon.png"  descriptor="dBtCartoon"/>

    <!-- sobreposicoes no quadradinho -->
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>
    <media id="photo"  src="photo.png"  descriptor="dPhoto">
      <property name="top" value="6.7%"/>
    </media>

    <!-- propaganda: icone + video do produto + formulario -->
    <media id="icon"  src="icon.png"  descriptor="dIcon"/>
    <media id="shoes" src="shoes.mp4" descriptor="dShoes"/>

    <switch id="formSwitch">
      <switchPort id="spForm">
        <mapping component="formPt"/>
        <mapping component="formEn"/>
      </switchPort>
      <defaultComponent component="formPt"/>
      <bindRule constituent="formEn" rule="rEn"/>
      <bindRule constituent="formPt" rule="rPt"/>
      <media id="formPt" src="ptForm.htm" descriptor="dForm"/>
      <media id="formEn" src="enForm.htm" descriptor="dForm"/>
    </switch>

    <!-- indicador de interatividade -->
    <media id="intOn"  src="intOn.png"  descriptor="dIntOn"/>
    <media id="intOff" src="intOff.png" descriptor="dIntOff"/>

    <!-- =========================================================== -->
    <!--  ELOS                                                       -->
    <!-- =========================================================== -->

    <!-- 0s: com o video, mostra o indicador LIGADO (estado ja e "true") -->
    <link id="lIntStart" xconnector="onBeginStartN">
      <bind role="onBegin" component="mainVideo"/>
      <bind role="start"   component="intOn"/>
    </link>

    <!-- +5s: entram fundo, menu (4 botoes) e a trilha padrao -->
    <link id="lMenuStart" xconnector="onBeginStartN">
      <bind role="onBegin" component="mainVideo" interface="seg5"/>
      <bind role="start"   component="background"/>
      <bind role="start"   component="btChorinho"/>
      <bind role="start"   component="btRock"/>
      <bind role="start"   component="btTechno"/>
      <bind role="start"   component="btCartoon"/>
      <bind role="start"   component="choro"/>
    </link>

    <!-- 12s: aparece o clipe de drible (fade-in 2s / wipe-out 1s) -->
    <link id="lDrible" xconnector="onBeginStartN">
      <bind role="onBegin" component="mainVideo" interface="seg12"/>
      <bind role="start"   component="drible"/>
    </link>

    <!-- 41s: aparece a foto por 5s -->
    <link id="lPhoto" xconnector="onBeginStartN">
      <bind role="onBegin" component="mainVideo" interface="seg41"/>
      <bind role="start"   component="photo"/>
    </link>

    <!-- foto desliza para baixo: 1s depois de aparecer, anima 'top' em 3s -->
    <link id="lPhotoAnim" xconnector="onBeginSetAnim">
      <bind role="onBegin" component="photo"/>
      <bind role="set"     component="photo" interface="top">
        <bindParam name="val"   value="80%"/>
        <bindParam name="delay" value="1s"/>
        <bindParam name="dur"   value="3s"/>
      </bind>
    </link>

    <!-- 45-51s: icone da propaganda, SO se a interatividade estiver LIGADA -->
    <link id="lIconShow" xconnector="onBeginTestStart">
      <bind role="onBegin" component="mainVideo" interface="seg45"/>
      <bind role="test"    component="settings"  interface="interactive">
        <bindParam name="expected" value="true"/>
      </bind>
      <bind role="start"   component="icon"/>
    </link>
    <link id="lIconHide" xconnector="onEndStopN">
      <bind role="onEnd" component="mainVideo" interface="seg45"/>
      <bind role="stop"  component="icon"/>
    </link>

    <!-- ~64s: encerra o menu e as trilhas (creditos) -->
    <link id="lMenuEnd" xconnector="onBeginStopN">
      <bind role="onBegin" component="mainVideo" interface="seg64"/>
      <bind role="stop"    component="btChorinho"/>
      <bind role="stop"    component="btRock"/>
      <bind role="stop"    component="btTechno"/>
      <bind role="stop"    component="btCartoon"/>
      <bind role="stop"    component="choro"/>
      <bind role="stop"    component="rock"/>
      <bind role="stop"    component="techno"/>
      <bind role="stop"    component="cartoon"/>
    </link>

    <!-- fim do video: encerra fundo e interatividade -->
    <link id="lAppEnd" xconnector="onEndStopN">
      <bind role="onEnd" component="mainVideo"/>
      <bind role="stop"  component="background"/>
      <bind role="stop"  component="intOn"/>
      <bind role="stop"  component="intOff"/>
    </link>

    <!-- INFO: alterna interatividade LIGADO -> DESLIGADO -->
    <link id="lInfoOff" xconnector="onKeyStopStartSet">
      <bind role="onSelection" component="intOn">
        <bindParam name="keyCode" value="INFO"/>
      </bind>
      <bind role="stop"  component="intOn"/>
      <bind role="start" component="intOff"/>
      <bind role="set"   component="settings" interface="interactive">
        <bindParam name="val" value="false"/>
      </bind>
    </link>

    <!-- INFO: alterna interatividade DESLIGADO -> LIGADO -->
    <link id="lInfoOn" xconnector="onKeyStopStartSet">
      <bind role="onSelection" component="intOff">
        <bindParam name="keyCode" value="INFO"/>
      </bind>
      <bind role="stop"  component="intOff"/>
      <bind role="start" component="intOn"/>
      <bind role="set"   component="settings" interface="interactive">
        <bindParam name="val" value="true"/>
      </bind>
    </link>

    <!-- OK em Chorinho: volume cheio na trilha padrao + para alternativas -->
    <link id="lSelChorinho" xconnector="onKeySetStop">
      <bind role="onSelection" component="btChorinho">
        <bindParam name="keyCode" value="ENTER"/>
      </bind>
      <bind role="set"  component="choro" interface="soundLevel">
        <bindParam name="val" value="1"/>
      </bind>
      <bind role="stop" component="rock"/>
      <bind role="stop" component="techno"/>
      <bind role="stop" component="cartoon"/>
    </link>

    <!-- OK em Rock: muta a padrao + para outras alternativas + toca rock -->
    <link id="lSelRock" xconnector="onKeySetStopStart">
      <bind role="onSelection" component="btRock">
        <bindParam name="keyCode" value="ENTER"/>
      </bind>
      <bind role="set"   component="choro" interface="soundLevel">
        <bindParam name="val" value="0"/>
      </bind>
      <bind role="stop"  component="techno"/>
      <bind role="stop"  component="cartoon"/>
      <bind role="start" component="rock"/>
    </link>

    <!-- OK em Techno -->
    <link id="lSelTechno" xconnector="onKeySetStopStart">
      <bind role="onSelection" component="btTechno">
        <bindParam name="keyCode" value="ENTER"/>
      </bind>
      <bind role="set"   component="choro" interface="soundLevel">
        <bindParam name="val" value="0"/>
      </bind>
      <bind role="stop"  component="rock"/>
      <bind role="stop"  component="cartoon"/>
      <bind role="start" component="techno"/>
    </link>

    <!-- OK em Cartoon -->
    <link id="lSelCartoon" xconnector="onKeySetStopStart">
      <bind role="onSelection" component="btCartoon">
        <bindParam name="keyCode" value="ENTER"/>
      </bind>
      <bind role="set"   component="choro" interface="soundLevel">
        <bindParam name="val" value="0"/>
      </bind>
      <bind role="stop"  component="rock"/>
      <bind role="stop"  component="techno"/>
      <bind role="start" component="cartoon"/>
    </link>

    <!-- RED (com o icone visivel): abre a propaganda -->
    <!--   toca o video da chuteira e o formulario (PT/EN)             -->
    <link id="lAdOpen" xconnector="onKeyStartN">
      <bind role="onSelection" component="icon">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="start" component="shoes"/>
      <bind role="start" component="formSwitch" interface="spForm"/>
    </link>
    <!--   video principal encolhe para PIP no topo-esquerdo           -->
    <link id="lAdPipW" xconnector="onKeySet">
      <bind role="onSelection" component="icon">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="set" component="mainVideo" interface="width">
        <bindParam name="val" value="45%"/>
      </bind>
    </link>
    <link id="lAdPipH" xconnector="onKeySet">
      <bind role="onSelection" component="icon">
        <bindParam name="keyCode" value="RED"/>
      </bind>
      <bind role="set" component="mainVideo" interface="height">
        <bindParam name="val" value="45%"/>
      </bind>
    </link>

    <!-- fim do formulario (~15s): restaura o video principal em tela cheia -->
    <link id="lAdCloseStop" xconnector="onEndStopN">
      <bind role="onEnd" component="formSwitch"/>
      <bind role="stop"  component="shoes"/>
    </link>
    <link id="lRestoreW" xconnector="onEndSet">
      <bind role="onEnd" component="formSwitch"/>
      <bind role="set"   component="mainVideo" interface="width">
        <bindParam name="val" value="100%"/>
      </bind>
    </link>
    <link id="lRestoreH" xconnector="onEndSet">
      <bind role="onEnd" component="formSwitch"/>
      <bind role="set"   component="mainVideo" interface="height">
        <bindParam name="val" value="88%"/>
      </bind>
    </link>

  </body>
</ncl>
