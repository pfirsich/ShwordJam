local mp = require("libs.MessagePack")
local utils = require("utils")
local const = require("constants")

local netUtils = {}

function netUtils.sendPackage(peer, type, data)
    netUtils.netLog("send", type, data and utils.inspect(data))

    peer:send(mp.pack({
        type = type,
        data = data,
    }))
end

function netUtils.netLog(...)
    if const.net.log then
        print(...)
    end
end


return netUtils
