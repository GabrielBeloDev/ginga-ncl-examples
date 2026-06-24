--parte do objeto jogo

jogoRede= {}

jogoRede.Novo = function(this,conexaoData)

	--filiação

	local self = jogo:Novo()

	require 'menuJogoRede'

	self.Objs[2] = ApagaTabela(self.Objs[2])
	self.Objs[2] = menuJogoRede:Novo()

	self.nomes = conexaoData.nomes

	if(conexaoData.direta)then
		require 'conexaoDireta'
		self.conexao = conexaoDireta.Novo(conexaoData.redeData,self)
	else
		require 'conexaoIndireta'
		self.conexao = conexaoIndireta.Novo(conexaoData.redeData,self)
	end

	self.TrataEventoRede = function(tableData)
		if(tableData.jogada)then
			if(self.Objs[1].cursor.jogador~=self.jogador)then
				self.movimentador:TrataBlocoJogada(tableData,true)
				self:Desenhar()
			end
		elseif(tableData.mensagem)then
			self.Objs[2]:RecebeMensagem(tableData.mensagem,tableData.cor)
			self:Desenhar()
		elseif(tableData.proposta)then
			if(not(principal.estadoAtual.animado))then
				self:Pausa()
			end
			self:PoeSobreMenu(self.Objs[2]:Propor(tableData))
			self:Desenhar()
		elseif(tableData.resposta)then
			self.controlador:RecebeResposta(tableData.resposta)
			self:Desenhar()
		elseif(tableData.vitorioso)then
			self.conexao:EnviarVitorioso(tableData.vitorioso)
		elseif(tableData.sair)then
			self:Sair()
		end
	end
	--deve apagar conexoes antes de sair
	self.Sair = function(this,msg)
		self.conexao:Terminar()
		principal:TrocaEstado(1)
	end


	self.TrocaJogador = function(this)
		if(self.Objs[1].cursor.jogador == 1)then
			self.Objs[1].cursor.jogador = 2
		else
			self.Objs[1].cursor.jogador = 1
		end
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
			if(self.Objs[1].cursor.jogador==self.jogador and self.animado)then
				self.controlador:Selecionado()
				if(self.movimentador.ultimaJogada)then
					local bloco = self.movimentador.ultimaJogada
					bloco.jogada = true
					self.conexao:Enviar(TabelaParaString(bloco))
					self.movimentador.ultimaJogada = ApagaTabela(ultimaJogada)
				end
			elseif(not(self.animado))then
				self.controlador:Selecionado()
			else
				self.Objs[2]:RecebeMensagem('Espere sua vez','black')
			end
		elseif evt.key == '' then
			if(self.animado)then
				self:Pausa()
			else
				self.controlador:Botao()
			end
		elseif(self.controlador.indiceAtual)then
			self.controlador:Receber(evt.key)
		end
	end

	self.PoeSobreMenu = function(this,menu)
		self.controlador = menu
		self.Objs[#self.Objs+1] = self.controlador
		self.animado =false
	end

	self.RetiraSobreMenu = function(this)
		if(#self.Objs >2)then
			self.controlador = self.Objs[#self.Objs-1]
			self.Objs[#self.Objs] = ApagaTabela(self.Objs[#self.Objs])
			collectgarbage('collect')
		end
	end

	self.RetiraTodosMenus = function(this)
		if(#self.Objs>2)then
			for i=3,#self.Objs do
				self.Objs[i] = ApagaTabela(self.Objs[i])
			end
		end
		self.controlador = self.movimentador
		self.animado =true
		collectgarbage('collect')
	end

	return self
end



