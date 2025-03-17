local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Evolvez1/Onetap/refs/heads/main/Onetap.lua')))()

local Window = OrionLib:MakeWindow({Name = "one<font color='rgb(224, 171, 3)'>tap</font> v1 Alpha", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/esp-library/main/library.lua"))()
local ItemESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evolvez1/Onetap/refs/heads/main/Item_ESP_Library"))()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

local Player_Visuals_Sectioon = Player_Visuals:AddSection({
    Name = "Player Visuals"
})

local World_Sectioon = World_Visuals:AddSection({
    Name = "World"
})

local World_VisualsColor_Sectioon = World_Sectioon:AddSection({
    Name = "Colors"
})

local Player_Chams_Sectioon = Player_Visuals:AddSection({
    Name = "Player Chams"
})

local Player_VisualsColor_Sectioon = Player_Visuals:AddSection({
    Name = "Colors"
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

World_Visuals_Sectioon:AddBind({
    Name = "Toggle Enable Items",
    Default = Enum.KeyCode.E,
    Hold = false,
    Callback = function()
        if isItemsEnabled then
            ItemESP.Enabled = not ItemESP.Enabled
        end
    end    
})

World_Visuals_Sectioon:AddToggle({
    Name = "Enable Items",
    Default = false,
    Callback = function(Enable_Players)
        isItemsEnabled = Enable_Players
        ItemESP.Enabled = Enable_Players
    end    
})

World_Visuals_Sectioon:AddToggle({
    Name = "Enable Name",
    Default = false,
    Callback = function(Enable_Name)
        ItemESP.ShowName = Enable_Name
    end    
})

World_Visuals_Sectioon:AddToggle({
    Name = "Enable Distance",
    Default = false,
    Callback = function(Enable_Distance)
        ItemESP.ShowDistance = Enable_Distance
    end   
})

World_Visuals_Sectioon:AddToggle({
    Name = "Enable Boxes",
    Default = false,
    Callback = function(Enable_Boxes)
        ItemESP.ShowBox = Enable_Boxes
    end   
})

World_Visuals_Sectioon:AddDropdown({
    Name = "Box Types",
    Default = "1",
    Options = {"2D", "Corner Box Esp"},
    Callback = function(SelectedBoxType)
        ItemESP.BoxType = SelectedBoxType
    end    
})

World_VisualsColor_Sectioon:AddColorpicker({
	Name = "Name Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(NameColorValue)
        ItemESP.NameColor = NameColorValue
	end	  
})

World_VisualsColor_Sectioon:AddColorpicker({
	Name = "Box Color",
	Default = Color3.fromRGB(224, 171, 3),
	Callback = function(BoxColorValue)
		ItemESP.BoxColor = BoxColorValue
        ItemESP.BoxOutlineColor = BoxColorValue
	end	  
})
