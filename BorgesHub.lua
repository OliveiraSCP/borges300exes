--== BorgesHub Executor Version ==--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

getgenv().savedPosition = nil

-- Função pra criar GUI principal
local function createHub()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BorgesHubExecutor"
    screenGui.Parent = CoreGui

    -- Hub Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 220)
    frame.Position = UDim2.new(0.5, -160, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Parent = screenGui

    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,0)
    title.Text = "BorgesHub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true
    title.Parent = frame

    -- Função pra criar botão
    local function createButton(text, position)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.8,0,0,45)
        btn.Position = position
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSans
        btn.TextScaled = true
        btn.Parent = frame
        return btn
    end

    -- Botões do Hub
    local saveBtn = createButton("SAVE POSITION", UDim2.new(0.1,0,0.4,0))
    local tpBtn = createButton("TP POSITION", UDim2.new(0.1,0,0.6,0))

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

    -- Tornar frame arrastável
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return screenGui, frame
end

-- Criar Hub
local screenGui, frame = createHub()
frame.Visible = false -- começa escondido

-- Botão para mostrar/esconder o Hub
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "BorgesHub"
toggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Parent = CoreGui

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
