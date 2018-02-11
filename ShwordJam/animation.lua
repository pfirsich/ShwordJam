local class = require("libs.class")
local utils = require("utils")


local Animaton = class("Animaton")

function Animaton:initialize(object, keyFrames)
    self.object = object
    self.keyFrames = keyFrames
    self.animatedKeys = {}

    for _, keyFrame in ipairs(self.keyFrames) do
        for key in pairs(keyFrame) do
            self.animatedKeys[key] = true
        end
    end
end

function Animaton:apply(time)
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
                self.object[key] = prev.value
            else
                local timeOffset = time - prev.time
                local progress = timeOffset / timeBetweenKeyFrames
                local valueBetweenFrames = next.value - prev.value
                local valueOffset = valueBetweenFrames * progress
                self.object[key] = prev.value + valueOffset
            end
        end
    end
end

return Animaton
