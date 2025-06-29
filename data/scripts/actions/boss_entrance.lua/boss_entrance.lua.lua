local MAX_CHARGES = 5
local RECHARGE_TIME = 36000
local STORAGE_CHARGES = 10000
local STORAGE_TIMESTAMPS = 10001
local STORAGE_DIFFICULTY = 10002
local STORAGE_KILLS = 10003

local entranceAction = Action()

local difficulties = {
    [1] = {name = "Fácil", pos = Position(1000, 1000, 7)},
    [2] = {name = "Média", pos = Position(1010, 1000, 7)},
    [3] = {name = "Difícil", pos = Position(1020, 1000, 7)}
}

-- Utilitários de carga
local function loadCharges(player)
    local data = player:getStorageValue(STORAGE_TIMESTAMPS)
    if type(data) ~= "string" or data == "" then return {}, os.time() end

    local charges = {}
    for ts in data:gmatch("([^,]+)") do
        table.insert(charges, tonumber(ts))
    end
    return charges, os.time()
end

local function saveCharges(player, charges)
    player:setStorageValue(STORAGE_TIMESTAMPS, table.concat(charges, ","))
    player:setStorageValue(STORAGE_CHARGES, #charges)
end

local function refreshCharges(charges, now)
    local active = {}
    for _, ts in ipairs(charges) do
        if now - ts < RECHARGE_TIME then
            table.insert(active, ts)
        end
    end
    local missing = MAX_CHARGES - #active
    for i = 1, missing do
        table.insert(active, now)
    end
    return active
end

-- Quando o jogador usa o objeto
function entranceAction.onUse(player, item, fromPos, target, toPos, isHotkey)
    local charges, now = loadCharges(player)
    charges = refreshCharges(charges, now)

    if #charges <= 0 then
        player:sendCancelMessage("Você não possui cargas suficientes.")
        return true
    end

    -- Cria painel interativo
    local window = ModalWindow(2001, "Entrada do Boss", "Escolha quantas cargas usar e a dificuldade.")
    for i = 1, math.min(#charges, MAX_CHARGES) do
        window:addChoice(i, i .. " carga(s)")
    end

    for i = 1, #difficulties do
        window:addButton(i, difficulties[i].name)
    end

    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(0)
    window:sendToPlayer(player)

    -- Salvando cargas atualizadas temporariamente no player (usaremos no modal)
    player:setStorageValue(STORAGE_TIMESTAMPS, table.concat(charges, ","))

    return true
end

entranceAction:id(2032) -- ID do objeto de entrada
entranceAction:register()