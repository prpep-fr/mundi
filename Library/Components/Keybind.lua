local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")
local UserInputService = game:GetService("UserInputService")

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(name, tip, defaultKey, callback, section)
    local self = setmetatable({}, Keybind)
    local theme = section.window.theme
    defaultKey = defaultKey or Enum.KeyCode.Unknown
    self.currentKey = typeof(defaultKey) == "EnumItem" and defaultKey.Name or tostring(defaultKey)

    self.frame = Instance.new("TextButton")
    self.frame.Name = "keybindElement"
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
    self.title.Size = UDim2.new(0, 222, 0, 14)
    self.title.Font = Enum.Font.GothamSemibold
    self.title.Text = name
    self.title.RichText = true
    self.title.TextColor3 = theme:Get("TextColor")
    self.title.TextSize = 14
    self.title.TextXAlignment = Enum.TextXAlignment.Left

    self.keyLabel = Instance.new("TextLabel")
    self.keyLabel.Name = "togName2"
    self.keyLabel.Parent = self.frame
    self.keyLabel.BackgroundTransparency = 1
    self.keyLabel.Position = UDim2.new(0.7274, 0, 0.2727, 0)
    self.keyLabel.Size = UDim2.new(0, 70, 0, 14)
    self.keyLabel.Font = Enum.Font.GothamSemibold
    self.keyLabel.Text = self.currentKey
    self.keyLabel.TextColor3 = theme:Get("SchemeColor")
    self.keyLabel.TextSize = 14
    self.keyLabel.TextXAlignment = Enum.TextXAlignment.Right

    self.touchIcon = Instance.new("ImageLabel")
    self.touchIcon.Name = "touch"
    self.touchIcon.Parent = self.frame
    self.touchIcon.BackgroundTransparency = 1
    self.touchIcon.Position = UDim2.new(0.02, 0, 0.18, 0)
    self.touchIcon.Size = UDim2.new(0, 21, 0, 21)
    self.touchIcon.Image = "rbxassetid://3926305904"
    self.touchIcon.ImageColor3 = theme:Get("SchemeColor")
    self.touchIcon.ImageRectOffset = Vector2.new(364, 284)
    self.touchIcon.ImageRectSize = Vector2.new(36, 36)

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
    theme:Register(self.keyLabel, "TextColor3", "SchemeColor")
    theme:Register(self.touchIcon, "ImageColor3", "SchemeColor")
    theme:Register(self.viewInfo, "ImageColor3", "SchemeColor")
    theme:Register(self.infoLabel, "TextColor3", "TextColor")

    local listenConnection
    local focus = false
    local viewActive = false

    self.frame.MouseButton1Click:Connect(function()
        if focus then
            return
        end
        self.keyLabel.Text = ". . ."
        focus = true
        listenConnection = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local code = input.KeyCode.Name
                if code ~= "Unknown" then
                    self.currentKey = code
                    self.keyLabel.Text = code
                end
                if listenConnection then
                    listenConnection:Disconnect()
                    listenConnection = nil
                end
                focus = false
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == self.currentKey then
            callback()
        end
    end)

    self.frame.MouseEnter:Connect(function()
        if not viewActive then
            Utility.Tween(self.frame, {BackgroundColor3 = theme:Get("ElementColor") + Color3.fromRGB(8, 9, 10)}, 0.1)
        end
    end)

    self.frame.MouseLeave:Connect(function()
        if not viewActive then
            Utility.Tween(self.frame, {BackgroundColor3 = theme:Get("ElementColor")}, 0.1)
        end
    end)

    self.viewInfo.MouseButton1Click:Connect(function()
        if viewActive then
            return
        end
        viewActive = true
        Utility.Tween(self.infoLabel, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.delay(1.5, function()
            viewActive = false
            Utility.Tween(self.infoLabel, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
        end)
    end)

    section.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.content.Size = UDim2.new(1, 0, 0, section.contentLayout.AbsoluteContentSize.Y)
        section.frame.Size = UDim2.new(0, 352, 0, section.contentLayout.AbsoluteContentSize.Y + 38)
    end)

    return self
end

return Keybind
