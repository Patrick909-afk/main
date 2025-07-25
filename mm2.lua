-- MM2 GUI by @gde_patrick
local Players, RunService, TweenService, CoreGui, TeleportService, HttpService =
	game:GetService("Players"),
	game:GetService("RunService"),
	game:GetService("TweenService"),
	game:GetService("CoreGui"),
	game:GetService("TeleportService"),
	game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local espEnabled, coinFarmEnabled, walkflinging = false, false, false
local Clip = true
local musicSound = nil

-- UI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MM2_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 320)
main.Position = UDim2.new(0, 20, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 80)
scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "❌"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 30, 0, 30)
toggle.Position = UDim2.new(1, -70, 0, 5)
toggle.Text = "🔥"
toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
toggle.MouseButton1Click:Connect(function()
	scroll.Visible = not scroll.Visible
	if not scroll.Visible then
		main.BackgroundTransparency = 1
	else
		main.BackgroundTransparency = 0
	end
end)

local musicBox = Instance.new("TextBox", main)
musicBox.Size = UDim2.new(0, 140, 0, 25)
musicBox.Position = UDim2.new(0, 10, 0, 45)
musicBox.PlaceholderText = "Audio ID"
musicBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
musicBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", musicBox).CornerRadius = UDim.new(0, 6)

local playBtn = Instance.new("TextButton", main)
playBtn.Size = UDim2.new(0, 60, 0, 25)
playBtn.Position = UDim2.new(0, 160, 0, 45)
playBtn.Text = "Play"
playBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
playBtn.MouseButton1Click:Connect(function()
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

-- Buttons
local y = 0
local function createBtn(txt, callback)
	local btn = Instance.new("TextButton", scroll)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.Text = txt
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
	y += 35
end

createBtn("ESP ON/OFF", function()
	espEnabled = not espEnabled
end)

createBtn("Coin Farm ON/OFF", function()
	coinFarmEnabled = not coinFarmEnabled
end)

createBtn("WalkFling ON/OFF", function()
	walkflinging = not walkflinging
	Clip = not walkflinging
end)

createBtn("TP to Sheriff", function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Gun") then
			LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
			break
		end
	end
end)

createBtn("TP to Murderer", function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Knife") then
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

-- ESP
RunService.RenderStepped:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local role = "Normal"
			if p.Backpack:FindFirstChild("Knife") then role = "Murderer" end
			if p.Backpack:FindFirstChild("Gun") then role = "Sheriff" end

			if espEnabled then
				local tag = p.Character:FindFirstChild("ESPTag")
				if not tag then
					local bill = Instance.new("BillboardGui", p.Character)
					bill.Name = "ESPTag"
					bill.Adornee = p.Character.HumanoidRootPart
					bill.Size = UDim2.new(0, 100, 0, 40)
					bill.StudsOffset = Vector3.new(0, 3, 0)
					bill.AlwaysOnTop = true

					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1, 0, 1, 0)
					txt.BackgroundTransparency = 1
					txt.TextStrokeTransparency = 0.5
					txt.TextScaled = true

					local dist = math.floor((p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
					txt.Text = p.Name.." ["..dist.."m]"
					if role == "Murderer" then txt.TextColor3 = Color3.new(1,0,0)
					elseif role == "Sheriff" then txt.TextColor3 = Color3.new(0,0.6,1)
					else txt.TextColor3 = Color3.new(0,1,0) end
				end
			else
				local tag = p.Character:FindFirstChild("ESPTag")
				if tag then tag:Destroy() end
			end
		end
	end
end)

-- Coin Farm
RunService.Heartbeat:Connect(function()
	if coinFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for _, coin in ipairs(workspace:GetDescendants()) do
			if not coinFarmEnabled then break end
			if coin:IsA("BasePart") and coin.Name:lower():find("coin") then
				LocalPlayer.Character:SetPrimaryPartCFrame(coin.CFrame)
				wait(0.075)
			end
		end
	end

	if walkflinging and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(100, 100, 100)
	end

	if not Clip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

-- Respawn handling
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
end)
