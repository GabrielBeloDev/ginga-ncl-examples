require 'constantes'

movimentador = {}

movimentador.Novo = function(this,tabuleiro)
	local self = {}

	self.pausavel = true

	self.tab = tabuleiro

	--define comportamento inicial

	self.MoveCima = function(this)
		if(self.tab.cursor.posicao.x > 0)then
			self.tab.cursor:Move(self.tab.cursor.posicao.x-1,self.tab.cursor.posicao.y)
		else
			self.tab.cursor:Move(7,self.tab.cursor.posicao.y)
		end
	end

	self.MoveBaixo = function(this)
		if(self.tab.cursor.posicao.x < 7)then
			self.tab.cursor:Move(self.tab.cursor.posicao.x+1,self.tab.cursor.posicao.y)
		else
			self.tab.cursor:Move(0,self.tab.cursor.posicao.y)
		end
	end

	self.MoveEsquerda = function(this)
		if(self.tab.cursor.posicao.y > 0)then
			self.tab.cursor:Move(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y-1)
		else
			self.tab.cursor:Move(self.tab.cursor.posicao.x,7)
		end
	end

	self.MoveDireita = function(this)
		if(self.tab.cursor.posicao.y < 7)then
			self.tab.cursor:Move(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y+1)
		else
			self.tab.cursor:Move(self.tab.cursor.posicao.x,0)
		end
	end

	self.Selecionado = function(this)
		local bloco = self.tab:TemJogada(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y)
		local peca = self.tab:TemPeca(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y)
		if(bloco)then
			self:TrataBlocoJogada(bloco)
		elseif(peca)then
			if(self.tab.pecas[peca].jogador == self.tab.cursor.jogador)then
				self.tab.blocosJogadas = {}
				self.tab.pecas[peca]:MarcaJogada()
			elseif(self.tab.pecas[peca].sopravel and self.tab.pecas[peca].viva)then
				self.tab.blocosJogadas = {}
				self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=self.tab.cursor.posicao.x,y=self.tab.cursor.posicao.y,noMove=true,sopra=peca}
			end
		end
	end

	self.TrataBlocoJogada = function(self,bloco,auxiliar)
		local troca = false
		local gravaJogada = not(auxiliar)
		if(bloco.noMove)then
			if(bloco.fazDama)then
				self:FazDama(self.tab.pecas[bloco.p])
				principal.estadoAtual.Objs[2]:RecebeMensagem(principal.estadoAtual.nomes[self.tab.cursor.jogador]..' fez Dama','black')
				troca = true
			elseif(bloco.sopra)then
				self:SopraPeca(self.tab.pecas[bloco.sopra])
				principal.estadoAtual.Objs[2]:RecebeMensagem(principal.estadoAtual.nomes[self.tab.cursor.jogador]..' soprou peca','black')
				troca = true
			else
				gravaJogada = false
			end
			self.tab.blocosJogadas = ApagaTabela(self.tab.blocosJogadas)
			self.tab.blocosJogadas = {}
		else
			self:LimpaSopraveis()
			self:FazJogada(bloco)
			if(#self.tab.blocosJogadas == 0)then
				troca = true
			end
		end

		if(gravaJogada)then
			self.ultimaJogada = bloco
		end
		if(troca)then
			principal.estadoAtual:TrocaJogador(auxiliar)
		end
	end

	self.FazDama = function(this,peca)
		self:MarcaSopraveis()
		event.post('out',{class='ncl',type= 'presentation',label='somEfectDama',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfectDama',action='start'})
		--self:LimpaSopraveis() #regra
		peca:Promover()
	end

	self.SopraPeca = function(this,peca)
		self:LimpaSopraveis()
		principal.estadoAtual.pontos[peca.jogador] = principal.estadoAtual.pontos[peca.jogador] -1
		event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='start'})
		peca.viva = false
	end

	self.FazJogada = function(this,bloco)
		if(bloco.come)then
			self.tab.pecas[bloco.come].viva = false
			principal.estadoAtual.pontos[self.tab.pecas[bloco.come].jogador] = principal.estadoAtual.pontos[self.tab.pecas[bloco.come].jogador] -1
			if(self.tab.pecas[bloco.p].tipo == 1)then
				event.post('out',{class='ncl',type= 'presentation',label='somEfectComeN',action='stop'})
				event.post('out',{class='ncl',type= 'presentation',label='somEfectComeN',action='start'})
			else
				event.post('out',{class='ncl',type= 'presentation',label='somEfectComeD',action='stop'})
				event.post('out',{class='ncl',type= 'presentation',label='somEfectComeD',action='start'})
			end
			self.tab.blocosJogadas = ApagaTabela(self.tab.blocosJogadas)
			self.tab.blocosJogadas = {}
			self.tab.pecas[bloco.p]:Move(bloco.x, bloco.y)
			self.tab.pecas[bloco.p]:MarcaJogada()
			local novosblocos = self.tab:TemCome()
			self.tab.blocosJogadas = novosblocos
			if(#novosblocos > 0)then
				self.tab.blocosJogadas[#self.tab.blocosJogadas+1] = {x=bloco.x,y=bloco.y,p=bloco.p}
			end
			principal.estadoAtual.Objs[2]:RecebeMensagem(principal.estadoAtual.nomes[self.tab.cursor.jogador]..' comeu uma peca','black')
			collectgarbage('collect')
		else
			if(self.tab.pecas[bloco.p].tipo == 1)then
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaN',action='stop'})
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaN',action='start'})
			else
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaD',action='stop'})
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaD',action='start'})
			end
			self.tab.blocosJogadas = ApagaTabela(self.tab.blocosJogadas)
			self.tab.blocosJogadas = {}
			collectgarbage('collect')
			self:MarcaSopraveis()
			self.tab.pecas[bloco.p]:Move(bloco.x, bloco.y)
		end
	end

	self.MarcaSopraveis = function(this)
		for indice,peca in pairs(self.tab.pecas)do
			if(peca.viva and peca.jogador == self.tab.cursor.jogador)then
				self.tab.blocosJogadas = ApagaTabela(self.tab.blocosJogadas)
				self.tab.blocosJogadas = {}
				peca:MarcaJogada()
				if(#self.tab:TemCome()>0)then
					peca.sopravel = true
				end
				collectgarbage('collect')
			end
		end
		self.tab.blocosJogadas = ApagaTabela(self.tab.blocosJogadas)
		self.tab.blocosJogadas = {}
		collectgarbage('collect')
	end

	self.LimpaSopraveis = function(this)
		for indice,peca in pairs(self.tab.pecas)do
			peca.sopravel = nil
		end
	end

	return self
end
