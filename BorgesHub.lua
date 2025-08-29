local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

getgenv().savedPosition = nil

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BorgesHubExecutor"
screenGui.Parent = CoreGui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0.5, -160, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Parent = screenGui
frame.Visible = false

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0,0,0,0)
title.Text = "BorgesHub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Função criar botão
local function createButton(text,posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8,0,0,50)
    btn.Position = UDim2.new(0.1,0,posY,0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.Parent = frame
    return btn
end

-- Botões SAVE/TP
local saveBtn = createButton("SAVE POSITION",0.4)
local tpBtn = createButton("TP POSITION",0.65)

saveBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        getgenv().savedPosition = LocalPlayer.Character.HumanoidRootPart.Position
        saveBtn.Text = "Saved!"
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

-- Botão flutuante para abrir/esconder
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0,120,0,40)
toggleButton.Position = UDim2.new(0,20,0,20)
toggleButton.Text = "BorgesHub"
toggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Parent = CoreGui

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
