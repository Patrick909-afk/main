-- 📌 Blackhole GUI by @gde_patrick

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local enabled = false
local radius = 15
local rotatingSpeed = 2

-- 👁 GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BlackholeGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🌀 Blackhole Menu"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0, 200, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0, 40)
Toggle.Text = "▶️ ВКЛЮЧИТЬ"
Toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.Gotham
Toggle.TextSize = 14
Instance.new("UICorner", Toggle)

local DistanceLabel = Instance.new("TextLabel", Frame)
DistanceLabel.Position = UDim2.new(0, 10, 0, 80)
DistanceLabel.Size = UDim2.new(0, 200, 0, 20)
DistanceLabel.Text = "📏 Дистанция: " .. radius
DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceLabel.Font = Enum.Font.Gotham
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.TextSize = 13

local DistanceSlider = Instance.new("TextButton", Frame)
DistanceSlider.Position = UDim2.new(0, 10, 0, 105)
DistanceSlider.Size = UDim2.new(0, 200, 0, 20)
DistanceSlider.Text = "🔁 Увеличить (Click)"
DistanceSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DistanceSlider.Font = Enum.Font.Gotham
DistanceSlider.TextSize = 13
Instance.new("UICorner", DistanceSlider)

local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 5)
Close.Text = "✖"
Close.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Instance.new("UICorner", Close)

-- 🧠 Логика притяжения
local function attractAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local targetHRP = plr.Character.HumanoidRootPart
            for _, f in pairs(targetHRP:GetChildren()) do
                if f:IsA("BodyPosition") and f.Name == "BlackholePos" then f:Destroy() end
                if f:IsA("BodyGyro") and f.Name == "BlackholeGyro" then f:Destroy() end
            end

            local angle = tick() * rotatingSpeed + (plr.UserId % 360)
            local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
            local destination = LocalPlayer.Character.HumanoidRootPart.Position + offset

            local bodyPos = Instance.new("BodyPosition")
            bodyPos.Name = "BlackholePos"
            bodyPos.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bodyPos.Position = destination
            bodyPos.P = 3000
            bodyPos.D = 400
            bodyPos.Parent = targetHRP

            local gyro = Instance.new("BodyGyro")
            gyro.Name = "BlackholeGyro"
            gyro.MaxTorque = Vector3.new(0, 1e6, 0)
            gyro.P = 3000
            gyro.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, destination)
            gyro.Parent = targetHRP
        end
    end
end

-- 🔄 Главный цикл
RunService.Heartbeat:Connect(function()
    if enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(attractAllPlayers)
    end
end)

-- 💡 Кнопки
Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    Toggle.Text = enabled and "⛔ ОТКЛЮЧИТЬ" or "▶️ ВКЛЮЧИТЬ"
    Toggle.BackgroundColor3 = enabled and Color3.fromRGB(220, 60, 60) or Color3.fromRGB(70, 130, 180)
end)

DistanceSlider.MouseButton1Click:Connect(function()
    radius = radius + 5
    if radius > 50 then radius = 5 end
    DistanceLabel.Text = "📏 Дистанция: " .. radius
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
