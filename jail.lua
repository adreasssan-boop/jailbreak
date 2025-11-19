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
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
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

-- JailBreak ESP System (старая система)
local ESP = {
    Enabled = false,
    Boxes = {},
    CopsColor = Color3.new(0, 0.4, 1),     -- Синий для полиции
    CriminalsColor = Color3.new(1, 0.5, 0), -- Оранжевый для преступников
    MaxDistance = 500
}

-- Auto Arrest System
local AutoArrest = {
    Enabled = false,
    Target = nil,
    Arresting = false,
    ArrestDistance = 10
}

-- Aimbot System
local Aimbot = {
    Enabled = false,
    Target = nil,
    TeamCheck = true, -- Аиметь только на преступников
    Smoothness = 0.1,
    FOV = 50
}

-- Кнопки для Misc
local miscButtons = {
    {name = "Fly to Target", y = 15},
    {name = "Noclip", y = 60}
}

-- Кнопки для Visuals
local visualsButtons = {
    {name = "JailBreak ESP", y = 15},
    {name = "Aimbot", y = 60},
    {name = "Auto Arrest", y = 105}
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
        
        if btn.name == "Fly to Target" then
            toggleFlyToTarget(toggles[btn.name].enabled)
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
        elseif btn.name == "Aimbot" then
            toggleAimbot(toggles[btn.name].enabled)
        elseif btn.name == "Auto Arrest" then
            toggleAutoArrest(toggles[btn.name].enabled)
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

-- СТАРАЯ СИСТЕМА ESP (из предыдущего кода)
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
        print("JailBreak ESP включен (старая система)")
    else
        clearJailBreakESP()
        print("JailBreak ESP выключен")
    end
end

-- Aimbot System
function findAimbotTarget()
    local closestTarget = nil
    local closestDistance = Aimbot.FOV
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local mousePos = Vector2.new(0, 0)
    if UserInputService.MouseEnabled then
        mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local team = getPlayerTeam(player)
            
            -- Проверка команды для аимбота
            if Aimbot.TeamCheck and team ~= "Criminal" then
                continue
            end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                -- Проверка FOV
                local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mousePos - targetPos).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = player
                    end
                end
            end
        end
    end
    
    return closestTarget
end

function smoothAim(targetPosition)
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local currentCFrame = camera.CFrame
    local delta = (targetPosition - currentCFrame.Position).Unit
    local goalCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + delta)
    
    return currentCFrame:Lerp(goalCFrame, Aimbot.Smoothness)
end

function toggleAimbot(state)
    Aimbot.Enabled = state
    if state then
        print("Aimbot включен (только на преступников)")
    else
        Aimbot.Target = nil
        print("Aimbot выключен")
    end
end

-- Auto Arrest System
function findArrestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local team = getPlayerTeam(player)
            if team == "Criminal" then -- Арестовываем только преступников
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 then
                    local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = player
                    end
                end
            end
        end
    end
    
    return closestTarget, closestDistance
end

function performArrest(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    
    -- Симуляция ареста через различные методы
    local arrestMethods = {
        function()
            local character = LocalPlayer.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "cuff") or 
                       string.find(string.lower(tool.Name), "tazer") or 
                       string.find(string.lower(tool.Name), "arrest")) then
                        tool:Activate()
                        return true
                    end
                end
            end
            return false
        end,
        
        function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = targetRoot.CFrame
                return true
            end
            return false
        end,
        
        function()
            local success = pcall(function()
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (string.find(string.lower(obj.Name), "arrest") or 
                       string.find(string.lower(obj.Name), "cuff") or 
                       string.find(string.lower(obj.Name), "taze")) then
                        obj:FireServer(targetPlayer)
                        return true
                    end
                end
                return false
            end)
            return success
        end
    }
    
    for _, method in pairs(arrestMethods) do
        if method() then
            print("Арест выполнен: " .. targetPlayer.Name)
            return true
        end
    end
    
    return false
end

function toggleAutoArrest(state)
    AutoArrest.Enabled = state
    if state then
        print("Auto Arrest включен - поиск преступников...")
    else
        AutoArrest.Target = nil
        AutoArrest.Arresting = false
        print("Auto Arrest выключен")
    end
end

-- Fly to Target System
function toggleFlyToTarget(state)
    if state then
        local target, distance = findArrestTarget()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)
                print("Прилетели к: " .. target.Name)
            end
        else
            print("Преступники не найдены")
        end
        -- Автоматически выключаем после использования
        wait(0.1)
        toggles["Fly to Target"].enabled = false
        toggles["Fly to Target"].button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        toggles["Fly to Target"].button.Text = "Fly to Target [OFF]"
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
    
    -- Aimbot System
    if Aimbot.Enabled then
        Aimbot.Target = findAimbotTarget()
        if Aimbot.Target and Aimbot.Target.Character then
            local head = Aimbot.Target.Character:FindFirstChild("Head")
            if head then
                local camera = workspace.CurrentCamera
                local newCFrame = smoothAim(head.Position)
                camera.CFrame = newCFrame
            end
        end
    end
    
    -- Auto Arrest System
    if AutoArrest.Enabled and not AutoArrest.Arresting then
        local target, distance = findArrestTarget()
        if target and distance < 50 then
            AutoArrest.Target = target
            AutoArrest.Arresting = true
            
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                wait(0.5)
                
                if performArrest(target) then
                    print("Успешный арест: " .. target.Name)
                else
                    print("Не удалось арестовать: " .. target.Name)
                end
                
                AutoArrest.Arresting = false
                wait(1)
            end
        end
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
print("🎯 Aimbot - авто-прицеливание на преступников")
print("📏 ESP показывает: ник, дистанцию, команду")
print("🚓 Auto Arrest - автоматический арест")
print("⚡ Fly to Target - мгновенный полет к цели")
print("🎨 Settings - смена цвета меню")
