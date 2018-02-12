require("enet")

local class = require("libs.class")
local utils = require("utils")

local Server = class("Server")


function Server:initialize(port)
    self.host = enet.host_create("0.0.0.0:" .. port)
    if not self.host then
        error("Can't create host")
    end
end

function Server:tick()
    local event = self.host:service()
    while event do
        if event.type == "receive" then
            print("Got message: ", event.data, event.peer)
            event.peer:send("pong")
        elseif event.type == "connect" then
            print(utils.inspect(event.peer))
            print(event.peer, "connected")
        elseif event.type == "disconnect" then
            print(event.peer, "disconnected")
        end

        event = self.host:service()
    end
end

function Server:close()
    for i = 1, self.host:peer_count() do
        local peer = self.host:get_peer(i)
        if peer:state() == "connected" then
            peer:disconnect()
        end
    end
    self.host:flush()
end

return Server
