--[[
    DELTA HUB — Painel estilo Windows 11
    Atualizado:
      - Sistema de abas
      - Abas: Principal, Itens, Cool, Emotes e Blox
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
local UserInputService = game:GetService("UserInputService")
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
-- GUI — NEBULA (design original)
----------------------------------------------------------------
pcall(function()
    if CoreGui:FindFirstChild("DeltaHubNebula") then
        CoreGui.DeltaHubNebula:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaHubNebula"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function gradient(obj, a, b, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(a, b)
    g.Rotation = rotation or 0
    g.Parent = obj
    return g
end

-- Container responsivo.
local main = Instance.new("Frame")
main.Name = "NebulaWindow"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(680, 620)
main.BackgroundColor3 = Color3.fromRGB(14, 15, 24)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui
corner(main, 20)
stroke(main, Color3.fromRGB(73, 61, 109), 1, 0.18)

local mainGradient = gradient(
    main,
    Color3.fromRGB(18, 19, 31),
    Color3.fromRGB(11, 12, 20),
    90
)

local glow = Instance.new("Frame")
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5, 0)
glow.Position = UDim2.fromScale(0.5, 0)
glow.Size = UDim2.fromScale(0.72, 0.36)
glow.BackgroundColor3 = Color3.fromRGB(118, 70, 255)
glow.BackgroundTransparency = 0.82
glow.BorderSizePixel = 0
glow.ZIndex = 0
glow.Parent = main
corner(glow, 999)
gradient(glow, Color3.fromRGB(91, 55, 255), Color3.fromRGB(0, 190, 255), 0)

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 62)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 19, 30)
titleBar.BackgroundTransparency = 0.05
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Parent = main

local titleLine = Instance.new("Frame")
titleLine.AnchorPoint = Vector2.new(0, 1)
titleLine.Position = UDim2.new(0, 0, 1, 0)
titleLine.Size = UDim2.new(1, 0, 0, 1)
titleLine.BackgroundColor3 = Color3.fromRGB(68, 57, 95)
titleLine.BackgroundTransparency = 0.42
titleLine.BorderSizePixel = 0
titleLine.Parent = titleBar

local brand = Instance.new("Frame")
brand.Position = UDim2.fromOffset(16, 12)
brand.Size = UDim2.fromOffset(38, 38)
brand.BackgroundColor3 = Color3.fromRGB(34, 27, 57)
brand.BorderSizePixel = 0
brand.Parent = titleBar
corner(brand, 12)
gradient(brand, Color3.fromRGB(130, 72, 255), Color3.fromRGB(50, 197, 255), 45)

local brandText = Instance.new("TextLabel")
brandText.BackgroundTransparency = 1
brandText.Size = UDim2.fromScale(1, 1)
brandText.Text = "D"
brandText.Font = Enum.Font.GothamBlack
brandText.TextSize = 20
brandText.TextColor3 = Color3.fromRGB(255, 255, 255)
brandText.Parent = brand

local titleWrap = Instance.new("Frame")
titleWrap.BackgroundTransparency = 1
titleWrap.Position = UDim2.fromOffset(64, 8)
titleWrap.Size = UDim2.new(1, -220, 0, 46)
titleWrap.Parent = titleBar

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 24)
title.Font = Enum.Font.GothamSemibold
title.Text = "Delta Hub"
title.TextSize = 19
title.TextColor3 = Color3.fromRGB(242, 242, 250)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleWrap

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(0, 23)
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Painel de recursos"
subtitle.TextSize = 12
subtitle.TextColor3 = Color3.fromRGB(151, 153, 175)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleWrap

local function topButton(symbol, xOffset)
    local b = Instance.new("TextButton")
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, xOffset, 0.5, 0)
    b.Size = UDim2.fromOffset(38, 38)
    b.BackgroundColor3 = Color3.fromRGB(28, 29, 43)
    b.BorderSizePixel = 0
    b.Text = symbol
    b.TextSize = 19
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = Color3.fromRGB(188, 190, 210)
    b.AutoButtonColor = false
    b.Parent = titleBar
    corner(b, 10)
    return b
end

local minBtn = topButton("—", -106)
local closeBtn = topButton("×", -18)

local function topHover(b, hover)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = hover}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 29, 43)}):Play()
    end)
end
topHover(minBtn, Color3.fromRGB(41, 42, 61))
topHover(closeBtn, Color3.fromRGB(154, 47, 71))

-- Corpo.
local body = Instance.new("Frame")
body.Name = "Body"
body.Position = UDim2.fromOffset(0, 62)
body.Size = UDim2.new(1, 0, 1, -104)
body.BackgroundTransparency = 1
body.ClipsDescendants = true
body.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.fromOffset(86, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(16, 17, 27)
sidebar.BorderSizePixel = 0
sidebar.Parent = body

local sideLine = Instance.new("Frame")
sideLine.AnchorPoint = Vector2.new(1, 0)
sideLine.Position = UDim2.new(1, 0, 0, 0)
sideLine.Size = UDim2.new(0, 1, 1, 0)
sideLine.BackgroundColor3 = Color3.fromRGB(65, 55, 92)
sideLine.BackgroundTransparency = 0.55
sideLine.BorderSizePixel = 0
sideLine.Parent = sidebar

local navLabel = Instance.new("TextLabel")
navLabel.BackgroundTransparency = 1
navLabel.Position = UDim2.fromOffset(0, 12)
navLabel.Size = UDim2.new(1, 0, 0, 18)
navLabel.Text = "MENU"
navLabel.Font = Enum.Font.GothamBold
navLabel.TextSize = 9
navLabel.TextColor3 = Color3.fromRGB(110, 112, 136)
navLabel.Parent = sidebar

local navHolder = Instance.new("Frame")
navHolder.BackgroundTransparency = 1
navHolder.Position = UDim2.fromOffset(10, 40)
navHolder.Size = UDim2.new(1, -20, 1, -50)
navHolder.Parent = sidebar

local navList = Instance.new("UIListLayout")
navList.Padding = UDim.new(0, 10)
navList.HorizontalAlignment = Enum.HorizontalAlignment.Center
navList.SortOrder = Enum.SortOrder.LayoutOrder
navList.Parent = navHolder

local pages = Instance.new("Frame")
pages.Name = "Pages"
pages.Position = UDim2.fromOffset(86, 0)
pages.Size = UDim2.new(1, -86, 1, 0)
pages.BackgroundTransparency = 1
pages.ClipsDescendants = true
pages.Parent = body

local function makePage(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(110, 79, 210)
    frame.CanvasSize = UDim2.fromOffset(0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    frame.Parent = pages

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 16)
    pad.PaddingBottom = UDim.new(0, 22)
    pad.PaddingLeft = UDim.new(0, 16)
    pad.PaddingRight = UDim.new(0, 16)
    pad.Parent = frame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = frame

    return frame
end

local pageMain = makePage("Main")
local pageCoils = makePage("Coils")
local pageCool = makePage("Cool")
local pageEmotes = makePage("Emotes")
local pageBlox = makePage("Blox")
pageMain.Visible = true

local function addPageHeader(parent, eyebrow, heading, description)
    local h = Instance.new("Frame")
    h.BackgroundTransparency = 1
    h.Size = UDim2.new(1, 0, 0, 84)
    h.LayoutOrder = -100
    h.Parent = parent

    local e = Instance.new("TextLabel")
    e.BackgroundTransparency = 1
    e.Position = UDim2.fromOffset(2, 0)
    e.Size = UDim2.new(1, -4, 0, 16)
    e.Text = string.upper(eyebrow)
    e.Font = Enum.Font.GothamBold
    e.TextSize = 10
    e.TextColor3 = Color3.fromRGB(128, 102, 232)
    e.TextXAlignment = Enum.TextXAlignment.Left
    e.Parent = h

    local hd = Instance.new("TextLabel")
    hd.BackgroundTransparency = 1
    hd.Position = UDim2.fromOffset(0, 18)
    hd.Size = UDim2.new(1, 0, 0, 30)
    hd.Text = heading
    hd.Font = Enum.Font.GothamBold
    hd.TextSize = 24
    hd.TextColor3 = Color3.fromRGB(242, 243, 250)
    hd.TextXAlignment = Enum.TextXAlignment.Left
    hd.Parent = h

    local d = Instance.new("TextLabel")
    d.BackgroundTransparency = 1
    d.Position = UDim2.fromOffset(0, 50)
    d.Size = UDim2.new(1, 0, 0, 28)
    d.Text = description
    d.Font = Enum.Font.Gotham
    d.TextSize = 12
    d.TextColor3 = Color3.fromRGB(153, 156, 177)
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = h
end

addPageHeader(pageMain, "Principal", "Comandos", "Acesse os recursos disponíveis para o seu personagem.")
addPageHeader(pageCoils, "Itens", "Coils & Buffs", "Ferramentas e melhorias disponíveis no inventário.")
addPageHeader(pageCool, "Cool", "Efeitos", "Recursos visuais e movimentos especiais.")
addPageHeader(pageEmotes, "Emotes", "Animações", "Adicione e use animações disponíveis.")
addPageHeader(pageBlox, "Blox", "Blox Fruits", "Consulte os estoques disponíveis em painéis separados.")

local function makeTabButton(text, icon, order)
    local b = Instance.new("TextButton")
    b.Name = text
    b.Size = UDim2.fromOffset(66, 58)
    b.BackgroundColor3 = Color3.fromRGB(25, 26, 39)
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.Parent = navHolder
    corner(b, 14)

    local ic = Instance.new("TextLabel")
    ic.Name = "Icon"
    ic.BackgroundTransparency = 1
    ic.Position = UDim2.new(0, 0, 0, 7)
    ic.Size = UDim2.new(1, 0, 0, 26)
    ic.Text = icon
    ic.Font = Enum.Font.GothamMedium
    ic.TextSize = 21
    ic.TextColor3 = Color3.fromRGB(180, 182, 202)
    ic.Parent = b

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 33)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 9
    label.TextColor3 = Color3.fromRGB(148, 150, 170)
    label.Parent = b

    return b
end

local tabMain = makeTabButton("Início", "⌂", 1)
local tabCoils = makeTabButton("Itens", "◇", 2)
local tabCool = makeTabButton("Cool", "✦", 3)
local tabEmotes = makeTabButton("Emotes", "☻", 4)
local tabBlox = makeTabButton("Blox", "◈", 5)

local allTabs = {tabMain, tabCoils, tabCool, tabEmotes, tabBlox}

local function switchTab(tab)
    pageMain.Visible = tab == "Main"
    pageCoils.Visible = tab == "Coils"
    pageCool.Visible = tab == "Cool"
    pageEmotes.Visible = tab == "Emotes"
    pageBlox.Visible = tab == "Blox"
end

local function styleTabs(activeButton)
    for _, b in ipairs(allTabs) do
        local on = b == activeButton
        local icon = b:FindFirstChild("Icon")
        local label = b:FindFirstChild("Label")
        TweenService:Create(b, TweenInfo.new(0.16), {
            BackgroundColor3 = on and Color3.fromRGB(57, 43, 92) or Color3.fromRGB(25, 26, 39)
        }):Play()
        if icon then icon.TextColor3 = on and Color3.fromRGB(212, 199, 255) or Color3.fromRGB(180, 182, 202) end
        if label then label.TextColor3 = on and Color3.fromRGB(212, 199, 255) or Color3.fromRGB(148, 150, 170) end
        local st = b:FindFirstChildOfClass("UIStroke")
        if not st then st = stroke(b, Color3.fromRGB(121, 88, 220), 1, 1) end
        st.Transparency = on and 0.15 or 1
    end
end

tabMain.MouseButton1Click:Connect(function() switchTab("Main"); styleTabs(tabMain) end)
tabCoils.MouseButton1Click:Connect(function() switchTab("Coils"); styleTabs(tabCoils) end)
tabCool.MouseButton1Click:Connect(function() switchTab("Cool"); styleTabs(tabCool) end)
tabEmotes.MouseButton1Click:Connect(function() switchTab("Emotes"); styleTabs(tabEmotes) end)
tabBlox.MouseButton1Click:Connect(function() switchTab("Blox"); styleTabs(tabBlox) end)
styleTabs(tabMain)

-- Barra de status.
local htmlStatus = Instance.new("Frame")
htmlStatus.Name = "StatusBar"
htmlStatus.AnchorPoint = Vector2.new(0, 1)
htmlStatus.Position = UDim2.new(0, 0, 1, 0)
htmlStatus.Size = UDim2.new(1, 0, 0, 42)
htmlStatus.BackgroundColor3 = Color3.fromRGB(18, 19, 30)
htmlStatus.BorderSizePixel = 0
htmlStatus.Parent = main

local statusAccent = Instance.new("Frame")
statusAccent.Position = UDim2.fromOffset(18, 15)
statusAccent.Size = UDim2.fromOffset(7, 7)
statusAccent.BackgroundColor3 = Color3.fromRGB(102, 229, 168)
statusAccent.BorderSizePixel = 0
statusAccent.Parent = htmlStatus
corner(statusAccent, 99)

local htmlStatusText = Instance.new("TextLabel")
htmlStatusText.BackgroundTransparency = 1
htmlStatusText.Position = UDim2.fromOffset(34, 0)
htmlStatusText.Size = UDim2.new(1, -52, 1, 0)
htmlStatusText.Font = Enum.Font.Gotham
htmlStatusText.TextSize = 12
htmlStatusText.TextColor3 = Color3.fromRGB(153, 156, 177)
htmlStatusText.TextXAlignment = Enum.TextXAlignment.Left
htmlStatusText.Text = "Sistema pronto"
htmlStatusText.Parent = htmlStatus

local statusLine = Instance.new("Frame")
statusLine.Size = UDim2.new(1, 0, 0, 1)
statusLine.BackgroundColor3 = Color3.fromRGB(68, 57, 95)
statusLine.BackgroundTransparency = 0.45
statusLine.BorderSizePixel = 0
statusLine.Parent = htmlStatus

-- Cartões.
local function makeCard(parent, icon, name, desc, order)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 82)
    card.BackgroundColor3 = Color3.fromRGB(24, 25, 37)
    card.AutoButtonColor = false
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order
    card.Parent = parent
    corner(card, 16)
    local cardStroke = stroke(card, Color3.fromRGB(67, 58, 91), 1, 0.55)

    local iconBox = Instance.new("Frame")
    iconBox.Position = UDim2.fromOffset(12, 13)
    iconBox.Size = UDim2.fromOffset(56, 56)
    iconBox.BackgroundColor3 = Color3.fromRGB(38, 33, 58)
    iconBox.BorderSizePixel = 0
    iconBox.Parent = card
    corner(iconBox, 14)
    gradient(iconBox, Color3.fromRGB(64, 44, 99), Color3.fromRGB(28, 48, 76), 25)

    local ic = Instance.new("TextLabel")
    ic.BackgroundTransparency = 1
    ic.Size = UDim2.fromScale(1, 1)
    ic.Text = icon
    ic.TextSize = 24
    ic.Font = Enum.Font.GothamBold
    ic.TextColor3 = Color3.fromRGB(236, 233, 255)
    ic.Parent = iconBox

    local nm = Instance.new("TextLabel")
    nm.BackgroundTransparency = 1
    nm.Position = UDim2.fromOffset(82, 14)
    nm.Size = UDim2.new(1, -168, 0, 23)
    nm.Font = Enum.Font.GothamSemibold
    nm.Text = name
    nm.TextSize = 16
    nm.TextColor3 = Color3.fromRGB(242, 243, 250)
    nm.TextXAlignment = Enum.TextXAlignment.Left
    nm.TextTruncate = Enum.TextTruncate.AtEnd
    nm.Parent = card

    local ds = Instance.new("TextLabel")
    ds.BackgroundTransparency = 1
    ds.Position = UDim2.fromOffset(82, 39)
    ds.Size = UDim2.new(1, -168, 0, 28)
    ds.Font = Enum.Font.Gotham
    ds.Text = desc
    ds.TextSize = 12
    ds.TextColor3 = Color3.fromRGB(151, 154, 176)
    ds.TextWrapped = true
    ds.TextXAlignment = Enum.TextXAlignment.Left
    ds.TextYAlignment = Enum.TextYAlignment.Top
    ds.Parent = card

    local pill = Instance.new("Frame")
    pill.Size = UDim2.fromOffset(54, 30)
    pill.Position = UDim2.new(1, -66, 0.5, -15)
    pill.BackgroundColor3 = Color3.fromRGB(48, 48, 65)
    pill.BorderSizePixel = 0
    pill.Parent = card
    corner(pill, 99)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(22, 22)
    knob.Position = UDim2.fromOffset(4, 4)
    knob.BackgroundColor3 = Color3.fromRGB(183, 185, 201)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    corner(knob, 99)

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(30, 31, 46)
        }):Play()
        cardStroke.Transparency = 0.22
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(24, 25, 37)
        }):Play()
        cardStroke.Transparency = 0.55
    end)

    local function setState(on)
        TweenService:Create(pill, TweenInfo.new(0.16), {
            BackgroundColor3 = on and Color3.fromRGB(103, 75, 205) or Color3.fromRGB(48, 48, 65)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.16), {
            Position = on and UDim2.fromOffset(28, 4) or UDim2.fromOffset(4, 4),
            BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(183, 185, 201)
        }):Play()
    end

    return card, setState, ds
end

local statusBar = Instance.new("TextLabel")
statusBar.BackgroundTransparency = 1
statusBar.Size = UDim2.new(1, 0, 0, 22)
statusBar.LayoutOrder = 999
statusBar.Font = Enum.Font.Gotham
statusBar.TextSize = 11
statusBar.TextColor3 = Color3.fromRGB(145, 149, 169)
statusBar.Text = "Pronto."
statusBar.TextXAlignment = Enum.TextXAlignment.Left
statusBar.Parent = pageMain

local function status(t)
    statusBar.Text = t
    htmlStatusText.Text = t
end

-- Navegação auxiliar.
local backBtn = Instance.new("TextButton")
backBtn.Visible = false
backBtn.Parent = gui
local refreshBtn = Instance.new("TextButton")
refreshBtn.Visible = false
refreshBtn.Parent = gui

-- Arrastar com mouse e toque, sem sair totalmente da tela.
do
    local dragging = false
    local dragStart, startPos

    local function clampWindow(x, y)
        local camera = workspace.CurrentCamera
        if not camera then return x, y end
        local viewport = camera.ViewportSize
        local size = main.AbsoluteSize
        local pad = 8
        return math.clamp(x, -size.X + 100, viewport.X - 100),
               math.clamp(y, -size.Y + 70, viewport.Y - 70)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local x, y = clampWindow(startPos.X + delta.X, startPos.Y + delta.Y)
            main.AnchorPoint = Vector2.new(0, 0)
            main.Position = UDim2.fromOffset(x, y)
        end
    end)
end

-- Ajuste responsivo.
local normalSize = Vector2.new(680, 620)
local stockPanel
local function fitWindow()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local v = camera.ViewportSize
    local margin = 18
    local w = math.min(normalSize.X, math.max(300, v.X - margin * 2))
    local h = math.min(normalSize.Y, math.max(300, v.Y - margin * 2))
    w = math.min(w, math.max(1, v.X - 8))
    h = math.min(h, math.max(1, v.Y - 8))

    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.Size = UDim2.fromOffset(w, h)

    local compact = w < 470
    sidebar.Size = UDim2.fromOffset(compact and 68 or 86, 0)
    pages.Position = UDim2.fromOffset(compact and 68 or 86, 0)
    pages.Size = UDim2.new(1, -(compact and 68 or 86), 1, 0)

    for _, b in ipairs(allTabs) do
        b.Size = UDim2.new(1, 0, 0, compact and 52 or 58)
        local label = b:FindFirstChild("Label")
        if label then label.Visible = not compact end
        local icon = b:FindFirstChild("Icon")
        if icon then
            icon.Position = compact and UDim2.new(0, 0, 0, 13) or UDim2.new(0, 0, 0, 7)
        end
    end
    navLabel.Visible = not compact
    navHolder.Position = UDim2.fromOffset(compact and 8 or 10, compact and 18 or 40)
    navHolder.Size = UDim2.new(1, compact and -16 or -20, 1, compact and -28 or -50)

    if stockPanel then
        local stockW = math.min(520, math.max(260, v.X - 28))
        local stockH = math.min(500, math.max(260, v.Y - 28))
        stockPanel.Size = UDim2.fromOffset(stockW, stockH)
    end
end

fitWindow()

local function hookCamera()
    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitWindow)
    end
end
hookCamera()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    hookCamera()
    fitWindow()
end)

----------------------------------------------------------------
-- BLOX FRUITS: PAINÉIS DE ESTOQUE
--
-- A consulta usa apenas dados que o próprio jogo disponibiliza ao cliente.
-- Se o servidor não expuser um estoque específico, o painel informa isso
-- em vez de inventar ou forçar dados.
----------------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local stockOverlay = Instance.new("Frame")
stockOverlay.Name = "BloxStockOverlay"
stockOverlay.Size = UDim2.fromScale(1, 1)
stockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
stockOverlay.BackgroundTransparency = 0.38
stockOverlay.Visible = false
stockOverlay.ZIndex = 50
stockOverlay.Parent = gui

stockPanel = Instance.new("Frame")
stockPanel.AnchorPoint = Vector2.new(0.5, 0.5)
stockPanel.Position = UDim2.fromScale(0.5, 0.5)
stockPanel.Size = UDim2.fromOffset(520, 500)
stockPanel.BackgroundColor3 = Color3.fromRGB(20, 21, 33)
stockPanel.BorderSizePixel = 0
stockPanel.ZIndex = 51
stockPanel.Parent = stockOverlay
corner(stockPanel, 18)
stroke(stockPanel, Color3.fromRGB(100, 76, 165), 1, 0.25)
fitWindow()

local stockTitle = Instance.new("TextLabel")
stockTitle.BackgroundTransparency = 1
stockTitle.Position = UDim2.fromOffset(20, 16)
stockTitle.Size = UDim2.new(1, -120, 0, 28)
stockTitle.Font = Enum.Font.GothamBold
stockTitle.TextSize = 19
stockTitle.TextColor3 = Color3.fromRGB(244, 244, 252)
stockTitle.TextXAlignment = Enum.TextXAlignment.Left
stockTitle.Text = "Estoque"
stockTitle.ZIndex = 52
stockTitle.Parent = stockPanel

local stockClose = Instance.new("TextButton")
stockClose.AnchorPoint = Vector2.new(1, 0)
stockClose.Position = UDim2.new(1, -16, 0, 12)
stockClose.Size = UDim2.fromOffset(38, 38)
stockClose.BackgroundColor3 = Color3.fromRGB(38, 39, 56)
stockClose.BorderSizePixel = 0
stockClose.Text = "×"
stockClose.Font = Enum.Font.GothamMedium
stockClose.TextSize = 24
stockClose.TextColor3 = Color3.fromRGB(215, 216, 230)
stockClose.ZIndex = 52
stockClose.Parent = stockPanel
corner(stockClose, 11)

local stockSubtitle = Instance.new("TextLabel")
stockSubtitle.BackgroundTransparency = 1
stockSubtitle.Position = UDim2.fromOffset(20, 48)
stockSubtitle.Size = UDim2.new(1, -40, 0, 24)
stockSubtitle.Font = Enum.Font.Gotham
stockSubtitle.TextSize = 12
stockSubtitle.TextColor3 = Color3.fromRGB(158, 161, 183)
stockSubtitle.TextXAlignment = Enum.TextXAlignment.Left
stockSubtitle.Text = "Atualizando..."
stockSubtitle.ZIndex = 52
stockSubtitle.Parent = stockPanel

local stockList = Instance.new("ScrollingFrame")
stockList.Position = UDim2.fromOffset(16, 82)
stockList.Size = UDim2.new(1, -32, 1, -98)
stockList.BackgroundColor3 = Color3.fromRGB(15, 16, 26)
stockList.BorderSizePixel = 0
stockList.ScrollBarThickness = 4
stockList.ScrollBarImageColor3 = Color3.fromRGB(126, 91, 235)
stockList.CanvasSize = UDim2.fromOffset(0, 0)
stockList.AutomaticCanvasSize = Enum.AutomaticSize.Y
stockList.ZIndex = 52
stockList.Parent = stockPanel
corner(stockList, 14)

local stockPad = Instance.new("UIPadding")
stockPad.PaddingTop = UDim.new(0, 10)
stockPad.PaddingBottom = UDim.new(0, 10)
stockPad.PaddingLeft = UDim.new(0, 10)
stockPad.PaddingRight = UDim.new(0, 10)
stockPad.Parent = stockList

local stockLayout = Instance.new("UIListLayout")
stockLayout.Padding = UDim.new(0, 7)
stockLayout.SortOrder = Enum.SortOrder.LayoutOrder
stockLayout.Parent = stockList

local function clearStockRows()
    for _, child in ipairs(stockList:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function addStockRow(text, dim)
    local row = Instance.new("TextLabel")
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(27, 28, 42)
    row.BorderSizePixel = 0
    row.Font = Enum.Font.GothamMedium
    row.TextSize = 13
    row.TextColor3 = dim and Color3.fromRGB(170, 172, 190) or Color3.fromRGB(238, 239, 248)
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.TextWrapped = true
    row.Text = "  " .. tostring(text)
    row.ZIndex = 53
    row.Parent = stockList
    corner(row, 10)
end

local function findCommRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local remote = remotes:FindFirstChild("CommF_")
        if remote and remote:IsA("RemoteFunction") then
            return remote
        end
    end
    local remote = ReplicatedStorage:FindFirstChild("CommF_", true)
    if remote and remote:IsA("RemoteFunction") then
        return remote
    end
    return nil
end

local function flattenStock(data, out, depth)
    depth = depth or 0
    if depth > 5 then return end
    if type(data) == "table" then
        -- Formatos comuns: lista de nomes ou dicionário com Name/Stock/Price.
        if data.Name or data.name then
            local name = data.Name or data.name
            local amount = data.Stock or data.stock or data.Amount or data.amount
            local price = data.Price or data.price
            local line = tostring(name)
            if amount ~= nil then line = line .. "  •  Estoque: " .. tostring(amount) end
            if price ~= nil then line = line .. "  •  $" .. tostring(price) end
            table.insert(out, line)
            return
        end
        for k, v in pairs(data) do
            if type(v) == "table" then
                flattenStock(v, out, depth + 1)
            elseif type(v) == "string" and v ~= "" then
                if type(k) == "number" then
                    table.insert(out, v)
                else
                    table.insert(out, tostring(k) .. ": " .. v)
                end
            elseif type(v) == "number" or type(v) == "boolean" then
                if type(k) == "string" and k ~= "Updated" and k ~= "Time" then
                    table.insert(out, tostring(k) .. ": " .. tostring(v))
                end
            end
        end
    elseif data ~= nil then
        table.insert(out, tostring(data))
    end
end

local function showStock(titleText, subtitleText, data, errText)
    stockTitle.Text = titleText
    stockSubtitle.Text = subtitleText
    clearStockRows()
    stockOverlay.Visible = true

    if errText then
        addStockRow(errText, true)
        return
    end

    local rows = {}
    flattenStock(data, rows)
    if #rows == 0 then
        addStockRow("Nenhum item de estoque foi retornado pelo servidor.", true)
        return
    end

    table.sort(rows, function(a, b) return tostring(a) < tostring(b) end)
    local seen = {}
    local added = 0
    for _, row in ipairs(rows) do
        if not seen[row] then
            seen[row] = true
            addStockRow(row, false)
            added += 1
        end
    end
    if added == 0 then
        addStockRow("Nenhum item de estoque disponível para mostrar.", true)
    end
end

stockClose.MouseButton1Click:Connect(function()
    stockOverlay.Visible = false
end)
stockOverlay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Fecha somente quando o toque/click ocorre fora do painel.
        local pos = input.Position
        local p = stockPanel.AbsolutePosition
        local sz = stockPanel.AbsoluteSize
        if pos.X < p.X or pos.X > p.X + sz.X or pos.Y < p.Y or pos.Y > p.Y + sz.Y then
            stockOverlay.Visible = false
        end
    end
end)

local function requestNormalStock()
    local remote = findCommRemote()
    if not remote then
        showStock("Estoque Normal", "Dados não expostos neste servidor", nil,
            "Não encontrei a fonte de estoque disponível ao cliente neste servidor.")
        return
    end

    status("Consultando estoque normal...")
    local ok, data = pcall(function()
        return remote:InvokeServer("GetFruits")
    end)

    if ok then
        showStock("Estoque Normal", "Dados retornados pelo servidor", data)
        status("Estoque normal atualizado.")
    else
        showStock("Estoque Normal", "Não foi possível consultar", nil,
            "O servidor não disponibilizou a consulta de estoque nesta sessão.")
        status("Não foi possível consultar o estoque normal.")
    end
end

local function requestMirageStock()
    -- A Mirage depende do estado/evento atual do servidor. O painel só mostra
    -- informações quando essa fonte estiver exposta ao cliente.
    local candidates = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        local n = string.lower(obj.Name)
        if n:find("mirage") and (obj:IsA("StringValue") or obj:IsA("Folder") or obj:IsA("Configuration")) then
            table.insert(candidates, obj.Name)
        end
    end

    if #candidates > 0 then
        showStock("Estoque Mirage", "Informações locais disponíveis", candidates)
        status("Painel Mirage atualizado.")
    else
        showStock("Estoque Mirage", "Mirage não exposta nesta sessão", nil,
            "A Mirage não está disponível ou o servidor não expõe o estoque ao cliente agora.")
        status("Estoque Mirage indisponível nesta sessão.")
    end
end

local normalStockCard = makeCard(pageBlox, "🍎", "Estoque Normal", "Abre o painel com o estoque normal disponível", 1)
local mirageStockCard = makeCard(pageBlox, "🌙", "Estoque Mirage", "Mostra o painel de estoque relacionado à Mirage", 2)

normalStockCard.MouseButton1Click:Connect(requestNormalStock)
mirageStockCard.MouseButton1Click:Connect(requestMirageStock)

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
flyControls.BackgroundColor3 = Color3.fromRGB(27, 23, 36)
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
local savedSize = nil

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = main.AbsoluteSize
        body.Visible = false
        htmlStatus.Visible = false
        TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 62)
        }):Play()
    else
        body.Visible = true
        htmlStatus.Visible = true
        fitWindow()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    stopFly()
    spinning = false
    if spinConn then spinConn:Disconnect() end
    gui:Destroy()
end)

status("Delta Hub carregado.")