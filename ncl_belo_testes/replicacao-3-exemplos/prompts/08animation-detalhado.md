# Prompt de intenção — nível DETALHADO (spec)

Gere UM documento NCL autocontido, perfil EDTV (`http://www.ncl.org.br/NCL3.0/EDTVProfile`), usando exclusivamente as mídias da pasta. Descrição do comportamento esperado abaixo (posições em % da tela; tempos referenciados à reprodução do vídeo principal).

## Mídias
- `background.png` — imagem de fundo
- `animGar.mp4` — vídeo principal (fio condutor)
- `choro.mp4` — trilha musical (usar só o áudio, sem exibição na tela)
- `drible.mp4` — clipe curto de drible
- `photo.png` — foto
- `icon.png` — ícone interativo
- `shoes.mp4` — clipe de vídeo do produto
- `ptForm.htm` / `enForm.htm` — formulários de compra (PT / EN)

## Layout (camadas e posições, % da tela)
- **Fundo** (`background.png`): tela cheia (left 0, top 0, width 100%, height 100%), camada mais baixa (zIndex 1).
- **Vídeo principal** (`animGar.mp4`): tela cheia (100% x 100%), camada acima do fundo (zIndex 2).
- **Quadro superior-esquerdo** (usado por `drible.mp4` e por `photo.png`): left 5%, top 6.7%, width 18.5%, height 18.5% (zIndex 3).
- **Ícone** (`icon.png`): canto superior-direito, left 87.5%, top 11.7%, width 8.45%, height 6.7% (zIndex 3).
- **Vídeo do produto** (`shoes.mp4`): região inferior-esquerda, left 15%, top 60%, width 25%, height 25% (zIndex 3).
- **Formulário** (`ptForm.htm` / `enForm.htm`): painel direito, left 57.25%, top 9.83%, width 37.75%, height 70.2% (zIndex 3).

## Linha do tempo (base = animGar.mp4)
- **t = 0s:** `animGar.mp4` inicia em tela cheia (é o ponto de entrada do documento).
- **t = 5s:** com 5s de atraso após o início do vídeo, iniciam JUNTOS `background.png` (fundo) e `choro.mp4` (áudio da trilha).
- **t = 12s:** inicia `drible.mp4` no quadro superior-esquerdo, com transição de entrada tipo *fade* de 2s e transição de saída tipo *barWipe* de 1s.
- **t = 41s:** inicia `photo.png` no quadro superior-esquerdo, com transparência 0.6 e duração explícita de 5s; anime a posição vertical (propriedade `top`) para o valor 290, com atraso de 1s e duração de 3s (a foto desliza para baixo enquanto está visível).
- **t = 45s a 51s:** exibe `icon.png` no canto superior-direito, com duração explícita de 6s. Esse ícone é o alvo da interação.

## Interações
- **Tecla VERMELHA (RED)** — válida enquanto o ícone está na tela (seleção sobre `icon.png`). Ao apertar, nesta ordem:
  1. para/oculta o ícone (`icon.png`);
  2. encolhe o vídeo principal para os limites `5%, 6.67%, 45%, 45%` (left, top, width, height) — um quadrado no canto superior-esquerdo, revelando o `background.png` atrás;
  3. inicia `shoes.mp4` na região inferior-esquerda;
  4. abre o formulário no painel direito por 15s (duração explícita), recebendo foco. Seleção de idioma: se `system.language` for `eng`, usa `enForm.htm`; caso contrário, `ptForm.htm` como padrão.
- **Fim do formulário (após 15s):** ao terminar, redefine os limites do vídeo principal para `0, 0, 222.22%, 222.22%` (volta a preencher a tela — de fato um pouco maior que a tela, dando efeito de zoom de volta ao fullscreen).

## Fechamento
- **Fim de `animGar.mp4`:** para `background.png` e para `choro.mp4`.

## Observações
- O vídeo principal deve ter marcas temporais (âncoras) em 12s, 41s e 45s–51s para disparar os eventos acima.
- O painel do formulário e o vídeo do produto são reutilizados/agrupados num bloco de propaganda; o ícone dispara a compra, e o encolhimento do vídeo principal ocorre para dar espaço ao fundo, ao produto e ao formulário.
- A mesma instância do vídeo principal é reaproveitada dentro do bloco de propaganda para que os limites (`bounds`) possam ser alterados e depois restaurados.
