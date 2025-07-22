local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SoundGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local close = Instance.new("TextButton", frame)
close.Text = "X"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local listBox = Instance.new("ScrollingFrame", frame)
listBox.Size = UDim2.new(1, -20, 0, 200)
listBox.Position = UDim2.new(0, 10, 0, 40)
listBox.CanvasSize = UDim2.new(0, 0, 0, 0)
listBox.ScrollBarThickness = 8
listBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local layout = Instance.new("UIListLayout", listBox)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Введите SoundId (rbxassetid://1234567)"
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 250)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.TextColor3 = Color3.fromRGB(255, 255, 255)

local play = Instance.new("TextButton", frame)
play.Text = "PLAY"
play.Size = UDim2.new(0.3, -5, 0, 30)
play.Position = UDim2.new(0, 10, 0, 290)
play.BackgroundColor3 = Color3.fromRGB(80, 255, 80)

local stop = Instance.new("TextButton", frame)
stop.Text = "STOP"
stop.Size = UDim2.new(0.3, -5, 0, 30)
stop.Position = UDim2.new(0.35, 5, 0, 290)
stop.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

local nextBtn = Instance.new("TextButton", frame)
nextBtn.Text = "NEXT"
nextBtn.Size = UDim2.new(0.3, -5, 0, 30)
nextBtn.Position = UDim2.new(0.7, 5, 0, 290)
nextBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 255)

-- Текущий звук
local currentSound = Instance.new("Sound", workspace)
currentSound.Name = "GuiSound"
currentSound.Volume = 5

-- Список всех звуков на сервере
local sounds = {}
local function gatherSounds()
	sounds = {}
	for _, obj in ipairs(game:GetDescendants()) do
		if obj:IsA("Sound") then
			table.insert(sounds, obj)
		end
	end
end

-- Добавляем кнопки звуков
local function populateList()
	listBox:ClearAllChildren()
	gatherSounds()

	for i, sound in ipairs(sounds) do
		local btn = Instance.new("TextButton", listBox)
		btn.Size = UDim2.new(1, -10, 0, 25)
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Text = sound.Name
		btn.MouseButton1Click:Connect(function()
			if sound.SoundId then
				currentSound:Stop()
				currentSound.SoundId = sound.SoundId
				currentSound:Play()
			end
		end)
	end
	listBox.CanvasSize = UDim2.new(0, 0, 0, #sounds * 26)
end

populateList()

-- Управление воспроизведением
play.MouseButton1Click:Connect(function()
	local id = input.Text
	if id ~= "" then
		currentSound:Stop()
		currentSound.SoundId = id
		currentSound:Play()
	end
end)

stop.MouseButton1Click:Connect(function()
	currentSound:Stop()
end)

local currentIndex = 1
nextBtn.MouseButton1Click:Connect(function()
	currentIndex += 1
	if currentIndex > #sounds then currentIndex = 1 end
	currentSound:Stop()
	currentSound.SoundId = sounds[currentIndex].SoundId
	currentSound:Play()
end)
