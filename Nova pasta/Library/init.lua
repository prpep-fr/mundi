local Window = require(script.Components.Window)

local Library = {}
Library.__index = Library

function Library.CreateLib(title, theme)
    return Window.new(title, theme)
end

return Library
