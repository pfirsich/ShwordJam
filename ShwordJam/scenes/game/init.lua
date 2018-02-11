local maps = require("maps")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local Player = require("gameobject.player")
local gamepadController = require("controller")

local scene = {name = "game"}

function scene.enter(mapPath)
    GameObject.resetWorld()
    maps.loadMap(mapPath)
    Player(gamepadController(love.joystick.getJoysticks()[1]))
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
