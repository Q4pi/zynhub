-- Zyn Hub V15 FIXED CLICKS by Q4pi
pcall(function()
    local code = [[repeat task.wait() until game:IsLoaded() task.wait(2) loadstring(game:HttpGet("https://raw.githubusercontent.com/Q4pi/zynhub/main/main.lua"))()]]
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
frame.Size = UDim2.new(0, 285, 0, 460)
frame.Position = UDim2.new(0, 40, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", frame) stroke.Color = Color3.fromRGB(80,40,120) stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Zyn Hub V15 FIXED"
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
minimizeBtn.ZIndex = 10
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-28,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.ZIndex = 10
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1, -20, 0, 28)
searchBox.Position = UDim2.new(0,10,0,32)
searchBox.BackgroundColor3 = Color3.fromRGB(35,35,50)
searchBox.Text = ""
searchBox.PlaceholderText = "Поиск..."
searchBox.ClearTextOnFocus = false
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.ZIndex = 10
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0,10,0,65)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,2400)
scroll.ScrollBarThickness = 4
scroll.Active = true
scroll.ZIndex = 5

local function makeButton(text, y, color)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1,-10,0,30)
	b.Position = UDim2.new(0,0,0,y)
	b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.ZIndex = 6
	b.Active = true
	b.Selectable = true
	b.Name = text
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

-- тут все твои кнопки
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

-- ПОИСК ФИКС
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

-- ВЕСЬ ТВОЙ КОД ДАЛЬШЕ (я сократил чтобы не спамить, вставь свой старый код начиная с local speedOn...)
-- Просто скопируй отсюда до конца из прошлого файла V15

-- Быстрый тест кнопок:
speedBtn.MouseButton1Click:Connect(function() print("Speed works!") end)

-- ЗАГЛУШКА ДЛЯ ОСТАЛЬНОГО - вставь свой старый код функций сюда
-- Чтобы не потерять функции, просто замени ВЕРХНЮЮ ЧАСТЬ (до кнопок) в своем старом файле на эту новую

-- Кнопка закрытия
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
local minimized = false
local oldFrameSize = frame.Size
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then oldFrameSize = frame.Size scroll.Visible = false searchBox.Visible=false frame.Size = UDim2.new(0, 200, 0, 32) minimizeBtn.Text = "+" else frame.Size = oldFrameSize scroll.Visible = true searchBox.Visible=true minimizeBtn.Text = "-" end
end)
