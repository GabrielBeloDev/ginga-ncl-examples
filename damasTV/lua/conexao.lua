require 'socket'
require 'copas'

conexao = {}

function conexao:Novo(dadosServidor)
	obj ={}
	setmetatable(obj,self)
	obj.dadosServidor =movimentador
	conexao.cliente = socket.udp()
	assert(conexao.cliente:setoption('broadcast',true))
	assert(conexao.cliente:setsockname('*',0))
	if(dadosServidor.addres)then
		conexao.cliente:setpeername(dadosServidor.addres,dadosServidor.port)
	end
	conexao.ocupado = false
	return obj
end

function conexao:Conecta()
	response = self.cliente:send('ip')
	print(response)
	if(response)then
		print('conectou'..self.cliente:getsockname())
		print('conecta'..self.cliente:getpeername())
		self.dadosServidor.addres = self.cliente:getpeername()
		self.cliente:close()
		self.cliente = socket.tcp()
		if(not(self.servidor))then
			self.Tratador = dadosServidor.Tratador
			local TratadorServidor = function(skt)
				print('entrou no handServer')
				skt = copas.wrap(skt)
				while(true)do
					local data = skt:receive('*l')
					print('recebeu data')
					self.Tratador(data)
				end
				self.ocupado = false
			end
			self.servidor = socket.bind("0.0.0.0", dadosServidor.port)
			copas.addserver(self.servidor, TratadorServidor)
		end
	end
end

function conexao.Enviar(data)
	self.cliente:send(data..'\n')
end

function conexao.Receber(this)
	return self.receive(conexao.cliente,'*l')
end

function conexao.IniciaServidor()
	self.Tratador = dadosServidor.Tratador
	local TratadorServidor = function(skt)
		print('entrou no handServer')
		skt = copas.wrap(skt)
		while(true)do
			local data = skt:receive('*l')
			print('recebeu data')
			if(not(self.dadosServidor.addres))then
				print(skt:getsockname())
				a()
			end
			self.Tratador(data)
		end
		self.ocupado = false
		print('saiu do hand')
	end
	self.servidor = socket.bind("0.0.0.0", dadosServidor.port)
	copas.addserver(self.servidor, TratadorServidor)
end

conexao.Espera = function(this)
	copas.step()
end

conexao.Disconect = function()
	if(conexao.servidor)then
		conexao.servidor:shutdown("both")
	elseif(conexao.cliente)then
		conexao.cliente:shutdown("both")
	end
end

