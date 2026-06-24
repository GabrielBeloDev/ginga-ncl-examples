

local texto = {}

local indiceAtual = 1

local arrayAuxiliar = {{'a','b','c','A','B','C','1'},{'d','e','f','D','E','F','2'},{'g','h','i','G','H','I','3'},{'j','k','l','J','K','L','4'},{'m','n','o','M','N','O','5'},{'p','q','r','P','Q','R','6'},{'s','t','u','S','T','U','7'},{'v','w','x','V','W','X','8'},{'y','z','Y','Z','9','0',' '}}

local indiceRole = 1

local ultimoDoArray = 0

local moveRole = function()
	if(indiceRole < 7)then
		indiceRole = indiceRole + 1
	else
		indiceRole = 1
	end
end

Receber = function(input)
	local input = tonumber(input)
	if(input)then
		if(input>0)then
			if(input == ultimoDoArray)then
				moveRole()
				texto[indiceAtual] = arrayAuxiliar[input][indiceRole]
			else
				indiceRole = 1
				indiceAtual = indiceAtual + 1
				ultimoDoArray = input
				texto[indiceAtual] = arrayAuxiliar[input][indiceRole]
			end
		end
	end
end

ReceberTexto = function()
	local ret = ""
	for indice,obj in pairs(texto)do
		ret = ret .. obj
	end
	return ret
end

AlteraTexto = function(text)
	texto = {}
	for i = 1, string.len(text) do
		texto[#texto] = string.sub(text,i,i)
	end
end

MoverParaFrente = function()
	indiceAtual = indiceAtual + 1
	if(indiceAtual > #texto)then
		texto[indiceAtual] = " "
	end
end

MoverParaTras = function()
	indiceAtual = indiceAtual - 1
	if(indiceAtual < 1)then
		indiceAtual = 1
	end
end
