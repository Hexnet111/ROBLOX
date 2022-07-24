--//Variables
local Module = {}


--//Background Functions
function GetAbsoluteMiddle(Object : GuiObject)
	return Object.AbsolutePosition + Object.AbsoluteSize / 2
end


--//Functions
function Module.new(Parent)
	local self = setmetatable({}, {__index = Module})

	self.Line = Instance.new("Frame", Parent)
	self.Line.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Line.Size = UDim2.new()
	self.Line.Name = "Line"
	
	self.Width = 5

	return self
end

function Module:Update(Point1, Point2)
	local Point1Vector = typeof(Point1) == "Instance" and GetAbsoluteMiddle(Point1) or typeof(Point1) == "UDim2" and Vector2.new(Point1.X.Offset, Point1.Y.Offset) or Point1
	local Point2Vector = typeof(Point2) == "Instance" and GetAbsoluteMiddle(Point2) or typeof(Point2) == "UDim2" and Vector2.new(Point2.X.Offset, Point2.Y.Offset) or Point2

	local MiddlePoint = Point1Vector - Vector2.new(Point1Vector.X - Point2Vector.X, 0)

	local Rotation = math.deg(math.atan2(MiddlePoint.Y - Point2Vector.Y, MiddlePoint.X - Point1Vector.X))
	local MiddlePosition = Point1Vector:Lerp(Point2Vector, 0.5)

	self.Line.Rotation = Rotation * -1
	self.Line.Position = UDim2.fromOffset(MiddlePosition.X, MiddlePosition.Y)
	self.Line.Size = UDim2.fromOffset((Point1Vector - Point2Vector).Magnitude, self.Width)
end


--//Script
return Module
