
PLAYER = PLAYER_1

function Actor.PlayCommandsOnChildren(self, cmd, params)
    return self:RunCommandsOnChildren(function(self) self:playcommand(cmd, params) end)
end

function Actor.QueueCommandsOnChildren(self, cmd)
    return self:RunCommandsOnChildren(function(self) self:queuecommand(cmd) end)
end