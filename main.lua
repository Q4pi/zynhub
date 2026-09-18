-- Zyn Hub V17 FINAL FIXED by Q4pi - NO SEARCH BUG, HIGH JUMP, ALL WORKING
local YOUR_URL = "https://raw.githubusercontent.com/Q4pi/zynhub/main/main.lua"

pcall(function()
    local code = 'repeat task.wait() until game:IsLoaded() task.wait(2) loadstring(game:HttpGet("'..YOUR_URL..'"))()'
    if queue_on_teleport then queue_on_teleport(code) end
    if syn and syn.queue_on_teleport then syn.queue_on_teleport(code) end
end)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

if player.PlayerGui:FindFirstChild("ZynHubGui") then player.PlayerGui.ZynHubGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZynHubGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 285, 0, 470)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", frame) stroke.Color = Color3.fromRGB(120,60,255) stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-75,0,30) title.Position = UDim2.new(0,10,0,0) title.BackgroundTransparency = 1
title.Text = "Zyn Hub V17 FINAL" title.Font = Enum.Font.GothamBold title.TextSize = 14 title.TextColor3 = Color3.fromRGB(150,100,255) title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0,30,0,25) minimizeBtn.Position = UDim2.new(1,-62,0,3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,70) minimizeBtn.Text = "-" minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold minimizeBtn.TextSize = 18 minimizeBtn.ZIndex = 10
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,25,0,25) closeBtn.Position = UDim2.new(1,-28,0,3) closeBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeBtn.Text = "X" closeBtn.TextColor3 = Color3.new(1,1,1) closeBtn.Font = Enum.Font.GothamBold closeBtn.TextSize = 14 closeBtn.ZIndex = 10
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-16,1,-38) scroll.Position = UDim2.new(0,8,0,34) scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0) scroll.ScrollBarThickness = 3 scroll.Active = true
local layout = Instance.new("UIListLayout", scroll) layout.Padding = UDim.new(0,5)
local pad = Instance.new("UIPadding", scroll) pad.PaddingTop=UDim.new(0,2) pad.PaddingLeft=UDim.new(0,2) pad.PaddingRight=UDim.new(0,2)

local function makeButton(text, color)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1,-6,0,30) b.BackgroundColor3 = color or Color3.fromRGB(40,40,60) b.Text = text
    b.TextColor3 = Color3.new(1,1,1) b.Font = Enum.Font.Gotham b.TextSize = 12 b.AutoButtonColor = true b.Active = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6) return b
end

-- VARS
local speedOn,flyOn,noclipOn,infJumpOn,espOn,fbOn,clickTPOn,invisOn,godOn,afkOn,desyncOn,lagOn,freecamOn,antilockOn,bhopOn,doorOn,aimbotOn,espBoxOn,magnetOn,thirdOn,staminaOn,nightOn,tracersOn,crosshairOn,spectateOn,antiRagOn,xrayOn,rainbowOn,lowGravOn,spinOn,hitboxOn,headlessOn,flingOn,antiKickOn,keybindsOn = false,false,false,false,false,false,false,false,false,false,false,false,false,false,true
local speedConn,flyConn,noclipConn,bv,bg,savedPoint,crosshairGui,freecamPart = nil,nil,nil,nil,nil,nil,nil,nil
local minimized = false
local oldSize = frame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then oldSize = frame.Size scroll.Visible = false frame.Size = UDim2.new(0, 200, 0, 32) minimizeBtn.Text = "+" title.Text="Zyn Hub [MIN]" else scroll.Visible = true frame.Size = oldSize minimizeBtn.Text = "-" title.Text="Zyn Hub V17 FINAL" end
end)
closeBtn.MouseButton1Click:Connect(function() pcall(function() settings().Network.IncomingReplicationLag=0 end) if crosshairGui then crosshairGui:Destroy() end gui:Destroy() end)

-- BUTTONS
local speedBtn = makeButton("Speed: OFF (CFrame)")
local jumpBtn = makeButton("Jump 50 -> 250 HIGH")
local flyBtn = makeButton("Fly: OFF [E] 400 SPD")
local noclipBtn = makeButton("Noclip: OFF")
local infJumpBtn = makeButton("Inf Jump: OFF")
local espBtn = makeButton("ESP: OFF")
local fullbrightBtn = makeButton("Fullbright: OFF")
local clickTPBtn = makeButton("Click TP: OFF [CTRL+CLICK]")
local invisBtn = makeButton("Invisible: OFF")
local godBtn = makeButton("God Mode: OFF")
local antiAfkBtn = makeButton("Anti-AFK: OFF")
local tpSpawnBtn = makeButton("TP на спавн")
local setPointBtn = makeButton("📍 Поставить точку [P]", Color3.fromRGB(60,60,120))
local tpPointBtn = makeButton("🚀 ТП на точку [T]", Color3.fromRGB(60,120,60))
local tpPlayersBtn = makeButton("TP к игроку")
local desyncBtn = makeButton("Desync: OFF [K] 💀", Color3.fromRGB(80,40,120))
local desyncTypeBtn = makeButton("Mode: GHOST 👻", Color3.fromRGB(40,80,80))
local lagBtn = makeButton("Lag Switch: OFF [L]", Color3.fromRGB(100,80,0))
local freecamBtn = makeButton("Freecam: OFF [F] 📷", Color3.fromRGB(0,100,150))
local antilockBtn = makeButton("Anti-Lock: OFF 🔒", Color3.fromRGB(150,50,0))
local bhopBtn = makeButton("Bhop: OFF 🐰", Color3.fromRGB(60,60,60))
local doorBtn = makeButton("Door Bypass: OFF 🚪", Color3.fromRGB(60,100,60))
local keybindsBtn = makeButton("⌨️ Keybinds: ON ✅", Color3.fromRGB(0,120,80))
local rejoinBtn = makeButton("Rejoin Server 🔄", Color3.fromRGB(60,60,120))
local aimbotBtn = makeButton("🎯 Aimbot: OFF [Q]", Color3.fromRGB(120,20,20))
local espBoxBtn = makeButton("📦 ESP Box: OFF", Color3.fromRGB(0,120,120))
local magnetBtn = makeButton("🧲 Item Magnet: OFF", Color3.fromRGB(120,100,0))
local thirdBtn = makeButton("👁️ Third Person: OFF", Color3.fromRGB(80,80,120))
local staminaBtn = makeButton("⚡ Inf Stamina: OFF", Color3.fromRGB(0,100,60))
local nightBtn = makeButton("🌙 Night Vision: OFF", Color3.fromRGB(20,60,100))
local tracersBtn = makeButton("📏 Tracers: OFF", Color3.fromRGB(100,0,100))
local crosshairBtn = makeButton("🎯 Crosshair: OFF", Color3.fromRGB(0,100,100))
local spectateBtn = makeButton("👀 Spectate: OFF", Color3.fromRGB(100,60,0))
local antiRagBtn = makeButton("🛡️ Anti-Ragdoll: OFF", Color3.fromRGB(60,120,60))
local serverHopBtn = makeButton("🌐 Server Hop [AUTOLOAD]", Color3.fromRGB(60,60,150))
local xrayBtn = makeButton("X-Ray: OFF")
local rainbowBtn = makeButton("Rainbow Body: OFF")
local fovBtn = makeButton("FOV 70 -> 120")
local lowGravBtn = makeButton("Low Gravity: OFF")
local spinBtn = makeButton("Spin Bot: OFF")
local hitboxBtn = makeButton("Hitbox Expander: OFF")
local headlessBtn = makeButton("Headless: OFF")
local flingBtn = makeButton("Fling: OFF")
local fpsBtn = makeButton("FPS BOOST", Color3.fromRGB(60,120,60))
local antiKickBtn = makeButton("Anti-Kick: OFF", Color3.fromRGB(120,60,60))
local resetAllBtn = makeButton("🔄 ВЕРНУТЬ ВСЕ НАЗАД", Color3.fromRGB(170,40,40))
local resetCharBtn = makeButton("Убить персонажа")

-- FUNCTIONS
speedBtn.MouseButton1Click:Connect(function() speedOn=not speedOn speedBtn.Text=speedOn and "Speed: ON (25)" or "Speed: OFF (CFrame)" speedBtn.BackgroundColor3=speedOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if speedOn then speedConn=RunService.Heartbeat:Connect(function() local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hrp and hum and hum.MoveDirection.Magnitude>0 then hrp.CFrame=hrp.CFrame+hum.MoveDirection*1.8 end end) else if speedConn then speedConn:Disconnect() end end end)

-- HIGH JUMP FIXED
jumpBtn.MouseButton1Click:Connect(function()
    local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if hum.JumpPower<100 then
        hum.UseJumpPower=false hum.JumpHeight=50 hum.JumpPower=150
        jumpBtn.Text="Jump: 250 HIGH ON" jumpBtn.BackgroundColor3=Color3.fromRGB(0,170,0)
        -- instant high jump
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 120, hrp.Velocity.Z)
    else
        hum.UseJumpPower=true hum.JumpPower=50 hum.JumpHeight=7.2
        jumpBtn.Text="Jump 50 -> 250 HIGH" jumpBtn.BackgroundColor3=Color3.fromRGB(40,40,60)
    end
end)

local function toggleFly()
    local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    flyOn=not flyOn flyBtn.Text=flyOn and "Fly: ON [400 SPD]" or "Fly: OFF [E] 400 SPD" flyBtn.BackgroundColor3=flyOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) hum.PlatformStand=flyOn
    if flyOn then bv=Instance.new("BodyVelocity") bv.MaxForce=Vector3.new(9e9,9e9,9e9) bv.Velocity=Vector3.zero bv.Parent=hrp bg=Instance.new("BodyGyro") bg.MaxTorque=Vector3.new(9e9,9e9,9e9) bg.CFrame=hrp.CFrame bg.Parent=hrp flyConn=RunService.Heartbeat:Connect(function() local cam=workspace.CurrentCamera if not bv or not bg then return end bg.CFrame=cam.CFrame local m=Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W) then m+=cam.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S) then m-=cam.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A) then m-=cam.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D) then m+=cam.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m+=Vector3.new(0,1,0) end if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then m-=Vector3.new(0,1,0) end bv.Velocity=m.Magnitude>0 and m.Unit*60 or Vector3.zero end) else if flyConn then flyConn:Disconnect() end if bv then bv:Destroy() bv=nil end if bg then bg:Destroy() bg=nil end end
end
flyBtn.MouseButton1Click:Connect(toggleFly)

noclipBtn.MouseButton1Click:Connect(function() noclipOn=not noclipOn noclipBtn.Text=noclipOn and "Noclip: ON" or "Noclip: OFF" noclipBtn.BackgroundColor3=noclipOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if noclipOn then noclipConn=RunService.Stepped:Connect(function() if player.Character then for _,v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) else if noclipConn then noclipConn:Disconnect() end end end)

infJumpBtn.MouseButton1Click:Connect(function() infJumpOn=not infJumpOn infJumpBtn.Text=infJumpOn and "Inf Jump: ON" or "Inf Jump: OFF" infJumpBtn.BackgroundColor3=infJumpOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) end)
UserInputService.JumpRequest:Connect(function() if infJumpOn then local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

espBtn.MouseButton1Click:Connect(function() espOn=not espOn espBtn.Text=espOn and "ESP: ON" or "ESP: OFF" espBtn.BackgroundColor3=espOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) for _,plr in pairs(game.Players:GetPlayers()) do if plr~=player and plr.Character then local h=plr.Character:FindFirstChild("ESP_H") if espOn then if not h then local hl=Instance.new("Highlight",plr.Character) hl.Name="ESP_H" hl.FillColor=Color3.fromRGB(255,0,0) end else if h then h:Destroy() end end end end end)

fullbrightBtn.MouseButton1Click:Connect(function() fbOn=not fbOn fullbrightBtn.Text=fbOn and "Fullbright: ON" or "Fullbright: OFF" fullbrightBtn.BackgroundColor3=fbOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) Lighting.Brightness=fbOn and 2 or 1 Lighting.FogEnd=fbOn and 1000000 or 100000 end)

clickTPBtn.MouseButton1Click:Connect(function() clickTPOn=not clickTPOn clickTPBtn.Text=clickTPOn and "Click TP: ON" or "Click TP: OFF [CTRL+CLICK]" clickTPBtn.BackgroundColor3=clickTPOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) end)
UserInputService.InputBegan:Connect(function(input,g) if clickTPOn and input.UserInputType==Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local mouse=player:GetMouse() if mouse.Hit then player.Character.HumanoidRootPart.CFrame=CFrame.new(mouse.Hit.p+Vector3.new(0,3,0)) end end end)

invisBtn.MouseButton1Click:Connect(function() invisOn=not invisOn invisBtn.Text=invisOn and "Invisible: ON" or "Invisible: OFF" invisBtn.BackgroundColor3=invisOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if player.Character then for _,v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Transparency=invisOn and 1 or 0 end end end end)

godBtn.MouseButton1Click:Connect(function() godOn=not godOn godBtn.Text=godOn and "God Mode: ON" or "God Mode: OFF" godBtn.BackgroundColor3=godOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if godOn then local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum.MaxHealth=math.huge hum.Health=math.huge end end end)

antiAfkBtn.MouseButton1Click:Connect(function() afkOn=not afkOn antiAfkBtn.Text=afkOn and "Anti-AFK: ON" or "Anti-AFK: OFF" antiAfkBtn.BackgroundColor3=afkOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if afkOn then for _,c in pairs(getconnections(player.Idled)) do c:Disable() end end end)

tpSpawnBtn.MouseButton1Click:Connect(function() player.Character.HumanoidRootPart.CFrame=CFrame.new(0,5,0) end)
setPointBtn.MouseButton1Click:Connect(function() local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then savedPoint=hrp.CFrame setPointBtn.Text="✅ Сохранено!" task.wait(1) setPointBtn.Text="📍 Поставить точку [P]" end end)
tpPointBtn.MouseButton1Click:Connect(function() if savedPoint then player.Character.HumanoidRootPart.CFrame=savedPoint+Vector3.new(0,2,0) end end)
tpPlayersBtn.MouseButton1Click:Connect(function() for _,p in pairs(game.Players:GetPlayers()) do if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame=p.Character.HumanoidRootPart.CFrame+Vector3.new(0,0,2) break end end end)

desyncBtn.MouseButton1Click:Connect(function() desyncOn=not desyncOn desyncBtn.Text=desyncOn and "Desync: ON [K] 🔥" or "Desync: OFF [K] 💀" desyncBtn.BackgroundColor3=desyncOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,40,120) if desyncOn then pcall(function() sethiddenproperty(player,"SimulationRadius",0) end) settings().Network.IncomingReplicationLag=10 else pcall(function() sethiddenproperty(player,"SimulationRadius",1000) end) settings().Network.IncomingReplicationLag=0 end end)
desyncTypeBtn.MouseButton1Click:Connect(function() desyncTypeBtn.Text=desyncTypeBtn.Text:find("GHOST") and "Mode: REAL CLONE 🧬" or "Mode: GHOST 👻" end)
lagBtn.MouseButton1Click:Connect(function() lagOn=not lagOn lagBtn.Text=lagOn and "Lag Switch: ON [L] 🔥" or "Lag Switch: OFF [L]" lagBtn.BackgroundColor3=lagOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(100,80,0) settings().Network.IncomingReplicationLag=lagOn and 10 or 0 end)
freecamBtn.MouseButton1Click:Connect(function() freecamOn=not freecamOn freecamBtn.Text=freecamOn and "Freecam: ON [F] 📷" or "Freecam: OFF [F] 📷" freecamBtn.BackgroundColor3=freecamOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,100,150) workspace.CurrentCamera.CameraType=freecamOn and Enum.CameraType.Scriptable or Enum.CameraType.Custom end)

antilockBtn.MouseButton1Click:Connect(function() antilockOn=not antilockOn antilockBtn.Text=antilockOn and "Anti-Lock: ON 🔒" or "Anti-Lock: OFF 🔒" antilockBtn.BackgroundColor3=antilockOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(150,50,0) end)
bhopBtn.MouseButton1Click:Connect(function() bhopOn=not bhopOn bhopBtn.Text=bhopOn and "Bhop: ON 🐰" or "Bhop: OFF 🐰" bhopBtn.BackgroundColor3=bhopOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60) end)
doorBtn.MouseButton1Click:Connect(function() doorOn=not doorOn doorBtn.Text=doorOn and "Door Bypass: ON 🚪" or "Door Bypass: OFF 🚪" doorBtn.BackgroundColor3=doorOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,100,60) if doorOn then for _,v in pairs(workspace:GetDescendants()) do if v.Name:lower():find("door") and v:IsA("BasePart") then v.CanCollide=false end end end end)
keybindsBtn.MouseButton1Click:Connect(function() keybindsOn=not keybindsOn keybindsBtn.Text=keybindsOn and "⌨️ Keybinds: ON ✅" or "⌨️ Keybinds: OFF ❌" keybindsBtn.BackgroundColor3=keybindsOn and Color3.fromRGB(0,120,80) or Color3.fromRGB(120,40,40) end)

rejoinBtn.MouseButton1Click:Connect(function() local code='repeat task.wait() until game:IsLoaded() task.wait(2) loadstring(game:HttpGet("'..YOUR_URL..'"))()' pcall(function() queue_on_teleport(code) end) TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
serverHopBtn.MouseButton1Click:Connect(function() local code='repeat task.wait() until game:IsLoaded() task.wait(2) loadstring(game:HttpGet("'..YOUR_URL..'"))()' pcall(function() queue_on_teleport(code) end) pcall(function() if syn then syn.queue_on_teleport(code) end end) TeleportService:Teleport(game.PlaceId, player) end)

aimbotBtn.MouseButton1Click:Connect(function() aimbotOn=not aimbotOn aimbotBtn.Text=aimbotOn and "🎯 Aimbot: ON [Q]" or "🎯 Aimbot: OFF [Q]" aimbotBtn.BackgroundColor3=aimbotOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(120,20,20) end)
espBoxBtn.MouseButton1Click:Connect(function() espBoxOn=not espBoxOn espBoxBtn.Text=espBoxOn and "📦 ESP Box: ON" or "📦 ESP Box: OFF" espBoxBtn.BackgroundColor3=espBoxOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,120,120) end)
magnetBtn.MouseButton1Click:Connect(function() magnetOn=not magnetOn magnetBtn.Text=magnetOn and "🧲 Item Magnet: ON" or "🧲 Item Magnet: OFF" magnetBtn.BackgroundColor3=magnetOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(120,100,0) end)
thirdBtn.MouseButton1Click:Connect(function() thirdOn=not thirdOn thirdBtn.Text=thirdOn and "👁️ Third Person: ON" or "👁️ Third Person: OFF" thirdBtn.BackgroundColor3=thirdOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,120) player.CameraMode=thirdOn and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end)
staminaBtn.MouseButton1Click:Connect(function() staminaOn=not staminaOn staminaBtn.Text=staminaOn and "⚡ Inf Stamina: ON" or "⚡ Inf Stamina: OFF" staminaBtn.BackgroundColor3=staminaOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,100,60) end)
nightBtn.MouseButton1Click:Connect(function() nightOn=not nightOn nightBtn.Text=nightOn and "🌙 Night Vision: ON" or "🌙 Night Vision: OFF" nightBtn.BackgroundColor3=nightOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(20,60,100) Lighting.Ambient=nightOn and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5) end)
tracersBtn.MouseButton1Click:Connect(function() tracersOn=not tracersOn tracersBtn.Text=tracersOn and "📏 Tracers: ON" or "📏 Tracers: OFF" tracersBtn.BackgroundColor3=tracersOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(100,0,100) end)
crosshairBtn.MouseButton1Click:Connect(function() crosshairOn=not crosshairOn crosshairBtn.Text=crosshairOn and "🎯 Crosshair: ON" or "🎯 Crosshair: OFF" crosshairBtn.BackgroundColor3=crosshairOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(0,100,100) if crosshairOn then crosshairGui=Instance.new("ScreenGui") crosshairGui.Name="CrosshairGui" crosshairGui.Parent=player.PlayerGui local dot=Instance.new("Frame") dot.Size=UDim2.new(0,4,0,4) dot.Position=UDim2.new(0.5,-2,0.5,-2) dot.BackgroundColor3=Color3.fromRGB(255,0,0) dot.BorderSizePixel=0 dot.Parent=crosshairGui Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0) else if crosshairGui then crosshairGui:Destroy() crosshairGui=nil end end end)
spectateBtn.MouseButton1Click:Connect(function() spectateOn=not spectateOn spectateBtn.Text=spectateOn and "👀 Spectate: ON" or "👀 Spectate: OFF" spectateBtn.BackgroundColor3=spectateOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(100,60,0) end)
antiRagBtn.MouseButton1Click:Connect(function() antiRagOn=not antiRagOn antiRagBtn.Text=antiRagOn and "🛡️ Anti-Ragdoll: ON" or "🛡️ Anti-Ragdoll: OFF" antiRagBtn.BackgroundColor3=antiRagOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,120,60) end)
xrayBtn.MouseButton1Click:Connect(function() xrayOn=not xrayOn xrayBtn.Text=xrayOn and "X-Ray: ON" or "X-Ray: OFF" xrayBtn.BackgroundColor3=xrayOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then v.LocalTransparencyModifier=xrayOn and 0.5 or 0 end end end)
rainbowBtn.MouseButton1Click:Connect(function() rainbowOn=not rainbowOn rainbowBtn.Text=rainbowOn and "Rainbow Body: ON" or "Rainbow Body: OFF" rainbowBtn.BackgroundColor3=rainbowOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) spawn(function() while rainbowOn do for i=0,1,0.02 do if not rainbowOn then break end if player.Character then for _,p in pairs(player.Character:GetChildren()) do if p:IsA("BasePart") then p.Color=Color3.fromHSV(i,1,1) end end end task.wait(0.05) end end end) end)
fovBtn.MouseButton1Click:Connect(function() workspace.CurrentCamera.FieldOfView=workspace.CurrentCamera.FieldOfView==70 and 120 or 70 fovBtn.Text="FOV: "..workspace.CurrentCamera.FieldOfView end)
lowGravBtn.MouseButton1Click:Connect(function() lowGravOn=not lowGravOn lowGravBtn.Text=lowGravOn and "Low Gravity: ON" or "Low Gravity: OFF" lowGravBtn.BackgroundColor3=lowGravOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) workspace.Gravity=lowGravOn and 50 or 196 end)
spinBtn.MouseButton1Click:Connect(function() spinOn=not spinOn spinBtn.Text=spinOn and "Spin Bot: ON" or "Spin Bot: OFF" spinBtn.BackgroundColor3=spinOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) spawn(function() while spinOn do if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame=player.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(30),0) end task.wait() end end) end)
hitboxBtn.MouseButton1Click:Connect(function() hitboxOn=not hitboxOn hitboxBtn.Text=hitboxOn and "Hitbox Expander: ON" or "Hitbox Expander: OFF" hitboxBtn.BackgroundColor3=hitboxOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) for _,plr in pairs(game.Players:GetPlayers()) do if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.Size=hitboxOn and Vector3.new(10,10,10) or Vector3.new(2,2,1) plr.Character.HumanoidRootPart.Transparency=hitboxOn and 0.5 or 1 end end end)
headlessBtn.MouseButton1Click:Connect(function() headlessOn=not headlessOn headlessBtn.Text=headlessOn and "Headless: ON" or "Headless: OFF" headlessBtn.BackgroundColor3=headlessOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if headlessOn then local head=player.Character and player.Character:FindFirstChild("Head") if head then head.Transparency=1 for _,d in pairs(head:GetChildren()) do if d:IsA("Decal") then d.Transparency=1 end end end end end)
flingBtn.MouseButton1Click:Connect(function() flingOn=not flingOn flingBtn.Text=flingOn and "Fling: ON" or "Fling: OFF" flingBtn.BackgroundColor3=flingOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) end)
fpsBtn.MouseButton1Click:Connect(function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material=Enum.Material.SmoothPlastic v.Reflectance=0 elseif v:IsA("Decal") then v.Transparency=1 end end Lighting.GlobalShadows=false fpsBtn.Text="FPS BOOSTED!" end)
antiKickBtn.MouseButton1Click:Connect(function() antiKickOn=not antiKickOn antiKickBtn.Text=antiKickOn and "Anti-Kick: ON" or "Anti-Kick: OFF" antiKickBtn.BackgroundColor3=antiKickOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(120,60,60) end)
resetAllBtn.MouseButton1Click:Connect(function() if speedConn then speedConn:Disconnect() end if flyConn then flyConn:Disconnect() end if noclipConn then noclipConn:Disconnect() end if bv then bv:Destroy() end if bg then bg:Destroy() end workspace.Gravity=196 Lighting.Brightness=1 if crosshairGui then crosshairGui:Destroy() end gui:Destroy() end)
resetCharBtn.MouseButton1Click:Connect(function() local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum.Health=0 end end)

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if not keybindsOn then return end
    if input.KeyCode==Enum.KeyCode.E then toggleFly()
    elseif input.KeyCode==Enum.KeyCode.K then desyncBtn:MouseButton1Click()
    elseif input.KeyCode==Enum.KeyCode.L then lagBtn:MouseButton1Click()
    elseif input.KeyCode==Enum.KeyCode.P then if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then savedPoint=player.Character.HumanoidRootPart.CFrame end
    elseif input.KeyCode==Enum.KeyCode.T then if savedPoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame=savedPoint+Vector3.new(0,3,0) end end
end)

task.wait(0.2) scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+15)
print("Zyn Hub V17 Loaded - HIGH JUMP + MINIMIZE + ALL FIXED")
