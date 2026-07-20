# Saida (resposta / explicacao)

Gerei o `gerado.ncl`: um app Ginga-NCL de **menu horizontal de canais com botoes**,
usando **somente** as imagens que ja estavam nesta pasta.

## Imagens da pasta (listadas antes de gerar)

| Arquivo | Tamanho | Papel no app |
|---|---|---|
| `fundo.png` | 1280x720 | Fundo do menu ("TV BELO - MENU PRINCIPAL" + dica de teclas) |
| `btn-clima.png` | 260x70 | Botao CLIMA (laranja) |
| `btn-jogos.png` | 260x70 | Botao JOGOS (azul) |
| `btn-noticias.png` | 260x70 | Botao NOTICIAS (verde) |
| `btn-sobre.png` | 260x70 | Botao SOBRE (roxo) |
| `tela-clima.png` | 1280x720 | Tela cheia do canal CLIMA |
| `tela-jogos.png` | 1280x720 | Tela cheia do canal JOGOS |
| `tela-noticias.png` | 1280x720 | Tela cheia do canal NOTICIAS |
| `tela-sobre.png` | 1280x720 | Tela cheia do canal SOBRE |

As proprias imagens ja documentam a interacao pretendida: o fundo mostra
"<- -> navega * OK seleciona * VERMELHO volta" e cada tela cheia diz
"(VERMELHO para voltar)". O app foi construido exatamente em cima dessa dica.

## Como o app funciona

1. **Inicio** -> abre o `fundo.png` (porta `pStart`).
2. Ao iniciar o fundo, um link liga os **4 botoes** lado a lado (linha horizontal,
   260x70 cada, gap de 48px, em `top=400`) e coloca o **foco no primeiro** botao.
3. **Setas Esquerda/Direita** navegam entre os botoes. A navegacao usa os atributos
   de foco do descritor NCL (`focusIndex` + `moveLeft`/`moveRight`); o botao em foco
   ganha uma **borda branca** (`focusBorderColor="white"`, `focusBorderWidth="4"`).
4. **OK/ENTER** no botao em foco: para o menu (fundo + botoes), abre a **tela cheia**
   correspondente e move o foco para essa tela.
5. **VERMELHO (RED)** na tela cheia: fecha a tela e reabre o `fundo.png`; ao reiniciar,
   o fundo remonta o menu e devolve o foco ao primeiro botao. O ciclo pode repetir.

## Estrutura tecnica

- Perfil: `NCL3.0/EDTVProfile` (Ginga-NCL). Canvas assumido: 1280x720 (bate com as imagens).
- **Regioes**: fundo/telas em tela cheia (`zIndex` 1 e 10); 4 regioes de botao 260x70.
- **Descritores**: botoes com `focusIndex` 1..4 e `moveLeft/moveRight` encadeados;
  telas com `focusIndex` 5..8 (para capturarem o VERMELHO enquanto ativas).
- **Foco**: media `application/x-ginga-settings` com `service.currentFocus`; os links
  usam a acao `set` para reposicionar o foco ao abrir/fechar uma tela.
- **Conectores** (definidos inline, sem depender de arquivo externo):
  - `onBeginStartSet` (onBegin -> start varios + set foco) monta o menu;
  - `onSelStopStartSet` (onSelection/OK -> stop menu + start tela + set foco) abre o canal;
  - `onKeyStopStart` (onSelection key=RED -> stop tela + start fundo) volta ao menu.
- **Links**: 1 de montagem do menu, 4 de abrir canal (OK), 4 de voltar (VERMELHO).

## Verificacao feita

- XML validado como **bem-formado** (`xml.dom.minidom`).
- Todos os `src` referenciados **existem** na pasta (9/9 imagens conferidas).
- Nenhuma imagem externa a pasta foi usada; nenhuma pasta acima foi lida.

## Observacoes

- Os `src` sao relativos (mesma pasta do `.ncl`), entao basta rodar o `gerado.ncl`
  aqui dentro no Ginga.
- Como cada botao tem uma unica arte (sem variante "focado"), o realce de foco e
  feito pela borda branca do descritor. Se quiser destaque diferente (ex.: trocar a
  imagem no foco), da pra adicionar `focusSrc`/imagens de foco depois.
- O keycode de retorno esta como `RED`; se o player/controle usar outro mapeamento
  para a tecla vermelha, basta ajustar o `bindParam name="keyCode"`.
