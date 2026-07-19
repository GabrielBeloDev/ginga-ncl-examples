# Prompt DETALHADO (spec) — recriar o app

Gere **um único documento NCL autocontido, perfil EDTV** (`http://www.ncl.org.br/NCL3.0/EDTVProfile`), usando exclusivamente as mídias da pasta `media`. O documento deve definir por conta própria todas as relações causais necessárias (não depender de nenhum arquivo externo). Reproduza exatamente o comportamento de espaço, tempo e interação especificado abaixo.

## Mídias usadas
- `background.png` — imagem de fundo
- `animGar.mp4` — vídeo principal
- `choro.mp4` — trilha (usado só como áudio, sem área na tela)
- `drible.mp4` — clipe curto
- `photo.png` — foto
- `icon.png` — ícone/chamada da propaganda
- `shoes.mp4` — vídeo do produto
- `ptForm.htm` — formulário em português (padrão)
- `enForm.htm` — formulário em inglês

## Layout (coordenadas em % da tela; camadas do fundo pro topo)
- **Fundo** (camada 1): `background.png` em `left=0`, `top=0`, `width=100%`, `height=100%`.
- **Tela principal** (camada 2): `animGar.mp4` em `0,0,100%,100%` (tela cheia).
- **Janela canto sup-esquerdo** (camada 3): `left=5%`, `top=6.7%`, `width=18.5%`, `height=18.5%`. Recebe `drible.mp4` e depois `photo.png`.
- **Ícone canto sup-direito** (camada 3): `left=87.5%`, `top=11.7%`, `width=8.45%`, `height=6.7%`. Recebe `icon.png`.
- **Área inferior-esquerda** (camada 3): `left=15%`, `top=60%`, `width=25%`, `height=25%`. Recebe `shoes.mp4`.
- **Painel direito / formulário** (camada 3): `left=57.25%`, `top=9.83%`, `width=37.75%`, `height=70.2%`. Recebe o formulário; deve ser focável (focusIndex 1).

## Transições
- **Fade** de 2s (entrada).
- **BarWipe** de 1s (saída).

## Linha do tempo (todos os tempos relativos ao início do `animGar.mp4`)
1. **t = 0s**: ponto de entrada do documento inicia o `animGar.mp4` em tela cheia.
2. **t = 5s**: com atraso (delay) de 5s a partir do início do vídeo, iniciam **em paralelo** o `background.png` (fundo) e o `choro.mp4` (áudio).
3. **t = 12s**: ao atingir a marca de 12s do `animGar.mp4`, inicia o `drible.mp4` na janela do canto sup-esquerdo, com **transição de entrada fade (2s)** e **transição de saída barWipe (1s)**.
4. **t = 41s**: ao atingir 41s do vídeo, inicia a `photo.png` na mesma janela do canto sup-esquerdo, com **duração explícita de 5s**.
5. **t = 45s–51s**: no trecho de 45s a 51s do vídeo, inicia o `icon.png` no canto sup-direito, com **duração explícita de 6s**.

## Interação (tecla)
- Enquanto o `icon.png` está sendo exibido, ao pressionar a tecla **VERMELHO (RED)**, executar em sequência:
  1. **parar** o `icon.png`;
  2. **redimensionar** o vídeo principal (a MESMA instância em execução do `animGar.mp4`, não uma nova) para os limites `left=5%`, `top=6.67%`, `width=45%`, `height=45%` (encolhe pro canto sup-esquerdo, continuando a tocar);
  3. **iniciar em paralelo** o `shoes.mp4` na área inferior-esquerda e o **formulário** no painel direito, com **duração explícita de 15s**. O formulário é selecionado por idioma do sistema: `enForm.htm` se `system.language = eng`, caso contrário `ptForm.htm` (componente padrão).
- **Ao fim do formulário** (após 15s): **redimensionar** o vídeo principal de volta para os limites `0,0,222.22%,222.22%`, restaurando a tela cheia.

## Encerramento
- **Ao fim do `animGar.mp4`**: **parar em paralelo** o `background.png` e o `choro.mp4`.

## Observações
- O vídeo principal e sua versão "encolhida" na propaganda são **a mesma instância** em execução (reaproveitada), para que ao apertar VERMELHO ele apenas mude de tamanho sem reiniciar.
- As marcas 12s, 41s e 45s–51s são âncoras/segmentos internos do próprio `animGar.mp4`.
