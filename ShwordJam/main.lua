lg = love.graphics
lf = love.filesystem
lm = love.math
lk = love.keyboard

require("libs.HC")

require("libs.strict")

local scenes = require("scenes")
local utils = require("utils")
local const = require("constants")
local fonts = require("fonts")
local Animator = require("animator")

function love.load(args)
    requireScenes()
    const.reload()

    -- load scenes
    for name, scene in pairs(scenes) do
        scene.realTime = 0
        scene.simTime = 0
        scene.frameCounter = 0
        utils.callNonNil(scene.load)
    end

    if args[2] == "--server" then
        enterScene(scenes.server, "test")
    else
        enterScene(scenes.connect, "test")
    end
end

function love.update()

end

function love.draw(dt)
    getCurrentScene().draw(dt)
end

function love.keypressed(key)
    local ctrl = lk.isDown("lctrl") or lk.isDown("rctrl")
    if ctrl and key == "r" then
        const.reload()
        Animator.reloadAnimationFiles()
    end
    if ctrl and key == "return" then
        enterScene(scenes.connect, "test")
    end
end

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        local scene = getCurrentScene()
        while scene.simTime <= scene.realTime do
            scene.simTime = scene.simTime + const.SIM_DT
            scene.frameCounter = scene.frameCounter + 1

            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            utils.callNonNil(scene.exit)
                            return a
                        end
                    end

                    love.handlers[name](a, b, c, d, e, f)
                    utils.callNonNil(scene[name], a, b, c, d, e, f)
                end
            end

            love.update()
            utils.callNonNil(scene.tick)
        end

        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        scene.realTime = scene.realTime + dt

        if lg and lg.isActive() then
            lg.clear(lg.getBackgroundColor())
            lg.origin()
            love.draw(dt)

            lg.setColor(20, 20, 20)
            lg.setFont(fonts.big)
            lg.print(love.timer.getFPS(), 5, 5)

            lg.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
