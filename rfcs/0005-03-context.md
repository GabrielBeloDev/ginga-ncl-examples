# RFC-0005: Contextos em NCL

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `Primeiro joao/.../Exemplos/03context.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/03context.png`](../Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/screenshots/03context.png) |

## 1. Resumo
Este documento demonstra o uso do elemento `<context>` em NCL como mecanismo de composição para agrupar componentes relacionados. No exemplo, um vídeo de animação ("João") dispara, ao longo do tempo, diversas mídias sincronizadas (trilha sonora, drible, foto) e, em determinado segmento, ativa um contexto de propaganda (`advert`) que encapsula um ícone interativo e um vídeo de chuteiras. O contexto isola seus próprios componentes e elos internos, expondo apenas portas (`<port>`) como interface para o documento que o contém.

## 2. Conceitos NCL demonstrados
- Composição com `<context>` (agrupamento de mídias e elos em um nó composto)
- Portas de contexto (`<port>`) como interface de entrada para componentes internos
- Elos que apontam para a interface de um contexto (`interface="pIcon"`, `interface="pShoes"`)
- Elos internos ao contexto (sincronismo e interação encapsulados)
- Âncoras temporais de conteúdo (`<area>` com `begin`/`end`)
- Propriedade de mídia `bounds` manipulada por `set` (redimensionamento dinâmico do vídeo)
- Conectores causais importados via `<importBase>` (causais + interatividade por tecla)
- Regiões aninhadas e descritores com `explicitDur`

## 3. Estrutura do documento

### 3.1 Layout — regiões e descritores
`<regionBase>` define regiões aninhadas dentro de `screenReg`:

| Região | Posição/tamanho | zIndex | Observação |
|--------|-----------------|--------|------------|
| `backgroundReg` | `width=100%`, `height=100%` | 1 | Fundo |
| `screenReg` | `width=100%`, `height=100%` | 2 | Tela cheia (pai das demais) |
| `frameReg` | `left=5%`, `top=6.7%`, `width=18.5%`, `height=18.5%` | 3 | Aninhada em `screenReg` |
| `iconReg` | `left=87.5%`, `top=11.7%`, `width=8.45%`, `height=6.7%` | 3 | Ícone de propaganda (canto sup. dir.) |
| `shoesReg` | `left=15%`, `top=60%`, `width=25%`, `height=25%` | 3 | Vídeo das chuteiras |

`<descriptorBase>`:

| Descritor | Região | Atributos |
|-----------|--------|-----------|
| `backgroundDesc` | `backgroundReg` | — |
| `screenDesc` | `screenReg` | — |
| `photoDesc` | `frameReg` | `explicitDur="5s"` |
| `audioDesc` | (sem região) | usado para áudio `choro` |
| `dribleDesc` | `frameReg` | — |
| `iconDesc` | `iconReg` | `explicitDur="6s"` |
| `shoesDesc` | `shoesReg` | — |

### 3.2 Conectores
Os conectores são importados de `causalConnBase.ncl` com `<importBase documentURI="causalConnBase.ncl" alias="conEx"/>`. Conectores efetivamente usados (referenciados como `conEx#<id>`):

- **`onBeginStart`** — condição `onBegin` → ação `start` (`max="unbounded"`, `qualifier="par"`).
- **`onBeginStart_delay`** — param `delay`; condição `onBegin` → ação `start delay="$delay"`.
- **`onEndStop`** — condição `onEnd` → ação `stop`.
- **`onEndSet_var`** — param `var`; condição `onEnd` → ação `set value="$var"`.
- **`onKeySelectionSet_var`** — params `keyCode`, `var`; condição `onSelection key="$keyCode"` → ação `set value="$var"`.
- **`onKeySelectionStopStart`** — param `keyCode`; condição `onSelection key="$keyCode"` → `compoundAction seq` com `stop` depois `start`.

### 3.3 Mídias
Componentes do `<body>` (nível principal):

| Mídia | src | Descritor | Interfaces |
|-------|-----|-----------|------------|
| `background` | `../media/background.png` | `backgroundDesc` | — |
| `animation` | `../media/animGar.mp4` | `screenDesc` | `<area segDrible begin="12s"/>`, `<area segPhoto begin="41s"/>`, `<area segIcon begin="45s" end="51s"/>`, `<property name="bounds"/>` |
| `choro` | `../media/choro.mp4` | `audioDesc` | — (trilha sonora) |
| `drible` | `../media/drible.mp4` | `dribleDesc` | — |
| `photo` | `../media/photo.png` | `photoDesc` | — |

`<port id="entry" component="animation"/>` é a porta de entrada do documento (a animação inicia a apresentação).

Contexto `advert` (composição) com suas portas e mídias internas:

- `<port id="pIcon" component="icon"/>` — interface que dá acesso à mídia `icon`.
- `<port id="pShoes" component="shoes"/>` — interface que dá acesso à mídia `shoes`.
- `<media id="icon" src="../media/icon.png" descriptor="iconDesc"/>` (com `explicitDur="6s"`).
- `<media id="shoes" src="../media/shoes.mp4" descriptor="shoesDesc"/>`.
- Elo interno `lBegingShoes` (`conEx#onKeySelectionStopStart`, `keyCode=RED`): ao selecionar o `icon` com a tecla VERMELHA → `start shoes` e `stop icon`.

### 3.4 Elos e temporização
Linha do tempo dirigida pelo vídeo `animation`:

| Elo | Conector | Disparo | Ação |
|-----|----------|---------|------|
| `lMusic` | `onBeginStart_delay` | `onBegin animation` | `start background` e `start choro`, ambos com `delay="5s"` |
| `lDrible` | `onBeginStart` | `onBegin animation/segDrible` (12s) | `start drible` |
| `lPhoto` | `onBeginStart` | `onBegin animation/segPhoto` (41s) | `start photo` |
| `lEnd` | `onEndStop` | `onEnd animation` | `stop background`, `stop choro` |
| `lIcon` | `onBeginStart` | `onBegin animation/segIcon` (45s–51s) | `start advert` via `interface="pIcon"` (inicia o ícone dentro do contexto) |
| `lAdvert` | `onKeySelectionSet_var` | `onSelection advert/pIcon`, `keyCode=RED` | `set animation.bounds = "5%,6.67%,45%,45%"` (encolhe a animação para abrir espaço à propaganda) |
| `lEndAdvert` | `onEndSet_var` | `onEnd advert/pShoes` (fim do vídeo das chuteiras) | `set animation.bounds = "0,0,222.22%,222.22%"` (restaura a animação a tela cheia) |

Fluxo temporal resumido:
1. `entry` → `animation` inicia (porta de entrada).
2. Após 5s, `background` e `choro` (trilha) iniciam em paralelo (`lMusic`, com delay).
3. Em 12s/41s aparecem `drible` e `photo` no quadro (`frameReg`).
4. Entre 45s e 51s, o segmento `segIcon` ativa o contexto `advert` pela porta `pIcon`, exibindo o `icon` interativo.
5. Pressionando RED sobre o ícone: o elo interno `lBegingShoes` para o ícone e inicia o vídeo `shoes`; o elo externo `lAdvert` redimensiona a `animation` (via `bounds`) para a propaganda ganhar espaço.
6. Ao terminar o vídeo `shoes` (fim de `pShoes`), `lEndAdvert` restaura a `animation` a tela cheia.
7. Ao fim da `animation`, `lEnd` para `background` e `choro`.

## 4. Execução
```bash
cd "Primeiro joao/PrimeiroJoao/PrimeiroJoao/Exemplos"
ginga 03context.ncl
```
**Comportamento esperado:** o vídeo da animação preenche a tela; após 5s entra a trilha sonora e o fundo; ao longo do tempo surgem o drible e a foto no quadro à esquerda; por volta de 45s aparece o ícone de propaganda no canto superior direito. Ao pressionar a tecla VERMELHA sobre o ícone, a animação encolhe (via `bounds`) e o vídeo das chuteiras é exibido; ao final desse vídeo a animação volta a ocupar toda a tela. O contexto `advert` encapsula as mídias e o elo de interação da propaganda.

**Resultado verificado:** ✅ O documento carrega e roda no Ginga atual; a composição `<context>` é apresentada corretamente, com os disparos temporais por âncora e a interação por tecla funcionando como descrito — ver captura.

## 5. Observações
- Todas as mídias referenciadas existem localmente em `Primeiro joao/PrimeiroJoao/PrimeiroJoao/media/` (`animGar.mp4`, `background.png`, `choro.mp4`, `drible.mp4`, `photo.png`, `icon.png`, `shoes.mp4`); os caminhos são relativos (`../media/...`).
- O exemplo depende do conector externo `causalConnBase.ncl` (no mesmo diretório `Exemplos/`), importado com `alias="conEx"`. Sem esse arquivo, os `xconnector="conEx#..."` não resolvem.
- A interação requer um controle/teclado com a tecla colorida VERMELHA (`keyCode="RED"`).
- O descritor `audioDesc` não declara `region` (é áudio, sem apresentação visual).
- A propriedade `bounds` da mídia `animation` é manipulada dinamicamente para redimensionar o vídeo durante a propaganda — note os valores `222.22%` usados na restauração a tela cheia.
- `animGar.mp4` é o arquivo de mídia mais pesado do conjunto (~37 MB); se o repositório usar Git LFS, garanta que os binários estejam efetivamente baixados antes de executar.
