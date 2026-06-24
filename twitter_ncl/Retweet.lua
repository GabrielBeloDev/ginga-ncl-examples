---Implementação da classe Retweet
--@author Manoel Campos da Silva Filho

---Classe estática que trata a interface gráfica para retweet de uma mensagem,
--além de iniciar o processo para envio da requisição de retweet ao
--servidor do Twitter
Retweet = {}

---Função para retweetar uma mensagem, iniciando 
--o processo de envio de uma requisição ao servidor do Twitter
--@param main Tabela contendo as funções comuns
--para o desenha da interface da aplicação,
--além de variáveis comuns usadas por
--cada uma das telas da mesma
function Retweet:send(main)
  --Se não tem nenhuma mensagem sendo exibida, sai sem fazer nada
  if main.itemIndex < 1 then
     return
  end
  
  --Função a ser executada quando o retweet for enviado ao servidor
  --do Twitter.
  --@param xmlTable Tabela lua gerada a partir do XML de retorno
  --da requisição
  --TODO: Falta implementar algo para dar feedback ao usuário
  local function callback(xmlTable)
  end

  --Obtem o código do tweet atual, que será retweetado  
  local tweetId = main.tweets.statuses.status[main.itemIndex].id
  main.twitter:retweet(callback, tweetId)
end
