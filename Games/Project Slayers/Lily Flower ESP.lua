--//Services
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hexnet111/ROBLOX/main/Libraries/ESP%20Library.lua"))()()


--//Script
ESPLibrary:DescendantCheck(workspace.Demon_Flowers_Spawn, {
	CustomName = "Lily Flower",
	Name = "Cube.002",
	ClassName = "MeshPart"
}, 
{
	Notify = {Enabled = true}
})
