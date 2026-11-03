--==============================================================
-- ECHO X | PAQUETE COMPLETO EN UN SOLO ARCHIVO
--==============================================================
-- IMPORTANTE: Roblox no permite que un LocalScript de interfaz y
-- un Script de servidor se ejecuten como un unico Script.
-- Este archivo reune ambos codigos para que tengas una sola descarga,
-- pero debes copiar cada seccion en la ubicacion indicada.
--==============================================================

--[[
SECCION 1 - LOCAL SCRIPT
Ubicacion: StarterPlayer > StarterPlayerScripts > LocalScript
Copia desde el comentario ECHO X | MENU DE UTILIDADES hasta el final
antes de la SECCION 2.
]]



--==================================================
-- ECHO X | MENU DE UTILIDADES
-- Roblox Studio - LocalScript
-- Ubicacion: StarterPlayer > StarterPlayerScripts
-- Tecla configurable: Mostrar / ocultar
--==================================================
local Players = game:GetService("Players")

local UIS = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local Lighting = game:GetService("Lighting")

local CollectionService = game:GetService("CollectionService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local antiHitRemote = ReplicatedStorage:WaitForChild("ECHO_X_AntiGolpeEvent", 10)

local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ECHO_X_Menu")

if old then

    old:Destroy()

end

local BLUE = Color3.fromRGB(0, 170, 255)

local DARKBLUE = Color3.fromRGB(0, 65, 115)

local BLACK = Color3.fromRGB(8, 11, 18)

local PANEL = Color3.fromRGB(19, 26, 40)

local WHITE = Color3.fromRGB(240, 247, 255)

local GREEN = Color3.fromRGB(35, 210, 130)

local NPC_RED = Color3.fromRGB(255, 45, 65)

local character, humanoid, root

local function getCharacter()

    character = player.Character

    humanoid = character and character:FindFirstChildOfClass("Humanoid")

    root = character and character:FindFirstChild("HumanoidRootPart")

end

getCharacter()

local state = {

    speed = 16,

    speedOn = false,

    fly = false,

    noclip = false,

    antiHit = false,

    fullbright = false,

    esp = false,

    npcESP = false,

    instantPrompt = false,

    antiAfk = false,

    lowEffects = false,

}

local connections = {}

local originalCollisions = {}

local originalPrompts = {}

local originalEffects = {}

local highlights = {}

local npcMarkers = {}

local oldLighting

local flyAttachment, flyVelocity, flyOrientation

local flyUp, flyDown = false, false

local function listen(signal, callback)

    local connection = signal:Connect(callback)

    table.insert(connections, connection)

    return connection

end

--================ GUI ECHO X MODERNO =============================
local gui = Instance.new("ScreenGui")
gui.Name = "ECHO_X_Menu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 1000
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(900, 540)
main.Position = UDim2.new(0.5, -450, 0.5, -270)
main.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 145, 255)
mainStroke.Transparency = 0.35
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local function fitMenuToScreen()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize
    if not viewport then return end
    uiScale.Scale = math.clamp(math.min(viewport.X / 940, viewport.Y / 580), 0.48, 1)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
end
fitMenuToScreen()
if workspace.CurrentCamera then
    listen(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), fitMenuToScreen)
end

-- Cabecera
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = Color3.fromRGB(19, 21, 30)
header.BorderSizePixel = 0
header.Parent = main
header.Active = true
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 250, 0, 30)
title.Position = UDim2.fromOffset(20, 7)
title.BackgroundTransparency = 1
title.Text = "ECHO X"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 25
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 300, 0, 16)
subtitle.Position = UDim2.fromOffset(22, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "UTILITY CONTROL CENTER  /  v2"
subtitle.TextColor3 = Color3.fromRGB(145, 155, 175)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local status = Instance.new("TextLabel")
status.Size = UDim2.fromOffset(130, 25)
status.Position = UDim2.new(1, -180, 0, 16)
status.BackgroundColor3 = Color3.fromRGB(20, 45, 48)
status.Text = "●  SISTEMA LISTO"
status.TextColor3 = Color3.fromRGB(65, 220, 155)
status.Font = Enum.Font.GothamBold
status.TextSize = 10
status.Parent = header
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -40, 0, 13)
close.BackgroundColor3 = Color3.fromRGB(65, 35, 48)
close.Text = "×"
close.TextColor3 = WHITE
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = header
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

-- Arrastrar desde la cabecera
local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
listen(UIS.InputChanged, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

-- Barra lateral
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 58)
sidebar.Size = UDim2.new(0, 66, 1, -58)
sidebar.BackgroundColor3 = Color3.fromRGB(17, 19, 27)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 9)
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Parent = sidebar

local navPadding = Instance.new("UIPadding")
navPadding.PaddingTop = UDim.new(0, 18)
navPadding.Parent = sidebar

-- Zona central y panel informativo
local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(78, 70)
content.Size = UDim2.new(1, -300, 1, -84)
content.BackgroundTransparency = 1
content.Parent = main

local rightPanel = Instance.new("Frame")
rightPanel.Position = UDim2.new(1, -210, 0, 72)
rightPanel.Size = UDim2.new(0, 195, 1, -88)
rightPanel.BackgroundColor3 = Color3.fromRGB(21, 23, 32)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = main
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 10)

local infoTitle = Instance.new("TextLabel")
infoTitle.Position = UDim2.fromOffset(14, 14)
infoTitle.Size = UDim2.new(1, -28, 0, 24)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "INFORMACIÓN"
infoTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 12
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = rightPanel

local infoText = Instance.new("TextLabel")
infoText.Position = UDim2.fromOffset(14, 48)
infoText.Size = UDim2.new(1, -28, 0, 130)
infoText.BackgroundTransparency = 1
infoText.Text = "Panel de utilidades ECHO X.\\n\\nSelecciona una sección en la barra lateral para ver sus opciones.\\n\\nLos cambios locales dependen de los sistemas de tu experiencia."
infoText.TextColor3 = Color3.fromRGB(175, 181, 195)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 10
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = rightPanel

local infoLine = Instance.new("Frame")
infoLine.Position = UDim2.new(0, 14, 0, 190)
infoLine.Size = UDim2.new(1, -28, 0, 1)
infoLine.BackgroundColor3 = Color3.fromRGB(55, 65, 82)
infoLine.BorderSizePixel = 0
infoLine.Parent = rightPanel

local tip = Instance.new("TextLabel")
tip.Position = UDim2.fromOffset(14, 205)
tip.Size = UDim2.new(1, -28, 0, 95)
tip.BackgroundTransparency = 1
tip.Text = "ATAJOS\\n\\nTecla configurable  ·  Mostrar / ocultar\\nWASD  ·  Movimiento de vuelo\\nSPACE  ·  Subir / saltar\\nCTRL  ·  Bajar en vuelo"
tip.TextColor3 = Color3.fromRGB(140, 150, 170)
tip.Font = Enum.Font.Gotham
tip.TextSize = 10
tip.TextWrapped = true
tip.TextYAlignment = Enum.TextYAlignment.Top
tip.TextXAlignment = Enum.TextXAlignment.Left
tip.Parent = rightPanel

local categories = {
    {name="MOVIMIENTO", icon="↗"},
    {name="INTERACCIONES", icon="⌁"},
    {name="VER NPC", icon="◎"},
    {name="ESP Y VISUALIZACION", icon="◉"},
    {name="ILUMINACIÓN", icon="☼"},
    {name="RENDIMIENTO", icon="▤"},
    {name="PRUEBAS Y CONTROL", icon="⚙"},
    {name="CONFIGURACION", icon="⌨"},
    {name="PUNTOS DE GUIA", icon="⌖"},
}
local pages, navButtons = {}, {}
local activePage = nil
local activeCategory = nil

local function showPage(name)
    activeCategory = name
    for pageName, page in pairs(pages) do page.Visible = (pageName == name) end
    for pageName, button in pairs(navButtons) do
        local selected = pageName == name
        button.BackgroundColor3 = selected and Color3.fromRGB(0, 91, 155) or Color3.fromRGB(25, 28, 39)
        button.TextColor3 = selected and Color3.fromRGB(255,255,255) or Color3.fromRGB(135,150,170)
    end
    infoText.Text = name .. "\\n\\nOpciones de esta sección del panel ECHO X. Activa únicamente las herramientas que necesites en tu propia experiencia."
end

for index, category in ipairs(categories) do
    local button = Instance.new("TextButton")
    button.Name = "Nav_" .. index
    button.Size = UDim2.fromOffset(46, 42)
    button.BackgroundColor3 = Color3.fromRGB(25, 28, 39)
    button.BorderSizePixel = 0
    button.Text = category.icon
    button.TextColor3 = Color3.fromRGB(135, 150, 170)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 19
    button.LayoutOrder = index
    button.Parent = sidebar
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    navButtons[category.name] = button

    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. index
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = content
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = page
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 3)
    pad.PaddingRight = UDim.new(0, 6)
    pad.Parent = page
    pages[category.name] = page
    button.Activated:Connect(function() showPage(category.name) end)
end

local function section(text)
    local matched = text
    if text == "ESP Y VISUALIZACION" then matched = "ESP Y VISUALIZACION" end
    if text == "REDUCIR EFECTOS" then matched = "RENDIMIENTO" end
    if text == "PRUEBAS Y CONTROL" then matched = "PRUEBAS Y CONTROL" end
    if text == "PUNTOS DE GUIA" then matched = "PUNTOS DE GUIA" end
    if text == "FULLBRIGHT" then matched = "ILUMINACIÓN" end
    if pages[matched] then
        activePage = pages[matched]
        showPage(matched)
    end
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(0, 170, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = activePage or content
end

local function row(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 43)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = activePage or content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(53, 62, 80)
    outline.Transparency = 0.65
    outline.Thickness = 1
    outline.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -125, 1, 0)
    label.Position = UDim2.fromOffset(12, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    return frame, label
end

local function styleButton(button, active)
    button.BackgroundColor3 = active and Color3.fromRGB(0, 145, 225) or Color3.fromRGB(65, 45, 105)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
end

local function toggle(text, initial, callback)
    local frame = row(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(76, 27)
    button.Position = UDim2.new(1, -88, 0.5, -13)
    button.Text = initial and "ON" or "OFF"
    button.Parent = frame
    styleButton(button, initial)
    local enabled = initial
    button.Activated:Connect(function()
        enabled = not enabled
        button.Text = enabled and "ON" or "OFF"
        styleButton(button, enabled)
        local ok, err = pcall(callback, enabled)
        if not ok then warn("[ECHO X] " .. tostring(err)) end
    end)
end

local function action(text, buttonText, callback)
    local frame = row(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(76, 27)
    button.Position = UDim2.new(1, -88, 0.5, -13)
    button.Text = buttonText
    button.Parent = frame
    styleButton(button, false)
    button.Activated:Connect(callback)
end


--================ PUNTOS DE GUIA ====================
-- Guarda hasta 50 ubicaciones durante esta sesion.
-- Las flechas son visuales y no teletransportan al jugador.
section("PUNTOS DE GUIA")

local MAX_PUNTOS = 50
local CANTIDAD_FLECHAS = 12
local SEPARACION_FLECHAS = 6
local RADIO_LLEGADA = 7
local puntos = {}
local puntoSeleccionado = nil
local guiandoPunto = false
local flechasVisibles = true
local flechasGuia = {}

local nombrePuntoFrame, nombrePuntoLabel = row("Nombre del punto")
nombrePuntoLabel.Size = UDim2.new(1, -145, 1, 0)
local nombrePunto = Instance.new("TextBox")
nombrePunto.Size = UDim2.fromOffset(128, 28)
nombrePunto.Position = UDim2.new(1, -138, 0.5, -14)
nombrePunto.BackgroundColor3 = Color3.fromRGB(15, 19, 29)
nombrePunto.TextColor3 = WHITE
nombrePunto.PlaceholderText = "Ej. Portal"
nombrePunto.PlaceholderColor3 = Color3.fromRGB(130, 145, 165)
nombrePunto.Text = ""
nombrePunto.ClearTextOnFocus = false
nombrePunto.Font = Enum.Font.Gotham
nombrePunto.TextSize = 10
nombrePunto.Parent = nombrePuntoFrame
Instance.new("UICorner", nombrePunto).CornerRadius = UDim.new(0, 6)

local estadoPuntos = Instance.new("TextLabel")
estadoPuntos.Size = UDim2.new(1, -8, 0, 34)
estadoPuntos.BackgroundColor3 = Color3.fromRGB(20, 29, 42)
estadoPuntos.Text = "Listo para guardar puntos (0/50)"
estadoPuntos.TextColor3 = Color3.fromRGB(190, 205, 220)
estadoPuntos.TextSize = 10
estadoPuntos.Font = Enum.Font.Gotham
estadoPuntos.TextWrapped = true
estadoPuntos.Parent = pages["PUNTOS DE GUIA"]
Instance.new("UICorner", estadoPuntos).CornerRadius = UDim.new(0, 6)

local listaPuntos = Instance.new("ScrollingFrame")
listaPuntos.Size = UDim2.new(1, -4, 0, 170)
listaPuntos.BackgroundColor3 = Color3.fromRGB(17, 20, 29)
listaPuntos.BorderSizePixel = 0
listaPuntos.ScrollBarThickness = 4
listaPuntos.ScrollBarImageColor3 = BLUE
listaPuntos.AutomaticCanvasSize = Enum.AutomaticSize.Y
listaPuntos.CanvasSize = UDim2.new()
listaPuntos.Parent = pages["PUNTOS DE GUIA"]
Instance.new("UICorner", listaPuntos).CornerRadius = UDim.new(0, 7)
local listaPuntosLayout = Instance.new("UIListLayout")
listaPuntosLayout.Padding = UDim.new(0, 5)
listaPuntosLayout.SortOrder = Enum.SortOrder.LayoutOrder
listaPuntosLayout.Parent = listaPuntos
local listaPuntosPadding = Instance.new("UIPadding")
listaPuntosPadding.PaddingTop = UDim.new(0, 6)
listaPuntosPadding.PaddingBottom = UDim.new(0, 6)
listaPuntosPadding.PaddingLeft = UDim.new(0, 6)
listaPuntosPadding.PaddingRight = UDim.new(0, 6)
listaPuntosPadding.Parent = listaPuntos

local function ocultarFlechasGuia()
    for _, par in ipairs(flechasGuia) do
        par[1].Transparency = 1
        par[2].Transparency = 1
    end
end

local function crearBarraGuia()
    local part = Instance.new("Part")
    part.Name = "ECHO_X_GuiaFlecha"
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = BLUE
    part.Transparency = 1
    part.Size = Vector3.new(0.45, 0.12, 1)
    part.Parent = workspace
    return part
end

for i = 1, CANTIDAD_FLECHAS do
    flechasGuia[i] = {crearBarraGuia(), crearBarraGuia()}
end

local function ponerBarraGuia(barra, a, b)
    local delta = b - a
    if delta.Magnitude < 0.05 then
        barra.Transparency = 1
        return
    end
    barra.Size = Vector3.new(0.45, 0.12, delta.Magnitude)
    barra.CFrame = CFrame.lookAt((a + b) / 2, b)
    barra.Transparency = 0.08
end

local function refrescarListaPuntos()
    for _, child in ipairs(listaPuntos:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for index, point in ipairs(puntos) do
        local selected = point == puntoSeleccionado
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -4, 0, 34)
        button.BackgroundColor3 = selected and Color3.fromRGB(0, 75, 115) or Color3.fromRGB(28, 32, 43)
        button.Text = string.format("%02d.  %s", index, point.nombre)
        button.TextColor3 = selected and BLUE or WHITE
        button.TextSize = 11
        button.Font = Enum.Font.GothamMedium
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.TextTruncate = Enum.TextTruncate.AtEnd
        button.LayoutOrder = index
        button.Parent = listaPuntos
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
        button.Activated:Connect(function()
            puntoSeleccionado = point
            refrescarListaPuntos()
            estadoPuntos.Text = "Seleccionado: " .. point.nombre
        end)
    end
    estadoPuntos.Text = string.format("Puntos guardados: %d/%d", #puntos, MAX_PUNTOS)
end

action("Guardar tu ubicacion actual", "GUARDAR", function()
    if #puntos >= MAX_PUNTOS then
        estadoPuntos.Text = "Limite alcanzado: 50 puntos."
        return
    end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        estadoPuntos.Text = "No se encontro tu personaje."
        return
    end
    local pointName = nombrePunto.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if pointName == "" then pointName = "Punto " .. (#puntos + 1) end
    pointName = string.sub(pointName, 1, 32)
    local point = {nombre = pointName, posicion = hrp.Position}
    table.insert(puntos, point)
    puntoSeleccionado = point
    nombrePunto.Text = ""
    refrescarListaPuntos()
    estadoPuntos.Text = "Ubicacion guardada: " .. pointName
end)

action("Seguir las flechas hasta el punto", "GUIARME", function()
    if not puntoSeleccionado then
        estadoPuntos.Text = "Primero selecciona un punto."
        return
    end
    guiandoPunto = true
    flechasVisibles = true
    estadoPuntos.Text = "Guiandote hacia: " .. puntoSeleccionado.nombre
end)

action("Mostrar u ocultar las flechas", "FLECHAS", function()
    flechasVisibles = not flechasVisibles
    if not flechasVisibles then
        ocultarFlechasGuia()
        estadoPuntos.Text = "Flechas ocultas."
    else
        estadoPuntos.Text = "Flechas visibles."
    end
end)

action("Eliminar el punto seleccionado", "ELIMINAR", function()
    if not puntoSeleccionado then
        estadoPuntos.Text = "Selecciona un punto para eliminar."
        return
    end
    local removedName = puntoSeleccionado.nombre
    for i, point in ipairs(puntos) do
        if point == puntoSeleccionado then
            table.remove(puntos, i)
            break
        end
    end
    puntoSeleccionado = nil
    guiandoPunto = false
    ocultarFlechasGuia()
    refrescarListaPuntos()
    estadoPuntos.Text = "Punto eliminado: " .. removedName
end)

local guideTimer = 0
listen(RunService.Heartbeat, function(dt)
    guideTimer += dt
    if guideTimer < 0.08 then return end
    guideTimer = 0
    if not guiandoPunto or not puntoSeleccionado or not flechasVisibles then
        ocultarFlechasGuia()
        return
    end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        ocultarFlechasGuia()
        return
    end
    local delta = puntoSeleccionado.posicion - hrp.Position
    local distance = delta.Magnitude
    if distance <= RADIO_LLEGADA then
        guiandoPunto = false
        ocultarFlechasGuia()
        estadoPuntos.Text = "Llegaste a: " .. puntoSeleccionado.nombre
        return
    end
    estadoPuntos.Text = string.format("Destino: %s  |  %.0f studs", puntoSeleccionado.nombre, distance)
    local horizontal = Vector3.new(delta.X, 0, delta.Z)
    if horizontal.Magnitude < 0.1 then
        ocultarFlechasGuia()
        return
    end
    local direction = horizontal.Unit
    local lateral = Vector3.new(-direction.Z, 0, direction.X)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local excluded = {char}
    for _, pair in ipairs(flechasGuia) do
        table.insert(excluded, pair[1])
        table.insert(excluded, pair[2])
    end
    params.FilterDescendantsInstances = excluded
    for i, pair in ipairs(flechasGuia) do
        local advance = i * SEPARACION_FLECHAS
        if advance >= horizontal.Magnitude then
            pair[1].Transparency = 1
            pair[2].Transparency = 1
        else
            local sample = hrp.Position + direction * advance
            local hit = workspace:Raycast(sample + Vector3.new(0, 12, 0), Vector3.new(0, -45, 0), params)
            if hit then
                local base = hit.Position + Vector3.new(0, 0.18, 0)
                local tipPosition = base + direction * 1.35
                local back = base - direction * 0.65
                ponerBarraGuia(pair[1], back + lateral * 0.85, tipPosition)
                ponerBarraGuia(pair[2], back - lateral * 0.85, tipPosition)
            else
                pair[1].Transparency = 1
                pair[2].Transparency = 1
            end
        end
    end
end)

--================ MOVIMIENTO ======================
local function setSpeed(value)

    state.speed = math.clamp(value, 16, 120)

    if humanoid and state.speedOn then

        humanoid.WalkSpeed = state.speed

    end

end

section("MOVIMIENTO")

local _, speedLabel = row("Velocidad: 16")

speedLabel.Size = UDim2.new(1, -105, 1, 0)

local minus = Instance.new("TextButton")

minus.Size = UDim2.fromOffset(30, 27)

minus.Position = UDim2.new(1, -70, 0.5, -13)

minus.BackgroundColor3 = DARKBLUE

minus.Text = "-"

minus.TextColor3 = WHITE

minus.Font = Enum.Font.GothamBold

minus.TextSize = 17

minus.Parent = speedLabel.Parent

Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 7)

local plus = Instance.new("TextButton")

plus.Size = UDim2.fromOffset(30, 27)

plus.Position = UDim2.new(1, -35, 0.5, -13)

plus.BackgroundColor3 = DARKBLUE

plus.Text = "+"

plus.TextColor3 = WHITE

plus.Font = Enum.Font.GothamBold

plus.TextSize = 17

plus.Parent = speedLabel.Parent

Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 7)

local function refreshSpeed()

    speedLabel.Text = "Velocidad: " .. state.speed

end

minus.Activated:Connect(function()

    setSpeed(state.speed - 8)

    refreshSpeed()

end)

plus.Activated:Connect(function()

    setSpeed(state.speed + 8)

    refreshSpeed()

end)

toggle("Activar velocidad ajustada", false, function(on)

    state.speedOn = on

    if humanoid then

        humanoid.WalkSpeed = on and state.speed or 16

    end

end)

local function stopFly()

    state.fly = false

    if flyVelocity then

        flyVelocity:Destroy()

        flyVelocity = nil

    end

    if flyOrientation then

        flyOrientation:Destroy()

        flyOrientation = nil

    end

    if flyAttachment then

        flyAttachment:Destroy()

        flyAttachment = nil

    end

    if humanoid then

        humanoid.PlatformStand = false

        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    end

    flyUp, flyDown = false, false

end

local function startFly()

    getCharacter()

    if not root or not humanoid then

        return

    end

    state.fly = true

    flyAttachment = Instance.new("Attachment")

    flyAttachment.Parent = root

    flyVelocity = Instance.new("LinearVelocity")

    flyVelocity.Attachment0 = flyAttachment

    flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World

    flyVelocity.MaxForce = 1000000

    flyVelocity.VectorVelocity = Vector3.zero

    flyVelocity.Parent = root

    flyOrientation = Instance.new("AlignOrientation")

    flyOrientation.Attachment0 = flyAttachment

    flyOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment

    flyOrientation.MaxTorque = 1000000

    flyOrientation.Responsiveness = 15

    flyOrientation.Parent = root

end

toggle("Vuelo (WASD / Space / Ctrl)", false, function(on)

    if on then

        startFly()

    else

        stopFly()

    end

end)

toggle("Sin colision (Noclip)", false, function(on)

    state.noclip = on

    if not on then

        for part, original in pairs(originalCollisions) do

            if part and part.Parent then

                part.CanCollide = original

            end

        end

        table.clear(originalCollisions)

    end

end)

--================ INTERACCIONES ===================
section("INTERACCIONES")

local function setPromptsInstant(on)

    state.instantPrompt = on

    if on then

        for _, obj in ipairs(workspace:GetDescendants()) do

            if obj:IsA("ProximityPrompt") then

                if originalPrompts[obj] == nil then

                    originalPrompts[obj] = obj.HoldDuration

                end

                obj.HoldDuration = 0

            end

        end

    else

        for prompt, duration in pairs(originalPrompts) do

            if prompt and prompt.Parent then

                prompt.HoldDuration = duration

            end

        end

        table.clear(originalPrompts)

    end

end

toggle("ProximityPrompt instantaneo local", false, setPromptsInstant)

action("Actualizar prompts nuevos", "ACTUALIZAR", function()

    if state.instantPrompt then

        for _, obj in ipairs(workspace:GetDescendants()) do

            if obj:IsA("ProximityPrompt") then

                if originalPrompts[obj] == nil then

                    originalPrompts[obj] = obj.HoldDuration

                end

                obj.HoldDuration = 0

            end

        end

    end

end)

--================ NPC: MARCADORES VISUALES =========
local function getNPCPart(model)

    return model:FindFirstChild("HumanoidRootPart")

        or model:FindFirstChild("Head")

        or model.PrimaryPart

end

local function isNPC(model)

    if not model or not model:IsA("Model") then

        return false

    end

    if player.Character and model == player.Character then

        return false

    end

    if Players:GetPlayerFromCharacter(model) then

        return false

    end

    local npcHumanoid = model:FindFirstChildOfClass("Humanoid")

    if not npcHumanoid or npcHumanoid.Health <= 0 then

        return false

    end

    return getNPCPart(model) ~= nil

end

local function removeNPCMarker(model)

    local data = npcMarkers[model]

    if not data then

        return

    end

    for _, object in ipairs(data.objects) do

        if object and object.Parent then

            object:Destroy()

        end

    end

    npcMarkers[model] = nil

end

local function createNPCMarker(model)

    if npcMarkers[model] or not isNPC(model) then

        return

    end

    local targetPart = getNPCPart(model)

    if not targetPart or not root then

        return

    end

    local objects = {}

-- Contorno rojo visible a traves de objetos.
    local highlight = Instance.new("Highlight")

    highlight.Name = "ECHO_X_NPC_Outline"

    highlight.Adornee = model

    highlight.FillColor = NPC_RED

    highlight.OutlineColor = NPC_RED

    highlight.FillTransparency = 0.82

    highlight.OutlineTransparency = 0

    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent = gui

    table.insert(objects, highlight)

-- Etiqueta negra de distancia.
    local billboard = Instance.new("BillboardGui")

    billboard.Name = "ECHO_X_NPC_Distance"

    billboard.Adornee = targetPart

    billboard.Size = UDim2.fromOffset(150, 34)

    billboard.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)

    billboard.AlwaysOnTop = true

    billboard.MaxDistance = 2000

    billboard.Parent = gui

    table.insert(objects, billboard)

    local label = Instance.new("TextLabel")

    label.Name = "DistanceLabel"

    label.Size = UDim2.fromScale(1, 1)

    label.BackgroundColor3 = Color3.fromRGB(5, 7, 12)

    label.BackgroundTransparency = 0.12

    label.BorderSizePixel = 0

    label.Text = "-- studs"

    label.TextColor3 = NPC_RED

    label.TextStrokeTransparency = 0.25

    label.Font = Enum.Font.GothamBold

    label.TextSize = 14

    label.Parent = billboard

    local corner = Instance.new("UICorner")

    corner.CornerRadius = UDim.new(0, 6)

    corner.Parent = label

-- Linea roja desde el jugador hasta el NPC.
    local startAttachment = Instance.new("Attachment")

    startAttachment.Name = "ECHO_X_NPC_LineStart"

    startAttachment.Parent = root

    table.insert(objects, startAttachment)

    local endAttachment = Instance.new("Attachment")

    endAttachment.Name = "ECHO_X_NPC_LineEnd"

    endAttachment.Parent = targetPart

    table.insert(objects, endAttachment)

    local beam = Instance.new("Beam")

    beam.Name = "ECHO_X_NPC_Line"

    beam.Attachment0 = startAttachment

    beam.Attachment1 = endAttachment

    beam.FaceCamera = true

    beam.Width0 = 0.045

    beam.Width1 = 0.045

    beam.Color = ColorSequence.new(NPC_RED)

    beam.Transparency = NumberSequence.new(0.12)

    beam.LightEmission = 0.2

    beam.Enabled = true

    beam.Parent = startAttachment

    table.insert(objects, beam)

    npcMarkers[model] = {

        objects = objects,

        label = label,

        billboard = billboard,

        highlight = highlight,

        targetPart = targetPart,

    }

end

local function clearNPCMarkers()

    for model in pairs(npcMarkers) do

        removeNPCMarker(model)

    end

end

local function refreshNPCMarkers()

    if not state.npcESP then

        clearNPCMarkers()

        return

    end

    getCharacter()

    if not root then

        clearNPCMarkers()

        return

    end

-- Solo buscar NPC cada cierto intervalo.
    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("Model") and isNPC(obj) then

            createNPCMarker(obj)

        end

    end

-- Quitar modelos eliminados o que ya no son NPC validos.
    for model, data in pairs(npcMarkers) do

        if not model.Parent or not isNPC(model) then

            removeNPCMarker(model)

        else

            local targetPart = getNPCPart(model)

            if not targetPart then

                removeNPCMarker(model)

            elseif data.targetPart ~= targetPart then

                removeNPCMarker(model)

                createNPCMarker(model)

            end

        end

    end

end

local function updateNPCDistances()

    if not state.npcESP or not root then

        return

    end

    for model, data in pairs(npcMarkers) do

        local targetPart = data.targetPart

        if model.Parent and targetPart and targetPart.Parent then

            local distance = (root.Position - targetPart.Position).Magnitude

            data.label.Text = math.floor(distance + 0.5) .. " studs"

        end

    end

end

section("VER NPC")

toggle("Contorno + linea + distancia", false, function(on)

    state.npcESP = on

    if on then

        refreshNPCMarkers()

        updateNPCDistances()

    else

        clearNPCMarkers()

    end

end)

action("Actualizar lista de NPC", "ACTUALIZAR", function()

    if state.npcESP then

        refreshNPCMarkers()

        updateNPCDistances()

    end

end)

--================ ESP GENERAL =====================
section("ESP Y VISUALIZACION")

local function clearESP()

    for instance, highlight in pairs(highlights) do

        if highlight then

            highlight:Destroy()

        end

        highlights[instance] = nil

    end

end

local function shouldMark(obj)

    if not (obj:IsA("BasePart") or obj:IsA("Model")) then

        return false

    end

    if character and obj:IsDescendantOf(character) then

        return false

    end

    local tags = {

        "ECHO_Entity", "ECHO_Item", "ECHO_Door",

        "ECHO_Locker", "ECHO_Money", "ECHO_Stairs",

        "ECHO_Target"

    }

    for _, tag in ipairs(tags) do

        if CollectionService:HasTag(obj, tag) then

            return true

        end

    end

    local name = string.lower(obj.Name)

    local keywords = {

        "door", "puerta", "locker", "armario",

        "money", "cash", "dinero", "item",

        "stairs", "escalera", "entity", "entidad"

    }

    for _, word in ipairs(keywords) do

        if string.find(name, word, 1, true) then

            return true

        end

    end

    return false

end

local function refreshESP()

    if not state.esp then

        clearESP()

        return

    end

    for _, obj in ipairs(workspace:GetDescendants()) do

        if shouldMark(obj) and not highlights[obj] then

            local highlight = Instance.new("Highlight")

            highlight.Name = "ECHO_X_Highlight"

            highlight.Adornee = obj

            highlight.FillColor = BLUE

            highlight.OutlineColor = WHITE

            highlight.FillTransparency = 0.72

            highlight.OutlineTransparency = 0

            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            highlight.Parent = gui

            highlights[obj] = highlight

        end

    end

    for obj, highlight in pairs(highlights) do

        if not obj or not obj.Parent then

            highlight:Destroy()

            highlights[obj] = nil

        end

    end

end

toggle("ESP de puertas, items y entidades", false, function(on)

    state.esp = on

    refreshESP()

end)

action("Actualizar marcadores", "ACTUALIZAR", refreshESP)

--================ FULLBRIGHT ======================
section("ILUMINACIÓN")
local function setFullbright(on)

    state.fullbright = on

    if on then

        if not oldLighting then

            oldLighting = {

                Brightness = Lighting.Brightness,

                ClockTime = Lighting.ClockTime,

                FogEnd = Lighting.FogEnd,

                GlobalShadows = Lighting.GlobalShadows,

                Ambient = Lighting.Ambient,

                OutdoorAmbient = Lighting.OutdoorAmbient,

            }

        end

        Lighting.Brightness = 3

        Lighting.ClockTime = 14

        Lighting.FogEnd = 100000

        Lighting.GlobalShadows = false

        Lighting.Ambient = Color3.new(1, 1, 1)

        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)

    elseif oldLighting then

        for property, value in pairs(oldLighting) do

            Lighting[property] = value

        end

        oldLighting = nil

    end

end

toggle("Fullbright local", false, setFullbright)

--================ REDUCIR EFECTOS =================
section("RENDIMIENTO")
local function setLowEffects(on)

    state.lowEffects = on

    if on then

        for _, obj in ipairs(workspace:GetDescendants()) do

            if obj:IsA("ParticleEmitter")

                or obj:IsA("Trail")

                or obj:IsA("Beam") then

                if originalEffects[obj] == nil then

                    originalEffects[obj] = obj.Enabled

                end

                obj.Enabled = false

            end

        end

    else

        for obj, enabled in pairs(originalEffects) do

            if obj and obj.Parent then

                obj.Enabled = enabled

            end

        end

        table.clear(originalEffects)

    end

end

toggle("Reducir efectos visuales", false, setLowEffects)

--================ PRUEBAS Y CONTROL ===============
section("PRUEBAS Y CONTROL")

toggle("Anti-AFK (mejor esfuerzo)", false, function(on)

    state.antiAfk = on

end)

toggle("ANTI-GOLPE | mano + bate: sin daño / empujon", false, function(on)

    state.antiHit = on

    if antiHitRemote then
        antiHitRemote:FireServer(on)
    else
        warn("[ECHO X] Falta el Script servidor ECHO_X_AntiGolpe_Server en ServerScriptService")
    end

end)

toggle("Atributo de prueba de proteccion", false, function(on)

-- Los scripts de daño del juego deben leer este
-- atributo en el servidor para aplicar la proteccion.
    if humanoid then

        humanoid:SetAttribute("ECHO_X_ProtectionTest", on)

    end

end)

action("Restaurar ajustes locales", "RESTAURAR", function()

    state.speed = 16

    state.speedOn = false

    state.noclip = false

    state.esp = false

    state.instantPrompt = false

    state.antiAfk = false

    state.antiHit = false
    if antiHitRemote then antiHitRemote:FireServer(false) end

    state.npcESP = false

    stopFly()

    setFullbright(false)

    setLowEffects(false)

    setPromptsInstant(false)

    clearESP()

    clearNPCMarkers()

    if humanoid then

        humanoid.WalkSpeed = 16

        humanoid:SetAttribute("ECHO_X_ProtectionTest", false)

    end

    for part, original in pairs(originalCollisions) do

        if part and part.Parent then

            part.CanCollide = original

        end

    end

    table.clear(originalCollisions)

    refreshSpeed()

    gui.Enabled = true

end)

--================ CONFIGURACION ====================
section("CONFIGURACION")

local menuToggleKey = Enum.KeyCode.Q
local esperandoTecla = false
local teclaActualLabel

local teclaFrame, teclaLabel = row("Tecla para abrir / cerrar el menu")
teclaLabel.Size = UDim2.new(1, -125, 1, 0)
local teclaButton = Instance.new("TextButton")
teclaButton.Size = UDim2.fromOffset(76, 27)
teclaButton.Position = UDim2.new(1, -88, 0.5, -13)
teclaButton.Text = menuToggleKey.Name
teclaButton.Parent = teclaFrame
styleButton(teclaButton, false)
teclaActualLabel = teclaButton
teclaButton.Activated:Connect(function()
    esperandoTecla = true
    teclaButton.Text = "PULSA..."
    teclaLabel.Text = "Presiona una tecla para abrir/cerrar"
end)

local function cambiarVisibilidadMenu()
    gui.Enabled = not gui.Enabled
end

--================ TECLAS Y ACTUALIZACION ==========
close.Activated:Connect(function()

    gui.Enabled = false

end)

listen(UIS.InputBegan, function(input, processed)

    if esperandoTecla then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            menuToggleKey = input.KeyCode
            esperandoTecla = false
            teclaButton.Text = menuToggleKey.Name
            teclaLabel.Text = "Tecla para abrir / cerrar el menu"
        end
        return
    end

    if processed then
        return
    end

    if input.KeyCode == menuToggleKey then

        cambiarVisibilidadMenu()

    elseif input.KeyCode == Enum.KeyCode.Space and state.fly then

        flyUp = true

    elseif input.KeyCode == Enum.KeyCode.LeftControl and state.fly then

        flyDown = true

    end

end)

listen(UIS.InputEnded, function(input)

    if input.KeyCode == Enum.KeyCode.Space then

        flyUp = false

    end

    if input.KeyCode == Enum.KeyCode.LeftControl then

        flyDown = false

    end

end)

listen(RunService.RenderStepped, function()

    if state.fly and root and flyVelocity and flyOrientation then

        local camera = workspace.CurrentCamera

        if camera then

            local direction = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then

                direction += camera.CFrame.LookVector

            end

            if UIS:IsKeyDown(Enum.KeyCode.S) then

                direction -= camera.CFrame.LookVector

            end

            if UIS:IsKeyDown(Enum.KeyCode.D) then

                direction += camera.CFrame.RightVector

            end

            if UIS:IsKeyDown(Enum.KeyCode.A) then

                direction -= camera.CFrame.RightVector

            end

            if flyUp then

                direction += Vector3.yAxis

            end

            if flyDown then

                direction -= Vector3.yAxis

            end

            if direction.Magnitude > 0 then

                direction = direction.Unit

            end

            flyVelocity.VectorVelocity =

                direction * math.max(state.speed, 40)

            local look = camera.CFrame.LookVector

            local flatLook = Vector3.new(look.X, 0, look.Z)

            if flatLook.Magnitude > 0.001 then

                flyOrientation.CFrame =

                    CFrame.lookAt(Vector3.zero, flatLook)

            end

        end

    end

    if state.noclip and character then

        for _, part in ipairs(character:GetDescendants()) do

            if part:IsA("BasePart") then

                if originalCollisions[part] == nil then

                    originalCollisions[part] = part.CanCollide

                end

                part.CanCollide = false

            end

        end

    end

end)

listen(player.CharacterAdded, function(newCharacter)

    character = newCharacter

    humanoid = newCharacter:WaitForChild("Humanoid", 10)

    root = newCharacter:WaitForChild("HumanoidRootPart", 10)

    table.clear(originalCollisions)

    stopFly()

-- Los accesorios visuales anteriores estaban ligados
-- al personaje viejo: recrearlos con la nueva raiz.
    clearNPCMarkers()

    if humanoid and state.speedOn then

        humanoid.WalkSpeed = state.speed

    end

    if state.npcESP then

        task.delay(1, function()

            if gui.Parent and state.npcESP then

                refreshNPCMarkers()

                updateNPCDistances()

            end

        end)

    end

end)

listen(workspace.DescendantAdded, function(obj)

    if state.instantPrompt and obj:IsA("ProximityPrompt") then

        if originalPrompts[obj] == nil then

            originalPrompts[obj] = obj.HoldDuration

        end

        obj.HoldDuration = 0

    end

    if state.lowEffects and (

        obj:IsA("ParticleEmitter")

        or obj:IsA("Trail")

        or obj:IsA("Beam")

    ) then

        if originalEffects[obj] == nil then

            originalEffects[obj] = obj.Enabled

        end

        obj.Enabled = false

    end

end)

-- Un solo bucle Heartbeat para ambas funciones ESP.
local espTimer = 0

local npcScanTimer = 0

local npcUpdateTimer = 0

listen(RunService.Heartbeat, function(dt)

    espTimer += dt

    if state.esp and espTimer >= 2 then

        espTimer = 0

        refreshESP()

    end

    if state.npcESP then

        npcScanTimer += dt

        npcUpdateTimer += dt

        if npcScanTimer >= 2 then

            npcScanTimer = 0

            refreshNPCMarkers()

        end

        if npcUpdateTimer >= 0.15 then

            npcUpdateTimer = 0

            updateNPCDistances()

        end

    else

        npcScanTimer = 0

        npcUpdateTimer = 0

    end

end)

listen(player.Idled, function()

    if state.antiAfk then

        pcall(function()

            VirtualUser:CaptureController()

            VirtualUser:ClickButton2(Vector2.new(0, 0))

        end)

    end

end)

gui.Destroying:Connect(function()

    if antiHitRemote then antiHitRemote:FireServer(false) end

    stopFly()

    setFullbright(false)

    setLowEffects(false)

    setPromptsInstant(false)

    clearESP()

    state.npcESP = false

    clearNPCMarkers()

    guiandoPunto = false
    for _, pair in ipairs(flechasGuia) do
        for _, part in ipairs(pair) do
            if part and part.Parent then part:Destroy() end
        end
    end

    for part, original in pairs(originalCollisions) do

        if part and part.Parent then

            part.CanCollide = original

        end

    end

    for _, connection in ipairs(connections) do

        if connection.Connected then

            connection:Disconnect()

        end

    end

end)

print("[ECHO X] Menu cargado correctamente. Pulsa Q.")



--==============================================================
-- SECCION 2 - SCRIPT DE SERVIDOR
-- Ubicacion: ServerScriptService > Script
-- Copia esta seccion completa en un Script normal.
--==============================================================

--==============================================================
-- ECHO X | SERVIDOR ANTI-GOLPE (PARA TU PROPIA EXPERIENCIA)
-- Ubicacion: ServerScriptService > Script
-- Crea el RemoteEvent y guarda el estado de proteccion del jugador.
-- IMPORTANTE: tus armas/scripts de combate deben consultar este atributo
-- antes de aplicar dano, empujon o ragdoll. Este script no intercepta
-- automaticamente sistemas de combate que no hayas conectado.
--==============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("ECHO_X_AntiGolpeEvent")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "ECHO_X_AntiGolpeEvent"
    remote.Parent = ReplicatedStorage
end

local function applyCharacterAttribute(player, character)
    character:SetAttribute("ECHO_X_AntiGolpe", player:GetAttribute("ECHO_X_AntiGolpe") == true)
end

Players.PlayerAdded:Connect(function(player)
    player:SetAttribute("ECHO_X_AntiGolpe", false)
    player.CharacterAdded:Connect(function(character)
        applyCharacterAttribute(player, character)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player:GetAttribute("ECHO_X_AntiGolpe") == nil then
        player:SetAttribute("ECHO_X_AntiGolpe", false)
    end
    player.CharacterAdded:Connect(function(character)
        applyCharacterAttribute(player, character)
    end)
    if player.Character then
        applyCharacterAttribute(player, player.Character)
    end
end

remote.OnServerEvent:Connect(function(player, enabled)
    if typeof(enabled) ~= "boolean" then return end
    player:SetAttribute("ECHO_X_AntiGolpe", enabled)
    if player.Character then
        player.Character:SetAttribute("ECHO_X_AntiGolpe", enabled)
    end
end)

-- EJEMPLO para colocar en el script de un arma, ANTES del dano/knockback:
-- local function isProtected(character)
--     local targetPlayer = Players:GetPlayerFromCharacter(character)
--     return targetPlayer ~= nil and targetPlayer:GetAttribute("ECHO_X_AntiGolpe") == true
-- end
-- if isProtected(targetCharacter) then return end
-- humanoid:TakeDamage(damage)
-- Aplicar la misma comprobacion antes de BodyVelocity/LinearVelocity,
-- ragdoll o cualquier estado de aturdimiento.

print("[ECHO X] Servidor Anti-Golpe listo")

