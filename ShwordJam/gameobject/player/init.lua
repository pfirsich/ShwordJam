local class = require("libs.class")
local const = require("constants")
local utils = require("utils")
local vmath = require("utils.vmath")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local states = require("gameobject.player.states")
local HCshapes = require("libs.HC.shapes")

local inspect = utils.inspect

local Player = class("Player", GameObject)

function Player:initialize(controller, spawnPosition)
    GameObject.initialize(self)
    self.controller = controller
    self.position = spawnPosition
    self.velocity = {0, 0}
    self.shape = GameObject.collider:rectangle(0, 0, const.player.width, const.player.height)
    self.shape._object = self
    self:setState(states.Wait)
    self.time = 0
    self.frameCounter = 0

    local w, h = const.player.width * const.player.groundProbeWidthFactor, const.player.groundProbeHeight
    self._groundProbe = HCshapes.newPolygonShape(0, 0,  w, 0,  w, h,  0, h)
end

function Player:setState(stateClass, ...)
    local state = stateClass(self)
    if self.state then
        self.state:exit(state)
    end
    self.state = state
    self.state:enter(...)
end

function Player:move(dv)
    self:moveTo(vmath.add(self.position, dv))
end

function Player:moveTo(v)
    self.position = {unpack(v)}
    self.shape:moveTo(unpack(v))
end

local function linearFriction(v, f)
    if v > 0 then
        return math.max(0, v - f)
    else
        return math.min(0, v + f)
    end
end

function Player:friction(x, y)
    self.velocity[1] = linearFriction(self.velocity[1], (x or 0) * const.SIM_DT)
    self.velocity[2] = linearFriction(self.velocity[2], (y or 0) * const.SIM_DT)
end

function Player:onGround()
    self._groundProbe:moveTo(self.position[1],
        self.position[2] + const.player.height/2 +
        const.player.groundProbeHeight * 0.5 +
        const.player.groundProbeOffsetY)
    local collisions = GameObject.collider:collisions(self._groundProbe)
    for other, mtv in pairs(collisions) do
        if other._object.class == Platform then
            return true
        end
    end
    return false
end

function Player:serialize()

end

function Player:deserialize()

end

function Player:update()
    local pconst = const.player

    self.controller:update()
    self.moveDir = {self.controller.moveX.state, self.controller.moveY.state}
    if vmath.len(self.moveDir) < pconst.moveDeadzone then
        self.moveDir = {0, 0}
    end

    self.time = self.time + const.SIM_DT
    self.frameCounter = self.frameCounter + 1

    self.state:update()

    -- integrate
    self:move(vmath.mul(self.velocity, const.SIM_DT))

    self:updateCollisions()
end

function Player:updateCollisions()
    local collisions = GameObject.collider:collisions(self.shape)
    for other, mtv in pairs(collisions) do
        if other._object.class == Platform then
            self:move({mtv.x, mtv.y})
            local normal = {mtv.x, mtv.y}
            local velNormal, velTangent = vmath.split(self.velocity, normal)
            if vmath.dot(normal, velNormal) < 0.0 then -- velocity points into surface
                self.velocity = velTangent
            end
        end
    end
end

function Player:draw()
    local pconst = const.player
    lg.setColor(0, 0, 255)
    local x, y, w, h = self.position[1], self.position[2], pconst.width, pconst.height
    lg.rectangle("fill", x - w/2, y - h/2, w, h)
end

function Player:hudDraw()
    lg.setColor(255, 255, 255)
    lg.print(utils.inspect({
        position = self.position,
        velocity = self.velocity,
        state = self.state:tostring()
    }), 5, 25)
end

return Player
