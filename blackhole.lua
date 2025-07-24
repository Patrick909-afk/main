-- Автофарм побед с GUI v1.0 by @gde_patrick

-- Создаём GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "WinFarmGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 60)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- RGB анимация
local rgb = 0
spawn(function()
	while true do
		rgb = (rgb + 1) % 255
		frame.BackgroundColor3 = Color3.fromHSV(rgb / 255, 1, 0.3)
		wait(0.05)
	end
end)

-- Кнопка включения
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 120, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 15)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggle.BorderSizePixel = 0
toggle.Text = "Автофарм: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold

-- Кнопка закрытия
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 15)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.Gotham
close.TextScaled = true
close.BorderSizePixel = 0

-- Закрытие GUI
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Переменные
local enabled = false

-- Автофарм логика
local function findNearestCheckpoint()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local nearest, dist = nil, math.huge
	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and part:IsDescendantOf(workspace) then
			local gui = part:FindFirstChildWhichIsA("BillboardGui", true)
			if gui and gui:FindFirstChildWhichIsA("TextLabel") then
				local label = gui:FindFirstChildWhichIsA("TextLabel")
				if label.Text:lower():find("прикоснуться") then
					local d = (part.Position - hrp.Position).Magnitude
					if d < dist then
						nearest = part
						dist = d
					end
				end
			end
		end
	end
	return nearest
end

-- Запуск цикла автофарма
spawn(function()
	while true do
		if enabled then
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local checkpoint = findNearestCheckpoint()
			if checkpoint and hrp then
				hrp.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)
			end
		end
		wait(1.5)
	end
end)

-- Обработка нажатия
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "Автофарм: ON" or "Автофарм: OFF"
	toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(20, 20, 20)
end)
