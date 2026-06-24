fundo = {}


fundo.largura, fundo.altura = canvas:attrSize()


fundo.DesenharFundo = function(this,fundo)
	canvas:compose(0,0,canvas:new(fundo))
end


fundo.Desenhar = function(this)
	canvas:attrColor('white')
	canvas:drawRect('fill',0,0,this.largura,this.altura)
end

