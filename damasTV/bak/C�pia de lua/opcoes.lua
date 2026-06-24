require 'fundo'
require 'constantes'

opcoes = {}

opcoes.Novo = function(this)
	local self = {}
	self.Fazer = function(this)
		fundo:DesenharFundo('imagens/opcoes.png')
		canvas:attrFont ('vera', 18)
		for i=1,#self.opcoes do
			if(i==self.menucorente)then
				canvas:attrColor('red')
			else
				canvas:attrColor('black')
			end
			canvas:drawText(100,50+50*(i) ,self.opcoes[i].nome)
			if(i<5)then
				if(i<3)then
					canvas:drawRect('frame',135 + 80*self.opcoes[i].valor ,40+50*(i),45,45)
				else
					canvas:drawRect('frame',115 + 60*self.opcoes[i].valor ,40+50*(i),45,45)
				end
			else
				if(self.opcoes[i].valor)then
					canvas:drawRect('frame',220 ,40+50*(i),100,45)
				else
					canvas:drawRect('frame',320 ,40+50*(i),100,45)
				end
			end
		end
		canvas:flush()
	end

	self.opcoes = {{valor=JOGADOR1,nome="Jogador 1"},{valor=JOGADOR2,nome="Jogador 2"},{valor=BLOCO_A,nome="Bloco A"},{valor=BLOCO_B,nome="Bloco B"},{valor=not(ORIENTACAO),nome="Orientacao"},{valor=ANIMACAO,nome="Animacao"}}
	self.menucorente=1

	self.HandlerMovimento = function(evt)
		if evt.class ~= 'key' then return end
		if evt.type ~= 'press' then return end
		if     evt.key == 'CURSOR_UP'    then
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='stop'})
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='start'})
			self:MoverParaCima()
		elseif evt.key == 'CURSOR_DOWN' then
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='stop'})
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='start'})
			self:MoverParaBaixo()
		elseif evt.key == 'CURSOR_LEFT' then
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='stop'})
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='start'})
			self:MoverParaEsquerda()
		elseif evt.key == 'CURSOR_RIGHT' then
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='stop'})
			event.post('out',{class='ncl',type= 'presentation',label='somEfectMenu',action='start'})
			self:MoverParaDireita()
		elseif evt.key == 'ENTER' then
			event.post('out',{class='ncl',type= 'presentation',label='somEfectSeleciona',action='stop'})
			event.post('out',{class='ncl',type='presentation',label='somEfectSeleciona',action='start'})
			self:Salvar()
		elseif evt.key == '' then
			event.post('out',{class='ncl',type= 'presentation',label='somEfectSopra',action='stop'})
			event.post('out',{class='ncl',type='presentation',label='somEfectSopra',action='start'})
			--self:Sair()
		end
	end

	self.MoverParaCima = function(this)
		if(self.menucorente<1)then
			self.menucorente=6
		else
			self.menucorente = self.menucorente-1
		end
	end

	self.MoverParaBaixo = function(this)
		if(self.menucorente>6)then
			self.menucorente=1
		else
			self.menucorente = self.menucorente+1
		end
	end

	self.MoverParaDireita = function(this)
		if(self.menucorente<5)then
			self:SomaMenu()
			if(self:VerificaProibido())then
				self:SomaMenu()
			end
		else
			self.opcoes[self.menucorente].valor = not(self.opcoes[self.menucorente].valor)
		end
	end

	self.MoverParaEsquerda = function(this)
		if(self.menucorente<5)then
			self:SubtraiMenu()
			if(self:VerificaProibido())then
				self:SubtraiMenu()
			end
		else
			self.opcoes[self.menucorente].valor = not(self.opcoes[self.menucorente].valor)
		end
	end

	self.Sair = function(this)
		main:TrocaEstado(1)
	end

	self.Salvar = function(this)
		local cor = {"green","red","yellow","maroon","blue"}
		local arquivo = "COR1 = '"..cor[self.opcoes[1].valor].."'\nCOR2 = '"..cor[self.opcoes[2].valor].."'\nJOGADOR1 = "
		arquivo = arquivo ..self.opcoes[1].valor.."\nJOGADOR2 = "..self.opcoes[2].valor.."\nBLOCO_A = "..self.opcoes[3].valor.."\nBLOCO_B ="
		arquivo = arquivo ..self.opcoes[4].valor.."\nBLOCO_S = 'imagens/blocos/blocoS.gif'\nBLOCO_C = 'imagens/blocos/blocoC.gif'"

		arquivo = arquivo .."\nORIENTACAO= "
		if(self.opcoes[5].valor)then
			arquivo = arquivo .."false"
		else
			arquivo = arquivo .."true"
		end

		arquivo = arquivo .."\nANIMACAO= "
		if(self.opcoes[6].valor)then
			arquivo = arquivo .. "true"
		else
			arquivo = arquivo .. "false"
		end
		file = io.open("constantes.lua","w")
		file:write(arquivo)
		file:close()
		dofile("constantes.lua")
		print(arquivo)
		self:Sair()
	end

	self.VerificaProibido = function(this)
		if(self.menucorente<3)then
			return self.opcoes[1].valor == self.opcoes[2].valor
		else
			return self.opcoes[4].valor == self.opcoes[3].valor
		end
	end

	self.SomaMenu = function(this)
		if((self.opcoes[self.menucorente].valor>4 and self.menucorente<3)or(self.opcoes[self.menucorente].valor>5 and self.menucorente>2))then
			self.opcoes[self.menucorente].valor =1
		else
			self.opcoes[self.menucorente].valor = self.opcoes[self.menucorente].valor+1
		end
	end

	self.SubtraiMenu = function(this)
		if(self.opcoes[self.menucorente].valor<2)then
			if(self.menucorente<3)then
				self.opcoes[self.menucorente].valor =5
			else
				self.opcoes[self.menucorente].valor =6
			end
		else
			self.opcoes[self.menucorente].valor = self.opcoes[self.menucorente].valor-1
		end
	end

	return self
end
