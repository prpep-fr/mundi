local Label = {}
Label.__index = Label

function Label.new(text, section)
    local self = setmetatable({}, Label)
    local theme = section.window.theme

    self.label = Instance.new("TextLabel")
    self.label.Name = "label"
    self.label.Parent = section.content
    self.label.BackgroundColor3 = theme:Get("SchemeColor")
    self.label.BorderSizePixel = 0
    self.label.ClipsDescendants = true
    self.label.Size = UDim2.new(0, 352, 0, 33)
    self.label.Font = Enum.Font.Gotham
    self.label.Text = "  " .. text
    self.label.RichText = true
    self.label.TextColor3 = theme:Get("TextColor")
    self.label.TextSize = 14
    self.label.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.label

    theme:Register(self.label, "BackgroundColor3", "SchemeColor")
    theme:Register(self.label, "TextColor3", "TextColor")

    section.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.content.Size = UDim2.new(1, 0, 0, section.contentLayout.AbsoluteContentSize.Y)
        section.frame.Size = UDim2.new(0, 352, 0, section.contentLayout.AbsoluteContentSize.Y + 38)
    end)

    function self:UpdateLabel(newText)
        self.label.Text = "  " .. newText
    end

    return self
end

return Label