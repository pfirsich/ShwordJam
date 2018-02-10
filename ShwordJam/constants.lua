local utils = require("utils")

-- all constants are here to not pollute the global namespace
local const = {}

local function setupConstants()
    -- pass
end

local lastModified = {}

local function modified(path)
    local mod = lf.getLastModified(path)
    return not lastModified[path] or lastModified[path] < mod
end

function reloadConstants(root, dontSetup)
    local suffix = ".constants.lua"
    for _, item in ipairs(lf.getDirectoryItems("")) do
        local path = (root or "") .. "/" .. item
        if lf.isFile(path) then
            if item:sub(-suffix:len()) == suffix and modified(path) then
                local c = utils.loveDoFile(item)
                utils.table.updateTable(const, c)
            end
        elseif lf.isDirectory(path) then
            reloadConstants(path, true)
        end
    end

    if not dontSetup then
        setupConstants()
    end
end

return const
