# Entrada — App NCL "Diálogo de decisão Sim/Não" (Canal Belo)

## Pedido original do usuário (vago)
> "quero um app NCL de diálogo de decisão Sim/Não com botões, com as imagens dessa pasta"

## Imagens disponíveis na pasta (as únicas usadas)
- `fundo.png` (1280x720) — header "CANAL BELO", pergunta "Deseja assinar o Canal Belo?" e dica no rodapé "(← → escolhe • OK confirma • VERMELHO volta)".
- `btn-sim.png` (320x90) — botão verde "SIM".
- `btn-nao.png` (320x90) — botão vermelho "NAO".
- `tela-sim.png` (1280x720) — tela verde "Assinatura confirmada! (VERMELHO volta)".
- `tela-nao.png` (1280x720) — tela vermelha "Talvez depois. (VERMELHO volta)".

---

## Perguntas de elicitação (com meus defaults)

### Imagens
Usar todas as 5, referenciando pelo nome? Alguma fica de fora?

### 1. Botões
- 1.1. São 2 botões: SIM (`btn-sim.png`) e NAO (`btn-nao.png`)?
- 1.2. Ordem SIM à esquerda / NAO à direita?

### 2. Layout
- 2.1. Botões centralizados horizontalmente, lado a lado, no meio da tela?
- 2.2. Tamanho ~260x64 px cada, com espaço entre eles?
- 2.3. A dica de navegação já está dentro do `fundo.png` — não criar texto extra?

### 3. Navegação e foco
- 3.1. Setas ESQUERDA/DIREITA movem o foco (sem CIMA/BAIXO)?
- 3.2. Navegação circular (SIM ↔ NAO)?
- 3.3. Foco inicial no SIM?
- 3.4. Destaque do foco: borda amarela, espessura 4?

### 4. Ação do OK
- 4.1. OK no SIM → `tela-sim.png`; OK no NAO → `tela-nao.png`?
- 4.2. Ao mostrar o resultado, o diálogo some e a tela ocupa a tela inteira?

### 5. Tecla VERMELHA
- 5.1. Nas telas de resultado, VERMELHO volta pro diálogo inicial (foco restaurado no SIM)?
- 5.2. Na tela inicial, VERMELHO não faz nada?

### 6. Detalhes técnicos
- 6.1. NCL 3.0 EDTV, autocontido?
- 6.2. Canvas 1280x720?
- 6.3. Saída na própria `pasta-de-trabalho/`?

---

## Respostas do usuário
**"Pode usar os defaults."** — Confirmação ponto a ponto:

- **Imagens:** usar as 5, nenhuma de fora.
- **1.1** Sim, 2 botões (SIM/NAO), só esses. **1.2** SIM à esquerda / NAO à direita.
- **2.1** Centralizados, lado a lado, no meio. **2.2** ~260x64 px cada, com espaço. **2.3** Sem texto extra, usar `fundo.png` como está.
- **3.1** Só ESQUERDA/DIREITA. **3.2** Circular SIM ↔ NAO. **3.3** Foco inicial no SIM. **3.4** Borda amarela, espessura 4.
- **4.1** OK no SIM → `tela-sim.png`; OK no NAO → `tela-nao.png`. **4.2** Diálogo some, resultado em tela cheia.
- **5.1** Nas telas de resultado, VERMELHO volta ao diálogo (foco no SIM). **5.2** Na tela inicial, VERMELHO não faz nada.
- **6.1** NCL 3.0 EDTV, autocontido. **6.2** 1280x720. **6.3** Saída na `pasta-de-trabalho/`.

**Aprovado — seguir exatamente o fluxo dos defaults.**

> Observação: nesta esteira de benchmark o arquivo gerado é salvo como `gerado.ncl` (a elicitação citava `main.ncl` como nome default; o pipeline padroniza em `gerado.ncl`).
