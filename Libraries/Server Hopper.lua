--//Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SaveSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hexnet111/ROBLOX/main/Libraries/Save%20System.lua"))()


--//Variables
local LP = Players.LocalPlayer
local CurrentSave = SaveSystem.LoadTableFromFile("ServersHopped") or {
	Servers = {},
	Time = os.time() / 3600
}


--//Functions
function GetTime()
	return os.time() / 3600
end

function SearchForServer(Settings, Page, RetryCount)
	RetryCount = RetryCount or 0

	local URL = string.format("https://games.roblox.com/v1/games/%i/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)

	if Page then
		URL ..= "&cursor=" ..Page
	end

	local PlaceData = HttpService:JSONDecode(game:HttpGet(URL))

	for _, Server in pairs(PlaceData.data) do
		if not Server.playing then continue end

		if Server.id == game.JobId then continue end
		if CurrentSave.Servers[Server.id] then continue end

		local ActualMaxPlayers = tonumber(Server.maxPlayers)
		local MaxPlayers = Settings.EmptySlots and math.clamp(ActualMaxPlayers - Settings.EmptySlots + 1, 1, math.huge) or ActualMaxPlayers

		if MaxPlayers == ActualMaxPlayers - 1 and tonumber(Server.playing) >= MaxPlayers or tonumber(Server.playing) > MaxPlayers then continue end
		if Server.ping and Settings.MinimumPing and tonumber(Server.ping) > Settings.MinimumPing then continue end

		warn("ID:", Server.id, "Players:", Server.playing, "Ping:", Server.ping)

		return Server.id
	end

	if PlaceData.nextPageCursor then
		RetryCount += 1

		warn("Couldn't find a server on page", RetryCount ..". Retrying on page", RetryCount + 1)

		task.wait(0.14)

		return SearchForServer(Settings, PlaceData.nextPageCursor, RetryCount)
	end
end


--//Script
return function(SearchSettings)
	SearchSettings = SearchSettings or {
		ClearTime = 5
	}

	local TimePassed = math.abs(GetTime() - CurrentSave.Time)

	if TimePassed > SearchSettings.ClearTime then
		table.clear(CurrentSave.Servers)
		CurrentSave.Time = GetTime()

		SaveSystem.SaveTableToFile("ServersHopped", CurrentSave)
	end

	while true do
		local NewServer = SearchForServer(SearchSettings)

		if not NewServer then 
			warn("Couldn't find a server with the required parameters.")

			break 
		end

		task.spawn(function()
			CurrentSave.Servers[NewServer] = true
			SaveSystem.SaveTableToFile("ServersHopped", CurrentSave)
		end)

		TeleportService:TeleportToPlaceInstance(game.PlaceId, NewServer, LP)

		task.wait(2)
	end
end
