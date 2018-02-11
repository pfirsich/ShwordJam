local const = require("constants")
local states = require("gameobject.player.states.states")

local JumpSquat = class("JumpSquat", states.Base)

function JumpSquat:initialize(player, ...)
    states.Base.initialize(self, player)
end

function JumpSquat:enter()

end

function JumpSquat:exit(newState)

end

function JumpSquat:update()
    local player = self.player

end

return JumpSquat
