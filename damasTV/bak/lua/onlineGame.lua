require 'tabuleiro'
require 'fundo'
require 'movimentador'
require 'game'
require 'conexao'
require "AuxFunctions"



--parte do objeto jogo

onlineGame= {}

onlineGame.Novo = function(this)
	--filiação
	print('onlineGame Criado')
	local self = game:Novo()

	ANIMACAO= true

	self.Fazer = function(this)
		self:Desenhar()
		if(self.Objs.tab.cursor.jogador ~= self.jogador)then
			self.conexao:Espera()
		else
			self.conexao:Enviar('')
		end
	end

	self.Conecta = function(this,onlineData)
		self.Objs.movimentador.nomes = onlineData.nomes
		if(onlineData.servidor)then
			local serverHand = function(data)
				self.conexao.Handler = self.HandlerMovimento
				self.conexao:Conecta()
			end
			self.conexao = conexao:Novo({addres=onlineData.ip,port=onlineData.port,Handler = serverHand})
			self.conexao:IniciaServidor()
			self.jogador = JOGADOR2
		else
			print('cliente')
			self.conexao = conexao:Novo({addres=onlineData.ip,port=onlineData.port,Handler=self.HandlerMovimento})
			self.conexao:Conecta()
			self.conexao:Enviar('ping')
			self.jogador = JOGADOR1
		end
		self.Objs.tab.cursor.jogador,self.Objs.tab.cursor.posicao=JOGADOR1,{x=3,y=4}
	end

	self.HandlerMovimento = function(evt)
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

	return self
end



