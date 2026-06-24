<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
2008 PUC-RIO/LABORATORIO TELEMIDIA,
Some Rights Reserved.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License version 2 as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License version 2 for more
details.

You should have received a copy of the GNU General Public License version 2
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
-->

<ncl id="Damas" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">

<head>

	<regionBase>
		<region id="tv" width="100%" height="100%">
		</region>
	</regionBase>



	<descriptorBase>
		<descriptor id="priDesc" region="tv" />
		<descriptor id="luaDesc" region="tv" focusIndex="1"/>
		<descriptor id="musicaFundoDesc" >
			<descriptorParam name="soundLevel" value="0.1" />
		</descriptor>
		<descriptor id="efeitoDesc" >
					<descriptorParam name="soundLevel" value="1" />
		</descriptor>
	</descriptorBase>


	<ruleBase>
		<rule id="somMenu" var="efeito" comparator="eq" value="mSom" />
		<rule id="somSelecao" var="efeito" comparator="eq" value="seleSom" />
		<rule id="somComeN" var="efeito" comparator="eq" value="cnSom" />
		<rule id="somAndaN" var="efeito" comparator="eq" value="anSom" />
		<rule id="somComeD" var="efeito" comparator="eq" value="cdSom" />
		<rule id="somAndaD" var="efeito" comparator="eq" value="adSom" />
		<rule id="somDama" var="efeito" comparator="eq" value="dSom" />
		<rule id="somSopra" var="efeito" comparator="eq" value="sSom" />
		<rule id="somVence" var="efeito" comparator="eq" value="vSom" />
	</ruleBase>

	<connectorBase>
		<causalConnector id="onBeginSetabortStart">
			<connectorParam name="var" />
			<simpleCondition role="onBegin" />
			<compoundAction operator="seq">
				<simpleAction role="abort" max="unbounded" qualifier="par" />
				<simpleAction role="set" value="$var" max="unbounded" qualifier="par" />
				<simpleAction role="start" max="unbounded" qualifier="par" />
			</compoundAction>
		</causalConnector>

		<causalConnector id="onBeginStart">
			<simpleCondition role="onBegin"/>
			<simpleAction role="start" max="unbounded" qualifier="par"/>
		</causalConnector>

		<causalConnector id="onBeginStop">
			<simpleCondition role="onBegin"/>
			<simpleAction role="stop"/>
		</causalConnector>

		<causalConnector id="onEndStartn">
			<simpleCondition role="onEnd"/>
			<simpleAction role="start" max="unbounded" qualifier="par"/>
		</causalConnector>

		<causalConnector id="onEndAbort">
			<simpleCondition role="onEnd"/>
			<simpleAction role="abort" max="unbounded" qualifier="par"/>
		</causalConnector>

	</connectorBase>
</head>

<body>

<!-- midias  -->
	<port id="int" component="videoInicial"/>

	<media type="application/x-ginga-settings" id="programSettings1">
		<property name="service.currentKeyMaster" value="1"/>
	</media>

	<media type="application/x-ginga-settings" id="nodeSettings">
		<property name="efeito"/>
	</media>

	<media type="application/x-ginga-settings" id="programSettings2">
		<property name="service.currentFocus" value="1" />
	</media>

	<media id="videoInicial" src="inicio.mp4" descriptor="priDesc" />
	<media id="musicaFundo" type="audio/mp3"  src="audios/musicaT.mp3" descriptor="musicaFundoDesc" />
	<switch id="efeitoSonoro">
		<bindRule rule="somMenu" constituent="efeitoMenu" />
		<media id="efeitoMenu" type="audio/basic" src="sounds/mudaMenu.wav" descriptor="efeitoDesc"/>

		<bindRule rule="somSelecao" constituent="efeitoSeleciona" />
		<media id="efeitoSeleciona" type="audio/mp3" src="sounds/set.mp3" descriptor="efeitoDesc"/>

		<bindRule rule="somComeN" constituent="efeitoComeN" />
		<media id="efeitoComeN" type="audio/basic" src="sounds/thog.wav" descriptor="efeitoDesc"/>

		<bindRule rule="somAndaN" constituent="efeitoAndaN" />
		<media id="efeitoAndaN" type="audio/basic" src="sounds/tapMove.wav" descriptor="efeitoDesc"/>

		<bindRule rule="somComeD" constituent="efeitoComeD" />
		<media id="efeitoComeD" type="audio/mp3" src="sounds/tloong.mp3" descriptor="efeitoDesc"/>

		<bindRule rule="somAndaD" constituent="efeitoAndaD" />
		<media id="efeitoAndaD" type="audio/mp3" src="sounds/slide.mp3" descriptor="efeitoDesc"/>

		<bindRule rule="somDama" constituent="efeitoCome" />
		<media id="efeitoCome" type="audio/mp3" src="sounds/metalicMove2.mp3" descriptor="efeitoDesc"/>

		<bindRule rule="somSopra" constituent="efeitoSopra" />
		<media id="efeitoSopra" type="audio/mp3" src="sounds/piu.mp3" descriptor="efeitoDesc"/>

		<bindRule rule="somVence" constituent="efeitovence" />
		<media id="efeitovence" type="audio/basic" src="sounds/victory.wav" descriptor="efeitoDesc"/>
	</switch>


	<media id="lua" type="application/x-ginga-NCLua" src="lua/principal.lua" descriptor="luaDesc">
		<property name="service.currentKeyMaster" value="1"/>
		<area id="somEfectSeleciona" />
		<area id="somEfectMenu" />
		<area id="somEfectComeN" />
		<area id="somEfectComeD" />
		<area id="somEfectAndaN" />
		<area id="somEfectAndaD" />
		<area id="somEfectDama" />
		<area id="somEfectSopra" />
		<area id="somEfectVence" />
		<area id="somEfeitoPausa" />
		<area id="musica" />
		<area id="jogoFim" />
	</media>




<!-- elos  -->
	<!-- iniciais -->

	<link id="videoTerminado" xconnector="onEndStartn">
		<bind component="videoInicial" role="onEnd" />
		<bind component="lua" role="start" />
	</link>


<!-- de execu�ao-->

<!-- Sons-efeitos -->
	<link id="LancaEfectSeleciona" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectSeleciona" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="seleSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectMenu" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectMenu" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="mSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectComeN" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectComeN" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="cnSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectComeD" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectComeD" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="cdSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectAndaN" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectAndaN" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="anSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectAndaD" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectAndaD" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="adSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectDama" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectDama" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="dSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectSopra" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectSopra" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="sSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>

	<link id="LancaEfectVence" xconnector="onBeginSetabortStart">
		<bind component="lua" role="onBegin" interface="somEfectVence" />
		<bind component="efeitoSonoro" role="abort" />
		<bind component="nodeSettings" interface="efeito" role="set">
			<bindParam name="var" value="vSom"/>
		</bind>
		<bind component="efeitoSonoro" role="start" />
	</link>
<!-- fim dos sons de efeito -->


	<link id="paraMusica" xconnector="onEndAbort">
		<bind component="lua" role="onEnd" interface="musica" />
		<bind component="musicaFundo" role="abort" />
	</link>

	<link id="paraJogo" xconnector="onBeginStop">
		<bind component="lua" role="onBegin" interface="jogoFim" />
		<bind component="lua" role="stop" />
		<bind component="musicaFundo" role="stop" />
		<bind component="efeitoSonoro" role="stop" />
	</link>

	<link id="voltaMusica" xconnector="onBeginStart">
		<bind component="lua" role="onBegin" interface="musica" />
		<bind component="musicaFundo" role="start" />
	</link>
	<link id="repeater" xconnector="onEndStartn">
		<bind component="musicaFundo" role="onEnd" />
		<bind component="musicaFundo" role="start" />
	</link>

</body>




</ncl>
