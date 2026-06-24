---
# RFC-0011: Nó settings e variáveis globais

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/09settings.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/09settings.png`](../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/09settings.png) |

## 1. Resumo

Este documento demonstra o uso do **nó `settings`** (mídia do tipo `application/x-ginga-settings`) e de **variáveis globais** de ambiente em NCL. O exemplo combina diversos recursos já vistos na trilha "Primeiro João" (regiões aninhadas, descritores com transição/duração explícita, reúso e reaproveitamento de instâncias via `refer`, `switch` por idioma, segmentação temporal por `<area>`) com um nó de configuração global que armazena a variável `service.interactivity`. Essa variável é escrita (`set`) e lida (em `assessmentStatement`) por elos, controlando se a oferta de interatividade aparece e se reativa-se a alteração de bounds da animação reaproveitada.

## 2. Conceitos NCL demonstrados

- **Nó `settings`** (`<media type="application/x-ginga-settings">`) com `<property>` de variável global (`service.interactivity`).
- **Variáveis globais de ambiente** lidas via `assessmentStatement`/`attributeAssessment` no conector `onBeginVarStart` (papel `var`).
- **Reúso de nó settings** entre contextos com `refer` + `instance="instSame"` (`reusedGlobalVar`).
- **Reúso de mídia** (`refer`/`instance="instSame"`) da animação principal em dois contextos (`anotherAnimation`, `reusedAnimation`).
- **Conectores causais importados** via `<importBase>` (alias `conEx`) — condições `onBegin`/`onEnd`/`onSelection` e ações `start`/`stop`/`set` com `compoundAction operator="seq"`.
- **Segmentação temporal** com `<area begin/end>` na animação (`segDrible`, `segPhoto`, `segIcon`).
- **`switch`** com seleção por regra de idioma (`system.language`) entre formulário PT e EN.
- **`transitionBase`** (`fade`, `barWipe`) aplicada via `transIn`/`transOut` em descritor.
- **Animação de propriedade** com `set` parametrizado por `delay`/`duration` (`onBeginStartSet_var_delay_duration`).
- **Interatividade por tecla** (`onSelection` com `keyCode` `INFO`/`RED`).
- **Contextos** (`interactivity`, `advert`) com encerramento por `stop` de contexto inteiro.

## 3. Estrutura do documento

Documento `ncl id="settingsEx"`, perfil `EDTVProfile`, encoding `ISO-8859-1`.

### 3.1 Layout — regiões e descritores

**Bases de regiões** (`<regionBase>`):

| Região | Posição / Tamanho | zIndex | Observação |
|--------|-------------------|--------|------------|
| `backgroundReg` | `width=100%`, `height=100%` | 1 | Fundo de tela |
| `screenReg` | `width=100%`, `height=100%` | 2 | Vídeo principal; contém as regiões aninhadas abaixo |
| `frameReg` | `left=5%` `top=6.7%` `width=18.5%` `height=18.5%` | 3 | Aninhada em `screenReg`; usada por foto e drible |
| `iconReg` | `left=87.5%` `top=11.7%` `width=8.45%` `height=6.7%` | 3 | Ícone da oferta de calçado |
| `shoesReg` | `left=15%` `top=60%` `width=25%` `height=25%` | 3 | Vídeo do tênis |
| `formReg` | `left=57.25%` `top=9.83%` `width=37.75%` `height=70.2%` | 3 | Formulário HTML (switch) |
| `intReg` | `left=92.5%` `top=91.7%` `width=5.07%` `height=6.51%` | 3 | Ícone de interatividade (canto inferior direito) |

**Descritores** (`<descriptorBase>`):

| Descritor | Região | Parâmetros relevantes |
|-----------|--------|------------------------|
| `backgroundDesc` | `backgroundReg` | — |
| `screenDesc` | `screenReg` | — |
| `photoDesc` | `frameReg` | `explicitDur="5s"`; `descriptorParam transparency=0.6` |
| `audioDesc` | (sem região) | descritor de áudio |
| `dribleDesc` | `frameReg` | `transIn="trans1"` (fade), `transOut="trans2"` (barWipe) |
| `iconDesc` | `iconReg` | `explicitDur="6s"` |
| `shoesDesc` | `shoesReg` | — |
| `formDesc` | `formReg` | `focusIndex="1"`, `explicitDur="15s"` |
| `intDesc` | `intReg` | — |

Há ainda uma `<ruleBase>` com a regra `en` (`system.language eq "en"`) e uma `<transitionBase>` com `trans1` (`fade`, `2s`) e `trans2` (`barWipe`, `1s`).

### 3.2 Conectores

Os conectores são **importados** do arquivo `causalConnBase.ncl` (`<importBase documentURI="causalConnBase.ncl" alias="conEx"/>`). Os usados neste exemplo:

| Conector (`conEx#…`) | Condição | Ação | Parâmetros |
|----------------------|----------|------|------------|
| `onBeginStart` | `onBegin` | `start` (par, `max=unbounded`) | — |
| `onBeginStart_delay` | `onBegin` | `start` com `delay="$delay"` (par) | `delay` |
| `onEndStop` | `onEnd` | `stop` (par) | — |
| `onBeginSet_varStart` | `onBegin` | `seq`: `set "$var"` → `start` (par) | `var` |
| `onKeySelectionStopSet_varStart` | `onSelection key="$keyCode"` | `seq`: `stop` → `set "$var"` → `start` | `var`, `keyCode` |
| `onEndSet_var` | `onEnd` | `set "$var"` | `var` |
| `onBeginVarStart` | `and`(`onBegin`, `assessmentStatement` `var eq "true"`) | `start` | papel `var` é `attributeAssessment` (nodeProperty/attribution) |
| `onBeginStartSet_var_delay_duration` | `onBegin` | `seq`: `start` → `set "$var" delay="$delay" duration="$duration"` | `var`, `delay`, `duration` |

O conector-chave para variáveis globais é **`onBeginVarStart`**: ele só dispara a ação `start` se, ao iniciar a condição `onBegin`, a propriedade ligada ao papel `var` for igual a `"true"` — ou seja, faz a leitura condicional da variável global do `settings`.

### 3.3 Mídias

**Corpo principal (`<body>`):**

| Mídia | `src` / tipo | Descritor | Áreas / Propriedades |
|-------|--------------|-----------|----------------------|
| `background` | `../media/background.png` | `backgroundDesc` | — |
| `animation` | `../media/animGar.mp4` | `screenDesc` | `<area segDrible begin=12s>`, `<area segPhoto begin=41s>`, `<area segIcon begin=45s end=51s>` |
| `choro` | `../media/choro.mp4` | `audioDesc` | — |
| `drible` | `../media/drible.mp4` | `dribleDesc` | — |
| `photo` | `../media/photo.png` | `photoDesc` | `<property name="top">` |

Há um `<port id="entry" component="animation"/>` — o ponto de entrada do documento é a animação principal.

**Contexto `interactivity`:**

| Mídia | Definição | Descritor |
|-------|-----------|-----------|
| `globalVar` | `type="application/x-ginga-settings"` com `<property name="service.interactivity" value="true"/>` | — (nó settings) |
| `anotherAnimation` | `refer="animation"` `instance="instSame"` | — (reúso da animação) |
| `intOn` | `../media/intOn.png` | `intDesc` |
| `intOff` | `../media/intOff.png` | `intDesc` |

**Contexto `advert`:**

| Mídia | Definição | Descritor |
|-------|-----------|-----------|
| `reusedAnimation` | `refer="animation"` `instance="instSame"`, com `<property name="bounds"/>` | — (reúso da animação) |
| `reusedGlobalVar` | `refer="globalVar"` `instance="instSame"` | — (reúso do settings) |
| `icon` | `../media/icon.png` | `iconDesc` |
| `shoes` | `../media/shoes.mp4` | `shoesDesc` |
| `form` (switch) | `switchPort spForm` → `enForm`/`ptForm`; regra `en` seleciona `enForm`, default `ptForm` | `ptForm`=`../media/ptForm.htm`, `enForm`=`../media/enForm.htm`, ambos `formDesc` |

O nó `settings` (`globalVar`) é o ponto central: ele guarda a variável global `service.interactivity`. A propriedade é declarada com valor inicial `"true"`, mas é reescrita pelos elos durante a execução (toggle ON/OFF).

### 3.4 Elos e temporização

**No contexto `interactivity`:**

- `lInt` (`onBeginSet_varStart`): ao **iniciar** `anotherAnimation`, faz `set service.interactivity = "true"` no `globalVar` e `start intOn`. Ativa a oferta de interatividade no início.
- `lOn` (`onKeySelectionStopSet_varStart`, `keyCode=INFO`): ao selecionar `intOn` com a tecla **INFO**, faz `stop intOn`, `set service.interactivity = "false"` e `start intOff`. Desliga a interatividade.
- `lOff` (`onKeySelectionStopSet_varStart`, `keyCode=INFO`): ao selecionar `intOff` com **INFO**, faz `stop intOff`, `set service.interactivity = "true"` e `start intOn`. Religa. Os elos `lOn`/`lOff` formam um toggle por tecla sobre a variável global.

**No contexto `advert`:**

- `lIcon` (`onBeginVarStart`): condição composta — ao iniciar a `<area segIcon>` da `reusedAnimation` **E** se `reusedGlobalVar#service.interactivity == "true"`, então `start icon`. Aqui a **variável global é lida** para decidir se o ícone de oferta aparece.
- `lBegingShoes` (`onKeySelectionStopSet_varStart`, `keyCode=RED`): ao selecionar `icon` com a tecla **RED**, faz `start shoes`, `start form` (via `spForm`), `set reusedAnimation#bounds = "5%,6.67%,45%,45%"` (encolhe/move a animação) e `stop icon`.
- `lEndForm` (`onEndSet_var`): ao **terminar** o `form` (`spForm`), faz `set reusedAnimation#bounds = "0,0,222.22%,222.22%"` — restaura a animação à tela cheia.

**No corpo (`<body>`):**

- `lMusic` (`onBeginStart_delay`): ao iniciar `animation`, `start background` e `start choro`, ambos com `delay=5s`.
- `lDrible` (`onBeginStart`): ao iniciar a `<area segDrible>` (12s), `start drible`.
- `lPhoto` (`onBeginStartSet_var_delay_duration`): ao iniciar a `<area segPhoto>` (41s), `start photo` e `set photo#top = "290"` com `delay=1s`, `duration=3s` (anima a posição vertical da foto).
- `lEnd` (`onEndStop`): ao **terminar** `animation`, `stop background`, `stop choro` e `stop interactivity` (encerra o contexto inteiro de interatividade).

**Sincronismo geral:** o documento parte de `animation` (porta `entry`). Em paralelo, fundo e áudio entram após 5s. As `<area>` da animação disparam segmentos sincronizados (drible aos 12s, foto aos 41s, ícone 45–51s). A interatividade é governada pela variável global `service.interactivity`, escrita por seleção de tecla e lida na condição do `lIcon`. Ao fim da animação principal, tudo é parado.

## 4. Execução

```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga 09settings.ncl
```

**Comportamento esperado:** inicia a animação `animGar.mp4` em tela cheia; após 5s entram o fundo (`background.png`) e a música (`choro.mp4`). Aos 12s, durante o segmento `segDrible`, surge no quadro (`frameReg`) o vídeo `drible.mp4` com transição de entrada *fade* e saída *barWipe*. Aos 41s aparece a foto (`photo.png`) com 60% de transparência, animando sua posição `top`. Aos 45–51s (`segIcon`), **se** a variável global `service.interactivity` estiver em `"true"`, surge o ícone de oferta (`icon.png`) no canto. Pressionando **RED** sobre o ícone, abrem-se o vídeo do tênis (`shoes.mp4`) e o formulário HTML (PT ou EN conforme `system.language`), enquanto a animação principal encolhe; ao fim do formulário ela volta à tela cheia. O ícone de interatividade no canto inferior direito (`intOn`/`intOff`) pode ser alternado com a tecla **INFO**, escrevendo `true`/`false` no nó settings.

**Resultado verificado:** ✅ O documento é carregado e executado pelo Ginga; a animação roda, os segmentos sincronizados disparam nos tempos definidos pelas `<area>`, o nó `settings` armazena e expõe `service.interactivity`, e os elos de leitura/escrita da variável global controlam a exibição condicional da oferta de interatividade — ver captura.

## 5. Observações

- **Mídias locais:** todas referenciam `../media/` (relativo a `Exemplos/`). Os arquivos usados existem no diretório `media/`: `background.png`, `animGar.mp4`, `choro.mp4`, `drible.mp4`, `photo.png`, `icon.png`, `shoes.mp4`, `intOn.png`, `intOff.png`, `ptForm.htm`, `enForm.htm`.
- **Conector externo:** depende de `causalConnBase.ncl` (mesma pasta `Exemplos/`), importado com alias `conEx`. Todos os conectores referenciados (`onBeginStart`, `onBeginStart_delay`, `onEndStop`, `onBeginSet_varStart`, `onKeySelectionStopSet_varStart`, `onEndSet_var`, `onBeginVarStart`, `onBeginStartSet_var_delay_duration`) existem nesse arquivo.
- **Nó settings:** `globalVar` é declarado uma única vez no contexto `interactivity` e reaproveitado em `advert` via `refer`/`instance="instSame"` (`reusedGlobalVar`); ambas as referências apontam para a mesma instância da variável global. O mesmo padrão de reúso aplica-se à `animation` (`anotherAnimation`, `reusedAnimation`).
- **Variável de ambiente:** `service.interactivity` é uma variável de configuração de serviço. A regra comentada no `<ruleBase>` (`service.interactivity eq "true"`) indica que o exemplo também pode usá-la como regra de seleção, mas no estado atual a leitura ocorre via `assessmentStatement` do conector `onBeginVarStart`.
- **Interação por teclas:** requer controle remoto/teclado com as teclas **INFO** e **RED** mapeadas; a oferta de tênis depende da seleção do ícone com RED, e o toggle de interatividade depende de INFO.
- **Idioma:** o `switch form` seleciona `enForm.htm` quando `system.language == "en"`; caso contrário usa `ptForm.htm` (default).
- **Limitações:** o exemplo depende dos arquivos de mídia locais e do conector importado estarem presentes na árvore do repositório; ausência de qualquer um impede a execução completa. Caso o repositório use Git LFS para os `.mp4`/`.png`, é necessário `git lfs pull` antes de rodar.
