# Elicitação — App NCL "Diálogo de decisão Sim/Não" (Canal Belo)

Pedido do usuário (vago): *"quero um app NCL de diálogo de decisão Sim/Não com botões, com as imagens dessa pasta"*.

Antes de gerar o NCL, preciso confirmar alguns pontos. Já dei uma olhada nas imagens e elas sugerem um fluxo — marquei minha **suposição (default)** em cada pergunta. Se estiver tudo certo, é só dizer "pode usar os defaults" que eu sigo.

## Imagens encontradas na pasta
- `fundo.png` — tela de fundo: header "CANAL BELO", pergunta "Deseja assinar o Canal Belo?" e a dica no rodapé "(← → escolhe • OK confirma • VERMELHO volta)".
- `btn-sim.png` — botão verde "SIM".
- `btn-nao.png` — botão vermelho "NAO".
- `tela-sim.png` — tela verde "Assinatura confirmada! (VERMELHO volta)".
- `tela-nao.png` — tela vermelha "Talvez depois. (VERMELHO volta)".

> Regra: uso **só** essas imagens, referenciando pelo nome. Confirme se posso usar todas ou se alguma deve ficar de fora.

---

## 1. Botões: quais e quantos
1.1. Confirma que são **2 botões**: SIM (`btn-sim.png`) e NAO (`btn-nao.png`)? Ou quer mais alguma opção?
1.2. A ordem na tela é **SIM à esquerda / NAO à direita** (default)? Ou invertido?

## 2. Layout / posição e tamanho dos botões
2.1. Onde ficam os botões sobre o `fundo.png`? Default meu: **centralizados horizontalmente, lado a lado, na metade da tela** (a pergunta fica em cima e a dica embaixo, então sobra o meio). Serve, ou prefere posição/coordenadas específicas?
2.2. Tamanho de cada botão: default **~260x64 px** cada, com um espaço entre eles. Ok ou quer outro tamanho?
2.3. A dica de navegação já está **desenhada dentro do `fundo.png`** — confirmo que não preciso criar texto extra pra isso (uso a imagem como está)?

## 3. Navegação e foco
3.1. Navegação entre botões com as **setas ESQUERDA/DIREITA** (default, bate com a dica "← → escolhe")? Ou quer CIMA/BAIXO também?
3.2. Navegação **circular** (do NAO com seta direita volta pro SIM e vice-versa)? Default: **sim, circular**.
3.3. Foco inicial no **SIM** (default) ou no NAO?
3.4. Destaque do foco: borda **amarela, espessura 4** (conforme regra). Mantém ou quer outra cor/espessura?

## 4. O que o OK (seleção) faz
4.1. Confirma o mapeamento: **OK no SIM → mostra `tela-sim.png`** ("Assinatura confirmada!") e **OK no NAO → mostra `tela-nao.png`** ("Talvez depois.")?
4.2. Ao mostrar a tela de resultado, o **diálogo (fundo + botões) some** e fica só a tela de resultado ocupando a tela inteira (default)? Ou os botões continuam visíveis por cima?

## 5. Voltar (tecla VERMELHA)
5.1. Nas telas de resultado (`tela-sim`/`tela-nao`), a tecla **VERMELHA volta pro diálogo inicial** (fundo + botões, com foco restaurado)? Default: **sim**.
5.2. Na tela **inicial do diálogo**, a tecla VERMELHA faz algo (ex.: encerrar/sair do app) ou **não faz nada** (default)?

## 6. Detalhes técnicos do documento
6.1. Perfil **NCL 3.0 EDTV** e documento **autocontido** (regiões, descritores, conectores e elos inline), conforme as regras. Confirmado?
6.2. Resolução alvo do canvas: **1280x720 (720p)** — que é o tamanho das imagens (default). Ok?
6.3. Nome do arquivo `.ncl` de saída: default **`main.ncl`** na própria `pasta-de-trabalho/`. Prefere outro nome/local?

---

**Resumo dos defaults (fluxo que vou seguir se você aprovar):**
Abre no `fundo.png` com SIM e NAO no centro, foco inicial no SIM (borda amarela). ← → alternam o foco (circular). OK no SIM abre `tela-sim.png`; OK no NAO abre `tela-nao.png` (tela cheia, diálogo some). Nas telas de resultado, VERMELHO volta pro diálogo. Documento NCL 3.0 EDTV autocontido, 1280x720, saída `main.ncl`.
