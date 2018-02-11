local utils = require("utils")
local const = require("constants")
local class = require("libs.class")

local states = require("gameobject.player.states.states")

local Run = class("Run", states.Base)

function Run:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Run:enter()

end

function Run:exit(newState)

end

function Run:update()
    local player = self.player

    local moveX = player.moveDir[1]
    local targetMoveSpeed = moveX * const.player.maxMoveSpeed

    if targetMoveSpeed > 0 and player.velocity[1] < targetMoveSpeed then
        player.velocity[1] = player.velocity[1] + const.player.acceleration * const.SIM_DT
    elseif targetMoveSpeed < 0 and player.velocity[1] > targetMoveSpeed then
        player.velocity[1] = player.velocity[1] - const.player.acceleration * const.SIM_DT
    else
        player:friction(const.player.friction)
    end

    local runEndSpeed = const.player.maxMoveSpeed * const.player.runEndFactor
    if math.abs(player.velocity[1]) < runEndSpeed and targetMoveSpeed < runEndSpeed then
        player:setState(states.Wait)
    end

    if not player:onGround() then
        player:setState(states.Fall)
    end
end

return Run
