require 'copas'

conexaoCopas = {}

conexaoCopas.Novo = function(this,HandlerData)

	local function echoHandler(skt)
	  skt = copas.wrap(skt)
	  while true do
		local data = skt:receive()
		data = HandlerData(data)
		if data.fim then
		  break
		else
			skt:send(data)
		end
	  end
	end

	local server = socket.bind("localhost", 20000)

	copas.addserver(server, echoHandler)

	copas.loop()

end
