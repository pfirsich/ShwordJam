local maps = require("maps")
local GameObject = require("gameobject")
local Platform = require("gameobject.platform")
local Player = require("gameobject.player")
local vmath = require("utils.vmath")
local gamepadController, dummyController = unpack(require("controller"))
local camera = require("camera")
local utils = require("utils")

local scene = {name = "server"}

local player

local bounds = nil

function scene.enter(mapFileName)
    GameObject.resetWorld()
    local map = maps.loadMapFile(mapFileName)
    bounds = map.size

    maps.loadMap(map.tileMap)

    camera.position = {map.size[1] / 2 + 1, map.size[2] / 2 + 1}

    local winW, winH = lg.getDimensions()
    local scaleX = winW / bounds[1]
    local scaleY = winH / bounds[2]
    camera.scale = math.min(scaleX, scaleY) * 0.98
end

function scene.tick()
    GameObject.updateAll()
end

function scene.draw(dt)
    camera.push()
    GameObject.drawAll(dt)
    camera.pop()

    GameObject.callAll("hudDraw")
end

return scene
