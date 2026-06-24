require 'socket'
require 'copas'

conexaoCliente = {}

function conexaoCliente:Novo(addres,port)
	local obj ={}
	setmetatable(obj,self)
	conexaoCliente.client:connect(addres,port)
	return obj
end

conexaoCliente.client = socket.tcp()


function conexaoCliente:Enviar(data)
	self.client:send(data..'\n')
end

function conexaoCliente:Receber()
	self.receive(conexaoCliente.client,'*l')
end
