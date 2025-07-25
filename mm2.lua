-- MM2 GUI by @gde_patrick (Фикс и улучшения)
local Players, RunService, Workspace, CoreGui, HttpService =
	game:GetService("Players"),
	game:GetService("RunService"),
	game:GetService("Workspace"),
	game:GetService("CoreGui"),
	game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MM2_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 230, 0, 400)
main.Position = UDim2.new(0, 20, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

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
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 30, 0, 30)
toggle.Position = UDim2.new(1, -70, 0, 5)
toggle.Text = "🔥"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)
toggle.MouseButton1Click:Connect(function()
	scroll.Visible = not scroll.Visible
end)

-- Infinity Yield запуск
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- Музыка
local musicBox = Instance.new("TextBox", main)
musicBox.Size = UDim2.new(0, 150, 0, 25)
musicBox.Position = UDim2.new(0, 10, 0, 45)
musicBox.PlaceholderText = "Audio ID"
musicBox.Text = ""
musicBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
musicBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", musicBox).CornerRadius = UDim.new(0, 6)

local playMusic = Instance.new("TextButton", main)
playMusic.Size = UDim2.new(0, 60, 0, 25)
playMusic.Position = UDim2.new(0, 170, 0, 45)
playMusic.Text = "Play"
playMusic.TextColor3 = Color3.new(1, 1, 1)
playMusic.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", playMusic).CornerRadius = UDim.new(0, 6)

local musicSound = nil
playMusic.MouseButton1Click:Connect(function()
	local id = tonumber(musicBox.Text)
	if id then
		if musicSound then musicSound:Stop() musicSound:Destroy() end
		musicSound = Instance.new("Sound", Workspace)
		musicSound.SoundId = "rbxassetid://"..id
		musicSound.Volume = 3
		musicSound.Looped = true
		musicSound:Play()
	end
end)

-- Кнопки
local y = 0
local function createBtn(txt, callback)
	local btn = Instance.new("TextButton", scroll)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.Text = txt
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
	y = y + 40
end

local espEnabled, coinFarmEnabled, walkflinging = false, false, false
local Clip = true
local NoclipConnection

-- ESP
createBtn("ESP ON/OFF", function()
	espEnabled = not espEnabled
end)

-- Coin Farm
createBtn("Coin Farm ON/OFF", function()
	coinFarmEnabled = not coinFarmEnabled
end)

-- WalkFling
createBtn("WalkFling ON/OFF", function()
	walkflinging = not walkflinging
	if walkflinging then
		Clip = false
		if NoclipConnection then NoclipConnection:Disconnect() end
		NoclipConnection = RunService.Stepped:Connect(function()
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end)
	else
		Clip = true
		if NoclipConnection then NoclipConnection:Disconnect() end
	end
end)

-- Телепорт
createBtn("TP to Sheriff", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Gun") and p.Character then
			LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
			break
		end
	end
end)

createBtn("TP to Murderer", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Knife") and p.Character then
			LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
			break
		end
	end
end)

createBtn("TP to Random Player", function()
	local targets = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(targets, p)
		end
	end
	if #targets > 0 then
		local target = targets[math.random(1, #targets)]
		LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
	end
end)

-- ESP Loop
RunService.RenderStepped:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local role = "Innocent"
			local color = Color3.fromRGB(0,255,0)
			if p.Backpack:FindFirstChild("Gun") then
				role = "Sheriff"
				color = Color3.fromRGB(0,0,255)
			elseif p.Backpack:FindFirstChild("Knife") then
				role = "Murderer"
				color = Color3.fromRGB(255,0,0)
			end
			local tag = p.Character:FindFirstChild("ESP")
			local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
			if espEnabled then
				if not tag then
					tag = Instance.new("BillboardGui", p.Character)
					tag.Name = "ESP"
					tag.Adornee = p.Character.HumanoidRootPart
					tag.Size = UDim2.new(0, 100, 0, 40)
					tag.StudsOffset = Vector3.new(0, 3, 0)
					tag.AlwaysOnTop = true
					local lbl = Instance.new("TextLabel", tag)
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 1
					lbl.TextStrokeTransparency = 0
					lbl.TextColor3 = color
					lbl.Text = p.Name.." ["..role.."]\n"..dist.." studs"
				else
					tag.TextLabel.Text = p.Name.." ["..role.."]\n"..dist.." studs"
					tag.TextLabel.TextColor3 = color
				end
			elseif tag then
				tag:Destroy()
			end
		end
	end
end)

-- Coin Farm + WalkFling
RunService.Heartbeat:Connect(function()
	if coinFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Name:lower():find("coin") then
				LocalPlayer.Character:SetPrimaryPartCFrame(v.CFrame)
				wait(0.05)
			end
		end
	end
	if walkflinging and LocalPlayer.Character then
		local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local theirRoot = p.Character.HumanoidRootPart
					if (theirRoot.Position - root.Position).Magnitude < 5 then
						theirRoot.Velocity = Vector3.new(300,300,300)
					end
				end
			end
		end
	end
end)
