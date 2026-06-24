<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="chat_tela" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<regionBase>
			<region id="rgVideoFullscreen" zIndex="1"/>
			<region id="rgLua" width="402" height="716" right="2%" bottom="2%" zIndex="10" />
		</regionBase>

		<descriptorBase>
			<descriptor id="dVideoFullscreen"  region="rgVideoFullscreen"/>
			<descriptor id="dLua" region="rgLua" focusIndex="1" focusBorderWidth="0" />
		</descriptorBase>
		
		<connectorBase>
			<causalConnector id="onEnd1StartN">
				<simpleCondition role="onEnd"/>
				<simpleAction role="start" max="unbounded" qualifier="par"/>
			</causalConnector>		
		</connectorBase>
		
	</head>
	
	<body>
		<port id="pVideoAbertura" component="videoAbertura"/>
		<port id="pLua" component="lua" />
		
		<media id="lua" src="main.lua" descriptor="dLua" />	
		<media id="videoAbertura" src="wannaworktogether.mpeg" descriptor="dVideoFullscreen" />
		
		<link id="lVideoLoop" xconnector="onEnd1StartN">
            <bind component="videoAbertura" role="onEnd"/>
            <bind component="videoAbertura" role="start" />
        </link>
        
	</body>
</ncl>
