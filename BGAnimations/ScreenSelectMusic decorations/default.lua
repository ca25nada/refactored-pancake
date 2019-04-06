local t = Def.ActorFrame{}

t[#t+1] = LoadActor(THEME:GetPathG("","Profilebar"),{Rating = "10.34",ProfileName = "Prim", AvatarPath = getAvatarPath(PLAYER_1)})..{
	InitCommand = function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
	end;
}

return t