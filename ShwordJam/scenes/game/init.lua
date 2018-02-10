local maps = require("maps")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")

local scene = {name = "game"}

function scene.enter(mapPath)
    GameObject.resetWorld()
    maps.loadMap(mapPath)

    Platform({0, 0, 1, 1, 0, 1})
end

function scene.tick()
    GameObject.updateAll()
end

function scene.draw()
    GameObject.drawAll()
end

return scene
