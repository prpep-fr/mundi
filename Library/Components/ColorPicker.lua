local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")
local UserInputService = game:GetService("UserInputService")

local ColorPicker = {}
ColorPicker.__index = ColorPicker

local function clamp(value, minVal, maxVal)
    return math.clamp(value, minVal, maxVal)
end

function ColorPicker.new(name, tip, defaultColor, callback, section)
    local self = setmetatable({}, ColorPicker)
    local theme = section.window.theme
    local h, s, v = Color3.toHSV(defaultColor)
    self.color = {h, s, v}
    self.open = false

    self.frame = Instance.new("TextButton")
    self.frame.Name = "colorElement"
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

    self.header = Instance.new("Frame")
    self.header.Name = "colorHeader"
    self.header.Parent = self.frame
    self.header.BackgroundColor3 = theme:Get("ElementColor")
    self.header.Size = UDim2.new(1, 0, 0, 33)
    self.header.ClipsDescendants = true
    Utility.ApplyCorner(self.header, 4)

    self.label = Instance.new("TextLabel")
    self.label.Name = "togName"
    self.label.Parent = self.header
    self.label.BackgroundTransparency = 1
    self.label.Position = UDim2.new(0.0967, 0, 0.2727, 0)
    self.label.Size = UDim2.new(0, 288, 0, 14)
    self.label.Font = Enum.Font.GothamSemibold
    self.label.Text = name
    self.label.RichText = true
    self.label.TextColor3 = theme:Get("TextColor")
    self.label.TextSize = 14
    self.label.TextXAlignment = Enum.TextXAlignment.Left

    self.colorPreview = Instance.new("Frame")
    self.colorPreview.Name = "colorCurrent"
    self.colorPreview.Parent = self.header
    self.colorPreview.BackgroundColor3 = defaultColor
    self.colorPreview.Position = UDim2.new(0.7926, 0, 0.2121, 0)
    self.colorPreview.Size = UDim2.new(0, 42, 0, 18)
    Utility.ApplyCorner(self.colorPreview, 4)

    self.touchIcon = Instance.new("ImageLabel")
    self.touchIcon.Name = "touch"
    self.touchIcon.Parent = self.header
    self.touchIcon.BackgroundTransparency = 1
    self.touchIcon.Position = UDim2.new(0.02, 0, 0.18, 0)
    self.touchIcon.Size = UDim2.new(0, 21, 0, 21)
    self.touchIcon.Image = "rbxassetid://3926305904"
    self.touchIcon.ImageColor3 = theme:Get("SchemeColor")
    self.touchIcon.ImageRectOffset = Vector2.new(44, 964)
    self.touchIcon.ImageRectSize = Vector2.new(36, 36)

    self.viewInfo = Instance.new("ImageButton")
    self.viewInfo.Name = "viewInfo"
    self.viewInfo.Parent = self.header
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

    self.innerFrame = Instance.new("Frame")
    self.innerFrame.Name = "colorInners"
    self.innerFrame.Parent = self.frame
    self.innerFrame.BackgroundColor3 = theme:Get("ElementColor")
    self.innerFrame.Position = UDim2.new(0, 0, 0.2553, 0)
    self.innerFrame.Size = UDim2.new(1, 0, 0, 105)
    self.innerFrame.Visible = false
    Utility.ApplyCorner(self.innerFrame, 4)

    self.colorBoard = Instance.new("ImageButton")
    self.colorBoard.Name = "rgb"
    self.colorBoard.Parent = self.innerFrame
    self.colorBoard.BackgroundTransparency = 1
    self.colorBoard.Position = UDim2.new(0.0199, 0, 0.0476, 0)
    self.colorBoard.Size = UDim2.new(0, 211, 0, 93)
    self.colorBoard.Image = "http://www.roblox.com/asset/?id=6523286724"

    self.colorCursor = Instance.new("ImageLabel")
    self.colorCursor.Name = "rbgcircle"
    self.colorCursor.Parent = self.colorBoard
    self.colorCursor.BackgroundTransparency = 1
    self.colorCursor.Size = UDim2.new(0, 14, 0, 14)
    self.colorCursor.Image = "rbxassetid://3926309567"
    self.colorCursor.ImageColor3 = Color3.new(0, 0, 0)
    self.colorCursor.ImageRectOffset = Vector2.new(628, 420)
    self.colorCursor.ImageRectSize = Vector2.new(48, 48)

    self.darkness = Instance.new("ImageButton")
    self.darkness.Name = "darkness"
    self.darkness.Parent = self.innerFrame
    self.darkness.BackgroundTransparency = 1
    self.darkness.Position = UDim2.new(0.6364, 0, 0.0476, 0)
    self.darkness.Size = UDim2.new(0, 18, 0, 93)
    self.darkness.Image = "http://www.roblox.com/asset/?id=6523291212"

    self.darkCursor = Instance.new("ImageLabel")
    self.darkCursor.Name = "darkcircle"
    self.darkCursor.Parent = self.darkness
    self.darkCursor.AnchorPoint = Vector2.new(0.5, 0)
    self.darkCursor.BackgroundTransparency = 1
    self.darkCursor.Size = UDim2.new(0, 14, 0, 14)
    self.darkCursor.Image = "rbxassetid://3926309567"
    self.darkCursor.ImageColor3 = Color3.new(0, 0, 0)
    self.darkCursor.ImageRectOffset = Vector2.new(628, 420)
    self.darkCursor.ImageRectSize = Vector2.new(48, 48)

    self.rainbowToggle = Instance.new("TextButton")
    self.rainbowToggle.Name = "onrainbow"
    self.rainbowToggle.Parent = self.innerFrame
    self.rainbowToggle.BackgroundTransparency = 1
    self.rainbowToggle.Position = UDim2.new(0, 0, 0.0657, 0)
    self.rainbowToggle.Size = UDim2.new(0, 21, 0, 21)
    self.rainbowToggle.Text = ""

    self.rainbowState = false
    self.rainbowConnection = nil

    theme:Register(self.frame, "BackgroundColor3", "ElementColor")
    theme:Register(self.header, "BackgroundColor3", "ElementColor")
    theme:Register(self.label, "TextColor3", "TextColor")
    theme:Register(self.touchIcon, "ImageColor3", "SchemeColor")
    theme:Register(self.viewInfo, "ImageColor3", "SchemeColor")
    theme:Register(self.innerFrame, "BackgroundColor3", "ElementColor")
    theme:Register(self.infoLabel, "TextColor3", "TextColor")

    local focus = false
    local viewActive = false
    local draggingColor = false
    local draggingDark = false

    local function updateColorFromPosition(x, y)
        local localX = clamp(x - self.colorBoard.AbsolutePosition.X, 0, self.colorBoard.AbsoluteSize.X)
        local localY = clamp(y - self.colorBoard.AbsolutePosition.Y, 0, self.colorBoard.AbsoluteSize.Y)
        local ratioX = localX / self.colorBoard.AbsoluteSize.X
        local ratioY = localY / self.colorBoard.AbsoluteSize.Y
        self.color = {ratioX, 1 - ratioY, self.color[3]}
        self.colorCursor.Position = UDim2.new(ratioX, -7, 1 - ratioY, -7)
        local colorValue = Color3.fromHSV(self.color[1], self.color[2], self.color[3])
        self.colorPreview.BackgroundColor3 = colorValue
        callback(colorValue)
    end

    local function updateDarkness(y)
        local localY = clamp(y - self.darkness.AbsolutePosition.Y, 0, self.darkness.AbsoluteSize.Y)
        local ratio = localY / self.darkness.AbsoluteSize.Y
        self.color[3] = 1 - ratio
        self.darkCursor.Position = UDim2.new(0.5, 0, ratio, -7)
        local colorValue = Color3.fromHSV(self.color[1], self.color[2], self.color[3])
        self.colorPreview.BackgroundColor3 = colorValue
        callback(colorValue)
    end

    local function setRainbow(enabled)
        self.rainbowState = enabled
        if self.rainbowConnection then
            self.rainbowConnection:Disconnect()
            self.rainbowConnection = nil
        end
        if enabled then
            self.rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
                self.color[1] = (self.color[1] + dt * 0.1) % 1
                local colorValue = Color3.fromHSV(self.color[1], self.color[2], self.color[3])
                self.colorPreview.BackgroundColor3 = colorValue
                callback(colorValue)
            end)
        end
    end

    self.frame.MouseButton1Click:Connect(function()
        if focus then
            return
        end
        self.open = not self.open
        self.innerFrame.Visible = self.open
        self.frame.Size = UDim2.new(0, 352, 0, self.open and 141 or 33)
        section.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize")
        section.content.Size = UDim2.new(1, 0, 0, section.contentLayout.AbsoluteContentSize.Y)
        section.frame.Size = UDim2.new(0, 352, 0, section.contentLayout.AbsoluteContentSize.Y + 38)
    end)

    self.colorBoard.MouseButton1Down:Connect(function(input)
        draggingColor = true
        updateColorFromPosition(input.Position.X, input.Position.Y)
    end)

    self.darkness.MouseButton1Down:Connect(function(input)
        draggingDark = true
        updateDarkness(input.Position.Y)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingColor and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateColorFromPosition(input.Position.X, input.Position.Y)
        elseif draggingDark and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDarkness(input.Position.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingColor = false
            draggingDark = false
        end
    end)

    self.rainbowToggle.MouseButton1Click:Connect(function()
        setRainbow(not self.rainbowState)
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

return ColorPicker
