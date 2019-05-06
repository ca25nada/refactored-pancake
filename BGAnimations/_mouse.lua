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

local function UpdateLoop()
    BUTTON:UpdateMouseState()
    return false
end

local t = Def.ActorFrame{
    InitCommand = function(self)
        BUTTON:ResetButtonTable()
        self:SetUpdateFunction(UpdateLoop):SetUpdateFunctionInterval(0.01)
    end,
    OnCommand = function(self)
        TopScreen = SCREENMAN:GetTopScreen()
        TopScreen:AddInputCallback(Input)
    end,
    OffCommand = function(self)
        BUTTON:ResetButtonTable()
    end,
    PlayTopPressedActorCommand = function(self)
    end,
}

return t