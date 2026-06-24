---
# RFC-0010: Animação de propriedades via `set` com `duration`/`by`

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/08animation.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/08animation.png`](../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/08animation.png) |

## 1. Resumo

Este documento descreve o exemplo `08animation.ncl`, cujo foco é a **animação de propriedades de mídia** em NCL. A animação é obtida por meio da ação `set` de um conector causal, parametrizada com `duration` (e `delay`): em vez de atribuir um novo valor a uma propriedade instantaneamente, o Ginga interpola o valor antigo até o novo valor ao longo do tempo indicado em `duration`. O exemplo aplica isso a duas propriedades distintas — a posição vertical (`top`) de uma foto e os limites (`bounds`) de um vídeo reutilizado — combinando-as ainda com transições (`fade`/`barWipe`), `switch` por idioma e reúso de nó (`refer`).

## 2. Conceitos NCL demonstrados

- **Animação de propriedade** com `set` + `duration` (interpolação temporal do valor, ex.: `top` de `0`→`290` em `3s` após `1s` de `delay`).
- **Animação de `bounds`** (posição + tamanho num único atributo: `left,top,width,height`) disparada por interação do usuário e por fim de evento.
- **`set` instantâneo vs. animado**: o mesmo `bounds` é alterado de forma abrupta (sem `duration`) num link e de forma gradual (com `duration`) noutro.
- **Reúso de nó** com `<media refer="animation" instance="instSame">` para animar o próprio vídeo principal já em exibição.
- **Âncoras de conteúdo** (`<area>` com `begin`/`end`) servindo de gatilho temporal para outros links (`onBegin`).
- **`<property>`** declarada explicitamente na mídia (`top`, `bounds`) para poder ser alvo de `set`.
- **Transições** de mídia (`transIn`/`transOut` → `fade`, `barWipe`).
- **`switch` por regra** (`ruleBase` sobre `system.language`) com `bindRule` e `defaultComponent`.
- **Conectores causais importados** via `<importBase>` (`onBegin → start`, `onEnd → stop`, `onSelection` por tecla, com `delay`/`duration`/`var`).
- **Descritores com `explicitDur`** e `descriptorParam` (`transparency`).

## 3. Estrutura do documento

Documento `ncl id="switchEx"`, perfil `EDTVProfile`, codificação ISO-8859-1.

### 3.1 Layout — regiões e descritores

Regiões (`<regionBase>`), com `screenReg` contendo regiões filhas aninhadas:

| Região | left | top | width | height | zIndex | Observação |
|--------|------|-----|-------|--------|--------|------------|
| `backgroundReg` | — | — | 100% | 100% | 1 | fundo |
| `screenReg` | — | — | 100% | 100% | 2 | container (filhas abaixo) |
| `frameReg` | 5% | 6.7% | 18.5% | 18.5% | 3 | quadro (foto/drible) |
| `iconReg` | 87.5% | 11.7% | 8.45% | 6.7% | 3 | ícone |
| `shoesReg` | 15% | 60% | 25% | 25% | 3 | vídeo dos chuteiras |
| `formReg` | 57.25% | 9.83% | 37.75% | 70.2% | 3 | formulário HTML |

Descritores (`<descriptorBase>`):

| Descritor | region | Atributos relevantes |
|-----------|--------|----------------------|
| `backgroundDesc` | `backgroundReg` | — |
| `screenDesc` | `screenReg` | — |
| `photoDesc` | `frameReg` | `explicitDur="5s"`, `descriptorParam transparency="0.6"` |
| `audioDesc` | (sem region) | usado para a trilha de áudio |
| `dribleDesc` | `frameReg` | `transIn="trans1"` (fade), `transOut="trans2"` (barWipe) |
| `iconDesc` | `iconReg` | `explicitDur="6s"` |
| `shoesDesc` | `shoesReg` | — |
| `formDesc` | `formReg` | `focusIndex="1"`, `explicitDur="15s"` |

Bases auxiliares no `<head>`:
- `<ruleBase>`: regra `en` → `system.language == "eng"`.
- `<transitionBase>`: `trans1` (`type="fade"`, `dur="2s"`), `trans2` (`type="barWipe"`, `dur="1s"`).

### 3.2 Conectores

Os conectores são importados de `causalConnBase.ncl` via
`<importBase documentURI="causalConnBase.ncl" alias="conEx"/>` e referenciados como `conEx#<id>`. Os efetivamente usados neste exemplo:

| Conector | Condição → Ação | Params | Papel no exemplo |
|----------|-----------------|--------|------------------|
| `onBeginStart` | `onBegin` → `start` (par, unbounded) | — | dispara mídias ao começar um evento/âncora |
| `onBeginStart_delay` | `onBegin` → `start delay="$delay"` | `delay` | inicia fundo/áudio com atraso de 5s |
| `onEndStop` | `onEnd` → `stop` (par, unbounded) | — | encerra fundo e áudio ao fim do vídeo |
| `onKeySelectionStopSet_varStart` | `onSelection key="$keyCode"` → seq(`stop`, `set value="$var"`, `start`) | `var`, `keyCode` | interação RED: para ícone, **anima** `bounds` e inicia shoes/form |
| `onEndSet_var` | `onEnd` → `set value="$var"` | `var` | ao fim do form, restaura `bounds` do vídeo |
| `onBeginStartSet_var_delay_duration` | `onBegin` → seq(`start`, `set value="$var" delay="$delay" duration="$duration"`) | `var`, `delay`, `duration` | **anima** a propriedade `top` da foto |

O conector-chave para a **animação** é `onBeginStartSet_var_delay_duration`: a ação `set` carrega `value="$var"` junto de `delay="$delay"` e `duration="$duration"`. É a presença de `duration` que transforma a atribuição em uma interpolação temporal (animação) em vez de uma troca instantânea de valor.

### 3.3 Mídias

No `<body>`:

| `id` | `src` | descritor / refer | Interfaces |
|------|-------|-------------------|------------|
| `background` | `../media/background.png` | `backgroundDesc` | — |
| `animation` | `../media/animGar.mp4` | `screenDesc` | `<area segDrible begin="12s">`, `<area segPhoto begin="41s">`, `<area segIcon begin="45s" end="51s">` |
| `choro` | `../media/choro.mp4` | `audioDesc` | — (trilha de áudio) |
| `drible` | `../media/drible.mp4` | `dribleDesc` | — |
| `photo` | `../media/photo.png` | `photoDesc` | `<property name="top">` (alvo da animação) |

No `<context id="advert">`:

| `id` | `src` / `refer` | descritor | Interfaces |
|------|-----------------|-----------|------------|
| `reusedAnimation` | `refer="animation" instance="instSame"` | (herda) | `<property name="bounds">` (alvo da animação) |
| `icon` | `../media/icon.png` | `iconDesc` | — |
| `shoes` | `../media/shoes.mp4` | `shoesDesc` | — |
| `form` (`<switch>`) | — | — | `<switchPort id="spForm">` mapeando `enForm`/`ptForm` |
| `ptForm` | `../media/ptForm.htm` | `formDesc` | (defaultComponent) |
| `enForm` | `../media/enForm.htm` | `formDesc` | (bindRule `en`) |

Pontos relevantes:
- `reusedAnimation` é uma **segunda instância do mesmo nó** `animation` (mesmo conteúdo/evento via `instance="instSame"`); animar seu `bounds` redimensiona/realoca o vídeo principal já em tela.
- `photo` declara a propriedade `top`; `reusedAnimation` declara `bounds`. Sem essas declarações de `<property>`, o `set` não teria interface-alvo.
- O ponto de entrada do documento é `<port id="entry" component="animation"/>` — a apresentação começa pelo vídeo principal.

### 3.4 Elos e temporização

Linha do tempo conduzida pelo vídeo `animation` (que começa pelo `port entry`):

1. **`lMusic`** (`onBeginStart_delay`): ao começar `animation`, inicia `background` e `choro` com `delay=5s` cada. Fundo e trilha entram 5s após o vídeo.
2. **`lDrible`** (`onBeginStart`): ao atingir a âncora `segDrible` (12s), inicia `drible` na `frameReg`, com transição de entrada `fade` e de saída `barWipe` (via `dribleDesc`).
3. **`lPhoto`** (`onBeginStartSet_var_delay_duration`): ao atingir `segPhoto` (41s), inicia `photo` e **anima** sua propriedade `top` para `290` com `delay=1s` e `duration=3s`. A foto desliza verticalmente de forma interpolada ao longo de 3s.
4. **`lIcon`** (no contexto `advert`, `onBeginStart`): ao atingir `segIcon` (45s–51s) de `reusedAnimation`, inicia `icon` na `iconReg` (visível por `explicitDur=6s`).
5. **`lBegingShoes`** (`onKeySelectionStopSet_varStart`, no `advert`): ao pressionar a tecla **RED** sobre `icon`, executa em sequência: `stop icon`, `start shoes`, `start form` (switch) e **`set` no `bounds`** de `reusedAnimation` para `5%,6.67%,45%,45%`. Aqui o `bounds` é alterado **sem** `duration` (mudança imediata: o vídeo principal encolhe e se reposiciona para abrir espaço ao conteúdo do anúncio).
6. **`lEndForm`** (`onEndSet_var`, no `advert`): ao terminar `form` (após `explicitDur=15s`), faz `set bounds = "0,0,222.22%,222.22%"` em `reusedAnimation`, restaurando/ampliando o vídeo de volta à tela cheia (também `set` instantâneo).
7. **`lEnd`** (`onEndStop`): ao fim de `animation`, para `background` e `choro`, encerrando a apresentação.

Sincronismo: gatilhos temporais vêm das `<area>` do vídeo principal (`onBegin`/`onEnd` de âncoras), e a interação do usuário (tecla RED sobre o ícone) introduz o ramo do anúncio. O contraste pedagógico do exemplo é justamente **`set` com `duration`** (links `lPhoto`, animação suave de `top`) versus **`set` sem `duration`** (links `lBegingShoes`/`lEndForm`, troca abrupta de `bounds`).

> Nota sobre o título "by/duration": o conector de animação usado emprega `duration` (interpolação ao longo de um intervalo). NCL 3.0 também admite `by` (velocidade/passo da animação) na ação `set`; no arquivo real deste exemplo o atributo presente é `duration` (mais `delay`), não `by`.

## 4. Execução

```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga 08animation.ncl
```

**Comportamento esperado:** o vídeo principal (`animGar.mp4`) inicia em tela cheia; 5s depois entram o fundo e a trilha (`choro`). Aos 12s surge o `drible` no quadro com transição de fade/barWipe. Aos 41s a `photo` aparece e **desliza verticalmente** (animação de `top`, 3s). Aos 45s aparece o `icon` no canto; ao pressionar **RED**, o vídeo principal **encolhe** (`bounds` reposicionado), o vídeo `shoes` toca e o formulário HTML (PT ou EN conforme idioma do sistema) é exibido. Ao fim do formulário (15s), o vídeo **volta a ocupar a tela** (`bounds` restaurado). No fim do vídeo principal, fundo e áudio são parados.

**Resultado verificado:** ✅ Documento carrega e roda no Ginga; a animação de `top` da foto (interpolada via `duration`) e as trocas de `bounds` do vídeo reutilizado ocorrem conforme os links acima — ver captura.

## 5. Observações

- **Dependência de mídia local:** o exemplo requer os arquivos em `../media/` relativos à pasta `Exemplos`: `background.png`, `animGar.mp4`, `choro.mp4`, `drible.mp4`, `photo.png`, `icon.png`, `shoes.mp4`, `ptForm.htm`, `enForm.htm` (todos presentes no repositório).
- **Conector importado:** a animação depende de `causalConnBase.ncl` (mesma pasta), importado com `alias="conEx"`. Sem ele, os `xconnector="conEx#..."` não resolvem.
- **Formulário HTML:** `ptForm.htm`/`enForm.htm` exigem suporte a HTML/browser embutido no exibidor; a seleção entre eles depende de `system.language` (regra `en`). Em sistema não configurado para inglês, o `defaultComponent` carrega `ptForm`.
- **Interação obrigatória:** o ramo do anúncio (shoes/form e as animações de `bounds`) só ocorre se o usuário pressionar a tecla **RED** enquanto o `icon` está em foco/visível (janela de ~6s a partir dos 45s).
- **`refer`/`instance="instSame"`:** o redimensionamento via `bounds` atua sobre o mesmo evento de apresentação do vídeo principal; é por isso que alterar `bounds` em `reusedAnimation` afeta o vídeo já em tela.
- **`bounds` em percentuais:** o valor `0,0,222.22%,222.22%` extrapola 100% propositalmente para reposicionar/escalar o vídeo de volta para além da `screenReg` filha após o anúncio.
