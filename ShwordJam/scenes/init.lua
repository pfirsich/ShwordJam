local utils = require("utils")

local scenes = {}

local curScene = nil

function enterScene(scene, ...)
    if curScene then
        utils.callNonNil(curScene.exit, scene)
    end

    curScene = scene
    utils.callNonNil(scene.enter, ...)
end

function getCurrentScene()
    return curScene
end

function requireScenes()
    for _, item in ipairs(lf.getDirectoryItems("scenes")) do
        local path = "scenes/" .. item

        local reqPath = nil

        if lf.isFile(path) and item ~= "init.lua" then
            reqPath = "scenes." .. item:sub(1, -5)
        elseif lf.isDirectory(path) then
            reqPath = "scenes." .. item
        end

        if reqPath then
            local scene = require(reqPath)
            scenes[scene.name] = scene
        end
    end
end

return scenes
