require 'constantes'
--talvez seja melhor quebrar esse objeto em vários

movimentador = {}

movimentador.Novo = function(this,tabela)
	local self = {}

	self.vitorias = {0,0}

	self.tab = tabela

	self.nomes = {'Jogador 1','Jogador 2'}

	--define comportamento inicial
	self.Inicio = function(this)
		self.tab:Inicio()

		self.Desenhar = function(this)
			canvas:attrColor (COR1)
			canvas:attrFont ('vera', 24)
			canvas:drawText(5,15,self.nomes[1] .. string.rep ('*',self.vitorias[1]))
			canvas:drawText(20,40,(12 - self.pontos[2]) .. ' pontos')
			canvas:attrColor (COR2)
			canvas:drawText(5,75,self.nomes[2] .. string.rep ('*',self.vitorias[2]))
			canvas:drawText(20,105,(12 - self.pontos[1]) .. ' pontos')
		end

		self.pontos ={12,12}

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

		self.Botao = function(this)
			self:Pausa()
		end

		self.Selecionado = function(this)
			local troca = false
			local bloco = self.tab:TemJogada(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y)
			local peca = self.tab:TemPeca(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y)
			if(bloco)then
				if(self.tab.blocosJogadas[bloco].noMove)then
					if(self.tab.blocosJogadas[bloco].fazDama)then
						self:FazDama(self.tab.blocosJogadas[bloco].p)
						troca = true
					elseif(self.tab.blocosJogadas[bloco].sopra)then
						self:SopraPeca(self.tab.blocosJogadas[bloco].sopra)
						troca = true
					end
					self.tab.blocosJogadas = {}
				else
					self:LimpaSopraveis()
					self:FazJogada(bloco)
					if(#self.tab.blocosJogadas == 0)then
						troca = true
					end
				end
			elseif(peca)then
				if(peca.jogador == self.tab.cursor.jogador)then
					self.tab.blocosJogadas = {}
					peca:MarcaJogada()
				elseif(peca.sopravel and peca.viva)then
					self.tab.blocosJogadas = {}
					self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=self.tab.cursor.posicao.x,y=self.tab.cursor.posicao.y,noMove=true,sopra=peca}
				end
			end

			if(troca)then
				if(self.pontos[1] == 0 or self.pontos[2] == 0) then
					self:FazFim()
				else
					if self.computador then
						self.computador:Jogar()
					elseif self.jogadorOnline then
						self.jogadorOnline.Jogar()
					else
						self:TrocaJogador()
					end
				end
			end
		end
	end

	self:Inicio()

	self.FazDama = function(this,peca)
		self:MarcaSopraveis()
		event.post('out',{class='ncl',type= 'presentation',label='somEfectDama',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfectDama',action='start'})
		--self:LimpaSopraveis() #regra
		peca:Promover()
	end

	self.SopraPeca = function(this,peca)
		self:LimpaSopraveis()
		self.pontos[peca.jogador] = self.pontos[peca.jogador] -1
		event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='start'})
		peca.viva = false
	end

	self.FazJogada = function(this,bloco)
		self.ultimaJogada = bloco
		local jogada = self.tab.blocosJogadas[bloco]
		if(self.tab.blocosJogadas[bloco].come)then
			while(bloco >0)do
				if(self.tab.blocosJogadas[bloco].come)then
					self.tab.blocosJogadas[bloco].come.viva = false
					self.pontos[self.tab.blocosJogadas[bloco].come.jogador] = self.pontos[self.tab.blocosJogadas[bloco].come.jogador] -1
					if(jogada.p.tipo == 1)then
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeN',action='stop'})
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeN',action='start'})
					else
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeD',action='stop'})
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeD',action='start'})
					end
				end
				bloco = bloco -1
			end
			self.tab.blocosJogadas = {}
			jogada.p:Move(jogada.x, jogada.y)
			jogada.p:MarcaJogada()
		else
			if(jogada.p.tipo == 1)then
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaN',action='stop'})
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaN',action='start'})
			else
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaD',action='stop'})
				event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaD',action='start'})
			end
			self.tab.blocosJogadas = {}
			self:MarcaSopraveis()
			jogada.p:Move(jogada.x, jogada.y)
		end
		if(not(self.tab:TemCome()))then
			self.tab.blocosJogadas = {}
		end
	end

	self.MarcaSopraveis = function(this)
		for indice,peca in pairs(self.tab.pecas)do
			if(peca.viva and peca.jogador == self.tab.cursor.jogador)then
				self.tab.blocosJogadas = {}
				peca:MarcaJogada()
				if(self.tab:TemCome())then
					--print(indice)
					peca.sopravel = true
				end
			end
		end
		self.tab.blocosJogadas = {}
	end

	self.LimpaSopraveis = function(this)
		for indice,peca in pairs(self.tab.pecas)do
			peca.sopravel = nil
		end
	end

	self.TrocaJogador = function(this)
		if(self.tab.cursor.jogador == 1)then
			self.tab.cursor.jogador = 2
		else
			self.tab.cursor.jogador = 1
		end
	end

	self.FazFim = function(this)
		principal.estadoAtual.animado = false
		event.post('out',{class='ncl',type= 'presentation',label='somEfectVence',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfecttVence',action='start'})

		local pontosdif = 0
		local vitorioso = ''
		local mensagem = ''
		if(self.pontos[1] > 0)then
			self.vitorioso = '1'
			self.vitorias[1] =self.vitorias[1] +1
			pontosdif = self.pontos[1]
		else
			self.vitorioso = '2'
			self.vitorias[2] =self.vitorias[2] +1
			pontosdif = self.pontos[2]
		end

		if pontosdif > 10 then
			mensagem = 'humilhou com '.. pontosdif .. ' pontos'
		elseif pontosdif >6 then
			mensagem = 'venceu com folga com '.. pontosdif .. ' pontos'
		elseif pontosdif >3 then
			mensagem = 'venceu com '.. pontosdif .. ' pontos'
		else
			mensagem = 'quase perdeu com '.. pontosdif .. ' pontos'
		end

		if(principal.estadoAtual.conexao)then
			principal.estadoAtual:FimJogo(1)
		end

		self.opcaoSelecionada= 1


		self.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:drawRect('fill',fundo.largura/2 - 200,fundo.altura/2 - 30,400,60)
			canvas:attrColor ('black')
			canvas:attrFont ('vera', 24)
			canvas:drawText(fundo.largura/2 - 180,fundo.altura/2-27,'Jogador ' .. vitorioso .. mensagem)
			canvas:attrFont ('vera', 12)
			canvas:drawText(fundo.largura/2 - 180+(100-canvas:measureText ('Jogar denovo'))/2,fundo.altura/2+6,'Jogar denovo')
			canvas:drawText(fundo.largura/2 - 60+(100-canvas:measureText ('Voltar ao menu'))/2,fundo.altura/2+6,'Voltar ao menu')
			canvas:drawText(fundo.largura/2 + 60+(100-canvas:measureText ('Sair'))/2,fundo.altura/2+6,'Sair')
			canvas:attrColor('blue')
			canvas:drawRect('frame',fundo.largura/2 -300 + 120*self.opcaoSelecionada ,fundo.altura/2+4,100,22)
		end
		local MoveDireita = function(this)
			if(self.opcaoSelecionada > 2)then
				self.opcaoSelecionada = 1
			else
				self.opcaoSelecionada = self.opcaoSelecionada +1
			end
		end
		local MoveEsquerda = function(this)
			if(self.opcaoSelecionada < 2)then
				self.opcaoSelecionada = 3
			else
				self.opcaoSelecionada = self.opcaoSelecionada -1
			end
		end

		self.Botao = function()
		end

		self.MoveCima= MoveDireita
		self.MoveBaixo = MoveEsquerda
		self.MoveDireita = MoveDireita
		self.MoveEsquerda = MoveEsquerda
		self.Selecionado = function(this)
			if(self.opcaoSelecionada==1)then
				principal.estadoAtual.animado = true
				self:Inicio()
			elseif(self.opcaoSelecionada==2)then
				principal.estadoAtual:VoltaMenu()
			else
				principal.estadoAtual:Sair()
			end
		end
	end

	self.Pausa = function(this)
		principal.estadoAtual.animado = false
		self.opcaoSelecionada= 1

		self.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:drawRect('fill',fundo.largura/2 - 210,fundo.altura/2 - 30,420,60)
			canvas:attrColor ('black')
			canvas:attrFont ('vera', 24)
			canvas:drawText(fundo.largura/2 - (canvas:measureText ('Jogo Pausado')/2),fundo.altura/2-27,'Jogo Pausado')
			canvas:attrFont ('vera', 12)
			canvas:drawText(fundo.largura/2 - 200+(100-canvas:measureText ('Resumir'))/2,fundo.altura/2+6,'Resumir')
			canvas:drawText(fundo.largura/2 - 100+(100-canvas:measureText ('Reiniciar'))/2,fundo.altura/2+6,'Reiniciar')
			canvas:drawText(fundo.largura/2 +(100-canvas:measureText ('Menu'))/2,fundo.altura/2+6,'Menu')
			canvas:drawText(fundo.largura/2 + 100+(100-canvas:measureText ('Sair'))/2,fundo.altura/2+6,'Sair')
			canvas:attrColor('blue')
			canvas:drawRect('frame',fundo.largura/2 -300 + 100*self.opcaoSelecionada ,fundo.altura/2+4,100,22)
		end

		local MoveDireita = function(this)
			if(self.opcaoSelecionada > 3)then
				self.opcaoSelecionada = 1
			else
				self.opcaoSelecionada = self.opcaoSelecionada +1
			end
		end
		local MoveEsquerda = function(this)
			if(self.opcaoSelecionada < 2)then
				self.opcaoSelecionada = 4
			else
				self.opcaoSelecionada = self.opcaoSelecionada -1
			end
		end

		self.Botao = function(this)
			local pontos = self.pontos
			self:Inicio()
			self.pontos = pontos
		end

		self.MoveCima = MoveDireita
		self.MoveBaixo = MoveEsquerda
		self.MoveDireita = MoveDireita
		self.MoveEsquerda = MoveEsquerda
		self.Selecionado = function(this)
			if(self.opcaoSelecionada==1)then
				principal.estadoAtual.animado = true
				local pontos = self.pontos
				self:Inicio()
				self.pontos = pontos
			elseif(self.opcaoSelecionada==2)then
				principal.estadoAtual.animado = true
				self:Inicio()
			elseif(self.opcaoSelecionada==3)then
				principal.estadoAtual:VoltaMenu()
			else
				principal.estadoAtual:Sair()
			end
		end
	end

	self.Sair = function(this)
		this = nil
	end

	return self
end
