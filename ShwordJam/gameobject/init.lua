local utils = require("utils")
local HC = require("libs.HC")

local GameObject = utils.class("GameObject")

function GameObject.resetWorld()
    GameObject.world = {}
    GameObject.collider = HC.new(1)
end

local function gameObjectCmp(a, b)
    return a.depth < b.depth
end

function GameObject.updateAll()
    for _, object in ipairs(GameObject.world) do
        object.update()
    end
    table.sort(GameObject.world, gameObjectCmp)
end

function GameObject.drawAll()
    for _, object in ipairs(GameObject.world) do
        object.draw()
    end
end

function GameObject:initialize()
    table.insert(GameObject.world, self)
    self.depth = 0
end

function GameObject:update()
end

function GameObject:draw()
end

return GameObject
