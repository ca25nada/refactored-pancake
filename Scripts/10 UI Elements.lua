-- Adapted from  Simply-Love-SM5/Scripts/SL-Helpers.lua
function Border(width, height, bw)
	return Def.ActorFrame {
		Def.Quad {
			Name = "MaskSource",
			InitCommand = function(self)
				self:zoomto(width, height):MaskSource(true)
			end
		},
		Def.Quad {
			Name = "MaskDest",
			InitCommand = function(self)
				self:zoomto(width+2*bw,height+2*bw):MaskDest()
			end
		},
		Def.Quad {
			Name = "ClearBuffer",
			InitCommand = function(self)
				self:diffusealpha(0):clearzbuffer(true)
			end
		},
	}
end

-- Basic clickable button implementation with quads
function QuadButton(z, depth)

	local t = Def.Quad{
		InitCommand = function(self) 
			self:z(z)
		end,
		OnCommand = function(self)
			local screen = SCREENMAN:GetTopScreen()
			if screen ~= nil then
				BUTTON:AddButton(self, screen:GetName(), depth)
			end
		end,
		MouseOverCommand = function(self) end,
		MouseOutCommand = function(self) end,
		MouseUpCommand = function(self) end,
		MouseDownCommand = function(self) end,
		MouseClickCommand = function(self) end,
		MouseReleaseCommand = function(self) end,
	}
	return t
end

-- Basic clickable button implementation with quads
function ButtonDemo(z)

	local t = Def.ActorFrame{
		RolloverUpdateCommand = function(self, params)
			self:PlayCommandsOnChildren("RolloverUpdate", params)
		end,
		ClickCommand = function(self, params)
			self:PlayCommandsOnChildren("Click", params)
		end,
		DragUpdateCommand = function(self, params)
			self:xy(params.MouseX, params.MouseY)
		end,
	}
	
	t[#t+1] = Border(150, 50, 5)..{
		InitCommand = function(self)
			self:visible(false):diffuse(color("#000000"))
		end,
		RolloverUpdateCommand = function(self, params)
			if params.update == "over" then
				self:visible(true)
				TOOLTIP:Show()
				TOOLTIP:SetText(string.format("X:%0.2f Y:%0.2f", self:GetTrueX(), self:GetTrueY()))
			end
		
			if params.update == "out" then
				self:visible(false)
				TOOLTIP:Hide()
			end
		end
	}

	t[#t+1] = QuadButton(z, 1)..{
		InitCommand= function(self) 
			self:z(z):zoomto(150,50):diffuse(color("#000000")):diffusealpha(0.5)
		end,
		MouseOverCommand = function(self) self:GetParent():playcommand("RolloverUpdate",{update = "over"}) end,
		MouseOutCommand = function(self) self:GetParent():playcommand("RolloverUpdate",{update = "out"}) end,
		MouseUpCommand = function(self) self:diffuse(color("#FF0000")):diffusealpha(0.5) self:GetParent():playcommand("Click",{update = "OnMouseUp"}) end,
		MouseDownCommand = function(self) self:diffuse(color("#00FF00")):diffusealpha(0.5) self:GetParent():playcommand("Click",{update = "OnMouseDown"}) end,
		MouseClickCommand = function(self) self:diffuse(color("#0000FF")):diffusealpha(0.5) self:GetParent():playcommand("Click",{update = "OnMouseClicked"}) end,
		MouseReleaseCommand = function(self) self:diffuse(color("#FF00FF")):diffusealpha(0.5) self:GetParent():playcommand("Click",{update = "OnMouseReleased"}) end,
		MouseDragCommand = function(self, params) self:GetParent():playcommand("DragUpdate", params) end,
	}

	t[#t+1] = LoadFont("Common Normal") .. {
		InitCommand= function(self) 
			self:y(0):zoom(0.6):settext("init")
		end,
		ClickCommand = function(self, params)
			self:settextf("X:%.0f Y:%.0f \nAngle:%.0f",self:GetTrueX(), self:GetTrueY(), self:GetTrueRotationZ()%360)
		end,
	}

	return t
end


-- Checkboxes
function CheckBox(z, checked)

	local zoom = 0.15
	local checked = checked

	local t = Def.ActorFrame{
		InitCommand = function(self)
			self:playcommand("Toggle")
		end,
		ToggleCommand = function(self)
			if checked then 
				checked = false
				self:playcommand("Uncheck")
				self:RunCommandsOnChildren(function(self) self:playcommand("Uncheck") end)
			else
				checked = true
				self:playcommand("Check")
				self:RunCommandsOnChildren(function(self) self:playcommand("Check") end)
			end
		end,
		CheckCommand = function(self)
		end,

		UncheckCommand = function(self)
		end
	}

	t[#t+1] = Def.Quad{
		InitCommand = function(self)
			self:zoomto(zoom*100,zoom*100)
			self:diffuse(color("#000000")):diffusealpha(0.8)
		end
	}

	t[#t+1] = QuadButton(z) .. {
		InitCommand = function(self)
			self:zoomto(zoom*100,zoom*100)
			self:diffuse(color("#FFFFFF")):diffusealpha(0)
		end,
		OnCommand = function(self)
			BUTTON:AddButtons(self)
		end,
	}

	t[#t+1] = LoadActor(THEME:GetPathG("", "_x"))..{
		InitCommand = function(self)
			self:zoom(zoom)
		end,
		CheckCommand = function(self)
			self:finishtweening()
			self:smooth(0.1)
			self:zoom(zoom)
			self:diffusealpha(1)
		end,
		UncheckCommand = function(self)
			self:finishtweening()
			self:smooth(0.1)
			self:zoom(0)
			self:diffusealpha(0)
		end
	}

	return t
end