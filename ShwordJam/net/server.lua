require("enet")

local class = require("libs.class")
local utils = require("utils")
local netUtils = require("net.utils")
local GameObject = require("gameobject")
local mp = require("libs.MessagePack")

local Server = class("Server")


function Server:initialize(port)
    self.host = enet.host_create("*:" .. port)
    if not self.host then
        error("Can't create host")
    end
end

function Server:handlePackage(type, data)
    netUtils.netLog("handle", type, utils.inspect(data))

    if type == "update" then
        for _, object in ipairs(data.updates) do
            -- update world
        end
    end
end

function Server:processPackage(eventData)
    local package = mp.unpack(eventData)
    self:handlePackage(package.type, package.data)
end

function Server:receive()
    local event = self.host:service()

    while event do
        if event.type == "receive" then
            self:processPackage(event.data)
        elseif event.type == "connect" then
            print("Client connected", event.peer)
        elseif event.type == "disconnect" then
            print("Client disconnected", event.peer)
        end
        event = self.host:service()
    end

    return nil
end

function Server:broadcastPackage(type, data)
    for i = 1, self.host:peer_count() do
        local peer = self.host:get_peer(i)
        if peer:state() == "connected" then
            netUtils.sendPackage(peer, type, data)
        end
    end
end

function Server:broadcastUpdate()
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

    self:broadcastPackage("update", {
        updates = updates
    })
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
