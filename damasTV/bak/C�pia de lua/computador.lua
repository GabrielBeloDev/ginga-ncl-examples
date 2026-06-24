require 'constantes'

computador = {}

computador.Novo = function(this,movimentador)
	local self = {}

	self.mov = movimentador

	self.Jogar = function(this)
		local jogadasCampeas= {}
		self.mov:TrocaJogador()
		for indice,peca in pairs(self.mov.tab.pecas) do
			if peca.viva then
				if peca.jogador == self.mov.tab.cursor.jogador then
					self.mov.MarcaJogada[peca.tipo](self.mov,peca.posicao.x,peca.posicao.y,indice)
				elseif peca.sopravel then
					self.mov.tab.blocosJogadas[#self.mov.tab.blocosJogadas+1] ={x=self.mov.tab.cursor.posicao.x,y=self.mov.tab.cursor.posicao.y,nomove=true,sopra=indice}
				end
			end
		end
		for indice,bloco in pairs(self.mov.tab.blocosJogadas)do
			if #jogadasCampeas > 0 then
				self:ComparaSuperioridade(jogadasCampeas,indice)
			else
				jogadasCampeas[#jogadasCampeas+1] = indice
			end
		end

		if(self.mov.tab.blocosJogadas[jogadasCampeas[#jogadasCampeas]].fazdama)then
			self.mov:FazDama(self.mov.tab.blocosJogadas[jogadasCampeas[#jogadasCampeas]].p)
		elseif(self.mov.tab.blocosJogadas[jogadasCampeas[#jogadasCampeas]].sopra) then
			self.mov:SopraPeca(self.mov.tab.blocosJogadas[jogadasCampeas[#jogadasCampeas]].sopra)
		else
			if(self.mov.tab.blocosJogadas[jogadasCampeas[#jogadasCampeas]].nomove)then
				self.mov:FazFim()
			end
			self.mov:FazJogada(jogadasCampeas[#jogadasCampeas])
			while #self.mov.tab.blocosJogadas >0 do
				self.mov:FazJogada(#self.mov.tab.blocosJogadas)
			end
		end
		self.mov.tab.blocosJogadas = {}
		self.mov:TrocaJogador()
	end

	self.ComparaSuperioridade = function(this,jogadas,bloco)
		if self.mov.tab.blocosJogadas[jogadas[#jogadas]].fazdama then
			--print('temDama')
			return
		elseif self.mov.tab.blocosJogadas[bloco].fazdama then
			--print('adiquiri dama')
			jogadas[#jogadas+1] = bloco
			return
		elseif self.mov.tab.blocosJogadas[jogadas[#jogadas]].come then
			return
		elseif self.mov.tab.blocosJogadas[bloco].come then
			--print('adiquiri come')
			jogadas[#jogadas+1] = bloco
			return
		elseif self.mov.tab.blocosJogadas[jogadas[#jogadas]].sopra then
			return
		elseif self.mov.tab.blocosJogadas[bloco].sopra then
			--print('adiquiri sopra')
			jogadas[#jogadas+1] = bloco
			return
		elseif self.mov.tab.blocosJogadas[jogadas[#jogadas]].noMove and not self.mov.tab.blocosJogadas[bloco].noMove then
			--print('adiquiri nada')
			jogadas[#jogadas+1] = bloco
			return
		end
	end

	return self
end
