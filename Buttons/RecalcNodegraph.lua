local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local nodes = game:findFirstChild("Nodes", true)

local showConnections = true
local numConnections = 0
local numNodes = 0
local numPaths = 0
local draw = false


local humanHull = {
	Vector3.new(0, 5, 0);
	Vector3.new(0, 0, 0);
	Vector3.new(-1, 4, -1);
	Vector3.new(1, 4, 1);
	Vector3.new(1, 4, -1);
	Vector3.new(-1, 4, 1);
}


local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local ignore = workspace:findFirstChild("Ignore")

if not ignore then
	ignore = Instance.new("Model", workspace)
	ignore.Name = "Ignore"
end

function disconnectAll(nodes)
	for _, c in pairs(nodes:children()) do
		if c.Name == "connection" then
			c:Destroy()
		else
			disconnectAll(c)
		end
	end
end

function connect(a, b)
	local conVal = Instance.new("ObjectValue", a)
	local conVal2 = Instance.new("ObjectValue", b)
	conVal.Name = "connection"
	conVal2.Name = "connection"
	conVal.Value = b
	conVal2.Value = a
	if draw then
		gui.DrawLine(a.Position, b.Position)
	end
end


function newRay(a, b, d)
	return Ray.new(a, (b - a).unit * d)
end


function isConnected(a, b)
	local pos1 = a.Position
	local pos2 = b.Position
	local hitCount = 0
	
	local firstRayPos = pos1 + humanHull[1]
	local ray = newRay(firstRayPos, pos1, 10)
	local firstRayHit = workspace:FindPartOnRayWithIgnoreList(ray, {ignore})
	
	--gui.DrawLine(pos1, firstpos, BrickColor.new("Bright red"))
	
	if firstRayHit then
		for hullpos = 1, #humanHull do
			local origin =  pos1 + humanHull[hullpos]
			local ray = newRay(origin, pos2, 100)
			local hit = workspace:FindPartOnRayWithIgnoreList(ray, {ignore})
			
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


function connectNodes(nodes)
	local amount = #nodes:children()
	local bar = gui.ProgressBar("Compiling nodegraph...", 0)
	local now = tick()
	for _, n1 in pairs(nodes:children()) do
		numNodes = numNodes + 1
		bar:TextUpdate("Compiling nodegraph...\n"..numNodes.." / "..amount.." nodes parsed")
		bar:Update(numNodes / amount * 100)
		for _, n2 in pairs(nodes:children()) do
			numPaths = numPaths + 1
			if isConnected(n1, n2) then
				numConnections = numConnections + 1
				connect(n1, n2)
			end
		end
	end
	bar:Kill()
	gui.Dialog("Nodegraph was calculated successfully! The compile took "..tostring(round(tick() - now, 4)).." seconds. See output for extra information.")
	warn(tostring(numConnections).." connections were created on "..tostring(numNodes).." nodes!") 
	warn(tostring(numPaths).." possible paths")
	numNodes = 0
	numConnections = 0
	numPaths = 0
end


button.Info = {
	"Recalculate Nodegraph",
	"Calculate or Recalculate an existing Nodegraph in workspace. Will overwrite any previous graph!",
	"http://www.roblox.com/asset/?id=207047507"
}


function button.Activate(pButton)
	pButton:SetActive(true)
	draw = gui.Dialog("Draw lines between connected nodes?", 0, "YesNo")
	nodes = workspace:findFirstChild("Nodes", true)
	if nodes ~= nil then
		disconnectAll(nodes)
		connectNodes(nodes)
	else
		gui.Dialog("'Nodes' IS NOT A VALID DESCENDANT OF WORKSPACE, CANNOT CALCULATE NODEGRAPH", false, true)
	end
end



return button
