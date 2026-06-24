---Lua Twitter API em NCLua para TV Digital v0.3<br/>
--<a href="http://manoelcampos.com">http://manoelcampos.com</a><br/>
--Reference: http://apiwiki.twitter.com/
--@author Manoel Campos da Silva Filho

require "config"
require "http"
require "util"
dofile("Entities2AccentedChars.lua")
dofile("LuaXML/xml.lua")
dofile("LuaXML/handler.lua")


---Classe que implementa a API do Twitter
Twitter = {
  host = "api.twitter.com",
  host2 = "twitter.com",
  port = 80,
  format = "xml",
  userAgent = "NCLuaTwitt/0.2",
  user = "",
  password = ""
}

---Construtor da classe
--@param user_ Nome de usuário do Twitter. 
--Se não informado, será procurado o valor
--no arquivo de configuração.
--@param password_ Senha do usuário do Twitter.
--Se não informado, será procurado o valor
--no arquivo de configuração.
function Twitter:new(user_, password_)
  --Carrega o arquivo de configuração
  config.load("twitter.config.lua")
  local o = {
    user = user_ or config.getValue("user", ""), 
    password = password_  or config.getValue("password", "")
  }
  
  --print("auth",o.user, o.password)
  
  function o:__index(key)
  	return Twitter[key]
  end
  
  setmetatable(o, o)
  return o 
end

---Envia uma requisição HTTP para o servidor do Twitter para
--obter um retorno em XML, que é convertido para uma table lua.<br>
--@param url URL para onde enviar a requisição
--@param callback Função de callback a ser executada quando
--for obtido o retorno da requisição enviada ao servidor do Twitter.
--Esta função de callback deve, obrigatoriamente,
--conter um parâmetro que será a tabela lua gerada a partir
--do parser do XML obtido do servidor do Twitter.
--Quando o código XML for obtido do servidor,
--a função de callback será executada
--e receberá, nesse parâmetro, a tabela
--lua gerada a partir do XML recebido.
--Tal função pode, por exemplo,
--exibir a primeira mensagem contida na tabela lua
--recebida por parâmetro.
--@param method Método HTTP a ser usado. 
--Opcional: se não informado, tem valor padrão GET
function Twitter:getXml(url, callback, method)
   method = method or "GET"
   --Função que executa todo o código para envio
   --e tratamento da resposta da requisição.
   local function _getXml(_callback)
       --A função http.getXml só aguarda o retorno da requisição
       --HTTP para poder retornar, 
       --devido ter sido executada a partir de uma função
       --executada por uma co-rotina (a função getXml).
       --Se http.getXml for executada fora de uma função
       --chamada por uma co-rotina, a mesma retorna imediatamente,
       --sem a resposta da requisição HTTP.
       local response = 
              http.getXml(
                url, method, self.userAgent, 
                self.user, self.password)
       if response == nil then
          print("---------------response = nil")
          return nil
       end 

       --Converte códigos HTML para representação
       --de caracteres acentuados e especiais,
       --para seus respectivos caracteres,
       --para que apareça na tela o caractere acentuado
       --e não o seu código HTML.   
       response = ConvertString(response)
       ---Instancia o objeto que é responsável por
	   --armazenar o XML em forma de uma table lua
	   local xmlhandler = simpleTreeHandler()
       local xmlparser = xmlParser(xmlhandler)
       xmlparser:parse(response)
       
       --Após ter obtido a resposta da requisição HTTP, que conterá
       --o arquivo XML com as mensagens do timeline do usuário,
       --executa a função de callback, passando a ela,
       --uma tabela, gerada a partir do parser do código XML obtido.
       _callback(xmlhandler.root)
   end
  
   --Cria uma co-rotina para executar a função getXml.
   --callback representa a função recebida
   --por parâmetro e que será executada
   --quando a função getXml, a ser executada pela co-rotina
   --a ser criada, finalizar.
   util.coroutineCreate(_getXml, callback)
end

--------------Authentication


function Twitter:oAuth()
--[[
http://apiwiki.twitter.com/Sign-in-with-Twitter
http://apiwiki.twitter.com/Authentication

# Request token URL
http://twitter.com/oauth/request_token

# Access token URL
http://twitter.com/oauth/access_token

# Authorize URL
http://twitter.com/oauth/authorize
--]]
end

--------------Account

function Twitter:rateLimiteStatus()
  --Requires Authentication:
  --true, to determine a user's rate limit status
  --false, to determine the requesting IP's rate limit status
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-account%C2%A0rate_limit_status
end

---Ends the session of the authenticating user, returning a null cookie.  
--Use this method to sign users out of client-facing applications like widgets.
function Twitter:endSession()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-account%C2%A0end_session
end

--------------Favorites

function Twitter:favorites()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-favorites
end


---Favorites the status specified in the ID parameter as the authenticating user. 
--Returns the favorite status when successful.
function Twitter:favoritesCreate()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-favorites%C2%A0create
end

--------------Statuses

---Obtém o timeline do usuário autenticado pelo login e senha.<br>
--@param callback Função de callback a ser executada quando
--for obtido o retorno da requisição enviada ao servidor do Twitter.
--Esta função de callback deve, obrigatoriamente,
--conter um parâmetro que será a tabela lua gerada a partir
--do parser do XML obtido do servidor do Twitter.<br/>
--@see Twitter.getXml
--<a href="http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-home_timeline">Twitter API</a>
function Twitter:homeTimeline(callback)
   local url = self.host.."/1/statuses/home_timeline."..self.format
   
   self:getXml(url, callback)
end

function Twitter:friends()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0friends
end

---Obtém o timeline de um determinado usuário.<br>
--@param callback Função de callback a ser executada quando
--for obtido o retorno da requisição enviada ao servidor do Twitter.
--Esta função de callback deve, obrigatoriamente,
--conter um parâmetro que será a tabela lua gerada a partir
--do parser do XML obtido do servidor do Twitter.<p/>
--<a href="http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline">http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline</a>
--@param userNameOrUserId Nome ou ID do usuário que se deseja obter as mensagens do timeline.
--@see Twitter.getXml
function Twitter:userTimeline(callback, userNameOrUserId)
  --http://twitter.com/statuses/user_timeline/username.format
  --http://twitter.com/statuses/user_timeline/userId.format
   local url = self.host2.."/statuses/user_timeline/" .. userNameOrUserId .."."..self.format
   
   self:getXml(url, callback)  
end

function Twitter:mentions()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-mentions
end

function Twitter:followers()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0followers
end

---Retweeta uma mensagem
--@param callback Função de callback a ser executada quando
--for obtido o retorno da requisição enviada ao servidor do Twitter.
--Esta função de callback deve, obrigatoriamente,
--conter um parâmetro que será a tabela lua gerada a partir
--do parser do XML obtido do servidor do Twitter.<p/>
--<a href="http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-retweet">http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-retweet</a>
--@see Twitter.getXml
--@param tweetId Identificador do tweet a ser retweetado
function Twitter:retweet(callback, tweetId)
  --http://api.twitter.com/1/statuses/retweet/id.format

   local url = self.host.."/1/statuses/retweet/"..tweetId.."."..self.format  
   self:getXml(url, callback, "POST")
end

--------------Direct Messages

---Returns a list of the 20 most recent direct messages  
--sent to the authenticating user
function Twitter:directMessages()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages
end

---Returns a list of the 20 most recent direct messages 
--sent by the authenticating user.
function Twitter:directMessagesSent()
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages%C2%A0sent
end

---Sends a new direct message to the specified user from the authenticating user.
--@param user User to send the message
--@param text Message to the user
function Twitter:directMessagesNew(user, text)
  --http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-direct_messages%C2%A0new
end

--------------Search

function Twitter:search()
  --http://apiwiki.twitter.com/Twitter-Search-API-Method%3A-search
end

