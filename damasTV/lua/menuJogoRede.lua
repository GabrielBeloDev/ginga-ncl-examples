menuJogoRede = {}

menuJogoRede.Novo = function(this)
	require 'menuJogo'
	local funcaoQueiroz = function(this)
	end

	local funcaoEsperaResposta = function(this)
		this.Selecionado = funcaoQueiroz
		this.MoveCima = funcaoQueiroz
		this.MoveBaixo = funcaoQueiroz
		this.MoveDireita = funcaoQueiroz
		this.MoveEsquerda = funcaoQueiroz
		this.Botao =  funcaoQueiroz
		this.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:attrFont('vera', 24)
			canvas:drawRect('fill',LARGURA/2 - (canvas:measureText('Esperando resposta')/2) -10,ALTURA/2 - 30,canvas:measureText ('Esperando resposta')+20,30)
			canvas:attrColor('black')
			canvas:drawText(LARGURA/2 - (canvas:measureText('Esperando resposta')/2),ALTURA/2-27,'Esperando resposta')
		end
	end

	local self = menuJogo:Novo()


	self.CriaMenuEscrita = function()
		require "menuDeEscrita"
		principal.estadoAtual:PoeSobreMenu(menuDeEscrita:Novo())
		principal.estadoAtual.controlador.Selecionado = function(this)
			local msg = principal.estadoAtual.nomes[principal.estadoAtual.jogador]..':'..principal.estadoAtual.controlador:StringTexto()
			principal.estadoAtual.Objs[2]:RecebeMensagem(msg,CORES[principal.estadoAtual.jogador],'black')
			principal.estadoAtual.conexao:Enviar('{mensagem="'..msg..'",cor="'..CORES[principal.estadoAtual.jogador]..'"}')
			principal.estadoAtual:RetiraSobreMenu()
		end
		principal.estadoAtual.controlador.Botao  = function(this)
			principal.estadoAtual:RetiraSobreMenu()
		end
	end

	self.Propor = function(this,tabelaData)
		local controlador = {}
		controlador.opcaoSelecionada = 1

		principal.estadoAtual.Objs[2]:RecebeMensagem(tabelaData.proposta,'black')
		if(not(principal.estadoAtual.animado))then
			controlador.pausado = true
		end
		controlador.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:attrFont ('vera', 24)
			canvas:drawRect('fill',LARGURA/2 - (canvas:measureText(tabelaData.proposta)/2) -10,ALTURA/2 - 30,canvas:measureText (tabelaData.proposta)+20,60)
			canvas:attrColor ('black')
			canvas:drawText(LARGURA/2 - (canvas:measureText(tabelaData.proposta)/2),ALTURA/2-27,tabelaData.proposta)
			canvas:attrFont ('vera', 12)
			canvas:drawText(LARGURA/2 - 100+(100-canvas:measureText ('Resumir'))/2,ALTURA/2+6,"Aceitar")
			canvas:drawText(LARGURA/2 +(100-canvas:measureText ('Reiniciar'))/2,ALTURA/2+6,'Declinar')
			canvas:attrColor('blue')
			canvas:drawRect('frame',LARGURA/2 -200 + 100*controlador.opcaoSelecionada ,ALTURA/2+4,100,22)
		end

		local Move = function(this)
			if(controlador.opcaoSelecionada == 1)then
				controlador.opcaoSelecionada = 2
			else
				controlador.opcaoSelecionada = 1
			end
		end

		controlador.Botao = funcaoQueiroz

		controlador.Selecionado = function(this)
			if(controlador.opcaoSelecionada==1)then
				principal.estadoAtual:Pausa()
				principal.estadoAtual.conexao:Enviar('{resposta={true}}')
				if(tabelaData.reinicio)then
					principal.estadoAtual:RetiraTodosMenus()
					principal.estadoAtual:Inicio()
					principal.estadoAtual.Objs[2]:RecebeMensagem('proposta aceita jogo reiniciado','black')
				elseif(tabelaData.empate)then
					principal.estadoAtual:RetiraTodosMenus()
					principal.estadoAtual:Fim()
				elseif(tabelaData.novoJogo)then
					principal.estadoAtual.conexao:EnviarVitorioso(tabelaData.vitorioso,true)
					principal.estadoAtual:RetiraTodosMenus()
					principal.estadoAtual:Inicio()
					principal.estadoAtual.Objs[2]:RecebeMensagem('proposta aceita novo jogo iniciado','black')
				end
			else
				principal.estadoAtual.conexao:Enviar('{resposta={false}}')
				principal.estadoAtual.Objs[2]:RecebeMensagem('proposta declinada','black')
				if(principal.estadoAtual.controlador.pausado)then
					principal.estadoAtual:RetiraSobreMenu()
				else
					principal.estadoAtual:Pausa()
				end
			end
		end

		controlador.MoveCima = Move
		controlador.MoveBaixo = Move
		controlador.MoveDireita = Move
		controlador.MoveEsquerda = Move

		return controlador
	end


	self.controladorPausa = function(this)
		local controlador = {}
		controlador.opcaoSelecionada= 1

		controlador.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:attrFont ('vera', 24)
			canvas:drawRect('fill',LARGURA/2 - 210,ALTURA/2 - 30,520,60)
			canvas:attrColor ('black')
			canvas:drawText(LARGURA/2 - (canvas:measureText ('Jogo Pausado')/2),ALTURA/2-27,'Jogo Pausado')
			canvas:attrFont ('vera', 12)
			canvas:drawText(LARGURA/2 - 200+(100-canvas:measureText ('Mensagem'))/2,ALTURA/2+6,'Mensagem')
			canvas:drawText(LARGURA/2 - 100+(100-canvas:measureText ('Resumir'))/2,ALTURA/2+6,'Resumir')
			canvas:drawText(LARGURA/2 +(100-canvas:measureText ('Reiniciar'))/2,ALTURA/2+6,'Reiniciar')
			canvas:drawText(LARGURA/2 +100+(100-canvas:measureText ('Empate'))/2,ALTURA/2+6,'Empate')
			canvas:drawText(LARGURA/2 + 200 +(100-canvas:measureText ('Sair'))/2,ALTURA/2+6,'Sair')
			canvas:attrColor('blue')
			canvas:drawRect('frame',LARGURA/2 -300 + 100*controlador.opcaoSelecionada ,ALTURA/2+4,100,22)
		end

		local MoveDireita = function(this)
			if(controlador.opcaoSelecionada > 4)then
				controlador.opcaoSelecionada = 1
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada +1
			end
		end
		local MoveEsquerda = function(this)
			if(controlador.opcaoSelecionada < 2)then
				controlador.opcaoSelecionada = 5
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada -1
			end
		end

		controlador.Botao = function(this)
			principal.estadoAtual:Pausa()
		end

		controlador.MoveCima = MoveDireita
		controlador.MoveBaixo = MoveEsquerda
		controlador.MoveDireita = MoveDireita
		controlador.MoveEsquerda = MoveEsquerda
		controlador.Selecionado = function(this)
			if(controlador.opcaoSelecionada==1)then
				self.CriaMenuEscrita()
			elseif(controlador.opcaoSelecionada==2)then
				principal.estadoAtual:Pausa()
			elseif(controlador.opcaoSelecionada==3)then
				local proposta = principal.estadoAtual.nomes[principal.estadoAtual.jogador]..": propoe reinicio"
				principal.estadoAtual.Objs[2]:RecebeMensagem(proposta,'black')
				principal.estadoAtual.conexao:Enviar('{proposta="'..proposta..'",reinicio=true}')
				this:EsperaResposta()
			elseif(controlador.opcaoSelecionada==4)then
				local proposta = principal.estadoAtual.nomes[principal.estadoAtual.jogador]..": propoe empate"
				principal.estadoAtual.Objs[2]:RecebeMensagem(proposta,'black')
				principal.estadoAtual.conexao:Enviar('{proposta="'..proposta..'",empate=true}')
				this:EsperaResposta()
			elseif(controlador.opcaoSelecionada==5)then
				principal.estadoAtual.conexao:Enviar('{sair=true}&fim=1')
			end
		end

		controlador.EsperaResposta = funcaoEsperaResposta
		controlador.RecebeResposta = function(this,resposta)
			if(resposta[1])then
				if(controlador.opcaoSelecionada==3)then
					principal.estadoAtual.Objs[2]:RecebeMensagem('proposta aceita jogo reiniciado','black')
					principal.estadoAtual:RetiraTodosMenus()
					principal.estadoAtual:Inicio()
				elseif(controlador.opcaoSelecionada==4)then
					principal.estadoAtual:RetiraTodosMenus()
					principal.estadoAtual:Fim()
				end
			else
				principal.estadoAtual.Objs[2]:RecebeMensagem('proposta declinada','black')
				principal.estadoAtual:Pausa()
			end
		end
		return controlador
	end

	self.controladorFim = function(this)
		local controlador = {}

		event.post('out',{class='ncl',type= 'presentation',label='somEfectVence',action='stop'})
		event.post('out',{class='ncl',type= 'presentation',label='somEfecttVence',action='start'})

		local mensagem = ''
		local vitorioso = nil
		if(principal.estadoAtual.pontos[1] == 0)then
			vitorioso = 2
			principal.estadoAtual.vitorias[1] =principal.estadoAtual.vitorias[2] +1
		elseif(principal.estadoAtual.pontos[2] == 0)then
			vitorioso = 1
			principal.estadoAtual.vitorias[2] =principal.estadoAtual.vitorias[1] +1
		else
			mensagem = "Empate, a disputa nao obteve conclusão"
		end

		if(vitorioso)then
			if principal.estadoAtual.pontos[vitorioso] > 10 then
				mensagem = principal.estadoAtual.nomes[vitorioso] .. mensagem..' humilhou com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
			elseif principal.estadoAtual.pontos[vitorioso] >6 then
				mensagem = principal.estadoAtual.nomes[vitorioso] .. mensagem..' venceu com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
			elseif principal.estadoAtual.pontos[vitorioso] >3 then
				mensagem = principal.estadoAtual.nomes[vitorioso] .. mensagem..' venceu com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
			else
				mensagem = principal.estadoAtual.nomes[vitorioso] .. mensagem..' venceu com '.. principal.estadoAtual.pontos[vitorioso] .. ' pontos'
			end
		else
			vitorioso = 0
		end

		principal.estadoAtual.Objs[2]:RecebeMensagem(mensagem,'black')

		controlador.opcaoSelecionada= 1

		controlador.Desenhar = function(this)
			canvas:attrColor ('white')
			canvas:drawRect('fill',LARGURA/2 - 270,ALTURA/2 - 30,520,60)
			canvas:attrColor ('black')
			canvas:attrFont ('vera', 24)
			canvas:drawText(LARGURA/2 - (canvas:measureText(mensagem)/2),ALTURA/2-27,mensagem)
			canvas:attrFont ('vera', 12)
			canvas:drawText(LARGURA/2 - 100+(100-canvas:measureText ('Mensagem'))/2,ALTURA/2+6,'Mensagem')
			canvas:drawText(LARGURA/2 +(100-canvas:measureText ('Novo Jogo'))/2,ALTURA/2+6,'Novo Jogo')
			canvas:drawText(LARGURA/2 +100+(100-canvas:measureText ('Sair'))/2,ALTURA/2+6,'Sair')
			canvas:attrColor('blue')
			canvas:drawRect('frame',LARGURA/2 -200 + 100*controlador.opcaoSelecionada ,ALTURA/2+4,100,22)
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
				controlador.opcaoSelecionada = 1
			else
				controlador.opcaoSelecionada = controlador.opcaoSelecionada -1
			end
		end

		controlador.MoveCima = MoveDireita
		controlador.MoveBaixo = MoveEsquerda
		controlador.MoveDireita = MoveDireita
		controlador.MoveEsquerda = MoveEsquerda

		controlador.Botao = funcaoQueiroz

		if(not(vitorioso))then
			vitorioso ='nil'
		end
		controlador.Selecionado = function(this)
			if(controlador.opcaoSelecionada==1)then
				self.CriaMenuEscrita()
			elseif(controlador.opcaoSelecionada==2)then
				local proposta = principal.estadoAtual.nomes[principal.estadoAtual.jogador]..": propoe novo Jogo"
				principal.estadoAtual.Objs[2]:RecebeMensagem(proposta,'black')
				principal.estadoAtual.conexao:Enviar('{proposta="'..proposta..'",novoJogo=true,vitorioso='..vitorioso..'}')
				this:EsperaResposta()
			elseif(controlador.opcaoSelecionada==3)then
				principal.estadoAtual.conexao:EnviarVitorioso(vitorioso)
			end
		end

		controlador.EsperaResposta = funcaoEsperaResposta
		controlador.RecebeResposta = function(this,resposta)
			if(resposta[1])then
				if(controlador.opcaoSelecionada==2)then
					principal.estadoAtual:Pausa()
					principal.estadoAtual.conexao:EnviarVitorioso(vitorioso,true)
					principal.estadoAtual.Objs[2]:RecebeMensagem('proposta aceita novo jogo','black')
					principal.estadoAtual:Inicio()
				end
			else
				principal.estadoAtual:Pausa()
			end
		end

		return controlador
	end

	return self
end
