require 'constantes'
require 'fundo'

pecaTabuleiro= {}

pecaTabuleiro.FiguraPeca = {{canvas:new('imagens/pecas/peca'..JOGADOR1..'.gif'),canvas:new('imagens/pecas/peca'..JOGADOR2..'.gif')},{canvas:new('imagens/pecas/peca'..JOGADOR1..'d.gif'),canvas:new('imagens/pecas/peca'..JOGADOR2..'d.gif')}}

pecaTabuleiro.Tamanho = {{pecaTabuleiro.FiguraPeca[1][1]:attrSize()},{pecaTabuleiro.FiguraPeca[1][2]:attrSize()}}

pecaTabuleiro.Jogada ={}
pecaTabuleiro.Jogada[1] = function(this)
	local yMaiorqueZero
	local xMaiorqueZero
	local yMenosqueMax
	local xMenosqueMax
	local peca = this
	local x=this.posicao.x
	local y=this.posicao.y

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

	local fazDama

	if(ORIENTACAO)then
		if(not(xMaiorqueZero) and this.tab.cursor.jogador == 2)then
			fazDama =  true
		elseif(not(xMenosqueMax) and this.tab.cursor.jogador == 1)then
			fazDama = true
		end
	else
		if(not(yMaiorqueZero) and this.tab.cursor.jogador == 2)then
			fazDama =  true
		elseif(not(yMenosqueMax) and this.tab.cursor.jogador == 1)then
			fazDama = true
		end
	end

	if(fazDama)then
		this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x,y=y,noMove=true,fazDama=true,p=peca}
	else
		this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x,y=y,noMove=true,p=peca}
	end

	if(yMaiorqueZero)then
		if(xMaiorqueZero)then
			local pecaUpLeft = this.tab:TemPeca(x-1,y-1)
			if(not(pecaUpLeft))then
				if(this.tab.cursor.jogador == 2)then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x-1,y=y-1,p=peca}
				end
			elseif(pecaUpLeft.jogador ~= this.tab.cursor.jogador and x-1>0 and y-1>0)then
				if(not(this.tab:TemJogada(x-2,y-2)) and not(this.tab:TemPeca(x-2,y-2)))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x-2,y=y-2,come=pecaUpLeft,p=peca}
				end
			end
		end
		if(xMenosqueMax)then
			local pecaUpRight = this.tab:TemPeca(x+1,y-1)
			if(not(pecaUpRight))then
				if((this.tab.cursor.jogador == 1 and ORIENTACAO)or(this.tab.cursor.jogador == 2 and not(ORIENTACAO)))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x+1,y=y-1,p=peca}
				end
			elseif(pecaUpRight.jogador ~= this.tab.cursor.jogador and x+1<7 and y-1>0)then
				if(not(this.tab:TemJogada(x+2,y-2)) and not(this.tab:TemPeca(x+2,y-2)))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x+2,y=y-2,come=pecaUpRight,p=peca}
				end
			end
		end
	end

	if(yMenosqueMax)then
		if(xMaiorqueZero)then
			local pecaDownLeft = this.tab:TemPeca(x-1,y+1)
			if(not(pecaDownLeft))then
				if((this.tab.cursor.jogador == 2 and ORIENTACAO)or(this.tab.cursor.jogador == 1 and not(ORIENTACAO)))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x-1,y=y+1,p=peca}
				end
			elseif(pecaDownLeft.jogador ~= this.tab.cursor.jogador and x-1>0 and y+1<7)then
				if(not(this.tab:TemJogada(x-2,y+2)) and not(this.tab:TemPeca(x-2,y+2)))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x-2,y=y+2,come=pecaDownLeft,p=peca}
				end
			end
		end
		if(xMenosqueMax)then
			local pecaDownRight = this.tab:TemPeca(x+1,y+1)
			--print('opcao 4',pecaDownRight)
			if(pecaDownRight == nil)then
				if(this.tab.cursor.jogador == 1)then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x+1,y=y+1,p=peca}
				end
			elseif(pecaDownRight.jogador ~= this.tab.cursor.jogador and x+1<7 and y+1<7)then
				if(not(this.tab:TemJogada(x+2,y+2)) and not(this.tab:TemPeca(x+2,y+2)))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=x+2,y=y+2,come=pecaDownRight,p=peca}
				end
			end
		end
	end
end
pecaTabuleiro.Jogada[2] = function(this)
	local yMaiorqueZero
	local xMaiorqueZero
	local yMenosqueMax
	local xMenosqueMax
	local peca = this
	local x=this.posicao.x
	local y=this.posicao.y

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
	this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=this.tab.cursor.posicao.x,y=this.tab.cursor.posicao.y,noMove=true,p=peca}

	local yLoc
	local jogadaValida
	if(yMaiorqueZero)then
		if(xMaiorqueZero)then
			yLoc = y
			local linhaDama = {}
			for xLoc=x-1 ,0,-1 do
				yLoc = yLoc-1
				local pecaUpLeft = this.tab:TemPeca(xLoc,yLoc)
				if(not(pecaUpLeft))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,p=peca}
				else
					if(pecaUpLeft.jogador ~= this.tab.cursor.jogador and xLoc>0 and yLoc>0 and not(this.tab:TemJogada(xLoc-1,yLoc-1)) and not(this.tab:TemPeca(xLoc-1,yLoc-1)))then
						this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=xLoc-1,y=yLoc-1,come=pecaUpLeft,p=peca}
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
				local pecaUpRight = this.tab:TemPeca(xLoc,yLoc)
				if(not(pecaUpRight))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,p=peca}
				else
					if(pecaUpRight.jogador ~= this.tab.cursor.jogador and xLoc<7 and yLoc>0 and not(this.tab:TemJogada(xLoc+1,yLoc-1)) and not(this.tab:TemPeca(xLoc+1,yLoc-1)))then
						this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=xLoc+1,y=yLoc-1,come=pecaUpRight,p=peca}
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
				local pecaDownLeft = this.tab:TemPeca(xLoc,yLoc)
				if(not(pecaDownLeft))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,p=peca}
				else
					if(pecaDownLeft.jogador ~= this.tab.cursor.jogador and xLoc>0 and yLoc<7 and not(this.tab:TemJogada(xLoc-1,yLoc+1)) and not(this.tab:TemPeca(xLoc-1,yLoc+1)))then
						this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=xLoc-1,y=yLoc+1,come=pecaDownLeft,p=peca}
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
				local pecaDownRight = this.tab:TemPeca(xLoc,yLoc)
				if(not(pecaDownRight))then
					this.tab.blocosJogadas[#this.tab.blocosJogadas+1] = {x=xLoc,y=yLoc,p=peca}
				else
					if(pecaDownRight.jogador ~= this.tab.cursor.jogador and xLoc<7 and yLoc<7 and not(this.tab:TemJogada(xLoc+1,yLoc+1)) and not(this.tab:TemPeca(xLoc+1,yLoc+1)))then
						this.tab.blocosJogadas[#this.tab.blocosJogadas+1] ={x=xLoc+1,y=yLoc+1,come=pecaDownRight,p=peca}
					end
					break
				end
			end
		end
	end
end

pecaTabuleiro.Novo = function (this,Posicao,Jogador,Tipo,Tabuleiro)
	local this = {posicao=Posicao,jogador=Jogador,tipo=Tipo,viva=true,tab=Tabuleiro}
	if(ANIMACAO)then
		this.frame = 10
	end
	this.Desenhar = function(this,bloco)
		if(this.viva)then
			canvas:compose(fundo.largura/2 +20 + ((this.posicao.y-this.posicao.x) * (bloco.largura/2)),
			fundo.altura/2-35 + ((this.posicao.x+this.posicao.y) * bloco.altura/4) -bloco.altura,
			pecaTabuleiro.FiguraPeca[this.tipo][this.jogador])
		else
			if(this.frame>0)then
				this.frame = this.frame -1
				--future implementation
			end
		end
	end
	this.MarcaJogada = pecaTabuleiro.Jogada[this.tipo]
	this.Promover = function(this)
		this.tipo = 2
		this.MarcaJogada = pecaTabuleiro.Jogada[this.tipo]
	end
	this.Move = function(this,x,y)
		this.posicao.x,this.posicao.y = x,y
	end

	return this
end
