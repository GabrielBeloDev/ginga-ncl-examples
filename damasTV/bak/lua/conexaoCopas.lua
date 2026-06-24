require 'copas'

conexaoCopas = {}

conexaoCopas.Novo = function(this,serverData)

	local echoHandler = function(skt)
	  skt = copas.wrap(skt)
	  while true do
		print('em copas')
		local data = skt:receive('*l')
		data = HandlerData(data)
		if(data)then
			skt:send(data..'\n')
		end
	  end
	end

	local server = socket.bind("0.0.0.0", serverData.port)

	copas.addserver(server, serverData.Handler)

	copas.loop()



end
