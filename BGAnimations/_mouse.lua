local screenName = ...
local topScreen

assert(type(screenName) == "string", "Screen Name must be specified when loading _mouse.lua")
BUTTON:ResetButtonTable(screenName)

local function Input(Event)
    if Event.type == "InputEventType_FirstPress" then
		if Event.DeviceInput.button == "DeviceButton_left mouse button" then
            BUTTON:SetMouseDown(Event.DeviceInput.button)
		end
		if Event.DeviceInput.button == "DeviceButton_right mouse button" then
            BUTTON:SetMouseDown(Event.DeviceInput.button)
        end
    end

    if Event.type == "InputEventType_Release" then
		if Event.DeviceInput.button == "DeviceButton_left mouse button" then
            BUTTON:SetMouseUp(Event.DeviceInput.button)
		end
		if Event.DeviceInput.button == "DeviceButton_right mouse button" then
            BUTTON:SetMouseUp(Event.DeviceInput.button)
        end
    end
end

local t = Def.ActorFrame{
    OnCommand = function(self)
        topScreen = SCREENMAN:GetTopScreen()
        topScreen:AddInputCallback(Input)
    end,
    OffCommand = function(self)
        BUTTON:ResetButtonTable(screenName)
        TOOLTIP:Hide()
    end,
}

return t