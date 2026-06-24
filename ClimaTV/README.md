# ClimaTV

> App de TV Digital Interativa (NCL + Lua) que mostra a previsão do tempo das capitais brasileiras via canal de retorno · Design: Cid Boechat · Desenvolvimento: Luiz Eduardo de Araujo · ~2010

## O que é
ClimaTV é uma aplicação NCLua para Ginga em que o telespectador navega por menus — primeiro escolhe a região do Brasil, depois o estado/capital — usando as teclas numéricas e coloridas do controle remoto. A partir da capital escolhida, o app consulta o serviço web da `weather.com` (xoap.weather.com) através do canal de retorno e exibe a previsão do tempo: cidade, temperatura, umidade, vento, índice UV, sensação térmica, nascente e poente. É construído com NCL para a estrutura de mídias (`main.ncl`) e Lua para toda a lógica de interface, desenho em `canvas`, paginação de estados e parsing da resposta. Inclui um cliente HTTP/TCP (`tcp.lua`), um parser de XML em Lua puro (`xmlparser.lua`), a base de regiões/estados/capitais (`libCity.lua`) e roda sobre um vídeo de abertura em loop (`wannaworktogether.mpeg`).

## Como rodar
```bash
cd ClimaTV
ginga main.ncl
```
Dica: adicione `-f` (tela cheia) ou `-s 960x540` (tamanho da janela).

## O que você deve ver
Em tese, um vídeo de abertura em loop ocupando a tela e, sobre ele, um painel à direita com o menu "Pressione no controle o número da região onde fica a sua capital", seguido pela lista de estados/capitais e pela tela de previsão do tempo. Na prática, nada disso é renderizado: o Ginga aborta antes de a interface aparecer (ver Status da verificação). Não há screenshot.

## Status da verificação
Testado em **2026-06-24** · Ginga (telemidia/ginga, C++) · Ubuntu 22.04
- ❌ Não roda — o processo Ginga abortou ainda na inicialização, antes de renderizar a interface.
- Erro exato no log: `ginga::PlayerLua::start(): out of memory` — a inicialização do NCLua falha neste Ginga.
- Causa-raiz: os scripts usam recursos de NCLua antigo incompatíveis com o Lua/Ginga atuais. Em particular `tcp.lua` começa com `module 'tcp'`, e a função `module()` foi removida no Lua 5.2+, o que quebra o carregamento dos módulos neste Ginga.

## Limitações conhecidas
- `module()` removido no Lua 5.2+: `tcp.lua` depende de `module 'tcp'`, padrão que não existe mais no Lua novo usado por este Ginga. Correção possível (fora do escopo): criar um shim de `module` ou portar os scripts.
- Serviço externo morto: depende do webservice `xoap.weather.com` (`http://xoap.weather.com/weather/local/...`), com chave de API fixa de ~2010, há muito desativado. Mesmo com o Lua corrigido, não há de onde buscar a previsão.
- Canal de retorno: requer conexão de saída (HTTP via `socket.http` ou TCP), recurso de TV interativa indisponível neste ambiente.
- Parser de XML estrito: `xmlparser.lua` espera exatamente a estrutura de resposta antiga da weather.com (índices fixos como `_xml[2][3][3][1]`); qualquer mudança de formato quebraria a leitura.

## Arquivos principais
- `main.ncl` — documento NCL principal; define as regiões/descritores, toca o vídeo de abertura em loop e carrega o `main.lua` no painel da direita.
- `main.lua` — ponto de entrada Lua; inicializa variáveis, desenha a tela inicial e registra o handler de eventos.
- `controle.lua` — máquina de estados da navegação (Região → Estado → Previsão); trata teclas numéricas, coloridas e cursores.
- `app.lua` — funções de desenho no `canvas` das telas (regiões, estados paginados, previsão) e a lógica de consulta/tratamento dos dados do webservice.
- `libCity.lua` — tabelas de regiões, estados, capitais e seus códigos de cidade da weather.com.
- `tcp.lua` — cliente TCP assíncrono via coroutines/eventos do Ginga (contém `module 'tcp'`, causa da falha no Lua novo).
- `xmlparser.lua` — parser de XML em Lua puro (skeleton de Roberto Ierusalimschy) que converte a resposta em tabela Lua.
- `wannaworktogether.mpeg` — vídeo de abertura exibido em loop ao fundo.
- `vera.ttf` — fonte Bitstream Vera usada nos textos da interface.
- `midias/` — recursos gráficos: `data/` (layouts e botões) e `icon/` (ícones numerados da previsão do tempo).
