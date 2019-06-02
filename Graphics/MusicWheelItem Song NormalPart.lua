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

t[#t+1] = UIElements.QuadButton(1) .. {
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
		self:xy(500-5,-22+10)
		self:halign(1)
		self:zoom(0.4)
	end,
	SetMessageCommand = function(self,params)
		local song = params.Song

		if song then
			local seconds = song:GetStepsSeconds()
			self:visible(true)
			if seconds < PREFSMAN:GetPreference("LongVerSongSeconds") then
				self:settext("Normal")
				self:diffuse(COLOR.TextMain)
			elseif seconds < PREFSMAN:GetPreference("MarathonVerSongSeconds") then
				self:settext("Long")
				self:diffuse(COLOR.SongLong)
			elseif seconds < PREFSMAN:GetPreference("MarathonVerSongSeconds")*2 then
				self:settext("Marathon")
				self:diffuse(COLOR.SongMarathon)
			else
				self:settext("UltraMarathon")
				self:diffuse(COLOR.SongUltraMarathon)
			end
		end
	end
}

t[#t+1] = UIElements.Border(500,40,1)..{
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
