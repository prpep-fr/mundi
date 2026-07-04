local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")
local Drag = GithubRequire("Library/Core/Drag")
local Theme = GithubRequire("Library/Core/Theme")

local Window = {}
Window.__index = Window

local function createFrame(properties)
    local frame = Instance.new("Frame")
    for property, value in pairs(properties) do
        frame[property] = value
    end
    return frame
end

function Window.new(title, themeName)
    local self = setmetatable({}, Window)
    self.theme = Theme.new(themeName or "DarkTheme")
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = title or "Library"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.screenGui.Parent = game:GetService("CoreGui")

    self.main = createFrame({
        Name = "Main",
        Parent = self.screenGui,
        BackgroundColor3 = self.theme:Get("Background"),
        ClipsDescendants = true,
        Position = UDim2.new(0.3365, 0, 0.2755, 0),
        Size = UDim2.new(0, 525, 0, 318),
    })
    Utility.ApplyCorner(self.main, 4)

    self.header = createFrame({
        Name = "MainHeader",
        Parent = self.main,
        BackgroundColor3 = self.theme:Get("Header"),
        Size = UDim2.new(1, 0, 0, 29),
    })
    Utility.ApplyCorner(self.header, 4)
    Drag.Enable(self.header, self.main)

    self.title = Instance.new("TextLabel")
    self.title.Name = "Title"
    self.title.Parent = self.header
    self.title.BackgroundTransparency = 1
    self.title.Position = UDim2.new(0.017, 0, 0.345, 0)
    self.title.Size = UDim2.new(0, 204, 0, 8)
    self.title.Font = Enum.Font.Gotham
    self.title.RichText = true
    self.title.Text = title or "Library"
    self.title.TextColor3 = self.theme:Get("TextColor")
    self.title.TextSize = 16
    self.title.TextXAlignment = Enum.TextXAlignment.Left

    self.closeButton = Instance.new("ImageButton")
    self.closeButton.Name = "Close"
    self.closeButton.Parent = self.header
    self.closeButton.BackgroundTransparency = 1
    self.closeButton.Position = UDim2.new(0.95, 0, 0.138, 0)
    self.closeButton.Size = UDim2.new(0, 21, 0, 21)
    self.closeButton.ZIndex = 2
    self.closeButton.Image = "rbxassetid://3926305904"
    self.closeButton.ImageRectOffset = Vector2.new(284, 4)
    self.closeButton.ImageRectSize = Vector2.new(24, 24)

    self.side = createFrame({
        Name = "MainSide",
        Parent = self.main,
        BackgroundColor3 = self.theme:Get("Header"),
        Position = UDim2.new(0, 0, 0.0912, 0),
        Size = UDim2.new(0, 149, 0, 289),
    })
    Utility.ApplyCorner(self.side, 4)

    self.tabContainer = createFrame({
        Name = "tabFrames",
        Parent = self.side,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.0439, 0, -0.0007, 0),
        Size = UDim2.new(0, 135, 0, 283),
    })

    self.tabLayout = Instance.new("UIListLayout")
    self.tabLayout.Parent = self.tabContainer
    self.tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    self.pages = createFrame({
        Name = "pages",
        Parent = self.main,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.299, 0, 0.1226, 0),
        Size = UDim2.new(0, 360, 0, 269),
    })

    self.pagesFolder = Instance.new("Folder")
    self.pagesFolder.Name = "Pages"
    self.pagesFolder.Parent = self.pages

    self.infoContainer = createFrame({
        Name = "infoContainer",
        Parent = self.main,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.299, 0, 0.8742, 0),
        Size = UDim2.new(0, 368, 0, 33),
    })

    self.theme:Register(self.main, "BackgroundColor3", "Background")
    self.theme:Register(self.header, "BackgroundColor3", "Header")
    self.theme:Register(self.side, "BackgroundColor3", "Header")
    self.theme:Register(self.title, "TextColor3", "TextColor")
    self.theme:Register(self.closeButton, "ImageColor3", "TextColor")

    self.theme.Changed:Connect(function()
        self.theme:Apply()
    end)

    self.closeButton.MouseButton1Click:Connect(function()
        self.screenGui:Destroy()
    end)

    self.tabs = {}
    return self
end

function Window:NewTab(tabName)
    local Tab = GithubRequire("Library/Components/Tab")
    local tab = Tab.new(tabName or "Tab", self)
    table.insert(self.tabs, tab)
    return tab
end

function Window:SaveConfig(name, settings)
    local json = game:GetService("HttpService"):JSONEncode(settings or {})
    if writefile then
        writefile(name or "LibraryConfig.json", json)
    end
end

function Window:LoadConfig(name)
    if readfile then
        local data = readfile(name or "LibraryConfig.json")
        return game:GetService("HttpService"):JSONDecode(data)
    end
    return {}
end

function Window:ChangeTheme(themeName)
    self.theme:Set(themeName)
end

function Window:ToggleUI()
    if self.screenGui.Parent then
        self.screenGui.Enabled = not self.screenGui.Enabled
    end
end

return Window
