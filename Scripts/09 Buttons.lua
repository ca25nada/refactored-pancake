
-- Rotates coordinates x,y by an angle (degrees) from the origin.
local function rotateFromOrigin(x, y, angle)
    local rad = math.rad(angle)
    return x*math.cos(rad) - y*math.sin(rad), x*math.sin(rad) + y*math.cos(rad)
end

-- Returns x2,x2 after rotated from x1,y1 by a specified angle
local function rotateFromPoint(x1, y1, x2, y2, angle)
    local x = x2-x1
    local y = y2-y1

    local newx, newy = rotateFromOrigin(x, y, angle)
    return newx+x1, newy+y1
end

function Actor.GetTrueRotationZ(self)
    if self == nil then
        return 0
    end

    local parent = self:GetParent()

    if parent == nil then
        return self:GetRotationZ()
    else 
        return self:GetRotationZ() + parent:GetTrueRotationZ()
    end
end

--Gets the true X/Y Position by recursively grabbing the parents' position.
--Now Attempts to take parent actors zoom and rotation into account.

function Actor.GetTrueX(self)
	if self == nil then
		return 0
	end

	local parent = self:GetParent()

	if parent == nil then
		return self:GetX()
    else
        local newX,newY = rotateFromOrigin(self:GetX(), self:GetY(), parent:GetTrueRotationZ())
		return newX + parent:GetTrueX()
	end
end

function Actor.GetTrueY(self)
	if self == nil then
		return 0
	end

	local parent = self:GetParent()

	if parent == nil then
		return self:GetY()
    else
        local newX,newY = rotateFromOrigin(self:GetX(), self:GetY(), parent:GetTrueRotationZ())
		return newY + parent:GetTrueY()
	end
end

-- Button Rollovers
function Actor.IsOver(self, mouseX, mouseY)
	if mouseX == nil then
		mouseX = INPUTFILTER:GetMouseX()
	end

	if mouseY == nil then
		mouseY = INPUTFILTER:GetMouseY()
    end
    
    local rotationZ = self:GetTrueRotationZ()

    local x, y = self:GetX(), self:GetY()
    local tx, ty =  self:GetTrueX(), self:GetTrueY()
	local hAlign, vAlign = self:GetHAlign(), self:GetVAlign()
    local w, h = self:GetZoomedWidth(), self:GetZoomedHeight()

    -- Since the boundaries for a rotated rectangle is a pain to calculate, rotate the mouse X/Y coordinates in the opposite direction and compare.
    local newMouseX, newMouseY = rotateFromOrigin(mouseX-tx, mouseY-ty, -rotationZ)

	local withinX = (newMouseX >= (x-(hAlign*w))) and (newMouseX <= ((x+w)-(hAlign*w)))
	local withinY = (newMouseY >= (y-(vAlign*h))) and (newMouseY <= ((y+h)-(vAlign*h)))

	return (withinX and withinY)
end



-- Singleton for button related events.
BUTTON = {
	ButtonTable = {}, -- Table containing all the registered buttons for the current screen. (Might allow multiple screens in the future)
	CurTopButton = nil, -- Current top button that the mouse is hovering over.
    CurDownButton = nil, -- Current button that is being held down.
    IsDraggable = false
}

-- Resets the list of buttons currently added to the given screen. Call when the screen is being initialized.
function BUTTON.ResetButtonTable(self)
	self.ButtonTable = {}
end

-- Add/Register buttons. This is called whenever QuadButton() is called.
function BUTTON.AddButtons(self, Actor)
	self.ButtonTable[#self.ButtonTable+1] = Actor
end

function BUTTON.AddDraggable(self, Actor)

end

-- Updates the position. Sends a broadcast if the position has changed.
-- This is called constantly from _mouse.lua via an updatefunction.
function BUTTON.UpdateMousePosition(self)
	local update = false
	newX = INPUTFILTER:GetMouseX()
	newY = INPUTFILTER:GetMouseY()

	update = true or (newX ~= self.MouseX) or (newY ~= self.MouseY)

	self.MouseX = newX
	self.MouseY = newY

	-- If mouse has moved since the last time the function was called.
	if update then
		
		local CurButton = self:GetTopButton(self.MouseX, self.MouseY)

		-- If the top actor in which the mouse was hovering over has changed.
		if CurButton ~= self.CurTopButton then
			if CurButton ~= nil then 
				self:OnMouseOver(CurButton)
			end
			if self.CurTopButton ~= nil then
				self:OnMouseOut(self.CurTopButton)
			end
		end
		self.CurTopButton = CurButton
	end
end

-- Record where the mousedown event occured.
function BUTTON.SetMouseDown(self, event)
	self.CurDownButton = self.CurTopButton
	if self.CurDownButton ~= nil then -- Only call onmousedown if a button is pressed.
		self:OnMouseDown(self.CurDownButton)
	end
end

-- Record where the mouseup event occured.
function BUTTON.SetMouseUp(self, event)

	-- Make local copies as the values can change before the function ends.
	local CurTopButton = self.CurTopButton
	local CurDownButton = self.CurDownButton

	if CurTopButton == nil then
		if CurDownButton == nil then -- Clicked non-button, release at non-button
            return
            
		else -- Clicked button, release at non-button
			self:OnMouseRelease(CurDownButton)
		end

	else
		if tostring(CurDownButton) == "nil" then -- Clicked non-button, release at button
			self:OnMouseUp(CurTopButton)

		elseif CurDownButton == CurTopButton then -- Clicked button, released on same button
			self:OnMouseUp(CurTopButton)
			self:OnMouseClick(CurTopButton)

		else -- Clicked button, released at different button
			self:OnMouseUp(CurTopButton)
			self:OnMouseRelease(CurDownButton)
		end
	end
	

	self.CurDownButton = nil

end

-- Return the button with the highest Z value that is clickable from coordinates (X,Y)
function BUTTON.GetTopButton(self, x, y)
	local topZ = 0
	local topButton = nil

	for i,v in ipairs(self.ButtonTable) do
		if v:IsOver(x, y) then 
			local z = v:GetZ()
			if z >= topZ then
				topButton = v
				topZ = z
			end
		end
	end

	return topButton
end

-- Called when mouse begins to hover over the actor.
function BUTTON.OnMouseOver(self, actor)
	actor:playcommand("MouseOver")
end

-- Called when the mouse is no longer hovering over the actor.
function BUTTON.OnMouseOut(self, actor)
	actor:playcommand("MouseOut")
end

-- Called when a mouse button is pressed while over the actor.
function BUTTON.OnMouseDown(self, actor, event)
	actor:playcommand("MouseDown")
end

-- Called when a mouse button is released while over the actor.
function BUTTON.OnMouseUp(self, actor, event)
	actor:playcommand("MouseUp")
end

-- Called when both mousedown and mouseup events occur on the same actor.
function BUTTON.OnMouseClick(self, actor, event)
	actor:playcommand("MouseClick")
end

-- Called when a button was pressed but a mouseup event occured while not on the button.
function BUTTON.OnMouseRelease(self, actor, event)
	actor:playcommand("MouseRelease")
end