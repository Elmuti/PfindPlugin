local gm = {}


local coreGui = game:GetService("CoreGui")
local root = script.Parent.Guis
local sgui = Instance.new("ScreenGui", coreGui)



local function c3(r, g, b)
	return Color3.new(r/255, g/255, b/255)
end


function gm.DrawLine(pos1, pos2)
	local ignore = workspace:findFirstChild("Ignore")
	if not ignore then
		ignore = Instance.new("Model", workspace)
		ignore.Name = "Ignore"
	end
	
	local dist = (pos1-pos2).magnitude
	local rayPart = Instance.new("Part", workspace.Ignore)
	rayPart.Name = "NodeConnector"
	rayPart.BrickColor = BrickColor.new("Lime green")
	rayPart.Transparency = 0.5
	rayPart.Anchored = true
	rayPart.CanCollide = false
	rayPart.TopSurface = Enum.SurfaceType.Smooth
	rayPart.BottomSurface = Enum.SurfaceType.Smooth
	rayPart.formFactor = Enum.FormFactor.Custom
	rayPart.Size = Vector3.new(0.2, 0.2, dist)
	rayPart.CFrame = CFrame.new(pos1, pos2) * CFrame.new(0, 0, -dist/2)
	rayPart.Archivable = false
	return rayPart
end



function gm.Dialog(text, dur, dtype)
	local dur = dur or 2
	local dg
	if dtype ~= nil then
		dg = root["Dialog"..dtype]:clone()
	else
		dg = root["Dialog"]:clone()
	end
	print(text)
	dg.TextLabel.Text = text
	
	local origin = dg.Position
	dg.Position = UDim2.new(0.4, 0, -0.4, 0)
	dg.Parent = sgui
	dg:TweenPosition(origin, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
	
	if dtype == "YesNo" or dtype == "OkCancel" then
		local yes, no = false, false
		dg.YesButton.MouseButton1Click:connect(function()
			yes = true
		end)
		dg.NoButton.MouseButton1Click:connect(function()
			no = true
		end)
		repeat
			wait()
		until yes or no
		dg:TweenPosition(UDim2.new(0.4, 0, -0.4, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
		if yes then
			return true
		else
			return false
		end
	else
		spawn(function()
			wait(dur)
			dg:TweenPosition(UDim2.new(0.4, 0, -0.4, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
		end)
	end
end



function gm.ProgressBar(text, pct)
	local pb = root.DialogProgressbar:clone()
	
	local origin = pb.Position
	pb.Position = UDim2.new(0.4, 0, -0.4, 0)
	pb.Parent = sgui
	pb.TextLabel.Text = text
	pb:TweenPosition(origin, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
	
	return {
		instance = pb.ProgressFrame.ProgressBar;
		percentage = 0;
		Update = function(self, pct)
			self.instance:TweenSize(UDim2.new(pct / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25)
			self.instance.Parent.Percentage.Text = math.floor(pct) .. " %"
		end;
		TextUpdate = function(self, text)
			self.instance.Parent.Parent.TextLabel.Text = text
		end;
		Kill = function(self)
			self.instance.Parent.Parent:TweenPosition(UDim2.new(0.4, 0, -0.4, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
			wait(0.6)
			self.instance.Parent.Parent:Destroy()
		end;
	}
end



return gm

