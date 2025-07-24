-- ChatGPT MM2 GUI 2025
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local RunService = game:GetService("RunService")

-- Перезагрузка после смерти
local function getChar()
    return plr.Character or plr.CharacterAdded:Wait()
end

-- GUI
pcall(function() plr.PlayerGui.MMCheat:Destroy() end)
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "MMCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 4)

local function makeBtn(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.MouseButton1Click:Connect(callback)
end

-- ESP
local espEnabled = false
function toggleESP()
    espEnabled = not espEnabled
    if not espEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                if p.Character:FindFirstChild("ESPTag") then
                    p.Character.ESPTag:Destroy()
                end
            end
        end
        return
    end

    RunService:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character:FindFirstChild("ESPTag") then
                    local tag = Instance.new("BillboardGui", p.Character)
                    tag.Name = "ESPTag"
                    tag.Adornee = p.Character.Head
                    tag.Size = UDim2.new(0,100,0,40)
                    tag.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", tag)
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Font = Enum.Font.SourceSansBold

                    if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                        label.TextColor3 = Color3.fromRGB(0,170,255)
                        label.Text = "SHERIFF"
                    elseif p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                        label.TextColor3 = Color3.fromRGB(255,0,0)
                        label.Text = "MURDERER"
                    else
                        label.Text = "PLAYER"
                        label.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end
            end
        end
    end)
end

-- TP to role
local function tpToRole(item)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then
            if p.Backpack:FindFirstChild(item) or p.Character:FindFirstChild(item) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    getChar():WaitForChild("HumanoidRootPart").CFrame = hrp.CFrame + Vector3.new(0,2,0)
                    break
                end
            end
        end
    end
end

-- Random TP
local function randomTP()
    local others = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(others, p)
        end
    end
    if #others > 0 then
        local r = others[math.random(1, #others)]
        getChar():WaitForChild("HumanoidRootPart").CFrame = r.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end

-- Coin Farm
local farming = false
function toggleCoinFarm()
    farming = not farming
    task.spawn(function()
        while farming do
            local hrp = getChar():WaitForChild("HumanoidRootPart")
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "Coin" then
                    hrp.CFrame = v.CFrame + Vector3.new(0,2,0)
                    task.wait(0.15)
                end
            end
            task.wait(1)
        end
    end)
end

-- WalkFling
local fling = false
function toggleFling()
    fling = not fling
    if fling then
        task.spawn(function()
            while fling do
                local hrp = getChar():WaitForChild("HumanoidRootPart")
                local bv = Instance.new("BodyAngularVelocity")
                bv.AngularVelocity = Vector3.new(9999,9999,9999)
                bv.MaxTorque = Vector3.new(1e9,1e9,1e9)
                bv.P = 100000
                bv.Name = "FlingVel"
                bv.Parent = hrp
                wait(0.1)
                if bv.Parent then bv:Destroy() end
                wait(0.05)
            end
        end)
    end
end

-- GUI Buttons
makeBtn("WalkFling ON/OFF", toggleFling)
makeBtn("TP to Murderer", function() tpToRole("Knife") end)
makeBtn("TP to Sheriff", function() tpToRole("Gun") end)
makeBtn("Coin Farm ON/OFF", toggleCoinFarm)
makeBtn("ESP ON/OFF", toggleESP)
makeBtn("Random TP", randomTP)
makeBtn("❌ Close", function() gui:Destroy() end)
