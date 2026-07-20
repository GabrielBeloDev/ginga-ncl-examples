# `harness/` — automação do benchmark (a implementar)

Esta pasta vai conter a **automação** do benchmark descrito em
[`../02-benchmark-de-prompting.md`](../02-benchmark-de-prompting.md) — hoje o piloto e a replicação
foram rodados com scripts avulsos; aqui entra a versão reprodutível.

Componentes planejados (nomes sugeridos no doc do benchmark):

- **`gerar.*`** — dispara a técnica de prompting (T0–T8) num agente cego e salva o `.ncl` gerado.
- **`rodar-ginga.*`** — executa cada `.ncl` no Ginga (headless via `-f`) e captura tela + log.
- **`comparar.*`** — extrai a estrutura (linha do tempo, regiões, `switch`, mídias, teclas) do gerado
  e do gabarito e calcula o **Fidelity Score**.
- **`matriz.*`** — orquestra `técnica × app × modelo × rodada` e consolida a tabela de resultados.

> Status: **stub**. A lógica de referência já existe em forma de scripts do piloto/replicação; o
> próximo passo é consolidá-la aqui como um harness parametrizável.
