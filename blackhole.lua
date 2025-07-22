local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MusicGui"
gui.ResetOnSpawn = false

-- Основной фрейм
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "🎶 Музыка на сервер"
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Кнопка закрытия
local close = Instance.new("TextButton", frame)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.new(1,0,0)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Поле ввода
local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Введите SoundId (например: 9118823100)"
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 40)
input.Text = ""
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(60,60,60)
input.TextColor3 = Color3.new(1,1,1)

-- Кнопка воспроизведения
local play = Instance.new("TextButton", frame)
play.Text = "▶️ PLAY"
play.Size = UDim2.new(0.45, -5, 0, 30)
play.Position = UDim2.new(0, 10, 0, 80)
play.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
play.Font = Enum.Font.GothamBold
play.TextSize = 14

-- Кнопка остановки
local stop = Instance.new("TextButton", frame)
stop.Text = "⛔ STOP"
stop.Size = UDim2.new(0.45, -5, 0, 30)
stop.Position = UDim2.new(0.55, 5, 0, 80)
stop.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
stop.Font = Enum.Font.GothamBold
stop.TextSize = 14

-- Скроллинг список песен
local scroller = Instance.new("ScrollingFrame", frame)
scroller.Size = UDim2.new(1, -20, 0, 130)
scroller.Position = UDim2.new(0, 10, 0, 120)
scroller.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
scroller.ScrollBarThickness = 6
scroller.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Массив песен (whitelisted SoundId)
local soundList = {
	{ Name = "C00lkid Music", Id = 9118823100 },
	{ Name = "Horror Background", Id = 9122067525 },
	{ Name = "SCP Sound", Id = 3342847073 },
	{ Name = "Doom Ambience", Id = 1837635121 },
	{ Name = "Spooky Sounds", Id = 142295308 },
	{ Name = "Thunder & Rain", Id = 9122059606 },
}

-- Создание кнопок песен
local layout = Instance.new("UIListLayout", scroller)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

for _, sound in ipairs(soundList) do
	local btn = Instance.new("TextButton", scroller)
	btn.Text = sound.Name
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(function()
		input.Text = tostring(sound.Id)
	end)
end

-- Авторазмер списка
scroller.CanvasSize = UDim2.new(0, 0, 0, #soundList * 35)

-- Sound объект
local sound = Instance.new("Sound", workspace)
sound.Looped = false
sound.Volume = 5

-- Переменные воспроизведения
local playingLoop = false
local queue = {}
local currentIndex = 1

-- Запуск трека
local function playSound(id)
	sound.SoundId = "rbxassetid://" .. tostring(id)
	sound:Play()
end

-- Циклическое воспроизведение
local function playQueue()
	playingLoop = true
	while playingLoop do
		if #queue == 0 then break end
		local id = queue[currentIndex]
		playSound(id)
		sound.Ended:Wait()
		currentIndex = (currentIndex % #queue) + 1
	end
end

-- Кнопка PLAY
play.MouseButton1Click:Connect(function()
	local id = tonumber(input.Text)
	if not id then return end
	table.clear(queue)
	table.insert(queue, id)
	currentIndex = 1
	playQueue()
end)

-- Кнопка STOP
stop.MouseButton1Click:Connect(function()
	playingLoop = false
	sound:Stop()
end)
