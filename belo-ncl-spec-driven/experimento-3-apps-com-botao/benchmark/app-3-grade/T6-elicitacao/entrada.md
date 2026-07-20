# Entrada — App NCL "grade de aplicativos 2x3 com botoes" (T6 elicitacao)

## Pedido original (vago)
> "quero um app NCL de grade de aplicativos 2x3 com botoes, com as imagens dessa pasta"

## Imagens disponiveis na pasta
- `fundo.png` (1280x720) — plano de fundo com cabecalho "APLICATIVOS (setas navega, OK abre, VERMELHO volta)"
- `app-1.png`..`app-6.png` (300x150) — botoes: VIDEO (1, azul), MUSICA (2, roxo), FOTOS (3, verde), JOGOS (4, vermelho), LOJA (5, dourado), CONFIG (6, cinza)
- `tela-1.png`..`tela-6.png` (1280x720) — telas de detalhe em tela cheia, uma por app (ex: tela-1 = "VIDEO / VERMELHO volta")

## Perguntas de elicitacao (resumo)
1. Orientacao da grade 2x3 (paisagem 3x2 ou retrato 2x3)?
2. Ordem dos botoes (VIDEO..CONFIG, app-1..app-6)?
3. Usar `fundo.png` cobrindo a tela toda?
4. Margens/gaps automaticos ou coordenadas fixas?
5. Confirma 6 botoes, um por imagem?
6. Tecla que navega = setas do controle?
7. Navegacao circular nas bordas?
8. Foco inicial no VIDEO (app-1)?
9. Destaque de foco = borda amarela grossa?
10. OK abre a tela de detalhe (app-N -> tela-N)?
11. Tela de detalhe cobre a grade (fullscreen)?
12. VERMELHA (RED) fecha o detalhe e volta pra grade?
13. Ao voltar, foco volta pro botao que abriu?
14. VERMELHA na grade (sem detalhe) faz algo?
15. NCL 3.0 EDTV autocontido, so imagens da pasta?
16. Nome/local do arquivo de saida?

## Respostas do usuario ("usa as sugestoes")
1. 3 colunas x 2 linhas (paisagem).
2. Ordem VIDEO, MUSICA, FOTOS (linha 1) / JOGOS, LOJA, CONFIG (linha 2), app-1..app-6 esq->dir, cima->baixo.
3. Sim, `fundo.png` cobrindo a tela toda.
4. Margens e gaps automaticos, grade 2x3 centralizada; sem coordenadas fixas.
5. Sim, 6 botoes, um por imagem; nao tira nem adiciona.
6. Sim, as 4 setas (CIMA/BAIXO/ESQUERDA/DIREITA).
7. Sim, navegacao circular nas bordas.
8. Sim, foco inicial no primeiro botao (VIDEO / app-1).
9. Sim, borda amarela grossa (focusBorderColor amarelo, largura 4).
10. Sim, OK abre app-N -> tela-N (mapeamento 1:1).
11. Sim, tela de detalhe fullscreen por cima.
12. Sim, RED fecha o detalhe e volta pra grade.
13. Sim, foco volta pro botao que abriu a tela.
14. RED na grade (sem detalhe aberto) nao faz nada.
15. Sim, NCL 3.0 EDTV autocontido, so imagens da pasta.
16. Gerar na `pasta-de-trabalho` (arquivo entregue: `gerado.ncl`).

## Escopo fechado (nada alem disto foi assumido)
Grade 3x2 de 6 botoes sobre `fundo.png`, navegacao pelas 4 setas com circularidade,
foco inicial no app-1, borda de foco amarela grossa, OK abrindo tela-N fullscreen,
RED voltando e devolvendo o foco ao botao de origem, RED sem efeito na grade.
