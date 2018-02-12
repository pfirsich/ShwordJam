local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local class = require("libs.class")
local camera = require("camera")
local Shword = require("gameobject.shword")

local states = require("gameobject.player.states.states")
local AimShwordGround = require("gameobject.player.states.aimshwordground")

local AimShwordAir = class("AimShwordAir", AimShwordGround)

function AimShwordAir:initialize(player, ...)
    AimShwordGround.initialize(self, player)
end

function AimShwordAir:update()
    local player = self.player

    if player.velocity[2] < const.player.maxFallSpeed then
        player.velocity[2] = player.velocity[2] + const.player.gravity * const.SIM_DT
    end

    if player:onGround() then
        player:setState(states.AimShwordGround, self.kind)
    end

    self:checkShwordInput()
end

return AimShwordAir
