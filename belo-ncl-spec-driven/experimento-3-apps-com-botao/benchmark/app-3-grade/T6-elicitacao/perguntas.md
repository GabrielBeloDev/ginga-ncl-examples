# Perguntas de elicitacao — App NCL "grade de aplicativos 2x3 com botoes"

Pedido do usuario (vago): "quero um app NCL de grade de aplicativos 2x3 com botoes, com as imagens dessa pasta".

Antes de gerar o NCL preciso fechar alguns pontos. Marquei em **[sugestao]** o que da pra assumir olhando as imagens da pasta — se concordar, e so dizer "usa as sugestoes".

## Imagens encontradas na pasta
- `fundo.png` — plano de fundo com cabecalho "APLICATIVOS (setas navega, OK abre, VERMELHO volta)"
- `app-1.png` = **VIDEO** (azul) · `app-2.png` = **MUSICA** (roxo) · `app-3.png` = **FOTOS** (verde)
- `app-4.png` = **JOGOS** (vermelho) · `app-5.png` = **LOJA** (dourado) · `app-6.png` = **CONFIG** (cinza)
- `tela-1.png` ... `tela-6.png` — telas de detalhe em tela cheia, uma por app (ex: tela-1 = "VIDEO / VERMELHO volta")

---

## 1. Layout da grade
1. **Orientacao da grade 2x3**: 3 colunas x 2 linhas (paisagem) ou 2 colunas x 3 linhas (retrato)? As imagens sao 16:9, entao **[sugestao: 3 colunas x 2 linhas]**.
2. **Ordem dos botoes** na grade: fica na sequencia VIDEO, MUSICA, FOTOS (linha de cima) / JOGOS, LOJA, CONFIG (linha de baixo)? **[sugestao: essa ordem, app-1..app-6 lendo da esquerda p/ direita, de cima p/ baixo]**.
3. **Fundo**: uso o `fundo.png` como plano de fundo (ele ja traz o titulo e as instrucoes de tecla)? **[sugestao: sim, fundo.png cobrindo a tela toda]**.
4. **Tamanho/espacamento dos botoes**: posso definir margens e gaps automaticos pra caber a grade centralizada, ou voce quer coordenadas/tamanhos especificos?

## 2. Botoes (quais e quantos)
5. Confirma **6 botoes**, um por imagem app-1..app-6 (VIDEO, MUSICA, FOTOS, JOGOS, LOJA, CONFIG)? Algum pra tirar/adicionar?

## 3. Navegacao
6. **Tecla que navega**: as setas do controle (cursor cima/baixo/esquerda/direita)? **[sugestao: setas]**.
7. **Navegacao circular** (ao passar da borda volta pro outro lado, ex: da ultima coluna pula pra primeira)? **[sugestao: sim, circular]**.
8. **Foco inicial**: comeca no VIDEO (app-1)? **[sugestao: sim]**.
9. **Destaque do foco**: borda amarela grossa (focusBorderColor="yellow", width 4)? **[sugestao: sim]**.

## 4. Acao do OK (selecao)
10. OK **abre a tela de detalhe** correspondente ao botao focado (app-N -> tela-N em tela cheia)? **[sugestao: sim, mapeamento 1:1]**.
11. A tela de detalhe **cobre a grade inteira** (fullscreen por cima)? **[sugestao: sim, fullscreen]**.

## 5. Voltar
12. **Tecla VERMELHA (RED)** fecha a tela de detalhe e volta pra grade? **[sugestao: sim]** (bate com o texto das telas).
13. Ao voltar, o **foco volta pro botao que abriu** ou reinicia no VIDEO? **[sugestao: volta pro botao que abriu]**.
14. VERMELHA **na propria grade** (sem detalhe aberto) faz algo — sair do app / nada? **[sugestao: nada, so volta quando tem detalhe aberto]**.

## 6. Tecnico / saida
15. Perfil **NCL 3.0 EDTV, autocontido** (regioes, descritores, conectores e elos inline), referenciando so as imagens da pasta pelo nome — confirma? **[sugestao: sim]**.
16. **Nome e local do arquivo** de saida: gero `app-grade.ncl` aqui na `pasta-de-trabalho`? Algum nome preferido?

---

Responde os itens que quiser mudar; no que estiver ok pode so falar "usa a sugestao". Assim que confirmar, eu gero o NCL.
