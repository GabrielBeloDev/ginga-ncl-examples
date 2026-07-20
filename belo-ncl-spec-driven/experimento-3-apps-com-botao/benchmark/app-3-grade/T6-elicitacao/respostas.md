# Respostas de elicitacao — App NCL "grade de aplicativos 2x3 com botoes"

Resumo: **usa as sugestoes**. Quero exatamente uma grade de 2 linhas x 3 colunas com 6 apps sobre o `fundo.png`, navegacao pelas 4 setas, OK abre a tela do app e VERMELHO volta, foco comecando no primeiro. Detalhando item a item:

## 1. Layout da grade
1. **3 colunas x 2 linhas** (paisagem). Usa a sugestao.
2. Sim, ordem **VIDEO, MUSICA, FOTOS** (linha 1) e **JOGOS, LOJA, CONFIG** (linha 2), lendo app-1..app-6 da esquerda p/ direita, de cima p/ baixo. Usa a sugestao.
3. Sim, `fundo.png` cobrindo a tela toda (com o titulo e as instrucoes). Usa a sugestao.
4. Pode definir **margens e gaps automaticos** pra deixar a grade 2x3 centralizada e proporcional. Nao tenho coordenadas fixas.

## 2. Botoes
5. Sim, **6 botoes**, um por imagem: VIDEO (app-1), MUSICA (app-2), FOTOS (app-3), JOGOS (app-4), LOJA (app-5), CONFIG (app-6). Nao tira nem adiciona nenhum.

## 3. Navegacao
6. Sim, **setas do controle**: CIMA, BAIXO, ESQUERDA e DIREITA (navegacao nas 2 direcoes). Usa a sugestao.
7. Sim, **navegacao circular** nas bordas (passou do fim volta pro comeco). Usa a sugestao.
8. Sim, **foco inicial no primeiro** botao = VIDEO (app-1). Usa a sugestao.
9. Sim, destaque de foco com **borda amarela grossa** (focusBorderColor amarelo, largura 4). Usa a sugestao.

## 4. Acao do OK
10. Sim, OK **abre a tela de detalhe** do app focado: app-N -> tela-N (mapeamento 1:1). Usa a sugestao.
11. Sim, a tela de detalhe **cobre a grade inteira** (fullscreen por cima). Usa a sugestao.

## 5. Voltar
12. Sim, tecla **VERMELHA (RED)** fecha a tela de detalhe e volta pra grade. Usa a sugestao.
13. Ao voltar, o **foco volta pro botao que abriu** a tela. Usa a sugestao.
14. VERMELHA **na grade** (sem detalhe aberto) **nao faz nada** — so tem efeito quando ha detalhe aberto. Usa a sugestao.

## 6. Tecnico / saida
15. Sim, **NCL 3.0 EDTV, autocontido** (regioes, descritores, conectores e elos inline), referenciando so as imagens da pasta pelo nome. Usa a sugestao.
16. Pode gerar **`app-grade.ncl`** aqui na `pasta-de-trabalho`. Nome ok.

---

Tudo confirmado, pode gerar o NCL.
