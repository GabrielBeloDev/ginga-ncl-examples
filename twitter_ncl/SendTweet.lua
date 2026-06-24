---Implementação da classe SendTweet
--@author Manoel Campos da Silva Filho

dofile("TextField.lua")

---Classe estática responsável por desenhar e controlar
--a interface gráfica para envio de Tweets
SendTweet = {
  --Valor do índice do tweet sendo exibido, antes
  --de entrar na tela de envio de tweet
  oldItemIndex = 0,
  --Identificador da página, antes de entrar
  --na tela de envio de tweet
  oldActivePage = 0,
  
  --TextField que armazenará a mensagem digitada pelo usuário
  text1 = false
}

---Desenha a interface para envio de um tweet
--@param main Tabela contendo as funções comuns
--para o desenha da interface da aplicação,
--além de variáveis comuns usadas por
--cada uma das telas da mesma
--@param inReplyTo Se fornecido, a mensagem será enviada
--em resposta a um tweet de outro usuário. O valor
--deste parâmetro deve ser o nome do usuário que receberá
--o reply, no formato @username.
function SendTweet:paint(main, inReplyTo)
  local w, h = canvas:attrSize()
  self.oldItemIndex = main.itemIndex
  self.oldActivePage = main.activePage 
  main.itemIndex = -1
  main:fullScreenMsg("Digite sua mensagem (140 caracteres):")
  main:drawButtons {"ok.png", "voltar.png", "fechar.png"}
  main.activePage = main.pages.sendTweet

  --A API retorna erro se os 140 caracteres forem excedidos.
  --top, left, width, upcase, allowCaseChange, maxLenght, multiLine, linesCount     
  text1 = TextField:new(28, 6, w-4, false, true, 140, true, 4)
  text1.onKeyPress = function (self, key)
      local count = 140-#self.text
	  canvas:attrColor("white")
	  local w, h = canvas:attrSize()
	  canvas:drawRect("fill", 0, 0, w, 28)
	  canvas:attrFont("vera", 24)
	  canvas:attrColor("blue")
	  canvas:drawText(10, 0, "Digite sua mensagem ("..count.." caracteres):")
	  canvas:flush()
  end

  --Adiciona na mensagem, o nome do usuário para o qual vai o reply.
  --Sem o nome do usuário, mensagem será apenas um tweet comum.
  if inReplyTo then
     text1.text = inReplyTo .. " "
     text1:paint()
  end
end

---Envia uma requisição para realizar um novo Tweet
--@param main Tabela contendo as funções comuns
--para o desenha da interface da aplicação,
--além de variáveis comuns usadas por
--cada uma das telas da mesma
function SendTweet:send(main, callback)
   --Função a ser executada quando o retweet for enviado ao servidor
   --do Twitter.
   --@param xmlTable Tabela lua gerada a partir do XML de retorno
   --da requisição
   local function callback(xmlTable)
      self:back(main)
      ShowTweets:drawTweet()
   end

   if text1.text ~= "" then
     main.twitter:statusUpdate(callback, text1.text)
   end
end

---Volta para a tela de exibição de tweets
function SendTweet:back(main)
  main.itemIndex  = self.oldItemIndex 
  main.activePage = self.oldActivePage
end