# Respostas — Elicitação App NCL "Diálogo Sim/Não" (Canal Belo)

Pode usar os defaults. Segue confirmação ponto a ponto.

## Imagens
Pode usar **todas as 5** (`fundo.png`, `btn-sim.png`, `btn-nao.png`, `tela-sim.png`, `tela-nao.png`), referenciando pelo nome. Nenhuma fica de fora.

## 1. Botões
- 1.1. Sim, **2 botões**: SIM (`btn-sim.png`) e NAO (`btn-nao.png`). Só esses.
- 1.2. Ordem **SIM à esquerda / NAO à direita**.

## 2. Layout
- 2.1. **Centralizados horizontalmente, lado a lado, no meio da tela**. Serve.
- 2.2. Tamanho **~260x64 px** cada, com espaço entre eles. Ok.
- 2.3. Confirmado — a dica de navegação já está dentro do `fundo.png`. **Não crie texto extra**, use a imagem como está.

## 3. Navegação e foco
- 3.1. Setas **ESQUERDA/DIREITA** movem o foco. Só essas (não precisa CIMA/BAIXO).
- 3.2. Navegação **circular** (SIM ↔ NAO). Sim.
- 3.3. Foco inicial no **SIM**.
- 3.4. Destaque do foco: **borda amarela, espessura 4**. Mantém.

## 4. Ação do OK
- 4.1. Confirmado: **OK no SIM → `tela-sim.png`** ("Assinatura confirmada!") e **OK no NAO → `tela-nao.png`** ("Talvez depois.").
- 4.2. Ao mostrar o resultado, o **diálogo some** e a tela de resultado ocupa a **tela inteira**. Botões não ficam por cima.

## 5. Tecla VERMELHA
- 5.1. Nas telas de resultado, **VERMELHO volta pro diálogo inicial** (fundo + botões, foco restaurado no SIM). Sim.
- 5.2. Na tela inicial, VERMELHO **não faz nada** (default).

## 6. Detalhes técnicos
- 6.1. **NCL 3.0 EDTV, autocontido** (regiões, descritores, conectores e elos inline). Confirmado.
- 6.2. Canvas **1280x720 (720p)**. Ok.
- 6.3. Saída **`main.ncl`** na própria `pasta-de-trabalho/`. Ok.

---

**Aprovado — segue exatamente o fluxo do resumo dos defaults.**
