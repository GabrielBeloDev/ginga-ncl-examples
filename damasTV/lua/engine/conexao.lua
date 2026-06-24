require 'copas'

conexaoTcp = {}

conexaoTcp.Novo = function(this,HandlerData)
	local self = {}

	--trata o dado rececbido
	self.Tratador = HandlerData

	self.conexoesAtivas = {}

	--trata dos eventos tcp
	self.HandlerLuaTcp = function(evt)
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
				self.conexoesAtivas[evt.connection].data = evt.data
				self.Tratador('recebido',evt.connection)
			else
				self.Tratador('erro',evt.error)
			end
		end
	end

	--conecta a um servidor o objeto server tem o host e a porta
	self.ConectaLuaTcp = function(this,server)
		event.post {
			class = 'tcp',
			type  = 'connect',
			host  = server.host,
			port  = server.port,
		}

		event.register(3,self.HandlerLuaTcp)

	end

	self.Envia



	return self
end
