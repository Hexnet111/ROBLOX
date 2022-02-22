--Note: If you want to stop this script mid finding you need to remove it's save file.
--This script is meant to be in the auto execute folder.

if game.PlaceId ~= 5094651510 then return end

--//Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local SaveSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hexnet111/ROBLOX/main/Libraries/Save%20System.lua"))()
local HopServer = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hexnet111/ROBLOX/main/Libraries/Server%20Hopper.lua"))()


--//Variables
repeat task.wait() until Players.LocalPlayer

local LP = Players.LocalPlayer

local Finder = Instance.new("ScreenGui")
local Find = Instance.new("TextButton")

local CurrentSave = SaveSystem.LoadTableFromFile("KaigakuFinder") or {
	Enabled = false
}

local HopSettings = {
	ClearTime = 0.333
}


--//Functions
function Enable()
	CurrentSave.Enabled = true
	SaveSystem.SaveTableToFile("KaigakuFinder", CurrentSave)
	Find.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
end

function Disable()
	CurrentSave.Enabled = false
	SaveSystem.SaveTableToFile("KaigakuFinder", CurrentSave)
	Find.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end

function Notify()
	local Notification = Instance.new("Sound",CoreGui)
	Notification.SoundId = "rbxassetid://232127604"
	Notification:Play()

	Debris:AddItem(Notification,Notification.TimeLength+2)
end

function FindKaigaku()
	if not CurrentSave.Enabled then return end

	if not LP.Character then
		LP.CharacterAdded:Wait()
	end

	task.wait(0.5)

	local Kaigaku = workspace:FindFirstChild("Kaigaku")

	if Kaigaku and Kaigaku:FindFirstChildWhichIsA("Model") and Kaigaku.Health.Value >= 250 then
		Notify()
		Disable()

		task.delay(5, function()
			if not LP.Character or not LP.Character:FindFirstChild("Health") then
				HopServer(HopSettings)
			end
		end)
	else
		HopServer(HopSettings)
	end
end


--//Events
Find.MouseButton1Click:Connect(function()
	if CurrentSave.Enabled then
		Disable()
	else
		Enable()
		FindKaigaku()
	end
end)


--//Script
FindKaigaku()

Finder.Name = "Finder"
Finder.Parent = CoreGui
Finder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Finder.ResetOnSpawn = false

Find.Name = "Find"
Find.Parent = Finder
Find.AnchorPoint = Vector2.new(1, 1)
Find.BackgroundColor3 = CurrentSave.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
Find.BackgroundTransparency = 0.200
Find.Position = UDim2.new(1, -10, 1, -20)
Find.Size = UDim2.new(0.100000001, 0, 0.0500000007, 0)
Find.Text = "Find Kaigaku"
Find.TextColor3 = Color3.fromRGB(0, 0, 0)
Find.TextScaled = true
