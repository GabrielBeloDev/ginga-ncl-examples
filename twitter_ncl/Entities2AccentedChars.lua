--http://lua-users.org/wiki/PhilippeLhoste
-- Entities2AccentedChars.lua
--
-- Convert HTML entities to corresponding accented letters.
--
-- Take one parameter: the file to convert, used as input and output.
-- Note that the file is processed as binary file, to preserve its EOLs
-- whatever the system default is.
--
-- by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
-- v. 1.1 by Manoel Campos (manoelcampos at gmail)
-- based on v. 1.0 -- 2004/06/05 -- Initial code based on ChangeFile.lua

local eol
local fileHandle

---Tabela para armazenar o mapeamento entre caracteres
--e seus respectivos códigos HTML para o charset ISO8859-1, além
--do mapeamento para sua representação em código HTML.
--Exemplos:<br/>
--código ISO8859-1: &#192;   caractere correspondente: À<br/>
--código HTML:      &Agrave; caractere correspondente: À<br/>
--<a href="http://www.lsi.usp.br/~help/html/iso.html">http://www.lsi.usp.br/~help/html/iso.html</a><br/>
--<a href="http://htmlguide.drgrog.com/alpha/isocodes.html">http://htmlguide.drgrog.com/alpha/isocodes.html</a>   
local entities =
{
	--Lista de códigos HTML para caracteres em charset ISO-8859-1, 
	--tendo formato &#NUMERO; 
    ["192"] = 'À',
    ["193"] = 'Á',
    ["194"] = 'Â',
    ["195"] = 'Ã',
    ["196"] = 'Ä',
    ["199"] = 'Ç',
    ["200"] = 'È',
    ["201"] = 'É',
    ["202"] = 'Ê',
    ["205"] = 'Í',
    ["211"] = 'Ó',
    ["212"] = 'Ô',
    ["213"] = 'Õ',
    ["224"] = 'à',
    ["225"] = 'á',
    ["226"] = 'â',
    ["227"] = 'ã',
    ["228"] = 'ä',
    ["231"] = 'ç',
    ["233"] = 'é',
    ["234"] = 'ê',
    ["237"] = 'í',
    ["243"] = 'ó',
    ["244"] = 'ô',
    ["245"] = 'õ',
    ["250"] = 'ú',   
    
	--Lista de códigos HTML para caracteres acentuados
	--e especiais, tendo formato &NOME; 
	aacute = 'á',
	agrave = 'à',
	acirc = 'â',
	auml = 'ä',
	eacute = 'é',
	egrave = 'è',
	ecirc = 'ê',
	euml = 'ë',
	icirc = 'î',
	iuml = 'ï',
	ocirc = 'ô',
	ouml = 'ö',
	ugrave = 'ù',
	ucirc = 'û',
	yuml = 'ÿ',
	Aacute = 'Á',
	Agrave = 'À',
	Acirc = 'Â',
	Auml = 'Ä',
	Eacute = 'É',
	Egrave = 'È',
	Ecirc = 'Ê',
	Euml = 'Ë',
	Icirc = 'Î',
	Iuml = 'Ï',
	Ocirc = 'Ô',
	Ouml = 'Ö',
	Ugrave = 'Ù',
	Ucirc = 'Û',
	ccedil = 'ç',
	Ccedil = 'Ç',
	Yuml = '',
	laquo = '«',
	raquo = '»',
	copy = '©',
	reg = '®',
	aelig = 'æ',
	AElig = 'Æ',
	OElig = '', -- Not understood by all browsers
	oelig = '', -- Not understood by all browsers
}


---Converte um código HTML de caractere especial ou acentuado
--para seu respectivo caractere.
--Usada como parâmetro para a função string.gsub
--dentro de @see ProcessLine
--@param entity Código a ser convertido para seu respectivo caractere
--@returns Retorna o caractere correspondente ao código passado.
local function ReplaceNamedEntity(entity)
    --Exemplo de valor para entity: &Agrave; 
    --assim, a linha abaixo remove o & e o ;
	return entities[string.sub(entity, 2, -2)] or entity
end

---Converte um código de caractere em formato HTML ISO8859-1
--para seu respectivo caractere.
--Usada como parâmetro para a função string.gsub
--dentro de @see ProcessLine
--@param entity Código a ser convertido para seu respectivo caractere
--@returns Retorna o caractere correspondente ao código passado.
local function ReplaceNumericCodeEntity(entity)
    --Exemplo de valor para entity: &#202;
    --assim, a linha abaixo remove o &# e o ;
	return entities[string.sub(entity, 3, -2)] or entity
end

---Processa uma linha (string), substituindo todos os códigos
--HTML de caracteres (em formato &#NUMERO; ou &NOME; como &#192; ou &Agrave; ) 
--para seus respectivos caracteres.
--@param line Linha (string) a ser processada
--@returns Retorna a linha (string) com os códigos HTML de caractere
--substituídos pelos seus respectivos caracteres.
local function ProcessLine(line)
	if line == nil then
		return nil
	end
	line = string.gsub(line, "&%a+;", ReplaceNamedEntity)
	line = string.gsub(line, "&#%d+;", ReplaceNumericCodeEntity)
	return line
end

---Obtem o formato de quebra de linha usada em uma string.
--Checa somente a primeira linha da string, considerando
--que a mesma é consistente.
--@param str String de onde será obtida o formato de quebra de linha.
--@returns Retorna o formato de quebra de linha obtido.
function GetEol(str)
	local eol1, eol2, eol, b
	b, _, eol1 = string.find(str, "([\r\n])")
	if b == nil then
		return nil	-- no EOL in this string
	end
	-- Care is taken in case the first line finishes with two EOLs
	eol2 = string.sub(str, b+1, b+1)
	if eol1 == '\r' then
		if eol2 == '\n' then
			-- Windows style
			eol = '\r\n'
		else
			-- Mac style
			eol = '\r'
		end
	else -- eol1 == '\n'
		-- Unix style
		eol = '\n'
	end
	return eol
end

---Converte o conteúdo de um arquivo,
--substituindo os códigos HTML para caracteres
--em seus respectivos caracteres.
--@param filename Nome do arquivo convertido.
--@returns Retorna true caso a conversão seja feita com sucesso.
--Caso contrário, retorna false e uma mensagem de erro.
function ConvertFile(filename)
	-- Read the whole file at once, to avoid clash with write
	-- Binary read, to preserve original EOLs, even if not in current system's style
	fileHandle = io.open(filename, "rb")
	if fileHandle == nil then
		return false, "open rb " .. filename
	end
	local file = fileHandle:read("*a")
	if file == nil then
		return false, "read " .. filename
	end
	fileHandle:close()

	-- Get the EOL kind for this file
	eol = GetEol(file)
	if eol == nil then
		-- Avoid to process the file, it can be binary or non-standard
		return false, "no EOL"
	end

	-- Prepare to write in the same file
	fileHandle = io.open(filename, "wb")
	if fileHandle == nil then
		return false, "open wb " .. filename
	end

	-- Loop on the lines and process them
	string.gsub(file, "(.-)" .. eol, ProcessLine)

	fileHandle:close()
	return true, nil
end

---Converte uma string,
--substituindo os códigos HTML para caracteres
--em seus respectivos caracteres.
--@param text String a ser convertida
--@returns Retorna a nova string em caso de sucesso.
--Caso contrário, retorna false e uma mensagem de erro.
function ConvertString(text)
	-- Get the EOL kind for this file
	eol = GetEol(text)
	if eol == nil then
		-- Avoid to process the file, it can be binary or non-standard
		return false, "no EOL"
	end

	-- Loop on the lines and process them
	return string.gsub(text, "(.-)" .. eol , ProcessLine)
end

