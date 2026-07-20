# Entrada (pedido/instrução recebida)

REGRAS (spec-kit) para gerar NCL de app com BOTOES:
- Documento NCL 3.0 perfil EDTV (xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"), AUTOCONTIDO (regioes, descritores, conectores causais e elos inline).
- Use SO as imagens da pasta, referenciando por nome.
- IMPORTANTE: toda `<media>` que deve aparecer no inicio precisa de um `<port>` no `<body>`, senao NAO aparece.
- Botao navegavel: cada botao e uma `<media>` cujo `<descriptor>` tem focusIndex="N" e moveLeft/moveRight/moveUp/moveDown apontando os vizinhos (circular), e focusBorderColor="yellow" focusBorderWidth="4" pra destacar o foco.
- Foco inicial: uma `<media type="application/x-ginga-settings">` com `<property name="service.currentFocus" value="1"/>` (com port).
- OK (selecao): conector com `<simpleCondition role="onSelection"/>` -> `<simpleAction role="start"/>`.
- Tecla VERMELHA (voltar): conector com `<connectorParam name="tecla"/>` + `<simpleCondition role="onSelection" key="$tecla"/>` -> stop; no `<bind>`, `<bindParam name="tecla" value="RED"/>`.
- Transparencia (se usar): `<descriptorParam name="transparency" value="..."/>`, NUNCA transparency como atributo do `<descriptor>`.
- `<port id="entry">` aponta o componente de entrada.

Seguindo ESTAS regras, gere um documento NCL EDTV autocontido e salve em
`/home/teleadm/Documents/NCL-files/belo-ncl-spec-driven/experimento-3-apps-com-botao/benchmark/app-1-menu/T5-regras/pasta-de-trabalho/gerado.ncl`,
reproduzindo este app: Menu com 4 botoes na BASE da tela, lado a lado: JOGOS, NOTICIAS, CLIMA, SOBRE (imagens btn-jogos.png, btn-noticias.png, btn-clima.png, btn-sobre.png), sobre um fundo (fundo.png). Setas ESQUERDA/DIREITA movem o foco (circular); OK abre uma TELA CHEIA daquele item (tela-jogos.png, tela-noticias.png, tela-clima.png, tela-sobre.png); a tecla VERMELHA fecha a tela e volta ao menu. Foco comeca no primeiro botao.

Use so as imagens da pasta. No fim, SALVE 3 arquivos nessa pasta (`.../T5-regras/pasta-de-trabalho`) com a ferramenta Write: `gerado.ncl` (o NCL), `entrada.md` (exatamente o pedido/instrucao que voce recebeu) e `saida.md` (sua resposta/explicacao). Liste a pasta antes pra ver as imagens. NAO leia pastas acima.
