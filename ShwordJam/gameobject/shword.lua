local class = require("libs.class")
local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
--local Player = require("gameobject.player")

local inspect = utils.inspect

local Shword = class("Shword", GameObject)

Shword.kinds = {"shwordA", "shwordB", "shwordC"}

Shword.drawShword = {}

function Shword.drawShword.sharedPush(x, y, dir)
    local ortho = vmath.ortho(dir)
    local d, o = dir, ortho
    lg.push()
    lg.translate(x, y)
    lg.rotate(vmath.angle(dir))
    lg.scale(const.shword.length / 2, const.shword.width / 2)
end

function Shword.drawShword.sharedPop()
    lg.pop()
end

function Shword.drawShword.shwordA(x, y, dir)
    Shword.drawShword.sharedPush(x, y, dir)
    lg.polygon("fill", {
         0, -1,
        -1,  0,
         0,  1,
         1,  0
    })
    Shword.drawShword.sharedPop()
end

function Shword.drawShword.shwordB(x, y, dir)
    Shword.drawShword.sharedPush(x, y, dir)
    lg.polygon("fill", {
        -1, -1,
        -1,  1,
         1,  0,
    })
    Shword.drawShword.sharedPop()
end

function Shword.drawShword.shwordC(x, y, dir)
    Shword.drawShword.sharedPush(x, y, dir)
    lg.ellipse("fill", 0, 0, 1.0, 1.0)
    Shword.drawShword.sharedPop()
end

function Shword:initialize(player, kind, position, direction)
    GameObject.initialize(self)
    self.kind = kind
    self.depth = 5
    self.position = vmath.copy(position)
    assert(vmath.len(direction) > 1e-5)
    self.direction = vmath.normed(direction)
    self.velocity = vmath.mul(direction, const.shword.speed)
    self.shape = GameObject.collider:circle(0, 0, const.shword.collisionRadius)
    self.shape._object = self
    self.player = player.id
end

function Shword:update()
    self.position = vmath.add(self.position, vmath.mul(self.velocity, const.SIM_DT))
    self.shape:moveTo(unpack(self.position))

    local collisions = GameObject.collider:collisions(self.shape)
    for other, mtv in pairs(collisions) do
        if other._object.class == Platform then
            self.position = vmath.add(self.position, {mtv.x, mtv.y})
            self.shape:moveTo(unpack(self.position))
            self.velocity = {0, 0}
        elseif other._object.class.name == "Player" then
            -- do something
        end
    end
end

function Shword:draw()
    lg.setColor(GameObject.getById(self.player).color or {255, 255, 255})
    self.drawShword[self.kind](self.position[1], self.position[2], self.direction)
    self.shape:draw()
end

return Shword
