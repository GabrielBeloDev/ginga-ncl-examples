menuDeEscrita = {}

menuDeEscrita.Novo = function(this)
	local self = {}


	self.texto = {}

	self.segundoReceber = false

	self.indiceAtual = 1

	self.arrayAuxiliar = {{'a','b','c','A','B','C','1'},{'d','e','f','D','E','F','2'},{'g','h','i','G','H','I','3'},{'j','k','l','J','K','L','4'},{'m','n','o','M','N','O','5'},{'p','q','r','P','Q','R','6'},{'s','t','u','S','T','U','7'},{'v','w','x','V','W','X','8'},{'y','z','Y','Z','9','0',' '}}

	self.roda = {{input = nil}}

	self.sobeRoda = function(this)
		if(this.roda[this.indiceAtual].indice < 7)then
			this.roda[this.indiceAtual].indice = this.roda[this.indiceAtual].indice + 1
		else
			this.roda[this.indiceAtual].indice = 1
		end
	end

	self.desceRoda = function(this)
		if(this.roda[this.indiceAtual].indice < 2)then
			this.roda[this.indiceAtual].indice = 7
		else
			this.roda[this.indiceAtual].indice = this.roda[this.indiceAtual].indice - 1
		end
	end

	self.Receber = function(this,input)
		local input = tonumber(input)
		if(input)then
			if(input>0)then
				if(input == this.roda[this.indiceAtual].input)then
					this:sobeRoda()
					this.texto[this.indiceAtual] = this.arrayAuxiliar[input][this.roda[this.indiceAtual].indice]
				else
					if(this.segundoReceber)then
						this.indiceAtual = this.indiceAtual + 1
					end
					this.roda[this.indiceAtual] = {indice = 1,input= input}
					this.texto[this.indiceAtual] = this.arrayAuxiliar[input][this.roda[this.indiceAtual].indice]
					this.segundoReceber = true
				end
			elseif(input==0)then
				this.texto[this.indiceAtual] = " "

			end
		end
	end

	self.StringTexto = function(this)
		local ret = ""
		for i=1,#this.texto-1 do
			ret = ret .. this.texto[i]
		end
		local from = ret:match"^%s*()"
		return from > #ret and "" or ret:match(".*%S", from)
	end

	self.AlteraTexto = function(this,text)
		this.texto = ApagaTabela(this.texto)
		collectgarbage('collect')
		this.texto = {}
		for i = 1, string.len(text) do
			this.texto[#this.texto] = string.sub(text,i,i)
		end
	end

	self.MoveCima = function(this)
		if(this.roda[1].input)then
			this:sobeRoda()
			this.texto[this.indiceAtual] = this.arrayAuxiliar[this.roda[this.indiceAtual].input][this.roda[this.indiceAtual].indice]
		end
	end

	self.MoveBaixo = function(this)
		if(this.roda[1].input)then
			this:desceRoda()
			this.texto[this.indiceAtual] = this.arrayAuxiliar[this.roda[this.indiceAtual].input][this.roda[this.indiceAtual].indice]
		end
	end


	self.MoveDireita = function(this)
		this.segundoReceber = false
		this.indiceAtual = this.indiceAtual + 1
		if(this.indiceAtual > #this.texto)then
			this.indiceAtual = 1
		end
	end

	self.MoveEsquerda = function(this)
		this.segundoReceber = false
		this.indiceAtual = this.indiceAtual - 1
		if(this.indiceAtual < 1)then
			this.indiceAtual = #this.texto
		end
	end

	self.Desenhar = function(this)
		local texto = this:StringTexto()
		canvas:attrColor ('white')
		canvas:drawRect('fill',LARGURA/2 - 110,ALTURA/2 - 15,220,125)
		canvas:attrColor ('navy')
		canvas:attrFont ('vera', 10)
		canvas:drawText(LARGURA/2 + (20-canvas:measureText('1'))/2,ALTURA/2+24,'1')
		canvas:drawText(LARGURA/2  +20+ (20-canvas:measureText('2'))/2,ALTURA/2+24,'2')
		canvas:drawText(LARGURA/2  +40+ (20-canvas:measureText('3'))/2,ALTURA/2+24,'3')
		canvas:drawText(LARGURA/2 + (20-canvas:measureText('4'))/2,ALTURA/2 +49,'4')
		canvas:drawText(LARGURA/2  +20+ (20-canvas:measureText('5'))/2,ALTURA/2+49,'5')
		canvas:drawText(LARGURA/2  +40+ (20-canvas:measureText('6'))/2,ALTURA/2+49,'6')
		canvas:drawText(LARGURA/2 + (20-canvas:measureText('7'))/2,ALTURA/2 +75,'7')
		canvas:drawText(LARGURA/2  +20+ (20-canvas:measureText('8'))/2,ALTURA/2+75,'8')
		canvas:drawText(LARGURA/2  +40+ (20-canvas:measureText('9'))/2,ALTURA/2+75,'9')
		canvas:attrColor ('aqua')
		canvas:attrFont ('vera', 8)
		canvas:drawText(LARGURA/2 + (20-canvas:measureText('abc'))/2,ALTURA/2+35,'abc')
		canvas:drawText(LARGURA/2  +20+ (20-canvas:measureText('def'))/2,ALTURA/2+35,'def')
		canvas:drawText(LARGURA/2  +40+ (20-canvas:measureText('ghi'))/2,ALTURA/2+35,'ghi')
		canvas:drawText(LARGURA/2 + (20-canvas:measureText('jkl'))/2,ALTURA/2 +59,'jkl')
		canvas:drawText(LARGURA/2  +20+ (20-canvas:measureText('mno'))/2,ALTURA/2+59,'mno')
		canvas:drawText(LARGURA/2  +40+ (20-canvas:measureText('pqr'))/2,ALTURA/2+59,'pqr')
		canvas:drawText(LARGURA/2 + (20-canvas:measureText('stu'))/2,ALTURA/2 +85,'stu')
		canvas:drawText(LARGURA/2  +20+ (20-canvas:measureText('vwx'))/2,ALTURA/2+85,'vwx')
		canvas:drawText(LARGURA/2  +40+ (20-canvas:measureText('yz0'))/2,ALTURA/2+85,'yz0')
		canvas:attrColor ('black')
		canvas:attrFont ('vera', 24)
		canvas:drawText(LARGURA/2 - (canvas:measureText(texto))/2,ALTURA/2 -6,texto)
		canvas:attrColor ('blue')
		canvas:drawText(LARGURA/2 - (canvas:measureText(texto))/2 + canvas:measureText(texto:sub(1,this.indiceAtual-1)),ALTURA/2 -5,"_")
	end

	return self
end
