# Entrada (pedido recebido)

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

Seguindo ESTAS regras, gere um documento NCL EDTV autocontido e salve em `/home/teleadm/Documents/NCL-files/belo-ncl-spec-driven/experimento-3-apps-com-botao/benchmark/app-3-grade/T5-regras/pasta-de-trabalho/gerado.ncl`, reproduzindo este app: Grade de 2 linhas x 3 colunas com 6 apps: VIDEO, MUSICA, FOTOS (linha 1) e JOGOS, LOJA, CONFIG (linha 2) (app-1.png a app-6.png), sobre fundo.png. Navegacao em 2 direcoes (setas CIMA/BAIXO/ESQ/DIR); OK abre a tela do app (tela-1.png a tela-6.png); VERMELHO volta. Foco no primeiro.

Use so as imagens da pasta. No fim, SALVE 3 arquivos nessa pasta (`/home/teleadm/Documents/NCL-files/belo-ncl-spec-driven/experimento-3-apps-com-botao/benchmark/app-3-grade/T5-regras/pasta-de-trabalho`) com a ferramenta Write: `gerado.ncl` (o NCL), `entrada.md` (exatamente o pedido/instrucao que voce recebeu) e `saida.md` (sua resposta/explicacao). Liste a pasta antes pra ver as imagens. NAO leia pastas acima.
