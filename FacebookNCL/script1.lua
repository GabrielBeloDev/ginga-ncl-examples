-- @author Thiago Nunes - thiagonunes.tns@gmail.com
-- @author Marcio Fraga - marcior.mfraga@gmail.com
-- @author Victor Muniz - munizcp@hotmail.com


-- Lista de possíveis perfis para serem visualizados
-- ComunidadeBrasil
-- maranhao.br
-- PHP
-- FacebookBrasil
-- ScrapMTV

require 'tcp'
require 'json'
require 'http'

local index = 1 		--variável que representa que feed da matriz está sendo mostrado
local feedsCount = 0	--variável que guarda a quantidade de feeds na matriz
local stopTimer			--variável que guarda uma função que para o timer atual

local feedsLimit = 7	--quantidade de feeds que devem ser recuperdados do facebook
local timeToRead = 7000	--tempo em milisegundos que cada feed fica na tela

local tempFileName = "tempIDFields.txt"	-- nome do arquivo temporário que contém informações do perfil do usuário

local facebookUserID = "maranhao.br"	--id ou username do perfil do Facebook que serão mostrados os feeds
local feedsFileName = "feed.txt"	--variável que guarda o nome do arquivo que contém os feeds

local dados				-- tabela que guarda os feeds 

------------ ## Métodos que manipulam a lista de feeds ## --------------

-- pega a lista de feeds do perfil e guarda na tabela "dados"
-- executado em uma co-rotina
local function getFeedList(url)

	print("----- ## Carregando Feeds!!")
	if http.getFile(url, feedsFileName) then
		print("----- ## Arquivo de feeds criado!!")
		readFeedsFile()	    
	else
		print("----- ## ERRO ao salvar o arquivo de feeds!!")
	end
end

function readFeedsFile()
	file, err = io.open(feedsFileName)
	if file == nil then
    	print("----- ## Erro ao abrir arquivo "..feedsFileName)
    	return false
    else
    	t = file:read("*all")
    	file:close()
    	
    	dados = json.decode(t)
    	
    	feedsCount = #dados.data
		
		print("----- ## Feeds Carregados com sucesso!!")	
		
		handler({class  = 'ncl',
			 type   = 'presentation',
			 action = 'start'}
			)
    	
    end
end


----------------------------------------------------------------------------------

------------ ## Métodos que tratam a imagem do perfil do usuário ## --------------

-- faz download da imagem do perfil do usuário que fez o post no mural
-- executado em uma co-rotina
-- @param id do perfil do usuário
-- @param feedIndex índice que representa o feed deste usuário mostrado na tela
function getProfileImage( id, feedIndex )

	local urlIDFields = "graph.facebook.com/" .. id .. "/?fields=picture"
	
	-- pega as informações sobre o perfil do id passado como parâmetro
	-- salva no arquivo tempIDFields.txt
	if http.getFile( urlIDFields, tempFileName ) then
	
		print("----- ## Realizou o download dos dados do usuario")
		readTempProfileInfoFile( id, feedIndex )
	
	else
		print("----- ## ERRO ao salvar o arquivo dos dados do usuário!!")
	end
	
end

-- faz a manipulação do arquivo temporário que contém as informações
-- do usuário que fez o post e faz o download da imagem do seu perfil
-- @param id do perfil do usuário
-- @param feedIndex índice que representa o feed deste usuário mostrado na tela
function readTempProfileInfoFile( id, feedIndex )
		file, err = io.open( tempFileName )
		if file == nil then
	    	print("----- ## Erro ao abrir arquivo "..tempFileName.. "\n")
	    	return false
	    else
	    	print("----- ## Arquivo" .. tempFileName .. " aberto com sucesso")
	    	
	    	t = file:read("*all")
	    	file:close()
	    	
	    	profile = json.decode(t)
			
			urlProfileImage = profile['picture'];
			tam = #urlProfileImage
			print(urlProfileImage)
			localfile = id .. string.sub( urlProfileImage, tam-3 )
			
			print("----- ## localfile = " .. localfile )
			
			-- o arquivo não existe, será baixado
			print("---- ## Iniciando o download da imagem...")
			util.coroutineCreate( getImage, urlProfileImage, localfile, feedIndex )
				    	
	        return true
	    end
		

end

-- faz o download de uma imagem e a mostra na tela, caso o feed que esteja sendo exibido
-- seja tenha o mesmo índice do feedIndex passado como parâmetro
-- @param imageURL url da imagem a ser baixada
-- @param localFileName nome do arquivo que deve ser salva a imagem baixada
-- @param feedIndex índice que representa o feed deste usuário mostrado na tela
function getImage( imageUrl, localFileName, feedIndex )
	if http.getFile( imageUrl, localFileName ) then
		print("----- ## Download de " .. tempFileName .. " concluído!")
		
		-- testa se o feed que está sendo mostrado ainda corresponde à imagem baixada
		if index == feedIndex then
			draw( dados.data[feedIndex] )
		end
		
	else
		print("----- ## Erro ao realizar o Download de " .. tempFileName)
	end
end


----------------------------------------------------------------------------------

function getDados()
	util.coroutineCreate(getFeedList, "graph.facebook.com/" .. facebookUserID .. "/feed?limit=" .. feedsLimit)
end

function limpar()

	dx, dy = canvas:attrSize()
	dx = dx
	dy = dy 
	canvas:attrColor(36,116,214,0)
	canvas:drawRect('fill', 10, 10,dx,dy)

end

function drawLoading()
	
	limpar()
	
	canvas:attrColor('white')
	canvas:attrFont('vera', 20, 'bold')
	canvas:drawText(10, 10, 'Carregando...' ) 
	canvas:flush()
	   	
end

function draw(feed)
	
	if feed == nil then print("passou nil") return end
	
	limpar()
	
	
	img = canvas:new('media/default_image.png')

	localfile = feed.from.id .. ".jpg"
	
	-- verifica se o arquivo já foi baixado anteriormente
	local test = io.open(localfile)
	if test then
		--o arquivo já existe 
		io.close(test)
		print("---- ## A imagem já foi baixada anteriormente")
		img = canvas:new(localfile)	
	
	else
		-- o arquivo não existe, será baixado
		print("---- ## Iniciando o download da imagem...")
		util.coroutineCreate(getProfileImage,feed.from.id,index)
	end


	dx, dy = img:attrSize()
	
	canvas:attrColor(5,5,5,255)
	canvas:drawRect('fill', 10, 10,dx,dy)
	
	foto = { img=img, x=10, y=10, dx=dx, dy=dy }
	canvas:compose(foto.x, foto.y, foto.img)
	
	tempx = dx + foto.x + 5;
	tempy = foto.y; 
	
	canvas:attrColor('white')
	canvas:attrFont('vera', 18, 'bold')
	canvas:drawText(tempx, tempy, '['.. index ..'] '..feed.from.name ) 
	
	canvas:attrFont('vera', 16, 'bold')
	tempy = tempy + 3
	
	local linhas = breakString(feed.message, 45)
	
	for k,ln in pairs(linhas) do
		tempy = tempy + 12 + 3
		canvas:drawText(tempx, tempy, ln)
	end
	
	canvas:flush()   

end

local ignore = false

function handler (evt)

	print("-- passando")
	
	if evt.action == 'stop' then
		print("-- STOP")
		--para o timer ativo
		stopTimer()
    	return
	end

	if ignore == false then
		getDados()
		index = 1
		ignore = true
	end
	
	if feedsCount > 0 then 
		print("tem feeds") 
	else
		print("nao tem feeds")
		drawLoading()
		return
	end

	if evt.type == 'attribution' then 
	
		if evt.name == "ignore" then 
			ignore = false
			feedsCount = 0
			dados = {data = {}}  
			return 
		end
	
		index = index + evt.value
		
		if index > feedsCount then index = 1 end
		if index < 1 then index = feedsCount end
		
		--para o timer ativo
		stopTimer()
		
		--desenha na tela
		draw(dados.data[index])
		
		--se chama como um evento de presentation
		handler({class  = 'ncl',
    			 type   = 'presentation',
    			 action = 'start'}
    			)
		return 
	end

	if evt.type == 'presentation' and evt.action == 'start' then 
	
	    if index < (feedsCount + 1) then
	    		    	
	    	--desenha na tela
	    	draw(dados.data[index])
	    	
    		--inicia um timer e guarda a função para pará-lo
	    	--ao fim do timer, se chama recursivamente
			stopTimer = event.timer(timeToRead, function()
				index = index + 1 	
		    	handler(evt)
		    end)
    	
	    	
		else
		    index = 1
		    handler(evt)	
	    end
	end
end

event.register(handler)



-- Métodos do util
-- pego emprestado da aplicação de leitura de rss
function breakString(str, maxLineSize)
  local t = {}
  local i, fim, countLns = 1, 0, 0

  if (str == nil) or (str == "") then
     return t
  end 

  str = string.gsub(str, "\n", " ")
  str = string.gsub(str, "\r", " ")
    
  while i < #str do
     countLns = countLns + 1
     if i > #str then
        t[countLns] = str
        i = #str 
     else
        fim = i+maxLineSize-1
        if fim > #str then
           fim = #str
        else
	        --se o caracter onde a string deve ser quebrada
	        --não for um espaço, procura o próximo espaço
	        if string.byte(str, fim) ~= 32 then
	           fim = string.find(str, ' ', fim)
	           if fim == nil then
	              fim = #str
	           end
	        end
        end
        t[countLns]=string.sub(str, i, fim)
        i=fim+1
     end
  end
  
  return t
end

-- verifica se a tabela contém determinado elemento
-- @return true or false
function contains(table, element)
	for key,value in pairs(table) do 
		print(key,value)
		if value == element then return true end
	end
  	return false
end

