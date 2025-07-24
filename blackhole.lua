--// Настройки
local TARGET_POSITION = Vector3.new(5024.69, 13445.93, 162.18)

--// Службы и переменные
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local enabled = false

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 110)
frame.Position = UDim2.new(0, 30, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Кнопка автофарма
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.Text = "🔴 AutoFarm: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

-- Кнопка закрытия
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

-- Координаты на экране
local coordsLabel = Instance.new("TextLabel", frame)
coordsLabel.Size = UDim2.new(1, -20, 0, 30)
coordsLabel.Position = UDim2.new(0, 10, 1, -35)
coordsLabel.BackgroundTransparency = 1
coordsLabel.TextColor3 = Color3.new(1, 1, 1)
coordsLabel.Font = Enum.Font.Code
coordsLabel.TextSize = 14
coordsLabel.Text = "Coords: ---"

-- Обновление координат
RunService.RenderStepped:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local pos = hrp.Position
		coordsLabel.Text = string.format("Coords: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
	end
end)

-- Телепорт каждые 2 секунды
task.spawn(function()
	while true do
		if enabled then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char:MoveTo(TARGET_POSITION)
			end
		end
		task.wait(2)
	end
end)

-- Поддержка после смерти
player.CharacterAdded:Connect(function()
	wait(1)
	if enabled then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(TARGET_POSITION)
		end
	end
end)

-- Переключатель
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggle.Text = "🟢 AutoFarm: ON"
		toggle.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
	else
		toggle.Text = "🔴 AutoFarm: OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end)

-- Закрытие
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
