local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// CONFIGURACIÓN
local Config = {
    Enabled = true,
    FOV = 120,
    MinFOV = 30,
    MaxFOV = 250,
    TeamCheck = true,
    Smoothness = 0.1,
    CloseRange = 70,
    MaxDistance = 999999,
}

--// COLORES
local COLORS = {
    OFF = Color3.fromRGB(80, 80, 80),
    NO_TARGET = Color3.fromRGB(255, 50, 50),
    FAR_TARGET = Color3.fromRGB(255, 150, 0),
    CLEAR = Color3.fromRGB(0, 255, 100),
}

local Target = nil
local TargetStatus = "NONE"
local TargetDistance = 0
local TargetPriority = nil
local AimPartName = "Head"
local MenuOpen = false

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotV3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

--// FOV CIRCLE
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = false
FOV_Circle.Thickness = 2
FOV_Circle.NumSides = 64
FOV_Circle.Radius = Config.FOV
FOV_Circle.Filled = false
FOV_Circle.Transparency = 0.9
FOV_Circle.Color = COLORS.NO_TARGET

--// MENÚ COMPACTO
local MenuContainer = Instance.new("Frame")
MenuContainer.Size = UDim2.new(0, 220, 0, 220)
MenuContainer.Position = UDim2.new(0, 10, 0, 30)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Parent = ScreenGui

local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(1, 0, 0, 45)
Menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Menu.ClipsDescendants = true
Menu.Parent = MenuContainer

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = Menu

--// HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.Parent = Menu

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AIMBOT V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 12, 0, 12)
StatusDot.Position = UDim2.new(1, -70, 0.5, -6)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = Header

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(0.5, 0)
DotCorner.Parent = StatusDot

local ExpandBtn = Instance.new("TextButton")
ExpandBtn.Size = UDim2.new(0, 38, 0, 38)
ExpandBtn.Position = UDim2.new(1, -45, 0, 3)
ExpandBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExpandBtn.Text = "▼"
ExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandBtn.TextSize = 20
ExpandBtn.Font = Enum.Font.GothamBold
ExpandBtn.Parent = Header

local ExpandCorner = Instance.new("UICorner")
ExpandCorner.CornerRadius = UDim.new(0, 8)
ExpandCorner.Parent = ExpandBtn

--// CONTENIDO
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -55)
Content.Position = UDim2.new(0, 8, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Menu

--// TOGGLE
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleFrame.Parent = Content

local TF_Corner = Instance.new("UICorner")
TF_Corner.CornerRadius = UDim.new(0, 8)
TF_Corner.Parent = ToggleFrame

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(0.5, 0, 1, 0)
ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Auto Aim"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.TextSize = 14
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleBtn.Position = UDim2.new(1, -80, 0.5, -15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
ToggleBtn.Text = "ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ToggleFrame

local TB_Corner = Instance.new("UICorner")
TB_Corner.CornerRadius = UDim.new(0, 6)
TB_Corner.Parent = ToggleBtn

--// FOV CONTROL
local FOVFrame = Instance.new("Frame")
FOVFrame.Size = UDim2.new(1, 0, 0, 65)
FOVFrame.Position = UDim2.new(0, 0, 0, 48)
FOVFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FOVFrame.Parent = Content

local FV_Corner = Instance.new("UICorner")
FV_Corner.CornerRadius = UDim.new(0, 8)
FV_Corner.Parent = FOVFrame

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 20)
FOVLabel.Position = UDim2.new(0, 10, 0, 6)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: " .. Config.FOV
FOVLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FOVLabel.TextSize = 12
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = FOVFrame

local FOVInput = Instance.new("TextBox")
FOVInput.Size = UDim2.new(0, 70, 0, 28)
FOVInput.Position = UDim2.new(0, 10, 0, 32)
FOVInput.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FOVInput.Text = tostring(Config.FOV)
FOVInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVInput.TextSize = 16
FOVInput.Font = Enum.Font.GothamBold
FOVInput.ClearTextOnFocus = true
FOVInput.Parent = FOVFrame

local FI_Corner = Instance.new("UICorner")
FI_Corner.CornerRadius = UDim.new(0, 6)
FI_Corner.Parent = FOVInput

--// BOTONES RÁPIDOS
local QuickFrame = Instance.new("Frame")
QuickFrame.Size = UDim2.new(0, 110, 0, 28)
QuickFrame.Position = UDim2.new(0, 90, 0, 32)
QuickFrame.BackgroundTransparency = 1
QuickFrame.Parent = FOVFrame

local function MakeMiniBtn(text, pos, val, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 32, 0, 28)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = QuickFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config.FOV = val
        FOVInput.Text = tostring(val)
        FOVLabel.Text = "FOV: " .. val
        FOV_Circle.Radius = val
    end)
end

MakeMiniBtn("S", UDim2.new(0, 0, 0, 0), 60, Color3.fromRGB(0, 100, 150))
MakeMiniBtn("M", UDim2.new(0, 37, 0, 0), 120, Color3.fromRGB(0, 150, 80))
MakeMiniBtn("L", UDim2.new(0, 74, 0, 0), 200, Color3.fromRGB(200, 100, 0))

--// INFO
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(1, 0, 0, 55)
InfoFrame.Position = UDim2.new(0, 0, 0, 118)
InfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InfoFrame.Parent = Content

local IF_Corner = Instance.new("UICorner")
IF_Corner.CornerRadius = UDim.new(0, 8)
IF_Corner.Parent = InfoFrame

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -16, 1, -10)
InfoText.Position = UDim2.new(0, 8, 0, 5)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Esperando..."
InfoText.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoText.TextSize = 12
InfoText.Font = Enum.Font.Gotham
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.Parent = InfoFrame

--// SISTEMA DE ARRASTRE
local Dragging = false
local Offset = nil

Header.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = input.Position
        local btnPos = ExpandBtn.AbsolutePosition
        local btnSize = ExpandBtn.AbsoluteSize
        
        if pos.X >= btnPos.X and pos.X <= btnPos.X + btnSize.X and
           pos.Y >= btnPos.Y and pos.Y <= btnPos.Y + btnSize.Y then
            return
        end
        
        Dragging = true
        local menuPos = MenuContainer.AbsolutePosition
        Offset = Vector2.new(pos.X - menuPos.X, pos.Y - menuPos.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local newPos = UDim2.new(0, input.Position.X - Offset.X, 0, input.Position.Y - Offset.Y)
        MenuContainer.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

--// FUNCIONES MEJORADAS

-- Verificar si una parte específica es visible (raycast limpio)
local function IsPartVisible(part, character)
    if not part then return false end
    
    local cameraPos = Camera.CFrame.Position
    local partPos = part.Position
    local direction = partPos - cameraPos
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(cameraPos, direction, raycastParams)
    
    return result == nil
end

-- Buscar la mejor parte para apuntar: CABEZA primero, si no → otra
local function GetBestAimPart(character)
    -- PRIORIDAD 1: CABEZA (siempre intentar cabeza primero)
    local head = character:FindFirstChild("Head")
    if head and IsPartVisible(head, character) then
        return head, "HEAD"
    end
    
    -- PRIORIDAD 2: HumanoidRootPart (torso centro)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp and IsPartVisible(hrp, character) then
        return hrp, "TORSO"
    end
    
    -- PRIORIDAD 3: UpperTorso (R15)
    local upperTorso = character:FindFirstChild("UpperTorso")
    if upperTorso and IsPartVisible(upperTorso, character) then
        return upperTorso, "TORSO"
    end
    
    -- PRIORIDAD 4: Cualquier parte visible del cuerpo
    local bodyParts = {
        "LeftUpperArm", "RightUpperArm",
        "LeftLowerArm", "RightLowerArm",
        "LeftHand", "RightHand",
        "LeftUpperLeg", "RightUpperLeg",
        "LeftLowerLeg", "RightLowerLeg",
        "LeftFoot", "RightFoot",
    }
    
    for _, partName in ipairs(bodyParts) do
        local part = character:FindFirstChild(partName)
        if part and IsPartVisible(part, character) then
            return part, "LIMB"
        end
    end
    
    -- Nada visible
    return nil, "NONE"
end

local function IsValidTarget(player)
    if player == LocalPlayer then return false end
    if Config.TeamCheck and player.Team == LocalPlayer.Team then return false end
    
    local char = player.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    return true
end

--// FUNCIÓN PRINCIPAL: Buscar target con prioridad de cabeza
local function FindBestTarget()
    local closeTargets = {}
    local farTargets = {}
    
    local myChar = LocalPlayer.Character
    if not myChar then return nil, "NONE", 0, nil, nil, nil end
    
    local myPos = myChar:GetPivot().Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidTarget(player) then
            local char = player.Character
            
            -- Verificar si está en FOV (usar cualquier parte para detección inicial)
            local detectPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            if not detectPart then continue end
            
            local dist = (myPos - detectPart.Position).Magnitude
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(detectPart.Position)
            if onScreen then
                local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                
                if screenDist <= Config.FOV then
                    -- Buscar la mejor parte para apuntar
                    local aimPart, partType = GetBestAimPart(char)
                    
                    if aimPart then
                        local targetData = {
                            player = player,
                            distance = dist,
                            aimPart = aimPart,
                            partType = partType,
                        }
                        
                        if dist <= Config.CloseRange then
                            table.insert(closeTargets, targetData)
                        else
                            table.insert(farTargets, targetData)
                        end
                    end
                end
            end
        end
    end
    
    -- PRIORIDAD 1: Cercanos (0-70m)
    if #closeTargets > 0 then
        table.sort(closeTargets, function(a, b) return a.distance < b.distance end)
        local best = closeTargets[1]
        return best.player, "CLEAR", best.distance, best.aimPart, best.partType, "CLOSE"
    end
    
    -- PRIORIDAD 2: Lejanos (71m+)
    if #farTargets > 0 then
        table.sort(farTargets, function(a, b) return a.distance < b.distance end)
        local best = farTargets[1]
        return best.player, "CLEAR", best.distance, best.aimPart, best.partType, "FAR"
    end
    
    return nil, "NONE", 0, nil, nil, nil
end

local function AimAt(target, aimPart)
    if not target or not aimPart then return end
    
    local targetPos = aimPart.Position
    local velocity = aimPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    targetPos = targetPos + (velocity * 0.08)
    
    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 - Config.Smoothness)
end

local function UpdateVisuals()
    if not Config.Enabled then
        FOV_Circle.Visible = false
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        ToggleBtn.Text = "OFF"
        InfoText.Text = "OFF - Esperando"
        InfoText.TextColor3 = Color3.fromRGB(150, 150, 150)
        return
    end
    
    FOV_Circle.Visible = true
    StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    ToggleBtn.Text = "ON"
    
    if not Target then
        FOV_Circle.Color = COLORS.NO_TARGET
        FOV_Circle.Thickness = 1.5
        InfoText.Text = "Buscando... Prioridad: Cabeza"
        InfoText.TextColor3 = COLORS.NO_TARGET
        
    elseif AimPartName == "HEAD" then
        -- Apuntando a cabeza (daño máximo)
        FOV_Circle.Color = COLORS.CLEAR
        FOV_Circle.Thickness = 3.5
        local rangeText = (TargetPriority == "CLOSE") and "CERCANO" or "LEJANO"
        InfoText.Text = string.format("🎯 CABEZA %s\n%s | %.0fm | Daño máximo", 
            rangeText, Target.Name:sub(1, 10), TargetDistance)
        InfoText.TextColor3 = COLORS.CLEAR
        
    else
        -- Apuntando a torso o extremidad
        FOV_Circle.Color = COLORS.FAR_TARGET
        FOV_Circle.Thickness = 2.5
        local rangeText = (TargetPriority == "CLOSE") and "CERCANO" or "LEJANO"
        InfoText.Text = string.format("%s %s\n%s | %.0fm | Cabeza bloqueada", 
            AimPartName, rangeText, Target.Name:sub(1, 10), TargetDistance)
        InfoText.TextColor3 = COLORS.FAR_TARGET
    end
end

--// EVENTOS
ExpandBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    
    if MenuOpen then
        ExpandBtn.Text = "▲"
        TweenService:Create(Menu, TweenInfo.new(0.2), {
            Size = UDim2.new(1, 0, 0, 180)
        }):Play()
    else
        ExpandBtn.Text = "▼"
        TweenService:Create(Menu, TweenInfo.new(0.2), {
            Size = UDim2.new(1, 0, 0, 45)
        }):Play()
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    if not Config.Enabled then
        Target = nil
        TargetStatus = "NONE"
        TargetPriority = nil
        AimPartName = "Head"
    end
    UpdateVisuals()
end)

FOVInput.FocusLost:Connect(function()
    local val = tonumber(FOVInput.Text)
    if val then
        val = math.clamp(val, Config.MinFOV, Config.MaxFOV)
        Config.FOV = val
        FOVInput.Text = tostring(val)
        FOVLabel.Text = "FOV: " .. val
        FOV_Circle.Radius = val
    else
        FOVInput.Text = tostring(Config.FOV)
    end
end)

--// LOOP
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOV_Circle.Position = center
    FOV_Circle.Radius = Config.FOV
    
    if Config.Enabled then
        local newTarget, status, distance, aimPart, partType, priority = FindBestTarget()
        
        Target = newTarget
        TargetStatus = status
        TargetDistance = distance
        TargetPriority = priority
        AimPartName = partType or "NONE"
        
        -- SIEMPRE APUNTA si hay target con parte válida
        if Target and aimPart then
            AimAt(Target, aimPart)
        end
    else
        Target = nil
        TargetStatus = "NONE"
        TargetDistance = 0
        TargetPriority = nil
        AimPartName = "Head"
    end
    
    UpdateVisuals()
end)

--// Notificación
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Aimbot V3",
        Text = "Prioridad: Cabeza → Torso → Extremidad",
        Duration = 4
    })
end)
