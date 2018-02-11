local maps = require("maps")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local Player = require("gameobject.player")
local gamepadController, dummyController = unpack(require("controller"))

local scene = {name = "game"}

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
    Player(controller)
end

function scene.tick()
    GameObject.updateAll()
end

function scene.draw()
    lg.push()
    lg.scale(25)
    GameObject.drawAll()
    lg.pop()
end

return scene
