local maps = require("maps")
local GameObject = require("gameobject")

local scene = {name = "game"}

function scene.enter(mapPath)
    GameObject.resetWorld();
    maps.loadMap(mapPath)
end

function scene.tick()
    GameObject.updateAll()
end

function scene.draw()
    GameObject.drawAll()
end

return scene
