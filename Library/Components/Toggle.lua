local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(name, tip, callback, section)
    local self = setmetatable({}, Toggle)
    local theme = section.window.theme
    self.state = false

    self.frame = Instance.new("TextButton")
    self.frame.Name = "toggleElement"
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

    self.iconOff = Instance.new("ImageLabel")
    self.iconOff.Name = "toggleDisabled"
    self.iconOff.Parent = self.frame
    self.iconOff.BackgroundTransparency = 1
    self.iconOff.Position = UDim2.new(0.02, 0, 0.18, 0)
    self.iconOff.Size = UDim2.new(0, 21, 0, 21)
    self.iconOff.Image = "rbxassetid://3926309567"
    self.iconOff.ImageColor3 = theme:Get("SchemeColor")
    self.iconOff.ImageRectOffset = Vector2.new(628, 420)
    self.iconOff.ImageRectSize = Vector2.new(48, 48)

    self.iconOn = Instance.new("ImageLabel")
    self.iconOn.Name = "toggleEnabled"
    self.iconOn.Parent = self.frame
    self.iconOn.BackgroundTransparency = 1
    self.iconOn.Position = UDim2.new(0.02, 0, 0.18, 0)
    self.iconOn.Size = UDim2.new(0, 21, 0, 21)
    self.iconOn.Image = "rbxassetid://3926309567"
    self.iconOn.ImageColor3 = theme:Get("SchemeColor")
    self.iconOn.ImageRectOffset = Vector2.new(784, 420)
    self.iconOn.ImageRectSize = Vector2.new(48, 48)
    self.iconOn.ImageTransparency = 1

    self.title = Instance.new("TextLabel")
    self.title.Name = "togName"
    self.title.Parent = self.frame
    self.title.BackgroundTransparency = 1
    self.title.Position = UDim2.new(0.0967, 0, 0.2727, 0)
    self.title.Size = UDim2.new(0, 288, 0, 14)
    self.title.Font = Enum.Font.GothamSemibold
    self.title.Text = name
    self.title.RichText = true
    self.title.TextColor3 = theme:Get("TextColor")
    self.title.TextSize = 14
    self.title.TextXAlignment = Enum.TextXAlignment.Left

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
    theme:Register(self.iconOff, "ImageColor3", "SchemeColor")
    theme:Register(self.iconOn, "ImageColor3", "SchemeColor")
    theme:Register(self.viewInfo, "ImageColor3", "SchemeColor")
    theme:Register(self.infoLabel, "TextColor3", "TextColor")

    local focus = false
    local viewActive = false

    local function setState(enabled)
        self.state = enabled
        self.iconOn.ImageTransparency = enabled and 0 or 1
        callback(enabled)
    end

    self.frame.MouseButton1Click:Connect(function()
        if focus then
            return
        end
        setState(not self.state)
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

    function self:UpdateToggle(newText, isOn)
        self.title.Text = newText or self.title.Text
        setState(isOn == true)
    end

    return self
end

return Toggle
