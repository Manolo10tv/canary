local config = {
    storage = 10005,
    actionId = 49279,
    minLevel = 800,
    newVocationId = 10,
    nameChange = {from = "Void", to = "Void Mister"}
}

local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.actionid ~= config.actionId then
        return false
    end

    if player:getStorageValue(config.storage) >= 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você já recebeu essa promoção.")
        return true
    end

    if player:getLevel() < config.minLevel then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa ter level " .. config.minLevel .. " para receber esta promoção.")
        return true
    end

    -- Troca de vocação
    player:setVocation(Vocation(config.newVocationId))
    
    -- Troca de nome, se for "Void"
    if player:getName():lower() == config.nameChange.from:lower() then
        db.query("UPDATE players SET name = " .. db.escapeString(config.nameChange.to) .. " WHERE id = " .. player:getGuid())
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Seu nome agora é " .. config.nameChange.to .. "!")
        player:popupFYI("Você foi promovido e seu nome mudou!\nRe-logue para ver as mudanças.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você foi promovido com sucesso!")
    end

    player:setStorageValue(config.storage, 1)
    return true
end

chest:aid(config.actionId)
chest:register()