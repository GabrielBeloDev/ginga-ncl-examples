package.path = package.path..';engine/?.lua'
require 'tabuleiro'
require 'fundo'
require 'movimentador'
require 'jogo'
require "AuxFunctions"



--parte do objeto jogo

jogoRede= {}

jogoRede.Novo = function(this)
	--filiação
	print('jogoRede Criado')
	local self = game:Novo()

	ANIMACAO= true

	self.ConexaoHttp = function(this,dadosRede)
		print('http')
		require 'conexaoTcp'
		self.codJogo = dadosRede.codJogo
		self.Objs.movimentador.nomes = dadosRede.nomes
		self.ultimoCodigo = 0
		self.jogadas= {}
		self.HandlerData = function(msg,conectionData)
			if(msg == 'conectado')then
				local url ='codUser='..dadosRede.codUser..'&codGame='..dadosRede.codGame..'&lastcode'..self.ultimoCodigo
				if(self.Objs.tab.cursor.jogador==self.jogador and #self.jogadas>0)then
					url = url..'&move='..AuxFunctions.TableToString(self.jogadas[#self.jogadas])
					self.jogadas[#self.jogadas] = nil
				end
				self.conexaoTcp:Envia('GET http://'..SERVIDOR..'/gameHTTP.php?'..url..'\n',connetcionData)
			elseif(msg == 'recebido')then
				local dados = assert(loadstring(self.conexaoTcp.conexoesAtivas[connetcionData].data))()
				if(dados.lastcode and dados.lastcode>self.ultimoCodigo)then
					self.ultimoCodigo = dados.lastcode
					if(dados.mov.p)then
						dados.mov.p = self.Objs.tab.TemPeca(dados.p.x,dados.p.y)
					end
					if(dados.mov.come)then
						dados.mov.come = self.Objs.tab.TemPeca(dados.come.x,dados.come.y)
					end
					if(dados.mov.sopra)then
						dados.mov.sopra = self.Objs.tab.TemPeca(dados.sopra.x,dados.sopra.y)
					end
					self.Objs.movimentador:FazJogada(dados.mov)
					self.Objs.movimentador.ultimaJogada = nil
					self:Fazer()
				elseif(dados.codigo)then
					self.ultimoCodigo = dados.codigo
					if(#self.jogadas>0)then
						self.conexao:Conecta({host=SERVIDOR,port=80})
					end
				end
			elseif(msg == 'erro')then
				self.mensagem ='Erro:'..connetcionData
			end
		end
		self.conexao = conexaoTcp:Novo(self.HandlerData)
		if(dadosRede.vez)then
			self.jogador = JOGADOR1
		else
			self.jogador = JOGADOR2
		end
		self.Objs.tab.cursor.jogador,self.Objs.tab.cursor.posicao=JOGADOR1,{x=3,y=4}

		self.TrataEvento = function(evt)
			if evt.class ~= 'key' then return end
			if evt.type ~= 'press' then return end
			if evt.key == 'CURSOR_UP'    then
				self.Objs.movimentador:MoveCima()
			elseif evt.key == 'CURSOR_DOWN' then
				self.Objs.movimentador:MoveBaixo()
			elseif evt.key == 'CURSOR_LEFT' then
				self.Objs.movimentador:MoveEsquerda()
			elseif evt.key == 'CURSOR_RIGHT' then
				self.Objs.movimentador:MoveDireita()
			elseif evt.key == 'ENTER' then
				if(self.Objs.tab.cursor.jogador==self.jogador and self.animado)then
					self.Objs.movimentador:Selecionado()
					if(self.Objs.movimentador.ultimaJogada)then
						self.jogadas[#self.jogadas+1] = self.Objs.movimentador.ultimaJogada
						if(self.jogadas[#self.jogadas+1].p)then
							self.jogadas[#self.jogadas+1].p = {x=self.jogadas[#self.jogadas+1].p.x,y=self.jogadas[#self.jogadas+1].p.y}
						end
						if(self.jogadas[#self.jogadas+1].come)then
							self.jogadas[#self.jogadas+1].come = {x=self.jogadas[#self.jogadas+1].come.x,y=self.jogadas[#self.jogadas+1].come.y}
						end
						if(self.jogadas[#self.jogadas+1].sopra)then
							self.jogadas[#self.jogadas+1].sopra = {x=self.jogadas[#self.jogadas+1].sopra.x,y=self.jogadas[#self.jogadas+1].sopra.y}
						end
						self.conexao:Conecta({host=SERVIDOR,port=80})
					end
				end
			--elseif evt.key == '' then
				--self.Objs.movimentador:Botao()
			end
		end

		self.FimJogo = function(this,vitorioso)
			local url = '/TerminaJogo.php?codJogo'..self.codJogo
			if(self.jogador == vioriso)then
				url = url..'&vitorioso=1'
			end
			if(self.codJogo)then
				self.ControladorFinal= function(msg,data)
					if(msg == 'conectado')then
						self.conexaoTcp:Envia('GET http://'..SERVIDOR..url..'&vitorioso=1\n',data)
					elseif(recebido=='recebido')then
						self:VoltaMenu()
					end
				end
				self.conexao= conexaoTcp:Novo(self.ControladorFinal)
				self.conexao:Conecta({host=SERVIDOR,port=80})
			end
		end

	end

	self.conexaoDireta = function(this,dadosRede)
		require 'conexao'
		self.Objs.movimentador.nomes = dadosRede.nomes
		if(dadosRede.servidor)then
			self.codJogo = dadosRede.codJogo
			local serverHand = function(data)
				self.conexao.Handler = self.TrataEvento
				self.conexao:Conecta()
			end
			self.conexao = conexao:Novo({addres=dadosRede.ip,port=dadosRede.port,Handler = serverHand})
			self.conexao:IniciaServidor()
			self.jogador = JOGADOR2

			--controles de fim de jogo
			self.FimJogo = function(this,vitorioso)
				local url = '/TerminaJogo.php?codJogo'..self.codJogo
				if(self.jogador == viorioso)then
					url = url..'&vitorioso=1'
				end
				self.ControladorFinal= function(msg,data)
				if(msg == 'conectado')then
					self.conexaoTcp:Envia('GET http://'..SERVIDOR..url..'&vitorioso=1\n',data)
					elseif(recebido=='recebido')then
						self:VoltaMenu()
					end
				end
				self.conexaoTcp = conexaoTcp:Novo(self.ControladorFinal)
				self.conexaoTcp:Conecta({host=SERVIDOR,port=80})
			end
		else
			print('cliente')
			self.conexao = conexao:Novo({addres=dadosRede.ip,port=dadosRede.port,Handler=self.TrataEvento})
			self.conexao:Conecta()
			self.conexao:Enviar('ping')
			self.jogador = JOGADOR1
		end
		self.Objs.tab.cursor.jogador,self.Objs.tab.cursor.posicao=JOGADOR1,{x=3,y=4}

		self.TrataEvento = function(evt)
			local liberaMove = self.Objs.tab.cursor.jogador == self.jogador
			local eminhavez = liberaMove
			if(liberaMove)then
				self.conexao:Enviar(AuxFunctions.TableToString(evt))
			end
			if(type(evt) == "string")then
				evt = assert(loadstring("return".. evt))()
				liberaMove = true
			end
			if evt.class ~= 'key' then return end
			if evt.type ~= 'press' then return end
			if liberaMove  then
				if evt.key == 'CURSOR_UP' then
					self.Objs.movimentador:MoveCima()
				elseif evt.key == 'CURSOR_DOWN' then
					self.Objs.movimentador:MoveBaixo()
				elseif evt.key == 'CURSOR_LEFT' then
					self.Objs.movimentador:MoveEsquerda()
				elseif evt.key == 'CURSOR_RIGHT' then
					self.Objs.movimentador:MoveDireita()
				elseif evt.key == 'ENTER' then
					self.Objs.movimentador:Selecionado()
				elseif evt.key == '' then
					self.Objs.movimentador:Botao()
				end
			end
			if(self.Objs.tab.cursor.jogador == self.jogador and not(eminhavez))then
				return true
			elseif eminhavez then
				self:Fazer()
			end
		end

		self.Fazer = function(this)
			self:Desenhar()
			if(self.Objs.tab.cursor.jogador ~= self.jogador)then
				self.conexao:Espera()
			else
				self.conexao:Enviar('')
			end
		end

	end

	return self
end



