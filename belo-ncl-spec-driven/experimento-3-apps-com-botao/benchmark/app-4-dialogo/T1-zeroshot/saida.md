# Saida (explicacao do NCL gerado)

## Imagens usadas (todas da propria pasta)
- `fundo.png` (1280x720) — tela do dialogo com a pergunta "Deseja assinar o Canal Belo?" e a dica de teclas.
- `btn-sim.png` (320x90) — botao verde "SIM".
- `btn-nao.png` (320x90) — botao vermelho "NAO".
- `tela-sim.png` (1280x720) — resultado "Assinatura confirmada!".
- `tela-nao.png` (1280x720) — resultado "Talvez depois".

## Layout (perfil EDTV, 1280x720)
- `rgFundo` e `rgTela`: tela cheia (0,0,1280,720).
- `rgBtnSim`: 320x90 em (280,380).
- `rgBtnNao`: 320x90 em (680,380).
- Os dois botoes ficam centralizados na faixa vazia do meio do fundo (o bloco SIM+NAO tem seu centro no centro horizontal da tela).

## Foco e navegacao
- Foco entre os botoes usa a navegacao nativa do Ginga por descritor:
  `dBtnSim.moveRight = idxNao` e `dBtnNao.moveLeft = idxSim`, ou seja, as setas ESQ/DIR
  alternam o foco entre SIM e NAO. O foco fica visivel por uma borda amarela
  (`focusBorderColor="yellow"`, `focusBorderWidth="6"`).
- **Foco inicial no SIM**: definido em `settings.service.currentFocus = idxSim`
  (valor default do no de settings) e reforcado por um link `onBegin(fundo) -> set(idxSim)`,
  que tambem devolve o foco ao SIM sempre que o dialogo reaparece.

## Interatividade (links declarativos)
Dois conectores cobrem todos os casos:
- `onBeginSet`: `onBegin -> set(service.currentFocus)` — posiciona o foco.
- `onSelStopStart`: `onSelection(tecla) -> par{ stop*, start* }` — reage a uma tecla parando
  objetos e iniciando outros (roles `stop`/`start` com `max="unbounded"`).

Fluxo:
1. Documento inicia com 3 ports: `fundo`, `btnSim`, `btnNao` sobem juntos. Foco no SIM.
2. **OK (ENTER) no SIM** -> para fundo+botoes e inicia `telaSim` ("Assinatura confirmada!").
3. **OK (ENTER) no NAO** -> para fundo+botoes e inicia `telaNao` ("Talvez depois").
4. Ao iniciar, cada tela de resultado recebe o foco
   (`onBegin(telaSim) -> set idxTelaSim`, idem tela-nao) para poder capturar a tecla colorida.
5. **VERMELHO (RED)** na tela de resultado -> para a tela e reinicia fundo+botoes;
   o `onBegin(fundo)` recoloca o foco no SIM. Volta ao estado inicial do dialogo.

## Observacoes
- Documento autocontido: usa apenas as 5 imagens da pasta, sem Lua e sem arquivos externos.
- As telas de resultado tem `focusBorderWidth="0"` para nao desenhar borda de foco visivel;
  o foco nelas serve so para o roteamento da tecla VERMELHO.
- Teclas conforme padrao Ginga/NCL: `ENTER` (OK), `RED` (VERMELHO); setas via `moveLeft`/`moveRight`.
