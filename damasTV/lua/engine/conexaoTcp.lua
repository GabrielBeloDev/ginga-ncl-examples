
conexaoTcp = {}

conexaoTcp.Novo = function(this,HandlerData)
	local self = {}

	--trata o dado rececbido
	self.Tratador = HandlerData

	self.espera = 100

	--trata dos eventos tcp
	self.Handler = function(evt)
		if evt.class ~= 'tcp' then return end
		if evt.type == 'connect' then
			if evt.error then
				self.Tratador('erro',evt.error)
			elseif evt.connection then
				self.Tratador('conectado',evt.connection)
			else
				self.Tratador('erro',nil)
			end
			return
		elseif evt.type == 'data' then
			if evt.error then
				self.Tratador('erro',evt.error)
			elseif evt.connection then
				self.conexaoAtiva = nil
				self.Tratador('recebido',evt.value)
				self:Disconecta()
			else
				self.Tratador('erro',nil)
			end
		elseif evt.type == 'disconnect'then
			self.Tratador('disconexao',nil)
			self.conexaoAtiva = nil
		end
	end

	--conecta a um servidor o objeto server tem o host e a porta
	self.Conecta = function(this,server)
		event.post {
			class = 'tcp',
			type  = 'connect',
			host  = server.host,
			port  = server.port,
			timeout = self.espera
		}
	end

	self.Disconecta = function(this)
		if(self.conexaoAtiva)then
			event.post {
					class = 'tcp',
					type  = 'disconnect',
					connection = evt.connection
				}
		end
	end

	event.register(3,self.Handler)

	self.Envia = function(this,data,id)
		if(not id)then
			id = self.conexaoAtiva
		end
		event.post {
			class      = 'tcp',
			type       = 'data',
			connection = id,
			value      = data
		}

	end

	self.Terminar = function(this)
		self:Disconecta()
		event.unregister(this.Handler)
	end



	return self
end
