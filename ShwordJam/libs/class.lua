local function class_call(c, ...)
    local self = setmetatable({}, c)
    self.class = c
    if self.init then self:init(...) end
    return self
end

function class(name, base)
    local cls = {}
    cls.__index = cls
    cls.name = name

    return setmetatable(cls, {
        __index = base,
        __call = class_call,
    })
end

return class
