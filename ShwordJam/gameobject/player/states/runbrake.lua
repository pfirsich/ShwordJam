local const = require("constants")
local states = require("gameobject.player.states.states")

local Runbrake = class("Runbrake", states.Base)

function Runbrake:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Runbrake:enter()

end

function Runbrake:exit(newState)

end

function Runbrake:update()
    local player = self.player

end

return Runbrake
