# O que foi capturado (e onde)

Nada se perdeu — **cada rodada da IA foi registrada por inteiro** e está versionada no git, organizada
por `<app>/<técnica>/`.

## Em CADA célula (`<app>/<técnica>/`)

| Arquivo | O que é |
|---|---|
| `entrada.md` | O **pedido/instrução que a IA recebeu** (o input), do jeito que o agente registrou. |
| `saida.md` | A **resposta da IA** (explicação/raciocínio que ela deu junto com o NCL). |
| `gerado.ncl` | O **documento NCL que a IA gerou**. |
| `tela-gerada.png` | O **screenshot** desse NCL **rodando no Ginga** (a prova visual). |

## Só nas células **T6** (elicitação) — o diálogo

| Arquivo | O que é |
|---|---|
| `perguntas.md` | As **perguntas** que a IA fez pra esclarecer a intenção. |
| `respostas.md` | As **respostas** do "usuário" (o input humano do diálogo). |

## Na raiz do benchmark

| Arquivo | O que é |
|---|---|
| `RESULTADO.md` | O **relatório**: tabela de resultados, screenshots comparativos e os achados. |
| `prompts-exatos-usados.js` | O **script exato** que montou todos os prompts (o input **verbatim** de cada técnica — a fonte da verdade caso o `entrada.md` de algum agente tenha ficado resumido). |
| `_ginga_results.json` | Quais NCLs carregaram no Ginga. |

> As pastas `pasta-de-trabalho/` (com as imagens copiadas e o log do Ginga) ficam **fora do git**
> (`.gitignore`) por serem só material de execução duplicado — o que importa (entrada, saída, NCL,
> screenshot, diálogo) está preservado no nível de cada célula.

**Resumindo:** input (prompt), output (resposta + NCL), tela rodando e o diálogo do T6 — tudo capturado,
tudo no repositório.
