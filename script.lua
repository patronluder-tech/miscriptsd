
--========================================================
-- ECHO X | PUNTOS DE GUIA
-- Roblox Studio - LocalScript
-- Ubicacion: StarterPlayer > StarterPlayerScripts
-- PC: RightShift para abrir/cerrar
-- Celular: boton flotante ECHO X
-- Maximo: 50 puntos guardados durante la sesion
--========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIGURACION
local MAX_PUNTOS = 50
local CANTIDAD_FLECHAS = 12
local SEPARACION_FLECHAS = 6
local RADIO_LLEGADA = 7

local AZUL = Color3.fromRGB(0, 185, 255)
local NEGRO = Color3.fromRGB(8, 12, 21)
local PANEL = Color3.fromRGB(17, 26, 41)
local BLANCO = Color3.fromRGB(240, 248, 255)
local VERDE = Color3.fromRGB(40, 220, 145)
local ROJO = Color3.fromRGB(255, 85, 100)

-- LIMPIAR VERSION ANTERIOR
local anterior = playerGui:FindFirstChild("ECHO_X_PuntosGuia")
if anterior then
    anterior:Destroy()
end

-- ESTADO
local puntos = {}
local seleccionado = nil
local guiando = false
local flechasVisibles = true
local menuAbierto = true
local conexiones = {}
local flechas = {}

--========================================================
-- FUNCIONES DE INTERFAZ
--========================================================

local function crear(className, props, parent)
    local obj = Instance.new(className)
    for propiedad, valor in pairs(props) do
        obj[propiedad] = valor
    end
    obj.Parent = parent
    return obj
end

local gui = crear("ScreenGui", {
    Name = "ECHO_X_PuntosGuia",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 1000
}, playerGui)

local escala = crear("UIScale", {
    Scale = 1
}, gui)

local function ajustarEscala()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local v = cam.ViewportSize
    escala.Scale = math.clamp(
        math.min((v.X - 16) / 390, (v.Y - 24) / 540),
        0.72, 1
    )
end

ajustarEscala()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(
        ajustarEscala
    )
end

local botonFlotante = crear("TextButton", {
    Name = "AbrirECHOX",
    Size = UDim2.fromOffset(100, 42),
    Position = UDim2.new(0, 12, 0.5, -21),
    BackgroundColor3 = NEGRO,
    Text = "ECHO X",
    TextColor3 = AZUL,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = true,
    Visible = false,
    ZIndex = 20
}, gui)

crear("UICorner", {CornerRadius = UDim.new(0, 10)}, botonFlotante)
crear("UIStroke", {Color = AZUL, Thickness = 2}, botonFlotante)

local menu = crear("Frame", {
    Name = "MenuPrincipal",
    Size = UDim2.fromOffset(390, 540),
    Position = UDim2.new(0.5, -195, 0.5, -270),
    BackgroundColor3 = NEGRO,
    BorderSizePixel = 0,
    Active = true
}, gui)

crear("UICorner", {CornerRadius = UDim.new(0, 14)}, menu)
crear("UIStroke", {Color = AZUL, Thickness = 2}, menu)

local titulo = crear("TextLabel", {
    Size = UDim2.new(1, -58, 0, 42),
    Position = UDim2.fromOffset(12, 5),
    BackgroundTransparency = 1,
    Text = "ECHO X | PUNTOS DE GUIA",
    TextColor3 = AZUL,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, menu)

local cerrar = crear("TextButton", {
    Size = UDim2.fromOffset(36, 34),
    Position = UDim2.new(1, -43, 0, 8),
    BackgroundColor3 = PANEL,
    Text = "X",
    TextColor3 = ROJO,
    TextSize = 18,
    Font = Enum.Font.GothamBold
}, menu)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, cerrar)

local estado = crear("TextLabel", {
    Size = UDim2.new(1, -20, 0, 28),
    Position = UDim2.fromOffset(10, 48),
    BackgroundColor3 = PANEL,
    Text = "Listo para guardar puntos",
    TextColor3 = BLANCO,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextWrapped = true
}, menu)

crear("UICorner", {CornerRadius = UDim.new(0, 7)}, estado)

local nombre = crear("TextBox", {
    Size = UDim2.new(1, -20, 0, 38),
    Position = UDim2.fromOffset(10, 84),
    BackgroundColor3 = PANEL,
    PlaceholderText = "Nombre del punto (ej. Portal)",
    PlaceholderColor3 = Color3.fromRGB(150, 165, 185),
    Text = "",
    TextColor3 = BLANCO,
    TextSize = 14,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false
}, menu)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, nombre)

local guardar = crear("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.fromOffset(10, 128),
    BackgroundColor3 = Color3.fromRGB(0, 105, 165),
    Text = "+  GUARDAR MI POSICION",
    TextColor3 = BLANCO,
    TextSize = 14,
    Font = Enum.Font.GothamBold
}, menu)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, guardar)

local etiqueta = crear("TextLabel", {
    Size = UDim2.new(1, -20, 0, 24),
    Position = UDim2.fromOffset(10, 174),
    BackgroundTransparency = 1,
    Text = "MIS PUNTOS (0/50) - Selecciona uno",
    TextColor3 = AZUL,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, menu)

local lista = crear("ScrollingFrame", {
    Name = "ListaPuntos",
    Size = UDim2.new(1, -20, 0, 190),
    Position = UDim2.fromOffset(10, 200),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = AZUL,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, menu)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, lista)

local layout = crear("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, lista)

crear("UIPadding", {
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6)
}, lista)

local regresar = crear("TextButton", {
    Size = UDim2.new(1, -20, 0, 42),
    Position = UDim2.fromOffset(10, 398),
    BackgroundColor3 = Color3.fromRGB(0, 115, 180),
    Text = "GUIARME AL PUNTO SELECCIONADO",
    TextColor3 = BLANCO,
    TextSize = 13,
    Font = Enum.Font.GothamBold
}, menu)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, regresar)

local filaBotones = crear("Frame", {
    Size = UDim2.new(1, -20, 0, 38),
    Position = UDim2.fromOffset(10, 444),
    BackgroundTransparency = 1
}, menu)

local ocultar = crear("TextButton", {
    Size = UDim2.new(0.49, 0, 1, 0),
    BackgroundColor3 = PANEL,
    Text = "Ocultar flechas",
    TextColor3 = AZUL,
    TextSize = 12,
    Font = Enum.Font.GothamBold
}, filaBotones)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, ocultar)

local eliminar = crear("TextButton", {
    Size = UDim2.new(0.49, 0, 1, 0),
    Position = UDim2.new(0.51, 0, 0, 0),
    BackgroundColor3 = PANEL,
    Text = "Eliminar punto",
    TextColor3 = ROJO,
    TextSize = 12,
    Font = Enum.Font.GothamBold
}, filaBotones)

crear("UICorner", {CornerRadius = UDim.new(0, 8)}, eliminar)

local pie = crear("TextLabel", {
    Size = UDim2.new(1, -20, 0, 22),
    Position = UDim2.fromOffset(10, 487),
    BackgroundTransparency = 1,
    Text = "PC: RightShift  |  Celular: boton ECHO X",
    TextColor3 = Color3.fromRGB(145, 165, 185),
    TextSize = 10,
    Font = Enum.Font.Gotham
}, menu)

--========================================================
-- MOSTRAR / OCULTAR MENU
--========================================================

local function cambiarMenu()
    menuAbierto = not menuAbierto
    menu.Visible = menuAbierto
    botonFlotante.Visible = not menuAbierto
end

cerrar.Activated:Connect(cambiarMenu)
botonFlotante.Activated:Connect(cambiarMenu)

UIS.InputBegan:Connect(function(input, procesado)
    if procesado then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        cambiarMenu()
    end
end)

--========================================================
-- ARRASTRAR MENU CON RATON O DEDO
--========================================================

local arrastrando = false
local inicioInput
local inicioPosicion

titulo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        arrastrando = true
        inicioInput = input.Position
        inicioPosicion = menu.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not arrastrando then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - inicioInput
        menu.Position = UDim2.new(
            inicioPosicion.X.Scale,
            inicioPosicion.X.Offset + delta.X,
            inicioPosicion.Y.Scale,
            inicioPosicion.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        arrastrando = false
    end
end)

--========================================================
-- CREAR FLECHAS NEON
--========================================================

local carpetaVisual = Instance.new("Folder")
carpetaVisual.Name = "ECHO_X_GuiaLocal"
carpetaVisual.Parent = workspace

local function crearBarra()
    local p = Instance.new("Part")
    p.Name = "Flecha"
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Material = Enum.Material.Neon
    p.Color = AZUL
    p.Transparency = 1
    p.Size = Vector3.new(0.45, 0.12, 1)
    p.Parent = carpetaVisual
    return p
end

for i = 1, CANTIDAD_FLECHAS do
    flechas[i] = {crearBarra(), crearBarra()}
end

local function ocultarTodasLasFlechas()
    for _, par in ipairs(flechas) do
        par[1].Transparency = 1
        par[2].Transparency = 1
    end
end

local function ponerBarra(barra, a, b)
    local delta = b - a
    if delta.Magnitude < 0.05 then
        barra.Transparency = 1
        return
    end

    barra.Size = Vector3.new(0.45, 0.12, delta.Magnitude)
    barra.CFrame = CFrame.lookAt((a + b) / 2, b)
    barra.Transparency = 0.08
end

--========================================================
-- LISTA DE PUNTOS
--========================================================

local function refrescarLista()
    for _, hijo in ipairs(lista:GetChildren()) do
        if hijo:IsA("TextButton") then
            hijo:Destroy()
        end
    end

    etiqueta.Text = string.format(
        "MIS PUNTOS (%d/%d) - Selecciona uno",
        #puntos, MAX_PUNTOS
    )

    for i, punto in ipairs(puntos) do
        local activo = seleccionado == punto

        local boton = crear("TextButton", {
            Name = "Punto_" .. i,
            Size = UDim2.new(1, -4, 0, 38),
            BackgroundColor3 = activo
                and Color3.fromRGB(0, 75, 115)
                or NEGRO,
            Text = string.format("%02d. %s", i, punto.nombre),
            TextColor3 = activo and AZUL or BLANCO,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = i
        }, lista)

        crear("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }, boton)

        crear("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 6)
        }, boton)

        boton.Activated:Connect(function()
            seleccionado = punto
            refrescarLista()
            estado.Text = "Seleccionado: " .. punto.nombre
        end)
    end
end

--========================================================
-- GUARDAR POSICION ACTUAL
--========================================================

guardar.Activated:Connect(function()
    if #puntos >= MAX_PUNTOS then
        estado.Text = "Limite alcanzado: 50 puntos"
        return
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        estado.Text = "No se encontro tu personaje"
        return
    end

    local nombrePunto = nombre.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if nombrePunto == "" then
        nombrePunto = "Punto " .. (#puntos + 1)
    end

    if #nombrePunto > 32 then
        nombrePunto = string.sub(nombrePunto, 1, 32)
    end

    local punto = {
        nombre = nombrePunto,
        posicion = root.Position
    }

    table.insert(puntos, punto)
    seleccionado = punto
    nombre.Text = ""
    refrescarLista()
    estado.Text = "Punto guardado: " .. nombrePunto
end)

--========================================================
-- INICIAR GUIA HACIA EL PUNTO SELECCIONADO
--========================================================

regresar.Activated:Connect(function()
    if not seleccionado then
        estado.Text = "Primero selecciona o guarda un punto"
        return
    end

    guiando = true
    flechasVisibles = true
    ocultar.Text = "Ocultar flechas"
    estado.Text = "Guiandote hacia: " .. seleccionado.nombre
end)

ocultar.Activated:Connect(function()
    flechasVisibles = not flechasVisibles
    ocultar.Text = flechasVisibles and "Ocultar flechas" or "Mostrar flechas"

    if not flechasVisibles then
        ocultarTodasLasFlechas()
    end
end)

--========================================================
-- ELIMINAR PUNTO SELECCIONADO
--========================================================

eliminar.Activated:Connect(function()
    if not seleccionado then
        estado.Text = "Selecciona un punto para eliminar"
        return
    end

    for i, punto in ipairs(puntos) do
        if punto == seleccionado then
            table.remove(puntos, i)
            break
        end
    end

    local nombreEliminado = seleccionado.nombre
    seleccionado = nil
    guiando = false
    ocultarTodasLasFlechas()
    refrescarLista()
    estado.Text = "Punto eliminado: " .. nombreEliminado
end)

--========================================================
-- ACTUALIZAR GUIA Y DISTANCIA
--========================================================

local tiempo = 0

RunService.Heartbeat:Connect(function(dt)
    tiempo += dt
    if tiempo < 0.08 then return end
    tiempo = 0

    if not guiando or not seleccionado or not flechasVisibles then
        ocultarTodasLasFlechas()
        return
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        ocultarTodasLasFlechas()
        return
    end

    local destino = seleccionado.posicion
    local delta = destino - root.Position
    local distancia = delta.Magnitude

    if distancia <= RADIO_LLEGADA then
        guiando = false
        ocultarTodasLasFlechas()
        estado.Text = "Llegaste a: " .. seleccionado.nombre
        return
    end

    estado.Text = string.format(
        "Destino: %s | %.0f studs",
        seleccionado.nombre,
        distancia
    )

    local horizontal = Vector3.new(delta.X, 0, delta.Z)

    if horizontal.Magnitude < 0.1 then
        ocultarTodasLasFlechas()
        return
    end

    local direccion = horizontal.Unit
    local lateral = Vector3.new(-direccion.Z, 0, direccion.X)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character, carpetaVisual}

    for i, par in ipairs(flechas) do
        local avance = i * SEPARACION_FLECHAS

        if avance >= horizontal.Magnitude then
            par[1].Transparency = 1
            par[2].Transparency = 1
            continue
        end

        local muestra = root.Position + direccion * avance

        local resultado = workspace:Raycast(
            muestra + Vector3.new(0, 12, 0),
            Vector3.new(0, -45, 0),
            params
        )

        if resultado then
            local base = resultado.Position + Vector3.new(0, 0.18, 0)
            local punta = base + direccion * 1.35
            local atras = base - direccion * 0.65
            local ala1 = atras + lateral * 0.85
            local ala2 = atras - lateral * 0.85

            ponerBarra(par[1], ala1, punta)
            ponerBarra(par[2], ala2, punta)
        else
            par[1].Transparency = 1
            par[2].Transparency = 1
        end
    end
end)

--========================================================
-- LIMPIEZA AL DESTRUIR EL GUI
--========================================================

gui.Destroying:Connect(function()
    if carpetaVisual then
        carpetaVisual:Destroy()
    end
end)

refrescarLista()
print("ECHO X: Menu de puntos de guia iniciado correctamente")
