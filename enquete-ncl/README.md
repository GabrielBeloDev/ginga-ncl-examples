# Enquete NCL

> Sistema de enquete/votação ("Sim/Não") para TV Digital usando NCL + Lua e canal de retorno · Manoel Campos da Silva Filho (manoelcampos.com) · 2009-2010

## O que é
Aplicação de TV Digital Interativa que exibe um vídeo e dois botões ("Sim" / "Não") sobre ele. O telespectador vota pressionando a tecla verde (Sim) ou vermelha (Não) do controle remoto. O documento NCL (`main.ncl`) cuida da apresentação e das interações; ao registrar o voto, um script NCLua (`votacao.lua`) usa a biblioteca `tcp.lua` (co-rotinas Lua para simular conexões TCP não-bloqueantes) para enviar o voto a uma página PHP remota (`votacao2.php`). O PHP grava os votos em arquivos texto e devolve uma tabela Lua com o resultado (`votos = { sim, nao, url }`), que é executada e exibida na tela. Desenvolvido por Manoel Campos da Silva Filho, então mestrando em Engenharia Elétrica (TV Digital) na UnB.

## Como rodar
```bash
cd enquete-ncl
ginga main.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
Em tese: o vídeo *Wanna Work Together* (Creative Commons) em tela cheia com os botões "Sim" e "Não" no canto inferior esquerdo, votação pelas teclas verde/vermelha e, após o voto, o resultado retornado pelo servidor. Na prática **isto não acontece** no Ginga atual: a aplicação aborta no carregamento (veja abaixo).

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — o processo Ginga abortou ao carregar os scripts Lua.
- Erro exato: `./tcp.lua:14: attempt to call a nil value (global 'module')`
- Causa-raiz: `tcp.lua` declara o módulo com a função `module 'tcp'` (linha 14). A função global `module()` foi removida no Lua 5.2+, então não existe no Lua usado por este Ginga e a chamada falha com "nil value". Sem screenshot do app rodando.

## Limitações conhecidas
- **Lua `module()` removido**: tanto `tcp.lua` (`module 'tcp'`) quanto o uso de `require 'tcp'` em `votacao.lua` dependem do antigo sistema de módulos do Lua 5.1. Sem um shim de `module` ou a portabilidade dos scripts, a aplicação não carrega.
- **Backend PHP**: o resultado depende de `votacao2.php` hospedado em servidor remoto (originalmente em manoelcampos.com), hoje indisponível.
- **Canal de retorno**: a aplicação assume conectividade TCP/HTTP a partir do receptor (canal de retorno da TVD), recurso não disponível neste ambiente de desktop.

## Arquivos principais
- `main.ncl` — documento NCL principal (regiões, descritores, conectores e links da votação Sim/Não).
- `votacao.lua` — script NCLua que envia o voto e exibe o resultado retornado pelo servidor.
- `tcp.lua` — biblioteca de conexões TCP via co-rotinas Lua (origem: tutorial NCLua da PUC-Rio/TeleMídia); contém a chamada `module 'tcp'` que quebra no Lua novo.
- `votacao2.php` — backend PHP que registra os votos em arquivos texto e gera a tabela Lua de resultado.
- `media/` — `Wanna_Work_Together_-_Creative_Commons.avi` (vídeo) e `sim.png` / `nao.png` (botões).
- `vera.ttf` — fonte usada para desenhar texto no canvas.
- `LEIAME.txt` — nota com o link do artigo original do autor.
- `doc/` — documentação LuaDoc gerada dos scripts.
- `Screenshot-Sistema-Enquete-TVD-Ginga-NCL.png` — captura de tela histórica (2010) do app original; não reflete uma execução verificada neste ambiente.
