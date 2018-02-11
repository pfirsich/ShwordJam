local utils = require("utils")

local maps = {}

local tileTypes = utils.table.enum({
    "EMPTY",
    "SPAWN_POINT",
    "STONE",
    "GRASS",
})

local tileCharTypeMap = {
    [" "] = tileTypes.EMPTY,
    ["s"] = tileTypes.SPAWN_POINT,
    ["#"] = tileTypes.STONE,
    ["\""] = tileTypes.GRASS,
}

local function lines(s)
    if s:sub(-1) ~= "\n" then
         s = s .. "\n"
     end
    return s:gmatch("(.-)\r?\n")
end

local function loadMapsFile(mapPath)
    local contents, sizeOrError = love.filesystem.read("media/maps/" .. mapPath .. ".lvl")

    if not contents then
        error(sizeOrError)
    end

    local properties = {}
    local tileMap = {}
    local parseProperties = true

    local y = 1
    for line in lines(contents) do
        if line == "" then
            parseProperties = false
        else
            if parseProperties then
                local key, value = line:match("(.-)%s*:%s*(.*)")
                if key then
                    properties[key] = value
                end
            else
                tileMap[y] = {}
                for x = 1, line:len() do
                    local char = line:sub(x, x)
                    local type = tileCharTypeMap[char]
                    tileMap[y][x] = type
                end

                y = y + 1
            end
        end
    end
    return tileMap, properties
end

local function at(t, y, x)
    return t[y] and t[y][x]
end

local function coordInList(list, x, y)
    for _, v in ipairs(list) do
        if v.x == x and v.y == y then
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
    [7] = 'left',
    [8] = 'down',
    [9] = 'special',
    [10] = 'down',
    [11] = 'down',
    [12] = 'right',
    [13] = 'up',
    [14] = 'right',
    [15] = 'error',
}

local function buildChunks(tileMap)
    local markedMap = {}
    local chunks = {}

    local function findChunk(x, y, type)
        local tileType = at(tileMap, y, x)

        if tileType and tileType ~= tileTypes.EMPTY and tileType == type and not at(markedMap, y, x) then
            local chunk = {}

            table.insert(chunk, {
                x = x,
                y = y,
                type = tileType,
            })
            markedMap[y][x] = true

            utils.table.extend(chunk, findChunk(x - 1, y, tileType))
            utils.table.extend(chunk, findChunk(x + 1, y, tileType))
            utils.table.extend(chunk, findChunk(x, y - 1, tileType))
            utils.table.extend(chunk, findChunk(x, y + 1, tileType))

            return chunk
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
            table.insert(chunks, findChunk(x, y, tileType))
        end
    end

    return chunks
end

local function printChunks(chunks, tileMap)
    local debugMap = {}
    for y = 1, #tileMap do
        debugMap[y] = {}
        for x = 1, #tileMap[y] do
            debugMap[y][x] = " "
        end
    end

    local c = string.byte("A")
    for _, chunk in ipairs(chunks) do
        for _, tile in ipairs(chunk) do
            debugMap[tile.y][tile.x] = string.char(c)
        end
        c = c + 1
    end

    for y = 1, #debugMap do
        for x = 1, #debugMap[y] do
            io.write(debugMap[y][x])
        end
        io.write("\n")
    end
end

local function buildPolygons(chunks)
    local polygons = {}

    for _, chunk in ipairs(chunks) do
        local polygon = {}
        repeat
            local point = nil

            local x
            local y

            if #polygon == 0 then
                table.insert(polygon, chunk[1].x)
                table.insert(polygon, chunk[1].y)
                x = chunk[1].x
                y = chunk[1].y
            else
                x = polygon[#polygon-1]
                y = polygon[#polygon-0]
            end

            local neighborsHash = 0

            if coordInList(chunk, x, y - 1) then
                neighborsHash = neighborsHash + 1
            end
            if coordInList(chunk, x - 1, y - 1) then
                neighborsHash = neighborsHash + 2
            end
            if coordInList(chunk, x, y) then
                neighborsHash = neighborsHash + 4
            end
            if coordInList(chunk, x - 1, y) then
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
                error("Invalid " .. whatToDo)
            end

            local knownPoint = false

            if #polygon ~= 0 and
                    point.x == polygon[1] and
                    point.y == polygon[2] then
                knownPoint = true
            else
                table.insert(polygon, point.x)
                table.insert(polygon, point.y)
            end
        until knownPoint

        table.insert(polygons, polygon)
    end

    return polygons
end

function maps.loadMap(mapPath)
    local tileMap, properties = loadMapsFile(mapPath)
    local chunks = buildChunks(tileMap)

    -- For debugging
    printChunks(chunks, tileMap)

    local polygons = buildPolygons(chunks)

    for _, poly in ipairs(polygons) do
        Platform(poly)
    end
end

return maps
