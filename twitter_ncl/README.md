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
Não foi possível ver a aplicação em funcionamento. Após corrigir dois crashes de carregamento (ver "Status da verificação"), o Ginga não aborta mais por esses motivos, mas o app **não exibe a timeline**: ele depende da API v1 do Twitter (login/senha), desativada há anos, então não há serviço que responda às requisições. Sem screenshot útil. A ideia original era ver o vídeo de fundo com a timeline do Twitter desenhada por cima e botões coloridos (tweet, reply, retweet, etc.) navegáveis pelo controle remoto.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ginga atual embarca **Lua 5.3** (os apps eram Lua 5.1) · Ubuntu 22.04

🔧 **Dois crashes corrigidos, mas o app ainda NÃO funciona.**

Correções aplicadas (detalhes em `../docs/CODE-CHANGES.md`):
1. **`module()` removido no Lua 5.2+** — vários scripts (`util.lua`, `config.lua`, `tcp.lua`, LuaXML, etc.) começam com `module(...)`, que não existe no Lua 5.3, gerando logo de início:
   `./util.lua:8: attempt to call a nil value (global 'module')`.
   Solução: foi adicionado o shim **`compat.lua`** (arquivo novo, não altera a lógica original), reativando `module()`/`setfenv()`, carregado com `require "compat"` na **primeira linha** de `main.lua`.
2. **`%d` com float no Lua 5.3** — em `util.lua` (linha ~90), `string.format("%d", areaWidth / tw)` recebia um float (divisão), e no Lua 5.3 o especificador `%d` exige inteiro, causando PANIC. Solução: envolver com `math.floor(...)` → `string.format("%d", math.floor(areaWidth / tw))`.

Resultado: o Ginga não aborta mais por esses motivos. Porém, como o serviço de que o app depende não existe mais, ele **não consegue obter nem exibir a timeline**.

## Limitações conhecidas
- **API antiga do Twitter (causa-raiz atual):** o código fala com a API v1 do Twitter usando login/senha (autenticação básica). Essa API foi desativada há anos; não há mais serviço que responda, então o app não exibe a timeline mesmo com os crashes corrigidos.
- **Canal de retorno TCP:** depende de conexão TCP de saída (`tcp.lua`/`http.lua`) para um serviço externo que não existe mais.
- **Credenciais em texto puro:** usuário e senha do Twitter ficam em `twitter.config.lua`.
- **Compatibilidade Lua 5.1 → 5.3:** o app só carrega graças ao shim `compat.lua`; os scripts originais foram escritos para Lua 5.1.

## Arquivos principais
- `main.ncl` — documento NCL principal: regiões, vídeo de fundo (`media/Wanna_Work_Together_-_Creative_Commons.avi`) e mídia Lua (`main.lua`).
- `main.lua` — ponto de entrada Lua: monta a interface, desenha botões e trata os eventos de teclado/controle remoto. Recebeu `require "compat"` na linha 1.
- `compat.lua` — shim de compatibilidade (arquivo novo) que reativa `module()`/`setfenv()` do Lua 5.1 no Lua 5.3. Ver `../docs/CODE-CHANGES.md`.
- `Twitter.lua` — classe que implementa a API do Twitter (HTTP para `api.twitter.com`/`twitter.com`, parse XML).
- `ShowTweets.lua` — exibe a home timeline e a timeline de um usuário selecionado.
- `SendTweet.lua` — tela de envio de tweet e reply (usa `TextField.lua`).
- `Retweet.lua` — envia retweets.
- `TextField.lua` — campo de texto para digitação na tela.
- `http.lua` / `tcp.lua` — cliente HTTP e canal de retorno TCP.
- `base64.lua` — codificação Base64 para autenticação básica.
- `util.lua` / `config.lua` — utilitários gerais e leitura de configuração (declaravam `module(...)`; `util.lua` também teve o ajuste de `%d`/`math.floor`).
- `twitter.config.lua` — arquivo de configuração com usuário e senha do Twitter.
- `Entities2AccentedChars.lua` — conversão de entidades HTML para caracteres acentuados.
- `LuaXML/` (e `LuaXML-0.0.0-lua5.1.tgz`) — cópia local da biblioteca LuaXML para parse das respostas.
- `media/` — imagens dos botões (tweet, reply, retweet, etc.) e o vídeo de fundo.
- `doc/`, `ncluatweet.html`, `nclua-tweet.png` — documentação (LuaDoc) e material de divulgação do projeto.
