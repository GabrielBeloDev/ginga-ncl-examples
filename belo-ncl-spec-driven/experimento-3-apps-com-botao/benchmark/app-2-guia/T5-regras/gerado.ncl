<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="guia-vertical" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>

    <regionBase>
      <!-- Fundo em tela cheia -->
      <region id="rgFundo" left="0" top="0" width="100%" height="100%" zIndex="0"/>

      <!-- Lista vertical de 5 itens a esquerda -->
      <region id="rgItem1" left="5%" top="12%" width="38%" height="13%" zIndex="1"/>
      <region id="rgItem2" left="5%" top="27%" width="38%" height="13%" zIndex="1"/>
      <region id="rgItem3" left="5%" top="42%" width="38%" height="13%" zIndex="1"/>
      <region id="rgItem4" left="5%" top="57%" width="38%" height="13%" zIndex="1"/>
      <region id="rgItem5" left="5%" top="72%" width="38%" height="13%" zIndex="1"/>

      <!-- Tela cheia dos itens (reaproveitada pelas 5 telas) -->
      <region id="rgTela" left="0" top="0" width="100%" height="100%" zIndex="5"/>
    </regionBase>

    <descriptorBase>
      <descriptor id="descFundo" region="rgFundo"/>

      <!-- Botoes navegaveis: foco em amarelo e navegacao vertical circular -->
      <descriptor id="descItem1" region="rgItem1" focusIndex="1"
                  moveUp="5" moveDown="2"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descItem2" region="rgItem2" focusIndex="2"
                  moveUp="1" moveDown="3"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descItem3" region="rgItem3" focusIndex="3"
                  moveUp="2" moveDown="4"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descItem4" region="rgItem4" focusIndex="4"
                  moveUp="3" moveDown="5"
                  focusBorderColor="yellow" focusBorderWidth="4"/>
      <descriptor id="descItem5" region="rgItem5" focusIndex="5"
                  moveUp="4" moveDown="1"
                  focusBorderColor="yellow" focusBorderWidth="4"/>

      <descriptor id="descTela" region="rgTela"/>
    </descriptorBase>

    <connectorBase>
      <!-- OK: ao selecionar, inicia a tela cheia -->
      <causalConnector id="onSelectionStart">
        <simpleCondition role="onSelection"/>
        <simpleAction role="start"/>
      </causalConnector>

      <!-- Tecla VERMELHA: ao selecionar a tecla, para a tela cheia (volta) -->
      <causalConnector id="onKeySelectionStop">
        <connectorParam name="tecla"/>
        <simpleCondition role="onSelection" key="$tecla"/>
        <simpleAction role="stop"/>
      </causalConnector>
    </connectorBase>

  </head>

  <body>
    <!-- Foco inicial no primeiro item -->
    <port id="pSettings" component="settings"/>
    <!-- Componente de entrada -->
    <port id="entry" component="fundo"/>
    <!-- Itens que aparecem no inicio precisam de port -->
    <port id="pItem1" component="item-1"/>
    <port id="pItem2" component="item-2"/>
    <port id="pItem3" component="item-3"/>
    <port id="pItem4" component="item-4"/>
    <port id="pItem5" component="item-5"/>

    <media id="settings" type="application/x-ginga-settings">
      <property name="service.currentFocus" value="1"/>
    </media>

    <media id="fundo" src="fundo.png" descriptor="descFundo"/>

    <media id="item-1" src="item-1.png" descriptor="descItem1"/>
    <media id="item-2" src="item-2.png" descriptor="descItem2"/>
    <media id="item-3" src="item-3.png" descriptor="descItem3"/>
    <media id="item-4" src="item-4.png" descriptor="descItem4"/>
    <media id="item-5" src="item-5.png" descriptor="descItem5"/>

    <!-- Telas cheias: iniciam escondidas, sem port -->
    <media id="tela-1" src="tela-1.png" descriptor="descTela"/>
    <media id="tela-2" src="tela-2.png" descriptor="descTela"/>
    <media id="tela-3" src="tela-3.png" descriptor="descTela"/>
    <media id="tela-4" src="tela-4.png" descriptor="descTela"/>
    <media id="tela-5" src="tela-5.png" descriptor="descTela"/>

    <!-- OK abre a tela cheia do item selecionado -->
    <link xconnector="onSelectionStart">
      <bind role="onSelection" component="item-1"/>
      <bind role="start" component="tela-1"/>
    </link>
    <link xconnector="onSelectionStart">
      <bind role="onSelection" component="item-2"/>
      <bind role="start" component="tela-2"/>
    </link>
    <link xconnector="onSelectionStart">
      <bind role="onSelection" component="item-3"/>
      <bind role="start" component="tela-3"/>
    </link>
    <link xconnector="onSelectionStart">
      <bind role="onSelection" component="item-4"/>
      <bind role="start" component="tela-4"/>
    </link>
    <link xconnector="onSelectionStart">
      <bind role="onSelection" component="item-5"/>
      <bind role="start" component="tela-5"/>
    </link>

    <!-- VERMELHO volta (para a tela cheia) -->
    <link xconnector="onKeySelectionStop">
      <bind role="onSelection" component="tela-1">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-1"/>
    </link>
    <link xconnector="onKeySelectionStop">
      <bind role="onSelection" component="tela-2">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-2"/>
    </link>
    <link xconnector="onKeySelectionStop">
      <bind role="onSelection" component="tela-3">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-3"/>
    </link>
    <link xconnector="onKeySelectionStop">
      <bind role="onSelection" component="tela-4">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-4"/>
    </link>
    <link xconnector="onKeySelectionStop">
      <bind role="onSelection" component="tela-5">
        <bindParam name="tecla" value="RED"/>
      </bind>
      <bind role="stop" component="tela-5"/>
    </link>
  </body>
</ncl>
