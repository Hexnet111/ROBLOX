--//Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")


--//Variables
local Module = {}

local Categories = {}
local UpdateSliders = {}
local LayoutOrder = 0

local UIEvents = {}

local Connections = {}
local CustomKeyNames = {
	Backquote = "`";
}

local FadeTweenInfo = TweenInfo.new(
	0.2,
	Enum.EasingStyle.Quint,
	Enum.EasingDirection.Out
)


--//Background Functions
function AddConnection(event)
	Connections[#Connections + 1] = event

	return event
end

function RenderSliders(Input)
	local MousePos = Input.Position

	for Slider, Sliding in pairs(UpdateSliders) do
		if not Sliding then continue end

		local Start = Slider.Parent.AbsolutePosition.X
		local End = Start + Slider.Parent.AbsoluteSize.X
		
		local Final = math.clamp((Start - MousePos.X) / (Start - End), 0, 1)

		Slider.Size = UDim2.fromScale(Final, 1)

		UIEvents[Slider]:Fire(Final)
	end
end

function CreateFade(Object, FadeIn, FadeOut)
	local FadeInTween = TweenService:Create(Object, FadeTweenInfo, FadeIn)
	local FadeOutTween = TweenService:Create(Object, FadeTweenInfo, FadeOut)

	FadeInTween.Parent = Object
	FadeOutTween.Parent = Object

	return FadeInTween, FadeOutTween
end


--//Functions
function Module:RemoveAllConnections()
	for _, Connection in pairs(Connections) do
		Connection:Disconnect()
	end
end

function Module.newCategory(Name, Parent)
	Categories[Name] = {
		Order = LayoutOrder + 1,
		Content = {}
	}

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Parent = Parent
	TextLabel.BackgroundTransparency = 1
	TextLabel.LayoutOrder = LayoutOrder
	TextLabel.Size = UDim2.new(1, 0, 0, 40)
	TextLabel.Font = Enum.Font.Gotham
	TextLabel.Text = Name
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true

	LayoutOrder += 2
end

function Module.newSelectable(Category, Parent)
	if not Category then return end

	Category = Categories[Category]

	local SelectableOption = Instance.new("Frame")
	local OptionName = Instance.new("TextLabel")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local SelectBackground = Instance.new("Frame")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local Button = Instance.new("TextButton")

	SelectableOption.Name = "SelectableOption"
	SelectableOption.Parent = Parent
	SelectableOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	SelectableOption.LayoutOrder = Category.Order
	SelectableOption.Size = UDim2.new(0.949999988, 0, 0, 35)

	OptionName.Name = "OptionName"
	OptionName.Parent = SelectableOption
	OptionName.AnchorPoint = Vector2.new(0, 0.5)
	OptionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OptionName.BackgroundTransparency = 1.000
	OptionName.Position = UDim2.new(0, 10, 0.5, 0)
	OptionName.Size = UDim2.new(0.800000012, -10, 0.800000012, 0)
	OptionName.Font = Enum.Font.Gotham
	OptionName.Text = ""
	OptionName.TextColor3 = Color3.fromRGB(255, 255, 255)
	OptionName.TextScaled = true
	OptionName.TextXAlignment = Enum.TextXAlignment.Left

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = SelectableOption

	SelectBackground.Name = "SelectBackground"
	SelectBackground.Parent = SelectableOption
	SelectBackground.AnchorPoint = Vector2.new(1, 0.5)
	SelectBackground.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	SelectBackground.BackgroundTransparency = 1
	SelectBackground.Position = UDim2.new(1, -5, 0.5, 0)
	SelectBackground.Size = UDim2.new(1, 0, 0.75, 0)

	UIAspectRatioConstraint.Parent = SelectBackground

	UIStroke.Parent = SelectBackground
	UIStroke.Color = Color3.new(1, 1, 1)
	UIStroke.Thickness = 2

	Button.Name = "Button"
	Button.Parent = SelectBackground
	Button.BackgroundTransparency = 1
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.Text = ""

	table.insert(Category.Content, SelectableOption)

	UIEvents[SelectableOption] = Instance.new("BindableEvent", Button)

	local FadeIn, FadeOut = CreateFade(SelectBackground, {
		BackgroundTransparency = 0
	},
	{
		BackgroundTransparency = 1
	})

	local On = false

	Button.MouseButton1Click:Connect(function()
		On = not On

		UIEvents[SelectableOption]:Fire(On)

		if On then
			FadeIn:Play()
		else
			FadeOut:Play()
		end
	end)

	return {
		Object = SelectableOption,
		Title = OptionName,
		MouseButton1Click = UIEvents[SelectableOption].Event
	}
end

function Module.newKeybind(Category, Parent, DefaultKey)
	if not Category then return end

	Category = Categories[Category]

	local KeybindOption = Instance.new("Frame")
	local OptionName = Instance.new("TextLabel")
	local UICorner = Instance.new("UICorner")
	local SelectBackground = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local Button = Instance.new("TextButton")

	KeybindOption.Name = "KeybindOption"
	KeybindOption.Parent = Parent
	KeybindOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	KeybindOption.LayoutOrder = Category.Order
	KeybindOption.Size = UDim2.new(0.949999988, 0, 0, 35)

	OptionName.Name = "OptionName"
	OptionName.Parent = KeybindOption
	OptionName.AnchorPoint = Vector2.new(0, 0.5)
	OptionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OptionName.BackgroundTransparency = 1
	OptionName.Position = UDim2.new(0, 10, 0.5, 0)
	OptionName.Size = UDim2.new(0.800000012, -12, 0.800000012, 0)
	OptionName.Font = Enum.Font.Gotham
	OptionName.Text = "Toggle Key"
	OptionName.TextColor3 = Color3.fromRGB(255, 255, 255)
	OptionName.TextScaled = true
	OptionName.TextXAlignment = Enum.TextXAlignment.Left

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = KeybindOption

	SelectBackground.Name = "SelectBackground"
	SelectBackground.Parent = KeybindOption
	SelectBackground.AnchorPoint = Vector2.new(1, 0.5)
	SelectBackground.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	SelectBackground.BackgroundTransparency = 1
	SelectBackground.Position = UDim2.new(1, -5, 0.5, 0)
	SelectBackground.Size = UDim2.new(0.200000003, -5, 0.75, 0)

	UIStroke.Parent = SelectBackground
	UIStroke.Color = Color3.new(1, 1, 1)
	UIStroke.Thickness = 2

	Button.Name = "Button"
	Button.Parent = SelectBackground
	Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Button.BackgroundTransparency = 1.000
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.Font = Enum.Font.RobotoMono
	Button.Text = DefaultKey.Name
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextScaled = true

	table.insert(Category.Content, KeybindOption)

	UIEvents[KeybindOption] = Instance.new("BindableEvent", Button)

	local CurrentKey = DefaultKey
	
	Button.MouseButton1Click:Connect(function()
		Button.Text = "..."

		local NewKey = UserInputService.InputBegan:Wait().KeyCode

		if NewKey == Enum.KeyCode.Unknown then
			Button.Text = CurrentKey

			return
		end

		CurrentKey = NewKey

		local KeyName = CustomKeyNames[NewKey.Name] or NewKey.Name

		Button.Text = KeyName

		UIEvents[KeybindOption]:Fire(NewKey)
	end)

	return {
		Object = KeybindOption,
		Title = OptionName,
		KeybindChanged = UIEvents[KeybindOption].Event
	}
end

function Module.newSlider(Category, Parent)
	if not Category then return end

	Category = Categories[Category]

	local SliderOption = Instance.new("Frame")
	local OptionName = Instance.new("TextLabel")
	local UICorner = Instance.new("UICorner")
	local SliderBackground = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Slider = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")

	SliderOption.Name = "SliderOption"
	SliderOption.Parent = Parent
	SliderOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	SliderOption.LayoutOrder = Category.Order
	SliderOption.Size = UDim2.new(0.949999988, 0, 0, 70)

	OptionName.Name = "OptionName"
	OptionName.Parent = SliderOption
	OptionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OptionName.BackgroundTransparency = 1.000
	OptionName.Position = UDim2.new(0, 10, 0, 0)
	OptionName.Size = UDim2.new(1, -20, 0, 28)
	OptionName.Font = Enum.Font.Gotham
	OptionName.Text = ""
	OptionName.TextColor3 = Color3.fromRGB(255, 255, 255)
	OptionName.TextScaled = true

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = SliderOption

	SliderBackground.Name = "SliderBackground"
	SliderBackground.Parent = SliderOption
	SliderBackground.AnchorPoint = Vector2.new(0.5, 1)
	SliderBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	SliderBackground.Position = UDim2.new(0.5, 0, 1, -5)
	SliderBackground.Size = UDim2.new(0.949999988, 0, 0.100000001, 21)

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = SliderBackground

	Slider.Name = "Slider"
	Slider.Parent = SliderBackground
	Slider.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	Slider.Size = UDim2.new(1, 0, 1, 0)
	Slider.BorderSizePixel = 0

	UICorner_3.CornerRadius = UDim.new(0, 5)
	UICorner_3.Parent = Slider

	table.insert(Category.Content, SliderOption)

	UpdateSliders[Slider] = false
	UIEvents[Slider] = Instance.new("BindableEvent", Slider)

	SliderBackground.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		UpdateSliders[Slider] = true

		RenderSliders(Input)
	end)

	return {
		Object = SliderOption,
		Title = OptionName,
		OnUpdate = UIEvents[Slider].Event
	}
end


--//Events
AddConnection(UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		for Slider, Sliding in pairs(UpdateSliders) do
			if not Sliding then continue end

			UpdateSliders[Slider] = false
		end
	end
end))

AddConnection(UserInputService.InputChanged:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseMovement then
		RenderSliders(Input)
	end
end))


--//Script
return Module
