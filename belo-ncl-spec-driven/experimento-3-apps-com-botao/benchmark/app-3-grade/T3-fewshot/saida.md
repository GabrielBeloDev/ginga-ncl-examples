# Saida (resposta/explicacao)

Gerei o documento `gerado.ncl` (perfil EDTV / NCL 3.0), autocontido, usando somente as imagens da pasta: `fundo.png`, `app-1.png`..`app-6.png` e `tela-1.png`..`tela-6.png`. XML validado como bem-formado.

## Layout da grade (2 linhas x 3 colunas)

```
        col1 (8%)     col2 (38%)    col3 (68%)
linha1  VIDEO  a1     MUSICA a2     FOTOS  a3     (top 28%)
linha2  JOGOS  a4     LOJA   a5     CONFIG a6     (top 58%)
```

Cada celula: `width=24%`, `height=22%`, `zIndex=2`. Fundo em `zIndex=0`, telas cheias em `zIndex=5` (ficam por cima da grade).

## Foco e navegacao (focusIndex 1..6)

`service.currentFocus=1` => foco inicial no primeiro app (VIDEO). Setas nos descritores:

| App | focusIndex | moveLeft | moveRight | moveUp | moveDown |
|-----|-----------|----------|-----------|--------|----------|
| VIDEO  a1 | 1 | 3 | 2 | 4 | 4 |
| MUSICA a2 | 2 | 1 | 3 | 5 | 5 |
| FOTOS  a3 | 3 | 2 | 1 | 6 | 6 |
| JOGOS  a4 | 4 | 6 | 5 | 1 | 1 |
| LOJA   a5 | 5 | 4 | 6 | 2 | 2 |
| CONFIG a6 | 6 | 5 | 4 | 3 | 3 |

- Esquerda/direita: circulam dentro da linha (wrap: da col1 vai pra col3 e vice-versa).
- Cima/baixo: como so ha 2 linhas, ambas alternam para a outra linha na mesma coluna (CIMA e BAIXO levam ao par vertical). Ex.: em VIDEO (linha1,col1), tanto CIMA quanto BAIXO vao pra JOGOS (foco 4).

Borda de foco amarela (`focusBorderColor="yellow"`, `focusBorderWidth="4"`).

## Interacao

- OK (selecao): conector `cSel` com `onSelection -> start`. Um link por app: selecionar `aN` inicia a media `tN` (tela cheia sobre a grade).
- VERMELHO (voltar): conector `cKey` parametrizado com `key="$tecla"` (RED). Um link por tela: com a tela `tN` no ar, apertar VERMELHO faz `stop tN`, voltando pra grade.

## Estrutura NCL

- 8 `region` (fundo, container de tela, 6 celulas) e 8 `descriptor` (dBg, dC, d1..d6).
- 2 `causalConnector` reaproveitados (`cSel`, `cKey`).
- Portas: `fundo`, `cfg` (settings) e os 6 apps abrem no start; as telas so entram via link.
- 6 links de selecao (OK abre tela) + 6 links de tecla (VERMELHO fecha tela) = 12 links.

Padrao identico ao exemplo de estilo, apenas escalado de 2 botoes para grade 6 apps com navegacao bidirecional.
