-- Zyn Hub V16 NO SEARCH - FULL FIXED by Q4pi
pcall(function()
    local code = [[repeat task.wait() until game:IsLoaded() task.wait(2) loadstring(game:HttpGet("https://raw.githubusercontent.com/Q4pi/zynhub/main/main.lua"))()]]
    if queue_on_teleport then queue_on_teleport(code) end
end)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

if player.PlayerGui:FindFirstChild("ZynHubGui") then player.PlayerGui.ZynHubGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZynHubGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 450)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", frame) stroke.Color = Color3.fromRGB(120,60,255) stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-70,0,30)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Zyn Hub V16"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(150,100,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,4)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-16,1,-38)
scroll.Position = UDim2.new(0,8,0,34)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 3
scroll.Active = true

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding", scroll) pad.PaddingTop=UDim.new(0,2) pad.PaddingLeft=UDim.new(0,2) pad.PaddingRight=UDim.new(0,2)

local function makeButton(text, color)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1,-6,0,30)
    b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.AutoButtonColor = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- VARIABLES
local speedOn, jumpOn, flyOn, noclipOn, infJumpOn, espOn, fbOn, clickTPOn, godOn, afkOn = false,false,false,false,false,false,false,false,false,false
local speedConn, flyConn, noclipConn
local savedPoint = nil

-- 1 SPEED CFrame
local speedBtn = makeButton("Speed: OFF (25)")
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        speedBtn.Text = "Speed: ON (25)" speedBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        speedConn = RunService.Heartbeat:Connect(function()
            local char = player.Character local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and player.Character:FindFirstChildOfClass("Humanoid").MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + player.Character:FindFirstChildOfClass("Humanoid").MoveDirection * 1.2
            end
        end)
    else speedBtn.Text="Speed: OFF (25)" speedBtn.BackgroundColor3=Color3.fromRGB(40,40,60) if speedConn then speedConn:Disconnect() end end
end)

-- 2 JUMP
local jumpBtn = makeButton("Jump 50 -> 120")
jumpBtn.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then if hum.JumpPower < 100 then hum.JumpPower=120 hum.JumpHeight=120 jumpBtn.Text="Jump 120 (ON)" jumpBtn.BackgroundColor3=Color3.fromRGB(0,170,0) else hum.JumpPower=50 hum.JumpHeight=7.2 jumpBtn.Text="Jump 50 -> 120" jumpBtn.BackgroundColor3=Color3.fromRGB(40,40,60) end end
end)

-- 3 FLY
local flyBtn = makeButton("Fly: OFF [E]")
local bv, bg
flyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    local char = player.Character local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyOn then
        flyBtn.Text="Fly: ON [E]" flyBtn.BackgroundColor3=Color3.fromRGB(0,170,0)
        bv = Instance.new("BodyVelocity", hrp) bv.MaxForce=Vector3.new(1e9,1e9,1e9) bv.Velocity=Vector3.zero
        bg = Instance.new("BodyGyro", hrp) bg.MaxTorque=Vector3.new(1e9,1e9,1e9) bg.CFrame=hrp.CFrame
        flyConn = RunService.Heartbeat:Connect(function()
            local cam = workspace.CurrentCamera
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move+=cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move-=cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move-=cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move+=cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then move+=Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move-=Vector3.new(0,1,0) end
            bv.Velocity = move * 60
            bg.CFrame = cam.CFrame
        end)
    else flyBtn.Text="Fly: OFF [E]" flyBtn.BackgroundColor3=Color3.fromRGB(40,40,60) if flyConn then flyConn:Disconnect() end if bv then bv:Destroy() end if bg then bg:Destroy() end
    end
end)

-- 4 NOCLIP
local noclipBtn = makeButton("Noclip: OFF")
noclipBtn.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    if noclipOn then noclipBtn.Text="Noclip: ON" noclipBtn.BackgroundColor3=Color3.fromRGB(0,170,0)
        noclipConn = RunService.Stepped:Connect(function() if player.Character then for _,v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end)
    else noclipBtn.Text="Noclip: OFF" noclipBtn.BackgroundColor3=Color3.fromRGB(40,40,60) if noclipConn then noclipConn:Disconnect() end end
end)

-- 5 INF JUMP
local infJumpBtn = makeButton("Inf Jump: OFF")
infJumpBtn.MouseButton1Click:Connect(function() infJumpOn=not infJumpOn infJumpBtn.Text=infJumpOn and "Inf Jump: ON" or "Inf Jump: OFF" infJumpBtn.BackgroundColor3=infJumpOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) end)
UserInputService.JumpRequest:Connect(function() if infJumpOn then local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

-- 6 ESP
local espBtn = makeButton("ESP: OFF")
espBtn.MouseButton1Click:Connect(function()
    espOn=not espOn espBtn.Text=espOn and "ESP: ON" or "ESP: OFF" espBtn.BackgroundColor3=espOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60)
    for _,plr in pairs(game.Players:GetPlayers()) do if plr~=player and plr.Character then if espOn then if not plr.Character:FindFirstChild("ESP_H") then local h=Instance.new("Highlight",plr.Character) h.Name="ESP_H" h.FillColor=Color3.fromRGB(255,0,0) h.OutlineColor=Color3.new(1,1,1) end else local h=plr.Character:FindFirstChild("ESP_H") if h then h:Destroy() end end end end
end)

-- 7 FULLBRIGHT
local fbBtn = makeButton("Fullbright: OFF")
fbBtn.MouseButton1Click:Connect(function() fbOn=not fbOn if fbOn then Lighting.Brightness=2 Lighting.ClockTime=14 Lighting.FogEnd=1e9 fbBtn.Text="Fullbright: ON" fbBtn.BackgroundColor3=Color3.fromRGB(0,170,0) else Lighting.Brightness=1 Lighting.ClockTime=14 Lighting.FogEnd=100000 fbBtn.Text="Fullbright: OFF" fbBtn.BackgroundColor3=Color3.fromRGB(40,40,60) end end)

-- 8 CLICK TP
local clickTPBtn = makeButton("Click TP: OFF")
clickTPBtn.MouseButton1Click:Connect(function() clickTPOn=not clickTPOn clickTPBtn.Text=clickTPOn and "Click TP: ON (CTRL+CLICK)" or "Click TP: OFF" clickTPBtn.BackgroundColor3=clickTPOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) end)
UserInputService.InputBegan:Connect(function(input) if clickTPOn and input.UserInputType==Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local mouse=player:GetMouse() if mouse.Hit then player.Character.HumanoidRootPart.CFrame=CFrame.new(mouse.Hit.p+Vector3.new(0,3,0)) end end end)

-- 9 SAVE POINT
local setPointBtn = makeButton("📍 Поставить точку [P]", Color3.fromRGB(60,60,120))
local tpPointBtn = makeButton("🚀 ТП на точку [T]", Color3.fromRGB(60,120,60))
setPointBtn.MouseButton1Click:Connect(function() local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then savedPoint=hrp.CFrame setPointBtn.Text="Точка: СОХРАНЕНА!" task.wait(1) setPointBtn.Text="📍 Поставить точку [P]" end end)
tpPointBtn.MouseButton1Click:Connect(function() if savedPoint then player.Character.HumanoidRootPart.CFrame=savedPoint end end)
UserInputService.InputBegan:Connect(function(i,g) if g then return end if i.KeyCode==Enum.KeyCode.P then local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then savedPoint=hrp.CFrame end elseif i.KeyCode==Enum.KeyCode.T then if savedPoint then player.Character.HumanoidRootPart.CFrame=savedPoint end end end)

-- 10 GOD
local godBtn = makeButton("God Mode: OFF")
godBtn.MouseButton1Click:Connect(function() godOn=not godOn godBtn.Text=godOn and "God Mode: ON" or "God Mode: OFF" godBtn.BackgroundColor3=godOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if godOn then local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid") if hum then hum.MaxHealth=math.huge hum.Health=math.huge end end end)

-- 11 ANTI AFK
local afkBtn = makeButton("Anti-AFK: OFF")
afkBtn.MouseButton1Click:Connect(function() afkOn=not afkOn afkBtn.Text=afkOn and "Anti-AFK: ON" or "Anti-AFK: OFF" afkBtn.BackgroundColor3=afkOn and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,60) if afkOn then for _,c in pairs(getconnections(player.Idled)) do c:Disable() end end end)

-- 12 FOV
local fovBtn = makeButton("FOV 70 -> 120")
fovBtn.MouseButton1Click:Connect(function() local cam=workspace.CurrentCamera cam.FieldOfView = cam.FieldOfView==70 and 120 or 70 fovBtn.Text="FOV: "..cam.FieldOfView end)

-- 13 FPS BOOST
local fpsBtn = makeButton("FPS BOOST", Color3.fromRGB(60,120,60))
fpsBtn.MouseButton1Click:Connect(function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material=Enum.Material.SmoothPlastic v.Reflectance=0 elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end Lighting.GlobalShadows=false Lighting.FogEnd=1e9 fpsBtn.Text="FPS BOOSTED!" end)

-- 14 REJOIN
local rejoinBtn = makeButton("Rejoin Server", Color3.fromRGB(60,60,120))
rejoinBtn.MouseButton1Click:Connect(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)

-- 15 SERVER HOP
local hopBtn = makeButton("Server Hop [AUTOLOAD]", Color3.fromRGB(60,60,150))
hopBtn.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, player) end)

-- 16 RESET
local resetBtn = makeButton("🔄 СБРОСИТЬ ВСЕ", Color3.fromRGB(170,40,40))
resetBtn.MouseButton1Click:Connect(function() if speedConn then speedConn:Disconnect() end if flyConn then flyConn:Disconnect() end if noclipConn then noclipConn:Disconnect() end if bv then bv:Destroy() end if bg then bg:Destroy() end Lighting.Brightness=1 gui:Destroy() end)

task.wait(0.1) scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
print("Zyn Hub V16 Loaded - No Search, All Fixed!")
