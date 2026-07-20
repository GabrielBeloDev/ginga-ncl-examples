# Entrada — App de menu horizontal de canais (T6-elicitacao)

## Pedido original (vago)

> "quero um app NCL de menu horizontal de canais com botoes, com as imagens dessa pasta"

## Imagens disponiveis na pasta (uso so estas, referenciadas por nome)

| Arquivo | Tamanho | Papel |
|---|---|---|
| `fundo.png` | 1280x720 | fundo/tela cheia |
| `btn-jogos.png` | 260x70 (RGBA) | botao Jogos |
| `btn-noticias.png` | 260x70 (RGBA) | botao Noticias |
| `btn-clima.png` | 260x70 (RGBA) | botao Clima |
| `btn-sobre.png` | 260x70 (RGBA) | botao Sobre |
| `tela-jogos.png` | 1280x720 | tela de conteudo Jogos |
| `tela-noticias.png` | 1280x720 | tela de conteudo Noticias |
| `tela-clima.png` | 1280x720 | tela de conteudo Clima |
| `tela-sobre.png` | 1280x720 | tela de conteudo Sobre |

Canvas base: 1280x720.

## Perguntas de elicitacao (resumo)

1. Botoes: quais/quantos e se `fundo.png` fica atras.
2. Layout: posicao da faixa (rodape/topo/centro), espacamento, se o menu some ao abrir tela.
3. Navegacao/foco: horizontal ou tambem vertical, circular ou nao, foco inicial e destaque.
4. Selecao (OK): abre `tela-*` em tela cheia; menu escondido enquanto tela aberta.
5. Voltar/sair: tecla de voltar, o que ela fecha, se precisa sair do app.
6. Extras: titulo/logo, transparencia, audio.

## Respostas do usuario (decisivas — base da geracao)

1.1. **4 botoes**, ordem esquerda->direita: **JOGOS, NOTICIAS, CLIMA, SOBRE**.
1.2. `fundo.png` fica **atras dos botoes** na tela inicial (o menu e sobre o fundo, nao e uma `tela-*`).
2.1. Faixa no **rodape**, 4 botoes lado a lado.
2.2. **Centralizado**, folga igual entre eles.
2.3. O menu **some** quando abre uma tela de canal (a tela cheia cobre tudo).
3.1. So **horizontal** (Esquerda/Direita); Cima/Baixo nao fazem nada.
3.2. Navegacao **circular**.
3.3. Foco inicial no **botao 1 = JOGOS**; borda amarela grossa (yellow, width 4).
4.1. **OK** abre a `tela-*` correspondente em **tela cheia** por cima de tudo.
4.2. **Menu escondido** enquanto a tela do canal esta aberta; volta so quando fecha.
5.1. Voltar com a tecla **VERMELHA (RED)**.
5.2. Voltar **fecha so a tela aberta** e volta pro menu (mesmo menu, foco preservado); sem tela de menu separada.
5.3. **Nao** precisa sair do app.
6.1. **Sem** titulo/logo.
6.2. **Sem** transparencia extra (alem do RGBA proprio dos PNGs).
6.3. **Sem** audio/beep.

Decisao final do usuario: **"Pode ir."**
