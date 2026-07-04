local Animation = {}
Animation.__index = Animation

function Animation.TweenObject(instance, properties, duration)
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(instance, tweenInfo, properties):Play()
end

return Animation