local t = Def.ActorFrame{}

t[#t+1] = LoadActor(THEME:GetPathG("","Profilebar"),{Rating = "10.34",ProfileName = "Prim", AvatarPath = getAvatarPath(PLAYER_1)})..{
	InitCommand = function(self)
		self:xy(SCREEN_WIDTH-140,45)
	end;
}

t[#t+1] = StandardDecorationFromFileOptional("Header","Header")

return t