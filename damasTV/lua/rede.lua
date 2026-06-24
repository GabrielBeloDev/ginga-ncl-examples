package.path = package.path..';engine/?.lua'
require 'mensageiro'

rede = {}

rede.Novo = function(this)
	local self = {}
	ORIENTACAO = true

	self.Fazer = function (this)
		DesenharFundo('imagens/fundo.png')
		canvas:attrFont ('vera', 20)
		canvas:attrColor('black')
		canvas:drawText(LARGURA*0.05,ALTURA*0.4 ,self.mensagem)
		for indice,obj in pairs(self.Objs) do
			canvas:attrColor(obj.cor)
			canvas:drawText(LARGURA*2/6,ALTURA*0.4 + ALTURA*0.1*indice,obj.texto)
		end
		if(self.menu)then
			self.menu:Desenhar()
		end
		canvas:flush()
	end

	self.TrataDados = function(tabelaDados)
		self.mensagem = tabelaDados.messagem
		if(tabelaDados.next_url)then
			local url = tabelaDados.next_url..'&user='..self.apelido.."&ip="..socket.dns.toip(socket.dns.gethostname())
			self.mensageiro:EnviaPagina(url)
		elseif(tabelaDados.ip)then
			self.mensageiro:Terminar()
			if(tabelaDados.codGame)then
				principal:TrocaEstado(5,{direta=true,nomes={tabelaDados.adversario,self.apelido},redeData={ip=tabelaDados.ip,port=20000,codJogo=tabelaDados.codGame,codUsuario=tabelaDados.codUser,codAdver=tabelaDados.codAdver}})
			else
				principal:TrocaEstado(5,{direta=true,nomes={self.apelido,tabelaDados.adversario},redeData={ip=tabelaDados.ip,port=20000}})
			end
		elseif(tabelaDados.codUser)then
			self.mensageiro:Terminar()
			if(tabelaDados.vez)then
				principal:TrocaEstado(5,{direta=false,nomes={self.apelido,tabelaDados.adversario},redeData={codJogo=tabelaDados.codGame,vez=true,codUsuario=tabelaDados.codUser,codAdver=tabelaDados.codAdver}})
			else
				principal:TrocaEstado(5,{direta=false,nomes={tabelaDados.adversario,self.apelido},redeData={codJogo=tabelaDados.codGame,codUsuario=tabelaDados.codUser,codAdver=tabelaDados.codAdver}})
			end
		elseif(tabelaDados.erro)then
			self.Objs = ApagaTabela(self.Objs)
			self.mensagem = "Erro na conexão"
			self.Objs = {{texto = 'Voltar',cor='red',aoSelecionar=self.Voltar}}
			self.indice = 1
		else
			local url = 'join.php?user='..self.apelido.."&ip="..socket.dns.toip(socket.dns.gethostname())
			self.mensageiro:EnviaPagina(url)
		end
	end

	self.mensageiro = mensageiro:Novo(self.TrataDados)

	self.SalvarNome = function(this)
		self.Selecionado = 1
		local novo = true
		local novosids = 'IDS = {'
		self.Objs = {{texto = 'Voltar',cor='red',aoSelecionar=self.Voltar}}
		for indice,ob in pairs(IDS) do
			novosids = novosids..ob..','
			if(self.apelido == ob)then
				novo = false
			end
		end
		if(novo)then
			table.insert(IDS,self.apelido)
			local str= TabelaParaString(IDS)
			local arquivo = 'SERVIDOR = "damstvserver.agilityhoster.com"\n'..string.sub(str,0,string.len(str)-1).."}"
			local file = io.open("constantesRede.lua","w")
			file:write(arquivo)
			file:close()
		end
		self.mensagem = 'Conectando por favor aguarde '..self.apelido
		local url = 'join.php?user='..self.apelido.."&ip="..socket.dns.toip(socket.dns.gethostname())
		self:Fazer()
		self.mensageiro:EnviaPagina(url)
	end

	self.Voltar = function(this)
		self.mensageiro:Terminar()
		principal:TrocaEstado(1)
	end

	self.ConfirmarApelido = function(this)
		local menuConfirma = {}

		menuConfirma.Desenhar = function(this)
			canvas:attrFont ('vera', 30)
			canvas:attrColor ('white')
			canvas:drawRect('fill',LARGURA/2 - 110,ALTURA/2 - 30,300,100)
			local cor
			if(this.confirmado)then
				cor = {'red','black'}
			else
				cor = {'black','red'}
			end
			canvas:attrColor ('black')
			canvas:drawText(LARGURA/2 - (canvas:measureText ("Usar o apelido '"..self.apelido.."'?")/2),ALTURA/2-27,"Usar o apelido: '"..self.apelido.."'?")
			canvas:attrColor (cor[1])
			canvas:drawText(LARGURA/2 - 100+(100-canvas:measureText ('Resumir'))/2,ALTURA/2+6,"Sim")
			canvas:attrColor (cor[2])
			canvas:drawText(LARGURA/2 +(100-canvas:measureText ('Reiniciar'))/2,ALTURA/2+6,'Nao')
		end

		menuConfirma.confirmado = true

		local movimenta = function(this)
			this.confirmado = not(this.confirmado)
		end

		menuConfirma.MoveCima = movimenta
		menuConfirma.MoveBaixo = movimenta
		menuConfirma.MoveDireita = movimenta
		menuConfirma.MoveEsquerda = movimenta

		menuConfirma.Seleciona = function(this)
			if(this.confirmado)then
				principal.estadoAtual.menu = ApagaTabela(principal.estadoAtual.menu)
				principal.estadoAtual:SalvarNome()
			else
				principal.estadoAtual.menu = ApagaTabela(principal.estadoAtual.menu)
			end
		end

		return menuConfirma
	end

	self.MudaApelido = function(this)
		self.apelido = this.texto
		self.menu = self:ConfirmarApelido()
	end

	self.AtivaMenu = function(this)
		require 'menuDeEscrita'
		self.menu = menuDeEscrita:Novo()
	end

	self.Inicio = function(this)
		self.Selecionado = 1
		self.mensagem = "Digite um apelido com as teclas numéricas ou escolha um"
		self.Objs ={}
		self.Objs[#self.Objs+1] = {texto = 'Novo apelido',cor='red',aoSelecionar=self.AtivaMenu}
		for indice,obj in pairs(IDS)do
			self.Objs[#self.Objs+1] = {texto = obj,cor='black',aoSelecionar=self.MudaApelido}
		end
		self.Objs[#self.Objs+1] = {texto = 'Voltar',cor='black',aoSelecionar=self.Voltar}
	end

	self:Inicio()

	self.MoveBaixo = function(this)
		if(self.menu)then
			self.menu:MoveBaixo()
		else
			self.Objs[self.Selecionado].cor = 'black'
			if(self.Selecionado < #self.Objs)then
				self.Selecionado=self.Selecionado+1
			else
				self.Selecionado=1
			end
			self.Objs[self.Selecionado].cor = 'red'
		end
	end

	self.MoveCima = function(this)
		if(self.menu)then
			self.menu:MoveCima()
		else
			self.Objs[self.Selecionado].cor = 'black'
			if(self.Selecionado > 1)then
				self.Selecionado = self.Selecionado-1
			else
				self.Selecionado = #self.Objs
			end
			self.Objs[self.Selecionado].cor = 'red'
		end
	end

	self.TrataEvento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type == 'press' then
			if     evt.key == 'CURSOR_UP'    then
				self:MoveCima()
			elseif evt.key == 'CURSOR_DOWN' then
				self:MoveBaixo()
			elseif(self.menu)then
				if(evt.key == "CURSOR_LEFT")then
					self.menu:MoveEsquerda()
				elseif(evt.key == "CURSOR_RIGHT")then
					self.menu:MoveDireita()
				elseif evt.key == 'ENTER'then
					if(self.apelido)then
						self.menu:Seleciona()
					else
						self.apelido = self.menu:StringTexto()
						self.menu = ApagaTabela(this.menu)
						if(self.apelido ~= '')then
							self.menu = self:ConfirmarApelido()
						else
							self.apelido = nil
						end
					end
				elseif(evt.key == '')then
					self.menu = ApagaTabela(self.menu)
				elseif(not(self.apelido))then
					self.menu:Receber(evt.key)
				end
			elseif evt.key == 'ENTER' and self.Selecionado then
				self.Objs[self.Selecionado]:aoSelecionar()
			end
		end
	end

	return self

end

