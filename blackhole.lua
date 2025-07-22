-- 📌 Автор: @gde_patrick — Area 51 Auto RayGun + Kill All Script

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 🔧 Настройки
local enabled = false
local targetGunName = "RayGun"
local gunSpotName = "RayGunGiver" -- изменяй, если другое имя
local killRange = 999
local enlargeSize = Vector3.new(10, 10, 10)
local killDelay = 5

-- 📦 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Area51ScriptGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0, 100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "☢️ Area 51 KILL GUI"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 40)
toggle.Position = UDim2.new(0.05, 0, 0, 40)
toggle.Text = "✅ ВКЛ: Автокилл"
toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 18

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 16

close.MouseButton1Click:Connect(function()
	gui:Destroy()
	enabled = false
end)

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "✅ ВКЛ: Автокилл" or "⛔️ ВЫКЛ: Автокилл"
	toggle.BackgroundColor3 = enabled and Color3.fromRGB(70,130,70) or Color3.fromRGB(130,70,70)
end)

-- 🔫 Получение RayGun
local function findRayGunSpot()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:lower():find("ray") then
			return obj
		end
	end
end

local function simulateEPress()
	local key = Enum.KeyCode.E
	UIS.InputBegan:Fire({KeyCode = key}, false)
	wait(0.1)
	UIS.InputEnded:Fire({KeyCode = key}, false)
end

local function equipRayGun()
	for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == targetGunName then
			LocalPlayer.Character.Humanoid:EquipTool(tool)
		end
	end
end

-- ☠️ Килл мобов
local function enlargeEnemies()
	for _, enemy in pairs(workspace:GetDescendants()) do
		if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
			local root = enemy.HumanoidRootPart
			root.Size = enlargeSize
			root.Transparency = 0.5
			root.CanCollide = false
			root.Material = Enum.Material.ForceField
		end
	end
end

local function killAllEnemies()
	local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if not tool or not tool:FindFirstChild("Handle") then return end

	for _, enemy in pairs(workspace:GetDescendants()) do
		if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
			local root = enemy.HumanoidRootPart
			if (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= killRange then
				tool:Activate()
				wait(0.1)
			end
		end
	end
end

-- 🔁 Главный цикл
coroutine.wrap(function()
	while true do
		wait(1)
		if enabled then
			local raySpot = findRayGunSpot()
			if raySpot then
				-- Телепорт к RayGun
				LocalPlayer.Character.HumanoidRootPart.CFrame = raySpot.CFrame + Vector3.new(0,2,0)
				wait(0.3)
				simulateEPress() -- Взять
				wait(0.3)
				equipRayGun() -- Надеть
				wait(0.3)
				simulateEPress() -- Перезарядка
			end
			enlargeEnemies()
			killAllEnemies()
			wait(killDelay)
		end
	end
end)()

-- ♻️ Возрождение
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	equipRayGun()
end)
