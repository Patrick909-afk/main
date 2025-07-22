-- C00lkid APOCALYPSE by @gde_patrick

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- Заменяем небо
local lighting = game:GetService("Lighting")
lighting.FogEnd = 100
lighting.FogColor = Color3.fromRGB(30, 0, 30)
lighting.Brightness = 0.5
lighting.ClockTime = 0
lighting.Ambient = Color3.fromRGB(0, 0, 0)
lighting.OutdoorAmbient = Color3.fromRGB(20, 0, 20)

local sky = Instance.new("Sky", lighting)
sky.SkyboxBk = "rbxassetid://159454299"
sky.SkyboxDn = "rbxassetid://159454296"
sky.SkyboxFt = "rbxassetid://159454293"
sky.SkyboxLf = "rbxassetid://159454286"
sky.SkyboxRt = "rbxassetid://159454300"
sky.SkyboxUp = "rbxassetid://159454288"

-- Звук ужаса
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://9125937434" -- страшная музыка
sound.Volume = 10
sound.Looped = true
sound:Play()

-- Тряска камеры
local run = game:GetService("RunService")
local cam = workspace.CurrentCamera
run.RenderStepped:Connect(function()
	cam.CFrame = cam.CFrame * CFrame.new(math.random(-1, 1)/15, math.random(-1, 1)/15, 0)
end)

-- Мигающий экран
spawn(function()
	while true do
		wait(0.2)
		local flash = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
		local frame = Instance.new("Frame", flash)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(1, 0, 0)
		frame.BackgroundTransparency = 0.7
		wait(0.1)
		flash:Destroy()
	end
end)

-- Спавн огня, дыма, c00lkid-клонов, голов, объектов
local function spawnChaos()
	-- Огонь и дым
	for i = 1, 5 do
		local part = Instance.new("Part", workspace)
		part.Anchored = false
		part.Size = Vector3.new(4, 1, 4)
		part.Position = hrp.Position + Vector3.new(math.random(-30, 30), 10, math.random(-30, 30))
		part.BrickColor = BrickColor.new("Really black")
		part.Material = Enum.Material.Neon
		part.CanCollide = true

		local fire = Instance.new("Fire", part)
		fire.Size = 10
		fire.Heat = 25

		local smoke = Instance.new("Smoke", part)
		smoke.Opacity = 0.5
		smoke.Size = 10
	end

	-- Клоны C00lkid
	for i = 1, 3 do
		local clone = char:Clone()
		clone.Parent = workspace
		clone.Name = "C00lkid"
		clone.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(math.random(-10, 10), 0, math.random(-10, 10))
		clone.HumanoidRootPart.Anchored = false
		pcall(function() clone.Head.face.Texture = "rbxassetid://7070700" end)
		pcall(function() clone.Shirt.ShirtTemplate = "rbxassetid://144076759" end)
		pcall(function() clone.Pants.PantsTemplate = "rbxassetid://144076760" end)
	end

	-- Летающие головы
	for i = 1, 3 do
		local head = Instance.new("Part", workspace)
		head.Size = Vector3.new(2, 2, 2)
		head.Shape = Enum.PartType.Ball
		head.Position = hrp.Position + Vector3.new(math.random(-20, 20), 10, math.random(-20, 20))
		head.BrickColor = BrickColor.new("Really red")
		head.Material = Enum.Material.SmoothPlastic
		head.Velocity = Vector3.new(math.random(-50, 50), math.random(20, 50), math.random(-50, 50))

		local decal = Instance.new("Decal", head)
		decal.Texture = "rbxassetid://7070700"
		decal.Face = Enum.NormalId.Front
	end

	-- Гром
	local thunder = Instance.new("Sound", workspace)
	thunder.SoundId = "rbxassetid://130767645"
	thunder.Volume = 10
	thunder:Play()

	-- Падающие объекты
	local object = Instance.new("Part", workspace)
	object.Size = Vector3.new(4, 4, 4)
	object.Position = hrp.Position + Vector3.new(math.random(-30, 30), 50, math.random(-30, 30))
	object.BrickColor = BrickColor.Random()
	object.Material = Enum.Material.CorrodedMetal
	object.Velocity = Vector3.new(0, -100, 0)
end

-- Запуск хаоса каждую секунду
while true do
	wait(1)
	spawnChaos()
end
