export const meta = {
  name: 'benchmark-botao',
  description: 'Benchmark T0/T1/T3/T5/T6 em 4 apps de botao; agentes cegos geram NCL e salvam entrada+saida',
  phases: [
    { title: 'Geração', detail: 'T0/T1/T3/T5: 1 agente por celula' },
    { title: 'T6 (elicitação)', detail: 'pergunta -> resposta -> gera, por app' },
  ],
}
const BM = "/home/teleadm/Documents/NCL-files/belo-ncl-spec-driven/experimento-3-apps-com-botao/benchmark"
const OK = { type:"object", properties:{ ok:{type:"boolean"}, nota:{type:"string"} }, required:["ok","nota"] }

const SPEC_KIT = `
REGRAS (spec-kit) para gerar NCL de app com BOTOES:
- Documento NCL 3.0 perfil EDTV (xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile"), AUTOCONTIDO (regioes, descritores, conectores causais e elos inline).
- Use SO as imagens da pasta, referenciando por nome.
- IMPORTANTE: toda <media> que deve aparecer no inicio precisa de um <port> no <body>, senao NAO aparece.
- Botao navegavel: cada botao e uma <media> cujo <descriptor> tem focusIndex="N" e moveLeft/moveRight/moveUp/moveDown apontando os vizinhos (circular), e focusBorderColor="yellow" focusBorderWidth="4" pra destacar o foco.
- Foco inicial: uma <media type="application/x-ginga-settings"> com <property name="service.currentFocus" value="1"/> (com port).
- OK (selecao): conector com <simpleCondition role="onSelection"/> -> <simpleAction role="start"/>.
- Tecla VERMELHA (voltar): conector com <connectorParam name="tecla"/> + <simpleCondition role="onSelection" key="$tecla"/> -> stop; no <bind>, <bindParam name="tecla" value="RED"/>.
- Transparencia (se usar): <descriptorParam name="transparency" value="..."/>, NUNCA transparency como atributo do <descriptor>.
- <port id="entry"> aponta o componente de entrada.`

const FEWSHOT = `
EXEMPLO (pedido -> NCL), so pra referencia de estilo (adapte pro seu caso):
Pedido: menu com 2 botoes (A, B) lado a lado embaixo; setas esq/dir navegam; OK abre a tela do botao; VERMELHO volta. Imagens: fundo.png, btnA.png, btnB.png, telaA.png, telaB.png.
NCL:
<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="ex" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
 <head>
  <regionBase>
   <region id="rBg" width="100%" height="100%" zIndex="0"/>
   <region id="rC" width="100%" height="100%" zIndex="5"/>
   <region id="rA" left="20%" top="80%" width="25%" height="12%" zIndex="2"/>
   <region id="rB" left="55%" top="80%" width="25%" height="12%" zIndex="2"/>
  </regionBase>
  <descriptorBase>
   <descriptor id="dBg" region="rBg"/><descriptor id="dC" region="rC"/>
   <descriptor id="dA" region="rA" focusIndex="1" moveRight="2" moveLeft="2" focusBorderColor="yellow" focusBorderWidth="4"/>
   <descriptor id="dB" region="rB" focusIndex="2" moveRight="1" moveLeft="1" focusBorderColor="yellow" focusBorderWidth="4"/>
  </descriptorBase>
  <connectorBase>
   <causalConnector id="cSel"><simpleCondition role="onSelection"/><simpleAction role="start"/></causalConnector>
   <causalConnector id="cKey"><connectorParam name="tecla"/><simpleCondition role="onSelection" key="$tecla"/><simpleAction role="stop"/></causalConnector>
  </connectorBase>
 </head>
 <body>
  <port id="e" component="fundo"/><port id="ps" component="cfg"/><port id="pa" component="ba"/><port id="pb" component="bb"/>
  <media id="cfg" type="application/x-ginga-settings"><property name="service.currentFocus" value="1"/></media>
  <media id="fundo" src="fundo.png" descriptor="dBg"/>
  <media id="ba" src="btnA.png" descriptor="dA"/><media id="bb" src="btnB.png" descriptor="dB"/>
  <media id="ta" src="telaA.png" descriptor="dC"/><media id="tb" src="telaB.png" descriptor="dC"/>
  <link xconnector="cSel"><bind role="onSelection" component="ba"/><bind role="start" component="ta"/></link>
  <link xconnector="cSel"><bind role="onSelection" component="bb"/><bind role="start" component="tb"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="ta"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="ta"/></link>
  <link xconnector="cKey"><bind role="onSelection" component="tb"><bindParam name="tecla" value="RED"/></bind><bind role="stop" component="tb"/></link>
 </body>
</ncl>`

const APPS = [
 { k:"app-1-menu", tipo:"menu horizontal de canais",
   intent:"Menu com 4 botoes na BASE da tela, lado a lado: JOGOS, NOTICIAS, CLIMA, SOBRE (imagens btn-jogos.png, btn-noticias.png, btn-clima.png, btn-sobre.png), sobre um fundo (fundo.png). Setas ESQUERDA/DIREITA movem o foco (circular); OK abre uma TELA CHEIA daquele item (tela-jogos.png, tela-noticias.png, tela-clima.png, tela-sobre.png); a tecla VERMELHA fecha a tela e volta ao menu. Foco comeca no primeiro botao." },
 { k:"app-2-guia", tipo:"guia de programacao (lista vertical)",
   intent:"Lista VERTICAL de 5 itens a esquerda: '18h Novela','19h Jornal','20h Futebol','22h Filme','23h Show' (item-1.png a item-5.png), sobre fundo.png. Setas CIMA/BAIXO movem o foco (circular); OK abre a tela cheia do item (tela-1.png a tela-5.png); VERMELHO volta. Foco no primeiro item." },
 { k:"app-3-grade", tipo:"grade de aplicativos 2x3",
   intent:"Grade de 2 linhas x 3 colunas com 6 apps: VIDEO, MUSICA, FOTOS (linha 1) e JOGOS, LOJA, CONFIG (linha 2) (app-1.png a app-6.png), sobre fundo.png. Navegacao em 2 direcoes (setas CIMA/BAIXO/ESQ/DIR); OK abre a tela do app (tela-1.png a tela-6.png); VERMELHO volta. Foco no primeiro." },
 { k:"app-4-dialogo", tipo:"dialogo de decisao Sim/Nao",
   intent:"Dialogo perguntando 'Deseja assinar o Canal Belo?' com 2 botoes SIM e NAO (btn-sim.png, btn-nao.png), sobre fundo.png. Setas ESQ/DIR movem o foco; OK no SIM mostra tela-sim.png ('Assinatura confirmada!') e OK no NAO mostra tela-nao.png ('Talvez depois'); VERMELHO volta. Foco no SIM." },
]

const cell = (app,tec)=>`${BM}/${app}/${tec}/pasta-de-trabalho`
const salvar = (dir)=>`No fim, SALVE 3 arquivos nessa pasta (${dir}) com a ferramenta Write: 'gerado.ncl' (o NCL), 'entrada.md' (exatamente o pedido/instrucao que voce recebeu) e 'saida.md' (sua resposta/explicacao). Liste a pasta antes pra ver as imagens. NAO leia pastas acima.`

// ---- T0..T5: 1 agente por celula ----
const single = []
for (const app of APPS) {
  const d0=cell(app.k,"T0-vago")
  single.push(()=>agent(`Gere um documento NCL e salve em ${d0}/gerado.ncl. Pedido do usuario (curto e vago): "cria um app NCL de ${app.tipo} com botoes, usando as imagens dessa pasta". Use so as imagens da pasta (liste-a). ${salvar(d0)}`,{label:`T0:${app.k}`,phase:'Geração',schema:OK,agentType:'general-purpose',model:'opus'}))
  const d1=cell(app.k,"T1-zeroshot")
  single.push(()=>agent(`Gere um documento NCL EDTV autocontido e salve em ${d1}/gerado.ncl, reproduzindo este app: ${app.intent}\nSem exemplos e sem lista de regras — so a descricao acima. Use so as imagens da pasta. ${salvar(d1)}`,{label:`T1:${app.k}`,phase:'Geração',schema:OK,agentType:'general-purpose',model:'opus'}))
  const d3=cell(app.k,"T3-fewshot")
  single.push(()=>agent(`Gere um documento NCL EDTV autocontido e salve em ${d3}/gerado.ncl, reproduzindo este app: ${app.intent}\n${FEWSHOT}\nUse so as imagens da pasta. ${salvar(d3)}`,{label:`T3:${app.k}`,phase:'Geração',schema:OK,agentType:'general-purpose',model:'opus'}))
  const d5=cell(app.k,"T5-regras")
  single.push(()=>agent(`${SPEC_KIT}\nSeguindo ESTAS regras, gere um documento NCL EDTV autocontido e salve em ${d5}/gerado.ncl, reproduzindo este app: ${app.intent}\nUse so as imagens da pasta. ${salvar(d5)}`,{label:`T5:${app.k}`,phase:'Geração',schema:OK,agentType:'general-purpose',model:'opus'}))
}
phase('Geração')
await parallel(single)

// ---- T6: dialogo (pergunta -> resposta -> gera) por app ----
phase('T6 (elicitação)')
await parallel(APPS.map(app=>async ()=>{
  const d=cell(app.k,"T6-elicitacao")
  // 1) asker (cego): recebe pedido vago + regras, faz perguntas
  await agent(`${SPEC_KIT}\nVoce e um assistente que gera NCL. O usuario mandou um pedido VAGO: "quero um app NCL de ${app.tipo} com botoes, com as imagens dessa pasta". Antes de gerar, seguindo suas regras, FACA as PERGUNTAS de esclarecimento essenciais (posicao/layout dos botoes, quais/quantos, qual tecla navega, o que OK faz, como volta, etc.) — agrupadas e objetivas. NAO gere o NCL ainda. Liste a pasta pra ver as imagens. SALVE as perguntas em ${d}/perguntas.md (Write). NAO leia pastas acima.`,{label:`T6-perg:${app.k}`,phase:'T6 (elicitação)',schema:OK,agentType:'general-purpose',model:'opus'})
  // 2) answerer (oraculo): responde as perguntas como o usuario que quer ESTE app
  await agent(`Voce e o USUARIO. Leia as perguntas em ${d}/perguntas.md e responda cada uma como quem quer exatamente este app: ${app.intent}\nResponda de forma direta e curta. SALVE as respostas em ${d}/respostas.md (Write).`,{label:`T6-resp:${app.k}`,phase:'T6 (elicitação)',schema:OK,agentType:'general-purpose',model:'opus'})
  // 3) generator (cego): usa pedido vago + as respostas pra gerar
  await agent(`${SPEC_KIT}\nVoce recebeu um pedido vago de um app NCL de ${app.tipo} com botoes e, apos perguntar, o usuario respondeu. Leia ${d}/perguntas.md e ${d}/respostas.md. Com base NISSO (nao invente alem do que foi respondido), gere o NCL EDTV autocontido e salve em ${d}/gerado.ncl. Use so as imagens da pasta. Tambem salve entrada.md (pedido + perguntas + respostas) e saida.md (sua explicacao) em ${d}. NAO leia pastas acima.`,{label:`T6-gerar:${app.k}`,phase:'T6 (elicitação)',schema:OK,agentType:'general-purpose',model:'opus'})
  return { app: app.k }
}))
return { feito: true }
