package.path = package.path..';engine/?.lua'
require 'copas'
require 'constantes'
require 'jogo'
require 'jogoRede'
require 'tela'
require 'opcoes'
require 'rede'
-- objeto principal não segue o padrão dos demais objetos

principal = {}

principal.estados = {tela,game,opcoes,rede,jogoRede} --todo objeto estado tem obrigatoriamente os metodos Fazer e TrataEvento

principal.estadoAtual = principal.estados[1]:Novo()

event.register(1,principal.estadoAtual.TrataEvento)

principal.TrocaEstado = function(self,estado)
	event.unregister(self.estadoAtual.TrataEvento)
	self.estadoAtual = nil
	self.estadoAtual = self.estados[estado]:Novo()
	event.register(1,self.estadoAtual.TrataEvento)
	if(not(ANIMACAO))then
		event.register(2,principal.Frame)
	end
end

principal.ultimoClok=event.uptime()
principal.Frame = function(evt)
	if(evt)then
		principal.estadoAtual:Fazer()
	elseif(ANIMACAO)then
		if(event.uptime()-principal.ultimoClok > 100)then
			principal.ultimoClok = event.uptime()
			principal.estadoAtual:Fazer()
		end
	end
	event.timer(0,principal.Frame)
	return
end

if(not(ANIMACAO))then
	event.register(2,principal.Frame)
else
	principal:Frame()
end
