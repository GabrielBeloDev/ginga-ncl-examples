# damasTV

> Jogo de damas interativo para TV Digital, em NCL + Lua, com modo local (contra o computador) e multiplayer via TCP · PUC-Rio / Laboratório TeleMídia · 2008 (arquivos de 2011)

## O que é
Um jogo de damas jogável pelo controle remoto da TV Digital Interativa, construído em NCL (estrutura, mídias e sincronismo) com toda a lógica do jogo escrita em Lua (NCLua). O documento `damas.ncl` orquestra um vídeo de abertura (`inicio.mp4`), música de fundo em loop e um amplo conjunto de efeitos sonoros (mover, comer, virar dama, soprar, vitória) acionados por links NCL a partir de áreas disparadas pelo código Lua. O motor em Lua desenha o tabuleiro e as peças via `canvas` do NCLua, implementa um adversário controlado pelo computador (`computador.lua`) e suporta partidas multiplayer através do canal de retorno usando eventos TCP (`conexaoTcp.lua`, `rede.lua`, `jogoRede.lua`).

## Como rodar
```bash
cd damasTV
ginga damas.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
O esperado seria o vídeo de abertura, seguido do menu do jogo e do tabuleiro de damas com música de fundo, jogável com as teclas direcionais e OK do controle. Na prática, o aplicativo nem chega a carregar (veja Status). Sem screenshot.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — falha no parse do documento NCL, antes de qualquer renderização.
- Erro exato: `damas.ncl: Element <descriptorParam> at line 39: Unknown attribute 'region'`
- Causa-raiz: a linha 39 declara `<descriptorParam name="soundLevel" region="test" value="1" />`. O atributo `region` não é válido em `<descriptorParam>`, e o parser NCL novo (mais estrito) do Ginga C++ rejeita o documento. Em players antigos esse atributo era simplesmente ignorado.

## Limitações conhecidas
- Erro de parse (acima) impede o carregamento; basta remover o atributo `region="test"` da linha 39 para passar dessa etapa, mas isso não foi aplicado/validado aqui.
- O modo multiplayer depende de servidor e conexão TCP pelo canal de retorno (`conexaoTcp.lua`, `rede.lua`), infraestrutura indisponível hoje.
- Coleção histórica de TV Digital (~2008–2012) rodando em Ginga moderno; mesmo após correções de parse, recursos de rede e de áudio podem não se comportar como na época.

## Arquivos principais
- `damas.ncl` — documento NCL principal: regiões, descritores, regras de efeito sonoro, mídias (vídeo, música, sons) e links de sincronismo.
- `lua/principal.lua` — ponto de entrada NCLua; máquina de estados (tela, jogo, opções, rede) e laço de quadros/eventos.
- `lua/jogo.lua` / `lua/jogoRede.lua` — lógica da partida local e da partida em rede.
- `lua/computador.lua` — adversário controlado pelo computador (escolha de jogadas).
- `lua/menuJogo.lua` / `lua/menuJogoRede.lua` — menus, placar e mensagens na tela.
- `lua/conexaoTcp.lua` / `lua/rede.lua` — comunicação multiplayer via eventos TCP.
- `lua/engine/` — funções de apoio (movimentador, tabuleiro, teclado, funções auxiliares).
- `inicio.mp4`, `logo.png`, `audios/`, `sounds/`, `imagens/`, `fonts/` — mídias do jogo (abertura, música, efeitos, sprites do tabuleiro/peças e fontes).
