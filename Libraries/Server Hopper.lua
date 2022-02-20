--//Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SaveSystem = loadstring(game:HttpGet("https://dumpz.org/cBnSWwMc8sp8/text/"))()


--//Variables
local LP = Players.LocalPlayer
local CurrentSave = SaveSystem.LoadTableFromFile("ServersHopped") or {
	Servers = {},
	Time = os.time() / 3600
}
local LastPage


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
		if Server.id == game.JobId then continue end
		if CurrentSave.Servers[Server.id] then continue end

		local MaxPlayers = Settings.EmptySlots and math.clamp(tonumber(Server.maxPlayers) - Settings.EmptySlots + 1, 1, math.huge) or tonumber(Server.maxPlayers)

		if tonumber(Server.playing) >= MaxPlayers then continue end
		if Settings.MinimumPing and tonumber(Server.ping) > Settings.MinimumPing then continue end

		warn("ID:", Server.id, "Players:", Server.playing, "Ping:", Server.ping)

		return Server.id
	end

	if PlaceData.nextPageCursor then
		RetryCount += 1

		warn("Couldn't find a server on page", RetryCount ..". Retrying on page", RetryCount + 1)

		task.wait(0.14)

		LastPage = PlaceData.nextPageCursor

		return SearchForServer(Settings, PlaceData.nextPageCursor, RetryCount)
	end
end


--//Script
local TimePassed = math.abs(GetTime() - CurrentSave.Time)

if TimePassed > SearchSettings.ClearTime then
	table.clear(CurrentSave.Servers)
	CurrentSave.Time = GetTime()

	SaveSystem.SaveTableToFile("ServersHopped", CurrentSave)
end

return function(SearchSettings)
	while true do
		local NewServer = SearchForServer(SearchSettings, LastPage)

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
