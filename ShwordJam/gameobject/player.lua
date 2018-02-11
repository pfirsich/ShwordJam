local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local GameObject = require("gameobject")

local pconst = const.player

Player = class("Player", GameObject)

function Player:initialize(controller)
    GameObject.initialize(self)
    self.controller = controller
    self.position = {0, 0}
    self.velocity = {0, 0}
end

function Player:update()
    self.position = vmath.add(self.position, vmath.mul(self.position, const.SIM_DT))
end

function Player:draw()
    lg.setColor(0, 0, 255)
    local x, y, w, h = self.position[1], self.position[2], pconst.width, pconst.height
    lg.rectangle("fill", x - w/2, y - h, w, h)
end

return Player
