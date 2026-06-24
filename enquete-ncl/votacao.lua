require "compat"  -- restaura module()/setfenv() do Lua 5.1 (ver compat.lua)
---Sistema de enquete para TV Digital<br/>
---Sistema de enquete para TV Digital.
---Esta versão envio o voto a uma página PHP
---e obtém um código lua como retorno, gerado
---pelo PHP. O código lua é executado
---e cria uma table contendo os dados da votação.
---Com isto a aplicação NCLua pode acessar os dados
---de forma estrutura e formatar sua exibição
---da maneira que desejar.<br/>
---@author Manoel Campos da Silva Filho<br/>
---http://manoelcampos.com<br/>

--Usa o arquivo tcp.lua disponível no diretório atual
require 'tcp'

---Seta o valor de uma propriedade do nó lua atual
--@param propName Nome da propriedade do nó lua a ser setada
--@param propValue Valor a ser atribuído à propriedade
function setLuaPropertie(propName, propValue)
    local evt = {
        class = 'ncl',
        type  = 'attribution',
        name  = propName,
        value = propValue, 
    }
    
    --Para que o documento NCL perceba a atribuição
    --de um valor a uma propriedade do nó lua,
    --deve-se disparar o evento dando um start
    --e depois um stop. Isto só é necessário
    --em casos de atribuição. 
    evt.action = 'start'; event.post(evt)
    evt.action = 'stop' ; event.post(evt)
end 

---Escreve um texto na tela
--@param text Texto a ser escrito
function writeText(text)
   --canvas:attrColor("black")
   --canvas:drawRect("fill", 0,0, canvas:attrSize())
	--RGBA: Red, Blue, Green, Alpha (0=transparente total .. 255=opaco total)
	
   canvas:attrColor(255,255,255,0)
   canvas:clear()
   
   canvas:attrFont("vera", 24)
   canvas:drawText(10, 5, text)
   canvas:flush()
end

---Exibe o resultado da votação na tela
--@param votos Tabela retornada pela página php
--contendo o resultado da votação
function writeResult(votos) 
   canvas:attrColor(255,255,255,0)
   canvas:clear()
   
   canvas:attrFont("vera", 24)
   canvas:drawText(10, 5, "Sim: "..votos.sim)
   canvas:drawText(10, 30, "Não: "..votos.nao)
   canvas:drawText(10, 55, votos.url)
   canvas:flush()
end

---Função tratadora de eventos disparados pelo documento NCL
--@param evt Tabela que armazena as propriedades do evento disparado.
function handler (evt)
    --Se está iniciando a apresentação NCL,
    --escreve o título da pergunta na tela.
	if evt.class == 'ncl' and evt.type == 'presentation' 
    and evt.action == 'start' then
       writeText("Você é a favor da doação de órgãos?")
    end 
	
	--Só executa o código após esse if se o evento
	--atual tiver sido disparado pela atribuição
	--de um valor à propriedade "voto" do nó lua
	--a partir do documento NCL.
	if evt.class ~= 'ncl' or evt.type ~= 'attribution' 
    or evt.action ~= 'start' or evt.name ~= 'voto' then 
       return 
    end
    
    local host = "manoelcampos.com"
    
    print(evt.name, evt.value)
    
    tcp.execute(
        function ()
            writeText("Obtendo resultado. Por favor, aguarde...")
            tcp.connect(host, 80)
            --conecta no servidor
            print("Conectado a "..host)
            
            local url = "GET http://"..host.."/votacao/votacao2.php?voto="..evt.value.."\n"
            print("URL: "..url)
            --envia uma requisição HTTP para gravar voto no servidor remoto
            tcp.send(url)
           	
           	--obtém todo o conteúdo da página acessada
            local result = tcp.receive("*a")
            if result then
            	print("Dados da conexao TCP recebidos")
            	--obtem o resultado da página php acessada,
            	--que retorna um código lua contendo
            	--a criação de uma tabela com o
            	--resultado da votação		    	
		        f = loadstring(result)
		        --se o código lua retornado pela página php foi
		        --compilado, executa o mesmo. Neste momento,
		        --a tabela votos = { sim, nao, url } será criada
		        --contados o total de votos sim, o total de não
		        --e o domínio do meu site   
				if f then 
				   f()
				   writeResult(votos)
			       
			       --Após ter sido feito a requisição para contabilizar o voto
			       --e exibido o resultado,
			       --deve-se notificar o documento NCL para que ele
			       --interrompa o nó lua para que o resultado não  
			       --seja mais apresentado.
			       --Para isso, é gerado um evento do tipo
			       --atributtion, atribuindo um valor qualquer
			       --à propriedade result do nó lua atual.
			       setLuaPropertie("result", 1)
				end
		    else
            	print("Erro ao receber dados da conexao TCP")
            	if evt.error ~= nil then 
		        	result = 'error: ' .. evt.error
		        end
	        end
	        
            tcp.disconnect()
        end
    )
end

--Registra a função handler para capturar os eventos
--disparados pelo documento NCL.
event.register(handler)
