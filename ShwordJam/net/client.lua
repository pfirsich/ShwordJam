require("enet")

local class = require("libs.class")
local utils = require("utils")
local netUtils = require("net.utils")
local GameObject = require("gameobject")
local mp = require("libs.MessagePack")

local Client = class("Client")


function Client:initialize(server_host)

    self.host = enet.host_create()
    self.server = self.host:connect(server_host)
end

function Client:handlePackage(type, data)
    netUtils.netLog("handle", type, utils.inspect(data))

    if type == "update" then
        for _, object in ipairs(data.updates) do
            -- update world
        end
    end
end

function Client:processPackage(eventData)
    local package = mp.unpack(eventData)
    self:handlePackage(package.type, package.data)
end

function Client:receive()
    local event = self.host:service()

    while event do
        if event.type == "receive" then
            self:processPackage(event.data)
        elseif event.type == "connect" then
            error("Invalid state: only just connected")
        elseif event.type == "disconnect" then
            return "Server disconnected"
        end
        event = self.host:service()
    end

    return nil
end

function Client:sendUpdate()
    local updates = {}

    for _, object in pairs(GameObject.world) do
        if object.owned then
            if object.serialize then
                table.insert(updates, object.serialize())
            else
                table.insert(updates, object)
            end
        end
    end

    netUtils.sendPackage(self.server, "update", {
        updates = updates
    })

    return nil
end

function Client:checkConnected()
    if self.server:state() == "connected" then
        return {connected = true}
    else
        local event = self.host:service()
        while event do
            if event.type == "receive" then
                error("Invalid state: Got message while waiting for a connection")
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
