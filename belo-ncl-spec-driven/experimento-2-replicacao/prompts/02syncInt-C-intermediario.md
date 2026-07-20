# Intenção — nível INTERMEDIÁRIO

Gera UM documento NCL autocontido (Ginga, perfil EDTV) usando as mídias da pasta `../media/`.
É um vídeo-tributo do Garrincha com sincronismo automático e uma interação com o controle.

## Ideia geral (o que aparece onde)
- O app começa pelo vídeo principal `animGar.mp4`, que ocupa a tela inteira.
- Atrás dele fica a imagem de fundo `background.png` (tela cheia), e junto toca a
  música `choro.mp4` (só áudio, sem imagem).
- Tem uma caixinha no canto superior esquerdo onde entram, em momentos diferentes, o
  clipe `drible.mp4` e depois a foto `photo.png`.
- Tem uma caixinha no canto superior direito onde aparece o ícone `icon.png` (é a dica
  de "aperta o botão").
- Tem uma caixa mais embaixo, à esquerda, reservada pro anúncio `shoes.mp4`.

## Linha do tempo (aproximada)
- Assim que o vídeo principal começa, uns 5 segundos depois entram juntos o fundo
  `background.png` e a música `choro.mp4`.
- Lá pelos 12s, o clipe `drible.mp4` aparece na caixinha do canto superior esquerdo.
- Lá pelos 40s, a foto `photo.png` aparece nessa mesma caixinha e fica só uns
  segundos.
- Logo depois, por volta dos 45s, o ícone `icon.png` pisca no canto superior direito
  por uns segundos, convidando o telespectador a apertar o botão VERMELHO.
- Quando o vídeo principal termina, o fundo e a música param junto e o programa encerra.

## Interação
- Enquanto o ícone `icon.png` estiver na tela, se o telespectador apertar o botão
  VERMELHO: o ícone some, o vídeo principal `animGar.mp4` encolhe pra uma janelinha no
  canto superior esquerdo (aí dá pra ver o `background.png` atrás), e começa a rodar o
  anúncio de tênis `shoes.mp4` na caixa de baixo à esquerda.
- Quando o anúncio `shoes.mp4` acaba, o vídeo principal volta a ocupar a tela inteira.
