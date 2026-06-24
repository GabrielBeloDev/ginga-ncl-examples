require 'pecaTabuleiro'
require 'constantes'

tabuleiro = {}

tabuleiro.Novo = function(this)
	local self = {}
	self.Inicio = function(this)
		self.pecas = {}
		local par = true
		for i=0,2 do
			par =  not(par)
			for j = 0,7,2 do
				if(par) then
					if(ORIENTACAO)then
						posicao = {y=j,x=i}
					else
						posicao = {y=i,x=j}
					end
				else
					if(ORIENTACAO)then
						posicao = {y=j+1,x=i}
					else
						posicao = {y=i,x=j+1}
					end
				end
				self.pecas[#self.pecas+1]= pecaTabuleiro:Novo(posicao,1,1)
			end
		end

		for i=5,7 do
			par=  not(par)
			for j = 0,7,2 do
				if(par) then
					if(ORIENTACAO)then
						posicao = {y=j,x=i}
					else
						posicao = {y=i,x=j}
					end
				else
					if(ORIENTACAO)then
						posicao = {y=j+1,x=i}
					else
						posicao = {y=i,x=j+1}
					end
				end
				self.pecas[#self.pecas+1] = pecaTabuleiro:Novo(posicao,2,1)
			end
		end
	end

	self:Inicio()
	--blocos, não fazem nada então não há rasão para ser criado um array deles cria-se apenas objetos para um ou outro
	self.blocos = {}


	self.blocos[1] = {}
	self.blocos[1].figura  = canvas:new('imagens/blocos/bloco'..BLOCO_A..'.gif')
	self.blocos[1].largura, self.blocos[1].altura = self.blocos[1].figura:attrSize()

	self.blocos[2]= {}
	self.blocos[2].figura  = canvas:new('imagens/blocos/bloco'..BLOCO_B..'.gif')
	--self.blocos[2].largura, tabuleiro.blocos[2].altura = tabuleiro.blocos[2].figura:attrSize()

	self.blocos['cursor']= {}
	self.blocos['cursor'].figura  = canvas:new(BLOCO_C)
	--self.blocos['cursor'].largura, tabuleiro.blocos[1].altura = tabuleiro.blocos[1].figura:attrSize()

	self.blocos['selecionado']= {}
	self.blocos['selecionado'].figura  = canvas:new(BLOCO_S)
	--self.blocos['selecionado'].largura, tabuleiro.blocos[1].altura = tabuleiro.blocos[1].figura:attrSize()
	math.random(2)
	if(math.random(2)==1)then
		self.cursor = {posicao={x=3,y=5},jogador=JOGADOR1}
	else
		self.cursor = {posicao={x=3,y=4},jogador=JOGADOR2}
	end
	self.cursor.figuras = {canvas:new('imagens/cursors/cursor'..JOGADOR1..'.gif'),canvas:new('imagens/cursors/cursor'..JOGADOR2..'.gif')}
	self.cursor.largura,self.cursor.altura = self.cursor.figuras[1]:attrSize()
	self.cursor.l = 1
	self.blocosJogadas = {}

	self.Desenhar = function(this)
		local par = true
		local tamx = fundo.altura/2 +55
		local tamy = fundo.largura/2 -20
		local larguraBloco = self.blocos[1].largura/2
		local fundoBloco = (self.blocos[1].altura/2) *(7/2)
		local fundoBp2 = (self.blocos[1].altura/2)/2

		for x=0, 7 do
			for y=0, 7 do
				local figura
				if(self.cursor.posicao.x == x and self.cursor.posicao.y == y)then
					figura = self.blocos.cursor.figura
				elseif(self:TemJogada(x,y))then
					figura = self.blocos.selecionado.figura
				elseif(par)then
					figura = self.blocos[1].figura
				else
					figura =self.blocos[2].figura
				end
				canvas:compose(tamx + ((y-x) * (larguraBloco)),
					tamy + ((x+y) * (fundoBp2)) - (fundoBloco),
					figura)
				par = not(par)
			end
			par=not(par)
		end

		for indice,peca in pairs(self.pecas)do
			peca:Desenhar()
		end
		--desenha cursor
		local  frame = self.cursor.l*self.blocos[1].largura
		local x,y = self.cursor.posicao.x,self.cursor.posicao.y
		self.cursor.figuras[self.cursor.jogador]:attrCrop (frame,0,self.blocos[1].largura,self.blocos[1].altura)
		canvas:compose(tamx + ((y-x) * (larguraBloco))
		, tamy + ((x+y) * (fundoBp2)) - (fundoBloco)-self.blocos[1].altura
		, self.cursor.figuras[self.cursor.jogador])
		if(ANIMACAO)then
			self.cursor.l =self.cursor.l+1
			if(self.cursor.l > 8)then
				self.cursor.l = 1
			end
		end


	end

	self.TemJogada= function(this,x,y)
		local retorno
		for indice,bloco in pairs(self.blocosJogadas)do
			if(bloco.x == x and bloco.y ==y)then
				if(not(retorno))then
					retorno = indice
				elseif( self.blocosJogadas[retorno].tier < bloco.tier )then
					retorno = indice
				end
			end
		end
		return retorno
	end

	self.TemPeca = function(this,x,y)
		for indice,peca in pairs(self.pecas) do
			if (peca.viva and peca.posicao.x==x and peca.posicao.y==y) then
				return indice
			end
		end
	end

	self.TemCome = function(this)
		for indice,bloco in pairs(self.blocosJogadas)do
			if(bloco.come)then
				--print('tem come',bloco.indicePeca)
				return true
			end
		end
	end

	self.MovePeca = function(this,indice,x,y)
		self.pecas[indice].posicao.x,self.pecas[indice].posicao.y = x,y
	end

	self.MoveCursor = function(this,x,y)
		--print('x=',x,'y=',y)
		self.cursor.posicao.x,self.cursor.posicao.y = x,y
	end

	return self
end





