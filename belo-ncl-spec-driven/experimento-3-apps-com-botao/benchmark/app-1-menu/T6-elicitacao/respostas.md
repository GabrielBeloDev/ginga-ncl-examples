# Respostas — App de menu horizontal (T6-elicitacao)

## 1. Botoes: quais e quantos
1.1. 4 botoes, mas a ordem certa da esquerda pra direita e: **JOGOS, NOTICIAS, CLIMA, SOBRE** (btn-jogos, btn-noticias, btn-clima, btn-sobre). Nao e Clima primeiro.
1.2. Sim, o `fundo.png` fica atras dos botoes na tela inicial. A tela inicial e o menu sobre o fundo, nao e uma das `tela-*`.

## 2. Layout / posicao do menu horizontal
2.1. **Rodape** (base da tela), os 4 botoes lado a lado.
2.2. **Centralizado**, com folga igual entre eles.
2.3. O menu **some** quando abre uma tela de canal (a tela cheia cobre tudo).

## 3. Navegacao (foco)
3.1. So **horizontal** (Esquerda/Direita). Cima/Baixo nao fazem nada.
3.2. Sim, **circular** (do ultimo, direita volta pro primeiro; do primeiro, esquerda vai pro ultimo).
3.3. Foco inicial no **botao 1 = JOGOS**. Borda amarela grossa de foco ok (focusBorderColor="yellow", width 4).

## 4. Selecao (tecla OK / ENTER)
4.1. Sim. **OK** abre a `tela-*` correspondente em **tela cheia** (1280x720) por cima de tudo.
4.2. O **menu fica escondido** enquanto a tela do canal esta aberta; so volta quando fecha.

## 5. Voltar / sair
5.1. Voltar com a tecla **VERMELHA (RED)**. Confirmado.
5.2. Voltar **fecha so a tela aberta** e volta pro menu (mesmo menu, foco onde estava). Nao tem tela de menu separada.
5.3. Nao precisa de sair do app.

## 6. Extras (opcionais)
6.1. Sem titulo/logo. So os botoes e o fundo.
6.2. Sem transparencia extra (alem do proprio PNG dos botoes, que ja e RGBA).
6.3. Sem audio/beep. Ignorar.

---

**Resumo:** 4 botoes na base, ordem JOGOS, NOTICIAS, CLIMA, SOBRE, centralizados sobre `fundo.png`. Navegacao circular Esquerda/Direita, foco inicial no botao 1 (JOGOS), borda amarela. OK abre `tela-*` em tela cheia; VERMELHA volta pro menu. Sem titulo, sem transparencia extra, sem audio. **Pode ir.**
