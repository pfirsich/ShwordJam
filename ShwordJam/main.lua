lg = love.graphics
lf = love.filesystem
lm = love.math
lk = love.keyboard

require("libs.HC")

require("libs.strict")

local scenes = require("scenes")
local const = require("constants")
local utils = require("utils")
local Animaton = require("animation")


local o = {x = 8}
local a = Animaton(o, {
    {
        _time = 0,
        x = 50,
        y = 8,
    },
    {
        _time = 0.2,
        x = 10,
    },
    {
        _time = 0.4,
        x = 50,
        y = 30,
    },
    {
        _time = 0.8,
        x = 80,
    },
    {
        _time = 1,
        x = 50,
        y = 8,
    },
}, true)

for i= 0, 40 do
    local t = i / 20
    a:apply(t)
    for i = 1, o.x do
        io.write(' ')
    end
    print('.')
    for i = 1, o.y do
        io.write(' ')
    end
    print('+')
    -- print(t, o.x)
end


function love.load()
    requireScenes()
    const.reload()

    -- load scenes
    for name, scene in pairs(scenes) do
        scene.realTime = 0
        scene.simTime = 0
        scene.frameCounter = 0
        utils.callNonNil(scene.load)
    end

    enterScene(scenes.game, 'test')
end

function love.update()

end

function love.draw()
    getCurrentScene().draw()
end

function love.keypressed(key)
    local ctrl = lk.isDown("lctrl") or lk.isDown("rctrl")
    if ctrl and key == "r" then
        const.reload()
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
        while scene.simTime < scene.realTime do
            scene.simTime = scene.simTime + const.SIM_DT
            scene.frameCounter = scene.frameCounter + 1

            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
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
            lg.print(love.timer.getFPS(), 5, 5)
            lg.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
