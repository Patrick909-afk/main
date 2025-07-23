-- GUI + Фонк из звука смерти
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "☠ Включить Смертельный ФОНК"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 16

-- Поиск звука смерти
local function getDeathSoundId()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    for _, v in pairs(hum:GetChildren()) do
        if v:IsA("Sound") and v.Name:lower():find("death") then
            return v.SoundId
        end
    end
end

-- Звук спам
local isPlaying = false
local deathLoop

local function startDeathFonkk(soundId)
    if isPlaying then return end
    isPlaying = true

    deathLoop = task.spawn(function()
        while isPlaying do
            local s = Instance.new("Sound")
            s.SoundId = soundId
            s.Volume = 10
            s.Pitch = math.random(80, 120) / 100 -- немного хаоса
            s.Parent = workspace
            s:Play()
            game:GetService("Debris"):AddItem(s, 2)
            wait(0.05) -- максимально часто (каждые 50 мс)
        end
    end)
end

local function stopDeathFonkk()
    isPlaying = false
end

-- Нажатие на кнопку
button.MouseButton1Click:Connect(function()
    if not isPlaying then
        local id = getDeathSoundId()
        if id then
            button.Text = "💀 ФОНК ВКЛЮЧЕН (Нажми, чтобы выключить)"
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            startDeathFonkk(id)
        else
            button.Text = "❌ Не найден звук смерти"
        end
    else
        button.Text = "☠ Включить Смертельный ФОНК"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        stopDeathFonkk()
    end
end)
