require "compat"  -- restaura module()/setfenv() do Lua 5.1 (ver compat.lua)
package.path = package.path..';engine/?.lua'
require 'constantes'
require 'jogo'
require 'jogoRede'
require 'tela'
require 'opcoes'
require 'rede'
require "FuncoesAuxiliares"
-- objeto principal não segue o padrão dos demais objetos

principal = {}

principal.estados = {tela,jogo,opcoes,rede,jogoRede} --todo objeto estado tem obrigatoriamente os metodos Fazer e TrataEvento

principal.estadoAtual = principal.estados[1]:Novo()

--event.register(1,principal.estadoAtual.TrataEvento)

principal.TrocaEstado = function(self,estado,argumentos)
	--event.unregister(self.estadoAtual.TrataEvento)
	self.estadoAtual = ApagaTabela(self.estadoAtual)
	collectgarbage('collect')
	self.estadoAtual = self.estados[estado]:Novo(argumentos)
	--event.register(1,self.estadoAtual.TrataEvento)
	event.register(2,principal.Frame)
end

principal.ultimoClokE=event.uptime()
principal.TrataEvento = function(evt)
	if(event.uptime()-principal.ultimoClokE > 200)then
		principal.estadoAtual.TrataEvento(evt)
		principal.ultimoClokE = event.uptime()
		if(not(ANIMACAO and principal.estadoAtual.animado))then
			principal:Frame()
		end
	end
	return
end
event.register(1,principal.TrataEvento)

principal.ultimoClok=event.uptime()
memoryUse = collectgarbage('count')
principal.Frame = function(evt)
	collectgarbage('collect')
	if(evt)then
		principal.estadoAtual:Fazer()
		principal.ultimoClok = event.uptime()
	end
	if(ANIMACAO and principal.estadoAtual.animado)then
		if(event.uptime()-principal.ultimoClok > 100)then
			principal.ultimoClok = event.uptime()
			principal.estadoAtual:Fazer()
		end
		event.timer(100,principal.Frame)
	end
	if(collectgarbage('count') - memoryUse~=0)then
		--print('memoria anterior '.. memoryUse..'memoria total usada'..collectgarbage('count'))
		memoryUse =collectgarbage('count')
	end
	return
end


principal:Frame()
