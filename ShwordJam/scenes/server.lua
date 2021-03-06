local maps = require("maps")
local GameObject = require("gameobject")
local camera = require("camera")
local utils = require("utils")
local Server = require("net.server")

local scene = {name = "server"}

local server;

local map

function scene.enter(mapFileName)
    server = Server("49648")

    GameObject.resetWorld()
    map = maps.loadMapFile(mapFileName)

    maps.loadMap(map.tileMap)

    camera.position = {map.size[1] / 2 + 1, map.size[2] / 2 + 1}

    local winW, winH = lg.getDimensions()
    local scaleX = winW / map.size[1]
    local scaleY = winH / map.size[2]
    camera.scale = math.min(scaleX, scaleY) * 0.98
end

function scene.tick()
    server:receive()

    GameObject.updateAll()

    server:broadcastUpdate()
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
    server:close()
end

return scene
