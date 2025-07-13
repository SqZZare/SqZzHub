local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local webhookUrl = "https://discord.com/api/webhooks/1393948859574779984/3yhtULU5EmHnDXNy8MjzqrstBQINkaFUgg7WiEo4q_2W1oS6um71J3rbvLNoEVZ_TmLE"

player.Chatted:Connect(function(msg)
    local embed = {
        title = "Chat Log",
        description = string.format("**User:** %s\n**Message:** %s", player.Name, msg),
        color = 0x3498db,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local data = {
        embeds = { embed }
    }

    pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
end)
