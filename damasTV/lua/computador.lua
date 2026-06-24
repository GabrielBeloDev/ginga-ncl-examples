require 'constantes'

computador = {}

computador.Novo = function(this,movimentador)
	local self = {}

	self.mov = movimentador

	self.Jogar = function(this)
		local jogadasCampeas= {}
		for indice,peca in pairs(self.mov.tab.pecas) do
			if peca.viva then
				if peca.jogador == self.mov.tab.cursor.jogador then
					peca:MarcaJogada()
				elseif peca.sopravel then
					self.mov.tab.blocosJogadas[#self.mov.tab.blocosJogadas+1] = {x= peca.posicao.x,y=peca.posicao.y,noMove=true,sopra=indice}
				end
			end
		end
		for indice,bloco in pairs(self.mov.tab.blocosJogadas)do
			if #jogadasCampeas > 0 then
				jogadasCampeas = self:ComparaSuperioridade(jogadasCampeas,bloco)
			else
				jogadasCampeas[#jogadasCampeas+1] = bloco
			end
		end
		local jogada = jogadasCampeas[math.random(#jogadasCampeas)]
		jogasCampeas = ApagaTabela(jogasCampeas)
		self.mov:TrataBlocoJogada(jogada,true)
		while #self.mov.tab.blocosJogadas >0 do
			self.mov:FazJogada(self.mov.tab.blocosJogadas[math.random(#self.mov.tab.blocosJogadas)])
			principal.estadoAtual:TrocaJogador(true)
		end
		collectgarbage('collect')
	end

	self.ComparaSuperioridade = function(this,jogadas,bloco)
		local soma = false
		local recebe = false
		if jogadas[#jogadas].fazDama then
			if bloco.fazDama then
				soma = true
			end
		elseif bloco.fazDama then
			recebe = true
		elseif jogadas[#jogadas].come then
			if bloco.come then
				soma = true
			end
		elseif bloco.come then
			recebe = true
		elseif jogadas[#jogadas].sopra then
			if bloco.sopra then
				soma = true
			end
		elseif bloco.sopra then
			recebe = true
		elseif(not(bloco.noMove))then
			if(jogadas[#jogadas].noMove and not(jogadas[#jogadas].sopra))then
				recebe = true
			else
				soma = true
			end
		end
		if(soma)then
			jogadas[#jogadas+1] = bloco
		elseif(recebe)then
			jogadas= ApagaTabela(jogadas)
			jogadas = {bloco}
			collectgarbage('collect')
		end

		return jogadas
	end

	return self
end
