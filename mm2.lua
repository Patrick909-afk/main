--// ИНИЦИАЛИЗАЦИЯ
local Players, RunService, TweenService = game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPEnabled, CoinFarm, Flinging = false, false, false
local AuraType, AuraRunning = nil, false
local GUIOpen = true
local Root = function(char) return char and char:FindFirstChild("HumanoidRootPart") end

--// ФУНКЦИИ ОБНАРУЖЕНИЯ
local function getMurderer()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			if (p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife"))) then
				return p
			end
		end
	end
end
local function getSheriff()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			if (p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun"))) then
				return p
			end
		end
	end
end

--// GUI СОЗДАНИЕ
local screengui = Instance.new("ScreenGui", game.CoreGui)
screengui.Name = "MM2Gui"
local frame = Instance.new("Frame", screengui)
frame.Size = UDim2.new(0, 250, 0, 310)
frame.Position = UDim2.new(0, 50, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 12)

local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 230, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

--// ESP
local function toggleESP()
	ESPEnabled = not ESPEnabled
	if ESPEnabled then
		coroutine.wrap(function()
			while ESPEnabled do
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
						local h = p.Character.Head
						if not h:FindFirstChild("ESP") then
							local b = Instance.new("BillboardGui", h)
							b.Name = "ESP"
							b.Adornee = h
							b.Size = UDim2.new(0,100,0,20)
							b.AlwaysOnTop = true
							local t = Instance.new("TextLabel", b)
							t.Size = UDim2.new(1,0,1,0)
							t.BackgroundTransparency = 1
							t.TextScaled = true
							t.Font = Enum.Font.SourceSansBold
							t.Text = p.Name
							if p == getMurderer() then
								t.TextColor3 = Color3.new(1,0,0)
							elseif p == getSheriff() then
								t.TextColor3 = Color3.new(0,0.7,1)
							else
								t.TextColor3 = Color3.new(1,1,1)
							end
						end
					end
				end
				wait(1)
			end
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("Head") then
					local esp = p.Character.Head:FindFirstChild("ESP")
					if esp then esp:Destroy() end
				end
			end
		end)()
	end
end

--// ФЛИНГ
local function toggleFling()
	local root = Root(LocalPlayer.Character)
	if not root then return end
	Flinging = not Flinging
	if Flinging then
		local bav = Instance.new("BodyAngularVelocity", root)
		bav.AngularVelocity = Vector3.new(0,99999,0)
		bav.MaxTorque = Vector3.new(0,math.huge,0)
		bav.P = math.huge
		bav.Name = "FlingBAV"
	else
		local bav = root:FindFirstChild("FlingBAV")
		if bav then bav:Destroy() end
	end
end

--// ФАРМ МОНЕТ
local coinfarmPos = nil
local function startCoinFarm()
	CoinFarm = true
	local root = Root(LocalPlayer.Character)
	if root then coinfarmPos = root.Position end
	coroutine.wrap(function()
		while CoinFarm do
			for _, coin in pairs(workspace:GetDescendants()) do
				if coin:IsA("Part") and coin.Name:lower():find("coin") then
					Root(LocalPlayer.Character).CFrame = CFrame.new(coin.Position + Vector3.new(0,2,0))
					task.wait(0.2)
				end
			end
			task.wait(0.5)
		end
		if coinfarmPos then
			Root(LocalPlayer.Character).CFrame = CFrame.new(coinfarmPos + Vector3.new(0,2,0))
		end
	end)()
end
local function stopCoinFarm() CoinFarm = false end

--// АУРА
local function startAura(targetType)
	if AuraRunning then return end
	AuraType = targetType
	AuraRunning = true
	coroutine.wrap(function()
		while AuraRunning do
			local target
			if AuraType == "Murderer" then target = getMurderer()
			elseif AuraType == "Sheriff" then target = getSheriff()
			elseif AuraType == "Others" then
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and p ~= getMurderer() and p ~= getSheriff() then
						target = p break
					end
				end
			end
			if target and target.Character and Root(target.Character) then
				local r = Root(target.Character)
				r.Size = Vector3.new(10,10,10)
				r.Transparency = 0.5
				Root(LocalPlayer.Character).CFrame = r.CFrame + Vector3.new(0,2,0)
			end
			wait(0.5)
		end
	end)()
end
local function stopAura()
	AuraRunning = false
end

--// КНОПКИ
createButton("ESP Murderer/Sheriff", 10, toggleESP)
createButton("Auto Coin Farm ON", 50, startCoinFarm)
createButton("Auto Coin Farm OFF", 90, stopCoinFarm)
createButton("Fling Toggle", 130, toggleFling)
createButton("KillAura: Murderer", 170, function() startAura("Murderer") end)
createButton("KillAura: Sheriff", 210, function() startAura("Sheriff") end)
createButton("KillAura: Others", 250, function() startAura("Others") end)
createButton("KillAura: STOP", 290, stopAura)

--// КНОПКА СВЕРНУТЬ
local toggle = Instance.new("TextButton", screengui)
toggle.Size = UDim2.new(0, 40, 0, 40)
toggle.Position = UDim2.new(0, 10, 0.3, -45)
toggle.Text = "🔥"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBlack
toggle.TextSize = 24
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 100)

toggle.MouseButton1Click:Connect(function()
	GUIOpen = not GUIOpen
	frame.Visible = GUIOpen
end)
