--//Services
local HttpService = game:GetService("HttpService")


--//Variables
local genv = {}

--Optimization
local type_of = typeof
local table_find = table.find or function(Table,Value)
	for i,v in pairs(Table) do
		if v == Value then
			return i
		end
	end
end

local UDim2_new = UDim2.new
local Color3_new = Color3.new
local UDim_new = UDim.new
local CFrame_new = CFrame.new
local Vector3_new = Vector3.new
local Vector2_new = Vector2.new
--Optimization end

local ValueTypes = {
	"Color3",
	"UDim2",
	"UDim",
	"Vector3",
	"Vector2",
	"CFrame",
	"Enum"
}


--//Functions
local ExploitSupported = pcall(function()
	local w = writefile
	local r = readfile

	if not w or not r then
		error()
	end
end)

local CanDeleteFiles = pcall(function()
	local d = delfile

	if not d then
		error()
	end
end)

if not ExploitSupported then
	warn("Your exploit does not support readfile and writefile.")
end

function EncodeValue(Value)
	if type_of(Value) == "Color3" then
		return {
			type = "Color3",
			R = Value.R,
			G = Value.G,
			B = Value.B
		}
	elseif type_of(Value) == "UDim2" then
		return {
			type = "UDim2",
			X = {
				Offset = Value.X.Offset,
				Scale = Value.X.Scale
			},
			Y = {
				Offset = Value.Y.Offset,
				Scale = Value.Y.Scale
			}
		}
	elseif type_of(Value) == "UDim" then
		return {
			type = "UDim",
			Offset = Value.Offset,
			Scale = Value.Scale
		}
	elseif type_of(Value) == "CFrame" then
		local OX,OY,OZ = Value:ToOrientation()
		return {
			type = "CFrame",
			X = Value.X,
			Y = Value.Y,
			Z = Value.Z,
			OX = OX,
			OY = OY,
			OZ = OZ
		}
	elseif type_of(Value) == "Vector3" then
		return {
			type = "Vector3",
			X = Value.X,
			Y = Value.Y,
			Z = Value.Z
		}
	elseif type_of(Value) == "Vector2" then
		return {
			type = "Vector2",
			X = Value.X,
			Y = Value.Y
		}
	elseif type_of(Value) == "Enums" or type_of(Value) == "Enum" or type_of(Value) == "EnumItem" then
		return {
			type = "Enum",
			Value = string.gsub(tostring(Value),"Enum.","")
		}
	else
		return Value
	end
end

function ConvertValue(Value)
	if type_of(Value) ~= "table" then return Value end
	if not Value.type then return Value end
	if not table_find(ValueTypes,Value.type) then return Value end

	if Value.type == "Color3" then
		return Color3_new(Value.R,Value.G,Value.B)
	elseif Value.type == "UDim2" then
		return UDim2_new(Value.X.Scale,Value.X.Offset,Value.Y.Scale,Value.Y.Offset)
	elseif Value.type == "UDim" then
		return UDim_new(Value.Scale,Value.Offset)
	elseif Value.type == "CFrame" then
		return (CFrame_new(Value.X,Value.Y,Value.Z) * CFrame.fromEulerAnglesYXZ(Value.OX,Value.OY,Value.OZ))
	elseif Value.type == "Vector3" then
		return Vector3_new(Value.X,Value.Y,Value.Z)
	elseif Value.type == "Vector2" then
		return Vector2_new(Value.X,Value.Y)
	elseif Value.type == "Enum" then
		local SplitEnum = string.split(Value.Value,".")

		if SplitEnum[1] == "" then return end
		local EnumValue = Enum
		for _,Split in pairs(SplitEnum) do
			EnumValue = EnumValue[Split]
		end

		return EnumValue
	end
end

function LookIntoTable(Table)
	local EncodedTable = {}
	for i,v in pairs(Table) do
		if type_of(v) == "table" then
			EncodedTable[i] = LookIntoTable(v)
		else
			EncodedTable[i] = EncodeValue(v)
		end
	end

	return EncodedTable
end

function LookIntoEncodedTable(Table)
	local ConvertedTable = {}
	for i,v in pairs(Table) do
		if type_of(v) == "table" then
			local ConvertedValue = ConvertValue(v)

			if type_of(ConvertedValue) ~= type_of(v) then
				ConvertedTable[i] = ConvertedValue
			else
				ConvertedTable[i] = LookIntoEncodedTable(v)
			end
		else
			ConvertedTable[i] = v
		end
	end

	return ConvertedTable
end

function ConvertTableToText(Table)
	local SafeTable = LookIntoTable(Table)

	if not SafeTable then warn("Table is not safe enough to be saved.") return end

	local EncodedTable = HttpService:JSONEncode(SafeTable)

	if not EncodedTable then warn("Script had trouble converting the table to json format.") return end

	return EncodedTable
end


--//Script
genv.SaveTableToFile = function(Name,Table,Raw)
	if not ExploitSupported then return end

	local EncodedTable = not Raw and ConvertTableToText(Table) or Table

	if not EncodedTable then return end

	writefile(Name ..".lua",EncodedTable)
end

genv.LoadTableFromFile = function(FileName,Raw)
	if not ExploitSupported then return end

	local _,EncodedTable = pcall(function()
		return readfile(FileName ..".lua")
	end)

	if type_of(EncodedTable) == "string" and (string.match(EncodedTable:lower(),"not exist") or string.match(EncodedTable:lower(),"not find")) then
		EncodedTable = nil
	end

	if not EncodedTable then warn("File does not exist") return end

	local DecodedTable = not Raw and HttpService:JSONDecode(EncodedTable) or EncodedTable

	if not DecodedTable then warn("Script had trouble decoding the table.") return end

	local ConvertedTable = not Raw and LookIntoEncodedTable(DecodedTable) or EncodedTable

	if not ConvertedTable then warn("Script had trouble converting the table.") return end

	return ConvertedTable
end

genv.DeleteFile = function(Name)
	if not CanDeleteFiles then warn("Your exploit does not support delfile.") return end

	delfile(Name ..".lua")
end

return genv
