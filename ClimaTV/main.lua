require 'app'
dofile ('controle.lua')


--Variáveis
DX, DY = canvas:attrSize()
_page = 1 --Paginação de ítens
cItens = 5 --Constante com a quantidade de ítens por página
if _Ctrl == nil then
	_Ctrl = 'Regiao' --Controle que indica a tela atual
	_Regiao, _Estado = nil --Variáveis para armazenar a região e o estado selecionado
end

desenharTela()
printRegiao()

function handler(evt)

	handlerControle( evt )

end

event.register ( handler )
