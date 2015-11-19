local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)


button.Info = {
	"Toggle Clutter",
	"Toggle node/connection visibility",
	""
}


function button.Activate(pButton)
	pButton:SetActive(true)
	gui.Dialog("Sorry, this button is still under work! Will be finished in the next version :)")
	pButton:SetActive(false)
end



return button