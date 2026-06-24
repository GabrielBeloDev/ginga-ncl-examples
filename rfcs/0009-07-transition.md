---
# RFC-0009: Transições visuais (`<transition>` fade/barWipe)

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/07transition.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/07transition.png`](../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/07transition.png) |

## 1. Resumo

Este documento descreve o exemplo `07transition.ncl`, que demonstra o uso de **transições visuais** em NCL por meio da `<transitionBase>` e do elemento `<transition>`. O ponto central é a definição de duas transições reutilizáveis — um *fade* de 2s e um *barWipe* de 1s — e sua aplicação à entrada (`transIn`) e à saída (`transOut`) de uma mídia de vídeo através de um `<descriptor>`. O exemplo reaproveita toda a infraestrutura dos exemplos anteriores (reúso de nó com `refer`, `switch` por idioma, contexto, conectores causais importados) e acrescenta sobre ela a camada de efeitos de transição.

## 2. Conceitos NCL demonstrados

- **`<transitionBase>` e `<transition>`** — definição de efeitos de transição reutilizáveis (`type="fade"`, `type="barWipe"`, atributo `dur`).
- **Aplicação de transição via descritor** — atributos `transIn` / `transOut` em `<descriptor>` referenciando IDs de `<transition>`.
- **Regiões aninhadas e `zIndex`** — sobreposição de planos (fundo, tela, quadros internos).
- **Descritores com `explicitDur`** — duração explícita imposta a mídias estáticas.
- **Conectores causais importados** — `<importBase>` de `causalConnBase.ncl` (relações `onBegin→start`, `onEnd→stop`, `onSelection→stop/set/start`).
- **Âncoras de conteúdo (`<area>`)** — segmentos temporais de um vídeo usados como condições de sincronismo.
- **Reúso de nó (`refer` / `instance`)** e manipulação de `bounds` via `<property>`.
- **`<switch>` com `<bindRule>`** — seleção de mídia (formulário) por idioma do sistema.
- **`<ruleBase>` / `<rule>`** — regra sobre `system.language`.

## 3. Estrutura do documento

Documento `ncl id="switchEx"`, perfil `http://www.ncl.org.br/NCL3.0/EDTVProfile`.

### 3.1 Layout — regiões e descritores

**Transições (`<transitionBase>`):**

| id | type | dur |
|------|--------|-----|
| `trans1` | `fade` | `2s` |
| `trans2` | `barWipe` | `1s` |

**Regiões (`<regionBase>`):**

| id | left | top | width | height | zIndex | observação |
|----|------|-----|-------|--------|--------|------------|
| `backgroundReg` | — | — | 100% | 100% | 1 | tela inteira, plano de fundo |
| `screenReg` | — | — | 100% | 100% | 2 | tela inteira, contém as regiões filhas |
| `frameReg` | 5% | 6.7% | 18.5% | 18.5% | 3 | quadro (foto/drible), aninhada em `screenReg` |
| `iconReg` | 87.5% | 11.7% | 8.45% | 6.7% | 3 | ícone, aninhada em `screenReg` |
| `shoesReg` | 15% | 60% | 25% | 25% | 3 | vídeo de chuteira, aninhada em `screenReg` |
| `formReg` | 57.25% | 9.83% | 37.75% | 70.2% | 3 | formulário HTML, aninhada em `screenReg` |

`frameReg`, `iconReg`, `shoesReg` e `formReg` são filhas de `screenReg`, herdando seu sistema de coordenadas.

**Descritores (`<descriptorBase>`):**

| id | region | atributos relevantes |
|----|--------|----------------------|
| `backgroundDesc` | `backgroundReg` | — |
| `screenDesc` | `screenReg` | — |
| `photoDesc` | `frameReg` | `explicitDur="5s"` |
| `audioDesc` | (sem região) | descritor de áudio |
| `dribleDesc` | `frameReg` | **`transIn="trans1"` `transOut="trans2"`** |
| `iconDesc` | `iconReg` | `explicitDur="6s"` |
| `shoesDesc` | `shoesReg` | — |
| `formDesc` | `formReg` | `focusIndex="1"` `explicitDur="15s"` |

O descritor-chave deste exemplo é `dribleDesc`: a mídia `drible` aparece com transição de **entrada** `fade` (2s) e desaparece com transição de **saída** `barWipe` (1s).

### 3.2 Conectores

Os conectores são importados via `<importBase documentURI="causalConnBase.ncl" alias="conEx"/>`. Os conectores realmente referenciados pelos elos deste documento são:

| Conector (`conEx#...`) | Condição | Ação | Parâmetros |
|------------------------|----------|------|------------|
| `onBeginStart` | `onBegin` | `start` (`max="unbounded"`, `par`) | — |
| `onBeginStart_delay` | `onBegin` | `start` com `delay="$delay"` (`par`) | `delay` |
| `onEndStop` | `onEnd` | `stop` (`par`) | — |
| `onKeySelectionStopSet_varStart` | `onSelection key="$keyCode"` | `compoundAction seq`: `stop` → `set value="$var"` → `start` | `var`, `keyCode` |
| `onEndSet_var` | `onEnd` | `set value="$var"` | `var` |

### 3.3 Mídias

Mídias no corpo (`<body>`) e no contexto `advert`:

| id | src | descritor | âncoras / propriedades |
|----|-----|-----------|------------------------|
| `background` | `../media/background.png` | `backgroundDesc` | — |
| `animation` | `../media/animGar.mp4` | `screenDesc` | `<area id="segDrible" begin="12s"/>`, `<area id="segPhoto" begin="41s"/>`, `<area id="segIcon" begin="45s" end="51s"/>` |
| `choro` | `../media/choro.mp4` | `audioDesc` | — |
| `drible` | `../media/drible.mp4` | `dribleDesc` | **mídia com `transIn`/`transOut`** |
| `photo` | `../media/photo.png` | `photoDesc` | — |
| `reusedAnimation` | `refer="animation"` `instance="instSame"` | — | `<property name="bounds"/>` |
| `icon` | `../media/icon.png` | `iconDesc` | — |
| `shoes` | `../media/shoes.mp4` | `shoesDesc` | — |
| `ptForm` | `../media/ptForm.htm` | `formDesc` | dentro do `<switch id="form">` (default) |
| `enForm` | `../media/enForm.htm` | `formDesc` | dentro do `<switch id="form">` (idioma `eng`) |

O `<port id="entry" component="animation"/>` é o ponto de entrada do documento: a apresentação inicia pela mídia `animation`.

O `<switch id="form">` seleciona entre `enForm` e `ptForm` conforme a regra `en` (`system.language eq "eng"`); o `<defaultComponent>` é `ptForm`. O `<switchPort id="spForm">` expõe ambos os mapeamentos para uso pelos elos.

### 3.4 Elos e temporização

**Elos no `<body>`:**

- **`lMusic`** (`onBeginStart_delay`): ao **iniciar** `animation`, inicia `background` e `choro`, ambos com `delay="5s"`. Ou seja, 5s após o vídeo principal começar, entram o plano de fundo e a trilha sonora.
- **`lDrible`** (`onBeginStart`): ao começar a âncora `segDrible` (12s do vídeo `animation`), inicia a mídia `drible` — é aqui que a **transição `fade` de entrada (`trans1`)** do `dribleDesc` se manifesta; ao terminar `drible`, atua a **transição `barWipe` de saída (`trans2`)**.
- **`lPhoto`** (`onBeginStart`): ao começar a âncora `segPhoto` (41s), inicia a mídia `photo` (exibida por `explicitDur="5s"`).
- **`lEnd`** (`onEndStop`): ao **terminar** `animation`, para `background` e `choro`, encerrando a apresentação.

**Elos no contexto `advert`:**

- **`lIcon`** (`onBeginStart`): ao começar a âncora `segIcon` (45s–51s) de `reusedAnimation`, inicia `icon` (mostrado por `explicitDur="6s"`).
- **`lBegingShoes`** (`onKeySelectionStopSet_varStart`): ao pressionar a tecla **VERMELHA** (`keyCode="RED"`) com foco em `icon`, executa em sequência: `start shoes`, `start form` (via `spForm`), `set bounds` de `reusedAnimation` para `5%,6.67%,45%,45%` (encolhe/reposiciona o vídeo) e `stop icon`.
- **`lEndForm`** (`onEndSet_var`): ao **terminar** o `form` (`spForm`), `set bounds` de `reusedAnimation` para `0,0,222.22%,222.22%` (restaura/amplia o vídeo a tela cheia).

Linha do tempo resumida (a partir do início de `animation`):

| t | evento |
|----|--------|
| 0s | `animation` inicia (entrada pelo `port entry`) |
| 5s | `background` + `choro` iniciam (delay do `lMusic`) |
| 12s | `segDrible` → `drible` entra com **fade 2s**, sai com **barWipe 1s** |
| 41s | `segPhoto` → `photo` (5s) |
| 45s–51s | `segIcon` → `icon` (6s); interação opcional com a tecla VERMELHA dispara `shoes` + `form` + reposicionamento do vídeo |
| fim de `animation` | `lEnd` para `background` e `choro` |

## 4. Execução

```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga 07transition.ncl
```

**Comportamento esperado:** o vídeo principal (`animGar.mp4`) inicia em tela cheia; após 5s entram o fundo e a trilha `choro`. No segundo 12 o clipe `drible` surge no quadro superior esquerdo com uma transição de **fade-in (2s)** e, ao se encerrar, sai com efeito **barWipe (1s)**. Aos 41s aparece a foto no mesmo quadro; entre 45s e 51s surge o ícone no canto superior direito. Pressionar a tecla **VERMELHA** enquanto o ícone está em foco inicia o vídeo da chuteira e o formulário HTML (em PT ou EN conforme o idioma), encolhendo o vídeo principal; ao fim do formulário o vídeo volta a tela cheia. Ao terminar o vídeo principal, fundo e trilha são interrompidos.

**Resultado verificado:** ✅ As transições `fade` (entrada) e `barWipe` (saída) sobre a mídia `drible` são aplicadas corretamente pelo descritor `dribleDesc`; o sincronismo por âncoras e a interação por tecla funcionam conforme descrito — ver captura.

## 5. Observações

- **Mídias locais:** todas as mídias estão em `../media/` (relativo à pasta `Exemplos`): `background.png`, `animGar.mp4`, `choro.mp4`, `drible.mp4`, `photo.png`, `icon.png`, `shoes.mp4`, `ptForm.htm`, `enForm.htm`. Todos os arquivos estão presentes no repositório (verificado em `PrimeiroJoao/media/`). O maior é `animGar.mp4` (~38 MB).
- **Dependência de conector:** o documento depende de `causalConnBase.ncl` (mesma pasta `Exemplos`) via `<importBase ... alias="conEx"/>`. A ausência desse arquivo quebraria a resolução de todos os `<link>`.
- **Suporte a transições no Ginga:** os efeitos `<transition>` (`fade`, `barWipe`) exigem suporte do formatador/renderizador. O Ginga C++ (telemidia/ginga) atual implementa esses tipos; em players parciais a mídia pode aparecer sem o efeito (corte direto), sem invalidar a lógica do documento.
- **Conteúdo HTML (`<media>` `.htm`):** os formulários `ptForm.htm`/`enForm.htm` exigem o suporte a mídia HTML (HTMLBrowser/NCLua HTML) do Ginga; em ambientes sem esse suporte, o `<switch>` ainda seleciona o nó, mas a renderização pode falhar.
- **Interação:** o efeito da tecla VERMELHA (`lBegingShoes`) só ocorre durante a janela de exibição do `icon` (45s–51s), quando ele detém o foco (`focusIndex` herdado do fluxo de interação); fora dessa janela não há reação.
- **Particularidade de IDs:** mantidos exatamente como no arquivo original, inclusive o `id="lBegingShoes"` (grafia do autor) e o atributo `id="switchEx"` do `<ncl>`, herdado do exemplo de `switch`.
---
