# Prompt de intenção — nível INTERMEDIÁRIO

Quero um app Ginga-NCL (perfil EDTV), num único documento autocontido, tema futebol, usando as mídias da pasta.

**Base:** o vídeo `animGar.mp4` roda em tela cheia e é o fio da meada — quase tudo acontece em cima da linha do tempo dele. Uns 5 segundinhos depois de ele começar, entram juntos a música `choro.mp4` (só o som, sem imagem) e uma imagem de fundo `background.png`, que fica atrás de tudo, na camada mais debaixo.

**Durante o vídeo:**
- Lá pelos 12s aparece um clipe de drible (`drible.mp4`) num quadradinho no canto superior esquerdo, entrando com um fade suave e saindo com um efeito de wipe.
- Mais pra frente (lá pelos 40s) aparece uma foto (`photo.png`) meio transparente no mesmo cantinho de cima à esquerda, e ela desliza pra baixo enquanto fica na tela por poucos segundos.
- Logo em seguida pisca um ícone (`icon.png`) no canto superior direito por uns segundos, convidando o usuário a apertar o botão VERMELHO.

**Interação (botão VERMELHO):** enquanto o ícone está na tela, se apertar VERMELHO:
- o ícone some;
- o vídeo principal encolhe pra um quadrado no canto superior esquerdo (aí aparece o fundo `background.png` atrás dele);
- toca o vídeo `shoes.mp4` embaixo, à esquerda;
- abre um formulário de compra ocupando o lado direito da tela, que ganha o foco e fica um tempo aberto — em português (`ptForm.htm`) por padrão, ou em inglês (`enForm.htm`) se o sistema estiver em inglês.

**Fechamento:**
- Quando o formulário termina, o vídeo principal volta a crescer e preencher a tela.
- Quando o vídeo principal acaba, para a música e o fundo.
