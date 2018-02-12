local utils = require("utils")
local scenes = require("scenes")
local Client = require("net.client")

local scene = {name = "connect"}


local nextMapFileName
local client

function scene.enter(_nextMapFileName)
    nextMapFileName = _nextMapFileName
    client = Client("localhost:49648")
end

function scene.tick()
    local status = client:checkConnected()
    if status.connected then
        enterScene(scenes.game, nextMapFileName, client)
    elseif status.failed then
        enterScene(scenes.message, "Failed to connect")
    end
end

function scene.draw()
    lg.print("Connecting...", 80, 80)
end
-- 
-- function scene.exit()
--     client:close()
-- end

return scene
