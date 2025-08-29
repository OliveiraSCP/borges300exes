repeat task.wait() until game:IsLoaded()

--== Configurações Gerais ==--
getgenv().Script_Mode = "BorgesHub_Script"
wait(5) -- Garantir execução completa

-- Webhook para notificações
_G.Webhook  = {
    ['WebhookLink'] = 'COLE_SEU_LINK_AQUI',
    ['SendWebhookReward'] = true -- Notificar quando teleportar ou salvar posição
}

-- Configurações do Hub
_G.SettingsBH = {
    ["AutoSavePosition"] = false,      -- Salvar posição automaticamente a cada X segundos
    ["TeleportDelay"] = 0.5,           -- Delay entre teleports (em segundos)
    ["EnableBlackScreen"] = true,      -- Tela preta ao teletransportar
    ["EquipBestItems"] = true,         -- Equipar melhor item disponível
    ["SpeedMultiplier"] = 2,           -- Velocidade do player multiplicada
    ["AutoLeaveAtWave"] = 50           -- Exemplo de função extra (se usar em jogo de waves)
}

-- Variáveis globais do Hub
getgenv().SavedPosition = nil
getgenv().HubEnabled = false

-- Funções do Hub
getgenv().BorgesHub = {}

function getgenv().BorgesHub.SavePosition()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        getgenv().SavedPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        print("[BorgesHub] Position Saved!")
        if _G.Webhook.SendWebhookReward then
            print("[Webhook] Notificando posição salva...")
            -- Aqui você pode adicionar envio real do webhook
        end
    end
end

function getgenv().BorgesHub.TeleportPosition()
    if getgenv().SavedPosition and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if _G.SettingsBH.EnableBlackScreen then
            local screen = Instance.new("Frame")
            screen.Size = UDim2.new(1,0,1,0)
            screen.BackgroundColor3 = Color3.fromRGB(0,0,0)
            screen.ZIndex = 9999
            screen.Parent = game:GetService("CoreGui")
            task.wait(0.1)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().SavedPosition)
            task.wait(0.2)
            screen:Destroy()
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(getgenv().SavedPosition)
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

-- Função extra: aumentar velocidade
function getgenv().BorgesHub.SetSpeed(multiplier)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 * (multiplier or _G.SettingsBH.SpeedMultiplier)
        print("[BorgesHub] Speed set to "..tostring(game.Players.LocalPlayer.Character.Humanoid.WalkSpeed))
    end
end

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
