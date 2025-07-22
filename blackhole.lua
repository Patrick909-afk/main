-- 📦 Area 51 Script by @gde_patrick

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")
local enemies = {}  -- список врагов
local hitboxesEnabled = false
local toolTaken = false

-- ⚙️ Настройки
local HITBOX_SIZE = Vector3.new(100, 100, 100)
local RAYGUN_NAME = "RayGun"
local RAYGUN_PART_NAME = "RayGun" -- Название части, возле которой надо нажать E

-- 🧱 GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "Area51Menu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 140)
frame.Position = UDim2.new(0.5, -150, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function makeButton(text, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.TextScaled = true
	btn.Font = Enum.Font.SourceSans
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local teleportButton = makeButton("🚀 Телепорт к RayGun", 15)
local hitboxButton = makeButton("🧠 Хитбоксы: OFF", 60)
local closeButton = makeButton("❌ Закрыть", 105)
closeButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)

-- 🔘 Функции
local function teleportToRayGun()
	for _, part in pairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and part.Name == RAYGUN_PART_NAME then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(1, 1, 0)
				wait(0.3)
				-- Нажатие клавиши E
				keypress(Enum.KeyCode.E)
				wait(0.1)
				keyrelease(Enum.KeyCode.E)
			end
			break
		end
	end
end

-- 📦 Увеличение хитбоксов врагов
local function updateEnemies()
	enemies = {}
	for _, npc in pairs(workspace:GetDescendants()) do
		if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then
			table.insert(enemies, npc)
		end
	end
end

local function setHitboxes(state)
	for _, npc in pairs(enemies) do
		local root = npc:FindFirstChild("HumanoidRootPart")
		if root then
			if state then
				root.Size = HITBOX_SIZE
				root.Transparency = 0.4
				root.Material = Enum.Material.ForceField
			else
				root.Size = Vector3.new(2, 2, 1)
				root.Transparency = 0
				root.Material = Enum.Material.Plastic
			end
		end
	end
end

-- ♻️ Цикл обновления
RunService.Heartbeat:Connect(function()
	if hitboxesEnabled then
		updateEnemies()
		setHitboxes(true)
	end
end)

-- 🧠 Кнопки
teleportButton.MouseButton1Click:Connect(function()
	teleportToRayGun()
end)

hitboxButton.MouseButton1Click:Connect(function()
	hitboxesEnabled = not hitboxesEnabled
	hitboxButton.Text = hitboxesEnabled and "🧠 Хитбоксы: ON" or "🧠 Хитбоксы: OFF"
	if not hitboxesEnabled then
		setHitboxes(false)
	end
end)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- ♻️ Автоперезапуск после смерти
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	toolTaken = false
end)
