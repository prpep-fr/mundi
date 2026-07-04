local GithubRequire = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/prpep-fr/mundi/main/GithubRequire.lua"
))()

local Utility = GithubRequire("Library/Core/Utility")

local Textbox = {}
Textbox.__index = Textbox

function Textbox.new(name, tip, callback, section)
    local self = setmetatable({}, Textbox)
    local theme = section.window.theme

    self.frame = Instance.new("TextButton")
    self.frame.Name = "textboxElement"
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

    self.label = Instance.new("TextLabel")
    self.label.Name = "togName"
    self.label.Parent = self.frame
    self.label.BackgroundTransparency = 1
    self.label.Position = UDim2.new(0.0967, 0, 0.2727, 0)
    self.label.Size = UDim2.new(0, 138, 0, 14)
    self.label.Font = Enum.Font.GothamSemibold
    self.label.Text = name
    self.label.RichText = true
    self.label.TextColor3 = theme:Get("TextColor")
    self.label.TextSize = 14
    self.label.TextXAlignment = Enum.TextXAlignment.Left

    self.textBox = Instance.new("TextBox")
    self.textBox.Parent = self.frame
    self.textBox.BackgroundColor3 = theme:Get("ElementColor")
    self.textBox.BorderSizePixel = 0
    self.textBox.ClipsDescendants = true
    self.textBox.Position = UDim2.new(0.4887, 0, 0.2121, 0)
    self.textBox.Size = UDim2.new(0, 150, 0, 18)
    self.textBox.ZIndex = 99
    self.textBox.ClearTextOnFocus = false
    self.textBox.Font = Enum.Font.Gotham
    self.textBox.PlaceholderColor3 = theme:Get("SchemeColor")
    self.textBox.PlaceholderText = "Type here!"
    self.textBox.Text = ""
    self.textBox.TextColor3 = theme:Get("SchemeColor")
    self.textBox.TextSize = 12

    Utility.ApplyCorner(self.textBox, 4)

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
    theme:Register(self.label, "TextColor3", "TextColor")
    theme:Register(self.textBox, "BackgroundColor3", "ElementColor")
    theme:Register(self.textBox, "PlaceholderColor3", "SchemeColor")
    theme:Register(self.textBox, "TextColor3", "SchemeColor")
    theme:Register(self.viewInfo, "ImageColor3", "SchemeColor")
    theme:Register(self.infoLabel, "TextColor3", "TextColor")

    local focus = false
    local viewActive = false

    self.textBox.FocusLost:Connect(function(enter)
        if enter then
            callback(self.textBox.Text)
            self.textBox.Text = ""
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

return Textbox
