---
# RFC-0017: Enquete/votação para TV Digital

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Roda (UI de votação; envio do voto dependia de backend PHP morto) |
| **App** | `enquete-ncl/main.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++, Lua 5.3) · Ubuntu 22.04 |
| **Captura** | [`../enquete-ncl/screenshots/enquete.png`](../enquete-ncl/screenshots/enquete.png) |
| **Correções** | ver [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md) |

## 1. Resumo

Este documento (`ncl id="main"`, perfil `EDTVProfile`) implementa um **sistema de enquete interativa para TV Digital**: sobre um vídeo de fundo em tela cheia, são exibidos dois botões — **Sim** (tecla verde) e **Não** (tecla vermelha) — e uma faixa de texto desenhada por um objeto **NCLua**. O usuário vota pressionando a tecla colorida correspondente; o NCL escreve a opção escolhida na propriedade `voto` do nó Lua, que então **envia o voto a um servidor web remoto** (página PHP) por um canal de retorno TCP e **exibe o resultado** da votação na tela.

A interface declarativa (vídeo + botões + script) **carrega e roda** no Ginga atual. A parte que depende de rede — o envio do voto e a obtenção do resultado — é feita por `votacao.lua` contra `manoelcampos.com/votacao/votacao2.php`; esse backend PHP **não está mais no ar**, de modo que a etapa de votação propriamente dita não se completa. O app só passou a carregar no Ginga atual graças a um shim de compatibilidade (`compat.lua`), pois tanto `votacao.lua` quanto `tcp.lua` usam `module()`/`setfenv()` do Lua 5.1 (ver seção 5).

O arquivo de origem traz como autoria **Manoel Campos da Silva Filho** (http://manoelcampos.com), sob licença Creative Commons Atribuição-Não comercial-Compartilha Igual.

## 2. Conceitos NCL/NCLua demonstrados

- **Objeto imperativo NCLua**: `media id="lua" src="votacao.lua"` integrada ao documento declarativo, com lógica de rede e desenho na tela.
- **Canal de retorno (interatividade)**: acesso TCP/HTTP a um servidor web remoto via `tcp.lua`, usando **co-rotinas** Lua para simular operações assíncronas sem travar a apresentação.
- **Comunicação NCL → Lua por atribuição**: `property name="voto"` no nó Lua, escrita pelo NCL via `bind role="set" interface="voto"`; o script captura o evento `ncl/attribution/start name='voto'` no `handler`.
- **Comunicação Lua → NCL por atribuição**: o script devolve ao NCL o evento de fim escrevendo `property name="result"`; via `event.post`, gerando `onEndAttribution` que o NCL usa para encerrar o nó Lua.
- **API gráfica do NCLua** (`canvas`): `attrColor`, `clear`, `attrFont`, `drawText`, `flush` (faixa de texto com a pergunta e o resultado).
- **API de eventos do NCLua** (`event`): `event.register(handler)`, `event.post` (gera atribuição com `action='start'`/`'stop'` para o NCL perceber a mudança de propriedade).
- **Nó settings** (`application/x-ginga-settings`) definindo `service.currentKeyMaster` para direcionar as teclas ao nó com `focusIndex="luaIdx"`.
- **Seleção por teclas coloridas** do controle remoto: `onSelection key="GREEN"` (Sim) e `onSelection key="RED"` (Não).
- **Transições** (`transitionBase`): efeito `fade` (`tFade`) aplicado nos botões via `transIn`/`transOut`.
- **Ações compostas e temporização**: `compoundAction operator="seq"` (set + stop) e ações com `delay` (`stop delay="1s"`, `stop delay="10s"`).

## 3. Estrutura do documento

### 3.1 Regiões e descritores

A `regionBase` define uma região raiz `rgTela` (640 × 480) que aninha as demais:

| Região | left / top | width × height | zIndex |
|--------|-----------|----------------|--------|
| `rgTela` | — | 640 × 480 | — |
| `rgVideo` | — | 100% × 100% | 0 |
| `rgSim` | 10 / 88% | 89 × 59 | 1 |
| `rgNao` | 120 / 88% | 89 × 58 | 1 |
| `rgLua` | 0 / 80% | 100% × 90 | 1 |

`rgVideo` é o fundo (vídeo em tela cheia, `zIndex=0`); `rgSim` e `rgNao` são os botões inferiores lado a lado; `rgLua` é a faixa onde o objeto NCLua desenha a pergunta e o resultado.

Descritores (`descriptorBase`):

- `dVideo` → `rgVideo` (vídeo de fundo).
- `dSim` → `rgSim`, com `transIn="tFade"`/`transOut="tFade"` (fade na entrada/saída do botão Sim).
- `dNao` → `rgNao`, com `transIn="tFade"`/`transOut="tFade"` (fade no botão Não).
- `dLua` → `rgLua`, com `focusIndex="luaIdx"` e `descriptorParam transparency="100%"` (objeto NCLua; o `currentKeyMaster` aponta para esse índice de foco para que as teclas cheguem ao app).

A `transitionBase` declara uma única transição `tFade` (`type="fade"`, `dur="0.7s"`).

### 3.2 Conectores

A `connectorBase` define seis conectores causais:

| Conector | Condição → Ação | Parâmetros |
|----------|-----------------|------------|
| `onBeginStartN` | `onBegin` → `start` (`max="unbounded"`, `qualifier="par"`) | — |
| `onBeginSet` | `onBegin` → `set $var` | `var` |
| `onKeySelecionSetStop` | `onSelection key=$keyCode` → seq(`set $var`, `stop`) | `keyCode`, `var` |
| `onKeySelecionDelayedStop` | `onSelection key=$keyCode` → `stop delay="1s"` | `keyCode` |
| `onKeySelecionStop` | `onSelection key=$keyCode` → `stop` | `keyCode` |
| `onEndAttributionDelayedStop` | `onEndAttribution` → `stop delay="10s"` | — |

`onBeginSet` e `onKeySelecionStop` estão declarados mas não são usados pelos elos do corpo (ver 3.4). `onKeySelecionSetStop` é o conector-chave: combina, em sequência, a escrita da propriedade `voto` e a parada do botão oposto.

### 3.3 Mídias

Mídias do corpo (`body`):

| id | src / tipo | descritor | observações |
|----|-----------|-----------|-------------|
| `programSettings` | `application/x-ginga-settings` | — | `property service.currentKeyMaster = "luaIdx"` |
| `sim` | `media/sim.png` | `dSim` | botão "Sim" (tecla verde) |
| `nao` | `media/nao.png` | `dNao` | botão "Não" (tecla vermelha) |
| `lua` | `votacao.lua` | `dLua` | **objeto NCLua** (entry da lógica) |
| `video` | `media/Wanna_Work_Together_-_Creative_Commons.avi` | `dVideo` | vídeo de fundo |

O `port pInicio` aponta para `video`: a apresentação começa pelo vídeo de fundo.

O nó Lua `lua` expõe duas **propriedades** que são a ponte com o NCL:

- `<property name="voto"/>` — escrita pelo NCL (`"sim"` ou `"nao"`); ao receber a atribuição, o script envia o voto ao servidor remoto.
- `<property name="result"/>` — escrita pelo próprio script (via `event.post`) após exibir o resultado; serve para sinalizar ao NCL que o nó Lua pode ser interrompido.

O vídeo de fundo referenciado é `Wanna_Work_Together_-_Creative_Commons.avi` (vídeo institucional Creative Commons).

### 3.4 Elos

Fluxo de elos do corpo:

1. **Início (`onBeginStartN`).** `onBegin video` → `start sim`, `start nao`, `start lua` (em paralelo). Quando o vídeo começa, surgem os dois botões e o objeto NCLua, que escreve a pergunta `"Você é a favor da doação de órgãos?"` na faixa inferior.

2. **Voto "Sim" (`onKeySelecionSetStop`).** `onSelection key="GREEN"` em `sim` → seq(`set lua.voto = "sim"`, `stop nao`). Vota em Sim e remove o botão Não.

3. **Esconde o botão "Sim" (`onKeySelecionDelayedStop`).** `onSelection key="GREEN"` em `sim` → `stop sim delay="1s"`. Após votar, o próprio botão Sim some com 1s de atraso.

4. **Voto "Não" (`onKeySelecionSetStop`).** `onSelection key="RED"` em `nao` → seq(`set lua.voto = "nao"`, `stop sim`). Vota em Não e remove o botão Sim.

5. **Esconde o botão "Não" (`onKeySelecionDelayedStop`).** `onSelection key="RED"` em `nao` → `stop nao delay="1s"`.

6. **Encerramento do nó Lua (`onEndAttributionDelayedStop`).** `onEndAttribution lua.result` → `stop lua delay="10s"`. Quando o script termina de escrever o resultado e atribui um valor a `result`, o NCL agenda a parada do nó Lua 10s depois (tempo para o usuário ler o resultado).

**Núcleo do app (lógica em `votacao.lua`):** o `handler` registrado trata dois casos — (a) na inicialização (`ncl/presentation/start`), desenha a pergunta no `canvas`; (b) ao receber `ncl/attribution/start name='voto'`, abre uma co-rotina via `tcp.execute`, conecta-se a `manoelcampos.com:80`, envia `GET .../votacao2.php?voto=<sim|nao>`, recebe um trecho de código Lua (gerado pelo PHP) que cria a tabela `votos = { sim, nao, url }`, executa-o com `loadstring`, desenha o resultado (`writeResult`) e por fim atribui `result=1` para que o NCL encerre o nó (elo 6).

## 4. Execução

```bash
cd enquete-ncl
ginga main.ncl
```

**Comportamento esperado:** o vídeo Creative Commons inicia em tela cheia. Surgem os dois botões (Sim/Não) com fade na faixa inferior esquerda, e o objeto NCLua escreve a pergunta "Você é a favor da doação de órgãos?". O usuário vota com a tecla verde (Sim) ou vermelha (Não); ao votar, o botão oposto some imediatamente e o botão escolhido some 1s depois. O script então tenta enviar o voto ao servidor remoto, recebe a tabela com os totais e exibe na faixa "Sim: N", "Não: M" e a URL; 10s após exibir o resultado, o nó Lua é interrompido.

**Resultado verificado:** ✅ O documento **carrega e roda** no Ginga atual — vídeo de fundo, botões Sim/Não e a faixa NCLua com a pergunta aparecem, e a seleção por teclas coloridas funciona. A etapa de **envio do voto/obtenção do resultado não se completa** porque o backend PHP (`manoelcampos.com/votacao/votacao2.php`) está fora do ar há anos; a UI de votação, porém, é apresentada corretamente. — ver captura [`../enquete-ncl/screenshots/enquete.png`](../enquete-ncl/screenshots/enquete.png).

## 5. Observações

- **Correção de compatibilidade (o que tornou o app executável).** O Ginga atual embarca **Lua 5.3**, mas os scripts deste app foram escritos para **Lua 5.1**: `tcp.lua` usa `module 'tcp'` (e variáveis de ambiente do estilo 5.1) e `votacao.lua` depende desse módulo. As funções `module()`/`setfenv()` foram **removidas no Lua 5.2+**, então o carregamento abortava logo no início com `attempt to call a nil value (global 'module')`. A correção foi adicionar o shim **`enquete-ncl/compat.lua`** (arquivo novo) que reativa `module`, `setfenv`, `getfenv` e `package.seeall` via biblioteca `debug`, e inserir **uma única linha** no topo do entry `votacao.lua`: `require "compat"`. **Nenhuma linha da lógica original foi alterada.** Detalhes em [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md).

- **Dependência de backend morto.** O envio do voto vai para `http://manoelcampos.com/votacao/votacao2.php?voto=<sim|nao>` (ver `votacao.lua`). Esse serviço não responde mais, então a parte de contagem/resultado não funciona. O arquivo `votacao2.php` está presente na pasta apenas como referência do contrato (ele devolvia um trecho de código Lua criando a tabela `votos`); não há servidor PHP rodando.

- **Dependência de canal de retorno e de rede.** Mesmo com o PHP no ar, a votação exige interatividade com canal de retorno (TCP) habilitada no ambiente Ginga; `tcp.lua` usa co-rotinas para não bloquear a apresentação enquanto aguarda a resposta HTTP.

- **Fonte de texto.** O texto da pergunta e do resultado usa a fonte `vera` (`vera.ttf` presente na pasta); se a fonte não estiver registrada no ambiente do Ginga, o `attrFont("vera", 24)` pode cair em fonte substituta.

- **Mídias locais.** Botões `media/sim.png` e `media/nao.png` e o vídeo `media/Wanna_Work_Together_-_Creative_Commons.avi` são referenciados por caminho relativo; executar a partir da pasta `enquete-ncl/` para que resolvam.

- **Conectores não usados.** `onBeginSet` e `onKeySelecionStop` estão declarados na `connectorBase` mas nenhum elo do corpo os referencia.

- **Encoding do `.ncl`:** `ISO-8859-1` (atenção à acentuação ao editar).
