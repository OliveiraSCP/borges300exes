-- ✅ FLY COM BOTÃO (Swift/Delta Executor)
-- Autor: MARBAS CREATOR
-- Oficial Kaynã (testes autorizados)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("HumanoidRootPart")

-- Configurações
local flying = false
local speed = 50

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local botao = Instance.new("TextButton")
botao.Size = UDim2.new(0, 120, 0, 50)
botao.Position = UDim2.new(0, 20, 0, 100)
botao.Text = "ATIVAR FLY"
botao.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
botao.TextColor3 = Color3.new(1, 1, 1)
botao.TextSize = 22
botao.Font = Enum.Font.GothamBold
botao.Parent = gui

-- Input
local UIS = game:GetService("UserInputService")
local direction = Vector3.zero

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if flying then
        if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then direction = Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then direction = Vector3.new(0,-1,0) end
    end
end)

UIS.InputEnded:Connect(function(input)
    if flying then
        direction = Vector3.zero
    end
end)

-- Loop de voo
game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        local cam = workspace.CurrentCamera.CFrame
        local move = cam:VectorToWorldSpace(direction)
        hum.Velocity = move * speed
    end
end)

-- Botão ativador
botao.MouseButton1Click:Connect(function()
    flying = not flying
    botao.Text = flying and "FLY: ON" or "ATIVAR FLY"
    botao.BackgroundColor3 = flying and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(0, 200, 0)
end)
