require("enet")

local class = require("libs.class")
local utils = require("utils")

local Client = class("Client")


function Client:initialize(server_host)
    self.host = enet.host_create()
    self.server = self.host:connect(server_host)
end

function Client:tick()
    local event = self.host:service()
    while event do
        if event.type == "receive" then
            print("Got message: ", event.data, event.peer)
            event.peer:send("ping")
        elseif event.type == "connect" then
            print(event.peer, "connected.")
            event.peer:send("ping")
        elseif event.type == "disconnect" then
            print(event.peer, "disconnected.")
            return "Server disconnected"
        end
        event = self.host:service()
    end

    return nil
end

function Client:checkConnected()
    print(utils.inspect(self.server:state()))

    if self.server:state() == "connected" then
        print("was")
        return {connected = true}
    else
        local event = self.host:service()
        while event do
            if event.type == "receive" then
                error("Got message while waiting for a connection")
            elseif event.type == "connect" then
                return {connected = true}
            elseif event.type == "disconnect" then
                return {failed = true}
            end
            event = self.host:service()
        end
        return {connected = false}
    end
end

function Client:close()
    if self.server:state() == "connected" then
        self.server:disconnect()
        self.host:flush()
    end
end

return Client
