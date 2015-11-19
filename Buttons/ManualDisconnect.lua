local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local history = {}
local nodeDir = workspace:FindFirstChild("Nodes", true)
local showConnections = true
local nodeselected = nil


function disconnect(a, b)
	for _, con in pairs(a:GetChildren()) do
		if con.ClassName == "ObjectValue" then
			if con.Value == b then
				con:Destroy()
			end
		end
	end
	for _, con in pairs(b:GetChildren()) do
		if con.ClassName == "ObjectValue" then
			if con.Value == a then
				con:Destroy()
			end
		end
	end
end

function selectionbox(part)
	local b = Instance.new("SelectionBox", part)
	b.Name = "SELECTION"
	b.Adornee = part
	b.Visible = true
	return b
end

button.Info = {
	"Disconnect Nodes",
	"Manually disconnect nodes",
	"http://www.roblox.com/asset/?id=208425721"
}


function button.Activate(pButton)
	gui.Dialog("Click 2 nodes to disconnect them, Press Z to unselect node")
	pButton:SetActive(true)
end



function button.MDown(hit, pos)
	if hit ~= nil then
		if hit:IsA("Part") and hit.Name == "node_walk" then
			if hit == nodeselected then
				gui.Dialog("Cant disconnect node from itself! Select a second node")
			else
				if nodeselected ~= nil then
					disconnect(hit, nodeselected)
					gui.Dialog("Nodes disconnected!")
					nodeselected.SELECTION:Destroy()
					nodeselected = nil
				else
					gui.Dialog("Node selected!")
					selectionbox(hit)
					nodeselected = hit
				end
			end
		end
	end
end



function button.KeyDown(key)
	key = key:lower()
	if key == "z" then
		gui.Dialog("Node un-selected!")
		nodeselected.SELECTION:Destroy()
		nodeselected = nil
	end
end



return button