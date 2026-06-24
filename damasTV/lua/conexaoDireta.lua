require "socket"
conexaoDireta = {}

conexaoDireta.Novo = function(redeData,objetoJogo)
	local self = {}
	self.mestreDeConexao =socket.tcp()
	self.mestreDeConexao:settimeout(-1)
	objetoJogo.Objs[1].cursor.jogador = 1
	objetoJogo.Objs[1].cursor.posicao.x,objetoJogo.Objs[1].cursor.posicao.y =3,3
	if(redeData.codJogo)then
		self.codJogo = redeData.codJogo
		self.codUsuario = redeData.codUsuario
		self.codAdversario = redeData.codAdver

		self.EnviarVitorioso = function(this,vitorioso,novo)
			require 'mensageiro'
			local fimDeJogo = function(responseData)
				if(responseData.novoJogo)then
					self.codJogo = responseData.novoJogo
				elseif(responseData.fim)then
					self:Enviar('&')
				end
			end
			self.mensageiroTcp = mensageiro:Novo(fimDeJogo)
			local pagina ='TerminaJogo.php?codGame='..self.codJogo..'&direct=1&codUser='..self.codUsuario..'&codAdver='..self.codAdversario..'&vitorioso='..vitorioso
			if(novo)then
				pagina = pagina..'&novoJogo=1'
			else
				self:Enviar('&')
			end
			self.mensageiroTcp:EnviaPagina(pagina)
		end

		self.mestreDeConexao:bind('*', redeData.port)
		self.mestreDeConexao:listen(1)
		self.cliente = self.mestreDeConexao:accept()
		objetoJogo.jogador = 2
	else
		self.mestreDeConexao:connect(redeData.ip,redeData.port)
		self.cliente = self.mestreDeConexao
		local funcaoQueiroz = function()end
		self.EnviarVitorioso = funcaoQueiroz
		self.NovoJogo = funcaoQueiroz
		self.cliente = self.mestreDeConexao
		objetoJogo.jogador = 1
	end

	self.cliente:setoption('keepalive',true)

	self.Receber = function()
		self.cliente:settimeout(0)
		local stringRecebida,msg = self.cliente:receive('*l')
		if(stringRecebida)then
			objetoJogo.TrataEventoRede(assert(loadstring(stringRecebida))())
		end
		if(msg == 'closed')then
			objetoJogo:Sair('Adversario caiu')
		else
			event.timer(1000,self.Receber)
		end
	end

	event.timer(1000,self.Receber)

	self.Enviar = function(self,stringTabela)
		self.cliente:settimeout(2000)
		local stringEnvio = 'return '
		if(type(stringTabela)== 'table')then
			stringEnvio = stringEnvio ..TabelaParaString(stringTabela)
		elseif(stringTabela:find('&'))then
			stringEnvio ='return {sair=true}'
		else
			stringEnvio =stringEnvio ..stringTabela
		end
		self.cliente:send(stringEnvio..'\n')
	end

	self.Terminar = function(self)
		if(self.mensageiroTcp)then
			self.mensageiroTcp:Terminar()
		end
		self.cliente:shutdown('both')
		self.cliente:close()
		self.mestreDeConexao:close()
	end

	return self
end
