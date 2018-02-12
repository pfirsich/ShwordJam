local maps = require("maps")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local Player = require("gameobject.player")
local vmath = require("utils.vmath")
local gamepadController, dummyController = unpack(require("controller"))
local camera = require("camera")

local scene = {name = "game"}

local player

function scene.enter(mapFileName)
    GameObject.resetWorld()
    local map = maps.loadMapFile(mapFileName)

    maps.loadMap(map.tileMap)

    local joysticks = love.joystick.getJoysticks()
    local controller = nil
    if #joysticks > 0 then
        controller = gamepadController(joysticks[1])
    else
        controller = dummyController()
    end
    player = Player(controller, map.spawnPoints[1])
end

function scene.tick()
    GameObject.updateAll()
    camera.target.position = vmath.copy(player.position)
    camera.position = camera.target.position
    camera.scale = 50
end

function scene.draw(dt)
    camera.push()
    GameObject.drawAll(dt)
    camera.pop()

    GameObject.callAll("hudDraw")
end

return scene
