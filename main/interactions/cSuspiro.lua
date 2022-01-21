local screenW, screenH = guiGetScreenSize()
local resW, resH = 1920, 1080
local x, y = (screenW/resW), (screenH/resH)

local font = dxCreateFont("assets/font/regular.ttf", 13, false, "antialiased")
local fontIcon = dxCreateFont("assets/font/icons.otf", 11, false, "antialiased")

local idText = createElement("BagEditBoxTexto")
local amountText = createElement("BagEditBoxTexto")

local pos = {

    button = {
        {x*739, y*564, x*441, y*54, true},
        {x*739, y*625, x*441, y*54, false},
    },

    icon = {
        {"", x*1129, y*466, x*18, y*18, idText},
        {"", x*1129, y*517, x*18, y*18, amountText},
    },

    text = {
        {"Confirmar", x*912, y*578, x*98, y*26, font},
        {"Cancelar", x*917, y*639, x*87, y*26, font},
    },

    ebox = {
        {x*761, y*454, x*399, y*41, x*761, y*492, x*399, y*3},
        {x*761, y*505, x*399, y*41, x*761, y*543, x*399, y*2},
    },
    
}

function interactionRender()

    local alphaInteraction = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 800), 'Linear')

	dxDrawRoundedRectangle(x*721, y*381, x*478, y*318, tocolor(41, 41, 41, alphaInteraction), 10)
    dxDrawRectangle(x*742, y*432, x*436, y*2, tocolor(110, 110, 110, alphaInteraction), false)

    dxDrawText('Enviar Item ['..itemSelecionado..']', x*740, y*395, x*(740 + 110), y*(395 + 26), tocolor(255, 255, 255, alphaInteraction), x*1.0, font, "left", "center", false, false, false, true, false)

    for i, v in ipairs(pos.button) do  
        
        if mousePosition(v[1], v[2], v[3], v[4]) then
            colorButton = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alphaInteraction)
        else
            colorButton = tocolor(31, 31, 31, alphaInteraction)
        end

        dxDrawRoundedRectangle(v[1], v[2], v[3], v[4], colorButton, 5)
    end

	dxDrawRoundedRectangle(x*741, y*626, x*437, y*52, tocolor(41, 41, 41, alphaInteraction), 3)
	dxDrawRoundedRectangle(x*741, y*565, x*437, y*52, tocolor(41, 41, 41, alphaInteraction), 3)

    for i, v in ipairs(pos.ebox) do 
        
        if mousePosition(v[1], v[2], v[3], v[4]) then
            colorLine = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alphaInteraction)
        else
            colorLine = tocolor(110, 110, 110, alphaInteraction)
        end

        dxDrawRectangle(v[5], v[6], v[7], v[8], colorLine, false)
    end

    for i, v in ipairs(pos.text) do 
        dxDrawText(v[1], v[2], v[3], (v[2] + v[4]), (v[3] + v[5]), tocolor(255, 255, 255, alphaInteraction), x*1.0, v[6], "center", "center", false, false, false, true, false)
    end

    for i, v in ipairs(pos.icon) do 

        if mousePosition(v[2], v[3], (v[2] + v[4]), (v[3] + v[5])) then
            colorIcon = tocolor(255, 255, 255, 200)
        else
            colorIcon = tocolor(255, 255, 255, 150)
        end

        dxDrawText(v[1], v[2], v[3], (v[2] + v[4]), (v[3] + v[5]), colorIcon, x*1.0, fontIcon, "center", "center", false, false, false, true, false)
    end

	dxDrawEditBox("ID do Jogador", x*761, y*454, x*399, y*41, false, 10, idText)
	dxDrawEditBox("Quantidade", x*761, y*505, x*399, y*41, false, 10, amountText)

end

addEventHandler("onClientClick", getRootElement(), function(button,state)
    if button == "left" and state == "down" then
        if isEventHandlerAdded("onClientRender", getRootElement(), interactionRender) then

            for i,v in ipairs(pos.button) do
                if isMouseInPosition(v[1], v[2], v[3], v[4]) then 

                    if v[5] == true then

                        local jogadorInteraction = getElementData(idText, "BagTexto") or ""
                        local quantidadeInteraction = getElementData(amountText, "BagTexto") or ""

                        if jogadorInteraction ~= "" then
                            if quantidadeInteraction ~= "" then
                                if tonumber(jogadorInteraction) and tonumber(quantidadeInteraction) then
                                    if tonumber(quantidadeInteraction) <= 0 then exports.bag_infobox:addBox('info', 'Digite uma quantidade maior que 0.') return end
                                    triggerServerEvent('Suspiro.bagSellItem', getLocalPlayer(), localPlayer, jogadorInteraction, categoriaSelecionada,itemSelecionado, quantidadeInteraction)
                                    openClose()
                                else
                                    exports.bag_infobox:addBox('error', 'Apenas números.')
                                end
                            else
                                exports.bag_infobox:addBox('error', 'Digite uma quantidade válida.')
                            end
                        else
                            exports.bag_infobox:addBox('error', 'Digite um ID válido.')
                        end

                    elseif v[5] == false then
                        openClose()
                    end

                    playSound('assets/sounds/click_2.mp3')
                end
            end

            for i, v in ipairs(pos.icon) do 
                if isMouseInPosition(v[2], v[3], v[4], v[5]) then 
                    if (getElementData(v[6], "BagTexto") or "") ~= "" then
                        setElementData(v[6], "BagTexto", "")
                    end
                    playSound('assets/sounds/click_2.mp3')
                end
            end

        end
    end
end)

function openClose()
    if not isEventHandlerAdded("onClientRender", getRootElement(), interactionRender) then
        playSound('assets/sounds/open.mp3')
        tick = getTickCount()
        setElementData(idText, "BagTexto", "")
        setElementData(amountText, "BagTexto", "")
		showCursor(true)
        showChat(false)
		addEventHandler("onClientRender", getRootElement(), interactionRender)
	else
		showCursor(false)
        showChat(true)
		removeEventHandler("onClientRender", getRootElement(), interactionRender)
	end
end

addEvent('Suspiro.bagInteractionPanel', true)
addEventHandler('Suspiro.bagInteractionPanel', root, openClose)

addEvent("Suspiro.bagPlaySound", true)
addEventHandler("Suspiro.bagPlaySound", root,
    function(file)
        playSound(file)
    end
)

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