require "libCity"

--Função para desenhar a tela padrão para seleção de ítens.
function desenharTela()

	local img = canvas:new('midias/data/layout1.gif')
	canvas:compose(0, 0, img)

	
	canvas:flush()
end

--Função para apresentar a relação de regiões.
function printRegiao()

	local _posicaoLinha = 157
	
	--Apresentação do titulo da tela
	canvas:attrColor(167, 5, 0, 255)
	canvas:attrFont('vera', 20)
	local vTexto = 'Pressione no controle o número'
	local vLarguraTxt = canvas:measureText(vTexto)
	canvas:drawText((DX - vLarguraTxt)/2, _posicaoLinha, vTexto)
	
	local _posicaoLinha = 183
	local vTexto = 'da região onde fica a sua capital:'
	local vLarguraTxt = canvas:measureText(vTexto)
	canvas:drawText((DX - vLarguraTxt)/2, _posicaoLinha, vTexto)

	--Apresentação das regiões
	canvas:attrColor(0, 0, 0, 255)
	canvas:attrFont('vera', 20)
	_posicaoLinha = 241
	for i=1,table.maxn(tbRegioes) do
		
		local img = canvas:new('midias/data/select.jpg')
		canvas:compose(32, _posicaoLinha, img)
		
		canvas:drawText(42, _posicaoLinha + 15, i .. ' - ' .. tbRegioes[i])
		_posicaoLinha = _posicaoLinha + 72
		
	end
	
	canvas:flush()
end

--Apresentação da relação de estados de acordo com a região selecionada e a 
--página atual que por padrão é 1.
function printEstados( pPages , pEstado )

	local _posicaoLinha = 157
	
	--Apresentação do título da tela
	canvas:attrColor(167, 5, 0, 255)
	canvas:attrFont('vera', 20)
	local vTexto = 'Pressione no controle o número'
	local vLarguraTxt = canvas:measureText(vTexto)
	canvas:drawText((DX - vLarguraTxt)/2, _posicaoLinha, vTexto)
	
	local _posicaoLinha = 183
	local vTexto = 'do estado onde fica a sua capital:'
	local vLarguraTxt = canvas:measureText(vTexto)
	canvas:drawText((DX - vLarguraTxt)/2, _posicaoLinha, vTexto)

	--Verifica o total de páginas para a impressão dos estados
	_TotalPage = math.ceil (table.maxn(tbEstados[tonumber(pEstado)])/cItens)
	_limiteInferior = (pPages * cItens) - cItens + 1 --Determina o primeiro ítem a ser impresso
	
	--Determina o último ítem a ser impresso
	_TotalItens = table.maxn(tbEstados[tonumber(pEstado)])
	if (_page * 5) > _TotalItens then
		_limiteSuperior = table.maxn(tbEstados[tonumber(pEstado)])
	else
		_limiteSuperior = _page * 5
	end
	
	--Apresenta a relação de estados para a região e página informados
	canvas:attrColor(0, 0, 0, 255)
	canvas:attrFont('vera', 20)
	_posicaoLinha = 241
	j = 0
	for i=_limiteInferior, _limiteSuperior do
		
		local img = canvas:new('midias/data/select.jpg')
		canvas:compose(32, _posicaoLinha, img)
		
		j = j + 1
		local vEstado = j .. ' - ' .. tbEstados[tonumber(pEstado)][i] .. ' - ' ..	tbCapitais[tbEstados[tonumber(pEstado)][i]][1]
		
		canvas:drawText(42, _posicaoLinha + 15, vEstado)
		_posicaoLinha = _posicaoLinha + 72

	end
	
	--Apresenta o indicador da página
	canvas:attrColor(0, 52, 154, 255)
	canvas:attrFont('vera', 16)
	_posicaoLinha = _posicaoLinha - 7
	local vTexto = 'Página ' .. _page .. ' de ' .. _TotalPage
	canvas:drawText( 32, _posicaoLinha, vTexto)	
	
	canvas:flush()
end

--Apresenta a previsão do tempo para o estado informado
function printPrevisao( pRegiao , pEstado )
	
	--Altera a imagem de fundo
	local img = canvas:new('midias/data/layout2.gif')
	canvas:compose(0, 0, img)
	
	--Consulta o webservice e trata as informações
	local tblDados = getPrevisao( tbCapitais[tbEstados[tonumber(pRegiao)][tonumber(pEstado)]][3] )
	
	if tblDados == 'ERROR -1' or tblDados == nil then
	
		--Apresenta mensagem de erro
		local vErro = 'Não foi possível apresentar'
		canvas:attrColor(42, 23, 116, 255)
		canvas:attrFont('vera', 16)
		local vLarguraTxt = canvas:measureText(vErro)
		canvas:drawText((DX - vLarguraTxt)/2, 186, vErro)
		
		local vErro = 'os dados solicitados'
		canvas:attrColor(42, 23, 116, 255)
		canvas:attrFont('vera', 16)
		local vLarguraTxt = canvas:measureText(vErro)
		canvas:drawText((DX - vLarguraTxt)/2, 207, vErro)
	
	else
	
		--Apresenta o nome da cidade solicitada e o país
		canvas:attrColor(42, 23, 116, 255)
		canvas:attrFont('vera', 26)
		local vLarguraTxt = canvas:measureText(tblDados['city'])
		canvas:drawText((DX - vLarguraTxt)/2, 186, tblDados['city'])
		
		--Apresenta a temperatura
		canvas:attrFont('vera', 30)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(60, 260, tblDados['temp'])
		
		--Apresenta o ícone relacionado a previsão do tempo
		img = canvas:new(tblDados['icon'])
		canvas:compose(256, 250, img)
		
		canvas:attrFont('vera', 20)
		
		--Apresentação da umidade
		local vLabel = 'Umidade: '
		canvas:attrColor(40, 14, 167, 255)
		canvas:drawText(52, 355, vLabel)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(52 + canvas:measureText(vLabel), 355, tblDados['hmid'])
		
		--Apresentação do vento
		local vLabel = 'Vento: '
		canvas:attrColor(40, 14, 167, 255)
		canvas:drawText(52, 403, vLabel)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(52 + canvas:measureText(vLabel), 403, tblDados['wind'])
		
		--Apresentação do índice UV
		local vLabel = 'Índice UV: '
		canvas:attrColor(40, 14, 167, 255)
		canvas:drawText(52, 451, vLabel)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(52 + canvas:measureText(vLabel), 451, tblDados['uv'])
		
		--Apresentação da sensação térmica
		local vLabel = 'Sensação Térmica: '
		canvas:attrColor(40, 14, 167, 255)
		canvas:drawText(52, 499, vLabel)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(52 + canvas:measureText(vLabel), 499, tblDados['flik']) 

		--Apresentação do nascente
		local vLabel = 'Nascente: '
		canvas:attrColor(40, 14, 167, 255)
		canvas:drawText(52, 540, vLabel)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(52 + canvas:measureText(vLabel), 540, tblDados['sunr'])
		
		--Apresentação do poente
		local vLabel = 'Poente: '
		canvas:attrColor(40, 14, 167, 255)
		canvas:drawText(52, 581, vLabel)
		canvas:attrColor(0, 0, 0, 255)
		canvas:drawText(52 + canvas:measureText(vLabel), 581, tblDados['suns'])

	end
	
	canvas:flush()
end

function getPrevisao( pCodCity )

	local _tbl = {}
	local _package = consultarServico( 'SOCKET' , pCodCity )
	
	if _package == 'ERROR -1' then
	
		_tbl = nil
		_tbl = _package
		
	else
	
		--Conversão do XML em Lua Table
		require 'xmlparser'
		local _xml = collect(_package)
		
		--Alocação manual dos dados significativos 
		--Tratamento dos dados para apresentação
		status, erro = pcall(function() _tbl['city'] = _xml[2][2][1][1] end)
		if status == false then _tbl['city'] = 'N/A' end
		
		status, erro = pcall(function() _tbl['temp'] = _xml[2][3][3][1] end)
		if status == false then 
			_tbl['temp'] = 'N/A'
		else
			_tbl['temp'] = _tbl['temp'] .. '° C'
		end
		
		status, erro = pcall(function() _tbl['icon'] = _xml[2][3][6][1] end)
		if status == false then 
			_tbl['icon'] = 'midias/icon/25.png'
		else
			if tonumber(_tbl['icon']) > 0 and tonumber(_tbl['icon']) < 10 then
				_tbl['icon'] = '0' .. _tbl['icon']
			end
			_tbl['icon'] = 'midias/icon/' .. _tbl['icon'] .. '.png'
		end
		
		status, erro = pcall(function() _tbl['hmid'] = _xml[2][3][9][1] end)
		if status == false then 
			_tbl['hmid'] = 'N/A'
		else
			_tbl['hmid'] = _tbl['hmid'] .. '%'
		end
		
		status, erro = pcall(function() _tbl['wind'] = _xml[2][3][8][1][1] end)
		if status == false then 
			_tbl['wind'] = 'N/A'
		else
			_tbl['wind'] = _tbl['wind'] .. ' km/h'
		end
		
		status, erro = pcall(function() _tbl['uv'] = _xml[2][3][11][1][1] end)
		if status == false then 
			_tbl['uv'] = 'N/A'
		else
			print(tonumber(_tbl['uv']))
			status, erro = pcall(function() _tbl['uv'] = tonumber(_tbl['uv']) end)
			if status == false then
				_tbl['uv'] = 'N/A'
			else
				if _tbl['uv'] == nil then
					_tbl['uv'] = 'N/A'
				else
					if tonumber(_tbl['uv']) >= 0 and tonumber(_tbl['uv']) <= 2 then
						_tbl['uv'] = _tbl['uv'] .. ' - Baixo'
					elseif tonumber(_tbl['uv']) >= 3 and tonumber(_tbl['uv']) <= 5 then
						_tbl['uv'] = _tbl['uv'] .. ' - Moderado'
					elseif tonumber(_tbl['uv']) >= 6 and tonumber(_tbl['uv']) <= 7 then
						_tbl['uv'] = _tbl['uv'] .. ' - Alto'
					elseif tonumber(_tbl['uv']) >= 8 and tonumber(_tbl['uv']) <= 10 then
						_tbl['uv'] = _tbl['uv'] .. ' - Muito Alto'
					elseif tonumber(_tbl['uv']) >= 11 then
						_tbl['uv'] = _tbl['uv'] .. ' - Extremo'
					end
				end
			end
		end
		
		status, erro = pcall(function() _tbl['flik'] = _xml[2][3][4][1] end)
		if status == false then 
			_tbl['flik'] = 'N/A'
		else
			_tbl['flik'] = _tbl['flik'] .. '° C'
		end
		
		status, erro = pcall(function() _tbl['sunr'] = _xml[2][2][5][1] end)
		if status == false then 
			_tbl['sunr'] = 'N/A'
		end
		
		status, erro = pcall(function() _tbl['suns'] = _xml[2][2][6][1] end)
		if status == false then 
			_tbl['suns'] = 'N/A'
		end

	end
	
	return _tbl
end 

--Consulta ao webservice
--Esta função foi criada pois não foi possível acessar pelo TCP do Ginga.
function consultarServico( pConexao , pCity )

	local _package = nil
	
	if pConexao == 'TCP' then
	
		require 'tcp'
		tcp.execute(
			function ()
				tcp.connect('xoap.weather.com', 80)
				tcp.send('GET /weather/local/'.. pCity ..'?cc=*&unit=m&dayf=0&prod=xoap&par=1150721602&key=3f7b7eb86ffe6fd9\n')
				_package = tcp.receive()
				tcp.disconnect()
			end
		)

	elseif pConexao == 'SOCKET' then

		http = require('socket.http')
		local _Endereco = '/weather/local/'.. pCity ..'?cc=*&unit=m&dayf=0&prod=xoap&par=1150721602&key=3f7b7eb86ffe6fd9'
		_package = http.request('http://xoap.weather.com'.._Endereco)
	
	else
	
		_package = 'ERROR -1'
	
	end
	
	if _package == nil then
		_package = 'ERROR -1'
	end
	
	return _package
	
end 
