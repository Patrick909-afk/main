-- MM2 GUI by @gde_patrick (фикс + WalkFling + InfinityYield)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
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
	main.BackgroundTransparency = scroll.Visible and 1 or 0
end)

-- Infinity Yield запуск
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- MUSIC FIELD
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
	btn.TextWrapped = true
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
	y = y + 40
end

-- Переменные
local espEnabled, coinFarmEnabled, walkflinging = false, false, false
local Clip = true
local NoclipConnection

createBtn("ESP ON/OFF", function() espEnabled = not espEnabled end)
createBtn("Coin Farm ON/OFF", function() coinFarmEnabled = not coinFarmEnabled end)
createBtn("WalkFling", function()
	if walkflinging then
		walkflinging = false
		if NoclipConnection then NoclipConnection:Disconnect() end
	else
		walkflinging = true
		if NoclipConnection then NoclipConnection:Disconnect() end
		NoclipConnection = RunService.Stepped:Connect(function()
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end)
	end
end)

createBtn("FLY", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)

createBtn("TP to Sheriff", function()
	for _, p in pairs(Players:GetPlayers()) do
		if (p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun"))) then
			LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
			break
		end
	end
end)

createBtn("TP to Murderer", function()
	for _, p in pairs(Players:GetPlayers()) do
		if (p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife"))) then
			LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
			break
		end
	end
end)

createBtn("TP to Random Player", function()
	local valid = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(valid, p)
		end
	end
	if #valid > 0 then
		local target = valid[math.random(1, #valid)]
		LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
	end
end)

createBtn("Play All Server Sounds", function()
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Sound") then
			v:Play()
		end
	end
end)

-- ESP
RunService.RenderStepped:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
			local role, color = "Innocent", Color3.fromRGB(0,255,0)
			if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
				role, color = "Sheriff", Color3.fromRGB(0,0,255)
			elseif p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
				role, color = "Murderer", Color3.fromRGB(255,0,0)
			end
			if espEnabled then
				local tag = p.Character:FindFirstChild("ESP")
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
			elseif p.Character:FindFirstChild("ESP") then
				p.Character.ESP:Destroy()
			end
		end
	end
end)

-- Farm + WalkFling
RunService.Heartbeat:Connect(function()
	if coinFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Name:lower():find("coin") then
				LocalPlayer.Character:SetPrimaryPartCFrame(v.CFrame)
				wait(0.03)
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
