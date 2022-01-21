connection = dbConnect('sqlite', 'database.db')
dbExec(connection, 'create table if not exists ITENS (user, categoria, item, quantidade)')

addEvent('Suspiro.loadBagInfos', true)
addEventHandler('Suspiro.loadBagInfos', getRootElement(),
	function()
		
		tabela = {}

        local result = dbPoll(dbQuery(connection, 'select * from ITENS where user = ?', getAccountName(getPlayerAccount(source))), - 1)

        if (#result ~= 0) then
            for i, v in ipairs(result) do
                table.insert(tabela, {v['categoria'], v['item'], v['quantidade'], source})
            end
        end

        for slot = 0, 12 do
            local Armas = getPedWeapon ( source, slot )
            local Municao = getPedTotalAmmo ( source, slot ) 
            if Armas > 0 then
                if Municao > 0 then
                    weapon_nome = getWeaponNameFromID ( Armas )
                    for i,v in ipairs(config['itens']) do
                        if v[1] == config.categoriaNames[2] then
                            if Armas == v[2] then
                                table.insert(tabela, {config.categoriaNames[2], weapon_nome, Municao, source}) 
                            end
                        end
                    end
                    
                end     
            end
        end

		triggerClientEvent(source, 'bag.insert', source, tabela)

    end
)

addCommandHandler(config.commandGiveItem, 
    function(source, cmd, id, item, qntd)
        if isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup (config.aclAdmin)) then
            if (item) and (qntd) and (id) then
                if tonumber(id) then
                    local target = getPlayerID(tonumber(id))
                    if target then
                        local quantidade = tonumber(qntd)
                        if quantidade > 0 then
                            if isItemValid(item) == true then 
                                giveBagItem(target, item, quantidade) 
                                exports.bag_infobox:addBox(source, 'success', 'Você enviou '..item..' '..quantidade..'x para '..removeHex(getPlayerName(target))..' ['..id..'].')
                            else
                                exports.bag_infobox:addBox(source, 'error', 'O item não existe.')
                            end
                        else
                            exports.bag_infobox:addBox(source, 'error', 'Digite uma quantidade maior que 0.')
                        end
                    else
                        exports.bag_infobox:addBox(source, 'error', 'O jogador não foi encontrado.')
                    end
                else
                    exports.bag_infobox:addBox(source, 'error', 'Digite um ID numérico.')
                end
            else
                exports.bag_infobox:addBox(source, 'error', 'Use /giveitem id item quantidade.')
            end
        else
            exports.bag_infobox:addBox(source, 'error', 'Você não tem permissão.')
        end
    end
)

addCommandHandler(config.commandTakeItem, 
    function(source, cmd, id, item, qntd)
        if isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup (config.aclAdmin)) then
            if (item) and (qntd) and (id) then
                if tonumber(id) then
                    local target = getPlayerID(tonumber(id))
                    if target then
                        local quantidade = tonumber(qntd)
                        if quantidade > 0 then
                            if isItemValid(item) == true then 
                                if getBagItem(target, item) <= 0 then exports.bag_infobox:addBox(source, 'error', 'O jogador não possui este item.') return end
                                takeBagItem(target, item, quantidade) 
                                exports.bag_infobox:addBox(source, 'success', 'Você removeu '..item..' '..quantidade..'x de '..removeHex(getPlayerName(target))..' ['..id..'].')
                            else
                                exports.bag_infobox:addBox(source, 'error', 'O item não existe.')
                            end
                        else
                            exports.bag_infobox:addBox(source, 'error', 'Digite uma quantidade maior que 0.')
                        end
                    else
                        exports.bag_infobox:addBox(source, 'error', 'O jogador não foi encontrado.')
                    end
                else
                    exports.bag_infobox:addBox(source, 'error', 'Digite um ID numérico.')
                end
            else
                exports.bag_infobox:addBox(source, 'error', 'Use /takeitem id item quantidade.')
            end
        else
            exports.bag_infobox:addBox(source, 'error', 'Você não tem permissão.')
        end
    end
)

function giveBagItem(player, item, qntd)
    if isItemValid(item) == true then

        local result = dbPoll(dbQuery(connection, 'select * from ITENS where user = ? AND item = ? ', getAccountName(getPlayerAccount(player)), item), - 1)
        local categoria = getItemCategoria(item)

        if (#result ~= 0) then  
            for i, v in ipairs(result) do
                
                if item == v['item'] then
                    dbExec(connection, "UPDATE ITENS SET quantidade = ? WHERE user = ? AND item =  ?", v['quantidade'] + tonumber(qntd), getAccountName(getPlayerAccount(player)), item)
                else
                    dbExec(connection, 'insert into ITENS (user, categoria, item, quantidade) values(?, ?, ?, ?)', getAccountName(getPlayerAccount(player)), categoria, item, tonumber(qntd))
                end
                
            end
        else
            dbExec(connection, 'insert into ITENS (user, categoria, item, quantidade) values(?, ?, ?, ?)', getAccountName(getPlayerAccount(player)), categoria, item, tonumber(qntd))
        end

        triggerEvent('Suspiro.loadBagInfos', player, bag)
    end
end

function takeBagItem(player, item, qntd)
    if isItemValid(item) == true then

        local result = dbPoll(dbQuery(connection, 'select * from ITENS where user = ? AND item = ? ', getAccountName(getPlayerAccount(player)), item), - 1)
        local categoria = getItemCategoria(item)

        if (#result ~= 0) then  
            for i, v in ipairs(result) do
                
                if item == v['item'] then
                    if tonumber(qntd) >= v['quantidade'] then
                        dbExec(connection, 'delete from ITENS where user = ? and item = ?', getAccountName(getPlayerAccount(player)), v['item'])
                    else
                        dbExec(connection, "UPDATE ITENS SET quantidade = ? WHERE user = ? AND item =  ?", v['quantidade'] - tonumber(qntd), getAccountName(getPlayerAccount(player)), item)
                    end
                end
                
            end
        end
        triggerEvent('Suspiro.loadBagInfos', player, bag)

    end
end

function getBagItem(player, item)
    local result = dbPoll(dbQuery(connection, 'select * from ITENS where user = ? AND item = ? ', getAccountName(getPlayerAccount(player)), item), - 1)
    if (#result ~= 0) then
        for i, v in ipairs(result) do
            if v['item'] == item then
                if v['quantidade'] > 0 then
                    return v['quantidade']
                else
                    return 0
                end 
            end
        end
    end
    return 0
end

function getAllBagItens(player)
    local itemTable = {}
    for _, v in ipairs(config.itens) do
        if type(v[2]) == 'string' then
            local item = getBagItem(player, v[2]) or 0
            if (item > 0) then
                table.insert(itemTable, {name = v[2], item = v[2], quantidade = item})
            end
        else
            for slot = 0, 12 do
                local Armas = getPedWeapon ( player, slot )
                local Municao = getPedTotalAmmo ( player, slot ) 
                if Armas > 0 then
                    if Municao > 0 then
                        if Armas == v[2] then
                            local weapon_nome = getWeaponNameFromID ( Armas )
                            table.insert(itemTable, {name = weapon_nome, item = v[2], quantidade = Municao}) 
                        end
                    end     
                end
            end
        end
        
    end
    return itemTable
end

-- Utils 

function getItemCategoria(item)
    for i,v in ipairs(config.itens) do
        if item == v[2] then 
            return v[1]
        end
    end
end

function isItemValid(item) 
    for i,v in ipairs(config.itens) do
        if v[2] == item then 
            return true
        end
    end
    return false
end


function convertNumber ( number )
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
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