local buttons = script.Parent.Buttons

local loadOrder = {
	"PlaceNodes";
	"RecalcNodegraph";
	"ManualNodeConnect";
	"ManualDisconnect";
	"NodeRemover";
	"FindPath";
	"InstallModule";
	"VersionCheck";
	"ClutterToggle";
	"ShowIDs";
	"IsConnected";
}


function createButtons()
	for _, btnName in pairs(loadOrder) do
		local buttonStatus, err = pcall(function()
			local button = buttons:FindFirstChild(btnName)
			local newButton = require(button)
			local Plugin = PluginManager():CreatePlugin()
			local Toolbar = Plugin:CreateToolbar("StealthKing95's Pathfinding Tools")
			local PluginButton = Toolbar:CreateButton(newButton.Info[1], newButton.Info[2], newButton.Info[3])
			local mouse = Plugin:GetMouse()
			
			if newButton.Deactivate ~= nil then
				Plugin.Deactivation:connect(newButton.Deactivate)
			end
			
			PluginButton.Click:connect(function()
				if newButton.Click ~= nil then
					newButton.Click()
				end
				newButton.Active = not newButton.Active
				if newButton.Active then
					Plugin:Activate(true)
					newButton.Activate(PluginButton)
				else
					if newButton.Deactivate ~= nil then
						newButton.Deactivate(PluginButton)
					end
					PluginButton:SetActive(false)
				end
			end)
	
			mouse.Button1Down:connect(function()
				if newButton.MDown ~= nil then
					newButton.MDown(mouse.Target, mouse.Hit.p)
				end
			end)
			
			mouse.Button2Down:connect(function()
				if newButton.M2Down ~= nil then
					newButton.M2Down(mouse.Target, mouse.Hit.p)
				end
			end)
			
			mouse.KeyDown:connect(function(key)
				if newButton.KeyDown ~= nil then
					newButton.KeyDown(key)
				end
			end)
		end)
		
		if not buttonStatus then
			error(err)
		end
	end
end


wait(1)
createButtons()