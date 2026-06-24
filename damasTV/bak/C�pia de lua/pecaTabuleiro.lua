require 'constantes'
require 'fundo'

pecaTabuleiro= {}

pecaTabuleiro.FiguraPeca = {{canvas:new('imagens/pecas/peca'..JOGADOR1..'.gif'),canvas:new('imagens/pecas/peca'..JOGADOR2..'.gif')},{canvas:new('imagens/pecas/peca'..JOGADOR1..'d.gif'),canvas:new('imagens/pecas/peca'..JOGADOR2..'d.gif')}}

pecaTabuleiro.Tamanho = {{pecaTabuleiro.FiguraPeca[1][1]:attrSize()},{pecaTabuleiro.FiguraPeca[1][2]:attrSize()}}

pecaTabuleiro.Novo = function (this,Posicao,Jogador,Tipo)
	local self = {posicao=Posicao,jogador=Jogador,tipo=Tipo,viva=true}
	self.Desenhar = function(this)
		if(self.viva)then
			canvas:compose(fundo.largura/2 -20 + ((self.posicao.y-self.posicao.x) * (pecaTabuleiro.Tamanho[self.tipo][1]/2)),
			fundo.altura/2+55 + ((self.posicao.x+self.posicao.y) * (pecaTabuleiro.Tamanho[self.tipo][2]/4)) - ((pecaTabuleiro.Tamanho[self.tipo][2]/2) *(7/2))-(pecaTabuleiro.Tamanho[self.tipo][2]/2),
			pecaTabuleiro.FiguraPeca[self.tipo][self.jogador])
		end
	end
	return self
end
