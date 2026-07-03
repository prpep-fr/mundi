local Signal = require(script.Parent.Signal)

local Theme = {}
Theme.__index = Theme

local baseThemes = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20),
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224),
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20),
    },
    GrapeTheme = {
        SchemeColor = Color3.fromRGB(166, 71, 214),
        Background = Color3.fromRGB(64, 50, 71),
        Header = Color3.fromRGB(36, 28, 41),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(74, 58, 84),
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71),
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(26, 189, 158),
        Background = Color3.fromRGB(44, 62, 82),
        Header = Color3.fromRGB(57, 81, 105),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(52, 74, 95),
    },
    Sentinel = {
        SchemeColor = Color3.fromRGB(230, 35, 69),
        Background = Color3.fromRGB(32, 32, 32),
        Header = Color3.fromRGB(24, 24, 24),
        TextColor = Color3.fromRGB(119, 209, 138),
        ElementColor = Color3.fromRGB(24, 24, 24),
    },
    Synapse = {
        SchemeColor = Color3.fromRGB(46, 48, 43),
        Background = Color3.fromRGB(13, 15, 12),
        Header = Color3.fromRGB(36, 38, 35),
        TextColor = Color3.fromRGB(152, 99, 53),
        ElementColor = Color3.fromRGB(24, 24, 24),
    },
    Serpent = {
        SchemeColor = Color3.fromRGB(0, 166, 58),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(22, 29, 31),
    },
}

local function resolveTheme(theme)
    if typeof(theme) == "string" then
        return baseThemes[theme] or baseThemes.DarkTheme
    elseif typeof(theme) == "table" then
        return {
            SchemeColor = theme.SchemeColor or Color3.fromRGB(74, 99, 135),
            Background = theme.Background or Color3.fromRGB(36, 37, 43),
            Header = theme.Header or Color3.fromRGB(28, 29, 34),
            TextColor = theme.TextColor or Color3.fromRGB(255, 255, 255),
            ElementColor = theme.ElementColor or Color3.fromRGB(32, 32, 38),
        }
    end
    return baseThemes.DarkTheme
end

function Theme.new(themeName)
    local self = setmetatable({
        values = resolveTheme(themeName),
        Changed = Signal.new(),
        registry = {},
    }, Theme)
    return self
end

function Theme:Register(instance, property, themeKey)
    assert(instance and typeof(property) == "string" and typeof(themeKey) == "string", "Theme:Register requires instance, property, themeKey")
    self.registry[instance] = self.registry[instance] or {}
    self.registry[instance][property] = themeKey
    instance[property] = self.values[themeKey] or instance[property]
end

function Theme:Apply()
    for instance, properties in pairs(self.registry) do
        if instance and instance.Parent then
            for property, themeKey in pairs(properties) do
                local value = self.values[themeKey]
                if value then
                    instance[property] = value
                end
            end
        end
    end
end

function Theme:Set(themeNameOrTable)
    self.values = resolveTheme(themeNameOrTable)
    self.Changed:Fire(self.values)
    self:Apply()
end

function Theme:Get(name)
    return self.values[name]
end

return Theme
