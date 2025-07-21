-- ⚠️ by @gde_patrick — убийство всех через уязвимые RemoteEvent'ы

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- 🔁 Обновление каждый 1.5 секунды
while wait(1.5) do
    local char = lp.Character
    if not char then continue end

    -- Поиск активного инструмента (оружия)
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        warn("❌ Оружие не найдено")
        continue
    end

    -- Поиск возможного RemoteEvent внутри инструмента
    local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
    if not remote then
        warn("❌ RemoteEvent не найден в инструменте")
        continue
    end

    print("✅ Использую: " .. remote.Name)

    -- Атака по всем игрокам
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= lp and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            -- Подача события с разными типами аргументов (тест)
            pcall(function() remote:FireServer(target) end)
            pcall(function() remote:FireServer(target.Character) end)
            pcall(function() remote:FireServer(target.Character.HumanoidRootPart.Position) end)
        end
    end
end
