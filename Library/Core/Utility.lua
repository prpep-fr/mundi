local Utility = {}
local TweenService = game:GetService("TweenService")

function Utility.Tween(instance, properties, duration, easingStyle, easingDirection)
    local info = TweenInfo.new(duration or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    TweenService:Create(instance, info, properties):Play()
end

function Utility.ApplyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    corner.Parent = instance
    return corner
end

function Utility.SetVisibleChildren(frame, visible)
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("GuiObject") then
            child.Visible = visible
        end
    end
end

function Utility.SafeConnect(signal, callback)
    return signal:Connect(callback)
end

return Utility