config = {

    aclAdmin = 'Admin', -- ACL Admin para dar item
    aclStaff = 'STAFF', -- ACL Staff
    aclPolicial = 'Policial', -- ACL Policial

    serverName = 'BSR RPG/FIVEM', -- Tag do Servidor
    serverColor = {0, 205, 0, "#00CD00"}, -- Cor do servidor em RGB e o Código
    
    idElement = 'ID', -- elementdata do ID
    gasolinaElement = 'fuel', -- elementdata da Gasolina
    hungerElement = 'fomeSede', -- elementdata da Fome
    sedeElement = 'fomeSede', -- elementdata da Sede

    commandGiveItem = 'giveitem', -- Comando para dar item a um jogador
    commandTakeItem = 'takeitem', -- Comando para tirar item a um jogador
    
    vendaItens = {
        ['drogas'] = {56, 'Bandeira Vermelha', 2, true, 'blipName', 'Venda de Drogas'}, -- ID do Blip ao vender Droga // Apelido do Blip para policiais // Tempo em minutos do Blip // TRUE para nome do blip no F11
        ['armas'] = {56, 'Bandeira Vermelha', 2, true, 'blipName', 'Venda de Armas'}, -- ID do Blip ao vender Droga // Apelido do Blip para policiais // Tempo em minutos do Blip // TRUE para nome do blip no F11
    },

    shop = {

        ['alimentos'] = {
            {'Hambúrguer', 300, 15}, -- Item // Preço // Quantidade máxima
            {'HotDog', 300, 15}, -- Item // Preço // Quantidade máxima
            {'Pizza', 300, 15}, -- Item // Preço // Quantidade máxima
            {'Coxinha', 300, 15}, -- Item // Preço // Quantidade máxima
            {'Água', 250, 15}, -- Item // Preço // Quantidade máxima
            {'Refrigerante', 250, 15}, -- Item // Preço // Quantidade máxima
            {'Cerveja', 600, 15}, -- Item // Preço // Quantidade máxima
            {'RedBull', 400, 15}, -- Item // Preço // Quantidade máxima
        },

        ['utilitarios'] = {
            {'Kit', 10000, 15}, -- Item // Preço // Quantidade 
		
        },

        ['Markers'] = { 
            {'alimentos', 2119.4, -1799.4, 13.6, 29}, -- Categoria // Local X, Y, Z // BLIP
			{'alimentos', 279.2, -1434.9, 14.0, 29}, -- Categoria // Local X, Y, Z // BLIP
			{'alimentos', 1367.1805419922,248.47720336914,19.566932678223, 10}, -- Categoria // Local X, Y, Z // BLIP			
			{'alimentos', -2104.27734375,-2342.13671875,30.617206573486	, 10}, -- Categoria // Local X, Y, Z // BLIP	
			{'alimentos', -2767.578125,788.79949951172,52.78125	, 10}, -- Categoria // Local X, Y, Z // BLIP	
			{'alimentos', -144.008, 1224.871, 19.899	, 10}, -- Categoria // Local X, Y, Z // BLIP	
			{'alimentos', -857.60559082031,1535.7019042969,22.587043762207	, 10}, -- Categoria // Local X, Y, Z // BLIP	,
			
			{'utilitarios', 2519.52, -1680.996, 14.704			, 47}, -- Categoria // Local X, Y, Z // BLIP		
        },
        
    },

    itens = { 

        -- // ALIMENTOS \\ --
        {'alimentos', 'Hambúrguer', 'hunger', 25, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'HotDog', 'hunger', 20, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'Pizza', 'hunger', 15, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'Coxinha', 'hunger', 10, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'Água', 'sede', 25, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'Refrigerante', 'sede', 20, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'Cerveja', 'sede', 15, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        {'alimentos', 'RedBull', 'sede', 10, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
		{'alimentos', 'Tubainas', 'sede', 10, true, true}, -- Categoria do Item // Item // Tipo // Quantidade que alimenta // TRUE para usar // TRUE para enviar
        -- // ARMAS \\ --
        {'armas', 6, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 22, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 23, false, false}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 24, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 25, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 26, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 27, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 29, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 32, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 30, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 31, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 33, false, false}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 34, false, false}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'armas', 14, false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar

        -- // UTILITÁRIOS \\ --
        {'utilitarios', 'Kit', 10000, 15, true, false, true}, -- Categoria do Item // Item // Preço na Loja // Quantidade máxima // TRUE para usar // TRUE para enviar // TRUE para usar somente em veiculos
        {'utilitarios', 'Cash', 10000, 1, true, false, true}, -- Categoria do Item // Item // Preço na Loja // Quantidade máxima // TRUE para usar // TRUE para enviar // TRUE para usar somente em veiculos

        -- // DROGAS \\ --
        {'drogas', 'maconha', true, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
        {'drogas', 'cocaina', true, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar
		{'drogas', 'crack', false, true}, -- Categoria do Item // Item // TRUE para usar // TRUE para enviar

    },

    categoriaNames = {
        [1] = 'alimentos',
        [2] = 'armas',
        [3] = 'utilitarios',
    },

}

