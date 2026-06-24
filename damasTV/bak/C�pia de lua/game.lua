require 'tabuleiro'
require 'fundo'
require 'movimentador'



--parte do objeto jogo

game= {}

game.Novo = function(this)
	--setando o randomseed com o relogio para que ele realmente seja aleatorio
	math.randomseed(os.clock())

	local self = {}
--criacao dos objetos no jogo
	self.Objs = {fundo,tab = tabuleiro:Novo()}
--criacao do controlador de moviemnto do jogo
	self.Objs.movimentador = movimentador:Novo(self.Objs.tab)

	self.Fazer = function(this)
		self:Desenhar()
	end

	self.Desenhar = function(this)
		for indice,obj in pairs(self.Objs) do
			obj:Desenhar()
		end
		canvas:flush()
	end

	self.HandlerMovimento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type ~= 'press' then return end
		if     evt.key == 'CURSOR_UP'    then
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

	return self
end



