package.path = package.path..';engine/?.lua'
teclado = require 'Teclado'
require 'conexaoTcp'
require 'constantesRede'
require 'fundo'
require 'conexaoCopas'
require 'socket'
require 'constantes'

rede = {}

rede.Novo = function(this)
	local self = {}

	self.Fazer = function (this)
		fundo:DesenharFundo('imagens/fundo.png')
		canvas:attrColor('black')
		canvas:drawText(fundo.largura*0.05,fundo.altura*0.4 ,self.mensagem)
		for indice,obj in pairs(self.Objs) do
			canvas:attrColor(obj.cor)
			canvas:drawText(fundo.largura*2/6,fundo.altura*0.4 + fundo.altura*0.1*indice,obj.texto)
		end
		canvas:flush()
	end

	self.TrataDados = function(msg,connetcionData)
		if(msg == 'conectado')then
			self.conexaoTcp:Envia('GET http://'..SERVIDOR..'/'..self.url..'\n',connetcionData)
		elseif(msg == 'recebido')then
			print(self.url)
			print(self.conexaoTcp.conexoesAtivas[connetcionData].data)
			local dados = assert(loadstring(self.conexaoTcp.conexoesAtivas[connetcionData].data))()
			self.mensagem = dados.messagem
			if(dados.next_url)then
				self.url = dados.next_url..'&user='..self.Objs[1].texto.."&ip="..socket.dns.toip(socket.dns.gethostname())
				print('em loop')
				self.conexaoTcp:Conecta({host=SERVIDOR,port=80})
			elseif(dados.codUser)then
				principal:TrocaEstado(5)
				if(dados.vez)then
					principal.estadoAtual:ConexaoHttp({nomes={dados.adversario,self.texto},codJogo=dados.codGame,vez=true,codUsuario=dados.codUser,codAdver=dados.codAdver})
				else
					principal.estadoAtual:ConexaoHttp({nomes={dados.adversario,self.texto},codJogo=dados.codGame,codUsuario=dados.codUser,codAdver=dados.codAdver})
				end
			elseif(dados.ip)then
				print('chegou')
				principal:TrocaEstado(5)
				if(dados.codGame)then
					principal.estadoAtual:conexaoDireta({ip=dados.ip,port=20000,nomes={dados.adversario,self.texto},codJogo=dados.codGame,servidro=true})
				else
					principal.estadoAtual:conexaoDireta({ip=dados.ip,port=20000,nomes={self.texto,dados.adversario}})
				end
			end
		elseif(msg == 'erro')then
			self.mensagem ='Erro:'..connetcionData
		end
	end

	self.conexaoTcp = conexaoTcp:Novo(self.TrataDados)

	self.MudaNick = function(this)
		teclado.AlteraTexto(this.texto)
		self.Objs[1].texto = this.texto
		self.Objs[self.Selecionado].cor = 'black'
		self.Selecionado = 1
		self.Objs[self.Selecionado].cor = 'red'
	end

	self.SalvarNome = function(this)
		local novo = true
		local texto = self.Objs[1].texto
		local novosids = 'IDS = {'
		self.Objs = {{texto = texto,cor='red'}}
		for indice,ob in pairs(IDS) do
			novosids = novosids..ob..','
			if(texto == ob)then
				novo = false
			end
		end
		if(novo)then
			package.path = package.path..';engine/?.lua'
			require "AuxFunctions"
			table.insert(IDS,texto)
			local str= AuxFunctions.TableToString(IDS)
			local arquivo = 'SERVIDOR = "damstvserver.agilityhoster.com"\n'..string.sub(str,0,string.len(str)-1).."}"
			local file = io.open("constantesRede.lua","w")
			file:write(arquivo)
			file:close()
		end
		self.mensagem = 'Conectando por favor aguarde'
		self.url = 'join.php?user='..texto.."&ip="..socket.dns.toip(socket.dns.gethostname())
		self.texto = texto
		self.conexaoTcp:Conecta({host=SERVIDOR,port=80})
	end

	self.Voltar = function(this)
		principal:TrocaEstado(1)
	end


	self.Inicio = function(this)
		self.Selecionado = 1
		self.mensagem = "Digite um nick com as teclas numericas ou escolha um"
		self.Objs ={}
		self.Objs[1] = {texto = "_",cor='red',aoSelecionar=self.SalvarNome}
		for indice,obj in pairs(IDS)do
			self.Objs[#self.Objs+1] = {texto = obj,cor='black',aoSelecionar=self.MudaNick}
		end
		self.Objs[#self.Objs+1] = {texto = 'Voltar',cor='black',aoSelecionar=self.Voltar}
	end

	self:Inicio()

	self.MoverParaBaixo = function(this)
		self.Objs[self.Selecionado].cor = 'black'
		if(self.Selecionado < #self.Objs)then
			self.Selecionado=self.Selecionado+1
		else
			self.Selecionado=1
		end
		self.Objs[self.Selecionado].cor = 'red'
	end

	self.MoverParaCima = function(this)
		self.Objs[self.Selecionado].cor = 'black'
		if(self.Selecionado > 1)then
			self.Selecionado = self.Selecionado-1
		else
			self.Selecionado = #self.Objs
		end
		self.Objs[self.Selecionado].cor = 'red'
	end

	self.TrataEvento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type == 'press' then
			if     evt.key == 'CURSOR_UP'    then
				self:MoverParaCima()
			elseif evt.key == 'CURSOR_DOWN' then
				self:MoverParaBaixo()
			elseif evt.key == 'ENTER' and #self.Objs>1 then
				self.Objs[self.Selecionado]:aoSelecionar()
			elseif(self.Selecionado == 1 and not(self.url))then
				if(evt.key == "CURSOR_LEFT")then
					teclado.MoverParaTras()
				elseif(evt.key == "CURSOR_RIGHT")then
					teclado.MoverParaFrente()
				else
					teclado.Receber(evt.key)
				end
				self.Objs[1].texto = teclado.ReceberTexto()
			end
		end
	end

	return self

end

