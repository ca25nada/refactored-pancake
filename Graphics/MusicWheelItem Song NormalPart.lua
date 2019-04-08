local curFolder = ""
local top
local t =  Def.ActorFrame{
	OnCommand = function(self)
		top = SCREENMAN:GetTopScreen()
	end,
	SetCommand = function(self,params)
		self:name(tostring(params.Index))
	end
}


t[#t+1] = Def.Quad{
	InitCommand= function(self) 
		self:x(0)
		self:zoomto(500,40)
		self:halign(0)
		self:zwrite(true):clearzbuffer(true):blend('BlendMode_NoEffect')
	end
}

t[#t+1] = QuadButton(1) .. {
	InitCommand= function(self) 
		self:x(0)
		self:zoomto(500,40)
		self:halign(0)
		self:visible(false)
	end,
	TopPressedCommand = function(self, params)
		if params.input ~= "DeviceButton_left mouse button" then
			return
		end

		local newIndex = tonumber(self:GetParent():GetName())
		local wheel = top:GetMusicWheel()
		local size = wheel:GetNumItems()
		local move = newIndex-wheel:GetCurrentIndex()

		if math.abs(move)>math.floor(size/2) then
			if newIndex > wheel:GetCurrentIndex() then
				move = (move)%size-size
			else
				move = (move)%size
			end
		end
		
		local wheelType = wheel:MoveAndCheckType(move)
		wheel:Move(0)

		-- TODO: play sounds.
		if move == 0 then
			if wheelType == 'WheelItemDataType_Section' then
				if wheel:GetSelectedSection() == curFolder then
					wheel:SetOpenSection("")
					curFolder = ""
				else
					wheel:SetOpenSection(wheel:GetSelectedSection())
					curFolder = wheel:GetSelectedSection()
				end
			else
				top:SelectCurrent(0)
			end
		end
	end
}

t[#t+1] = Def.Quad{
	InitCommand= function(self) 
		self:x(0)
		self:zoomto(500,40)
		self:halign(0)
	end,
	SetCommand = function(self)
		self:name("Wheel"..tostring(self:GetParent():GetName()))
		self:diffusealpha(0.8)
	end,
	BeginCommand = function(self) self:queuecommand('Set') end,
	OffCommand = function(self) self:visible(false) end
}

t[#t+1] = Def.Sprite {
	InitCommand = function(self)
		self:halign(0)
		self:x(5)
	 	self:diffusealpha(0.8)
	end,
	SetMessageCommand = function(self,params)
		local song = params.Song
		local bnpath = nil
		if song then
			bnpath = params.Song:GetBannerPath()
			if bnpath then
				self:LoadBackground(bnpath)
				self:zoomto(96,30)
			end
		end
	end
}


t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand = function(self)
		self:xy(340-5,-22+5)
		self:halign(1)
		self:zoom(0.3)
	end,
	SetMessageCommand = function(self,params)
		local song = params.Song

		if song then
			local seconds = song:GetStepsSeconds()
			self:visible(true)
			if seconds > PREFSMAN:GetPreference("MarathonVerSongSeconds") then
				self:settext("Marathon")
			elseif seconds > PREFSMAN:GetPreference("LongVerSongSeconds") then
				self:settext("Long")
			else
				self:visible(false)
			end
			--self:diffuse(getSongLengthColor(seconds))
		end
	end
}

t[#t+1] = Border(500,40,1)..{
	InitCommand = function(self)
		self:diffuse(COLOR.MainBorder)
		self:x(250)
	end
}

t[#t+1] = LoadActor("round_star") .. {
	InitCommand = function(self)
		self:xy(3,-19)
		self:zoom(0.25)
		self:wag()
		self:diffuse(Color.Yellow)
	end,
	SetMessageCommand = function(self,params)
		local song = params.Song
		self:visible(false)
		if song then
			if song:IsFavorited() then
				self:visible(true)
			end
		end
	end
}

return t
