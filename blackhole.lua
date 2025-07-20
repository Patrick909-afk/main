-- Blackhole GUI by @gde_patrick

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BlackholeGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 130)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Blackhole by @gde_patrick"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Toggle = Instance.new("TextButton", Frame)
Toggle.Text = "🔴 ВЫКЛ"
Toggle.Size = UDim2.new(1, -20, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0, 35)
Toggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.Gotham
Toggle.TextSize = 14

local DistanceLabel = Instance.new("TextLabel", Frame)
DistanceLabel.Text = "Радиус: 50"
DistanceLabel.Size = UDim2.new(1, -20, 0, 20)
DistanceLabel.Position = UDim2.new(0, 10, 0, 70)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.TextColor3 = Color3.new(1, 1, 1)
DistanceLabel.Font = Enum.Font.Gotham
DistanceLabel.TextSize = 14

local Slider = Instance.new("TextButton", Frame)
Slider.Size = UDim2.new(1, -20, 0, 25)
Slider.Position = UDim2.new(0, 10, 0, 95)
Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Slider.Text = "Изменить радиус"
Slider.TextColor3 = Color3.new(1, 1, 1)
Slider.Font = Enum.Font.Gotham
Slider.TextSize = 12

-- Blackhole Logic
local enabled = false
local radius = 50

Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    Toggle.Text = enabled and "🟢 ВКЛ" or "🔴 ВЫКЛ"
    Toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 0, 0)
end)

Slider.MouseButton1Click:Connect(function()
    radius = radius + 25
    if radius > 200 then radius = 25 end
    DistanceLabel.Text = "Радиус: " .. radius
end)

-- Притягивание
RunService.Heartbeat:Connect(function()
    if not enabled then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and (obj.Position - HRP.Position).Magnitude < radius then
            local direction = (HRP.Position - obj.Position).Unit
            obj.Velocity = direction * 50
        end
    end
end)
