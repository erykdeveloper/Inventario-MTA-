local screenW, screenH = guiGetScreenSize()
local resW, resH = 1920, 1080
local x, y = (screenW/resW), (screenH/resH)

local font = dxCreateFont("assets/font/regular.ttf", 14, false, "antialiased")

local shopNextPage = 0
local shopMaxLinhas = 5

local shopPos = {

    button = {
        {x*768, y*653, x*383, y*54, true},
        {x*768, y*717, x*383, y*55, false},
    },

    selects = {
        {x*768, y*332, x*383, y*57, 55, 55, 55},  
        {x*768, y*389, x*383, y*57, 45, 45, 45},  
        {x*768, y*446, x*383, y*57, 55, 55, 55},  
        {x*768, y*503, x*383, y*57, 45, 45, 45},  
        {x*768, y*560, x*383, y*57, 55, 55, 55},  
    },

    textItem = {
        {x*817, y*347, x*49, y*28},  
        {x*817, y*404, x*49, y*28},  
        {x*817, y*461, x*49, y*28},  
        {x*817, y*515, x*49, y*28},  
        {x*817, y*575, x*49, y*28},  
    },

    textPrice = {
        { x*1049, y*347, x*54, y*28},  
        { x*1049, y*404, x*54, y*28},  
        { x*1049, y*461, x*54, y*28},  
        { x*1049, y*515, x*54, y*28},  
        { x*1049, y*575, x*54, y*28},  
    },

    texts = {
        {"Menu Shop", x*767, y*278, x*121, y*28, 'left'},
        {"Cancelar", x*912, y*730, x*95, y*28, 'center'},
        {"Confirmar", x*906, y*666, x*107, y*28, 'center'},
    },

}

function shopRender()

    local alphaShop = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 500), 'Linear')

    dxDrawRoundedRectangle(x*739, y*259, x*441, y*540, tocolor(41, 41, 41, alphaShop), 10)

    linha = 0
    for i,v in ipairs(config.shop[categoriaShop]) do 
        if (i > shopNextPage and linha < shopMaxLinhas) then
            linha = linha + 1

            if mousePosition(shopPos.selects[linha][1], shopPos.selects[linha][2], shopPos.selects[linha][3], shopPos.selects[linha][4]) then
                colorShopSelected = tocolor(shopPos.selects[linha][5] + 25, shopPos.selects[linha][6] + 25, shopPos.selects[linha][7] + 25, alphaShop)
            else
                colorShopSelected = tocolor(shopPos.selects[linha][5], shopPos.selects[linha][6], shopPos.selects[linha][7], alphaShop)
            end
            
            if itemShopSelect == v[1] then 
                colorShopSelected = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alphaShop)
            end

            dxDrawRoundedRectangle(shopPos.selects[linha][1], shopPos.selects[linha][2], shopPos.selects[linha][3], shopPos.selects[linha][4], colorShopSelected, 3)
            dxDrawText(v[1], shopPos.textItem[linha][1], shopPos.textItem[linha][2], (shopPos.textItem[linha][1] + shopPos.textItem[linha][3]), (shopPos.textItem[linha][2] + shopPos.textItem[linha][4]), tocolor(255, 255, 255, alphaShop), x*1, font, "left", "center", false, false, false, true, false)
            dxDrawText('$'..convertNumber(v[2]), shopPos.textPrice[linha][1], shopPos.textPrice[linha][2], (shopPos.textPrice[linha][1] + shopPos.textPrice[linha][3]), (shopPos.textPrice[linha][2] + shopPos.textPrice[linha][4]), tocolor(255, 255, 255, alphaShop), x*1, font, "left", "center", false, false, false, true, false)
        end
    end

    for i,v in ipairs(shopPos.button) do
        if mousePosition(v[1], v[2], v[3], v[4]) then
            colorShopButton = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alphaShop)
        else
            colorShopButton = tocolor(31, 31, 31, alphaShop)
        end

        dxDrawRoundedRectangle(v[1], v[2], v[3], v[4], colorShopButton, 5)
    end

	dxDrawRoundedRectangle(x*769, y*718, x*381, y*52, tocolor(41, 41, 41, alphaShop), 5)
	dxDrawRoundedRectangle(x*769, y*654, x*381, y*52, tocolor(41, 41, 41, alphaShop), 5)

    for i,v in ipairs(shopPos.texts) do 
        dxDrawText(v[1], v[2], v[3], (v[2] + v[4]), (v[3] + v[5]), tocolor(255, 255, 255, alphaShop), x*1.0, font, v[6], "center", false, false, false, true, false)
    end
    
end

addEventHandler("onClientClick", getRootElement(), function(button,state)
    if button == "left" and state == "down" then
        if isEventHandlerAdded("onClientRender", getRootElement(), shopRender) then

            linha = 0
            for i,v in ipairs(config.shop[categoriaShop]) do
                if (i > shopNextPage and linha < shopMaxLinhas) then
                    linha = linha + 1
                    if isMouseInPosition(shopPos.selects[linha][1], shopPos.selects[linha][2], shopPos.selects[linha][3], shopPos.selects[linha][4]) then
                        if itemShopSelect ~= v[1] then
                            itemShopSelect = v[1]
                        else
                            itemShopSelect = nil
                        end
                        playSound('assets/sounds/click.mp3')
                    end
                end
            end
            
            for i,v in ipairs(shopPos.button) do
                if isMouseInPosition(v[1], v[2], v[3], v[4]) then

                    if v[5] == true then
                        if itemShopSelect == nil then exports.bag_infobox:addBox('error', 'Selecione um item.') return end
                        triggerServerEvent('Suspiro.bagShopBuyItem', getLocalPlayer(), localPlayer, categoriaShop, itemShopSelect)
                    end

                    if v[5] == false then
                        showCursor(false)
                        showChat(true)
                        removeEventHandler("onClientRender", getRootElement(), shopRender)
                    end

                    playSound('assets/sounds/click.mp3')
                end
            end

        end
    end
end)

addEvent('Suspiro.bagShopOpenClose', true)
addEventHandler('Suspiro.bagShopOpenClose', root, 
    function(categoria)
        if not isEventHandlerAdded("onClientRender", getRootElement(), shopRender) then
            playSound('assets/sounds/open.mp3')
            itemShopSelect = nil
            categoriaShop = categoria
            shopNextPage = 0
            tick = getTickCount()
            showCursor(true)
            showChat(false)
            addEventHandler("onClientRender", getRootElement(), shopRender)
        else
            showCursor(false)
            showChat(true)
            removeEventHandler("onClientRender", getRootElement(), shopRender)
        end
    end
)

function shopUpDown (b)
    if isEventHandlerAdded('onClientRender', root, shopRender) then
        if isMouseInPosition(x*739, y*306, x*441, y*330) then
            if b == 'mouse_wheel_down' then
                shopNextPage = shopNextPage + 1
                if (shopNextPage > #config.shop[categoriaShop] - shopMaxLinhas) then
                    shopNextPage = #config.shop[categoriaShop] - shopMaxLinhas
                end
            elseif b == 'mouse_wheel_up'  then
                if (shopNextPage > 0) then
                    shopNextPage = shopNextPage - 1
                end
            end
        end
    end
end

bindKey('mouse_wheel_up', 'down', shopUpDown)
bindKey('mouse_wheel_down', 'down', shopUpDown)

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
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if ( k==0 ) then
            break
        end
    end
    return formatted
end