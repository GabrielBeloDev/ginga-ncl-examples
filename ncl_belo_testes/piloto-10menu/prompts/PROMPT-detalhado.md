# Prompt para gerar o NCL (cole isto no Claude Code aberto na pasta `sets/`)

> Gere **um único documento NCL** (Nested Context Language, perfil **NCL 3.0 EDTVProfile**,
> `xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`), **autocontido** (com regiões, descritores,
> conectores causais e elos definidos no próprio arquivo — não importe bases externas), que use as
> **mídias presentes nesta pasta** para reproduzir a aplicação interativa de TV Digital descrita
> abaixo. Salve como `app.ncl`. As mídias estão no mesmo diretório do `.ncl` (referencie pelo nome do
> arquivo, sem subpasta). Responda só com o arquivo `.ncl`.

---

## Visão geral

Uma aplicação interativa de TV Digital construída em torno de um **vídeo de desenho do Garrincha**
(`animGar.mp4`). Enquanto o vídeo toca em tela quase cheia, o telespectador pode: **escolher a trilha
sonora** num menu na base da tela (4 gêneros), **ligar/desligar um indicador de interatividade**, e
**abrir uma propaganda** (a "Chuteira do João") com um formulário. Ao longo do vídeo, sobreposições
temporizadas (um clipe de drible e uma foto) aparecem sobre a imagem.

## Mídias desta pasta e seu papel

- `animGar.mp4` — **vídeo principal** (desenho do Garrincha). É o ponto de entrada; dura ~64 s ou mais.
- `background.png` — **imagem de fundo** atrás de tudo (entra 5 s após o vídeo começar).
- `choro.mp4` — **trilha sonora padrão** (áudio; gênero "chorinho").
- `rock.mp4`, `techno.mp4`, `cartoon.mp4` — **trilhas sonoras alternativas** (áudio).
- `chorinho.png`, `rock.png`, `techno.png`, `cartoon.png` — **rótulos dos 4 botões** do menu (base da tela).
- `drible.mp4` — **clipe curto de drible**, sobreposto num quadradinho no canto superior esquerdo.
- `photo.png` — **foto** sobreposta no mesmo quadradinho, semitransparente, que desliza para baixo.
- `icon.png` — **ícone de propaganda** (canto superior direito), aparece por volta de 45–51 s.
- `shoes.mp4` — **vídeo do produto** (a chuteira) que toca na propaganda, na parte inferior esquerda.
- `ptForm.htm` / `enForm.htm` — **formulário do produto** em HTML (PT por padrão; EN se o idioma do
  sistema for inglês).
- `intOn.png` / `intOff.png` — **indicador de interatividade** ligado/desligado (canto inferior direito).

## Layout (tela = 100% × 100%)

- **Fundo** (`background.png`): tela inteira (100%×100%), atrás de tudo.
- **Vídeo principal** (`animGar.mp4`): topo, largura total, **88%** de altura.
- **Quadradinho** (drible/foto): canto superior esquerdo — esquerda **5%**, topo **6,7%**, **18,5%×18,5%**.
- **Ícone de propaganda** (`icon.png`): canto superior direito — esquerda **87,5%**, topo **11,7%**, **~8,5%×6,7%**.
- **Vídeo da chuteira** (`shoes.mp4`): inferior esquerdo — esquerda **15%**, topo **60%**, **25%×25%**.
- **Formulário** (HTML): painel à direita — esquerda **57,25%**, topo **9,83%**, **37,75%×70,2%**.
- **Indicador de interatividade** (`intOn/intOff.png`): canto inferior direito — esquerda **92,5%**, topo **91,7%**, **~5%×6,5%**.
- **Menu de trilhas** (4 botões na base, topo **91,7%**, cada um **~11,7%×6,5%**):
  `chorinho.png` em esquerda **2,5%** · `rock.png` em **25%** · `techno.png` em **47,5%** · `cartoon.png` em **70%**.

## Linha do tempo (relativa ao início do vídeo)

- **0 s** — o vídeo principal inicia (ponto de entrada da aplicação).
- **+5 s** — entram a **imagem de fundo** e o **menu** (os 4 botões + a trilha padrão `choro.mp4` tocando).
- **12 s** — o **clipe de drible** aparece no quadradinho (entra com **fade de 2 s**, sai com **wipe de 1 s**).
- **41 s** — a **foto** aparece no quadradinho por **5 s**, **semitransparente (~60%)**, e **desliza para
  baixo** (a posição do topo é animada) ao longo de **3 s**, começando **1 s** depois de aparecer.
- **45–51 s** — o **ícone de propaganda** aparece no canto superior direito por **~6 s**, **mas só quando a
  interatividade estiver LIGADA**.
- **~64 s** — o menu é encerrado (créditos do vídeo).
- **fim do vídeo** — o fundo e a interatividade são encerrados.

## Interações (teclas do controle remoto)

- **Indicador de interatividade:** ao iniciar o vídeo, mostra o ícone "ligado" (`intOn.png`) no canto
  inferior direito e o estado de interatividade começa **LIGADO**. A tecla **INFO** alterna entre
  ligado/desligado (troca `intOn`↔`intOff` e o estado correspondente).
- **Menu de trilhas (base da tela):** os 4 botões (Chorinho, Rock, Techno, Cartoon) são **navegáveis com
  as setas esquerda/direita** (o foco circula entre eles). Ao **selecionar (OK)** um botão:
  - **Chorinho** → volta a trilha padrão (`choro.mp4`) em **volume cheio** e para a trilha alternativa.
  - **Rock / Techno / Cartoon** → **muta** a trilha padrão (volume 0) e toca a **trilha alternativa
    correspondente** (`rock.mp4` / `techno.mp4` / `cartoon.mp4`), conforme o botão em foco.
- **Propaganda:** enquanto o **ícone de propaganda** (canto superior direito) estiver visível, a tecla
  **VERMELHA (RED)** abre a propaganda: o **vídeo da chuteira** (`shoes.mp4`) toca no inferior esquerdo, o
  **formulário** (HTML, PT ou EN conforme o idioma) aparece no painel à direita, e o **vídeo principal
  encolhe** para um quadro menor (picture-in-picture) no topo-esquerdo. Quando o formulário termina
  (~15 s), o vídeo principal **volta a ocupar a tela inteira**.
- **Idioma:** o formulário é exibido em **português por padrão**, ou em **inglês** se o idioma do sistema
  for inglês.

---

*Objetivo do exercício: o NCL gerado a partir desta descrição de intenção deve reproduzir a aplicação
original. Gere o código completo e funcional.*
