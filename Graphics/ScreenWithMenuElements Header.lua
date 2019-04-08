
local height = 20
local top

local t = Def.ActorFrame{
	OnCommand = function(self)
		top = SCREENMAN:GetTopScreen()
	end
}

t[#t+1] = Def.Quad{
	InitCommand = function(self)
		self:xy(-30,45)
		self:halign(0)
		self:zoomto(500,15)
		self:skewx(-0.02)
		self:diffuse(COLOR.MainHighlight)
	end
}

t[#t+1] = LoadFont("DFPGothic 64px")..{
	Name = "HeaderTitle",
	Text = Screen.String("HeaderText"),
	InitCommand = function (self)
		self:diffuse(COLOR.TextMain)
		self:zoom(0.6)
		self:halign(0)
		self:xy(10,30)
	end,
	UpdateScreenHeaderMessageCommand = function(self,param)
		self:settext(param.Header)
	end
}

return t