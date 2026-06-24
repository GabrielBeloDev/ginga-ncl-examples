---
# RFC-0018: Leitor de RSS (LuaRSS) para TV Digital

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Roda (vídeo + faixa de notícias; conteúdo do feed depende de rede) |
| **App** | `rss-reader/main.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++, Lua 5.3) · Ubuntu 22.04 |
| **Captura** | [`../rss-reader/screenshots/rss-reader.png`](../rss-reader/screenshots/rss-reader.png) |
| **Correções** | ver [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md) |

## 1. Resumo

O `rss-reader/main.ncl` (`ncl id="main"`, perfil `EDTVProfile`) é uma aplicação de TV Digital Interativa escrita em **NCL + Lua (NCLua)** que funciona como **leitor de RSS**. O documento NCL é enxuto: exibe um **vídeo em tela cheia** (`media/Wanna_Work_Together_-_Creative_Commons.avi`) e sobrepõe, no **rodapé** (região `rgLua`, 30% inferior da tela), uma **mídia Lua** (`main.lua`) que concentra toda a lógica do leitor.

Toda a parte de rede, parse e renderização das notícias vive no lado imperativo (`main.lua`): ele baixa um feed RSS pela rede usando a biblioteca de conexões TCP por co-rotinas (`tcp.lua`), conecta-se na **porta 80**, faz uma requisição **HTTP GET**, remove o cabeçalho HTTP da resposta e faz o **parse do XML** com a biblioteca **LuaXML** (`LuaXML/xml.lua` + `LuaXML/handler.lua`). As notícias são então desenhadas sobre o vídeo usando a API gráfica `canvas` do NCLua, uma a uma, com avanço automático por timer e navegação manual pelas setas do controle remoto. O host padrão no código é `www.r7.com` (há `g1.globo.com` e `rss.noticias.uol.com.br` comentados como alternativos).

Autoria original de Manoel Campos da Silva Filho (IFTO), por volta de 2010, escrito para o Ginga/Lua da época (**Lua 5.1**).

## 2. Conceitos NCL/NCLua demonstrados

- **Objeto imperativo NCLua**: `media id="lua"` com `src="main.lua"`, integrada ao documento declarativo e responsável por toda a lógica do app.
- **Vídeo de fundo declarativo** em tela cheia, com **reinício automático ao terminar** via conector `onEndStart` (loop).
- **Nó settings** (`application/x-ginga-settings`) definindo `service.currentKeyMaster` para direcionar o foco/teclas ao objeto Lua (`luaIdx`).
- **Foco e captura de teclas**: `focusIndex="luaIdx"` no descritor `dLua` + `currentKeyMaster`, fazendo a mídia Lua receber as teclas do controle.
- **Conector causal por seleção de tecla**: `onKeySelectionStop` com `connectorParam`/`bindParam` (`key=RED`) — a tecla **vermelha** encerra a mídia Lua.
- **API de rede do NCLua** (no `main.lua`): biblioteca `tcp` (módulo `tcp.lua`) com `tcp.execute`/`tcp.connect`/`tcp.send`/`tcp.receive`/`tcp.disconnect`, usada para baixar o feed via HTTP GET na porta 80.
- **Parse de XML** com **LuaXML** (`xmlParser`, `simpleTreeHandler`), transformando o feed RSS em tabela Lua (`xmlhandler.root.rss.channel.item`).
- **API gráfica do NCLua** (`canvas`): `attrSize`, `attrColor`, `attrFont`, `drawRect`, `drawText`, `measureText`, `new`/`compose` (ícones), `clear`, `flush`.
- **API de eventos do NCLua** (`event`): `event.register(handler)`, `event.timer(8000, autoForward)` (avanço automático a cada 8 s) e tratamento de eventos de tecla (`CURSOR_RIGHT`/`CURSOR_LEFT`) e de apresentação (`ncl/presentation/start`).

## 3. Estrutura do documento

### 3.1 Regiões e descritores

A `regionBase` define duas regiões; a `descriptorBase`, dois descritores:

| Região | left / top | width × height | zIndex |
|--------|-----------|----------------|--------|
| `rgVideo` | (padrão) | 100% × 100% | 0 |
| `rgLua` | 0 / 70% | 100% × 30% | 1 |

| Descritor | region | observação |
|-----------|--------|------------|
| `dVideo` | `rgVideo` | descritor do vídeo de fundo |
| `dLua` | `rgLua` | descritor da mídia Lua, com `focusIndex="luaIdx"` |

A `rgLua` ocupa a **faixa inferior** da tela (30% de altura, ancorada em `top=70%`) e fica **acima** do vídeo (`zIndex=1` vs. `0`), de modo que a faixa de notícias é desenhada **sobre** o vídeo.

### 3.2 Conectores

A `connectorBase` define três conectores causais (apenas dois são efetivamente usados nos elos ativos):

| Conector | Condição | Ação | Parâmetro |
|----------|----------|------|-----------|
| `onEndStart` | `onEnd` | `start` | — |
| `onKeySelectionStop` | `onSelection` (key=`$key`) | `stop` | `key` |
| `onBeginStop` | `onBegin` | `stop` | — |

O `onBeginStop` está definido mas **não é usado** (o elo correspondente, junto com a âncora `fechar`, está comentado no `body`).

### 3.3 Mídias

O `body` declara duas portas de entrada — `pLua` (component `lua`) e `pVideo` (component `video1`) — e três nós de mídia:

| Mídia | type / src | descritor | papel |
|-------|------------|-----------|-------|
| `programSettings` | `application/x-ginga-settings` | — | define `service.currentKeyMaster = luaIdx` |
| `video1` | `media/Wanna_Work_Together_-_Creative_Commons.avi` | `dVideo` | vídeo de fundo em tela cheia |
| `lua` | `main.lua` | `dLua` | objeto NCLua: lógica do leitor de RSS |

A âncora `<area id="fechar"/>` dentro do nó `lua` está **comentada** no documento.

### 3.4 Elos

| Elo (`xconnector`) | Binds | Efeito |
|--------------------|-------|--------|
| `onEndStart` | `video1: onEnd` → `video1: start` | reinicia o vídeo de fundo ao terminar (loop) |
| `onKeySelectionStop` | `lua: onSelection` (`key=RED`) → `lua: stop` | a tecla **vermelha** encerra a mídia Lua |

Há ainda um elo `onBeginStop` (mídia `lua`, âncora `fechar`) **comentado** no `body`, inativo.

## 4. Execução

**Comando:**

```bash
cd rss-reader
ginga main.ncl
```

**Comportamento esperado:** o vídeo de fundo (`Wanna_Work_Together_-_Creative_Commons.avi`) toca em tela cheia e reinicia ao terminar; a região `rgLua` (rodapé, 30% inferior) é renderizada com a faixa Lua. O `main.lua` tenta baixar o feed RSS do host padrão (`www.r7.com`) via HTTP GET na porta 80, faz o parse do XML e exibe as notícias uma a uma (avanço automático a cada 8 s; setas esquerda/direita do controle navegam manualmente como lista circular; a tecla vermelha encerra a faixa Lua).

**Resultado verificado (2026-06-24 · Ginga Lua 5.3 · Ubuntu 22.04):** ✅ **Roda.** O vídeo de fundo aparece e a região da faixa de notícias (rodapé) é renderizada. O **conteúdo das notícias depende de baixar com sucesso um feed RSS pela rede** (canal de retorno / HTTP na porta 80); o host padrão e os alternativos podem não responder mais no formato esperado, então a faixa pode vir vazia se o feed não responder corretamente.

## 5. Observações

- **Correção de compatibilidade que tornou o app executável.** O app foi escrito para **Lua 5.1**, mas o Ginga atual embarca **Lua 5.3**. O arquivo `tcp.lua` declara-se como módulo com `module 'tcp'` (linha 14) e o `main.lua` faz `require "tcp"`; como a função global `module()` foi **removida no Lua 5.2+**, o carregamento abortava logo no início com:

  ```
  ./tcp.lua:14: attempt to call a nil value (global 'module')
  ```

  A correção foi adicionar o shim **`compat.lua`** (arquivo novo em `rss-reader/compat.lua`), que **reativa** `module()`/`setfenv()`/`getfenv()`/`package.seeall` do Lua 5.1 no Lua 5.3 (reproduzindo a troca de ambiente `_ENV` via biblioteca `debug`), carregado por **uma única linha** no topo do `main.lua`:

  ```lua
  require "compat"  -- restaura module()/setfenv() do Lua 5.1 (ver compat.lua)
  ```

  Essa é a **única alteração** na lógica original do app: o shim não toca no código existente, apenas restaura as APIs que ele espera. Sem ele, o `module()` em `tcp.lua` volta a quebrar o carregamento. Detalhes em [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md).

- **Dependência de rede.** A interface roda independentemente da rede, mas o **conteúdo** das notícias exige baixar um feed RSS externo. O host padrão (`www.r7.com`) e os alternativos comentados (`g1.globo.com`, `rss.noticias.uol.com.br`) são de ~2010 e podem não responder mais no formato esperado; nesse caso a faixa de notícias fica vazia.

- **Como trocar o feed.** Para usar outro feed, editam-se as variáveis `host` e `uri` no `main.lua` (há comentários no próprio código com exemplos de g1/r7/uol e notas sobre URL completa vs. apenas URI e cabeçalho `Host:` para tratar redirecionamentos 301/302).

- **Estrutura de arquivos.** `main.ncl` (documento NCL), `main.lua` (lógica do leitor; começa com `require "compat"`), `compat.lua` (shim), `tcp.lua` (TCP por co-rotinas — antigo ponto da falha), `LuaXML/` (parse do XML) e `media/` (vídeo de fundo + ícones `dir.png`/`esq.png`/`fechar.png`).
