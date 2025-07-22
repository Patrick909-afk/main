-- 📌 Автор: @gde_patrick

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local rayGunName = "RayGun"
local hitboxSize = Vector3.new(1000, 1000, 1000)
local hitboxToggle = false

-- 🧠 Враги (настрой вручную, если игра другая)
local function getEnemies()
    local enemies = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            table.insert(enemies, obj)
        end
    end
    return enemies
end

-- 📦 Взять RayGun
local function pickupRayGun()
    local rg = Workspace:FindFirstChild(rayGunName)
    if rg and rg:IsA("Tool") then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = rg.CFrame + Vector3.new(0, 3, 0)
            fireproximityprompt(rg:FindFirstChildOfClass("ProximityPrompt"), 1)
            wait(1)
            local backpack = LocalPlayer:WaitForChild("Backpack")
            local tool = backpack:FindFirstChild(rayGunName)
            if tool then
                tool.Parent = LocalPlayer.Character
            end
        end
    end
end

-- 🌀 Хитбоксы вкл/выкл
local function toggleHitboxes()
    hitboxToggle = not hitboxToggle
    for _, enemy in ipairs(getEnemies()) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if root then
            if hitboxToggle then
                root.Size = hitboxSize
                root.Transparency = 0.6
                root.Material = Enum.Material.Neon
                root.CanCollide = false
            else
                root.Size = Vector3.new(2, 2, 1)
                root.Transparency = 0
                root.Material = Enum.Material.Plastic
                root.CanCollide = true
            end
        end
    end
end

-- ♻️ Возврат хитбоксов после возрождения мобов
RunService.Heartbeat:Connect(function()
    if hitboxToggle then
        for _, enemy in ipairs(getEnemies()) do
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if root and root.Size.Magnitude < 100 then
                root.Size = hitboxSize
                root.Transparency = 0.6
                root.Material = Enum.Material.Neon
                root.CanCollide = false
            end
        end
    end
end)

-- 💡 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PatrickMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 100, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(1, -20, 0, 40)
tpButton.Position = UDim2.new(0, 10, 0, 10)
tpButton.Text = "📦 Телепорт к RayGun"
tpButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextSize = 18
Instance.new("UICorner", tpButton)

local hitboxButton = Instance.new("TextButton", frame)
hitboxButton.Size = UDim2.new(1, -20, 0, 40)
hitboxButton.Position = UDim2.new(0, 10, 0, 60)
hitboxButton.Text = "🎯 Хитбоксы: OFF"
hitboxButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
hitboxButton.TextColor3 = Color3.new(1, 1, 1)
hitboxButton.Font = Enum.Font.SourceSansBold
hitboxButton.TextSize = 18
Instance.new("UICorner", hitboxButton)

tpButton.MouseButton1Click:Connect(function()
    pickupRayGun()
end)

hitboxButton.MouseButton1Click:Connect(function()
    toggleHitboxes()
    hitboxButton.Text = hitboxToggle and "🎯 Хитбоксы: ON" or "🎯 Хитбоксы: OFF"
end)

-- 🔁 Перезапуск после смерти
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    pickupRayGun()
end)
