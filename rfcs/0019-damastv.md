# RFC-0019: damasTV — jogo de damas

| Campo | Valor |
|-------|-------|
| **Status** | 🔶 Carrega e abre apos correcoes (parse NCL + module); jogo completo precisa de teclas (nao verificado headless) |
| **App** | `damasTV/damas.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++, Lua 5.3) · Ubuntu 22.04 |
| **Captura** | — |
| **Correcoes** | ver [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md) |

## 1. Resumo

Este documento descreve o **damasTV**, um jogo de damas para TV digital interativa escrito em
NCL 3.0 (perfil EDTV) com toda a logica de jogo implementada em **NCLua**. O NCL aqui atua como
um *casco* de orquestracao: ele exibe uma abertura em video, sobe a engine Lua, toca a musica de
fundo em loop e dispara **efeitos sonoros** conforme os eventos do jogo (mover peca, capturar,
virar dama, soprar, vitoria, etc.).

A peca central e a midia `lua` (`lua/principal.lua`), uma aplicacao NCLua que carrega uma engine
modular (constantes, jogo, jogoRede, tela, opcoes, rede e funcoes auxiliares) e gerencia o
tabuleiro, o menu e a navegacao **por teclas do controle remoto**. A comunicacao entre a engine
e o NCL e feita atraves de **areas (`<area>`)** declaradas na midia Lua: cada area corresponde a
um efeito sonoro, e quando a engine "entra" naquela area (via `onBegin`), o NCL seleciona e toca
o som correto por meio de um `<switch>` controlado por **regras (`ruleBase`)**.

O app **nao roda** no Ginga atual sem ajustes. Foram necessarias **duas correcoes diretas no
`damas.ncl`** (parser novo mais estrito) e **uma correcao de compatibilidade Lua 5.1 → 5.3** (shim
`compat.lua`). Apos isso, o documento carrega e a abertura toca sem crashar; a partida em si
depende de teclas do controle e nao foi exercitada no ambiente headless de verificacao.

## 2. Conceitos NCL/NCLua demonstrados

- **Midia NCLua como aplicacao** (`type="application/x-ginga-NCLua"`): toda a logica de jogo vive
  em Lua, nao em NCL.
- **Areas (`<area>`) como pontos de ancoragem de eventos**: a midia `lua` declara 12 areas
  (`somEfect*`, `musica`, `jogoFim`) usadas como interfaces de `onBegin`/`onEnd` para que a engine
  Lua sinalize o NCL.
- **Selecao de midia por regra** (`<switch>` + `<ruleBase>` + `<bindRule>`): um unico componente
  logico (`efeitoSonoro`) escolhe entre 9 arquivos de som conforme o valor da variavel `efeito`.
- **Variavel de ambiente via settings** (`application/x-ginga-settings` com a propriedade `efeito`):
  o NCL escreve em `efeito` e o `<switch>` reavalia as regras para tocar o som certo.
- **Conectores causais reutilizaveis** com **acoes compostas** (`<compoundAction>`, `operator="seq"`,
  `qualifier="par"`, `max="unbounded"`): o padrao "aborta o som atual → seta a regra → inicia o novo som".
- **Parametrizacao de conector** (`<connectorParam>` / `<bindParam>`): o mesmo conector
  `onBeginSetabortStart` recebe valores diferentes (`mSom`, `seleSom`, `cnSom`, ...) por elo.
- **Settings de teclado/foco** (`service.currentKeyMaster`, `service.currentFocus`): direciona as
  teclas do controle remoto para a aplicacao Lua.
- **Audio em loop** (elo `repeater`: `onEnd` da musica reinicia a propria musica).
- **NCLua: engine modular** carregada via `require`/`module()` (padrao Lua 5.1), com loop de
  frames acionado por `event.register`/`event.timer`.

## 3. Estrutura do documento

### 3.1 Regioes e descritores

**Regiao** (`<regionBase>`) — apenas uma, cobrindo a tela inteira:

| Regiao | Geometria | Observacao |
|--------|-----------|------------|
| `tv` | `width=100%`, `height=100%` | tela cheia; recebe o video de abertura e a midia NCLua |

**Descritores** (`<descriptorBase>`):

| Descritor | Regiao | Atributos / parametros |
|-----------|--------|------------------------|
| `priDesc` | `tv` | descritor do video de abertura |
| `luaDesc` | `tv` | `focusIndex="1"` — recebe foco/teclas para a aplicacao NCLua |
| `musicaFundoDesc` | — | `soundLevel=0.1` (musica de fundo baixa) |
| `efeitoDesc` | — | `soundLevel=1` (efeitos sonoros em volume cheio) |

> Observacao: `musicaFundoDesc` e `efeitoDesc` nao referenciam regiao (sao apenas audio); definem
> somente o nivel de som via `<descriptorParam name="soundLevel">`.

**Regras** (`<ruleBase>`) — uma regra por efeito sonoro, todas comparando a variavel `efeito`
(`comparator="eq"`) com um valor literal:

| Regra | Valor de `efeito` | Som associado |
|-------|-------------------|---------------|
| `somMenu` | `mSom` | mudanca de menu |
| `somSelecao` | `seleSom` | selecao |
| `somComeN` | `cnSom` | captura por peca normal |
| `somAndaN` | `anSom` | movimento de peca normal |
| `somComeD` | `cdSom` | captura por dama |
| `somAndaD` | `adSom` | movimento de dama |
| `somDama` | `dSom` | peca virou dama |
| `somSopra` | `sSom` | soprar |
| `somVence` | `vSom` | vitoria |

### 3.2 Conectores

Definidos em `<connectorBase>` (todos causais):

| Conector | Condicao | Acao | Uso |
|----------|----------|------|-----|
| `onBeginSetabortStart` | `onBegin` | `seq`: `abort` (par) → `set $var` (par) → `start` (par) | padrao dos 9 elos de efeito sonoro: para o som atual, seta a regra e inicia o novo som |
| `onBeginStart` | `onBegin` | `start` (par) | religa a musica de fundo |
| `onBeginStop` | `onBegin` | `stop` | encerra jogo (para Lua, musica e efeitos) |
| `onEndStartn` | `onEnd` | `start` (par) | encadeia inicio (video → Lua; loop da musica) |
| `onEndAbort` | `onEnd` | `abort` (par) | aborta a musica |

O `onBeginSetabortStart` recebe um `<connectorParam name="var">`, preenchido por `<bindParam>` em
cada elo de som — e o que permite reutilizar o mesmo conector para todos os 9 efeitos.

### 3.3 Midias

| Midia | Tipo / src | Descritor | Papel |
|-------|------------|-----------|-------|
| `programSettings1` | `x-ginga-settings` (`service.currentKeyMaster=1`) | — | direciona o controle remoto |
| `nodeSettings` | `x-ginga-settings` (propriedade `efeito`) | — | variavel global lida pelas regras do `<switch>` |
| `programSettings2` | `x-ginga-settings` (`service.currentFocus=1`) | — | foco inicial |
| `videoInicial` | `inicio.mp4` | `priDesc` | abertura; ao terminar, sobe a engine Lua |
| `musicaFundo` | `audio/mp3` `audios/musicaT.mp3` | `musicaFundoDesc` | trilha de fundo em loop |
| `efeitoSonoro` | `<switch>` de 9 `<media>` de audio (wav/mp3) | `efeitoDesc` | seleciona e toca o efeito conforme a regra ativa |
| `lua` | `x-ginga-NCLua` `lua/principal.lua` | `luaDesc` | **a engine do jogo**; declara `service.currentKeyMaster=1` e 12 `<area>` |

O `<switch id="efeitoSonoro">` agrupa as 9 midias de som (`efeitoMenu`, `efeitoSeleciona`,
`efeitoComeN`, `efeitoAndaN`, `efeitoComeD`, `efeitoAndaD`, `efeitoCome`, `efeitoSopra`,
`efeitovence`), cada uma associada a uma regra por `<bindRule>`.

As **areas da midia `lua`** sao os pontos por onde a engine sinaliza o NCL:
`somEfectSeleciona`, `somEfectMenu`, `somEfectComeN`, `somEfectComeD`, `somEfectAndaN`,
`somEfectAndaD`, `somEfectDama`, `somEfectSopra`, `somEfectVence`, `somEfeitoPausa`, `musica` e
`jogoFim`.

**Engine NCLua** (`lua/principal.lua` + `lua/engine/`): o entry carrega `compat` e depois
`constantes`, `jogo`, `jogoRede`, `tela`, `opcoes`, `rede` e `FuncoesAuxiliares`, define o objeto
`principal` (maquina de estados `{tela, jogo, opcoes, rede, jogoRede}`) e registra os handlers de
`event` (tecla e timer) que rodam o loop de frames do jogo. A pasta `lua/engine/` traz modulos
auxiliares (movimentador, tabuleiro, copas, conexoes de rede, teclado, coxpcall, etc.).

### 3.4 Elos

**Inicial:**

| Elo | Conector | Efeito |
|-----|----------|--------|
| `videoTerminado` | `onEndStartn` | quando `videoInicial` termina (`onEnd`), inicia a midia `lua` (sobe o jogo) |

**Efeitos sonoros** (9 elos, todos com `onBeginSetabortStart`): cada um liga uma `<area>` da midia
`lua` (`onBegin`) ao trio *abortar `efeitoSonoro` → setar `nodeSettings.efeito` (via `<bindParam>`) →
iniciar `efeitoSonoro`*:

| Elo | Area (Lua) | `var` setado | Regra ativada |
|-----|------------|--------------|---------------|
| `LancaEfectSeleciona` | `somEfectSeleciona` | `seleSom` | `somSelecao` |
| `LancaEfectMenu` | `somEfectMenu` | `mSom` | `somMenu` |
| `LancaEfectComeN` | `somEfectComeN` | `cnSom` | `somComeN` |
| `LancaEfectComeD` | `somEfectComeD` | `cdSom` | `somComeD` |
| `LancaEfectAndaN` | `somEfectAndaN` | `anSom` | `somAndaN` |
| `LancaEfectAndaD` | `somEfectAndaD` | `adSom` | `somAndaD` |
| `LancaEfectDama` | `somEfectDama` | `dSom` | `somDama` |
| `LancaEfectSopra` | `somEfectSopra` | `sSom` | `somSopra` |
| `LancaEfectVence` | `somEfectVence` | `vSom` | `somVence` |

**Musica e fim de jogo:**

| Elo | Conector | Efeito |
|-----|----------|--------|
| `paraMusica` | `onEndAbort` | area `musica` (`onEnd`) → aborta `musicaFundo` |
| `voltaMusica` | `onBeginStart` | area `musica` (`onBegin`) → inicia `musicaFundo` |
| `paraJogo` | `onBeginStop` | area `jogoFim` (`onBegin`) → para `lua`, `musicaFundo` e `efeitoSonoro` |
| `repeater` | `onEndStartn` | `musicaFundo` (`onEnd`) → reinicia `musicaFundo` (loop) |

**Porta de entrada:** `<port id="int" component="videoInicial"/>` — a aplicacao comeca pelo video
de abertura.

## 4. Execucao

**Comando:**

```bash
cd damasTV
ginga damas.ncl
```

**Comportamento esperado:** a aplicacao inicia pela porta `int`, tocando o video de abertura
(`inicio.mp4`) em tela cheia. Ao fim do video, o elo `videoTerminado` sobe a midia NCLua
(`lua/principal.lua`), que desenha o menu/tabuleiro e passa a receber as teclas do controle remoto.
A musica de fundo toca em loop e, conforme os eventos do jogo, os efeitos sonoros corretos sao
disparados pelos elos `LancaEfect*`. Ao terminar a partida, o elo `paraJogo` encerra a aplicacao e
seus audios.

**Resultado verificado (2026-06-24, headless):** apos as correcoes (secao 5), o documento **carrega
e abre** sem crashar — o parse do NCL passa e a engine Lua sobe (o `module()` deixa de quebrar).
A **partida completa nao foi verificada**: o tabuleiro e o menu sao navegados por **teclas do
controle remoto** e o ambiente de verificacao headless **nao simula teclas**, portanto apenas a
abertura/carga foi confirmada. Dai o status 🔶.

## 5. Observacoes

Este app **nao executava** no Ginga atual sem ajustes. Tres alteracoes foram necessarias — duas
diretas no `damas.ncl` (parser mais estrito) e uma de compatibilidade Lua (shim externo, sem tocar
na logica). Detalhes em [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md).

### 5.1 Correcoes no `damas.ncl`

1. **Atributo invalido em `<descriptorParam>`** (descritor `efeitoDesc`, ~linha 39): o parser novo
   rejeitava o atributo `region` em `<descriptorParam>`, que nao existe nesse elemento.

   ```diff
   - <descriptorParam name="soundLevel" region="test" value="1" />
   + <descriptorParam name="soundLevel" value="1" />
   ```

2. **Typo de maiuscula em `<bindRule>`** (regra `somVence`, ~linha 134): o `bindRule` referenciava
   `efeitoVence`, mas a midia se chama `efeitovence` (v minusculo), causando
   `Bad value 'efeitoVence' for attribute 'constituent' (no such object in scope)`.

   ```diff
   - <bindRule rule="somVence" constituent="efeitoVence" />
   + <bindRule rule="somVence" constituent="efeitovence" />
   ```

### 5.2 Correcao de compatibilidade Lua 5.1 → 5.3 (o que tornou o app executavel)

O Ginga atual embarca **Lua 5.3**, mas a engine do damasTV foi escrita para **Lua 5.1** e usa
`module()` (e `setfenv()`), **removidos no Lua 5.2+**. Sem isso, o carregamento da midia NCLua
abortava com:

```
attempt to call a nil value (global 'module')
```

A correcao foi um **shim `compat.lua`** (arquivo novo, em `damasTV/lua/compat.lua`) que **reativa**
`module`, `setfenv`, `getfenv` e `package.seeall` no Lua 5.3, reproduzindo a troca de ambiente
(`_ENV`) via biblioteca `debug` — **sem alterar a logica original**. Ele e carregado por uma unica
linha no topo do entry (`damasTV/lua/principal.lua`, linha 1):

```lua
require "compat"  -- restaura module()/setfenv() do Lua 5.1 (ver compat.lua)
```

### 5.3 Limitacao remanescente

O tabuleiro e o menu sao desenhados em NCLua e navegados por **teclas do controle remoto**. A
verificacao automatica (headless) **nao simula teclas**, entao apenas a abertura/carga foi
confirmada — a jogabilidade completa permanece nao verificada neste ambiente. Para reverter as
mudancas, basta remover `damasTV/lua/compat.lua` + a linha `require "compat"` e desfazer as duas
edicoes da secao 5.1.
