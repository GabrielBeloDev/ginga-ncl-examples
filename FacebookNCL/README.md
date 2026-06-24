# FacebookNCL

> Cliente de Facebook para TV Digital: lê e exibe o feed/mural de um perfil em NCL + Lua · Thiago Nunes, Marcio Fraga e Victor Muniz (bibliotecas Lua de Manoel Campos da Silva Filho e Craig Mason-Jones) · ~2010

## O que é
Aplicação Ginga-NCL que se conecta à antiga Graph API do Facebook (`graph.facebook.com`) para baixar os últimos posts de um perfil e exibi-los, um a um, num "mural" sobreposto a uma imagem de fundo (São Luís). A interface é montada em NCL (`main.ncl`), enquanto a lógica fica num objeto NCLua (`script1.lua`): ele dispara requisições HTTP por co-rotinas, recebe a resposta em JSON, decodifica e desenha cada feed no `canvas` (nome do autor, mensagem quebrada em linhas e foto de perfil baixada sob demanda). A camada de rede é feita por bibliotecas Lua puras — `tcp.lua` (sockets via canal de retorno), `http.lua`, `json.lua`, `base64.lua` e `util.lua`. Navegação por controle remoto: tecla VERMELHA abre/fecha o mural e as setas esquerda/direita percorrem os posts; cada feed também avança sozinho por um timer.

## Como rodar
```bash
cd FacebookNCL
ginga main.ncl
```

## O que você deve ver
Em tese: a foto de fundo de São Luís com o logo do Facebook no canto superior direito; ao apertar a tecla VERMELHA, abriria um mural na parte inferior com setas e a mensagem "Carregando..." até os posts do perfil (`maranhao.br`, por padrão) chegarem da API e serem exibidos com nome, texto e foto. Na prática isso **não acontece** neste Ginga (ver abaixo). Sem screenshot.

## Status da verificação
Testado em **2026-06-24** · Ginga atual com **Lua 5.3**.
- 🔧 **`module()` RESOLVIDO**, mas **AINDA NÃO RODA** por causa de um erro de NCL.
- **Correção do `module()` (funcionou):** foi adicionado o shim `compat.lua` e a linha `require "compat"` no **topo do `script1.lua`** (linha 1). Esse shim reativa `module()`/`setfenv()` do Lua 5.1 sob o Lua 5.3, sem alterar a lógica original. Com isso, o carregamento de `tcp.lua`, `json.lua`, `http.lua`, `util.lua` e `base64.lua` (que começam com `module(...)`) não quebra mais. Detalhes em `docs/CODE-CHANGES.md`.
- **Novo bloqueio (erro de NCL):** o parser novo é mais estrito e rejeita o `ConnectorBase.ncl`. No conector `onSelectionTestOnStopStart` há um `<simpleCondition role="onStop"/>` (linha **1699**) **sem o atributo obrigatório `eventType`**. Como o documento não é aceito, o app não chega a inicializar. Isso ainda não foi corrigido — ver `docs/CODE-CHANGES.md` (seção 3).
- **Mesmo com o NCL corrigido, não funcionaria:** o app depende da **antiga Graph API do Facebook** (`graph.facebook.com/<perfil>/feed`, `/?fields=picture`), desativada há anos. Logo, não há serviço para responder ao feed.

## Limitações conhecidas
- **`<simpleCondition>` sem `eventType` no `ConnectorBase.ncl` (linha 1699)**: o parser atual exige o atributo e rejeita o documento, então o app não inicializa. Correção possível (fora do escopo até aqui): adicionar `eventType="presentation"` (ou equivalente) na condição `onStop`. Ver `docs/CODE-CHANGES.md`.
- **API antiga do Facebook desativada**: o app depende da Graph API legada (`graph.facebook.com/<perfil>/feed`, `/?fields=picture`), que não existe mais nesse formato — exigiria hoje token de acesso e endpoints atuais. Mesmo com o NCL corrigido, o feed não carregaria.
- **`module()` era um problema (já resolvido)**: as bibliotecas `tcp.lua`, `json.lua`, `http.lua`, `util.lua` e `base64.lua` usam `module(...)`, removido no Lua 5.2+. Resolvido pelo shim `compat.lua` + `require "compat"` no topo do `script1.lua` (ver `docs/CODE-CHANGES.md`).
- **Depende de rede/canal de retorno (TCP)**: precisa de acesso TCP de saída para `graph.facebook.com` e para baixar as imagens de perfil; sem isso, nada é exibido.
- Perfil-alvo fixo no código (`facebookUserID = "maranhao.br"`), apenas 7 feeds, 7 s por feed.

## Arquivos principais
- `main.ncl` — documento NCL principal: regiões, descritores, mídias e links (tecla VERMELHA abre/fecha o mural, setas navegam nos feeds).
- `script1.lua` — lógica NCLua: baixa o feed via HTTP, decodifica o JSON, baixa fotos de perfil e desenha cada post no canvas. Tem `require "compat"` na linha 1 (correção do `module()`).
- `compat.lua` — **arquivo novo** (não original): shim que reativa `module()`/`setfenv()`/`getfenv()`/`package.seeall` do Lua 5.1 no Lua 5.3, via biblioteca `debug`. Ver `docs/CODE-CHANGES.md`.
- `ConnectorBase.ncl` — base de conectores (causal connectors) importada pelo `main.ncl`. Contém o `<simpleCondition>` sem `eventType` (linha 1699) que bloqueia a execução no parser atual.
- `http.lua` — biblioteca de requisições/download HTTP (autor: Manoel Campos da Silva Filho); usa `module "http"`.
- `tcp.lua` — sockets TCP via canal de retorno, base do `http.lua`; usa `module 'tcp'`.
- `json.lua` — JSON4Lua, codificação/decodificação JSON (Craig Mason-Jones); usa `module("json")`.
- `base64.lua` — conversão base64 usada pelo HTTP; usa `module('base64', package.seeall)`.
- `util.lua` — funções utilitárias (co-rotinas, impressão de tabelas); usa `module "util"`.
- `media/` — imagens: fundo `sao_luis.jpg`, `facebook.png`, `mural_bg2.png`, setas e `default_image.png` (foto padrão de perfil).
