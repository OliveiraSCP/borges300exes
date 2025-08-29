repeat task.wait() until game:IsLoaded()

--== Configurações Gerais ==--
getgenv().Script_Mode = "BorgesHub_Script"
wait(2)

-- Webhook opcional
_G.Webhook  = {
    ['WebhookLink'] = 'COLE_SEU_LINK_AQUI',
    ['SendWebhookReward'] = true
}

-- Configurações do Hub
_G.SettingsBH = {
    ["AutoSavePosition"] = false,
    ["TeleportDelay"] = 0.5,
    ["EnableBlackScreen"] = true,
    ["SpeedMultiplier"] = 2
}

-- Variáveis globais
getgenv().SavedPosition = nil
getgenv().HubEnabled = false

-- Funções principais
getgenv().BorgesHub = {}

function getgenv().BorgesHub.SavePosition()
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        getgenv().SavedPosition = plr.Character.HumanoidRootPart.Position
        print("[BorgesHub] Position Saved!")
        if _G.Webhook.SendWebhookReward then
            print("[Webhook] Notificando posição salva...")
        end
    end
end

function getgenv().BorgesHub.TeleportPosition()
    local plr = game.Players.LocalPlayer
    if getgenv().SavedPosition and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        if _G.SettingsBH.EnableBlackScreen then
            local screen = Instance.new("Frame")
            screen.Size = UDim2.new(1,0,1,0)
            screen.BackgroundColor3 = Color3.fromRGB(0,0,0)
            screen.ZIndex = 9999
            screen.Parent = game:GetService("CoreGui")
            task.wait(0.1)
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().SavedPosition)
            task.wait(0.2)
            screen:Destroy()
        else
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().SavedPosition)
        end
        print("[BorgesHub] Teleported!")
        if _G.Webhook.SendWebhookReward then
            print("[Webhook] Notificando teleport...")
        end
    end
end

function getgenv().BorgesHub.ToggleHub()
    getgenv().HubEnabled = not getgenv().HubEnabled
    print("[BorgesHub] Hub " .. (getgenv().HubEnabled and "Enabled" or "Disabled"))
end

function getgenv().BorgesHub.SetSpeed(multiplier)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = 16 * (multiplier or _G.SettingsBH.SpeedMultiplier)
        print("[BorgesHub] Speed set to "..plr.Character.Humanoid.WalkSpeed)
    end
end

-- GUI mínima só pra toggle visual opcional
local CoreGui = game:GetService("CoreGui")
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
    getgenv().BorgesHub.ToggleHub()
end)

-- AutoSavePosition (se ativado)
if _G.SettingsBH.AutoSavePosition then
    task.spawn(function()
        while true do
            task.wait(5)
            getgenv().BorgesHub.SavePosition()
        end
    end)
end

print("[BorgesHub] Script Loaded! Use: BorgesHub.SavePosition(), BorgesHub.TeleportPosition(), BorgesHub.ToggleHub(), BorgesHub.SetSpeed()")
