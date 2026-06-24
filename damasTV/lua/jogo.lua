require 'computador'

--parte do objeto jogo

jogo= {}

jogo.Novo = function(this,contraComputador)
	require 'tabuleiro'
	require 'movimentador'
	require 'menuJogo'

	--setando o randomseed com o relogio para que ele realmente seja aleatorio
	math.randomseed(os.clock())

	local self = {}

--criacao dos objetos no jogo
	self.Objs = {tabuleiro:Novo(),menuJogo:Novo()}
	self.movimentador = movimentador:Novo(self.Objs[1])
	self.controlador = self.movimentador

--variaveis do jogo
	self.vitorias = {0,0}
	self.nomes = {'Jogador 1','Jogador 2'}
	if(contraComputador)then
		self.computador = computador:Novo(self.movimentador)
		self.nomes = {'Computador','Computador'}
		self.nomes[self.Objs[1].cursor.jogador] = "Jogador"
	end
--especificacao das funcoes abstratas
	self.Fazer = function(this)
		self:Desenhar()
	end

	self.TrataEvento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type ~= 'press' then return end
		if evt.key == 'CURSOR_UP'    then
			self.controlador:MoveCima()
		elseif evt.key == 'CURSOR_DOWN' then
			self.controlador:MoveBaixo()
		elseif evt.key == 'CURSOR_LEFT' then
			self.controlador:MoveEsquerda()
		elseif evt.key == 'CURSOR_RIGHT' then
			self.controlador:MoveDireita()
		elseif evt.key == 'ENTER' then
			self.controlador:Selecionado()
		elseif evt.key == '' then
			if(self.controlador.pausavel)then
				self:Pausa()
			end
		end
	end

--funcoes do jogo
	self.Desenhar = function(this)
		LimpaTela()
		for indice,obj in pairs(self.Objs) do
			obj:Desenhar()
		end
		canvas:flush()
	end

	self.VoltaMenu = function(this)
		principal:TrocaEstado(1)
	end

	self.Sair = function(this)
		event.post('out',{class='ncl',type= 'presentation',label='jogoFim',action='start'})
	end

	self.Inicio = function(this,jogador)
		self.animado = true
		if(self.Objs[1].pecas)then
			self.Objs[1].pecas = ApagaTabela(self.Objs[1].pecas)
		end
		if(self.pontos)then
			self.pontos = ApagaTabela(self.pontos)
		end
		collectgarbage('collect')
		self.Objs[1]:Inicio()
		self.pontos = {12,12}
	end

	self.TrocaJogador = function(this,comp)
		if(self.pontos[1] == 0 or self.pontos[2] == 0) then
			self:Fim()
		else
			if(self.Objs[1].cursor.jogador == 1)then
				self.Objs[1].cursor.jogador = 2
			else
				self.Objs[1].cursor.jogador = 1
			end
			if self.computador and not(comp) then
				self.computador:Jogar()
			end
		end

	end

	self.Pausa = function(this)
		if(principal.estadoAtual.animado)then
			principal.estadoAtual.animado = false
			self.controlador = self.Objs[2]:controladorPausa()
			print(#self.Objs)
			self.Objs[#self.Objs+1] = self.controlador
		else
			print(#self.Objs)
			self.Objs[#self.Objs] = nil
			principal.estadoAtual.animado = true
			self.controlador = ApagaTabela(self.controlador)
			collectgarbage('collect')
			self.controlador = self.movimentador
		end
	end

	self.Fim = function(this)
		principal.estadoAtual.animado = false
		self.controlador = self.Objs[2]:controladorFim()
		self.Objs[#self.Objs+1] = self.controlador
	end

	self:Inicio()
	return self
end



