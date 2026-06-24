

LARGURA, ALTURA = canvas:attrSize()


function DesenharFundo(figura)
	canvas:compose(0,0,canvas:new(figura))
end


function LimpaTela(self)
	canvas:attrColor('white')
	canvas:drawRect('fill',0,0,LARGURA,ALTURA)
end

