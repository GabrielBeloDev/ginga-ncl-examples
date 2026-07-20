# Respostas — App NCL "Guia de Programação" (lista vertical com botões)

**Resumo:** confirma tudo. Segue com os defaults, com os detalhes abaixo.

## 1. Itens / conteúdo da lista
1.1. Sim — os 5 itens nessa ordem: 18h Novela, 19h Jornal, 20h Futebol, 22h Filme, 23h Show (item-1 a item-5).
1.2. Sim — cada botão é a própria imagem `item-N.png`, sem desenhar texto/retângulo via NCL.

## 2. Layout / posição na tela
2.1. Sim — 1280×720, coordenadas em pixels.
2.2. Sim — `fundo.png` entra no início e fica sempre visível atrás da lista.
2.3. Sim — coluna vertical à esquerda, abaixo do cabeçalho (~100px do topo), botões empilhados com gap uniforme.
2.4. Largura fixa da coluna mantendo a altura proporcional. Beleza.

## 3. Navegação entre botões
3.1. Sim — só ↑ / ↓ (moveUp/moveDown).
3.2. Sim — circular (último ↓ volta pro primeiro; primeiro ↑ vai pro último).
3.3. Ignoro ← / → — não fazem nada.
3.4. Sim — foco inicial no item 1 (18h Novela), currentFocus = 1.
3.5. Sim — borda amarela, espessura 4.

## 4. Ação do OK (seleção)
4.1. Sim — OK abre a tela de detalhe correspondente (item-N → tela-N).
4.2. Sim — tela de detalhe em tela cheia (1280×720), cobrindo a lista e o fundo.
4.3. Sim — só uma tela de detalhe aberta por vez.

## 5. Voltar (tecla VERMELHA)
5.1. Sim — VERMELHO fecha o detalhe e volta pra lista.
5.2. Sim — volta mantendo o foco no mesmo item selecionado.
5.3. VERMELHO só funciona dentro do detalhe; na lista não faz nada.

## 6. Extras (opcionais)
6.1. Não — sem áudio.
6.2. Não — sem transparência.
6.3. Sim — saída `gerado.ncl` na própria pasta-de-trabalho.
