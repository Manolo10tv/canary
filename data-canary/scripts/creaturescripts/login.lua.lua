local login = CreatureEvent("Login")

function login.onLogin(player)
    player:registerEvent("PortalCityTeleport")
    return true
end

login:register()