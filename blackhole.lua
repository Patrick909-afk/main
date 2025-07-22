-- Убедись, что этот скрипт запускается от имени сервера
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- Ужасное небо
Lighting.Sky = Instance.new("Sky", Lighting)
Lighting.Sky.SkyboxBk = "rbxassetid://159454299" -- страшное небо
Lighting.Sky.SkyboxDn = "rbxassetid://159454299"
Lighting.Sky.SkyboxFt = "rbxassetid://159454299"
Lighting.Sky.SkyboxLf = "rbxassetid://159454299"
Lighting.Sky.SkyboxRt = "rbxassetid://159454299"
Lighting.Sky.SkyboxUp = "rbxassetid://159454299"

Lighting.Ambient = Color3.fromRGB(20, 0, 0)
Lighting.FogColor = Color3.fromRGB(10, 0, 0)
Lighting.FogEnd = 100
Lighting.Brightness = 1

-- Жуткая музыка
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://133461261796019" -- страшный амбиент
sound.Looped = true
sound.Volume = 5
sound:Play()

-- C00lkid спам
local function spawnC00lkid()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			local clone = player.Character:Clone()
			clone.Humanoid.DisplayName = "C00lkid"
			clone.Parent = workspace
			clone:SetPrimaryPartCFrame(player.Character:GetPrimaryPartCFrame() * CFrame.new(math.random(-10,10), 0, math.random(-10,10)))
			for _, p in pairs(clone:GetDescendants()) do
				if p:IsA("BasePart") then
					p.BrickColor = BrickColor.new("Really red")
					p.Material = Enum.Material.Neon
					p.CanCollide = false
				end
			end
			Debris:AddItem(clone, 10)
		end
	end
end

-- Кровавые головы
local function spawnHeads()
	for _ = 1, 5 do
		local head = Instance.new("Part", workspace)
		head.Size = Vector3.new(2,2,2)
		head.Shape = Enum.PartType.Ball
		head.BrickColor = BrickColor.new("Really red")
		head.Material = Enum.Material.Fabric
		head.CFrame = CFrame.new(Vector3.new(math.random(-50,50), 50, math.random(-50,50)))
		head.Velocity = Vector3.new(0, -50, 0)
		head.Name = "BloodHead"
		Debris:AddItem(head, 10)
	end
end

-- Огненные эффекты
local function fireExplosion()
	local part = Instance.new("Part", workspace)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Position = Vector3.new(math.random(-30,30), 5, math.random(-30,30))

	local fire = Instance.new("Fire", part)
	fire.Heat = 10
	fire.Size = 10

	local smoke = Instance.new("Smoke", part)
	smoke.RiseVelocity = 5
	smoke.Size = 15

	Debris:AddItem(part, 8)
end

-- Молнии
local function lightning()
	local part = Instance.new("Part", workspace)
	part.Anchored = true
	part.CanCollide = false
	part.Size = Vector3.new(1, 30, 1)
	part.Material = Enum.Material.Neon
	part.BrickColor = BrickColor.new("White")
	part.Position = Vector3.new(math.random(-50, 50), 50, math.random(-50,50))
	Debris:AddItem(part, 0.2)
end

-- Главный цикл: ужас каждую секунду
while true do
	task.wait(1)
	local roll = math.random(1,6)
	if roll == 1 then
		spawnC00lkid()
	elseif roll == 2 then
		spawnHeads()
	elseif roll == 3 then
		fireExplosion()
	elseif roll == 4 then
		lightning()
	elseif roll == 5 then
		Lighting.FogEnd = math.random(50, 100)
	elseif roll == 6 then
		Lighting.Ambient = Color3.fromRGB(math.random(0,50), 0, 0)
	end
end
