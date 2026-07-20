# Entrada — App NCL "Guia de Programação" (T6 elicitação)

## Pedido original (vago)
> "quero um app NCL de guia de programação (lista vertical) com botões, com as imagens dessa pasta"

## Imagens disponíveis na pasta
- `fundo.png` (1280×720) — fundo escuro com cabeçalho: "GUIA — HOJE NA TV (↑↓ navega • OK abre • VERMELHO volta)"
- `item-1.png` … `item-5.png` (520×70 cada) — botões da lista:
  - item-1 = **18h — Novela** (vinho)
  - item-2 = **19h — Jornal** (azul)
  - item-3 = **20h — Futebol** (verde)
  - item-4 = **22h — Filme** (marrom)
  - item-5 = **23h — Show** (roxo)
- `tela-1.png` … `tela-5.png` (1280×720 cada) — telas de detalhe em tela cheia, uma por item, cada uma com "(VERMELHO volta)"

---

## Perguntas de elicitação (com defaults sugeridos)

### 1. Itens / conteúdo da lista
- 1.1. Usar os 5 itens (Novela, Jornal, Futebol, Filme, Show) nessa ordem? *(default: sim)*
- 1.2. Cada botão é a própria imagem `item-N.png`, sem desenhar texto/retângulo via NCL? *(default: sim)*

### 2. Layout / posição
- 2.1. Resolução 1280×720, coordenadas em pixels? *(default: sim)*
- 2.2. `fundo.png` sempre visível atrás da lista? *(default: sim)*
- 2.3. Lista vertical à esquerda, abaixo do cabeçalho (~100px do topo), gap uniforme? *(default: sim)*
- 2.4. Manter proporção original de cada `item-N.png` ou esticar? *(default: largura fixa da coluna, altura proporcional)*

### 3. Navegação entre botões
- 3.1. Navegação com ↑ / ↓? *(default: sim, moveUp/moveDown)*
- 3.2. Navegação circular? *(default: sim)*
- 3.3. ← / → fazem algo? *(default: ignoro)*
- 3.4. Foco inicial no item 1? *(default: sim, currentFocus = 1)*
- 3.5. Destaque do foco: borda amarela, espessura 4? *(default: sim)*

### 4. Ação do OK (seleção)
- 4.1. OK abre a tela de detalhe correspondente (item-N → tela-N)? *(default: sim)*
- 4.2. Detalhe em tela cheia cobrindo lista + fundo? *(default: sim)*
- 4.3. Só uma tela de detalhe aberta por vez? *(default: sim)*

### 5. Voltar (tecla VERMELHA)
- 5.1. RED fecha o detalhe e volta pra lista? *(default: sim)*
- 5.2. Ao voltar, foco no mesmo item? *(default: sim)*
- 5.3. RED faz algo na lista ou só no detalhe? *(default: só no detalhe)*

### 6. Extras
- 6.1. Som/áudio? *(default: não)*
- 6.2. Transparência? *(default: não)*
- 6.3. Saída `gerado.ncl` na pasta? *(default: sim)*

---

## Respostas do usuário
**Resumo: "confirma tudo"** — seguiu todos os defaults. Detalhes confirmados:

1. **Itens** — os 5 itens na ordem item-1 a item-5; cada botão é a própria imagem `item-N.png`, sem desenhar nada via NCL.
2. **Layout** — 1280×720 em pixels; `fundo.png` entra no início e fica; coluna vertical à esquerda abaixo do cabeçalho (~100px); largura fixa da coluna mantendo altura proporcional.
3. **Navegação** — só ↑/↓ (moveUp/moveDown); circular; ←/→ ignoradas; foco inicial no item 1 (currentFocus = 1); borda amarela espessura 4.
4. **OK** — abre a tela de detalhe correspondente (item-N → tela-N); tela cheia cobrindo lista e fundo; só uma aberta por vez.
5. **VERMELHO** — RED fecha o detalhe e volta pra lista mantendo o foco no mesmo item; na lista não faz nada (só dentro do detalhe).
6. **Extras** — sem áudio; sem transparência; saída `gerado.ncl` na própria pasta.
