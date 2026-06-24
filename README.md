# Coleção de Aplicações NCL / Ginga (TV Digital Interativa)

Coleção histórica de **aplicações e exemplos em NCL** (*Nested Context Language*) para o
middleware **Ginga**, do Sistema Brasileiro de TV Digital. Os apps foram desenvolvidos
aproximadamente entre **2008 e 2012** e reunidos aqui para estudo, execução e documentação.

Cada pasta tem seu próprio `README.md` com **o que o app faz, como rodar e o status real de
verificação** (testado de verdade, não só "deveria funcionar").

> **Por que isso existe:** este repositório é o artefato-base de uma pesquisa sobre *autoria de
> documentos NCL com agentes LLM* (geração guiada por especificação). O primeiro passo da pesquisa
> é exatamente este: rodar a linguagem/middleware, validar o que funciona e organizar os exemplos.

---

## O que é NCL e Ginga?

**NCL** é uma linguagem declarativa, baseada em XML, para descrever aplicações multimídia
interativas — quais mídias existem, **onde** aparecem na tela (regiões/descritores), **quando**
e **como** se relacionam no tempo (conectores causais e elos/`link`). A lógica procedural
(interatividade, rede, dados) é escrita em **Lua** (chamado de *NCLua*). **Ginga** é o middleware
de referência que interpreta e executa esses documentos `.ncl`.

---

## Pré-requisitos

- **Ginga** instalado. Neste ambiente foi usado o **`telemidia/ginga` (implementação C++)** em
  **Ubuntu 22.04**. Guia de instalação no Ubuntu (o mesmo usado aqui):
  <https://github.com/TeleMidia/ginga/blob/master/extra/ubuntu/README.md>
- **Git LFS** para baixar os vídeos/áudios (veja abaixo).

Confirme com:
```bash
ginga --help
```

---

## Como clonar (com a mídia)

Os vídeos/áudios são versionados via **Git LFS**. Para obtê-los junto com o código:

```bash
git lfs install
git clone <url-do-repositorio>
cd <repositorio>
git lfs pull        # baixa os arquivos de mídia (.mp4/.avi/.mp3/...)
```

---

## Como rodar qualquer exemplo

A partir da pasta do app, aponte o Ginga para o `.ncl` principal:

```bash
cd <pasta-do-app>
ginga <arquivo-principal>.ncl
```

Opções úteis: `-f` (tela cheia), `-s 960x540` (tamanho da janela), `-d` (debug).
Exemplo: `ginga -s 960x540 A_Onda.ncl`

---

## Índice e status de verificação

Verificado em **2026-06-24**, Ginga `telemidia/ginga` (C++), Ubuntu 22.04. Cada app foi
**executado de verdade** e a tela capturada. Resumo honesto:

| App | Pasta | O que é | Status neste Ginga |
|-----|-------|---------|--------------------|
| **Exemplos "Primeiro João"** | [`Primeiro joao/.../Exemplos`](Primeiro%20joao/PrimeiroJoao/PrimeiroJoao/Exemplos/) | 14 exemplos didáticos de NCL (sincronismo, contexto, reuso, switch, transição, animação, menu, NCLua…) | ✅ **Todos os 14 rodam** |
| **A_Onda** | [`A_Onda/`](A_Onda/) | App educacional sobre a Amazônia (PUC-Rio/TeleMídia) | ✅ **Roda** (abertura + vídeo) |
| **ClimaTV** | [`ClimaTV/`](ClimaTV/) | Previsão do tempo via canal de retorno | ❌ Crash (NCLua: *out of memory*) |
| **damasTV** | [`damasTV/`](damasTV/) | Jogo de damas (local / rede TCP) | ❌ Erro de parse NCL (`<descriptorParam>`) |
| **enquete-ncl** | [`enquete-ncl/`](enquete-ncl/) | Enquete/votação via canal de retorno | ❌ Crash (Lua `module()` removido) |
| **FacebookNCL** | [`FacebookNCL/`](FacebookNCL/) | Leitor de feed do Facebook | ❌ Não roda (Lua `module()` / API morta) |
| **TVDQuiz** | [`TVDQuiz/`](TVDQuiz/) | Quiz/trivia interativo | ❌ Crash (Lua `module()` removido) |
| **twitter_ncl** | [`twitter_ncl/`](twitter_ncl/) | Cliente de Twitter (ler/postar) | ❌ Crash (Lua `module()` / API morta) |
| **RSS Reader** | [`rss-reader/`](rss-reader/) | Leitor de RSS em NCLua | ❌ Crash (Lua `module()` removido) |

**Placar:** **15 de 22** pontos de entrada rodam neste Ginga (14 exemplos didáticos + A_Onda).

<p align="center">
  <img src="screenshots/A_Onda.png" width="45%" alt="A_Onda rodando">
  <img src="screenshots/01sync.png" width="45%" alt="Exemplo de sincronismo rodando">
</p>

> 📸 Capturas de tela (em tela cheia) de **todos os que rodam** ficam em [`screenshots/`](screenshots/).
> 📄 Cada um que roda tem também um documento técnico (RFC) em [`rfcs/`](rfcs/).

---

## ⚠️ Problema de compatibilidade conhecido (por que os apps NCLua quebram)

A maioria dos apps que **não** rodam falha pela mesma causa: os scripts `.lua` começam com a função
**`module(...)`**, que era idiomática no **Lua 5.1** mas foi **removida no Lua 5.2+**. O Ginga atual
embarca um Lua novo, então o carregamento do script aborta com:

```
attempt to call a nil value (global 'module')
```

**Correção possível (fora do escopo desta primeira etapa):** adicionar um *shim* de `module` ou
portar os scripts para o estilo de módulos do Lua moderno (`local M = {} ... return M`). Mesmo
assim, vários desses apps ainda dependem de **serviços externos hoje desativados** (APIs antigas do
Twitter/Facebook, weather.com, backends PHP, canal de retorno), então não funcionariam de ponta a
ponta sem reescrita adicional.

---

## Bibliotecas auxiliares (não executáveis)

- **`rss-reader/LuaXML/`** — parser XML em Lua (Paul Chakravarti), usado pelo leitor de RSS (e há
  uma cópia própria dentro de `twitter_ncl/LuaXML/`).
- **`tcp.lua`, `http.lua`, `json.lua`, `base64.lua`, `util.lua`** (dentro de cada app) — bibliotecas
  de apoio (rede, codificação) usadas pelos apps de integração web.

---

## Artefatos grandes mantidos **apenas localmente** (não vão pro GitHub)

Para não estourar limites do GitHub, estes ficam fora do versionamento (veja `.gitignore`):

- `Primeiro joao/primeirojoao_ait.ts` (~1.3 GB) — *transport stream* MPEG-TS de transmissão,
  derivado dos exemplos. Não é necessário para rodar os `.ncl`.
- `Primeiro joao/PrimeiroJoao.zip` (~42 MB) — cópia compactada redundante do conteúdo já presente
  descompactado na pasta.

---

## Ambiente de verificação

- **SO:** Ubuntu 22.04 · **Middleware:** `telemidia/ginga` (C++) · **Data:** 2026-06-24
- Cada app foi iniciado com `ginga -s 960x540 <arquivo.ncl>`; a tela foi capturada após alguns
  segundos e o log do Ginga inspecionado em busca de erros de parse/execução.
