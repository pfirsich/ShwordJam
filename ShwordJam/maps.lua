local utils = require("utils")

local maps = {}

function lines(s)
    if s:sub(-1) ~= "\n" then
         s = s .. "\n"
     end
    return s:gmatch("(.-)\n")
end

function loadFile(mapPath)
    local contents, sizeOrError = love.filesystem.read("media/maps/" .. mapPath .. ".lvl")

    if not contents then
        error(sizeOrError)
    end

    local properties = {}
    local tileMap = {}
    local newlineCount = 0

    local y = 1
    for line in lines(contents) do
        if line == "" then
            newlineCount = newlineCount + 1
        elseif newlineCount < 2 then
            newlineCount = 0
        end

        if newlineCount == 0 then
            local key, value = line:match("(.-)%s*:%s*(.*)")
            if key then
                properties[key] = value
            end
        elseif newlineCount >= 2 then
            tileMap[y] = {}
            for x = 1, line:len() do
                tileMap[y][x] = line:sub(x, x)
            end

            y = y + 1
        end
    end
    return tileMap, properties
end

function maps.loadMap(mapPath)
    local map, properties = loadFile(mapPath)

    -- Create gameobjects
end

return maps
