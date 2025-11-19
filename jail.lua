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
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "RAGE MOD | JAIL BREAK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Tabs
local TabButtons = {}
local TabFrames = {}

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.5, 0, 0, 30)
    TabButton.Position = UDim2.new(0, #TabButtons * 225, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = MainFrame
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, -20, 1, -80)
    TabFrame.Position = UDim2.new(0, 10, 0, 80)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = #TabButtons == 0
    TabFrame.Parent = MainFrame
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        TabFrame.Visible = true
    end)
    
    table.insert(TabButtons, TabButton)
    TabFrames[tabName] = TabFrame
    return TabFrame
end

-- Create Tabs
local MiscTab = CreateTab("Misc")
local VisualsTab = CreateTab("Visuals")

-- Noclip Toggle
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -20, 0, 35)
NoclipToggle.Position = UDim2.new(0, 10, 0, 10)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
FlyToggle.Size = UDim2.new(1, -20, 0, 35)
FlyToggle.Position = UDim2.new(0, 10, 0, 55)
FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyToggle.BorderSizePixel = 0
FlyToggle.Text = "Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.Font = Enum.Font.Gotham
FlyToggle.TextSize = 14
FlyToggle.Parent = MiscTab

local FlyEnabled = false
local BodyVelocity

FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyToggle.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
    
    if FlyEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Space then
                    BodyVelocity.Velocity = Vector3.new(0, 50, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    BodyVelocity.Velocity = Vector3.new(0, -50, 0)
                end
            end)
        end
    else
        if BodyVelocity then
            BodyVelocity:Destroy()
        end
    end
end)

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 35)
ESPToggle.Position = UDim2.new(0, 10, 0, 10)
ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = "3D ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 14
ESPToggle.Parent = VisualsTab

local ESPEnabled = false
local ESPHighlights = {}

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "3D ESP: " .. (ESPEnabled and "ON" or "OFF")
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                AddESP(player)
            end
        end
        Players.PlayerAdded:Connect(AddESP)
    else
        for _, highlight in pairs(ESPHighlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        ESPHighlights = {}
    end
end)

function AddESP(player)
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "RAGE_ESP"
    highlight.Parent = player.Character
    
    if player.Team then
        if player.Team.Name:lower():find("criminal") then
            highlight.FillColor = Color3.fromRGB(255, 165, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
        else
            highlight.FillColor = Color3.fromRGB(0, 100, 255)
            highlight.OutlineColor = Color3.fromRGB(0, 80, 200)
        end
    end
    
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    ESPHighlights[player] = highlight
    
    player.CharacterAdded:Connect(function()
        wait(1)
        if ESPEnabled then
            AddESP(player)
        end
    end)
end

-- Button hover effects
local function SetupButtonHover(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
end

SetupButtonHover(NoclipToggle)
SetupButtonHover(FlyToggle)
SetupButtonHover(ESPToggle)

for _, tab in pairs(TabButtons) do
    SetupButtonHover(tab)
end
