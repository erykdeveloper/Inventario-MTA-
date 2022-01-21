shopMarker = {}

addEvent('Suspiro.bagShopBuyItem', true)
addEventHandler('Suspiro.bagShopBuyItem', root, 
    function(player, categoria, item)
        for i,v in ipairs(config.shop[categoria]) do
            if v[1] == item then

                local playerItem = getBagItem(player, item)
                local playerMoney = getPlayerMoney(player)
                
                if playerMoney < v[2] then exports.bag_infobox:addBox(player, 'info', 'Dinheiro insuficiente. Custo: $'..convertNumber(v[2])) return end
                if (playerItem) >= v[3] then exports.bag_infobox:addBox(player, 'error', 'Você já atingiu o limite deste item.') return end
                
                giveBagItem(player, item, 1)
                takePlayerMoney(player, v[2])

                exports.bag_infobox:addBox(player, 'success', 'Você comprou um '..item..' por $'..convertNumber(v[2]))

            end
        end
    end
)

for i,v in ipairs(config.shop['Markers']) do

    shopMarker[i] = createMarker(v[2], v[3], v[4] -1, 'cylinder', 1.3, config.serverColor[1], config.serverColor[2], config.serverColor[3], 50)

    addEventHandler('onMarkerHit', shopMarker[i],
        function(source)
            triggerClientEvent(source, 'Suspiro.bagShopOpenClose', source, v[1])
        end
    )

    blip = createBlip(v[2], v[3], v[4], v[5])
    setElementVisibleTo(blip, root, true)

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