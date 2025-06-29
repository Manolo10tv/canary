local CITIES = {
    ["Thais"] = {pos = Position(5010, 4998, 7)}, -- livre
    ["Carlin"] = {pos = Position(1943, 1345, 7)}, -- livre
}

local MODAL_ID = 1000
local TEMP_STORAGE_LIST = 9000

local portalStep = MoveEvent()

function portalStep.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then return true end

    local modal = ModalWindow(MODAL_ID, "Escolha seu destino", "Para onde você quer ir?")
    local tempList = {}

    for name, info in pairs(CITIES) do
        if not info.storage or player:getStorageValue(info.storage) >= (info.value or 1) then
            table.insert(tempList, name)
            modal:addChoice(#tempList - 1, name)
        end
    end

    if #tempList == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você ainda não desbloqueou nenhuma cidade.")
        return true
    end

    modal:addButton(1, "OK")
    modal:addButton(2, "Cancelar")
    modal:setDefaultEnterButton(1)
    modal:setDefaultEscapeButton(2)

    player:setStorageValue(TEMP_STORAGE_LIST, table.concat(tempList, ","))
    player:registerEvent("PortalCityTeleport")
    modal:sendToPlayer(player)
    return true
end

portalStep:type("stepin")
portalStep:uid(45000) -- ActionID do tile do portal
portalStep:register()