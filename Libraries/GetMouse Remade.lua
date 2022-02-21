--Note: Don't judge me. I was bored and I had nothing to do, so I decided to remake GetMouse using UserInputService.
--Also this is not an exact remake, so expect some differences.

--//Services
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")


--//Variables
local Module = {
	TargetFilter = {},
	TargetFilterType = Enum.RaycastFilterType.Blacklist
}
local MouseProperties = {
	RayParams = RaycastParams.new()
}

local Tracked = {}
local Events = {}

local EventTypes = {
	InputBegan = {
		"KeyDown",
		"Mouse1Down",
		"Mouse2Down"
	},
	
	InputChanged = {
		"Move",
		"WheelForward",
		"WheelBackward"
	},
	
	InputEnded = {
		"KeyUp",
		"Mouse1Up",
		"Mouse2Up"
	},
}


--//Background Functions
function CreateEvent(RealName,FakeName)
	if not Events[FakeName] then
		Events[FakeName .."Fire"] = function(...)
			for i,func in pairs(Events[FakeName].Connections) do
				coroutine.wrap(func)(...)
			end
		end
	else
		return Events[FakeName]
	end
	
	if not Tracked[RealName] then
		EventTypes[RealName]:Start()
	end
	
	local NewEvent = {
		Connections = {}
	}
	
	function NewEvent:Connect(func)
		if not func or typeof(func) ~= "function" then return end
		
		local ConnectionID = #NewEvent.Connections + 1
		
		NewEvent.Connections[ConnectionID] = func
		
		return {
			Disconnect = function()
				NewEvent.Connections[ConnectionID] = nil
				
				if #NewEvent.Connections == 0 then
					Tracked[RealName]:Disconnect()
					Tracked[RealName] = nil
					
					Events[FakeName] = nil
					Events[FakeName .."Fire"] = nil
				end
			end,
		}
	end
	
	Events[FakeName] = NewEvent
	
	return NewEvent
end

function FireFakeEvent(FakeEvent,...)
	if not Events[FakeEvent] then return end
	
	Events[FakeEvent .."Fire"](...)
end

function GetEventType(Name)
	for i,v in pairs(EventTypes) do
		if table.find(v,Name) then
			return i
		end
	end
end

function MouseHitRay()
	local UnitRay = MouseProperties:UnitRay()

	MouseProperties.RayParams.FilterDescendantsInstances = Module.TargetFilter
	MouseProperties.RayParams.FilterType = Module.TargetFilterType

	return workspace:Raycast(UnitRay.Origin,UnitRay.Direction*999,MouseProperties.RayParams)
end


--//Property Functions
function MouseProperties:X()
	return UserInputService:GetMouseLocation().X
end

function MouseProperties:Y()
	return UserInputService:GetMouseLocation().Y - 36
end

function MouseProperties:UnitRay()
	local MouseLocation = UserInputService:GetMouseLocation()
	local UnitRay = Camera:ViewportPointToRay(MouseLocation.X,MouseLocation.Y)
	
	return UnitRay
end

function MouseProperties:Origin()
	return MouseProperties:UnitRay().Origin
end

function MouseProperties:Hit()
	local UnitRay = MouseProperties:UnitRay()
	local NewRay = MouseHitRay()
	
	if NewRay then
		return CFrame.new(NewRay.Position)
	else
		return CFrame.new(UnitRay.Origin + (UnitRay.Direction * 999))
	end
end

function MouseProperties:Target()
	local NewRay = MouseHitRay()
	
	if NewRay then
		return NewRay.Instance
	end
end

function MouseProperties:TargetSurface()
	local NewRay = MouseHitRay()
	
	if NewRay then
		return NewRay.Normal
	end
end

function MouseProperties:ViewSizeX()
	return Camera.ViewportSize.X
end

function MouseProperties:ViewSizeY()
	return Camera.ViewportSize.Y - 36
end


--//Event Functions
function EventTypes.InputBegan:Start()
	Tracked.InputBegan = UserInputService.InputBegan:Connect(function(Input)
		if Events.KeyDown and Input.KeyCode and Input.KeyCode ~= Enum.KeyCode.Unknown then
			FireFakeEvent("KeyDown",Input.KeyCode.Name)
		end
		
		if Events.Mouse1Down and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			FireFakeEvent("Mouse1Down")
		elseif Events.Mouse2Down and Input.UserInputType == Enum.UserInputType.MouseButton2 then
			FireFakeEvent("Mouse2Down")
		end
	end)
end

function EventTypes.InputChanged:Start()
	Tracked.InputChanged = UserInputService.InputChanged:Connect(function(Input)
		if Events.Move and Input.UserInputType == Enum.UserInputType.MouseMovement then
			FireFakeEvent("Move",Input.Position,Input.Delta)
		end
		
		if Input.UserInputType == Enum.UserInputType.MouseWheel then
			if Events.WheelForward and Input.Position.Z > 0 then
				FireFakeEvent("WheelForward")
			end
			
			if Events.WheelBackward and Input.Position.Z < 0 then
				FireFakeEvent("WheelBackward") 
			end
		end
	end)
end

function EventTypes.InputEnded:Start()
	Tracked.InputEnded = UserInputService.InputEnded:Connect(function(Input)
		if Events.KeyUp and Input.KeyCode and Input.KeyCode ~= Enum.KeyCode.Unknown then
			FireFakeEvent("KeyUp",Input.KeyCode.Name)
		end

		if Events.Mouse1Up and Input.UserInputType == Enum.UserInputType.MouseButton1 then
			FireFakeEvent("Mouse1Up")
		elseif Events.Mouse2Up and Input.UserInputType == Enum.UserInputType.MouseButton2 then
			FireFakeEvent("Mouse2Up")
		end
	end)
end


--//Script
return setmetatable(Module,{
	__index = function(index,value)
		if typeof(MouseProperties[value]) == "function" then
			return MouseProperties[value]()
		else
			local EventType = GetEventType(value)
			
			if not EventType then return end
			
			return CreateEvent(EventType,value)
		end
	end,
})
