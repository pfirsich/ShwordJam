local utils = require("utils")
local scenes = require("scenes")
local Client = require("net.client")

local scene = {name = "connect"}


local nextMapFileName
local client

function scene.enter(_nextMapFileName)
    nextMapFileName = _nextMapFileName
    client = Client("127.0.0.1:5349")
end

function scene.tick()
    local status = client:checkConnected()
    print(utils.inspect(status))
    if status.connected then
        enterScene(scenes.game, nextMapFileName, client)
    elseif status.failed then
        enterScene(scenes.message, "Failed to connect")
    end
end

function scene.draw()
    lg.print("Connecting...", 80, 80)
end

function scene.exit()
    client:close()
end

return scene