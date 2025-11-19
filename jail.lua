-- Expensive JailBreak Hack v2
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Ждем игрока
if not LocalPlayer then
    LocalPlayer = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

-- Ждем загрузки персонажа
repeat wait(0.5) 
    print("Ожидание загрузки персонажа...")
until LocalPlayer.Character

print("JailBreak хак загружается...")

-- Удаляем старое меню если есть
if CoreGui:FindFirstChild("JailBreakHack") then
    CoreGui.JailBreakHack:Destroy()
end

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

-- СОЗДАЕМ МЕНЮ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "JailBreakHack"
ScreenGui.Enabled = true
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = MenuColors[1]
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "JailBreak Hack v2 - INSERT to Hide"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TopBar

-- Tabs
local Tabs = {"Misc", "Visuals", "Settings"}
local TabFrames = {}
local CurrentTab

for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.33, 0, 0, 30)
    TabButton.Position = UDim2.new((i-1) * 0.33, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 12
    TabButton.Parent = MainFrame
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, -20, 1, -90)
    TabFrame.Position = UDim2.new(0, 10, 0, 80)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = i == 1
    TabFrame.Parent = MainFrame
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        TabFrame.Visible = true
        CurrentTab = TabFrame
    end)
    
    TabFrames[tabName] = TabFrame
    if i == 1 then CurrentTab = TabFrame end
end

-- JailBreak ESP System
local ESP = {
    Enabled = false,
    Boxes = {},
    CopsColor = Color3.new(0, 0.4, 1),     -- Синий для полиции
    CriminalsColor = Color3.new(1, 0.5, 0), -- Оранжевый для преступников
    MaxDistance = 500
}

-- Fly System
local Fly = {
    Enabled = false,
    BodyGyro = nil,
    BodyVelocity = nil,
    Speed = 50
}

-- Кнопки для Misc
local miscButtons = {
    {name = "Fly", y = 15},
    {name = "Noclip", y = 60}
}

-- Кнопки для Visuals
local visualsButtons = {
    {name = "JailBreak ESP", y = 15}
}

local toggles = {}

-- Misc Tab
local MiscTab = TabFrames.Misc
for i, btn in pairs(miscButtons) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, btn.y)
    button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    button.BorderSizePixel = 0
    button.Text = btn.name .. " [OFF]"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Parent = MiscTab
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    toggles[btn.name] = {enabled = false, button = button}
    
    button.MouseButton1Click:Connect(function()
        toggles[btn.name].enabled = not toggles[btn.name].enabled
        if toggles[btn.name].enabled then
            button.BackgroundColor3 = Color3.new(0.8, 0, 0)
            button.Text = btn.name .. " [ON]"
        else
            button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            button.Text = btn.name .. " [OFF]"
        end
        
        if btn.name == "Fly" then
            toggleFly(toggles[btn.name].enabled)
        elseif btn.name == "Noclip" then
            toggleNoclip(toggles[btn.name].enabled)
        end
    end)
end

-- Visuals Tab
local VisualsTab = TabFrames.Visuals
for i, btn in pairs(visualsButtons) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, btn.y)
    button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    button.BorderSizePixel = 0
    button.Text = btn.name .. " [OFF]"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Parent = VisualsTab
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    toggles[btn.name] = {enabled = false, button = button}
    
    button.MouseButton1Click:Connect(function()
        toggles[btn.name].enabled = not toggles[btn.name].enabled
        if toggles[btn.name].enabled then
            button.BackgroundColor3 = Color3.new(0.8, 0, 0)
            button.Text = btn.name .. " [ON]"
        else
            button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            button.Text = btn.name .. " [OFF]"
        end
        
        if btn.name == "JailBreak ESP" then
            toggleJailBreakESP(toggles[btn.name].enabled)
        end
    end)
end

-- Settings Tab
local SettingsTab = TabFrames.Settings

-- Menu Color Selection
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(1, -20, 0, 25)
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
    TopBar.BackgroundColor3 = titleColor
end

for i = 1, 9 do
    local ColorButton = Instance.new("TextButton")
    ColorButton.Size = UDim2.new(0.3, -5, 0, 30)
    ColorButton.Position = UDim2.new(((i-1) % 3) * 0.33, 10, 0, 45 + math.floor((i-1) / 3) * 35)
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

-- Menu Toggle
local MenuToggle = Instance.new("TextButton")
MenuToggle.Size = UDim2.new(1, -20, 0, 35)
MenuToggle.Position = UDim2.new(0, 10, 0, 180)
MenuToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MenuToggle.BorderSizePixel = 0
MenuToggle.Text = "Hide Menu (Insert)"
MenuToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuToggle.Font = Enum.Font.Gotham
MenuToggle.TextSize = 12
MenuToggle.Parent = SettingsTab

-- Destroy Script
local DestroyToggle = Instance.new("TextButton")
DestroyToggle.Size = UDim2.new(1, -20, 0, 35)
DestroyToggle.Position = UDim2.new(0, 10, 0, 225)
DestroyToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyToggle.BorderSizePixel = 0
DestroyToggle.Text = "Destroy Script"
DestroyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyToggle.Font = Enum.Font.Gotham
DestroyToggle.TextSize = 12
DestroyToggle.Parent = SettingsTab

DestroyToggle.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Функция определения команды игрока
function getPlayerTeam(player)
    if player:FindFirstChild("Team") then
        return player.Team.Value
    elseif player:FindFirstChild("leaderstats") then
        local stats = player.leaderstats
        if stats:FindFirstChild("Wanted") or stats:FindFirstChild("Criminal") then
            return "Criminal"
        elseif stats:FindFirstChild("Arrests") or stats:FindFirstChild("Police") then
            return "Police"
        end
    end
    
    -- Альтернативные методы определения команды
    local character = player.Character
    if character then
        -- По униформе/одежде
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                local itemName = string.lower(item.Name)
                if string.find(itemName, "police") or string.find(itemName, "cop") or string.find(itemName, "guard") then
                    return "Police"
                elseif string.find(itemName, "criminal") or string.find(itemName, "prison") or string.find(itemName, " inmate") then
                    return "Criminal"
                end
            end
        end
    end
    
    return "Unknown"
end

-- ESP System
function createJailBreakESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    local team = getPlayerTeam(player)
    local espColor = ESP.CriminalsColor -- По умолчанию преступник
    
    if team == "Police" then
        espColor = ESP.CopsColor
    elseif team == "Criminal" then
        espColor = ESP.CriminalsColor
    else
        espColor = Color3.new(1, 1, 1) -- Белый для неизвестных
    end
    
    -- Создаем BillboardGui для ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "JailBreakESP"
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = ESP.MaxDistance
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = espColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = billboard
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = espColor
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Parent = billboard
    
    -- Team indicator
    local teamLabel = Instance.new("TextLabel")
    teamLabel.Size = UDim2.new(1, 0, 0, 20)
    teamLabel.Position = UDim2.new(0, 0, 0, -25)
    teamLabel.BackgroundTransparency = 1
    teamLabel.Text = "[" .. team .. "]"
    teamLabel.TextColor3 = espColor
    teamLabel.TextStrokeTransparency = 0
    teamLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    teamLabel.Font = Enum.Font.Gotham
    teamLabel.TextSize = 11
    teamLabel.Parent = billboard
    
    billboard.Parent = player.Character
    
    ESP.Boxes[player] = {
        Billboard = billboard,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        TeamLabel = teamLabel,
        Humanoid = humanoid,
        Team = team
    }
    
    updateJailBreakESPInfo(player)
end

function updateJailBreakESPInfo(player)
    if not ESP.Boxes[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    
    -- Обновляем дистанцию
    ESP.Boxes[player].DistanceLabel.Text = math.floor(distance) .. "m"
    
    -- Обновляем команду
    local currentTeam = getPlayerTeam(player)
    if ESP.Boxes[player].Team ~= currentTeam then
        ESP.Boxes[player].Team = currentTeam
        local newColor = currentTeam == "Police" and ESP.CopsColor or ESP.CriminalsColor
        ESP.Boxes[player].NameLabel.TextColor3 = newColor
        ESP.Boxes[player].DistanceLabel.TextColor3 = newColor
        ESP.Boxes[player].TeamLabel.TextColor3 = newColor
        ESP.Boxes[player].TeamLabel.Text = "[" .. currentTeam .. "]"
    end
    
    -- Обновляем видимость по дистанции
    ESP.Boxes[player].Billboard.Enabled = (distance <= ESP.MaxDistance)
end

function clearJailBreakESP()
    for player, boxData in pairs(ESP.Boxes) do
        if boxData.Billboard then 
            boxData.Billboard:Destroy() 
        end
    end
    ESP.Boxes = {}
end

function toggleJailBreakESP(state)
    ESP.Enabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createJailBreakESP(player)
            end
        end
        print("JailBreak ESP включен")
    else
        clearJailBreakESP()
        print("JailBreak ESP выключен")
    end
end

-- Fly System
function toggleFly(state)
    Fly.Enabled = state
    
    if state then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            
            -- Создаем BodyGyro для стабильности
            Fly.BodyGyro = Instance.new("BodyGyro")
            Fly.BodyGyro.P = 1000
            Fly.BodyGyro.D = 50
            Fly.BodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            Fly.BodyGyro.CFrame = root.CFrame
            Fly.BodyGyro.Parent = root
            
            -- Создаем BodyVelocity для движения
            Fly.BodyVelocity = Instance.new("BodyVelocity")
            Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            Fly.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            Fly.BodyVelocity.Parent = root
            
            print("Fly включен - используйте WASD для движения, Space/Shift для высоты")
        else
            print("Ошибка: персонаж не найден")
            toggles["Fly"].enabled = false
            toggles["Fly"].button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            toggles["Fly"].button.Text = "Fly [OFF]"
            return
        end
    else
        -- Удаляем BodyGyro и BodyVelocity
        if Fly.BodyGyro then
            Fly.BodyGyro:Destroy()
            Fly.BodyGyro = nil
        end
        if Fly.BodyVelocity then
            Fly.BodyVelocity:Destroy()
            Fly.BodyVelocity = nil
        end
        print("Fly выключен")
    end
end

-- Noclip функция
function toggleNoclip(state)
    toggles["Noclip"].enabled = state
    print("Noclip: " .. (state and "ON" or "OFF"))
end

-- Главный цикл
RunService.Heartbeat:Connect(function()
    -- Обновляем JailBreak ESP
    if ESP.Enabled then
        for player, boxData in pairs(ESP.Boxes) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                updateJailBreakESPInfo(player)
            else
                if boxData.Billboard then boxData.Billboard:Destroy() end
                ESP.Boxes[player] = nil
            end
        end
    end
    
    -- Fly System
    if Fly.Enabled and Fly.BodyVelocity then
        local root = LocalPlayer.Character.HumanoidRootPart
        local velocity = Vector3.new(0, 0, 0)
        
        -- WASD controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + root.CFrame.LookVector * Fly.Speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity - root.CFrame.LookVector * Fly.Speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity - root.CFrame.RightVector * Fly.Speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + root.CFrame.RightVector * Fly.Speed
        end
        
        -- Up/Down controls
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, Fly.Speed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity - Vector3.new(0, Fly.Speed, 0)
        end
        
        Fly.BodyVelocity.Velocity = velocity
    end
    
    -- Noclip
    if toggles["Noclip"] and toggles["Noclip"].enabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Авто-добавление ESP для новых игроков
Players.PlayerAdded:Connect(function(player)
    if ESP.Enabled then
        wait(2)
        createJailBreakESP(player)
    end
end)

-- Перетаскивание окна
local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Insert для скрытия/показа
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
        Title.Text = ScreenGui.Enabled and "JailBreak Hack v2 - INSERT to Hide" or "JailBreak Hack v2 - INSERT to Show"
    end
end)

-- Button hover effects
for _, tab in pairs(Tabs) do
    for _, button in pairs(TabFrames[tab]:GetChildren()) do
        if button:IsA("TextButton") then
            button.MouseEnter:Connect(function()
                if button.BackgroundColor3 ~= Color3.new(0.8, 0, 0) then
                    button.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
                end
            end)
            button.MouseLeave:Connect(function()
                if button.BackgroundColor3 ~= Color3.new(0.8, 0, 0) then
                    button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
                end
            end)
        end
    end
end

-- Сообщение об успехе
print("🎮 JailBreak Hack v2 Loaded!")
print("📝 Нажми INSERT чтобы скрыть/показать")
print("👮 ESP: Синий - полиция, Оранжевый - преступники")
print("📏 ESP показывает: ник, дистанцию, команду")
print("🕊️ Fly - полет на WASD + Space/Shift")
print("🎨 Settings - смена цвета меню")
