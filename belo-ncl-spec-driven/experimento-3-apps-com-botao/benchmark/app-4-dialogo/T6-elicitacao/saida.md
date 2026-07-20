# Saída — Explicação do `gerado.ncl`

App NCL 3.0 **EDTV autocontido** de diálogo Sim/Não do "Canal Belo". Tudo (regiões, descritores, conectores causais e elos) está inline no próprio documento; usa **apenas** as 5 imagens da pasta, referenciadas pelo nome. Canvas **1280x720**.

## Fluxo implementado (exatamente o aprovado)
1. Abre em `fundo.png` (tela cheia) com os botões **SIM** (esquerda) e **NAO** (direita) no meio da tela.
2. Foco inicial no **SIM**, com **borda amarela espessura 4**.
3. **← / →** alternam o foco, de forma **circular** (SIM ↔ NAO).
4. **OK** no **SIM** → mostra `tela-sim.png` ("Assinatura confirmada!"); **OK** no **NAO** → mostra `tela-nao.png` ("Talvez depois."). O diálogo (fundo + botões) **some** e o resultado ocupa a **tela inteira**.
5. Nas telas de resultado, a tecla **VERMELHA** volta ao diálogo inicial, com o **foco restaurado no SIM**.
6. Na tela inicial o VERMELHO **não faz nada** (não há elo para isso).

## Como cada regra do spec-kit foi atendida
- **Perfil/namespace:** `xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`.
- **Aparecer no início = ter `<port>`:** portas para `fundo`, `settings`, `btnSim` e `btnNao` no `<body>`.
- **Botão navegável:** cada botão é uma `<media>` cujo descritor tem `focusIndex` e `moveLeft`/`moveRight` apontando o vizinho (circular), com `focusBorderColor="yellow"` e `focusBorderWidth="4"`.
  - `dSim`: `focusIndex="1"`, `moveLeft/moveRight="2"` (vai pro NAO).
  - `dNao`: `focusIndex="2"`, `moveLeft/moveRight="1"` (vai pro SIM).
  - `moveUp/moveDown` apontam pra si mesmos (só ← → movem o foco, como pedido).
- **Foco inicial:** `<media type="application/x-ginga-settings">` com `<property name="service.currentFocus" value="1"/>` (e port). Valor `1` = botão SIM.
- **OK (seleção):** conector `cOKMostra` com `<simpleCondition role="onSelection"/>` → ação composta `stop` (fundo + os 2 botões) + `start` (tela de resultado) + `set` (move o foco pra tela de resultado, pra ela receber o VERMELHO).
- **Tecla VERMELHA (voltar):** conector `cVoltaVermelho` com `<connectorParam name="tecla"/>` + `<simpleCondition role="onSelection" key="$tecla"/>` → `stop` (tela de resultado) + `start` (fundo + botões) + `set` (foco de volta pro SIM). Nos binds: `<bindParam name="tecla" value="RED"/>`.
- **Transparência:** não foi usada (não havia necessidade).
- **Só imagens da pasta:** `fundo.png`, `btn-sim.png`, `btn-nao.png`, `tela-sim.png`, `tela-nao.png`.

## Layout dos botões (coordenadas)
Botões de **260x64 px**, lado a lado, centralizados: espaço de 40 px entre eles, largura total 560 px, margem 360 px de cada lado.
- `rgSim`: `left=360 top=360 width=260 height=64`
- `rgNao`: `left=660 top=360 width=260 height=64`
- Ambos com `zIndex=1` (sobre o fundo). Telas de resultado em `rgResultado` (tela cheia, `zIndex=2`).

## Detalhe técnico do "voltar"
Para o `onSelection key="RED"` disparar numa tela de resultado, ela precisa estar em foco. Por isso `dTelaSim`/`dTelaNao` têm `focusIndex` (3 e 4) e, ao serem exibidas, o elo do OK também faz `set service.currentFocus` pra elas. O elo do VERMELHO devolve o foco pro SIM (`value="1"`) ao reabrir o diálogo. As telas de resultado usam `focusBorderWidth="0"` pra não mostrar borda de foco.

## Validação
Documento validado como **XML bem-formado**. Estrutura: 5 regiões, 5 descritores, 2 conectores causais, 6 mídias, 4 portas, 4 elos.

Arquivo gerado: `gerado.ncl` (nesta pasta).
