local const = require("constants")
local states = require("gameobject.player.states.states")

local Landing = class("Landing", states.Base)

function Landing:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Landing:enter()

end

function Landing:exit(newState)

end

function Landing:update()
    local player = self.player

end

return Landing
