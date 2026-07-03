local Utility = require(script.Parent.Parent.Core.Utility)

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(name, tip, list, callback, section)
    local self = setmetatable({}, Dropdown)
    local theme = section.window.theme
    list = list or {}

    self.frame = Instance.new("Frame")
    self.frame.Name = "dropFrame"
    self.frame.Parent = section.content
    self.frame.BackgroundColor3 = theme:Get("Background")
    self.frame.BorderSizePixel = 0
    self.frame.Position = UDim2.new(0, 0, 1.2357, 0)
    self.frame.Size = UDim2.new(0, 352, 0, 33)
    self.frame.ClipsDescendants = true

    self.openButton = Instance.new("TextButton")
    self.openButton.Name = "dropOpen"
    self.openButton.Parent = self.frame
    self.openButton.BackgroundColor3 = theme:Get("ElementColor")
    self.openButton.Size = UDim2.new(1, 0, 0, 33)
    self.openButton.AutoButtonColor = false
    self.openButton.Font = Enum.Font.SourceSans
    self.openButton.Text = ""
    self.openButton.TextColor3 = Color3.new(0, 0, 0)
    self.openButton.TextSize = 14
    self.openButton.ClipsDescendants = true

    Utility.ApplyCorner(self.openButton, 4)

    self.label = Instance.new("TextLabel")
    self.label.Name = "itemTextbox"
    self.label.Parent = self.openButton
    self.label.BackgroundTransparency = 1
    self.label.Position = UDim2.new(0.097, 0, 0.273, 0)
    self.label.Size = UDim2.new(0, 138, 0, 14)
    self.label.Font = Enum.Font.GothamSemibold
    self.label.Text = name
    self.label.RichText = true
    self.label.TextColor3 = theme:Get("TextColor")
    self.label.TextSize = 14
    self.label.TextXAlignment = Enum.TextXAlignment.Left

    self.icon = Instance.new("ImageLabel")
    self.icon.Name = "listImg"
    self.icon.Parent = self.openButton
    self.icon.BackgroundTransparency = 1
    self.icon.Position = UDim2.new(0.02, 0, 0.18, 0)
    self.icon.Size = UDim2.new(0, 21, 0, 21)
    self.icon.Image = "rbxassetid://3926305904"
    self.icon.ImageColor3 = theme:Get("SchemeColor")
    self.icon.ImageRectOffset = Vector2.new(644, 364)
    self.icon.ImageRectSize = Vector2.new(36, 36)

    self.viewInfo = Instance.new("ImageButton")
    self.viewInfo.Name = "viewInfo"
    self.viewInfo.Parent = self.openButton
    self.viewInfo.BackgroundTransparency = 1
    self.viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    self.viewInfo.Size = UDim2.new(0, 23, 0, 23)
    self.viewInfo.ZIndex = 2
    self.viewInfo.Image = "rbxassetid://3926305904"
    self.viewInfo.ImageRectOffset = Vector2.new(764, 764)
    self.viewInfo.ImageRectSize = Vector2.new(36, 36)
    self.viewInfo.ImageColor3 = theme:Get("SchemeColor")

    self.optionsLayout = Instance.new("UIListLayout")
    self.optionsLayout.Parent = self.frame
    self.optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.optionsLayout.Padding = UDim.new(0, 3)

    self.infoLabel = Instance.new("TextLabel")
    self.infoLabel.Name = "TipMore"
    self.infoLabel.Parent = section.window.infoContainer
    self.infoLabel.BackgroundTransparency = 1
    self.infoLabel.Position = UDim2.new(0, 0, 2, 0)
    self.infoLabel.Size = UDim2.new(0, 353, 0, 33)
    self.infoLabel.Font = Enum.Font.GothamSemibold
    self.infoLabel.RichText = true
    self.infoLabel.Text = "  " .. tip
    self.infoLabel.TextColor3 = theme:Get("TextColor")
    self.infoLabel.TextSize = 14
    self.infoLabel.TextXAlignment = Enum.TextXAlignment.Left

    theme:Register(self.frame, "BackgroundColor3", "Background")
    theme:Register(self.openButton, "BackgroundColor3", "ElementColor")
    theme:Register(self.label, "TextColor3", "TextColor")
    theme:Register(self.icon, "ImageColor3", "SchemeColor")
    theme:Register(self.viewInfo, "ImageColor3", "SchemeColor")
    theme:Register(self.infoLabel, "TextColor3", "TextColor")

    self.open = false
    local focus = false
    local viewActive = false

    local function updateSize()
        self.frame.Size = UDim2.new(0, 352, 0, 33 + (self.open and self.optionsLayout.AbsoluteContentSize.Y or 0))
        section.content.Size = UDim2.new(1, 0, 0, section.contentLayout.AbsoluteContentSize.Y)
        section.frame.Size = UDim2.new(0, 352, 0, section.contentLayout.AbsoluteContentSize.Y + 38)
    end

    local function closeDropdown()
        self.open = false
        self.frame.Size = UDim2.new(0, 352, 0, 33)
        updateSize()
    end

    local function openDropdown()
        self.open = true
        self.frame.Size = UDim2.new(0, 352, 0, 33 + self.optionsLayout.AbsoluteContentSize.Y)
        updateSize()
    end

    self.openButton.MouseButton1Click:Connect(function()
        if focus then
            return
        end
        if self.open then
            closeDropdown()
        else
            openDropdown()
        end
    end)

    local function createOption(option)
        local button = Instance.new("TextButton")
        button.Name = "optionSelect"
        button.Parent = self.frame
        button.BackgroundColor3 = theme:Get("ElementColor")
        button.Size = UDim2.new(1, 0, 0, 33)
        button.AutoButtonColor = false
        button.Font = Enum.Font.GothamSemibold
        button.Text = "  " .. option
        button.TextColor3 = theme:Get("TextColor")
        button.TextSize = 14
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.ClipsDescendants = true

        Utility.ApplyCorner(button, 4)

        local icon = Instance.new("ImageLabel")
        icon.Name = "Sample1"
        icon.Parent = button
        icon.BackgroundTransparency = 1
        icon.Image = "http://www.roblox.com/asset/?id=4560909609"
        icon.ImageColor3 = theme:Get("SchemeColor")
        icon.ImageTransparency = 0.6

        theme:Register(button, "BackgroundColor3", "ElementColor")
        theme:Register(button, "TextColor3", "TextColor")
        theme:Register(icon, "ImageColor3", "SchemeColor")

        button.MouseButton1Click:Connect(function()
            if focus then
                return
            end
            self.label.Text = option
            callback(option)
            closeDropdown()
        end)
    end

    for _, option in ipairs(list) do
        createOption(option)
    end

    self.viewInfo.MouseButton1Click:Connect(function()
        if viewActive then
            return
        end
        viewActive = true
        focus = true
        Utility.Tween(self.infoLabel, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.delay(1.5, function()
            focus = false
            Utility.Tween(self.infoLabel, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
            viewActive = false
        end)
    end)

    section.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    function self:Refresh(newList)
        for _, child in ipairs(self.frame:GetChildren()) do
            if child.Name == "optionSelect" then
                child:Destroy()
            end
        end
        for _, option in ipairs(newList or {}) do
            createOption(option)
        end
        if self.open then
            openDropdown()
        end
    end

    return self
end

return Dropdown
