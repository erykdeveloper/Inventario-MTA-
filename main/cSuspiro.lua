local screenW, screenH = guiGetScreenSize()
local resW, resH = 1920, 1080
local x, y = (screenW/resW), (screenH/resH)

font = dxCreateFont("assets/font/regular.ttf", 14, false, "antialiased")

local maxLinhas = 6
local proximaPagina = 0
local bag = {}

pos = {

    menu = {

        {'retangulo', x*825, y*704, x*409, y*61, 'use'},
        {'retangulo', x*825, y*768, x*409, y*61, 'sell'},

        {'text', 'Item', x*894, y*256, x*37, y*21, font},
        {'text', 'Quantidade', x*1089, y*256, x*92, y*21, font},
        {'text', 'Usar', x*1011, y*724, x*37, y*21, font},
        {'text', 'Enviar', x*1005, y*788, x*50, y*21, font},

    },

    categoria = {

        {'alimentos', 'retangulo', x*672, y*268, x*130, y*130, x*699, y*395, x*80, y*3},
        {'alimentos', 'imagem', x*705, y*317, x*63, y*50},
        {'alimentos', 'text', 'Alimentos', x*695, y*287, x*83, y*21},

        {'armas', 'retangulo', x*672, y*406, x*130, y*130, x*699, y*533, x*80, y*3},
        {'armas', 'imagem', x*699, y*442, x*75, y*75},
        {'armas', 'text', 'Armas', x*710, y*425, x*54, y*21},

        {'utilitarios', 'retangulo', x*672, y*544, x*130, y*130, x*697, y*671, x*80, y*3},
        {'utilitarios', 'imagem', x*710, y*593, x*50, y*50},
        {'utilitarios', 'text', 'Utilitários', x*699, y*564, x*79, y*21},

        {'drogas', 'retangulo', x*672, y*682, x*130, y*130, x*697, y*809, x*80, y*3},
        {'drogas', 'imagem', x*705, y*730, x*63, y*50},
        {'drogas', 'text', 'Drogas', x*708, y*702, x*58, y*21},

    },

    retangles = {
        {x*833, y*299, x*394, y*61, 41, 41, 41},
        {x*833, y*364, x*394, y*61, 31, 31, 31},
        {x*833, y*429, x*394, y*61, 41, 41, 41},
        {x*833, y*494, x*394, y*61, 31, 31, 31},
        {x*833, y*559, x*394, y*61, 41, 41, 41},
        {x*833, y*624, x*394, y*61, 31, 31, 31},
    },

    item = {
        {x*878, y*318, x*(878 + 155), y*(318 + 21)},
        {x*878, y*383, x*(878 + 155), y*(383 + 21)},
        {x*878, y*448, x*(878 + 155), y*(448 + 21)},
        {x*878, y*513, x*(878 + 155), y*(513 + 21)},
        {x*878, y*578, x*(878 + 155), y*(578 + 21)},
        {x*878, y*643, x*(878 + 155), y*(643 + 21)},
    },

    quantidade = {
        {x*998, y*316, x*(998 + 155), y*(316 + 21)},
        {x*998, y*381, x*(998 + 155), y*(381 + 21)},
        {x*998, y*446, x*(998 + 155), y*(446 + 21)},
        {x*998, y*511, x*(998 + 155), y*(511 + 21)},
        {x*998, y*576, x*(998 + 155), y*(576 + 21)},
        {x*998, y*641, x*(998 + 155), y*(641 + 21)},
    },

}

function bagRender()

    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 800), 'Linear')

    dxDrawRoundedRectangle(x*812, y*230, x*436, y*619, tocolor(25, 25, 25, alpha), 10)

    for i,v in ipairs(pos.menu) do 

        if v[1] == 'retangulo' then
            if mousePosition(v[2], v[3], v[4], v[5]) then
                colorMenu = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alpha)
            else
                colorMenu = tocolor(41, 41, 41, alpha)
            end

            dxDrawRoundedRectangle(v[2], v[3], v[4], v[5], colorMenu, 3)
        end

        if v[1] == 'text' then
            
            dxDrawText(v[2], v[3], v[4], (v[3] + v[5]), (v[4] + v[6]), tocolor(255, 255, 255, alpha), x*1.0, v[7], "center", "center", false, false, false, true, false)
        end
        
    end

    for i,v in ipairs(pos.categoria) do 

        if v[2] == 'retangulo' then 

            dxDrawRoundedRectangle(v[3], v[4], v[5], v[6], tocolor(25, 25, 25, alpha), 5)

            if mousePosition(v[3], v[4], v[5], v[6]) then
	            dxDrawRectangle(v[7], v[8], v[9], v[10], tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alpha), false)
            end

            if categoriaSelecionada == v[1] then
                dxDrawRectangle(v[7], v[8], v[9], v[10], tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alpha), false)
            end

        end

        if v[2] == 'imagem' then 
	        dxDrawImage(v[3], v[4], v[5], v[6], 'assets/icons/'..v[1]..'.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        end

        if v[2] == 'text' then
            dxDrawText(v[3], v[4], v[5], (v[4] + v[6]), (v[5] + v[7]), tocolor(255, 255, 255, alpha), x*1.0, font, "center", "center", false, false, false, true, false)
        end

    end

    linha = 0
	for i, v in ipairs(bag) do
        if v[1] == categoriaSelecionada then
            if v[4] == localPlayer then
                if (i > proximaPagina and linha < maxLinhas) then
                    linha = linha + 1

                    if mousePosition(pos.retangles[linha][1], pos.retangles[linha][2], pos.retangles[linha][3], pos.retangles[linha][4]) then
                        colorRetangle = tocolor(pos.retangles[linha][5] + 25, pos.retangles[linha][6] + 25, pos.retangles[linha][7] + 25, alpha)
                    else
                        colorRetangle = tocolor(pos.retangles[linha][5], pos.retangles[linha][6], pos.retangles[linha][7], alpha)
                    end
                    
                    if itemSelecionado == v[2] then
                        colorRetangle = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alpha)
                    end

                    dxDrawRoundedRectangle(pos.retangles[linha][1], pos.retangles[linha][2], pos.retangles[linha][3], pos.retangles[linha][4], colorRetangle, 5)

                    if v[2] then
                        dxDrawText(v[2], pos.item[linha][1], pos.item[linha][2], pos.item[linha][3], pos.item[linha][4], tocolor(255, 255, 255, alpha), x*1.0, font, "left", "center", false, false, false, true, false)
                    end

                    if v[3] then
                        dxDrawText(v[3]..'x', pos.quantidade[linha][1], pos.quantidade[linha][2], pos.quantidade[linha][3], pos.quantidade[linha][4], tocolor(255, 255, 255, alpha), x*1.0, font, "right", "center", false, false, false, true, false)
                    end

                end
            end
		end
	end

end

addEventHandler("onClientClick", getRootElement(), function(button,state)
    if button == "left" and state == "down" then
        if isEventHandlerAdded("onClientRender", getRootElement(), bagRender) then

            for i,v in ipairs(pos.categoria) do
                if v[2] == 'retangulo' then
                    if isMouseInPosition(v[3], v[4], v[5], v[6]) then
                        if categoriaSelecionada ~= v[1] then
                            categoriaSelecionada = v[1] 
                        else
                            categoriaSelecionada = config.categoriaNames[1]
                        end
                        playSound('assets/sounds/click.mp3')
                        itemSelecionado = nil
                        proximaPagina = 0
                    end
                end
            end

            linha = 0
            for i, v in ipairs(bag) do
                if v[1] == categoriaSelecionada then
                    if v[4] == localPlayer then
                        if (i > proximaPagina and linha < maxLinhas) then
                            linha = linha + 1
                            if isMouseInPosition(pos.retangles[linha][1], pos.retangles[linha][2], pos.retangles[linha][3], pos.retangles[linha][4]) then
                                if itemSelecionado ~= v[2] then
                                    itemSelecionado = v[2]
                                else
                                    itemSelecionado = nil
                                end
                                playSound('assets/sounds/click_2.mp3')
                            end
                        end
                    end
                end
            end

            for i,v in ipairs(pos.menu) do 
                if v[1] == 'retangulo' then
                    if isMouseInPosition(v[2], v[3], v[4], v[5]) then
                        if itemSelecionado ~= nil then
                            triggerServerEvent('Suspiro.bagInteraction', getLocalPlayer(), localPlayer, v[6], categoriaSelecionada, itemSelecionado)
                            triggerServerEvent('Suspiro.loadBagInfos', localPlayer, bag)
                            if v[6] == 'sell' then
                                open_close()
                            end
                        else
                            exports.bag_infobox:addBox('error', 'Selecione algum item.')
                        end
                        playSound('assets/sounds/click.mp3')
                    end
                end
            end

        end
    end
end)

function scroll(button)
	if (isEventHandlerAdded('onClientRender', root, bagRender)) then
        if mousePosition(x*833, y*298, x*394, y*384) then
            if (button == 'mouse_wheel_down') then
                proximaPagina = proximaPagina + 1
                if (proximaPagina > #bag - maxLinhas) then
                    proximaPagina = #bag - maxLinhas
                end
            elseif (button == 'mouse_wheel_up') then
                if (proximaPagina > 0) then
                    proximaPagina = proximaPagina - 1
                end
            end
        end
	end
end
bindKey('mouse_wheel_up', 'down', scroll)
bindKey('mouse_wheel_down', 'down', scroll)

addCommandHandler('cu', function()
    local mo = getBagItemC('Maconha')
    outputChatBox(mo)
end)

function open_close()

    if isEventHandlerAdded("onClientRender", getRootElement(), interactionRender) then
		removeEventHandler("onClientRender", getRootElement(), interactionRender)
	end

    if not isEventHandlerAdded("onClientRender", getRootElement(), bagRender) then
        playSound('assets/sounds/open.mp3')
        tick = getTickCount()
        bag = {}
        categoriaSelecionada = config.categoriaNames[1]
        itemSelecionado = nil
        triggerServerEvent('Suspiro.loadBagInfos', localPlayer, bag)
		showCursor(true)
		addEventHandler("onClientRender", getRootElement(), bagRender)
	else
		showCursor(false)
		removeEventHandler("onClientRender", getRootElement(), bagRender)
	end
    
end
bindKey('b', 'down', open_close)

addEvent('Suspiro.openCloseBag', true)
addEventHandler('Suspiro.openCloseBag', root, open_close)

addEvent('bag.insert', true)
addEventHandler('bag.insert', getRootElement(),
	function(tabelinha)
		bag = tabelinha
	end
)

function getBagItemC(item)

    triggerServerEvent('Suspiro.loadBagInfos', localPlayer)
    local itemValue = 0

    for i, v in ipairs(bag) do
        if v[2] == item then 
            itemValue = v[3]
        end
    end

    return itemValue
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius
    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)
        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing( ) ) then
      return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end
  
function mousePosition (x,y,w,h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx*resx, my*resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end
  
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
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
