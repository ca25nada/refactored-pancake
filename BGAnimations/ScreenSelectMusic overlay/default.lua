local t = Def.ActorFrame{}

t[#t+1] = LoadActor("../_mouse.lua")

t[#t+1] = LoadActor(THEME:GetPathG("","Profilebar"))..{
	OnCommand = function(self)
		self:xy(SCREEN_WIDTH-140,45)
		self:playcommand("Set")
	end,
	SetCommand = function(self)
		local Name = ""
		local LocalSR = 0 
		local OnlineSR = 0
		local OnlineRank = 0
		local Params
		local AvatarPath = getAvatarPath(PLAYER)

		if DLMAN:IsLoggedIn() then
			OnlineRank = DLMAN:GetSkillsetRank("Overall")
			OnlineSR = DLMAN:GetSkillsetRating("Overall")
			Name = DLMAN:GetUsername()
			Params = {AvatarPath = AvatarPath, Rating = OnlineSR, ProfileName = Name, Rank = OnlineRank}
		else
			OnlineRank = DLMAN:GetSkillsetRank("Overall")
			LocalSR = GetPlayerOrMachineProfile(PLAYER):GetPlayerRating()
			Name = GetPlayerOrMachineProfile(PLAYER):GetDisplayName()
			Params = {AvatarPath = AvatarPath, Rating = LocalSR, ProfileName = Name, Rank = 0}
		end

		self:playcommand("Update", Params)
	end,
	LoginMessageCommand = function(self) self:playcommand("Set") end,
	LogOutMessageCommand = function(self) self:playcommand("Set") end,
	OnlineUpdateMessageCommand = function(self) self:playcommand("Set") end,
}


t[#t+1] = StandardDecorationFromFileOptional("Header","Header")

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(700,SCREEN_CENTER_Y)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(900,SCREEN_CENTER_Y)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(1100,SCREEN_CENTER_Y)
	end
}


t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(700,SCREEN_CENTER_Y-200)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(900,SCREEN_CENTER_Y-200)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(1100,SCREEN_CENTER_Y-200)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(700,SCREEN_CENTER_Y+200)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(900,SCREEN_CENTER_Y+200)
	end
}

t[#t+1] = ButtonDemo(500)..{
	InitCommand = function(self)
		self:xy(1100,SCREEN_CENTER_Y+200)
	end
}


return t