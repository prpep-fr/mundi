local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({ _listeners = {} }, Signal)
    return self
end

function Signal:Connect(callback)
    assert(typeof(callback) == "function", "Signal callback must be a function")
    table.insert(self._listeners, callback)
    local index = #self._listeners
    return {
        Disconnect = function()
            self._listeners[index] = nil
        end,
    }
end

function Signal:Fire(...)
    for _, callback in ipairs(self._listeners) do
        if callback then
            task.spawn(callback, ...)
        end
    end
end

function Signal:Clear()
    table.clear(self._listeners)
end

return Signal