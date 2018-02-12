local const = require("constants")
local class = require("libs.class")

local states = require("gameobject.player.states.states")

local Dash = class("Dash", states.Base)

function Dash:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Dash:enter()
    self.direction = self.player.moveDir[1] > 0 and 1 or -1
    self.player.velocity[1] = self.direction * const.player.dashSpeedFactor * const.player.maxMoveSpeed

    self.player.animator:play('dash')
end

function Dash:exit(newState)

end

function Dash:update()
    local player = self.player

    local moveX = player.moveDir[1]
    if math.abs(moveX) > const.player.dashThresh and moveX * self.direction < 0 then
        player:setState(states.Dash)
    end

    if player.time - self.start > const.player.dashDuration then
        if math.abs(moveX) < 1e-5 then
            player:setState(states.Wait)
        else
            player:setState(states.Run)
        end
    end

    if player.controller.jump.pressed then
        player:setState(states.JumpSquat)
    end

    if not player:onGround() then
        player:setState(states.Fall)
    end

    player:enterAimShword()
end

return Dash
