Restaurados e conferidos: `perguntas.md` e `respostas.md` de `app-3-grade/T6-elicitacao/` voltaram a bater exatamente com a versão íntegra em `pasta-de-trabalho/` (e com o commit `f2f2c4a`) — `git status` já não mostra diferença nesses dois arquivos.

Resumindo o que estava errado: alguém colou o texto de entrega final ("Pronto, tá tudo criado e validado...") dentro de `perguntas.md` — esse texto pertence a `saida.md`, não é uma lista de perguntas de elicitação — e `respostas.md` ficou vazio (0 bytes). Como as perguntas reais (16 itens sobre orientação da grade, ordem dos botões, navegação circular, foco, ação do OK, tecla de volta etc.) e as respostas correspondentes ("usa a sugestão" em cada item) ainda existiam intactas em `pasta-de-trabalho/`, restaurei a partir de lá em vez de inventar respostas pra um texto que não era pergunta — isso corromperia o dataset do benchmark.

Ainda restam modificados (não mexi, fora do escopo desse pedido): `T5-regras/entrada.md`, `T5-regras/gerado.ncl`, `T5-regras/saida.md` e o arquivo novo `T5-regras/_raw.txt`. Quer que eu olhe esses também, ou isso é de uma rodada em andamento que você quer deixar como está?
 VIDEO (app-1). Usa a sugestao.
9. Sim, destaque de foco com **borda amarela grossa** (focusBorderColor amarelo, largura 4). Usa a sugestao.

## 4. Acao do OK
10. Sim, OK **abre a tela de detalhe** do app focado: app-N -> tela-N (mapeamento 1:1). Usa a sugestao.
11. Sim, a tela de detalhe **cobre a grade inteira** (fullscreen por cima). Usa a sugestao.

## 5. Voltar
12. Sim, tecla **VERMELHA (RED)** fecha a tela de detalhe e volta pra grade. Usa a sugestao.
13. Ao voltar, o **foco volta pro botao que abriu** a tela. Usa a sugestao.
14. VERMELHA **na grade** (sem detalhe aberto) **nao faz nada** — so tem efeito quando ha detalhe aberto. Usa a sugestao.

## 6. Tecnico / saida
15. Sim, **NCL 3.0 EDTV, autocontido** (regioes, descritores, conectores e elos inline), referenciando so as imagens da pasta pelo nome. Usa a sugestao.
16. Pode gerar **`app-grade.ncl`** aqui na `pasta-de-trabalho`. Nome ok.

---

Tudo confirmado, pode gerar o NCL.
