local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Window = GithubRequire("/Library/Components/Window")

local Library = {}
Library.__index = Library

function Library.CreateLib(title, theme)
    return Window.new(title, theme)
end

Library.CreateLib(TEST, DarkTheme)

return Library
