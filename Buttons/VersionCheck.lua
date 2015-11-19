local button = {}
button.Active = false
local coregui = game:GetService("CoreGui")
local gui = require(script.Parent.Parent.DialogLib)
local mps = game:GetService("MarketplaceService")


local moduleversion = 3.0


button.Info = {
	"Version Check",
	"Check if the version of this plugin is up to date",
	""
}

function checkVersion()
	local newestVers = moduleversion
	local desc = mps:GetProductInfo(313444087).Description
	local s, e = string.find(desc, "Newest version: ")
	if s ~= nil and e ~= nil then
		newestVers = desc:sub(e)
	end
	return newestVers
end


function button.Activate(pButton)
	pButton:SetActive(true)
	local oldVers = moduleversion
	local vers = checkVersion()
	if (tonumber(vers) or 0) > (tonumber(oldVers) or 0) then
		gui.Dialog("Your version is outdated! (Current version: "..oldVers..", Newest version: "..vers..")")
	else
		gui.Dialog("Your version is up to date! (Current version: "..oldVers..")")
	end
	pButton:SetActive(false)
end



return button