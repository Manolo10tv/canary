local cities = {
    ["Thais"] = {pos = Position(5010, 4998, 7)},
    ["Carlin"] = {pos = Position(1943, 1345, 7)},
}

local modalTeleport = CreatureEvent("PortalCityTeleport")

function modalTeleport.onModalWindow(player, modalWindowId, buttonId, choiceId)
    if modalWindowId ~= 1000 or buttonId ~= 1 then return false end

    local listString = player:getStorageValue(9000)
    if not listString or listString == -1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Erro ao recuperar lista de cidades.")
        return true
    end

    -- Indexa por ID exato do modal
    local list = {}
    local index = 0
    for name in string.gmatch(listString, '([^,]+)') do
        list[index] = name
        index = index + 1
    end

    local chosenName = list[choiceId]
    if not chosenName then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Escolha inválida.")
        return true
    end

    local data = cities[chosenName]
    if data and data.pos then
        player:teleportTo(data.pos)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Destino inválido.")
    end
    return true
end

modalTeleport:register()