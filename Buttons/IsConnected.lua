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


button.Info = {
	"Hull con.",
	"Check Hull connections between nodes",
	""
}


function button.Activate(pButton)
	pButton:SetActive(true)
end


local humanHull = {
	Vector3.new(0, 5, 0);
	Vector3.new(0, 0, 0);
	Vector3.new(-1, 4, -1);
	Vector3.new(1, 4, 1);
	Vector3.new(1, 4, -1);
	Vector3.new(-1, 4, 1);
}


local ignore = workspace:WaitForChild("Ignore")

function newRay(a, b, d)
	return Ray.new(a, (b - a).unit * d)
end


function isConnected(a, b)
	local pos1 = a.Position
	local pos2 = b.Position
	local hitCount = 0
	
	local firstRayPos = pos1 + humanHull[1]
	local ray = newRay(firstRayPos, pos1, 10)
	local firstRayHit, firstpos = workspace:FindPartOnRayWithIgnoreList(ray, {ignore, workspace.Map.Entities, workspace.Map.Spawns})
	
	--gui.DrawLine(pos1, firstpos, BrickColor.new("Bright red"))
	
	if firstRayHit then
		for hullpos = 1, #humanHull do
			local origin =  pos1 + humanHull[hullpos]
			local ray = newRay(origin, pos2, 100)
			local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {ignore, workspace.Map.Entities, workspace.Map.Spawns})
			
			--gui.DrawLine(origin, pos)
			
			if hit then
				if hit == b then
					hitCount = hitCount + 1
				end
			end
		end
		if hitCount == #humanHull then
			return true
		end
	end
	return false
end

function button.MDown(hit, pos)
	if hit ~= nil then
		if hit:IsA("Part") and hit.Name == "node_walk" then
			if hit == nodeselected then
				gui.Dialog("Cant connect node to itself!", 1.5)
			else
				if nodeselected ~= nil then
					local nodeConnection = isConnected(nodeselected, hit)
					gui.Dialog("Nodes connected: "..tostring(nodeConnection), 1)
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