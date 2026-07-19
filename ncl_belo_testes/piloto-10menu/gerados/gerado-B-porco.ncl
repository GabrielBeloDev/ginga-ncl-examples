<?xml version="1.0" encoding="UTF-8"?>
<!--
  ============================================================================
  Garrincha - Aplicacao Ginga-NCL (perfil EDTV / NCL 3.0)
  ============================================================================
  O que faz:
    * Toca o video do Garrincha (animGar.mp4) na janela superior esquerda,
      com uma musica de fundo (padrao: Chorinho).
    * Um clipe de drible (drible.mp4) roda em loop na janela inferior esquerda.
    * Um menu embaixo com 4 botoes troca a trilha sonora:
        Chorinho / Rock / Techno / Cartoon
      Navegue com as SETAS (esq/dir) e confirme com OK/ENTER.
    * Durante o video (a partir de 8s) aparece a propaganda da "Chuteira
      do Joao": o tenis (icon.png) + video (shoes.mp4) + indicador "i".
      Aperte SETA PARA CIMA para focar o tenis e OK para ABRIR o formulario
      (ptForm.htm) na janela da direita. Aperte a tecla VERMELHA para FECHAR.

  Comandos:
    Setas ESQ/DIR .... move o cursor entre os botoes de trilha
    OK / ENTER ....... seleciona a trilha (ou abre a propaganda)
    Seta CIMA ........ vai do menu para a propaganda (quando visivel)
    Tecla VERMELHA ... fecha o formulario
  ============================================================================
-->
<ncl id="garrincha" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ==================== REGIOES (layout em % de 800x600) ============= -->
    <regionBase>
      <region id="rgBg"     left="0"     top="0"    width="100%"  height="100%" zIndex="0"/>
      <region id="rgVideo"  left="4%"    top="7%"   width="45%"   height="48%"  zIndex="1"/>
      <region id="rgSmall"  left="14.7%" top="60.3%" width="25.6%" height="27.5%" zIndex="1"/>

      <!-- Area da direita: propaganda -> formulario -->
      <region id="rgAd"     left="58.5%" top="9%"   width="37.5%" height="34%"  zIndex="1"/>
      <region id="rgAdLogo" left="62%"   top="45%"  width="12%"   height="9%"   zIndex="2"/>
      <region id="rgInd"    left="90.5%" top="8.5%" width="6.5%"  height="8.3%" zIndex="3"/>
      <region id="rgForm"   left="57%"   top="7%"   width="39.5%" height="80%"  zIndex="5"/>

      <!-- Menu de trilhas (embaixo) -->
      <region id="rgBtn1"   left="3.7%"  top="90%"  width="15%"   height="8.3%" zIndex="1"/>
      <region id="rgBtn2"   left="29.6%" top="90%"  width="15%"   height="8.3%" zIndex="1"/>
      <region id="rgBtn3"   left="55.5%" top="90%"  width="15%"   height="8.3%" zIndex="1"/>
      <region id="rgBtn4"   left="81.4%" top="90%"  width="15%"   height="8.3%" zIndex="1"/>
    </regionBase>

    <!-- ==================== DESCRITORES ================================== -->
    <descriptorBase>
      <descriptor id="descBg"    region="rgBg"/>
      <descriptor id="descVideo" region="rgVideo"/>
      <descriptor id="descSmall" region="rgSmall"/>
      <descriptor id="descAd"    region="rgAd"/>
      <descriptor id="descInd"   region="rgInd"/>

      <!-- Musica de fundo: sem regiao = apenas audio -->
      <descriptor id="descMusic"/>

      <!-- Botoes do menu (navegaveis por foco) -->
      <descriptor id="descBtn1" region="rgBtn1" focusIndex="1"
                  moveRight="2" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descBtn2" region="rgBtn2" focusIndex="2"
                  moveLeft="1" moveRight="3" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descBtn3" region="rgBtn3" focusIndex="3"
                  moveLeft="2" moveRight="4" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descBtn4" region="rgBtn4" focusIndex="4"
                  moveLeft="3" moveUp="5" focusBorderColor="yellow" focusBorderWidth="4"/>

      <!-- Tenis clicavel (propaganda) e formulario -->
      <descriptor id="descAdLogo" region="rgAdLogo" focusIndex="5"
                  moveDown="1" focusBorderColor="red" focusBorderWidth="5"/>
      <descriptor id="descForm" region="rgForm" focusIndex="6"
                  focusBorderColor="green" focusBorderWidth="3"/>
    </descriptorBase>

    <!-- ==================== CONECTORES =================================== -->
    <connectorBase>
      <!-- propaganda surge: ao comecar a ancora, liga varias midias e -->
      <!-- desliga o indicador "off" -->
      <causalConnector id="cAdShow">
        <simpleCondition role="onBegin"/>
        <compoundAction operator="par">
          <simpleAction role="start" max="unbounded" qualifier="par"/>
          <simpleAction role="stop"  max="unbounded" qualifier="par"/>
        </compoundAction>
      </causalConnector>

      <!-- selecionar botao: liga uma trilha e para as outras -->
      <causalConnector id="cSwitchMusic">
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="stop" max="unbounded" qualifier="par"/>
        </compoundAction>
      </causalConnector>

      <!-- abrir formulario: liga form, desliga propaganda e move o foco -->
      <causalConnector id="cOpenForm">
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection"/>
        <compoundAction operator="par">
          <simpleAction role="start"/>
          <simpleAction role="stop" max="unbounded" qualifier="par"/>
          <simpleAction role="set" value="$foco"/>
        </compoundAction>
      </causalConnector>

      <!-- fechar formulario (tecla VERMELHA): para form, religa propaganda -->
      <causalConnector id="cCloseForm">
        <connectorParam name="foco"/>
        <simpleCondition role="onSelection" key="RED"/>
        <compoundAction operator="par">
          <simpleAction role="stop"/>
          <simpleAction role="start" max="unbounded" qualifier="par"/>
          <simpleAction role="set" value="$foco"/>
        </compoundAction>
      </causalConnector>

      <!-- loop: quando termina, comeca de novo -->
      <causalConnector id="cLoop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- fim do programa: para tudo que ainda toca -->
      <causalConnector id="cEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop" max="unbounded" qualifier="par"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>

    <!-- ==================== PONTOS DE ENTRADA (auto-start) =============== -->
    <port id="pBg"    component="mBg"/>
    <port id="pVideo" component="animGar"/>
    <port id="pSmall" component="drible"/>
    <port id="pMusic" component="mChoro"/>
    <port id="pInd"   component="intOff"/>
    <port id="pBtn1"  component="btnChorinho"/>
    <port id="pBtn2"  component="btnRock"/>
    <port id="pBtn3"  component="btnTechno"/>
    <port id="pBtn4"  component="btnCartoon"/>

    <!-- ==================== MIDIAS ======================================= -->
    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="mBg"     src="background.png" descriptor="descBg"/>

    <media id="animGar" src="animGar.mp4" descriptor="descVideo">
      <area id="aAd" begin="8s"/>       <!-- momento em que a propaganda entra -->
    </media>

    <media id="drible"  src="drible.mp4" descriptor="descSmall"/>

    <!-- Trilhas sonoras (audio de fundo) -->
    <media id="mChoro"   src="choro.mp4"   descriptor="descMusic"/>
    <media id="mRock"    src="rock.mp4"    descriptor="descMusic"/>
    <media id="mTechno"  src="techno.mp4"  descriptor="descMusic"/>
    <media id="mCartoon" src="cartoon.mp4" descriptor="descMusic"/>

    <!-- Botoes do menu -->
    <media id="btnChorinho" src="chorinho.png" descriptor="descBtn1"/>
    <media id="btnRock"     src="rock.png"     descriptor="descBtn2"/>
    <media id="btnTechno"   src="techno.png"   descriptor="descBtn3"/>
    <media id="btnCartoon"  src="cartoon.png"  descriptor="descBtn4"/>

    <!-- Propaganda da Chuteira do Joao -->
    <media id="shoesAd" src="shoes.mp4" descriptor="descAd"/>
    <media id="adLogo"  src="icon.png"  descriptor="descAdLogo"/>
    <media id="intOn"   src="intOn.png"  descriptor="descInd"/>
    <media id="intOff"  src="intOff.png" descriptor="descInd"/>

    <!-- Formulario de compra (HTML) -->
    <media id="form" src="ptForm.htm" descriptor="descForm"/>

    <!-- ==================== ELOS (links) ================================ -->

    <!-- Propaganda aparece aos 8s: liga tenis+video+indicador "i",
         desliga o indicador "off" -->
    <link xconnector="cAdShow">
      <bind role="onBegin" component="animGar" interface="aAd"/>
      <bind role="start" component="shoesAd"/>
      <bind role="start" component="adLogo"/>
      <bind role="start" component="intOn"/>
      <bind role="stop"  component="intOff"/>
    </link>

    <!-- Menu: trocar trilha sonora -->
    <link xconnector="cSwitchMusic">
      <bind role="onSelection" component="btnChorinho"/>
      <bind role="start" component="mChoro"/>
      <bind role="stop"  component="mRock"/>
      <bind role="stop"  component="mTechno"/>
      <bind role="stop"  component="mCartoon"/>
    </link>
    <link xconnector="cSwitchMusic">
      <bind role="onSelection" component="btnRock"/>
      <bind role="start" component="mRock"/>
      <bind role="stop"  component="mChoro"/>
      <bind role="stop"  component="mTechno"/>
      <bind role="stop"  component="mCartoon"/>
    </link>
    <link xconnector="cSwitchMusic">
      <bind role="onSelection" component="btnTechno"/>
      <bind role="start" component="mTechno"/>
      <bind role="stop"  component="mChoro"/>
      <bind role="stop"  component="mRock"/>
      <bind role="stop"  component="mCartoon"/>
    </link>
    <link xconnector="cSwitchMusic">
      <bind role="onSelection" component="btnCartoon"/>
      <bind role="start" component="mCartoon"/>
      <bind role="stop"  component="mChoro"/>
      <bind role="stop"  component="mRock"/>
      <bind role="stop"  component="mTechno"/>
    </link>

    <!-- Abrir o formulario ao selecionar o tenis (foco 5 -> foco no form 6) -->
    <link xconnector="cOpenForm">
      <bind role="onSelection" component="adLogo"/>
      <bind role="start" component="form"/>
      <bind role="stop"  component="shoesAd"/>
      <bind role="stop"  component="adLogo"/>
      <bind role="stop"  component="intOn"/>
      <bind role="set"   component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="6"/>
      </bind>
    </link>

    <!-- Fechar o formulario com a tecla VERMELHA (volta o foco para o tenis) -->
    <link xconnector="cCloseForm">
      <bind role="onSelection" component="form"/>
      <bind role="stop"  component="form"/>
      <bind role="start" component="shoesAd"/>
      <bind role="start" component="adLogo"/>
      <bind role="start" component="intOn"/>
      <bind role="set"   component="settings" interface="service.currentFocus">
        <bindParam name="foco" value="5"/>
      </bind>
    </link>

    <!-- Loops dos clipes -->
    <link xconnector="cLoop">
      <bind role="onEnd" component="drible"/>
      <bind role="start" component="drible"/>
    </link>
    <link xconnector="cLoop">
      <bind role="onEnd" component="shoesAd"/>
      <bind role="start" component="shoesAd"/>
    </link>

    <!-- Fim do video principal: para musica, clipes e propaganda -->
    <link xconnector="cEndStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop" component="mChoro"/>
      <bind role="stop" component="mRock"/>
      <bind role="stop" component="mTechno"/>
      <bind role="stop" component="mCartoon"/>
      <bind role="stop" component="drible"/>
      <bind role="stop" component="shoesAd"/>
      <bind role="stop" component="adLogo"/>
      <bind role="stop" component="intOn"/>
    </link>

  </body>
</ncl>
