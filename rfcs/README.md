# RFCs — Documentação técnica dos exemplos que rodam

Cada **RFC** documenta a estrutura NCL real (regiões, descritores, conectores, mídias e elos) de um
app/exemplo **verificado como executável** no Ginga atual. Funcionam como uma *especificação técnica*
de cada exemplo funcional — útil tanto para estudo quanto como base para a pesquisa de autoria de NCL.

> Têm RFC os entrypoints que rodam: **A_Onda + os 14 exemplos didáticos** "Primeiro João", **e os apps
> recuperados após as correções de compatibilidade** (TVDQuiz, enquete-ncl, rss-reader, damasTV — veja
> [`../docs/CODE-CHANGES.md`](../docs/CODE-CHANGES.md)). Os apps que ainda não rodam estão documentados
> nos READMEs de suas pastas, com o erro e a causa-raiz.

| RFC | Título | Exemplo |
|-----|--------|---------|
| [RFC-0001](0001-a-onda.md) | App educacional interativo sobre a Amazônia | `A_Onda/A_Onda.ncl` |
| [RFC-0002](0002-00-syncprop.md) | Sincronismo por propriedades | `00syncProp.ncl` |
| [RFC-0003](0003-01-sync.md) | Sincronismo básico com reuso | `01sync.ncl` |
| [RFC-0004](0004-02-syncint.md) | Sincronismo com âncoras de conteúdo | `02syncInt.ncl` |
| [RFC-0005](0005-03-context.md) | Contextos em NCL | `03context.ncl` |
| [RFC-0006](0006-04-reuse.md) | Reuso de componentes | `04reuse.ncl` |
| [RFC-0007](0007-05-return.md) | Pontos de retorno | `05return.ncl` |
| [RFC-0008](0008-06-switch.md) | Seleção de conteúdo com switch | `06switch.ncl` |
| [RFC-0009](0009-07-transition.md) | Transições visuais | `07transition.ncl` |
| [RFC-0010](0010-08-animation.md) | Animação de propriedades | `08animation.ncl` |
| [RFC-0011](0011-09-settings.md) | Nó settings e variáveis globais | `09settings.ncl` |
| [RFC-0012](0012-10-menu.md) | Menu interativo por teclas | `10menu.ncl` |
| [RFC-0013](0013-11-nclua.md) | Integração com NCLua | `11nclua.ncl` |
| [RFC-0014](0014-12-embncl.md) | NCL embarcado / documento aninhado | `12embNCL.ncl` |
| [RFC-0015](0015-advert.md) | Inserção de propaganda | `advert.ncl` |
| [RFC-0016](0016-tvdquiz.md) | TVD Quiz — quiz interativo *(recuperado)* | `TVDQuiz/main.ncl` |
| [RFC-0017](0017-enquete.md) | Enquete/votação *(recuperado)* | `enquete-ncl/main.ncl` |
| [RFC-0018](0018-rss-reader.md) | Leitor de RSS (LuaRSS) *(recuperado)* | `rss-reader/main.ncl` |
| [RFC-0019](0019-damastv.md) | damasTV — jogo de damas *(carrega após correções)* | `damasTV/damas.ncl` |
