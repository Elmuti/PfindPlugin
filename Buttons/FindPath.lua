local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local pathLib = require(script.Parent.Parent.PathfindingLibrary)
local nodeselected = nil
local nodes = workspace:FindFirstChild("Nodes", true)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

button.Info = {
	"Find Path",
	"Find a path on an existing nodegraph in workspace",
	"http://www.roblox.com/asset/?id=207047513"
}

function selectionbox(part)
	local b = Instance.new("SelectionBox", part)
	b.Name = "SELECTION"
	b.Adornee = part
	b.Visible = true
	return b
end


function button.Activate(pButton)
	pButton:SetActive(true)
	nodes = workspace:FindFirstChild("Nodes", true)
	if nodes then
		gui.Dialog("Click any 2 nodes to find the shortest path between them. 'Z' un-selects node, 'X' deletes drawn paths", 4)
	else
		gui.Dialog("Cannot find paths, nodegraph not found in workspace!")
		pButton:SetActive(false)
	end
end


function button.MDown(hit, pos)
	if hit ~= nil then
		if hit:IsA("Part") and hit.Name == "node_walk" then
			if nodeselected ~= nil then
				local masterTable, mnt_index = pathLib.CollectNodes(nodes)
				local id1 = pathLib.SearchByBrick(masterTable, hit)
				local id2 = pathLib.SearchByBrick(masterTable, nodeselected)
				local path = pathLib.AStar(masterTable, id1, id2)
				local drawn = pathLib.DrawPath(path)
				drawn.Name = "PluginFoundPath"
				drawn.Parent = workspace.Ignore
				gui.Dialog("Path found and drawn! Additional info in output", 2.2)
				warn("Path length in nodes: " .. #path .. " , Path length in studs: " .. pathLib.GetPathLength(path))
				nodeselected.SELECTION:Destroy()
				nodeselected = nil
			else
				selectionbox(hit)
				nodeselected = hit
				gui.Dialog("Node selected!", 1.5)
			end
		end
	end
end



function button.KeyDown(key)
	if key == "z" then
		if nodeselected ~= nil then
			nodeselected.SELECTION:Destroy()
			nodeselected = nil
			gui.Dialog("Canceled node select", 1.5)
		end
	elseif key == "x" then
		for k,v in pairs(workspace.Ignore:children()) do
			if v.Name == "PluginFoundPath" then
				v:Destroy()
			end
		end
	end
end




return button