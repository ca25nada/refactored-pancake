local t = Def.ActorFrame{
	InitCommand = function(self)
		self:rotationz(0)
	end;
}

t[#t+1] = LoadActor("../_mouse.lua", "ScreenSelectMusic")

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

t[#t+1] = Def.ActorFrame{
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):spin():effectmagnitude(0,0	,-10)
	end,
	Def.ActorFrame{
		InitCommand = function(self)
			self:xy(200,200):spin():effectmagnitude(0,0	,20)
		end,
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(0,0):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(-200,0):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(200,0):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(-200,-200):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(0,-200):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(200,-200):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(-200,200):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(0,200):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		},
		ButtonDemo(500)..{
			InitCommand = function(self)
				self:xy(200,200):rotationz(12):spin():effectmagnitude(0,0,(math.random()-0.5)*150)
			end
		}
	},
}

t[#t+1] = UIElements.CheckBox(10, true) .. {
	InitCommand = function(self)
		self:xy(200,200)
	end
}

t[#t+1] = UIElements.Slider(10, 400) .. {
	InitCommand = function(self)
		self:xy(400,400)
	end
}

return t