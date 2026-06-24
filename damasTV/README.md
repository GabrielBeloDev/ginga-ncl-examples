# damasTV

> Jogo de damas interativo para TV Digital, em NCL + Lua, com modo local (contra o computador) e multiplayer via TCP · PUC-Rio / Laboratório TeleMídia · 2008 (arquivos de 2011)

## O que é
Um jogo de damas jogável pelo controle remoto da TV Digital Interativa, construído em NCL (estrutura, mídias e sincronismo) com toda a lógica do jogo escrita em Lua (NCLua). O documento `damas.ncl` orquestra um vídeo de abertura (`inicio.mp4`), música de fundo em loop e um amplo conjunto de efeitos sonoros (mover, comer, virar dama, soprar, vitória) acionados por links NCL a partir de áreas disparadas pelo código Lua. O motor em Lua desenha o tabuleiro e as peças via `canvas` do NCLua, implementa um adversário controlado pelo computador (`computador.lua`) e suporta partidas multiplayer através do canal de retorno usando eventos TCP (`conexaoTcp.lua`, `rede.lua`, `jogoRede.lua`).

## Como rodar
```bash
cd damasTV
ginga damas.ncl
```

## O que você deve ver
O esperado é o vídeo de abertura (logo) tocar e, em seguida, o menu do jogo e o tabuleiro de damas com música de fundo, navegados pelas teclas direcionais e OK do controle remoto. Hoje o aplicativo **carrega e toca a abertura** sem crashar; o menu/tabuleiro, porém, só pode ser exercitado com as teclas do controle (veja Status). Sem screenshot útil — a abertura fica escura.

## Status da verificação
Testado em **2026-06-24** · Ginga (Lua 5.3) · execução headless
- 🔶 **Carrega e não crasha mais.** Antes: erro de parse do documento NCL, antes de qualquer renderização. Agora o app carrega e **toca a abertura (logo)**.
- No teste headless, a sessão termina logo após a abertura. O tabuleiro/menu é desenhado em NCLua e **navegado por teclas do controle remoto**, que não puderam ser acionadas automaticamente aqui.
- Honestamente: **carrega/abre agora; o jogo completo precisa de interação por teclas, não verificado neste teste.**

Correções aplicadas (detalhes em `docs/CODE-CHANGES.md`):
1. `damas.ncl` (linha ~39) — removido o atributo inválido `region="test"` de `<descriptorParam>`, que fazia o parser NCL mais estrito do Ginga rejeitar o documento.
2. `damas.ncl` (linha ~134) — corrigido o typo de maiúscula no `<bindRule>`: `constituent="efeitoVence"` → `constituent="efeitovence"` (a mídia se chama `efeitovence`, com v minúsculo).
3. Adicionado o shim `lua/compat.lua` e `require "compat"` no topo de `lua/principal.lua`. O Ginga atual usa Lua 5.3, mas os scripts são de Lua 5.1; o motor carrega `engine/copas.lua`, que usa `module()`. O shim reativa `module()`/`setfenv()` (removidos no Lua 5.2+), sem alterar a lógica original.

## Limitações conhecidas
- O jogo completo (menu, tabuleiro, partida) depende de **teclas do controle remoto** e não foi exercitado no teste headless; sua correção funcional não está verificada aqui.
- O modo multiplayer depende de **servidor e conexão TCP** pelo canal de retorno (`conexaoTcp.lua`, `rede.lua`); infraestrutura indisponível hoje.
- Sem screenshot útil: a abertura fica escura.
- Coleção histórica de TV Digital (~2008–2012) rodando em Ginga moderno; mesmo após as correções, recursos de rede e de áudio podem não se comportar como na época.

## Arquivos principais
- `damas.ncl` — documento NCL principal: regiões, descritores, regras de efeito sonoro, mídias (vídeo, música, sons) e links de sincronismo.
- `lua/principal.lua` — ponto de entrada NCLua; máquina de estados (tela, jogo, opções, rede) e laço de quadros/eventos. Inicia com `require "compat"`.
- `lua/compat.lua` — shim de compatibilidade (NOVO) que reativa `module()`/`setfenv()` do Lua 5.1 sob o Lua 5.3 do Ginga (ver `docs/CODE-CHANGES.md`).
- `lua/jogo.lua` / `lua/jogoRede.lua` — lógica da partida local e da partida em rede.
- `lua/computador.lua` — adversário controlado pelo computador (escolha de jogadas).
- `lua/menuJogo.lua` / `lua/menuJogoRede.lua` — menus, placar e mensagens na tela.
- `lua/conexaoTcp.lua` / `lua/rede.lua` — comunicação multiplayer via eventos TCP.
- `lua/engine/` — funções de apoio (movimentador, tabuleiro, teclado, funções auxiliares, `copas.lua`).
- `inicio.mp4`, `logo.png`, `audios/`, `sounds/`, `imagens/`, `fonts/` — mídias do jogo (abertura, música, efeitos, sprites do tabuleiro/peças e fontes).
