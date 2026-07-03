local Window = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/Nova%20pasta/Library/Components/Window.lua"
))()

local Library = {}
Library.__index = Library

function Library.CreateLib(title, theme)
    return Window.new(title, theme)
end

return Library
