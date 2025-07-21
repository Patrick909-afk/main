-- 📌 Ultimate Lag Machine by @gde_patrick

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local pulling, rotating = true, true
local pullDistance = 15

-- 🖼 GUI setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "UltimateLagGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 230, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- 🔘 GUI кнопки
createButton("🌀 Притягивать игроков", 10, function() pulling = not pulling end)

createButton("📡 Remote-спам", 45, function()
    for i = 1, 100 do
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") then pcall(function() v:FireServer("LAG") end) end
            if v:IsA("RemoteFunction") then pcall(function() v:InvokeServer("LAG") end) end
        end
    end
end)

createButton("💣 Спавн объектов", 80, function()
    for i = 1, 150 do
        local p = Instance.new("Part", workspace)
        p.Anchored = false
        p.Size = Vector3.new(5,5,5)
        p.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-30,30), 10, math.random(-30,30))
    end
end)

createButton("⚔️ Бесконечная атака", 115, function()
    local char = LocalPlayer.Character
    if char then
        for _, tool in pairs(char:GetDescendants()) do
            if tool:IsA("Tool") then
                tool.Grip = CFrame.new()
                tool.Activated:Connect(function() tool:Activate() end)
            end
        end
    end
end)

createButton("🔄 Вращение игроков", 150, function() rotating = not rotating end)

createButton("🔊 Звуковой спам", 185, function()
    for i = 1, 30 do
        local sound = Instance.new("Sound", SoundService)
        sound.SoundId = "rbxassetid://9118823105" -- громкий звук
        sound.Volume = 10
        sound:Play()
        game.Debris:AddItem(sound, 3)
    end
end)

createButton("💥 Оттолкнуть всех", 220, function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity", plr.Character.HumanoidRootPart)
            bv.Velocity = Vector3.new(math.random(-150,150), math.random(50,150), math.random(-150,150))
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            game.Debris:AddItem(bv, 1)
        end
    end
end)

createButton("💀 Удалить все объекты", 255, function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if not obj:IsDescendantOf(LocalPlayer.Character) then
            pcall(function() obj:Destroy() end)
        end
    end
end)

-- ❌ Закрыть
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 18
close.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    pulling = false
    rotating = false
end)

-- 🔁 Логика притягивания и вращения
RunService.Heartbeat:Connect(function()
    if pulling then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local angle = tick() * 3
                    local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * pullDistance
                    hrp.CFrame = CFrame.new(root.Position + offset)
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if rotating then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    pulling = true
    rotating = true
end)
