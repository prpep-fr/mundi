local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")

local Slider = {}
Slider.__index = Slider

function Slider.new(name, tip, maxValue, minValue, callback, section)
    local self = setmetatable({}, Slider)
    local theme = section.window.theme
    maxValue = tonumber(maxValue) or 500
    minValue = tonumber(minValue) or 16

    self.frame = Instance.new("TextButton")
    self.frame.Name = "sliderElement"
    self.frame.Parent = section.content
    self.frame.BackgroundColor3 = theme:Get("ElementColor")
    self.frame.ClipsDescendants = true
    self.frame.Size = UDim2.new(0, 352, 0, 33)
    self.frame.AutoButtonColor = false
    self.frame.Font = Enum.Font.SourceSans
    self.frame.Text = ""
    self.frame.TextColor3 = Color3.new(0, 0, 0)
    self.frame.TextSize = 14

    Utility.ApplyCorner(self.frame, 4)

    self.title = Instance.new("TextLabel")
    self.title.Name = "togName"
    self.title.Parent = self.frame
    self.title.BackgroundTransparency = 1
    self.title.Position = UDim2.new(0.0967, 0, 0.2727, 0)
    self.title.Size = UDim2.new(0, 138, 0, 14)
    self.title.Font = Enum.Font.GothamSemibold
    self.title.Text = name
    self.title.RichText = true
    self.title.TextColor3 = theme:Get("TextColor")
    self.title.TextSize = 14
    self.title.TextXAlignment = Enum.TextXAlignment.Left

    self.valueLabel = Instance.new("TextLabel")
    self.valueLabel.Name = "val"
    self.valueLabel.Parent = self.frame
    self.valueLabel.BackgroundTransparency = 1
    self.valueLabel.Position = UDim2.new(0.3524, 0, 0.2727, 0)
    self.valueLabel.Size = UDim2.new(0, 41, 0, 14)
    self.valueLabel.Font = Enum.Font.GothamSemibold
    self.valueLabel.Text = tostring(minValue)
    self.valueLabel.TextColor3 = theme:Get("TextColor")
    self.valueLabel.TextSize = 14
    self.valueLabel.TextTransparency = 1
    self.valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    self.sliderBar = Instance.new("TextButton")
    self.sliderBar.Name = "sliderBtn"
    self.sliderBar.Parent = self.frame
    self.sliderBar.BackgroundColor3 = theme:Get("ElementColor") + Color3.fromRGB(5, 5, 5)
    self.sliderBar.BorderSizePixel = 0
    self.sliderBar.Position = UDim2.new(0.4887, 0, 0.3939, 0)
    self.sliderBar.Size = UDim2.new(0, 149, 0, 6)
    self.sliderBar.AutoButtonColor = false
    self.sliderBar.Text = ""
    self.sliderBar.ClipsDescendants = true

    self.sliderFill = Instance.new("Frame")
    self.sliderFill.Name = "sliderDrag"
    self.sliderFill.Parent = self.sliderBar
    self.sliderFill.BackgroundColor3 = theme:Get("SchemeColor")
    self.sliderFill.BorderSizePixel = 0
    self.sliderFill.Size = UDim2.new(0, 0, 1, 0)

    Utility.ApplyCorner(self.frame, 4)
    Utility.ApplyCorner(self.sliderBar, 4)

    self.icon = Instance.new("ImageLabel")
    self.icon.Name = "write"
    self.icon.Parent = self.frame
    self.icon.BackgroundTransparency = 1
    self.icon.Position = UDim2.new(0.02, 0, 0.18, 0)
    self.icon.Size = UDim2.new(0, 21, 0, 21)
    self.icon.Image = "rbxassetid://3926307971"
    self.icon.ImageColor3 = theme:Get("SchemeColor")
    self.icon.ImageRectOffset = Vector2.new(404, 164)
    self.icon.ImageRectSize = Vector2.new(36, 36)

    self.viewInfo = Instance.new("ImageButton")
    self.viewInfo.Name = "viewInfo"
    self.viewInfo.Parent = self.frame
    self.viewInfo.BackgroundTransparency = 1
    self.viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    self.viewInfo.Size = UDim2.new(0, 23, 0, 23)
    self.viewInfo.ZIndex = 2
    self.viewInfo.Image = "rbxassetid://3926305904"
    self.viewInfo.ImageRectOffset = Vector2.new(764, 764)
    self.viewInfo.ImageRectSize = Vector2.new(36, 36)
    self.viewInfo.ImageColor3 = theme:Get("SchemeColor")

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

    theme:Register(self.frame, "BackgroundColor3", "ElementColor")
    theme:Register(self.title, "TextColor3", "TextColor")
    theme:Register(self.valueLabel, "TextColor3", "TextColor")
    theme:Register(self.sliderBar, "BackgroundColor3", "ElementColor")
    theme:Register(self.sliderFill, "BackgroundColor3", "SchemeColor")
    theme:Register(self.icon, "ImageColor3", "SchemeColor")
    theme:Register(self.viewInfo, "ImageColor3", "SchemeColor")
    theme:Register(self.infoLabel, "TextColor3", "TextColor")

    local focus = false
    local viewActive = false
    local dragging = false
    local currentValue = minValue

    local function updateValue(x)
        local sliderX = math.clamp(x - self.sliderBar.AbsolutePosition.X, 0, self.sliderBar.AbsoluteSize.X)
        local ratio = sliderX / self.sliderBar.AbsoluteSize.X
        currentValue = math.floor((maxValue - minValue) * ratio + minValue)
        self.sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        self.valueLabel.Text = tostring(currentValue)
        callback(currentValue)
    end

    self.sliderBar.MouseButton1Down:Connect(function(input)
        if focus then
            return
        end
        dragging = true
        updateValue(input.Position.X)
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    self.frame.MouseEnter:Connect(function()
        if not focus then
            Utility.Tween(self.frame, {BackgroundColor3 = theme:Get("ElementColor") + Color3.fromRGB(8, 9, 10)}, 0.1)
        end
    end)

    self.frame.MouseLeave:Connect(function()
        if not focus then
            Utility.Tween(self.frame, {BackgroundColor3 = theme:Get("ElementColor")}, 0.1)
        end
    end)

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

    section.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.content.Size = UDim2.new(1, 0, 0, section.contentLayout.AbsoluteContentSize.Y)
        section.frame.Size = UDim2.new(0, 352, 0, section.contentLayout.AbsoluteContentSize.Y + 38)
    end)

    return self
end

return Slider
