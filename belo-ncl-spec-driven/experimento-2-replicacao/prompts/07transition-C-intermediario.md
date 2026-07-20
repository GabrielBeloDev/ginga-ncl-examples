# Prompt INTERMEDIARIO — recriar o app (intenção com noção de espaço/tempo)

Faz um app de TV digital interativa em **NCL (perfil EDTV)**, num **documento único autocontido**, usando as mídias da pasta `media`. Segue o comportamento abaixo (posições e tempos são aproximados, capta a ideia):

## Layout (o que fica onde)
- `background.png` cobre a tela inteira, lá no fundo de tudo.
- `animGar.mp4` é o vídeo principal, também em tela cheia, por cima do fundo.
- Tem uma **janelinha no canto superior-esquerdo** onde aparecem, em momentos diferentes, o `drible.mp4` e depois a `photo.png`.
- Tem um **ícone pequeno no canto superior-direito**: o `icon.png`.
- Uma **área na parte de baixo, à esquerda** pro `shoes.mp4`.
- Um **painel grande do lado direito** pro formulário (`ptForm.htm` / `enForm.htm`).

## Linha do tempo
1. Começa tocando o `animGar.mp4` em tela cheia.
2. Uns 5 segundinhos depois, entra o `background.png` atrás e começa a música `choro.mp4` (só o som).
3. Lá pelos 12s, o `drible.mp4` toca naquela janelinha do canto superior-esquerdo, entrando com um **fade** suave e saindo com um efeito de **cortina (barWipe)**.
4. Mais pro fim (lá pelos 40s), a `photo.png` aparece uns instantes na mesma janelinha do canto.
5. Logo em seguida, o `icon.png` pisca no canto superior-direito por uns segundinhos.

## Interação
- Enquanto o `icon.png` está na tela, se o usuário apertar o botão **VERMELHO** do controle:
  - o `icon.png` some;
  - o vídeo principal **encolhe** para uma janelinha lá no canto superior-esquerdo (continua tocando, é o mesmo vídeo);
  - toca o `shoes.mp4` naquela área de baixo à esquerda;
  - abre o formulário no painel da direita — `enForm.htm` se o sistema estiver em inglês, senão o `ptForm.htm` (padrão em português).
- Depois de um tempo o formulário fecha sozinho e o vídeo principal **volta a ocupar a tela inteira**.

## Fim
- Quando o `animGar.mp4` acaba, a música `choro.mp4` e o `background.png` são cortados junto.
