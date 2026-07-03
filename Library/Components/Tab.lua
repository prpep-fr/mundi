local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")

local Tab = {}
Tab.__index = Tab

local function createFrame(properties)
    local frame = Instance.new("Frame")
    for property, value in pairs(properties) do
        frame[property] = value
    end
    return frame
end

function Tab.new(name, window)
    local self = setmetatable({}, Tab)
    self.window = window
    self.name = name
    self.page = Instance.new("ScrollingFrame")
    self.page.Name = "Page"
    self.page.Parent = window.pagesFolder
    self.page.Active = true
    self.page.BackgroundColor3 = window.theme:Get("Background")
    self.page.BorderSizePixel = 0
    self.page.Position = UDim2.new(0, 0, -0.0037, 0)
    self.page.Size = UDim2.new(1, 0, 1, 0)
    self.page.Visible = false
    self.page.ScrollBarThickness = 5
    self.page.ScrollBarImageColor3 = window.theme:Get("SchemeColor")

    self.list = Instance.new("UIListLayout")
    self.list.Parent = self.page
    self.list.SortOrder = Enum.SortOrder.LayoutOrder
    self.list.Padding = UDim.new(0, 5)

    self.button = Instance.new("TextButton")
    self.button.Name = name .. "TabButton"
    self.button.Parent = window.tabContainer
    self.button.BackgroundColor3 = window.theme:Get("SchemeColor")
    self.button.Size = UDim2.new(0, 135, 0, 28)
    self.button.AutoButtonColor = false
    self.button.Font = Enum.Font.Gotham
    self.button.Text = name
    self.button.TextColor3 = window.theme:Get("TextColor")
    self.button.TextSize = 14
    self.button.BackgroundTransparency = 1

    Utility.ApplyCorner(self.button, 5)

    window.theme:Register(self.page, "BackgroundColor3", "Background")
    window.theme:Register(self.page, "ScrollBarImageColor3", "SchemeColor")
    window.theme:Register(self.button, "BackgroundColor3", "SchemeColor")
    window.theme:Register(self.button, "TextColor3", "TextColor")

    self.button.MouseButton1Click:Connect(function()
        for _, child in ipairs(window.pagesFolder:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        self.page.Visible = true
        for _, tabButton in ipairs(window.tabContainer:GetChildren()) do
            if tabButton:IsA("TextButton") then
                tabButton.BackgroundTransparency = 1
            end
        end
        self.button.BackgroundTransparency = 0
    end)

    if #window.tabs == 0 then
        self.page.Visible = true
        self.button.BackgroundTransparency = 0
    end

    self.sections = {}
    self.page.ChildAdded:Connect(function()
        self.page.CanvasSize = UDim2.new(0, self.list.AbsoluteContentSize.Y, 0, 0)
    end)
    self.page.ChildRemoved:Connect(function()
        self.page.CanvasSize = UDim2.new(0, self.list.AbsoluteContentSize.Y, 0, 0)
    end)

    return self
end

function Tab:NewSection(name)
    local Section = GithubRequire("Library/Components/Section")
    local section = Section.new(name, self)
    table.insert(self.sections, section)
    return section
end

return Tab
