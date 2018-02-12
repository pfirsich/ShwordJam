local class = require("libs.class")
local utils = require("utils")


local Animaton = class("Animaton")

function Animaton:initialize(keyFrames, speed, loop, loopPoint)
    self.keyFrames = keyFrames

    self.loop = loop or false
    self.speed = speed
    self.loopPoint = loopPoint
end

function Animaton:apply(target, time)
    local length = self:length()

    local prevForKey = {}
    local nextForKey = {}
    for _, keyFrame in ipairs(self.keyFrames) do
        if keyFrame._time <= time then
            for k in pairs(keyFrame) do
                if k ~= "_time" then
                    prevForKey[k] = {
                        value = keyFrame[k],
                        time = keyFrame._time,
                    }
                end
            end
        end
        if keyFrame._time >= time then
            for k in pairs(keyFrame) do
                if k ~= "_time" and not nextForKey[k] then
                    nextForKey[k] = {
                        value = keyFrame[k],
                        time = keyFrame._time,
                    }
                end
            end
        end
    end

    for key, prev in pairs(prevForKey) do
        if nextForKey[key] then
            next = nextForKey[key]
            local timeBetweenKeyFrames = next.time - prev.time
            if timeBetweenKeyFrames == 0 then
                target[key] = prev.value
            else
                local timeOffset = time - prev.time
                local progress = timeOffset / timeBetweenKeyFrames
                local valueBetweenFrames = next.value - prev.value
                local valueOffset = valueBetweenFrames * progress
                target[key] = prev.value + valueOffset
            end
        else
            target[key] = prev.value
        end
    end
end

function Animaton:length()
    return self.keyFrames[#self.keyFrames]._time
end

return Animaton
