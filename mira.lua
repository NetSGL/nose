local a,b,c,d,e,f=game:GetService("Players"),game:GetService("RunService"),game:GetService("Workspace"),game:GetService("UserInputService"),game:GetService("CoreGui"),game:GetService("TweenService")
local g,h=a.LocalPlayer,c.CurrentCamera
local i={Enabled=true,FOV=120,MinFOV=30,MaxFOV=250,TeamCheck=true,Smoothness=0.1,CloseRange=70,MaxDistance=999999}
local j={OFF=Color3.fromRGB(80,80,80),NO_TARGET=Color3.fromRGB(255,50,50),FAR_TARGET=Color3.fromRGB(255,150,0),CLEAR=Color3.fromRGB(0,255,100)}
local k,l,m,n,o,p,q=nil,"NONE",0,nil,"Head",false
local r=Instance.new("ScreenGui")
r.Name="AimbotV3"
r.Parent=e
r.ResetOnSpawn=false
local s=Drawing.new("Circle")
s.Visible=false
s.Thickness=2
s.NumSides=64
s.Radius=i.FOV
s.Filled=false
s.Transparency=0.9
s.Color=j.NO_TARGET
local t=Instance.new("Frame")
t.Size=UDim2.new(0,220,0,220)
t.Position=UDim2.new(0,10,0,30)
t.BackgroundTransparency=1
t.Parent=r
local u=Instance.new("Frame")
u.Size=UDim2.new(1,0,0,45)
u.BackgroundColor3=Color3.fromRGB(25,25,25)
u.ClipsDescendants=true
u.Parent=t
local v=Instance.new("UICorner")
v.CornerRadius=UDim.new(0,10)
v.Parent=u
local w=Instance.new("Frame")
w.Size=UDim2.new(1,0,0,45)
w.BackgroundColor3=Color3.fromRGB(35,35,35)
w.Parent=u
local x=Instance.new("UICorner")
x.CornerRadius=UDim.new(0,10)
x.Parent=w
local y=Instance.new("TextLabel")
y.Size=UDim2.new(1,-90,1,0)
y.Position=UDim2.new(0,12,0,0)
y.BackgroundTransparency=1
y.Text="AIMBOT V3"
y.TextColor3=Color3.fromRGB(255,255,255)
y.TextSize=16
y.Font=Enum.Font.GothamBold
y.TextXAlignment=Enum.TextXAlignment.Left
y.Parent=w
local z=Instance.new("Frame")
z.Size=UDim2.new(0,12,0,12)
z.Position=UDim2.new(1,-70,0.5,-6)
z.BackgroundColor3=Color3.fromRGB(0,255,0)
z.BorderSizePixel=0
z.Parent=w
local A=Instance.new("UICorner")
A.CornerRadius=UDim.new(0.5,0)
A.Parent=z
local B=Instance.new("TextButton")
B.Size=UDim2.new(0,38,0,38)
B.Position=UDim2.new(1,-45,0,3)
B.BackgroundColor3=Color3.fromRGB(50,50,50)
B.Text="▼"
B.TextColor3=Color3.fromRGB(255,255,255)
B.TextSize=20
B.Font=Enum.Font.GothamBold
B.Parent=w
local C=Instance.new("UICorner")
C.CornerRadius=UDim.new(0,8)
C.Parent=B
local D=Instance.new("Frame")
D.Size=UDim2.new(1,-16,1,-55)
D.Position=UDim2.new(0,8,0,50)
D.BackgroundTransparency=1
D.Parent=u
local E=Instance.new("Frame")
E.Size=UDim2.new(1,0,0,40)
E.BackgroundColor3=Color3.fromRGB(40,40,40)
E.Parent=D
local F=Instance.new("UICorner")
F.CornerRadius=UDim.new(0,8)
F.Parent=E
local G=Instance.new("TextLabel")
G.Size=UDim2.new(0.5,0,1,0)
G.Position=UDim2.new(0,10,0,0)
G.BackgroundTransparency=1
G.Text="Auto Aim"
G.TextColor3=Color3.fromRGB(255,255,255)
G.TextSize=14
G.Font=Enum.Font.Gotham
G.TextXAlignment=Enum.TextXAlignment.Left
G.Parent=E
local H=Instance.new("TextButton")
H.Size=UDim2.new(0,70,0,30)
H.Position=UDim2.new(1,-80,0.5,-15)
H.BackgroundColor3=Color3.fromRGB(0,180,0)
H.Text="ON"
H.TextColor3=Color3.fromRGB(255,255,255)
H.TextSize=14
H.Font=Enum.Font.GothamBold
H.Parent=E
local I=Instance.new("UICorner")
I.CornerRadius=UDim.new(0,6)
I.Parent=H
local J=Instance.new("Frame")
J.Size=UDim2.new(1,0,0,65)
J.Position=UDim2.new(0,0,0,48)
J.BackgroundColor3=Color3.fromRGB(40,40,40)
J.Parent=D
local K=Instance.new("UICorner")
K.CornerRadius=UDim.new(0,8)
K.Parent=J
local L=Instance.new("TextLabel")
L.Size=UDim2.new(1,-20,0,20)
L.Position=UDim2.new(0,10,0,6)
L.BackgroundTransparency=1
L.Text="FOV: "..i.FOV
L.TextColor3=Color3.fromRGB(200,200,200)
L.TextSize=12
L.Font=Enum.Font.Gotham
L.TextXAlignment=Enum.TextXAlignment.Left
L.Parent=J
local M=Instance.new("TextBox")
M.Size=UDim2.new(0,70,0,28)
M.Position=UDim2.new(0,10,0,32)
M.BackgroundColor3=Color3.fromRGB(55,55,55)
M.Text=tostring(i.FOV)
M.TextColor3=Color3.fromRGB(255,255,255)
M.TextSize=16
M.Font=Enum.Font.GothamBold
M.ClearTextOnFocus=true
M.Parent=J
local N=Instance.new("UICorner")
N.CornerRadius=UDim.new(0,6)
N.Parent=M
local O=Instance.new("Frame")
O.Size=UDim2.new(0,110,0,28)
O.Position=UDim2.new(0,90,0,32)
O.BackgroundTransparency=1
O.Parent=J
local function P(Q,R,S,T)
local U=Instance.new("TextButton")
U.Size=UDim2.new(0,32,0,28)
U.Position=R
U.BackgroundColor3=T
U.Text=Q
U.TextColor3=Color3.fromRGB(255,255,255)
U.TextSize=11
U.Font=Enum.Font.GothamBold
U.Parent=O
local V=Instance.new("UICorner")
V.CornerRadius=UDim.new(0,5)
V.Parent=U
U.MouseButton1Click:Connect(function()
i.FOV=S
M.Text=tostring(S)
L.Text="FOV: "..S
s.Radius=S
end)
end
P("S",UDim2.new(0,0,0,0),60,Color3.fromRGB(0,100,150))
P("M",UDim2.new(0,37,0,0),120,Color3.fromRGB(0,150,80))
P("L",UDim2.new(0,74,0,0),200,Color3.fromRGB(200,100,0))
local W=Instance.new("Frame")
W.Size=UDim2.new(1,0,0,55)
W.Position=UDim2.new(0,0,0,118)
W.BackgroundColor3=Color3.fromRGB(40,40,40)
W.Parent=D
local X=Instance.new("UICorner")
X.CornerRadius=UDim.new(0,8)
X.Parent=W
local Y=Instance.new("TextLabel")
Y.Size=UDim2.new(1,-16,1,-10)
Y.Position=UDim2.new(0,8,0,5)
Y.BackgroundTransparency=1
Y.Text="Esperando..."
Y.TextColor3=Color3.fromRGB(180,180,180)
Y.TextSize=12
Y.Font=Enum.Font.Gotham
Y.TextWrapped=true
Y.TextYAlignment=Enum.TextYAlignment.Top
Y.Parent=W
local Z,_=false,nil
w.InputBegan:Connect(function(aa,ab)
if ab then return end
if aa.UserInputType==Enum.UserInputType.Touch or aa.UserInputType==Enum.UserInputType.MouseButton1 then
local ac=aa.Position
local ad=B.AbsolutePosition
local ae=B.AbsoluteSize
if ac.X>=ad.X and ac.X<=ad.X+ae.X and ac.Y>=ad.Y and ac.Y<=ad.Y+ae.Y then
return
end
Z=true
local af=t.AbsolutePosition
_=Vector2.new(ac.X-af.X,ac.Y-af.Y)
end
end)
d.InputChanged:Connect(function(ag)
if Z and(ag.UserInputType==Enum.UserInputType.Touch or ag.UserInputType==Enum.UserInputType.MouseMovement)then
t.Position=UDim2.new(0,ag.Position.X-_.X,0,ag.Position.Y-_.Y)
end
end)
d.InputEnded:Connect(function(ah)
if ah.UserInputType==Enum.UserInputType.Touch or ah.UserInputType==Enum.UserInputType.MouseButton1 then
Z=false
end
end)
local function ai(aj,ak)
if not aj then return false end
local al=h.CFrame.Position
local am=aj.Position
local an=am-al
local ao=RaycastParams.new()
ao.FilterDescendantsInstances={g.Character,ak}
ao.FilterType=Enum.RaycastFilterType.Blacklist
ao.IgnoreWater=true
return c:Raycast(al,an,ao)==nil
end
local function ap(aq)
local ar=aq:FindFirstChild("Head")
if ar and ai(ar,aq)then
return ar,"HEAD"
end
local as=aq:FindFirstChild("HumanoidRootPart")
if as and ai(as,aq)then
return as,"TORSO"
end
local at=aq:FindFirstChild("UpperTorso")
if at and ai(at,aq)then
return at,"TORSO"
end
local au={"LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
for _,av in ipairs(au)do
local aw=aq:FindFirstChild(av)
if aw and ai(aw,aq)then
return aw,"LIMB"
end
end
return nil,"NONE"
end
local function ax(ay)
if ay==g then return false end
if i.TeamCheck and ay.Team==g.Team then return false end
local az=ay.Character
if not az then return false end
local aA=az:FindFirstChildOfClass("Humanoid")
if not aA or aA.Health<=0 then return false end
return true
end
local function aB()
local aC,aD={},{}
local aE=g.Character
if not aE then return nil,"NONE",0,nil,nil,nil end
local aF=aE:GetPivot().Position
for _,aG in pairs(a:GetPlayers())do
if ax(aG)then
local aH=aG.Character
local aI=aH:FindFirstChild("HumanoidRootPart")or aH:FindFirstChild("Head")
if not aI then continue end
local aJ=(aF-aI.Position).Magnitude
local aK,aL=h:WorldToViewportPoint(aI.Position)
if aL then
local aM=Vector2.new(h.ViewportSize.X/2,h.ViewportSize.Y/2)
if(Vector2.new(aK.X,aK.Y)-aM).Magnitude<=i.FOV then
local aN,aO=ap(aH)
if aN then
local aP={player=aG,distance=aJ,aimPart=aN,partType=aO}
if aJ<=i.CloseRange then
table.insert(aC,aP)
else
table.insert(aD,aP)
end
end
end
end
end
end
if#aC>0 then
table.sort(aC,function(aQ,aR)return aQ.distance<aR.distance end)
local aS=aC[1]
return aS.player,"CLEAR",aS.distance,aS.aimPart,aS.partType,"CLOSE"
end
if#aD>0 then
table.sort(aD,function(aT,aU)return aT.distance<aU.distance end)
local aV=aD[1]
return aV.player,"CLEAR",aV.distance,aV.aimPart,aV.partType,"FAR"
end
return nil,"NONE",0,nil,nil,nil
end
local function aW(aX,aY)
if not aX or not aY then return end
local aZ=aY.Position
local a_=aY.AssemblyLinearVelocity or Vector3.new(0,0,0)
aZ=aZ+(a_*0.08)
h.CFrame=h.CFrame:Lerp(CFrame.new(h.CFrame.Position,aZ),1-i.Smoothness)
end
local function b0()
if not i.Enabled then
s.Visible=false
z.BackgroundColor3=Color3.fromRGB(255,0,0)
H.BackgroundColor3=Color3.fromRGB(180,0,0)
H.Text="OFF"
Y.Text="OFF - Esperando"
Y.TextColor3=Color3.fromRGB(150,150,150)
return
end
s.Visible=true
z.BackgroundColor3=Color3.fromRGB(0,255,0)
H.BackgroundColor3=Color3.fromRGB(0,180,0)
H.Text="ON"
if not k then
s.Color=j.NO_TARGET
s.Thickness=1.5
Y.Text="Buscando... Prioridad: Cabeza"
Y.TextColor3=j.NO_TARGET
elseif p=="HEAD"then
s.Color=j.CLEAR
s.Thickness=3.5
local b1=(o=="CLOSE")and"CERCANO"or"LEJANO"
Y.Text=string.format("🎯 CABEZA %s\n%s | %.0fm | Daño máximo",b1,k.Name:sub(1,10),m)
Y.TextColor3=j.CLEAR
else
s.Color=j.FAR_TARGET
s.Thickness=2.5
local b2=(o=="CLOSE")and"CERCANO"or"LEJANO"
Y.Text=string.format("%s %s\n%s | %.0fm | Cabeza bloqueada",p,b2,k.Name:sub(1,10),m)
Y.TextColor3=j.FAR_TARGET
end
end
B.MouseButton1Click:Connect(function()
q=not q
if q then
B.Text="▲"
f:Create(u,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,180)}):Play()
else
B.Text="▼"
f:Create(u,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,45)}):Play()
end
end)
H.MouseButton1Click:Connect(function()
i.Enabled=not i.Enabled
if not i.Enabled then
k=nil
l="NONE"
o=nil
p="Head"
end
b0()
end)
M.FocusLost:Connect(function()
local b3=tonumber(M.Text)
if b3 then
b3=math.clamp(b3,i.MinFOV,i.MaxFOV)
i.FOV=b3
M.Text=tostring(b3)
L.Text="FOV: "..b3
s.Radius=b3
else
M.Text=tostring(i.FOV)
end
end)
b.RenderStepped:Connect(function()
local b4=Vector2.new(h.ViewportSize.X/2,h.ViewportSize.Y/2)
s.Position=b4
s.Radius=i.FOV
if i.Enabled then
local b5,b6,b7,b8,b9,ba=aB()
k=b5
l=b6
m=b7
o=ba
p=b9 or"NONE"
if k and b8 then
aW(k,b8)
end
else
k=nil
l="NONE"
m=0
o=nil
p="Head"
end
b0()
end)
pcall(function()
game:GetService("StarterGui"):SetCore("SendNotification",{Title="Aimbot V3",Text="Prioridad: Cabeza → Torso → Extremidad",Duration=4})
end)
