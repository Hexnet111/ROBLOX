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

function GetObjectColor(Object)
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


--//Functions
function Module:StopScript()
	RemoveAllConnections()
end

function Module:DescendantCheck(MainParent, ObjectData, CustomCheck)
	AddConnection(MainParent.DescendantAdded:Connect(function(Object)
		if CustomCheck and typeof(CustomCheck) == "function" and CustomCheck(Object, ObjectData) or Object.Name == ObjectData.Name and Object.ClassName == ObjectData.ClassName then
			Module:ESPObject(Object, ObjectData.CustomName or Object.Name, GetObjectColor(Object))
		end
	end))
end

function Module:ChildCheck(MainParent, ObjectData, CustomCheck)
	AddConnection(MainParent.ChildAdded:Connect(function(Object)
		if CustomCheck and typeof(CustomCheck) == "function" and CustomCheck(Object, ObjectData) or Object.Name == ObjectData.Name and Object.ClassName == ObjectData.ClassName then
			Module:ESPObject(Object, ObjectData.CustomName or Object.Name, GetObjectColor(Object))
		end
	end))
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

function Module.ESPObject(Object,Name,Color)
    local Clone = BillboardGui:Clone()
    Clone.Parent = CoreGui
    Clone.Adornee = Object
    Clone.TextLabel.Text = Name
    Clone.Size = UDim2.new(20,#Name*2,5,#Name)

    if Color then
        Clone.TextLabel.TextColor3 = Color
    end

    Pickables[Object] = Clone
end

function Module.RemoveObject(Object)
    if not Pickables[Object] then return end

    Pickables[Object]:Destroy()
    Pickables[Object] = nil
end


--//Events
AddConnection(UserInputService.InputBegan:Connect(function()
	if Input.KeyCode ~= Settings.StopKEY then return end

	Module:StopScript()
end))


--//Script
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
