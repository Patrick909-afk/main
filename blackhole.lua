-- 📦 Автовыдача всех предметов GUI
-- by @gde_patrick

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- 🔎 Сканируем все возможные контейнеры
local containers = {
	ReplicatedStorage,
	StarterPack,
	Workspace,
	game:GetService("Lighting"),
}

local items = {}

-- Фильтр выдаваемых объектов
for _, container in ipairs(containers) do
	for _, obj in ipairs(container:GetDescendants()) do
		if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("Accessory") or obj:IsA("HopperBin") then
			table.insert(items, obj)
		end
	end
end

-- 🧱 Интерфейс
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoItemMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local close = Instance.new("TextButton", frame)
close.Text = "✖"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local giveAll = Instance.new("TextButton", frame)
giveAll.Text = "📦 Выдать всё"
giveAll.Size = UDim2.new(1, -20, 0, 40)
giveAll.Position = UDim2.new(0, 10, 0, 5)
giveAll.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
giveAll.TextColor3 = Color3.new(1, 1, 1)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 42)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasPosition = Vector2.new(0, 0)

-- 💥 Кнопка "выдать всё"
giveAll.MouseButton1Click:Connect(function()
	for _, obj in ipairs(items) do
		local success, clone = pcall(function()
			return obj:Clone()
		end)
		if success and clone then
			clone.Parent = player.Backpack
		end
	end
	giveAll.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	task.wait(1)
	giveAll.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

-- 🔘 Кнопки на каждый предмет
for i, obj in ipairs(items) do
	local btn = Instance.new("TextButton", scroll)
	btn.Size = UDim2.new(1, -10, 0, 38)
	btn.Position = UDim2.new(0, 5, 0, (i - 1) * 42)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = "🎁 " .. obj:GetFullName()

	btn.MouseButton1Click:Connect(function()
		local success, clone = pcall(function()
			return obj:Clone()
		end)
		if success and clone then
			clone.Parent = player.Backpack
			btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
			task.wait(1)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end
	end)
end
