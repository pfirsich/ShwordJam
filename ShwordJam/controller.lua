local utils = require("utils")

local Control = utils.class("Control")

local binaryGamepadInputs = {
    "a", "b", "x", "y", "back", "guide", "start",
    "leftstick", "rightstick", "leftshoulder", "rightshoulder",
    "dpup", "dpdown", "dpleft", "dpright"
}
local analogGamepadInputs = {
    "leftx", "lefty", "rightx", "righty",
    "triggerleft", "triggerright"
}

function Control:initialize(getState, isBinary)
    self.getState = getState
    self.isBinary = isBinary
    if self.isBinary then
        self.state = false
        self.lastState = false
        self.pressed = false
        self.released = false
    else
        self.state = 0
        self.lastState = 0
    end
end

function Control:update()
    self.lastState = self.state
    self.state = self.getState()

    if self.isBinary then
        self.pressed = self.state and not self.lastState
        self.released = not self.state and self.lastState
    end
end

local analogSlots = {
    "moveX", "moveY",
}

local binarySlots =  {
    "jump", "attack", "dodge",
    "shwordA", "shwordB", "shwordC",
}

local allSlots = utils.table.mergeLists(analogSlots, binarySlots)

local Controller = utils.class("Controller")

function Controller:initialize()

end

function Controller:bind(slot, getState)
    assert(utils.table.inList(allSlots, slot))
    local isBinarySlot = utils.table.inList(binarySlots, slot)
    assert(isBinarySlot and type(getState()) == "boolean" or type(getState()) == "number")
    self[slot] = Control(getState, isBinarySlot)
end

function Controller:update()
    for _, slot in ipairs(slots) do
        self[slot]:update()
    end
end

----

local function gamepadButton(joystick, button)
    return function()
        return joystick:isGamepadDown(button)
    end
end

local function gamepadAxis(joystick, axis)
    return function()
        return joystick:getGamepadAxis(axis)
    end
end

local function _binaryDummy()
    return false
end

local function binaryDummy()
    return _binaryDummy
end

local function _analogDummy()
    return 0
end

local function analogDummy()
    return _analogDummy
end

----

local function gamepadController(joystick)
    local ctrl = Controller()
    ctrl:bind("moveX", gamepadAxis(joystick, "leftx"))
    ctrl:bind("moveY", gamepadAxis(joystick, "lefty"))
    ctrl:bind("jump", gamepadButton(joystick, "a"))
    ctrl:bind("attack", gamepadButton(joystick, "rightshoulder"))
    ctrl:bind("dodge", gamepadButton(joystick, "leftshoulder"))
    ctrl:bind("shwordA", gamepadButton(joystick, "x"))
    ctrl:bind("shwordB", gamepadButton(joystick, "y"))
    ctrl:bind("shwordC", gamepadButton(joystick, "b"))
    return ctrl
end

local function dummyController()
    local ctrl = Controller()
    for _, slot in ipairs(analogSlots) do
        ctrl:bind(slot, analogDummy())
    end
    for _, slot in ipairs(binarySlots) do
        ctrl:bind(slot, binaryDummy())
    end
end

return {gamepadController, dummyController}
