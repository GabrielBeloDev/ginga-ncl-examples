--Função para controlar os eventos da aplicação.
--Leva em consideração a tela atual.
function handlerControle ( evt )

	if evt.type == 'release' then

		if evt.key == 'RED' or string.upper(evt.key) == 'R' then
				
			local evt = { class='ncl', type='presentation', action='stop' }
			event.post(evt)
			
		end

	
		if _Ctrl == 'Regiao' then
		
			if evt.key == '1' or evt.key == '2' or evt.key == '3' or evt.key == '4' or evt.key == '5' then
				
				_Ctrl = 'Estado'
				desenharTela()
				_Regiao = evt.key
				printEstados( _page , _Regiao )
				
			end
			
		elseif _Ctrl == 'Estado' then
			
			if evt.key == '1' or evt.key == '2' or evt.key == '3' or evt.key == '4' or evt.key == '5' then
				
				if tonumber(evt.key) <= _limiteSuperior then

					_Ctrl = 'Previsao'
					
					local vEstado = nil
					if _page == 1 then
						vEstado = tonumber(evt.key)
					else
						vEstado = ((_page - 1) * 5) + tonumber(evt.key)
					end

					printPrevisao( _Regiao , vEstado )
					
				end
				
			elseif evt.key == 'CURSOR_UP' then
				
				_page = _page - 1
				
				if _page < _TotalPage then _page = 1 end
				
				print(_page)
				desenharTela()
				printEstados( _page , _Regiao )
					
			
			elseif evt.key == 'CURSOR_DOWN' then
				_page = _page + 1

				if _page > _TotalPage then _page = _TotalPage end
				
				print(_page)
				desenharTela()
				printEstados( _page , _Regiao )
			
			elseif evt.key == 'GREEN' or string.upper(evt.key) == 'G' then
				
				_Ctrl = 'Regiao'
				_Regiao = nil
				_page = 1
				desenharTela()
				printRegiao()
				
			end
		
		elseif _Ctrl == 'Previsao' then
		
			if evt.key == 'GREEN' or string.upper(evt.key) == 'G' then
				
				_Ctrl = 'Estado'
				desenharTela()
				printEstados( _page , _Regiao )
				
			end
			
		end
		
		
	end
	
end
