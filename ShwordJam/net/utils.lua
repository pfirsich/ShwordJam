local mp = require("libs.MessagePack")

local utils = {}

function utils.sendPackage(peer, type, data)
    print("send", type)
    peer:send(mp.pack({
        type = type,
        data = data,
    }))
end


return utils
