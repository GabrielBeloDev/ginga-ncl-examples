# Intenção — nível DETALHADO (spec)

Gerar UM documento NCL autocontido, Ginga perfil **EDTV** (`NCL3.0/EDTVProfile`),
referenciando as mídias em `../media/`. O app é um vídeo-tributo do Garrincha com
sincronismo automático ancorado no tempo do vídeo principal e uma interação por tecla
colorida. Todas as posições em % da tela.

## Mídias (arquivos reais)
- `../media/background.png` — imagem de fundo.
- `../media/animGar.mp4` — vídeo principal (âncora de tempo de todo o sincronismo).
- `../media/choro.mp4` — trilha de áudio (usar como áudio, sem imagem).
- `../media/drible.mp4` — clipe curto de drible.
- `../media/photo.png` — foto.
- `../media/icon.png` — ícone de interação (dica do botão VERMELHO).
- `../media/shoes.mp4` — anúncio de tênis.

## Layout (posições em % da tela, com camadas)
- **Fundo** (camada mais baixa, z=1): `background.png` em left=0, top=0, width=100%,
  height=100%.
- **Tela principal** (z=2): `animGar.mp4` em left=0, top=0, width=100%, height=100%.
  Precisa ter uma propriedade de "bounds" (posição/tamanho) alterável em tempo de
  execução.
- **Caixa moldura** (z=3), canto superior esquerdo: left=5%, top=6.7%, width=18.5%,
  height=18.5%. Compartilhada por `drible.mp4` e `photo.png`.
- **Caixa ícone** (z=3), canto superior direito: left=87.5%, top=11.7%, width=8.45%,
  height=6.7%. Usada por `icon.png`.
- **Caixa anúncio** (z=3), parte inferior esquerda: left=15%, top=60%, width=25%,
  height=25%. Usada por `shoes.mp4`.

## Linha do tempo (tempos ancorados no `animGar.mp4`)
- **t=0s**: o documento inicia por `animGar.mp4` (ponto de entrada). Toca em tela cheia
  até o fim.
- **t=5s** (5s após o início do vídeo principal): iniciar **em paralelo** o fundo
  `background.png` e a música `choro.mp4`.
- **t=12s**: iniciar `drible.mp4` na caixa moldura (canto sup. esquerdo), com a duração
  natural do clipe. Disparado por âncora aos 12s do vídeo principal.
- **t=41s → 46s**: exibir `photo.png` na caixa moldura por **5s** (duração explícita
  5s). Disparado por âncora aos 41s do vídeo principal.
- **t=45s → 51s**: exibir `icon.png` na caixa ícone (canto sup. direito), duração
  explícita **6s** (âncora de 45s a 51s do vídeo principal). É a janela em que a
  interação fica disponível.
- **fim do `animGar.mp4`**: parar **em paralelo** `background.png` e `choro.mp4`; o
  programa encerra.

## Interação (tecla colorida)
- **Condição**: a seleção é feita SOBRE o `icon.png`, então só vale enquanto ele
  estiver visível (janela 45–51s), ao pressionar a tecla **VERMELHA (RED)**. Executar
  em sequência:
  1. parar/esconder `icon.png`;
  2. redimensionar o vídeo principal `animGar.mp4` para uma janela reduzida no canto
     superior esquerdo — bounds left=5%, top=6.67%, width=45%, height=45% (revela o
     `background.png` atrás);
  3. iniciar o anúncio `shoes.mp4` na caixa anúncio (inferior esquerda).
- **Ao término de `shoes.mp4`**: restaurar o vídeo principal `animGar.mp4` para
  ocupar a tela inteira novamente — bounds de volta para `0, 0, 222.22%, 222.22%`
  (usar exatamente esses números; valor relativo ao estado encolhido que restaura a
  tela cheia).

## Observações de comportamento
- Todo o sincronismo (drible, foto, ícone) é disparado pelo avanço do tempo do vídeo
  principal `animGar.mp4`, não por relógio absoluto.
- Se o telespectador não apertar VERMELHO durante a janela do ícone, o vídeo segue
  normal em tela cheia até o fim, e nenhum anúncio é exibido.

## Entrega
Um único arquivo `.ncl` autocontido, perfil EDTV, pronto para rodar no Ginga, usando as
sete mídias listadas.
