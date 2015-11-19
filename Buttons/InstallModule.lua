local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)

button.Info = {
	"Install Module", 
	"Install the Pathfinding Module", 
	"http://www.roblox.com/asset/?id=207047513"
}


function button.Activate(pButton)
	pButton:SetActive(true)
	local newMod = script.Parent.Parent.PathfindingLibrary:clone()
	newMod.Parent = workspace
	gui.Dialog("Pathfinding module has been installed successfully! Check your workspace for the module and examples!")
	pButton:SetActive(false)
end



return button