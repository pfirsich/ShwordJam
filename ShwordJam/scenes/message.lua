local scene = {name = "message"}

local message

function scene.enter(_message)
    message = _message
end

function scene.draw()
    lg.print(message, 80, 80)
end


return scene
