local mp = require("libs.MessagePack")
local const = require("constants")

local utils = {}

function utils.sendPackage(peer, type, data)
    utils.netLog("send", type, data)

    peer:send(mp.pack({
        type = type,
        data = data,
    }))
end

function utils.netLog(...)
    if const.net.log then
        print(...)
    end
end


return utils
