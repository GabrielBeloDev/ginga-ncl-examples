package.path = package.path..';engine/?.lua'
require 'copas'
require 'constantes'
require 'game'
require 'tela'
require 'opcoes'
require 'online'
-- objeto principal não segue o padrão dos demais objetos

main = {}

main.estados = {tela,game,opcoes,online} --todo objeto estado tem obrigatoriamente os metodos Fazer e HandlerMovimento

main.estadoAtual = main.estados[1]:Novo()

event.register(1,main.estadoAtual.HandlerMovimento)

main.TrocaEstado = function(self,estado)
	event.unregister(self.estadoAtual.HandlerMovimento)
	self.estadoAtual = nil
	self.estadoAtual = self.estados[estado]:Novo()
	event.register(1,self.estadoAtual.HandlerMovimento)
	print("torcando estado para"..estado)
	if(not(ANIMACAO))then
		event.register(2,main.Frame)
	end
end


main.Frame = function(evt)
	main.estadoAtual:Fazer()
	if(ANIMACAO)then
		event.timer(100,main.Frame)
	end
end

if(not(ANIMACAO))then
	event.register(2,main.Frame)
else
	main:Frame()
end
