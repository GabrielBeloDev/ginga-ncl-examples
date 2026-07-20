# Experimento 3 — Apps com BOTÃO + NAVEGAÇÃO

Depois dos exemplos de sincronismo (que são fáceis e os modelos já geravam bem), este experimento foca
no que é **difícil e interessante** em NCL: **botões navegáveis pelo controle remoto** (foco, setas,
seleção). É aqui que a **elicitação** (a IA perguntar posição/tecla/comportamento) mais importa.

## O corpus (gabaritos construídos e verificados)

Apps pequenos, **em NCL puro** (sem Lua), de padrões de navegação diferentes — todos **rodam no Ginga**
e a **navegação por foco funciona** (o botão focado ganha borda amarela):

| App | Padrão de botão/navegação | Situação |
|-----|---------------------------|----------|
| [`gabaritos/app-1-menu/`](gabaritos/app-1-menu/) | Menu horizontal, 4 botões (← →), OK abre tela, VERMELHO volta | ✅ roda |
| [`gabaritos/app-2-guia/`](gabaritos/app-2-guia/) | Lista vertical, 5 itens (↑ ↓) | ✅ roda |
| [`gabaritos/app-3-grade/`](gabaritos/app-3-grade/) | Grade 2×3, navegação em 2 direções (↑ ↓ ← →) | ✅ roda |
| `10menu` (do acervo) | Menu de 4 trilhas + propaganda + interatividade | ✅ roda (já usado no piloto) |

Cada pasta tem o `.ncl` + os assets (imagens geradas). O mecanismo de navegação usa `focusIndex` +
`moveLeft/moveRight/moveUp/moveDown` + `onSelection` (tecla OK) + tecla `RED` para voltar — tudo padrão
do NCL, sem Lua.

## Benchmark (feito) → [`benchmark/RESULTADO.md`](benchmark/RESULTADO.md)

Rodamos as **5 técnicas (T0, T1, T3, T5, T6)** sobre estes apps: uma IA **cega** recria cada um, e
medimos se a **navegação dos botões sai correta**. Resultado resumido:

| Técnica | Carrega | Fidelidade estrutural |
|---|:---:|:---:|
| T0 vago / T1 zero-shot | 4/4 · 3/4 | 3.8 · 3.2 |
| **T3 few-shot / T5 regras / T6 elicitação** | 4/4 | **5.0 · 4.5 · 4.5** |

As técnicas **estruturadas ganham**; o **T6 (elicitação, o fluxo do paper)** ainda **recupera a intenção
exata** via perguntas (ex.: a IA perguntou a ordem dos botões e o usuário corrigiu — algo que o T0 vago
errou). **Tudo capturado** em `benchmark/<app>/<técnica>/`: prompt, resposta da IA, NCL gerado,
screenshot da execução, e o diálogo do T6. Detalhes e figuras em
[`benchmark/RESULTADO.md`](benchmark/RESULTADO.md).
