# Perguntas de esclarecimento — App NCL "Guia de Programação" (lista vertical com botões)

Pedido recebido: *"quero um app NCL de guia de programação (lista vertical) com botões, com as imagens dessa pasta"*.

Antes de gerar o NCL, preciso confirmar alguns pontos. Já dei uma olhada nas imagens da pasta e coloquei um **default sugerido** em cada pergunta (baseado no que as imagens indicam) — se estiver tudo certo, é só responder "beleza/confirma tudo" que sigo com os defaults.

## Imagens que achei na pasta
- `fundo.png` — fundo escuro com cabeçalho: "GUIA — HOJE NA TV (↑↓ navega • OK abre • VERMELHO volta)"
- `item-1.png` = **18h — Novela** (vinho) · `item-2.png` = **19h — Jornal** (azul) · `item-3.png` = **20h — Futebol** (verde) · `item-4.png` = **22h — Filme** (marrom) · `item-5.png` = **23h — Show** (roxo)
- `tela-1.png` … `tela-5.png` — telas de detalhe em tela cheia, uma por item, cada uma com "(VERMELHO volta)"

---

## 1. Itens / conteúdo da lista
1.1. Uso os **5 itens** (Novela, Jornal, Futebol, Filme, Show), nessa ordem de cima pra baixo? *(default: sim, os 5, nessa ordem)*
1.2. Cada botão é a própria imagem `item-N.png` (não preciso desenhar texto/retângulo via NCL, né)? *(default: sim, uso as imagens direto)*

## 2. Layout / posição na tela
2.1. Resolução alvo **1280×720**, coordenadas em pixels? *(default: sim, 1280×720)*
2.2. O `fundo.png` (com o cabeçalho) fica **sempre visível** atrás da lista? *(default: sim, fundo entra no início e fica)*
2.3. Lista **vertical, centralizada/à esquerda**, começando **abaixo do cabeçalho** (~100px do topo), botões empilhados com espaçamento uniforme? *(default: coluna alinhada à esquerda com margem, um botão embaixo do outro, ~10px de gap)*
2.4. Mantenho a **proporção original** de cada `item-N.png` (tipo ~510×64) ou estico pra uma largura fixa? *(default: largura fixa da coluna, mantendo altura proporcional)*

## 3. Navegação entre botões
3.1. Navegação com as teclas **↑ / ↓** (setas cima/baixo), como diz o cabeçalho? *(default: sim, moveUp/moveDown)*
3.2. Navegação **circular** (do último ↓ volta pro primeiro, e do primeiro ↑ vai pro último)? *(default: sim, circular)*
3.3. As teclas **← / →** fazem alguma coisa ou ignoro? *(default: ignoro, só ↑↓ navegam)*
3.4. **Foco inicial** no item 1 (**18h — Novela**)? *(default: sim, currentFocus = 1)*
3.5. Destaque do foco: **borda amarela, espessura 4** (focusBorderColor="yellow" / focusBorderWidth="4")? *(default: sim)*

## 4. Ação do OK (seleção)
4.1. Apertar **OK** num item abre a **tela de detalhe correspondente** (`item-N` → `tela-N`)? *(default: sim)*
4.2. A tela de detalhe é **tela cheia** e **cobre** a lista + o fundo enquanto está aberta? *(default: sim, tela-N ocupa 1280×720 por cima de tudo)*
4.3. Dá pra ter **só uma** tela de detalhe aberta por vez (abrir uma fecha a lista, e voltar reexibe a lista)? *(default: sim)*

## 5. Voltar (tecla VERMELHA)
5.1. Dentro da tela de detalhe, a tecla **VERMELHA (RED)** fecha o detalhe e **volta pra lista**? *(default: sim)*
5.2. Ao voltar, o foco retorna **no mesmo item** que estava selecionado? *(default: sim, mantém o foco)*
5.3. A tecla VERMELHA faz algo **na tela da lista** (ex.: sair do app) ou só funciona dentro do detalhe? *(default: só dentro do detalhe; na lista não faz nada)*

## 6. Extras (opcionais)
6.1. Quer algum **som**/áudio ao selecionar ou ao abrir? *(default: não, sem áudio)*
6.2. Quer **transparência** em algum elemento? *(default: não)*
6.3. Nome do arquivo de saída: `gerado.ncl` na própria pasta-de-trabalho? *(default: sim)*

---

**Responde o que quiser mudar (ou "confirma tudo") que eu gero o NCL na sequência.**
