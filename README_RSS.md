# RSS-root (LuaRSS Reader para TV Digital)

> Leitor de RSS em NCLua que exibe notícias de um feed sobre um vídeo · Manoel Campos da Silva Filho (IFTO) · ~2010

## O que é
Aplicação de TV Digital Interativa escrita em NCL + Lua (NCLua) que funciona como um leitor de RSS. O `main.ncl` exibe um vídeo em tela cheia (`media/Wanna_Work_Together_-_Creative_Commons.avi`) e sobrepõe, no rodapé (região `rgLua`, 30% inferior da tela), uma faixa de Lua que baixa um feed RSS pela rede, faz o parse do XML (via biblioteca LuaXML) e apresenta as notícias uma a uma. O download usa a classe TCP do Ginga simulada com co-rotinas (`tcp.lua`), conectando-se na porta 80 e fazendo uma requisição HTTP GET; o feed padrão no código é `www.r7.com` (há hosts alternativos comentados como `g1.globo.com` e `rss.noticias.uol.com.br`). O telespectador navega entre as notícias pelo controle remoto e a tecla vermelha (RED) está mapeada para encerrar a mídia Lua.

## Como rodar
```bash
# a partir da raiz do repositório:
ginga main.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
O esperado seria o vídeo em tela cheia com uma faixa de notícias do feed RSS rolando no rodapé, navegável pelo controle remoto. Na prática isso não acontece nesta máquina: a aplicação não chega a carregar (ver abaixo). Sem screenshot do app em execução.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — a aplicação falha no carregamento do script Lua.
- Erro exato: `./tcp.lua:14: attempt to call a nil value (global 'module')`
- Causa-raiz: o arquivo `tcp.lua` declara-se como módulo com `module 'tcp'` (linha 14). A função global `module()` foi removida no Lua 5.2+, e o Ginga atual usa um Lua novo; como `main.lua` faz `require "tcp"`, o erro ocorre logo no início e impede a execução.

## Limitações conhecidas
- `module()` removido no Lua 5.2+: `tcp.lua` (e o padrão de módulos da época) quebra no carregamento neste Ginga. Correção possível, fora do escopo agora: criar um shim de `module` ou portar o script.
- Mesmo corrigido o erro de Lua, o app depende de acesso de rede ao feed RSS (canal de retorno / HTTP na porta 80). O host padrão (`www.r7.com`) e os alternativos podem não responder mais no formato esperado, e a navegação depende de o feed ser baixado com sucesso.

## Arquivos principais
- `main.ncl` — documento NCL principal: define regiões, descritores, o vídeo de fundo e a mídia Lua, além dos links de controle (tecla RED encerra).
- `main.lua` — lógica do leitor de RSS: baixa o feed, faz parse do XML, formata e exibe as notícias sobre o vídeo, e trata as teclas do controle remoto.
- `tcp.lua` — biblioteca de conexões TCP do Ginga usando co-rotinas; ponto exato da falha (`module 'tcp'` na linha 14).
- `LuaXML/` — biblioteca LuaXML (`xml.lua`, `handler.lua`) usada para fazer o parse do XML do feed RSS.
- `media/` — mídias do app: o vídeo de fundo `Wanna_Work_Together_-_Creative_Commons.avi` e ícones (`dir.png`, `esq.png`, `fechar.png`).
- `LEIAME.txt` — nota curta com o título e o link do artigo original do autor.
- `Leitor-RSS-TV-Digital-GingaNCL.png` — imagem de divulgação/ilustração do app (não é uma captura da execução nesta máquina).
