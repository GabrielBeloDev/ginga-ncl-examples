---NCLua Tweet - Cliente de Twitter para TV Digital v0.5<br/>
--http://manoelcampos.com
--Reference: http://apiwiki.twitter.com/<p/>
--Licença: <a href="http://creativecommons.org/licenses/by-nc-sa/2.5/br/">http://creativecommons.org/licenses/by-nc-sa/2.5/br/</a>
--@author Manoel Campos da Silva Filho

require "util"
require "http"
dofile("Twitter.lua")
dofile("Entities2AccentedChars.lua")

--Interface gráfica--------
dofile("SendTweet.lua")
dofile("ShowTweets.lua")
dofile("Retweet.lua")
---------------------------


---Tabela com as variáveis usadas pelo main.lua   
local main = {
	--"Enumeration" que representa o tipo de conteúdo sendo
	--obtido do twitter: se está obtendo o timeline do usuário
	--conectado, de um outro usuário, etc.  
	pages = {
	  homeTimeline = 1,
	  userTimeline = 2,
	  sendTweet = 3, 
	},
	
    --Objeto da classe Twitter, que será instanciado
    --quando a aplicação NCL inicializa, disparando
    --um evento para o script lua. 
    twitter = nil,

	--Indica qual a página atual sendo exibida.
	--O valor inicial é pages.homeTimeline, para indicar que,
	--ao iniciar, a aplicação exibe o timeline do usuário conectado.
	activePage = 1, --pages.homeTimeline
}

---Desenha os botões (imagens) da aplicação
--@param fileNames Tabela contendo os nomes dos arquivos de imagens para os botões
function main:drawButtons(fileNames)
   --width e height do canvas
   local cw, ch = canvas:attrSize()
   local x, y, bw, bh = 4, 0, 0, 0
   local img = false
	 
   for k, v in pairs(fileNames) do
	   img = canvas:new("media/"..v)
	   bw, bh = img:attrSize()	   
	   y = ch-(bh+4)
	   canvas:compose(x, ch-(bh+4), img)
	   x = x + bw
   end
end

---Apaga toda a interface da aplicação e exibe apenas
--a mensagem passada por parâmetro
--@param msg Mensagem a ser mostrada na tela.
function main:fullScreenMsg(msg)
  canvas:attrColor("white")
  local w, h = canvas:attrSize()
  h = height or h
  canvas:drawRect("fill", 0, 0, w, h)
  canvas:attrFont("vera", 24)
  canvas:attrColor("blue")
  util.paintBreakedString(w-10, 10, 0, msg)
  canvas:flush()
end

---Função tratadora de eventos
--@param evt Tabela contendo dados sobre o evento disparado
function main.handler(evt)
   print(evt.class, evt.type, evt.action or "")
   
   if (evt.class == 'key' and evt.type == 'press') then
         if evt.key == "CURSOR_RIGHT" and 
         main.activePage ~= main.pages.sendTweet then
            ShowTweets:moveItemIndex(true)
            ShowTweets:drawTweet()
         elseif evt.key == "CURSOR_LEFT" and
         main.activePage ~= main.pages.sendTweet then
            ShowTweets:moveItemIndex(false)
            ShowTweets:drawTweet()
         elseif evt.key == "ENTER" then
            if (main.activePage == main.pages.homeTimeline) 
            and (ShowTweets.itemIndex > 0) then
		       main:fullScreenMsg(
		          "Buscando mensagens do usuário selecionado, aguarde...")          
               local userId = ShowTweets:getTweetUserId()
               ShowTweets:clearVars()

               main.activePage = main.pages.userTimeline 		   
		       --Envia requisição para obter o timeline do usuário.
		       --As credenciais do mesmo são definidas no arquivo de configuração
		       --twitter.config.lua.
		       main.twitter:userTimeline(
		          ShowTweets.initTweetsInterfaceCallback, userId)
		    elseif main.activePage == main.pages.sendTweet then
		       SendTweet:send(main)
            end
         elseif evt.key == "YELLOW" or evt.key == "Y" or evt.key == "y" then
            if main.activePage == main.pages.homeTimeline then
               ShowTweets:cancelTimer() 
               SendTweet:paint(main)                 
            elseif main.activePage == main.pages.userTimeline then
               ShowTweets:startHomeTimeline()
            elseif main.activePage == main.pages.sendTweet then
               SendTweet:back(main)
               ShowTweets:drawTweet() 
            end
         elseif evt.key == "GREEN" or evt.key == "G" or evt.key == "g" 
         and main.activePage ~= main.pages.sendTweet then
            ShowTweets:cancelTimer() 
            --Obtém o username do usuário da mensagem atual,
            --para o qual o reply será enviado.
            local replyUserName = ShowTweets:getTweetUserName()
            SendTweet:paint(main, replyUserName)                 
         elseif evt.key == "BLUE" or evt.key == "B" or evt.key == "b" then
            Retweet:send(main)
         end
      
         return 
   end
   
   if evt.class == "ncl" and evt.type == "presentation" and evt.action=="start" then
      --Instancia objeto da classe Twitter
      main.twitter = Twitter:new()
      ShowTweets:init(main)
      --Inicia requisição para obter as mensagens do usuário conectado
      ShowTweets:startHomeTimeline()     
   end
end

--Registra a função handler como tratadora de eventos.
event.register(main.handler)
