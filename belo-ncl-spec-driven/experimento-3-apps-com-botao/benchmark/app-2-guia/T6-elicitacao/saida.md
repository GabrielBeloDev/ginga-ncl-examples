# Saída — Explicação do `gerado.ncl`

App NCL 3.0 perfil EDTV, **autocontido** (regiões, descritores, conectores causais e elos todos inline) e gerado **só a partir das respostas** confirmadas na elicitação. Usa **apenas** as imagens da pasta.

## Estrutura geral
- **`<ncl>`** com `xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`.
- **`<head>`**: `regionBase`, `descriptorBase`, `connectorBase`.
- **`<body>`**: portas, mídias e elos.

## Layout (1280×720)
- `rgTela` é a região raiz 1280×720; as demais são filhas.
- `rgFundo` (0,0,1280×720, `zIndex=0`) — fundo com o cabeçalho, sempre atrás.
- `rgItem1..5` — coluna à esquerda (`left=60`), abaixo do cabeçalho, começando em `top=110` e empilhados de 80 em 80 (item de 70px + gap de 10px): 110, 190, 270, 350, 430. Cada região é **520×70**, o tamanho nativo de `item-N.png`, então **mantém a proporção** sem distorcer. `zIndex=1`.
- `rgDetalhe` (0,0,1280×720, `zIndex=5`) — tela de detalhe em **tela cheia por cima de tudo**. As 5 telas compartilham essa região (só uma abre por vez).

## Botões navegáveis (o que a spec pede)
Cada botão é uma `<media>` (`item1..item5`) apontando `item-N.png`, com um descritor que tem:
- `focusIndex="N"`;
- `moveUp` / `moveDown` **circulares** — item1: up→5/down→2; item2: up→1/down→3; …; item5: up→4/down→1;
- **sem** `moveLeft`/`moveRight` (←/→ ignoradas, conforme resposta 3.3);
- `focusBorderColor="yellow"` e `focusBorderWidth="4"` pra destacar o foco.

## Foco inicial
`<media id="cfg" type="application/x-ginga-settings">` com `<property name="service.currentFocus" value="1"/>` — foco começa no item 1 (18h Novela). Tem porta (`pCfg`) pra ser ativada.

## Portas (aparece no início ⇒ precisa de port)
- `entry` → `fundo` (componente de entrada);
- `pCfg` → `cfg` (foco inicial);
- `pItem1..pItem5` → botões da lista.
As telas de detalhe **não** têm porta (só entram via OK).

## OK (seleção) — abrir detalhe
Conector `cSelecao`: `simpleCondition role="onSelection"` → `simpleAction role="start"`.
Um elo por item liga `onSelection` do botão ao `start` da tela correspondente (item-N → tela-N). Como `rgDetalhe` tem `zIndex=5`, a tela cheia cobre a lista e o fundo.

## VERMELHO (RED) — voltar
Conector `cVoltar`: `connectorParam name="tecla"` + `simpleCondition role="onSelection" key="$tecla"` → `simpleAction role="stop"`, com `<bindParam name="tecla" value="RED"/>` no `<bind>`.

Detalhe importante do design: tanto o OK quanto o RED estão vinculados ao **próprio botão da lista** (`item-N`), que permanece o elemento em foco. Assim:
- **O foco nunca sai do item** — quando a tela fecha, a lista reaparece com o mesmo item selecionado (atende 5.2).
- RED só tem efeito enquanto o detalhe correspondente está aberto; parar uma tela já parada é no-op, então **na lista o VERMELHO não faz nada** (atende 5.3).
- Garante **uma única tela por vez**: como o foco fica no item, você só consegue abrir/fechar a tela daquele item.

## Extras
Sem áudio e sem transparência (respostas 6.1/6.2). Nenhuma imagem além das da pasta foi usada.

## Validação
XML checado como bem-formado (`xml.dom.minidom`). Arquivo salvo em `gerado.ncl` na própria pasta-de-trabalho.
