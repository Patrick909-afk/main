-- Создание GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CoordTracker"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local coordsLabel = Instance.new("TextLabel", frame)
coordsLabel.Size = UDim2.new(1, -20, 0, 60)
coordsLabel.Position = UDim2.new(0, 10, 0, 10)
coordsLabel.TextColor3 = Color3.new(1, 1, 1)
coordsLabel.Text = "Координаты: ..."
coordsLabel.TextWrapped = true
coordsLabel.TextSize = 14
coordsLabel.Font = Enum.Font.Gotham

local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(0.5, -15, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 1, -40)
teleportButton.Text = "Телепорт"
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
teleportButton.Font = Enum.Font.Gotham
teleportButton.TextSize = 14
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(1, 0)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0.5, -15, 0, 30)
closeButton.Position = UDim2.new(0.5, 5, 1, -40)
closeButton.Text = "Закрыть"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 14
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

-- Отслеживание координат
local savedPosition = nil

spawn(function()
	while gui.Parent do
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local pos = hrp.Position
			coordsLabel.Text = string.format("X: %.2f\nY: %.2f\nZ: %.2f", pos.X, pos.Y, pos.Z)
			savedPosition = pos
		end
		wait(0.5)
	end
end)

-- Кнопка телепорта
teleportButton.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	if savedPosition then
		hrp.CFrame = CFrame.new(savedPosition + Vector3.new(0, 3, 0))
	end
end)

-- Кнопка закрытия
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
