local maps = require("maps")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local Player = require("gameobject.player")
local vmath = require("utils.vmath")
local gamepadController, dummyController = require("controller")
local camera = require("camera")

local scene = {name = "game"}

local player

function scene.enter(mapPath)
    GameObject.resetWorld()
    maps.loadMap(mapPath)

    local joysticks = love.joystick.getJoysticks()
    local controller = nil
    if #joysticks > 0 then
        controller = gamepadController(joysticks[1])
    else
        controller = dummyController()
    end
    player = Player(controller)
end

function scene.tick()
    GameObject.updateAll()
    camera.target.position = vmath.copy(player.position)
end

function scene.draw()
    camera.push()
    lg.push()
        lg.scale(25)
        GameObject.drawAll()
    lg.pop()
    camera.pop()
end

return scene
