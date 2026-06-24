# RFC-0016: TVD Quiz — quiz interativo

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Roda e funciona (após correção de compatibilidade Lua 5.3) |
| **App** | `TVDQuiz/main.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++, Lua 5.3) · Ubuntu 22.04 |
| **Captura** | [`../TVDQuiz/screenshots/TVDQuiz.png`](../TVDQuiz/screenshots/TVDQuiz.png) |
| **Correções** | ver [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md) |

## 1. Resumo

O **TVD Quiz** é uma aplicação de TV digital interativa em NCL 3.0 (perfil EDTV) que exibe um vídeo em tela cheia e, sobre ele, um **quiz de múltipla escolha** desenhado e controlado por um script NCLua. O documento NCL é deliberadamente enxuto: ele apenas posiciona o vídeo e o objeto Lua na tela e fornece os elos de controle (iniciar o Lua quando o vídeo começa, encerrar o quiz com a tecla VERMELHA e finalizar o quiz com a tecla VERDE). **Toda a lógica do quiz vive no Lua**: o `main.lua` desenha as perguntas e alternativas no `canvas`, lê as teclas do controle remoto (setas para navegar entre perguntas, números 1–9 para escolher alternativas) e, ao final, mostra o gabarito com acertos/erros e o percentual. O banco de perguntas (`perguntas.lua`) e o leitor de configuração (`config.lua`) são módulos Lua separados. **O quiz é totalmente offline** — não depende de rede; as perguntas vêm de um arquivo local.

A aplicação foi escrita para o Ginga/Lua 5.1 da época e **só voltou a executar** no Ginga atual (Lua 5.3) após a adição de um shim de compatibilidade (`compat.lua`) que reativa `module()`/`setfenv()` — ver seção 5 e `docs/CODE-CHANGES.md`.

## 2. Conceitos NCL/NCLua demonstrados

- **Objeto NCLua sobreposto ao vídeo** — uma `<media src="main.lua">` ocupando uma região parcial da tela (banda inferior), por cima do vídeo de fundo.
- **Regiões aninhadas** com `zIndex` para empilhamento (Lua sobre o vídeo).
- **Transições visuais** (`<transitionBase>` / `transIn` / `transOut`) com efeito `fade` aplicado ao descritor do Lua.
- **Foco / tecla mestre** via `application/x-ginga-settings` (`service.currentKeyMaster`), entregando o foco de teclado ao objeto Lua.
- **Conectores causais locais**: `onBegin→start`, `onEnd→start` (loop do vídeo), `onSelection(key)→stop` e `onSelection(key)→set(value)`.
- **Interação por seleção de teclas coloridas** (VERMELHA encerra, VERDE finaliza) tratada no NCL.
- **Comunicação NCL → Lua por atribuição de propriedade**: o elo da tecla VERDE faz `set` na propriedade `finalizar` da mídia Lua; o `handler` Lua reage ao evento de `attribution`.
- **NCLua puro**: tratador `event.register(handler)`, desenho com a API `canvas` (`drawText`, `drawRect`, `compose`, `flush`, `attrColor`, `attrFont`, `measureText`), e leitura de teclas (`key`/`press`).
- **Modularização Lua** com `module()`/`require` e arquivo Lua usado como **arquivo de configuração** (carregado via `loadfile` + `setfenv` em `config.lua`).

## 3. Estrutura do documento

### 3.1 Regiões e descritores

**Regiões** (`<regionBase>`):

| Região | Geometria | zIndex | Observação |
|--------|-----------|--------|------------|
| `rgVideo` | `width=100%`, `height=100%` | 0 | tela cheia; recebe o vídeo de fundo |
| `rgLua` | `left=0`, `top=58%`, `width=100%`, `height=42%` | 1 | **aninhada** em `rgVideo`; banda inferior (~42% da altura) onde o quiz Lua é desenhado |

A `rgLua` está aninhada dentro de `rgVideo` e tem `zIndex="1"`, ficando **acima** do vídeo (`zIndex="0"`). Ou seja, o quiz aparece sobreposto ao terço inferior do vídeo.

**Descritores** (`<descriptorBase>`):

| Descritor | Região | Atributos |
|-----------|--------|-----------|
| `dVideo` | `rgVideo` | — |
| `dLua` | `rgLua` | `focusIndex="luaIdx"`, `transIn="tFade"`, `transOut="tFade"` |

O `dLua` recebe `focusIndex="luaIdx"` (referenciado pela tecla mestre, ver 3.3) e transições de entrada/saída em `fade`, definidas em `<transitionBase>` (`<transition id="tFade" type="fade"/>`).

### 3.2 Conectores

Os conectores são **definidos localmente** em `<connectorBase>`:

| Conector | Condição | Ação | Parâmetros |
|----------|----------|------|------------|
| `onBeginStart` | `onBegin` | `start` | — |
| `onKeySelectionSet` | `onSelection key="$key"` | `set value="$value"` | `key`, `value` |
| `onEndStart` | `onEnd` | `start` | — |
| `onKeySelectionStop` | `onSelection key="$key"` | `stop` | `key` |
| `onBeginStop` | `onBegin` | `stop` | — |

Observação: `onBeginStop` é declarado mas **não é referenciado** por nenhum `<link>` no `<body>`.

### 3.3 Mídias

| Mídia (`id`) | `src` / tipo | Descritor | Papel na cena |
|--------------|--------------|-----------|---------------|
| `programSettings` | `application/x-ginga-settings` | — | define `service.currentKeyMaster="luaIdx"`, dando o foco de teclado ao objeto Lua |
| `video1` | `media/Wanna_Work_Together_-_Creative_Commons.avi` | `dVideo` | vídeo de fundo (licença Creative Commons) |
| `lua` | `main.lua` | `dLua` | objeto NCLua que desenha e controla o quiz; declara a propriedade `<property name="finalizar"/>` |

A **âncora de entrada** é a porta `<port id="pVideo" component="video1"/>`: a aplicação começa tocando o vídeo. A propriedade `finalizar` da mídia `lua` é o canal pelo qual o NCL sinaliza ao Lua que o quiz deve ser finalizado (ver elo da tecla VERDE em 3.4).

**Conteúdo Lua (lógica do quiz, fora do NCL):**

- `main.lua` (entry, ~248 linhas) — registra `event.register(main.handler)`. No evento `presentation/start` da classe `ncl`, carrega `perguntas.lua` via `config.load(...)`, inicializa o vetor de respostas e desenha a primeira pergunta. Trata teclas (`key`/`press`): `CURSOR_LEFT`/`CURSOR_RIGHT` navegam entre perguntas (com *wrap-around*), os dígitos `1`–`9` selecionam alternativas (a opção escolhida é realçada em amarelo). No evento `attribution` de nome `finalizar`, chama `main.finalizar()`, que exibe o gabarito (acertos em verde, erros em vermelho) e o percentual de acertos. Desenha botões PNG (`dir.png`, `esq.png`, `fechar.png`, `concluir.png`) na tela via `canvas:compose`.
- `perguntas.lua` — **banco de perguntas** (uma tabela `perguntas`); cada item tem `per` (enunciado), `resp` (lista de alternativas) e `corr` (índice da correta). No estado verificado contém **3 perguntas** (tema: Copa do Mundo / seleção brasileira de 2010).
- `config.lua` — módulo `config` que **lê um arquivo Lua como arquivo de configuração**: usa `loadfile` + `setfenv(execFile, data)` para carregar as variáveis do arquivo dentro da tabela `config.data` (as perguntas ficam acessíveis em `config.data.perguntas`). Tem ainda `save`/`getValue`/`setValue` (a função `save` usa `io`, indisponível no Ginga, e serve só para depuração).
- `compat.lua` — **arquivo novo** de compatibilidade (ver seção 5); não faz parte da lógica original do quiz.

### 3.4 Elos

**Elo 1 — `onBeginStart`** (inicia o quiz quando o vídeo começa):

```xml
<link xconnector="onBeginStart">
  <bind role="onBegin" component="video1"/>
  <bind role="start"   component="lua"/>
</link>
```

Quando `video1` começa (`onBegin`), o objeto `lua` é iniciado — o quiz aparece sobre o vídeo.

**Elo 2 — `onKeySelectionSet`** (tecla VERDE finaliza o quiz):

```xml
<link xconnector="onKeySelectionSet">
  <bind role="onSelection" component="video1">
    <bindParam name="key" value="GREEN"/>
  </bind>
  <bind role="set" component="lua" interface="finalizar">
    <bindParam name="value" value="true"/>
  </bind>
</link>
```

Ao pressionar a tecla **VERDE** (`GREEN`), o elo faz `set "true"` na propriedade `finalizar` da mídia `lua`. Isso gera, no Lua, um evento de `attribution` que dispara `main.finalizar()` (exibe o gabarito).

**Elo 3 — `onEndStart`** (vídeo em loop):

```xml
<link xconnector="onEndStart">
  <bind component="video1" role="onEnd"/>
  <bind component="video1" role="start"/>
</link>
```

Quando `video1` termina (`onEnd`), ele é reiniciado — o vídeo de fundo **toca em laço**.

**Elo 4 — `onKeySelectionStop`** (tecla VERMELHA encerra):

```xml
<link xconnector="onKeySelectionStop">
  <bind component="video1" role="onSelection">
    <bindParam name="key" value="RED"/>
  </bind>
  <bind component="lua" role="stop"/>
</link>
```

Ao pressionar a tecla **VERMELHA** (`RED`), o objeto `lua` é parado (`stop`), encerrando o quiz (o vídeo continua).

**Fluxo resumido:**
1. `t=0` — entra o `video1` (via porta `pVideo`).
2. `onBegin` do vídeo → inicia `lua`; o quiz é desenhado na banda inferior, com foco de teclado (tecla mestre `luaIdx`).
3. O telespectador navega com as **setas** e responde com os **números**; o vídeo segue em loop ao fim de cada execução.
4. Tecla **VERDE** → `set finalizar=true` → o Lua mostra o gabarito (acertos/erros + percentual).
5. Tecla **VERMELHA** → `stop` no `lua` → o quiz é encerrado.

## 4. Execução

```bash
cd TVDQuiz
ginga main.ncl
```

**Comportamento esperado:** o vídeo de fundo (Creative Commons) inicia em tela cheia e entra em loop. Sobre o terço inferior da tela, surge (com *fade*) o quiz desenhado pelo NCLua: o enunciado da pergunta atual e suas alternativas numeradas, mais os botões de navegação/concluir/fechar. As **setas esquerda/direita** trocam de pergunta; os **números 1–9** selecionam a alternativa (realçada em amarelo). A tecla **VERDE** finaliza e mostra o gabarito (acertos em verde, erros em vermelho, com o percentual de acertos); a tecla **VERMELHA** encerra o quiz.

**Resultado verificado:** ✅ A aplicação **roda e funciona** — o quiz interativo aparece sobre o vídeo e responde à navegação e seleção, conforme a captura [`../TVDQuiz/screenshots/TVDQuiz.png`](../TVDQuiz/screenshots/TVDQuiz.png). O funcionamento foi obtido **após a correção de compatibilidade Lua 5.3** descrita na seção 5.

## 5. Observações

- **Correção que tornou o app executável (compatibilidade Lua 5.3):** o Ginga atual (`telemidia/ginga`, C++) embarca **Lua 5.3**, mas os scripts originais foram escritos para **Lua 5.1**. `config.lua` usa `module("config")` e `setfenv(...)`, e `main.lua` faz `require "config"`. Como `module()` e `setfenv()` foram **removidos no Lua 5.2+**, o carregamento abortava logo no início com `attempt to call a nil value (global 'module')`. A correção foi adicionar o shim **`TVDQuiz/compat.lua`** (arquivo **novo**), que reativa `module`, `setfenv`, `getfenv` e `package.seeall` no Lua 5.3 reproduzindo a troca de ambiente (`_ENV`) via biblioteca `debug`. A **única alteração no código original** foi **uma linha** no topo de `main.lua`:

  ```lua
  require "compat"  -- restaura module()/setfenv() do Lua 5.1 (ver compat.lua)
  ```

  Nenhuma outra linha da lógica original foi tocada. Detalhes em [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md).

- **Quiz offline:** as perguntas vêm de `perguntas.lua` (arquivo local); **não há dependência de rede**. Para mudar/ampliar o quiz, basta editar a tabela `perguntas` (campos `per`, `resp`, `corr`). No estado verificado há **3 perguntas**.
- **NCL como casca; Lua como motor:** o `.ncl` apenas posiciona o vídeo e o objeto Lua e fornece os elos; **todo o desenho e a interatividade do quiz estão no NCLua**, usando a API `canvas`.
- **Mídias locais necessárias** (presentes): vídeo `media/Wanna_Work_Together_-_Creative_Commons.avi` e os PNGs de botões em `media/` (`dir.png`, `esq.png`, `fechar.png`, `concluir.png`). A ausência de qualquer um deixa a respectiva área vazia.
- **`config.save()` usa `io`**, que não está disponível no Ginga; a função é apenas para depuração e não é exercitada no fluxo do quiz.
- **Conector `onBeginStop` declarado, mas não usado** por nenhum `<link>`.
- O arquivo `.ncl` está codificado em **ISO-8859-1** (Latin-1); os comentários e os textos das perguntas usam acentuação nessa codificação.
- **Autores originais:** Ueslei Taivan (Faculdade Católica do Tocantins) e Manoel Campos da Silva Filho (IFTO). Licença Creative Commons BY-NC-SA 2.5 BR.
