-- Death Terror GUI by @gde_patrick

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeathTerrorGUI"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "☠️ Старт террора"
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -20, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 60)
closeBtn.Text = "❌ Закрыть GUI"
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 14

-- Переменные
local enabled = false
local index = 1
local victims = {}

local function refreshVictims()
	victims = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(victims, p)
		end
	end
end

local function killNearPlayer()
	if #victims == 0 then return end
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	index = (index % #victims) + 1
	local target = victims[index]
	if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

	-- Телепорт к игроку
	character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0))

	-- Убить себя
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end

-- Цикл обновления
spawn(function()
	while true do
		wait(1)
		if enabled then
			refreshVictims()
			killNearPlayer()
		end
	end
end)

-- Подключение кнопок
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "☠️ Стоп террора" or "☠️ Старт террора"
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- После смерти — продолжение
LocalPlayer.CharacterAdded:Connect(function(char)
	wait(1)
	if enabled then
		refreshVictims()
	end
end)
