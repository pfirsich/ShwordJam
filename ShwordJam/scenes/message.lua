local fonts = require("fonts")

local scene = {name = "message"}

local message

function scene.enter(_message)
    message = _message
end

function scene.draw()
    lg.setBackgroundColor(240, 240, 240)

    lg.setColor(20, 20, 20)
    lg.setFont(fonts.big)
    lg.print(message, 80, 80)
end


return scene
