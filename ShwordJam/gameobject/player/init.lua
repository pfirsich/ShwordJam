local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local GameObject = require("gameobject")

Player = class("Player", GameObject)

function Player:initialize(controller)
    GameObject.initialize(self)
    self.controller = controller
    self.position = {0, 0}
    self.velocity = {0, 0}
    self.shape = GameObject.collider:rectangle(0, 0, const.player.width, const.player.height)
    self.time = 0
end

function Player:update()
    local pconst = const.player

    self.controller:update()
    self.moveDir = {self.controller.moveX.state, self.controller.moveY.state}
    if vmath.len(self.moveDir) < pconst.moveDeadzone then
        self.moveDir = {0, 0}
    end

    self.time = self.time + const.SIM_DT

    self.position = vmath.add(self.position, vmath.mul({self.moveDir[1], self.moveDir[2]}, pconst.maxMoveSpeed))
    --self.state:update()

    --self:updateCollisions()

    -- integrate
    self.position = vmath.add(self.position, vmath.mul(self.position, const.SIM_DT))
end

function Player:updateCollisions()

end

function Player:draw()
    local pconst = const.player
    lg.setColor(0, 0, 255)
    local x, y, w, h = self.position[1], self.position[2], pconst.width, pconst.height
    lg.rectangle("fill", x - w/2, y - h, w, h)
end

return Player