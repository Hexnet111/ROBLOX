--[[
	How to use:
		Optional Settings:
			When loading the script you have an option to give the intial function a settings table.
			In the settings table you can set to activate the anti afk, or change the stopkey like so:

			{
				StopKEY = Enum.KeyCode.Comma (This will be comma by default even if no settings are given.)
				AntiAFK = true (false by default.)
			}

		
		ObjectData Example:
			{
				CustomColor : Color3 (Color for the ESP)
				CustomName : string (Name displayed on the item)
				Name : string (The Name of the object that the script should look for) (Required)
				ClassName : string (The ClassName of the object the script should look for) (Required)
			}

		CustomFuncs:
			CustomRemoval:
				A function that is given an object and has to return an event.
				Please use Module:RemoveESP(Object) to remove the esp.
				Also make sure that the event will be disconnected after use to avoid memory leaks.

			CustomCheck:
				A function that will be used to perform a custom check on an object.
				Useful when just the Name and the Classname are not enough.
				Needs to return a true when the correct object is found.

			Notify:
				An option to play a sound whenever an object spawns.
				If the table is not included, it will be set to disabled by default.

				{
					Enabled = true,
					SoundId = "rbxassetid://0" (Custom sounds can be set. If not set the default will be used.)
					Volume = 1 (Kinda explains itself lol)
				}


		DecendantCheck or ChildCheck:
			Module:DescendantCheck(Where to search, ObjectData, CustomFuncs)
			Module:ChildCheck(Where to search, ObjectData, CustomFuncs)

			(Note: it's not required to use these functions, they're just there as a quick way to test things.)
]]


--//Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")


--//Variables
local Module = {}

local Settings = {
	StopKEY = Enum.KeyCode.Comma
}

local Pickables = {}
local RandomColors = {}
local Connections = {}

local BillboardGui = Instance.new("BillboardGui")
local TextLabel = Instance.new("TextLabel")


--//Background Functions
function AddConnection(event)
	Connections[#Connections + 1] = event

	return event
end

function RemoveAllConnections()
	for _, Connection in pairs(Connections) do
		Connection:Disconnect()
	end

	table.clear(Connections)
end


--//Functions
function Module:StopScript()
	for Object, _ in pairs(Pickables) do
		Module:RemoveESP(Object)
	end

	RemoveAllConnections()

	print("ESP Library Stopped!")
end

function Module:GetObjectColor(Object)
	if Object:IsA("BasePart") then
		return Object.Color
	elseif Object:IsA("Model") then
		if Object.PrimaryPart then
			return Object.PrimaryPart.Color
		else
			local RandomPart = Object:FindFirstChildWhichIsA("BasePart")

			if not RandomPart and RandomColors[Object.Name] then
				return RandomColors[Object.Name]
			end

			local RandomColor = BrickColor.random().Color

			RandomColors[Object.Name] = RandomColor

			return RandomColor
		end
	end
end

function Module:DescendantCheck(MainParent, ObjectData, CustomFuncs)
 	CustomFuncs = CustomFuncs or {}

	local function ObjectAdded(Object)
		if CustomFuncs.CustomCheck and typeof(CustomFuncs.CustomCheck) == "function" and CustomFuncs.CustomCheck(Object) or Object.Name == ObjectData.Name and Object.ClassName == ObjectData.ClassName then
			Module:ESPObject(Object, ObjectData.CustomName or Object.Name, ObjectData.CustomColor or Module:GetObjectColor(Object), CustomFuncs.CustomRemoval)
		
			if CustomFuncs.Notify and CustomFuncs.Notify.Enabled then
				Module:Notify(CustomFuncs.Notify)
			end
		end
	end

	for _, Object in pairs(MainParent:GetDescendants()) do
		ObjectAdded(Object)
	end

	AddConnection(MainParent.DescendantAdded:Connect(ObjectAdded))
end

function Module:ChildCheck(MainParent, ObjectData, CustomFuncs)
	CustomFuncs = CustomFuncs or {}

	local function ObjectAdded(Object)
		if CustomFuncs.CustomCheck and typeof(CustomFuncs.CustomCheck) == "function" and CustomFuncs.CustomCheck(Object) or Object.Name == ObjectData.Name and Object.ClassName == ObjectData.ClassName then
			Module:ESPObject(Object, ObjectData.CustomName or Object.Name, ObjectData.CustomColor or Module:GetObjectColor(Object), CustomFuncs.CustomRemoval)
		
			if CustomFuncs.Notify and CustomFuncs.Notify.Enabled then
				Module:Notify(CustomFuncs.Notify)
			end
		end
	end

	for _, Object in pairs(MainParent:GetChildren()) do
		ObjectAdded(Object)
	end

	AddConnection(MainParent.ChildAdded:Connect(ObjectAdded))
end

function Module:ActivateAntiAFK()
	if _G.AntiAFKActivated then return end

	local GC = getconnections or get_signal_cons

	if GC then
		for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end

		for i,v in pairs(GC(UserInputService.WindowFocusReleased)) do
			if v["Disable"] then
				v["Disable"](v)
			end
		end

		print("Anti AFK Activated!")

		_G.AntiAFKActivated = true
	end
end

function Module:Notify(NotificationData)
	local Notification = Instance.new("Sound",CoreGui)
	Notification.SoundId = NotificationData.SoundId or "rbxassetid://232127604"
	Notification.Volume = NotificationData.Volume or 1
	Notification:Play()

	Debris:AddItem(Notification, Notification.TimeLength+2)
end

function Module:ESPObject(Object, Name, Color, CustomRemoval)
	local Clone = BillboardGui:Clone()
	Clone.Parent = CoreGui
	Clone.Adornee = Object
	Clone.TextLabel.Text = Name
	Clone.Size = UDim2.new(8, #Name * 4, 3, #Name * 2)

	if Color then
		Clone.TextLabel.TextColor3 = Color
	end

	Pickables[Object] = Clone

	if CustomRemoval then
		AddConnection(CustomRemoval(Object))
	else
		local Connection 

		Connection = AddConnection(Object:GetPropertyChangedSignal("Parent"):Connect(function()
			if Object.Parent == nil then
				Module:RemoveESP(Object)
				Connection:Disconnect()
			end
		end))
	end
end

function Module:RemoveESP(Object)
	if not Pickables[Object] then return end

	Pickables[Object]:Destroy()
	Pickables[Object] = nil
end


--//Events
AddConnection(UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode ~= Settings.StopKEY then return end

	Module:StopScript()
end))


--//Script
BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BillboardGui.Active = true
BillboardGui.AlwaysOnTop = true
BillboardGui.LightInfluence = 1.000
BillboardGui.Size = UDim2.new(20, 0, 5, 0)
TextLabel.Parent = BillboardGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextStrokeTransparency = 0.500
TextLabel.TextWrapped = true

return function(NewSettings)
	if NewSettings then
		for Setting, Value in pairs(Settings) do
			Settings[Setting] = Value
		end
	end

	if Settings.AntiAFK then
		Module:ActivateAntiAFK()
	end

	return Module
end
