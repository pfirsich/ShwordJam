local class = require("libs.class")
local utils = require("utils")
local Animation = require("animation")


local Animator = class("Animator")

Animator.animationFiles = {}

local modified = utils.ModifiedChecker()

function Animator.reloadAnimationFiles()
    for path, file in pairs(Animator.animationFiles) do
        print(("Reload animator %s"):format(path))
        Animator.load(path)
    end
end

function Animator.load(path, animator)
    local animFile = Animator.animationFiles[path]
    if not animFile then
        animFile = {
            animations = {},
            animators = setmetatable({}, {__mode = "v"}),
        }
        Animator.animationFiles[path] = animFile
    end

    if animator then
        table.insert(animFile.animators, animator)
    end

    -- if modified(path) is called the first time for path, it returns true
    if modified(path) then
        for key, value in pairs(utils.loveDoFile(path)) do
            local animation = Animation(value.keyFrames)
            animFile.animations[key] = {
                animation = animation,
                speed = value.speed,
                loop = value.loop,
                loopPoint = value.loopPoint,
            }
        end

        -- pairs, because .animators is a weak-valued table!
        for _, animator in pairs(animFile.animators) do
            animator:updateAnimations(animFile.animations)
        end
    end

    return animFile.animations
end

function Animator:initialize(target, animationsFileName)
    self.target = target
    self.current = nil
    self.speedMultiplier = 1
    self.time = 0
    self.animations = Animator.load(animationsFileName, self)
end

function Animator:updateAnimations(animations)
    self.animations = animations
end

function Animator:play(name, speedMultiplier)
    self.current = name
    self.speedMultiplier = speedMultiplier or 1
    self.time = 0
end

function Animator:update(dt)
    if self.current then
        local current = self.animations[self.current]
        local anim = current.animation
        local speed = current.speed
        local loop = current.loop
        local loopPoint = current.loopPoint

        self.time = self.time + dt * speed * self.speedMultiplier
        local length = anim:length()


        if loop then
            if self.time > length then
                if loopPoint then
                    self.time = loopPoint + self.time % length
                else
                    self.time = self.time % length
                end
            end
        end

        anim:apply(self.target, self.time)
    end
end

return Animator
