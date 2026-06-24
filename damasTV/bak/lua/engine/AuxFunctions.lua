local type,string,pairs = type,string,pairs
module("AuxFunctions")

function TableToString(tab)
	if(type(tab) ~= "table")then
		return nil
	end
	local str = "{"
	for indice,obj in pairs(tab) do
		if(type(indice) == "string")then
			str = str ..indice.."="
		end
		if(type(obj) =="table")then
			str = str..TableToString(obj)
		elseif(type(obj) =="string") then
			str = str.."'"..obj.."'"
		else
			str = str..obj
		end
		str = str ..","
	end
	return string.sub(str,0,string.len(str)-1).."}"
end

function EraseTable(tab)
	if(type(tab) ~= "table")then
		tab = nil
		return nil
	end
	for indice,obj in pairs(tab) do
		obj = EraseTable(obj)
	end
end
