local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local GameObject = require("GameObject")

local pconst = const.player

Player = class("Player", GameObject)

function Player:initialize()
    GameObject.initialize(self)
    self.position = {0, 0}
    self.velocity = {0, 0}
end

function Player:update()
    self.position = vadd(self.position, vmul(self.position, const.SIM_DT))
end

function Player:draw()
    lg.setColor(0, 0, 255)
    local x, y, w, h = self.position[1], self.position[2], pconst.width, pconst.height
    lg.rectangle("fill", x - w/2, y - h, w, h)
end
