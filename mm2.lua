-- MM2 GUI by @gde_patrick
local Players, RunService, TweenService, CoreGui, TeleportService =
    game:GetService("Players"),
    game:GetService("RunService"),
    game:GetService("TweenService"),
    game:GetService("CoreGui"),
    game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MM2_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 400)
main.Position = UDim2.new(0, 20, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "❌"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 30, 0, 30)
toggle.Position = UDim2.new(1, -70, 0, 5)
toggle.Text = "🔥"
toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 80)
scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
toggle.MouseButton1Click:Connect(function()
    scroll.Visible = not scroll.Visible
end)

-- Music Player
local musicBox = Instance.new("TextBox", main)
musicBox.Size = UDim2.new(0, 180, 0, 25)
musicBox.Position = UDim2.new(0, 10, 0, 45)
musicBox.PlaceholderText = "Audio ID"
musicBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", musicBox).CornerRadius = UDim.new(0, 6)

local playMusic = Instance.new("TextButton", main)
playMusic.Size = UDim2.new(0, 60, 0, 25)
playMusic.Position = UDim2.new(0, 200, 0, 45)
playMusic.Text = "Play"
playMusic.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", playMusic).CornerRadius = UDim.new(0, 6)

local musicSound = nil
playMusic.MouseButton1Click:Connect(function()
    local id = tonumber(musicBox.Text)
    if id then
        if musicSound then musicSound:Stop() musicSound:Destroy() end
        musicSound = Instance.new("Sound", workspace)
        musicSound.SoundId = "rbxassetid://"..id
        musicSound.Volume = 1
        musicSound.Looped = true
        musicSound:Play()
    end
end)

-- Functional Vars
local espEnabled, coinFarmEnabled, walkflinging = false, false, false
local Clip = true
local Noclipping = nil
local lastPosition = nil

-- Buttons
local y = 0
local function createBtn(txt, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    y = y + 35
end

-- ESP
createBtn("ESP ON/OFF", function()
    espEnabled = not espEnabled
end)

-- Coin Farm
createBtn("Coin Farm ON/OFF", function()
    coinFarmEnabled = not coinFarmEnabled
end)

-- WalkFling + NoClip
createBtn("WalkFling ON/OFF", function()
    walkflinging = not walkflinging
    if walkflinging then
        Clip = false
        if not Noclipping then
            Noclipping = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        Clip = true
        if Noclipping then
            Noclipping:Disconnect()
            Noclipping = nil
        end
    end
end)

-- TP Buttons
createBtn("TP to Sheriff", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Backpack:FindFirstChild("Gun") then
            LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
            break
        end
    end
end)

createBtn("TP to Murderer", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Backpack:FindFirstChild("Knife") then
            LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
            break
        end
    end
end)

createBtn("TP to Random Player", function()
    local list = Players:GetPlayers()
    local target = list[math.random(1, #list)]
    if target and target.Character then
        LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
    end
end)

-- ESP Render
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if espEnabled then
                if not p.Character:FindFirstChild("ESP") then
                    local bill = Instance.new("BillboardGui", p.Character)
                    bill.Name = "ESP"
                    bill.Adornee = p.Character.HumanoidRootPart
                    bill.Size = UDim2.new(0, 100, 0, 40)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.AlwaysOnTop = true

                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.Text = p.Name
                    txt.TextColor3 = Color3.new(1,0,0)
                    txt.BackgroundTransparency = 1
                    txt.TextStrokeTransparency = 0
                end
            else
                if p.Character:FindFirstChild("ESP") then
                    p.Character.ESP:Destroy()
                end
            end
        end
    end
end)

-- Coin Farm + WalkFling Logic
RunService.Heartbeat:Connect(function()
    if coinFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local coins = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("coin") then
                table.insert(coins, v)
            end
        end
        if #coins > 0 then
            lastPosition = LocalPlayer.Character.HumanoidRootPart.Position
            for _, coin in pairs(coins) do
                if not coinFarmEnabled then break end
                LocalPlayer.Character:SetPrimaryPartCFrame(coin.CFrame)
                wait(0.1)
            end
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(lastPosition))
        end
    end

    if walkflinging and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(100, 0, 100)
    end
end)

-- After Death
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if walkflinging then
        Clip = false
        if not Noclipping then
            Noclipping = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end)
