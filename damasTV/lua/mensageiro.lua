require 'conexaoTcp'
require 'constantesRede'

mensageiro = {}

mensageiro.Novo= function(this,funcaoRetorno)
	local self= {}
	self.funcaoRetorno = funcaoRetorno
	self.TrataDados = function(msg,connetcionData)
		if(msg == 'conectado' and self.url)then
			self.conexaoTcp:Envia('GET http://'..SERVIDOR..'/'..self.url..'\n',connetcionData)
		elseif(msg == 'recebido')then
			if(self.funcaoRetorno)then
					local iretorno = string.find(connetcionData,'return')
					if(iretorno)then
						local stringdados = string.sub(connetcionData,iretorno,string.len(connetcionData))
						local dados = loadstring(stringdados)
						self.funcaoRetorno(assert(dados)())
					else
						self.funcaoRetorno({erro=connetcionData})
					end
			end
		elseif(msg == 'erro')then
			principal:TrocaEstado(1,'Erro de conexao')
		end
	end

	self.conexaoTcp = conexaoTcp:Novo(self.TrataDados)

	self.EnviaPagina = function(this,page)
		while(self.conexaoTcp.conexaoAtiva)do
		end
		self.url = page
		self.conexaoTcp:Conecta({host=SERVIDOR,port=80})
	end

	self.Terminar = function(this)
		this.conexaoTcp:Terminar()
	end

	return self
end
