menuJogo = {}

menuJogo.Novo = function(this)
	local self = {}

	self.historicoMensagem = {}

	self.RecebeMensagem = function(self,mensg,color)
		if(mensg and color)then
			table.insert(self.historicoMensagem,1,{msg=mensg,cor=color})
			while(#self.historicoMensagem>5)do
				table.remove(self.historicoMensagem,#self.historicoMensagem)
				collectgarbage('collect')
			end
		end
	end

	self.Desenhar = function(this)
			canvas:attrColor (CORES[1])
			canvas:attrFont ('vera', 24)
			canvas:drawText(5,15,principal.estadoAtual.nomes[1] .. string.rep ('*',principal.estadoAtual.vitorias[1]))
			canvas:drawText(20,40,(12 - principal.estadoAtual.pontos[2]) .. ' pontos')
			canvas:attrColor (CORES[2])
			canvas:drawText(5,75,principal.estadoAtual.nomes[2] .. string.rep ('*',principal.estadoAtual.vitorias[2]))
			canvas:drawText(20,105,(12 - principal.estadoAtual.pontos[1]) .. ' pontos')
			for indice,obj in pairs(self.historicoMensagem)do
				canvas:attrColor(obj.cor)
				canvas:attrFont ('vera', 12)
				canvas:drawText(LARGURA-(12+canvas:measureText(obj.msg)),15+13*indice,obj.msg)
			end
	end

	self.controladorPausa = function(this)
		local controlador = {}
		controlador.pausavel = true
		controlador.opcaoSelecionada= 1

		controlador.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:drawRect('fill',LARGURA/2 - 210,ALTURA/2 - 30,420,60)
			canvas:attrColor ('black')
			canvas:attrFont ('vera', 24)
			canvas:drawText(LARGURA/2 - (canvas:measureText ('Jogo Pausado')/2),ALTURA/2-27,'Jogo Pausado')
			canvas:attrFont ('vera', 12)
			canvas:drawText(LARGURA/2 - 200+(100-canvas:measureText ('Resumir'))/2,ALTURA/2+6,'Resumir')
			canvas:drawText(LARGURA/2 - 100+(100-canvas:measureText ('Reiniciar'))/2,ALTURA/2+6,'Reiniciar')
			canvas:drawText(LARGURA/2 +(100-canvas:measureText ('Menu'))/2,ALTURA/2+6,'Menu')
			canvas:drawText(LARGURA/2 + 100+(100-canvas:measureText ('Sair'))/2,ALTURA/2+6,'Sair')
			canvas:attrColor('blue')
			canvas:drawRect('frame',LARGURA/2 -300 + 100*controlador.opcaoSelecionada ,ALTURA/2+4,100,22)
		end

		local MoveDireita = function(this)
			if(controlador.opcaoSelecionada > 3)then
				controlador.opcaoSelecionada = 1
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada +1
			end
		end
		local MoveEsquerda = function(this)
			if(controlador.opcaoSelecionada < 2)then
				controlador.opcaoSelecionada = 4
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada -1
			end
		end

		controlador.MoveCima = MoveDireita
		controlador.MoveBaixo = MoveEsquerda
		controlador.MoveDireita = MoveDireita
		controlador.MoveEsquerda = MoveEsquerda
		controlador.Selecionado = function(this)
			if(controlador.opcaoSelecionada==1)then
				principal.estadoAtual:Pausa()
			elseif(controlador.opcaoSelecionada==2)then
				principal.estadoAtual:Pausa()
				principal.estadoAtual:Inicio()
			elseif(controlador.opcaoSelecionada==3)then
				principal.estadoAtual:VoltaMenu()
			else
				principal.estadoAtual:Sair()
			end
		end

		return controlador
	end


	self.controladorFim = function(this)
		local controlador = {}
		event.post('out',{class='ncl',type= 'presentation',label='somEfectVence',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfecttVence',action='start'})

		local vitorioso = 0
		local mensagem = ''
		local vitorioso
		if(principal.estadoAtual.pontos[1] > 0)then
			vitorioso = 1
			principal.estadoAtual.vitorias[1] =principal.estadoAtual.vitorias[1] +1
		else
			vitorioso = 2
			principal.estadoAtual.vitorias[2] =principal.estadoAtual.vitorias[2] +1
		end

		if principal.estadoAtual.pontos[vitorioso] > 10 then
			mensagem = ' venceu com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
		elseif principal.estadoAtual.pontos[vitorioso] >6 then
			mensagem = ' venceu com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
		elseif principal.estadoAtual.pontos[vitorioso] >3 then
			mensagem = ' venceu com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
		else
			mensagem = ' veceu com'.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
		end

		controlador.opcaoSelecionada= 1


		controlador.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:drawRect('fill',LARGURA/2 - 200,ALTURA/2 - 30,400,60)
			canvas:attrColor ('black')
			canvas:attrFont ('vera', 24)
			canvas:drawText(LARGURA/2 - 180,ALTURA/2-27,principal.estadoAtual.nomes[vitorioso] .. mensagem)
			canvas:attrFont ('vera', 12)
			canvas:drawText(LARGURA/2 - 180+(100-canvas:measureText ('Jogar denovo'))/2,ALTURA/2+6,'Jogar denovo')
			canvas:drawText(LARGURA/2 - 60+(100-canvas:measureText ('Voltar ao menu'))/2,ALTURA/2+6,'Voltar ao menu')
			canvas:drawText(LARGURA/2 + 60+(100-canvas:measureText ('Sair'))/2,ALTURA/2+6,'Sair')
			canvas:attrColor('blue')
			canvas:drawRect('frame',LARGURA/2 -300 + 120*controlador.opcaoSelecionada ,ALTURA/2+4,100,22)
		end
		local MoveDireita = function(this)
			if(controlador.opcaoSelecionada > 2)then
				controlador.opcaoSelecionada = 1
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada +1
			end
		end
		local MoveEsquerda = function(this)
			if(controlador.opcaoSelecionada < 2)then
				controlador.opcaoSelecionada = 3
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada -1
			end
		end

		controlador.MoveCima= MoveDireita
		controlador.MoveBaixo = MoveEsquerda
		controlador.MoveDireita = MoveDireita
		controlador.MoveEsquerda = MoveEsquerda
		controlador.Selecionado = function(this)
			if(controlador.opcaoSelecionada==1)then
				principal.estadoAtual:Pausa()
				principal.estadoAtual:Inicio()
			elseif(controlador.opcaoSelecionada==2)then
				principal.estadoAtual:VoltaMenu()
			else
				principal.estadoAtual:Sair()
			end
		end

		return controlador
	end

	return self
end
