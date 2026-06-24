require 'mensageiro'
conexaoIndireta = {}

conexaoIndireta.Novo = function(redeData,objetoJogo)
	local self = {}
	self.paginas = {}
	self.codJogo = redeData.codJogo
	self.codUsuario = redeData.codUsuario
	self.codAdversario = redeData.codAdver
	self.ultimoMov = nil
	self.intervalo = 1

	objetoJogo.Objs[1].cursor.jogador = 1
	objetoJogo.Objs[1].cursor.posicao.x,objetoJogo.Objs[1].cursor.posicao.y =3,3
	self.TrataResposta = function(responseData)
		self.intervalo = 1
		if(responseData.novoJogo)then
			self.codJogo = responseData.novoJogo
		end
		if(responseData.mov and TabelaParaString(responseData.mov) ~= self.ultimoMov)then
			self.ultimoMov = TabelaParaString(responseData.mov)
			objetoJogo.TrataEventoRede(responseData.mov)
		end
		if(responseData.code)then
			table.remove(self.paginas,#self.paginas)
		elseif(responseData.fim)then
			objetoJogo:Sair()
		end
	end
	self.mensageiro = mensageiro:Novo(self.TrataResposta)
	self.EnviarVitorioso = function(this,vitorioso,novo)
		if(objetoJogo.jogador == 1)then
			local pagina ='TerminaJogo.php?codGame='..self.codJogo..'&direct=0&codUser='..self.codUsuario..'&codAdver='..self.codAdversario
			if(tonumber(vitorioso))then
				pagina =pagina..'&vitorioso='..vitorioso
			end
			if(novo)then
				pagina = pagina..'&novoJogo=1'
			end
			table.insert(self.paginas,1,pagina)
		elseif(not(novo))then
			self:Enviar('{vitorioso='..vitorioso..'}&fim=1')
		end
	end

	self.Enviar = function(self,stringTabela)
		local page ='gameHTTP.php?codUser='..self.codUsuario..'&codGame='..self.codJogo
		if(type(stringTabela) == 'table')then
			table.insert(self.paginas,1,page..'&move='.. TabelaParaString(stringTabela))
		else
			table.insert(self.paginas,1,page..'&move='.. stringTabela)
		end
		self.mensageiro:EnviaPagina(self.paginas[#self.paginas]..'&cache='..math.random())
	end

	self.Vasculhar =function()
		self.intervalo = self.intervalo+1
		local page =''
		if(#self.paginas >0)then
			page = self.paginas[#self.paginas]
		else
			page ='gameHTTP.php?codUser='..self.codUsuario..'&codGame='..self.codJogo
		end
		self.mensageiro:EnviaPagina(page..'&cache='..math.random())
		event.timer(1000*self.intervalo,self.Vasculhar)
	end

	event.timer(0,self.Vasculhar)

	self.Terminar = function(self)
		event.unregister(self.Vasculhar)
		self.mensageiro:Terminar()
	end

	if(redeData.vez)then
		objetoJogo.jogador = 1
	else
		objetoJogo.jogador = 2
	end

	return self
end
