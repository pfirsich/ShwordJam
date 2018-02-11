local utils = require("utils")

local maps = {}

local tileTypes = utils.table.enum({
    "PLATFORM",
    "SPAWN_POINT",
})

local tileCharTypeMap = {
    [" "] = nil,
    ["#"] = tileTypes.PLATFORM,
    ["s"] = tileTypes.SPAWN_POINT,
}

local function lines(s)
    if s:sub(-1) ~= "\n" then
         s = s .. "\n"
     end
    return s:gmatch("(.-)\n")
end

local function loadFile(mapPath)
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
                local char = line:sub(x, x)
                local type = tileCharTypeMap[char]
                tileMap[y][x] = type
            end

            y = y + 1
        end
    end
    return tileMap, properties
end

local function cordTable(x, y)
    return {
        x = x,
        y = y,
    }
end

local function at(t, y, x)
    return t[y] and t[y][x]
end

local function cordInList(list, x, y)
    for i, v in ipairs(list) do
        if v and v.x == x and v.y == y then
            return true
        end
    end
    return false
end

local marchingRoute = {
    [0] = 'error',
    [1] = 'up',
    [2] = 'left',
    [3] = 'left',
    [4] = 'right',
    [5] = 'up',
    [6] = 'special',
    [7] = 'right',
    [8] = 'down',
    [9] = 'special',
    [10] = 'down',
    [11] = 'down',
    [12] = 'left',
    [13] = 'up',
    [14] = 'left',
    [15] = 'error',
}

local function buildMap(mapPath)
    local tileMap, properties = loadFile(mapPath)
    local markedMap = {}
    local groups = {}

    local function findGroup(x, y)
        local tileType = at(tileMap, y, x)

        if tileType and not at(markedMap, y, x) then
            local group = {}

            table.insert(group, {
                x = x,
                y = y,
                type = tileType,
            })
            markedMap[y][x] = true

            utils.table.extend(group, findGroup(x - 1, y))
            utils.table.extend(group, findGroup(x + 1, y))
            utils.table.extend(group, findGroup(x, y - 1))
            utils.table.extend(group, findGroup(x, y + 1))

            return group
        else
            return nil
        end
    end

    for y, row in ipairs(tileMap) do
        markedMap[y] = {}
        for x = 1, #row do
            markedMap[y][x] = false
        end
    end

    for y, row in ipairs(tileMap) do
        for x, tileType in ipairs(row) do
            table.insert(groups, findGroup(x, y))
        end
    end


    local polygons = {}

    for _, group in ipairs(groups) do
        local polygon = {}
        repeat
            local point = nil
            if #polygon == 0 then
                point = group[1]
            else
                local x = polygon[#polygon].x
                local y = polygon[#polygon].y

                local neighborsHash = 0

                if cordInList(group, x, y - 1) then
                    neighborsHash = neighborsHash + 1
                end
                if cordInList(group, x - 1, y - 1) then
                    neighborsHash = neighborsHash + 2
                end
                if cordInList(group, x, y) then
                    neighborsHash = neighborsHash + 4
                end
                if cordInList(group, x - 1, y) then
                    neighborsHash = neighborsHash + 8
                end

                local whatToDo = marchingRoute[neighborsHash]

                if whatToDo == 'special' then
                    error('Unhandled special case', x, y)
                elseif whatToDo == 'error' then
                    error(('Error at %d %d with hash %d'):format(x, y, neighborsHash))
                elseif whatToDo == 'up' then
                    point = {x = x, y = y - 1}
                elseif whatToDo == 'down' then
                    point = {x = x, y = y + 1}
                elseif whatToDo == 'right' then
                    point = {x = x + 1, y = y}
                elseif whatToDo == 'left' then
                    point = {x = x - 1, y = y}
                else
                    error("Invalid whatToDo " .. whatToDo)
                end
            end

            local knownPoint = false

            if #polygon ~= 0 and point.x == polygon[1].x and point.y == polygon[1].y then
                knownPoint = true
            else
                table.insert(polygon, point)
            end
        until knownPoint

        table.insert(polygons, polygon)
    end

    return polygons
end

function maps.loadMap(mapPath)
    local polygons = buildMap(mapPath)

    for _, poly in ipairs(polygons) do
        local points = {}
        for _, p in ipairs(poly) do
            table.insert(points, p.x)
            table.insert(points, p.y)
        end
        Platform(points)
    end
end

return maps
