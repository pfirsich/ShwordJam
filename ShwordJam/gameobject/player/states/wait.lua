local const = require("constants")
local class = require("libs.class")
local states = require("gameobject.player.states.states")
local Shword = require("gameobject.shword")

local Wait = class("Wait", states.Base)

function Wait:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Wait:enter()
    self.lastMove = nil
    self.player.animator:play('idle')
    self.canDash = false
end

function Wait:exit(newState)

end

function Wait:update()
    local player = self.player

    player:friction(const.player.friction)

    if math.abs(player.moveDir[1]) <= 1e-5 then
        self.canDash = true
        self.lastMove = nil
    else
        if not self.lastMove then
            self.lastMove = player.time
        end
    end

    if self.canDash and math.abs(player.moveDir[1]) > const.player.dashThresh then
        player:setState(states.Dash)
        return
    end

    if self.lastMove and player.time - self.lastMove > const.player.dashInputDelay then
        player:setState(states.Run)
        return
    end

    if player.controller.jump.pressed then
        player:setState(states.JumpSquat)
        return
    end

    if not player:onGround() then
        player:setState(states.Fall)
        return
    end

    player:enterAimShword()
end

return Wait
