local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)


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


button.Info = {
	"Remove Nodes",
	"Remove existing nodes and any connections to them",
	"http://www.roblox.com/asset/?id=208426068"
}


function button.Activate(pButton)
	pButton:SetActive(true)
	gui.Dialog("Click a node to remove it. CANNOT BE UN-DONE.")
end



function button.MDown(hit, pos)
	if hit ~= nil then
		if hit:IsA("Part") and hit.Name == "node_walk" then
			for _, con in pairs(hit:GetChildren()) do
				if con.Name == "connection" then
					disconnect(hit, con.Value)
				end
			end
			hit:Destroy()
			gui.Dialog("Node and its connections removed successfully.", 1.5)
		end
	end
end




return button