# Exemplos didáticos de NCL — "Primeiro João"

Conjunto de **14 exemplos progressivos** de NCL, cada um isolando um conceito da linguagem
(sincronismo, contexto, reuso, switch, transição, animação, menu, NCLua…). São **autocontidos**
(usam apenas mídia local na pasta `../media`), o que os torna ideais para aprender e para validar
o middleware.

## Status da verificação

Testado em **2026-06-24** · Ginga `telemidia/ginga` (C++) · Ubuntu 22.04 ·
**✅ Todos os 14 rodam** (carregam e renderizam sem erro; vídeo/áudio tocam normalmente).

Cada execução foi feita em **tela cheia** (`ginga -f <arquivo>.ncl`) e a tela capturada. As capturas
de todos os exemplos ficam na pasta [`screenshots/`](../../../../screenshots/) na raiz do repositório.

<p align="center">
  <img src="../../../../screenshots/01sync.png" width="60%" alt="01sync.ncl rodando — animação sincronizada">
</p>

## Como rodar

A partir desta pasta (`Exemplos/`):

```bash
ginga 01sync.ncl          # troque pelo exemplo desejado
# dica: ginga -f 08animation.ncl   (tela cheia)
```

## Os exemplos

| Arquivo | Conceito | Status |
|---------|----------|--------|
| `00syncProp.ncl` | Sincronismo usando propriedades | ✅ |
| `01sync.ncl` | Sincronismo básico (com reuso de regiões/descritores) | ✅ |
| `02syncInt.ncl` | Sincronismo com âncoras/intervalos de conteúdo | ✅ |
| `03context.ncl` | Uso de contextos (`<context>`) | ✅ |
| `04reuse.ncl` | Reuso de componentes (`refer`/`instance`) | ✅ |
| `05return.ncl` | Pontos de retorno / *return* | ✅ |
| `06switch.ncl` | Seleção de conteúdo com `<switch>` | ✅ |
| `07transition.ncl` | Transições visuais entre mídias | ✅ |
| `08animation.ncl` | Animação de propriedades | ✅ |
| `09settings.ncl` | Nó de configurações (`settings`) e variáveis globais | ✅ |
| `10menu.ncl` | Menu interativo (navegação por teclas) | ✅ |
| `11nclua.ncl` | Integração com **NCLua** (lógica em Lua) | ✅ |
| `12embNCL.ncl` | NCL embarcado / documento aninhado | ✅ |
| `advert.ncl` | Inserção de propaganda/*advertisement* | ✅ |

> `causalConnBase.ncl` **não** é executado diretamente: é uma base de conectores causais importada
> pelos outros exemplos via `<importBase>`.

## Observação

Estes exemplos acompanham material didático de NCL (sincronismo e interatividade na TV Digital) e
usam mídias curtas locais (`../media/animGar.mp4`, `choro.mp4`, etc.), todas versionadas via Git LFS.
