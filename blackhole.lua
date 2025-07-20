-- 🌀 Притягивалка объектов GUI v1.0 by @gde_patrick

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humRoot = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

local enabled = false
local distance = 10
local connections = {}

-- 🧱 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ObjectMagnetGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌀 Object Magnet by @gde_patrick"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 120, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "✅ Включить"
toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 16

local slider = Instance.new("TextBox", frame)
slider.Size = UDim2.new(0, 100, 0, 30)
slider.Position = UDim2.new(0, 10, 0, 80)
slider.PlaceholderText = "Дистанция (10-100)"
slider.Text = tostring(distance)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.TextColor3 = Color3.new(1, 1, 1)
slider.Font = Enum.Font.SourceSans
slider.TextSize = 14

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 100, 0, 30)
close.Position = UDim2.new(0, 130, 0, 80)
close.Text = "❌ Закрыть"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSans
close.TextSize = 16

-- 💫 Притягивание
local function getParts()
	local parts = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Anchored == false and not obj:IsDescendantOf(character) then
			table.insert(parts, obj)
		end
	end
	return parts
end

local function attractParts()
	for _, part in ipairs(getParts()) do
		local angle = tick() % (2 * math.pi)
		local radius = tonumber(distance)
		local x = math.cos(angle + part:GetDebugId(1):len()) * radius
		local z = math.sin(angle + part:GetDebugId(1):len()) * radius
		local pos = humRoot.Position + Vector3.new(x, 0.5, z)
		part.Velocity = (pos - part.Position) * 5
	end
end

-- 🔁 Цикл
local function start()
	if connections.loop then return end
	connections.loop = runService.Heartbeat:Connect(function()
		if enabled then
			attractParts()
		end
	end)
end

local function stop()
	if connections.loop then
		connections.loop:Disconnect()
		connections.loop = nil
	end
end

-- 🕹️ Кнопки
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "⛔ Выключить" or "✅ Включить"
	if enabled then
		start()
	else
		stop()
	end
end)

slider.FocusLost:Connect(function()
	local val = tonumber(slider.Text)
	if val and val >= 5 and val <= 100 then
		distance = val
	else
		slider.Text = tostring(distance)
	end
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
	stop()
end)

-- 🛡️ Ноуклип
runService.Stepped:Connect(function()
	if enabled and character:FindFirstChildOfClass("Humanoid") then
		for _, v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)
