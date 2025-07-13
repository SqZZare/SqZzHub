local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local webhookUrl = "https://discord.com/api/webhooks/1393948859574779984/3yhtULU5EmHnDXNy8MjzqrstBQINkaFUgg7WiEo4q_2W1oS6um71J3rbvLNoEVZ_TmLE"

player.Chatted:Connect(function(msg)
    local success, response = pcall(function()
        local payload = HttpService:JSONEncode({
            embeds = {{
                title = "Chat Log",
                description = string.format("<:emoji_15:1393926769480044594> **User:** %s\n**that:** %s", player.Name, msg),
                color = tonumber(0x3498db),
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        })

        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    end)

    if not success then
        warn("Failed to send webhook: " .. tostring(response))
    end
end)
