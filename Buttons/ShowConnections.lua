local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local pathLib = require(script.Parent.Parent.PathfindingLibrary)
local nodes = workspace:FindFirstChild("Nodes", true)
local connections = {}
local masterTable, mnt_index


button.Info = {
	"Connection View",
	"Show individual connections/toggle connection grid",
	""
}


function toggleAll(disable)
	if disable then
		for _, c in pairs(connections) do
			c:Destroy()
		end
	else
		for _, n in pairs(nodes:GetChildren()) do
			toggleNode(n)
		end
	end
end

function toggleNode(node, disable)
	--gui.DrawLine()
	if disable then
		local localId = pathLib.SearchByBrick(masterTable, node)
		for id, c in pairs(connections) do
			if id == localId then
				c:Destroy()
				table.remove(connections, id)
			end
		end
	else
		for _, c in pairs(node:GetChildren()) do
			if c.Name == "connection" then
				if c.Value ~= nil then
					local con = c.Value
					local line = gui.DrawLine(c.Position, con.Position)
					local id = pathLib.SearchByBrick(masterTable, node)
					if connections[id] == nil then
						connections[id] = {}
						table.insert(connections[id], line)
					else
						table.insert(connections[id], line)
					end
				end
			end
		end
	end
end


function button.Activate(pButton)
	pButton:SetActive(true)
	nodes = workspace:FindFirstChild("Nodes", true)
	if nodes then
		masterTable, mnt_index = pathLib.CollectNodes(nodes)
		gui.Dialog("Click nodes to see their connections, press MOUSE2 to unselect, press 'C' to show ALL connections")
	else
		gui.Dialog("'Nodes' not a descendant of Workspace, cannot use this feature")
		pButton:SetActive(false)
	end
end


function button.MDown(hit, pos)
	if hit ~= nil then
		if hit.Name == "node_walk" then
			if hit:FindFirstChild("Connection") then
				toggleNode(hit)
			else
				gui.Dialog("Node has no connections")
			end
		end
	end
end


function button.M2Down(hit, pos)
	if hit ~= nil then
		if hit.Name == "node_walk" then
			if hit:FindFirstChild("Connection") then
				toggleNode(hit, true)
			end
		end
	end
end

function button.KeyDown(key)
	if key == "c" then
		toggleAll()
	end
end



return button