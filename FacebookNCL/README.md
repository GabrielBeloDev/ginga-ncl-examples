# FacebookNCL

> Cliente de Facebook para TV Digital: lê e exibe o feed/mural de um perfil em NCL + Lua · Thiago Nunes, Marcio Fraga e Victor Muniz (bibliotecas Lua de Manoel Campos da Silva Filho e Craig Mason-Jones) · ~2010

## O que é
Aplicação Ginga-NCL que se conecta à antiga Graph API do Facebook (`graph.facebook.com`) para baixar os últimos posts de um perfil e exibi-los, um a um, num "mural" sobreposto a uma imagem de fundo (São Luís). A interface é montada em NCL (`main.ncl`), enquanto a lógica fica num objeto NCLua (`script1.lua`): ele dispara requisições HTTP por co-rotinas, recebe a resposta em JSON, decodifica e desenha cada feed no `canvas` (nome do autor, mensagem quebrada em linhas e foto de perfil baixada sob demanda). A camada de rede é feita por bibliotecas Lua puras — `tcp.lua` (sockets via canal de retorno), `http.lua`, `json.lua`, `base64.lua` e `util.lua`. Navegação por controle remoto: tecla VERMELHA abre/fecha o mural e as setas esquerda/direita percorrem os posts; cada feed também avança sozinho por um timer.

## Como rodar
```bash
cd FacebookNCL
ginga main.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
Em tese: a foto de fundo de São Luís com o logo do Facebook no canto superior direito; ao apertar a tecla VERMELHA, abriria um mural na parte inferior com setas e a mensagem "Carregando..." até os posts do perfil (`maranhao.br`, por padrão) chegarem da API e serem exibidos com nome, texto e foto. Na prática isso **não acontece** neste Ginga (ver abaixo). Sem screenshot.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — o objeto NCLua não inicializa; o app não chega a exibir o feed.
- O `script1.lua` faz `require 'tcp'`, `require 'json'` e `require 'http'`, e essas bibliotecas (além de `util.lua` e `base64.lua`) começam com a função `module(...)` — por exemplo `module 'tcp'`, `module("json")`, `module "http"`, `module "util"`, `module('base64',package.seeall)`. Essa função foi **removida no Lua 5.2+**, então o carregamento dos módulos falha e o script quebra.
- Causa-raiz: mesmo padrão dos outros apps NCLua da coleção — código escrito para o Lua antigo (com `module()`), incompatível com o Lua novo embarcado neste Ginga.

## Limitações conhecidas
- **`module()` removido no Lua 5.2+**: impede o carregamento de `tcp.lua`, `json.lua`, `http.lua`, `util.lua` e `base64.lua`. Correção possível (fora do escopo): criar um shim de `module` ou portar os scripts para o Lua novo.
- **API antiga do Facebook desativada**: o app depende da Graph API legada (`graph.facebook.com/<perfil>/feed`, `/?fields=picture`), que não existe mais nesse formato — exigiria hoje token de acesso e endpoints atuais. Logo, mesmo com o `module()` corrigido, o feed não carregaria.
- **Depende de rede/canal de retorno (TCP)**: precisa de acesso TCP de saída para `graph.facebook.com` e para baixar as imagens de perfil; sem isso, nada é exibido.
- Perfil-alvo fixo no código (`facebookUserID = "maranhao.br"`), apenas 7 feeds, 7 s por feed.

## Arquivos principais
- `main.ncl` — documento NCL principal: regiões, descritores, mídias e links (tecla VERMELHA abre/fecha o mural, setas navegam nos feeds).
- `script1.lua` — lógica NCLua: baixa o feed via HTTP, decodifica o JSON, baixa fotos de perfil e desenha cada post no canvas.
- `ConnectorBase.ncl` — base de conectores (causal connectors) importada pelo `main.ncl`.
- `http.lua` — biblioteca de requisições/download HTTP (autor: Manoel Campos da Silva Filho); usa `module "http"`.
- `tcp.lua` — sockets TCP via canal de retorno, base do `http.lua`; usa `module 'tcp'`.
- `json.lua` — JSON4Lua, codificação/decodificação JSON (Craig Mason-Jones); usa `module("json")`.
- `base64.lua` — conversão base64 usada pelo HTTP; usa `module('base64', package.seeall)`.
- `util.lua` — funções utilitárias (co-rotinas, impressão de tabelas); usa `module "util"`.
- `media/` — imagens: fundo `sao_luis.jpg`, `facebook.png`, `mural_bg2.png`, setas e `default_image.png` (foto padrão de perfil).
