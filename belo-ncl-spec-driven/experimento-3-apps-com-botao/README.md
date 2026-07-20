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

## Próximo passo (benchmark)

Rodar as técnicas de prompting **T0, T1, T3, T5, T6** (ver
[`../02-benchmark-de-prompting.md`](../02-benchmark-de-prompting.md)) sobre estes apps: uma IA **cega**
recria cada app a partir da intenção, e a gente mede se **a navegação dos botões sai correta**
(foco/setas/seleção/voltar) e o quão fiel fica ao gabarito. O foco do artigo é a técnica **T6**
(spec-kit de regras + elicitação por perguntas); as demais entram como **validação comparativa**.
