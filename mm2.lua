-- MM2 GUI [clean + working] by ChatGPT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = function() return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart") end

-- GUI Setup
pcall(function() LocalPlayer.PlayerGui:FindFirstChild("MM2_GUI"):Destroy() end)
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "MM2_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 260)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 4)

local function makeButton(text, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.MouseButton1Click:Connect(callback)
end

-- ESP
local espEnabled = false
function toggleESP()
	espEnabled = not espEnabled
	if not espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("ESP_TAG") then
				p.Character.ESP_TAG:Destroy()
			end
		end
		RunService:UnbindFromRenderStep("MM2_ESP")
		return
	end

	RunService:BindToRenderStep("MM2_ESP", 200, function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				if not p.Character:FindFirstChild("ESP_TAG") then
					local tag = Instance.new("BillboardGui", p.Character)
					tag.Name = "ESP_TAG"
					tag.Adornee = p.Character.Head
					tag.Size = UDim2.new(0,100,0,40)
					tag.AlwaysOnTop = true

					local txt = Instance.new("TextLabel", tag)
					txt.Size = UDim2.new(1,0,1,0)
					txt.BackgroundTransparency = 1
					txt.TextStrokeTransparency = 0
					txt.TextScaled = true
					txt.Font = Enum.Font.SourceSansBold
					txt.Text = "PLAYER"
					txt.TextColor3 = Color3.fromRGB(255,255,255)

					if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
						txt.Text = "SHERIFF"
						txt.TextColor3 = Color3.fromRGB(0, 170, 255)
					elseif p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
						txt.Text = "MURDERER"
						txt.TextColor3 = Color3.fromRGB(255, 0, 0)
					end
				else
					local lbl = p.Character.ESP_TAG:FindFirstChildOfClass("TextLabel")
					if lbl then
						if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
							lbl.Text = "SHERIFF"
							lbl.TextColor3 = Color3.fromRGB(0,170,255)
						elseif p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
							lbl.Text = "MURDERER"
							lbl.TextColor3 = Color3.fromRGB(255,0,0)
						else
							lbl.Text = "PLAYER"
							lbl.TextColor3 = Color3.fromRGB(255,255,255)
						end
					end
				end
			end
		end
	end)
end

-- TP to role
local function tpToRole(item)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			if p.Backpack:FindFirstChild(item) or p.Character:FindFirstChild(item) then
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					Root().CFrame = hrp.CFrame + Vector3.new(0,2,0)
					break
				end
			end
		end
	end
end

-- Random TP
local function randomTP()
	local alive = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(alive, p)
		end
	end
	if #alive > 0 then
		local rand = alive[math.random(1, #alive)]
		Root().CFrame = rand.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	end
end

-- Coin Farm
local farmOn = false
function toggleFarm()
	farmOn = not farmOn
	if not farmOn then return end

	coroutine.wrap(function()
		while farmOn do
			local root = Root()
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and v.Name == "Coin" then
					root.CFrame = v.CFrame + Vector3.new(0,2,0)
					task.wait(0.1)
				end
			end
			task.wait(0.5)
		end
	end)()
end

-- Respawn Support
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	if espEnabled then toggleESP() toggleESP() end
	if farmOn then farmOn = false wait(0.2) toggleFarm() end
end)

-- Buttons
makeButton("TP to Murderer", function() tpToRole("Knife") end)
makeButton("TP to Sheriff", function() tpToRole("Gun") end)
makeButton("ESP ON/OFF", toggleESP)
makeButton("Coin Farm ON/OFF", toggleFarm)
makeButton("Random TP", randomTP)
makeButton("❌ Close", function() gui:Destroy() end)
