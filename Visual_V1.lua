local a = game:GetService("Players")
local b = a.LocalPlayer
local c = game:GetService("RunService")
local d = game:GetService("Workspace")
local e = game:GetService("Lighting")
local f = {
    ShowSilhouettes = false,
    ShowDistance = false,
    ShowLines = false,
    Fullbright = false,
    Xray = false,
    ShowFriends = false
}
local g = {
    Highlights = {},
    Distances = {},
    Lines = {},
    Friends = {},
    MyLineAtt0 = nil,
    PlayerAddedConnection = nil,
    CharacterAddedConnections = {},
    RenderSteppedConnections = {},
    OriginalLightingSettings = {},
    XrayConnection = nil,
    bCharRemovingXray = nil
}

local function h(i)
    if i.Team then
        local j = i.TeamColor.Color
        local k = (j.R + j.G + j.B) / 3
        if k < 0.3 then
            return Color3.new(j.R + 0.3, j.G + 0.3, j.B + 0.3)
        elseif k > 0.7 then
            return Color3.new(j.R - 0.3, j.G - 0.3, j.B - 0.3)
        end
        return j
    end
    return Color3.new(1, 0, 0)
end

local function l(m)
    if m and m.Parent then
        m:Destroy()
        return true
    end
    return false
end

local function n()
    for _, i in pairs(a:GetPlayers()) do
        if g.Highlights[i] then
            l(g.Highlights[i])
            g.Highlights[i] = nil
        end
    end
    g.Highlights = {}
end

local function p()
    for _, i in pairs(a:GetPlayers()) do
        if g.Distances[i] then
            if g.Distances[i].Billboard then
                l(g.Distances[i].Billboard)
            end
            g.Distances[i] = nil
        end
    end
    g.Distances = {}
end

local function q()
    for _, i in pairs(a:GetPlayers()) do
        if g.Lines[i] then
            l(g.Lines[i].Att1)
            l(g.Lines[i].Beam)
            g.Lines[i] = nil
        end
    end
    g.Lines = {}
    if g.MyLineAtt0 then
        l(g.MyLineAtt0)
        g.MyLineAtt0 = nil
    end
end

local function r()
    for _, i in pairs(a:GetPlayers()) do
        if g.Friends[i] then
            l(g.Friends[i].Gui)
            g.Friends[i] = nil
        end
    end
    g.Friends = {}
end

local function s()
    for _, t in pairs(g.RenderSteppedConnections) do
        if t then
            t:Disconnect()
        end
    end
    g.RenderSteppedConnections = {}
    for _, t in pairs(g.CharacterAddedConnections) do
        if t then
            t:Disconnect()
        end
    end
    g.CharacterAddedConnections = {}
    if g.PlayerAddedConnection then
        g.PlayerAddedConnection:Disconnect()
        g.PlayerAddedConnection = nil
    end
    if g.XrayConnection then
        g.XrayConnection:Disconnect()
        g.XrayConnection = nil
    end
    if g.bCharRemovingXray then
        g.bCharRemovingXray:Disconnect()
        g.bCharRemovingXray = nil
    end
end

local function u()
    n()
    p()
    q()
    r()
    s()
    if f.Fullbright then
        for v, w in pairs(g.OriginalLightingSettings) do
            e[v] = w
        end
        f.Fullbright = false
    end
    if f.Xray then
        for _, x in pairs(d:GetDescendants()) do
            if x:IsA("BasePart") then
                x.LocalTransparencyModifier = 0
            end
        end
        f.Xray = false
    end
end

-- Create functions
local function create_silhouette(i, A)
    if g.Highlights[i] then
        l(g.Highlights[i])
        g.Highlights[i] = nil
    end
    if A then
        local B = Instance.new("Highlight")
        B.FillColor = h(i)
        B.FillTransparency = 0.5
        B.OutlineColor = h(i)
        B.OutlineTransparency = 0
        B.Parent = A
        g.Highlights[i] = B
    end
end

local function create_distance(i, A)
    if g.Distances[i] then
        l(g.Distances[i].Billboard)
        g.Distances[i] = nil
    end
    if A then
        spawn(function()
            local head = A:WaitForChild("Head", 30)
            if head and f.ShowDistance then
                local E = Instance.new("BillboardGui")
                E.Size = UDim2.new(0, 200, 0, 50)
                E.StudsOffset = Vector3.new(0, 2, 0)
                E.AlwaysOnTop = true
                local F = Instance.new("TextLabel")
                F.Size = UDim2.new(1, 0, 1, 0)
                F.BackgroundTransparency = 1
                F.TextColor3 = h(i)
                F.TextStrokeTransparency = 0
                F.TextSize = 14
                F.Font = Enum.Font.GothamBold
                F.Parent = E
                E.Parent = head
                g.Distances[i] = {Billboard = E, Label = F}
            end
        end)
    end
end

local function create_line(i, A)
    if g.Lines[i] then
        l(g.Lines[i].Att1)
        l(g.Lines[i].Beam)
        g.Lines[i] = nil
    end
    if A then
        spawn(function()
            local targetHRP = A:WaitForChild("HumanoidRootPart", 30)
            if b.Character and b.Character:FindFirstChild("HumanoidRootPart") and targetHRP and f.ShowLines then
                local myHRP = b.Character.HumanoidRootPart
                -- Shared Att0
                if not g.MyLineAtt0 or g.MyLineAtt0.Parent ~= myHRP then
                    if g.MyLineAtt0 then
                        l(g.MyLineAtt0)
                    end
                    g.MyLineAtt0 = Instance.new("Attachment")
                    g.MyLineAtt0.Name = "ESPLineAtt0"
                    g.MyLineAtt0.Parent = myHRP
                end
                local att1 = Instance.new("Attachment")
                att1.Parent = targetHRP
                local beam = Instance.new("Beam")
                beam.Attachment0 = g.MyLineAtt0
                beam.Attachment1 = att1
                beam.Width0 = 0.2
                beam.Width1 = 0.2
                beam.FaceCamera = true
                beam.Color = ColorSequence.new(h(i))
                beam.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0.3)
                })
                beam.Parent = d
                g.Lines[i] = {Att1 = att1, Beam = beam}
            end
        end)
    end
end

local function create_friends(i, A)
    if not i:IsFriendsWith(b.UserId) then return end
    if g.Friends[i] then
        l(g.Friends[i].Gui)
        g.Friends[i] = nil
    end
    if A then
        spawn(function()
            local head = A:WaitForChild("Head", 30)
            if head and f.ShowFriends then
                local N = Instance.new("BillboardGui")
                N.Size = UDim2.new(0, 200, 0, 50)
                N.StudsOffset = Vector3.new(0, 4, 0)
                N.AlwaysOnTop = true
                local O = Instance.new("TextLabel")
                O.Size = UDim2.new(1, 0, 1, 0)
                O.BackgroundTransparency = 1
                O.Text = i.Name
                O.TextSize = 16
                O.Font = Enum.Font.Highway
                O.Parent = N
                N.Parent = head
                g.Friends[i] = {Gui = N, Label = O}
            end
        end)
    end
end

local function ar(i)
    if i == b then return end
    -- Apply to current character if exists
    local char = i.Character
    if char then
        if f.ShowSilhouettes then
            create_silhouette(i, char)
        end
        if f.ShowDistance then
            create_distance(i, char)
        end
        if f.ShowLines then
            create_line(i, char)
        end
        if f.ShowFriends then
            create_friends(i, char)
        end
    end
    -- Set unified CharacterAdded connection if not set
    if not g.CharacterAddedConnections[i] then
        g.CharacterAddedConnections[i] = i.CharacterAdded:Connect(function(A)
            -- Clean old ESP by recreating (destroys old objects)
            if f.ShowSilhouettes then
                create_silhouette(i, A)
            end
            if f.ShowDistance then
                create_distance(i, A)
            end
            if f.ShowLines then
                create_line(i, A)
            end
            if f.ShowFriends then
                create_friends(i, A)
            end
        end)
    end
end

local function Q()
    if not b.Character or not b.Character:FindFirstChild("HumanoidRootPart") then return end
    for i, R in pairs(g.Distances) do
        if i.Character and i.Character:FindFirstChild("HumanoidRootPart") and R.Label then
            local S = (i.Character.HumanoidRootPart.Position - b.Character.HumanoidRootPart.Position).Magnitude
            R.Label.Text = math.floor(S) .. "m"
        end
    end
end

local function T()
    f.Fullbright = not f.Fullbright
    if f.Fullbright then
        g.OriginalLightingSettings = {
            Brightness = e.Brightness,
            ClockTime = e.ClockTime,
            FogEnd = e.FogEnd,
            GlobalShadows = e.GlobalShadows,
            OutdoorAmbient = e.OutdoorAmbient
        }
        g.RenderSteppedConnections.Fullbright = c.RenderStepped:Connect(function()
            e.Brightness = 2
            e.ClockTime = 14
            e.FogEnd = 100000
            e.GlobalShadows = false
            e.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end)
    else
        if g.RenderSteppedConnections.Fullbright then
            g.RenderSteppedConnections.Fullbright:Disconnect()
            g.RenderSteppedConnections.Fullbright = nil
        end
        for v, w in pairs(g.OriginalLightingSettings) do
            e[v] = w
        end
    end
end

local function U()
    f.Xray = not f.Xray
    local function apply_xray()
        for _, x in pairs(d:GetDescendants()) do
            if x:IsA("BasePart") and b.Character and not x:IsDescendantOf(b.Character) then
                x.LocalTransparencyModifier = 0.8
            end
        end
    end
    if f.Xray then
        apply_xray()
        g.XrayConnection = d.DescendantAdded:Connect(function(x)
            if x:IsA("BasePart") and b.Character and not x:IsDescendantOf(b.Character) then
                x.LocalTransparencyModifier = 0.8
            end
        end)
        g.bCharRemovingXray = b.CharacterRemoving:Connect(function(oldchar)
            spawn(function()
                wait(0.1)
                for _, x in pairs(oldchar:GetDescendants()) do
                    if x:IsA("BasePart") and f.Xray then
                        x.LocalTransparencyModifier = 0.8
                    end
                end
            end)
        end)
    else
        if g.XrayConnection then
            g.XrayConnection:Disconnect()
            g.XrayConnection = nil
        end
        if g.bCharRemovingXray then
            g.bCharRemovingXray:Disconnect()
            g.bCharRemovingXray = nil
        end
        for _, x in pairs(d:GetDescendants()) do
            if x:IsA("BasePart") then
                x.LocalTransparencyModifier = 0
            end
        end
    end
end

local function V()
    f.ShowSilhouettes = not f.ShowSilhouettes
    if f.ShowSilhouettes then
        for _, i in pairs(a:GetPlayers()) do
            ar(i)  -- Will create if char exists
        end
    else
        n()
    end
end

local function W()
    f.ShowDistance = not f.ShowDistance
    if f.ShowDistance then
        for _, i in pairs(a:GetPlayers()) do
            ar(i)
        end
        g.RenderSteppedConnections.Distance = c.RenderStepped:Connect(Q)
    else
        p()
        if g.RenderSteppedConnections.Distance then
            g.RenderSteppedConnections.Distance:Disconnect()
            g.RenderSteppedConnections.Distance = nil
        end
    end
end

local function X()
    f.ShowLines = not f.ShowLines
    if f.ShowLines then
        for _, i in pairs(a:GetPlayers()) do
            ar(i)
        end
    else
        q()
    end
end

local function Y()
    f.ShowFriends = not f.ShowFriends
    if f.ShowFriends then
        for _, i in pairs(a:GetPlayers()) do
            ar(i)
        end
        g.RenderSteppedConnections.Friends = c.RenderStepped:Connect(function()
            if not f.ShowFriends then return end
            local P = (tick() % 5) / 5
            local col = Color3.fromHSV(P, 1, 1)
            for _, R in pairs(g.Friends) do
                if R.Label then
                    R.Label.TextColor3 = col
                end
            end
        end)
    else
        r()
        if g.RenderSteppedConnections.Friends then
            g.RenderSteppedConnections.Friends:Disconnect()
            g.RenderSteppedConnections.Friends = nil
        end
    end
end

-- GUI
local Z = Instance.new("ScreenGui")
Z.Name = "ESP_GUI"
Z.ResetOnSpawn = false
Z.Parent = game:GetService("CoreGui")

local _ = Instance.new("ImageButton")
_.Size = UDim2.new(0, 50, 0, 50)
_.Position = UDim2.new(0, 20, 0, 20)
_.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
_.Image = "rbxassetid://6031068430"
_.BackgroundTransparency = 0.1
_.Parent = Z
local a0 = Instance.new("UICorner")
a0.CornerRadius = UDim.new(1, 0)
a0.Parent = _

local a1 = Instance.new("Frame")
a1.Size = UDim2.new(0, 350, 0, 500)
a1.Position = UDim2.new(0.5, -175, 0.5, -250)
a1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
a1.BorderSizePixel = 0
a1.Visible = false
a1.Parent = Z
local a2 = Instance.new("UICorner")
a2.CornerRadius = UDim.new(0, 10)
a2.Parent = a1

local a3 = Instance.new("Frame")
a3.Size = UDim2.new(1, 0, 0, 40)
a3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
a3.BorderSizePixel = 0
a3.Parent = a1
local a4 = Instance.new("TextLabel")
a4.Size = UDim2.new(1, -40, 1, 0)
a4.Position = UDim2.new(0, 10, 0, 0)
a4.BackgroundTransparency = 1
a4.Text = "ESP Menu"
a4.TextColor3 = Color3.new(1, 1, 1)
a4.TextSize = 18
a4.Font = Enum.Font.GothamBold
a4.TextXAlignment = Enum.TextXAlignment.Left
a4.Parent = a3

local a5 = Instance.new("TextButton")
a5.Size = UDim2.new(0, 30, 0, 30)
a5.Position = UDim2.new(1, -35, 0.5, -15)
a5.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
a5.Text = "X"
a5.TextColor3 = Color3.new(1, 1, 1)
a5.TextSize = 14
a5.Font = Enum.Font.GothamBold
a5.Parent = a3
local a6 = Instance.new("UICorner")
a6.CornerRadius = UDim.new(0, 6)
a6.Parent = a5

local a7 = Instance.new("Frame")
a7.Size = UDim2.new(1, -20, 1, -50)
a7.Position = UDim2.new(0, 10, 0, 45)
a7.BackgroundTransparency = 1
a7.Parent = a1

local function a8(a9, aa, ab)
    local ac = Instance.new("TextButton")
    ac.Size = UDim2.new(0.45, 0, 1, 0)
    ac.Position = aa
    ac.BackgroundColor3 = ab
    ac.Text = a9
    ac.TextColor3 = Color3.new(1, 1, 1)
    ac.TextSize = 16
    ac.Font = Enum.Font.GothamBold
    local ad = Instance.new("UICorner")
    ad.CornerRadius = UDim.new(0, 8)
    ad.Parent = ac
    return ac
end

local function ae(a9, aa, af, ag)
    local ac = Instance.new("TextButton")
    ac.Size = UDim2.new(1, 0, 0, 45)
    ac.Position = UDim2.new(0, 0, 0, aa)
    ac.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ac.Text = a9
    ac.TextColor3 = Color3.new(1, 1, 1)
    ac.TextSize = 16
    ac.Font = Enum.Font.GothamSemibold
    ac.Parent = a7
    local ad = Instance.new("UICorner")
    ad.CornerRadius = UDim.new(0, 8)
    ad.Parent = ac
    ac.MouseButton1Click:Connect(function()
        if ag then ag() end
        ac.BackgroundColor3 = f[af] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    end)
    return ac
end

local ah = {
    {name = "Ver Siluetas", key = "ShowSilhouettes", func = V},
    {name = "Ver Distancia", key = "ShowDistance", func = W},
    {name = "Ver Líneas", key = "ShowLines", func = X},
    {name = "Fullbright", key = "Fullbright", func = T},
    {name = "Xray", key = "Xray", func = U},
    {name = "Ver Amigos", key = "ShowFriends", func = Y}
}
for ai, aj in ipairs(ah) do
    ae(aj.name, (ai - 1) * 50, aj.key, aj.func)
end
local ak = ae("Salir", (#ah) * 50, nil, u)
ak.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ak.MouseButton1Click:Connect(function()
    u()
    Z:Destroy()
end)

local al = Instance.new("Frame")
al.Size = UDim2.new(0, 300, 0, 150)
al.Position = UDim2.new(0.5, -150, 0.5, -75)
al.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
al.BorderSizePixel = 0
al.Visible = false
al.Parent = Z
local am = Instance.new("UICorner")
am.CornerRadius = UDim.new(0, 10)
am.Parent = al

local an = Instance.new("TextLabel")
an.Size = UDim2.new(1, 0, 0.5, 0)
an.Position = UDim2.new(0, 0, 0, 20)
an.BackgroundTransparency = 1
an.Text = "¿Deseas salir del script?"
an.TextColor3 = Color3.new(1, 1, 1)
an.TextSize = 18
an.Font = Enum.Font.GothamBold
an.Parent = al

local ao = Instance.new("Frame")
ao.Size = UDim2.new(1, -40, 0, 40)
ao.Position = UDim2.new(0, 20, 1, -60)
ao.BackgroundTransparency = 1
ao.Parent = al

local ap = a8("Aceptar", UDim2.new(0, 0, 0, 0), Color3.fromRGB(0, 170, 0))
ap.Parent = ao
local aq = a8("Cancelar", UDim2.new(0.55, 0, 0, 0), Color3.fromRGB(255, 50, 50))
aq.Parent = ao

ap.MouseButton1Click:Connect(function()
    u()
    Z:Destroy()
end)
aq.MouseButton1Click:Connect(function()
    al.Visible = false
end)
ak.MouseButton1Click:Connect(function()
    al.Visible = true
end)

_.MouseButton1Click:Connect(function()
    a1.Visible = not a1.Visible
end)
a5.MouseButton1Click:Connect(function()
    a1.Visible = false
end)

-- Init
g.PlayerAddedConnection = a.PlayerAdded:Connect(ar)
a.PlayerRemoving:Connect(function(i)
    if g.Highlights[i] then l(g.Highlights[i]); g.Highlights[i] = nil end
    if g.Distances[i] then l(g.Distances[i].Billboard); g.Distances[i] = nil end
    if g.Lines[i] then l(g.Lines[i].Att1); l(g.Lines[i].Beam); g.Lines[i] = nil end
    if g.Friends[i] then l(g.Friends[i].Gui); g.Friends[i] = nil end
    if g.CharacterAddedConnections[i] then
        g.CharacterAddedConnections[i]:Disconnect()
        g.CharacterAddedConnections[i] = nil
    end
end)

for _, i in pairs(a:GetPlayers()) do
    ar(i)
end

-- Draggable
local as = game:GetService("UserInputService")
local at, au, av

local function aw(ax)
    local ay = ax.Position - au
    _.Position = UDim2.new(av.X.Scale, av.X.Offset + ay.X, av.Y.Scale, av.Y.Offset + ay.Y)
end

_.InputBegan:Connect(function(ax)
    if ax.UserInputType == Enum.UserInputType.MouseButton1 or ax.UserInputType == Enum.UserInputType.Touch then
        au = ax.Position
        av = _.Position
        ax.Changed:Connect(function()
            if ax.UserInputState == Enum.UserInputState.End then
                at = nil
            end
        end)
    end
end)
_.InputChanged:Connect(function(ax)
    if ax.UserInputType == Enum.UserInputType.MouseMovement or ax.UserInputType == Enum.UserInputType.Touch then
        at = ax
    end
end)
as.InputChanged:Connect(function(ax)
    if ax == at and at then
        aw(ax)
    end
end)
