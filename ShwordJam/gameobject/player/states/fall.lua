local const = require("constants")
local class = require("libs.class")

local states = require("gameobject.player.states.states")

local Fall = class("Fall", states.Base)

function Fall:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Fall:enter()
    self.canFastFall = false
end

function Fall:exit(newState)

end

function Fall:update()
    local player = self.player

    if player.moveDir[2] < 1e-5 then
        self.canFastFall = true
    end

    if player.velocity[2] < const.player.maxFallSpeed then
        player.velocity[2] = player.velocity[2] + const.player.gravity * const.SIM_DT
    end

    if player.velocity[2] < 0 and canFastFall and player.moveDir[2] > const.player.fastFallThresh then
        player.velocity[2] = const.player.maxFallSpeed * const.player.fastFallFactor
    end

    if player:onGround() then
        player:setState(states.Wait)
    end
end

return Fall
