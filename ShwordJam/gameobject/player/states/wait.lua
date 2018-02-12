local const = require("constants")
local class = require("libs.class")
local states = require("gameobject.player.states.states")

local Wait = class("Wait", states.Base)

function Wait:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Wait:enter()
    self.lastMove = nil
    self.player.animator:play('idle')
end

function Wait:exit(newState)

end

function Wait:update()
    local player = self.player

    player:friction(const.player.friction)

    if math.abs(player.moveDir[1]) <= 1e-5 then
        self.lastMove = nil
    else
        if not self.lastMove then
            self.lastMove = player.time
        end
    end

    if math.abs(player.moveDir[1]) > const.player.dashThresh then
        player:setState(states.Dash)
    end

    if self.lastMove and player.time - self.lastMove > const.player.dashInputDelay then
        if math.abs(player.moveDir[1]) > const.player.dashThresh then
            player:setState(states.Dash)
        elseif math.abs(player.moveDir[1]) > 1e-5 then
            player:setState(states.Run)
        end
    end

    if player.controller.jump.pressed then
        player:setState(states.JumpSquat)
    end

    if not player:onGround() then
        player:setState(states.Fall)
    end
end

return Wait
