local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Evolvez1/Onetap/refs/heads/main/Onetap.lua')))()

local Window = OrionLib:MakeWindow({Name = "one<font color='rgb(224, 171, 3)'>tap</font> v1 Alpha", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evolvez1/Onetap/refs/heads/main/Player_Esp_Library"))()
local ItemESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evolvez1/Onetap/refs/heads/main/Item_ESP_Library"))()

local Packets = require(game.ReplicatedStorage.Modules.Packets)
local ItemIDs = require(game.ReplicatedStorage.Modules.ItemIDS)
local GameUtil = require(game.ReplicatedStorage.Modules.GameUtil)
local ItemData = require(game.ReplicatedStorage.Modules.ItemData)
local anims = require(game.Players.LocalPlayer.PlayerScripts.src.Game.Animations)


local oldHitsoundID = "rbxassetid://609351621"
local hitSound = game.ReplicatedStorage.LocalSounds.Quicks.HitMarker

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PlayerFruits = {}

local BlacklistedItemsForFruits = {
    "Reinforced Chest",
    "Nest",
    "Fish Trap",
    "Chest",
    "Barley"
}

local AutohealEnabled = false
local AutohealFruit = "Bloodfruit"
local AutohealCPS = 18
local AutohealHealth = 50

local AutoEat_Enabled = false
local AutoEat_Threshold = 80
local AutoEat_Fruit = "Bloodfruit"
local Last_AutoEat = os.clock() - 30

local Auto_GoldFarm = false
local Auto_GoldPickup = false
local AutoTeleportGoldChestClose = false

local KillauraEnabled = false
local KillAuraHighlight = false
local KillauraDistance = 25

local GoldCFrames = {
    CFrame.new(911.979431, 7.25228977, -1419.3252, 0.996205986, 6.9248415e-08, 0.0870266706, -7.09935648e-08, 1, 1.69580456e-08, -0.0870266706, -2.30720385e-08, 0.9962059),
    CFrame.new(945.686523, 7.04348373, -1434.47449, 0.216310561, 3.49470568e-08, -0.976324677, -1.89225133e-08, 1, 3.16021094e-08, 0.976324677, 1.16386429e-08, 0.2163105),
    CFrame.new(964.500549, 6.7959342, -1391.35193, 0.965889454, 1.52734501e-08, -0.258954793, -1.985034e-08, 1, -1.50597153e-08, 0.258954793, 1.9686361e-08, 0.965889454),
    CFrame.new(920.278198, 7.00919914, -1387.68835, 0.45413065, -2.20037517e-08, 0.890935123, 7.18583024e-08, 1, -1.19305081e-08, -0.890935123, 6.94390891e-08, 0.454130)
}

for Name, Data in next, ItemData do
    if Data.growthTime ~= nil and not table.find(BlacklistedItemsForFruits, Name) then
        table.insert(PlayerFruits, Name)
    end
end

table.sort(PlayerFruits, function(a, b)
    return ItemData[a].nourishment.health > ItemData[b].nourishment.health
end)

local ChamSettings = {
    Enabled = false,
    TeamCheck = false,
    TeamColor = false,
    FillColor = Color3.fromRGB(255, 0, 0),
    OutlineColor = Color3.fromRGB(255, 255, 255),
    FillTransparency = 0.5,
    OutlineTransparency = 0,
    PulseEffect = false,
    XRay = false,
    RainbowEffect = false,
    PulseSpeed = 1,
    PulseIntensity = 0.5,
    Brightness = 1,
    Style = "Normal"
}

local ChamCache = {}

ESP.Enabled = false
ESP.ShowBox = false
ESP.BoxType = "Corner Box Esp"
ESP.ShowName = false
ESP.ShowHealth = false
ESP.ShowTracer = false
ESP.TracerThickness = 2
ESP.ShowDistance = false

ItemESP.Enabled = false
ItemESP.ShowBox = false
ItemESP.BoxType = "Corner Box Esp"
ItemESP.ShowName = false
ItemESP.ShowDistance = false

local Combat = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Healing = Window:MakeTab({
    Name = "Healing",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Farming = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GoldFarming = Window:MakeTab({
    Name = "Gold",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Player_Visuals = Window:MakeTab({
    Name = "Player Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local World_Visuals = Window:MakeTab({
    Name = "World Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local FourNodes = GoldFarming:AddSection({
    Name = "4 Gold Nodes"
})

local TweenGold = GoldFarming:AddSection({
    Name = "Tween Gold"
})

local Player_Visuals_Sectioon = Player_Visuals:AddSection({
    Name = "Player Visuals"
})

local World_Sectioon = World_Visuals:AddSection({
    Name = "World"
})

local Items_Sectioon = World_Visuals:AddSection({
    Name = "Items"
})

local Items_VisualsColor_Sectioon = World_Visuals:AddSection({
    Name = "Items Colors"
})

local Player_Chams_Sectioon = Player_Visuals:AddSection({
    Name = "Player Chams"
})

local Player_VisualsColor_Sectioon = Player_Visuals:AddSection({
    Name = "Colors"
})

local Farming_Plants_Sectioon = Farming:AddSection({
    Name = "Plants"
})

local Autoeat_section = Healing:AddSection({
    Name = "Autoeat"
})

local Autoheal_section = Healing:AddSection({
    Name = "Autoheal"
})

local HitSounds = Combat:AddSection({
    Name = "Hit Sounds"
})

local CombatSection = Combat:AddSection({
    Name = "Kill Aura"
})

local isPlayersEnabled = false

Player_Visuals_Sectioon:AddBind({
    Name = "Toggle Enable Players",
    Default = Enum.KeyCode.E,
    Hold = false,
    Callback = function()
        if isPlayersEnabled then
            ESP.Enabled = not ESP.Enabled
        end
    end    
})

Player_Visuals_Sectioon:AddToggle({
    Name = "Enable Players",
    Default = false,
    Callback = function(Enable_Players)
        isPlayersEnabled = Enable_Players
        ESP.Enabled = Enable_Players
    end    
})

Player_Visuals_Sectioon:AddToggle({
    Name = "Enable Name",
    Default = false,
    Callback = function(Enable_Name)
        ESP.ShowName = Enable_Name
    end    
})

Player_Visuals_Sectioon:AddToggle({
    Name = "Enable Distance",
    Default = false,
    Callback = function(Enable_Distance)
        ESP.ShowDistance = Enable_Distance
    end   
})

Player_Visuals_Sectioon:AddToggle({
    Name = "Enable Health",
    Default = false,
    Callback = function(Enable_Heath)
        ESP.ShowHealth = Enable_Heath
    end    
})

Player_Visuals_Sectioon:AddToggle({
    Name = "Enable Boxes",
    Default = false,
    Callback = function(Enable_Boxes)
        ESP.ShowBox = Enable_Boxes
    end   
})

Player_Visuals_Sectioon:AddDropdown({
    Name = "Box Types",
    Default = "1",
    Options = {"2D", "Corner Box Esp"},
    Callback = function(SelectedBoxType)
        ESP.BoxType = SelectedBoxType
        if (ESP.Enabled) then
            ESP.Enabled = false
            task.wait(0.1)
            ESP.Enabled = true
        end
    end    
})

Player_Visuals_Sectioon:AddToggle({
    Name = "Enable Skeleton",
    Default = false,
    Callback = function(Enable_Skeleton)
        ESP.ShowSkeletons = Enable_Skeleton
    end   
})

Player_VisualsColor_Sectioon:AddColorpicker({
	Name = "Name Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(NameColorValue)
        ESP.NameColor = NameColorValue
	end	  
})

Player_VisualsColor_Sectioon:AddColorpicker({
	Name = "Health Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(HealthColorValue)
		ESP.HealthHighColor = HealthColorValue
        ESP.HealthLowColor = HealthColorValue
        ESP.HealthOutlineColor = HealthColorValue
	end	  
})

Player_VisualsColor_Sectioon:AddColorpicker({
	Name = "Box Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(BoxColorValue)
		ESP.BoxColor = BoxColorValue
        ESP.BoxOutlineColor = BoxColorValue
	end	  
})

Player_VisualsColor_Sectioon:AddColorpicker({
	Name = "Skeleton Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(SkeletonColorValue)
		ESP.SkeletonsColor = SkeletonColorValue
	end	  
})

local function GetIndex(name)
    for index, data in next, GameUtil.GetData().inventory do
        if data.name == name then
            return index
        end
    end
end

local function CreateCham(part)
    local boxHandleAdornment = Instance.new("BoxHandleAdornment")
    boxHandleAdornment.Name = "Cham"
    boxHandleAdornment.AlwaysOnTop = true
    boxHandleAdornment.ZIndex = 10
    boxHandleAdornment.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
    boxHandleAdornment.Adornee = part
    boxHandleAdornment.Color3 = ChamSettings.FillColor
    boxHandleAdornment.Transparency = ChamSettings.FillTransparency
    boxHandleAdornment.Parent = part
    return boxHandleAdornment
end

local function ApplyChams(player)
    if not player.Character or player == LocalPlayer then return end
    
    if not ChamCache[player] then
        ChamCache[player] = {}
    end

    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local cham = CreateCham(part)
            table.insert(ChamCache[player], cham)
        end
    end
end

local function RemoveChams(player)
    if ChamCache[player] then
        for _, cham in pairs(ChamCache[player]) do
            cham:Destroy()
        end
        ChamCache[player] = nil
    end
end

Player_Chams_Sectioon:AddToggle({
    Name = "Enable Chams",
    Default = false,
    Callback = function(Enable_Chams)
        ChamSettings.Enabled = Enable_Chams
        if Enable_Chams then
            for _, player in ipairs(Players:GetPlayers()) do
                ApplyChams(player)
            end
        else
            for player, _ in pairs(ChamCache) do
                RemoveChams(player)
            end
        end
    end   
})

Player_Chams_Sectioon:AddToggle({
    Name = "Enable Pulse Effect",
    Default = false,
    Callback = function(Enable_ChamsPulseEffect)
        ChamSettings.PulseEffect = Enable_ChamsPulseEffect
    end   
})

Player_Chams_Sectioon:AddSlider({
	Name = "Pulse Speed",
	Min = 0.1,
	Max = 1,
	Default = 0.5,
	Color = Color3.fromRGB(224, 171, 3),
	Increment = 0.1,
	ValueName = "Pulse Speed",
	Callback = function(PulseIntensity_Value)
		ChamSettings.PulseIntensity = PulseIntensity_Value
	end    
})

Player_Chams_Sectioon:AddColorpicker({
	Name = "Chams Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(ChamsColorValue)
        ChamSettings.FillColor = ChamsColorValue
        for _, chams in pairs(ChamCache) do
            for _, cham in pairs(chams) do
                cham.Color3 = ChamsColorValue
            end
        end
	end	  
})

Player_Chams_Sectioon:AddToggle({
    Name = "Enable Rainbow Effect",
    Default = false,
    Callback = function(Enable_ChamsRainbowEffect)
        ChamSettings.RainbowEffect = Enable_ChamsRainbowEffect
    end   
})

RunService.RenderStepped:Connect(function()
    if ChamSettings.Enabled and ChamSettings.PulseEffect then
        local pulse = (math.sin(tick() * ChamSettings.PulseSpeed) + 1) / 2
        local transparency = ChamSettings.FillTransparency + (pulse * ChamSettings.PulseIntensity)
        
        for _, chams in pairs(ChamCache) do
            for _, cham in pairs(chams) do
                cham.Transparency = transparency
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if ChamSettings.Enabled and ChamSettings.RainbowEffect then
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        
        for _, chams in pairs(ChamCache) do
            for _, cham in pairs(chams) do
                cham.Color3 = color
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if ChamSettings.Enabled then
        player.CharacterAdded:Connect(function()
            ApplyChams(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveChams(player)
end)

local isItemsEnabled = false

Items_Sectioon:AddBind({
    Name = "Toggle Enable Items",
    Default = Enum.KeyCode.E,
    Hold = false,
    Callback = function()
        if isItemsEnabled then
            ItemESP.Enabled = not ItemESP.Enabled
        end
    end    
})

Items_Sectioon:AddToggle({
    Name = "Enable Items",
    Default = false,
    Callback = function(Enable_Players)
        isItemsEnabled = Enable_Players
        ItemESP.Enabled = Enable_Players
    end    
})

Items_Sectioon:AddToggle({
    Name = "Enable Name",
    Default = false,
    Callback = function(Enable_Name)
        ItemESP.ShowName = Enable_Name
    end    
})

Items_Sectioon:AddToggle({
    Name = "Enable Distance",
    Default = false,
    Callback = function(Enable_Distance)
        ItemESP.ShowDistance = Enable_Distance
    end   
})

Items_Sectioon:AddToggle({
    Name = "Enable Boxes",
    Default = false,
    Callback = function(Enable_Boxes)
        ItemESP.ShowBox = Enable_Boxes
    end   
})

Items_Sectioon:AddDropdown({
    Name = "Box Types",
    Default = "1",
    Options = {"2D", "Corner Box Esp"},
    Callback = function(SelectedBoxType)
        ItemESP.BoxType = SelectedBoxType
        if (ItemESP.Enabled) then
            ItemESP.Enabled = false
            task.wait(0.1)
            ItemESP.Enabled = true
        end
    end    
})

Items_VisualsColor_Sectioon:AddColorpicker({
	Name = "Name Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(NameColorValue)
        ItemESP.NameColor = NameColorValue
	end	  
})

Items_VisualsColor_Sectioon:AddColorpicker({
	Name = "Box Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(BoxColorValue)
		ItemESP.BoxColor = BoxColorValue
        ItemESP.BoxOutlineColor = BoxColorValue
	end	  
})

local hitSoundEnabled = false
local hitSoundNameList = {}

local soundIds = {
    ["skeet"] = "rbxassetid://5447626464",
    ["rust"] = "rbxassetid://5043539486",
    ["bag"] = "rbxassetid://364942410",
    ["baimware"] = "rbxassetid://6607339542",
    ["1nn"] = "rbxassetid://7349055654",
    ["Cod"] = "rbxassetid://131864673",
    ["Bonk"] = "rbxassetid://3765689841",
    ["cod"] = "rbxassetid://131864673",
    ["Semi"] = "rbxassetid://7791675603",
    ["osu"] = "rbxassetid://7149919358",
    ["Tf2"] = "rbxassetid://296102734",
    ["Tf2 pan"] = "rbxassetid://3431749479",
    ["M55solix"] = "rbxassetid://364942410",
    ["Slap"] = "rbxassetid://4888372697",
    ["1"] = "rbxassetid://7349055654",
    ["Minecraft"] = "rbxassetid://7273736372",
    ["jojo"] = "rbxassetid://6787514780",
    ["vibe"] = "rbxassetid://1848288500",
    ["supersmash"] = "rbxassetid://2039907664",
    ["epic"] = "rbxassetid://7344303740",
    ["retro"] = "rbxassetid://3466984142",
    ["quek"] = "rbxassetid://4868633804",
    ["dababy"] = "rbxassetid://6559380085",
    ["Welcome"] = "rbxassetid://5149595745",
}

for i,_ in soundIds do
    table.insert(hitSoundNameList, i)
end

HitSounds:AddToggle({
    Name = "Bow Hitsound",
    Default = false,
    Callback = function(v)
        hitSoundEnabled = v
    end    
})

local oinlyplayerhsitound = false

HitSounds:AddToggle({
    Name = "Only Players",
    Default = false,
    Callback = function(v)
        oinlyplayerhsitound = v
    end    
})

HitSounds:AddDropdown({
    Name = "Hitsound",
    Default = "skeet",
    Options = hitSoundNameList,
    Callback = function(selected)
        hitSound.SoundId = soundIds[selected]
    end    
})

local old = Packets.ProjectileImpact.send
Packets.ProjectileImpact.send = function(...)
    if not hitSoundEnabled then return end
    local args = {...}
    local pos = table.unpack(args)["position"]

    if oinlyplayerhsitound then
        for _, player in game.Players:GetPlayers() do
            local char = player.Character
            if char then
                local dist = (char:GetPivot().Position - pos).Magnitude
                if dist < 3 then
                    hitSound:Play()
                end
            end
        end
    else
        hitSound:Play()
    end
    
    old(...)
end

local AutoPlant = false
local AutoPlantFruit = "Bloodfruit"
local AutoHarvest = false

Farming_Plants_Sectioon:AddDropdown({
    Name = "AutoPlant Fruit",
    Default = "Bloodfruit",
    Options = PlayerFruits,
    Callback = function(selected)
        AutoPlantFruit = selected
    end    
})

Farming_Plants_Sectioon:AddToggle({
    Name = "AutoPlant",
    Default = false,
    Callback = function(v)
        AutoPlant = v
    end    
})

Farming_Plants_Sectioon:AddToggle({
    Name = "AutoHarvest",
    Default = false,
    Callback = function(v)
        AutoHarvest = v
    end    
})

local plantBoxes = {}

for _, box in workspace.Deployables:GetChildren() do
    if box.Name == "Plant Box" and not table.find(plantBoxes, box) then
        table.insert(plantBoxes, box)
    end
end

workspace.Deployables.ChildAdded:connect(function(box)
    if box.Name == "Plant Box" and not table.find(plantBoxes, box) then
        table.insert(plantBoxes, box)
    end
end)

workspace.Deployables.ChildRemoved:connect(function(box)
    if box.Name == "Plant Box" and table.find(plantBoxes, box) then
        local index = table.find(plantBoxes, box)
        table.remove(plantBoxes, index)
    end
end)

local plantBushes = {}
local possiblePlantPickups = {"bush", "tree", "patch", "cacti"}

local function findPlantNamePossibleInPossiblePlantPickups(name)
    for _,v in possiblePlantPickups do
        if string.find(string.lower(name), v) then
            return true
        end
    end
    return false
end

for _, bush in workspace:GetChildren() do
    if findPlantNamePossibleInPossiblePlantPickups(bush.Name) and not table.find(plantBushes, bush) then
        table.insert(plantBushes, bush)
    end
end

workspace.ChildAdded:connect(function(bush)
    if findPlantNamePossibleInPossiblePlantPickups(bush.Name) and not table.find(plantBushes, bush) then
        table.insert(plantBushes, bush)
    end
end)

workspace.ChildRemoved:connect(function(bush)
    if findPlantNamePossibleInPossiblePlantPickups(bush.Name) and table.find(plantBushes, bush) then
        local index = table.find(plantBushes, bush)
        table.remove(plantBushes, index)
    end
end)

local function getClosestPlantBox(checkPlant)
    local closest, distance = nil, 35

    for _, box in plantBoxes do
        if checkPlant then
            if box:FindFirstChild("Seed") then continue end
        end

        local dist = (box:GetPivot().Position - Players.LocalPlayer.Character:GetPivot().Position).Magnitude

        if dist < distance then
            closest = box
            distance = dist
        end
    end

    return closest, distance
end

local function getNearBushes()
    local bvuches = {}

    for _,v in plantBushes do
        if (v:GetPivot().Position - Players.LocalPlayer.Character:GetPivot().Position).Magnitude < 30 then
            table.insert(bvuches, v)
        end
    end

    return bvuches
end

local function plant(box, fruit)
    Packets.InteractStructure.send({["entityID"] = box:GetAttribute("EntityID"), ["itemID"] = ItemIDs[fruit]})
end

local function pickup(id)
    Packets.Pickup.send(id)
end

task.spawn(function()
    while task.wait() do
        if AutoPlant then
            local plantBox, boxDistance = getClosestPlantBox(true)

            if plantBox then
                plant(plantBox, AutoPlantFruit)
            end
        end

        if AutoHarvest then
            local bushes = getNearBushes()

            for _,bush in bushes do
                pickup(bush:GetAttribute("EntityID"))
            end
        end
    end
end)

local function fixItemName(name)
    for n, d in ItemData do
        if string.lower(n) == string.lower(name) then
            return n
        end
    end
    return nil
end

function FindClosestIce()
    local closest, distance = nil, 250

    for _,v in next, workspace.Resources:GetChildren() do
        if v.Name ~= "Ice Chunk" then continue end
        for _,loc in next, GoldCFrames do
            if (v:GetPivot().Position - loc.Position).Magnitude < 15 then
                local dist = (game.Players.LocalPlayer.Character:GetPivot().Position - loc.Position).Magnitude

                if dist < distance then
                    distance = dist
                    closest = v
                end
            end
        end
    end

    return closest, distance
end

function FindClosestGold()
    local closest, dist = nil, 150

    for _,v in workspace:GetChildren() do
        if v.Name == "Gold Node" then
            local distance = (LocalPlayer.Character:GetPivot().Position - v:GetPivot().Position).Magnitude

            if distance < dist then
                closest = v
                dist = distance
            end
        end
    end

    return closest, dist
end

local chests = {}

for _,v in workspace.Deployables:GetChildren() do
    if (v.Name == "Chest" or v.Name == "Reinforced Chest") then
        table.insert(chests, v)
    end
end

workspace.Deployables.ChildAdded:Connect(function(d)
    if d.Name == "Chest" or d.Name == "Reinforced Chest" then
        table.insert(chests, d)
    end
end)

workspace.Deployables.ChildRemoved:Connect(function(d)
    if d.Name == "Chest" or d.Name == "Reinforced Chest" and table.find(chests, d) then
        table.remove(chests, table.find(chests, d))
    end
end)

local function getClosestChest()
    local closest, dist = nil, math.huge

    for _,v in workspace.Deployables:GetChildren() do
        if v.Name == "Chest" or v.Name == "Reinforced Chest" then
            local distance = (LocalPlayer.Character:GetPivot().Position - v:GetPivot().Position).Magnitude

            if distance < dist then
                closest = v
                dist = distance
            end
        end
    end

    return closest
end

local presses = {}

for _,v in workspace.Deployables:GetChildren() do
    if v.Name == "Coin Press" then
        table.insert(presses, v)
    end
end

workspace.Deployables.ChildAdded:Connect(function(d)
    if d.Name == "Coin Press" then
        table.insert(presses, d)
    end
end)

workspace.Deployables.ChildRemoved:Connect(function(d)
    if d.Name == "Coin Press" and table.find(presses, d) then
        table.remove(presses, table.find(presses, d))
    end
end)

local function getClosestPress()
    local closest, dist = nil, 35

    for _, v in presses do
        if v.Name == "Coin Press" then
            local d = (v:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude

            if d < dist then
                closest = v
                dist = d
            end
        end
    end

    return closest, dist
end

local function getClosestChest()
    local closest, dist = nil, 35

    for _, v in workspace.Deployables:GetChildren() do
        if v.Name == "Chest" or v.Name == "Reinforced Chest" then
            local d = (v:GetPivot().Position - game.Players.LocalPlayer.Character:GetPivot().Position).Magnitude

            if d < dist then
                closest = v
                dist = d
            end
        end
    end

    return closest, dist
end

Autoheal_section:AddToggle({
    Name = "Autoheal",
    Default = false,
    Callback = function(AutohealEnabled_Value)
        AutohealEnabled = AutohealEnabled_Value
    end    
})

Autoheal_section:AddDropdown({
    Name = "Autoheal Fruit",
    Default = "Bloodfruit", 
    Options = PlayerFruits,
    Callback = function(AutohealFruit_Value)
        AutohealFruit = AutohealFruit_Value
        -- print("Selected Autoheal Fruit: " .. AutohealFruit)
    end    
})

Autoheal_section:AddSlider({
	Name = "Autoheal Health",
	Min = 1,
	Max = 100,
	Default = 82,
	Color = Color3.fromRGB(224, 171, 3),
	Increment = 1,
	ValueName = "AutoHeal Health",
	Callback = function(AutohealHealth_Value)
        AutohealHealth = tonumber(AutohealHealth_Value)
	end    
})

Autoheal_section:AddSlider({
	Name = "Autoheal CPS",
	Min = 5,
	Max = 100,
	Default = 18,
	Color = Color3.fromRGB(224, 171, 3),
	Increment = 1,
	ValueName = "AutoHeal CPS",
	Callback = function(AutohealCPS_Value)
        AutohealCPS = tonumber(AutohealCPS_Value)
	end    
})

Autoeat_section:AddToggle({
    Name = "Autoeat",
    Default = false,
    Callback = function(AutoEat_Enabled_Value)
        AutoEat_Enabled = AutoEat_Enabled_Value
    end    
})

Autoeat_section:AddDropdown({
    Name = "Autoeat Fruit",
    Default = "Bloodfruit", 
    Options = PlayerFruits,
    Callback = function(AutoEat_FruitValue)
        AutoEat_Fruit = AutoEat_FruitValue
        -- print("Selected Autoheal Fruit: " .. AutohealFruit)
    end    
})

Autoeat_section:AddSlider({
	Name = "Autoeat Threshold",
	Min = 1,
	Max = 100,
	Default = 80,
	Color = Color3.fromRGB(224, 171, 3),
	Increment = 1,
	ValueName = "Autoeat Threshold",
	Callback = function(AutoEat_ThresholdValue)
        AutoEat_Threshold = tonumber(AutoEat_ThresholdValue)
	end    
})

CombatSection:AddToggle({
    Name = "Enable Kill-Aura",
    Default = false,
    Callback = function(KillauraEnabled_Value)
        KillauraEnabled = KillauraEnabled_Value
    end    
})

CombatSection:AddSlider({
	Name = "Kill-Aura Distance",
	Min = 5,
	Max = 35,
	Default = 10,
	Color = Color3.fromRGB(224, 171, 3),
	Increment = 1,
	ValueName = "Killaura Distance",
	Callback = function(KillauraDistance_Value)
        KillauraDistance = tonumber(KillauraDistance_Value)
	end    
})

task.spawn(function()
    while task.wait(1/AutohealCPS) do
        if AutohealEnabled and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            if hum.Health > AutohealHealth then continue end

            local index = GetIndex(AutohealFruit)

            if index ~= nil then
                Packets.UseBagItem.send(index)
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if not AutoEat_Enabled or os.clock() - Last_AutoEat < 3 then continue end

        if GameUtil.GetData().stats.food < AutoEat_Threshold then
            local index = GetIndex(AutoEat_Fruit)

            local food_gain = ItemData[AutoEat_Fruit].nourishment.food
            local gained = 0

            for i = 1, 100 do
                gained += 1
                if GameUtil.GetData().stats.food + (gained * food_gain) >= 100 then
                    break
                end
            end

            if index ~= nil then
                for i = 1, gained do
                    Packets.UseBagItem.send(index)
                end
                Last_AutoEat = os.clock()
            end
        end
    end
end)

local function getClosestPlayer()
    local closest, distance = nil, tonumber(KillauraDistance)

    for _, p in game.Players:GetPlayers() do
        if p == LocalPlayer then continue end
        local char = p.Character

        if char and LocalPlayer.Character then
            local dist = (char:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude

            if dist < distance then
                closest = p
                distance = dist
            end
        end
    end

    return closest
end

task.spawn(function()
    while task.wait(1/3) do
        if KillauraEnabled then
            local player = getClosestPlayer()

            if player and GameUtil.GetData().equipped ~= nil then
                Packets.SwingTool.send({player.Character:GetAttribute("EntityID")})
                anims.playAnimation("Slash")
            end
        end
    end
end)

FourNodes:AddToggle({
    Name = "Enable Gold Farm",
    Default = false,
    Callback = function(Auto_GoldFarm_Value)
        Auto_GoldFarm = Auto_GoldFarm_Value
    end    
})

FourNodes:AddToggle({
    Name = "Enable Teleport Gold To Chest",
    Default = false,
    Callback = function(AutoTeleportGoldChestClose_Value)
        AutoTeleportGoldChestClose = AutoTeleportGoldChestClose_Value
    end    
})

FourNodes:AddToggle({
    Name = "Enable Auto-Pickup Gold",
    Default = false,
    Callback = function(Auto_GoldPickup_Value)
        Auto_GoldPickup = Auto_GoldPickup_Value
    end    
})

task.spawn(function()
    while task.wait(.1) do
        if AutoTeleportGoldChestClose then
            for _, item in workspace.Items:GetChildren() do
                if item.Name == "Raw Gold" then
                    local closestChest = getClosestChest()

                    if closestChest then
                        Packets.ForceInteract.send(item:GetAttribute("EntityID"))
                        item:PivotTo(closestChest:GetPivot() * CFrame.new(0, 2, 0))
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
	task.wait()
        if Auto_GoldPickup then
            for _, item in workspace.Items:GetChildren() do
                if item.Name == "Raw Gold" or item.Name == "Gold Bar" then
                    for i = 1, 100 do
                        Packets.Pickup.send(item:GetAttribute("EntityID"))
                    end
                end
            end
        end
     end
end)

local p = OverlapParams.new()
p.FilterType = Enum.RaycastFilterType.Include
p.FilterDescendantsInstances = {workspace.Deployables}

task.spawn(function()
    while task.wait() do
        if Auto_GoldFarm then

            local gold, dist = FindClosestGold()

            if gold then
                if gold then
                    local ti = TweenInfo.new(dist/16, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

                    p.Position = LocalPlayer.Character:GetPivot().Position + Vector3.new(0, 4, 0)
                    local tween = game:GetService("TweenService"):Create(p, ti, {Position = gold:GetPivot().Position + Vector3.new(0, 1, 0)})
                    tween:Play()
    
                    con = p:GetPropertyChangedSignal("Position"):Connect(function()
                        LocalPlayer.Character:PivotTo(p:GetPivot())
                    end)
    
                    tween.Completed:Wait()
                    con:Disconnect()

                    local t = os.clock()

                    local size = 6
                    local buff = buffer.create(size)
                    local offset = 0
                    buffer.writeu32(buff, offset, gold:GetAttribute("EntityID"))
                    offset = offset + 4
                    buffer.writeu16(buff, offset, offset / 4)
                    offset = offset + 2
                    local sendBuff = buffer.create(offset)
                    buffer.copy(sendBuff, 0, buff, 0, offset)

                    repeat Packets.SwingTool.send(sendBuff) task.wait(1/3) until
                    gold == nil or gold.Parent == nil or gold.PrimaryPart == nil or gold:FindFirstChild("Health") == nil or gold.Health.Value <= 0 or os.clock() - t > 10
                end
            else
                local ice, dist = FindClosestIce()
                
                if ice then
                local ti = TweenInfo.new(dist/16, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

                p.Position = LocalPlayer.Character:GetPivot().Position + Vector3.new(0, 4, 0)
                local tween = game:GetService("TweenService"):Create(p, ti, {Position = ice:GetPivot().Position})
                tween:Play()

                con = p:GetPropertyChangedSignal("Position"):Connect(function()
                    LocalPlayer.Character:PivotTo(p:GetPivot())
                end)

                ice:FindFirstChild("Ice").CanCollide = false

                tween.Completed:Wait()
                con:Disconnect()

                LocalPlayer.Character.PrimaryPart.Anchored = true

                local t = os.clock()

                local size = 6
                local buff = buffer.create(size)
                local offset = 0
                buffer.writeu32(buff, offset, ice:GetAttribute("EntityID"))
                offset = offset + 4
                buffer.writeu16(buff, offset, offset / 4)
                offset = offset + 2
                local sendBuff = buffer.create(offset)
                buffer.copy(sendBuff, 0, buff, 0, offset)

                repeat Packets.SwingTool.send(sendBuff) task.wait(1/3) until
                ice == nil or ice.Parent == nil or ice.PrimaryPart == nil or ice:FindFirstChild("Health") == nil or ice.Health.Value <= 0 or LocalPlayer.Character.PrimaryPart.Anchored == false or os.clock() - t >= 10

                task.wait(.1)

                local gold = FindClosestGold()

                local t = os.clock()

                if gold then

                    local size = 6
                    local buff = buffer.create(size)
                    local offset = 0
                    buffer.writeu32(buff, offset, gold:GetAttribute("EntityID"))
                    offset = offset + 4
                    buffer.writeu16(buff, offset, offset / 4)
                    offset = offset + 2
                    local sendBuff = buffer.create(offset)
                    buffer.copy(sendBuff, 0, buff, 0, offset)

                    repeat Packets.SwingTool.send(sendBuff) task.wait(1/3) until
                    gold == nil or gold.Parent == nil or gold.PrimaryPart == nil or gold:FindFirstChild("Health") == nil or gold.Health.Value <= 0 or LocalPlayer.Character.PrimaryPart.Anchored == false or os.clock() - t > 10
                end

                LocalPlayer.Character.PrimaryPart.Anchored = false
                end
            end
        else
            LocalPlayer.Character.PrimaryPart.Anchored = false
            if con then
                con:Disconnect()
            end
        end
    end
end)
