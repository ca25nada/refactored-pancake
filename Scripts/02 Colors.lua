COLOR = {
	MainBackground = color("#FFFFFF"),	-- White
	MainHighlight = color("#FFB4B4"),	-- Pink
	MainBorder = color("#4C4C4C"),		-- Black 70%
	UICaution = "", 					-- Yellow
	UIWarning = "", 					-- Red
	UINew = "", 						-- Blue
	UIAction = "", 						-- Green
	TextMain = color("#4C4C4C"),		-- Black 70%
	TextSub1 = color("#666666"),		-- Black 60%
	TextSub2 = color("#808080"),		-- Black 50%/Grey

}



function GetRatingColors(rating)
	SCREENMAN:SystemMessage((198 - math.floor(rating,35)*(324/35))%360)
	return HSV(((198 - math.floor(rating,35)*(324/35))%360), 0.5, 0.75)
end