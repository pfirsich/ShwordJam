local class = require("libs.class")
local const = require("constants")
local Animator = require("animator")
local utils = require("utils")
local vmath = require("utils.vmath")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local Shword = require("gameobject.shword")
local states = require("gameobject.player.states")
local HCshapes = require("libs.HC.shapes")
local fonts = require("fonts")
local camera = require("camera")

local inspect = utils.inspect

local Player = class("Player", GameObject)

function Player:initialize(controller, spawnPosition)
    GameObject.initialize(self)
    self.depth = 1
    self.controller = controller
    self.position = spawnPosition
    self.velocity = {0, 0}
    self.shape = GameObject.collider:rectangle(0, 0, const.player.width, const.player.height)
    self.shape._object = self
    self.time = 0
    self.frameCounter = 0
    self.shwords = {}
    self.shwordButtonFresh = {}
    self.nextTeleport = 0

    self.drawParams = {
        x = 0,
        y = 0,
        angle = 0,
        scaleX = 1,
        scaleY = 1,
    }
    self.animator = Animator(self.drawParams, "animations/player.lua")
    self.flipped = false

    self:setState(states.Wait)

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

function Player:enterAimShword()
    for _, kind in ipairs(Shword.kinds) do
        if self.controller[kind].state then
            if self.shwordButtonFresh[kind] then
                self.shwordButtonFresh[kind] = false
                local shword = self.shwords[kind] and
                    GameObject.getById(self.shwords[kind])
                if shword then
                    if self.nextTeleport < self.time then
                        self.nextTeleport = self.time +
                            const.player.teleportCooldown
                        self.position = vmath.copy(shword.position)
                        if shword.stuck then
                            self.shwords[kind] = nil
                            shword:removeFromWorld()
                        end
                    end
                else
                    if self:onGround() then
                        self:setState(states.AimShwordGround, kind)
                    else
                        self:setState(states.AimShwordAir, kind)
                    end
                end
            end
        else
            self.shwordButtonFresh[kind] = true
        end
    end
end

function Player:shootShword(kind)
    self.shwords[kind] = Shword(self, kind, self.position, self.moveDir).id
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
    else
        self.moveDir = vmath.mul(self.moveDir, vmath.len(self.moveDir) / (1 - const.player.moveDeadzone))
    end
    if self.moveDir[1] > 0 then
        self.flipped = false
    elseif self.moveDir[1] < 0 then
        self.flipped = true
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

function Player:preHudDraw()
    utils.callNonNil(self.state.preHudDraw, self.state)
end

function Player:draw(dt)
    self.animator:update(dt)
    local pconst = const.player
    lg.setColor(255, 255, 255)

    utils.callNonNil(self.state.preDraw, self.state)

    lg.push()
    do
        local p = self.drawParams
        lg.translate(unpack(self.position))
        lg.translate(p.x, p.y)

        lg.scale(self.flipped and -1 or 1, 1)
        lg.translate(0, pconst.height * (1 - p.scaleY) / 2)
        lg.rotate(p.angle)
        local w, h = pconst.width * p.scaleX, pconst.height * p.scaleY
        lg.rectangle("fill", -w/2, -h/2, w, h)
    end
    lg.pop()

    utils.callNonNil(self.state.postDraw, self.state)
end

function Player:postHudDraw()
    utils.callNonNil(self.state.postHudDraw, self.state)

    lg.setColor(20, 20, 20)
    lg.setFont(fonts.big)
    lg.print(utils.inspect({
        position = self.position,
        velocity = self.velocity,
        onGround = self:onGround(),
        flipped = self.flipped,
    }), 5, 30)
    lg.print(self.state:tostring(), 5, 200)
end

return Player
