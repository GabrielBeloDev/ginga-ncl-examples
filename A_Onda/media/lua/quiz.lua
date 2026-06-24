--tabela com perguntas e respostas
local questions = { }

--respostas corretas do usuário
local score = 0

--foco do usuário
local focus = 'a'

--andamento do quiz
local question_num = 1

--dimensão do nó nclua
local width, height = canvas:attrSize()

--flag para fim de jogo
local gameOver = false

--finaliza aplicação
function gameOverSignal()
	evt = {
		class = "ncl",
		type = "presentation",
		action = "stop",

	}
	event.post(evt)
end

--trata eventos de tecla do usuário
function handleKeys(key)
	if key == 'CURSOR_UP' and not gameOver then
		if focus == 'a' then
			focus = 'd'
		elseif focus == 'b' then
			focus = 'a'
		elseif focus == 'c' then
			focus = 'b'
		elseif focus == 'd' then
			focus = 'c'
		end

		updateFocus()
		
	elseif key == 'CURSOR_DOWN' and not gameOver then
		if focus == 'a' then
			focus = 'b'
		elseif focus == 'b' then
			focus = 'c'
		elseif focus == 'c' then
			focus = 'd'
		elseif focus == 'd' then
			focus = 'a'
		end
		
		updateFocus()

	elseif key == 'ENTER' and not gameOver then
		if (questions[question_num].answer == focus) then
			score = score + 1
		end

		focus = 'a'

		if (question_num < #questions) then 
			question_num = question_num + 1

		elseif (question_num == #questions) then
			drawResult()
		end
		
		if (not gameOver) then
			drawQuestion()
		end
	
	elseif key == 'RED' or string.upper(key) == 'R' then
		local evt = { class='ncl', type='presentation', action='stop' }
		event.post(evt)
	end

	print('O foco do usuario eh: ' .. focus .. ' tecla: ' .. key)

end

--funcao tratadora de eventos de tecla
function handler(event)
	if event.class == 'key' and event.type == 'press' then
		handleKeys(event.key)
	end

end

function clearInterface()
	--azul semelhante ao menu
	canvas:attrColor(255,255,255,0)
	canvas:drawRect('fill', 0, 0, width, height)

	--cria a imagem de background
	local img_frame = canvas:new('../img/quiz/frame.png')
	local wf, hf = img_frame:attrSize()
	canvas:compose(width-wf,height-hf+60,img_frame)
	local img = canvas:new('../img/quiz/candiru2.gif')
	local wi, hi = img:attrSize()
	canvas:compose(width-wi-20,(height/2),img)
	canvas:flush()
	
end

--funcao para desenhar a interface do quiz
function drawInterface()
	--cria a imagem de background
	local img_frame = canvas:new('../img/quiz/frame.png')
	local wf, hf = img_frame:attrSize()
	canvas:compose(width-wf,height-hf+60,img_frame)
	local img = canvas:new('../img/quiz/candiru2.gif')
	local wi, hi = img:attrSize()
	canvas:compose(width-wi-20,(height/2),img)
	canvas:flush()
	
	--azul semelhante ao menu
	canvas:attrColor(136,180,245,200)
	--canvas:drawRect('fill', 0, 0, width, height)

	--titulo do quiz (com 'shading')
	local title = 'Quiz da Pororoca'
	canvas:attrColor('black')
	canvas:attrFont('vera', 21)
	local tw = canvas:measureText(title)
	canvas:drawText((width-tw)/2, 95, title)

	canvas:attrColor('white')
	canvas:attrFont('vera', 20)
	local tw2 = canvas:measureText(title)
	canvas:drawText((width-tw2)/2, 95, title)

end

function updateFocus()

	--clearInterface()

	--desenha respostas
	if(focus == 'a') then
		canvas:attrColor('red')
		canvas:drawText(35, 185, "A ] " .. questions[question_num].a)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 185, "A ] " .. questions[question_num].a)
	end
	
	if(focus == 'b') then
		canvas:attrColor('red')
		canvas:drawText(35, 205, "B ] " .. questions[question_num].b)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 205, "B ] " .. questions[question_num].b)
	end

	if(focus == 'c') then
		canvas:attrColor('red')
		canvas:drawText(35, 225, "C ] " .. questions[question_num].c)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 225, "C ] " .. questions[question_num].c)
	end

	if(focus == 'd') then
		canvas:attrColor('red')
		canvas:drawText(35, 245, "D ] " .. questions[question_num].d)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 245, "D ] " .. questions[question_num].d)
	end
end

--funcao para desenhar as perguntas
function drawQuestion()
	--limpa regiao de desenho da pergunta
	clearInterface()

	--titulo do quiz (com 'shading')
	local title = 'Quiz da Pororoca'
	canvas:attrColor('black')
	canvas:attrFont('vera', 21)
	local tw = canvas:measureText(title)
	canvas:drawText((width-tw)/2, 95, title)

	canvas:attrColor('white')
	canvas:attrFont('vera', 20)
	local tw2 = canvas:measureText(title)
	canvas:drawText((width-tw2)/2, 95, title)


	--desenha a pergunta corrente
	canvas:attrColor('white')
	canvas:attrFont('vera', 14)
	local qstr = question_num .. "] " .. questions[question_num].question

	if(string.find(qstr, "<>")) then
		i,j = string.find(qstr, "<>")
		qstr = string.gsub(qstr,"<>","")
		canvas:drawText(35, 130, string.sub(qstr,1,i))
		canvas:drawText(55, 150, string.sub(qstr,j))
	else
		canvas:drawText(35, 130, qstr)
	end


	--desenha respostas
	if(focus == 'a') then
		canvas:attrColor('red')
		canvas:drawText(35, 185, "A ] " .. questions[question_num].a)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 185, "A ] " .. questions[question_num].a)
	end
	
	if(focus == 'b') then
		canvas:attrColor('red')
		canvas:drawText(35, 205, "B ] " .. questions[question_num].b)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 205, "B ] " .. questions[question_num].b)
	end

	if(focus == 'c') then
		canvas:attrColor('red')
		canvas:drawText(35, 225, "C ] " .. questions[question_num].c)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 225, "C ] " .. questions[question_num].c)
	end

	if(focus == 'd') then
		canvas:attrColor('red')
		canvas:drawText(35, 245, "D ] " .. questions[question_num].d)
	else
		canvas:attrColor('white')
		canvas:drawText(35, 245, "D ] " .. questions[question_num].d)
	end

	--canvas:flush()
end

--desenha o resultado do quiz
function drawResult()

	clearInterface()

	--titulo do quiz (com 'shading')
	local title = 'Fim de Jogo'
	canvas:attrColor('black')
	canvas:attrFont('vera', 21)
	local tw = canvas:measureText(title)
	canvas:drawText((width-tw)/2, 95, title)

	canvas:attrColor('white')
	canvas:attrFont('vera', 20)
	local tw2 = canvas:measureText(title)
	canvas:drawText((width-tw2)/2, 95, title)

	--resultado do quiz
	canvas:attrColor('white')
	canvas:attrFont('vera', 14)
	local result = 'Você acertou ' .. score .. ' de ' .. #questions .. '.'
	canvas:drawText((width-canvas:measureText(result))/2, height/2, result)

	--análise do resultado
	if(score == #questions) then
		local msg = 'EXCELENTE!!! Você é um craque da Pororoca! :)'
		canvas:drawText((width-15-canvas:measureText(msg))/2, height/2 + 30, msg)
	elseif(score < #questions/2) then
		local msg = 'Xihh! Você precisa conhecer mais sobre a Pororoca! :('
		canvas:drawText((width-15-canvas:measureText(msg))/2, height/2 + 30, msg)
	else
		local msg = 'Parabéns, você conhece bem a Pororoca. :)'
		canvas:drawText((width-15-canvas:measureText(msg))/2, height/2 + 30, msg)
	end

	--fim de jogo e sai da aplicação após 5s
	gameOver = true
	event.timer(5000, gameOverSignal)
end

--lê perguntas do quiz a partir do arquivo
function readQuestions()
	io.input('../txt/quiz/quiz1.txt')
	local qstr =  io.read("*all")
	local num = 0

	local question = nil
	local a = nil
	local b = nil
	local c = nil
	local d = nil
	local answer = nil

	for k,v in string.gmatch(qstr, "(%w+)=\"([^//]*)\"") do
		if(k == "question") then
			num = num + 1
			question = v
		elseif(k == "a") then
			a = v
		elseif(k == "b") then
			b = v
		elseif(k == "c") then
			c = v
		elseif(k == "d") then
			d = v
		elseif(k == "answer") then
			answer = v
		end

		if(question and a and b and c and d and answer) then
			questions[num] = { question=question, a=a, b=b, c=c, d=d, answer=answer}
			question = nil
			a = nil
			b = nil
			c = nil
			d = nil
			answer = nil
		end
	end

	print("QUESTIONS: " .. #questions .. " qnum=" .. num)
end

--registra tratador de eventos
event.register(handler)

readQuestions()
drawInterface()
drawQuestion()
