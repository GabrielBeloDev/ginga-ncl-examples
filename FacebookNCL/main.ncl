<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="main" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<regionBase>
			<region id="rgBackground" height="100%" width="100%"/>
			<region id="rgLogoFacebook" height="64" width="64" zIndex="1" right="2.5%" top="2.5%"/>
			<region id="rgMural" height="30%" width="95%" top="67.5%" left="2.5%">
				<region id="rgBtnEsq" height="32" width="32" top="35%" left="5"/>
				<region id="rgFeed" height="90%" width="90%" top="2.5%" left="35"/>
				<region id="rgBtnDir" height="32" width="32" top="35%" right="5"/>
			</region>
		</regionBase>
		<descriptorBase>
			<descriptor id="dsBackground" region="rgBackground"/>
			<descriptor id="dsLogoFacebook" region="rgLogoFacebook"/>
			<descriptor id="dsMural" region="rgMural"/>
			<descriptor id="dsFeed" region="rgFeed"/>
			<descriptor id="dsBtnEsq" region="rgBtnEsq"/>
			<descriptor id="dsBtnDir" region="rgBtnDir"/>
		</descriptorBase>
		<connectorBase>
			<importBase documentURI="ConnectorBase.ncl" alias="con"/>
		</connectorBase>
	</head>
	<body>
		
		<port id="porta" component="bg"/>
		
		<media id="bg" src="media/sao_luis.jpg" descriptor="dsBackground"/>
		<media id="logoFacebook" src="media/facebook.png" descriptor="dsLogoFacebook"/>		
		<media id="logoFacebookSair" src="media/facebook.png" descriptor="dsLogoFacebook"/>
		<media id="mural" src="media/mural_bg2.png" descriptor="dsMural"/>
		<media id="btnEsq" src="media/arrow_left.png" descriptor="dsBtnEsq"/>
		<media id="btnDir" src="media/arrow_right.png" descriptor="dsBtnDir"/>
		
		<media id="lua1" src="script1.lua" descriptor="dsFeed">
			<property name="inc"/>
			<property name="ignore"/>
		</media>
		
		
		<link xconnector="con#onBeginStartN">
			<bind role="onBegin" component="bg"/>
			<bind role="start" component="logoFacebook"/>
		</link>
		
		<link xconnector="con#onSelectionStartNStopN">
			<bind role="onSelection" component="logoFacebook">
				<bindParam name="key" value="RED"/>
			</bind>
			<bind role="stop" component="logoFacebook"/>
			<bind role="start" component="logoFacebookSair"/>
			<bind role="start" component="mural"/>
			<bind role="start" component="btnEsq"/>
			<bind role="start" component="btnDir"/>
			<bind role="start" component="lua1"/>
		</link>
		
		<link xconnector="con#onSelectionSet">
			<bind role="onSelection" component="logoFacebookSair">
				<bindParam name="key" value="RED"/>
			</bind>
			<bind role="set" component="lua1" interface="ignore">
				<bindParam name="var" value="false"/>
			</bind>
		</link>
			
	
		<link xconnector="con#onEndStop">
			<bind role="onEnd" component="mural"/>
			<bind role="stop" component="lua1"/>
		</link>
		
		<link xconnector="con#onSelectionSet">
			<bind role="onSelection" component="btnDir">
				<bindParam name="key" value="CURSOR_RIGHT"/>
			</bind>
			<bind role="set" component="lua1" interface="inc">
				<bindParam name="var" value="1"/>
			</bind>
		</link>
		
		<link xconnector="con#onSelectionSet">
			<bind role="onSelection" component="btnEsq">
				<bindParam name="key" value="CURSOR_LEFT"/>
			</bind>
			<bind role="set" component="lua1" interface="inc">
				<bindParam name="var" value="-1"/>
			</bind>
		</link>
	
	</body>
</ncl>
