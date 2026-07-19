<?xml version="1.0" encoding="UTF-8"?>
<ncl id="gen" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <!-- ================= REGRAS (seleção de idioma do formulário) ================= -->
    <ruleBase>
      <rule id="rEng" var="system.language" comparator="eq" value="eng"/>
    </ruleBase>

    <!-- ================= TRANSIÇÕES ================= -->
    <transitionBase>
      <transition id="tFade" type="fade"    dur="2s"/>
      <transition id="tBar"  type="barWipe" dur="1s"/>
    </transitionBase>

    <!-- ================= REGIÕES (layout em % da tela; z do fundo pro topo) ================= -->
    <regionBase>
      <!-- camada 1: fundo -->
      <region id="rgBg"     left="0"      top="0"      width="100%"   height="100%"  zIndex="1"/>
      <!-- camada 2: tela principal -->
      <region id="rgMain"   left="0"      top="0"      width="100%"   height="100%"  zIndex="2"/>
      <!-- camada 3: janela canto superior-esquerdo -->
      <region id="rgWindow" left="5%"     top="6.7%"   width="18.5%"  height="18.5%" zIndex="3"/>
      <!-- camada 3: ícone canto superior-direito -->
      <region id="rgIcon"   left="87.5%"  top="11.7%"  width="8.45%"  height="6.7%"  zIndex="3"/>
      <!-- camada 3: área inferior-esquerda -->
      <region id="rgShoes"  left="15%"    top="60%"    width="25%"    height="25%"   zIndex="3"/>
      <!-- camada 3: painel direito / formulário -->
      <region id="rgForm"   left="57.25%" top="9.83%"  width="37.75%" height="70.2%" zIndex="3"/>
    </regionBase>

    <!-- ================= DESCRITORES ================= -->
    <descriptorBase>
      <descriptor id="dBg"     region="rgBg"/>
      <descriptor id="dMain"   region="rgMain"/>
      <!-- choro: só áudio, sem região na tela -->
      <descriptor id="dChoro"/>
      <!-- drible: fade na entrada, barWipe na saída -->
      <descriptor id="dDrible" region="rgWindow" transIn="tFade" transOut="tBar"/>
      <!-- photo: duração explícita de 5s -->
      <descriptor id="dPhoto"  region="rgWindow" explicitDur="5s"/>
      <!-- icon: duração explícita de 6s -->
      <descriptor id="dIcon"   region="rgIcon"   explicitDur="6s"/>
      <descriptor id="dShoes"  region="rgShoes"/>
      <!-- formulário: focável (focusIndex 1) e duração explícita de 15s -->
      <descriptor id="dForm"   region="rgForm"   focusIndex="1" explicitDur="15s"/>
    </descriptorBase>

    <!-- ================= CONECTORES CAUSAIS ================= -->
    <connectorBase>

      <!-- onBegin -> start -->
      <causalConnector id="onBeginStart">
        <simpleCondition role="onBegin"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- onBegin -> start (com atraso parametrizável) -->
      <causalConnector id="onBeginStartDelay">
        <connectorParam name="pDelay"/>
        <simpleCondition role="onBegin"/>
        <simpleAction role="start" delay="$pDelay"/>
      </causalConnector>

      <!-- onEnd -> stop -->
      <causalConnector id="onEndStop">
        <simpleCondition role="onEnd"/>
        <simpleAction role="stop"/>
      </causalConnector>

      <!-- onEnd -> set (redimensiona via propriedade) -->
      <causalConnector id="onEndSet">
        <connectorParam name="pValue"/>
        <simpleCondition role="onEnd"/>
        <simpleAction role="set" value="$pValue"/>
      </causalConnector>

      <!-- tecla: onSelection(key) -> seq( stop, set, start, start ) -->
      <causalConnector id="onKeyStopSetStartStart">
        <connectorParam name="pKey"/>
        <connectorParam name="pValue"/>
        <simpleCondition role="onSelection" key="$pKey"/>
        <compoundAction operator="seq">
          <simpleAction role="rStop"   eventType="presentation" actionType="stop"/>
          <simpleAction role="rSet"    eventType="attribution"  actionType="start" value="$pValue"/>
          <simpleAction role="rStartA" eventType="presentation" actionType="start"/>
          <simpleAction role="rStartB" eventType="presentation" actionType="start"/>
        </compoundAction>
      </causalConnector>

    </connectorBase>
  </head>

  <body>

    <!-- t = 0s: ponto de entrada inicia o vídeo principal em tela cheia -->
    <port id="pStart" component="animGar"/>

    <!-- ================= NÓS DE MÍDIA ================= -->
    <media id="bg"      src="background.png" descriptor="dBg"/>

    <media id="animGar" src="animGar.mp4" descriptor="dMain">
      <!-- propriedade usada para redimensionar a MESMA instância em execução -->
      <property name="bounds"/>
      <!-- âncoras/segmentos internos do próprio vídeo -->
      <area id="a12s" begin="12s"/>
      <area id="a41s" begin="41s"/>
      <area id="a45s" begin="45s" end="51s"/>
    </media>

    <media id="choro"  src="choro.mp4"  descriptor="dChoro"/>
    <media id="drible" src="drible.mp4" descriptor="dDrible"/>
    <media id="photo"  src="photo.png"  descriptor="dPhoto"/>
    <media id="icon"   src="icon.png"   descriptor="dIcon"/>
    <media id="shoes"  src="shoes.mp4"  descriptor="dShoes"/>

    <!-- formulário selecionado por idioma do sistema (padrão: ptForm).
         switchPort spEnd expõe o fim do componente selecionado p/ o elo de restauração -->
    <switch id="swForm">
      <switchPort id="spEnd">
        <mapping component="ptForm"/>
        <mapping component="enForm"/>
      </switchPort>
      <defaultComponent component="ptForm"/>
      <bindRule rule="rEng" constituent="enForm"/>
      <media id="enForm" src="enForm.htm" descriptor="dForm"/>
      <media id="ptForm" src="ptForm.htm" descriptor="dForm"/>
    </switch>

    <!-- ================= ELOS (LINKS) ================= -->

    <!-- t = 5s: delay de 5s do início do vídeo -> inicia fundo (paralelo) -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="pDelay" value="5s"/>
      <bind role="onBegin" component="animGar"/>
      <bind role="start"   component="bg"/>
    </link>

    <!-- t = 5s: delay de 5s do início do vídeo -> inicia áudio choro (paralelo) -->
    <link xconnector="onBeginStartDelay">
      <linkParam name="pDelay" value="5s"/>
      <bind role="onBegin" component="animGar"/>
      <bind role="start"   component="choro"/>
    </link>

    <!-- t = 12s: âncora do vídeo -> inicia drible (fade in / barWipe out) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a12s"/>
      <bind role="start"   component="drible"/>
    </link>

    <!-- t = 41s: âncora do vídeo -> inicia photo (dur 5s, mesma janela) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a41s"/>
      <bind role="start"   component="photo"/>
    </link>

    <!-- t = 45s..51s: âncora do vídeo -> inicia icon (dur 6s) -->
    <link xconnector="onBeginStart">
      <bind role="onBegin" component="animGar" interface="a45s"/>
      <bind role="start"   component="icon"/>
    </link>

    <!-- tecla VERMELHO enquanto icon é exibido:
         1) para o icon
         2) redimensiona a MESMA instância do vídeo principal p/ o canto sup-esq
         3) inicia em paralelo shoes (área inf-esq) e o formulário (dur 15s) -->
    <link xconnector="onKeyStopSetStartStart">
      <linkParam name="pKey"   value="RED"/>
      <linkParam name="pValue" value="5%,6.67%,45%,45%"/>
      <bind role="onSelection" component="icon"/>
      <bind role="rStop"       component="icon"/>
      <bind role="rSet"        component="animGar" interface="bounds"/>
      <bind role="rStartA"     component="shoes"/>
      <bind role="rStartB"     component="swForm"/>
    </link>

    <!-- ao fim do formulário (15s): restaura o vídeo principal p/ tela cheia -->
    <link xconnector="onEndSet">
      <linkParam name="pValue" value="0,0,222.22%,222.22%"/>
      <bind role="onEnd" component="swForm" interface="spEnd"/>
      <bind role="set"   component="animGar" interface="bounds"/>
    </link>

    <!-- encerramento: ao fim do vídeo principal, para fundo e áudio em paralelo -->
    <link xconnector="onEndStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop"  component="bg"/>
    </link>
    <link xconnector="onEndStop">
      <bind role="onEnd" component="animGar"/>
      <bind role="stop"  component="choro"/>
    </link>

  </body>
</ncl>
