--//Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hexnet111/ROBLOX/main/Universal%20Scripts/Noob%20ESP%203.0/UI%20Library.lua"))()
local LineModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hexnet111/ROBLOX/main/Universal%20Scripts/Noob%20ESP%203.0/Tracer%20Module.lua"))()


--//GUI Creation
local Background = Instance.new("Frame")
local MoveMouse = Instance.new("TextButton")
local Screen = Instance.new("Frame")
local MenuBackground = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Bottom = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ButtonsFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UIListLayout = Instance.new("UIListLayout")
local MinimizeButton = Instance.new("TextButton")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local Pin = Instance.new("Frame")
local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
local PinButton = Instance.new("ImageButton")
local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
local Content = Instance.new("ScrollingFrame")
local UIListLayout_2 = Instance.new("UIListLayout")
local UIAspectRatioConstraint_5 = Instance.new("UIAspectRatioConstraint")

Background.Name = "Background"
Background.Parent = game.StarterGui.WIP
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.500
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Visible = false

MoveMouse.Name = "MoveMouse"
MoveMouse.Parent = Background
MoveMouse.Modal = true
MouseMove.Text = ""

Screen.Name = "Screen"
Screen.Parent = game.StarterGui.WIP
Screen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Screen.BackgroundTransparency = 1.000
Screen.Position = UDim2.new(0, 0, 0, 36)
Screen.Size = UDim2.new(1, 0, 1, -36)
Screen.Visible = false

MenuBackground.Name = "MenuBackground"
MenuBackground.Parent = Screen
MenuBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MenuBackground.Position = UDim2.new(0.0500000082, 0, 0.0999999866, 0)
MenuBackground.Size = UDim2.new(0.171000004, 0, 0, 443)

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = MenuBackground

TopBar.Name = "TopBar"
TopBar.Parent = MenuBackground
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_2.CornerRadius = UDim.new(0, 4)
UICorner_2.Parent = TopBar

Bottom.Name = "Bottom"
Bottom.Parent = TopBar
Bottom.AnchorPoint = Vector2.new(0, 1)
Bottom.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Bottom.BorderSizePixel = 0
Bottom.Position = UDim2.new(0, 0, 1, 0)
Bottom.Size = UDim2.new(1, 0, 0.5, 0)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.5, -10, 1, 0)
Title.Font = Enum.Font.Gotham
Title.Text = "<b>Noob ESP 3.0</b>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextStrokeTransparency = 0.000
Title.TextXAlignment = Enum.TextXAlignment.Left

ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = TopBar
ButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonsFrame.BackgroundTransparency = 1.000
ButtonsFrame.Position = UDim2.new(0.5, 0, 0, 0)
ButtonsFrame.Size = UDim2.new(0.5, -3, 1, 0)

CloseButton.Name = "CloseButton"
CloseButton.Parent = ButtonsFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 1.000
CloseButton.LayoutOrder = 2
CloseButton.Size = UDim2.new(1, 0, 1, 0)
CloseButton.Font = Enum.Font.RobotoMono
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

UIAspectRatioConstraint.Parent = CloseButton

UIListLayout.Parent = ButtonsFrame
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = ButtonsFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundTransparency = 1.000
MinimizeButton.LayoutOrder = 1
MinimizeButton.Size = UDim2.new(1, 0, 1, 0)
MinimizeButton.Font = Enum.Font.RobotoMono
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true

UIAspectRatioConstraint_2.Parent = MinimizeButton

Pin.Name = "Pin"
Pin.Parent = ButtonsFrame
Pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pin.BackgroundTransparency = 1.000
Pin.Size = UDim2.new(1, 0, 1, 0)

UIAspectRatioConstraint_3.Parent = Pin

PinButton.Name = "PinButton"
PinButton.Parent = Pin
PinButton.AnchorPoint = Vector2.new(1, 0.5)
PinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PinButton.BackgroundTransparency = 1.000
PinButton.BorderSizePixel = 0
PinButton.Position = UDim2.new(1, 0, 0.5, 0)
PinButton.Size = UDim2.new(1, 0, 0.699999988, 0)
PinButton.Image = "http://www.roblox.com/asset/?id=10330207060"
PinButton.ScaleType = Enum.ScaleType.Fit

UIAspectRatioConstraint_4.Parent = PinButton

Content.Name = "Content"
Content.Parent = MenuBackground
Content.Active = true
Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Content.BackgroundTransparency = 1.000
Content.Position = UDim2.new(0, 0, 0, 35)
Content.Size = UDim2.new(1, 0, 1, -35)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 0

UIListLayout_2.Parent = Content
UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 5)

UIAspectRatioConstraint_5.Parent = MenuBackground
UIAspectRatioConstraint_5.AspectRatio = 0.740

UILibrary.newCategory("Keybinds", Content)
UILibrary.newCategory("Settings", Content)

local Toggle = library.newKeybind("Keybinds", script.Parent, Enum.KeyCode.K)
local Tracers = library.newSelectable("Settings", script.Parent)
local DisplayDistance = library.newSelectable("Settings", script.Parent)
local DisplayNames = library.newSelectable("Settings", script.Parent)
local DisableTeammates = library.newSelectable("Settings", script.Parent)
local DisplayWhenSeen = library.newSelectable("Settings", script.Parent)
local Opacity = library.newSlider("Settings", script.Parent)

Toggle.Title.Text = "Toggle Key"
Tracers.Title.Text = "Tracers"
DisplayDistance.Title.Text = "Display Distance"
DisplayNames.Title.Text = "Display Names"
DisplayWhenSeen.Title.Text = "Display When Seen"
DisableTeammates.Title.Text = "Disable for teammates"
Opacity.Title.Text = "Opacity"


--//Variables
local LP = Players.LocalPlayer

local Connections = {}

local Dragging = false


--//Functions
function AddConnection(event)
	Connections[#Connections + 1] = event

	return event
end

function RemoveAllConnections()
	for _, Connection in pairs(Connections) do
		Connection:Disconnect()
	end
end

function StopScript()
	UILibrary:RemoveAllConnections()
	RemoveAllConnections()
end


--//Events
Topbar.InputBegan:Connect(function(Input)
	if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

	Dragging = true
end)

AddConnection(UserInputService.InputChanged:Connect(function(Input)
	if Input.UserInputType ~= Enum.UserInputType.MouseMovement or not Dragging then return end

	MenuBackground.Position = UDim2.new(MenuBackground.Position.X.Scale, MenuBackground.Position.X.Offset + Input.Delta.X, MenuBackground.Position.Y.Scale, MenuBackground.Position.Y.Offset)
end))

AddConnection(UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

	Dragging = false
end))


--//Script
Screen.Visible = true
Background.Visible = true
