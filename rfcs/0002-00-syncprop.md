# RFC-0002: Sincronismo por propriedades

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/00syncProp.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../screenshots/00syncProp.png`](../screenshots/00syncProp.png) |

## 1. Resumo

Este documento descreve o exemplo `00syncProp.ncl` (`<ncl id="syncEx">`), que demonstra
**sincronismo entre mídias usando exclusivamente `<property>`** para o posicionamento e a
ordenação visual (layout), em vez de `<region>`/`<descriptor>`. Todo o tamanho, posição
(`left`/`top`/`width`/`height`), empilhamento (`zIndex`) e até a duração (`explicitDur`) são
definidos como propriedades diretamente dentro de cada `<media>`. O sincronismo temporal é
obtido por elos causais (`<link>`) que partem de âncoras de conteúdo (`<area>` com `begin`)
da mídia principal, sem interação do usuário.

## 2. Conceitos NCL demonstrados

- **Layout por propriedades**: posicionamento e dimensão via `<property>` (`left`, `top`,
  `width`, `height`, `zIndex`) — não há `<regionBase>` nem `<descriptorBase>` no documento.
- **Âncoras de conteúdo temporais** (`<area>` com atributo `begin`) sobre uma mídia de vídeo.
- **Conectores causais inline** (`<connectorBase>` no `<head>`, sem `<importBase>`).
- **Sincronismo `onBegin → start`** com e sem atraso (`delay` parametrizado por `bindParam`).
- **Encerramento sincronizado** `onEnd → stop`.
- **Duração explícita** de uma imagem estática via `explicitDur`.
- **`<port>` de entrada** apontando para a mídia que inicia a apresentação.

## 3. Estrutura do documento

### 3.1 Layout — regiões e descritores

O exemplo **não usa `<region>` nem `<descriptor>`**. Esse é justamente o ponto demonstrado:
o layout é definido por `<property>` dentro de cada `<media>`. As propriedades reais são:

| Mídia | left | top | width | height | zIndex | outras |
|-------|------|-----|-------|--------|--------|--------|
| `animation` | — (default) | — | `100%` | `100%` | `2` | — |
| `drible` | `5%` | `6.7%` | `18.5%` | `18.5%` | `3` | — |
| `photo` | `5%` | `6.7%` | `18.5%` | `18.5%` | `3` | `explicitDur="5s"` |
| `choro` | — | — | — | — | — | (somente áudio/trilha; sem propriedades de layout) |

Interpretação: `animation` ocupa a tela inteira (`100% x 100%`) com `zIndex=2`. As mídias
`drible` e `photo` formam um quadro picture-in-picture no canto superior esquerdo
(`left=5%`, `top=6.7%`, `18.5% x 18.5%`) com `zIndex=3`, ficando **acima** da animação de
fundo. `choro` é a trilha sonora (vídeo `choro.mp4`) e não recebe propriedades de
posicionamento.

### 3.2 Conectores

Os conectores são definidos inline em `<connectorBase>` (não há conector importado de
`causalConnBase.ncl` ou similar). São três `<causalConnector>`:

| Conector | Condição | Ação | Parâmetros |
|----------|----------|------|------------|
| `onBeginStart_delay` | `onBegin` | `start` (`delay="$delay"`, `max="unbounded"`, `qualifier="par"`) | `<connectorParam name="delay"/>` |
| `onBeginStart` | `onBegin` | `start` (`max="unbounded"`, `qualifier="par"`) | — |
| `onEndStop` | `onEnd` | `stop` (`max="unbounded"`, `qualifier="par"`) | — |

`onBeginStart_delay` parametriza o atraso de início via `$delay`, permitindo reuso do mesmo
conector com tempos diferentes informados em cada elo. `max="unbounded"` e `qualifier="par"`
habilitam disparar a ação sobre múltiplos alvos em paralelo.

### 3.3 Mídias

| Mídia | `src` | Layout / âncoras / propriedades |
|-------|-------|----------------------------------|
| `animation` | `../media/animGar.mp4` | tela cheia (`width/height=100%`, `zIndex=2`); âncoras `<area id="segDrible" begin="12s"/>` e `<area id="segPhoto" begin="41s"/>` |
| `choro` | `../media/choro.mp4` | trilha (sem propriedades de layout) |
| `drible` | `../media/drible.mp4` | PiP canto sup. esquerdo (`5%`, `6.7%`, `18.5% x 18.5%`, `zIndex=3`) |
| `photo` | `../media/photo.png` | PiP canto sup. esquerdo (mesma geometria de `drible`, `zIndex=3`, `explicitDur="5s"`) |

A mídia `animation` (`animGar.mp4`) é o eixo do sincronismo: suas âncoras temporais
`segDrible` (em 12 s) e `segPhoto` (em 41 s) servem de gatilho para iniciar as demais mídias.

### 3.4 Elos e temporização

A porta de entrada `<port id="entry" component="animation"/>` inicia a apresentação pela
mídia `animation`. A partir daí, os quatro `<link>` disparam o sincronismo:

| Elo | Conector | Condição (origem) | Ação (alvo) | Efeito |
|-----|----------|-------------------|-------------|--------|
| `lMusic` | `onBeginStart_delay` | `onBegin` de `animation` | `start` de `choro` (`bindParam delay="5s"`) | 5 s após o início da animação, começa a trilha `choro` |
| `lDrible` | `onBeginStart` | `onBegin` da âncora `segDrible` (`begin=12s`) de `animation` | `start` de `drible` | em 12 s, o vídeo `drible` aparece no PiP |
| `lPhoto` | `onBeginStart` | `onBegin` da âncora `segPhoto` (`begin=41s`) de `animation` | `start` de `photo` | em 41 s, a imagem `photo` aparece no PiP por 5 s (`explicitDur`) |
| `lEnd` | `onEndStop` | `onEnd` de `animation` | `stop` de `choro` | ao fim da animação, a trilha `choro` é encerrada |

**Linha do tempo aproximada** (relativa ao início de `animation`):

- `t=0s`  → `animation` inicia (tela cheia).
- `t=5s`  → `choro` (trilha) inicia (atraso parametrizado em `lMusic`).
- `t=12s` → `drible` inicia no PiP superior esquerdo (gatilho `segDrible`).
- `t=41s` → `photo` aparece no PiP por 5 s, encerrando em `t≈46s` (gatilho `segPhoto` + `explicitDur`).
- fim de `animation` → `choro` é parado (`lEnd`).

Não há interação do usuário: todo o encadeamento é automático, dirigido pelas âncoras
temporais da mídia principal.

## 4. Execução

```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga 00syncProp.ncl
```

**Comportamento esperado:** abre a animação `animGar.mp4` em tela cheia (personagem em
campo, estilo cartoon). Aos 5 s entra a trilha sonora (`choro.mp4`). Aos 12 s surge um quadro
picture-in-picture no canto superior esquerdo com o vídeo `drible.mp4`. Aos 41 s aparece, no
mesmo quadro, a imagem `photo.png` por 5 s. Ao terminar a animação, a trilha é interrompida.

**Resultado verificado:** ✅ a apresentação roda no Ginga atual; a animação principal é
exibida em tela cheia conforme as propriedades `width/height=100%` e `zIndex=2`, com o quadro
PiP previsto pelas propriedades `left=5%`/`top=6.7%`/`18.5%`/`zIndex=3` — ver captura
[`../screenshots/00syncProp.png`](../screenshots/00syncProp.png).

## 5. Observações

- **Mídias locais obrigatórias**: o exemplo depende de `../media/animGar.mp4`,
  `../media/choro.mp4`, `../media/drible.mp4` e `../media/photo.png`. Todos os quatro
  arquivos existem na pasta `Exemplos/../media/` (verificado), incluindo o `animGar.mp4` de
  ~38 MB. Se o repositório usar Git LFS para vídeos, garanta o `git lfs pull` antes de rodar.
- **Ausência intencional de layout estruturado**: por não haver `<regionBase>`/
  `<descriptorBase>`, todo o posicionamento depende das `<property>` de cada mídia; alterar o
  PiP significa editar as propriedades `left/top/width/height/zIndex` diretamente nas mídias.
- **Encoding**: o arquivo declara `ISO-8859-1` no cabeçalho XML.
- **Particularidade**: `choro` é declarada como vídeo (`choro.mp4`), mas serve apenas de
  trilha — não recebe propriedades de layout, então só seu áudio é relevante para o exemplo.
- **Limitação**: os instantes `12s`/`41s`/`delay=5s`/`explicitDur=5s` são fixos no documento;
  o sincronismo está atrelado à duração/conteúdo de `animGar.mp4`, sem ramos condicionais nem
  interação do usuário.
