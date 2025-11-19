-- RAGE MOD Jail Break
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow("RAGE MOD", "v1.01.02")

-- Tabs
local MiscTab = Window:AddTab("Misc")
local VisualsTab = Window:AddTab("Visuals")

-- Misc Features
local Noclip = MiscTab:AddToggle("Noclip", {Text = "Noclip", Default = false})
local Fly = MiscTab:AddToggle("Fly", {Text = "Fly", Default = false})

-- Visuals Features
local ESP = VisualsTab:AddToggle("ESP", {Text = "3D ESP", Default = false})

-- Noclip
Noclip:OnChanged(function()
    if Noclip.Value then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Fly
Fly:OnChanged(function()
    if Fly.Value then
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0,0,0)
        BodyVelocity.MaxForce = Vector3.new(0,0,0)
        BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                BodyVelocity.Velocity = Vector3.new(0,50,0)
            end
        end)
    else
        if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
            LocalPlayer.Character.HumanoidRootPart.BodyVelocity:Destroy()
        end
    end
end)

-- ESP
ESP:OnChanged(function()
    if ESP.Value then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = player.Character
                
                if player.Team and player.Team.Name == "Criminals" then
                    Highlight.FillColor = Color3.fromRGB(255, 165, 0)
                    Highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
                else
                    Highlight.FillColor = Color3.fromRGB(0, 100, 255)
                    Highlight.OutlineColor = Color3.fromRGB(0, 80, 200)
                end
                
                Highlight.FillTransparency = 0.3
                Highlight.OutlineTransparency = 0
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local Highlight = player.Character:FindFirstChild("Highlight")
                if Highlight then
                    Highlight:Destroy()
                end
            end
        end
    end
end)
