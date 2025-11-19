-- RAGE MOD Jail Break Cheat (Optimized)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.BorderSizePixel = 0
Title.Text = "expensive hack"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Menu Dragging
local Dragging, DragStart, StartPosition
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPosition = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- Tabs
local Tabs = {"Misc", "Visuals", "Settings"}
local TabFrames = {}
local CurrentTab

for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.33, 0, 0, 30)
    TabButton.Position = UDim2.new((i-1) * 0.33, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 12
    TabButton.Parent = MainFrame
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, -20, 1, -80)
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

-- Misc Features
local MiscTab = TabFrames.Misc

-- Noclip
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -20, 0, 35)
NoclipToggle.Position = UDim2.new(0, 10, 0, 15)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NoclipToggle.BorderSizePixel = 0
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.Font = Enum.Font.Gotham
NoclipToggle.TextSize = 12
NoclipToggle.Parent = MiscTab

local NoclipEnabled = false
NoclipToggle.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipToggle.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
    
    if NoclipEnabled then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Fly
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1, -20, 0, 35)
FlyToggle.Position = UDim2.new(0, 10, 0, 60)
FlyToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FlyToggle.BorderSizePixel = 0
FlyToggle.Text = "Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.Font = Enum.Font.Gotham
FlyToggle.TextSize = 12
FlyToggle.Parent = MiscTab

local FlyEnabled = false
FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyToggle.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
    
    if FlyEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character.HumanoidRootPart
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.P = 1000
        BodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        BodyGyro.CFrame = root.CFrame
        BodyGyro.Parent = root
        
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        BodyVelocity.Parent = root
        
        local function UpdateFly()
            if not FlyEnabled then return end
            local velocity = Vector3.new(0, 0, 0)
            local FlySpeed = 50
            
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
end)

-- Visuals Features
local VisualsTab = TabFrames.Visuals

-- ESP
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 35)
ESPToggle.Position = UDim2.new(0, 10, 0, 15)
ESPToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 12
ESPToggle.Parent = VisualsTab

local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 255, 255)
local ESPDistance = 500

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if ESPEnabled then
                    wait(1)
                    CreateESP(player)
                end
            end)
        end)
    else
        for _, gui in pairs(ScreenGui:GetChildren()) do
            if gui.Name == "ESP_" then
                gui:Destroy()
            end
        end
    end
end)

function CreateESP(player)
    if not player.Character then return end
    
    local espGui = Instance.new("BillboardGui")
    espGui.Name = "ESP_" .. player.Name
    espGui.Adornee = player.Character.Head
    espGui.Size = UDim2.new(0, 200, 0, 50)
    espGui.StudsOffset = Vector3.new(0, 3, 0)
    espGui.AlwaysOnTop = true
    espGui.MaxDistance = ESPDistance
    espGui.Parent = ScreenGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = ESPColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = espGui
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = ESPColor
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Parent = espGui
    
    -- Update distance
    RunService.Heartbeat:Connect(function()
        if player.Character and LocalPlayer.Character then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            distanceLabel.Text = math.floor(distance) .. "m"
            espGui.Enabled = distance <= ESPDistance
        end
    end)
end

-- Skeleton ESP
local SkeletonToggle = Instance.new("TextButton")
SkeletonToggle.Size = UDim2.new(1, -20, 0, 35)
SkeletonToggle.Position = UDim2.new(0, 10, 0, 60)
SkeletonToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SkeletonToggle.BorderSizePixel = 0
SkeletonToggle.Text = "Skeleton: OFF"
SkeletonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SkeletonToggle.Font = Enum.Font.Gotham
SkeletonToggle.TextSize = 12
SkeletonToggle.Parent = VisualsTab

local SkeletonEnabled = false
SkeletonToggle.MouseButton1Click:Connect(function()
    SkeletonEnabled = not SkeletonEnabled
    SkeletonToggle.Text = "Skeleton: " .. (SkeletonEnabled and "ON" or "OFF")
    
    if SkeletonEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateSkeleton(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local skeleton = player.Character:FindFirstChild("RAGE_SKELETON")
                if skeleton then
                    skeleton:Destroy()
                end
            end
        end
    end
end)

function CreateSkeleton(player)
    if not player.Character then return end
    
    local skeletonFolder = Instance.new("Folder")
    skeletonFolder.Name = "RAGE_SKELETON"
    skeletonFolder.Parent = player.Character
    
    local bones = {
        {"HumanoidRootPart", "LowerTorso"},
        {"LowerTorso", "UpperTorso"},
        {"UpperTorso", "Head"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"}
    }
    
    for _, bone in pairs(bones) do
        local part1 = player.Character:FindFirstChild(bone[1])
        local part2 = player.Character:FindFirstChild(bone[2])
        
        if part1 and part2 then
            local attachment1 = Instance.new("Attachment")
            local attachment2 = Instance.new("Attachment")
            local beam = Instance.new("Beam")
            
            attachment1.Parent = part1
            attachment2.Parent = part2
            
            beam.Attachment0 = attachment1
            beam.Attachment1 = attachment2
            beam.Color = ColorSequence.new(ESPColor)
            beam.Width0 = 0.1
            beam.Width1 = 0.1
            beam.Parent = skeletonFolder
        end
    end
end

-- Settings
local SettingsTab = TabFrames.Settings

-- Menu Toggle
local MenuToggle = Instance.new("TextButton")
MenuToggle.Size = UDim2.new(1, -20, 0, 35)
MenuToggle.Position = UDim2.new(0, 10, 0, 15)
MenuToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MenuToggle.BorderSizePixel = 0
MenuToggle.Text = "Hide Menu (Insert)"
MenuToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuToggle.Font = Enum.Font.Gotham
MenuToggle.TextSize = 12
MenuToggle.Parent = SettingsTab

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Destroy Script
local DestroyToggle = Instance.new("TextButton")
DestroyToggle.Size = UDim2.new(1, -20, 0, 35)
DestroyToggle.Position = UDim2.new(0, 10, 0, 60)
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

-- Simple button hover effect
for _, tab in pairs(Tabs) do
    for _, button in pairs(TabFrames[tab]:GetChildren()) do
        if button:IsA("TextButton") then
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end)
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end)
        end
    end
end
