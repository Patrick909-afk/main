-- Trolls Cant Break Tower GUI Script (Edited by @gde_patrick)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Config
local DEBOUNCE_TIME = 0.005
local ATTACK_COOLDOWN = 0.02
local MAX_HITBOX_SIZE = 1000
local MIN_HITBOX_SIZE = 1
local HITBOX_UPDATE_RATE = 1/120
local SLAP_POWER = 10000

-- Safe wait
local function safeWait(time)
	local start = tick()
	while tick() - start < time do
		RunService.Heartbeat:Wait()
	end
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollsCantBreakTowerScript"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 250)
Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", Frame).Color = Color3.fromRGB(100, 80, 150)

local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 15)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.Text = "Trolls_Cant_Break_Tower_Game_Script"
TitleLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSans
Instance.new("UIStroke", TitleLabel).Color = Color3.fromRGB(0, 0, 0)

local CreditsLabel = Instance.new("TextLabel", Frame)
CreditsLabel.Size = UDim2.new(1, 0, 0, 30)
CreditsLabel.Position = UDim2.new(0, 0, 1, -40)
CreditsLabel.Text = "Credits: @gde_patrick"
CreditsLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.TextScaled = true
CreditsLabel.Font = Enum.Font.SourceSans
Instance.new("UIStroke", CreditsLabel).Color = Color3.fromRGB(0, 0, 0)

local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 50)
ToggleButton.Text = "Activate Troll System"
ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 90, 180)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", ToggleButton).Color = Color3.fromRGB(180, 150, 220)

local SizeFrame = Instance.new("Frame", Frame)
SizeFrame.Size = UDim2.new(0.9, 0, 0, 50)
SizeFrame.Position = UDim2.new(0.05, 0, 0, 110)
SizeFrame.BackgroundTransparency = 1

local IncreaseButton = Instance.new("TextButton", SizeFrame)
IncreaseButton.Size = UDim2.new(0.45, -10, 1, 0)
IncreaseButton.Position = UDim2.new(0, 0, 0, 0)
IncreaseButton.Text = "+"
IncreaseButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.TextScaled = true
IncreaseButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", IncreaseButton).CornerRadius = UDim.new(0, 10)

local DecreaseButton = Instance.new("TextButton", SizeFrame)
DecreaseButton.Size = UDim2.new(0.45, -10, 1, 0)
DecreaseButton.Position = UDim2.new(0.55, 0, 0, 0)
DecreaseButton.Text = "-"
DecreaseButton.BackgroundColor3 = Color3.fromRGB(180, 100, 100)
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.TextScaled = true
DecreaseButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", DecreaseButton).CornerRadius = UDim.new(0, 10)

local SizeLabel = Instance.new("TextLabel", Frame)
SizeLabel.Size = UDim2.new(0.9, 0, 0, 30)
SizeLabel.Position = UDim2.new(0.05, 0, 0, 170)
SizeLabel.Text = "Hitbox Size: 10"
SizeLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextScaled = true
SizeLabel.Font = Enum.Font.SourceSans

local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -45, 0, 2.5)
MinimizeButton.Text = "−"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(180, 120, 220)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 10)

-- Variables
local Spamming = false
local hitboxSize = 10
local hitboxIndicator = nil
local isMinimized = false
local lastUpdate = 0
local cachedPlayers = {}
local connection

local function createHitbox()
	if hitboxIndicator then pcall(function() hitboxIndicator:Destroy() end) end
	local part = Instance.new("Part")
	part.Name = "TrollHitbox"
	part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0.5
	part.Color = Color3.fromRGB(150, 100, 255)
	part.Material = Enum.Material.ForceField
	part.Parent = workspace
	hitboxIndicator = part
end

local function updateHitbox()
	SizeLabel.Text = "Hitbox Size: " .. math.floor(hitboxSize)
	if not Spamming or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		if hitboxIndicator then pcall(function() hitboxIndicator:Destroy() end) hitboxIndicator = nil end
		return
	end
	if hitboxIndicator then
		hitboxIndicator.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
		hitboxIndicator.Position = LocalPlayer.Character.HumanoidRootPart.Position
	end
end

local function updatePlayerCache()
	cachedPlayers = {}
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(cachedPlayers, player)
		end
	end
end

local function getAttackRemote()
	local char = LocalPlayer.Character
	if char then
		for _, tool in pairs(char:GetChildren()) do
			if tool:IsA("Tool") and tool:FindFirstChild("Event") then
				return tool.Event
			end
		end
	end
	return nil
end

local function triggerHitbox()
	while Spamming do
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local remote = getAttackRemote()
		if root and remote then
			updatePlayerCache()
			for _, player in pairs(cachedPlayers) do
				local target = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if target and (target.Position - root.Position).Magnitude <= hitboxSize then
					coroutine.wrap(function()
						pcall(function()
							remote:FireServer("slash", player.Character, target.Position, Vector3.new(0, SLAP_POWER, 0))
							if not target:FindFirstChild("BodyVelocity") then
								local bv = Instance.new("BodyVelocity")
								bv.MaxForce = Vector3.new(0, math.huge, 0)
								bv.Velocity = Vector3.new(0, SLAP_POWER, 0)
								bv.Parent = target
								game.Debris:AddItem(bv, 0.5)
							end
						end)
					end)()
				end
			end
		end
		safeWait(ATTACK_COOLDOWN)
	end
end

local function tweenProperty(obj, prop, val, time)
	local success, tween = pcall(function()
		local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		local t = TweenService:Create(obj, info, {[prop] = val})
		t:Play()
		return t
	end)
	if not success then obj[prop] = val end
	return tween
end

ToggleButton.MouseButton1Click:Connect(function()
	Spamming = not Spamming
	if Spamming then
		ToggleButton.Text = "Troll System Active"
		tweenProperty(ToggleButton, "BackgroundColor3", Color3.fromRGB(100, 180, 100), 0.3)
		createHitbox()
		coroutine.wrap(triggerHitbox)()
	else
		ToggleButton.Text = "Activate Troll System"
		tweenProperty(ToggleButton, "BackgroundColor3", Color3.fromRGB(120, 90, 180), 0.3)
		if hitboxIndicator then hitboxIndicator:Destroy() hitboxIndicator = nil end
	end
end)

IncreaseButton.MouseButton1Click:Connect(function()
	if hitboxSize < MAX_HITBOX_SIZE then
		hitboxSize = math.min(hitboxSize + 10, MAX_HITBOX_SIZE)
		if Spamming then createHitbox() end
		updateHitbox()
	end
end)

DecreaseButton.MouseButton1Click:Connect(function()
	if hitboxSize > MIN_HITBOX_SIZE then
		hitboxSize = math.max(hitboxSize - 10, MIN_HITBOX_SIZE)
		if Spamming then createHitbox() end
		updateHitbox()
	end
end)

MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		tweenProperty(Frame, "Size", UDim2.new(0, 350, 0, 40), 0.3)
		CreditsLabel.Visible = false
		MinimizeButton.Text = "+"
	else
		tweenProperty(Frame, "Size", UDim2.new(0, 350, 0, 250), 0.3)
		CreditsLabel.Visible = true
		MinimizeButton.Text = "−"
	end
end)

connection = RunService.Heartbeat:Connect(function()
	if Spamming and tick() - lastUpdate >= HITBOX_UPDATE_RATE then
		updateHitbox()
		lastUpdate = tick()
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.T then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

game:BindToClose(function()
	if hitboxIndicator then pcall(function() hitboxIndicator:Destroy() end) end
	if connection then connection:Disconnect() end
end)
