function TabelaParaString(tab)
	if(type(tab) ~= "table")then
		return nil
	end
	local str = "{"
	for indice,obj in pairs(tab) do
		if(type(indice) == "string")then
			str = str ..indice.."="
		end
		if(type(obj) =="table")then
			str = str..TabelaParaString(obj)
		elseif(type(obj) =="string") then
			str = str.."'"..obj.."'"
		elseif(type(obj) =="boolean")then
			if(obj)then
				str = str..'true'
			else
				str = str..'false'
			end
		elseif(type(obj) =="function" or type(obj) =="userdata")then
			str = str..'nil'
		else
			str = str..obj
		end
		str = str ..","
	end
	if(string.len(str)>2)then
		return string.sub(str,0,string.len(str)-1).."}"
	else
		return 'nil'
	end
end

function ApagaTabela(tab)
	if(type(tab) ~= "table")then
		tab = nil
		return nil
	else
		while(tab[#tab])do
			if(type(tab[#tab]) == 'table')then
				tab[#tab] = ApagaTabela(tab[#tab])
			else
				tab[#tab] = nil
			end
		end
	end
	return nil
end
