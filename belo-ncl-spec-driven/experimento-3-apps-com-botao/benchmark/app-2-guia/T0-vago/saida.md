# Saida (resposta / explicacao)

Criei um app NCL/Ginga de **guia de programacao** com **lista vertical de botoes**, usando somente as imagens desta pasta.

## Imagens da pasta (listadas antes de gerar)

| Arquivo | Tamanho | Uso |
|---|---|---|
| `fundo.png` | 1280x720 | Fundo/tela cheia, com o cabecalho `GUIA — HOJE NA TV (↑↓ navega • OK abre • VERMELHO volta)` |
| `item-1.png` | 520x70 | Botao da lista: `18h — Novela` (vinho) |
| `item-2.png` | 520x70 | Botao da lista: `19h — Jornal` (azul) |
| `item-3.png` | 520x70 | Botao da lista: `20h — Futebol` (verde) |
| `item-4.png` | 520x70 | Botao da lista: `22h — Filme` (marrom) |
| `item-5.png` | 520x70 | Botao da lista: `23h — Show` (roxo) |
| `tela-1.png` | 1280x720 | Detalhe de `18h — Novela` (`VERMELHO volta`) |
| `tela-2.png` | 1280x720 | Detalhe de `19h — Jornal` |
| `tela-3.png` | 1280x720 | Detalhe de `20h — Futebol` |
| `tela-4.png` | 1280x720 | Detalhe de `22h — Filme` |
| `tela-5.png` | 1280x720 | Detalhe de `23h — Show` |

Todas as 11 imagens sao usadas; nada externo foi referenciado.

## O que o app faz

1. Abre mostrando `fundo.png` (tela cheia) com os 5 botoes empilhados verticalmente e centralizados (regioes de 520x70 nas posicoes top 130/230/330/430/530).
2. **↑ / ↓ (CURSOR_UP / CURSOR_DOWN)**: navega pela lista. A navegacao circular (o item 5 volta pro 1 e vice-versa) e feita pelos atributos `focusIndex` + `moveUp`/`moveDown` dos descritores. O item focado ganha uma **borda amarela** (`focusBorderColor="yellow"` / `focusBorderWidth="5"`).
3. **OK (ENTER)**: abre a tela de detalhe correspondente (`tela-N.png`) por cima da lista (zIndex 5) e move o foco para a propria tela.
4. **VERMELHO (RED)**: fecha a tela de detalhe e devolve o foco pro item de origem, voltando pra lista.

## Como foi feito (decisoes tecnicas)

- **Perfil**: NCL 3.0 EDTV (`http://www.ncl.org.br/NCL3.0/EDTVProfile`).
- **Foco/navegacao**: usei o mecanismo nativo do Ginga — `service.currentFocus` no no `application/x-ginga-settings` + `focusIndex`/`moveUp`/`moveDown` nos descritores. Isso evita logica manual de navegacao.
  - Itens: `focusIndex` 1..5. Telas: `focusIndex` 11..15 (sem `moveUp`/`moveDown`, entao as setas nao fazem nada no detalhe).
- **Conectores causais** (definidos inline no `connectorBase`):
  - `cOnBeginSet`: no inicio grava o foco inicial (item 1).
  - `cOnOkStartSet`: `onSelection` (OK) → `start` da tela + `set` do foco para a tela.
  - `cOnKeyStopSet`: `onSelection` com `key="RED"` → `stop` da tela + `set` do foco de volta pro item.
- **Por que as telas sao focaveis**: o evento de selecao (incl. tecla colorida) so dispara no elemento focado; por isso, ao abrir, o foco vai pra tela, permitindo o RED funcionar nela.
- **Camadas**: lista continua rodando embaixo; a tela de detalhe (zIndex 5) cobre tudo, e como o foco fica na tela, as setas nao "vazam" pra lista escondida.

## Validacao

- O XML foi validado como **bem-formado** (`xml.dom.minidom`).
- Arquivo gerado: `gerado.ncl` (nesta pasta). Rodar no Ginga: `ginga gerado.ncl` (a partir desta pasta, para os `src` relativos resolverem).

## Observacoes / limites

- Coordenadas em pixels assumindo HD **1280x720** (resolucao das imagens); em outra resolucao o Ginga escala a base de regioes.
- Nao ha audio nem timers: a navegacao e 100% por controle remoto (setas, OK, VERMELHO), conforme o cabecalho da `fundo.png`.
