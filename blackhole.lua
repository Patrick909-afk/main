--// Настройки
local TELEPORT_POSITION = Vector3.new(5024.69, 13445.93, 162.18) -- твои координаты

--// Переменные
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local enabled = false

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 20)
toggleBtn.Text = "🔴 AutoFarm: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

--// АвтоТелепорт
task.spawn(function()
	while true do
		if enabled then
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				character:MoveTo(TELEPORT_POSITION)
			end
		end
		wait(2)
	end
end)

--// Вкл/Выкл логика
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleBtn.Text = "🟢 AutoFarm: ON"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
	else
		toggleBtn.Text = "🔴 AutoFarm: OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end)
