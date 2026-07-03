local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Window = GithubRequire("/Library/Components/Window")

local Library = {}
Library.__index = Library

function Library.CreateLib(title, theme)
    return Window.new(title, theme)
end

local win = Library.CreateLib("TEST", "DarkTheme")
local tab1 = win:NewTab("Principal")
local tab2 = win:NewTab("Config")
local section = tab1:NewSection("Alguma coisa")

return Library
