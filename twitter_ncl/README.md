# NCLua Tweet

> Cliente de Twitter para TV Digital Interativa (ler, enviar, responder e retweetar) feito em NCL + Lua (Ginga) · Manoel Campos da Silva Filho (manoelcampos.com) · v0.5, 2010

## O que é
Aplicação NCL/Ginga que funciona como um cliente de Twitter dentro da TV Digital. O documento `main.ncl` exibe um vídeo de fundo (um clipe Creative Commons) e carrega o script `main.lua`, que monta a interface gráfica com `canvas` e trata eventos de teclado/controle remoto. Em cima disso há uma camada de classes Lua: `Twitter.lua` (implementação da API do Twitter, falando com `api.twitter.com`/`twitter.com` via HTTP), `ShowTweets.lua` (exibe a home timeline e a timeline de usuários), `SendTweet.lua` (tela de envio/reply com um campo de texto `TextField.lua`) e `Retweet.lua`. O acesso à rede é feito por `http.lua`/`tcp.lua` (canal de retorno TCP) com autenticação básica via `base64.lua`, e o parse das respostas XML usa uma cópia local da LuaXML. As credenciais (usuário e senha) ficam em `twitter.config.lua`, lido por `config.lua`.

## Como rodar
```bash
cd twitter_ncl
ginga main.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
Não foi possível ver a aplicação: o Ginga abortou no carregamento, antes de exibir qualquer interface (chegou a aparecer o diálogo do Ubuntu "Ginga closed unexpectedly"). Sem screenshot. A ideia original era ver o vídeo de fundo com a timeline do Twitter desenhada por cima e botões coloridos (tweet, reply, retweet, etc.) navegáveis pelo controle remoto.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — o processo Ginga abortou no carregamento dos scripts Lua.
- Erro exato: `./util.lua:8: attempt to call a nil value (global 'module')`
- Causa-raiz: a função Lua `module()` foi removida no Lua 5.2+. Vários scripts deste app (`util.lua`, `config.lua`, e a LuaXML) começam com `module(...)`, que não existe mais no Lua usado por este Ginga, quebrando o `require`/carregamento logo de início.

## Limitações conhecidas
- **Lua `module()` removido (Lua 5.2+):** causa o crash imediato. Correção possível (fora do escopo agora): criar um shim para `module` ou portar os scripts para o sistema de módulos do Lua atual.
- **API antiga do Twitter:** o código fala com a API v1 do Twitter usando login/senha (autenticação básica). Essa API foi desativada há anos; mesmo com o Lua corrigido, as requisições não funcionariam.
- **Canal de retorno TCP:** depende de conexão TCP de saída (`tcp.lua`/`http.lua`) para um serviço externo que não existe mais.
- **Credenciais em texto puro:** usuário e senha do Twitter ficavam em `twitter.config.lua`.

## Arquivos principais
- `main.ncl` — documento NCL principal: regiões, vídeo de fundo (`media/Wanna_Work_Together_-_Creative_Commons.avi`) e mídia Lua (`main.lua`).
- `main.lua` — ponto de entrada Lua: monta a interface, desenha botões e trata os eventos de teclado/controle remoto.
- `Twitter.lua` — classe que implementa a API do Twitter (HTTP para `api.twitter.com`/`twitter.com`, parse XML).
- `ShowTweets.lua` — exibe a home timeline e a timeline de um usuário selecionado.
- `SendTweet.lua` — tela de envio de tweet e reply (usa `TextField.lua`).
- `Retweet.lua` — envia retweets.
- `TextField.lua` — campo de texto para digitação na tela.
- `http.lua` / `tcp.lua` — cliente HTTP e canal de retorno TCP.
- `base64.lua` — codificação Base64 para autenticação básica.
- `util.lua` / `config.lua` — utilitários gerais e leitura de configuração (declaram `module(...)`, origem do crash).
- `twitter.config.lua` — arquivo de configuração com usuário e senha do Twitter.
- `Entities2AccentedChars.lua` — conversão de entidades HTML para caracteres acentuados.
- `LuaXML/` (e `LuaXML-0.0.0-lua5.1.tgz`) — cópia local da biblioteca LuaXML para parse das respostas.
- `media/` — imagens dos botões (tweet, reply, retweet, etc.) e o vídeo de fundo.
- `doc/`, `ncluatweet.html`, `nclua-tweet.png` — documentação (LuaDoc) e material de divulgação do projeto.
