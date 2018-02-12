local utils = require("utils")
local const = require("constants")
local class = require("libs.class")

local states = require("gameobject.player.states.states")

local JumpSquat = class("JumpSquat", states.Base)

function JumpSquat:initialize(player, ...)
    states.Base.initialize(self, player)
end

function JumpSquat:enter()
    self.player.animator:play('jump')
end

function JumpSquat:exit(newState)

end

function JumpSquat:update()
    local player = self.player

    player:friction(const.player.friction * const.player.jumpSquatFrictionFactor)

    if player.time - self.start > const.player.jumpSquatDuration then
        local factor = 1.0
        if not player.controller.jump.state then
            factor = const.player.shorthopFactor
        end
        player.velocity[2] = -const.player.jumpStartSpeed * factor

        local jumpMaxMoveSpeed = const.player.maxMoveSpeed * const.player.jumpMaxMoveSpeedFactor
        player.velocity[1] = player.velocity[1] * const.player.groundToJumpMoveSpeedFactor
        player.velocity[1] = player.velocity[1] + player.moveDir[1] * jumpMaxMoveSpeed * const.player.jumpMoveSpeedFactor
        player.velocity[1] = utils.math.clampAbs(player.velocity[1], jumpMaxMoveSpeed)

        player:setState(states.Fall)
    end
end

return JumpSquat
