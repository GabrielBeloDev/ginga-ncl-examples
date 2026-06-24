# RFC-0004: Sincronismo com âncoras de conteúdo

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/02syncInt.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../screenshots/02syncInt.png`](../screenshots/02syncInt.png) |

## 1. Resumo

Este documento demonstra **sincronismo baseado em âncoras de conteúdo** (intervalos temporais)
de uma mídia de vídeo. A partir de uma única animação principal (`animGar.mp4`), o exemplo
define âncoras `<area>` com marcas de tempo (`begin`/`end`) que disparam o início de outras
mídias em momentos específicos da reprodução — sem qualquer ação do usuário. Em seguida o
exemplo combina esse sincronismo automático com **interatividade** (tecla RED) e com
manipulação dinâmica da propriedade `bounds` do vídeo principal, mostrando como reposicioná-lo
em tela durante a apresentação.

## 2. Conceitos NCL demonstrados

- **Âncoras de conteúdo (`<area>`)** com `begin` e `begin`/`end` para marcar intervalos dentro de um vídeo.
- **Sincronismo causal** entre nós: `onBegin` de uma âncora → `start` de outra mídia.
- **Regiões aninhadas** (`<region>` dentro de `<region>`) e uso de `zIndex` para empilhamento.
- **Descritores** com duração explícita (`explicitDur`) sobrepondo a duração natural da mídia.
- **Importação de base de conectores** via `<importBase>` com `alias`.
- **Conectores causais** parametrizados (`connectorParam`, `$delay`, `$var`, `$keyCode`).
- **Interatividade por tecla** (`onSelection` com `keyCode="RED"`).
- **Manipulação de propriedade** em tempo de execução: `set` na `<property name="bounds"/>`
  para mover/redimensionar o vídeo principal (efeito picture-in-picture / retorno a tela cheia).
- **Ações compostas** em sequência (`compoundAction operator="seq"`) e paralelas (`qualifier="par"`).

## 3. Estrutura do documento

Documento NCL: `id="syncIntEx"`, perfil `http://www.ncl.org.br/NCL3.0/EDTVProfile`,
encoding `ISO-8859-1`.

### 3.1 Layout — regiões e descritores

**Regiões (`<regionBase>`):**

| Região | left | top | width | height | zIndex | Observação |
|--------|------|-----|-------|--------|--------|------------|
| `backgroundReg` | — | — | 100% | 100% | 1 | Fundo, tela cheia |
| `screenReg` | — | — | 100% | 100% | 2 | Vídeo principal (animação), tela cheia; contém as 3 regiões abaixo |
| `frameReg` | 5% | 6.7% | 18.5% | 18.5% | 3 | Aninhada em `screenReg` — quadro p/ foto e drible |
| `iconReg` | 87.5% | 11.7% | 8.45% | 6.7% | 3 | Aninhada — ícone interativo (canto superior direito) |
| `shoesReg` | 15% | 60% | 25% | 25% | 3 | Aninhada — vídeo de propaganda (chuteiras) |

Observação: `frameReg`, `iconReg` e `shoesReg` são **regiões aninhadas** dentro de `screenReg`,
portanto suas coordenadas são relativas à área da tela do vídeo principal.

**Descritores (`<descriptorBase>`):**

| Descritor | region | explicitDur | Usado por |
|-----------|--------|-------------|-----------|
| `backgroundDesc` | `backgroundReg` | — | `background` |
| `screenDesc` | `screenReg` | — | `animation` (vídeo principal) |
| `photoDesc` | `frameReg` | `5s` | `photo` |
| `audioDesc` | (sem região) | — | `choro` (áudio) |
| `dribleDesc` | `frameReg` | — | `drible` |
| `iconDesc` | `iconReg` | `6s` | `icon` |
| `shoesDesc` | `shoesReg` | — | `shoes` |

`audioDesc` não referencia região, pois `choro` é áudio (sem apresentação visual).

### 3.2 Conectores

Os conectores são importados de `causalConnBase.ncl`:

```xml
<connectorBase>
    <importBase documentURI="causalConnBase.ncl" alias="conEx"/>
</connectorBase>
```

Conectores efetivamente usados neste exemplo (todos referenciados como `conEx#<id>`):

| Conector | Param(s) | Condição | Ação |
|----------|----------|----------|------|
| `onBeginStart` | — | `onBegin` | `start` (max `unbounded`, `par`) |
| `onBeginStart_delay` | `delay` | `onBegin` | `start delay="$delay"` (max `unbounded`, `par`) |
| `onEndStop` | — | `onEnd` | `stop` (max `unbounded`, `par`) |
| `onKeySelectionStopSet_varStart` | `var`, `keyCode` | `onSelection key="$keyCode"` | `seq`: `stop` → `set value="$var"` → `start` |
| `onEndSet_var` | `var` | `onEnd` | `set value="$var"` |

Notas:
- `onBeginStart_delay` usa o parâmetro `$delay` para atrasar o início das mídias ligadas.
- `onKeySelectionStopSet_varStart` é um conector **interativo**: dispara ao selecionar a tecla
  indicada em `$keyCode` e executa, em sequência, parada, atribuição de propriedade e início.

### 3.3 Mídias

| Mídia | src | descritor | Âncoras / Propriedades |
|-------|-----|-----------|------------------------|
| `background` | `../media/background.png` | `backgroundDesc` | — |
| `animation` | `../media/animGar.mp4` | `screenDesc` | `<area>` e `<property>` abaixo |
| `choro` | `../media/choro.mp4` | `audioDesc` | — (trilha de áudio) |
| `drible` | `../media/drible.mp4` | `dribleDesc` | — |
| `photo` | `../media/photo.png` | `photoDesc` | — |
| `icon` | `../media/icon.png` | `iconDesc` | — |
| `shoes` | `../media/shoes.mp4` | `shoesDesc` | — |

A `<port id="entry" component="animation"/>` define o vídeo `animation` como ponto de entrada
do documento.

**Âncoras de conteúdo da mídia `animation`** (núcleo do exemplo):

```xml
<media id="animation" src="../media/animGar.mp4" descriptor="screenDesc">
    <area id="segDrible" begin="12s"/>
    <area id="segPhoto"  begin="41s"/>
    <area id="segIcon"   begin="45s" end="51s"/>
    <property name="bounds"/>
</media>
```

- `segDrible` — âncora pontual em 12s (dispara a mídia `drible`).
- `segPhoto` — âncora pontual em 41s (dispara a mídia `photo`).
- `segIcon` — âncora de **intervalo** (45s–51s) que delimita a exibição do ícone interativo.
- `<property name="bounds"/>` — propriedade alvo das ações `set` (posição/tamanho do vídeo).

### 3.4 Elos e temporização

| Elo | Conector | Condição (gatilho) | Ação |
|-----|----------|--------------------|------|
| `lMusic` | `onBeginStart_delay` | início de `animation` | inicia `background` e `choro` com `delay=5s` |
| `lDrible` | `onBeginStart` | `animation` atinge `segDrible` (12s) | inicia `drible` (no `frameReg`) |
| `lPhoto` | `onBeginStart` | `animation` atinge `segPhoto` (41s) | inicia `photo` (no `frameReg`, dura 5s) |
| `lIcon` | `onBeginStart` | `animation` atinge `segIcon` (45s) | inicia `icon` (no `iconReg`, dura 6s) |
| `lEnd` | `onEndStop` | fim de `animation` | para `background` e `choro` |
| `lAdvert` | `onKeySelectionStopSet_varStart` | tecla **RED** sobre `icon` | para `icon`; `set bounds=5%,6.67%,45%,45%` em `animation` (reduz o vídeo → PiP); inicia `shoes` |
| `lEndAdvert` | `onEndSet_var` | fim de `shoes` | `set bounds=0,0,222.22%,222.22%` em `animation` (restaura o vídeo a tela cheia) |

**Fluxo no tempo:**

1. `animation` (vídeo principal) inicia pela `<port entry>` e ocupa a tela inteira (`screenReg`).
2. Aos **5s** (delay de `lMusic`), entram o `background` e o áudio `choro`.
3. Aos **12s** a âncora `segDrible` dispara o vídeo `drible` no quadro `frameReg`.
4. Aos **41s** a âncora `segPhoto` dispara a `photo` no mesmo quadro (5s de duração explícita).
5. Entre **45s–51s** a âncora `segIcon` mantém o `icon` no canto superior direito (`iconReg`,
   6s de duração explícita), sinalizando a interatividade disponível.
6. **Interação:** se o usuário pressionar **RED** enquanto o `icon` está visível, `lAdvert`
   reduz o vídeo principal para um picture-in-picture (`bounds=5%,6.67%,45%,45%`), inicia o
   vídeo de propaganda `shoes` (`shoesReg`) e remove o ícone.
7. Ao terminar `shoes`, `lEndAdvert` restaura o vídeo principal a tela cheia
   (`bounds=0,0,222.22%,222.22%`).
8. Ao fim de `animation`, `lEnd` para `background` e `choro`.

## 4. Execução

```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga 02syncInt.ncl
```

**Comportamento esperado:** o vídeo da animação do jogador inicia em tela cheia; após 5s entram
o fundo e a trilha de áudio; ao longo da reprodução surgem, em sincronia com as marcas de tempo,
o vídeo de drible e a foto no quadro à esquerda, e o ícone interativo no canto superior direito
(45s–51s). Pressionando a tecla RED com o ícone na tela, o vídeo principal encolhe para um
canto (PiP) e roda o anúncio das chuteiras; ao final do anúncio o vídeo volta a tela cheia.

**Resultado verificado:** ✅ A apresentação roda no Ginga atual; a captura mostra o vídeo
principal (`animGar.mp4`) em tela cheia com o jogador animado em campo, confirmando o ponto de
entrada e o layout `screenReg` (tela cheia) — ver captura `../screenshots/02syncInt.png`.

## 5. Observações

- **Dependências de mídia local:** todas as mídias estão em `../media/` relativa à pasta
  `Exemplos`: `background.png`, `animGar.mp4` (~38 MB), `choro.mp4`, `drible.mp4`, `photo.png`,
  `icon.png` e `shoes.mp4`. Todos os arquivos referenciados existem no repositório.
- **Conector importado:** o documento depende de `causalConnBase.ncl` (mesma pasta `Exemplos`),
  importado com `alias="conEx"`. Os IDs de conector citados nos elos resolvem-se contra esse
  arquivo; alterá-lo ou removê-lo quebra todos os `<link>`.
- **Duração explícita vs. natural:** `photoDesc` (5s) e `iconDesc` (6s) usam `explicitDur` para
  controlar o tempo em tela de mídias estáticas (PNG), independentemente da âncora que as dispara.
- **Sintaxe de `bounds`:** os valores `5%,6.67%,45%,45%` e `0,0,222.22%,222.22%` seguem o formato
  `left,top,width,height`; o segundo retorna o vídeo a uma área maior que a região-base
  (efeito de "voltar a tela cheia" a partir do estado reduzido).
- **Interatividade opcional:** o trecho da tecla RED (`lAdvert`/`lEndAdvert`) só ocorre se houver
  ação do usuário durante a janela do ícone (45s–51s); na ausência de interação, o documento
  segue apenas o sincronismo automático até o fim do vídeo principal.
- Encoding declarado `ISO-8859-1` — manter ao editar para preservar acentuação dos comentários.
