local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local class = require("libs.class")
local camera = require("camera")
local Shword = require("gameobject.shword")

local states = require("gameobject.player.states.states")

local AimShwordGround = class("AimShwordGround", states.Base)

function AimShwordGround:initialize(player, ...)
    states.Base.initialize(self, player)
end

function AimShwordGround:enter(kind)
    self.kind = kind
end

function AimShwordGround:exit(newState)

end

function AimShwordGround:update()
    local player = self.player

    player:friction(const.player.friction)

    if not player:onGround() then
        player:setState(states.Fall)
    end

    local button = player.controller[self.kind]
    if not button.state then
        local dir = vmath.normed(player.moveDir)
        if vmath.len(dir) < 1e-5 then
            player:setState(states.Wait)
        else
            player:shootShword(self.kind)
            player:setState(states.Wait)
        end
    end
end

function AimShwordGround:preDraw()
    local player = self.player
    lg.setLineWidth(0.05)
    lg.circle("line", player.position[1], player.position[2], const.player.aimShwordRadius, 40)
end

function AimShwordGround:postDraw()
    local player = self.player
    local dir = vmath.normed(player.moveDir)
    if vmath.len(dir) > 1e-5 then
        local pos = vmath.add(player.position, vmath.mul(dir, const.player.aimShwordRadius))
        Shword.drawShword[self.kind](pos[1], pos[2], dir)
    end
end

return AimShwordGround
