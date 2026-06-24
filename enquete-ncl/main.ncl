<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Sistema de enquete para TV Digital.
Esta versão envio o voto a uma página PHP
e obtém um código lua como retorno, gerado
pelo PHP. O código lua é executado
e cria uma table contendo os dados da votação.
Com isto a aplicação NCLua pode acessar os dados
de forma estrutura e formatar sua exibição
da maneira que desejar.
@author Manoel Campos da Silva Filho
http://manoelcampos.com

@license Atribuição-Uso não-comercial-Compartilhamento pela mesma licença http://creativecommons.org/licenses/by-nc-sa/2.5/br/
-->
<ncl id="main" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<transitionBase>
			<transition id="tFade" type="fade" dur="0.7s" />			
		</transitionBase>
		
		  
		<regionBase>
			<region id="rgTela" width="640" height="480">
				<region id="rgVideo" width="100%" height="100%" zIndex="0" />  
				<region id="rgSim" width="89" height="59" top="88%" left="10" zIndex="1" />
				<region id="rgNao" width="89" height="58" top="88%" left="120" zIndex="1" />

				<region id="rgLua" width="100%" height="90" left="0" top="80%" zIndex="1" />
			</region>
		</regionBase>
		
		<descriptorBase>
			<descriptor id="dVideo" region="rgVideo" />  
			<descriptor id="dSim" region="rgSim" transIn="tFade" transOut="tFade" />
			<descriptor id="dNao" region="rgNao" transIn="tFade" transOut="tFade" />
			<descriptor id="dLua" region="rgLua" focusIndex="luaIdx">
				<descriptorParam name="transparency" value="100%"/>
			</descriptor>
		</descriptorBase>

		<connectorBase>
			<causalConnector id="onBeginStartN">
				<simpleCondition role="onBegin" />
				<simpleAction role="start" max="unbounded" qualifier="par" />
			</causalConnector>
				
			<causalConnector id="onBeginSet">
				<connectorParam name="var" />
				<simpleCondition role="onBegin" />
				<simpleAction role="set" value="$var" />	
			</causalConnector>
			
			<causalConnector id="onKeySelecionSetStop">
				<connectorParam name="keyCode"/>
				<connectorParam name="var"/>
				
				<simpleCondition role="onSelection" key="$keyCode"/>
				<compoundAction operator="seq">
				    <simpleAction role="set" value="$var" />				    	
				    <simpleAction role="stop" />
				</compoundAction>
			</causalConnector>
			
			<causalConnector id="onKeySelecionDelayedStop">
				<connectorParam name="keyCode"/>
				
				<simpleCondition role="onSelection" key="$keyCode"/>
				<simpleAction role="stop" delay="1s" />
			</causalConnector>
			
			<causalConnector id="onKeySelecionStop">
				<connectorParam name="keyCode"/>
				
				<simpleCondition role="onSelection" key="$keyCode"/>
				<simpleAction role="stop" />
			</causalConnector>									
			
			<causalConnector id="onEndAttributionDelayedStop">
				<simpleCondition role="onEndAttribution"/>
				<simpleAction role="stop" delay="10s"/>
			</causalConnector>
		</connectorBase>			
	</head>

	<body>
		<port id="pInicio" component="video"/>
		
		<media type="application/x-ginga-settings" id="programSettings">
	        <property name="service.currentKeyMaster" value="luaIdx"/>
		</media>
		
		<media id="sim" src="media/sim.png" descriptor="dSim" />
		<media id="nao" src="media/nao.png" descriptor="dNao" />
								
		<!--Script lua que faz acesso ao servidor web remoto-->
		<media id="lua" src="votacao.lua" descriptor="dLua">
			<!--Propriedade que é setada para "sim" quando o
			usuário pressiona a tecla verde (Sim) e para
			"nao" quando o usuário pressiona a tecla vermelha (Não).
			Quando esta propriedade é setada, o script lua
			captura este evento e envio o voto para o servidor
			web remoto.-->
			<property name="voto"/>
			
			<!--Propriedade que é setada pelo script lua, 
			para indicar ao NCL que o resultado 
			da votação foi exibido e assim, deve-se interromper
			o nó lua. A interrupção ocorre com delay.-->
			<property name="result"/>			
		</media>
		
		<!--http://creativecommons.org/videos/wanna-work-together-->
		<media id="video" src="media/Wanna_Work_Together_-_Creative_Commons.avi" descriptor="dVideo"/>
		
		<link xconnector="onBeginStartN">
			<bind component="video" role="onBegin" />
			<bind component="sim" role="start" />
			<bind component="nao" role="start" />
			<bind component="lua" role="start" />	
		</link>
		
		<!--Quando o usuário pressionar a tecla verde
		para votar em "Sim", a propriedade
		"voto" do nó lua é setada para "sim",
		e é dado um stop no botão "Não"-->
		<link xconnector="onKeySelecionSetStop">
			<bind component="sim" role="onSelection">
				<bindParam name="keyCode" value="GREEN"/>
			</bind>
			<bind component="lua" role="set" interface="voto">
				<bindParam name="var" value="sim"/>
			</bind>
			<bind component="nao" role="stop"/>			
		</link>

		<!--Quando o usuário pressionar a tecla verde
		para votar em "Sim" é dado um stop com delay no botão "Sim"-->		
		<link xconnector="onKeySelecionDelayedStop">
			<bind component="sim" role="onSelection">
				<bindParam name="keyCode" value="GREEN"/>
			</bind>
			<bind component="sim" role="stop" />
		</link>		
		
		<!--Quando o usuário pressionar a tecla vermelha
		para votar em "Não", a propriedade
		"voto" do nó lua é setada para "nao",
		e é dado um stop no botão "Sim"-->
		<link xconnector="onKeySelecionSetStop">
			<bind component="nao" role="onSelection">
				<bindParam name="keyCode" value="RED"/>
			</bind>
			<bind component="lua" role="set" interface="voto">
				<bindParam name="var" value="nao"/>
			</bind>
			<bind component="sim" role="stop" />
		</link>	
		
		<!--Quando o usuário pressionar a tecla vermelha
		para votar em "Não" é dado um stop com delay no botão "Não"-->		
		<link xconnector="onKeySelecionDelayedStop">
			<bind component="nao" role="onSelection">
				<bindParam name="keyCode" value="RED"/>
			</bind>
			<bind component="nao" role="stop" />
		</link>		
				
		<!--Depois que o resultado for exibido, 
		após 10 segundos, interrompe o nó lua. -->
		<link xconnector="onEndAttributionDelayedStop">
			<bind component="lua" role="onEndAttribution" interface="result" />
			<bind component="lua" role="stop" />
		</link>	
	</body>
</ncl>

