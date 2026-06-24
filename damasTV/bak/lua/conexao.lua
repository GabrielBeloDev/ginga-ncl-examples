require 'socket'
require 'copas'

conexao = {}

conexao.Novo = function(this,dadosServidor)
	self = {}

	self.dadosServidor = dadosServidor
	self.cliente = socket.udp()
	assert(self.cliente:setoption('broadcast',true))
	assert(self.cliente:setsockname('*',0))
	if(dadosServidor.addres)then
		self.cliente:setpeername(dadosServidor.addres,dadosServidor.port)
	end

	self.Conecta = function(this)
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
	self.Enviar = function(this,data)
		self.cliente:send(data..'\n')
	end

	self.Receber = function(this)
		return copas.receive(self.cliente,'*l')
	end

	self.IniciaServidor = function(this)
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

	self.ocupado = false

	self.Espera = function(this)
		print('espera')
		copas.step()
	end

	self.Disconect = function()
		if(self.servidor)then
			self.servidor:shutdown("both")
		elseif(self.cliente)then
			self.cliente:shutdown("both")
		end
	end

	return self
end
