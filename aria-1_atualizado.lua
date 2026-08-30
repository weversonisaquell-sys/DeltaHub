--[[
    DELTA HUB — Painel estilo Windows 11
    Atualizado:
      - Sistema de abas
      - Aba Principal + Aba Coils
      - Fly corrigido
      - Controles mobile na tela para subir/descer
      - Click TP toggle
      - Speed Tool
      - Jump Tool
      - Fusion Tool
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    return
end

local Mouse = LocalPlayer:GetMouse()

----------------------------------------------------------------
-- HELPERS BASE
----------------------------------------------------------------
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid")
end

local function getBackpack()
    return LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack", 5)
end

local function removeIfExists(name)
    local removed = false
    local backpack = getBackpack()
    local char = LocalPlayer.Character

    if backpack and backpack:FindFirstChild(name) then
        backpack[name]:Destroy()
        removed = true
    end

    if char and char:FindFirstChild(name) then
        char[name]:Destroy()
        removed = true
    end

    return removed
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
pcall(function()
    if CoreGui:FindFirstChild("DeltaHubWin11") then
        CoreGui.DeltaHubWin11:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaHubWin11"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

pcall(function()
    gui.Parent = CoreGui
end)

if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Name = "Window"
main.Size = UDim2.fromOffset(420, 360)
main.Position = UDim2.new(0.5, -210, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(243, 243, 243)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(210, 210, 210)
stroke.Thickness = 1
stroke.Parent = main

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(251, 251, 251)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 8)
tbCorner.Parent = titleBar

local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 10)
tbFix.Position = UDim2.new(0, 0, 1, -10)
tbFix.BackgroundColor3 = titleBar.BackgroundColor3
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -120, 1, 0)
title.Font = Enum.Font.GothamMedium
title.Text = "Delta Hub"
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(32, 32, 32)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local function winBtn(txt, xOff, hoverColor, hoverText)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(46, 36)
    b.Position = UDim2.new(1, xOff, 0, 0)
    b.BackgroundColor3 = hoverColor
    b.BackgroundTransparency = 1
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Text = txt
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(32, 32, 32)
    b.Parent = titleBar

    b.MouseEnter:Connect(function()
        b.BackgroundTransparency = 0
        if hoverText then
            b.TextColor3 = hoverText
        end
    end)

    b.MouseLeave:Connect(function()
        b.BackgroundTransparency = 1
        b.TextColor3 = Color3.fromRGB(32, 32, 32)
    end)

    return b
end

local closeBtn = winBtn("✕", -46, Color3.fromRGB(232, 17, 35), Color3.fromRGB(255,255,255))
local minBtn = winBtn("—", -92, Color3.fromRGB(232,232,232))

----------------------------------------------------------------
-- BODY
----------------------------------------------------------------
local body = Instance.new("Frame")
body.BackgroundTransparency = 1
body.Position = UDim2.fromOffset(0, 36)
body.Size = UDim2.new(1, 0, 1, -36)
body.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(248,248,248)
sidebar.BorderSizePixel = 0
sidebar.Parent = body

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Color3.fromRGB(225,225,225)
sidebarStroke.Parent = sidebar

local pages = Instance.new("Frame")
pages.Position = UDim2.new(0, 120, 0, 0)
pages.Size = UDim2.new(1, -120, 1, 0)
pages.BackgroundTransparency = 1
pages.Parent = body

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 8)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebar

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 12)
sidebarPad.PaddingLeft = UDim.new(0, 6)
sidebarPad.PaddingRight = UDim.new(0, 6)
sidebarPad.Parent = sidebar

local function makePage(name)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = pages

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = frame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = frame

    return frame
end

local pageMain = makePage("Main")
local pageCoils = makePage("Coils")
local pageCool = makePage("Cool")
local pageEmotes = makePage("Emotes")
pageMain.Visible = true

local function makeTabButton(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -12, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(255,255,255)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = Color3.fromRGB(30,30,30)
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.Parent = sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b

    return b
end

local tabMain = makeTabButton("Principal", 1)
local tabCoils = makeTabButton("Coils", 2)
local tabCool = makeTabButton("Cool", 3)
local tabEmotes = makeTabButton("Emotes", 4)

local function switchTab(tab)
    pageMain.Visible = false
    pageCoils.Visible = false
    pageCool.Visible = false
    pageEmotes.Visible = false

    if tab == "Main" then
        pageMain.Visible = true
    elseif tab == "Coils" then
        pageCoils.Visible = true
    elseif tab == "Cool" then
        pageCool.Visible = true
    elseif tab == "Emotes" then
        pageEmotes.Visible = true
    end
end

tabMain.MouseButton1Click:Connect(function()
    switchTab("Main")
end)

tabCoils.MouseButton1Click:Connect(function()
    switchTab("Coils")
end)

tabCool.MouseButton1Click:Connect(function()
    switchTab("Cool")
end)

tabEmotes.MouseButton1Click:Connect(function()
    switchTab("Emotes")
end)

----------------------------------------------------------------
-- CARD
----------------------------------------------------------------
local function makeCard(parent, icon, name, desc, order)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(255,255,255)
    card.AutoButtonColor = false
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order
    card.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = card

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(228,228,228)
    s.Thickness = 1
    s.Parent = card

    local ic = Instance.new("TextLabel")
    ic.BackgroundTransparency = 1
    ic.Position = UDim2.fromOffset(12, 0)
    ic.Size = UDim2.fromOffset(32, 56)
    ic.Text = icon
    ic.TextSize = 20
    ic.Font = Enum.Font.GothamBold
    ic.TextColor3 = Color3.fromRGB(0, 95, 184)
    ic.Parent = card

    local nm = Instance.new("TextLabel")
    nm.BackgroundTransparency = 1
    nm.Position = UDim2.fromOffset(52, 10)
    nm.Size = UDim2.new(1, -140, 0, 18)
    nm.Font = Enum.Font.GothamMedium
    nm.Text = name
    nm.TextSize = 13
    nm.TextColor3 = Color3.fromRGB(26,26,26)
    nm.TextXAlignment = Enum.TextXAlignment.Left
    nm.Parent = card

    local ds = Instance.new("TextLabel")
    ds.BackgroundTransparency = 1
    ds.Position = UDim2.fromOffset(52, 28)
    ds.Size = UDim2.new(1, -140, 0, 16)
    ds.Font = Enum.Font.Gotham
    ds.Text = desc
    ds.TextSize = 11
    ds.TextColor3 = Color3.fromRGB(110,110,110)
    ds.TextXAlignment = Enum.TextXAlignment.Left
    ds.Parent = card

    local pill = Instance.new("Frame")
    pill.Size = UDim2.fromOffset(40, 20)
    pill.Position = UDim2.new(1, -52, 0.5, -10)
    pill.BackgroundColor3 = Color3.fromRGB(235,235,235)
    pill.BorderSizePixel = 0
    pill.Parent = card

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1, 0)
    pc.Parent = pill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(10, 10)
    knob.Position = UDim2.fromOffset(5, 5)
    knob.BackgroundColor3 = Color3.fromRGB(90,90,90)
    knob.BorderSizePixel = 0
    knob.Parent = pill

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(246,246,246)
        }):Play()
    end)

    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(255,255,255)
        }):Play()
    end)

    local function setState(on)
        TweenService:Create(pill, TweenInfo.new(0.15), {
            BackgroundColor3 = on and Color3.fromRGB(0,95,184) or Color3.fromRGB(235,235,235)
        }):Play()

        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = on and UDim2.fromOffset(25, 5) or UDim2.fromOffset(5, 5),
            BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(90,90,90)
        }):Play()
    end

    return card, setState, ds
end

local statusBar = Instance.new("TextLabel")
statusBar.BackgroundTransparency = 1
statusBar.Size = UDim2.new(1, 0, 0, 20)
statusBar.LayoutOrder = 999
statusBar.Font = Enum.Font.Gotham
statusBar.TextSize = 11
statusBar.TextColor3 = Color3.fromRGB(120,120,120)
statusBar.Text = "Pronto."
statusBar.TextXAlignment = Enum.TextXAlignment.Left
statusBar.Parent = pageMain

local function status(t)
    statusBar.Text = t
end

----------------------------------------------------------------
-- PRINCIPAL: BAN HAMMER
----------------------------------------------------------------
local banCard, banState = makeCard(pageMain, "🔨", "Ban Hammer", "Carrega o script universal", 1)
local banLoaded = false

banCard.MouseButton1Click:Connect(function()
    if banLoaded then
        status("Ban Hammer já foi carregado.")
        return
    end

    status("Carregando Ban Hammer...")
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Ban-Hammer-Script-58232"))()
    end)

    if ok then
        banLoaded = true
        banState(true)
        status("Ban Hammer carregado!")
    else
        status("Erro: " .. tostring(err))
    end
end)

----------------------------------------------------------------
-- PRINCIPAL: FLY
----------------------------------------------------------------
local flying = false
local flySpeed = 70
local flyConn, bv, bg
local moveUp = false
local moveDown = false

local flyControls = Instance.new("Frame")
flyControls.Size = UDim2.fromOffset(140, 100)
flyControls.Position = UDim2.new(1, -160, 1, -120)
flyControls.BackgroundColor3 = Color3.fromRGB(255,255,255)
flyControls.BorderSizePixel = 0
flyControls.Visible = false
flyControls.Parent = gui

local flyControlsCorner = Instance.new("UICorner")
flyControlsCorner.CornerRadius = UDim.new(0, 8)
flyControlsCorner.Parent = flyControls

local flyControlsStroke = Instance.new("UIStroke")
flyControlsStroke.Color = Color3.fromRGB(220,220,220)
flyControlsStroke.Parent = flyControls

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(1, -20, 0, 36)
upBtn.Position = UDim2.fromOffset(10, 10)
upBtn.Text = "Subir"
upBtn.Font = Enum.Font.GothamMedium
upBtn.TextSize = 12
upBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
upBtn.BorderSizePixel = 0
upBtn.Parent = flyControls
local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 6)
upCorner.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(1, -20, 0, 36)
downBtn.Position = UDim2.fromOffset(10, 54)
downBtn.Text = "Descer"
downBtn.Font = Enum.Font.GothamMedium
downBtn.TextSize = 12
downBtn.BackgroundColor3 = Color3.fromRGB(240,240,240)
downBtn.BorderSizePixel = 0
downBtn.Parent = flyControls
local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 6)
downCorner.Parent = downBtn

upBtn.MouseButton1Down:Connect(function()
    moveUp = true
end)
upBtn.MouseButton1Up:Connect(function()
    moveUp = false
end)
upBtn.MouseLeave:Connect(function()
    moveUp = false
end)

downBtn.MouseButton1Down:Connect(function()
    moveDown = true
end)
downBtn.MouseButton1Up:Connect(function()
    moveDown = false
end)
downBtn.MouseLeave:Connect(function()
    moveDown = false
end)

local function stopFly()
    flying = false
    moveUp = false
    moveDown = false
    flyControls.Visible = false

    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    if bv then
        bv:Destroy()
        bv = nil
    end
    if bg then
        bg:Destroy()
        bg = nil
    end

    local _, hum = getRoot()
    if hum then
        hum.PlatformStand = false
    end
end

local function startFly()
    local root, hum = getRoot()
    if not root then
        status("Personagem não encontrado.")
        return
    end

    flying = true
    flyControls.Visible = true

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.P = 1e5
    bg.CFrame = workspace.CurrentCamera.CFrame
    bg.Parent = root

    if hum then
        hum.PlatformStand = false
    end

    flyConn = RunService.RenderStepped:Connect(function()
        if not flying then
            return
        end

        local rootNow, humNow = getRoot()
        if not rootNow then
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then
            return
        end

        local dir = Vector3.zero
        local look = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or moveUp then dir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or moveDown then dir -= Vector3.new(0, 1, 0) end

        if dir.Magnitude == 0 and humNow and humNow.MoveDirection.Magnitude > 0 then
            dir += Vector3.new(humNow.MoveDirection.X, 0, humNow.MoveDirection.Z)
        end

        if bv then
            bv.Velocity = dir.Magnitude > 0 and (dir.Unit * flySpeed) or Vector3.zero
        end

        if bg then
            bg.CFrame = cam.CFrame
        end
    end)
end

local flyCard, flyState = makeCard(pageMain, "🕊️", "Voar", "WASD + Espaço / Shift  •  tecla F", 2)

local function toggleFly()
    if flying then
        stopFly()
        flyState(false)
        status("Voo desligado.")
    else
        startFly()
        flyState(flying)
        if flying then
            status("Voando.")
        end
    end
end

flyCard.MouseButton1Click:Connect(toggleFly)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if flying then
        stopFly()
        flyState(false)
    end
end)

----------------------------------------------------------------
-- PRINCIPAL: CLICK TP
----------------------------------------------------------------
local tpCard, tpState = makeCard(pageMain, "📍", "Click Teleport", "Clique outra vez para remover", 3)
local tpEnabled = false

local function giveTpTool()
    local backpack = getBackpack()
    if not backpack then
        status("Backpack não encontrada.")
        return false
    end

    removeIfExists("Click TP")

    local tool = Instance.new("Tool")
    tool.Name = "Click TP"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.ToolTip = "Clique em qualquer lugar para se teleportar"
    tool.Parent = backpack

    tool.Activated:Connect(function()
        local root = getCharacter():FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hit = Mouse.Hit
        if hit then
            root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            status("Teleportado.")
        end
    end)

    return true
end

tpCard.MouseButton1Click:Connect(function()
    if tpEnabled then
        local removed = removeIfExists("Click TP")
        tpEnabled = false
        tpState(false)
        status(removed and "Click TP removido." or "Click TP desativado.")
    else
        local ok = giveTpTool()
        if ok then
            tpEnabled = true
            tpState(true)
            status("Click TP adicionado.")
        end
    end
end)

----------------------------------------------------------------
-- PRINCIPAL: RESET INSTANTÂNEO
----------------------------------------------------------------
local resetCard = makeCard(pageMain, "💀", "Reset Instantâneo", "Reseta seu personagem imediatamente", 4)

resetCard.MouseButton1Click:Connect(function()
    local hum = getHumanoid()
    if hum then
        hum.Health = 0
        status("Personagem resetado.")
    else
        status("Humanoid não encontrado.")
    end
end)

----------------------------------------------------------------
-- PRINCIPAL: GHOST HUB
----------------------------------------------------------------
local ghostCard = makeCard(pageMain, "👻", "Ghost Hub", "Carrega o Ghost Hub", 5)

ghostCard.MouseButton1Click:Connect(function()
    status("Carregando Ghost Hub...")

    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/gabrielalves124r-jpg/ac499fb1cee10b142db662bf9251be68/raw/648f0f8f9c3fdf6830f08e6b51fc1d5f7b2446e5/Ghost%2520Hub%2520v1.0%25E2%2580%259D"))()
    end)

    if ok then
        status("Ghost Hub carregado!")
    else
        status("Erro: " .. tostring(err))
    end
end)

----------------------------------------------------------------
-- COILS / TOOLS
----------------------------------------------------------------
local function makeBuffTool(toolName, buffType)
    local backpack = getBackpack()
    if not backpack then
        status("Backpack não encontrada.")
        return false
    end

    removeIfExists(toolName)

    local tool = Instance.new("Tool")
    tool.Name = toolName
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.ToolTip = "Equipe para ativar, desequipe para desativar"
    tool.Parent = backpack

    local equipped = false
    local oldWalkSpeed = nil
    local oldJumpPower = nil
    local oldUseJumpPower = nil
    local charAddedConn = nil

    local function applyBuff()
        local hum = getHumanoid()
        if not hum then return end

        if oldWalkSpeed == nil then
            oldWalkSpeed = hum.WalkSpeed
        end

        if oldJumpPower == nil then
            oldJumpPower = hum.JumpPower
        end

        if oldUseJumpPower == nil then
            oldUseJumpPower = hum.UseJumpPower
        end

        if buffType == "speed" then
            hum.WalkSpeed = 42
        elseif buffType == "jump" then
            hum.UseJumpPower = true
            hum.JumpPower = 14
        elseif buffType == "fusion" then
            hum.WalkSpeed = 42
            hum.UseJumpPower = true
            hum.JumpPower = 14
        end
    end

    local function removeBuff()
        local hum = getHumanoid()
        if not hum then return end

        if buffType == "speed" then
            hum.WalkSpeed = oldWalkSpeed or 16
        elseif buffType == "jump" then
            hum.UseJumpPower = (oldUseJumpPower ~= nil) and oldUseJumpPower or hum.UseJumpPower
            hum.JumpPower = oldJumpPower or 50
        elseif buffType == "fusion" then
            hum.WalkSpeed = oldWalkSpeed or 16
            hum.UseJumpPower = (oldUseJumpPower ~= nil) and oldUseJumpPower or hum.UseJumpPower
            hum.JumpPower = oldJumpPower or 50
        end
    end

    tool.Equipped:Connect(function()
        equipped = true
        applyBuff()
        status(toolName .. " equipado.")
    end)

    tool.Unequipped:Connect(function()
        equipped = false
        removeBuff()
        status(toolName .. " desequipado.")
    end)

    tool.Destroying:Connect(function()
        if equipped then
            removeBuff()
        end
        if charAddedConn then
            charAddedConn:Disconnect()
            charAddedConn = nil
        end
    end)

    charAddedConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)

        -- Se a ferramenta continuar equipada após o respawn,
        -- reaplica o buff no novo Humanoid.
        if equipped then
            applyBuff()
        end
    end)

    return true
end

local speedToolCard, speedToolState = makeCard(pageCoils, "⚡", "Speed Tool", "Clique de novo para remover", 1)
local jumpToolCard, jumpToolState = makeCard(pageCoils, "🦘", "Jump Tool", "Clique de novo para remover", 2)
local fusionToolCard, fusionToolState = makeCard(pageCoils, "🟣", "Fusion Tool", "Speed + Jump", 3)

local speedToolEnabled = false
local jumpToolEnabled = false
local fusionToolEnabled = false

speedToolCard.MouseButton1Click:Connect(function()
    if speedToolEnabled then
        local removed = removeIfExists("Speed Tool")
        speedToolEnabled = false
        speedToolState(false)
        status(removed and "Speed Tool removido." or "Speed Tool desativado.")
    else
        local ok = makeBuffTool("Speed Tool", "speed")
        if ok then
            speedToolEnabled = true
            speedToolState(true)
            status("Speed Tool adicionado.")
        end
    end
end)

jumpToolCard.MouseButton1Click:Connect(function()
    if jumpToolEnabled then
        local removed = removeIfExists("Jump Tool")
        jumpToolEnabled = false
        jumpToolState(false)
        status(removed and "Jump Tool removido." or "Jump Tool desativado.")
    else
        local ok = makeBuffTool("Jump Tool", "jump")
        if ok then
            jumpToolEnabled = true
            jumpToolState(true)
            status("Jump Tool adicionado.")
        end
    end
end)

fusionToolCard.MouseButton1Click:Connect(function()
    if fusionToolEnabled then
        local removed = removeIfExists("Fusion Tool")
        fusionToolEnabled = false
        fusionToolState(false)
        status(removed and "Fusion Tool removido." or "Fusion Tool desativado.")
    else
        local ok = makeBuffTool("Fusion Tool", "fusion")
        if ok then
            fusionToolEnabled = true
            fusionToolState(true)
            status("Fusion Tool adicionada.")
        end
    end
end)

----------------------------------------------------------------
-- COOL: GIRO RÁPIDO
----------------------------------------------------------------
local spinning = false
local spinConn
local spinOldAutoRotate = nil
local spinCard, spinState = makeCard(pageCool, "🌀", "Giro Rápido", "Gira rapidamente", 1)

spinCard.MouseButton1Click:Connect(function()
    spinning = not spinning
    spinState(spinning)

    if spinConn then
        spinConn:Disconnect()
        spinConn = nil
    end

    local hum = getHumanoid()
    if spinning then
        spinOldAutoRotate = hum and hum.AutoRotate
        if hum then
            hum.AutoRotate = false
        end

        spinConn = RunService.Heartbeat:Connect(function()
            local root = getCharacter():FindFirstChild("HumanoidRootPart")
            if root then
                local velocity = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = velocity
                root.AssemblyAngularVelocity = Vector3.new(0, math.rad(1440), 0)
            end
        end)
        status("Giro rápido ativado.")
    else
        local root = getCharacter():FindFirstChild("HumanoidRootPart")
        if root then
            local velocity = root.AssemblyLinearVelocity
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = velocity
        end
        if hum and spinOldAutoRotate ~= nil then
            hum.AutoRotate = spinOldAutoRotate
        end
        spinOldAutoRotate = nil
        status("Giro desligado.")
    end
end)

----------------------------------------------------------------
-- EMOTES: NOPE
----------------------------------------------------------------
local nopeCard, nopeState = makeCard(pageEmotes, "🙅", "Nope", "Recebe uma ferramenta de gesto", 1)
local nopeToolName = "Nope Emote"
local nopeEnabled = false

-- Procura os joints pelo nome e também pelo nome das partes ligadas.
-- Assim funciona com nomes de R6 e R15, incluindo versões com espaços.
local function normalizeBodyName(name)
    return string.lower((name or ""):gsub("[%s_%-%./]", ""))
end

local function findBodyMotor(char, names)
    local wanted = {}
    for _, name in ipairs(names) do
        wanted[normalizeBodyName(name)] = true
    end

    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") then
            local motorName = normalizeBodyName(obj.Name)
            local part0Name = obj.Part0 and normalizeBodyName(obj.Part0.Name) or ""
            local part1Name = obj.Part1 and normalizeBodyName(obj.Part1.Name) or ""

            if wanted[motorName] or wanted[part0Name] or wanted[part1Name] then
                return obj
            end
        end
    end

    return nil
end

local function getRightArmJoints(char)
    local shoulder = findBodyMotor(char, {
        "RightShoulder",
        "Right Shoulder",
        "RightUpperArm",
        "Right Upper Arm"
    })

    local elbow = findBodyMotor(char, {
        "RightElbow",
        "Right Elbow",
        "RightLowerArm",
        "Right Lower Arm"
    })

    local wrist = findBodyMotor(char, {
        "RightWrist",
        "Right Wrist",
        "RightHand"
    })

    -- Fallback específico para R6: o motor normalmente é "Right Shoulder".
    if not shoulder then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                local p0 = obj.Part0 and normalizeBodyName(obj.Part0.Name) or ""
                local p1 = obj.Part1 and normalizeBodyName(obj.Part1.Name) or ""
                local mn = normalizeBodyName(obj.Name)
                if mn == "rightshoulder" or p0 == "torso" and p1 == "rightarm" or p1 == "torso" and p0 == "rightarm" then
                    shoulder = obj
                    break
                end
            end
        end
    end

    return shoulder, elbow, wrist
end

local function stopNopePose(char, joints)
    for joint, original in pairs(joints) do
        if joint and joint.Parent then
            joint.C0 = original
        end
    end
end

local function playNopeEmote()
    local char = getCharacter()
    if not char then
        status("Personagem não encontrado.")
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then
        status("Personagem não encontrado.")
        return
    end

    local shoulder, elbow, wrist = getRightArmJoints(char)

    if not shoulder then
        status("Nenhum joint do braço direito encontrado.")
        return
    end

    local joints = {}
    for _, joint in ipairs({shoulder, elbow, wrist}) do
        if joint and joint:IsA("Motor6D") then
            joints[joint] = joint.C0
        end
    end

    local oldAutoRotate = hum.AutoRotate
    hum.AutoRotate = false

    task.spawn(function()
        local ok, err = pcall(function()
            local baseShoulder = joints[shoulder]
            local baseElbow = elbow and joints[elbow] or nil
            local baseWrist = wrist and joints[wrist] or nil

            -- Levanta o braço e faz o gesto de "não, não, não".
            for i = 1, 3 do
                if not shoulder or not shoulder.Parent then
                    return
                end

                local side = (i % 2 == 1) and -1 or 1

                shoulder.C0 = baseShoulder
                    * CFrame.Angles(math.rad(-65), math.rad(15), math.rad(side * 42))

                if elbow and baseElbow then
                    elbow.C0 = baseElbow * CFrame.Angles(math.rad(-18), 0, math.rad(-side * 8))
                end

                if wrist and baseWrist then
                    wrist.C0 = baseWrist
                        * CFrame.Angles(math.rad(-25), math.rad(side * 18), math.rad(side * 12))
                end

                task.wait(0.16)

                shoulder.C0 = baseShoulder
                    * CFrame.Angles(math.rad(-65), math.rad(15), math.rad(-side * 42))

                if elbow and baseElbow then
                    elbow.C0 = baseElbow * CFrame.Angles(math.rad(-18), 0, math.rad(side * 8))
                end

                if wrist and baseWrist then
                    wrist.C0 = baseWrist
                        * CFrame.Angles(math.rad(-25), math.rad(-side * 18), math.rad(-side * 12))
                end

                task.wait(0.16)
            end

            -- Finaliza com a mão virada para baixo, simulando o dislike.
            shoulder.C0 = baseShoulder
                * CFrame.Angles(math.rad(35), math.rad(10), math.rad(5))

            if elbow and baseElbow then
                elbow.C0 = baseElbow * CFrame.Angles(math.rad(-45), 0, 0)
            end

            if wrist and baseWrist then
                wrist.C0 = baseWrist * CFrame.Angles(math.rad(70), 0, 0)
            end

            task.wait(0.55)
        end)

        stopNopePose(char, joints)

        if hum and hum.Parent then
            hum.AutoRotate = oldAutoRotate
        end

        if not ok then
            status("Erro no emote: " .. tostring(err))
        else
            status("Nope!")
        end
    end)
end

local function giveNopeTool()
    local backpack = getBackpack()
    if not backpack then
        status("Backpack não encontrada.")
        return false
    end

    removeIfExists(nopeToolName)

    local tool = Instance.new("Tool")
    tool.Name = nopeToolName
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.ToolTip = "Use para fazer o gesto de não e dislike"
    tool.Parent = backpack

    tool.Activated:Connect(playNopeEmote)
    return true
end

nopeCard.MouseButton1Click:Connect(function()
    if nopeEnabled then
        local removed = removeIfExists(nopeToolName)
        nopeEnabled = false
        nopeState(false)
        status(removed and "Nope Emote removido." or "Nope Emote desativado.")
    else
        local ok = giveNopeTool()
        if ok then
            nopeEnabled = true
            nopeState(true)
            status("Nope Emote adicionado ao inventário.")
        end
    end
end)

----------------------------------------------------------------

-- MINIMIZAR / FECHAR
----------------------------------------------------------------
local minimized = false

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized

    TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
        Size = minimized and UDim2.fromOffset(420, 36) or UDim2.fromOffset(420, 360)
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    stopFly()
    spinning = false
    if spinConn then spinConn:Disconnect() end
    gui:Destroy()
end)

main.Size = UDim2.fromOffset(420, 0)
TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(420, 360)
}):Play()

status("Delta Hub carregado.")