-- ESP + Aimbot Mobile Delta Executor
-- Script pronto para testes autorizados

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuração
local ESPEnabled = true
local AimbotEnabled = false
local TeamCheck = true
local ESPColor = Color3.fromRGB(255,0,0)
local AimbotFOV = 50 -- pixels do centro da tela
local AimbotKey = Enum.KeyCode.E -- tecla para aimbot (Delta Mobile considera toque no centro)

-- GUI touch-friendly
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 150)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- ESP Toggle
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 200, 0, 50)
ESPButton.Position = UDim2.new(0, 10, 0, 10)
ESPButton.Text = "ESP: ON"
ESPButton.TextColor3 = Color3.fromRGB(255,255,255)
ESPButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
ESPButton.Parent = Frame

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPButton.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
end)

-- Aimbot Toggle
local AimButton = Instance.new("TextButton")
AimButton.Size = UDim2.new(0, 200, 0, 50)
AimButton.Position = UDim2.new(0, 10, 0, 70)
AimButton.Text = "Aimbot: OFF"
AimButton.TextColor3 = Color3.fromRGB(255,255,255)
AimButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
AimButton.Parent = Frame

AimButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimButton.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

-- Função ESP
local function createESP(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.Size = Vector3.new(2,5,1)
    box.Color3 = ESPColor
    box.Transparency = 0.5
    box.Parent = workspace

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not ESPEnabled or not player.Character or (TeamCheck and player.Team == LocalPlayer.Team) then
            box.Visible = false
        else
            box.Visible = true
            box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
        end
    end)

    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then
            conn:Disconnect()
            box:Destroy()
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)

-- Aimbot Mobile (centro da tela)
local function getClosestPlayerMobile()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closestPlayer = nil
    local shortestDistance = AimbotFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if TeamCheck and player.Team == LocalPlayer.Team then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Loop do aimbot
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayerMobile()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)
