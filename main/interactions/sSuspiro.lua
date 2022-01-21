blipIlegal = {}
timerBlip = {}

addEvent('Suspiro.bagSellItem', true)
addEventHandler('Suspiro.bagSellItem', root,
    function(player, id, categoria, item, quantidade)
        print(player, id, categoria, item, quantidade)
        if id then
            if tonumber(id) then

                local itemPlayer = getBagItem(player, item)
                local target = getPlayerID(tonumber(id))

                if not target then exports.bag_infobox:addBox(player, 'info', 'O jogador não foi encontrado.') return end
                --if target == player then exports.bag_infobox:addBox(player, 'error', 'Você não pode enviar um item para si mesmo.') return end
                if item == "Cash" and tonumber(quantidade) > 1 then exports.bag_infobox:addBox(player, 'error', 'Você pode vender um cash por vez') return end

                local playerX, playerY, playerZ = getElementPosition(player)
                local targetX, targetY, targetZ = getElementPosition(target)
                local playerLocal = getZoneName(playerX, playerY, playerZ, true)

                local distancia = getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ)

                if distancia >= 5 then exports.srp_infobox:addBox(player, 'error', 'Chegue mais perto do jogador.') return end

                if categoria == config.categoriaNames[2] then
                    local weaponID = getWeaponIDFromName(item)
                    for slot = 0, 12 do 
                        local weaponPlayer = getPedWeapon(player, slot)
                        local weaponAmmo = getPedTotalAmmo(player, slot)
                        if weaponPlayer > 0 and weaponAmmo > 0 then
                            if weaponPlayer == weaponID then
                                if weaponAmmo < tonumber(quantidade) then exports.bag_infobox:addBox(player, 'info', 'Você não possui '..quantidade..' munições de '..item..'.') return end
                                takeWeapon(player, weaponID, quantidade)
                                giveWeapon(target, weaponID, quantidade, true)
                                triggerEvent('Suspiro.loadBagInfos', player)
                            end
                        end
                    end
                else
                    if itemPlayer <= 0 then exports.bag_infobox:addBox(player, 'info', 'Você não possui '..item) return end
                    if itemPlayer < tonumber(quantidade) then exports.bag_infobox:addBox(player, 'info', 'Você não possui '..quantidade..' '..item..'(s).') return end 
                    takeBagItem(player, item, quantidade)
                    giveBagItem(target, item, quantidade)
                    triggerEvent('Suspiro.loadBagInfos', player)
                end
                
                if categoria == config.categoriaNames[2] or categoria == config.categoriaNames[4] then 
                    for _, targetACL in ipairs(getElementsByType("player")) do
        
                        if isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(targetACL)), aclGetGroup (config.aclPolicial)) then 

                            outputChatBox('#FFFFFF==============================', targetACL, 255, 255, 255, true)
                            outputChatBox(''..config.serverColor[4]..'['..config.serverName..' info] #FFFFFFEstá ocorrendo uma venda de '..categoria..'.', targetACL, 255, 255, 255, true)
                            outputChatBox(''..config.serverColor[4]..'['..config.serverName..' info] #FFFFFFItem: '..item, targetACL, 255, 255, 255, true)
                            outputChatBox(''..config.serverColor[4]..'['..config.serverName..' info] #FFFFFFLocalização: '..playerLocal, targetACL, 255, 255, 255, true)
                            outputChatBox(''..config.serverColor[4]..'['..config.serverName..' info] #FFFFFFGPS: '..config.vendaItens[categoria][2]..'', targetACL, 255, 255, 255, true)
                            outputChatBox('#FFFFFF==============================', targetACL, 255, 255, 255, true)

                            triggerClientEvent(targetACL, "Suspiro.bagPlaySound", targetACL, 'assets/sounds/sell.wav')
        
                            blipIlegal[player] = createBlip(playerX, playerY, playerZ, config.vendaItens[categoria][1])
                            setElementVisibleTo(blipIlegal[player], root, false) 
                            setElementVisibleTo(blipIlegal[player], targetACL, true)

                            if config.vendaItens[categoria][4] == true then
                                setElementData(blipIlegal[player], config.vendaItens[categoria][5], config.vendaItens[categoria][6])
                            end
                            
                            timerBlip[player] = setTimer(function(b)
                                if isElement(b) then
                                    destroyElement(b) 
                                end
                            end, config.vendaItens[categoria][3]*60*1000, 1, blipIlegal[player]) 

                        end
        
                        if isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(targetACL)), aclGetGroup (config.aclStaff)) then
                            outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' Staff] #FFFFFF• O jogador '..removeHex(getPlayerName(player))..' '..config.serverColor[4]..'['..(getElementData(player, config.idElement) or 0)..'] #FFFFFF enviou '..item..' ['..quantidade..'] para '..removeHex(getPlayerName(target))..' '..config.serverColor[4]..'['..(getElementData(target, config.idElement) or 0)..'] #FFFFFF.', target, 255, 255, 255, true)
                        end
        
                    end
                end
                
                outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• Você enviou uma '..item..' ['..quantidade..'] para '..removeHex(getPlayerName(target))..' '..config.serverColor[4]..'['..(getElementData(target, config.idElement) or 0)..'] #FFFFFF.', player, 255, 255, 255, true)
                outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• Você recebeu uma '..item..' ['..quantidade..'] de '..removeHex(getPlayerName(player))..' '..config.serverColor[4]..'['..(getElementData(player, 'ID') or 0)..'] #FFFFFF.', target, 255, 255, 255, true)

            end
        end
    end
)

addEvent('Suspiro.bagInteraction', true)
addEventHandler('Suspiro.bagInteraction', root,
    function(player, type, categoria, item)

        local itemPlayer = getBagItem(player, item)

        if type == 'use' then
            if categoria == config.categoriaNames[1] then
                
                if itemPlayer <= 0 then exports.bag_infobox:addBox(player, 'info', 'Você não possui '..item) return end
                
                local hunger = getElementData(player, config.hungerElement) or 0
                local sede = getElementData(player, config.sedeElement) or 0

                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == item then

                            if v[5] ==  false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser usado.') return end

                            if v[3] == 'hunger' then

                                local calculoFome = hunger + v[4]
                                if (hunger) >= 100 then exports.bag_infobox:addBox(player, 'error', 'Você não está com fome.') return end

                                outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• Você comeu um(a) '..item..' 1x.', player, 255, 255, 255, true)

                                if calculoFome >= 100 then
                                    setElementData(player, config.hungerElement, 100)
                                else
                                    setElementData(player, config.hungerElement, calculoFome)
                                end
                                
                            elseif v[3] == 'sede' then

                                local calculoSede = sede + v[4]
                                if (sede) >= 100 then exports.bag_infobox:addBox(player, 'error', 'Você não está com sede.') return end

                                outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• Você bebeu um(a) '..item..' 1x.', player, 255, 255, 255, true)

                                if calculoSede >= 100 then
                                    setElementData(player, config.sedeElement, 100)
                                else
                                    setElementData(player, config.sedeElement, calculoSede)
                                end
                                
                            end

                            takeBagItem(player, item, 1)
                            setPedAnimation(player, 'FOOD', 'eat_pizza', 4000, false,false,false,false)	

                        end
                    end
                end
                
            elseif categoria == config.categoriaNames[2] then

                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == getWeaponIDFromName(item) then
                            if v[3] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser usado.') return end
                        end
                    end
                end
                
            elseif categoria == config.categoriaNames[3] then

                if itemPlayer <= 0 then exports.bag_infobox:addBox(player, 'info', 'Você não possui '..item) return end

                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == item then
                            if v[5] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser usado.') return end

                            if v[2] == 'JBL' then
                                triggerEvent('Suspiro.jblEvent', player, player)
                            end

                            if v[7] == true then

                                local vehicle = getPedOccupiedVehicle(player)
                                if not vehicle then exports.bag_infobox:addBox(player, 'error', 'Você deve estar em um veiculo.') return end

                                if v[2] == 'Gasolina' then
                                    if tonumber(getElementData(vehicle, config.gasolinaElement) or 0) < 100 then
                                        setElementData(vehicle, config.gasolinaElement, 100)
                                        takeBagItem(player, item, 1)
                                        outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• Seu veiculo foi abastecido com sucesso.', player, 255, 255, 255, true)
                                    else
                                        outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• A gasolina do seu veiculo já está cheia.', player, 255, 255, 255, true)
                                    end
                                elseif v[2] == 'Kit' then
                                    fixVehicle(vehicle)
                                    takeBagItem(player, item, 1)
                                    outputChatBox('• '..config.serverColor[4]..'['..config.serverName..' info] #FFFFFF• Seu veiculo foi reparado com sucesso.', player, 255, 255, 255, true)
                                elseif v[2] == 'Radinho' then
                                    triggerClientEvent(player, 'Suspiro.openCloseRadioC', player)
                                end

                            end
                        end
                    end
                end

            elseif categoria == config.categoriaNames[4] then

                if itemPlayer <= 0 then exports.bag_infobox:addBox(player, 'info', 'Você não possui '..item) return end

                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == item then
                            if v[3] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser usado.') return end
                            triggerEvent('Suspiro.bagDrugS', player, player, item)
                        end
                    end
                end

            end

        elseif type == 'sell' then

            if categoria == config.categoriaNames[1] then
                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == item then
                            if v[6] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser enviado.') return end
                            triggerClientEvent(player, 'Suspiro.bagInteractionPanel', player)
                        end
                    end
                end
            elseif categoria == config.categoriaNames[2] then
                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == getWeaponIDFromName(item) then
                            if v[6] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser enviado.') return end
                            triggerClientEvent(player, 'Suspiro.bagInteractionPanel', player)
                        end
                    end
                end
            elseif categoria == config.categoriaNames[3] then
                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == item then
                            if v[4] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser enviado.') return end
                            triggerClientEvent(player, 'Suspiro.bagInteractionPanel', player)
                        end
                    end
                end
            elseif categoria == config.categoriaNames[4] then
                for i,v in ipairs(config['itens']) do
                    if v[1] == categoria then
                        if v[2] == item then
                            if v[4] == false then exports.bag_infobox:addBox(player, 'error', 'Este item não pode ser enviado.') return end
                            triggerClientEvent(player, 'Suspiro.bagInteractionPanel', player)
                        end
                    end
                end
            end

        end

    end
)

addEventHandler("onPlayerQuit", root, 
    function()

        if isElement(blipIlegal[source]) then
            destroyElement(blipIlegal[source])
            blipIlegal[source] = {}
        end

        if isElement(timerBlip[source]) then
            destroyElement(timerBlip[source])
            timerBlip[source] = {}
        end
        
    end
)

function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "ID") == id then
			v = player
			break
		end
	end
	return v
end

function convertNumber ( number )
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if ( k==0 ) then
            break
        end
    end
    return formatted
end 

function removeHex(s)   
    if type(s) == "string" then
        while(string.find(s, "#%x%x%x%x%x%x")) do
            s = string.gsub(s, "#%x%x%x%x%x%x","")
        end
    end
    return s
  end