local maps = require("maps")
local GameObject = require("gameobject")
local Player = require("gameobject.player")
local vmath = require("utils.vmath")
local gamepadController, dummyController = unpack(require("controller"))
local camera = require("camera")
local utils = require("utils")
local scenes = require("scenes")

local scene = {name = "game"}

local client

local player
local map

function scene.enter(mapFileName, _client)
    client = _client

    GameObject.resetWorld()
    map = maps.loadMapFile(mapFileName)

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
    local error = client:receive()
    if error then
        enterScene(scenes.message, "Error: " .. error)
        return
    end

    GameObject.updateAll()

    camera.target.position = vmath.copy(player.position)
    camera.position = camera.target.position
    camera.scale = 40

    local camTopLeftX, camTopLeftY, camBottomRightX, camBottomRightY = camera.getAABB()
    local camW = camBottomRightX - camTopLeftX
    local camH = camBottomRightY - camTopLeftY
    camera.position[1] = utils.math.clamp(camera.position[1], camW/2 + 1, map.size[1] - camW/2 + 1)
    camera.position[2] = utils.math.clamp(camera.position[2], camH/2 + 1, map.size[2] - camH/2 + 1)

    local error = client:sendUpdate()
    if error then
        enterScene(scenes.message, "Error: " .. error)
        return
    end
end

function scene.draw(dt)
    if map.properties.background then
        lg.setBackgroundColor(map.properties.background:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)"))
    end

    GameObject.callAll("preHudDraw")

    camera.push()
    GameObject.drawAll(dt)
    camera.pop()

    GameObject.callAll("postHudDraw")
end

function scene.exit()
    client:close()
end

return scene
