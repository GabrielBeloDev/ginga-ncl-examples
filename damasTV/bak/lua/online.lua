package.path = package.path..';engine/?.lua'
teclado = require 'Teclado'
require 'conexaoTcp'
require 'fundo'
require 'conexaoCopas'
require 'socket'
require 'constantes'

online = {}

online.Novo = function(this)
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

	self.HandlerData = function(msg,connetcionData)
		if(msg == 'conectado')then
			print('conectou')
			self.conexaoTcp:Envia('GET http://'..SERVIDOR..'/'..self.url,connetcionData)
		elseif(msg == 'recebido')then
			local dados = assert(self.conexaoTcp.conexoesAtivas[connetcionData].data)
			self.mensagem = dados.mensagem
			if(dados.next_url)then
				self.url = dados.next_url
				print('em loop')
				self.conexaoTcp:Conecta({host=SERVIDOR,port=80})
			else
				print('chegou')
				main:TrocaEstado(5)
				if(dados.codGame)then
					main.estadoAtual:Conecta({ip=dados.ip,port=20000,nomes={dados.adversario,self.texto},codJogo=dados.codGame,servidro=true})
				else
					main.estadoAtual:Conecta({ip=dados.ip,port=20000,nomes={self.texto,dados.adversario}})
				end
			end
		elseif(msg == 'erro')then
			self.mensagem ='Erro:'..connetcionData
		end
	end

	self.conexaoTcp = conexaoTcp:Novo(self.HandlerData)

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
		self.Objs = {{texto = texto,cor='red'}}
		for indice,ob in pairs(IDS) do
			if(texto == ob)then
				novo = false
			end
		end
		if(novo)then
			table.insert(texto)
		end
		self.mensagem = 'Conectando por favor aguarde'
		self.url = 'join.php?user='..texto.."&ip="..socket.dns.toip(socket.dns.gethostname())
		self.texto = texto
		self.conexaoTcp:Conecta({host=SERVIDOR,port=80})
	end

	self.Voltar = function(this)
		main:TrocaEstado(1)
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

	self.HandlerMovimento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type == 'press' then
			if     evt.key == 'CURSOR_UP'    then
				self:MoverParaCima()
			elseif evt.key == 'CURSOR_DOWN' then
				self:MoverParaBaixo()
			elseif evt.key == 'ENTER' and #self.Objs>1 then
				self.Objs[self.Selecionado]:aoSelecionar()
			elseif(self.Selecionado == 1)then
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

