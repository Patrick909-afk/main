-- // GUI Setup
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local uis = game:GetService("UserInputService")

-- Remove old GUI
pcall(function() plr.PlayerGui.MainCheatGui:Destroy() end)

-- Create GUI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "MainCheatGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 270)
frame.Position = UDim2.new(0.01, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uilist = Instance.new("UIListLayout", frame)
uilist.Padding = UDim.new(0, 5)
uilist.FillDirection = Enum.FillDirection.Vertical
uilist.SortOrder = Enum.SortOrder.LayoutOrder

-- // Create Button
local function createButton(txt, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.Text = txt
	btn.Font = Enum.Font.SourceSansBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- // ESP
local espOn = false
local function toggleESP()
	espOn = not espOn
	if not espOn then
		for _, v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("ESPBox") then
				v.ESPBox:Destroy()
			end
		end
	else
		spawn(function()
			while espOn do
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						if not player.Character:FindFirstChild("ESPBox") then
							local box = Instance.new("BillboardGui", player.Character)
							box.Name = "ESPBox"
							box.Size = UDim2.new(0, 100, 0, 40)
							box.Adornee = player.Character:FindFirstChild("Head")
							box.AlwaysOnTop = true
							local txt = Instance.new("TextLabel", box)
							txt.Size = UDim2.new(1, 0, 1, 0)
							txt.BackgroundTransparency = 1
							txt.TextColor3 = Color3.fromRGB(255, 255, 255)
							txt.TextStrokeTransparency = 0
							txt.Font = Enum.Font.SourceSansBold
							txt.TextScaled = true
							txt.Text = player.Name

							if player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
								txt.TextColor3 = Color3.fromRGB(0, 170, 255) -- Шериф
							elseif player.Character:FindFirstChild("Knife") then
								txt.TextColor3 = Color3.fromRGB(255, 60, 60) -- Убийца
							end
						end
					end
				end
				wait(1)
			end
		end)
	end
end

-- // TP to role
local function tpToRole(roleTool)
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character then
			if player.Backpack:FindFirstChild(roleTool) or player.Character:FindFirstChild(roleTool) then
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					char:WaitForChild("HumanoidRootPart").CFrame = hrp.CFrame + Vector3.new(0, 2, 0)
				end
			end
		end
	end
end

-- // Random TP
local function randomTP()
	local others = {}
	for _, p in ipairs(game.Players:GetPlayers()) do
		if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(others, p)
		end
	end
	if #others > 0 then
		local rand = others[math.random(1, #others)]
		char:WaitForChild("HumanoidRootPart").CFrame = rand.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
	end
end

-- // WalkFling
local flingOn = false
local flingConn
local function toggleWalkFling()
	flingOn = not flingOn
	if flingOn then
		local vel = Instance.new("BodyAngularVelocity")
		vel.AngularVelocity = Vector3.new(10000, 10000, 10000)
		vel.MaxTorque = Vector3.new(100000, 100000, 100000)
		vel.Name = "FlingForce"
		vel.P = 100000

		flingConn = plr.CharacterAdded:Connect(function(char)
			wait(0.5)
			local hrp = char:WaitForChild("HumanoidRootPart")
			local clone = vel:Clone()
			clone.Parent = hrp
		end)

		local hrp = char:WaitForChild("HumanoidRootPart")
		vel:Clone().Parent = hrp
	else
		if flingConn then flingConn:Disconnect() end
		for _, v in ipairs(plr.Character:GetDescendants()) do
			if v:IsA("BodyAngularVelocity") and v.Name == "FlingForce" then
				v:Destroy()
			end
		end
	end
end

-- // Coin Autofarm
local farming = false
local function toggleCoinFarm()
	farming = not farming
	spawn(function()
		while farming do
			for _, v in pairs(workspace:GetDescendants()) do
				if v.Name == "CoinContainer" then
					for _, coin in pairs(v:GetChildren()) do
						if coin:IsA("BasePart") then
							char:WaitForChild("HumanoidRootPart").CFrame = coin.CFrame + Vector3.new(0, 2, 0)
							wait(0.2)
						end
					end
				end
			end
			wait(1)
		end
	end)
end

-- // Buttons
createButton("WalkFling ON/OFF", toggleWalkFling)
createButton("TP to Murderer", function() tpToRole("Knife") end)
createButton("TP to Sheriff", function() tpToRole("Gun") end)
createButton("Money Collect ON/OFF", toggleCoinFarm)
createButton("ESP ON/OFF", toggleESP)
createButton("Random TP", randomTP)

-- // Close button
local close = createButton("❌ Close Menu", function()
	gui:Destroy()
end)
close.TextColor3 = Color3.fromRGB(255, 80, 80)
