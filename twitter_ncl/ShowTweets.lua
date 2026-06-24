---Implementação da classe ShowTweets.
--@author Manoel Campos da Silva Filho

---Classe estática responsável por desenhar e controlar
--a interface gráfica para visualização de Tweets,
--além de iniciar o processo de envio de requisição
--ao servidor do Twitter para receber o XML contendo
--as mensagens (tweets).
--Devido esta classe utilizar funções de callback,
--como explicado ao longo do seu código,
--não é possível usar uma instância da classe,
--apenas diretamente a classe estática, pois
--com a instância, é necessário usar
--dois-pontos (:) nas chamadas das funções
--para se ter acesso ao parâmetro implícito self,
--porém, nas funções de callback, não se pode
--declarar e nem chamar as funçõe usando dois-pontos (:),
--pois da forma como as funções de callback estão sendo
--chamadas, não é previsto nenhum parâmetro self.
--Assim, a tentativa de acessar self para obter
--o valor de algum atributo de uma instância iria
--resultar em um erro, pois não vai existir tal
--parâmetro. A inclusão de tal suporte iria
--complicar desnecessariamente a implementação
--das chamadas das funções de callback, recurso
--usado pela classe Twitter.  
ShowTweets = {
    cancelTimerFunc = false,

    --Número do tweet a ser exibido no momento
    itemIndex = -1,
    
    --Tabela contendo as funções comuns
    --para o desenha da interface da aplicação,
    --além de variáveis comuns usadas por
    --cada uma das telas da mesma
    main = nil,
        
	--Tabela que contém os tweets obtidos
	--a partir de uma requisição HTTP a um
	--arquivo XML no servidor do Twitter.
	--Ela é inicializada na função @see startApplication
	tweets = nil,
	
    --Nome do arquivo onde a imagem do usuário, que
    --enviou o tweet sendo exibido, será salva
    imgFileName = "image",    
    
    --Image Width e Image Height: altura e largura para as imagens do usuário do Twitter
    iw = 50,
    ih = 50,
        
    --Código do usuário da última mensagem exibida,
    --usado para verificar se o usuário
    --da mensagem atual é o mesmo da mensagem 
    --anterior. Se for, a imagem
    --do usuário não é baixada novamente 
    lastUserId = 0,  	   
}

---Função para inicializar atributos na classe estática ShowTweets
--@param main Tabela contendo as funções comuns
--para o desenha da interface da aplicação,
--além de variáveis comuns usadas por
--cada uma das telas da mesma
function ShowTweets:init(main)
  self.main = main
end

---Altera o índice de notícia, para que seja
--exibida uma próxima notícia ou uma notícia anterior.
--@param forward Se igual a true, incrementa o índice em 1,
--senão, decrementa em 1.
--@returns Retorna o novo índice da notícia a ser exibida.
function ShowTweets:moveItemIndex(forward)
  --Se o index for menor que zero, é porque
  --o XML do feed ainda não foi baixado, logo,
  --não há notícia a ser exibida.
  if self.itemIndex < 0 then
     return self.itemIndex
  end
  
  local main = self.main
  --Armazena o id do usuário, antes de mover para outro tweet.
  --Assim, pode-se verificar se o usuário da próxima mensagem
  --é o mesmo da mensagem atual. Se for, não
  --precisa baixar a imagem do usuário novamente
  self.lastUserId = self:getTweetUserId()
  
  if forward then
     self.itemIndex = self.itemIndex + 1
     if self.itemIndex > #self.tweets.statuses.status then
        self.itemIndex = 1
     end
  else
     self.itemIndex = self.itemIndex - 1
     if self.itemIndex <= 0 then
        self.itemIndex = #self.tweets.statuses.status
     end;
  end
  
  return self.itemIndex
end 

---Desenha os textos de um tweet na tela.
--@param i Índice do tweet a ser impresso.
function ShowTweets:paintTweetText(i)
     if i < 1 then
        return
     end
     canvas:attrFont("vera", 24)
     canvas:attrColor("blue")
     
     --width e height do canvas
     local cw, ch = canvas:attrSize()
     
     local main = self.main
     local text = self.tweets.statuses.status[i].user.name
     canvas:drawText(self.iw+5, 2, text)
     
     text = i.."/"..#self.tweets.statuses.status 
     
     --width e height do texto que mostra o tweet atual e o total de tweets
     local tw, th = canvas:measureText(text)
     
     canvas:drawText(cw-(tw+4), ch-th, text)     

     canvas:attrFont("vera", 24)
     canvas:attrColor("black")

     local y= 0
     text = self.tweets.statuses.status[i].text
         
     --Quebra o texto da notícia em diversas linhas, 
     --gerando uma tabela onde cada item é uma linha que
     --foi quebrada. Isto é usado para que o texto seja
     --exibido sem sair da tela. 
     util.paintBreakedString(cw-self.iw, self.iw+5, th + 2, text)
end

---Desenha as imagens das setas de navegação
function ShowTweets:drawNavButtons()
   --width e height do canvas
   local cw, ch = canvas:attrSize()
   
   local img = canvas:new("media/dir.png")
   --Button Width e Button Height
   local bw1, bh1 = img:attrSize()
   canvas:compose(cw-bw1, 2, img)
   
   img = canvas:new("media/esq.png")
   --Button Width e Button Height
   local bw2, bh2 = img:attrSize()
   canvas:compose(cw-(bw1+bw2), 2, img)   
end

---Avança para o próximo tweet.
--Função utilizada para fazer o 
--avanço automático para o próximo tweet
--depois de um determinado tempo. 
function ShowTweets.autoForward()
    ShowTweets:moveItemIndex(true)
    ShowTweets:drawTweet()  
end

---Função a ser executada em uma co-rotina,
--para baixar a imagem do usuário do Tweet 
--a ser exibido.
--@param _callback Função de callback a ser
--executada quando a imagem for obtida do servidor
--do Twitter.
function ShowTweets.getImage(_callback)
     if ShowTweets.itemIndex < 1 then
        return
     end
     
     local i = ShowTweets.itemIndex
     local url = ShowTweets.tweets.statuses.status[i].user.profile_image_url
     if http.getFile(url, ShowTweets.imgFileName, Twitter.userAgent) then
        print("-------------Baixou imagem", ShowTweets.itemIndex)
        --Após baixar a imagem, chama a função de callback
        --para exibir a mesma
        _callback()
     end 
end

---Função de callback a ser
--executada quando a imagem for obtida do servidor
--do Twitter, para exibir a mesma na tela, tendo concluído o download da imagem.
function ShowTweets.showImageCallback()
     if util.fileExists(ShowTweets.imgFileName) then
         local img = canvas:new(ShowTweets.imgFileName)
         canvas:compose(4, 4, img)
         canvas:flush()
     end
end

---Desenha a interface para exibição de uma mensagem do Twitter.
function ShowTweets:drawTweet()
   local main = self.main
   self:cancelTimer()

   if (self.itemIndex > 0 and self.tweets and self.tweets.statuses 
   and self.tweets.statuses.status 
   and (#self.tweets.statuses.status > 0)) == false then
      print("------------------Erro na tabela tweets")
      return
   end
   
   local cw, ch = canvas:attrSize()
   canvas:clear()
   canvas:attrColor("white")
   canvas:drawRect("fill", 0,0, cw, ch)
   local i = self.itemIndex
   print("Twitt", i)
      
   self:paintTweetText(i)
   self:drawNavButtons()

   local fileNames = false
   if main.activePage == main.pages.homeTimeline then
       fileNames = {
          "ok.png", "tweet.png", "reply.png", "retweet.png", "fechar.png" 
       }
   elseif main.activePage == main.pages.userTimeline then
       fileNames = {
          "reply.png", "retweet.png", "voltar.png", "fechar.png"
       }
   end
   
   print("-------------------drawTweet()")
   main:drawButtons(fileNames)   
   canvas:flush()      
 
   --Se está na página inicial da aplicação
   --(a de exibir as mensagens do usuário logado),
   --busca a imagem do usuário que mandou a mensagem.
   --Se estiver na página de um usuário específico,
   --não busca a imagem, pois isto só precisa ser feito uma vez. 
   if main.activePage == main.pages.homeTimeline then
       --Se o usuário do tweet atual é o mesmo do anterior,
       --apenas exibe a mesma imagem do usuário
       if self.lastUserId == self:getTweetUserId() then
          self.showImageCallback()
       else
          --senão, baixa a imagem do usuário e exibe.
          
          --Cria uma co-rotina para executar a função getImage para baixar
          --a imagem do usuário.
          --O parâmetro showImageCallback é uma função de callback
          --que será chamada quando getImage retornar.
          util.coroutineCreate(self.getImage, self.showImageCallback)
       end
   else 
      self.showImageCallback()
   end
 
   --Cria um timer para passar para a próxima mensagem após 6 segundos,
   --chamando a função autoForward
   self.cancelTimerFunc = event.timer(6000, self.autoForward)
end

---Inicializa variáveis para começar a exibir as mensagens
--obtidas do twitter. Esta é uma função de callback, executada
--na chamada das funções homeTimeline e userTimeline da classe Twitter,
--chamada dentro da função @see handler.
--@param xmlTable Tabela contendo as mensagens do timeline
--do usuário no Twitter, que será passada a esta função,
--chamada por callback pelo método homeTimeline ou userTimeline da classe Twitter.
function ShowTweets.initTweetsInterfaceCallback(xmlTable)
    local main = ShowTweets.main
    print("----------initTweetsInterfaceCallback()")
    if xmlTable.hash and xmlTable.hash.error then
       canvas:clear()
       canvas:attrColor("white")
       local w, h = canvas:attrSize()
       canvas:drawRect("fill", 0, 0, w, h)
       local msg = "Erro ao tentar acessar o Twitter.\n " ..
          "Tente novamente em instantes.\n\n " ..
          xmlTable.hash.error .. "\n\n" ..
          "Pressione a tecla vermelha para sair."
       print("\n"..msg.."\n")
       util.paintBreakedString(w-10, 10, 10, msg)
       canvas:flush()
       
       print("-----------------"..xmlTable.hash.error)
       return
    end 
  
    if xmlTable and xmlTable.statuses 
    and xmlTable.statuses.status 
    and (#xmlTable.statuses.status > 0) then
        ShowTweets.tweets = xmlTable
        print("-------------------Carregou tweets")
        ShowTweets.itemIndex = 1
        ShowTweets:drawTweet()
        --Se está na página de mensagens de um usuário específico,
        --baixa a imagem dele apenas uma vez, pois a função
        --drawTweet não baixará a cada mensagem exibida, pois
        --todas serão de um mesmo usuário.
        if main.activePage == main.pages.userTimeline then
           util.coroutineCreate(ShowTweets.getImage, ShowTweets.showImageCallback)
        end        
    end
end

---Envia requisição para obtenção das mensagens
--do timeline do usuário conectado.
function ShowTweets:startHomeTimeline()
      local main = self.main
      self:clearVars()
      main.activePage = main.pages.homeTimeline
      main:fullScreenMsg("Acessando suas mensagens no Twitter, aguarde...")             
   
      --Envia requisição para obter o timeline do usuário.
      --As credenciais do mesmo são definidas no arquivo de configuração
      --twitter.config.lua.
      --A função initTweetsInterfaceCallback, passada à homeTimeline,
      --é uma função de callback, chamada quando o arquivo
      --XML, contendo as mensagens do timeline do usuário,
      --é baixado do servidor do Twitter.
      --Em todas as funções que utilizam a classe TCP (como é o caso
      --da função homeTimeline da classe Twitter),
      --devido estas usarem co-rotinas para simular threads
      --e enviar requisições HTTP, a chamada
      --da função tcp.execute retorna imediatamente, não aguardando
      --a resposta da requisição HTTP enviada. Assim, para resolver
      --este problema, utiliza-se o recurso de funções de callback.
      --Estas são funções que são passadas por parâmetro para outra função,
      --e só são executadas depois que determinado evento ocorra,
      --neste caso, após ser obtida resposta da requisição TCP enviada.
      --Por enquanto, essa foi a única forma de encapsular
      --todo o código, necessário para envio de uma requisição HTTP,
      --em uma função única.
      main.twitter:homeTimeline(self.initTweetsInterfaceCallback)
end


---Verifica se tem uma função de timer ativa 
--e cancela a mesma. Essa função
--de timer é utilizada para avançar
--os tweets automaticamente.
function ShowTweets:cancelTimer()
   --Variável que aponta para uma função
   --utilizada para interromper
   --o avanço automático de notícias
   --quando o usuário pressiona uma 
   --tecla e assim, reiniciar
   --a contagem de tempo.
   if self.cancelTimerFunc then
      self.cancelTimerFunc() --cancela o timer anteriormente criado
   end
end

---Apaga algumas variáveis da tabela main, para
--que a aplicação não avance a exibição dos tweets
--automaticamente, e não permita uso das setas
--direcionais, até que a resposta de uma nova requisição
--ao Twitter seja recebida para redesenhar a interface
--da aplicação
function ShowTweets:clearVars()
   self.tweets = nil
   self.itemIndex = -1
   self.lastUserId = 0
   self:cancelTimer()
end

---Retorna o ID do usuário do tweet atual
function ShowTweets:getTweetUserId()
  if self.itemIndex < 0 then
     return 0
  end
  
  return self.tweets.statuses.status[self.itemIndex].user.id
end

---Retorna o nome de usuário do tweet atual
function ShowTweets:getTweetUserName()
  if self.itemIndex < 0 then
     return 0
  end
  
  return '@'..self.tweets.statuses.status[self.itemIndex].user.screen_name
end