# Saida (resposta e explicacao)

Criei um app Ginga-NCL 3.0 (perfil EDTVProfile) de **dialogo de decisao Sim/Nao com botoes**,
usando **apenas** as 5 imagens desta pasta. Arquivo gerado: `gerado.ncl`.

## O que o app faz

1. Abre mostrando `fundo.png` (pergunta "Deseja assinar o Canal Belo?" + a dica de teclas)
   com os dois botoes por cima: `btn-sim.png` (SIM) a esquerda e `btn-nao.png` (NAO) a direita.
2. O foco comeca no botao **SIM** (borda amarela). As **setas esquerda/direita** movem o foco
   entre SIM e NAO (navegacao nativa do Ginga via `moveLeft`/`moveRight`).
3. **OK/ENTER** confirma o botao focado:
   - SIM  -> some o dialogo e mostra `tela-sim.png` ("Assinatura confirmada!")
   - NAO  -> some o dialogo e mostra `tela-nao.png` ("Talvez depois.")
4. Na tela de resultado, a tecla **VERMELHO (RED)** volta para o dialogo inicial
   (reinicia fundo + botoes e devolve o foco ao SIM).

Isso corresponde exatamente a dica que aparece no proprio fundo:
`(<- ->  escolhe | OK confirma | VERMELHO volta)`.

## Como foi construido (mapeando o pedido vago -> NCL)

- **Regioes** (`regionBase`): duas telas cheias em `100%` (fundo/dialogo em zIndex 0 e
  resultado em zIndex 10, por cima) e duas regioes de botao em percentual, centralizadas
  e simetricas (SIM em `left 20%`, NAO em `left 55%`, ambos `25% x 12.5%`, `top 47%`).
  Usei percentuais para o layout escalar em qualquer tela 16:9 mantendo a proporcao
  dos botoes (320x90).
- **Descritores** (`descriptorBase`): `focusIndex` 1 (SIM) e 2 (NAO) com
  `moveLeft`/`moveRight` para a navegacao, e `focusBorderColor="yellow"` para destacar o foco.
  As telas de resultado tem `focusIndex` 3 e 4 para poderem captar a tecla VERMELHO.
- **Conectores** (`connectorBase`):
  - `onBeginSet` (onBegin -> set) para posicionar o foco quando cada tela aparece;
  - `onSelectionStopStart` (OK -> para varios objetos e inicia outro) para confirmar;
  - `onKeySelectionStopStart` (onSelection com `key="RED"` -> para e reinicia) para o "voltar".
- **Foco inicial e transicoes de foco** via `service.currentFocus` no no de
  `application/x-ginga-settings` (foco 1 no inicio, foco 3/4 ao abrir cada resultado).
- **Portas** iniciam simultaneamente `fundo`, `botaoSim` e `botaoNao`.

## Imagens usadas (todas locais, nada externo)

`fundo.png`, `btn-sim.png`, `btn-nao.png`, `tela-sim.png`, `tela-nao.png`.

## Verificacao

- XML validado como **bem-formado** (`python3 -m xml.dom.minidom` fez o parse sem erros).
- Sem dependencias externas: todos os `src` apontam para arquivos desta pasta.

## Observacoes / decisoes

- Como o pedido era vago, adotei o mesmo esquema de teclas ja impresso no `fundo.png`
  (setas escolhem, OK confirma, VERMELHO volta) para o app ficar coerente com a arte.
- Dei `focusIndex` as telas de resultado (e foco explicito ao abri-las) para garantir a
  captura da tecla VERMELHO em diferentes implementacoes do Ginga.
- Codificado em UTF-8; comentarios sem acento para evitar qualquer problema de codificacao no player.
