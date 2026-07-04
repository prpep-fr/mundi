local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")

local Section = {}
Section.__index = Section

function Section.new(name, tab)
    local self = setmetatable({}, Section)
    self.tab = tab
    self.name = name

    self.frame = Instance.new("Frame")
    self.frame.Name = "sectionFrame"
    self.frame.Parent = tab.page
    self.frame.BackgroundColor3 = tab.window.theme:Get("Background")
    self.frame.BorderSizePixel = 0

    self.layout = Instance.new("UIListLayout")
    self.layout.Parent = self.frame
    self.layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.layout.Padding = UDim.new(0, 5)

    self.header = Instance.new("Frame")
    self.header.Name = "sectionHead"
    self.header.Parent = self.frame
    self.header.BackgroundColor3 = tab.window.theme:Get("SchemeColor")
    self.header.Size = UDim2.new(0, 352, 0, 33)
    Utility.ApplyCorner(self.header, 4)

    self.title = Instance.new("TextLabel")
    self.title.Name = "sectionName"
    self.title.Parent = self.header
    self.title.BackgroundTransparency = 1
    self.title.Position = UDim2.new(0.02, 0, 0, 0)
    self.title.Size = UDim2.new(0.98, 0, 1, 0)
    self.title.Font = Enum.Font.Gotham
    self.title.RichText = true
    self.title.Text = name
    self.title.TextColor3 = tab.window.theme:Get("TextColor")
    self.title.TextSize = 14
    self.title.TextXAlignment = Enum.TextXAlignment.Left

    self.content = Instance.new("Frame")
    self.content.Name = "sectionInners"
    self.content.Parent = self.frame
    self.content.BackgroundTransparency = 1
    self.content.Position = UDim2.new(0, 0, 0.19, 0)
    self.content.Size = UDim2.new(1, 0, 0, 0)

    self.contentLayout = Instance.new("UIListLayout")
    self.contentLayout.Parent = self.content
    self.contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.contentLayout.Padding = UDim.new(0, 3)

    self.window = tab.window
    self.window.theme:Register(self.frame, "BackgroundColor3", "Background")
    self.window.theme:Register(self.header, "BackgroundColor3", "SchemeColor")
    self.window.theme:Register(self.title, "TextColor3", "TextColor")

    self.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.content.Size = UDim2.new(1, 0, 0, self.contentLayout.AbsoluteContentSize.Y)
        self.frame.Size = UDim2.new(0, 352, 0, self.contentLayout.AbsoluteContentSize.Y + 38)
        self.tab.page.CanvasSize = UDim2.new(0, self.tab.list.AbsoluteContentSize.Y, 0, 0)
    end)

    self.elements = {}
    return self
end

function Section:NewButton(name, tip, callback)
    local Button = GithubRequire("Library/Components/Button")
    local element = Button.new(name or "Click Me!", tip or "Tip: Clicking this nothing will happen!", callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewToggle(name, tip, callback)
    local Toggle = GithubRequire("Library/Components/Toggle")
    local element = Toggle.new(name or "Toggle", tip or "Prints Current Toggle State", callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewSlider(name, tip, maxValue, minValue, callback)
    local Slider = GithubRequire("Library/Components/Slider")
    local element = Slider.new(name or "Slider", tip or "Slider tip here", maxValue or 500, minValue or 16, callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewDropdown(name, inf, list, callback)
    local Dropdown = GithubRequire("Library/Components/Dropdown")
    local element = Dropdown.new(name or "Dropdown", inf or "Dropdown info", list or {}, callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewTextBox(name, tip, callback)
    local Textbox = GithubRequire("Library/Components/Textbox")
    local element = Textbox.new(name or "Textbox", tip or "Gets a value of Textbox", callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewKeybind(name, tip, defaultKey, callback)
    local Keybind = GithubRequire("Library/Components/Keybind")
    local element = Keybind.new(name or "KeybindText", tip or "KeybindInfo", defaultKey, callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewColorPicker(name, tip, defaultColor, callback)
    local ColorPicker = GithubRequire("Library/Components/ColorPicker")
    local element = ColorPicker.new(name or "ColorPicker", tip or "ColorPicker info", defaultColor or Color3.fromRGB(255, 255, 255), callback or function() end, self)
    table.insert(self.elements, element)
    return element
end

function Section:NewLabel(text)
    local Label = GithubRequire("Library/Components/Label")
    local element = Label.new(text or "Label", self)
    table.insert(self.elements, element)
    return element
end

return Section
