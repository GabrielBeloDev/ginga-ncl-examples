# Perguntas de esclarecimento — App de menu horizontal de canais (T6-elicitacao)

Pedido recebido (vago): *"quero um app NCL de menu horizontal de canais com botoes, com as imagens dessa pasta"*.

Antes de gerar o NCL (perfil EDTV, autocontido), preciso fechar alguns pontos. Segue o que vi na pasta e as perguntas agrupadas.

## Imagens disponiveis na pasta (uso so o que esta aqui, referenciado por nome)

| Arquivo | Tamanho | Papel provavel |
|---|---|---|
| `fundo.png` | 1280x720 | fundo/tela cheia |
| `btn-clima.png` | 260x70 (RGBA/transparente) | botao Clima |
| `btn-jogos.png` | 260x70 (RGBA/transparente) | botao Jogos |
| `btn-noticias.png` | 260x70 (RGBA/transparente) | botao Noticias |
| `btn-sobre.png` | 260x70 (RGBA/transparente) | botao Sobre |
| `tela-clima.png` | 1280x720 | tela de conteudo do Clima |
| `tela-jogos.png` | 1280x720 | tela de conteudo dos Jogos |
| `tela-noticias.png` | 1280x720 | tela de conteudo das Noticias |
| `tela-sobre.png` | 1280x720 | tela de conteudo do Sobre |

Canvas base: **1280x720**. Ha exatamente **4 botoes** e **4 telas** correspondentes + 1 fundo.

## 1. Botoes: quais e quantos
1.1. Confirma os **4 botoes** (Clima, Jogos, Noticias, Sobre) nessa ordem da esquerda pra direita? Ou quer outra ordem / menos botoes?
1.2. O `fundo.png` deve aparecer atras do menu na tela inicial (fundo dos botoes)? Ou a tela inicial ja e uma das `tela-*`?

## 2. Layout / posicao do menu horizontal
2.1. Onde fica a faixa de botoes: **rodape** (parte de baixo), **topo** ou **centro** vertical da tela?
2.2. Espacamento entre botoes: os 4 botoes de 260px cabem em linha (4x260 = 1040px). Quer **centralizado** com folga igual entre eles, ou **alinhado a esquerda** com margem fixa?
2.3. Os botoes ficam sempre visiveis (menu por cima do conteudo) ou o menu **some** quando abre uma tela de canal?

## 3. Navegacao (foco)
3.1. Navega so na **horizontal** (setas Esquerda/Direita)? Ou tambem quer Cima/Baixo fazendo algo?
3.2. A navegacao e **circular**? (do ultimo botao, seta direita volta pro primeiro, e vice-versa)
3.3. Foco inicial no **botao 1 (Clima)**? Confirma o destaque de foco em **borda amarela grossa** (focusBorderColor="yellow", width 4)?

## 4. Selecao (tecla OK / ENTER)
4.1. Ao dar **OK** num botao, abre a `tela-*` correspondente em **tela cheia** (1280x720) por cima de tudo? Confirma esse comportamento?
4.2. Enquanto a tela do canal esta aberta, o **menu fica escondido** e volta so quando fecha? Ou o menu continua navegavel por cima da tela?

## 5. Voltar / sair
5.1. Pra **voltar** da tela do canal pro menu: uso a tecla **VERMELHA (RED)** (regra padrao do projeto) — confirma? Ou prefere OK/BACK?
5.2. Voltar deve **fechar so a tela aberta** (mantendo o menu) ou tem tela inicial de menu separada pra onde ele retorna?
5.3. Precisa de opcao de **sair do app**? Se sim, qual tecla?

## 6. Extras (opcionais, so confirmar se quer)
6.1. Quer algum **titulo/logo** fixo no topo? (nao ha imagem de titulo na pasta — so os `btn-*` e `tela-*`, entao ficaria sem, a menos que use texto)
6.2. Alguma **transparencia** em botao ou fundo? (se sim, uso `descriptorParam transparency`, nunca atributo do descriptor)
6.3. Efeito sonoro/beep na navegacao ou selecao? (nao ha audio na pasta — so confirmar se e pra ignorar)

---

**Resumo do que assumo por padrao se voce so disser "pode ir":**
- 4 botoes (Clima, Jogos, Noticias, Sobre), faixa horizontal no rodape, centralizada, sobre `fundo.png`.
- Navegacao circular Esquerda/Direita, foco inicial no botao 1, borda amarela de foco.
- OK abre `tela-*` em tela cheia; tecla VERMELHA volta pro menu.
- Sem titulo, sem transparencia, sem audio.

So responder por numero (ex.: "1.1 ok, 2.1 rodape, ...") ou mandar "pode ir com os padroes".
