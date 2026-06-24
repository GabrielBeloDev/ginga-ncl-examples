---
# RFC-0001: A_Onda — app educacional interativo sobre a Amazônia

| Campo | Valor |
|-------|-------|
| **Status** | ✅ Implementado e verificado (roda no Ginga atual) |
| **App / Exemplo** | `A_Onda/A_Onda.ncl` |
| **Verificado em** | 2026-06-24 · Ginga telemidia/ginga (C++) · Ubuntu 22.04 |
| **Captura** | [`../A_Onda/screenshots/A_Onda.png`](../A_Onda/screenshots/A_Onda.png) |

## 1. Resumo

`A_Onda` é um aplicativo de TV Digital Interativa (perfil NCL 3.0 EDTVProfile) produzido na disciplina de Fundamentos de Sistemas Multimídia da PUC-Rio (2010.2). Ele exibe um vídeo principal animado sobre a Amazônia (`media/A_Onda.mp4`) e, em pontos pré-definidos do tempo do vídeo (marcados por `<area>`), oferece conteúdo interativo: propagandas/informações sobrepostas, um contexto sobre o peixe Candiru, um menu de três níveis (Lendas, Espécies e Turismo) e um quiz implementado em NCLua. É um exemplo grande e completo que demonstra praticamente todo o vocabulário do NCL declarativo: regiões aninhadas, descritores com transições de fade, conectores causais importados, âncoras de conteúdo temporais, `<switch>` com `<ruleBase>` (inclusive seleção regional por CEP via `user.location`) e integração com objeto imperativo Lua.

## 2. Conceitos NCL demonstrados

- **Regiões aninhadas** (`<regionBase>` com `<region>` dentro de `<region>`) e uso de `zIndex` para empilhamento.
- **Descritores** com `transIn`/`transOut`, `explicitDur`, navegação por foco (`focusIndex`, `moveUp`, `moveDown`, `focusSrc`, `focusSelSrc`).
- **Transições** (`<transitionBase>`/`<transition>`) do tipo `fade`.
- **Conectores causais** definidos em base separada e trazidos via `<importBase>` (reuso de conectores entre documentos).
- **Âncoras de conteúdo temporais** (`<area begin=... end=...>`) sobre o vídeo principal para disparar interatividade sincronizada com o tempo de mídia.
- **Elos causais** (`<link>`) com papéis `onBegin`/`onEnd`/`onSelection`/`onEndAttribution` → `start`/`stop`/`set`/`abort`.
- **`<switch>` + `<ruleBase>`**: seleção de conteúdo por regras, incluindo regionalização por CEP (`user.location`), idioma e variável de serviço (`service.ctxChoice`).
- **`<context>`** (composições aninhadas) e **reúso por `refer`** de contextos.
- **Variáveis de aplicação** via nó de settings (`application/x-ginga-settings`): `service.ctxChoice`, `service.currentFocus`, `service.currentKeyMaster`.
- **`<property name="bounds">`** para redimensionar o vídeo em tempo de execução (picture-in-picture).
- **NCLua**: objeto imperativo (`quiz.lua`) embutido como `<media>` para o quiz.
- **Múltiplos dispositivos**: regiões/descritores para `systemScreen(2)` e mídias do tipo aplicação NCL embarcada (suporte a segunda tela).

## 3. Estrutura do documento

Documento raiz `<ncl id="A_Onda" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">`. O `<head>` concentra `<ruleBase>`, `<transitionBase>`, `<regionBase>` (duas, sendo uma para `systemScreen(2)`), `<descriptorBase>` e `<connectorBase>` com importação. O `<body>` é grande (~1560 linhas) e organiza o conteúdo em uma mídia de vídeo central, mídias de sobreposição, contextos (`ctxCandiru`, `ctxMenu`, `ctxNCLuaQuiz`), switches e os elos de sincronismo/interação.

### 3.1 Layout — regiões e descritores

**Regiões** (`<regionBase>`): a base define um par de regiões de tela cheia e uma árvore aninhada dentro de `screenReg`:

- `backgroundReg` — 100% × 100%, `zIndex="1"` (fundo).
- `screenReg` — 100% × 100%, `zIndex="2"` (camada da tela), contendo:
  - `interactivityReg` (`right=10% top=10% 20%×10%`, z=3) — ícone de interatividade.
  - `backReg` (`left=28% top=43% 10%×7%`, z=3) e `cancelReg` (`right=3% bottom=40% 16%×8%`, z=3) — botões voltar/cancelar.
  - `menu1Reg` (`left=5% top=10% 20%×30%`, z=3) com três sub-regiões `menu1_1Reg`/`menu1_2Reg`/`menu1_3Reg` (cada uma 100% × 30%, empilhadas em top 0% / 35% / 70%) — primeiro nível do menu.
  - `menu2RegArc` (`left=24% top=7% 25%×36%`, z=3) — moldura/arco do submenu.
  - `menu2Reg` (`left=28% top=10% 20%×30%`, z=4) com `menu2_1Reg`/`menu2_2Reg`/`menu2_3Reg` (mesmo padrão de empilhamento) — segundo nível do menu.
  - `rgLua` (`right=0 bottom=0 60%×55%`, z=2) — área do quiz NCLua.
- `regionBase device="systemScreen(2)"` define `activeDeviceReg` (100% × 100%) para a segunda tela.

O padrão de aninhamento (uma região “container” com três filhas idênticas de 30% de altura) é replicado para o nível 1 e o nível 2 do menu.

**Descritores** (`<descriptorBase>`): mapeiam regiões e configuram transição/foco. Exemplos representativos:

- `backgroundDesc` → `backgroundReg`; `screenDesc` → `screenReg`.
- `interactivitDesc` → `interactivityReg`, `transIn="transInFade"`, `explicitDur="15s"`.
- `advertDesc` (sem região fixa; posição vem por `<property>` na mídia), `transIn`/`transOut` fade, `explicitDur="10s"`.
- Descritores de menu nível 1: `menu1_1Desc`/`menu1_2Desc`/`menu1_3Desc` com `focusIndex` 1/2/3, `moveUp`/`moveDown` encadeando a navegação circular, e imagens de foco/seleção (`focusSrc`/`focusSelSrc`), `focusBorderWidth="0"`.
- Descritores de menu nível 2 seguem o mesmo padrão: Lendas `focusIndex` 4–6, Espécies 7–9, Turismo (Pacotes) 10–12, sempre com navegação circular `moveUp`/`moveDown` e imagens de foco/seleção próprias.
- `dsLua` → `rgLua`, `focusIndex="13"` (quiz).
- `activeDeviceDesc` → `activeDeviceReg` (segunda tela).

### 3.2 Conectores

Os conectores **não** são definidos inline; o `<connectorBase>` do documento principal apenas faz:

```xml
<connectorBase>
    <importBase documentURI="A_Onda_ConnectorBase.ncl" alias="conExe"/>
</connectorBase>
```

Todos os elos referenciam os conectores via `xconnector="conExe#<id>"`. O arquivo importado `A_Onda/A_Onda_ConnectorBase.ncl` (`<ncl id="A_Onda_ConnectorBase">`) define os `<causalConnector>` reutilizados. Principais:

- `onBeginStart` — `onBegin` → `start` (max `unbounded`, `seq`). Usado para sincronizar mídias com o início de uma âncora/mídia.
- `onBeginSet` — param `var`; `onBegin` → `set $var`. Ajusta variável de settings quando algo inicia.
- `onBeginSetStart` — param `var`; `onBegin` → ação composta `set $var` então `start`.
- `onEndStart` — `onEnd` → `start`.
- `onEndSet` — param `var`; `onEnd` → `set $var`.
- `onEndStop` — `onEnd` → `stop` (`par`).
- `onEndStopStart` — `onEnd` → composto `stop` então `start`.
- `onEndAbort` — `onEnd` → `abort`.
- `onKeySelectionStartStop` / `onKeySelectionStopStart` — param `keyCode`; `onSelection key=$keyCode` → composição de `stop`/`start`.
- `onKeySelectionStopSetStart` — params `keyCode` e `var`; `onSelection` → `stop` → `set $var` → `start`. É o conector de interação mais usado no menu (seleciona item, ajusta `service.ctxChoice` e troca o conteúdo exibido).
- `onKeySelectionStop` — param `keyCode`; `onSelection key=$keyCode` (qualifier `or`) → `stop`. Usado no botão vermelho de cancelar.
- `onOrKeySelectionStopSet` / `onOrKeySelectionSetStop` — params `keyCode` e `var`; condição `onSelection` com `or`/`max=unbounded` combinando vários binds, → `stop` e `set $var` (volta de submenu via `CURSOR_LEFT`).
- `onEndAttributionCmpStopStart` — param `val`; condição composta (`and`) de `onEndAttribution` + `assessmentStatement`/`attributeAssessment` comparando o valor de uma propriedade com `$val`, → `stop` então `start` com `delay="0.5s"`. Usado para migrar conteúdo para a segunda tela quando a flag (`candiruToDevice`/`menuToDevice`) vira `true`.

### 3.3 Mídias

**Mídia central e sobreposições (corpo principal):**

- `background` — `media/img/background/vlcsnap-2010-10-13-11h58m57s159.png`, descritor `backgroundDesc`.
- `compVideoAOnda` — `media/A_Onda.mp4`, descritor `screenDesc`. É o objeto âncora do documento; possui `<area>` temporais (ver 3.4) e `<property name="bounds">` (manipulado via `set` para PiP).
- `compImgEstado` (`media/img/amapa/fort_fim_01.jpg`) + `compTxtVisite` (`media/txt/amapa/estado.txt`) — propaganda de estado, descritor `advertDesc`, posição/estilo via `<property>`.
- `compImgMinSaude` (`media/img/saude/logoBrasilSaude.jpg`) + `compTxtVacina` (`media/txt/saude/saude.txt`) — campanha de saúde/vacina, `advertDesc`.
- `compImgInteratividade`, `compImgInteratividadeCandiru`, `compImgInteratividadeQuiz` — todos `media/img/interactivity/int_green.png` (ícone “verde” de interatividade), descritor `interactivitDesc`.
- `iconMenuCancel` — `media/img/interactivity/int_red.png` (ícone “vermelho” cancelar), `cancelDesc`.
- `compImgCreditos` — `media/img/creditos/creditos_PUC-Rio.png`, `creditosDesc`, `explicitDur=2s`.
- Mídias de segunda tela: `activeDeviceCompImgCandiru`, `activeDeviceCompCandiruIcon`, `activeDeviceCompMenu`, `activeDeviceCompMenuIcon` — `src` apontando para aplicações NCL embarcadas em `NCLApplications/A_Onda/*.ncl`, descritor `activeDeviceDesc`.
- `settingCtx` — nó de configuração `type="application/x-ginga-settings"` com as propriedades `service.ctxChoice`, `service.currentFocus`, `service.candiruToDevice`, `service.menuToDevice`, `service.viagemToDevice`, `service.currentKeyMaster` (todas inicializadas).

**Contexto `ctxCandiru`** (acionado pelo segmento Candiru): imagens `mapaCandiru.jpg`/`imgCandiru.png` e textos `candiru01_1`, `candiru01_2`, `candiru02_1`, `candiru02_2` (em `media/txt/candiru/`), todos com `explicitDur=10s` e posicionamento por `<property>`.

**Contexto `ctxMenu`** (menu de dois níveis): ícones do menu nível 1 (`menuLendasOrig.png`, `menuEspeciesOrig.png`, `menuTurismoOrig.png`) e, por submenu, ícones nível 2 mais o conteúdo:

- Lendas: `imgLenda1` (cobra_grande.jpg)/`txtLenda1`, `imgLenda2` (ms_curupira.jpg)/`txtLenda2`, `imgLenda3` (vitoria_regia.jpg)/`txtLenda3`.
- Espécies: `imgEspecie1` (tucunare.jpg), `imgEspecie2` (peixe-boi.jpg), `imgEspecie3` (tambaqui.jpg), com seus textos.
- Turismo: pacotes 1–3, cada um implementado como `<switch>` (`switchTurismo-Hotel01/02/03`) que regionaliza o conteúdo por CEP — ver 3.4.

**Contexto `ctxNCLuaQuiz`**: `<media id="lua" src="media/lua/quiz.lua" descriptor="dsLua">`. O `quiz.lua` é um objeto imperativo NCLua que desenha as questões no `canvas`, trata as teclas (`CURSOR_UP`/`CURSOR_DOWN` para mover o foco entre alternativas a–d, `ENTER` para confirmar), contabiliza `score` e, ao terminar, emite um evento NCL de `presentation/stop` (`gameOverSignal`) para encerrar o objeto.

### 3.4 Elos e temporização

A temporização é dirigida pelas `<area>` do vídeo principal `compVideoAOnda`, que disparam elos por `onBegin`:

- `segComercViagem` (100s–110s) → `lViagem`: inicia `compImgEstado` + `compTxtVisite`.
- `segMinSaudeVacina` (150s–160s) → `lVacina`: inicia `compImgMinSaude` + `compTxtVacina`.
- `segIntCandiru` (350s–360s) → `lIntCandiru`: mostra ícone verde (`compImgInteratividadeCandiru`) e o ícone na segunda tela.
- `segIntMenu` (395s–415s) → `lIntMenu`: mostra ícone de interatividade do menu.
- `segQuizQuestion` (480s–490s) → `lIntQuiz`: mostra ícone do quiz.
- `segCreditos` (740s–750s) → `lCreditos`: mostra `compImgCreditos`.

Além de `lBeginVideoPrincipal` (`onBegin` do vídeo → `start background`) e `lEndVideoPrincipal` (`onEnd` do vídeo → `stop` de todas as sobreposições e do `switchContexts`).

**Interação (tecla VERDE / GREEN):** enquanto o ícone de interatividade está visível, pressionar `GREEN` aciona o conector `onKeySelectionStopSetStart`:

- `lInfoCandiru`: para o ícone, faz `set service.ctxChoice = 111`, ajusta `bounds` do vídeo para `50%, 0%, 50%, 50%` (PiP no canto) e dá `start` em `switchContexts`.
- `lCtxMenu`: `set service.ctxChoice = 112`, mesmo PiP, `start switchContexts` e `start iconMenuCancel`.
- `lQuizQuestion`: `set service.currentKeyMaster = 13` e `service.currentFocus = 13`, então `start ctxNCLuaQuiz` (entrega o controle de teclado ao Lua). `lQuizQuestionEnd` (`onEnd` do contexto Lua) devolve `currentKeyMaster = 0`.

**Seleção de contexto por regra:** `switchContexts` usa `<bindRule>` sobre `service.ctxChoice` (`rCtxCandiru=111` → `ctxCandiru`; `rCtxMenu=112` → `ctxMenu`). Dentro do menu, cada item selecionado dispara `onKeySelectionStopSetStart`, que ajusta `service.ctxChoice` (códigos hierárquicos como `1111`, `11111`, …) para trocar qual lenda/espécie/pacote aparece, parando os demais. `CURSOR_LEFT` sobre os itens (conector `onOrKeySelectionStopSet`) volta ao nível anterior, restaurando `service.currentFocus`.

**Regionalização por CEP:** a `<ruleBase>` define regras sobre `user.location` (ex.: `BH` = `30000000`, `SP` = `gte 01000001`) e idioma/interatividade. Os três pacotes turísticos são `<switch>` (`switchTurismo-Hotel01/02/03`) com `<bindRule rule="BH">` e `<bindRule rule="SP">` mapeando para contextos `hotel{1,2,3}{BH,RJ,SP}Ctx` reusados via `refer`, e `defaultComponent` apontando para a variante RJ. Assim, o mesmo elo de seleção exibe textos/imagens de hotel diferentes conforme a localização do receptor.

**Segunda tela:** os elos `lStartCandiruOnDevice` e `lStartMenuOnDevice` usam `onEndAttributionCmpStopStart`: quando `service.candiruToDevice`/`service.menuToDevice` recebem `true`, o conteúdo é parado na tela principal e iniciado na aplicação embarcada da segunda tela (com `delay` de 0,5 s). `lEndSwitchContexts` (`onEnd` de `switchContexts`) restaura `bounds` do vídeo para `0, 0, 200%, 200%` (tela cheia novamente).

## 4. Execução

```bash
cd A_Onda
ginga A_Onda.ncl
```

**Comportamento esperado:** o vídeo principal animado sobre a Amazônia ocupa a tela cheia. Ao longo da reprodução, nos instantes definidos pelas `<area>`, surgem (com fade) propagandas/informações no canto e ícones de interatividade. Pressionando a tecla VERDE com um ícone visível, o vídeo encolhe para um quadro picture-in-picture (50% × 50% no canto) e abre o contexto correspondente: informações do Candiru, o menu de Lendas/Espécies/Turismo (navegável pelo controle remoto, com itens em foco/seleção), ou o quiz NCLua (alternativas a–d navegáveis por cima/baixo, confirmação por ENTER). A tecla VERMELHA cancela e a tecla ESQUERDA volta um nível no menu. Ao final do vídeo, exibem-se os créditos (PUC-Rio) e as sobreposições são encerradas.

**Resultado verificado:** ✅ O documento carrega e roda no Ginga atual; o vídeo principal é reproduzido (a captura mostra um quadro da animação na cena de cabeceira do rio/raízes) e os elos temporais e de interação são processados conforme descrito — ver captura.

## 5. Observações

- **Mídia local pesada:** o app depende de `media/A_Onda.mp4` (~146 MB) presente em `A_Onda/media/`. Sem esse arquivo (ou em repositórios que o sirvam via Git LFS), o vídeo não toca e os elos baseados em `<area>` não disparam. Demais mídias (imagens `.png`/`.jpg`, textos `.txt`, fonte `vera.ttf`) também precisam estar locais em `A_Onda/media/...`.
- **NCLua:** `media/lua/quiz.lua` usa a API NCLua (`canvas`, `event`) e a fonte `media/lua/vera.ttf`; requer um Ginga com suporte a objetos imperativos Lua.
- **Codificação:** ambos os arquivos NCL declaram `encoding="ISO-8859-1"` (Latin-1) — relevante para os acentos dos textos.
- **Segunda tela (multi-device):** as mídias `activeDevice*` apontam para `NCLApplications/A_Onda/*.ncl`, que são aplicações de segunda tela. Esses caminhos não fazem parte de `A_Onda/media/` e os recursos de segundo dispositivo só têm efeito quando há um receptor secundário pareado; na execução padrão (tela única) esses elos não produzem saída visível.
- **Regionalização:** a saída regional (pacotes turísticos por CEP) depende de `user.location` configurado no receptor; sem isso, o `<switch>` cai no `defaultComponent` (variante RJ). Há, no `<ruleBase>`, regras de faixa de CEP via `compositeRule` comentadas — apenas as comparações simples (`BH` eq, `SP` gte) estão ativas.
- **Arquivos de ruído:** o diretório contém artefatos de empacotamento de macOS (`__MACOSX/`, `._*`, `.DS_Store`) que devem ser ignorados; não afetam a execução.
- **Limitação:** trata-se de um app de demonstração acadêmico (PUC-Rio, 2010.2); foi projetado para um receptor de TVD com controle remoto (teclas coloridas, cursores, ENTER) e segunda tela, recursos que no ambiente de desktop são exercitados parcialmente.
