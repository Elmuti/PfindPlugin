local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local pathLib = require(script.Parent.Parent.PathfindingLibrary)
local nodes = workspace:FindFirstChild("Nodes", true)
local masterTable, mnt_index


button.Info = {
	"Show IDs",
	"Show node IDs",
	""
}

--localId = pathLib.SearchByBrick(masterTable, node)

function bbgui(p, text)
	local bg = Instance.new("BillboardGui", p)
	local lb = Instance.new("TextLabel", bg)
	bg.Adornee = p
	bg.Name = "NodeIdDisplay"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.StudsOffset = Vector3.new(0, 2, 0)
	lb.Size = UDim2.new(1, 0, 1, 0)
	lb.BackgroundTransparency = 1
	lb.TextColor3 = Color3.new(1, 1, 1)
	lb.FontSize = Enum.FontSize.Size24
	lb.Text = text
	return bg
end


function button.Activate(pButton)
	pButton:SetActive(true)
	nodes = workspace:FindFirstChild("Nodes", true)
	if nodes then
		if #nodes:GetChildren() > 0 then
			masterTable, mnt_index = pathLib.CollectNodes(nodes)
			for _, node in pairs(nodes:GetChildren()) do
				if node:FindFirstChild("NodeIdDisplay") then
					node.NodeIdDisplay:Destroy()
				else
					local id = pathLib.SearchByBrick(masterTable, node)
					bbgui(node, "#" .. id)
				end
			end
			pButton:SetActive(false)
		else
			gui.Dialog("Nodes model is empty, cannot use this feature")
			pButton:SetActive(false)
		end
	else
		gui.Dialog("'Nodes' not a descendant of Workspace, cannot use this feature")
		pButton:SetActive(false)
	end
end




return button