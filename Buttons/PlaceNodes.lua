local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local history = {}
local nodeDir = workspace:FindFirstChild("Nodes", true)

button.Info = {
	"Place Nodes",
	"Place nodes for a graph",
	"http://www.roblox.com/asset/?id=207047509"
}


function button.Activate(pButton)
	if not nodeDir then
		nodeDir = Instance.new("Model", workspace)
		nodeDir.Name = "Nodes"
	end
	pButton:SetActive(true)
	gui.Dialog("Click anywhere to place a node,  Press Z to undo,  Press X to undo all")
end



function button.MDown(hit, pos)
	local p = Instance.new("Part", nodeDir)
	p.Transparency = 0
	p.CanCollide = false
	p.Anchored = true
	p.BrickColor = BrickColor.new("Lime green")
	p.Locked = true
	p.formFactor = "Custom"
	p.Size = Vector3.new(2, 1, 2)
	p.Name = "node_walk"
	p.Position = pos + Vector3.new(0, p.Size.y / 2, 0)
	table.insert(history, p)
end



function button.KeyDown(key)
	key = key:lower()
	if key == "z" then
		history[#history]:Destroy()
		gui.Dialog("Node undo successful!")
	elseif key == "x" then
		for i = 1, #history do
			history[i]:Destroy()
		end
		gui.Dialog("Cleared node history!")
	end
end



return button