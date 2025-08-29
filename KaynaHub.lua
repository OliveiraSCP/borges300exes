--== Kaynã Hub Executor Version ==--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Variável pra guardar posição
getgenv().savedPosition = nil

-- Criando ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KaynaHubExecutor"
screenGui.Parent = CoreGui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Kaynã Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Função pra criar botão
local function createButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.Parent = frame
    return btn
end

-- Botões
local saveBtn = createButton("SAVE POSITION", UDim2.new(0.1,0,0.4,0))
local tpBtn = createButton("TP POSITION", UDim2.new(0.1,0,0.65,0))

-- Funções dos botões
saveBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        getgenv().savedPosition = LocalPlayer.Character.HumanoidRootPart.Position
        saveBtn.Text = "Position Saved!"
        wait(1)
        saveBtn.Text = "SAVE POSITION"
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if getgenv().savedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().savedPosition)
        tpBtn.Text = "Teleported!"
        wait(1)
        tpBtn.Text = "TP POSITION"
    end
end)
