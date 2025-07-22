-- 📦 Area 51 Script by @gde_patrick

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local RayGunName = "RayGun"
local MobFolderName = "ZombieStorage" -- папка с мобами (замени при необходимости)
local RayGunObject = Workspace:FindFirstChild(RayGunName) or Workspace:WaitForChild(RayGunName)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Area51ScriptGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0, 50, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local teleportBtn = Instance.new("TextButton", frame)
teleportBtn.Size = UDim2.new(1, -20, 0, 40)
teleportBtn.Position = UDim2.new(0, 10, 0, 10)
teleportBtn.Text = "🚀 Телепорт к RayGun"
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
Instance.new("UICorner", teleportBtn)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 65)
toggleBtn.Text = "🎯 Хитбоксы: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
Instance.new("UICorner", toggleBtn)

-- 📌 Функция телепортации и взятия RayGun
teleportBtn.MouseButton1Click:Connect(function()
	local function pressE()
		local VirtualInputManager = game:GetService("VirtualInputManager")
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		wait(0.1)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	end

	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and RayGunObject then
		LocalPlayer.Character.HumanoidRootPart.CFrame = RayGunObject.CFrame + Vector3.new(0, 2, 0)
		wait(0.3)
		pressE()
	end
end)

-- 🔥 Хитбоксы мобов
local hitboxEnabled = false
local mobs = {}

local function updateMobs()
	local folder = Workspace:FindFirstChild(MobFolderName)
	if folder then
		for _, mob in ipairs(folder:GetDescendants()) do
			if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
				table.insert(mobs, mob)
			end
		end
	end
end

local function expandHitbox(mob)
	local root = mob:FindFirstChild("HumanoidRootPart")
	if root and not root:FindFirstChild("BigBox") then
		local box = Instance.new("SelectionBox", root)
		box.Name = "BigBox"
		box.Adornee = root
		box.LineThickness = 0.01
		root.Size = Vector3.new(100, 100, 100)
	end
end

local function resetHitbox(mob)
	local root = mob:FindFirstChild("HumanoidRootPart")
	if root then
		pcall(function()
			root.Size = Vector3.new(2, 2, 1)
			local b = root:FindFirstChild("BigBox")
			if b then b:Destroy() end
		end)
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	toggleBtn.Text = hitboxEnabled and "🎯 Хитбоксы: ON" or "🎯 Хитбоксы: OFF"
	toggleBtn.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(60, 90, 60) or Color3.fromRGB(90, 60, 60)
end)

-- 🧠 Цикл увеличения хитбоксов
RunService.Heartbeat:Connect(function()
	if hitboxEnabled then
		updateMobs()
		for _, mob in ipairs(mobs) do
			if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
				expandHitbox(mob)
			else
				resetHitbox(mob)
			end
		end
	end
end)

-- 🛡 Автовосстановление после смерти
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	teleportBtn.Text = "🚀 Телепорт к RayGun"
end)
