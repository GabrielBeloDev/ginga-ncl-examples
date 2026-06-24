
conexaoTcp = {}

conexaoTcp.Novo = function(this,HandlerData)
	local self = {}

	--trata o dado rececbido
	self.Tratador = HandlerData

	obj.espera = HandlerData.espera

	self.conexoesAtivas = {}

	--trata dos eventos tcp
	self.Handler = function(evt)
		if evt.class ~= 'tcp' then return end

		if evt.type == 'connect' then
			if evt.connection then
				self.conexoesAtivas[evt.connection] = {host=evt.host,port=evt.pot}
				self.Tratador('conectado',evt.connection)
			else
				self.Tratador('erro',evt.error)
			end
			return
		end

		if evt.type == 'data' then
			if evt.connection then
				self.conexoesAtivas[evt.connection].data = evt.value
				self.Tratador('recebido',evt.connection)
			else
				self.Tratador('erro',evt.error)
			end
		end
	end

	--conecta a um servidor o objeto server tem o host e a porta
	self.Conecta = function(this,server)
		event.post {
			class = 'tcp',
			type  = 'connect',
			host  = server.host,
			port  = server.port
		}
	end

	event.register(3,self.Handler)

	self.Envia = function(this,data,id)
		if(not id)then
			id = next(self.conexoesAtivas)
		end
		event.post {
			class      = 'tcp',
			type       = 'data',
			connection = id,
			value      = data,
			timeout = self.espera
		}

	end

	self.Terminar = function(this)
		event.unregister(this.Handler)
	end



	return self
end
