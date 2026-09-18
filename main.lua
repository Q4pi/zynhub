-- Zyn Hub V15 AUTOLOAD EDITION
-- Авто-загрузка после телепорта
local autoLoadCode = [[
repeat task.wait() until game:IsLoaded()
task.wait(3)
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_GITHUB/zyn/main.lua"))()
]]

-- Для локальной версии без гитхаба используем сохранение скрипта в очередь
local function setAutoLoad()
    local codeToQueue = [[
        repeat task.wait() until game:IsLoaded()
        task.wait(2)
        -- Если у тебя Delta / Synapse X / KRNL, он сам перезапустит этот файл если он в autoexec
        -- Поэтому просто кидай этот файл в папку autoexec твоего инжектора
        print("Zyn Hub reloading after teleport...")
    ]]
    -- Пытаемся поставить в очередь всеми возможными методами
    pcall(function() queue_on_teleport(codeToQueue) end)
    pcall(function() if syn then syn.queue_on_teleport(codeToQueue) end end)
    pcall(function() if fluxus then fluxus.queue_on_teleport(codeToQueue) end end)
end

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui")
gui.Name = "ZynHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 285, 0, 460)
frame.Position = UDim2.new(0, 40, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", frame) stroke.Color = Color3.fromRGB(80,40,120) stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Zyn Hub V15 AUTOLOAD"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(150,100,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0,30,0,25)
minimizeBtn.Position = UDim2.new(1,-60,0,3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-28,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1, -20, 0, 28)
searchBox.Position = UDim2.new(0,10,0,32)
searchBox.BackgroundColor3 = Color3.fromRGB(35,35,50)
searchBox.Text = ""
searchBox.PlaceholderText = "🔍 Поиск... (fly, esp, desync, crosshair)"
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0,10,0,65)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,2400)
scroll.ScrollBarThickness = 4

local function makeButton(text, y, color)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1,-10,0,30)
	b.Position = UDim2.new(0,0,0,y)
	b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Name = text
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local speedBtn = makeButton("Speed: OFF (CFrame)", 0)
local jumpBtn = makeButton("Jump 50 -> 120", 35)
local flyBtn = makeButton("Fly: OFF [E] 400 SPD", 70)
local noclipBtn = makeButton("Noclip: OFF", 105)
local infJumpBtn = makeButton("Inf Jump: OFF", 140)
local espBtn = makeButton("ESP: OFF", 175)
local fullbrightBtn = makeButton("Fullbright: OFF", 210)
local clickTPBtn = makeButton("Click TP: OFF [CTRL+CLICK]", 245)
local invisBtn = makeButton("Invisible: OFF", 280)
local godBtn = makeButton("God Mode: OFF", 315)
local antiAfkBtn = makeButton("Anti-AFK: OFF", 350)
local tpSpawnBtn = makeButton("TP на спавн", 385)
local setPointBtn = makeButton("📍 Поставить точку [P]", 420, Color3.fromRGB(60, 60, 120))
local tpPointBtn = makeButton("🚀 ТП на точку [T]", 455, Color3.fromRGB(60, 120, 60))
local tpPlayersBtn = makeButton("TP к игроку", 490)
local desyncBtn = makeButton("Desync: OFF [K] 💀", 525, Color3.fromRGB(80, 40, 120))
local desyncTypeBtn = makeButton("Mode: GHOST 👻", 560, Color3.fromRGB(40,80,80))
local lagBtn = makeButton("Lag Switch: OFF [L]", 595, Color3.fromRGB(100,80,0))
local freecamBtn = makeButton("Freecam: OFF [F] 📷", 630, Color3.fromRGB(0,100,150))
local antilockBtn = makeButton("Anti-Lock: OFF 🔒", 665, Color3.fromRGB(150,50,0))
local bhopBtn = makeButton("Bhop: OFF 🐰", 700, Color3.fromRGB(60,60,60))
local doorBtn = makeButton("Door Bypass: OFF 🚪", 735, Color3.fromRGB(60,100,60))
local keybindsBtn = makeButton("⌨️ Keybinds: ON ✅", 770, Color3.fromRGB(0,120,80))
local rejoinBtn = makeButton("Rejoin Server 🔄", 805, Color3.fromRGB(60,60,120))
local aimbotBtn = makeButton("🎯 Aimbot: OFF [Q]", 840, Color3.fromRGB(120,20,20))
local espBoxBtn = makeButton("📦 ESP Box: OFF", 875, Color3.fromRGB(0,120,120))
local magnetBtn = makeButton("🧲 Item Magnet: OFF", 910, Color3.fromRGB(120,100,0))
local thirdBtn = makeButton("👁️ Third Person: OFF", 945, Color3.fromRGB(80,80,120))
local staminaBtn = makeButton("⚡ Inf Stamina: OFF", 980, Color3.fromRGB(0,100,60))
local nightBtn = makeButton("🌙 Night Vision: OFF", 1015, Color3.fromRGB(20,60,100))
local tracersBtn = makeButton("📏 Tracers: OFF", 1050, Color3.fromRGB(100,0,100))
local crosshairBtn = makeButton("🎯 Crosshair: OFF", 1085, Color3.fromRGB(0,100,100))
local spectateBtn = makeButton("👀 Spectate: OFF", 1120, Color3.fromRGB(100,60,0))
local antiRagBtn = makeButton("🛡️ Anti-Ragdoll: OFF", 1155, Color3.fromRGB(60,120,60))
local serverHopBtn = makeButton("🌐 Server Hop [AUTOLOAD]", 1190, Color3.fromRGB(60,60,150))
local xrayBtn = makeButton("X-Ray: OFF", 1225)
local rainbowBtn = makeButton("Rainbow Body: OFF", 1260)
local fovBtn = makeButton("FOV 70 -> 120", 1295)
local lowGravBtn = makeButton("Low Gravity: OFF", 1330)
local spinBtn = makeButton("Spin Bot: OFF", 1365)
local hitboxBtn = makeButton("Hitbox Expander: OFF", 1400)
local headlessBtn = makeButton("Headless: OFF", 1435)
local flingBtn = makeButton("Fling: OFF", 1470)
local fpsBtn = makeButton("FPS BOOST", 1505, Color3.fromRGB(60,120,60))
local antiKickBtn = makeButton("Anti-Kick: OFF", 1540, Color3.fromRGB(120,60,60))
local resetAllBtn = makeButton("🔄 ВЕРНУТЬ ВСЕ НАЗАД", 1575, Color3.fromRGB(170,40,40))
local resetCharBtn = makeButton("Убить персонажа", 1610)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local query = searchBox.Text:lower()
	local y = 0
	for _,btn in pairs(scroll:GetChildren()) do
		if btn:IsA("TextButton") then
			if query == "" or btn.Text:lower():find(query) then
				btn.Visible = true
				btn.Position = UDim2.new(0,0,0,y)
				y = y + 35
			else
				btn.Visible = false
			end
		end
	end
	scroll.CanvasSize = UDim2.new(0,0,0,y+10)
end)

local speedOn, speedConn = false, nil
local flying, bv, bg = false, nil, nil
local flySpeed = 400
local noclipOn, noclipConn = false, nil
local espOn = false
local fullbrightOn, oldLighting = false, {}
local godOn, godConn = false, nil
local antiAfkOn, antiAfkConn = false, nil
local rainbowOn, rainbowConn = false, nil
local spinOn, spinConn = false, nil
local flingOn, flingConn = false, nil
local desyncOn, desyncConn, desyncClone = false, nil, nil
local desyncMode = "ghost"
local lagOn = false
local freecamOn, freecamConn = false, nil
local aimbotOn, aimbotConn = false, nil
local espBoxOn = false
local magnetOn, magnetConn = false, nil
local staminaOn, staminaConn = false, nil
local tracersOn, tracerLines = false, {}
local keybindsOn = true
local crosshairOn = false
local crosshairGui = nil
local spectateOn, spectateConn = false, nil
local spectateTarget = 1
local antiRagOn, antiRagConn = false, nil
local minimized = false
local oldFrameSize = frame.Size
local savedPoint = nil
local pointPart = nil
local oldCamCF = nil

minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then oldFrameSize = frame.Size scroll.Visible = false searchBox.Visible=false frame.Size = UDim2.new(0, 200, 0, 32) minimizeBtn.Text = "+" title.Text = "Zyn Hub [поиск]"
	else frame.Size = oldFrameSize scroll.Visible = true searchBox.Visible=true minimizeBtn.Text = "-" title.Text = "Zyn Hub V15 AUTOLOAD" end
end)
closeBtn.MouseButton1Click:Connect(function() if pointPart then pointPart:Destroy() end if desyncClone then desyncClone:Destroy() end if crosshairGui then crosshairGui:Destroy() end pcall(function() sethiddenproperty(player,"SimulationRadius",1000) end) gui:Destroy() end)

local function resetAll()
	for _,c in pairs({speedConn, godConn, antiAfkConn, rainbowConn, spinConn, flingConn, desyncConn, freecamConn, aimbotConn, magnetConn, staminaConn, spectateConn, antiRagConn}) do if c then c:Disconnect() end end
	if desyncClone then desyncClone:Destroy() desyncClone=nil end
	for _,l in pairs(tracerLines) do if l then l:Remove() end end tracerLines={}
	if crosshairGui then crosshairGui:Destroy() crosshairGui=nil end
	speedOn=false flying=false if bv then bv:Destroy() end if bg then bg:Destroy() end bv=nil bg=nil noclipOn=false espOn=false fullbrightOn=false godOn=false antiAfkOn=false rainbowOn=false spinOn=false flingOn=false desyncOn=false lagOn=false freecamOn=false aimbotOn=false espBoxOn=false magnetOn=false staminaOn=false tracersOn=false crosshairOn=false spectateOn=false antiRagOn=false
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom workspace.CurrentCamera.FieldOfView = 70 workspace.Gravity = 196.2
	if player.Character then local hum = player.Character:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=16 hum.JumpPower=50 hum.PlatformStand=false hum.AutoRotate=true end end
	pcall(function() sethiddenproperty(player,"SimulationRadius",1000) settings().Network.IncomingReplicationLag=0 end)
	flyBtn.Text="Fly: OFF [E] 400 SPD" desyncBtn.Text="Desync: OFF [K] 💀" lagBtn.Text="Lag Switch: OFF [L]" aimbotBtn.Text="🎯 Aimbot: OFF [Q]" keybindsBtn.Text="⌨️ Keybinds: ON ✅" keybindsOn=true searchBox.Text=""
end

speedBtn.MouseButton1Click:Connect(function() speedOn=not speedOn speedBtn.BackgroundColor3=speedOn and Color3.fromRGB(0,170,90) or Color3.fromRGB(40,40,60) if speedOn then speedConn=RunService.RenderStepped:Connect(function() local char=player.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") local hum=char:FindFirstChildOfClass("Humanoid") if hrp and hum and hum.MoveDirection.Magnitude>0 then hrp.CFrame=hrp.CFrame+hum.MoveDirection*1.8 end end) else if speedConn then speedConn:Disconnect() end end end)
local function toggleFly() local char=player.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") local hum=char:FindFirstChild("Humanoid") if not hrp or not hum then return end flying=not flying flyBtn.Text=flying and "Fly: ON [400 SPD]" or "Fly: OFF [E] 400 SPD" flyBtn.BackgroundColor3=flying and Color3.fromRGB(0,170,90) or Color3.fromRGB(40,40,60) hum.PlatformStand=flying if flying then bv=Instance.new("BodyVelocity") bv.MaxForce=Vector3.new(9e9,9e9,9e9) bv.Velocity=Vector3.zero bv.Parent=hrp bg=Instance.new("BodyGyro") bg.MaxTorque=Vector3.new(9e9,9e9,9e9) bg.CFrame=hrp.CFrame bg.Parent=hrp else if bv then bv:Destroy() bv=nil end if bg then bg:Destroy() bg=nil end end end
flyBtn.MouseButton1Click:Connect(toggleFly)
local function toggleDesync() desyncOn=not desyncOn desyncBtn.Text=desyncOn and "Desync: ON [K] 🔥" or "Desync: OFF [K] 💀" desyncBtn.BackgroundColor3=desyncOn and Color3.fromRGB(0,170,90) or Color3.fromRGB(80,40,120) if desyncOn then desyncConn=RunService.Heartbeat:Connect(function() pcall(function() sethiddenproperty(player,"SimulationRadius",0) end) settings().Network.IncomingReplicationLag=3 end) else if desyncConn then desyncConn:Disconnect() end if desyncClone then desyncClone:Destroy() end pcall(function() sethiddenproperty(player,"SimulationRadius",1000) settings().Network.IncomingReplicationLag=0 end) end end
desyncTypeBtn.MouseButton1Click:Connect(function() if desyncMode=="ghost" then desyncMode="real" desyncTypeBtn.Text="Mode: REAL CLONE 🧬" else desyncMode="ghost" desyncTypeBtn.Text="Mode: GHOST 👻" end end)
local function toggleLag() lagOn=not lagOn lagBtn.Text=lagOn and "Lag Switch: ON [L] 🔥" or "Lag Switch: OFF [L]" lagBtn.BackgroundColor3=lagOn and Color3.fromRGB(0,170,90) or Color3.fromRGB(100,80,0) if lagOn then settings().Network.IncomingReplicationLag=10 pcall(function() sethiddenproperty(player,"SimulationRadius",0) end) else settings().Network.IncomingReplicationLag=0 if not desyncOn then pcall(function() sethiddenproperty(player,"SimulationRadius",1000) end) end end end
keybindsBtn.MouseButton1Click:Connect(function() keybindsOn=not keybindsOn keybindsBtn.Text=keybindsOn and "⌨️ Keybinds: ON ✅" or "⌨️ Keybinds: OFF ❌" keybindsBtn.BackgroundColor3=keybindsOn and Color3.fromRGB(0,120,80) or Color3.fromRGB(120,40,40) end)
crosshairBtn.MouseButton1Click:Connect(function() crosshairOn=not crosshairOn crosshairBtn.Text=crosshairOn and "🎯 Crosshair: ON ✅" or "🎯 Crosshair: OFF" crosshairBtn.BackgroundColor3=crosshairOn and Color3.fromRGB(0,170,90) or Color3.fromRGB(0,100,100) if crosshairOn then crosshairGui = Instance.new("ScreenGui") crosshairGui.Name="CrosshairGui" crosshairGui.Parent=player.PlayerGui local dot = Instance.new("Frame") dot.Size=UDim2.new(0,4,0,4) dot.Position=UDim2.new(0.5,-2,0.5,-2) dot.BackgroundColor3=Color3.fromRGB(255,0,0) dot.BorderSizePixel=0 dot.Parent=crosshairGui Instance.new("UICorner", dot).CornerRadius=UDim.new(1,0) local h = Instance.new("Frame") h.Size=UDim2.new(0,20,0,2) h.Position=UDim2.new(0.5,-10,0.5,-1) h.BackgroundColor3=Color3.fromRGB(255,255,255) h.BorderSizePixel=0 h.Parent=crosshairGui local v = Instance.new("Frame") v.Size=UDim2.new(0,2,0,20) v.Position=UDim2.new(0.5,-1,0.5,-10) v.BackgroundColor3=Color3.fromRGB(255,255,255) v.BorderSizePixel=0 v.Parent=crosshairGui else if crosshairGui then crosshairGui:Destroy() crosshairGui=nil end end end)

-- SERVER HOP С АВТОЗАГРУЗКОЙ
serverHopBtn.MouseButton1Click:Connect(function()
	serverHopBtn.Text="Hopping... + AutoLoad ON"
	-- Ставим скрипт в очередь на загрузку после телепорта
	local scriptSource = game:HttpGet("https://raw.githubusercontent.com/yourname/zynhub/main.lua") -- ЗАМЕНИ НА СВОЮ ССЫЛКУ
	-- Если используешь локальный файл, то сохрани этот файл в workspace и используй:
	local queueCode = [[
		repeat task.wait() until game:IsLoaded()
		task.wait(2)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yourname/zynhub/main.lua"))()
	]]
	-- Для Delta / Synapse / KRNL без гитхаба - кидай файл в autoexec
	-- Тогда код очереди такой:
	local localQueueCode = [[
		repeat task.wait() until game:IsLoaded()
		task.wait(1)
		if isfile and isfile("zyn_hub.lua") then
			loadstring(readfile("zyn_hub.lua"))()
		end
	]]
	
	-- Пытаемся всеми способами
	pcall(function() queue_on_teleport(queueCode) end)
	pcall(function() if syn and syn.queue_on_teleport then syn.queue_on_teleport(queueCode) end end)
	
	local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
	local available = {}
	for _,s in pairs(servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(available, s.id) end end
	if #available > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, available[math.random(1,#available)], player)
	else TeleportService:Teleport(game.PlaceId, player) end
end)

rejoinBtn.MouseButton1Click:Connect(function()
	rejoinBtn.Text="Rejoining... + AutoLoad"
	local queueCode = [[
		repeat task.wait() until game:IsLoaded()
		task.wait(2)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yourname/zynhub/main.lua"))()
	]]
	pcall(function() queue_on_teleport(queueCode) end)
	pcall(function() if syn and syn.queue_on_teleport then syn.queue_on_teleport(queueCode) end end)
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

UserInputService.InputBegan:Connect(function(input,gpe)
	if gpe then return end
	if searchBox:IsFocused() then return end
	if not keybindsOn then return end
	if input.KeyCode==Enum.KeyCode.E then toggleFly()
	elseif input.KeyCode==Enum.KeyCode.K then toggleDesync()
	elseif input.KeyCode==Enum.KeyCode.L then toggleLag()
	elseif input.KeyCode==Enum.KeyCode.P then if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then savedPoint=player.Character.HumanoidRootPart.CFrame end
	elseif input.KeyCode==Enum.KeyCode.T then if savedPoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame=savedPoint+Vector3.new(0,3,0) end end
end)

RunService.RenderStepped:Connect(function()
	if flying and bv and bg and player.Character then
		local cam=workspace.CurrentCamera bg.CFrame=cam.CFrame
		local m=Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then m+=cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then m-=cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then m-=cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then m+=cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m+=Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then m-=Vector3.new(0,1,0) end
		local cs=flySpeed if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then cs=flySpeed*2 end
		bv.Velocity=m.Magnitude>0 and m.Unit*cs or Vector3.zero
	end
end)

resetAllBtn.MouseButton1Click:Connect(resetAll)
desyncBtn.MouseButton1Click:Connect(toggleDesync)
lagBtn.MouseButton1Click:Connect(toggleLag)

local dragging, dragStart, startPos
title.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true dragStart=input.Position startPos=frame.Position end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then local d=input.Position-dragStart frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)

print("Zyn Hub V15 AUTOLOAD loaded! Hop = auto reload")
