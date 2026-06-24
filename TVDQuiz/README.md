# TVD Quiz

> Aplicativo de quiz/trivia interativo para TV Digital, em NCL + Lua · Ueslei Taivan (Faculdade Católica do Tocantins) e Manoel Campos da Silva Filho (IFTO) · 2010

## O que é
Aplicação de TV Digital Interativa que exibe um vídeo em tela cheia e, sobreposta a ele, uma interface de quiz desenhada em Lua (NCLua). O `main.ncl` cuida do layout (regiões, descritores, conectores) e da reprodução do vídeo `Wanna_Work_Together_-_Creative_Commons.avi`, enquanto o `main.lua` desenha os botões via Canvas e controla a interação pelo controle remoto. As perguntas, alternativas e respostas corretas ficam num arquivo de dados (`perguntas.lua`), carregado por um módulo de configuração próprio (`config.lua`) que usa `loadfile`/`setfenv`. As teclas coloridas (VERMELHO/VERDE) iniciam, param e finalizam a aplicação Lua.

## Como rodar
```bash
cd TVDQuiz
ginga main.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
O esperado seria o vídeo em tela cheia com o painel de quiz desenhado em Lua sobre o terço inferior da tela, exibindo perguntas (ex.: "Quem ganhou a Copa do Mundo de 2010?") e alternativas numeradas, navegáveis pelo controle remoto. Na prática, isso NÃO acontece: o aplicativo aborta no carregamento, antes de qualquer interface aparecer.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — o processo Ginga abortou no carregamento dos scripts Lua.
- Erro exato: `./config.lua:16: attempt to call a nil value (global 'module')`
- Causa-raiz: o `config.lua` chama `module "config"` (linha 16). A função global `module()` foi removida no Lua 5.2+, usado por esta implementação nova do Ginga. Como o `main.lua` faz `require "config"`, a falha derruba toda a aplicação.

## Limitações conhecidas
- Lua `module()`: removida no Lua 5.2+; quebra o `config.lua` neste Ginga. Correção possível (fora do escopo): criar um shim de `module` ou portar o script para o estilo de módulos moderno (tabela `local config = {}` + `return config`).
- O `config.lua` já registra que a função `save()` (módulo `io`) não funciona no Ginga — depuração apenas.
- Aplicação offline/local: não há dependência de canal de retorno nem de serviços externos; os dados das perguntas estão embutidos em `perguntas.lua`.

## Arquivos principais
- `main.ncl` — documento NCL principal: regiões, descritores, conectores, links de teclas e reprodução do vídeo.
- `main.lua` — script NCLua principal: desenha a interface do quiz no Canvas e trata a interação do usuário.
- `perguntas.lua` — base de dados das perguntas, alternativas e índice da resposta correta.
- `config.lua` — módulo utilitário para ler arquivos `.lua` como configuração (onde ocorre o erro de `module`).
- `media/` — vídeo `Wanna_Work_Together_-_Creative_Commons.avi` (Creative Commons) e imagens dos botões (PNG).
- `doc/` — documentação LuaDoc gerada dos scripts.
- `screenshot-tvdquiz.png` — captura histórica do app (de 2010); não reflete uma execução verificada neste ambiente.
