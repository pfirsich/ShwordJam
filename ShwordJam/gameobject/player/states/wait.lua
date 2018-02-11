local const = require("constants")
local states = require("gameobject.player.states.states")

local Wait = class("Wait", states.Base)

function Wait:initialize(player, ...)
    states.Base.initialize(self, player)
end

function Wait:enter()
    self.lastMove = nil
end

function Wait:exit(newState)

end

function Wait:update()
    local player = self.player

    player:friction(const.player.friction)

    if math.abs(player.moveDir[1]) <= 1e-5 then
        self.lastMove = nil
    else
        if not self.lastMove then
            self.lastMove = player.frameCounter
        end
    end

    if self.lastMove then
        if math.abs(player.moveDir[1]) > const.player.dashThresh then
            player:setState(states.Dash)
        elseif math.abs(player.moveDir[1]) > 1e-5 then
            player:setState(states.Run)
        end
    end

    if not player:onGround() then
        player:setState(states.Fall)
    end
end

return Wait
