local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local history = {}
local nodeDir = workspace:FindFirstChild("Nodes", true)
local showConnections = true
local nodeselected = nil

function selectionbox(part)
	local b = Instance.new("SelectionBox", part)
	b.Name = "SELECTION"
	b.Adornee = part
	b.Visible = true
	return b
end

function connect(a, b, draw)
	local conVal = Instance.new("ObjectValue", a)
	local conVal2 = Instance.new("ObjectValue", b)
	conVal.Name = "connection"
	conVal2.Name = "connection"
	conVal.Value = b
	conVal2.Value = a
	if showConnections then
		gui.DrawLine(a.Position, b.Position)
	end
end


button.Info = {
	"Connect Nodes",
	"Manually connect nodes",
	"http://www.roblox.com/asset/?id=207047511"
}


function button.Activate(pButton)
	gui.Dialog("Click 2 nodes to connect them, Press C to toggle showing new connections,  Press Z to unselect node")
	pButton:SetActive(true)
end



function button.MDown(hit, pos)
	if hit ~= nil then
		if hit:IsA("Part") and hit.Name == "node_walk" then
			if hit == nodeselected then
				gui.Dialog("Cant connect node to itself!", 1.5)
			else
				if nodeselected ~= nil then
					connect(hit, nodeselected)
					gui.Dialog("Nodes connected!", 1)
					nodeselected.SELECTION:Destroy()
					nodeselected = nil
				else
					gui.Dialog("Node selected!", 1)
					selectionbox(hit)
					nodeselected = hit
				end
			end
		end
	end
end



function button.KeyDown(key)
	key = key:lower()
	if key == "c" then
		showConnections = not showConnections
		gui.Dialog("Changed showing connections to: "..tostring(showConnections))
	elseif key == "z" then
		gui.Dialog("Node unselected!", 1.5)
		nodeselected.SELECTION:Destroy()
		nodeselected = nil
	end
end



return button