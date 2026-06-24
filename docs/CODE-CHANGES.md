# Mudanças de código vs. original

Este documento registra **todas as alterações feitas no código original** dos apps para tentar
fazê-los rodar no Ginga atual (`telemidia/ginga`, C++, **Lua 5.3**). Os apps foram escritos para o
Ginga/Lua da época (**Lua 5.1**), e várias APIs que eles usam foram **removidas no Lua 5.2+**.

> **Princípio:** mexer o mínimo possível. Sempre que dava, a correção foi feita **sem tocar na lógica
> original** (via um shim de compatibilidade carregado à parte). As poucas edições diretas em
> arquivos originais estão listadas abaixo com *antes → depois*.

Verificado em **2026-06-24** · Ubuntu 22.04.

---

## Resumo do resultado

| App | Antes | Depois da correção |
|-----|-------|--------------------|
| **TVDQuiz** | ❌ crash `module()` | ✅ **roda e funciona** (quiz interativo aparece) |
| **enquete-ncl** | ❌ crash `module()` | ✅ **roda** (UI de votação Sim/Não sobre o vídeo) |
| **rss-reader** | ❌ crash `module()` | ✅ **roda** (vídeo + faixa de notícias; feed depende de rede) |
| **damasTV** | ❌ erro de parse NCL | 🔶 **carrega e toca a abertura** (não crasha mais); jogo precisa de tecla do controle (não exercitado no headless) |
| **twitter_ncl** | ❌ crash `module()` | 🔧 2 crashes corrigidos; **ainda não funciona** (depende da API antiga do Twitter, desativada) |
| **ClimaTV** | ❌ crash `module()` | 🔧 `module()` resolvido, mas surge outro erro (`PlayerLua: out of memory`); **não funciona** (e dependia do weather.com) |
| **FacebookNCL** | ❌ não roda | 🔧 `module()` resolvido, mas há erro de NCL no `ConnectorBase.ncl` (linha 1699) + API do Facebook desativada |

**Placar:** de **15/22**, passamos para **18/22 rodando** com UI (TVDQuiz, enquete, rss-reader somam aos
14 didáticos + A_Onda) **+ damasTV carregando**. Os 3 restantes dependem de serviços externos mortos.

---

## 1. Causa-raiz comum: `module()` e `setfenv()` removidos no Lua 5.2+

Os scripts `.lua` originais usam a função **`module(...)`** (e, em alguns casos, **`setfenv()`**) — padrão
do **Lua 5.1**. Ambas foram **removidas no Lua 5.2+**. Como o Ginga atual embarca **Lua 5.3**, o
carregamento abortava logo no início com:

```
attempt to call a nil value (global 'module')
```

### Correção: `compat.lua` (arquivo NOVO, não altera os originais)

Foi adicionado um shim **`compat.lua`** que **reativa** `module`, `setfenv`, `getfenv` e
`package.seeall` no Lua 5.3, reproduzindo a troca de ambiente (`_ENV`) via biblioteca `debug`. Ele é
carregado **antes de tudo**, com uma única linha no topo do script de entrada de cada app:

```lua
require "compat"  -- restaura module()/setfenv() do Lua 5.1 (ver compat.lua)
```

**Arquivos `compat.lua` adicionados (NOVOS):**

| App | Local do `compat.lua` | Entry que recebeu `require "compat"` (linha 1) |
|-----|------------------------|------------------------------------------------|
| ClimaTV | `ClimaTV/compat.lua` | `ClimaTV/main.lua` |
| enquete-ncl | `enquete-ncl/compat.lua` | `enquete-ncl/votacao.lua` |
| TVDQuiz | `TVDQuiz/compat.lua` | `TVDQuiz/main.lua` |
| twitter_ncl | `twitter_ncl/compat.lua` | `twitter_ncl/main.lua` |
| FacebookNCL | `FacebookNCL/compat.lua` | `FacebookNCL/script1.lua` |
| rss-reader | `rss-reader/compat.lua` | `rss-reader/main.lua` |
| damasTV | `damasTV/lua/compat.lua` | `damasTV/lua/principal.lua` |

> A única mudança nos arquivos **originais** aqui é **uma linha** (`require "compat"`) no topo de cada
> entry. Nenhuma outra linha da lógica original foi tocada. O conteúdo do `compat.lua` está em cada
> pasta e é idêntico (comentado).

---

## 2. Edições diretas em arquivos originais

Apenas **3 linhas** em **2 arquivos** originais foram editadas (além do `require "compat"`):

### 2.1 `damasTV/damas.ncl` — atributo inválido em `<descriptorParam>` (linha ~39)

O parser novo é mais estrito e rejeitava o atributo `region` (que não existe em `descriptorParam`).

```diff
- <descriptorParam name="soundLevel" region="test" value="1" />
+ <descriptorParam name="soundLevel" value="1" />
```

### 2.2 `damasTV/damas.ncl` — typo de maiúscula em `<bindRule>` (linha ~134)

O `bindRule` referenciava `efeitoVence`, mas a mídia se chama `efeitovence` (v minúsculo), causando
`Bad value 'efeitoVence' for attribute 'constituent' (no such object in scope)`.

```diff
- <bindRule rule="somVence" constituent="efeitoVence" />
+ <bindRule rule="somVence" constituent="efeitovence" />
```

### 2.3 `twitter_ncl/util.lua` — `%d` com float no Lua 5.3 (linha ~90)

No Lua 5.3, `string.format("%d", x)` exige inteiro; `areaWidth / tw` é divisão e resulta em float,
gerando `bad argument #2 to 'format' (number has no integer representation)`.

```diff
- local charsByLine = tonumber(string.format("%d", areaWidth / tw))
+ local charsByLine = tonumber(string.format("%d", math.floor(areaWidth / tw)))
```

---

## 3. Limitações que permanecem (não são problema de código corrigível aqui)

- **twitter_ncl** — depende da **API v1 do Twitter** (autenticação básica usuário/senha), desativada
  há anos. Mesmo sem crash, não há serviço para responder.
- **ClimaTV** — após o `module()`, surge `ginga::PlayerLua::start(): out of memory` (causa distinta, a
  investigar) e o app dependia do **weather.com**.
- **FacebookNCL** — `ConnectorBase.ncl` tem `<simpleCondition>` sem o atributo `eventType` (linha 1699),
  rejeitado pelo parser novo; além disso dependia da **API antiga do Facebook**.
- **damasTV** — o tabuleiro/menu é desenhado em NCLua e navegado por **teclas do controle remoto**;
  a verificação automática (headless) não simula teclas, então só a abertura foi confirmada.

---

## 4. Como reverter

Todas as mudanças estão no histórico git. Para reverter um app específico, basta remover o
`compat.lua` da pasta e a linha `require "compat"` do entry; e desfazer as 3 edições da seção 2.
