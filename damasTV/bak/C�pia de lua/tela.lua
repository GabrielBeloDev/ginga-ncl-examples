require 'computador'
require 'fundo'
require 'constantes'

tela = {}

tela.Novo = function(this)
	local self = {}
	canvas:attrFont ('vera', 30)
	canvas:attrColor('blue')
	self.Fazer = function (this)
		fundo:DesenharFundo('imagens/fundo.png')
		for indice,obj in pairs(self.Objs) do
			if(indice == self.Selecionado) then
				canvas:attrColor('red')
			else
				canvas:attrColor('black')
			end
			canvas:drawText(fundo.largura*2/6,fundo.altura*0.4 + fundo.altura*0.1*indice,obj.texto)
		end
		canvas:flush()
	end

	self.IrParaJogo = function(this)
		self.Objs = {{texto='Contra Computador',aoSelecionar=self.JogoContraComputador},{texto='Multi Jogador',aoSelecionar=self.JogoMultijogador},{texto='Jogar Online',aoSelecionar=self.JogoOnline},{texto='Voltar',aoSelecionar=self.Voltar}}
	end

	self.Voltar = function(this)
		self.Objs = {{texto='Inicio',aoSelecionar=self.IrParaJogo},{texto='Opcoes',aoSelecionar=self.IrParaOpcoes},{texto='Sair',aoSelecionar=self.Sair}}
		self.Selecionado =1
	end

	self.JogoOnline = function(this)
		event.post('out',{class='ncl',type='presentation',label='musica',action='stop'})
		main:TrocaEstado(4)
	end

	self.JogoMultijogador = function(this)
		event.post('out',{class='ncl',type='presentation',label='musica',action='stop'})
		main:TrocaEstado(2)
	end

	self.JogoContraComputador = function(this)
		event.post('out',{class='ncl',type='presentation',label='musica',action='stop'})
		main:TrocaEstado(2)
		main.estadoAtual.Objs.movimentador.computador = computador:Novo(main.estadoAtual.Objs.movimentador)
	end

	self.IrParaOpcoes = function(this)
		event.post('out',{class='ncl',type='presentation',label='musica',action='stop'})
		main:TrocaEstado(3)
	end

	self.Sair = function(this)
		event.post('out',{class='ncl',type='presentation',label='jogoFim',action='start'})
	end

	self.MoverParaBaixo = function(this)
		if(self.Selecionado < #self.Objs)then
			self.Selecionado=self.Selecionado+1
		else
			self.Selecionado=1
		end

	end

	self.MoverParaCima = function(this)
		if(self.Selecionado > 1)then
			self.Selecionado = self.Selecionado-1
		else
			self.Selecionado = #self.Objs
		end
	end


	self.HandlerMovimento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type == 'release' then
			if     evt.key == 'CURSOR_UP'    then
				event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='stop'})
				self:MoverParaCima()
				event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='start'})
			elseif evt.key == 'CURSOR_DOWN' then
				event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='stop'})
				self:MoverParaBaixo()
				event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='start'})
			end
		elseif(evt.type == 'press')then
			if evt.key == 'ENTER' then
				--print(evt.type)
				event.post('out',{class='ncl',type= 'presentation',label='somEfectSeleciona',action='stop'})
				event.post('out',{class='ncl',type='presentation',label='somEfectSeleciona',action='start'})
				self.Objs[self.Selecionado]:aoSelecionar()
			end
		end

	end
	----Menus

	--self.Objs = {{imagen='imagens/inicio.gif',indice=1,aoSelecionar=self.IrParaJogo},{imagen='imagens/opcoes.gif',indice=2,aoSelecionar=self.IrParaOpcoes},{imagen='imagens/sair.gif',indice=3,aoSelecionar=self.Sair}}
	self.Objs = {{texto='Inicio',aoSelecionar=self.IrParaJogo},{texto='Opcoes',aoSelecionar=self.IrParaOpcoes},{texto='Sair',aoSelecionar=self.Sair}}
	self.Selecionado =1

	event.post('out',{class='ncl',type='presentation',label='musica',action='start'})

	return self

end
