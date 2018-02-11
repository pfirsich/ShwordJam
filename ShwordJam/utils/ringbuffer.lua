local class = require("libs.class")

local RingBuffer = class("RingBuffer")

function RingBuffer:init(size)
    self._buffer = {}
    self._size = size
    self._nextIndex = 1
end

function RingBuffer:push(data)
    self._buffer[self._nextIndex] = data
    self._nextIndex = self._nextIndex + 1
    if self._nextIndex > self._size then
        self._nextIndex = 1
    end
end

function RingBuffer:getRealIndex(index)
    if index < 0 then
        index = #self._buffer + index + 1
    end

    if index > #self._buffer then
        return nil
    end

    if #self._buffer < self._size then
        return index
    else
        index = index + self._nextIndex - 1
        if index > self._size then
            index = index - self._size
        end
        return index
    end
end

-- 1 is the "oldest" element in the list
function RingBuffer:get(index)
    return self._buffer[self:getRealIndex(index)]
end

function RingBuffer:set(index, data)
    self._buffer[self:getRealIndex(index)] = data
end

function RingBuffer:size()
    return #self._buffer
end

function RingBuffer:list(reversed)
    local ret = {}
    for i = 1, #self._buffer do
        ret[i] = self:get(reversed and -i or i)
    end
    return ret
end

return RingBuffer
