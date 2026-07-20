# Saída — Diálogo "Canal Belo" (NCL EDTV)

Gerei `gerado.ncl`, um documento NCL 3.0 (perfil EDTV) autocontido que reproduz o app de diálogo de assinatura.

## Imagens usadas (todas da própria pasta)
- `fundo.png` — fundo com a pergunta "Deseja assinar o Canal Belo?"
- `btn-sim.png` — botão SIM
- `btn-nao.png` — botão NÃO
- `tela-sim.png` — tela "Assinatura confirmada!"
- `tela-nao.png` — tela "Talvez depois"

## Estrutura do documento

### Regiões (`regionBase`)
- `rBg` (zIndex 0): fundo em tela cheia.
- `rTela` (zIndex 5): telas de resposta em tela cheia, por cima de tudo.
- `rSim` (left 20%, top 80%, 25%x12%): botão SIM, embaixo à esquerda.
- `rNao` (left 55%, top 80%, 25%x12%): botão NÃO, embaixo à direita.

### Descritores (`descriptorBase`)
- `dSim` → `focusIndex=1`, com `moveRight`/`moveLeft` = 2 (leva o foco pro NÃO).
- `dNao` → `focusIndex=2`, com `moveRight`/`moveLeft` = 1 (leva o foco pro SIM).
- Ambos com borda de foco amarela (`focusBorderColor="yellow"`, `focusBorderWidth="4"`).
- As setas ESQ/DIR alternam o foco entre os dois botões (navegação circular).

### Foco inicial
- A mídia `cfg` (`application/x-ginga-settings`) define `service.currentFocus = 1`, ou seja, **o foco começa no SIM**, conforme pedido.

### Conectores (`connectorBase`)
- `cSel`: `onSelection` (tecla OK sobre o item focado) → `start`. Usado para abrir a tela do botão.
- `cKey`: `onSelection` com `key="$tecla"` → `stop`. Usado para a tecla VERMELHA (RED) fechar a tela e voltar ao diálogo.

### Elos (`link`)
1. OK no SIM → `start` de `tela-sim.png` ("Assinatura confirmada!").
2. OK no NÃO → `start` de `tela-nao.png` ("Talvez depois").
3. VERMELHO (RED) na tela SIM → `stop` da tela SIM (volta ao diálogo).
4. VERMELHO (RED) na tela NÃO → `stop` da tela NÃO (volta ao diálogo).

## Fluxo de uso
1. Abre com fundo + botões SIM/NÃO; foco no SIM (borda amarela).
2. Setas ESQ/DIR movem o foco entre SIM e NÃO.
3. OK confirma: SIM abre "Assinatura confirmada!"; NÃO abre "Talvez depois" (a tela cobre a interface, zIndex 5).
4. Tecla VERMELHA fecha a tela de resposta e retorna ao diálogo, com os botões ainda ativos.

Segue o mesmo estilo do exemplo de referência, adaptado para os nomes de arquivo e o caso específico (SIM/NÃO, foco inicial no SIM).
