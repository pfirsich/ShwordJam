local maps = require("maps")

local scene = {name = "game"}

function scene.enter(mapPath)
    maps.loadmap(mapPath)
end

return scene
