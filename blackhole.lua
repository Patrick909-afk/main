-- 📌 Автор: @gde_patrick

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- ⚙️ Настройки
local pulling = true
local pullDistance = 15
local rotateSpeed = 5
local lagEnabled = false

-- 🖼 GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "BlackholeGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 190)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "🌀 Blackhole GUI by @gde_patrick"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0, 10, 0, 35)
toggle.Size = UDim2.new(0, 200, 0, 30)
toggle.Text = "✅ ВКЛ: Притяжение"
toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 18

local distanceLabel = Instance.new("TextLabel", frame)
distanceLabel.Position = UDim2.new(0, 10, 0, 70)
distanceLabel.Size = UDim2.new(0, 200, 0, 20)
distanceLabel.Text = "Дистанция: " .. tostring(pullDistance)
distanceLabel.TextColor3 = Color3.new(1, 1, 1)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Font = Enum.Font.SourceSans
distanceLabel.TextSize = 16

local increase = Instance.new("TextButton", frame)
increase.Position = UDim2.new(0, 10, 0, 95)
increase.Size = UDim2.new(0, 95, 0, 25)
increase.Text = "⬆️ Увеличить"
increase.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
increase.TextColor3 = Color3.new(1, 1, 1)
increase.Font = Enum.Font.SourceSans
increase.TextSize = 16

local decrease = Instance.new("TextButton", frame)
decrease.Position = UDim2.new(0, 115, 0, 95)
decrease.Size = UDim2.new(0, 95, 0, 25)
decrease.Text = "⬇️ Уменьшить"
decrease.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
decrease.TextColor3 = Color3.new(1, 1, 1)
decrease.Font = Enum.Font.SourceSans
decrease.TextSize = 16

local lagButton = Instance.new("TextButton", frame)
lagButton.Position = UDim2.new(0, 10, 0, 125)
lagButton.Size = UDim2.new(0, 200, 0, 25)
lagButton.Text = "🚨 ВКЛ: Лаг-машина"
lagButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
lagButton.TextColor3 = Color3.new(1, 1, 1)
lagButton.Font = Enum.Font.SourceSansBold
lagButton.TextSize = 16

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 18

-- 🔘 GUI кнопки
toggle.MouseButton1Click:Connect(function()
    pulling = not pulling
    toggle.Text = pulling and "✅ ВКЛ: Притяжение" or "⛔️ ВЫКЛ: Притяжение"
end)

increase.MouseButton1Click:Connect(function()
    pullDistance = pullDistance + 5
    distanceLabel.Text = "Дистанция: " .. tostring(pullDistance)
end)

decrease.MouseButton1Click:Connect(function()
    pullDistance = math.max(5, pullDistance - 5)
    distanceLabel.Text = "Дистанция: " .. tostring(pullDistance)
end)

lagButton.MouseButton1Click:Connect(function()
    lagEnabled = not lagEnabled
    lagButton.Text = lagEnabled and "💣 ВЫКЛ: Лаг-машина" or "🚨 ВКЛ: Лаг-машина"
    lagButton.BackgroundColor3 = lagEnabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(120, 0, 0)
end)

close.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    pulling = false
    lagEnabled = false
end)

-- 🧲 Притягивание + Вращение
local function attractPlayers()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local angle = tick() * rotateSpeed
            local offset = Vector3.new(
                math.cos(angle) * pullDistance,
                0,
                math.sin(angle) * pullDistance
            )
            targetHRP.CFrame = CFrame.new(hrp.Position + offset)
        end
    end
end

-- 💣 Лаг-машина
local function lagLoop()
    -- Спам Remote'ами
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            pcall(function()
                for _ = 1, 5 do
                    v:FireServer("🧨")
                end
            end)
        end
    end

    -- Спам звуками
    for i = 1, 5 do
        local sound = Instance.new("Sound", SoundService)
        sound.SoundId = "rbxassetid://9118823104" -- громкий звук
        sound.Volume = 10
        sound:Play()
        game.Debris:AddItem(sound, 2)
    end
end

-- 🔁 Цикл
RunService.Heartbeat:Connect(function()
    if pulling then
        pcall(attractPlayers)
    end
    if lagEnabled then
        pcall(lagLoop)
    end
end)

-- ♻️ После респавна
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    pulling = true
end)
