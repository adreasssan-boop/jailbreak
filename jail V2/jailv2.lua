-- RAGE MOD Jail Break Cheat
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "RAGE_MOD"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.BorderSizePixel = 0
Title.Text = "expensive hack"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Цвета меню
local MenuColors = {
    Color3.fromRGB(25, 25, 25),    -- Черный
    Color3.fromRGB(30, 30, 45),    -- Синий
    Color3.fromRGB(45, 30, 30),    -- Красный
    Color3.fromRGB(30, 45, 30),    -- Зеленый
    Color3.fromRGB(45, 45, 25),    -- Желтый
    Color3.fromRGB(45, 30, 45),    -- Фиолетовый
    Color3.fromRGB(25, 45, 45),    -- Бирюзовый
    Color3.fromRGB(45, 35, 25),    -- Оранжевый
    Color3.fromRGB(35, 35, 35)     -- Серый
}

local CurrentMenuColor = 1

-- Цвета ESP
local ESPColors = {
    Color3.fromRGB(128, 128, 128), -- Серый
    Color3.fromRGB(0, 0, 0),       -- Черный
    Color3.fromRGB(255, 0, 0),     -- Красный
    Color3.fromRGB(0, 100, 255)    -- Синий
}

local CurrentESPColor = 1

-- Перемещение меню
local Dragging = false
local DragInput, DragStart, StartPosition

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPosition = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPosition.X.Scale, 
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, 
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

-- Tabs
local TabButtons = {}
local TabFrames = {}
local CurrentTab = nil

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.33, 0, 0, 35)
    TabButton.Position = UDim2.new(0, #TabButtons * 167, 0, 45)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = MainFrame
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, -20, 1, -100)
    TabFrame.Position = UDim2.new(0, 10, 0, 90)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.Parent = MainFrame
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
        end
        
        TabFrame.Visible = true
        CurrentTab = TabFrame
    end)
    
    table.insert(TabButtons, TabButton)
    TabFrames[tabName] = TabFrame
    
    if #TabButtons == 1 then
        TabFrame.Visible = true
        CurrentTab = TabFrame
    end
    
    return TabFrame
end

-- Create Tabs
local MiscTab = CreateTab("Misc")
local VisualsTab = CreateTab("Visuals")
local SettingsTab = CreateTab("Settings")

-- Noclip Toggle
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -20, 0, 40)
NoclipToggle.Position = UDim2.new(0, 10, 0, 15)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NoclipToggle.BorderSizePixel = 0
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.Font = Enum.Font.Gotham
NoclipToggle.TextSize = 14
NoclipToggle.Parent = MiscTab

local NoclipConnection
local NoclipEnabled = false

NoclipToggle.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipToggle.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
    
    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
    end
end)

-- Fly Toggle
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1, -20, 0, 40)
FlyToggle.Position = UDim2.new(0, 10, 0, 65)
FlyToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FlyToggle.BorderSizePixel = 0
FlyToggle.Text = "Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.Font = Enum.Font.Gotham
FlyToggle.TextSize = 14
FlyToggle.Parent = MiscTab

local FlyEnabled = false
local BodyGyro, BodyVelocity
local FlySpeed = 50

FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyToggle.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
    
    if FlyEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            
            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.P = 1000
            BodyGyro.D = 50
            BodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            BodyGyro.CFrame = root.CFrame
            BodyGyro.Parent = root
            
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            BodyVelocity.Parent = root
            
            local function UpdateFly()
                if not FlyEnabled or not BodyVelocity then return end
                
                local velocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + root.CFrame.LookVector * FlySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - root.CFrame.LookVector * FlySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - root.CFrame.RightVector * FlySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + root.CFrame.RightVector * FlySpeed
                end
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, FlySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity - Vector3.new(0, FlySpeed, 0)
                end
                
                BodyVelocity.Velocity = velocity
            end
            
            RunService.Heartbeat:Connect(UpdateFly)
        end
    else
        if BodyGyro then
            BodyGyro:Destroy()
            BodyGyro = nil
        end
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end)

-- ESP Settings
local ESPMaxDistance = 500
local ESPEnabled = false
local ESPLabels = {}

-- ESP Distance Slider
local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Size = UDim2.new(1, -20, 0, 25)
DistanceLabel.Position = UDim2.new(0, 10, 0, 65)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.Text = "ESP Distance: " .. ESPMaxDistance .. "m"
DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceLabel.Font = Enum.Font.Gotham
DistanceLabel.TextSize = 12
DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
DistanceLabel.Parent = VisualsTab

local DistanceSlider = Instance.new("Frame")
DistanceSlider.Size = UDim2.new(1, -20, 0, 20)
DistanceSlider.Position = UDim2.new(0, 10, 0, 90)
DistanceSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DistanceSlider.BorderSizePixel = 0
DistanceSlider.Parent = VisualsTab

local DistanceFill = Instance.new("Frame")
DistanceFill.Size = UDim2.new(0.5, 0, 1, 0)
DistanceFill.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
DistanceFill.BorderSizePixel = 0
DistanceFill.Parent = DistanceSlider

local DistanceButton = Instance.new("TextButton")
DistanceButton.Size = UDim2.new(0, 10, 0, 25)
DistanceButton.Position = UDim2.new(0.5, -5, 0.5, -12)
DistanceButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
DistanceButton.BorderSizePixel = 0
DistanceButton.Text = ""
DistanceButton.Parent = DistanceSlider

-- ESP Color Selection
local ESPColorLabel = Instance.new("TextLabel")
ESPColorLabel.Size = UDim2.new(1, -20, 0, 25)
ESPColorLabel.Position = UDim2.new(0, 10, 0, 120)
ESPColorLabel.BackgroundTransparency = 1
ESPColorLabel.Text = "ESP Color: Gray"
ESPColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorLabel.Font = Enum.Font.Gotham
ESPColorLabel.TextSize = 12
ESPColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPColorLabel.Parent = VisualsTab

local ESPColorButtons = {}
local ESPColorNames = {"Gray", "Black", "Red", "Blue"}

for i = 1, 4 do
    local ESPColorButton = Instance.new("TextButton")
    ESPColorButton.Size = UDim2.new(0.22, -5, 0, 25)
    ESPColorButton.Position = UDim2.new((i-1) * 0.25, 10, 0, 145)
    ESPColorButton.BackgroundColor3 = ESPColors[i]
    ESPColorButton.BorderSizePixel = 0
    ESPColorButton.Text = ESPColorNames[i]
    ESPColorButton.TextColor3 = (i == 2) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    ESPColorButton.Font = Enum.Font.Gotham
    ESPColorButton.TextSize = 10
    ESPColorButton.Parent = VisualsTab
    
    ESPColorButton.MouseButton1Click:Connect(function()
        CurrentESPColor = i
        ESPColorLabel.Text = "ESP Color: " .. ESPColorNames[i]
        UpdateAllESPColors()
    end)
    
    table.insert(ESPColorButtons, ESPColorButton)
end

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 40)
ESPToggle.Position = UDim2.new(0, 10, 0, 15)
ESPToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 14
ESPToggle.Parent = VisualsTab

local function CreateESP(player, character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RAGE_ESP"
    billboard.Adornee = character.Head or character.HumanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = ESPMaxDistance
    
    -- HP Bar Background
    local hpBarBackground = Instance.new("Frame")
    hpBarBackground.Size = UDim2.new(1, 0, 0, 12)
    hpBarBackground.Position = UDim2.new(0, 0, 0, 0)
    hpBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    hpBarBackground.BorderSizePixel = 0
    hpBarBackground.Parent = billboard
    
    -- HP Bar Fill
    local hpBarFill = Instance.new("Frame")
    hpBarFill.Size = UDim2.new(1, 0, 1, 0)
    hpBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpBarFill.BorderSizePixel = 0
    hpBarFill.Parent = hpBarBackground
    
    -- Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = ESPColors[CurrentESPColor]
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = billboard
    
    -- Distance Label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 35)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = ESPColors[CurrentESPColor]
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Parent = billboard
    
    -- HP Text Label
    local hpLabel = Instance.new("TextLabel")
    hpLabel.Size = UDim2.new(1, 0, 0, 20)
    hpLabel.Position = UDim2.new(0, 0, 0, 55)
    hpLabel.BackgroundTransparency = 1
    hpLabel.TextColor3 = ESPColors[CurrentESPColor]
    hpLabel.TextStrokeTransparency = 0
    hpLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpLabel.Font = Enum.Font.Gotham
    hpLabel.TextSize = 11
    hpLabel.Parent = billboard
    
    billboard.Parent = character
    ESPLabels[player] = {
        Billboard = billboard,
        HPBar = hpBarFill,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        HPLabel = hpLabel
    }
    
    -- Функция обновления HP
    local function updateHP()
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local hp = humanoid.Health
            local maxHp = humanoid.MaxHealth
            local hpPercent = hp / maxHp
            
            hpBarFill.Size = UDim2.new(hpPercent, 0, 1, 0)
            
            -- Меняем цвет HP бара в зависимости от здоровья
            if hpPercent > 0.5 then
                hpBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый
            elseif hpPercent > 0.25 then
                hpBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Желтый
            else
                hpBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный
            end
            
            hpLabel.Text = "HP: " .. math.floor(hp) .. "/" .. math.floor(maxHp)
        else
            hpLabel.Text = "HP: N/A"
        end
    end
    
    -- Функция обновления дистанции
    local function updateDistance()
        if not character or not LocalPlayer.Character then return end
        if not character:FindFirstChild("HumanoidRootPart") then return end
        
        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
        distanceLabel.Text = math.floor(distance) .. "m"
        
        -- Автоматическое скрытие при превышении дистанции
        if distance > ESPMaxDistance then
            billboard.Enabled = false
        else
            billboard.Enabled = true
        end
    end
    
    -- Постоянное обновление
    RunService.Heartbeat:Connect(function()
        updateHP()
        updateDistance()
    end)
end

local function RemoveESP(player)
    if ESPLabels[player] then
        ESPLabels[player].Billboard:Destroy()
        ESPLabels[player] = nil
    end
end

local function UpdateAllESP()
    for player, espData in pairs(ESPLabels) do
        if player.Character and espData.Billboard.Parent == player.Character then
            if player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance > ESPMaxDistance then
                    espData.Billboard.Enabled = false
                else
                    espData.Billboard.Enabled = true
                end
            end
        else
            RemoveESP(player)
        end
    end
end

local function UpdateAllESPColors()
    for player, espData in pairs(ESPLabels) do
        if espData then
            espData.NameLabel.TextColor3 = ESPColors[CurrentESPColor]
            espData.DistanceLabel.TextColor3 = ESPColors[CurrentESPColor]
            espData.HPLabel.TextColor3 = ESPColors[CurrentESPColor]
        end
    end
end

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    
    if ESPEnabled then
        -- Удаляем старые ESP
        for player, _ in pairs(ESPLabels) do
            RemoveESP(player)
        end
        ESPLabels = {}
        
        -- Создаем ESP для всех игроков
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player, player.Character)
            end
        end
        
        -- Обработка новых игроков
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function(character)
                    if ESPEnabled then
                        wait(1)
                        CreateESP(player, character)
                    end
                end)
            end
        end)
        
        -- Обработка смены персонажа
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function(character)
                    if ESPEnabled then
                        wait(1)
                        CreateESP(player, character)
                    end
                end)
            end
        end
        
        -- Постоянное обновление ESP
        RunService.Heartbeat:Connect(UpdateAllESP)
        
    else
        -- Удаляем все ESP
        for player, _ in pairs(ESPLabels) do
            RemoveESP(player)
        end
        ESPLabels = {}
    end
end)

-- Slider Logic
local SliderDragging = false

DistanceButton.MouseButton1Down:Connect(function()
    SliderDragging = true
end)

UserInputService.InputChanged:Connect(function(input)
    if SliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = DistanceSlider.AbsolutePosition
        local sliderSize = DistanceSlider.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        ESPMaxDistance = math.floor(relativeX * 500)
        
        DistanceLabel.Text = "ESP Distance: " .. ESPMaxDistance .. "m"
        DistanceFill.Size = UDim2.new(relativeX, 0, 1, 0)
        DistanceButton.Position = UDim2.new(relativeX, -5, 0.5, -12)
        
        -- Обновляем MaxDistance для всех ESP
        for _, espData in pairs(ESPLabels) do
            espData.Billboard.MaxDistance = ESPMaxDistance
        end
        
        UpdateAllESP()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderDragging = false
    end
end)

-- Settings - Color Selection
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(1, -20, 0, 30)
ColorLabel.Position = UDim2.new(0, 10, 0, 15)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "Menu Color:"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.Font = Enum.Font.Gotham
ColorLabel.TextSize = 14
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.Parent = SettingsTab

local ColorButtons = {}
local ColorNames = {"Black", "Blue", "Red", "Green", "Yellow", "Purple", "Cyan", "Orange", "Gray"}

local function UpdateMenuColor(colorIndex)
    CurrentMenuColor = colorIndex
    MainFrame.BackgroundColor3 = MenuColors[colorIndex]
    
    -- Обновляем цвет заголовка (немного темнее основного)
    local titleColor = Color3.new(
        math.max(0, MenuColors[colorIndex].R - 0.05),
        math.max(0, MenuColors[colorIndex].G - 0.05),
        math.max(0, MenuColors[colorIndex].B - 0.05)
    )
    Title.BackgroundColor3 = titleColor
    
    -- Обновляем цвет вкладок
    for _, tab in pairs(TabButtons) do
        tab.BackgroundColor3 = Color3.new(
            math.max(0, MenuColors[colorIndex].R - 0.03),
            math.max(0, MenuColors[colorIndex].G - 0.03),
            math.max(0, MenuColors[colorIndex].B - 0.03)
        )
    end
end

for i = 1, 9 do
    local ColorButton = Instance.new("TextButton")
    ColorButton.Size = UDim2.new(0.3, -5, 0, 30)
    ColorButton.Position = UDim2.new(((i-1) % 3) * 0.33, 10, 0, 55 + math.floor((i-1) / 3) * 35)
    ColorButton.BackgroundColor3 = MenuColors[i]
    ColorButton.BorderSizePixel = 0
    ColorButton.Text = ColorNames[i]
    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorButton.Font = Enum.Font.Gotham
    ColorButton.TextSize = 11
    ColorButton.Parent = SettingsTab
    
    ColorButton.MouseButton1Click:Connect(function()
        UpdateMenuColor(i)
    end)
    
    table.insert(ColorButtons, ColorButton)
end

-- Button hover effects
local function SetupButtonHover(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
end

SetupButtonHover(NoclipToggle)
SetupButtonHover(FlyToggle)
SetupButtonHover(ESPToggle)

for _, tab in pairs(TabButtons) do
    SetupButtonHover(tab)
end

-- Open/Close menu with Insert key
local MenuVisible = true

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        Shadow.Visible = MenuVisible
    end
end)

-- Clean up
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui:Destroy()
    end
end)
