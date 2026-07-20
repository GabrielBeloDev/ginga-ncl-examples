# Saida — explicacao do `gerado.ncl`

App NCL 3.0 perfil EDTV, **autocontido** (regioes, descritores, conectores causais e elos inline),
referenciando **apenas** as imagens da pasta pelo nome. Implementa exatamente o que foi confirmado
na elicitacao — nada alem disso.

## Grade 3 colunas x 2 linhas (paisagem), centralizada
Canvas 1280x720 (mesmo tamanho do `fundo.png`). Botoes de 340x170 posicionados com
margens/gaps automaticos para ficar centralizado abaixo do cabecalho:

```
colunas x = 90, 470, 850   (gap 40, margem lateral 90 dos dois lados)
linhas  y = 200, 440       (gap 70, folga ~115 em cima e embaixo)

        1 VIDEO    2 MUSICA   3 FOTOS      (app-1  app-2  app-3)
        4 JOGOS    5 LOJA     6 CONFIG     (app-4  app-5  app-6)
```

`fundo.png` ocupa a tela toda em `regFundo` (zIndex 0); os botoes ficam por cima (zIndex 1);
as telas de detalhe abrem em `regTela` fullscreen (zIndex 2), cobrindo a grade.

## Aparecer no inicio
Todo componente inicial tem `<port>`: `fundo`, os 6 botoes `app-1..app-6` e o no de `ajustes`
(settings). As telas `tela-1..tela-6` **nao** tem port — so aparecem quando o OK as inicia.

## Botoes navegaveis (setas, circular)
Cada botao e uma `<media>` com descritor contendo `focusIndex` e `moveLeft/moveRight/moveUp/moveDown`,
mais `focusBorderColor="yellow"` e `focusBorderWidth="4"` para destacar o foco. Mapa (circular):

| foco | botao  | left | right | up | down |
|------|--------|------|-------|----|------|
| 1    | VIDEO  | 3    | 2     | 4  | 4    |
| 2    | MUSICA | 1    | 3     | 5  | 5    |
| 3    | FOTOS  | 2    | 1     | 6  | 6    |
| 4    | JOGOS  | 6    | 5     | 1  | 1    |
| 5    | LOJA   | 4    | 6     | 2  | 2    |
| 6    | CONFIG | 5    | 4     | 3  | 3    |

Horizontal circular dentro da linha (da ultima coluna volta pra primeira); vertical circular dentro
da coluna (como so ha 2 linhas, cima e baixo levam sempre a outra linha).

## Foco inicial
`<media type="application/x-ginga-settings">` (id `ajustes`) com
`<property name="service.currentFocus" value="1"/>` e port — foco comeca no VIDEO (app-1).

## OK (selecao) abre a tela de detalhe
Conector `cSelectOpen`: `onSelection` (OK) -> acao composta `start` + `set`. Cada elo liga
`app-N` a `start tela-N` **e** move o foco para o `focusIndex` da tela (11..16). Mover o foco para
a tela e o que permite a tecla VERMELHA valer ali (o `onSelection key=RED` so dispara no no focado).
As telas usam `focusBorderWidth="0"` (sem borda). Mapeamento 1:1: app-1->tela-1 ... app-6->tela-6.

## VERMELHA (RED) volta e devolve o foco
Conector `cRedBack`: `<connectorParam name="tecla"/>` + `<simpleCondition role="onSelection" key="$tecla"/>`
-> acao composta `stop` + `set`. No `<bind>`, `<bindParam name="tecla" value="RED"/>`. Cada elo para a
`tela-N` e devolve o foco ao botao que a abriu (`service.currentFocus` = N). Assim, ao voltar, o foco
retorna ao botao de origem (item 13).

## RED na grade nao faz nada (item 14)
As condicoes de RED estao **so** nas telas (`onSelection` na `tela-N`). Os botoes so respondem ao OK
(`onSelection` sem key). Logo, com a grade aberta e nenhum detalhe na tela, o VERMELHO nao tem efeito.

## Notas tecnicas
- Perfil EDTV (`xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"`).
- Sem `transparency` (nao foi pedida); se fosse usada, iria como `<descriptorParam>`, nunca atributo do descritor.
- XML validado como bem-formado; todas as 13 imagens referenciadas existem na pasta e nenhuma imagem externa e usada.
- Arquivo de saida: `gerado.ncl` na propria `pasta-de-trabalho`.
