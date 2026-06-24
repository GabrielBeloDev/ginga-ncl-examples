require 'socket'
require 'copas'

conexaoCliente = {}

conexaoCliente.Novo = function(this,server)
	self = {}

	self.client = socket.tcp()

	self.client:connect(server.addres,server.port)

	self.Enviar = function(this,data)
		self.client:send(data..'\n')
	end

	self.Receber = function(this)
		return copas.receive(self.client,'*l')
	end

	return self
end
