local utils = require("utils")

local GameObject = utils.class("GameObject")

function GameObject.static.resetWorld()
    GameObject.static.world = {}
    GameObject.static.collider = HC.new(1)
end

local function gameObjectCmp(a, b)
    return a.depth < b.depth
end

function GameObject.static.updateAll()
    for _, object in ipairs(GameObject.world) do
        object.update()
    end
    table.sort(GameObject.world, gameObjectCmp)
end

function GameObject.static.drawAll()
    for _, object in ipairs(GameObject.world) do
        object.draw()
    end
end

function GameObject:initialize()
    table.insert(GameObject.static.world, self)
    self.depth = 0
end

function GameObject:update()
end

function GameObject:draw()
end

return GameObject
