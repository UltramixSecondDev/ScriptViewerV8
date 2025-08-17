-- ScriptViewer V7.5 + Output funcional

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ScriptViewerV7.5"
gui.ResetOnSpawn = false

local darkMode = true

-- Main frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 850, 0, 500)
main.Position = UDim2.new(0, 60, 0, 60)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ScriptViewer V7.5"
title.TextSize = 8
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0.5, -15)
minimize.Text = "-"
minimize.TextSize = 8
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

-- Content holder (todo el contenido menos header)
local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, 0, 1, -40)
contentHolder.Position = UDim2.new(0, 0, 0, 40)
contentHolder.BackgroundTransparency = 1

-- Botones
local buttonFrame = Instance.new("Frame", contentHolder)
buttonFrame.Position = UDim2.new(0, 10, 0, 10)
buttonFrame.Size = UDim2.new(0, 600, 0, 40)
buttonFrame.BackgroundTransparency = 1

local uiList = Instance.new("UIListLayout", buttonFrame)
uiList.FillDirection = Enum.FillDirection.Horizontal
uiList.Padding = UDim.new(0, 8)

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 1, 0)
	btn.Text = text
	btn.TextSize = 8
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.Parent = buttonFrame
	return btn
end

local runBtn = createButton("Execute")
local clearBtn = createButton("Clear")
local copyBtn = createButton("Copy")
local selectAllBtn = createButton("Keyboard")
local temaBtn = createButton("Theme")
local pasteBtn = createButton("Visualizer")
local saveBtn = createButton("bytecode")
local openBtn = createButton("Gallery")
local closeBtn = createButton("Source")

-- Contenedor del editor y output
local container = Instance.new("Frame", contentHolder)
container.Position = UDim2.new(0, 10, 0, 60)
container.Size = UDim2.new(1, -20, 1, -100)
container.BorderSizePixel = 0
Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

-- ScrollingFrame del editor de código
local scroll = Instance.new("ScrollingFrame", container)
scroll.Position = UDim2.new(0, 0, 0, 0)
scroll.Size = UDim2.new(0.6, 0, 1, 0) -- 60% ancho para editor
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ClipsDescendants = true
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.HorizontalScrollBarInset = Enum.ScrollBarInset.Always

local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 40, 0, 0)
lineNumbers.Position = UDim2.new(0, 0, 0, 0)
lineNumbers.AutomaticSize = Enum.AutomaticSize.Y
lineNumbers.Text = "1"
lineNumbers.TextXAlignment = Enum.TextXAlignment.Center
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.TextSize = 8
lineNumbers.BackgroundTransparency = 1
lineNumbers.Parent = scroll

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -45, 0, 0)
codeBox.Position = UDim2.new(0, 45, 0, 0)
codeBox.AutomaticSize = Enum.AutomaticSize.Y
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.BackgroundTransparency = 1
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.Text = ""
codeBox.TextSize = 8
codeBox.TextWrapped = false
codeBox.Parent = scroll

-- Label info de líneas y caracteres
local infoLabel = Instance.new("TextLabel", contentHolder)
infoLabel.Size = UDim2.new(0, 300, 0, 20)
infoLabel.Position = UDim2.new(0, 10, 1, -30)
infoLabel.BackgroundTransparency = 1
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextSize = 8

-- Output container (el panel de salida de texto)
local outputMain = Instance.new("Frame", container)
outputMain.Size = UDim2.new(0.4, -10, 1, 0) -- 40% ancho para Output
outputMain.Position = UDim2.new(0.6, 10, 0, 0) -- al lado derecho del editor
outputMain.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", outputMain).CornerRadius = UDim.new(0, 8)

local outputInterior = Instance.new("Frame", outputMain)
outputInterior.Size = UDim2.new(1, 0, 1, 0)
outputInterior.Position = UDim2.new(0, 0, 0, 0)
outputInterior.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
Instance.new("UICorner", outputInterior).CornerRadius = UDim.new(0, 8)

local outputHeader = Instance.new("TextLabel", outputInterior)
outputHeader.Size = UDim2.new(1, 0, 0, 30)
outputHeader.Position = UDim2.new(0, 0, 0, 0)
outputHeader.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
outputHeader.Text = "Output"
outputHeader.TextColor3 = Color3.fromRGB(255,255,255)
outputHeader.TextSize = 12
outputHeader.TextXAlignment = Enum.TextXAlignment.Left
outputHeader.Font = Enum.Font.Code
Instance.new("UICorner", outputHeader).CornerRadius = UDim.new(0, 8)

local outputScroll = Instance.new("ScrollingFrame", outputInterior)
outputScroll.Size = UDim2.new(1, 0, 1, -30)
outputScroll.Position = UDim2.new(0, 0, 0, 30)
outputScroll.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
outputScroll.ScrollBarThickness = 8
outputScroll.ClipsDescendants = true
outputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
outputScroll.CanvasSize = UDim2.new(0,0,0,0)
outputScroll.Parent = outputInterior

-- Función para enviar texto al output
local function sendToOutput(text, color)
	color = color or Color3.new(1, 1, 1)
	
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Text = text
	label.Parent = outputScroll
	
	-- Ajustar canvas para mostrar todo
	outputScroll.CanvasSize = UDim2.new(0, 0, 0, outputScroll.CanvasSize.Y.Offset + 20)
	
	-- Hacer scroll automático al final
	outputScroll.CanvasPosition = Vector2.new(0, outputScroll.CanvasSize.Y.Offset)
end

-- Actualizar contador de líneas y caracteres
local function updateLineAndCharCount()
	local lines = select(2, codeBox.Text:gsub("\n", "\n")) + 1
	local chars = #codeBox.Text
	local txt = ""
	for i = 1, lines do txt = txt .. i .. "\n" end
	lineNumbers.Text = txt
	infoLabel.Text = "Líneas: " .. lines .. " | Caracteres: " .. chars
end

codeBox:GetPropertyChangedSignal("Text"):Connect(updateLineAndCharCount)

-- Botones funcionales
runBtn.MouseButton1Click:Connect(function()
	outputScroll:ClearAllChildren() -- Limpiar output antes de correr

	local f, err = loadstring(codeBox.Text)
	if not f then
		sendToOutput("⚠️ Error de sintaxis: " .. tostring(err), Color3.fromRGB(255, 100, 100))
		return
	end

	local success, runtimeErr = pcall(f)
	if not success then
		sendToOutput("💥 Error en ejecución: " .. tostring(runtimeErr), Color3.fromRGB(255, 100, 100))
	else
		sendToOutput("✅ Código ejecutado sin errores", Color3.fromRGB(100, 255, 100))
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	codeBox.Text = ""
	outputScroll:ClearAllChildren()
end)

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard(codeBox.Text) end
end)

pasteBtn.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("TabEditor")

	if gui then
		gui.Enabled = true
	else
		local success, result = pcall(function()
			return loadstring(game:HttpGet("https://raw.githubusercontent.com/UltramixSecondDev/ScriptViewerV1.Lua/main/BoltEditor.lua"))()
		end)

		if not success then
			sendToOutput("❌ Error al cargar BoltEditor: " .. tostring(result), Color3.fromRGB(255, 100, 100))
		end
	end
end)

saveBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("BytecodeEditorGUI")

    if gui then
        gui.Enabled = true
    else
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/UltramixSecondDev/BytecodeEditor/main/Source.lua"))()
        end)

        if not success then
            sendToOutput("❌ Error al cargar BytecodeEditorGUI: " .. tostring(result), Color3.fromRGB(255, 100, 100))
        end
    end
end)


openBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("ScriptGalleryV1")

    if gui then
        gui.Enabled = true
    else
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/UltramixSecondDev/Galery.lua/main/ScriptGalery.Lua"))()
        end)

        if not success then
            sendToOutput("❌ Error al cargar la galería: " .. tostring(result), Color3.fromRGB(255, 100, 100))
        end
    end
end)

selectAllBtn.MouseButton1Click:Connect(function()
	codeBox:CaptureFocus()
	codeBox.CursorPosition = #codeBox.Text + 1
end)

closeBtn.MouseButton1Click:Connect(function()
    local existingGui = player:FindFirstChild("PlayerGui"):FindFirstChild("RetroEditorV2")
    if existingGui then
        existingGui:Destroy() -- Si ya existe, cerramos
    else
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/UltramixSecondDev/Explorer-Editor-/main/Source.lua"))()
        end)
        if not success then
            warn("Error al abrir RetroEditor: "..tostring(result))
        end
    end
end)

-- Minimizar
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	local goalSize = minimized and UDim2.new(0, 850, 0, 40) or UDim2.new(0, 850, 0, 500)
	TweenService:Create(main, TweenInfo.new(0.3), {Size = goalSize}):Play()
	for _, v in pairs(contentHolder:GetChildren()) do
		if v:IsA("GuiObject") then v.Visible = not minimized end
	end
end)

-- Tema claro/oscuro
local function aplicarTema()
	local fondo = darkMode and Color3.fromRGB(30,30,30) or Color3.fromRGB(240,240,240)
	local fondo2 = darkMode and Color3.fromRGB(45,45,45) or Color3.fromRGB(220,220,220)
	local texto = darkMode and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
	local texto2 = darkMode and Color3.fromRGB(120,120,120) or Color3.fromRGB(80,80,80)
	local boton = darkMode and Color3.fromRGB(60,60,60) or Color3.fromRGB(200,200,200)

	main.BackgroundColor3 = fondo
	header.BackgroundColor3 = fondo2
	title.TextColor3 = texto
	minimize.BackgroundColor3 = boton
	minimize.TextColor3 = texto
	codeBox.TextColor3 = texto
	lineNumbers.TextColor3 = texto2
	lineNumbers.BackgroundColor3 = darkMode and Color3.fromRGB(35,35,35) or Color3.fromRGB(230,230,230)
	container.BackgroundColor3 = fondo2
	infoLabel.TextColor3 = texto

	for _, btn in pairs(buttonFrame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.BackgroundColor3 = boton
			btn.TextColor3 = texto
		end
	end
end

temaBtn.MouseButton1Click:Connect(function()
	darkMode = not darkMode
	aplicarTema()
end)

aplicarTema()
updateLineAndCharCount()
