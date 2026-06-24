require 'constantes'
--talvez seja melhor quebrar esse objeto em vários

movimentador = {}

movimentador.Novo = function(this,tabela)
	local self = {}

	self.vitorias = {0,0}

	self.tab = tabela

	--define comportamento inicial
	self.Inicio = function(this)

		self.Desenhar = function(this)
			canvas:attrColor (COR1)
			canvas:attrFont ('vera', 24)
			canvas:drawText(5,15,'Jogador 1' .. string.rep ('*',self.vitorias[1]))
			canvas:drawText(20,40,(12 - self.pontos[2]) .. ' pontos')
			canvas:attrColor (COR2)
			canvas:drawText(5,75,'Jogador 2' .. string.rep ('*',self.vitorias[2]))
			canvas:drawText(20,105,(12 - self.pontos[1]) .. ' pontos')
		end

		self.pontos ={12,12}

		self.MoveCima = function(this)
			if(self.tab.cursor.posicao.x > 0)then
				self.tab:MoveCursor(self.tab.cursor.posicao.x-1,self.tab.cursor.posicao.y)
			else
				self.tab:MoveCursor(7,self.tab.cursor.posicao.y)
			end
		end

		self.MoveBaixo = function(this)
			if(self.tab.cursor.posicao.x < 7)then
				self.tab:MoveCursor(self.tab.cursor.posicao.x+1,self.tab.cursor.posicao.y)
			else
				self.tab:MoveCursor(0,self.tab.cursor.posicao.y)
			end
		end

		self.MoveEsquerda = function(this)
			if(self.tab.cursor.posicao.y > 0)then
				self.tab:MoveCursor(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y-1)
			else
				self.tab:MoveCursor(self.tab.cursor.posicao.x,7)
			end
		end

		self.MoveDireita = function(this)
			if(self.tab.cursor.posicao.y < 7)then
				self.tab:MoveCursor(self.tab.cursor.posicao.x,self.tab.cursor.posicao.y+1)
			else
				self.tab:MoveCursor(self.tab.cursor.posicao.x,0)
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
				if(self.tab.pecas[peca].jogador == self.tab.cursor.jogador)then
					self.tab.blocosJogadas = {}
					self.MarcaJogada[self.tab.pecas[peca].tipo](self,self.tab.cursor.posicao.x,self.tab.cursor.posicao.y,1,peca)
				elseif(self.tab.pecas[peca].sopravel and self.tab.pecas[peca].viva)then
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
		self:LimpaSopraveis()
		self.tab.pecas[peca].tipo = 2
	end

	self.SopraPeca = function(this,peca)
		self:LimpaSopraveis()
		self.pontos[self.tab.pecas[peca].jogador] = self.pontos[self.tab.pecas[peca].jogador] -1
		event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='start'})
		self.tab.pecas[peca].viva = false
	end

	self.MarcaJogada = {}
	self.MarcaJogada[1] = function(this,x,y,tier,peca)
		local yMaiorqueZero
		local xMaiorqueZero
		local yMenosqueMax
		local xMenosqueMax
		if(y > 0)then
			yMaiorqueZero= true
		end
		if(y < 7)then
			yMenosqueMax = true
		end

		if(x > 0)then
			xMaiorqueZero=true
		end
		if(x < 7)then
			xMenosqueMax = true
		end

		if(tier == 1)then
			local fazDama

			if(ORIENTACAO)then
				if(not(xMaiorqueZero) and self.tab.cursor.jogador == 2)then
					fazDama =  true
				elseif(not(xMenosqueMax) and self.tab.cursor.jogador == 1)then
					fazDama = true
				end
			else
				if(not(yMaiorqueZero) and self.tab.cursor.jogador == 2)then
					fazDama =  true
				elseif(not(yMenosqueMax) and self.tab.cursor.jogador == 1)then
					fazDama = true
				end
			end

			if(fazDama)then
				self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=self.tab.cursor.posicao.x,y=self.tab.cursor.posicao.y,noMove=true,fazDama=true,tier=0,p=peca}
			else
				self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=self.tab.cursor.posicao.x,y=self.tab.cursor.posicao.y,noMove=true,tier=0,p=peca}
			end
		end

		if(yMaiorqueZero)then
			if(xMaiorqueZero)then
				local pecaUpLeft = self.tab:TemPeca(x-1,y-1)
				if(not(pecaUpLeft))then
					if((self.tab.cursor.jogador == 2)and (tier==1))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x-1,y=y-1,tier= tier,p=peca}
					end
				elseif(self.tab.pecas[pecaUpLeft].jogador ~= self.tab.cursor.jogador and x-1>0 and y-1>0)then
					if(not(self.tab:TemJogada(x-2,y-2)) and not(self.tab:TemPeca(x-2,y-2)))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x-2,y=y-2,come=pecaUpLeft,tier=tier,p=peca}
						--self.MarcaJogada[1](self,x-2,y-2,tier+1)
					end
				end
			end
			if(xMenosqueMax)then
				local pecaUpRight = self.tab:TemPeca(x+1,y-1)
				--print('opcao 2',pecaUpRight)
				if(not(pecaUpRight))then
					if((tier==1)and((self.tab.cursor.jogador == 1 and ORIENTACAO)or(self.tab.cursor.jogador == 2 and not(ORIENTACAO))))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x+1,y=y-1,tier= tier,p=peca}
					end
				elseif(self.tab.pecas[pecaUpRight].jogador ~= self.tab.cursor.jogador and x+1<7 and y-1>0)then
					if(not(self.tab:TemJogada(x+2,y-2)) and not(self.tab:TemPeca(x+2,y-2)))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x+2,y=y-2,come=pecaUpRight,tier=tier,p=peca}
						--self.MarcaJogada[1](self,x+2,y-2,tier+1)
					end
				end
			end
		end

		if(yMenosqueMax)then
			if(xMaiorqueZero)then
				local pecaDownLeft = self.tab:TemPeca(x-1,y+1)
				--print('opcao 3',pecaDownLeft)
				if(not(pecaDownLeft))then
					if((tier==1)and((self.tab.cursor.jogador == 2 and ORIENTACAO)or(self.tab.cursor.jogador == 1 and not(ORIENTACAO))))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x-1,y=y+1,tier= tier,p=peca}
					end
				elseif(self.tab.pecas[pecaDownLeft].jogador ~= self.tab.cursor.jogador and x-1>0 and y+1<7)then
					if(not(self.tab:TemJogada(x-2,y+2)) and not(self.tab:TemPeca(x-2,y+2)))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x-2,y=y+2,come=pecaDownLeft,tier=tier,p=peca}
						--self.MarcaJogada[1](self,x-2,y+2,tier+1)
					end
				end
			end
			if(xMenosqueMax)then
				local pecaDownRight = self.tab:TemPeca(x+1,y+1)
				--print('opcao 4',pecaDownRight)
				if(pecaDownRight == nil)then
					if((tier==1)and(self.tab.cursor.jogador == 1))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x+1,y=y+1,tier= tier,p=peca}
					end
				elseif(self.tab.pecas[pecaDownRight].jogador ~= self.tab.cursor.jogador and x+1<7 and y+1<7)then
					if(not(self.tab:TemJogada(x+2,y+2)) and not(self.tab:TemPeca(x+2,y+2)))then
						self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=x+2,y=y+2,come=pecaDownRight,tier=tier,p=peca}
						--self.MarcaJogada[1](self,x+2,y+2,tier+1)
					end
				end
			end
		end
	end

	self.MarcaJogada[2] = function(this,x,y,tier,peca)
		local concatenaTabela = function(tab1,tab2)
			for indice,objeto in pairs(tab2) do
				tab1[#tab1+1]= objeto
			end
		end

		local yMaiorqueZero
		local xMaiorqueZero
		local yMenosqueMax
		local xMenosqueMax
		if(y > 0)then
			yMaiorqueZero= true
		end
		if(y < 7)then
			yMenosqueMax = true
		end

		if(x > 0)then
			xMaiorqueZero=true
		end
		if(x < 7)then
			xMenosqueMax = true
		end

		if(tier == 1)then
			self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=self.tab.cursor.posicao.x,y=self.tab.cursor.posicao.y,noMove=true,tier=0,p=peca}
		end

		local yLoc
		local jogadaValida
		if(yMaiorqueZero)then
			if(xMaiorqueZero)then
				yLoc = y
				local linhaDama = {}
				for xLoc=x-1 ,0,-1 do
					yLoc = yLoc-1
					local pecaUpLeft = self.tab:TemPeca(xLoc,yLoc)
					if(not(pecaUpLeft))then
						if(tier == 1)then
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,tier=tier,p=peca}
						else
							linhaDama[#linhaDama+1] =  {x=xLoc,y=yLoc,tier=tier}
						end
					else
						if(self.tab.pecas[pecaUpLeft].jogador ~= self.tab.cursor.jogador and xLoc>0 and yLoc>0 and not(self.tab:TemJogada(xLoc-1,yLoc-1)) and not(self.tab:TemPeca(xLoc-1,yLoc-1)))then
							if(tier > 1)then
								concatenaTabela(self.tab.blocosJogadas,linhaDama)
							end
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=xLoc-1,y=yLoc-1,come=pecaUpLeft,tier=tier,p=peca}
							--self.MarcaJogada[2](self,xLoc-1,yLoc-1,tier+1)
						end
						break
					end
				end
			end
			if(xMenosqueMax)then
				yLoc = y
				local linhaDama = {}
				for xLoc=x+1,7 do
					yLoc = yLoc-1
					local pecaUpRight = self.tab:TemPeca(xLoc,yLoc)
					if(not(pecaUpRight))then
						if(tier == 1)then
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,tier=tier,p=peca}
						else
							linhaDama[#linhaDama+1] =  {x=xLoc,y=yLoc,tier=tier}
						end
					else
						if(self.tab.pecas[pecaUpRight].jogador ~= self.tab.cursor.jogador and xLoc<7 and yLoc>0 and not(self.tab:TemJogada(xLoc+1,yLoc-1)) and not(self.tab:TemPeca(xLoc+1,yLoc-1)))then
							if(tier > 1)then
								concatenaTabela(self.tab.blocosJogadas,linhaDama)
							end
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=xLoc+1,y=yLoc-1,come=pecaUpRight,tier=tier,p=peca}
							--self.MarcaJogada[2](self,xLoc+1,yLoc-1,tier+1)
						end
						break
					end
				end
			end
		end

		if(yMenosqueMax)then
			if(xMaiorqueZero)then
				yLoc = y
				local linhaDama = {}
				for xLoc=x-1,0,-1 do
					yLoc = yLoc+1
					local pecaDownLeft = self.tab:TemPeca(xLoc,yLoc)
					if(not(pecaDownLeft))then
						if(tier == 1)then
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,tier=tier,p=peca}
						else
							linhaDama[#linhaDama+1] =  {x=xLoc,y=yLoc,tier=tier}
						end
					else
						if(self.tab.pecas[pecaDownLeft].jogador ~= self.tab.cursor.jogador and xLoc>0 and yLoc<7 and not(self.tab:TemJogada(xLoc-1,yLoc+1)) and not(self.tab:TemPeca(xLoc-1,yLoc+1)))then
							if(tier > 1)then
								concatenaTabela(self.tab.blocosJogadas,linhaDama)
							end
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=xLoc-1,y=yLoc+1,come=pecaDownLeft,tier=tier,p=peca}
							--self.MarcaJogada[2](self,xLoc-1,yLoc+1,tier+1)
						end
						break
					end
				end
			end
			if(xMenosqueMax)then
				yLoc = y
				local linhaDama = {}
				for xLoc=x+1,7 do
					yLoc = yLoc+1
					local pecaDownRight = self.tab:TemPeca(xLoc,yLoc)
					if(not(pecaDownRight))then
						if(tier == 1)then
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,tier=tier,p=peca}
						else
							linhaDama[#linhaDama+1] =  {x=xLoc,y=yLoc,tier=tier}
						end
					else
						if(self.tab.pecas[pecaDownRight].jogador ~= self.tab.cursor.jogador and xLoc<7 and yLoc<7 and not(self.tab:TemJogada(xLoc+1,yLoc+1)) and not(self.tab:TemPeca(xLoc+1,yLoc+1)))then
							if(tier > 1)then
								concatenaTabela(self.tab.blocosJogadas,linhaDama)
							end
							self.tab.blocosJogadas[#self.tab.blocosJogadas+1] ={x=xLoc+1,y=yLoc+1,come=pecaDownRight,tier=tier,p=peca}
							--self.MarcaJogada[2](self,xLoc+1,yLoc+1,tier+1)
						end
						break
					end
				end
			end
		end
	end

	self.FazJogada = function(this,bloco)
		local jogada = self.tab.blocosJogadas[bloco]
		if(self.tab.blocosJogadas[bloco].come)then
			local tier = self.tab.blocosJogadas[bloco].tier+1
			while(bloco >0 and tier>1)do
				--print('bloco',bloco,'tier',self.tab.blocosJogadas[bloco].tier,bloco)
				if(self.tab.blocosJogadas[bloco].come and tier > self.tab.blocosJogadas[bloco].tier)then
					self.tab.pecas[self.tab.blocosJogadas[bloco].come].viva = false
					self.pontos[self.tab.pecas[self.tab.blocosJogadas[bloco].come].jogador] = self.pontos[self.tab.pecas[self.tab.blocosJogadas[bloco].come].jogador] -1
					if(self.tab.pecas[jogada.p].tipo == 1)then
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeN',action='stop'})
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeN',action='start'})
					else
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeD',action='stop'})
						event.post('out',{class='ncl',type= 'presentation',label='somEfectComeD',action='start'})
					end
					tier = self.tab.blocosJogadas[bloco].tier
				end
				bloco = bloco -1
			end
			self.tab.blocosJogadas = {}
			--self.tab.blocosJogadas[#self.tab.blocosJogadas+1] = {x=self.tab.cursor.posicao.x,y=self.tab.cursor.posicao.y,tier=0}
			self.MarcaJogada[self.tab.pecas[jogada.p].tipo](self,jogada.x, jogada.y,2,jogada.p)
		else
			if(self.tab.blocosJogadas[bloco].tier>0)then
				if(self.tab.pecas[jogada.p].tipo == 1)then
					event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaN',action='stop'})
					event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaN',action='start'})
				else
					event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaD',action='stop'})
					event.post('out',{class='ncl',type= 'presentation',label='somEfectAndaD',action='start'})
				end
			end
			self.tab.blocosJogadas = {}
			self:MarcaSopraveis()
		end
		self.tab:MovePeca(jogada.p,jogada.x, jogada.y)
		if(not(self.tab:TemCome()))then
			self.tab.blocosJogadas = {}
		end
	end

	self.MarcaSopraveis = function(this)
		for indice,peca in pairs(self.tab.pecas)do
			if(peca.viva and peca.jogador == self.tab.cursor.jogador)then
				self.tab.blocosJogadas = {}
				self.MarcaJogada[peca.tipo](self,peca.posicao.x,peca.posicao.y,1,indice)
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
			self.tab.cursor.jogador =2
		else
			self.tab.cursor.jogador = 1
		end
	end

	self.FazFim = function(this)
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

		self.MoveCima= MoveDireita
		self.MoveBaixo = MoveEsquerda
		self.MoveDireita = MoveDireita
		self.MoveEsquerda = MoveEsquerda
		self.Selecionado = function(this)
			if(self.opcaoSelecionada==1)then
				self:Inicio()
				self.tab:Inicio()
			elseif(self.opcaoSelecionada==2)then
				main:TrocaEstado(1)
			else
				event.post('out',{class='ncl',type= 'presentation',label='jogoFim',action='start'})
			end
		end
	end

	self.Pausa = function(this)

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
				local pontos = self.pontos
				self:Inicio()
				self.pontos = pontos
			elseif(self.opcaoSelecionada==2)then
				self:Inicio()
				self.tab:Inicio()
			elseif(self.opcaoSelecionada==3)then
				main:TrocaEstado(1)
			else
				event.post('out',{class='ncl',type= 'presentation',label='jogoFim',action='start'})
			end
		end
	end

	return self
end
